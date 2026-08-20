-- M1-PIM-GOV Attribute / Option / Completeness governance v2
-- Corrected production mirror for the Pilot contract originally applied as
-- m1_pim_gov_attribute_governance_v1. The earlier draft referenced obsolete
-- pim.attributes / completeness_profile_rules names. This version targets the
-- accepted current schema and does not rewrite PIM configuration rows.

create or replace function security.admin_pim_governance_read(p_args jsonb default '{}'::jsonb)
returns jsonb
language plpgsql
stable
security definer
set search_path = pg_catalog, security, pim, auth
as $$
declare
  v_rank integer:=0;
  v_limit integer:=least(greatest(coalesce(nullif(p_args->>'limit','')::integer,200),1),500);
  v_result jsonb;
begin
  if auth.uid() is null then raise exception 'authentication required' using errcode='42501'; end if;
  select security.current_role_rank() into v_rank;
  if v_rank<5 then raise exception 'pim_admin role required' using errcode='42501'; end if;

  select jsonb_build_object(
    'families',coalesce((select jsonb_agg(to_jsonb(x) order by x.code) from (select * from pim.attribute_families order by code limit v_limit) x),'[]'::jsonb),
    'groups',coalesce((select jsonb_agg(to_jsonb(x) order by x.display_order nulls last,x.code) from (select * from pim.attribute_groups order by display_order nulls last,code limit v_limit) x),'[]'::jsonb),
    'attributes',coalesce((select jsonb_agg(to_jsonb(x) order by x.display_order nulls last,x.code) from (select * from pim.attribute_definitions order by display_order nulls last,code limit v_limit) x),'[]'::jsonb),
    'options',coalesce((select jsonb_agg(to_jsonb(x) order by x.attribute_id,x.display_order nulls last,x.code) from (select * from pim.attribute_options order by attribute_id,display_order nulls last,code limit v_limit) x),'[]'::jsonb),
    'completeness_profiles',coalesce((select jsonb_agg(to_jsonb(x) order by x.code) from (select * from pim.completeness_profiles order by code limit v_limit) x),'[]'::jsonb),
    'completeness_profile_rules',coalesce((select jsonb_agg(to_jsonb(x) order by x.profile_id,x.requirement_code,x.attribute_code) from (
      select cr.id,cr.profile_id,cr.attribute_id,cr.requirement_code,cr.weight,cr.is_mandatory,cr.rule,cr.created_at,
             ad.code attribute_code,ad.name attribute_name
      from pim.completeness_requirements cr
      left join pim.attribute_definitions ad on ad.id=cr.attribute_id
      order by cr.profile_id,cr.requirement_code,ad.code
      limit v_limit
    ) x),'[]'::jsonb),
    'family_groups',coalesce((select jsonb_agg(to_jsonb(x) order by x.family_id,x.display_order nulls last) from (select * from pim.family_groups order by family_id,display_order nulls last limit v_limit) x),'[]'::jsonb),
    'family_attributes',coalesce((select jsonb_agg(to_jsonb(x) order by x.family_id,x.display_order nulls last) from (select * from pim.family_attributes order by family_id,display_order nulls last limit v_limit) x),'[]'::jsonb),
    'counts',jsonb_build_object(
      'families',(select count(*) from pim.attribute_families),
      'groups',(select count(*) from pim.attribute_groups),
      'attributes',(select count(*) from pim.attribute_definitions),
      'options',(select count(*) from pim.attribute_options),
      'completeness_profiles',(select count(*) from pim.completeness_profiles),
      'completeness_profile_rules',(select count(*) from pim.completeness_requirements)
    ),
    'limit',v_limit
  ) into v_result;
  return v_result;
end
$$;

revoke execute on function security.admin_pim_governance_read(jsonb) from public, anon;
grant execute on function security.admin_pim_governance_read(jsonb) to authenticated, service_role;

-- The browser PIM boundary is public.admin_read -> private rank-checked helper.
-- Keep legacy UI compatibility helpers service-role only.
do $$
declare r regprocedure;
begin
  foreach r in array array[
    'public.ui_attribute_families_list()'::regprocedure,
    'public.ui_attribute_groups_list()'::regprocedure,
    'public.ui_attributes_list()'::regprocedure,
    'public.ui_attribute_options_list(integer)'::regprocedure,
    'public.ui_completeness_profiles_list()'::regprocedure
  ] loop
    execute format('revoke execute on function %s from public, anon, authenticated',r);
    execute format('grant execute on function %s to service_role',r);
  end loop;
end $$;
