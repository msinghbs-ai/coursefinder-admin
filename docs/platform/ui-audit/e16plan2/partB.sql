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
