-- APPLIED 7 Nov 2026 under Platform Admin directive 17:48 priority 2 (evidence-based; Admin #382 decision chain). Exactly three intakes; application_deadline only.
-- Evidence: item 274447 quotes only "Canadian Applicants Application Deadline <date>" for these PhD intakes; no international-applicant deadline is stated. Null = not held.
do $apply$
declare
  v_actor uuid := '63ba56cb-48d4-4169-98c2-7c4d1f72925b';
  v_operation constant text := 'P0-DEADLINE-382-20261107-UBC-CANADIAN-ONLY';
  v_course constant uuid := '387d4fa8-3fd0-5bd9-950b-c15ef36b5436';
  v_count int; v_rows int; v_before jsonb;
begin
  perform 1 from catalogue.course_intakes where id in ('3893acd1-4110-4d7a-b9e7-41d9cadb12cc','8618d40a-09f0-413e-acb5-07598da33c8d','9300ebf1-7427-423c-bc6c-7884760618e7') order by id for update;
  if exists (select 1 from pipeline.admin_control_events where area='intake_dates' and action='deadline_semantic_withdraw' and target=v_operation) then raise exception 'operation already recorded'; end if;
  if exists (select 1 from pipeline.manual_locks where entity='course' and entity_id=v_course and field in ('all','deadline','intake','intakes')) then raise exception 'human lock exists'; end if;
  with expected(intake_id,wrong_date,quote) as (values
    ('3893acd1-4110-4d7a-b9e7-41d9cadb12cc'::uuid,'2027-02-01'::date,'Canadian Applicants Application Deadline 1 February 2027'),
    ('9300ebf1-7427-423c-bc6c-7884760618e7','2027-08-01','Canadian Applicants Application Deadline 1 August 2027'),
    ('8618d40a-09f0-413e-acb5-07598da33c8d','2027-10-01','Canadian Applicants Application Deadline 1 October 2027'))
  select count(*), jsonb_agg(jsonb_build_object('intake',to_jsonb(i),'item_id',f.id,'quote',x.quote) order by i.id)
    into v_count, v_before
    from expected x join catalogue.course_intakes i on i.id=x.intake_id and i.course_id=v_course
    join pipeline.field_enrich_items f on f.id=274447 and f.course_id=v_course and f.field='deadline' and f.state='filled'
   where i.status='active' and i.application_deadline=x.wrong_date
     and exists (select 1 from jsonb_array_elements(f.value->'deadlines') d where d->>'date'=x.wrong_date::text and d->>'quote'=x.quote and d->>'outcome'='kept' and d->'intake_ids' @> jsonb_build_array(x.intake_id::text))
     and not exists (select 1 from jsonb_array_elements(f.value->'deadlines') d where d->>'quote' ilike 'international%');
  if v_count <> 3 then raise exception 'only % of 3 exact guards match; nothing changed', v_count; end if;
  insert into pipeline.admin_control_events(area,action,target,detail,actor)
  values ('intake_dates','deadline_semantic_withdraw',v_operation,jsonb_build_object('governance','Admin #382','decision','Platform Admin 7 Nov 2026 17:48 priority 2','reason','Deadline labelled for Canadian applicants only; no international deadline held. Withdrawn to null (not held).','before',v_before,'fields_changed',jsonb_build_array('application_deadline'),'count',3),v_actor);
  update catalogue.course_intakes set application_deadline=null where id in ('3893acd1-4110-4d7a-b9e7-41d9cadb12cc','8618d40a-09f0-413e-acb5-07598da33c8d','9300ebf1-7427-423c-bc6c-7884760618e7') and application_deadline is not null;
  get diagnostics v_rows = row_count;
  if v_rows <> 3 then raise exception 'updated %, expected 3', v_rows; end if;
  perform search.refresh_course_enrichment_scoped_v1(array[v_course], true);
end $apply$;
