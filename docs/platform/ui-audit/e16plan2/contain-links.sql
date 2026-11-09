-- CF-247 E16 containment, groups (b) and (c): wrong official links the SS-007 hold cannot reach (the page binding is not on the wrong page).
-- PASTE FILE PREPARED READ-ONLY 2 NOV 2026 AFTER SEARCH REFRESH #7725 (v2.15.402). NOT RUN. Not a migration. E15 Part 1 pattern
-- (PASTE-20261101-e15-course-link-repair.sql): count-guarded, exact ids, nothing deleted, audit event, rollback.
-- Project fxcwkweaxjtknorudmwp only. Run as postgres in an allowed minute (:x5-:x8, not :35-:42), after apply-hold.sql.
-- Authority: Platform Admin 2 Nov 2026 07:21 AEDT, E16 final disposition decision section 2 (contain "confirmed wrong-programme destination
--   exposed to consumers" through existing governed or reversible controls). The classification is a candidate assessment, not proof.
-- Each part sets exactly the listed wrong links to 'unverified' and not primary, adds the page to pipeline.page_rejections (source
--   'e16_containment') so no lane re-binds or re-links it, refreshes those courses' search documents, requests a full refresh, and writes one
--   pipeline.admin_control_events row with before and after. Parts run independently.
-- Why the rejection is needed (live code, v2.15.402, security.exit_awards_apply_v2 md5 e7080925ba79eef320f361bf236cb072):
--   line 25  if security.course_held_v1(...) or security.page_refused_v1(r.child_course_id, r.page_url) then ... continue;   <- stops the lane
--   line 27-36  verdict not 'pass' and no active link on the page -> security.binding_refusal_route_v1 (rejection + Layer 4), continue: does
--               NOT re-activate (part B on its own would be safe; the rejection makes it explicit and suppresses an unplanned Layer 4 item)
--   line 70  verdict 'pass' -> security.coverage_apply_course_v1(..., r.page_url, ...), whose upsert (coverage_apply_course_v1 lines 19-22)
--            is "on conflict (course_id, link_type, url) do update set status = 'active' ..." -> RE-ACTIVATES an unverified link within the hour
--            (part C1 without the rejection would be undone at the next :37).
--   Other writers checked: security.link_refresh_tick_v1 only touches active links (lines 36-53); security.l4_rule6_apply_v1 only sets
--   'inactive'; svc_coursefacts_apply_record and security.cf245_admit_official_url_record_v1 re-activate only a URL named by a CourseFacts
--   record (live 2 Nov: every official link on these 31 courses comes from the provider sweep or provider page sources, none from CourseFacts); admin_course_edit,
--   admin_course_link_edit and security.layer4_course_link_apply_impl are a person's decision.


-- ===== Part B: exit or nested award link, award-lane verdict refuse (15 links on 15 courses) =====
-- Link written by the award-link lane (exit_awards_apply_v2); the v2.15.402 check refuses it (level / old_year, title match only, no
-- programme-specific evidence). The lane no longer re-verifies it (line 29-30) but it stays shown until set aside.
-- Link ids md5 (sorted, comma-joined): 76e52aedaead0a4595902140d3a15593
begin;
do $e16b$
declare
  v_n int; v_md5 text; v_before jsonb; v_courses uuid[];
begin
  create temp table e16_b(link_id uuid, course_id uuid, provider_id uuid, url_md5 text, was_primary boolean, evidence_id uuid, code text) on commit drop;
  insert into e16_b values
    ('244bb9e3-c756-483c-aebc-67f0d3ebdeb4'::uuid, '40afad92-5a55-47d8-88e3-2015c41d11af'::uuid, '8e1adb6c-e069-43db-9584-bd054255e702'::uuid, 'ea07f2246f4e61bae0905be99b9e8072', false, '53749049-6886-4dbc-9578-f6387be106cf'::uuid, '014891M'),
    ('e29eced9-aa22-4990-a0bf-04c54de0711d'::uuid, '9f50f886-8d83-40b9-8607-28a5d46b44a4'::uuid, 'de6d32b0-f91b-4dd0-a3da-a542f1aba5f2'::uuid, '5e9efc393abcb31fce343e4c8fa086bc', false, '2d16f6d4-dccd-4ab4-892c-52d34c1bcb6b'::uuid, '045960B'),
    ('2e19bd63-083a-4330-9f26-35ee3d2e765b'::uuid, 'd5e7c833-7912-4046-8b6a-da966520a7c4'::uuid, 'de6d32b0-f91b-4dd0-a3da-a542f1aba5f2'::uuid, '7189607e4af0b5ea3cd80e18e829ac68', false, 'dc67cc4c-3764-46b4-89de-320b0533f119'::uuid, '049410M'),
    ('cac260ab-8608-4233-8005-e7ef650ccadc'::uuid, '2d6d3d1c-8f6f-4455-8228-91d3f32ca491'::uuid, '8e1adb6c-e069-43db-9584-bd054255e702'::uuid, '512325ab968d069ff92be07fa6b2f5c9', false, '15cb7e56-ee7d-4ae5-b57c-e925bdc9d61e'::uuid, '055528B'),
    ('8d3374b8-2059-4858-bf33-911665969ee6'::uuid, '196a1939-628d-4e86-8e4f-f40e0858be2e'::uuid, '8e1adb6c-e069-43db-9584-bd054255e702'::uuid, '95ec8444c20658cf9301e6fe36fef337', false, 'ff154427-ef94-4494-97df-3743ac906420'::uuid, '060584G'),
    ('3aa26679-9dd5-470a-b758-818b8490926a'::uuid, '8a7a7b24-6ba1-4140-ac35-651552220afd'::uuid, 'de6d32b0-f91b-4dd0-a3da-a542f1aba5f2'::uuid, '383cee89f76ef3333b92ccccf30aa86e', false, '2b732622-37c2-4326-a177-375038dc2e22'::uuid, '075492K'),
    ('00f019f2-bfe1-4db8-8dc1-55915d17c75b'::uuid, '20f2aa2c-1e7f-44c6-950c-47afa7881428'::uuid, 'de6d32b0-f91b-4dd0-a3da-a542f1aba5f2'::uuid, 'b473f4d8939318bae887d0d28852957b', false, '0d5d631b-c357-4134-ae0a-4d63f5b59705'::uuid, '075503A'),
    ('c63e2bd2-6ec5-4c12-957a-434cc4af20e6'::uuid, '8c317304-0728-42ca-8e14-0b308a5ffbb2'::uuid, 'de6d32b0-f91b-4dd0-a3da-a542f1aba5f2'::uuid, '7dc9f5c1709294a3e010b8b3ec5aa7f2', false, '7e541a99-db66-4f28-8ad9-7aee01e17f5d'::uuid, '075504M'),
    ('492577a5-245d-42f9-9d29-51a9f05b6637'::uuid, '6d42acd7-35e9-4975-aa9f-2b7f400d341d'::uuid, '8e1adb6c-e069-43db-9584-bd054255e702'::uuid, '6910946fb1520495be758cd07be2c9a8', false, '602ab4a7-53e3-419d-a7a1-2f06d54da8fc'::uuid, '076022K'),
    ('92427cc6-4b82-4550-a664-04b54b1a3b84'::uuid, '111079e4-ca8d-4a72-bca1-145a141e201d'::uuid, '36086f5e-9fe0-4878-aa40-1897a7d8cb24'::uuid, '489dfce134df8ec5a9da41d08a97c0fc', false, '8a00212a-10e9-41dd-9a7c-8ce5439276f7'::uuid, '082403B'),
    ('5b66b697-9672-4c2b-90a1-d67cda537791'::uuid, '670b7ce1-719e-4cdb-91e1-4111d0eba767'::uuid, 'de6d32b0-f91b-4dd0-a3da-a542f1aba5f2'::uuid, '557106ca1dea5aad8c324d9e3012ad2e', false, '18fb19df-437b-4c30-8e01-26662cb214dc'::uuid, '092765D'),
    ('e6fb8f75-5d8d-46d4-b9bc-11d4bd18ea6c'::uuid, 'fcde61b0-f5fe-4618-814c-a76a4b4d1dc7'::uuid, '0e1532b8-de30-4761-87fe-460684608633'::uuid, 'c7f0e27d27ef0c6cfc54bac54096fc10', false, '11aa9cf4-4b94-430c-89e7-01a3cad222de'::uuid, '103875C'),
    ('73fdbbe8-3eeb-4cee-8c0d-2a21e8c71c2a'::uuid, '7e117900-eab0-4c4d-8104-11b9ffaf9b26'::uuid, '36086f5e-9fe0-4878-aa40-1897a7d8cb24'::uuid, 'f254dbf229ef36fcfc7714bd5c0b50d2', false, '5645111f-c6ca-4ae9-bf72-61dd8764ae88'::uuid, '107421A'),
    ('f58bf30a-20e2-429e-b76e-46b06f9eec35'::uuid, '87975d53-8b43-46c8-b209-9924fa43ea79'::uuid, '0e1532b8-de30-4761-87fe-460684608633'::uuid, 'b9437bf4948b30058cba654a18c4d390', false, '595090ad-aef4-4065-8021-cd4a3e31cabd'::uuid, '110293M'),
    ('1a55d330-2ec7-4554-9cc6-a807e2497108'::uuid, '95fcd50f-257e-43d6-9920-f3599cacf374'::uuid, '36086f5e-9fe0-4878-aa40-1897a7d8cb24'::uuid, 'f7d07ccd085a2c852a60aa35beb797c0', false, 'dc26ad8f-c3c2-446d-a49a-992b67b0fc33'::uuid, '114089E');
  -- guard 1: the exact id set
  select count(distinct link_id), md5(string_agg(link_id::text, ',' order by link_id)) into v_n, v_md5 from e16_b;
  if v_n <> 15 or v_md5 <> '76e52aedaead0a4595902140d3a15593' then raise exception 'E16 part B guard 1: id set % / %', v_n, v_md5; end if;
  -- guard 2: each link is still the active official link on the same course, with the same address (md5) and primary flag as read on 2 Nov
  select count(*) into v_n from e16_b e join catalogue.course_links l on l.id = e.link_id
   where l.course_id = e.course_id and l.link_type = 'official_course' and l.status = 'active' and md5(l.url) = e.url_md5 and l.is_primary = e.was_primary;
  if v_n <> 15 then raise exception 'E16 part B guard 2: % of 15 links are exactly as read on 2 Nov; nothing changed', v_n; end if;
  -- guard 3: no hand lock on the course's official page or course URL
  select count(*) into v_n from pipeline.manual_locks k join e16_b e on k.entity = 'course' and k.entity_id = e.course_id and k.field in ('official_url', 'course_url');
  if v_n <> 0 then raise exception 'E16 part B guard 3: % hand locks; stop and re-read', v_n; end if;
  -- guard 4: not entered by hand or confirmed by a reviewer (source manual_entry or layer4_human_review)
  select count(*) into v_n from e16_b e join catalogue.course_links l on l.id = e.link_id join pipeline.sources so on so.id = l.source_id
   where so.source_type in ('manual_entry', 'layer4_human_review');
  if v_n <> 0 then raise exception 'E16 part B guard 4: % links were set by a person; stop', v_n; end if;
  -- guard 5: the course is still active, not under a remediation hold, and the page is not already rejected or blocked
  select count(*) into v_n from e16_b e join catalogue.courses c on c.id = e.course_id join catalogue.course_links l on l.id = e.link_id
   where c.lifecycle_status = 'active' and not security.course_held_v1(e.course_id) and not security.page_refused_v1(e.course_id, l.url);
  if v_n <> 15 then raise exception 'E16 part B guard 5: % of 15 courses are active, not held and not already refused', v_n; end if;
  -- guard 6: the consumer projection still shows this link (it is the exposed one)
  select count(*) into v_n from e16_b e join catalogue.course_links l on l.id = e.link_id join search.course_documents d on d.course_id = e.course_id
   where d.official_course_url = l.url;
  if v_n <> 15 then raise exception 'E16 part B guard 6: % of 15 courses still show this link; re-read before running', v_n; end if;

  select jsonb_agg(jsonb_build_object('link_id', l.id, 'course_id', l.course_id, 'code', e.code, 'url', l.url, 'status', l.status, 'is_primary', l.is_primary,
                                      'source_id', l.source_id, 'evidence_id', l.evidence_id, 'last_verified_at', l.last_verified_at, 'updated_at', l.updated_at) order by e.code),
         array_agg(distinct l.course_id)
    into v_before, v_courses
    from e16_b e join catalogue.course_links l on l.id = e.link_id;

  -- the link stops being shown: the existing status 'unverified', not primary (as security.binding_remediation_apply_v1 and
  -- security.link_refresh_tick_v1 do). Nothing deleted.
  update catalogue.course_links l set status = 'unverified', is_primary = false, updated_at = now()
    from e16_b e where l.id = e.link_id and l.status = 'active';
  get diagnostics v_n = row_count;
  if v_n <> 15 then raise exception 'E16 part B: set % links unverified, expected 15; rolled back', v_n; end if;

  -- no lane binds or links this page to this course again (security.page_refused_v1: exit_awards_apply_v2 line 25, binding guard)
  insert into pipeline.page_rejections(course_id, url, provider_id, evidence_id, source, reason, signals)
  select e.course_id, l.url, e.provider_id, e.evidence_id, 'e16_containment',
         'E16 containment: the official link shown was a sibling-award or older-year page (candidate assessment from title and URL, cohort 2 Nov 2026); held from consumers pending Layer 4 review',
         jsonb_build_object('part', 'B', 'group', 'exit or nested award link, award-lane verdict refuse', 'link_id', e.link_id, 'decision', 'E16 final disposition, Platform Admin 2 Nov 2026 07:21, section 2', 'tag', 'e16_containment_b')
    from e16_b e join catalogue.course_links l on l.id = e.link_id
  on conflict (course_id, url) do nothing;
  get diagnostics v_n = row_count;
  if v_n <> 15 then raise exception 'E16 part B: % page rejections written, expected 15; rolled back', v_n; end if;

  perform search.refresh_course_enrichment_scoped_v1(v_courses, true);
  insert into search.refresh_requests(requested_by) values ('E16 containment part B: 15 wrong official links set unverified');
  insert into pipeline.admin_control_events(area, action, target, detail, actor)
  values ('catalogue', 'e16_course_link_containment', 'catalogue.course_links',
          jsonb_build_object('part', 'B', 'group', 'exit or nested award link, award-lane verdict refuse', 'count', 15, 'ids_md5', '76e52aedaead0a4595902140d3a15593',
                             'before', v_before,
                             'after', jsonb_build_object('status', 'unverified', 'is_primary', false, 'page_rejection_source', 'e16_containment'),
                             'reason', 'E16 containment: confirmed (candidate) wrong-programme destination shown to consumers',
                             'decision', 'E16 final disposition, Platform Admin 2 Nov 2026 07:21, section 2',
                             'rollback', 'contain-links.sql rollback block, part B'), null);
end $e16b$;
-- read-back before commit: expect 15 unverified, 0 active, 15 rejections tagged e16_containment_b
select l.status, count(*) from catalogue.course_links l where l.id = any(array['00f019f2-bfe1-4db8-8dc1-55915d17c75b','1a55d330-2ec7-4554-9cc6-a807e2497108','244bb9e3-c756-483c-aebc-67f0d3ebdeb4','2e19bd63-083a-4330-9f26-35ee3d2e765b','3aa26679-9dd5-470a-b758-818b8490926a','492577a5-245d-42f9-9d29-51a9f05b6637','5b66b697-9672-4c2b-90a1-d67cda537791','73fdbbe8-3eeb-4cee-8c0d-2a21e8c71c2a','8d3374b8-2059-4858-bf33-911665969ee6','92427cc6-4b82-4550-a664-04b54b1a3b84','c63e2bd2-6ec5-4c12-957a-434cc4af20e6','cac260ab-8608-4233-8005-e7ef650ccadc','e29eced9-aa22-4990-a0bf-04c54de0711d','e6fb8f75-5d8d-46d4-b9bc-11d4bd18ea6c','f58bf30a-20e2-429e-b76e-46b06f9eec35']::uuid[]) group by 1;
select count(*) rejections from pipeline.page_rejections where source = 'e16_containment' and signals->>'tag' = 'e16_containment_b';
commit;

-- ROLLBACK of part B (restores status active and the primary flag held before; the page rejections stay unless the Platform Admin
-- separately removes them, because pipeline.page_rejections is documented as never deleted):
-- begin;
-- do $e16br$
-- declare v_n int; v_courses uuid[];
-- begin
--   with b as (select (x->>'link_id')::uuid id, (x->>'is_primary')::boolean pri from pipeline.admin_control_events ev, jsonb_array_elements(ev.detail->'before') x
--               where ev.action = 'e16_course_link_containment' and ev.detail->>'part' = 'B' and ev.detail->>'ids_md5' = '76e52aedaead0a4595902140d3a15593')
--   update catalogue.course_links l set status = 'active', is_primary = b.pri, updated_at = now() from b where l.id = b.id and l.status = 'unverified';
--   get diagnostics v_n = row_count;
--   if v_n <> 15 then raise exception 'E16 part B rollback: restored %, expected 15', v_n; end if;
--   select array_agg(distinct course_id) into v_courses from catalogue.course_links where id = any(array['00f019f2-bfe1-4db8-8dc1-55915d17c75b','1a55d330-2ec7-4554-9cc6-a807e2497108','244bb9e3-c756-483c-aebc-67f0d3ebdeb4','2e19bd63-083a-4330-9f26-35ee3d2e765b','3aa26679-9dd5-470a-b758-818b8490926a','492577a5-245d-42f9-9d29-51a9f05b6637','5b66b697-9672-4c2b-90a1-d67cda537791','73fdbbe8-3eeb-4cee-8c0d-2a21e8c71c2a','8d3374b8-2059-4858-bf33-911665969ee6','92427cc6-4b82-4550-a664-04b54b1a3b84','c63e2bd2-6ec5-4c12-957a-434cc4af20e6','cac260ab-8608-4233-8005-e7ef650ccadc','e29eced9-aa22-4990-a0bf-04c54de0711d','e6fb8f75-5d8d-46d4-b9bc-11d4bd18ea6c','f58bf30a-20e2-429e-b76e-46b06f9eec35']::uuid[]);
--   perform search.refresh_course_enrichment_scoped_v1(v_courses, true);
--   insert into pipeline.admin_control_events(area, action, target, detail, actor)
--   values ('catalogue', 'e16_course_link_containment_rollback', 'catalogue.course_links', jsonb_build_object('part', 'B', 'count', v_n, 'ids_md5', '76e52aedaead0a4595902140d3a15593'), null);
-- end $e16br$;
-- commit;
-- Optional, Platform Admin paste only (a delete): let the lanes link the page again
-- delete from pipeline.page_rejections where source = 'e16_containment' and signals->>'tag' = 'e16_containment_b';  -- expect 15


-- ===== Part C1: exit or nested award link, award-lane verdict pass (programme-specific evidence on record) (14 links on 14 courses) =====
-- INTEGRATOR DECISION FIRST: v2.15.402 ACCEPTS these links (rule award_on_parent_page: the award was recorded by hand with evidence, or the
-- parent page names the award). The cohort classifies them as confirmed sibling pages from title and URL. Under section 3 of the decision a
-- parent page that names the award is a possible genuine shared page. Running this part treats the cohort classification as overriding
-- the recorded award evidence; leaving it keeps them shown as the parent course's page. Without the rejection the lane re-activates them.
-- Link ids md5 (sorted, comma-joined): c26142173a84cb90dcc53c82ea522409
begin;
do $e16c1$
declare
  v_n int; v_md5 text; v_before jsonb; v_courses uuid[];
begin
  create temp table e16_c1(link_id uuid, course_id uuid, provider_id uuid, url_md5 text, was_primary boolean, evidence_id uuid, code text) on commit drop;
  insert into e16_c1 values
    ('bb5581a1-965a-4d17-9436-95ec5718bad9'::uuid, 'e1596a78-53ad-463f-bd1a-1442109c6ac3'::uuid, '36086f5e-9fe0-4878-aa40-1897a7d8cb24'::uuid, '89f5f9341df1b8c52d45f90cae623f23', true, '1afa1229-dca9-4de7-96b0-a21194c144ee'::uuid, '0101621'),
    ('0afc091a-68df-47fe-8f4d-46d68176d64c'::uuid, 'ebfc236d-1c66-4f5b-bd4d-815ad7655e33'::uuid, '36086f5e-9fe0-4878-aa40-1897a7d8cb24'::uuid, '19f1d1a470c5058bace5c8ea2ad67b87', true, '59988fcd-bd8d-4dee-b562-6fbc62c316b1'::uuid, '046442E'),
    ('25b031b3-82aa-4fe7-b893-a6c61b3b87b4'::uuid, '264c5b84-eff8-49ac-b03f-c8cf12708198'::uuid, '36086f5e-9fe0-4878-aa40-1897a7d8cb24'::uuid, '74f2609f1e2a50db73295ac61b28bedf', true, '6216d4a3-0252-40fb-9041-8c7e3b63372c'::uuid, '061457F'),
    ('9c3b1064-f3d3-4590-b7f6-5aa0f3d4c411'::uuid, 'fa955ff0-37d1-4c91-826a-89c812cde021'::uuid, 'de6d32b0-f91b-4dd0-a3da-a542f1aba5f2'::uuid, '1b4fd695e3a0ec37ab9463b99a048311', true, '6942a32e-21da-4572-88dd-84f9b2681639'::uuid, '085950F'),
    ('6dac18dd-0137-46a3-9554-4a8f401d6593'::uuid, '283a0dd2-0101-45c0-8a09-b0441f51d783'::uuid, '8e1adb6c-e069-43db-9584-bd054255e702'::uuid, 'fc8acb4d10ed7849faa2582e506771d2', false, 'bda20ed6-eb95-40ea-b258-4902b76de884'::uuid, '103218C'),
    ('34594cd0-993a-44c5-86d4-1a6d6555652c'::uuid, 'ba8d7def-6f2e-48aa-a314-70603abe8d9c'::uuid, '8e1adb6c-e069-43db-9584-bd054255e702'::uuid, '77d0fe215243fac3019b2c85a2bebf73', true, '0f1a4927-22f0-4b83-bfcd-9a8b5583da1b'::uuid, '103220J'),
    ('ac6c69fd-33fa-40a7-9140-839a4bfffbe5'::uuid, 'ff63eb8b-2705-4db7-8500-1db2c548216a'::uuid, '8e1adb6c-e069-43db-9584-bd054255e702'::uuid, '6a052f4d1d4ba4ccf7d9a56c9ec50162', true, 'd5d6c905-9f3b-4326-b157-18392fa5816d'::uuid, '103223F'),
    ('e882e231-384f-4958-a8f0-930338fca1d3'::uuid, 'de86b0d9-bb66-4a7d-8b05-ff1fa2c6d9cd'::uuid, '8e1adb6c-e069-43db-9584-bd054255e702'::uuid, '1096cfa202d89bd69260832e2f5a9b39', false, '9bab1485-f5fa-49c5-84e7-07bb7233bc22'::uuid, '103227B'),
    ('5aacfe2c-b49c-4fae-9f8d-5077c8bcf3cd'::uuid, 'cdc06d73-f08b-40fc-9d30-1700df678e62'::uuid, '8e1adb6c-e069-43db-9584-bd054255e702'::uuid, '54c4362ebb50b60463f76cb2e6a33683', true, '755bcbef-97fd-4b53-bbfd-cc0fab8f9445'::uuid, '103228A'),
    ('08859f87-3c9f-477e-9d19-34dfd15c0ed2'::uuid, 'd25f60bb-bd10-4956-8337-cdefdff8b1ce'::uuid, '8e1adb6c-e069-43db-9584-bd054255e702'::uuid, '43cd714c3f5ee57e1e2f3cb7afb770a3', false, 'b9961b67-da56-4724-8aa6-e359c11f1d68'::uuid, '103229M'),
    ('4e90e565-5881-48a2-8003-1dcdc4af33f1'::uuid, '6b5874f1-770f-4000-9614-56a6df194724'::uuid, '8e1adb6c-e069-43db-9584-bd054255e702'::uuid, '7cadcf8d9fcbfb7215eb4ef0bd4f8b9c', true, 'b14c9ac1-887b-4a6b-992a-d9d39a18ea80'::uuid, '103236A'),
    ('6fb25eac-aebf-4b1c-b3a3-8c7f238d090d'::uuid, '60ebab30-d9a8-47f9-bf7f-85aebc49039f'::uuid, '8e1adb6c-e069-43db-9584-bd054255e702'::uuid, 'd0d8d0ada29b388fd4ae3c4df73f0672', true, 'ca52d51e-d9d1-42e6-8a59-187f97e5ee38'::uuid, '104982C'),
    ('4a5ee905-3124-474f-9635-1ffa0033fa2f'::uuid, '2cf5c4ac-b56d-44e2-b69e-93b6ce39a475'::uuid, '36086f5e-9fe0-4878-aa40-1897a7d8cb24'::uuid, 'f7d07ccd085a2c852a60aa35beb797c0', true, 'b40fcbbf-3234-4d48-8e1e-c420f6b8f366'::uuid, '114091M'),
    ('aae09bf5-0eef-4ada-b193-b4d139efe77c'::uuid, 'b2226705-305a-4e88-9af5-fd8b404239c5'::uuid, 'f30cd2cd-01fc-458e-a061-b7aa5faa8a00'::uuid, 'b6c5493599a073302ff7ee9774ea03c5', true, 'f1d69aaa-d049-421a-8ff4-5e4d5cf4430c'::uuid, '121356K');
  -- guard 1: the exact id set
  select count(distinct link_id), md5(string_agg(link_id::text, ',' order by link_id)) into v_n, v_md5 from e16_c1;
  if v_n <> 14 or v_md5 <> 'c26142173a84cb90dcc53c82ea522409' then raise exception 'E16 part C1 guard 1: id set % / %', v_n, v_md5; end if;
  -- guard 2: each link is still the active official link on the same course, with the same address (md5) and primary flag as read on 2 Nov
  select count(*) into v_n from e16_c1 e join catalogue.course_links l on l.id = e.link_id
   where l.course_id = e.course_id and l.link_type = 'official_course' and l.status = 'active' and md5(l.url) = e.url_md5 and l.is_primary = e.was_primary;
  if v_n <> 14 then raise exception 'E16 part C1 guard 2: % of 14 links are exactly as read on 2 Nov; nothing changed', v_n; end if;
  -- guard 3: no hand lock on the course's official page or course URL
  select count(*) into v_n from pipeline.manual_locks k join e16_c1 e on k.entity = 'course' and k.entity_id = e.course_id and k.field in ('official_url', 'course_url');
  if v_n <> 0 then raise exception 'E16 part C1 guard 3: % hand locks; stop and re-read', v_n; end if;
  -- guard 4: not entered by hand or confirmed by a reviewer (source manual_entry or layer4_human_review)
  select count(*) into v_n from e16_c1 e join catalogue.course_links l on l.id = e.link_id join pipeline.sources so on so.id = l.source_id
   where so.source_type in ('manual_entry', 'layer4_human_review');
  if v_n <> 0 then raise exception 'E16 part C1 guard 4: % links were set by a person; stop', v_n; end if;
  -- guard 5: the course is still active, not under a remediation hold, and the page is not already rejected or blocked
  select count(*) into v_n from e16_c1 e join catalogue.courses c on c.id = e.course_id join catalogue.course_links l on l.id = e.link_id
   where c.lifecycle_status = 'active' and not security.course_held_v1(e.course_id) and not security.page_refused_v1(e.course_id, l.url);
  if v_n <> 14 then raise exception 'E16 part C1 guard 5: % of 14 courses are active, not held and not already refused', v_n; end if;
  -- guard 6: the consumer projection still shows this link (it is the exposed one)
  select count(*) into v_n from e16_c1 e join catalogue.course_links l on l.id = e.link_id join search.course_documents d on d.course_id = e.course_id
   where d.official_course_url = l.url;
  if v_n <> 14 then raise exception 'E16 part C1 guard 6: % of 14 courses still show this link; re-read before running', v_n; end if;

  select jsonb_agg(jsonb_build_object('link_id', l.id, 'course_id', l.course_id, 'code', e.code, 'url', l.url, 'status', l.status, 'is_primary', l.is_primary,
                                      'source_id', l.source_id, 'evidence_id', l.evidence_id, 'last_verified_at', l.last_verified_at, 'updated_at', l.updated_at) order by e.code),
         array_agg(distinct l.course_id)
    into v_before, v_courses
    from e16_c1 e join catalogue.course_links l on l.id = e.link_id;

  -- the link stops being shown: the existing status 'unverified', not primary (as security.binding_remediation_apply_v1 and
  -- security.link_refresh_tick_v1 do). Nothing deleted.
  update catalogue.course_links l set status = 'unverified', is_primary = false, updated_at = now()
    from e16_c1 e where l.id = e.link_id and l.status = 'active';
  get diagnostics v_n = row_count;
  if v_n <> 14 then raise exception 'E16 part C1: set % links unverified, expected 14; rolled back', v_n; end if;

  -- no lane binds or links this page to this course again (security.page_refused_v1: exit_awards_apply_v2 line 25, binding guard)
  insert into pipeline.page_rejections(course_id, url, provider_id, evidence_id, source, reason, signals)
  select e.course_id, l.url, e.provider_id, e.evidence_id, 'e16_containment',
         'E16 containment: the official link shown was a sibling-award or older-year page (candidate assessment from title and URL, cohort 2 Nov 2026); held from consumers pending Layer 4 review',
         jsonb_build_object('part', 'C1', 'group', 'exit or nested award link, award-lane verdict pass (programme-specific evidence on record)', 'link_id', e.link_id, 'decision', 'E16 final disposition, Platform Admin 2 Nov 2026 07:21, section 2', 'tag', 'e16_containment_c1')
    from e16_c1 e join catalogue.course_links l on l.id = e.link_id
  on conflict (course_id, url) do nothing;
  get diagnostics v_n = row_count;
  if v_n <> 14 then raise exception 'E16 part C1: % page rejections written, expected 14; rolled back', v_n; end if;

  perform search.refresh_course_enrichment_scoped_v1(v_courses, true);
  insert into search.refresh_requests(requested_by) values ('E16 containment part C1: 14 wrong official links set unverified');
  insert into pipeline.admin_control_events(area, action, target, detail, actor)
  values ('catalogue', 'e16_course_link_containment', 'catalogue.course_links',
          jsonb_build_object('part', 'C1', 'group', 'exit or nested award link, award-lane verdict pass (programme-specific evidence on record)', 'count', 14, 'ids_md5', 'c26142173a84cb90dcc53c82ea522409',
                             'before', v_before,
                             'after', jsonb_build_object('status', 'unverified', 'is_primary', false, 'page_rejection_source', 'e16_containment'),
                             'reason', 'E16 containment: confirmed (candidate) wrong-programme destination shown to consumers',
                             'decision', 'E16 final disposition, Platform Admin 2 Nov 2026 07:21, section 2',
                             'rollback', 'contain-links.sql rollback block, part C1'), null);
end $e16c1$;
-- read-back before commit: expect 14 unverified, 0 active, 14 rejections tagged e16_containment_c1
select l.status, count(*) from catalogue.course_links l where l.id = any(array['08859f87-3c9f-477e-9d19-34dfd15c0ed2','0afc091a-68df-47fe-8f4d-46d68176d64c','25b031b3-82aa-4fe7-b893-a6c61b3b87b4','34594cd0-993a-44c5-86d4-1a6d6555652c','4a5ee905-3124-474f-9635-1ffa0033fa2f','4e90e565-5881-48a2-8003-1dcdc4af33f1','5aacfe2c-b49c-4fae-9f8d-5077c8bcf3cd','6dac18dd-0137-46a3-9554-4a8f401d6593','6fb25eac-aebf-4b1c-b3a3-8c7f238d090d','9c3b1064-f3d3-4590-b7f6-5aa0f3d4c411','aae09bf5-0eef-4ada-b193-b4d139efe77c','ac6c69fd-33fa-40a7-9140-839a4bfffbe5','bb5581a1-965a-4d17-9436-95ec5718bad9','e882e231-384f-4958-a8f0-930338fca1d3']::uuid[]) group by 1;
select count(*) rejections from pipeline.page_rejections where source = 'e16_containment' and signals->>'tag' = 'e16_containment_c1';
commit;

-- ROLLBACK of part C1 (restores status active and the primary flag held before; the page rejections stay unless the Platform Admin
-- separately removes them, because pipeline.page_rejections is documented as never deleted):
-- begin;
-- do $e16c1r$
-- declare v_n int; v_courses uuid[];
-- begin
--   with b as (select (x->>'link_id')::uuid id, (x->>'is_primary')::boolean pri from pipeline.admin_control_events ev, jsonb_array_elements(ev.detail->'before') x
--               where ev.action = 'e16_course_link_containment' and ev.detail->>'part' = 'C1' and ev.detail->>'ids_md5' = 'c26142173a84cb90dcc53c82ea522409')
--   update catalogue.course_links l set status = 'active', is_primary = b.pri, updated_at = now() from b where l.id = b.id and l.status = 'unverified';
--   get diagnostics v_n = row_count;
--   if v_n <> 14 then raise exception 'E16 part C1 rollback: restored %, expected 14', v_n; end if;
--   select array_agg(distinct course_id) into v_courses from catalogue.course_links where id = any(array['08859f87-3c9f-477e-9d19-34dfd15c0ed2','0afc091a-68df-47fe-8f4d-46d68176d64c','25b031b3-82aa-4fe7-b893-a6c61b3b87b4','34594cd0-993a-44c5-86d4-1a6d6555652c','4a5ee905-3124-474f-9635-1ffa0033fa2f','4e90e565-5881-48a2-8003-1dcdc4af33f1','5aacfe2c-b49c-4fae-9f8d-5077c8bcf3cd','6dac18dd-0137-46a3-9554-4a8f401d6593','6fb25eac-aebf-4b1c-b3a3-8c7f238d090d','9c3b1064-f3d3-4590-b7f6-5aa0f3d4c411','aae09bf5-0eef-4ada-b193-b4d139efe77c','ac6c69fd-33fa-40a7-9140-839a4bfffbe5','bb5581a1-965a-4d17-9436-95ec5718bad9','e882e231-384f-4958-a8f0-930338fca1d3']::uuid[]);
--   perform search.refresh_course_enrichment_scoped_v1(v_courses, true);
--   insert into pipeline.admin_control_events(area, action, target, detail, actor)
--   values ('catalogue', 'e16_course_link_containment_rollback', 'catalogue.course_links', jsonb_build_object('part', 'C1', 'count', v_n, 'ids_md5', 'c26142173a84cb90dcc53c82ea522409'), null);
-- end $e16c1r$;
-- commit;
-- Optional, Platform Admin paste only (a delete): let the lanes link the page again
-- delete from pipeline.page_rejections where source = 'e16_containment' and signals->>'tag' = 'e16_containment_c1';  -- expect 14


-- ===== Part C2: sweep link, award row already off (2 links on 2 courses) =====
-- Federation 085206E and 085209B: the shown link came from the provider sweep; the exit-award rows are already off (active false) and
-- the page binding is 'mismatch' on a handbook search page, so the hold cannot act. Nothing re-writes these links today.
-- Link ids md5 (sorted, comma-joined): 6a10155e5c4dc4e19ebc4d827f6a0ec7
begin;
do $e16c2$
declare
  v_n int; v_md5 text; v_before jsonb; v_courses uuid[];
begin
  create temp table e16_c2(link_id uuid, course_id uuid, provider_id uuid, url_md5 text, was_primary boolean, evidence_id uuid, code text) on commit drop;
  insert into e16_c2 values
    ('7ec47cc4-83d8-4eda-a1a8-7ea313a4ab21'::uuid, '2be0fafe-c403-495c-96bc-32b9f181a1a2'::uuid, '9cc8ef21-52ec-4c18-849a-598ba1072459'::uuid, '7e24e5675bc41190bb4949271d811a96', true, 'ec4f3e3e-4bd8-454e-8aa6-fe2ba4dd6a98'::uuid, '085206E'),
    ('b374f0f2-d90e-43e9-9b2e-ad0af0d85440'::uuid, '4ad16106-b97b-44e6-b0bb-aa1ebd3b21aa'::uuid, '9cc8ef21-52ec-4c18-849a-598ba1072459'::uuid, '7e24e5675bc41190bb4949271d811a96', true, 'ec4f3e3e-4bd8-454e-8aa6-fe2ba4dd6a98'::uuid, '085209B');
  -- guard 1: the exact id set
  select count(distinct link_id), md5(string_agg(link_id::text, ',' order by link_id)) into v_n, v_md5 from e16_c2;
  if v_n <> 2 or v_md5 <> '6a10155e5c4dc4e19ebc4d827f6a0ec7' then raise exception 'E16 part C2 guard 1: id set % / %', v_n, v_md5; end if;
  -- guard 2: each link is still the active official link on the same course, with the same address (md5) and primary flag as read on 2 Nov
  select count(*) into v_n from e16_c2 e join catalogue.course_links l on l.id = e.link_id
   where l.course_id = e.course_id and l.link_type = 'official_course' and l.status = 'active' and md5(l.url) = e.url_md5 and l.is_primary = e.was_primary;
  if v_n <> 2 then raise exception 'E16 part C2 guard 2: % of 2 links are exactly as read on 2 Nov; nothing changed', v_n; end if;
  -- guard 3: no hand lock on the course's official page or course URL
  select count(*) into v_n from pipeline.manual_locks k join e16_c2 e on k.entity = 'course' and k.entity_id = e.course_id and k.field in ('official_url', 'course_url');
  if v_n <> 0 then raise exception 'E16 part C2 guard 3: % hand locks; stop and re-read', v_n; end if;
  -- guard 4: not entered by hand or confirmed by a reviewer (source manual_entry or layer4_human_review)
  select count(*) into v_n from e16_c2 e join catalogue.course_links l on l.id = e.link_id join pipeline.sources so on so.id = l.source_id
   where so.source_type in ('manual_entry', 'layer4_human_review');
  if v_n <> 0 then raise exception 'E16 part C2 guard 4: % links were set by a person; stop', v_n; end if;
  -- guard 5: the course is still active, not under a remediation hold, and the page is not already rejected or blocked
  select count(*) into v_n from e16_c2 e join catalogue.courses c on c.id = e.course_id join catalogue.course_links l on l.id = e.link_id
   where c.lifecycle_status = 'active' and not security.course_held_v1(e.course_id) and not security.page_refused_v1(e.course_id, l.url);
  if v_n <> 2 then raise exception 'E16 part C2 guard 5: % of 2 courses are active, not held and not already refused', v_n; end if;
  -- guard 6: the consumer projection still shows this link (it is the exposed one)
  select count(*) into v_n from e16_c2 e join catalogue.course_links l on l.id = e.link_id join search.course_documents d on d.course_id = e.course_id
   where d.official_course_url = l.url;
  if v_n <> 2 then raise exception 'E16 part C2 guard 6: % of 2 courses still show this link; re-read before running', v_n; end if;

  select jsonb_agg(jsonb_build_object('link_id', l.id, 'course_id', l.course_id, 'code', e.code, 'url', l.url, 'status', l.status, 'is_primary', l.is_primary,
                                      'source_id', l.source_id, 'evidence_id', l.evidence_id, 'last_verified_at', l.last_verified_at, 'updated_at', l.updated_at) order by e.code),
         array_agg(distinct l.course_id)
    into v_before, v_courses
    from e16_c2 e join catalogue.course_links l on l.id = e.link_id;

  -- the link stops being shown: the existing status 'unverified', not primary (as security.binding_remediation_apply_v1 and
  -- security.link_refresh_tick_v1 do). Nothing deleted.
  update catalogue.course_links l set status = 'unverified', is_primary = false, updated_at = now()
    from e16_c2 e where l.id = e.link_id and l.status = 'active';
  get diagnostics v_n = row_count;
  if v_n <> 2 then raise exception 'E16 part C2: set % links unverified, expected 2; rolled back', v_n; end if;

  -- no lane binds or links this page to this course again (security.page_refused_v1: exit_awards_apply_v2 line 25, binding guard)
  insert into pipeline.page_rejections(course_id, url, provider_id, evidence_id, source, reason, signals)
  select e.course_id, l.url, e.provider_id, e.evidence_id, 'e16_containment',
         'E16 containment: the official link shown was a sibling-award or older-year page (candidate assessment from title and URL, cohort 2 Nov 2026); held from consumers pending Layer 4 review',
         jsonb_build_object('part', 'C2', 'group', 'sweep link, award row already off', 'link_id', e.link_id, 'decision', 'E16 final disposition, Platform Admin 2 Nov 2026 07:21, section 2', 'tag', 'e16_containment_c2')
    from e16_c2 e join catalogue.course_links l on l.id = e.link_id
  on conflict (course_id, url) do nothing;
  get diagnostics v_n = row_count;
  if v_n <> 2 then raise exception 'E16 part C2: % page rejections written, expected 2; rolled back', v_n; end if;

  perform search.refresh_course_enrichment_scoped_v1(v_courses, true);
  insert into search.refresh_requests(requested_by) values ('E16 containment part C2: 2 wrong official links set unverified');
  insert into pipeline.admin_control_events(area, action, target, detail, actor)
  values ('catalogue', 'e16_course_link_containment', 'catalogue.course_links',
          jsonb_build_object('part', 'C2', 'group', 'sweep link, award row already off', 'count', 2, 'ids_md5', '6a10155e5c4dc4e19ebc4d827f6a0ec7',
                             'before', v_before,
                             'after', jsonb_build_object('status', 'unverified', 'is_primary', false, 'page_rejection_source', 'e16_containment'),
                             'reason', 'E16 containment: confirmed (candidate) wrong-programme destination shown to consumers',
                             'decision', 'E16 final disposition, Platform Admin 2 Nov 2026 07:21, section 2',
                             'rollback', 'contain-links.sql rollback block, part C2'), null);
end $e16c2$;
-- read-back before commit: expect 2 unverified, 0 active, 2 rejections tagged e16_containment_c2
select l.status, count(*) from catalogue.course_links l where l.id = any(array['7ec47cc4-83d8-4eda-a1a8-7ea313a4ab21','b374f0f2-d90e-43e9-9b2e-ad0af0d85440']::uuid[]) group by 1;
select count(*) rejections from pipeline.page_rejections where source = 'e16_containment' and signals->>'tag' = 'e16_containment_c2';
commit;

-- ROLLBACK of part C2 (restores status active and the primary flag held before; the page rejections stay unless the Platform Admin
-- separately removes them, because pipeline.page_rejections is documented as never deleted):
-- begin;
-- do $e16c2r$
-- declare v_n int; v_courses uuid[];
-- begin
--   with b as (select (x->>'link_id')::uuid id, (x->>'is_primary')::boolean pri from pipeline.admin_control_events ev, jsonb_array_elements(ev.detail->'before') x
--               where ev.action = 'e16_course_link_containment' and ev.detail->>'part' = 'C2' and ev.detail->>'ids_md5' = '6a10155e5c4dc4e19ebc4d827f6a0ec7')
--   update catalogue.course_links l set status = 'active', is_primary = b.pri, updated_at = now() from b where l.id = b.id and l.status = 'unverified';
--   get diagnostics v_n = row_count;
--   if v_n <> 2 then raise exception 'E16 part C2 rollback: restored %, expected 2', v_n; end if;
--   select array_agg(distinct course_id) into v_courses from catalogue.course_links where id = any(array['7ec47cc4-83d8-4eda-a1a8-7ea313a4ab21','b374f0f2-d90e-43e9-9b2e-ad0af0d85440']::uuid[]);
--   perform search.refresh_course_enrichment_scoped_v1(v_courses, true);
--   insert into pipeline.admin_control_events(area, action, target, detail, actor)
--   values ('catalogue', 'e16_course_link_containment_rollback', 'catalogue.course_links', jsonb_build_object('part', 'C2', 'count', v_n, 'ids_md5', '6a10155e5c4dc4e19ebc4d827f6a0ec7'), null);
-- end $e16c2r$;
-- commit;
-- Optional, Platform Admin paste only (a delete): let the lanes link the page again
-- delete from pipeline.page_rejections where source = 'e16_containment' and signals->>'tag' = 'e16_containment_c2';  -- expect 2
