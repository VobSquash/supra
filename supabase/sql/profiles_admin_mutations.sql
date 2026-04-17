-- RLS: allow administrators and elevated users to add member profiles + extensions.
-- Apply after your base policies exist. Adjust if your `profiles`/`profile_extensions`
-- table names or `profile_type` literals differ.
--
-- Caller (Flutter) inserts: `profiles` (no `profile_extension_id` yet), then
-- `profile_extensions`, then PATCH `profiles.profile_extension_id`.
--
-- Schema note: this flow generates a new UUID for `profiles.id`. If your database
-- requires `profiles.id` = `auth.users.id`, create the Auth user first (e.g. Admin API)
-- and pass that id into the app/client instead of a random UUID.

-- Helper: current session user is an admin/elevated row in public.profiles.
-- Matches either profiles.id = auth.uid() OR profiles.email = auth.users.email (legacy rows).
create or replace function public._is_admin_or_elevated_profile()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1
    from public.profiles p
    where p.profile_type in ('administrator', 'elivated')
      and (
        p.id = auth.uid()
        or (
          (select u.email from auth.users u where u.id = auth.uid()) is not null
          and lower(trim(p.email)) = lower(trim((select u.email from auth.users u where u.id = auth.uid())))
        )
      )
  );
$$;

-- INSERT new member rows (normal members use `profile_type` = 'user' in app inserts).
drop policy if exists "profiles_insert_admin_or_elevated" on public.profiles;
create policy "profiles_insert_admin_or_elevated"
  on public.profiles
  for insert
  to authenticated
  with check (public._is_admin_or_elevated_profile());

-- INSERT extension rows for new members.
drop policy if exists "profile_extensions_insert_admin_or_elevated" on public.profile_extensions;
create policy "profile_extensions_insert_admin_or_elevated"
  on public.profile_extensions
  for insert
  to authenticated
  with check (public._is_admin_or_elevated_profile());

-- UPDATE profiles to set `profile_extension_id` after extension row exists.
drop policy if exists "profiles_update_admin_link_extension" on public.profiles;
create policy "profiles_update_admin_link_extension"
  on public.profiles
  for update
  to authenticated
  using (public._is_admin_or_elevated_profile())
  with check (public._is_admin_or_elevated_profile());
