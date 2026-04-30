-- Slice 1C — Subscription auto-renewal + cancel
--
-- Adds:
--   set_auto_renew(uuid, bool)              — trader toggles their own sub's auto_renew
--   process_subscription_renewals()         — cron-callable (and admin-triggerable) renewal/expiry pass
--   pg_cron schedule "subscription-renewals" — daily at 00:00 UTC
--
-- Renewal model (per spec, 2026-05-01):
--   * Cancel = stop auto-renew. Sub keeps running until expires_at, then expires. No refund.
--   * Auto-renew at expiry: charge at *current* admin pricing for the sub's
--     (tier_at_purchase, commitment_months) cell. Tier may shift if admin moved
--     slot range bands; we re-derive via tier_for_slot_count.
--   * Insufficient wallet at renewal time: mark expired (no partial debit).
--   * Notification side: in-app banner today (UI checks expires_at - now); email
--     hook is a stub (lands when an email service is wired in a later slice).

-- =============================================================================
-- set_auto_renew RPC — trader-callable, scoped to caller's own subs
-- =============================================================================

create or replace function public.set_auto_renew(
  p_subscription_id uuid,
  p_auto_renew      boolean
)
returns public.user_subscriptions
language plpgsql
security definer
set search_path = public
as $$
declare
  v_user_id uuid;
  v_row     public.user_subscriptions;
begin
  v_user_id := auth.uid();
  if v_user_id is null then
    raise exception 'not authenticated';
  end if;

  update public.user_subscriptions
     set auto_renew = p_auto_renew
   where id = p_subscription_id
     and user_id = v_user_id
     and status = 'active'
   returning * into v_row;

  if v_row.id is null then
    raise exception 'subscription not found, not yours, or not active';
  end if;

  return v_row;
end;
$$;

grant execute on function public.set_auto_renew(uuid, boolean) to authenticated;

-- =============================================================================
-- process_subscription_renewals — bulk renewal / expiry pass
--
-- Callable by:
--   * pg_cron (postgres role, no auth.uid())
--   * admin user via Flutter (authenticated, is_admin() = true)
-- Trader callers are blocked (non-admin authenticated user fails the check).
-- =============================================================================

create or replace function public.process_subscription_renewals()
returns table (renewed_count int, expired_count int)
language plpgsql
security definer
set search_path = public
as $$
declare
  v_renewed   int := 0;
  v_expired   int := 0;
  v_sub       record;
  v_cost      numeric;
  v_wallet_id uuid;
  v_balance   numeric;
  v_caller    uuid;
begin
  -- Cron has no auth.uid (runs as postgres). For Flutter callers, require admin.
  v_caller := auth.uid();
  if v_caller is not null and not public.is_admin() then
    raise exception 'permission denied: admin only';
  end if;

  for v_sub in
    select id, user_id, tier, slot_count, commitment_months,
           expires_at, auto_renew
      from public.user_subscriptions
     where status = 'active'
       and expires_at <= now()
     for update
  loop
    if not v_sub.auto_renew then
      -- Auto-renew off → expire on schedule
      update public.user_subscriptions
         set status = 'expired'
       where id = v_sub.id;
      v_expired := v_expired + 1;
      continue;
    end if;

    -- Compute current price (admin may have changed pricing or tier ranges).
    begin
      v_cost := public.compute_subscription_cost(
        v_sub.slot_count, v_sub.commitment_months
      );
    exception when others then
      v_cost := null;
    end;

    if v_cost is null then
      -- No tier matches anymore — admin removed the band. Expire.
      update public.user_subscriptions
         set status = 'expired'
       where id = v_sub.id;
      v_expired := v_expired + 1;
      continue;
    end if;

    -- Lock + read wallet
    select id, balance into v_wallet_id, v_balance
      from public.wallets
     where user_id = v_sub.user_id
       for update;

    if v_wallet_id is null or v_balance < v_cost then
      -- Insufficient → expire (TODO: email notification when wired)
      update public.user_subscriptions
         set status = 'expired'
       where id = v_sub.id;
      v_expired := v_expired + 1;
      continue;
    end if;

    -- Renew: debit + extend
    update public.wallets
       set balance = balance - v_cost
     where id = v_wallet_id;

    update public.user_subscriptions
       set expires_at = expires_at + make_interval(months => commitment_months),
           total_paid = v_cost,
           tier = public.tier_for_slot_count(slot_count)
     where id = v_sub.id;

    insert into public.wallet_transactions (
      wallet_id, type, amount, balance_after, reference, created_by
    ) values (
      v_wallet_id, 'slot_renewal', -v_cost, v_balance - v_cost,
      format('renewal:%s (%s slots × %s months)',
             v_sub.id, v_sub.slot_count, v_sub.commitment_months),
      v_sub.user_id
    );

    v_renewed := v_renewed + 1;
  end loop;

  return query select v_renewed, v_expired;
end;
$$;

grant execute on function public.process_subscription_renewals() to authenticated;

-- =============================================================================
-- pg_cron schedule — daily at 00:00 UTC
--
-- Requires the pg_cron extension enabled on the Supabase project.
-- If pg_cron isn't installed the migration emits a NOTICE and skips the
-- schedule rather than failing — operator can enable it via Supabase
-- Dashboard → Database → Extensions and re-run this migration.
-- =============================================================================

do $$
declare
  v_job_id bigint;
begin
  if not exists (select 1 from pg_extension where extname = 'pg_cron') then
    raise notice
      'pg_cron extension not enabled — auto-renewal cron NOT scheduled. '
      'Enable pg_cron in Supabase Dashboard → Database → Extensions, '
      'then re-run this migration.';
    return;
  end if;

  -- Idempotent: drop any prior version of this job
  select jobid into v_job_id
    from cron.job
    where jobname = 'subscription-renewals';
  if v_job_id is not null then
    perform cron.unschedule(v_job_id);
  end if;

  perform cron.schedule(
    'subscription-renewals',
    '0 0 * * *',  -- every day at 00:00 UTC
    $cron$ select public.process_subscription_renewals(); $cron$
  );
end $$;

-- After this migration:
--   1. Verify the cron job:
--        select jobname, schedule, command from cron.job
--          where jobname = 'subscription-renewals';
--      If empty, enable pg_cron extension and re-push.
--   2. Manual test: call select * from public.process_subscription_renewals();
--      Returns (renewed_count, expired_count).
--   3. To force a renewal test, edit a sub's expires_at to be in the past:
--        update public.user_subscriptions set expires_at = now() - interval '1 hour'
--          where id = '<sub-id>';
--      Then run process_subscription_renewals() and check wallet + sub state.
