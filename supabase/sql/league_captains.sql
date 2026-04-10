-- Parse class `LeagueCaptains` (see packages/examples/back4app_client/.../client_club_captains.dart).
-- PostgREST: /league_captains
--
-- Migrate: `dart run migration --club-captains` (dry) or `dart run migration --migrate --club-captains`.

create table if not exists public.league_captains (
  id uuid primary key,
  club_name text,
  captain_name text,
  captain_contact_no text,
  is_catering boolean,
  league_team int,
  -- Parse Location pointer objectId (or plain string FK)
  club_location_fk text,
  -- Same convention as Parse: enum index (0=mens, 1=ladies, 2=masters)
  ladder_type int,
  legacy_object_id text
);

create index if not exists league_captains_club_name_idx
  on public.league_captains (club_name);

alter table public.league_captains enable row level security;

create policy "league_captains_select_anon_authenticated"
  on public.league_captains
  for select
  to anon, authenticated
  using (true);
