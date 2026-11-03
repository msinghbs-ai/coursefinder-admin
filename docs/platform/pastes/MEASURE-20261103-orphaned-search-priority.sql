-- MEASURE-20261103-orphaned-search-priority.sql (read-only): the classification the paste uses, and the guard values for the safe set.
begin;
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
select cls, count(*) n, count(distinct provider_id) providers, md5(string_agg(course_id::text, ',' order by course_id)) ids_md5 from _orph group by cls order by cls;
rollback;
