-- M1-PIM-GOV Course state/Search projection semantics v1
-- Applied to coursefinder_Pilot as m1_pim_gov_course_state_semantics_v1.
-- Fix the live courses_page Search-state wrapper: search.course_documents
-- has publication_status, not status. Keep Search projection state explicitly
-- named and separate from canonical lifecycle/publication/Admin readiness.

create or replace function security.admin_course_page_search_state(p_page jsonb)
returns jsonb
language plpgsql
stable
security definer
set search_path = pg_catalog, public, security, search, auth
as $$
declare
  v_rank integer:=0;
  v_items jsonb;
begin
  if auth.uid() is null then raise exception 'authentication required' using errcode='42501'; end if;
  select security.current_role_rank() into v_rank;
  if v_rank<1 then raise exception 'assigned CourseFinder role required' using errcode='42501'; end if;

  select coalesce(jsonb_agg(
    i.item || jsonb_build_object(
      'search_projected', d.course_id is not null,
      'search_projection_status', d.publication_status,
      'search_projection_completeness', d.completeness_score,
      'search_projection_version', d.projection_version,
      'search_catalogue_generation', d.catalogue_generation,
      'search_projection_updated_at', d.updated_at,
      'search_projection_generated_at', d.generated_at,
      'search_has_fee', d.has_fee,
      'search_has_intake', d.has_intake,
      'search_has_english', d.has_english,
      'search_has_scholarship', d.has_scholarship
    ) order by i.ord
  ),'[]'::jsonb)
  into v_items
  from jsonb_array_elements(coalesce(p_page->'items','[]'::jsonb)) with ordinality as i(item,ord)
  left join search.course_documents d on d.course_id=nullif(i.item->>'id','')::uuid;

  return jsonb_set(coalesce(p_page,'{}'::jsonb),'{items}',v_items,true);
end
$$;
