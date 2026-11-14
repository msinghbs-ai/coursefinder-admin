begin;
-- Queue hygiene draft: rolled-back rehearsal against live. Order: #1143 (sections 0 and 2 to 5; its index build and timing post-check are left out so
-- the rehearsal never holds a share lock on the 176 MB extractions table), then DRAFT_cf247_sch_queue_hygiene.sql verbatim, then assertions.
-- Forced rollback: the final DO block always raises REHEARSAL_RESULT.
set local lock_timeout = '3s';
create temp table _rh_pre on commit drop as select
  (select count(*) from pipeline.platform_toolset_settings) settings_total, (select count(*) from cron.job) cron_jobs,
  md5(pg_get_functiondef('public.svc_scholarship_ai_next(integer)'::regprocedure)) next_md5,
  md5(pg_get_functiondef('public.svc_scholarship_read_record(uuid,text,integer,text,text,text,text,jsonb)'::regprocedure)) read_md5,
  md5(pg_get_functiondef('public.svc_scholarship_ai_record(bigint,jsonb,jsonb,text,numeric,integer,integer,numeric,text,text,text,text,jsonb,boolean)'::regprocedure)) ai_md5,
  md5(pg_get_functiondef('security.admin_job_watch_v1(uuid)'::regprocedure)) watch_md5,
  md5(pg_get_functiondef('security.ops_step_value_v1(uuid,text,jsonb)'::regprocedure)) ops_md5;
-- ===== #1143 prerequisite (sections 0, 2, 3-4, 5 verbatim) =====
-- 0. guards: the live definitions this change edits ------------------------------------------------------------------------------------------------------
do $g$
begin
  if md5(pg_get_functiondef('public.svc_scholarship_ai_record(bigint,jsonb,jsonb,text,numeric,integer,integer,numeric,text,text,text,text,jsonb,boolean)'::regprocedure)) <> 'cbcf286f7d5cdd916aee7bb34ca52bc4' then
    raise exception 'live public.svc_scholarship_ai_record differs from the definition this change edits';
  end if;
  if md5(pg_get_functiondef('security.scholarship_sweep_apply_v1(uuid)'::regprocedure)) <> 'ccd52459abe03f92b18de526ae100d82' then
    raise exception 'live security.scholarship_sweep_apply_v1 differs from the definition this change edits';
  end if;
  if md5(pg_get_functiondef('security.scholarship_admission_withdraw_v1(uuid,jsonb)'::regprocedure)) <> 'b95aa4d6bd52881eecc448a593a28167' then
    raise exception 'live security.scholarship_admission_withdraw_v1 differs from the definition this change edits';
  end if;
  perform 'search.refresh_course_enrichment_scoped_v1(uuid[],boolean)'::regprocedure;
end $g$;

-- 2. the course refresh queue ----------------------------------------------------------------------------------------------------------------------------
create table if not exists search.course_refresh_requests (
  id bigserial primary key,
  course_id uuid not null,
  requested_at timestamptz not null default now(),
  requested_by text not null,
  processed_at timestamptz,
  result jsonb
);
comment on table search.course_refresh_requests is 'Courses whose search documents need the scoped enrichment refresh, queued by calls that must stay inside the 8 s statement limit (svc_scholarship_ai_record through scholarship_sweep_apply_v1 and scholarship_admission_withdraw_v1) and refreshed by security.search_course_refresh_drain_v1 (job search-course-refresh). Append-only for callers; the drain stamps processed_at.';
create index if not exists course_refresh_requests_open on search.course_refresh_requests (id) where processed_at is null;
create index if not exists course_refresh_requests_open_course on search.course_refresh_requests (course_id, id) where processed_at is null;
alter table search.course_refresh_requests enable row level security;
revoke all on table search.course_refresh_requests from public, anon, authenticated, service_role;
revoke all on sequence search.course_refresh_requests_id_seq from public, anon, authenticated, service_role;

create or replace function search.course_refresh_request_v1(p_course_ids uuid[], p_requested_by text)
 returns integer
 language plpgsql
 security definer
 set search_path to ''
as $function$
-- R5 (14 Nov 2026): queue courses for the scoped search refresh; an insert only, so the caller never waits on a lock
declare v_n integer;
begin
  if p_course_ids is null or cardinality(p_course_ids) = 0 then return 0; end if;
  insert into search.course_refresh_requests(course_id, requested_by)
  select distinct c.id, coalesce(p_requested_by, 'unknown') from unnest(p_course_ids) c(id) where c.id is not null;
  get diagnostics v_n = row_count;
  return v_n;
end
$function$;
comment on function search.course_refresh_request_v1(uuid[], text) is 'Queues courses for the scoped search refresh (search.course_refresh_requests); refreshed by security.search_course_refresh_drain_v1. Insert only, never waits on a lock.';
revoke all on function search.course_refresh_request_v1(uuid[], text) from public, anon, authenticated;

create or replace function security.search_course_refresh_drain_v1(p_limit integer)
 returns jsonb
 language plpgsql
 security definer
 set search_path to ''
as $function$
-- R5 (14 Nov 2026): refreshes queued courses with the existing scoped refresh, oldest first; never waits for the writer lock
declare v_t0 timestamptz := clock_timestamp(); v_max bigint; v_ids uuid[]; r jsonb; v_rows integer;
begin
  if not pg_try_advisory_xact_lock(hashtext('cf247:search_course_documents_writer')) then  -- fixed: the one writer lock for search.course_documents (W27); never wait for it
    return jsonb_build_object('held', 'another search-document writer is running; the queued courses wait for the next run',
                              'open_courses', (select count(distinct q.course_id) from search.course_refresh_requests q where q.processed_at is null));
  end if;
  select max(q.id) into v_max from search.course_refresh_requests q where q.processed_at is null;
  if v_max is null then return jsonb_build_object('open_courses', 0); end if;
  select array_agg(z.course_id order by z.first_id) into v_ids
    from (select q.course_id, min(q.id) first_id from search.course_refresh_requests q
           where q.processed_at is null and q.id <= v_max group by q.course_id order by min(q.id) limit greatest(coalesce(p_limit, 0), 1)) z;
  r := search.refresh_course_enrichment_scoped_v1(v_ids, true);
  update search.course_refresh_requests q set processed_at = now(), result = jsonb_build_object('rows', r->'rows', 'changed', r->'changed')
   where q.processed_at is null and q.id <= v_max and q.course_id = any(v_ids);
  get diagnostics v_rows = row_count;
  return jsonb_build_object('courses', cardinality(v_ids), 'requests', v_rows, 'changed', r->'changed',
                            'open_courses', (select count(distinct q.course_id) from search.course_refresh_requests q where q.processed_at is null),
                            'ms', (extract(epoch from clock_timestamp() - v_t0) * 1000)::int);
end
$function$;
comment on function security.search_course_refresh_drain_v1(integer) is 'Job search-course-refresh: refreshes up to p_limit queued courses (search.course_refresh_requests, oldest first) with search.refresh_course_enrichment_scoped_v1 when the search-document writer lock is free, and stamps the requests it covered.';
revoke all on function security.search_course_refresh_drain_v1(integer) from public, anon, authenticated;

-- 3 and 4. md5-guarded edits ------------------------------------------------------------------------------------------------------------------------------
create or replace function pg_temp.edit_n(p_sig text, p_md5 text, p_edits text[][], p_times int[]) returns void language plpgsql as $f$
declare v_def text := pg_get_functiondef(p_sig::regprocedure); i int; v_c int;
begin
  if md5(v_def) <> p_md5 then raise exception 'live % differs from the definition this change edits (md5 %)', p_sig, md5(v_def); end if;
  for i in 1 .. array_length(p_edits, 1) loop
    v_c := (length(v_def) - length(replace(v_def, p_edits[i][1], ''))) / length(p_edits[i][1]);
    if v_c <> p_times[i] then raise exception '%: edit % must apply exactly % times (found %)', p_sig, i, p_times[i], v_c; end if;
    v_def := replace(v_def, p_edits[i][1], p_edits[i][2]);
  end loop;
  execute v_def;
end $f$;

select pg_temp.edit_n('security.scholarship_sweep_apply_v1(uuid)', 'ccd52459abe03f92b18de526ae100d82', array[
  array[$o$    perform search.refresh_course_enrichment_scoped_v1(array(select distinct unnest(v_add||v_del)),true);$o$,
        $n$    -- R5 (14 Nov 2026): inside svc_scholarship_ai_record (flag cf247.defer_search_refresh) the courses are queued, not refreshed in the call
    if coalesce(current_setting('cf247.defer_search_refresh', true), '') = 'on' then
      perform search.course_refresh_request_v1(array(select distinct unnest(v_add||v_del)), 'scholarship_sweep_apply_v1');
    else
      perform search.refresh_course_enrichment_scoped_v1(array(select distinct unnest(v_add||v_del)),true);
    end if;$n$]
], array[1]);

select pg_temp.edit_n('security.scholarship_admission_withdraw_v1(uuid,jsonb)', 'b95aa4d6bd52881eecc448a593a28167', array[
  array[$o$  if cardinality(v_courses)>0 then perform search.refresh_course_enrichment_scoped_v1(v_courses,true); end if;$o$,
        $n$  -- R5 (14 Nov 2026): inside svc_scholarship_ai_record (flag cf247.defer_search_refresh) the courses are queued, not refreshed in the call
  if cardinality(v_courses)>0 then
    if coalesce(current_setting('cf247.defer_search_refresh', true), '') = 'on' then
      perform search.course_refresh_request_v1(v_courses, 'scholarship_admission_withdraw_v1');
    else
      perform search.refresh_course_enrichment_scoped_v1(v_courses,true);
    end if;
  end if;$n$]
], array[1]);

select pg_temp.edit_n('public.svc_scholarship_ai_record(bigint,jsonb,jsonb,text,numeric,integer,integer,numeric,text,text,text,text,jsonb,boolean)', 'cbcf286f7d5cdd916aee7bb34ca52bc4', array[
  array[$o$  if current_user <> 'postgres' and coalesce(auth.role(), '') <> 'service_role' then raise exception 'service_role required'; end if;$o$,
        $n$  if current_user <> 'postgres' and coalesce(auth.role(), '') <> 'service_role' then raise exception 'service_role required'; end if;
  -- R5 (14 Nov 2026): search refreshes this answer causes are queued (search.course_refresh_requests) so the paid answer commits inside the 8 s limit
  if security.pipeline_num_v1('search.defer_ai_record_refresh_on', 1) = 1 then perform set_config('cf247.defer_search_refresh', 'on', true); end if;$n$],
  array[$o$    select e.answer->'value' val, e.model_code into v_prev from pipeline.scholarship_ai_extractions e join pipeline.scholarship_ai_queue x on x.id = e.queue_id
     where coalesce(x.root_id, x.id) = coalesce(q.root_id, q.id) and x.id <> q.id and e.verdict = 'scholarship' and e.error is null
       and coalesce((e.checks->>'value')::boolean, false) order by e.id desc limit 1;$o$,
        $n$    -- R5 (14 Nov 2026): the root row and its children by id and root_id (indexed), the same rows as the join on coalesce(root_id, id)
    select e.answer->'value' val, e.model_code into v_prev from pipeline.scholarship_ai_extractions e
     where e.queue_id in (select x.id from pipeline.scholarship_ai_queue x where x.id = coalesce(q.root_id, q.id) and coalesce(x.root_id, x.id) = coalesce(q.root_id, q.id)
                          union all
                          select x.id from pipeline.scholarship_ai_queue x where x.root_id = coalesce(q.root_id, q.id))
       and e.queue_id <> q.id and e.verdict = 'scholarship' and e.error is null
       and coalesce((e.checks->>'value')::boolean, false) order by e.id desc limit 1;$n$]
], array[1, 1]);

-- 5. settings (G2), job (G1), register -------------------------------------------------------------------------------------------------------------------
insert into pipeline.platform_toolset_settings(toolset_key, key, label, help, kind, value, min_value, max_value, unit, sort, section, used_by, reason) values
 ('pipeline', 'search.defer_ai_record_refresh_on', 'Scholarship AI: queue the search refresh an answer causes',
  '1: when a scholarship AI answer changes a scholarship''s course links or withdraws it, the courses are queued for the search refresh (job search-course-refresh, every minute) so the paid answer is saved inside the 8 s limit. 0: refresh in the answer''s own call, as before 14 Nov 2026 (answers can time out and be paid for again).',
  'number', to_jsonb(1), 0, 1, 'on (1) or off (0)', 331, 'Website API', 'public.svc_scholarship_ai_record',
  'R5 (14 Nov 2026): 188 paid answers in 24 hours were cancelled at the 8 s limit, 170 of them in the search refresh'),
 ('pipeline', 'batch.search_course_refresh', 'Queued courses refreshed in search per run',
  'Each minute the search-course-refresh job refreshes at most this many queued courses (about 60 ms a course), when no full search refresh is running.',
  'number', to_jsonb(300), 10, 2000, 'courses', 332, 'Website API', 'security.search_course_refresh_drain_v1 (job search-course-refresh)',
  'R5 (14 Nov 2026)')
on conflict (toolset_key, key) do nothing;

insert into pipeline.automation_catalogue(jobname, area, sort, label, description, control_rank, batch_editable, layer23_stage) values
 ('search-course-refresh', 'Search and API', 11, 'Refresh search for queued courses',
  'Every minute: refreshes up to batch.search_course_refresh courses queued in search.course_refresh_requests (scholarship course links changed or withdrawn by an AI answer) with the scoped search refresh, when no full search refresh is running. No Firecrawl and no AI.',
  5, true, null)
on conflict (jobname) do nothing;
do $j$
begin
  if not exists (select 1 from cron.job where jobname = 'search-course-refresh') then
    perform cron.schedule('search-course-refresh', '* * * * *', 'select security.search_course_refresh_drain_v1(security.pipeline_num_v1(''batch.search_course_refresh'', 300)::int)');
  end if;
end $j$;

insert into pipeline.component_register(kind, name, layer, area, purpose, status, replaces, introduced_in) values
 ('job', 'search-course-refresh', 'Website API', 'Search and API', 'R5: refreshes courses queued by calls that must stay inside the 8 s limit (scholarship AI answers) with the scoped search refresh', 'active', '{}', '20261114181500'),
 ('table', 'search.course_refresh_requests', 'Website API', 'Search and API', 'Courses queued for the scoped search refresh, with who queued them and when the drain covered them', 'active', '{}', '20261114181500')
on conflict do nothing;


-- ===== DRAFT_cf247_sch_queue_hygiene.sql verbatim =====
-- CF-247 scholarship queue hygiene (DRAFT, unnumbered; applies only after Pilot #1143 is merged and applied; #1139 is merged).
-- Findings: admin docs/audits/proposal-pre-ai-admission/QUEUE-HYGIENE-FINDINGS.md (live, read-only, 14 Nov 2026).
-- What:
--   1. public.svc_scholarship_read_record (md5-guarded edit): sets the transaction-local flag cf247.defer_search_refresh while
--      search.defer_read_record_refresh_on is 1, so the rule-read path (security.scholarship_sweep_apply_v1 and
--      security.scholarship_admission_withdraw_v1, already flag-aware after #1143) queues its courses in search.course_refresh_requests
--      instead of waiting on the search-document writer lock. Today that path is dormant: AI admission is on with one active model, so the
--      read call only queues an AI re-read (0 read_record cancellations in the 24 h log window; pg_stat_statements max 7,993 ms is history since
--      10 Aug). It runs again the moment AI admission is switched off or no model is active, and then it waits on the same lock as R5.
--   2. Design pre-ai-admission-v1 §4.3 (Decision 278): a scholarship AI item the admission gate stopped (worker sends
--      p_error 'rejected_admission: <codes>', only for a reason whose admission.enforce.<reason> is on) is terminal:
--      * public.svc_scholarship_ai_record (md5-guarded edit of the #1143 definition): after the extraction row is written, the item goes to
--        state 'rejected_admission' (no retry, no next model, no Layer 4 review, no admission); a discovered candidate page is marked
--        admit_status 'skipped' with the gate's codes (the enqueuers already pass over skipped candidates, as for directory sites) and logged;
--        an approved single read is refused with the reason.
--      * pipeline.scholarship_ai_queue state check gains 'rejected_admission' (same constraint name; replaced in place, as 20261113060000 did
--        for run_kind). public.svc_scholarship_ai_next needs no change: it only picks 'queued' and lapsed 'leased' items.
--      * security.admin_job_watch_v1 and security.ops_step_value_v1 (md5-guarded, one token each) count the new state as finished, so a job
--        or provider step does not show it as still running.
--   3. pipeline.search_refresh_signals gets a table comment saying what it is (write-only, no reader). Its retirement is a separate change (§2
--      of the findings): its nine writers belong to three workstreams.
-- Guards: G1 (no job), G2 (the new switch is a setting with label, range, unit, used_by), G3 (no consumer API object read or changed),
--   Decision 260 (Replaces/Retires; no new table), nothing dropped or deleted (a check constraint is replaced in place under the same name).
-- Live definitions this change edits (md5 of pg_get_functiondef):
--   public.svc_scholarship_read_record(uuid,text,integer,text,text,text,text,jsonb)  ec72dc9952cce9f63e427377ec0513a8  (live 14 Nov 2026; #1143 leaves it)
--   public.svc_scholarship_ai_record(...)  fa3345b7e0fe4ba9b6abafe2ebec4f6a  (the #1143 result; live before #1143: cbcf286f7d5cdd916aee7bb34ca52bc4)
--   security.admin_job_watch_v1(uuid)  947806f31aee1ba3df6311a7ba756e40;  security.ops_step_value_v1(uuid,text,jsonb)  1cb05209c00d6bfd135d0855d32614d7
--   prerequisite (#1143 applied): security.scholarship_sweep_apply_v1 34d0eb52bd702d0556a0ea884115b6aa, security.scholarship_admission_withdraw_v1
--   f2238b1c811dc871bb61a409038d1e9e, search.course_refresh_request_v1(uuid[],text) present.
-- Rollback without a migration: search.defer_read_record_refresh_on = 0 (part 1). Part 2 does nothing until an admission.enforce.<reason> is on;
--   switching those off is its rollback.
-- Rehearsal: QUEUE-HYGIENE-REHEARSAL.sql in this folder (rolled back against live, with #1143 sections 0 and 2 to 5 first); result in the findings.
-- Replaces: public.svc_scholarship_read_record and public.svc_scholarship_ai_record (same names, from the md5s above); security.admin_job_watch_v1 and
--   security.ops_step_value_v1 (one token each); constraint pipeline.scholarship_ai_queue.scholarship_ai_queue_state_check (same name, one more state).
-- Retires: nothing (pipeline.search_refresh_signals: retirement proposed separately, findings §2).

-- 0. guards ---------------------------------------------------------------------------------------------------------------------------------------------
do $g$
begin
  if to_regprocedure('search.course_refresh_request_v1(uuid[],text)') is null
     or md5(pg_get_functiondef('security.scholarship_sweep_apply_v1(uuid)'::regprocedure)) <> '34d0eb52bd702d0556a0ea884115b6aa'
     or md5(pg_get_functiondef('security.scholarship_admission_withdraw_v1(uuid,jsonb)'::regprocedure)) <> 'f2238b1c811dc871bb61a409038d1e9e' then
    raise exception 'prerequisite: #1143 (20261114181500_cf247_sch_ai_record_timeouts) is not applied as rehearsed';
  end if;
end $g$;

create or replace function pg_temp.edit_h(p_sig text, p_md5 text, p_edits text[][], p_times int[]) returns void language plpgsql as $f$
declare v_def text := pg_get_functiondef(p_sig::regprocedure); i int; v_c int;
begin
  if md5(v_def) <> p_md5 then raise exception 'live % differs from the definition this change edits (md5 %)', p_sig, md5(v_def); end if;
  for i in 1 .. array_length(p_edits, 1) loop
    v_c := (length(v_def) - length(replace(v_def, p_edits[i][1], ''))) / length(p_edits[i][1]);
    if v_c <> p_times[i] then raise exception '%: edit % must apply exactly % times (found %)', p_sig, i, p_times[i], v_c; end if;
    v_def := replace(v_def, p_edits[i][1], p_edits[i][2]);
  end loop;
  execute v_def;
end $f$;

-- 1. svc_scholarship_read_record: the rule-read path queues its search refresh -----------------------------------------------------------------------
select pg_temp.edit_h('public.svc_scholarship_read_record(uuid,text,integer,text,text,text,text,jsonb)', 'ec72dc9952cce9f63e427377ec0513a8', array[
  array[$o$  if current_user<>'postgres' and coalesce(auth.role(),'')<>'service_role' then raise exception 'service_role required'; end if;$o$,
        $n$  if current_user<>'postgres' and coalesce(auth.role(),'')<>'service_role' then raise exception 'service_role required'; end if;
  -- queue hygiene (after R5): when the rules apply or withdraw (AI admission off or no active model), the courses are queued for the search
  -- refresh (search.course_refresh_requests, job search-course-refresh) instead of waiting on the search-document writer lock inside the 8 s call
  if security.pipeline_num_v1('search.defer_read_record_refresh_on', 1) = 1 then perform set_config('cf247.defer_search_refresh', 'on', true); end if;$n$]
], array[1]);

-- 2. svc_scholarship_ai_record: rejected_admission is terminal -----------------------------------------------------------------------------------------
select pg_temp.edit_h('public.svc_scholarship_ai_record(bigint,jsonb,jsonb,text,numeric,integer,integer,numeric,text,text,text,text,jsonb,boolean)', 'fa3345b7e0fe4ba9b6abafe2ebec4f6a', array[
  array[$o$v_why text; v_next text; v_prev record;$o$,
        $n$v_why text; v_next text; v_prev record; v_codes text[];$n$],
  array[$o$  returning id into v_id;
$o$,
        $n$  returning id into v_id;
  -- pre-ai-admission-v1 §4.3 (Decision 278): a read the admission gate stopped, for a reason the Platform Admin switched on, is terminal. Nothing was
  -- sent to the AI; the extraction above keeps the error and the evidence. No retry, no next model, no Layer 4 review, no admission. A discovered
  -- page is skipped with the gate's codes (the enqueuers pass over skipped candidates); an approved single read is refused with the reason.
  if p_error like 'rejected_admission:%' then
    v_codes := array_remove(string_to_array(regexp_replace(substr(p_error, 20), '\s', '', 'g'), ','), '');
    update pipeline.scholarship_ai_queue set state = 'rejected_admission', done_at = now(), leased_until = null, extraction_id = v_id, skip_reason = left(p_error, 400)
     where id = q.id;
    if q.candidate_id is not null then
      update pipeline.scholarship_page_candidates c set admit_status = 'skipped', admit_reasons = array['rejected_admission'] || v_codes
       where c.id = q.candidate_id and c.admitted_scholarship_id is null and c.matched_scholarship_id is null
         and coalesce(c.admit_status, '') not in ('admitted', 'matched_held', 'duplicate');
      if found then
        insert into pipeline.scholarship_admission_log(candidate_id, provider_id, action, detail)
        values (q.candidate_id, q.provider_id, 'skipped', jsonb_build_object('by', 'pre_ai_admission', 'reason', 'rejected_admission', 'codes', to_jsonb(v_codes),
                                                                             'extraction', v_id, 'queue_id', q.id, 'decision', 'Decision 278'));
      end if;
    end if;
    if q.read_request_id is not null then
      update pipeline.scholarship_read_requests set state = 'refused', finished_at = now(),
             outcome = jsonb_build_object('why', 'stopped before the AI by the admission rule', 'codes', to_jsonb(v_codes), 'extraction', v_id)
       where id = q.read_request_id and state = 'queued';
    end if;
    return jsonb_build_object('ok', true, 'extraction', v_id, 'rejected_admission', to_jsonb(v_codes));
  end if;
$n$]
], array[1, 1]);

-- 3. the queue state and the two readers that count finished items ---------------------------------------------------------------------------------
do $c$ begin
  if position('''rejected_admission''' in (select pg_get_constraintdef(c.oid) from pg_constraint c where c.conname = 'scholarship_ai_queue_state_check' and c.conrelid = 'pipeline.scholarship_ai_queue'::regclass)) = 0 then
    alter table pipeline.scholarship_ai_queue drop constraint scholarship_ai_queue_state_check,
      add constraint scholarship_ai_queue_state_check check (state = any (array['queued'::text, 'leased'::text, 'done'::text, 'failed'::text, 'rejected_admission'::text]));
  end if;
end $c$;

select pg_temp.edit_h('security.admin_job_watch_v1(uuid)', '947806f31aee1ba3df6311a7ba756e40', array[
  array[$o$count(*) filter (where q.state in ('done', 'failed')), count(*) into v_done, v_total from pipeline.scholarship_ai_queue q$o$,
        $n$count(*) filter (where q.state in ('done', 'failed', 'rejected_admission')), count(*) into v_done, v_total from pipeline.scholarship_ai_queue q$n$]
], array[1]);

select pg_temp.edit_h('security.ops_step_value_v1(uuid,text,jsonb)', '1cb05209c00d6bfd135d0855d32614d7', array[
  array[$o$from pipeline.scholarship_ai_queue q where q.provider_id = p_provider and q.state not in ('done', 'failed'))$o$,
        $n$from pipeline.scholarship_ai_queue q where q.provider_id = p_provider and q.state not in ('done', 'failed', 'rejected_admission'))$n$]
], array[1]);

-- 4. setting (G2) and the signals table's purpose -------------------------------------------------------------------------------------------------
insert into pipeline.platform_toolset_settings(toolset_key, key, label, help, kind, value, min_value, max_value, unit, sort, section, used_by, reason) values
 ('pipeline', 'search.defer_read_record_refresh_on', 'Scholarship page reads: queue the search refresh a rule read causes',
  '1: when a scholarship page read applies the rules or withdraws (AI admission off or no active model), the courses are queued for the search refresh (job search-course-refresh, every minute) so the read is saved inside the 8 s limit. 0: refresh in the read''s own call, as before.',
  'number', to_jsonb(1), 0, 1, 'on (1) or off (0)', 333, 'Website API', 'public.svc_scholarship_read_record',
  'Queue hygiene after R5 (14 Nov 2026): the rule-read path takes the same search-document writer lock that cancelled 170 paid answers a day')
on conflict (toolset_key, key) do nothing;

comment on table pipeline.search_refresh_signals is 'Write-only record of Layer 4 and machine admissions that asked for a search refresh (CF-CHG-20260825-038). No function or job reads it to refresh search: course documents are refreshed by job search-refresh-requested (search.refresh_requests, full refresh) and search.course_refresh_requests. Retirement proposed 14 Nov 2026 (admin docs/audits/proposal-pre-ai-admission/QUEUE-HYGIENE-FINDINGS.md §2).';

-- 5. post-checks -----------------------------------------------------------------------------------------------------------------------------------
do $p$
declare v text;
begin
  v := pg_get_functiondef('public.svc_scholarship_read_record(uuid,text,integer,text,text,text,text,jsonb)'::regprocedure);
  if position('search.defer_read_record_refresh_on' in v) = 0 or position('cf247.defer_search_refresh' in v) = 0 then raise exception 'post-check: read_record not edited'; end if;
  v := pg_get_functiondef('public.svc_scholarship_ai_record(bigint,jsonb,jsonb,text,numeric,integer,integer,numeric,text,text,text,text,jsonb,boolean)'::regprocedure);
  if position('rejected_admission:%' in v) = 0 or position('cf247.defer_search_refresh' in v) = 0 or position('v_codes text[]' in v) = 0 then raise exception 'post-check: ai_record not edited (or #1143 edit lost)'; end if;
  if position('''rejected_admission''' in (select pg_get_constraintdef(c.oid) from pg_constraint c where c.conname = 'scholarship_ai_queue_state_check' and c.conrelid = 'pipeline.scholarship_ai_queue'::regclass)) = 0 then
    raise exception 'post-check: queue state check';
  end if;
  if position('rejected_admission' in pg_get_functiondef('security.admin_job_watch_v1(uuid)'::regprocedure)) = 0
     or position('rejected_admission' in pg_get_functiondef('security.ops_step_value_v1(uuid,text,jsonb)'::regprocedure)) = 0 then raise exception 'post-check: readers'; end if;
  if not exists (select 1 from pipeline.platform_toolset_settings where toolset_key = 'pipeline' and key = 'search.defer_read_record_refresh_on' and used_by is not null and unit is not null) then
    raise exception 'post-check: setting';
  end if;
  if md5(pg_get_functiondef('public.svc_scholarship_ai_next(integer)'::regprocedure)) <> '4860b52da46c2912b10d687f944fb65a' then raise exception 'post-check: svc_scholarship_ai_next changed'; end if;
end $p$;

-- ===== rehearsal assertions (forced rollback: the block always raises) =====
do $rehearsal$
declare p record; f text[] := '{}'; r jsonb := '{}'; v jsonb; t0 timestamptz; v_ms int; k bigint := hashtext('cf247:search_course_documents_writer');
        v_sch uuid := '26ad43cc-f790-5a5c-ad99-2e5df19609be'; v_url text; v_prov uuid; v_n int; v_held int; qa bigint; qb bigint; qc bigint; qd bigint; v_rr bigint; v_rev bigint;
        v_reviews int; v_ctl boolean;
begin
  select * into p from _rh_pre;
  -- A. Task 1: the rule-read path queues its search refresh instead of waiting on the writer lock
  update pipeline.scholarship_ai_extract_settings set ai_admission = false where id = 1;  -- rehearsal only: reach the dormant rule path
  select sp.url, s.provider_id into v_url, v_prov from pipeline.scholarship_pages sp join scholarship.scholarships s on s.id = sp.scholarship_id where sp.scholarship_id = v_sch;
  perform set_config('cf247.defer_search_refresh', '', true);
  t0 := clock_timestamp();
  v := public.svc_scholarship_read_record(v_sch, 'read', 200, 'scraper', v_url, null, null,
         jsonb_build_object('admission', jsonb_build_object('admit', false, 'reasons', jsonb_build_array('rehearsal')), 'extractor', 'rehearsal'));
  v_ms := (extract(epoch from clock_timestamp() - t0) * 1000)::int;
  select count(*) into v_n from search.course_refresh_requests where requested_by = 'scholarship_admission_withdraw_v1' and processed_at is null;
  select count(*) into v_held from pg_locks where locktype = 'advisory' and pid = pg_backend_pid() and objsubid = 1
     and classid = ((k >> 32) & 4294967295)::oid and objid = (k & 4294967295)::oid;
  r := r || jsonb_build_object('A_read_record', jsonb_build_object('result', v, 'ms', v_ms, 'queued_courses', v_n, 'writer_lock_held', v_held,
                                                                   'flag', current_setting('cf247.defer_search_refresh', true)));
  if current_setting('cf247.defer_search_refresh', true) is distinct from 'on' then f := array_append(f, 'A1 flag not set by read_record'::text); end if;
  if coalesce(v->>'withdrawn', '') <> 'true' then f := array_append(f, 'A2 withdraw path not reached'::text); end if;
  if v_n = 0 then f := array_append(f, 'A3 no courses queued'::text); end if;
  if v_held <> 0 then f := array_append(f, 'A4 writer lock taken'::text); end if;
  if v_ms >= 8000 then f := array_append(f, 'A5 over 8 s'::text); end if;
  -- A6: the switch: 0 leaves the flag unset (a waiting_scraper read does not apply or withdraw)
  update pipeline.platform_toolset_settings set value = to_jsonb(0) where toolset_key = 'pipeline' and key = 'search.defer_read_record_refresh_on';
  perform set_config('cf247.defer_search_refresh', '', true);
  perform public.svc_scholarship_read_record(v_sch, 'waiting_scraper', null, 'scraper', v_url, null, null, null);
  if coalesce(current_setting('cf247.defer_search_refresh', true), '') <> '' then f := array_append(f, 'A6 switch 0 still sets the flag'::text); end if;
  -- A7: positive control for the lock check (only when the writer lock is free right now)
  v_ctl := pg_try_advisory_xact_lock(k);
  if v_ctl then
    select count(*) into v_held from pg_locks where locktype = 'advisory' and pid = pg_backend_pid() and objsubid = 1
       and classid = ((k >> 32) & 4294967295)::oid and objid = (k & 4294967295)::oid;
    if v_held <> 1 then f := array_append(f, 'A7 lock check does not see a held writer lock'::text); end if;
  end if;
  r := r || jsonb_build_object('A7_lock_control', case when v_ctl then 'checked' else 'writer busy: skipped' end);

  -- B. Task 3: rejected_admission is terminal
  select count(*) into v_reviews from pipeline.scholarship_ai_reviews;
  -- B1 candidate page
  insert into pipeline.scholarship_ai_queue(model_code, prompt_version, run_kind, candidate_id, provider_id, url, state, attempts, leased_until)
  select 'qwen3-30b', 3, 'admit', c.id, c.provider_id, c.url, 'leased', 1, now() + interval '4 minutes' from pipeline.scholarship_page_candidates c where c.id = 41943 returning id into qa;
  v := public.svc_scholarship_ai_record(qa, null, null, null, 0, null, null, 1.2, 'rejected_admission: thin_page, soft_block', null, null, null, null, false);
  r := r || jsonb_build_object('B1_candidate', v);
  if v->'rejected_admission' is distinct from '["thin_page","soft_block"]'::jsonb then f := array_append(f, 'B1a codes'::text); end if;
  if not exists (select 1 from pipeline.scholarship_ai_queue where id = qa and state = 'rejected_admission' and done_at is not null and leased_until is null
                   and extraction_id = (v->>'extraction')::bigint and attempts = 1 and skip_reason like 'rejected_admission:%') then f := array_append(f, 'B1b queue row not terminal'::text); end if;
  if exists (select 1 from pipeline.scholarship_ai_queue where root_id = qa) then f := array_append(f, 'B1c escalated to another model'::text); end if;
  if not exists (select 1 from pipeline.scholarship_page_candidates where id = 41943 and admit_status = 'skipped' and admit_reasons = array['rejected_admission','thin_page','soft_block']) then f := array_append(f, 'B1d candidate not skipped'::text); end if;
  if not exists (select 1 from pipeline.scholarship_admission_log where candidate_id = 41943 and action = 'skipped' and detail->>'by' = 'pre_ai_admission') then f := array_append(f, 'B1e no admission log'::text); end if;
  if not exists (select 1 from pipeline.scholarship_ai_extractions where id = (v->>'extraction')::bigint and error like 'rejected_admission:%' and coalesce(cost_usd, 0) = 0) then f := array_append(f, 'B1f extraction'::text); end if;
  -- the picker never takes it again (svc_scholarship_ai_next's due predicate) and the enqueuer passes over the candidate
  if exists (select 1 from pipeline.scholarship_ai_queue q where q.id = qa and ((q.state = 'queued' and q.next_try_at <= now()) or (q.state = 'leased' and q.leased_until < now()))) then f := array_append(f, 'B1g picker would take it'::text); end if;
  if exists (select 1 from pipeline.scholarship_page_candidates c where c.id = 41943 and coalesce(c.admit_status, '') not in ('skipped', 'duplicate', 'admitted', 'matched_held')) then f := array_append(f, 'B1h enqueuer would queue it again'::text); end if;
  -- B2 approved single read: refused with the reason, no Layer 4 review opened
  select id into v_rev from pipeline.scholarship_ai_reviews order by id desc limit 1;
  insert into pipeline.scholarship_read_requests(review_id, candidate_id, provider_id, url, fresh, reason, approved_by)
  select v_rev, c.id, c.provider_id, c.url, false, 'rehearsal', 'rehearsal' from pipeline.scholarship_page_candidates c where c.id = 41933 returning id into v_rr;
  insert into pipeline.scholarship_ai_queue(model_code, prompt_version, run_kind, candidate_id, provider_id, url, state, attempts, leased_until, read_request_id)
  select 'qwen3-30b', 3, 'admit', c.id, c.provider_id, c.url, 'leased', 1, now() + interval '4 minutes', v_rr from pipeline.scholarship_page_candidates c where c.id = 41933 returning id into qb;
  v := public.svc_scholarship_ai_record(qb, null, null, null, 0, null, null, 0.4, 'rejected_admission: thin_page', null, null, null, null, false);
  r := r || jsonb_build_object('B2_read_request', v);
  if not exists (select 1 from pipeline.scholarship_read_requests where id = v_rr and state = 'refused' and outcome->>'why' = 'stopped before the AI by the admission rule') then f := array_append(f, 'B2a request not refused'::text); end if;
  if not exists (select 1 from pipeline.scholarship_ai_queue where id = qb and state = 'rejected_admission') then f := array_append(f, 'B2b queue row'::text); end if;
  if (select count(*) from pipeline.scholarship_ai_reviews) <> v_reviews then f := array_append(f, 'B2c a Layer 4 review was opened'::text); end if;
  -- B3 re-read of a known scholarship
  insert into pipeline.scholarship_ai_queue(model_code, prompt_version, run_kind, scholarship_id, provider_id, url, state, attempts, leased_until)
  values ('qwen3-30b', 3, 'reread', v_sch, v_prov, v_url, 'leased', 2, now() + interval '4 minutes') returning id into qc;
  v := public.svc_scholarship_ai_record(qc, null, null, null, 0, null, null, 0.3, 'rejected_admission: page_not_ok', null, null, null, null, false);
  if not exists (select 1 from pipeline.scholarship_ai_queue where id = qc and state = 'rejected_admission' and attempts = 2) or exists (select 1 from pipeline.scholarship_ai_queue where root_id = qc) then f := array_append(f, 'B3 reread not terminal'::text); end if;
  -- B4 regression: any other error keeps today's behaviour (retry or next model), never the new state
  insert into pipeline.scholarship_ai_queue(model_code, prompt_version, run_kind, scholarship_id, provider_id, url, state, attempts, leased_until)
  values ('qwen3-30b', 3, 'reread', v_sch, v_prov, v_url, 'leased', 1, now() + interval '4 minutes') returning id into qd;
  v := public.svc_scholarship_ai_record(qd, null, null, null, 0, null, null, 0.3, 'HTTP 500 rehearsal', null, null, null, null, false);
  r := r || jsonb_build_object('B4_other_error', v, 'B4_state', (select state from pipeline.scholarship_ai_queue where id = qd));
  if (select state from pipeline.scholarship_ai_queue where id = qd) = 'rejected_admission' then f := array_append(f, 'B4 other error became terminal'::text); end if;
  -- B5 the state check refuses an unknown state
  begin
    update pipeline.scholarship_ai_queue set state = 'bogus' where id = qd;
    f := array_append(f, 'B5 unknown state accepted'::text);
  exception when check_violation then null;
  end;

  -- N. nothing else
  if (select count(*) from cron.job) <> p.cron_jobs + 1 then f := array_append(f, 'N1 cron jobs (expected +1, search-course-refresh from #1143)'::text); end if;
  if (select count(*) from pipeline.platform_toolset_settings) <> p.settings_total + 3 then f := array_append(f, 'N2 settings (expected +3: two from #1143, one here)'::text); end if;
  if md5(pg_get_functiondef('public.svc_scholarship_ai_next(integer)'::regprocedure)) <> p.next_md5 then f := array_append(f, 'N3 picker changed'::text); end if;
  r := r || jsonb_build_object('md5_after', jsonb_build_object(
          'read_record', md5(pg_get_functiondef('public.svc_scholarship_read_record(uuid,text,integer,text,text,text,text,jsonb)'::regprocedure)),
          'ai_record', md5(pg_get_functiondef('public.svc_scholarship_ai_record(bigint,jsonb,jsonb,text,numeric,integer,integer,numeric,text,text,text,text,jsonb,boolean)'::regprocedure)),
          'job_watch', md5(pg_get_functiondef('security.admin_job_watch_v1(uuid)'::regprocedure)),
          'ops_step', md5(pg_get_functiondef('security.ops_step_value_v1(uuid,text,jsonb)'::regprocedure))),
        'md5_before', jsonb_build_object('read_record', p.read_md5, 'ai_record', p.ai_md5, 'job_watch', p.watch_md5, 'ops_step', p.ops_md5));
  r := jsonb_build_object('verdict', case when cardinality(f) = 0 then 'PASS' else 'FAIL' end, 'failed', to_jsonb(f), 'txid', txid_current(), 'at', now()) || r;
  raise exception 'REHEARSAL_RESULT %', r::text;
end $rehearsal$;
