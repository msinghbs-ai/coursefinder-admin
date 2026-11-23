-- PASTE-20261123-s1011-duplicate-indexes-drop.sql
-- CF-247 s1011 (S1-Build; Platform Admin 23 Nov 2026 20:38 AEDT; Decision 260: a migration drops nothing, so a person runs this).
-- Drops one index of each of three exact duplicate pairs found by the architecture audit bundle (section 9.4) and confirmed live on
-- 23 Nov 2026 20:41 AEDT in a rolled-back read: each pair has the same table, columns, order and WHERE clause, and neither index backs a
-- constraint. The planner uses either one, so reads are unchanged; writes to these tables get one index less to maintain.
--
--   Kept                                          Dropped
--   catalogue.courses_empty_reason_code_idx       catalogue.idx_courses_empty_reason_code     (empty_reason_code) where not null
--   catalogue.courses_study_load_idx              catalogue.idx_courses_study_load            (study_load) where not null
--   pipeline.aer_v2_shadow_results_version_course pipeline.aer_v2_shadow_results_course       (prompt_version, course_id)
--
-- No column, type or function changes (catalogue.courses is read by the frozen consumer API; an index is not part of its shape).
-- HOW TO RUN (Supabase SQL editor, project fxcwkweaxjtknorudmwp only):
--   Step 1: run the CHECK block alone. It stops with an error unless all three pairs are still exact duplicates and no constraint uses
--           the index to be dropped. It changes nothing.
--   Step 2: run each DROP line on its own (DROP INDEX CONCURRENTLY cannot run inside a transaction or a multi-statement batch). Each takes
--           no lock that blocks reads or writes.
--   Step 3: run the CONFIRM query; it should return the three kept index names and none of the dropped ones.
-- Re-running is safe: every statement uses IF EXISTS.

-- Step 1: CHECK (changes nothing)
do $chk$
declare p record;
begin
  for p in select * from (values
      ('catalogue', 'courses_empty_reason_code_idx', 'idx_courses_empty_reason_code'),
      ('catalogue', 'courses_study_load_idx', 'idx_courses_study_load'),
      ('pipeline', 'aer_v2_shadow_results_version_course', 'aer_v2_shadow_results_course')) v(sch, keep, drop_name) loop
    if to_regclass(p.sch || '.' || p.drop_name) is null then
      raise notice 'already dropped: %.%', p.sch, p.drop_name;
      continue;
    end if;
    if to_regclass(p.sch || '.' || p.keep) is null then
      raise exception 'stop: the index to keep (%.%) is missing', p.sch, p.keep;
    end if;
    if replace(pg_get_indexdef((p.sch || '.' || p.keep)::regclass), p.keep, '#')
       <> replace(pg_get_indexdef((p.sch || '.' || p.drop_name)::regclass), p.drop_name, '#') then
      raise exception 'stop: %.% and %.% are no longer the same index', p.sch, p.keep, p.sch, p.drop_name;
    end if;
    if exists (select 1 from pg_constraint c where c.conindid = (p.sch || '.' || p.drop_name)::regclass) then
      raise exception 'stop: a constraint uses %.%', p.sch, p.drop_name;
    end if;
    raise notice 'ok to drop: %.% (duplicate of %)', p.sch, p.drop_name, p.keep;
  end loop;
end $chk$;

-- Step 2: DROP (run each line on its own)
drop index concurrently if exists catalogue.idx_courses_empty_reason_code;
drop index concurrently if exists catalogue.idx_courses_study_load;
drop index concurrently if exists pipeline.aer_v2_shadow_results_course;

-- Step 3: CONFIRM
select schemaname, tablename, indexname from pg_indexes
 where indexname in ('courses_empty_reason_code_idx', 'idx_courses_empty_reason_code', 'courses_study_load_idx', 'idx_courses_study_load',
                     'aer_v2_shadow_results_version_course', 'aer_v2_shadow_results_course')
 order by 1, 2, 3;
