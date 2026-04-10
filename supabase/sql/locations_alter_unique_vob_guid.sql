-- One-time fix when `locations` was created with a partial unique index on
-- `vob_guid` (PostgREST upsert on `vob_guid` can fail with 42P10).
--
-- Safe to run if you have no conflicting duplicate non-null vob_guid values.

drop index if exists public.locations_vob_guid_key;

alter table public.locations
  add constraint locations_vob_guid_key unique (vob_guid);
