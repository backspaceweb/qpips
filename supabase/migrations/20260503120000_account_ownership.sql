-- Slice B.1 — Account ownership
--
-- Adds:
--   account_ownership table — one row per registered trading account.
--                              Trader app's "Accounts" tab reads from
--                              here; admin reads all (for ops).
--   get_my_slot_usage()      — (used, quota) helper used by the
--                              trading-proxy Edge Function for the
--                              slot-quota gate at register time.
--
-- mirroring_disabled column lands here (default false) so 1C-style
-- runtime enforcement (slice B.4) can flip rows without another
-- schema change.
--
-- No data backfill: operator's existing accounts (415614138 master /
-- 413713476 slave) MUST be deleted via the existing admin Add/Delete
-- flow before this migration deploys, so the new table starts empty
-- and ownership is enforced from the first new registration.

-- =============================================================================
-- account_ownership table
-- =============================================================================

create table if not exists public.account_ownership (
  trading_account_id  bigint primary key,                     -- broker login (matches API userId)
  user_id             uuid not null references auth.users on delete cascade,
  platform            text not null
                        check (platform in ('mt4', 'mt5', 'ctrader',
                                            'dxtrade', 'tradelocker', 'matchtrade')),
  account_type        text not null check (account_type in ('master', 'slave')),
  display_name        text,
  registered_at       timestamptz not null default now(),
  mirroring_disabled  boolean not null default false,
  updated_at          timestamptz not null default now()
);

create index if not exists account_ownership_user_id_idx
  on public.account_ownership (user_id);

drop trigger if exists on_account_ownership_updated on public.account_ownership;
create trigger on_account_ownership_updated
  before update on public.account_ownership
  for each row execute function public.touch_updated_at();

-- =============================================================================
-- RLS
--
-- Reads: owner + admin. Mutations only via the Edge Function using the
-- service-role key (which bypasses RLS) — keeping insert/delete out of
-- normal client reach.
-- =============================================================================

alter table public.account_ownership enable row level security;

drop policy if exists "account_ownership select own"   on public.account_ownership;
drop policy if exists "account_ownership select admin" on public.account_ownership;

create policy "account_ownership select own"
  on public.account_ownership for select
  using (auth.uid() = user_id);

create policy "account_ownership select admin"
  on public.account_ownership for select
  using (public.is_admin());

-- =============================================================================
-- get_my_slot_usage helper
--
-- Single-row table return: (used, quota).
--   used  = count of trader's owned accounts
--   quota = sum of slot_count across active subscriptions
-- The trading-proxy Edge Function calls this RPC under the trader's
-- JWT (RLS scopes naturally) before forwarding any /register* call.
-- =============================================================================

create or replace function public.get_my_slot_usage()
returns table (used int, quota int)
language sql
stable
security definer
set search_path = public
as $$
  select
    (select count(*)::int
       from public.account_ownership
       where user_id = auth.uid()),
    (select coalesce(sum(slot_count)::int, 0)
       from public.user_subscriptions
       where user_id = auth.uid() and status = 'active');
$$;

grant execute on function public.get_my_slot_usage() to authenticated;

-- After this migration:
--   1. Verify table + helper:
--        select * from public.account_ownership;     -- should be empty
--        select * from public.get_my_slot_usage();   -- (0, X) where X is your sub slot count
--   2. Deploy the updated trading-proxy Edge Function — it begins
--      enforcing the quota gate + writing/deleting ownership rows
--      atomically with successful trading-API register/delete calls.
