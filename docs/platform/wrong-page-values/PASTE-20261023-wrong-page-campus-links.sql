-- CF-247, 23 Oct 2026. Paste file for the Platform Admin (Supabase SQL editor, project fxcwkweaxjtknorudmwp).
-- Removes the campus links the AI reader took from a page the platform had already found to be another course's page
-- (status mismatch). The Platform Admin approved taking these values back on 23 Oct 2026 ("Take them all back").
-- Migration 20261023017000_cf247_ai_reader_bound_pages_only.sql recorded every such value in pipeline.enrich_value_retractions
-- (with its campus ids, quote and page) and took back the delivery, duration, international and intake values; a migration does
-- not delete, so the campus links are removed here. Expected at preparation: 717 links on 581 courses.
-- To restore a link: pipeline.enrich_value_retractions.value->'campuses' holds the campus ids.

begin;

-- 1 check: how many links will go (expected about 717)
select count(*) links, count(distinct cc.course_id) courses
  from catalogue.course_campuses cc
  join pipeline.enrich_value_retractions r on r.field = 'campus' and cc.course_id = r.course_id and cc.evidence_id = r.evidence_id;

-- 2 remove them
delete from catalogue.course_campuses cc
 using pipeline.enrich_value_retractions r
 where r.field = 'campus' and cc.course_id = r.course_id and cc.evidence_id = r.evidence_id;

-- 3 record that they are cleared
update pipeline.enrich_value_retractions r set cleared = true
 where r.field = 'campus'
   and not exists (select 1 from catalogue.course_campuses cc where cc.course_id = r.course_id and cc.evidence_id = r.evidence_id);

-- 4 check: should be 0 links left and 581 campus rows cleared
select (select count(*) from catalogue.course_campuses cc join pipeline.enrich_value_retractions r on r.field = 'campus' and cc.course_id = r.course_id and cc.evidence_id = r.evidence_id) links_left,
       (select count(*) from pipeline.enrich_value_retractions where field = 'campus' and cleared) campus_cleared;

commit;
