-- Cleanup script: remove exact duplicate GENERAL bookings.
--
-- Definition of duplicate in this script:
--   same vob_guid + same court_no + same booking_date timestamp + general booking
--   (coalesce(group_booking_id, 0) = 0)
--
-- Behavior:
--   keeps the first booking in each exact duplicate set
--   deletes the rest
--
-- Safe to run as PREVIEW multiple times.
-- APPLY is destructive; run inside a transaction and validate preview first.

-- ---------------------------------------------------------------------------
-- PREVIEW: shows exact duplicate groups and which rows would be deleted.
-- ---------------------------------------------------------------------------
with ranked as (
  select
    b.id,
    b.vob_guid,
    b.booking_date,
    b.court_no,
    b.display_name,
    b.group_booking_id,
    row_number() over (
      partition by b.vob_guid, b.court_no, b.booking_date
      order by b.id asc
    ) as rn,
    count(*) over (
      partition by b.vob_guid, b.court_no, b.booking_date
    ) as group_size
  from public.bookings b
  where b.vob_guid is not null
    and coalesce(b.group_booking_id, 0) = 0
),
dupes as (
  select *
  from ranked
  where group_size > 1
)
select
  d.vob_guid,
  d.court_no,
  d.id,
  d.booking_date,
  d.display_name,
  d.group_booking_id,
  d.rn,
  d.group_size,
  case when d.rn = 1 then 'KEEP' else 'DELETE' end as action
from dupes d
order by d.vob_guid, d.court_no, d.booking_date, d.rn;

-- Optional quick summary:
-- with ranked as (
--   select
--     b.vob_guid,
--     b.court_no,
--     b.booking_date,
--     row_number() over (
--       partition by b.vob_guid, b.court_no, b.booking_date
--       order by b.id asc
--     ) as rn,
--     count(*) over (
--       partition by b.vob_guid, b.court_no, b.booking_date
--     ) as group_size
--   from public.bookings b
--   where b.vob_guid is not null
--     and coalesce(b.group_booking_id, 0) = 0
-- )
-- select
--   count(*) filter (where group_size > 1 and rn > 1) as rows_to_delete,
--   count(distinct (vob_guid, court_no, booking_date)) filter (where group_size > 1) as duplicate_groups
-- from ranked;

-- ---------------------------------------------------------------------------
-- APPLY: uncomment and run ONLY after preview looks correct.
-- ---------------------------------------------------------------------------
/*
begin;

with ranked as (
  select
    b.id,
    row_number() over (
      partition by b.vob_guid, b.court_no, b.booking_date
      order by b.id asc
    ) as rn,
    count(*) over (
      partition by b.vob_guid, b.court_no, b.booking_date
    ) as group_size
  from public.bookings b
  where b.vob_guid is not null
    and coalesce(b.group_booking_id, 0) = 0
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
  b.vob_guid,
  b.booking_date,
  b.court_no,
  b.display_name,
  b.group_booking_id;

commit;
*/
