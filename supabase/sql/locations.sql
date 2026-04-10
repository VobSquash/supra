-- Run in Supabase SQL editor (or `supabase db push` if using CLI migrations).
-- Stores legacy Parse-style location fields; lat/long as text to match app DTOs.
--
-- Back4App → Supabase: `dart run migration --locations` (dry run) or
-- `dart run migration --migrate --locations` from packages/migration (service role key).

create table if not exists public.locations (
  id uuid primary key default gen_random_uuid(),
  -- Plain UNIQUE (not partial): PostgREST `on_conflict=vob_guid` needs a real
  -- unique constraint; multiple NULL vob_guid values are still allowed in PG.
  vob_guid text unique,
  name text,
  latitude text,
  longitude text,
  lookup text
);

-- If you already created this table with a partial unique index and hit 42P10 on
-- upsert, run `locations_alter_unique_vob_guid.sql` once, then optional.

alter table public.locations enable row level security;

-- Adjust to match your project: anon read for REST verification from the test app.
create policy "locations_select_anon_authenticated"
  on public.locations
  for select
  to anon, authenticated
  using (true);
