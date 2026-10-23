-- CF-247, 23 Oct 2026. Paste file for the Platform Admin (Supabase SQL editor, project fxcwkweaxjtknorudmwp).
-- Run AFTER migration 20261023019000_cf247_older_wrong_page_values_and_south_auckland.sql (deployed with v2.15.330).
-- Platform Admin 16:02: "Take back 3,462, re-read 2,023". Removes the campus links the AI reader took from an earlier page that is not
-- the course's own page (recorded in pipeline.enrich_value_retractions with reason ... 16:02 ...), then asks Read with AI to read the
-- campus again from the course's own page for courses that now have one. The re-read is queued only after the removal because a
-- re-read does not link a campus the course already has. Expected at preparation: 1,572 links removed; 375 campus re-reads queued.
-- To restore a link: pipeline.enrich_value_retractions.value->'campuses' holds the campus ids.

begin;

-- 1 check: links that will go (expected about 1,572)
select count(*) links, count(distinct cc.course_id) courses
  from catalogue.course_campuses cc
  join pipeline.enrich_value_retractions r on r.field = 'campus' and cc.course_id = r.course_id and cc.evidence_id = r.evidence_id
 where r.reason like '%16:02%';

-- 2 remove them
delete from catalogue.course_campuses cc
 using pipeline.enrich_value_retractions r
 where r.field = 'campus' and r.reason like '%16:02%' and cc.course_id = r.course_id and cc.evidence_id = r.evidence_id;

update pipeline.enrich_value_retractions r set cleared = true
 where r.field = 'campus' and r.reason like '%16:02%'
   and not exists (select 1 from catalogue.course_campuses cc where cc.course_id = r.course_id and cc.evidence_id = r.evidence_id);

-- 3 campus read again from the course's own page: one Read with AI job per university
create temp table _cj on commit drop as
select r.provider_id, gen_random_uuid() job_id, jsonb_agg(distinct r.course_id) course_ids, count(distinct r.course_id) n
  from pipeline.enrich_value_retractions r
 where r.field = 'campus' and r.reason like '%16:02: re-read'
   and not exists (select 1 from catalogue.course_campuses cc where cc.course_id = r.course_id)
 group by r.provider_id;

insert into pipeline.admin_jobs(id, kind, lane, state, title, args, progress, requested_by, reason, scope)
select j.job_id, 'enrich_fields', 'enrich', 'queued',
       left('Read with AI again from the correct page (campus) · ' || coalesce(p.display_name, p.canonical_name), 200),
       jsonb_build_object('read_now', true, 'countries', '[]'::jsonb, 'provider_ids', jsonb_build_array(j.provider_id), 'course_ids', j.course_ids,
                          'fields', '["campus"]'::jsonb, 'ai', true, 'scraper', false),
       jsonb_build_object('done', 0, 'total', 0), '63ba56cb-48d4-4169-98c2-7c4d1f72925b'::uuid,
       'Platform Admin 23 Oct 2026 16:02: campus read again from the course''s own page after the wrong-page links were removed', j.n || ' courses'
  from _cj j join catalogue.providers p on p.id = j.provider_id;

insert into pipeline.field_enrich_items(job_id, provider_id, course_id, field, state)
select j.job_id, j.provider_id, c.value::uuid, 'campus', 'queued' from _cj j cross join lateral jsonb_array_elements_text(j.course_ids) c
on conflict do nothing;
insert into pipeline.field_enrich_items(job_id, provider_id, course_id, field, state)
select j.job_id, j.provider_id, null, 'campus_list', 'waiting' from _cj j
on conflict do nothing;

-- 4 check: 0 links left; campus jobs and items queued
select (select count(*) from catalogue.course_campuses cc join pipeline.enrich_value_retractions r on r.field = 'campus' and cc.course_id = r.course_id and cc.evidence_id = r.evidence_id where r.reason like '%16:02%') links_left,
       (select count(*) from _cj) campus_jobs,
       (select coalesce(sum(n), 0) from _cj) campus_courses;

commit;
