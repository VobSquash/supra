-- Parse class `LeagueFixture` (see packages/examples/back4app_client/.../client_league_fixtures.dart).
-- PostgREST: /league_fixtures
--
-- Migrate: `dart run migration --league-fixtures` (dry) or `dart run migration --migrate --league-fixtures`.

create table if not exists public.league_fixtures (
  id uuid primary key,
  game_date timestamptz not null,
  opponent text,
  opponent_location_id text,
  is_home boolean,
  league_team int,
  ladder_type int,
  legacy_object_id text
);

create index if not exists league_fixtures_game_date_idx
  on public.league_fixtures (game_date);

alter table public.league_fixtures enable row level security;

create policy "league_fixtures_select_anon_authenticated"
  on public.league_fixtures
  for select
  to anon, authenticated
  using (true);
