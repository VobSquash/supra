-- One table per Parse ladder class: LadderMens, LadderLadies, LadderMasters.
-- PostgREST: /ladder_mens, /ladder_ladies, /ladder_masters
-- After data is migrated, apply `profiles_vob_guid_fks.sql` for FK + embedded `profiles(...)`.
--
-- CLI: `dart run migration --ladders` / `--migrate --ladders`.
--
-- If you previously used the unified `ladder_entries` schema, drop it after cutover:
--   drop table if exists public.ladder_entries cascade;

create table if not exists public.ladder_mens (
  id uuid primary key,
  sort_order int,
  year int,
  vob_guid uuid,
  team int,
  can_be_challenged boolean,
  legacy_object_id text
);

create index if not exists ladder_mens_sort_order_idx
  on public.ladder_mens (sort_order);

alter table public.ladder_mens enable row level security;

create policy "ladder_mens_select_anon_authenticated"
  on public.ladder_mens
  for select
  to anon, authenticated
  using (true);

create table if not exists public.ladder_ladies (
  id uuid primary key,
  sort_order int,
  year int,
  vob_guid uuid,
  team int,
  can_be_challenged boolean,
  legacy_object_id text
);

create index if not exists ladder_ladies_sort_order_idx
  on public.ladder_ladies (sort_order);

alter table public.ladder_ladies enable row level security;

create policy "ladder_ladies_select_anon_authenticated"
  on public.ladder_ladies
  for select
  to anon, authenticated
  using (true);

create table if not exists public.ladder_masters (
  id uuid primary key,
  sort_order int,
  year int,
  vob_guid uuid,
  team int,
  can_be_challenged boolean,
  legacy_object_id text
);

create index if not exists ladder_masters_sort_order_idx
  on public.ladder_masters (sort_order);

alter table public.ladder_masters enable row level security;

create policy "ladder_masters_select_anon_authenticated"
  on public.ladder_masters
  for select
  to anon, authenticated
  using (true);
