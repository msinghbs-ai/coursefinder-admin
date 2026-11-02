-- CF-247 E16 containment, group (a): 12 wrong official links whose page binding IS the wrong page (Decision 1, option 2).
-- PASTE FILE PREPARED READ-ONLY 2 NOV 2026 11:05-12:27 AEDT. NOT RUN. Not a migration. Pattern: contain-links.sql part B (lines 27-109),
-- executed 10:05 as event #28603. Project fxcwkweaxjtknorudmwp only. Run as postgres, one production writer (the integrator).
-- Run in an allowed minute: admission jobs are now coverage-admit :x3, coverage-admit-intakes :x5, adapter-overwrite :x9 (read 12:16),
--   so use :x6-:x8, never :35-:42, and not in the 3 minutes before :37. Re-check cron.job first (the stagger may move again).
-- Authority: Platform Admin consolidated decision pack 2 Nov 2026 10:56, Decision 1 ("APPROVED APPROACH: Option 2 - targeted link
--   containment ... same reversible method previously applied to E16 Part B ... Do not use the SS-007 hold where doing so unnecessarily
--   pauses course-url-fill platform-wide. Verify the exact 12-record cohort against current production before applying").
--   security.binding_remediation_apply_v1 is NOT used. courses.course_url is NOT touched. pipeline.course_url_fills is NOT touched.
--
-- LIVE COHORT RE-VERIFIED 2 Nov 10:57-12:17 AEDT (read-only, keyed by these ids):
--   * 12 courses, 12 active official links (exactly one per course), every one shown: search.course_documents.official_course_url = the link.
--   * course ids md5 c32e8f7a59dc91d1927e9f96d5ecf032 = the apply-hold.sql cohort (unchanged). Link ids md5 below.
--   * 0 hand locks (official_url, course_url); 0 links from manual_entry / layer4_human_review (all source_type provider_course_page_sweep);
--     0 open remediation holds; 0 page_rejections rows; 0 Layer 4 course-link items (any status); all 12 courses active.
--   * Spellings: 11 links equal the reviewed wrong URL exactly. UTS 114585M: the active link is the reviewed spelling
--     '...primary-education?student=international&type=international' (= the binding's final_url); the bare address is already 'inactive'
--     and blocked (pipeline.course_page_blocks), so it is not in this file.
--   * Already blocked (course_page_blocks, so security.page_refused_v1 = true) yet still active and shown: Sydney 000723J and 105221C.
--     Guard 5 of part B ("page not already refused") would stop on these two, so guard 5 here checks page_rejections only and asserts the
--     exact known block count (2).
--
-- WHY THIS FILE HAS ONE STEP MORE THAN PART B (integrator to accept or stop; see report.md section 2):
--   Part B's bindings were not on the wrong page. Group (a)'s are: pipeline.coverage_course_pages is status 'bound', read_status 'read',
--   identity_basis cricos_code (8) or exact_title (4), extractor coverage-sweep-v0.5.6, on the wrong page, for all 12. Live
--   security.coverage_admission_plan_v1 (md5 f9dceaf2ff05e2b410d06ed968cfcac0) proposes official_url = coalesce(final_url, url) with action
--   'write' whenever the course has no ACTIVE official link; it checks course_held_v1 and Layer 4 blocks, NOT page_refused_v1. Job
--   coverage-admit (security.coverage_admission_gated_v1('coverage-admit', ..., 'coverage-sweep-v0.5.6', array['official_url','english']))
--   then calls public.svc_coursefacts_apply_record, whose link upsert is
--     on conflict(course_id,link_type,url) do update set ... status='active' ...
--   and no trigger on catalogue.course_links checks rejections or holds. So setting the link 'unverified' alone (part B exactly) is undone
--   by the next coverage-admit run that does a full pass (input mark change, or at most waste.admit_full_check_hours = 6 h).
--   The smallest stop that does NOT pause course-url-fill: mark the binding read_status 'page_refused' and next_read_at null, keeping
--   status 'bound', url, evidence_id and identity_basis unchanged:
--     - coverage_admission_plan_v1 requires p.read_status = 'read'  -> not proposed again;
--     - security.course_url_fill_v1 guard 3 retracts only when status <> 'bound' or evidence_id changes -> no retraction, no pause;
--     - trigger coverage_page_refused_host fires only on update of url, status, identity_basis -> not fired;
--     - re-read lanes pick next_read_at <= now() or read_status null/fetch_failed/blocked -> not re-read;
--     - enrich_fields_slice_v1 already requires read_status 'read' -> no AI read of the wrong page.
--   'page_refused' is the existing value the binding guard writes for a refused page (migration 20261102030000 line 364).
--   If the integrator does not accept this step, do not run the file: part B alone would show the link again within hours.
--
-- What the block does: links -> 'unverified', not primary; one pipeline.page_rejections row each (source 'e16_containment', tag
--   'e16_containment_a'); bindings -> read_status 'page_refused', next_read_at null; scoped search refresh + a refresh request; one
--   pipeline.admin_control_events row with the full before state (links and bindings) and the after state. Nothing deleted.
-- Predicted consumer effect after the refresh: 12 of 12 show no official link (no other active official link on any of them; projection
--   search.refresh_course_enrichment_core_scoped_v1 md5 5b45bbf1e39d9098d5f23de729418b2d takes official_course_url only from active links).
--   Website item.official_url and Zoho item.official_course_url read that column: null on all 12. No other field changes.
-- Link ids md5 (sorted, comma-joined): fb9151ed0b33fe3b4de09f425bdcb64d.  Course ids md5: c32e8f7a59dc91d1927e9f96d5ecf032.

begin;
do $e16a$
declare
  v_n int; v_md5 text; v_before jsonb; v_bind jsonb; v_courses uuid[];
begin
  create temp table e16_a(link_id uuid, course_id uuid, provider_id uuid, url_md5 text, was_primary boolean, evidence_id uuid, code text, bind_url_md5 text, bind_evidence uuid) on commit drop;
  insert into e16_a values
    ('8e8b2530-189b-40d8-b88b-da9642b3793d'::uuid, '0d25903f-de8e-460c-b403-2648148fcadd'::uuid, '68022bdf-43e8-44b3-ac14-e9eed9f71e83'::uuid, '99eb6fafd942b972094b73a624d58c03', false, '6d7348a0-b065-44bb-b668-45f878c5237a'::uuid, '000723J', '99eb6fafd942b972094b73a624d58c03', '6d7348a0-b065-44bb-b668-45f878c5237a'::uuid),
    ('fe63f690-ec2f-4ea7-8396-99801a198d86'::uuid, '7cf958c9-c317-4a77-868c-3ba802174d1d'::uuid, '739948f6-6338-4ee9-8d0c-a8c8e953c29d'::uuid, '969513eefcf07de94e1dbed0ceefaf29', false, '4c1c791d-e882-42f8-b778-690e652e18ec'::uuid, '0101290', '969513eefcf07de94e1dbed0ceefaf29', '1da59216-94d9-409d-b15a-2746f6a058e0'::uuid),
    ('ae0f8921-0dee-42b2-9436-799b1bb177de'::uuid, '51b27099-8086-4c68-9b9f-04c74af883f6'::uuid, 'fec52f92-a8a3-4de8-a862-06f355e4e2f7'::uuid, 'a5d8134e5d647949ae1e38ccd972d4b5', false, '4f5a3bf0-867a-4405-9bb4-e57bfa528723'::uuid, '089932J', 'a5d8134e5d647949ae1e38ccd972d4b5', '2e4be12a-db1e-4dd7-8224-0527a7a04c29'::uuid),
    ('a012cff5-3d76-4137-aeab-db57437d05d2'::uuid, 'a940f900-bfa0-43a8-bba1-1e60c922a699'::uuid, '739948f6-6338-4ee9-8d0c-a8c8e953c29d'::uuid, '3bd7c826818637f0948e775a4f2439d9', false, 'e86a58f4-61a8-44cf-a9d4-1f7a800a72c1'::uuid, '098314E', '3bd7c826818637f0948e775a4f2439d9', '6b82f659-0166-44f6-bfce-7e99ff026755'::uuid),
    ('1490978f-f783-4008-b121-2484c21fe553'::uuid, '486ed99f-09f3-4ef5-9649-1dec1d9878d8'::uuid, '0a42da16-8df1-4439-a929-4dfdd04b6d83'::uuid, '5d71934397dccf31251b2c4f8ff4b4e8', false, '7be3c2d1-99f9-46b0-a487-9d5420892bd2'::uuid, '105122F', '5d71934397dccf31251b2c4f8ff4b4e8', 'b8defab6-c165-405d-ab9a-1cefee7a5771'::uuid),
    ('e9550efb-29fe-47bb-b866-73dcfb70c0f1'::uuid, '33ded954-9998-43ff-9384-c3ca6788d54f'::uuid, '68022bdf-43e8-44b3-ac14-e9eed9f71e83'::uuid, '99eb6fafd942b972094b73a624d58c03', false, '6d7348a0-b065-44bb-b668-45f878c5237a'::uuid, '105221C', '99eb6fafd942b972094b73a624d58c03', '6d7348a0-b065-44bb-b668-45f878c5237a'::uuid),
    ('334e27a2-7a5f-4966-957c-b752fe7a2af8'::uuid, 'f5baa817-87a6-4f2d-a57f-a02b9e9dd90a'::uuid, '739948f6-6338-4ee9-8d0c-a8c8e953c29d'::uuid, 'a96746f19acc5de68fa9e28526db2f59', false, '13eb168d-830e-42d2-ac3c-104a50266a8d'::uuid, '107662F', 'a96746f19acc5de68fa9e28526db2f59', '986ba232-50c9-40ec-bfbb-4c4da2991ab0'::uuid),
    ('b97d43fa-3f45-4219-b644-59b03a2180a5'::uuid, '7f9cffdb-54ae-47e3-a595-edac98cd0dd6'::uuid, '2ad1287c-34a3-44df-b5f3-cf4d8b12d404'::uuid, '6efcd682fd5c91ba5fd6242465d20178', false, '36cedab5-9982-4a33-ad82-b39c2ef83a00'::uuid, '109071B', '6efcd682fd5c91ba5fd6242465d20178', '36cedab5-9982-4a33-ad82-b39c2ef83a00'::uuid),
    ('f6ed16e7-69c0-4ca6-aa55-5883309da116'::uuid, 'dd5f7176-0ca9-462c-b399-4f05d06c5e67'::uuid, '9d22a19e-c3f7-4012-b738-17bc0b481e7f'::uuid, '7cf57de884b5ef757f4b1d293440422b', false, 'a609609d-3721-40e0-a230-1346896bf2e6'::uuid, '114585M', '512aa70803c107a0cb3951bd9d893e30', 'a609609d-3721-40e0-a230-1346896bf2e6'::uuid),
    ('f6f2c69e-0127-4a28-a628-39f72d7f1deb'::uuid, '1b78ba46-638c-4465-859e-8689e96295a8'::uuid, 'e55396d2-869a-46ef-9d17-841c7eab1313'::uuid, '186a2c6925bb18b1ee93dbcd40fdb261', false, '35e7642f-2d26-4a32-9e50-89f4c195895c'::uuid, '116548M', '186a2c6925bb18b1ee93dbcd40fdb261', '3532dd60-bbdf-4e30-9aff-c71cd8c5f957'::uuid),
    ('352fe535-b15d-4bcf-bb3f-8e58cee88653'::uuid, 'a0195518-e6a5-4663-88d4-677bd9c8d0b1'::uuid, '53eaf404-8f22-46ff-a208-b0e82da4284e'::uuid, '4a61086b0fda9f6b25658496b56694fa', false, 'b96adc91-03d3-499b-b8e6-c2e48d13a9cd'::uuid, '118491G', '4a61086b0fda9f6b25658496b56694fa', 'b96adc91-03d3-499b-b8e6-c2e48d13a9cd'::uuid),
    ('1fd3852b-481b-4d3a-b2bc-b745bcab1b26'::uuid, '02c7bc01-0cc8-40bd-a190-b6eea143f3a5'::uuid, '53eaf404-8f22-46ff-a208-b0e82da4284e'::uuid, '4a61086b0fda9f6b25658496b56694fa', false, 'b96adc91-03d3-499b-b8e6-c2e48d13a9cd'::uuid, '118493E', '4a61086b0fda9f6b25658496b56694fa', 'b96adc91-03d3-499b-b8e6-c2e48d13a9cd'::uuid);
  -- guard 1: the exact id set
  select count(distinct link_id), md5(string_agg(link_id::text, ',' order by link_id)) into v_n, v_md5 from e16_a;
  if v_n <> 12 or v_md5 <> 'fb9151ed0b33fe3b4de09f425bdcb64d' then raise exception 'E16 part A guard 1: id set % / %', v_n, v_md5; end if;
  -- guard 2: each link is still the active official link on the same course, with the same address (md5) and primary flag as read on 2 Nov,
  --          and it is the course's only active official link (so the course shows nothing after this, not a different page)
  select count(*) into v_n from e16_a e join catalogue.course_links l on l.id = e.link_id
   where l.course_id = e.course_id and l.link_type = 'official_course' and l.status = 'active' and md5(l.url) = e.url_md5 and l.is_primary = e.was_primary
     and (select count(*) from catalogue.course_links o where o.course_id = e.course_id and o.link_type = 'official_course' and o.status = 'active') = 1;
  if v_n <> 12 then raise exception 'E16 part A guard 2: % of 12 links are exactly as read on 2 Nov; nothing changed', v_n; end if;
  -- guard 3: no hand lock on the course's official page or course URL
  select count(*) into v_n from pipeline.manual_locks k join e16_a e on k.entity = 'course' and k.entity_id = e.course_id and k.field in ('official_url', 'course_url');
  if v_n <> 0 then raise exception 'E16 part A guard 3: % hand locks; stop and re-read', v_n; end if;
  -- guard 4: not entered by hand or confirmed by a reviewer (source manual_entry or layer4_human_review)
  select count(*) into v_n from e16_a e join catalogue.course_links l on l.id = e.link_id join pipeline.sources so on so.id = l.source_id
   where so.source_type in ('manual_entry', 'layer4_human_review');
  if v_n <> 0 then raise exception 'E16 part A guard 4: % links were set by a person; stop', v_n; end if;
  -- guard 5: the course is still active and not under a remediation hold; no page rejection exists yet for this page; the only
  --          existing negative evidence is the 2 known Sydney course_page_blocks rows (read 2 Nov 11:05)
  select count(*) into v_n from e16_a e join catalogue.courses c on c.id = e.course_id join catalogue.course_links l on l.id = e.link_id
   where c.lifecycle_status = 'active' and not security.course_held_v1(e.course_id)
     and not exists (select 1 from pipeline.page_rejections r where r.course_id = e.course_id and r.url = l.url);
  if v_n <> 12 then raise exception 'E16 part A guard 5: % of 12 courses are active, not held and not already rejected', v_n; end if;
  select count(*) into v_n from e16_a e join catalogue.course_links l on l.id = e.link_id join pipeline.course_page_blocks b on b.course_id = e.course_id and b.url = l.url;
  if v_n <> 2 then raise exception 'E16 part A guard 5b: % blocked pages, expected the 2 Sydney rows; re-read', v_n; end if;
  -- guard 6: the consumer projection still shows this link (it is the exposed one)
  select count(*) into v_n from e16_a e join catalogue.course_links l on l.id = e.link_id join search.course_documents d on d.course_id = e.course_id
   where d.official_course_url = l.url;
  if v_n <> 12 then raise exception 'E16 part A guard 6: % of 12 courses still show this link; re-read before running', v_n; end if;
  -- guard 7: the binding is still the wrong page as read on 2 Nov (bound, read, same address and stored copy, not manual, no lease)
  select count(*) into v_n from e16_a e join pipeline.coverage_course_pages p on p.course_id = e.course_id
   where p.status = 'bound' and p.read_status = 'read' and md5(p.url) = e.bind_url_md5 and p.evidence_id = e.bind_evidence
     and coalesce(p.basis, '') <> 'manual' and coalesce(p.leased_until, '-infinity') < now();
  if v_n <> 12 then raise exception 'E16 part A guard 7: % of 12 bindings are exactly as read on 2 Nov; nothing changed', v_n; end if;

  select jsonb_agg(jsonb_build_object('link_id', l.id, 'course_id', l.course_id, 'code', e.code, 'url', l.url, 'status', l.status, 'is_primary', l.is_primary,
                                      'source_id', l.source_id, 'evidence_id', l.evidence_id, 'last_verified_at', l.last_verified_at, 'updated_at', l.updated_at) order by e.code),
         array_agg(distinct l.course_id)
    into v_before, v_courses
    from e16_a e join catalogue.course_links l on l.id = e.link_id;
  select jsonb_agg(jsonb_build_object('course_id', p.course_id, 'code', e.code, 'url', p.url, 'status', p.status, 'read_status', p.read_status,
                                      'next_read_at', p.next_read_at, 'evidence_id', p.evidence_id, 'identity_basis', p.identity_basis) order by e.code)
    into v_bind
    from e16_a e join pipeline.coverage_course_pages p on p.course_id = e.course_id;

  -- the link stops being shown: the existing status 'unverified', not primary (as part B). Nothing deleted.
  update catalogue.course_links l set status = 'unverified', is_primary = false, updated_at = now()
    from e16_a e where l.id = e.link_id and l.status = 'active';
  get diagnostics v_n = row_count;
  if v_n <> 12 then raise exception 'E16 part A: set % links unverified, expected 12; rolled back', v_n; end if;

  -- no lane binds or links this page to this course again (security.page_refused_v1: exit_awards_apply_v2, binding guard)
  insert into pipeline.page_rejections(course_id, url, provider_id, evidence_id, source, reason, signals)
  select e.course_id, l.url, e.provider_id, e.evidence_id, 'e16_containment',
         'E16 containment: the official link shown was another programme''s page (sibling award, double degree or parent master; candidate assessment from title and URL, cohort 2 Nov 2026); held from consumers pending Layer 4 review',
         jsonb_build_object('part', 'A', 'group', 'page binding is the wrong page (group a)', 'link_id', e.link_id, 'decision', 'Platform Admin consolidated decision pack 2 Nov 2026 10:56, Decision 1 option 2', 'tag', 'e16_containment_a')
    from e16_a e join catalogue.course_links l on l.id = e.link_id
  on conflict (course_id, url) do nothing;
  get diagnostics v_n = row_count;
  if v_n <> 12 then raise exception 'E16 part A: % page rejections written, expected 12; rolled back', v_n; end if;

  -- the admission lane does not propose the wrong page again (coverage_admission_plan_v1 needs read_status 'read'); status, url, stored
  -- copy and identity are unchanged, so course-url-fill guard 3 does not retract course_url and does not pause itself
  update pipeline.coverage_course_pages p set read_status = 'page_refused', next_read_at = null
    from e16_a e where p.course_id = e.course_id and p.status = 'bound' and p.read_status = 'read' and p.evidence_id = e.bind_evidence;
  get diagnostics v_n = row_count;
  if v_n <> 12 then raise exception 'E16 part A: marked % bindings, expected 12; rolled back', v_n; end if;

  perform search.refresh_course_enrichment_scoped_v1(v_courses, true);
  insert into search.refresh_requests(requested_by) values ('E16 containment part A: 12 wrong official links set unverified');
  insert into pipeline.admin_control_events(area, action, target, detail, actor)
  values ('catalogue', 'e16_course_link_containment', 'catalogue.course_links',
          jsonb_build_object('part', 'A', 'group', 'page binding is the wrong page (group a)', 'count', 12, 'ids_md5', 'fb9151ed0b33fe3b4de09f425bdcb64d',
                             'course_ids_md5', 'c32e8f7a59dc91d1927e9f96d5ecf032',
                             'before', v_before, 'bindings_before', v_bind,
                             'after', jsonb_build_object('status', 'unverified', 'is_primary', false, 'page_rejection_source', 'e16_containment',
                                                         'binding_read_status', 'page_refused', 'binding_next_read_at', null),
                             'reason', 'E16 containment: confirmed (candidate) wrong-programme destination shown to consumers; SS-007 hold not used (Decision 1)',
                             'decision', 'Platform Admin consolidated decision pack 2 Nov 2026 10:56, Decision 1 option 2',
                             'rollback', 'contain-links-A.sql rollback block'), null);
end $e16a$;
-- read-back before commit: expect 12 unverified, 12 rejections tagged e16_containment_a, 12 bindings bound + page_refused
select l.status, count(*) from catalogue.course_links l where l.id = any(array['1490978f-f783-4008-b121-2484c21fe553','1fd3852b-481b-4d3a-b2bc-b745bcab1b26','334e27a2-7a5f-4966-957c-b752fe7a2af8','352fe535-b15d-4bcf-bb3f-8e58cee88653','8e8b2530-189b-40d8-b88b-da9642b3793d','a012cff5-3d76-4137-aeab-db57437d05d2','ae0f8921-0dee-42b2-9436-799b1bb177de','b97d43fa-3f45-4219-b644-59b03a2180a5','e9550efb-29fe-47bb-b866-73dcfb70c0f1','f6ed16e7-69c0-4ca6-aa55-5883309da116','f6f2c69e-0127-4a28-a628-39f72d7f1deb','fe63f690-ec2f-4ea7-8396-99801a198d86']::uuid[]) group by 1;
select count(*) rejections from pipeline.page_rejections where source = 'e16_containment' and signals->>'tag' = 'e16_containment_a';
select p.status, p.read_status, count(*) from pipeline.coverage_course_pages p where p.course_id = any(array['7cf958c9-c317-4a77-868c-3ba802174d1d','a940f900-bfa0-43a8-bba1-1e60c922a699','f5baa817-87a6-4f2d-a57f-a02b9e9dd90a','a0195518-e6a5-4663-88d4-677bd9c8d0b1','02c7bc01-0cc8-40bd-a190-b6eea143f3a5','486ed99f-09f3-4ef5-9649-1dec1d9878d8','7f9cffdb-54ae-47e3-a595-edac98cd0dd6','1b78ba46-638c-4465-859e-8689e96295a8','0d25903f-de8e-460c-b403-2648148fcadd','33ded954-9998-43ff-9384-c3ca6788d54f','51b27099-8086-4c68-9b9f-04c74af883f6','dd5f7176-0ca9-462c-b399-4f05d06c5e67']::uuid[]) group by 1, 2;
commit;

-- After commit (and after the next coverage-admit run at :x3, the stated recurrence test), read back:
--   select d.course_id, d.official_course_url from search.course_documents d where d.course_id = any(<the 12 course ids>);   -- expect 12 x null
--   select l.status, count(*) from catalogue.course_links l where l.id = any(<the 12 link ids>) group by 1;                   -- expect 12 unverified
--   select count(*) from pipeline.course_url_fills where course_id = any(<the 12 course ids>) and retracted_at > now() - interval '1 day';  -- expect 0
--   website public.website_v2_course(code) -> item.official_url, Zoho public.zoho_edge_course_lookup_v1(code) -> item.official_course_url: null.

-- ROLLBACK of part A (restores link status and primary flag, and the binding's read_status and next_read_at, from the audit row; the page
-- rejections stay unless the Platform Admin separately removes them, because pipeline.page_rejections is documented as never deleted):
-- begin;
-- do $e16ar$
-- declare v_n int; v_courses uuid[];
-- begin
--   with b as (select (x->>'link_id')::uuid id, (x->>'is_primary')::boolean pri from pipeline.admin_control_events ev, jsonb_array_elements(ev.detail->'before') x
--               where ev.action = 'e16_course_link_containment' and ev.detail->>'part' = 'A' and ev.detail->>'ids_md5' = 'fb9151ed0b33fe3b4de09f425bdcb64d')
--   update catalogue.course_links l set status = 'active', is_primary = b.pri, updated_at = now() from b where l.id = b.id and l.status = 'unverified';
--   get diagnostics v_n = row_count;
--   if v_n <> 12 then raise exception 'E16 part A rollback: restored % links, expected 12', v_n; end if;
--   with b as (select (x->>'course_id')::uuid cid, x->>'read_status' rs, (x->>'next_read_at')::timestamptz nra, (x->>'evidence_id')::uuid ev
--                from pipeline.admin_control_events ev, jsonb_array_elements(ev.detail->'bindings_before') x
--               where ev.action = 'e16_course_link_containment' and ev.detail->>'part' = 'A' and ev.detail->>'ids_md5' = 'fb9151ed0b33fe3b4de09f425bdcb64d')
--   update pipeline.coverage_course_pages p set read_status = b.rs, next_read_at = b.nra from b
--    where p.course_id = b.cid and p.read_status = 'page_refused' and p.evidence_id = b.ev;
--   get diagnostics v_n = row_count;
--   if v_n <> 12 then raise exception 'E16 part A rollback: restored % bindings, expected 12', v_n; end if;
--   v_courses := array['7cf958c9-c317-4a77-868c-3ba802174d1d','a940f900-bfa0-43a8-bba1-1e60c922a699','f5baa817-87a6-4f2d-a57f-a02b9e9dd90a','a0195518-e6a5-4663-88d4-677bd9c8d0b1','02c7bc01-0cc8-40bd-a190-b6eea143f3a5','486ed99f-09f3-4ef5-9649-1dec1d9878d8','7f9cffdb-54ae-47e3-a595-edac98cd0dd6','1b78ba46-638c-4465-859e-8689e96295a8','0d25903f-de8e-460c-b403-2648148fcadd','33ded954-9998-43ff-9384-c3ca6788d54f','51b27099-8086-4c68-9b9f-04c74af883f6','dd5f7176-0ca9-462c-b399-4f05d06c5e67']::uuid[];
--   perform search.refresh_course_enrichment_scoped_v1(v_courses, true);
--   insert into pipeline.admin_control_events(area, action, target, detail, actor)
--   values ('catalogue', 'e16_course_link_containment_rollback', 'catalogue.course_links', jsonb_build_object('part', 'A', 'count', 12, 'ids_md5', 'fb9151ed0b33fe3b4de09f425bdcb64d'), null);
-- end $e16ar$;
-- commit;
-- Optional, Platform Admin paste only (a delete): let the lanes link the page again
-- delete from pipeline.page_rejections where source = 'e16_containment' and signals->>'tag' = 'e16_containment_a';  -- expect 12
