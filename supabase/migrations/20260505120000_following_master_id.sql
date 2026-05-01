-- Phase E.2.0 — record which master each slave follows
--
-- Today the trading API knows the slave→master binding (set at
-- register time via the masterId query param) but we don't persist it
-- locally. That's fine for accounts ops (delete + register suffice)
-- but breaks the My Follows / Provider Profile surfaces, which need
-- to ask "who is this slave following?" / "is this master being
-- followed by any of my slaves?" without a round-trip.
--
-- Adding the column closes the gap. Going forward, the trading-proxy
-- Edge Function writes following_master_id on every successful slave
-- register (and switch master ships the same code path because it
-- delete-then-registers a fresh row).
--
-- Backfill: existing slaves left NULL — we don't have a cheap way to
-- ask the trading API "who is slave X following" without an extra
-- endpoint round-trip per row. The trader can clear the unbound
-- state by switching master once, or by delete + re-register.

alter table public.account_ownership
  add column if not exists following_master_id bigint
    references public.account_ownership (trading_account_id)
    on delete set null;

-- Useful indexed query: My Follows wants every slave belonging to the
-- caller, joined with the master row. Filter on user_id + slave first
-- (cheap), then point-fetch the master via trading_account_id (PK).
create index if not exists account_ownership_following_master_id_idx
  on public.account_ownership (following_master_id)
  where following_master_id is not null;

-- Trigger guard: a row's following_master_id must reference a row
-- that's account_type = 'master'. Prevents pointing a slave at another
-- slave by accident (the FK would only catch missing IDs, not the
-- type mismatch).
create or replace function public.check_following_master_is_master()
returns trigger
language plpgsql
as $$
declare
  v_type text;
begin
  if new.following_master_id is null then
    return new;
  end if;
  -- Skip the lookup if value didn't change (avoids an extra select on
  -- non-binding updates like display_name renames).
  if tg_op = 'UPDATE'
     and old.following_master_id is not distinct from new.following_master_id
  then
    return new;
  end if;
  select account_type into v_type
    from public.account_ownership
   where trading_account_id = new.following_master_id;
  if v_type is null then
    raise exception
      'following_master_id % does not exist in account_ownership',
      new.following_master_id;
  end if;
  if v_type <> 'master' then
    raise exception
      'following_master_id % refers to a %, not a master',
      new.following_master_id, v_type;
  end if;
  return new;
end;
$$;

drop trigger if exists check_following_master_is_master_ins
  on public.account_ownership;
create trigger check_following_master_is_master_ins
  before insert on public.account_ownership
  for each row execute function public.check_following_master_is_master();

drop trigger if exists check_following_master_is_master_upd
  on public.account_ownership;
create trigger check_following_master_is_master_upd
  before update of following_master_id on public.account_ownership
  for each row execute function public.check_following_master_is_master();
