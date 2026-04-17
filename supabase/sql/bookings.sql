-- Parse class `Bookings` (see packages/examples/back4app_client/.../client_bookings.dart).
-- PostgREST: /bookings
-- Apply `profiles_vob_guid_fks.sql` so `select=*,profiles(...)` works via FK.
--
-- Migrate: `dart run migration --bookings` (dry) or `dart run migration --migrate --bookings`.
-- Back4App query only imports BookingDate ≥ 1 Jan 2026 UTC (see Back4appBookingsExtractor).

create table if not exists public.bookings (
  id uuid primary key default gen_random_uuid(),
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

create unique index if not exists bookings_slot_unique_idx
  on public.bookings (court_no, booking_date)
  where court_no is not null;

alter table public.bookings enable row level security;

create policy "bookings_select_anon_authenticated"
  on public.bookings
  for select
  to anon, authenticated
  using (true);

create policy "bookings_insert_authenticated"
  on public.bookings
  for insert
  to authenticated
  with check (true);

-- Own booking: profile row matches booking.vob_guid AND either
--   (a) profiles.id = auth.uid() (standard Supabase), or
--   (b) profiles.email matches JWT email (legacy rows where id != auth user id).
create policy "bookings_delete_own"
  on public.bookings
  for delete
  to authenticated
  using (
    exists (
      select 1
      from public.profiles p
      where p.vob_guid is not null
        and p.vob_guid = public.bookings.vob_guid
        and (
          p.id = auth.uid()
          or (
            coalesce(p.email, '') <> ''
            and coalesce(auth.jwt() ->> 'email', '') <> ''
            and lower(trim(p.email)) = lower(trim(auth.jwt() ->> 'email'))
          )
        )
    )
  );

create or replace function public.booking_requester_is_coach(p_vob_guid uuid)
returns boolean
language sql
stable
as $$
  select coalesce(pe.is_coach, false)
  from public.profiles p
  left join public.profile_extensions pe
    on (
      (p.profile_extension_id is not null and pe.id = p.profile_extension_id)
      or (
        p.profile_extension_id is null
        and pe.vob_guid is not null
        and p.vob_guid = pe.vob_guid::uuid
      )
    )
  where p.vob_guid = p_vob_guid
  limit 1;
$$;

create or replace function public.enforce_bookings_rules()
returns trigger
language plpgsql
as $$
declare
  requester_is_coach boolean := false;
begin
  -- Defensive check with a clearer message than generic DB errors.
  if new.court_no is null then
    raise exception 'Court number is required.';
  end if;

  -- Non-coach general bookings: max one booking per UTC day.
  if coalesce(new.group_booking_id, 0) = 0 and new.vob_guid is not null then
    requester_is_coach := coalesce(public.booking_requester_is_coach(new.vob_guid), false);
    if not requester_is_coach and exists (
      select 1
      from public.bookings b
      where b.id is distinct from new.id
        and b.vob_guid = new.vob_guid
        and coalesce(b.group_booking_id, 0) = 0
        and (b.booking_date at time zone 'UTC')::date = (new.booking_date at time zone 'UTC')::date
    ) then
      raise exception using
        errcode = '23505',
        message = 'You already have a booking for this day.';
    end if;
  end if;

  return new;
end;
$$;

drop trigger if exists bookings_rules_enforcer on public.bookings;

create trigger bookings_rules_enforcer
before insert or update on public.bookings
for each row
execute function public.enforce_bookings_rules();
