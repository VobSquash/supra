-- Profile picture URL on core profile row + storage bucket for binaries.
-- Apply in Supabase SQL editor (order: columns + view, then storage).

alter table public.profiles
  add column if not exists profile_picture_url text null;

alter table public.profiles
  add column if not exists profile_picture_updated_at timestamptz null;

comment on column public.profiles.profile_picture_url is
  'Public or signed URL for avatar; optional. One per profile.';
comment on column public.profiles.profile_picture_updated_at is
  'Last time avatar image was replaced; used for cache busting on clients.';

-- Extend membership view with picture columns.
-- New columns must come at the end of the SELECT list: Postgres rejects
-- CREATE OR REPLACE VIEW when earlier columns shift position (ERROR 42P16).
create or replace view public.v_member_ladder_membership_with_profile as
select
  m.vob_guid,
  m.ladder_type,
  m.ladder_rank,
  m.league_team_number,
  m.rank_within_team,
  p.id as profile_id,
  p.first_name as profile_first_name,
  p.last_name as profile_last_name,
  p.email as profile_email,
  p.contact_number as profile_contact_number,
  p.date_of_birth as profile_date_of_birth,
  p.is_active as profile_is_active,
  pe.id as profile_extension_id,
  pe.membership_type as membership_type,
  pe.emergency_contact_number as emergency_contact_number,
  pe.can_show_email as can_show_email,
  pe.can_show_contact as can_show_contact,
  pe.can_show_birthday as can_show_birthday,
  pe.is_coach as is_coach,
  p.profile_picture_url as profile_picture_url,
  p.profile_picture_updated_at as profile_picture_updated_at
from public.v_member_ladder_membership m
left join public.profiles p
  on p.vob_guid = m.vob_guid
left join lateral (
  select pe.*
  from public.profile_extensions pe
  where
    (p.profile_extension_id is not null and pe.id = p.profile_extension_id)
    or (p.profile_extension_id is null and pe.vob_guid = p.vob_guid)
  limit 1
) pe on true;

-- --- Storage (requires storage extension; runs in Supabase-hosted DB) ---
-- Optional: set file size / MIME allowlist in Dashboard if your project supports those columns.
insert into storage.buckets (id, name, public)
values ('avatars', 'avatars', true)
on conflict (id) do update set public = excluded.public;

drop policy if exists "avatars_public_read" on storage.objects;
create policy "avatars_public_read"
  on storage.objects
  for select
  to public
  using (bucket_id = 'avatars');

drop policy if exists "avatars_insert_own_folder" on storage.objects;
create policy "avatars_insert_own_folder"
  on storage.objects
  for insert
  to authenticated
  with check (
    bucket_id = 'avatars'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

drop policy if exists "avatars_update_own_folder" on storage.objects;
create policy "avatars_update_own_folder"
  on storage.objects
  for update
  to authenticated
  using (
    bucket_id = 'avatars'
    and (storage.foldername(name))[1] = auth.uid()::text
  )
  with check (
    bucket_id = 'avatars'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

drop policy if exists "avatars_delete_own_folder" on storage.objects;
create policy "avatars_delete_own_folder"
  on storage.objects
  for delete
  to authenticated
  using (
    bucket_id = 'avatars'
    and (storage.foldername(name))[1] = auth.uid()::text
  );
