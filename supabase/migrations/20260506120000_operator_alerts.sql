-- Operator alerts — generates admin-visible alerts when slot capacity
-- gets close to the operator's bought ceiling.
--
-- Two new tables:
--   * operator_settings — admin-editable key/value config. Today only
--     'account_limit' is used (mirrors the value the operator sees on
--     the trading API team's getAPIInfo). Operator updates it manually
--     when they buy more capacity.
--   * admin_alerts — alert inbox. Rows are written by check_capacity_alerts()
--     and dismissed via dismiss_admin_alert() once an operator acks them.
--
-- A single SQL function check_capacity_alerts() runs on an hourly
-- pg_cron schedule. It reads account_limit from operator_settings,
-- sums slot_count from active user_subscriptions, and inserts an alert
-- when utilization crosses 80% (warning) or 95% (urgent) — but only
-- if no un-dismissed alert of the same kind already exists, so the
-- inbox doesn't fill up with one row per cron tick.

-- =============================================================================
-- operator_settings
--
-- Generic key/value table for operator-scoped config that needs SQL
-- visibility but isn't worth a dedicated column. Today: account_limit.
-- Tomorrow: alert thresholds, notification channels, etc.
-- =============================================================================

create table if not exists public.operator_settings (
  key         text primary key,
  value       jsonb       not null,
  updated_at  timestamptz not null default now(),
  updated_by  uuid        references auth.users(id)
);

alter table public.operator_settings enable row level security;

drop policy if exists "operator_settings admin read"
  on public.operator_settings;
create policy "operator_settings admin read"
  on public.operator_settings for select
  using (public.is_admin());

drop policy if exists "operator_settings admin write"
  on public.operator_settings;
create policy "operator_settings admin write"
  on public.operator_settings for all
  using (public.is_admin())
  with check (public.is_admin());

-- Seed with the current account limit. Idempotent — only inserts if
-- the row is missing. Operator updates the value through the admin UI
-- (see set_account_limit RPC below) when they buy more capacity.
insert into public.operator_settings (key, value, updated_at)
values ('account_limit', '2'::jsonb, now())
on conflict (key) do nothing;

-- =============================================================================
-- admin_alerts
--
-- Append-only alert inbox. The triage flow is: cron writes an alert,
-- admin sees it in the Plans tab banner, admin clicks dismiss, the
-- dismissed_at column stops it from rendering. Severity follows
-- syslog conventions (info/warning/error/critical) but only warning
-- and critical are used today.
-- =============================================================================

create table if not exists public.admin_alerts (
  id            uuid primary key default gen_random_uuid(),
  kind          text not null,
  severity      text not null
                check (severity in ('info', 'warning', 'critical')),
  message       text not null,
  payload       jsonb,
  created_at    timestamptz not null default now(),
  dismissed_at  timestamptz,
  dismissed_by  uuid references auth.users(id)
);

create index if not exists admin_alerts_undismissed_idx
  on public.admin_alerts (created_at desc)
  where dismissed_at is null;

alter table public.admin_alerts enable row level security;

drop policy if exists "admin_alerts admin read"
  on public.admin_alerts;
create policy "admin_alerts admin read"
  on public.admin_alerts for select
  using (public.is_admin());

drop policy if exists "admin_alerts admin write"
  on public.admin_alerts;
create policy "admin_alerts admin write"
  on public.admin_alerts for all
  using (public.is_admin())
  with check (public.is_admin());

-- =============================================================================
-- set_account_limit(p_value int)
--
-- Admin-only RPC for the Plans tab editor. Wraps the upsert so callers
-- don't need write access to operator_settings.value as a raw jsonb
-- shape. Returns the new value.
-- =============================================================================

create or replace function public.set_account_limit(p_value int)
returns int
language plpgsql
security definer
set search_path = public
as $$
declare
  v_uid uuid := auth.uid();
begin
  if not public.is_admin() then
    raise exception 'admin only';
  end if;
  if p_value < 0 then
    raise exception 'account_limit must be >= 0, got %', p_value;
  end if;

  insert into public.operator_settings (key, value, updated_at, updated_by)
  values ('account_limit', to_jsonb(p_value), now(), v_uid)
  on conflict (key) do update set
    value      = excluded.value,
    updated_at = excluded.updated_at,
    updated_by = excluded.updated_by;

  return p_value;
end;
$$;

revoke all on function public.set_account_limit(int) from public;
grant execute on function public.set_account_limit(int) to authenticated;

-- =============================================================================
-- dismiss_admin_alert(p_alert_id uuid)
--
-- Admin-only RPC for the dismiss button on the alerts banner. Returns
-- the alert row post-update so the UI can update local state without a
-- second roundtrip.
-- =============================================================================

create or replace function public.dismiss_admin_alert(p_alert_id uuid)
returns public.admin_alerts
language plpgsql
security definer
set search_path = public
as $$
declare
  v_uid uuid := auth.uid();
  v_row public.admin_alerts;
begin
  if not public.is_admin() then
    raise exception 'admin only';
  end if;

  update public.admin_alerts
     set dismissed_at = now(),
         dismissed_by = v_uid
   where id = p_alert_id
     and dismissed_at is null
  returning * into v_row;

  if v_row.id is null then
    raise exception 'alert % not found or already dismissed', p_alert_id;
  end if;
  return v_row;
end;
$$;

revoke all on function public.dismiss_admin_alert(uuid) from public;
grant execute on function public.dismiss_admin_alert(uuid) to authenticated;

-- =============================================================================
-- check_capacity_alerts()
--
-- Hourly pg_cron tick. Reads account_limit from operator_settings,
-- sums active subscription slot_count, computes utilization, and
-- inserts an alert when the threshold is crossed. Debounced — if an
-- un-dismissed alert of the same kind already exists, this is a no-op.
--
-- Two thresholds:
--   * 'capacity_warning'   — utilization >= 80%
--   * 'capacity_critical'  — utilization >= 95% OR slots_sold > limit
--
-- The critical alert supersedes warning conceptually, but we still
-- insert both kinds independently so admin sees the full progression
-- in the inbox if they don't dismiss promptly.
-- =============================================================================

create or replace function public.check_capacity_alerts()
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_limit       int;
  v_sold        int;
  v_pct         numeric;
  v_oversold    boolean;
  v_have_warn   boolean;
  v_have_crit   boolean;
begin
  select (value::text)::int into v_limit
    from public.operator_settings
   where key = 'account_limit';
  if v_limit is null or v_limit <= 0 then
    return;  -- not configured yet
  end if;

  select coalesce(sum(slot_count), 0) into v_sold
    from public.user_subscriptions
   where status = 'active';

  v_oversold := v_sold > v_limit;
  v_pct := (v_sold::numeric / v_limit::numeric);

  select exists (
    select 1 from public.admin_alerts
     where kind = 'capacity_warning'
       and dismissed_at is null
  ) into v_have_warn;

  select exists (
    select 1 from public.admin_alerts
     where kind = 'capacity_critical'
       and dismissed_at is null
  ) into v_have_crit;

  if (v_pct >= 0.95 or v_oversold) and not v_have_crit then
    insert into public.admin_alerts (kind, severity, message, payload)
    values (
      'capacity_critical',
      'critical',
      case when v_oversold
        then format(
          'Sold %s slots but only %s covered by trading API team — '
          'new trader registrations may be blocked.',
          v_sold, v_limit
        )
        else format(
          'Slot utilization at %s%% (%s of %s) — buy more capacity '
          'from trading API team urgently.',
          round(v_pct * 100), v_sold, v_limit
        )
      end,
      jsonb_build_object(
        'sold', v_sold,
        'limit', v_limit,
        'pct', round(v_pct * 100, 1)
      )
    );
  elsif v_pct >= 0.80 and not v_have_warn and not v_have_crit then
    insert into public.admin_alerts (kind, severity, message, payload)
    values (
      'capacity_warning',
      'warning',
      format(
        'Slot utilization at %s%% (%s of %s) — start planning to buy '
        'more capacity from the trading API team.',
        round(v_pct * 100), v_sold, v_limit
      ),
      jsonb_build_object(
        'sold', v_sold,
        'limit', v_limit,
        'pct', round(v_pct * 100, 1)
      )
    );
  end if;
end;
$$;

revoke all on function public.check_capacity_alerts() from public;
-- No grant — only pg_cron (running as postgres) and admin invocation
-- need to call this. Admin can invoke for manual testing.
grant execute on function public.check_capacity_alerts() to authenticated;

-- =============================================================================
-- pg_cron schedule: capacity-alerts
--
-- Hourly tick — small SQL function with no external calls, so cost is
-- negligible. Idempotent: drops any prior version before scheduling.
-- =============================================================================

do $$
declare
  v_job_id bigint;
begin
  if not exists (select 1 from pg_extension where extname = 'pg_cron') then
    raise notice
      'pg_cron not enabled — capacity-alerts cron NOT scheduled. '
      'Enable pg_cron in Supabase Dashboard → Database → Extensions.';
    return;
  end if;

  select jobid into v_job_id
    from cron.job
    where jobname = 'capacity-alerts';
  if v_job_id is not null then
    perform cron.unschedule(v_job_id);
  end if;

  perform cron.schedule(
    'capacity-alerts',
    '0 * * * *',  -- top of every hour
    'select public.check_capacity_alerts();'
  );
end $$;

-- After this migration:
--   1. Verify the cron job was scheduled:
--        select jobname, schedule, command from cron.job
--          where jobname = 'capacity-alerts';
--   2. Smoke-test thresholds without waiting an hour:
--        -- a) Force a critical alert by lowering the account limit:
--        select public.set_account_limit(1);
--        select public.check_capacity_alerts();
--        select kind, severity, message from public.admin_alerts
--          where dismissed_at is null;
--        -- b) Restore real value:
--        select public.set_account_limit(2);
--   3. Dismiss test alerts:
--        select public.dismiss_admin_alert('<alert-uuid>');
