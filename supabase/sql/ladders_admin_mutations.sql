-- RLS: allow administrators/elevated users to insert/update/delete ladder tables.
-- DELETE is required for the app’s “purge season rows then re-insert ordered list” save path.
-- Requires helper function from profiles_admin_mutations.sql:
--   public._is_admin_or_elevated_profile()

-- Mens ladder
drop policy if exists "ladder_mens_insert_admin_or_elevated" on public.ladder_mens;
create policy "ladder_mens_insert_admin_or_elevated"
  on public.ladder_mens
  for insert
  to authenticated
  with check (public._is_admin_or_elevated_profile());

drop policy if exists "ladder_mens_update_admin_or_elevated" on public.ladder_mens;
create policy "ladder_mens_update_admin_or_elevated"
  on public.ladder_mens
  for update
  to authenticated
  using (public._is_admin_or_elevated_profile())
  with check (public._is_admin_or_elevated_profile());

drop policy if exists "ladder_mens_delete_admin_or_elevated" on public.ladder_mens;
create policy "ladder_mens_delete_admin_or_elevated"
  on public.ladder_mens
  for delete
  to authenticated
  using (public._is_admin_or_elevated_profile());

-- Ladies ladder
drop policy if exists "ladder_ladies_insert_admin_or_elevated" on public.ladder_ladies;
create policy "ladder_ladies_insert_admin_or_elevated"
  on public.ladder_ladies
  for insert
  to authenticated
  with check (public._is_admin_or_elevated_profile());

drop policy if exists "ladder_ladies_update_admin_or_elevated" on public.ladder_ladies;
create policy "ladder_ladies_update_admin_or_elevated"
  on public.ladder_ladies
  for update
  to authenticated
  using (public._is_admin_or_elevated_profile())
  with check (public._is_admin_or_elevated_profile());

drop policy if exists "ladder_ladies_delete_admin_or_elevated" on public.ladder_ladies;
create policy "ladder_ladies_delete_admin_or_elevated"
  on public.ladder_ladies
  for delete
  to authenticated
  using (public._is_admin_or_elevated_profile());

-- Masters ladder
drop policy if exists "ladder_masters_insert_admin_or_elevated" on public.ladder_masters;
create policy "ladder_masters_insert_admin_or_elevated"
  on public.ladder_masters
  for insert
  to authenticated
  with check (public._is_admin_or_elevated_profile());

drop policy if exists "ladder_masters_update_admin_or_elevated" on public.ladder_masters;
create policy "ladder_masters_update_admin_or_elevated"
  on public.ladder_masters
  for update
  to authenticated
  using (public._is_admin_or_elevated_profile())
  with check (public._is_admin_or_elevated_profile());

drop policy if exists "ladder_masters_delete_admin_or_elevated" on public.ladder_masters;
create policy "ladder_masters_delete_admin_or_elevated"
  on public.ladder_masters
  for delete
  to authenticated
  using (public._is_admin_or_elevated_profile());

-- Table privileges (RLS still applies on direct REST; the RPC in ladders_admin_replace_rpc.sql bypasses ladder RLS for the save path).
grant select, insert, update, delete on public.ladder_mens to authenticated;
grant select, insert, update, delete on public.ladder_ladies to authenticated;
grant select, insert, update, delete on public.ladder_masters to authenticated;
