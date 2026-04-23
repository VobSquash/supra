-- RPC: replace an entire ladder division for one season in a single transaction.
-- Runs as SECURITY DEFINER (table owner) so ladder-table RLS does not block writes.
-- Still requires public._is_admin_or_elevated_profile() (from profiles_admin_mutations.sql).
--
-- Client: POST /rest/v1/rpc/admin_replace_ladder_division
--   { "p_division": "men"|"ladies"|"masters", "p_year": 2026, "p_rows": [ { "vob_guid", "sort_order", "team?", "can_be_challenged?" }, ... ] }

create or replace function public.admin_replace_ladder_division(
  p_division text,
  p_year int,
  p_rows jsonb
)
returns void
language plpgsql
security definer
set search_path = public
as $fn$
begin
  if not public._is_admin_or_elevated_profile() then
    raise exception
      'not authorized: re-apply profiles_admin_mutations.sql (updated _is_admin_or_elevated_profile). '
      'Your profiles row must be admin/elevated and match this login via profiles.id = auth.uid(), '
      'or email = auth.users.email, or JWT user_metadata.vob_guid = profiles.vob_guid.'
      using errcode = '42501';
  end if;

  if p_division not in ('men', 'ladies', 'masters') then
    raise exception 'invalid division: %', p_division using errcode = '22023';
  end if;

  if jsonb_typeof(p_rows) is distinct from 'array' then
    raise exception 'p_rows must be a JSON array' using errcode = '22023';
  end if;

  if p_division = 'men' then
    delete from public.ladder_mens where year = p_year;
    insert into public.ladder_mens (id, sort_order, year, vob_guid, team, can_be_challenged, legacy_object_id)
    select
      gen_random_uuid(),
      coalesce(nullif(trim(t.elem->>'sort_order'), '')::int, 0),
      p_year,
      nullif(trim(t.elem->>'vob_guid'), '')::uuid,
      case jsonb_typeof(t.elem->'team')
        when 'number' then (t.elem->>'team')::int
        else null
      end,
      coalesce(
        case jsonb_typeof(t.elem->'can_be_challenged')
          when 'boolean' then (t.elem->>'can_be_challenged')::boolean
          else null
        end,
        false
      ),
      gen_random_uuid()::text
    from jsonb_array_elements(p_rows) as t(elem)
    where nullif(trim(t.elem->>'vob_guid'), '') is not null;

  elsif p_division = 'ladies' then
    delete from public.ladder_ladies where year = p_year;
    insert into public.ladder_ladies (id, sort_order, year, vob_guid, team, can_be_challenged, legacy_object_id)
    select
      gen_random_uuid(),
      coalesce(nullif(trim(t.elem->>'sort_order'), '')::int, 0),
      p_year,
      nullif(trim(t.elem->>'vob_guid'), '')::uuid,
      case jsonb_typeof(t.elem->'team')
        when 'number' then (t.elem->>'team')::int
        else null
      end,
      coalesce(
        case jsonb_typeof(t.elem->'can_be_challenged')
          when 'boolean' then (t.elem->>'can_be_challenged')::boolean
          else null
        end,
        false
      ),
      gen_random_uuid()::text
    from jsonb_array_elements(p_rows) as t(elem)
    where nullif(trim(t.elem->>'vob_guid'), '') is not null;

  else
    delete from public.ladder_masters where year = p_year;
    insert into public.ladder_masters (id, sort_order, year, vob_guid, team, can_be_challenged, legacy_object_id)
    select
      gen_random_uuid(),
      coalesce(nullif(trim(t.elem->>'sort_order'), '')::int, 0),
      p_year,
      nullif(trim(t.elem->>'vob_guid'), '')::uuid,
      case jsonb_typeof(t.elem->'team')
        when 'number' then (t.elem->>'team')::int
        else null
      end,
      coalesce(
        case jsonb_typeof(t.elem->'can_be_challenged')
          when 'boolean' then (t.elem->>'can_be_challenged')::boolean
          else null
        end,
        false
      ),
      gen_random_uuid()::text
    from jsonb_array_elements(p_rows) as t(elem)
    where nullif(trim(t.elem->>'vob_guid'), '') is not null;
  end if;
end;
$fn$;

revoke all on function public.admin_replace_ladder_division(text, int, jsonb) from public;
grant execute on function public.admin_replace_ladder_division(text, int, jsonb) to authenticated;
grant execute on function public.admin_replace_ladder_division(text, int, jsonb) to service_role;
