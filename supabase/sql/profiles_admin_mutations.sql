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
-- Identity match (any): profiles.id = auth.uid(); or email = auth.users.email; or
-- JWT user_metadata.vob_guid = profiles.vob_guid (legacy / non-1:1 profiles.id layouts).
-- profile_type: string literals used in app + common spellings (see ProfileTypeEnum).
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
    where (
        lower(trim(coalesce(p.profile_type::text, ''))) in (
          'administrator',
          'admin',
          'super_admin',
          'superadmin',
          'elivated',
          'elevated'
        )
        -- If profile_type is stored as numeric ids (see ProfileTypeEnum: admin=2, elevated=3):
        or trim(coalesce(p.profile_type::text, '')) in ('2', '3')
      )
      and (
        p.id = auth.uid()
        or (
          (select u.email from auth.users u where u.id = auth.uid()) is not null
          and lower(trim(coalesce(p.email, ''))) =
              lower(trim((select u.email from auth.users u where u.id = auth.uid())))
        )
        or (
          (auth.jwt() -> 'user_metadata') ? 'vob_guid'
          and nullif(trim(auth.jwt() -> 'user_metadata' ->> 'vob_guid'), '') is not null
          and p.vob_guid is not null
          and lower(replace(p.vob_guid::text, '-', '')) =
              lower(replace(trim(auth.jwt() -> 'user_metadata' ->> 'vob_guid'), '-', ''))
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

-- UPDATE any extension row (directory flags, emergency contact, SSA, etc.).
drop policy if exists "profile_extensions_update_admin_or_elevated" on public.profile_extensions;
create policy "profile_extensions_update_admin_or_elevated"
  on public.profile_extensions
  for update
  to authenticated
  using (public._is_admin_or_elevated_profile())
  with check (public._is_admin_or_elevated_profile());

-- UPDATE profiles to set `profile_extension_id` after extension row exists,
-- and to change fields such as `email` and `is_active` for any member row (same USING).
drop policy if exists "profiles_update_admin_link_extension" on public.profiles;
create policy "profiles_update_admin_link_extension"
  on public.profiles
  for update
  to authenticated
  using (public._is_admin_or_elevated_profile())
  with check (public._is_admin_or_elevated_profile());
