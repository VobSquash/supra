-- Adds an investigation-friendly creation date on bookings.
--
-- Safe to re-run.

alter table public.bookings
  add column if not exists date_created date;

-- Existing rows: default to "today" as requested.
update public.bookings
set date_created = current_date
where date_created is null;

-- New rows: auto-populate on insert.
alter table public.bookings
  alter column date_created set default current_date;

alter table public.bookings
  alter column date_created set not null;
