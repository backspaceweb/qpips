-- Slice B.4 — Runtime mirroring enforcement (DB-side state)
--
-- Adds:
--   enforce_slot_coverage(user_id)        — flips mirroring_disabled
--                                             on account_ownership rows
--                                             based on (used vs quota).
--   triggers on account_ownership +        — auto-recompute coverage
--           user_subscriptions               whenever either side moves.
--
-- Coverage rule: if used <= quota, all the trader's accounts are
-- enabled. If used > quota, the OLDEST (used - quota) accounts get
-- mirroring_disabled = true; the rest stay enabled. Oldest-first picked
-- so newer registrations (which the trader presumably "wants more"
-- since they spent slots most recently) stay live.
--
-- Today this is a DB-only signal — the trader UI surfaces it via the
-- Status pill ("INACTIVE") and a banner. Server-side actual mirroring
-- pause requires calling the trading API's active_master / active_slave
-- toggle endpoints; that hook lands in B.4.1 once the API team is back
-- online and we can verify the toggle behaves as advertised.

create or replace function public.enforce_slot_coverage(p_user_id uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_quota      int;
  v_used       int;
  v_to_disable int;
begin
  if p_user_id is null then
    return;
  end if;

  select coalesce(sum(slot_count)::int, 0) into v_quota
    from public.user_subscriptions
   where user_id = p_user_id and status = 'active';

  select count(*)::int into v_used
    from public.account_ownership
   where user_id = p_user_id;

  if v_used <= v_quota then
    -- All accounts covered → ensure none are disabled.
    update public.account_ownership
       set mirroring_disabled = false
     where user_id = p_user_id and mirroring_disabled = true;
    return;
  end if;

  v_to_disable := v_used - v_quota;

  -- Disable the oldest N; ensure the rest are enabled. One UPDATE
  -- handles both transitions.
  with ranked as (
    select trading_account_id,
           row_number() over (order by registered_at asc) as rn
      from public.account_ownership
     where user_id = p_user_id
  )
  update public.account_ownership ao
     set mirroring_disabled = (r.rn <= v_to_disable)
    from ranked r
   where ao.trading_account_id = r.trading_account_id
     and ao.mirroring_disabled <> (r.rn <= v_to_disable);
end;
$$;

grant execute on function public.enforce_slot_coverage(uuid) to authenticated;

-- =============================================================================
-- Triggers
-- =============================================================================

create or replace function public.trg_coverage_on_account()
returns trigger
language plpgsql
as $$
begin
  perform public.enforce_slot_coverage(
    coalesce(NEW.user_id, OLD.user_id)
  );
  return null;  -- AFTER triggers ignore the return value
end;
$$;

drop trigger if exists account_ownership_coverage on public.account_ownership;
create trigger account_ownership_coverage
  after insert or delete on public.account_ownership
  for each row execute function public.trg_coverage_on_account();

create or replace function public.trg_coverage_on_subscription()
returns trigger
language plpgsql
as $$
begin
  -- Fires on insert (new sub bought) and update (status flipped to
  -- active/expired/cancelled, slot_count changed, etc).
  perform public.enforce_slot_coverage(
    coalesce(NEW.user_id, OLD.user_id)
  );
  return null;
end;
$$;

drop trigger if exists user_subscription_coverage on public.user_subscriptions;
create trigger user_subscription_coverage
  after insert or update or delete on public.user_subscriptions
  for each row execute function public.trg_coverage_on_subscription();

-- =============================================================================
-- Backfill: run enforce_slot_coverage once for every existing user so
-- the new column reflects the current (used, quota) state.
-- =============================================================================

do $$
declare
  rec record;
begin
  for rec in
    select distinct user_id from public.account_ownership
  loop
    perform public.enforce_slot_coverage(rec.user_id);
  end loop;
end $$;

-- After this migration:
--   * Buy a slot → if you'd previously been over-quota, the oldest
--     account auto-re-enables.
--   * Sub expires → if it pushes you over-quota, oldest excess
--     account(s) flip to mirroring_disabled=true.
--   * UI: account_ownership.mirroring_disabled flips drive the
--     Status column ("ACTIVE"/"INACTIVE") + the inactive-accounts
--     banner on the Accounts tab.
--
-- Server-side mirror pause via trading API's active_*_/MT4|MT5 toggle
-- endpoints lands in B.4.1 (deferred — needs API team back online).
