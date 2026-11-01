-- CF-247 E16 containment, group (a): the governed SS-007 hold (security.binding_remediation_apply_v1) for the 12 confirmed courses whose page
-- binding is exactly the wrong page. PREPARED READ-ONLY 2 NOV 2026 (after search refresh #7725, v2.15.402). NOT RUN. For the integrator (postgres).
-- Project fxcwkweaxjtknorudmwp only.
-- Authority: Platform Admin 2 Nov 2026 07:21 AEDT, E16 final disposition decision section 2 (quarantine unsupported or demonstrably incorrect
--   published course links through the existing governed hold mechanism). The E16 classification is a candidate assessment, not proof.
-- Live state at 09:25 AEDT (read-only): all 12 still show the wrong page in search.course_documents.official_course_url; each binding is
--   status 'bound', basis not manual, no hand lock, not held, course active; 12 active wrong links (UTS: the ?student=international spelling,
--   passed as also_links). Function md5 532863b38e0637730f5290b1e4263bf4 (unchanged by v2.15.402).
-- What the function does per course (SS-007 migration 20261031030000): one course_remediation_holds row with the full before state; one
--   page_rejections row (source binding_remediation); binding -> 'mismatch'; active official links on that page -> 'unverified', not primary;
--   one search.refresh_requests row per batch. Nothing deleted.
-- Recurrence after the hold: exit_awards_apply_v2 line 25 skips a held course (security.course_held_v1) and a refused page; the binding guard
--   keeps a held course's binding (SS-007 edit); search, page-read and AI-match lanes skip held courses. Collarts 118491G/118493E, Flinders
--   105122F and Torrens 089932J have adapter exit-award rows with register_check 'fail' (set_by adapter), already skipped at line 20.
-- Side effect to accept first (open decision D4 from e16plan/report.md): job course-url-fill (guard 3) retracts courses.course_url for the 12;
--   the 30-day retraction rate was 4.97% on 2 Nov 07:29 and is expected to pass the 5% limit (course_url.max_retraction_pct), which pauses
--   course_url.fill_enabled platform-wide on the job's next run. Accept and re-enable with a reason, or raise the limit with a reason beforehand.
-- Layer 4: the hold does not create a Layer 4 item. layer4.sql raises one course-link item per course through security.binding_refusal_route_v1.
-- Order: this file, then contain-links.sql, then fees.sql, then layer4.sql. Run in an allowed minute (:x5-:x8, not :35-:42), not within 3 minutes
--   before :37.

-- 0. Read-only pre-check (expect 12 rows, every column ok = true). Stop if any row is false.
select v.code, v.course_id,
       g.url = v.url and g.status = 'bound' and coalesce(g.basis,'') <> 'manual' and g.provider_id = v.provider ok_binding,
       not exists (select 1 from pipeline.manual_locks k where k.entity='course' and k.entity_id=v.course_id and k.field in ('official_url','course_url')) ok_no_lock,
       not security.course_held_v1(v.course_id) ok_not_held,
       (select c.lifecycle_status='active' from catalogue.courses c where c.id=v.course_id) ok_active,
       (select count(*) from catalogue.course_links l where l.course_id=v.course_id and l.link_type='official_course' and l.status='active' and (l.url=v.url or l.url=v.also)) = 1 ok_one_wrong_link,
       (select md5(pg_get_functiondef('security.binding_remediation_apply_v1(uuid,jsonb,integer,text,text)'::regprocedure))) = '532863b38e0637730f5290b1e4263bf4' ok_fn
  from pipeline.coverage_course_pages g join (values
  ('0101290', '7cf958c9-c317-4a77-868c-3ba802174d1d'::uuid, '739948f6-6338-4ee9-8d0c-a8c8e953c29d'::uuid, 'https://bond.edu.au/program/graduate-diploma-project-management/graduate_outcomes', null),
  ('098314E', 'a940f900-bfa0-43a8-bba1-1e60c922a699'::uuid, '739948f6-6338-4ee9-8d0c-a8c8e953c29d'::uuid, 'https://bond.edu.au/program/bachelor-of-actuarial-science-honours/graduate_outcomes', null),
  ('107662F', 'f5baa817-87a6-4f2d-a57f-a02b9e9dd90a'::uuid, '739948f6-6338-4ee9-8d0c-a8c8e953c29d'::uuid, 'https://bond.edu.au/program/bachelor-of-global-studies-sustainability/graduate_outcomes', null),
  ('118491G', 'a0195518-e6a5-4663-88d4-677bd9c8d0b1'::uuid, '53eaf404-8f22-46ff-a208-b0e82da4284e'::uuid, 'https://www.collarts.edu.au/courses/postgraduate-progams/master-of-creative-industries/', null),
  ('118493E', '02c7bc01-0cc8-40bd-a190-b6eea143f3a5'::uuid, '53eaf404-8f22-46ff-a208-b0e82da4284e'::uuid, 'https://www.collarts.edu.au/courses/postgraduate-progams/master-of-creative-industries/', null),
  ('105122F', '486ed99f-09f3-4ef5-9649-1dec1d9878d8'::uuid, '0a42da16-8df1-4439-a929-4dfdd04b6d83'::uuid, 'https://www.flinders.edu.au/study/courses/postgraduate-master-computer-science', null),
  ('109071B', '7f9cffdb-54ae-47e3-a595-edac98cd0dd6'::uuid, '2ad1287c-34a3-44df-b5f3-cf4d8b12d404'::uuid, 'https://sistc.edu.au/courses/postgraduate-courses/master-of-information-technology/', null),
  ('116548M', '1b78ba46-638c-4465-859e-8689e96295a8'::uuid, 'e55396d2-869a-46ef-9d17-841c7eab1313'::uuid, 'https://study.uq.edu.au/study-options/programs/bachelor-nutrition-sciences-master-dietetics-studies-2534', null),
  ('000723J', '0d25903f-de8e-460c-b403-2648148fcadd'::uuid, '68022bdf-43e8-44b3-ac14-e9eed9f71e83'::uuid, 'https://www.sydney.edu.au/courses/courses/uc/bachelor-of-pharmacy-honours-and-master-of-pharmacy-practice.html', null),
  ('105221C', '33ded954-9998-43ff-9384-c3ca6788d54f'::uuid, '68022bdf-43e8-44b3-ac14-e9eed9f71e83'::uuid, 'https://www.sydney.edu.au/courses/courses/uc/bachelor-of-pharmacy-honours-and-master-of-pharmacy-practice.html', null),
  ('089932J', '51b27099-8086-4c68-9b9f-04c74af883f6'::uuid, 'fec52f92-a8a3-4de8-a862-06f355e4e2f7'::uuid, 'https://www.torrens.edu.au/courses/hospitality/master-of-international-hotel-management', null),
  ('114585M', 'dd5f7176-0ca9-462c-b399-4f05d06c5e67'::uuid, '9d22a19e-c3f7-4012-b738-17bc0b481e7f'::uuid, 'https://www.uts.edu.au/courses/bachelor-of-education-futures-master-of-teaching-in-primary-education', 'https://www.uts.edu.au/courses/bachelor-of-education-futures-master-of-teaching-in-primary-education?student=international&type=international')
) v(code, course_id, provider, url, also) on g.course_id = v.course_id order by v.code;

-- Bond University Limited (0101290, 098314E, 107662F): p_expected 3
begin;
select security.binding_remediation_apply_v1(
  '739948f6-6338-4ee9-8d0c-a8c8e953c29d'::uuid,
  '[{"course_id": "7cf958c9-c317-4a77-868c-3ba802174d1d", "url": "https://bond.edu.au/program/graduate-diploma-project-management/graduate_outcomes", "class": "E16 sibling_award", "also_links": []}, {"course_id": "a940f900-bfa0-43a8-bba1-1e60c922a699", "url": "https://bond.edu.au/program/bachelor-of-actuarial-science-honours/graduate_outcomes", "class": "E16 sibling_award", "also_links": []}, {"course_id": "f5baa817-87a6-4f2d-a57f-a02b9e9dd90a", "url": "https://bond.edu.au/program/bachelor-of-global-studies-sustainability/graduate_outcomes", "class": "E16 sibling_award", "also_links": []}]'::jsonb,
  3,
  'Platform Admin 2 Nov 2026 07:21 AEDT: E16 final disposition decision (2026-11-02-e16-final-disposition-decision.md) section 2',
  'E16 containment: the official link shown is a sibling-award or older-year page (candidate assessment from title and URL, e16-sibling-variant-cohort-2026-11-02.csv); quarantined pending Layer 4 review');
-- read-back before commit: expect 3 open holds from this approval and no active link left on the reviewed page(s)
select h.course_id, h.batch_id, h.after->>'links_unverified' links_unverified,
       (select count(*) from catalogue.course_links l where l.course_id=h.course_id and l.link_type='official_course' and l.status='active' and l.url=h.url) still_active
  from pipeline.course_remediation_holds h where h.course_id = any(array['7cf958c9-c317-4a77-868c-3ba802174d1d','a940f900-bfa0-43a8-bba1-1e60c922a699','f5baa817-87a6-4f2d-a57f-a02b9e9dd90a']::uuid[]) and h.lifted_at is null;
commit;

-- Collarts (118491G, 118493E): p_expected 2
begin;
select security.binding_remediation_apply_v1(
  '53eaf404-8f22-46ff-a208-b0e82da4284e'::uuid,
  '[{"course_id": "a0195518-e6a5-4663-88d4-677bd9c8d0b1", "url": "https://www.collarts.edu.au/courses/postgraduate-progams/master-of-creative-industries/", "class": "E16 sibling_award", "also_links": []}, {"course_id": "02c7bc01-0cc8-40bd-a190-b6eea143f3a5", "url": "https://www.collarts.edu.au/courses/postgraduate-progams/master-of-creative-industries/", "class": "E16 sibling_award", "also_links": []}]'::jsonb,
  2,
  'Platform Admin 2 Nov 2026 07:21 AEDT: E16 final disposition decision (2026-11-02-e16-final-disposition-decision.md) section 2',
  'E16 containment: the official link shown is a sibling-award or older-year page (candidate assessment from title and URL, e16-sibling-variant-cohort-2026-11-02.csv); quarantined pending Layer 4 review');
-- read-back before commit: expect 2 open holds from this approval and no active link left on the reviewed page(s)
select h.course_id, h.batch_id, h.after->>'links_unverified' links_unverified,
       (select count(*) from catalogue.course_links l where l.course_id=h.course_id and l.link_type='official_course' and l.status='active' and l.url=h.url) still_active
  from pipeline.course_remediation_holds h where h.course_id = any(array['a0195518-e6a5-4663-88d4-677bd9c8d0b1','02c7bc01-0cc8-40bd-a190-b6eea143f3a5']::uuid[]) and h.lifted_at is null;
commit;

-- Flinders University (105122F): p_expected 1
begin;
select security.binding_remediation_apply_v1(
  '0a42da16-8df1-4439-a929-4dfdd04b6d83'::uuid,
  '[{"course_id": "486ed99f-09f3-4ef5-9649-1dec1d9878d8", "url": "https://www.flinders.edu.au/study/courses/postgraduate-master-computer-science", "class": "E16 sibling_award", "also_links": []}]'::jsonb,
  1,
  'Platform Admin 2 Nov 2026 07:21 AEDT: E16 final disposition decision (2026-11-02-e16-final-disposition-decision.md) section 2',
  'E16 containment: the official link shown is a sibling-award or older-year page (candidate assessment from title and URL, e16-sibling-variant-cohort-2026-11-02.csv); quarantined pending Layer 4 review');
-- read-back before commit: expect 1 open holds from this approval and no active link left on the reviewed page(s)
select h.course_id, h.batch_id, h.after->>'links_unverified' links_unverified,
       (select count(*) from catalogue.course_links l where l.course_id=h.course_id and l.link_type='official_course' and l.status='active' and l.url=h.url) still_active
  from pipeline.course_remediation_holds h where h.course_id = any(array['486ed99f-09f3-4ef5-9649-1dec1d9878d8']::uuid[]) and h.lifted_at is null;
commit;

-- Sydney International School of Technology and Commerce (109071B): p_expected 1
begin;
select security.binding_remediation_apply_v1(
  '2ad1287c-34a3-44df-b5f3-cf4d8b12d404'::uuid,
  '[{"course_id": "7f9cffdb-54ae-47e3-a595-edac98cd0dd6", "url": "https://sistc.edu.au/courses/postgraduate-courses/master-of-information-technology/", "class": "E16 sibling_award", "also_links": []}]'::jsonb,
  1,
  'Platform Admin 2 Nov 2026 07:21 AEDT: E16 final disposition decision (2026-11-02-e16-final-disposition-decision.md) section 2',
  'E16 containment: the official link shown is a sibling-award or older-year page (candidate assessment from title and URL, e16-sibling-variant-cohort-2026-11-02.csv); quarantined pending Layer 4 review');
-- read-back before commit: expect 1 open holds from this approval and no active link left on the reviewed page(s)
select h.course_id, h.batch_id, h.after->>'links_unverified' links_unverified,
       (select count(*) from catalogue.course_links l where l.course_id=h.course_id and l.link_type='official_course' and l.status='active' and l.url=h.url) still_active
  from pipeline.course_remediation_holds h where h.course_id = any(array['7f9cffdb-54ae-47e3-a595-edac98cd0dd6']::uuid[]) and h.lifted_at is null;
commit;

-- The University of Queensland (116548M): p_expected 1
begin;
select security.binding_remediation_apply_v1(
  'e55396d2-869a-46ef-9d17-841c7eab1313'::uuid,
  '[{"course_id": "1b78ba46-638c-4465-859e-8689e96295a8", "url": "https://study.uq.edu.au/study-options/programs/bachelor-nutrition-sciences-master-dietetics-studies-2534", "class": "E16 sibling_award", "also_links": []}]'::jsonb,
  1,
  'Platform Admin 2 Nov 2026 07:21 AEDT: E16 final disposition decision (2026-11-02-e16-final-disposition-decision.md) section 2',
  'E16 containment: the official link shown is a sibling-award or older-year page (candidate assessment from title and URL, e16-sibling-variant-cohort-2026-11-02.csv); quarantined pending Layer 4 review');
-- read-back before commit: expect 1 open holds from this approval and no active link left on the reviewed page(s)
select h.course_id, h.batch_id, h.after->>'links_unverified' links_unverified,
       (select count(*) from catalogue.course_links l where l.course_id=h.course_id and l.link_type='official_course' and l.status='active' and l.url=h.url) still_active
  from pipeline.course_remediation_holds h where h.course_id = any(array['1b78ba46-638c-4465-859e-8689e96295a8']::uuid[]) and h.lifted_at is null;
commit;

-- The University of Sydney (000723J, 105221C): p_expected 2
begin;
select security.binding_remediation_apply_v1(
  '68022bdf-43e8-44b3-ac14-e9eed9f71e83'::uuid,
  '[{"course_id": "0d25903f-de8e-460c-b403-2648148fcadd", "url": "https://www.sydney.edu.au/courses/courses/uc/bachelor-of-pharmacy-honours-and-master-of-pharmacy-practice.html", "class": "E16 sibling_award", "also_links": []}, {"course_id": "33ded954-9998-43ff-9384-c3ca6788d54f", "url": "https://www.sydney.edu.au/courses/courses/uc/bachelor-of-pharmacy-honours-and-master-of-pharmacy-practice.html", "class": "E16 sibling_award", "also_links": []}]'::jsonb,
  2,
  'Platform Admin 2 Nov 2026 07:21 AEDT: E16 final disposition decision (2026-11-02-e16-final-disposition-decision.md) section 2',
  'E16 containment: the official link shown is a sibling-award or older-year page (candidate assessment from title and URL, e16-sibling-variant-cohort-2026-11-02.csv); quarantined pending Layer 4 review');
-- read-back before commit: expect 2 open holds from this approval and no active link left on the reviewed page(s)
select h.course_id, h.batch_id, h.after->>'links_unverified' links_unverified,
       (select count(*) from catalogue.course_links l where l.course_id=h.course_id and l.link_type='official_course' and l.status='active' and l.url=h.url) still_active
  from pipeline.course_remediation_holds h where h.course_id = any(array['0d25903f-de8e-460c-b403-2648148fcadd','33ded954-9998-43ff-9384-c3ca6788d54f']::uuid[]) and h.lifted_at is null;
commit;

-- Torrens University Australia; Torrens University Language Centre; Chifley Business School  (089932J): p_expected 1
begin;
select security.binding_remediation_apply_v1(
  'fec52f92-a8a3-4de8-a862-06f355e4e2f7'::uuid,
  '[{"course_id": "51b27099-8086-4c68-9b9f-04c74af883f6", "url": "https://www.torrens.edu.au/courses/hospitality/master-of-international-hotel-management", "class": "E16 sibling_award", "also_links": []}]'::jsonb,
  1,
  'Platform Admin 2 Nov 2026 07:21 AEDT: E16 final disposition decision (2026-11-02-e16-final-disposition-decision.md) section 2',
  'E16 containment: the official link shown is a sibling-award or older-year page (candidate assessment from title and URL, e16-sibling-variant-cohort-2026-11-02.csv); quarantined pending Layer 4 review');
-- read-back before commit: expect 1 open holds from this approval and no active link left on the reviewed page(s)
select h.course_id, h.batch_id, h.after->>'links_unverified' links_unverified,
       (select count(*) from catalogue.course_links l where l.course_id=h.course_id and l.link_type='official_course' and l.status='active' and l.url=h.url) still_active
  from pipeline.course_remediation_holds h where h.course_id = any(array['51b27099-8086-4c68-9b9f-04c74af883f6']::uuid[]) and h.lifted_at is null;
commit;

-- University of Technology Sydney (UTS) (114585M): p_expected 1
begin;
select security.binding_remediation_apply_v1(
  '9d22a19e-c3f7-4012-b738-17bc0b481e7f'::uuid,
  '[{"course_id": "dd5f7176-0ca9-462c-b399-4f05d06c5e67", "url": "https://www.uts.edu.au/courses/bachelor-of-education-futures-master-of-teaching-in-primary-education", "class": "E16 sibling_award", "also_links": ["https://www.uts.edu.au/courses/bachelor-of-education-futures-master-of-teaching-in-primary-education?student=international&type=international"]}]'::jsonb,
  1,
  'Platform Admin 2 Nov 2026 07:21 AEDT: E16 final disposition decision (2026-11-02-e16-final-disposition-decision.md) section 2',
  'E16 containment: the official link shown is a sibling-award or older-year page (candidate assessment from title and URL, e16-sibling-variant-cohort-2026-11-02.csv); quarantined pending Layer 4 review');
-- read-back before commit: expect 1 open holds from this approval and no active link left on the reviewed page(s)
select h.course_id, h.batch_id, h.after->>'links_unverified' links_unverified,
       (select count(*) from catalogue.course_links l where l.course_id=h.course_id and l.link_type='official_course' and l.status='active' and l.url=h.url) still_active
  from pipeline.course_remediation_holds h where h.course_id = any(array['dd5f7176-0ca9-462c-b399-4f05d06c5e67']::uuid[]) and h.lifted_at is null;
commit;

-- After all 8 batches: expect 12 open holds, 12 rejections (source binding_remediation, or an earlier rejection kept), 12 links unverified.
-- After the next search refresh (search.refresh_requests rows written by the function), read back:
--   select d.course_id, d.official_course_url from search.course_documents d where d.course_id = any(<the 12 ids>);   -- expect null on all 12
--   (prediction from live links: none of the 12 keeps another active official link, so each shows no link; website item official_url null, Zoho
--    official_course_url null).
-- 12 course ids md5 (sorted, comma-joined): c32e8f7a59dc91d1927e9f96d5ecf032.

-- ROLLBACK (per course; Platform Admin): restore the binding and the official link exactly as before (rejection added by this hold is removed
-- only when none existed before, per the function):
--   select security.binding_remediation_lift_v1('<course_id>'::uuid, 'restore', 'E16 containment rolled back: <reason>');
-- or hand the course back to the normal lanes and keep the page rejected:
--   select security.binding_remediation_lift_v1('<course_id>'::uuid, 'release', '<reason>');
