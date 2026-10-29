-- CF-247 paste file (Platform Admin) — re-apply the scholarship course-link rules to the 214 scholarships whose pages state only
-- "postgraduate_research" and were therefore linked by field alone to every study level (mandate 29 Oct 2026 12:23, section A2).
-- Run ONLY after migration 20261029070000_cf247_scholarship_relationship_fix.sql is live. This file REMOVES links (through the existing
-- security.scholarship_sweep_apply_v1), which is why it is a paste file and not part of a migration.
-- Drafted 29 Oct 2026 from live counts (read only): 13,584 field-only links on 214 scholarships; 8,042 of them on published, active
-- scholarships to courses that are not research degrees (2,553 courses, 17 providers, 148 scholarships); 7,949 of those are in
-- search.course_documents and returned by public.website_v2_course (e.g. DP020 shows two RMIT PhD scholarships).
-- What it does: for each of the 214, security.scholarship_sweep_apply_v1(id) reads the stored page facts again. With the migration,
-- "postgraduate_research" now means Masters (Research) and Doctorate, so field-only links to other levels are removed and research-level
-- courses in the stated fields are linked (expected roughly 1,500 links, give or take named-course matches). Links made by a person
-- are never touched (there are none on these 214). Search documents are refreshed by the function for the courses whose links change.
-- Note: the function also re-applies the page's award value, dates and criteria from the same stored facts (idempotent; hand locks are kept).
-- 4 of the 214 have no applicable page (read_status 'gone' or 'name_mismatch'); the function returns applied=false and leaves their 383 links
-- unchanged. They are listed at the end for a separate decision (optional block C, commented out).
-- Everything runs in one transaction; any failed check rolls it all back.

begin;
set local statement_timeout = 0;  -- the search refresh for ~2,500 courses can take several minutes

-- ---------------------------------------------------------------- A. preconditions: the migration is live
do $$
begin
  if security.scholarship_level_codes('["postgraduate_research"]'::jsonb) <> array['doctorate','masters_research'] then
    raise exception 'migration 20261029070000 is not live: postgraduate_research is not yet a research level'; end if;
  if position('levels_not_recognised' in pg_get_functiondef('security.scholarship_sweep_apply_v1(uuid)'::regprocedure)) = 0 then
    raise exception 'migration 20261029070000 is not live: the sweep still links by field when no stated level is recognised'; end if;
end $$;

-- ---------------------------------------------------------------- the affected scholarships, fixed before anything changes
create temp table _affected on commit drop as
select distinct m.scholarship_id
  from scholarship.course_mappings m
 where m.mapping_basis = 'sweep_level_field_scope' and m.proof->>'kind' = 'levels_fields'
   and m.proof->'levels' = '["postgraduate_research"]'::jsonb;

create temp table _before on commit drop as
select (select count(*) from _affected) scholarships,
       (select count(*) from scholarship.course_mappings m join _affected a using (scholarship_id)) links,
       (select count(*) from scholarship.course_mappings m join _affected a using (scholarship_id)
          join catalogue.courses c on c.id = m.course_id left join ref.study_levels sl on sl.id = c.study_level_id
         where m.proof->'levels' = '["postgraduate_research"]'::jsonb and coalesce(sl.code,'') not in ('masters_research','doctorate')) wrong_level_links,
       (select count(*) from scholarship.course_mappings m join _affected a using (scholarship_id) where m.mapped_by is not null) hand_links;

do $$
declare b record;
begin
  select * into b from _before;
  raise notice 'before: % scholarships, % links, % to non-research levels, % made by hand', b.scholarships, b.links, b.wrong_level_links, b.hand_links;
  if b.scholarships <> 214 then raise exception 'expected 214 affected scholarships, found % — re-check before running', b.scholarships; end if;
end $$;

-- ---------------------------------------------------------------- B. re-apply through the existing mechanism
create temp table _results(scholarship_id uuid primary key, result jsonb) on commit drop;
do $$
declare r record;
begin
  for r in select scholarship_id from _affected order by scholarship_id loop
    insert into _results values (r.scholarship_id, security.scholarship_sweep_apply_v1(r.scholarship_id));
  end loop;
end $$;

-- ---------------------------------------------------------------- after: checks (any failure rolls everything back)
do $$
declare v_applied int; v_not int; v_wrong int; v_hand int; v_links int; v_unapplied_wrong int;
begin
  select count(*) filter (where (result->>'applied')::boolean), count(*) filter (where not coalesce((result->>'applied')::boolean,false)) into v_applied, v_not from _results;
  select count(*) into v_links from scholarship.course_mappings m join _affected a using (scholarship_id);
  select count(*) into v_hand from scholarship.course_mappings m join _affected a using (scholarship_id) where m.mapped_by is not null;
  -- no applied scholarship keeps a field-only link to a non-research course
  select count(*) into v_wrong from scholarship.course_mappings m join _results x using (scholarship_id)
    join catalogue.courses c on c.id = m.course_id left join ref.study_levels sl on sl.id = c.study_level_id
   where (x.result->>'applied')::boolean and m.mapping_basis = 'sweep_level_field_scope' and m.proof->>'kind' = 'levels_fields'
     and coalesce(sl.code,'') not in ('masters_research','doctorate');
  select count(*) into v_unapplied_wrong from scholarship.course_mappings m join _results x using (scholarship_id)
   where not coalesce((x.result->>'applied')::boolean,false) and m.proof->'levels' = '["postgraduate_research"]'::jsonb;
  raise notice 'after: % applied, % not applicable; % links now (was %); % wrong-level links left on applied scholarships; % left on the not-applicable ones; % made by hand',
    v_applied, v_not, v_links, (select links from _before), v_wrong, v_unapplied_wrong, v_hand;
  if v_applied <> 210 or v_not <> 4 then raise exception 'expected 210 applied and 4 not applicable, got % and %', v_applied, v_not; end if;
  if v_wrong <> 0 then raise exception '% field-only links to non-research courses remain on applied scholarships', v_wrong; end if;
  if v_hand <> (select hand_links from _before) then raise exception 'links made by hand changed'; end if;
end $$;

-- the not-applicable four, for the record
select x.scholarship_id, s.name, s.publication_status, pg.read_status, x.result
  from _results x join scholarship.scholarships s on s.id = x.scholarship_id join pipeline.scholarship_pages pg on pg.scholarship_id = x.scholarship_id
 where not coalesce((x.result->>'applied')::boolean, false);
-- expected: 1c686f40… Research Career Launch Scholarship (unpublished, gone, 162 links), 23824025… Battery Research Scholarship (published,
-- name_mismatch, 75), 3b42346b… REACH Scholarship (published, name_mismatch, 32), 67ef3848… Postgraduate Research Scholarship in Nonlinear
-- Dynamical Systems (published, gone, 114).

-- ---------------------------------------------------------------- C. OPTIONAL (Platform Admin decision): the 4 not-applicable scholarships
-- Their pages cannot be applied again, so their field-only links stay. To remove only the links to non-research courses, uncomment:
-- delete from scholarship.course_mappings m using catalogue.courses c left join ref.study_levels sl on sl.id = c.study_level_id
--  where c.id = m.course_id and m.mapped_by is null and m.mapping_basis = 'sweep_level_field_scope'
--    and m.proof->'levels' = '["postgraduate_research"]'::jsonb and coalesce(sl.code,'') not in ('masters_research','doctorate')
--    and m.scholarship_id in ('1c686f40-9810-5a30-a41b-d58c033e6a55','23824025-afd6-5d99-a71a-f2b04c27cc17','3b42346b-3d61-5663-a94f-d76141b10fc3','67ef3848-c442-5d8b-ae71-0a649d1924c7');
-- (then refresh their courses: select search.refresh_course_enrichment_scoped_v1(array[...course ids...], true);)

commit;
