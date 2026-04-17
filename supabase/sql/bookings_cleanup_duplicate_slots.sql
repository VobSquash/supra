-- Cleanup script: remove duplicate bookings occupying the exact same slot.
--
-- Duplicate definition in this script:
--   same court_no + same booking_date timestamp
--
-- Behavior:
--   keeps one row per slot (lowest id), deletes the rest.
--
-- Safe to run PREVIEW multiple times.
-- APPLY is destructive; validate preview first.

-- ---------------------------------------------------------------------------
-- PREVIEW: rows grouped by duplicate slot, with KEEP/DELETE action.
-- ---------------------------------------------------------------------------
with ranked as (
  select
    b.id,
    b.court_no,
    b.booking_date,
    b.vob_guid,
    b.display_name,
    b.group_booking_id,
    row_number() over (
      partition by b.court_no, b.booking_date
      order by b.id asc
    ) as rn,
    count(*) over (
      partition by b.court_no, b.booking_date
    ) as group_size
  from public.bookings b
  where b.court_no is not null
),
dupes as (
  select *
  from ranked
  where group_size > 1
)
select
  d.court_no,
  d.booking_date,
  d.id,
  d.vob_guid,
  d.display_name,
  d.group_booking_id,
  d.rn,
  d.group_size,
  case when d.rn = 1 then 'KEEP' else 'DELETE' end as action
from dupes d
order by d.court_no, d.booking_date, d.rn;

-- Optional summary:
-- with ranked as (
--   select
--     b.court_no,
--     b.booking_date,
--     row_number() over (
--       partition by b.court_no, b.booking_date
--       order by b.id asc
--     ) as rn,
--     count(*) over (
--       partition by b.court_no, b.booking_date
--     ) as group_size
--   from public.bookings b
--   where b.court_no is not null
-- )
-- select
--   count(*) filter (where group_size > 1 and rn > 1) as rows_to_delete,
--   count(distinct (court_no, booking_date)) filter (where group_size > 1) as duplicate_slots
-- from ranked;

-- ---------------------------------------------------------------------------
-- APPLY: uncomment once preview is validated.
-- ---------------------------------------------------------------------------
/*
begin;

with ranked as (
  select
    b.id,
    row_number() over (
      partition by b.court_no, b.booking_date
      order by b.id asc
    ) as rn,
    count(*) over (
      partition by b.court_no, b.booking_date
    ) as group_size
  from public.bookings b
  where b.court_no is not null
),
to_delete as (
  select id
  from ranked
  where group_size > 1
    and rn > 1
)
delete from public.bookings b
using to_delete d
where b.id = d.id
returning
  b.id,
  b.court_no,
  b.booking_date,
  b.vob_guid,
  b.display_name,
  b.group_booking_id;

commit;
*/
