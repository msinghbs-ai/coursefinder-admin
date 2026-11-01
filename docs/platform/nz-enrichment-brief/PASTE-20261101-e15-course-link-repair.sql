-- CF-247 E15 data repair (paste file for the Platform Admin; not a migration). Project fxcwkweaxjtknorudmwp.
-- Prepared 1 Nov 2026 from read-only queries. Nothing is deleted: superseded links become 'inactive' and stay for history.
-- Each block is count-guarded: it checks every row it touches is exactly as read on 1 Nov, otherwise it raises and changes nothing.

-- ===== Part 1: four TAFE courses decided "Use the new page" on 30 Oct that hold two active official links =====
-- course 8e1fa1a8 (092518G)  old 4224e232 ...bachelor-of-business--1460     reviewer 716d752c ...bachelor-of-business--1349
-- course c1fe0a99 (107862J)  old a57ecf8c .../19/19060/diploma-of-screen... reviewer 59508a5b .../18/18476/diploma-of-screen...
-- course 0e86f5d1 (084563C)  old 4793c98d ...bachelor-of-fashion-design--1439 reviewer bda25d4e ...bachelor-of-fashion-design--1456
-- course 9a4ee5c5 (108538B)  old d3dd00de ...diploma-of-business--1351     reviewer 0f922674 ...diploma-of-business--1475
-- catalogue.courses.course_url already holds the reviewer's page for all four (set by course-url-fill at 02:23 on 30 Oct): not changed.
do $e15a$
declare
  v_courses uuid[] := array['8e1fa1a8-7ff6-454b-9138-6b228f969a15','c1fe0a99-75c1-43ab-a172-b0ce73eb0788','0e86f5d1-400b-48a8-8f09-f48eb70a1b60','9a4ee5c5-ca06-4892-af6f-e452fcd9e4a5']::uuid[];
  v_old uuid[] := array['4224e232-693c-45bc-8453-94ad19dc835e','a57ecf8c-1f16-4154-96e7-265125156d2e','4793c98d-0d3c-40a7-9846-56833c9d9d11','d3dd00de-c8f5-48c6-bb22-50d6d5ec24d4']::uuid[];
  v_new uuid[] := array['716d752c-5b13-4568-bea5-9e35a8ee397e','59508a5b-7ca0-40bc-ab52-28c96adf7182','bda25d4e-88a4-459c-8469-80afb9d6bebc','0f922674-2cbe-43e9-9c59-96945e316b8d']::uuid[];
  v_n int;
begin
  -- guards: 8 official links, all active and not primary; exactly these 8 active official links on the 4 courses; no active primary link;
  -- the reviewer link equals each course's course_url; no manual lock on these courses
  select count(*) into v_n from catalogue.course_links where id = any(v_old || v_new) and link_type = 'official_course' and status = 'active' and not is_primary;
  if v_n <> 8 then raise exception 'E15 part 1: expected 8 active non-primary links, found %', v_n; end if;
  select count(*) into v_n from catalogue.course_links where course_id = any(v_courses) and link_type = 'official_course' and status = 'active';
  if v_n <> 8 then raise exception 'E15 part 1: expected 8 active official links on the 4 courses, found %', v_n; end if;
  select count(*) into v_n from catalogue.course_links where course_id = any(v_courses) and status = 'active' and is_primary;
  if v_n <> 0 then raise exception 'E15 part 1: expected no active primary link, found %', v_n; end if;
  select count(*) into v_n from catalogue.course_links l join catalogue.courses c on c.id = l.course_id where l.id = any(v_new) and c.course_url = l.url;
  if v_n <> 4 then raise exception 'E15 part 1: expected course_url = reviewer page on 4 courses, found %', v_n; end if;
  select count(*) into v_n from pipeline.manual_locks where entity = 'course' and entity_id = any(v_courses);
  if v_n <> 0 then raise exception 'E15 part 1: a course is now locked by hand (% locks); stop and re-read', v_n; end if;

  update catalogue.course_links set status = 'inactive', is_primary = false, updated_at = now() where id = any(v_old) and status = 'active';
  get diagnostics v_n = row_count;
  if v_n <> 4 then raise exception 'E15 part 1: retired % links, expected 4', v_n; end if;
  update catalogue.course_links set is_primary = true, updated_at = now() where id = any(v_new) and status = 'active' and not is_primary;
  get diagnostics v_n = row_count;
  if v_n <> 4 then raise exception 'E15 part 1: made % links primary, expected 4', v_n; end if;

  perform search.refresh_course_enrichment_scoped_v1(v_courses, true);
  insert into pipeline.admin_control_events(area, action, target, detail, actor)
  values ('catalogue', 'e15_course_link_repair', 'catalogue.course_links',
          jsonb_build_object('part', 1, 'courses', to_jsonb(v_courses), 'made_inactive', to_jsonb(v_old), 'made_primary', to_jsonb(v_new),
                             'reason', 'E15: 30 Oct "Use the new page" left the previous official page active'), null);
end $e15a$;

-- Check after part 1 (expect 4 rows, one active official link each, primary, equal to course_url and to the website's official_url):
-- select l.course_id, count(*) filter (where l.status='active') active, bool_and(l.is_primary) filter (where l.status='active') prim,
--        max(l.url) filter (where l.status='active') = max(c.course_url) url_ok, max(d.official_course_url) = max(c.course_url) site_ok
--   from catalogue.course_links l join catalogue.courses c on c.id=l.course_id left join search.course_documents d on d.course_id=l.course_id
--  where l.course_id in ('8e1fa1a8-7ff6-454b-9138-6b228f969a15','c1fe0a99-75c1-43ab-a172-b0ce73eb0788','0e86f5d1-400b-48a8-8f09-f48eb70a1b60','9a4ee5c5-ca06-4892-af6f-e452fcd9e4a5')
--    and l.link_type='official_course' group by l.course_id;

-- Rollback of part 1 (restores the 1 Nov state exactly: both links active, neither primary):
-- update catalogue.course_links set status='active', updated_at=now() where id in ('4224e232-693c-45bc-8453-94ad19dc835e','a57ecf8c-1f16-4154-96e7-265125156d2e','4793c98d-0d3c-40a7-9846-56833c9d9d11','d3dd00de-c8f5-48c6-bb22-50d6d5ec24d4') and status='inactive';  -- expect 4
-- update catalogue.course_links set is_primary=false, updated_at=now() where id in ('716d752c-5b13-4568-bea5-9e35a8ee397e','59508a5b-7ca0-40bc-ab52-28c96adf7182','bda25d4e-88a4-459c-8469-80afb9d6bebc','0f922674-2cbe-43e9-9c59-96945e316b8d') and is_primary;  -- expect 4
-- select search.refresh_course_enrichment_scoped_v1(array['8e1fa1a8-7ff6-454b-9138-6b228f969a15','c1fe0a99-75c1-43ab-a172-b0ce73eb0788','0e86f5d1-400b-48a8-8f09-f48eb70a1b60','9a4ee5c5-ca06-4892-af6f-e452fcd9e4a5']::uuid[], true);


-- ===== Part 2: Waikato WI0194 and MITO 4226 — A DECISION FOR THE PLATFORM ADMIN BEFORE RUNNING =====
-- At 08:50 on 30 Oct the reviewer re-entered each course's own page on the course record ("Enter another address" on a held-fee item, batch
-- L4B-20261030-0816), which locked official_url and course_url. At 12:43 the same reviewer chose "Use the new page" on a new link item; the
-- lock guard skipped the insert silently, so the decision reads "approved" and nothing changed. The two choices conflict, and for Waikato the
-- held page is the /int/ international page bound on the Platform Admin instruction of 5 Oct 13:02, while the "new page" is the domestic path.
--   Option B (recommended, no data change): keep the hand-set pages. Record that the two 12:43 decisions were not applied (the block below
--     only writes an audit event).
--   Option A: apply the 12:43 decisions on the course record, as a hand edit would (the lock stays, now on the new page). Run the second block.

-- Option B: record only
-- insert into pipeline.admin_control_events(area, action, target, detail, actor)
-- values ('layer4', 'e15_decision_not_applied', 'pipeline.layer4_decisions',
--         jsonb_build_object('decisions', jsonb_build_array('202e4319-9162-4678-8ea0-165e0feb1130','1177c2f1-9598-4442-882f-a3392346bdcf'),
--                            'courses', jsonb_build_array('31fc82f7-0303-4401-8207-4179658edab6','f26df112-b419-439f-bd1b-60ce24190565'),
--                            'reason', 'E15: page set by hand at 08:50 (manual lock); the 12:43 approval was skipped by the lock guard. Platform Admin kept the hand-set pages.'), null);

-- Option A: apply the 12:43 decisions (only if the Platform Admin chooses A)
-- do $e15b$
-- declare v_n int;
--   v_c uuid[] := array['31fc82f7-0303-4401-8207-4179658edab6','f26df112-b419-439f-bd1b-60ce24190565']::uuid[];
--   v_old uuid[] := array['5e31147e-1542-40aa-8b37-6d611d2f5f2c','75355ee6-b485-4f88-95d2-0fa1a17452db']::uuid[];
-- begin
--   select count(*) into v_n from catalogue.course_links where id = any(v_old) and link_type='official_course' and status='active' and is_primary;
--   if v_n <> 2 then raise exception 'E15 part 2: expected the 2 hand-set links active and primary, found %', v_n; end if;
--   select count(*) into v_n from catalogue.course_links where course_id = any(v_c) and link_type='official_course' and status='active';
--   if v_n <> 2 then raise exception 'E15 part 2: expected 2 active official links on the 2 courses, found %', v_n; end if;
--   select count(*) into v_n from catalogue.courses where id = any(v_c) and course_url in ('https://www.waikato.ac.nz/int/study/qualifications/certificate-of-attainment-in-english-language/','https://www.mito.org.nz/programmes/automotive/coachbuilding-level4');
--   if v_n <> 2 then raise exception 'E15 part 2: course_url changed since 1 Nov (% match)', v_n; end if;
--   perform set_config('cf.manual_edit', 'on', true);  -- a hand edit by the Platform Admin, as public.admin_course_edit does
--   update catalogue.course_links set status='inactive', is_primary=false, updated_at=now() where id = any(v_old) and status='active';
--   get diagnostics v_n = row_count; if v_n <> 2 then raise exception 'E15 part 2: retired %, expected 2', v_n; end if;
--   insert into catalogue.course_links(course_id, link_type, url, audience, label, is_primary, status, source_id, confidence, last_verified_at, updated_at)
--   values ('31fc82f7-0303-4401-8207-4179658edab6','official_course','https://www.waikato.ac.nz/study/qualifications/certificate-of-attainment-in-english-language/','international','Official course page',true,'active',(select id from pipeline.sources where source_type='manual_entry' limit 1),1,now(),now()),
--          ('f26df112-b419-439f-bd1b-60ce24190565','official_course','https://www.mito.org.nz/programmes/automotive/coachbuilding','international','Official course page',true,'active',(select id from pipeline.sources where source_type='manual_entry' limit 1),1,now(),now());
--   update catalogue.courses set course_url='https://www.waikato.ac.nz/study/qualifications/certificate-of-attainment-in-english-language/', updated_at=now() where id='31fc82f7-0303-4401-8207-4179658edab6';
--   update catalogue.courses set course_url='https://www.mito.org.nz/programmes/automotive/coachbuilding', updated_at=now() where id='f26df112-b419-439f-bd1b-60ce24190565';
--   update pipeline.coverage_course_pages p set url=v.u, basis='manual', status='bound', bound_at=now(), next_read_at=now(), read_attempts=0, leased_until=null
--     from (values ('31fc82f7-0303-4401-8207-4179658edab6'::uuid,'https://www.waikato.ac.nz/study/qualifications/certificate-of-attainment-in-english-language/'),
--                  ('f26df112-b419-439f-bd1b-60ce24190565'::uuid,'https://www.mito.org.nz/programmes/automotive/coachbuilding')) v(c,u) where p.course_id=v.c;
--   get diagnostics v_n = row_count; if v_n <> 2 then raise exception 'E15 part 2: rebound % course pages, expected 2', v_n; end if;
--   perform search.refresh_course_enrichment_scoped_v1(v_c, true);
--   insert into pipeline.admin_control_events(area, action, target, detail, actor)
--   values ('catalogue','e15_course_link_repair','catalogue.course_links', jsonb_build_object('part',2,'courses',to_jsonb(v_c),'made_inactive',to_jsonb(v_old),
--           'reason','E15: Platform Admin applied the 30 Oct 12:43 decisions (Use the new page) on the course record'), null);
-- end $e15b$;
-- Rollback of option A: as a hand edit — set the two old links (5e31147e..., 75355ee6...) active and primary after making the two new links
-- inactive and not primary (same cf.manual_edit setting), restore course_url to the /int/ and -level4 pages and rebind coverage_course_pages to them.
