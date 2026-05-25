-- RLS: allow admin/elevated profiles to UPDATE `settings` rows (Dupra admin: system flags, ladder breakdown, etc.).
--
-- Prerequisites: `profiles_admin_mutations.sql` has been applied so
-- `public._is_admin_or_elevated_profile()` exists.
--
-- Apply in Supabase: SQL Editor → run this file (or merge into your migration flow).

alter table public.settings enable row level security;

drop policy if exists "settings_update_admin_or_elevated" on public.settings;

create policy "settings_update_admin_or_elevated"
  on public.settings
  for update
  to authenticated
  using (public._is_admin_or_elevated_profile())
  with check (public._is_admin_or_elevated_profile());
