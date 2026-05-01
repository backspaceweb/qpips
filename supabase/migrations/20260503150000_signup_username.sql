-- Trader sign-up support — username from raw_user_meta_data
--
-- Sign-up flow passes the trader-chosen username via Supabase's auth
-- metadata field (auth.signUp(data: {'username': ...})). That metadata
-- lands on auth.users.raw_user_meta_data->>'username'. We hook it
-- through to profiles.display_name in the existing handle_new_user
-- trigger.
--
-- Backwards-compatible: when no username is supplied (e.g. operator
-- creates a user via Supabase Dashboard), the trigger falls back to
-- the email — same as before.

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (user_id, display_name)
    values (
      new.id,
      coalesce(
        nullif(trim(new.raw_user_meta_data->>'username'), ''),
        new.email
      )
    )
    on conflict (user_id) do nothing;
  return new;
end;
$$;
