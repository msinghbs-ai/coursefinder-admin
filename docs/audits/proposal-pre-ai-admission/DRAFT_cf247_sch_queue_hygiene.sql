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
