-- Foreign keys: ladder_* / bookings.vob_guid → profiles.vob_guid
-- Enables PostgREST embeds: select=*,profiles(*,profile_extensions(*))
--
-- Your `public.profiles.vob_guid` is **uuid**. Ladder/booking tables in this repo
-- were created as **text** — Postgres requires matching types for FKs.
--
-- This script:
--   1) Ensures a unique target on profiles(vob_guid) (uuid-safe).
--   2) Alters child columns from text → uuid (cast fails if any value is not a valid UUID).
--   3) Adds FK constraints.
--
-- Fix or remove rows with invalid/non-matching vob_guid before running.
--
-- Safe to re-run: drops FKs first; column type change is no-op if already uuid.

-- 0) Drop FKs if re-running
alter table public.ladder_mens drop constraint if exists ladder_mens_vob_guid_fkey;
alter table public.ladder_ladies drop constraint if exists ladder_ladies_vob_guid_fkey;
alter table public.ladder_masters drop constraint if exists ladder_masters_vob_guid_fkey;
alter table public.bookings drop constraint if exists bookings_vob_guid_fkey;

-- 1) Unique target (skip error if your schema already has unique on profiles.vob_guid)
create unique index if not exists profiles_vob_guid_key
  on public.profiles (vob_guid);

-- 2) Child columns: text → uuid (empty/whitespace → NULL)
--    Uses trim; requires each non-null value to cast cleanly to uuid (hyphenated or 32-hex per PG rules).
alter table public.ladder_mens
  alter column vob_guid type uuid using (
    case
      when vob_guid is null then null
      when btrim(vob_guid::text) = '' then null
      else btrim(vob_guid::text)::uuid
    end
  );

alter table public.ladder_ladies
  alter column vob_guid type uuid using (
    case
      when vob_guid is null then null
      when btrim(vob_guid::text) = '' then null
      else btrim(vob_guid::text)::uuid
    end
  );

alter table public.ladder_masters
  alter column vob_guid type uuid using (
    case
      when vob_guid is null then null
      when btrim(vob_guid::text) = '' then null
      else btrim(vob_guid::text)::uuid
    end
  );

alter table public.bookings
  alter column vob_guid type uuid using (
    case
      when vob_guid is null then null
      when btrim(vob_guid::text) = '' then null
      else btrim(vob_guid::text)::uuid
    end
  );

-- 3) Foreign keys
alter table public.ladder_mens
  add constraint ladder_mens_vob_guid_fkey
  foreign key (vob_guid) references public.profiles (vob_guid);

alter table public.ladder_ladies
  add constraint ladder_ladies_vob_guid_fkey
  foreign key (vob_guid) references public.profiles (vob_guid);

alter table public.ladder_masters
  add constraint ladder_masters_vob_guid_fkey
  foreign key (vob_guid) references public.profiles (vob_guid);

alter table public.bookings
  add constraint bookings_vob_guid_fkey
  foreign key (vob_guid) references public.profiles (vob_guid);
