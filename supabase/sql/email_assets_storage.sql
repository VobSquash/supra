-- Public bucket for HTML email images (served at send time via email_asset_base_url).
-- Upload these object names (see DupraEmailImageManifest in app/dupra):
--   logo-side.png, header.png, shirt.png, it_comms.png,
--   facebook-circle-gray.png, twitter-circle-gray.png,
--   home_light_mode.png, Brent.png
--
-- After running, set in app_config.json:
--   "email_asset_base_url": "https://<project-ref>.supabase.co/storage/v1/object/public/email-images/"

insert into storage.buckets (id, name, public)
values ('email-images', 'email-images', true)
on conflict (id) do update set public = true;

drop policy if exists "email_assets_public_read" on storage.objects;
create policy "email_assets_public_read"
  on storage.objects
  for select
  to public
  using (bucket_id = 'email-images');

-- Service role / dashboard uploads; tighten with admin-only insert if needed.
drop policy if exists "email_assets_authenticated_insert" on storage.objects;
create policy "email_assets_authenticated_insert"
  on storage.objects
  for insert
  to authenticated
  with check (bucket_id = 'email-images');

drop policy if exists "email_assets_authenticated_update" on storage.objects;
create policy "email_assets_authenticated_update"
  on storage.objects
  for update
  to authenticated
  using (bucket_id = 'email-images');
