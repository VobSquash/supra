-- Run once in the Supabase SQL editor if `map_image_url` was added earlier.
-- Map thumbnails use bundled assets in the app; no DB column needed.

alter table public.locations
  drop column if exists map_image_url;
