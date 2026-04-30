-- Slice 1A — Wallet groundwork
--
-- Adds:
--   profiles            (user_id, role) — admin/trader role gate
--   wallets             (user_id → balance) — one per user, auto-created on signup
--   wallet_transactions (deposit/slot_purchase/etc) — append-only audit log
--   confirm_deposit RPC — atomic admin-only deposit (debits caller-checked admin)
--
-- Triggers auto-create profile + wallet whenever an auth.users row appears,
-- so admin or any future-signed-up trader gets a wallet without manual SQL.
--
-- Slot purchase / renewal logic lands in 1B; the corresponding transaction
-- enum values are pre-declared here to avoid an enum-extension migration.

-- =============================================================================
-- profiles + wallets + wallet_transactions schema
-- =============================================================================

create table if not exists public.profiles (
  user_id      uuid primary key references auth.users on delete cascade,
  role         text not null default 'trader'
                   check (role in ('admin', 'trader')),
  display_name text,
  created_at   timestamptz not null default now()
);

create table if not exists public.wallets (
  id         uuid primary key default gen_random_uuid(),
  user_id    uuid not null unique references auth.users on delete cascade,
  balance    numeric(14,2) not null default 0,
  currency   text not null default 'USD',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  check (balance >= 0)
);

do $$
begin
  if not exists (select 1 from pg_type where typname = 'wallet_transaction_type') then
    create type public.wallet_transaction_type as enum (
      'deposit',
      'slot_purchase',
      'slot_renewal',
      'refund',
      'adjustment'
    );
  end if;
end $$;

create table if not exists public.wallet_transactions (
  id             uuid primary key default gen_random_uuid(),
  wallet_id      uuid not null references public.wallets on delete cascade,
  type           public.wallet_transaction_type not null,
  amount         numeric(14,2) not null,
  balance_after  numeric(14,2) not null,
  reference      text,
  created_by     uuid references auth.users,
  created_at     timestamptz not null default now()
);

create index if not exists wallet_transactions_wallet_id_created_at_idx
  on public.wallet_transactions (wallet_id, created_at desc);

-- =============================================================================
-- triggers: auto-create profile + wallet on auth signup; touch wallet.updated_at
-- =============================================================================

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (user_id, display_name)
    values (new.id, new.email)
    on conflict (user_id) do nothing;
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

create or replace function public.handle_new_profile()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.wallets (user_id) values (new.user_id)
    on conflict (user_id) do nothing;
  return new;
end;
$$;

drop trigger if exists on_profile_created on public.profiles;
create trigger on_profile_created
  after insert on public.profiles
  for each row execute function public.handle_new_profile();

create or replace function public.touch_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists on_wallet_updated on public.wallets;
create trigger on_wallet_updated
  before update on public.wallets
  for each row execute function public.touch_updated_at();

-- =============================================================================
-- is_admin helper (used by RLS + confirm_deposit)
-- =============================================================================

create or replace function public.is_admin()
returns boolean
language sql
security definer
stable
set search_path = public
as $$
  select exists(
    select 1 from public.profiles
    where user_id = auth.uid() and role = 'admin'
  );
$$;

grant execute on function public.is_admin() to authenticated;

-- =============================================================================
-- RLS
-- =============================================================================

alter table public.profiles enable row level security;
alter table public.wallets enable row level security;
alter table public.wallet_transactions enable row level security;

-- profiles
drop policy if exists "profiles select own"   on public.profiles;
drop policy if exists "profiles select admin" on public.profiles;
drop policy if exists "profiles update admin" on public.profiles;

create policy "profiles select own"
  on public.profiles for select
  using (auth.uid() = user_id);

create policy "profiles select admin"
  on public.profiles for select
  using (public.is_admin());

create policy "profiles update admin"
  on public.profiles for update
  using (public.is_admin());

-- wallets (read-only via RLS; mutations go through confirm_deposit / RPCs)
drop policy if exists "wallets select own"   on public.wallets;
drop policy if exists "wallets select admin" on public.wallets;

create policy "wallets select own"
  on public.wallets for select
  using (auth.uid() = user_id);

create policy "wallets select admin"
  on public.wallets for select
  using (public.is_admin());

-- wallet_transactions (read-only; appended by RPCs only)
drop policy if exists "wallet_transactions select own"   on public.wallet_transactions;
drop policy if exists "wallet_transactions select admin" on public.wallet_transactions;

create policy "wallet_transactions select own"
  on public.wallet_transactions for select
  using (
    exists (
      select 1 from public.wallets w
      where w.id = wallet_transactions.wallet_id
        and w.user_id = auth.uid()
    )
  );

create policy "wallet_transactions select admin"
  on public.wallet_transactions for select
  using (public.is_admin());

-- =============================================================================
-- confirm_deposit RPC — admin-only atomic credit
-- =============================================================================

create or replace function public.confirm_deposit(
  target_user_id     uuid,
  deposit_amount     numeric,
  deposit_reference  text
)
returns table (transaction_id uuid, new_balance numeric)
language plpgsql
security definer
set search_path = public
as $$
declare
  v_wallet_id   uuid;
  v_new_balance numeric;
  v_tx_id       uuid;
begin
  if not public.is_admin() then
    raise exception 'permission denied: only admins can confirm deposits';
  end if;

  if deposit_amount is null or deposit_amount <= 0 then
    raise exception 'invalid amount: must be positive';
  end if;

  select id, balance + deposit_amount
    into v_wallet_id, v_new_balance
  from public.wallets
  where user_id = target_user_id
  for update;

  if v_wallet_id is null then
    raise exception 'wallet not found for user %', target_user_id;
  end if;

  update public.wallets
     set balance = v_new_balance
   where id = v_wallet_id;

  insert into public.wallet_transactions (
    wallet_id, type, amount, balance_after, reference, created_by
  ) values (
    v_wallet_id, 'deposit', deposit_amount, v_new_balance,
    deposit_reference, auth.uid()
  )
  returning id into v_tx_id;

  return query select v_tx_id, v_new_balance;
end;
$$;

grant execute on function public.confirm_deposit(uuid, numeric, text) to authenticated;

-- =============================================================================
-- Backfill: profiles + wallets for existing auth.users (pre-trigger)
-- =============================================================================

insert into public.profiles (user_id, display_name)
  select id, email from auth.users
  on conflict (user_id) do nothing;

insert into public.wallets (user_id)
  select user_id from public.profiles
  on conflict (user_id) do nothing;

-- =============================================================================
-- Seed: promote Susanto's email to admin role
-- =============================================================================

update public.profiles
   set role = 'admin', display_name = coalesce(display_name, 'Susanto (Admin)')
 where user_id = (
   select id from auth.users
   where lower(email) = lower('business.skchowdhury@gmail.com')
   limit 1
 );

-- After this migration runs:
--   1. Open Supabase Dashboard → Authentication → Users → "Add user"
--      Create at least one test trader (e.g. trader1@quantumpips.test)
--      with a known password. The trigger auto-creates profile + wallet.
--   2. Verify in SQL editor:
--        select p.role, p.display_name, w.balance
--        from public.profiles p
--        join public.wallets w on w.user_id = p.user_id;
--      Expected: at least 2 rows — admin (you) + trader1 (test user).
