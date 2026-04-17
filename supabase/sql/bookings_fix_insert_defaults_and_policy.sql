-- One-off patch for existing bookings tables:
-- 1) ensure inserts can omit `id` (uuid default)
-- 2) allow authenticated inserts under RLS
--
-- Safe to re-run.

alter table public.bookings
  alter column id set default gen_random_uuid();

do $$
begin
  if not exists (
    select 1
    from pg_policies
    where schemaname = 'public'
      and tablename = 'bookings'
      and policyname = 'bookings_insert_authenticated'
  ) then
    create policy "bookings_insert_authenticated"
      on public.bookings
      for insert
      to authenticated
      with check (true);
  end if;
end
$$;
