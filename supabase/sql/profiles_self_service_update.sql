-- RLS: allow members to update their own [profiles] and linked [profile_extensions] rows.
-- Apply after base policies exist. Complements [profiles_admin_mutations.sql] (admin insert/update).
--
-- Matches legacy rows where [profiles.id] may not equal auth.uid() by allowing updates when
-- [profiles.email] matches the JWT email (same idea as `bookings_delete_own`).

-- Own profile row: standard Supabase link or legacy email match.
drop policy if exists "profiles_update_own" on public.profiles;
create policy "profiles_update_own"
  on public.profiles
  for update
  to authenticated
  using (
    id = auth.uid()
    or (
      coalesce(trim(email), '') <> ''
      and coalesce(trim(auth.jwt() ->> 'email'), '') <> ''
      and lower(trim(email)) = lower(trim(auth.jwt() ->> 'email'))
    )
  )
  with check (
    id = auth.uid()
    or (
      coalesce(trim(email), '') <> ''
      and coalesce(trim(auth.jwt() ->> 'email'), '') <> ''
      and lower(trim(email)) = lower(trim(auth.jwt() ->> 'email'))
    )
  );

-- Extension row tied to the member’s profile (FK by id or vob_guid).
drop policy if exists "profile_extensions_update_own" on public.profile_extensions;
create policy "profile_extensions_update_own"
  on public.profile_extensions
  for update
  to authenticated
  using (
    exists (
      select 1
      from public.profiles p
      where (
        (p.profile_extension_id is not null and p.profile_extension_id = profile_extensions.id)
        or (p.vob_guid is not null and profile_extensions.vob_guid is not null and p.vob_guid = profile_extensions.vob_guid)
      )
      and (
        p.id = auth.uid()
        or (
          coalesce(trim(p.email), '') <> ''
          and coalesce(trim(auth.jwt() ->> 'email'), '') <> ''
          and lower(trim(p.email)) = lower(trim(auth.jwt() ->> 'email'))
        )
      )
    )
  )
  with check (
    exists (
      select 1
      from public.profiles p
      where (
        (p.profile_extension_id is not null and p.profile_extension_id = profile_extensions.id)
        or (p.vob_guid is not null and profile_extensions.vob_guid is not null and p.vob_guid = profile_extensions.vob_guid)
      )
      and (
        p.id = auth.uid()
        or (
          coalesce(trim(p.email), '') <> ''
          and coalesce(trim(auth.jwt() ->> 'email'), '') <> ''
          and lower(trim(p.email)) = lower(trim(auth.jwt() ->> 'email'))
        )
      )
    )
  );
