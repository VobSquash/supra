-- Public bucket for upcoming-event banner images (member home carousel).
-- Upload objects at the bucket root with numeric names, e.g. 1.png, 2.jpg, 3.webp.
-- The app lists the bucket dynamically (no hardcoded filenames).
--
-- After running, optionally set in app_config.json:
--   "banner_events_base_url": "https://<project-ref>.supabase.co/storage/v1/object/public/banner_events/"

insert into storage.buckets (id, name, public)
values ('banner_events', 'banner_events', true)
on conflict (id) do update set public = true;

drop policy if exists "banner_events_public_read" on storage.objects;
create policy "banner_events_public_read"
  on storage.objects
  for select
  to public
  using (bucket_id = 'banner_events');

drop policy if exists "banner_events_authenticated_insert" on storage.objects;
create policy "banner_events_authenticated_insert"
  on storage.objects
  for insert
  to authenticated
  with check (bucket_id = 'banner_events');

drop policy if exists "banner_events_authenticated_update" on storage.objects;
create policy "banner_events_authenticated_update"
  on storage.objects
  for update
  to authenticated
  using (bucket_id = 'banner_events');

drop policy if exists "banner_events_authenticated_delete" on storage.objects;
create policy "banner_events_authenticated_delete"
  on storage.objects
  for delete
  to authenticated
  using (bucket_id = 'banner_events');
