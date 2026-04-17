-- Enforce bookings rules with coach-aware daily limit and strict slot uniqueness.
--
-- Safe to re-run.

drop index if exists public.bookings_one_per_day_per_member_uidx;

create unique index if not exists bookings_slot_unique_idx
  on public.bookings (court_no, booking_date)
  where court_no is not null;

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
  if new.court_no is null then
    raise exception 'Court number is required.';
  end if;

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
