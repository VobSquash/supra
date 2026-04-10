-- Parse class `Bookings` (see packages/examples/back4app_client/.../client_bookings.dart).
-- PostgREST: /bookings
-- Apply `profiles_vob_guid_fks.sql` so `select=*,profiles(...)` works via FK.
--
-- Migrate: `dart run migration --bookings` (dry) or `dart run migration --migrate --bookings`.
-- Back4App query only imports BookingDate ≥ 1 Jan 2026 UTC (see Back4appBookingsExtractor).

create table if not exists public.bookings (
  id uuid primary key,
  vob_guid uuid,
  court_no int,
  booking_date timestamptz not null,
  display_name text,
  group_booking_id int,
  legacy_object_id text
);

create index if not exists bookings_booking_date_idx
  on public.bookings (booking_date);

create index if not exists bookings_vob_guid_idx
  on public.bookings (vob_guid);

alter table public.bookings enable row level security;

create policy "bookings_select_anon_authenticated"
  on public.bookings
  for select
  to anon, authenticated
  using (true);
