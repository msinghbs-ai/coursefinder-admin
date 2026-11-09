-- APPLIED 7 Nov 2026 under Platform Admin 17:48 priority 2 and 18:12 item 5 (governed batches, no blanket withdrawal). Batch 1 of the 799 guard-failing deadlines.
-- Batch rule: every supporting quote for the intake date fails security.course_deadline_in_quote_v1 (md5 2357306c), at least one quote carries explicit
-- start/intake/semester/term wording, and none carries closing wording (close/deadline/due/apply by/last date/cut-off). application_deadline only. No human lock.
-- Held for later batches: 10 with closing wording (guard format gaps), 379 bare campus/date quotes.
do $apply$
declare
  v_actor uuid := '63ba56cb-48d4-4169-98c2-7c4d1f72925b'; v_operation constant text := 'P0-DEADLINE-382-20261107-START-BATCH-1';
  v_expect constant int := 410; v_ids uuid[]; v_courses uuid[]; v_before jsonb; v_rows int;
begin
  if md5(pg_get_functiondef('security.course_deadline_in_quote_v1(date,text)'::regprocedure)) <> '2357306ca969fb7b299021bac3b6f3fa' then raise exception 'guard not the reviewed version'; end if;
  if exists (select 1 from pipeline.admin_control_events where area='intake_dates' and action='deadline_semantic_withdraw' and target=v_operation) then raise exception 'operation already recorded'; end if;
  create temp table b1 on commit drop as
  select ci.id intake_id, ci.course_id, ci.application_deadline dl, f.id item_id, array_agg(distinct d->>'quote') quotes
    from catalogue.course_intakes ci
    join pipeline.field_enrich_items f on f.course_id=ci.course_id and f.field='deadline' and f.state='filled'
    cross join lateral jsonb_array_elements(f.value->'deadlines') d
   where ci.status='active' and ci.application_deadline is not null and d->>'outcome'='kept' and d->'intake_ids' @> jsonb_build_array(ci.id::text) and d->>'date'=ci.application_deadline::text
   group by 1,2,3,4
  having not bool_or(security.course_deadline_in_quote_v1(ci.application_deadline, d->>'quote'))
     and bool_or((d->>'quote') ~* '\m(start|starts|starting|commenc\w*|begins?|semester|trimester|term|intake|session|study period|orientation|teaching)\M')
     and not bool_or((d->>'quote') ~* '\m(clos\w*|deadline|due|apply by|last date|cut-?off)\M');
  delete from b1 where exists (select 1 from pipeline.manual_locks m where m.entity='course' and m.entity_id=b1.course_id and m.field in ('all','deadline','intake','intakes'));
  select array_agg(intake_id), array_agg(distinct course_id), jsonb_agg(jsonb_build_object('intake_id',intake_id,'course_id',course_id,'deadline',dl,'item_id',item_id,'quotes',quotes) order by intake_id) into v_ids, v_courses, v_before from b1;
  if coalesce(array_length(v_ids,1),0) <> v_expect then raise exception 'batch has % rows, expected %; nothing changed', coalesce(array_length(v_ids,1),0), v_expect; end if;
  insert into pipeline.admin_control_events(area,action,target,detail,actor)
  values ('intake_dates','deadline_semantic_withdraw',v_operation,jsonb_build_object('governance','Admin #382','decision','Platform Admin 7 Nov 2026 18:12 item 5 (governed batches)','reason','Stored as application-closing dates but every supporting quote is a start, intake or semester date with no closing wording; withdrawn to null (not held)','before',v_before,'fields_changed',jsonb_build_array('application_deadline'),'count',v_expect),v_actor);
  update catalogue.course_intakes set application_deadline=null where id = any(v_ids) and application_deadline is not null;
  get diagnostics v_rows = row_count;
  if v_rows <> v_expect then raise exception 'updated %, expected %', v_rows, v_expect; end if;
end $apply$;

-- BATCH 2 (APPLIED 7 Nov 2026, audit P0-DEADLINE-382-20261107-START-BATCH-2, 370 intakes, 216 courses): same block with operation name START-BATCH-2, expected 370, and the having clause:
--   not bool_or(guard) and not bool_or(start/intake/semester wording) and not bool_or(closing wording)
--   and not bool_or(quote ~* '\m(by|until|before|receipt|accepted|completed|open|opens|enrol\w*|census|discount|payment|fees?|day|last)\M')
-- i.e. bare date listings with no closing cue. Held (19): 10 quotes with closing wording the guard cannot parse (9 look genuine, e.g. "Close: 13 Jan 2027"; 1 ambiguous "Application deadline Start date June 15, 2026") and 9 sentence-form quotes with by/open/enrolment cues.
