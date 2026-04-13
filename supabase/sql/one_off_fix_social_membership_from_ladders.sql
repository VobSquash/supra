-- One-off: fix profile_extensions.membership_type when it is still a social* value
-- but the member appears on a league ladder.
--
-- App identifiers match MembershipTypeEnum in packages/client_models (e.g. leagueMen, social).
--
-- IMPORTANT: ladder_* tables reference public.profiles(vob_guid). Ladder presence must be
-- checked using profiles.vob_guid. The profile ↔ extension link matches
-- ladder_team_breakdown.sql (v_member_ladder_membership_with_profile):
--   (p.profile_extension_id is not null and pe.id = p.profile_extension_id)
--   or (p.profile_extension_id is null and pe.vob_guid = p.vob_guid)
--
-- Priority when multiple ladders apply (same profile): men's > ladies > masters.
-- Masters ladder maps to mastersOnly; if your club uses leagueAndMasters for those
-- rows instead, adjust the CASE below before running.
--
-- Safe to re-run: only updates rows where membership_type is social / socialStudent / socialScholar
-- (case-insensitive) and a ladder match exists for the linked profile.
--
-- Workflow:
--   1. Run the PREVIEW only; sanity-check rows.
--   2. Uncomment DIAGNOSTIC to inspect the four names (extension vs profile vob_guid, ladder flags).
--   3. Uncomment the APPLY block; run BEGIN; UPDATE ... COMMIT; (or ROLLBACK;).

-- ---------------------------------------------------------------------------
-- PREVIEW: who would change and to what
-- ---------------------------------------------------------------------------
with ext_profile as (
  select distinct on (pe.id)
    pe.id as extension_id,
    pe.vob_guid as extension_vob_guid,
    pe.membership_type as current_membership,
    p.id as profile_id,
    p.vob_guid as profile_vob_guid,
    p.first_name,
    p.last_name
  from public.profile_extensions pe
  inner join public.profiles p
    on (
      (p.profile_extension_id is not null and pe.id = p.profile_extension_id)
      or (
        p.profile_extension_id is null
        and pe.vob_guid is not null
        and p.vob_guid = pe.vob_guid::uuid
      )
    )
  order by pe.id, p.id
),
target as (
  select
    ep.extension_id,
    ep.extension_vob_guid,
    ep.profile_vob_guid,
    ep.first_name,
    ep.last_name,
    ep.current_membership,
    case
      when exists (
        select 1
        from public.ladder_mens lm
        where lm.vob_guid is not null
          and lm.vob_guid = ep.profile_vob_guid
      ) then 'leagueMen'::text
      when exists (
        select 1
        from public.ladder_ladies ll
        where ll.vob_guid is not null
          and ll.vob_guid = ep.profile_vob_guid
      ) then 'ladiesLeague'::text
      when exists (
        select 1
        from public.ladder_masters lma
        where lma.vob_guid is not null
          and lma.vob_guid = ep.profile_vob_guid
      ) then 'mastersOnly'::text
    end as new_membership
  from ext_profile ep
  where
    ep.profile_vob_guid is not null
    and lower(trim(coalesce(ep.current_membership, ''))) in ('social', 'socialstudent', 'socialscholar')
)
select
  t.extension_id as id,
  t.extension_vob_guid,
  t.profile_vob_guid,
  t.first_name,
  t.last_name,
  t.current_membership,
  t.new_membership
from target t
where t.new_membership is not null
order by t.last_name nulls last, t.first_name nulls last, t.profile_vob_guid;

-- ---------------------------------------------------------------------------
-- DIAGNOSTIC: four members who were missing before (join + ladder + membership)
-- Uncomment the block below and run it alone.
-- ---------------------------------------------------------------------------
/*
with ext_profile as (
  select distinct on (pe.id)
    pe.id as extension_id,
    pe.vob_guid as extension_vob_guid,
    pe.membership_type,
    p.vob_guid as profile_vob_guid,
    p.first_name,
    p.last_name
  from public.profile_extensions pe
  inner join public.profiles p
    on (
      (p.profile_extension_id is not null and pe.id = p.profile_extension_id)
      or (
        p.profile_extension_id is null
        and pe.vob_guid is not null
        and p.vob_guid = pe.vob_guid::uuid
      )
    )
  order by pe.id, p.id
)
select
  ep.extension_id,
  ep.extension_vob_guid,
  ep.profile_vob_guid,
  ep.first_name,
  ep.last_name,
  ep.membership_type,
  lower(trim(coalesce(ep.membership_type, ''))) as membership_normalized,
  exists (select 1 from public.ladder_mens lm where lm.vob_guid = ep.profile_vob_guid) as on_mens,
  exists (select 1 from public.ladder_ladies ll where ll.vob_guid = ep.profile_vob_guid) as on_ladies,
  exists (select 1 from public.ladder_masters lma where lma.vob_guid = ep.profile_vob_guid) as on_masters
from ext_profile ep
where
  (ep.first_name ilike '%aidan%' and ep.last_name ilike '%lang%')
  or (ep.first_name ilike '%barry%' and ep.last_name ilike '%lodewyks%')
  or (ep.first_name ilike '%genevieve%' and ep.last_name ilike '%king%')
  or (ep.first_name ilike '%justin%' and ep.last_name ilike '%fletcher%');
*/

-- ---------------------------------------------------------------------------
-- APPLY — uncomment this block after the preview looks correct
-- (Supabase SQL editor: run inside a transaction: begin; … commit;)
-- ---------------------------------------------------------------------------
/*
begin;

update public.profile_extensions pe
set membership_type = v.new_membership
from (
  with ext_profile as (
    select distinct on (pe2.id)
      pe2.id as extension_id,
      pe2.membership_type,
      p.vob_guid as profile_vob_guid
    from public.profile_extensions pe2
    inner join public.profiles p
      on (
        (p.profile_extension_id is not null and pe2.id = p.profile_extension_id)
        or (
          p.profile_extension_id is null
          and pe2.vob_guid is not null
          and p.vob_guid = pe2.vob_guid::uuid
        )
      )
    order by pe2.id, p.id
  )
  select
    ep.extension_id as id,
    case
      when exists (
        select 1
        from public.ladder_mens lm
        where lm.vob_guid is not null
          and lm.vob_guid = ep.profile_vob_guid
      ) then 'leagueMen'::text
      when exists (
        select 1
        from public.ladder_ladies ll
        where ll.vob_guid is not null
          and ll.vob_guid = ep.profile_vob_guid
      ) then 'ladiesLeague'::text
      when exists (
        select 1
        from public.ladder_masters lma
        where lma.vob_guid is not null
          and lma.vob_guid = ep.profile_vob_guid
      ) then 'mastersOnly'::text
    end as new_membership
  from ext_profile ep
  where
    ep.profile_vob_guid is not null
    and lower(trim(coalesce(ep.membership_type, ''))) in ('social', 'socialstudent', 'socialscholar')
) v
where pe.id = v.id
  and v.new_membership is not null
returning
  pe.id,
  pe.vob_guid,
  (select pr.first_name from public.profiles pr where (pr.profile_extension_id is not null and pr.profile_extension_id = pe.id) or (pr.profile_extension_id is null and pe.vob_guid is not null and pr.vob_guid = pe.vob_guid::uuid) limit 1) as first_name,
  (select pr.last_name from public.profiles pr where (pr.profile_extension_id is not null and pr.profile_extension_id = pe.id) or (pr.profile_extension_id is null and pe.vob_guid is not null and pr.vob_guid = pe.vob_guid::uuid) limit 1) as last_name,
  pe.membership_type;

commit;
*/

-- ---------------------------------------------------------------------------
-- Optional: men’s ladder only (skip ladies/masters logic above)
-- ---------------------------------------------------------------------------
-- update public.profile_extensions pe
-- set membership_type = 'leagueMen'
-- from public.profiles p
-- where
--   (
--     (p.profile_extension_id is not null and pe.id = p.profile_extension_id)
--     or (p.profile_extension_id is null and pe.vob_guid is not null and p.vob_guid = pe.vob_guid::uuid)
--   )
--   and p.vob_guid is not null
--   and lower(trim(coalesce(pe.membership_type, ''))) in ('social', 'socialstudent', 'socialscholar')
--   and exists (
--     select 1
--     from public.ladder_mens lm
--     where lm.vob_guid is not null
--       and lm.vob_guid = p.vob_guid
--   );
