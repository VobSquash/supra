-- Allow authenticated users to delete only their own bookings (RLS).
--
-- Matches a profile by bookings.vob_guid = profiles.vob_guid and either:
--   - profiles.id = auth.uid() (typical Supabase profile row keyed by auth user), or
--   - profiles.email matches the signed-in user's email from the JWT (legacy imports
--     where profile.id may not equal auth.uid()).
--
-- Re-run this after changing the policy text (drops and recreates).

drop policy if exists "bookings_delete_own" on public.bookings;

create policy "bookings_delete_own"
  on public.bookings
  for delete
  to authenticated
  using (
    exists (
      select 1
      from public.profiles p
      where p.vob_guid is not null
        and p.vob_guid = public.bookings.vob_guid
        and (
          p.id = auth.uid()
          or (
            coalesce(p.email, '') <> ''
            and coalesce(auth.jwt() ->> 'email', '') <> ''
            and lower(trim(p.email)) = lower(trim(auth.jwt() ->> 'email'))
          )
        )
    )
  );
