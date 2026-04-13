-- Normalized ladder team breakdown + member ladder membership view.
--
-- Goal:
-- - move breakdown rules out of settings JSON into first-class rows
-- - expose member -> ladder/team/rank mapping via SQL view for profile screens
--
-- This is safe to run multiple times.

create table if not exists public.ladder_team_breakdown_rules (
  id uuid primary key default gen_random_uuid(),
  ladder_type text not null check (ladder_type in ('men', 'ladies', 'masters')),
  sort_index integer not null check (sort_index > 0),
  team_number integer not null check (team_number > 0),
  team_member_count integer not null check (team_member_count > 0),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (ladder_type, sort_index)
);

create index if not exists idx_ladder_team_breakdown_rules_type_sort
  on public.ladder_team_breakdown_rules (ladder_type, sort_index);

alter table public.ladder_team_breakdown_rules enable row level security;

drop policy if exists "ladder_team_breakdown_rules_select_anon_authenticated"
  on public.ladder_team_breakdown_rules;

create policy "ladder_team_breakdown_rules_select_anon_authenticated"
  on public.ladder_team_breakdown_rules
  for select
  to anon, authenticated
  using (true);

-- Optional one-time backfill from legacy settings JSON (no-op if already populated).
with current_count as (
  select count(*)::int as n from public.ladder_team_breakdown_rules
),
src as (
  select
    s.value::jsonb as payload
  from public.settings s
  where
    s.name in ('CurrentLeagueTeamBreakdown', 'LadderBreakdown2026')
    and s.value is not null
  order by
    case when s.name = 'CurrentLeagueTeamBreakdown' then 0 else 1 end
  limit 1
),
expanded as (
  select
    'men'::text as ladder_type,
    e.ordinality::int as sort_index,
    nullif(e.item ->> 'TeamNumber', '')::int as team_number,
    nullif(e.item ->> 'TeamMemberCount', '')::int as team_member_count
  from src s
  cross join lateral jsonb_array_elements(coalesce(s.payload -> 'LeagueTeams', '[]'::jsonb)) with ordinality as e(item, ordinality)
  union all
  select
    'ladies'::text as ladder_type,
    e.ordinality::int as sort_index,
    nullif(e.item ->> 'TeamNumber', '')::int as team_number,
    nullif(e.item ->> 'TeamMemberCount', '')::int as team_member_count
  from src s
  cross join lateral jsonb_array_elements(coalesce(s.payload -> 'LeagueLadiesTeams', '[]'::jsonb)) with ordinality as e(item, ordinality)
  union all
  select
    'masters'::text as ladder_type,
    e.ordinality::int as sort_index,
    nullif(e.item ->> 'TeamNumber', '')::int as team_number,
    nullif(e.item ->> 'TeamMemberCount', '')::int as team_member_count
  from src s
  cross join lateral jsonb_array_elements(coalesce(s.payload -> 'LeagueMastersTeams', '[]'::jsonb)) with ordinality as e(item, ordinality)
)
insert into public.ladder_team_breakdown_rules (
  ladder_type,
  sort_index,
  team_number,
  team_member_count
)
select
  e.ladder_type,
  e.sort_index,
  e.team_number,
  e.team_member_count
from expanded e
cross join current_count c
where
  c.n = 0
  and e.team_number is not null
  and e.team_member_count is not null
  and e.team_number > 0
  and e.team_member_count > 0
on conflict (ladder_type, sort_index) do nothing;

create or replace view public.v_member_ladder_membership as
with ladder_entries as (
  select 'men'::text as ladder_type, lm.vob_guid, lm.sort_order
  from public.ladder_mens lm
  union all
  select 'ladies'::text as ladder_type, ll.vob_guid, ll.sort_order
  from public.ladder_ladies ll
  union all
  select 'masters'::text as ladder_type, lma.vob_guid, lma.sort_order
  from public.ladder_masters lma
),
ranked_entries as (
  select
    e.ladder_type,
    e.vob_guid,
    e.sort_order as ladder_rank
  from ladder_entries e
  where e.vob_guid is not null and e.sort_order is not null
),
rules_with_ranges as (
  select
    r.ladder_type,
    r.sort_index,
    r.team_number,
    r.team_member_count,
    sum(r.team_member_count) over (
      partition by r.ladder_type
      order by r.sort_index
      rows between unbounded preceding and current row
    ) as end_rank
  from public.ladder_team_breakdown_rules r
),
rules_resolved as (
  select
    ladder_type,
    sort_index,
    team_number,
    team_member_count,
    (end_rank - team_member_count + 1) as start_rank,
    end_rank
  from rules_with_ranges
),
assigned as (
  select
    e.vob_guid,
    e.ladder_type,
    e.ladder_rank,
    rr.team_number
  from ranked_entries e
  left join rules_resolved rr
    on rr.ladder_type = e.ladder_type
   and e.ladder_rank between rr.start_rank and rr.end_rank
)
select
  a.vob_guid,
  a.ladder_type,
  a.ladder_rank,
  a.team_number as league_team_number,
  case
    when a.team_number is null then null
    else row_number() over (
      partition by a.ladder_type, a.team_number
      order by a.ladder_rank
    )
  end as rank_within_team
from assigned a;

-- UI-friendly projection: ladder membership + profile + extension in one query.
-- Join strategy: profile by vob_guid; extension by FK id, else by vob_guid (legacy).
create or replace view public.v_member_ladder_membership_with_profile as
select
  m.vob_guid,
  m.ladder_type,
  m.ladder_rank,
  m.league_team_number,
  m.rank_within_team,
  p.id as profile_id,
  p.first_name as profile_first_name,
  p.last_name as profile_last_name,
  p.email as profile_email,
  p.contact_number as profile_contact_number,
  p.date_of_birth as profile_date_of_birth,
  p.is_active as profile_is_active,
  pe.id as profile_extension_id,
  pe.membership_type as membership_type,
  pe.emergency_contact_number as emergency_contact_number,
  pe.can_show_email as can_show_email,
  pe.can_show_contact as can_show_contact,
  pe.can_show_birthday as can_show_birthday,
  pe.is_coach as is_coach
from public.v_member_ladder_membership m
left join public.profiles p
  on p.vob_guid = m.vob_guid
left join lateral (
  select pe.*
  from public.profile_extensions pe
  where
    (p.profile_extension_id is not null and pe.id = p.profile_extension_id)
    or (p.profile_extension_id is null and pe.vob_guid = p.vob_guid)
  limit 1
) pe on true;

