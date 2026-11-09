-- PASTE-20261103-orphaned-search-priority-release.sql (CF-247 workstream D; Platform Admin approval 3 Nov 2026 18:14: "Before releasing
-- 1,273 orphaned queue slots, verify ownership, leases and pending dependencies; execute only a guarded, reversible correction.")
-- Applied by the Integration Controller in one transaction (load windows; not at :35-:42 or :47-:48).
-- What: course_link_search rows that are queued, carry a Find course pages task's precedence (requested_at) and are listed by no open task.
--   Only rows classified 'safe' are changed: their requested_at is set to null, so they are searched in their normal turn (as when a person
--   cancels a task). Nothing leaves the queue; state, attempts, queued_at and every other column are untouched.
--   safe = the latest task listing the course is ended (done, failed or cancelled) with a recorded outcome, and set this requested_at
--   (within 10 minutes of its start); no send in the last 60 minutes; no open plan or open Find course pages task for the provider; no step of
--   the provider's latest plan due or scheduled for a retry re-plan (security.enrich_plan_inputs_v1 retry_steps, or restart.retry_on); no pending Layer 4 official_course_url
--   item for the course.
-- Measured live 3 Nov 2026 18:27 AEDT (v2.15.430): 1,275 orphaned rows; safe 731 (144 providers), keep_retry_pending 290 (7), keep_pending_dependency
--   135 (2), unclear 119 (33), keep_in_flight 0, keep_layer4 0 (its 42 rows are inside keep_retry_pending).
-- Guard: the safe set must equal the measured set exactly (count and md5 of the sorted course ids); otherwise nothing changes. Re-measure
--   with MEASURE-20261103-orphaned-search-priority.sql just before applying and replace both values if the queue moved.
-- Reversible: every changed row's before-state is kept in pipeline.ops_lane_priority_snapshots (batch orphan-priority-20261103);
--   ROLLBACK-20261103-orphaned-search-priority-release.sql restores requested_at exactly.
-- Nothing is deleted.
begin;
create table if not exists pipeline.ops_lane_priority_snapshots (
  id bigint generated always as identity primary key,
  batch text not null,
  course_id uuid not null,
  provider_id uuid,
  requested_at timestamptz not null,
  queued_at timestamptz,
  state text not null,
  owner_job uuid,
  owner_outcome text,
  taken_at timestamptz not null default now(),
  restored_at timestamptz,
  restore_note text,
  unique (batch, course_id));
comment on table pipeline.ops_lane_priority_snapshots is 'CF-247 workstream D (Platform Admin 3 Nov 2026 18:14): the before-state of every course_link_search row whose task precedence (requested_at) a guarded correction released, by batch, with the task that had set it and its outcome; the rollback restores requested_at from here exactly and records when.';
revoke all on pipeline.ops_lane_priority_snapshots from public, anon, authenticated;
-- The orphaned-priority classification (shared by the measurement, the paste file and its rollback check). One row per course_link_search row
-- that is queued, carries a task's precedence (requested_at) and is not listed by any open Find course pages task.
create temp table _orph on commit drop as
with o as (
  select s.course_id, s.provider_id, s.requested_at, s.queued_at, s.sent_at, s.state
    from pipeline.course_link_search s
   where s.state = 'queued' and s.requested_at is not null
     and not exists (select 1 from pipeline.admin_jobs j where j.kind = 'course_page_find' and j.state in ('queued', 'running', 'paused') and j.args->'course_ids' ? s.course_id::text)),
own as (
  select o.course_id, j.id job_id, j.state jstate, j.outcome, j.created_at jcreated
    from o left join lateral (select j.* from pipeline.admin_jobs j where j.kind = 'course_page_find' and j.args->'course_ids' ? o.course_id::text
                               order by j.created_at desc limit 1) j on true),
p as (select distinct o.provider_id from o),
dep as (select p.provider_id,
               exists (select 1 from pipeline.enrich_plan_runs r where r.provider_id = p.provider_id and r.state in ('queued', 'running')) open_plan,
               exists (select 1 from pipeline.admin_jobs j where j.kind = 'course_page_find' and j.state in ('queued', 'running', 'paused') and j.args->>'provider_id' = p.provider_id::text) open_task,
               coalesce(jsonb_array_length(security.enrich_plan_inputs_v1(p.provider_id)->'retry_steps'), 0) > 0
               -- or a step of its latest plan is scheduled for a retry re-plan (restart.retry_on, not waiting for a change), even before it is due
               or exists (select 1 from (select r.steps from pipeline.enrich_plan_runs r where r.provider_id = p.provider_id order by r.created_at desc limit 1) l
                             cross join lateral jsonb_array_elements(l.steps) s
                           where s->>'status' in ('failed', 'timed_out', 'cancelled', 'stopped') and coalesce((s->'restart'->>'retry_on')::boolean, false)
                             and not coalesce((s->'restart'->>'waits_for_change')::boolean, false)) retry_due
          from p)
select o.course_id, o.provider_id, o.requested_at, o.queued_at, o.sent_at, own.job_id owner_job, own.jstate owner_state, own.outcome owner_outcome,
       case when o.sent_at is not null and o.sent_at > now() - interval '60 minutes' then 'keep_in_flight'
            when dep.open_plan or dep.open_task then 'keep_pending_dependency'
            when dep.retry_due then 'keep_retry_pending'
            when exists (select 1 from pipeline.layer4_review_items l where l.entity_type = 'course' and l.entity_id = o.course_id and l.status = 'pending'
                            and l.field_code = 'official_course_url') then 'keep_layer4'
            when own.job_id is null or own.jstate not in ('done', 'failed', 'cancelled') or own.outcome is null
                 or abs(extract(epoch from (o.requested_at - own.jcreated))) >= 600 then 'unclear'
            else 'safe' end cls
  from o join own using (course_id) join dep using (provider_id);
do $$
declare v_n int; v_md5 text; v_u int;
  c_expected int := 731; c_md5 text := '7158d298e94b79265b0f521f946438ac'; c_batch text := 'orphan-priority-20261103';
begin
  select count(*), md5(string_agg(course_id::text, ',' order by course_id)) into v_n, v_md5 from _orph where cls = 'safe';
  if v_n <> c_expected or v_md5 is distinct from c_md5 then
    raise exception 'count guard: % safe rows now (ids md5 %), measured % (%); nothing changed. Re-measure and update the guard.', v_n, v_md5, c_expected, c_md5;
  end if;
  if exists (select 1 from pipeline.ops_lane_priority_snapshots where batch = c_batch) then raise exception 'batch % already applied; nothing changed', c_batch; end if;
  insert into pipeline.ops_lane_priority_snapshots(batch, course_id, provider_id, requested_at, queued_at, state, owner_job, owner_outcome)
  select c_batch, o.course_id, o.provider_id, o.requested_at, o.queued_at, 'queued', o.owner_job, o.owner_outcome from _orph o where o.cls = 'safe';
  update pipeline.course_link_search s set requested_at = null
    from _orph o where o.cls = 'safe' and o.course_id = s.course_id and s.state = 'queued' and s.requested_at = o.requested_at;
  get diagnostics v_u = row_count;
  if v_u <> c_expected then raise exception 'update guard: % rows changed, expected %; rolled back', v_u, c_expected; end if;
  insert into pipeline.admin_control_events(area, action, target, detail)
  values ('ops', 'lane_priority_release', 'course_link_search',
          jsonb_build_object('batch', c_batch, 'released', v_u, 'ids_md5', v_md5, 'approved', 'Platform Admin 3 Nov 2026 18:14',
                             'classes', (select jsonb_object_agg(cls, n) from (select cls, count(*) n from _orph group by 1) z),
                             'rollback', 'ROLLBACK-20261103-orphaned-search-priority-release.sql'));
  raise notice 'released % rows (batch %)', v_u, c_batch;
end $$;
commit;
