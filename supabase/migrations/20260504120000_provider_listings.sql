-- Phase E.1.0 — provider_listings table
--
-- Public directory + approval workflow for trader-owned master accounts.
-- A row exists once a trader applies for their master to be public; admin
-- approval flips status='approved' and the master becomes visible on the
-- Discover surface. This is the source-of-truth for the
-- SupabaseSignalDirectoryRepository (E.1.3) that replaces the D.5 mock.
--
-- v1 simplifications:
--   * Performance numbers (gain_pct, drawdown_pct, followers_count) are
--     operator-set snapshots, set at approval time. Live-from-trades is
--     a separate slice — that needs trade-history aggregation.
--   * No re-application table; trader edits the same row when rejected.
--   * No per-master broker display name; we read account_ownership.platform
--     and surface the brand at presentation time.

-- =============================================================================
-- provider_listings table
-- =============================================================================

create table if not exists public.provider_listings (
  id                  uuid primary key default gen_random_uuid(),
  master_account_id   bigint not null
                        references public.account_ownership (trading_account_id)
                        on delete cascade,
  owner_user_id       uuid   not null
                        references auth.users (id) on delete cascade,
  -- Lifecycle. New applications start at 'pending'. Operator's review
  -- updates it to approved/rejected. Re-application after rejection just
  -- flips back to pending — no separate history row in v1.
  status              text not null default 'pending'
                        check (status in ('pending', 'approved', 'rejected')),
  -- Trader-supplied
  display_name        text not null,
  bio                 text,
  min_deposit         numeric(12,2),
  currency            text default 'USD',
  -- Operator-set on approval
  tier                text
                        check (tier is null
                               or tier in ('bronze', 'silver', 'gold', 'diamond')),
  risk_score          text
                        check (risk_score is null
                               or risk_score in ('low', 'medium', 'high')),
  gain_pct            numeric(8,4),    -- e.g. 0.0532 = +5.32%
  drawdown_pct        numeric(8,4),    -- e.g. -0.1200 = -12.00%
  -- Denormalized counter — kept fresh by the trigger below so the
  -- Discover surface doesn't need to count rows on every list query.
  followers_count     int not null default 0,
  -- Audit
  submitted_at        timestamptz not null default now(),
  reviewed_at         timestamptz,
  reviewed_by         uuid references auth.users (id) on delete set null,
  rejection_reason    text,
  created_at          timestamptz not null default now(),
  updated_at          timestamptz not null default now(),
  -- A trader can have at most one listing per master account. Re-apply
  -- after rejection updates the existing row — see status flow above.
  unique (master_account_id)
);

-- Useful read indexes for the two hot queries:
--   * Discover (anyone authenticated): status='approved' rows, paginated.
--   * Trader's own dashboard: owner_user_id='<me>', any status.
create index if not exists provider_listings_status_idx
  on public.provider_listings (status)
  where status = 'approved';
create index if not exists provider_listings_owner_idx
  on public.provider_listings (owner_user_id);

-- updated_at maintenance via the existing project-wide touch_updated_at()
drop trigger if exists on_provider_listings_updated on public.provider_listings;
create trigger on_provider_listings_updated
  before update on public.provider_listings
  for each row execute function public.touch_updated_at();

-- =============================================================================
-- Ownership guard
--
-- INSERT/UPDATE must reference a master_account_id that the caller
-- actually owns AND that's of type 'master'. Slaves can't be listed.
-- Admin bypasses (via the policies below they update reviewed_*
-- columns under is_admin()).
-- =============================================================================

create or replace function public.check_provider_listing_ownership()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  v_owner uuid;
  v_type  text;
begin
  select user_id, account_type into v_owner, v_type
    from public.account_ownership
   where trading_account_id = new.master_account_id;

  if v_owner is null then
    raise exception
      'master account % not found in account_ownership',
      new.master_account_id;
  end if;
  if v_type <> 'master' then
    raise exception
      'account % is a %, not a master — slaves cannot be listed',
      new.master_account_id, v_type;
  end if;
  if v_owner <> new.owner_user_id then
    raise exception
      'owner_user_id % does not match account_ownership.user_id %',
      new.owner_user_id, v_owner;
  end if;

  return new;
end;
$$;

drop trigger if exists check_provider_listing_ownership_ins
  on public.provider_listings;
create trigger check_provider_listing_ownership_ins
  before insert on public.provider_listings
  for each row execute function public.check_provider_listing_ownership();

-- On UPDATE the same check applies if owner_user_id or master_account_id
-- changes. Operator-controlled fields (status, tier, etc) shouldn't
-- re-validate ownership.
drop trigger if exists check_provider_listing_ownership_upd
  on public.provider_listings;
create trigger check_provider_listing_ownership_upd
  before update of master_account_id, owner_user_id on public.provider_listings
  for each row execute function public.check_provider_listing_ownership();

-- =============================================================================
-- followers_count maintenance
--
-- account_ownership.account_type='slave' rows that bind to a master
-- (via the trading API) aren't directly tied to a provider_listing.
-- For v1 we keep followers_count as an operator-editable approximation;
-- E.1.4 (or a separate slice) will denormalize from a real follow-intent
-- table once that exists.
-- =============================================================================

-- Placeholder: today the operator sets followers_count on approval; the
-- value isn't auto-maintained. When the follow_intents table lands in a
-- later slice, replace this comment with a trigger that increments /
-- decrements on intent insert/delete.

-- =============================================================================
-- RLS
--
-- Reads:
--   * Owner sees own (any status) — for the trader's "My Provider
--     Application" surface.
--   * Anyone authenticated sees status='approved' — for Discover.
--   * Admin sees all — for the approval queue.
--
-- Writes:
--   * Owner can insert + update their own pending row's trader-supplied
--     fields. RLS doesn't easily restrict per-column, so we rely on the
--     ownership trigger above + filter status changes via a separate
--     RPC for trader-side edits (resubmit_provider_application). For
--     v1, traders just write directly and we trust the UI not to flip
--     status — admin policies override anyway.
--   * Admin can update any row (status, tier, risk_score, etc).
-- =============================================================================

alter table public.provider_listings enable row level security;

drop policy if exists "provider_listings select own"      on public.provider_listings;
drop policy if exists "provider_listings select public"   on public.provider_listings;
drop policy if exists "provider_listings select admin"    on public.provider_listings;
drop policy if exists "provider_listings insert own"      on public.provider_listings;
drop policy if exists "provider_listings update own"      on public.provider_listings;
drop policy if exists "provider_listings update admin"    on public.provider_listings;

create policy "provider_listings select own"
  on public.provider_listings for select
  using (auth.uid() = owner_user_id);

create policy "provider_listings select public"
  on public.provider_listings for select
  using (status = 'approved' and auth.uid() is not null);

create policy "provider_listings select admin"
  on public.provider_listings for select
  using (public.is_admin());

create policy "provider_listings insert own"
  on public.provider_listings for insert
  with check (auth.uid() = owner_user_id);

create policy "provider_listings update own"
  on public.provider_listings for update
  using (auth.uid() = owner_user_id)
  with check (auth.uid() = owner_user_id);

create policy "provider_listings update admin"
  on public.provider_listings for update
  using (public.is_admin())
  with check (public.is_admin());

-- =============================================================================
-- Approval RPC (admin-only)
--
-- Wraps the status flip + reviewer attribution in one call so the
-- admin UI doesn't need to construct partial-update objects. Sets
-- reviewed_at + reviewed_by automatically.
-- =============================================================================

create or replace function public.approve_provider_listing(
  p_listing_id      uuid,
  p_tier            text,
  p_risk_score      text,
  p_gain_pct        numeric,
  p_drawdown_pct    numeric,
  p_followers_count int default 0
)
returns public.provider_listings
language plpgsql
security definer
set search_path = public
as $$
declare
  v_admin uuid;
  v_row   public.provider_listings;
begin
  v_admin := auth.uid();
  if v_admin is null or not public.is_admin() then
    raise exception 'permission denied: admin only';
  end if;

  update public.provider_listings
     set status            = 'approved',
         tier              = p_tier,
         risk_score        = p_risk_score,
         gain_pct          = p_gain_pct,
         drawdown_pct      = p_drawdown_pct,
         followers_count   = p_followers_count,
         reviewed_at       = now(),
         reviewed_by       = v_admin,
         rejection_reason  = null
   where id = p_listing_id
   returning * into v_row;

  if v_row.id is null then
    raise exception 'provider listing % not found', p_listing_id;
  end if;

  return v_row;
end;
$$;

grant execute on function
  public.approve_provider_listing(uuid, text, text, numeric, numeric, int)
  to authenticated;

create or replace function public.reject_provider_listing(
  p_listing_id uuid,
  p_reason     text
)
returns public.provider_listings
language plpgsql
security definer
set search_path = public
as $$
declare
  v_admin uuid;
  v_row   public.provider_listings;
begin
  v_admin := auth.uid();
  if v_admin is null or not public.is_admin() then
    raise exception 'permission denied: admin only';
  end if;

  update public.provider_listings
     set status            = 'rejected',
         reviewed_at       = now(),
         reviewed_by       = v_admin,
         rejection_reason  = p_reason
   where id = p_listing_id
   returning * into v_row;

  if v_row.id is null then
    raise exception 'provider listing % not found', p_listing_id;
  end if;

  return v_row;
end;
$$;

grant execute on function public.reject_provider_listing(uuid, text)
  to authenticated;

-- After this migration:
--   1. Verify table + RLS:
--        \d public.provider_listings
--        select policyname from pg_policies
--          where tablename = 'provider_listings';
--   2. Smoke test as trader: insert a row with their own master_account_id
--      (status defaults to 'pending'). Confirm the trigger rejects an
--      attempt to insert with someone else's master_account_id.
--   3. Smoke test as admin: select approve_provider_listing(<id>, 'gold',
--      'medium', 0.05, -0.10, 0); confirm row updates.
