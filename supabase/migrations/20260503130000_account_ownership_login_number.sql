-- Slice B.1.1 — split trading_account_id (server-side) from login_number (user-facing)
--
-- Bug spotted in B.1: we were storing the trader-supplied broker login
-- as trading_account_id. But the trading API assigns its own internal
-- serverId on register, and that's what the masterId param (slave
-- register) and delete endpoints expect. Login != serverId for MT5 etc.
--
-- Fix: account_ownership keeps trading_account_id as the API serverId,
-- and adds a separate login_number column (the broker login the trader
-- typed in). UI shows login_number; trading_account_id is internal
-- glue.
--
-- Backfill: existing rows get login_number = trading_account_id::text
-- as a placeholder. Operator should replace those rows by deleting
-- the corresponding account via the trader app + re-registering after
-- this migration deploys (the new register flow stores both columns
-- correctly).

alter table public.account_ownership
  add column if not exists login_number text not null default '';

update public.account_ownership
   set login_number = trading_account_id::text
   where login_number = '';

-- Drop the default so future inserts must specify it explicitly (the
-- Edge Function fills it from the register-call's userId query param).
alter table public.account_ownership
  alter column login_number drop default;

create index if not exists account_ownership_login_number_idx
  on public.account_ownership (login_number);

-- After this migration: existing rows have login_number =
-- trading_account_id::text (which is the buggy value from B.1).
-- Operator should:
--   1. Delete affected accounts via the trader app's Accounts table.
--   2. Re-register through Add Account; the Edge Function now stores
--      serverId + login_number correctly.
