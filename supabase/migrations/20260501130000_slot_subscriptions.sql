-- Slice 1B — Slot subscriptions
--
-- Adds:
--   plan_tier enum            ('start', 'pro', 'premium')
--   plan_tier_config          (admin-editable: ranges + base monthly price per slot)
--   commitment_discount       (admin-editable: discount % per commitment length)
--   user_subscriptions        (one row per slot purchase; auto_renew default ON)
--
-- Helpers + RPCs:
--   tier_for_slot_count(int)              → plan_tier
--   compute_subscription_cost(...)        → numeric
--   book_slots(slots, months)             → trader-callable; debits wallet, inserts sub
--   update_tier_config(...)               → admin-only
--   update_commitment_discount(...)       → admin-only
--
-- Renewal pricing model (per spec, 2026-05-01): slots renew at
-- *current* admin pricing, NOT locked at purchase. The tier on a
-- subscription is also re-derived at renewal from the current
-- plan_tier_config in case admin moved the slot range bands.
-- (Renewal job lands in 1C.)

-- =============================================================================
-- plan_tier enum
-- =============================================================================

do $$
begin
  if not exists (select 1 from pg_type where typname = 'plan_tier') then
    create type public.plan_tier as enum ('start', 'pro', 'premium');
  end if;
end $$;

-- =============================================================================
-- plan_tier_config — slot ranges + base monthly price per tier
-- =============================================================================

create table if not exists public.plan_tier_config (
  tier                 public.plan_tier primary key,
  min_slots            int not null check (min_slots >= 1),
  max_slots            int check (max_slots is null or max_slots >= min_slots),
  base_price_per_slot  numeric(10,2) not null check (base_price_per_slot >= 0),
  updated_at           timestamptz not null default now()
);

drop trigger if exists on_plan_tier_config_updated on public.plan_tier_config;
create trigger on_plan_tier_config_updated
  before update on public.plan_tier_config
  for each row execute function public.touch_updated_at();

-- Seed defaults (idempotent — preserves operator edits across re-runs).
insert into public.plan_tier_config (tier, min_slots, max_slots, base_price_per_slot)
values
  ('start',    1,  10,   4.99),
  ('pro',      11, 50,   3.99),
  ('premium',  51, null, 2.99)
on conflict (tier) do nothing;

-- =============================================================================
-- commitment_discount — discount % per commitment length
-- =============================================================================

create table if not exists public.commitment_discount (
  commitment_months  int primary key check (commitment_months in (1, 3, 6, 12)),
  discount_percent   numeric(5,2) not null default 0
                       check (discount_percent >= 0 and discount_percent <= 100),
  updated_at         timestamptz not null default now()
);

drop trigger if exists on_commitment_discount_updated on public.commitment_discount;
create trigger on_commitment_discount_updated
  before update on public.commitment_discount
  for each row execute function public.touch_updated_at();

insert into public.commitment_discount (commitment_months, discount_percent)
values
  (1,  0),
  (3,  5),
  (6,  10),
  (12, 20)
on conflict (commitment_months) do nothing;

-- =============================================================================
-- user_subscriptions
-- =============================================================================

create table if not exists public.user_subscriptions (
  id                 uuid primary key default gen_random_uuid(),
  user_id            uuid not null references auth.users on delete cascade,
  tier               public.plan_tier not null,
  slot_count         int not null check (slot_count >= 1),
  commitment_months  int not null check (commitment_months in (1, 3, 6, 12)),
  total_paid         numeric(14,2) not null check (total_paid >= 0),
  started_at         timestamptz not null default now(),
  expires_at         timestamptz not null,
  status             text not null default 'active'
                       check (status in ('active', 'expired', 'cancelled')),
  auto_renew         boolean not null default true,
  created_at         timestamptz not null default now(),
  updated_at         timestamptz not null default now()
);

create index if not exists user_subscriptions_user_id_idx
  on public.user_subscriptions (user_id);

create index if not exists user_subscriptions_expires_at_idx
  on public.user_subscriptions (expires_at)
  where status = 'active';

drop trigger if exists on_user_subscription_updated on public.user_subscriptions;
create trigger on_user_subscription_updated
  before update on public.user_subscriptions
  for each row execute function public.touch_updated_at();

-- =============================================================================
-- Pricing helpers
-- =============================================================================

create or replace function public.tier_for_slot_count(slots int)
returns public.plan_tier
language sql
stable
set search_path = public
as $$
  select tier from public.plan_tier_config
  where slots >= min_slots
    and (max_slots is null or slots <= max_slots)
  order by min_slots
  limit 1;
$$;

grant execute on function public.tier_for_slot_count(int) to authenticated;

create or replace function public.compute_subscription_cost(
  p_slot_count        int,
  p_commitment_months int
)
returns numeric
language plpgsql
stable
set search_path = public
as $$
declare
  v_tier         public.plan_tier;
  v_base_price   numeric;
  v_discount_pct numeric;
  v_total        numeric;
begin
  v_tier := public.tier_for_slot_count(p_slot_count);
  if v_tier is null then
    raise exception 'no tier matches slot_count=%', p_slot_count;
  end if;

  select base_price_per_slot into v_base_price
    from public.plan_tier_config where tier = v_tier;

  select discount_percent into v_discount_pct
    from public.commitment_discount
    where commitment_months = p_commitment_months;
  if v_discount_pct is null then
    raise exception 'unsupported commitment_months=%', p_commitment_months;
  end if;

  -- total = qty × base_price × months × (1 − discount/100)
  v_total := p_slot_count
             * v_base_price
             * p_commitment_months
             * (1 - v_discount_pct / 100.0);

  return round(v_total, 2);
end;
$$;

grant execute on function public.compute_subscription_cost(int, int) to authenticated;

-- =============================================================================
-- RLS
-- =============================================================================

alter table public.plan_tier_config enable row level security;
alter table public.commitment_discount enable row level security;
alter table public.user_subscriptions enable row level security;

-- plan_tier_config: any authenticated reads, admin writes via RPC
drop policy if exists "plan_tier_config select all" on public.plan_tier_config;
create policy "plan_tier_config select all"
  on public.plan_tier_config for select
  using (auth.role() = 'authenticated');

-- commitment_discount: any authenticated reads, admin writes via RPC
drop policy if exists "commitment_discount select all" on public.commitment_discount;
create policy "commitment_discount select all"
  on public.commitment_discount for select
  using (auth.role() = 'authenticated');

-- user_subscriptions: owner reads own; admin reads all; mutations via RPC
drop policy if exists "user_subscriptions select own"   on public.user_subscriptions;
drop policy if exists "user_subscriptions select admin" on public.user_subscriptions;

create policy "user_subscriptions select own"
  on public.user_subscriptions for select
  using (auth.uid() = user_id);

create policy "user_subscriptions select admin"
  on public.user_subscriptions for select
  using (public.is_admin());

-- =============================================================================
-- book_slots RPC — trader buys a subscription, debits wallet
-- =============================================================================

create or replace function public.book_slots(
  p_slot_count        int,
  p_commitment_months int
)
returns table (
  subscription_id  uuid,
  total_paid       numeric,
  expires_at       timestamptz,
  new_wallet_balance numeric
)
language plpgsql
security definer
set search_path = public
as $$
declare
  v_user_id          uuid;
  v_tier             public.plan_tier;
  v_total            numeric;
  v_wallet_id        uuid;
  v_wallet_balance   numeric;
  v_new_balance      numeric;
  v_sub_id           uuid;
  v_expires_at       timestamptz;
  v_now              timestamptz;
begin
  v_user_id := auth.uid();
  if v_user_id is null then
    raise exception 'not authenticated';
  end if;

  if p_slot_count is null or p_slot_count < 1 then
    raise exception 'slot_count must be >= 1';
  end if;

  v_tier := public.tier_for_slot_count(p_slot_count);
  if v_tier is null then
    raise exception 'no tier matches slot_count=%', p_slot_count;
  end if;

  v_total := public.compute_subscription_cost(p_slot_count, p_commitment_months);

  -- Lock + read wallet
  select id, balance into v_wallet_id, v_wallet_balance
    from public.wallets
    where user_id = v_user_id
    for update;

  if v_wallet_id is null then
    raise exception 'wallet not found for user';
  end if;

  if v_wallet_balance < v_total then
    raise exception 'insufficient wallet balance: need %, have %',
      v_total, v_wallet_balance;
  end if;

  v_new_balance := v_wallet_balance - v_total;
  v_now := now();
  v_expires_at := v_now + make_interval(months => p_commitment_months);

  -- Debit wallet
  update public.wallets
    set balance = v_new_balance
    where id = v_wallet_id;

  -- Create subscription
  insert into public.user_subscriptions (
    user_id, tier, slot_count, commitment_months,
    total_paid, started_at, expires_at, status, auto_renew
  ) values (
    v_user_id, v_tier, p_slot_count, p_commitment_months,
    v_total, v_now, v_expires_at, 'active', true
  )
  returning id into v_sub_id;

  -- Audit transaction (negative amount for debit)
  insert into public.wallet_transactions (
    wallet_id, type, amount, balance_after, reference, created_by
  ) values (
    v_wallet_id, 'slot_purchase', -v_total, v_new_balance,
    format('subscription:%s (%s slots × %s months × tier %s)',
           v_sub_id, p_slot_count, p_commitment_months, v_tier),
    v_user_id
  );

  return query
    select v_sub_id, v_total, v_expires_at, v_new_balance;
end;
$$;

grant execute on function public.book_slots(int, int) to authenticated;

-- =============================================================================
-- Admin pricing RPCs
-- =============================================================================

create or replace function public.update_tier_config(
  p_tier                 public.plan_tier,
  p_min_slots            int,
  p_max_slots            int,
  p_base_price_per_slot  numeric
)
returns public.plan_tier_config
language plpgsql
security definer
set search_path = public
as $$
declare
  v_row public.plan_tier_config;
begin
  if not public.is_admin() then
    raise exception 'permission denied: admin only';
  end if;

  if p_min_slots < 1 then
    raise exception 'min_slots must be >= 1';
  end if;

  if p_max_slots is not null and p_max_slots < p_min_slots then
    raise exception 'max_slots must be >= min_slots or null';
  end if;

  if p_base_price_per_slot < 0 then
    raise exception 'base_price_per_slot must be >= 0';
  end if;

  update public.plan_tier_config
    set min_slots = p_min_slots,
        max_slots = p_max_slots,
        base_price_per_slot = p_base_price_per_slot
    where tier = p_tier
    returning * into v_row;

  if v_row is null then
    raise exception 'unknown tier %', p_tier;
  end if;

  return v_row;
end;
$$;

grant execute on function public.update_tier_config(public.plan_tier, int, int, numeric) to authenticated;

create or replace function public.update_commitment_discount(
  p_commitment_months  int,
  p_discount_percent   numeric
)
returns public.commitment_discount
language plpgsql
security definer
set search_path = public
as $$
declare
  v_row public.commitment_discount;
begin
  if not public.is_admin() then
    raise exception 'permission denied: admin only';
  end if;

  if p_discount_percent < 0 or p_discount_percent > 100 then
    raise exception 'discount_percent must be 0..100';
  end if;

  update public.commitment_discount
    set discount_percent = p_discount_percent
    where commitment_months = p_commitment_months
    returning * into v_row;

  if v_row is null then
    raise exception 'unsupported commitment_months %', p_commitment_months;
  end if;

  return v_row;
end;
$$;

grant execute on function public.update_commitment_discount(int, numeric) to authenticated;

-- After this migration runs:
--   1. Verify defaults seeded:
--        select * from public.plan_tier_config;
--        select * from public.commitment_discount;
--   2. As admin, edit pricing via the new admin Plans screen.
--   3. As trader (with wallet balance), book slots via Buy Slots screen.
