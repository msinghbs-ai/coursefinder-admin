-- APPLIED 7 Nov 2026 under Platform Admin directive 16:43 D2 (Admin #382 comment 6702979821). Exactly two intakes; application_deadline only.
do $apply$
declare
  v_actor uuid := '63ba56cb-48d4-4169-98c2-7c4d1f72925b'; v_decision text := 'Admin #382 comment 6702979821 (Platform Admin 7 Nov 2026 16:43 D2)';
  v_operation constant text := 'P0-DEADLINE-382-20261107-TWO';
  v_count int; v_rows int; v_before jsonb; r record; v_payload jsonb; v_path text;
begin
  if md5(pg_get_functiondef('security.course_deadline_in_quote_v1(date,text)'::regprocedure)) <> '2357306ca969fb7b299021bac3b6f3fa' then raise exception 'semantic guard is not the reviewed version'; end if;
  perform 1 from catalogue.course_intakes where id in ('05f8c255-1920-4aaf-9112-598a715b8311','39d6cb1c-c0cf-48ad-9b41-53dad2e39a00') order by id for update;
  if exists (select 1 from pipeline.admin_control_events where area = 'intake_dates' and action = 'deadline_semantic_withdraw' and target = v_operation) then raise exception 'operation already recorded: reconcile, do not replay'; end if;
  if exists (select 1 from pipeline.manual_locks where entity = 'course' and entity_id in ('2c8a32ae-1fce-4ede-bc93-f592048649a2','2caef4bd-459a-4685-87b8-b05c367dcc34') and field in ('all','deadline','intake','intakes')) then raise exception 'affected human lock exists'; end if;
  with expected(course_id,intake_id,item_id,wrong_date,quote,item_evidence,intake_evidence) as (values
    ('2c8a32ae-1fce-4ede-bc93-f592048649a2'::uuid,'05f8c255-1920-4aaf-9112-598a715b8311'::uuid,273427::bigint,'2027-03-01'::date,'Next Start Date 01 March 2027','45136cfd-9c5e-4f98-9a8b-53c9b01c849e'::uuid,'80659bd7-af0c-4757-ba8b-0f26598c1c6e'::uuid),
    ('2caef4bd-459a-4685-87b8-b05c367dcc34','39d6cb1c-c0cf-48ad-9b41-53dad2e39a00',273432,'2024-07-09','Advanced Diploma of Civil Construction Design July 9, 2024','0bc3987d-983a-47c6-8504-4a8639877659','0bc3987d-983a-47c6-8504-4a8639877659'))
  select count(*), jsonb_agg(jsonb_build_object('intake',to_jsonb(i),'item_id',f.id,'item_evidence',f.evidence_id,'quote',x.quote) order by i.id)
    into v_count, v_before from expected x join catalogue.course_intakes i on i.id=x.intake_id and i.course_id=x.course_id
    join pipeline.field_enrich_items f on f.id=x.item_id and f.course_id=x.course_id and f.field='deadline' and f.state='filled' and f.evidence_id=x.item_evidence
   where i.status='active' and i.application_deadline=x.wrong_date and i.evidence_id=x.intake_evidence
     and exists (select 1 from jsonb_array_elements(f.value->'deadlines') d where d->>'date'=x.wrong_date::text and d->>'quote'=x.quote and d->>'outcome'='kept' and d->'intake_ids' @> jsonb_build_array(x.intake_id::text))
     and not security.course_deadline_in_quote_v1(x.wrong_date,x.quote);
  if v_count <> 2 then raise exception 'only % of 2 exact guards match; nothing changed', v_count; end if;
  insert into pipeline.admin_control_events(area,action,target,detail,actor)
  values ('intake_dates','deadline_semantic_withdraw',v_operation,jsonb_build_object('governance','Admin #382','decision',v_decision,'reason','A commencement date and a dated page heading were stored as application-closing dates','before',v_before,'fields_changed',jsonb_build_array('application_deadline'),'count',2),v_actor);
  update catalogue.course_intakes set application_deadline = null where id in ('05f8c255-1920-4aaf-9112-598a715b8311','39d6cb1c-c0cf-48ad-9b41-53dad2e39a00') and application_deadline is not null;
  get diagnostics v_rows = row_count;
  if v_rows <> 2 then raise exception 'updated %, expected 2', v_rows; end if;
  perform search.refresh_course_enrichment_scoped_v1(array['2c8a32ae-1fce-4ede-bc93-f592048649a2'::uuid,'2caef4bd-459a-4685-87b8-b05c367dcc34'::uuid], true);
  for r in select * from (values ('2c8a32ae-1fce-4ede-bc93-f592048649a2'::uuid,'089201M','March'),('2caef4bd-459a-4685-87b8-b05c367dcc34','116248A','July')) x(course_id,code,label) loop
    foreach v_path in array array['website','zoho_v1','zoho_v2'] loop
      v_payload := case v_path when 'website' then api.website_v2_course_item(r.course_id) when 'zoho_v1' then public.zoho_edge_course_lookup_v1(r.code)->'item' else public.zoho_v2_course(r.code)->'item' end;
      -- unpublished courses are not served to consumers (payload null): accepted only when the course is unpublished
      if v_payload is null then
        if (select publication_status from catalogue.courses where id = r.course_id) <> 'unpublished' then raise exception '% projection missing for a published course', v_path; end if;
      elsif (select count(*) from jsonb_array_elements(coalesce(v_payload->'intakes','[]'::jsonb)) i where i->>'label'=r.label and i->>'application_deadline' is not null) <> 0 then
        raise exception '% projection still shows a deadline for %', v_path, r.code;
      end if;
    end loop;
  end loop;
end $apply$;
