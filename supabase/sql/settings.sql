-- Key-value app settings (Parse `Settings` class parity: Name / Value).
--
-- CLI: `dart run migration --settings` (dry run) or `dart run migration --migrate --settings`.

create table if not exists public.settings (
  id uuid primary key default gen_random_uuid(),
  name text not null unique,
  value text,
  legacy_object_id text
);

alter table public.settings enable row level security;

create policy "settings_select_anon_authenticated"
  on public.settings
  for select
  to anon, authenticated
  using (true);
