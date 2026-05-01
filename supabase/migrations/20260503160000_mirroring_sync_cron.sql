-- B.4.1 — server-side mirroring sync (pending-sync table pattern)
--
-- Today: enforce_slot_coverage() flips mirroring_disabled in the DB
-- when a trader exceeds their slot quota (sub lapse, etc), but the
-- trading API still mirrors trades server-side. The trader sees
-- INACTIVE in the UI yet trades keep copying. This migration closes
-- that gap with a "transactional outbox" pattern:
--
--   1) account_ownership.mirroring_synced_at marks rows whose DB flag
--      hasn't been confirmed on the trading API yet (NULL = pending).
--   2) BEFORE UPDATE trigger nulls it when mirroring_disabled changes
--      from any path — subscription expiry, slot-coverage trigger, or
--      direct UPDATE — UNLESS the caller explicitly supplied a
--      mirroring_synced_at value (manual pause/resume goes through
--      the trading-proxy Edge Function, which sets synced_at = now()
--      in the same UPDATE so the cron skips the row).
--   3) pg_cron 'mirroring-sync' fires every minute and pokes the new
--      sync-mirroring Edge Function via pg_net. The function pulls
--      pending rows, calls the trading API's active_master/active_slave
--      endpoint per platform/role, and writes synced_at on ack.
--
-- Lag is bounded to ~60s (cron tick + Edge Function execution). For
-- subscription expiry — which the existing daily renewal cron at
-- 00:00 UTC drives — that's invisible.

-- =============================================================================
-- account_ownership.mirroring_synced_at
--
-- Default now() for backfill: existing rows are considered already in
-- sync (no spurious cron pass on first deploy). Going forward, the
-- trigger below nulls this when the disabled flag flips.
-- =============================================================================

alter table public.account_ownership
  add column if not exists mirroring_synced_at timestamptz
    default now();

-- =============================================================================
-- on_mirroring_disabled_change
--
-- Fires BEFORE UPDATE so we can mutate NEW. Logic:
--   - If mirroring_disabled is unchanged → leave synced_at alone.
--   - If mirroring_disabled changed AND caller didn't explicitly set
--     synced_at in the same UPDATE → null synced_at so the sync cron
--     picks the row up.
--   - If mirroring_disabled changed AND caller explicitly set
--     synced_at (e.g. trading-proxy did the API call already) → leave
--     it alone.
--
-- The "explicitly set" check uses NEW.mirroring_synced_at IS NOT
-- DISTINCT FROM OLD.mirroring_synced_at — if the caller didn't touch
-- synced_at, NEW will equal OLD; if they did, NEW differs.
-- =============================================================================

create or replace function public.on_mirroring_disabled_change()
returns trigger
language plpgsql
as $$
begin
  if new.mirroring_disabled is distinct from old.mirroring_disabled
     and new.mirroring_synced_at is not distinct from old.mirroring_synced_at
  then
    new.mirroring_synced_at := null;
  end if;
  return new;
end;
$$;

drop trigger if exists on_mirroring_disabled_change
  on public.account_ownership;
create trigger on_mirroring_disabled_change
  before update on public.account_ownership
  for each row execute function public.on_mirroring_disabled_change();

-- =============================================================================
-- pg_cron schedule: mirroring-sync
--
-- Calls the sync-mirroring Edge Function once a minute. The function
-- itself reads pending rows and dispatches to the trading API; we
-- don't need any SQL state here beyond the URL + service-role key,
-- which we read from vault.decrypted_secrets so they never appear in
-- pg_dump output.
--
-- BEFORE THIS MIGRATION RUNS the operator must create two vault
-- secrets (Supabase Dashboard → Project Settings → Vault, or via SQL):
--   select vault.create_secret(
--     '<https://your-project-ref.supabase.co>',
--     'project_url'
--   );
--   select vault.create_secret(
--     '<service-role JWT from project settings>',
--     'service_role_key'
--   );
-- The migration logs a notice and skips the schedule if either secret
-- is missing, so a deploy without secrets won't fail — operator just
-- re-runs the migration after creating them.
-- =============================================================================

do $$
declare
  v_job_id      bigint;
  v_project_url text;
  v_service_key text;
begin
  if not exists (select 1 from pg_extension where extname = 'pg_cron') then
    raise notice
      'pg_cron not enabled — mirroring-sync cron NOT scheduled. '
      'Enable pg_cron in Supabase Dashboard → Database → Extensions.';
    return;
  end if;

  if not exists (select 1 from pg_extension where extname = 'pg_net') then
    raise notice
      'pg_net not enabled — mirroring-sync cron NOT scheduled. '
      'Enable pg_net in Supabase Dashboard → Database → Extensions.';
    return;
  end if;

  select decrypted_secret into v_project_url
    from vault.decrypted_secrets where name = 'project_url' limit 1;
  select decrypted_secret into v_service_key
    from vault.decrypted_secrets where name = 'service_role_key' limit 1;

  if v_project_url is null or v_service_key is null then
    raise notice
      'vault secrets project_url / service_role_key missing — '
      'mirroring-sync cron NOT scheduled. Create them and re-run.';
    return;
  end if;

  -- Idempotent: drop prior version of this job
  select jobid into v_job_id
    from cron.job
    where jobname = 'mirroring-sync';
  if v_job_id is not null then
    perform cron.unschedule(v_job_id);
  end if;

  perform cron.schedule(
    'mirroring-sync',
    '* * * * *',  -- every minute
    format($cron$
      select net.http_post(
        url     := %L,
        headers := %L::jsonb,
        body    := '{}'::jsonb
      );
    $cron$,
      v_project_url || '/functions/v1/sync-mirroring',
      jsonb_build_object(
        'Content-Type', 'application/json',
        'Authorization', 'Bearer ' || v_service_key
      )::text
    )
  );
end $$;

-- After this migration:
--   1. Verify:
--        select jobname, schedule, command from cron.job
--          where jobname = 'mirroring-sync';
--   2. Smoke test: flip a row by hand, watch synced_at clear then
--      repopulate within ~60s:
--        update public.account_ownership
--           set mirroring_disabled = true
--         where id = '<some-row-id>';
--        -- wait ~60s
--        select mirroring_disabled, mirroring_synced_at from
--          public.account_ownership where id = '<some-row-id>';
