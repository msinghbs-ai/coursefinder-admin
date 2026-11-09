-- CF-247 E16 containment: Layer 4 routing of the contained courses through v2.15.402's own route, security.binding_refusal_route_v1.
-- PREPARED READ-ONLY 2 NOV 2026 AFTER SEARCH REFRESH #7725. NOT RUN. Project fxcwkweaxjtknorudmwp only. Run as postgres after apply-hold.sql
-- and contain-links.sql (and only for the parts actually run: delete the rows of a part that was not run, and change the count guard).
-- Authority: Platform Admin 2 Nov 2026 07:21, E16 final disposition section 2 actions 5-7 (send unresolved cases to the existing Layer 4 review
--   kind or keep a linked pending item; no duplicate items).
-- Does any lane create these items by itself? No:
--   * group (a): security.binding_remediation_apply_v1 writes no Layer 4 item; exit_awards_apply_v2 line 25 skips a held course; the binding
--     guard routes only a page being bound or re-bound (migration 20261102030000 lines 354-374), and a refused page is set 'page_refused'
--     without routing (lines 363-366).
--   * groups (b) and (c): contain-links.sql adds a page rejection, so exit_awards_apply_v2 stops at line 25 before its own route call (line 32).
--     (Without the rejection, part B courses would be routed by the lane at the next :37; part C1 would be re-activated instead.)
--   So the 43 items must be raised; this file calls the same function the lanes use, with its own dedupe:
--     (1) pg_advisory_xact_lock('layer4 course link ' || course) - one route at a time per course, across lanes;
--     (2) a pending official_course_url item for the course -> 'pending_item_kept', nothing added;
--     (3) any official_course_url item ever raised for this course and this page (Decision 263) -> 'decided_before', nothing added.
-- The route records the refused page in pipeline.page_rejections (on conflict do nothing: the hold's or the containment's row is kept) and
--   raises one item: entity course, field official_course_url (review kind course_link), proposed_value {"course_url": <the refused page>},
--   before_value = the course's active official links at that moment (after containment: none, or the course's own page on 5 part C1 courses),
--   reason "The page found automatically was not linked: <reason>. If it is this course's own page, choose Use the new page; otherwise keep the
--   page we hold." A reviewer who keeps the held page closes it; "Use the new page" would re-link the refused page (the documented route back).
-- Live check 2 Nov 09:25: none of the 43 courses has a pending official_course_url item, and none has any official_course_url item in any
--   status, so (2) and (3) do not block: expected result 43 x 'item_created', 0 duplicates. Pending items of other kinds are kept (6 RMIT
--   course_entry_first_read items are on courses that are not in this list).
-- Course ids md5 (sorted, comma-joined): 107b9d74a91cfbd84cbb183df58534ab

-- 0. Read-only pre-check: expect 0 rows from each query.
-- select i.entity_id, i.status from pipeline.layer4_review_items i where i.entity_type = 'course' and i.field_code = 'official_course_url' and i.entity_id = any(array['02c7bc01-0cc8-40bd-a190-b6eea143f3a5','0d25903f-de8e-460c-b403-2648148fcadd','111079e4-ca8d-4a72-bca1-145a141e201d','196a1939-628d-4e86-8e4f-f40e0858be2e','1b78ba46-638c-4465-859e-8689e96295a8','20f2aa2c-1e7f-44c6-950c-47afa7881428','264c5b84-eff8-49ac-b03f-c8cf12708198','283a0dd2-0101-45c0-8a09-b0441f51d783','2be0fafe-c403-495c-96bc-32b9f181a1a2','2cf5c4ac-b56d-44e2-b69e-93b6ce39a475','2d6d3d1c-8f6f-4455-8228-91d3f32ca491','33ded954-9998-43ff-9384-c3ca6788d54f','40afad92-5a55-47d8-88e3-2015c41d11af','486ed99f-09f3-4ef5-9649-1dec1d9878d8','4ad16106-b97b-44e6-b0bb-aa1ebd3b21aa','51b27099-8086-4c68-9b9f-04c74af883f6','60ebab30-d9a8-47f9-bf7f-85aebc49039f','670b7ce1-719e-4cdb-91e1-4111d0eba767','6b5874f1-770f-4000-9614-56a6df194724','6d42acd7-35e9-4975-aa9f-2b7f400d341d','7cf958c9-c317-4a77-868c-3ba802174d1d','7e117900-eab0-4c4d-8104-11b9ffaf9b26','7f9cffdb-54ae-47e3-a595-edac98cd0dd6','87975d53-8b43-46c8-b209-9924fa43ea79','8a7a7b24-6ba1-4140-ac35-651552220afd','8c317304-0728-42ca-8e14-0b308a5ffbb2','95fcd50f-257e-43d6-9920-f3599cacf374','9f50f886-8d83-40b9-8607-28a5d46b44a4','a0195518-e6a5-4663-88d4-677bd9c8d0b1','a940f900-bfa0-43a8-bba1-1e60c922a699','b2226705-305a-4e88-9af5-fd8b404239c5','ba8d7def-6f2e-48aa-a314-70603abe8d9c','cdc06d73-f08b-40fc-9d30-1700df678e62','d25f60bb-bd10-4956-8337-cdefdff8b1ce','d5e7c833-7912-4046-8b6a-da966520a7c4','dd5f7176-0ca9-462c-b399-4f05d06c5e67','de86b0d9-bb66-4a7d-8b05-ff1fa2c6d9cd','e1596a78-53ad-463f-bd1a-1442109c6ac3','ebfc236d-1c66-4f5b-bd4d-815ad7655e33','f5baa817-87a6-4f2d-a57f-a02b9e9dd90a','fa955ff0-37d1-4c91-826a-89c812cde021','fcde61b0-f5fe-4618-814c-a76a4b4d1dc7','ff63eb8b-2705-4db7-8500-1db2c548216a']::uuid[]);

begin;
do $e16l4$
declare
  r record; v_res text; v_chk jsonb; v_url text; v_ev uuid;
  v_created int := 0; v_kept int := 0; v_decided int := 0; v_nothing int := 0; v_n int; v_md5 text;
begin
  create temp table e16_l4(part text, code text, course_id uuid, link_id uuid) on commit drop;
  insert into e16_l4 values
    ('A', '000723J', '0d25903f-de8e-460c-b403-2648148fcadd'::uuid, '8e8b2530-189b-40d8-b88b-da9642b3793d'::uuid),
    ('A', '0101290', '7cf958c9-c317-4a77-868c-3ba802174d1d'::uuid, 'fe63f690-ec2f-4ea7-8396-99801a198d86'::uuid),
    ('A', '089932J', '51b27099-8086-4c68-9b9f-04c74af883f6'::uuid, 'ae0f8921-0dee-42b2-9436-799b1bb177de'::uuid),
    ('A', '098314E', 'a940f900-bfa0-43a8-bba1-1e60c922a699'::uuid, 'a012cff5-3d76-4137-aeab-db57437d05d2'::uuid),
    ('A', '105122F', '486ed99f-09f3-4ef5-9649-1dec1d9878d8'::uuid, '1490978f-f783-4008-b121-2484c21fe553'::uuid),
    ('A', '105221C', '33ded954-9998-43ff-9384-c3ca6788d54f'::uuid, 'e9550efb-29fe-47bb-b866-73dcfb70c0f1'::uuid),
    ('A', '107662F', 'f5baa817-87a6-4f2d-a57f-a02b9e9dd90a'::uuid, '334e27a2-7a5f-4966-957c-b752fe7a2af8'::uuid),
    ('A', '109071B', '7f9cffdb-54ae-47e3-a595-edac98cd0dd6'::uuid, 'b97d43fa-3f45-4219-b644-59b03a2180a5'::uuid),
    ('A', '114585M', 'dd5f7176-0ca9-462c-b399-4f05d06c5e67'::uuid, 'f6ed16e7-69c0-4ca6-aa55-5883309da116'::uuid),
    ('A', '116548M', '1b78ba46-638c-4465-859e-8689e96295a8'::uuid, 'f6f2c69e-0127-4a28-a628-39f72d7f1deb'::uuid),
    ('A', '118491G', 'a0195518-e6a5-4663-88d4-677bd9c8d0b1'::uuid, '352fe535-b15d-4bcf-bb3f-8e58cee88653'::uuid),
    ('A', '118493E', '02c7bc01-0cc8-40bd-a190-b6eea143f3a5'::uuid, '1fd3852b-481b-4d3a-b2bc-b745bcab1b26'::uuid),
    ('B', '014891M', '40afad92-5a55-47d8-88e3-2015c41d11af'::uuid, '244bb9e3-c756-483c-aebc-67f0d3ebdeb4'::uuid),
    ('B', '045960B', '9f50f886-8d83-40b9-8607-28a5d46b44a4'::uuid, 'e29eced9-aa22-4990-a0bf-04c54de0711d'::uuid),
    ('B', '049410M', 'd5e7c833-7912-4046-8b6a-da966520a7c4'::uuid, '2e19bd63-083a-4330-9f26-35ee3d2e765b'::uuid),
    ('B', '055528B', '2d6d3d1c-8f6f-4455-8228-91d3f32ca491'::uuid, 'cac260ab-8608-4233-8005-e7ef650ccadc'::uuid),
    ('B', '060584G', '196a1939-628d-4e86-8e4f-f40e0858be2e'::uuid, '8d3374b8-2059-4858-bf33-911665969ee6'::uuid),
    ('B', '075492K', '8a7a7b24-6ba1-4140-ac35-651552220afd'::uuid, '3aa26679-9dd5-470a-b758-818b8490926a'::uuid),
    ('B', '075503A', '20f2aa2c-1e7f-44c6-950c-47afa7881428'::uuid, '00f019f2-bfe1-4db8-8dc1-55915d17c75b'::uuid),
    ('B', '075504M', '8c317304-0728-42ca-8e14-0b308a5ffbb2'::uuid, 'c63e2bd2-6ec5-4c12-957a-434cc4af20e6'::uuid),
    ('B', '076022K', '6d42acd7-35e9-4975-aa9f-2b7f400d341d'::uuid, '492577a5-245d-42f9-9d29-51a9f05b6637'::uuid),
    ('B', '082403B', '111079e4-ca8d-4a72-bca1-145a141e201d'::uuid, '92427cc6-4b82-4550-a664-04b54b1a3b84'::uuid),
    ('B', '092765D', '670b7ce1-719e-4cdb-91e1-4111d0eba767'::uuid, '5b66b697-9672-4c2b-90a1-d67cda537791'::uuid),
    ('B', '103875C', 'fcde61b0-f5fe-4618-814c-a76a4b4d1dc7'::uuid, 'e6fb8f75-5d8d-46d4-b9bc-11d4bd18ea6c'::uuid),
    ('B', '107421A', '7e117900-eab0-4c4d-8104-11b9ffaf9b26'::uuid, '73fdbbe8-3eeb-4cee-8c0d-2a21e8c71c2a'::uuid),
    ('B', '110293M', '87975d53-8b43-46c8-b209-9924fa43ea79'::uuid, 'f58bf30a-20e2-429e-b76e-46b06f9eec35'::uuid),
    ('B', '114089E', '95fcd50f-257e-43d6-9920-f3599cacf374'::uuid, '1a55d330-2ec7-4554-9cc6-a807e2497108'::uuid),
    ('C1', '0101621', 'e1596a78-53ad-463f-bd1a-1442109c6ac3'::uuid, 'bb5581a1-965a-4d17-9436-95ec5718bad9'::uuid),
    ('C1', '046442E', 'ebfc236d-1c66-4f5b-bd4d-815ad7655e33'::uuid, '0afc091a-68df-47fe-8f4d-46d68176d64c'::uuid),
    ('C1', '061457F', '264c5b84-eff8-49ac-b03f-c8cf12708198'::uuid, '25b031b3-82aa-4fe7-b893-a6c61b3b87b4'::uuid),
    ('C2', '085206E', '2be0fafe-c403-495c-96bc-32b9f181a1a2'::uuid, '7ec47cc4-83d8-4eda-a1a8-7ea313a4ab21'::uuid),
    ('C2', '085209B', '4ad16106-b97b-44e6-b0bb-aa1ebd3b21aa'::uuid, 'b374f0f2-d90e-43e9-9b2e-ad0af0d85440'::uuid),
    ('C1', '085950F', 'fa955ff0-37d1-4c91-826a-89c812cde021'::uuid, '9c3b1064-f3d3-4590-b7f6-5aa0f3d4c411'::uuid),
    ('C1', '103218C', '283a0dd2-0101-45c0-8a09-b0441f51d783'::uuid, '6dac18dd-0137-46a3-9554-4a8f401d6593'::uuid),
    ('C1', '103220J', 'ba8d7def-6f2e-48aa-a314-70603abe8d9c'::uuid, '34594cd0-993a-44c5-86d4-1a6d6555652c'::uuid),
    ('C1', '103223F', 'ff63eb8b-2705-4db7-8500-1db2c548216a'::uuid, 'ac6c69fd-33fa-40a7-9140-839a4bfffbe5'::uuid),
    ('C1', '103227B', 'de86b0d9-bb66-4a7d-8b05-ff1fa2c6d9cd'::uuid, 'e882e231-384f-4958-a8f0-930338fca1d3'::uuid),
    ('C1', '103228A', 'cdc06d73-f08b-40fc-9d30-1700df678e62'::uuid, '5aacfe2c-b49c-4fae-9f8d-5077c8bcf3cd'::uuid),
    ('C1', '103229M', 'd25f60bb-bd10-4956-8337-cdefdff8b1ce'::uuid, '08859f87-3c9f-477e-9d19-34dfd15c0ed2'::uuid),
    ('C1', '103236A', '6b5874f1-770f-4000-9614-56a6df194724'::uuid, '4e90e565-5881-48a2-8003-1dcdc4af33f1'::uuid),
    ('C1', '104982C', '60ebab30-d9a8-47f9-bf7f-85aebc49039f'::uuid, '6fb25eac-aebf-4b1c-b3a3-8c7f238d090d'::uuid),
    ('C1', '114091M', '2cf5c4ac-b56d-44e2-b69e-93b6ce39a475'::uuid, '4a5ee905-3124-474f-9635-1ffa0033fa2f'::uuid),
    ('C1', '121356K', 'b2226705-305a-4e88-9af5-fd8b404239c5'::uuid, 'aae09bf5-0eef-4ada-b193-b4d139efe77c'::uuid);
  select count(distinct course_id), md5(string_agg(course_id::text, ',' order by course_id)) into v_n, v_md5 from e16_l4;
  if v_n <> 43 or v_md5 <> '107b9d74a91cfbd84cbb183df58534ab' then raise exception 'E16 Layer 4 guard: course set % / %', v_n, v_md5; end if;
  -- the containment ran first: none of the links is still active
  select count(*) into v_n from e16_l4 e join catalogue.course_links l on l.id = e.link_id where l.status = 'active';
  if v_n <> 0 then raise exception 'E16 Layer 4 guard: % links are still active; run apply-hold.sql and contain-links.sql first', v_n; end if;
  for r in select e.*, l.url, l.evidence_id from e16_l4 e join catalogue.course_links l on l.id = e.link_id order by e.part, e.code loop
    v_chk := security.course_page_check_v1(r.course_id, r.url);
    v_res := security.binding_refusal_route_v1(r.course_id, r.url,
               jsonb_build_object('verdict', 'refuse', 'rule', 'e16_containment',
                 'reason', 'the page is another award or an older handbook year of this programme (E16 cohort, title and address), so it was taken off the course pending review',
                 'checks', coalesce(v_chk->'checks', '{}'::jsonb) || jsonb_build_object('page_check_verdict', v_chk->>'verdict', 'page_check_rule', v_chk->>'rule', 'e16_part', r.part, 'link_id', r.link_id)),
               'e16_containment', r.evidence_id);
    case v_res when 'item_created' then v_created := v_created + 1; when 'pending_item_kept' then v_kept := v_kept + 1;
               when 'decided_before' then v_decided := v_decided + 1; else v_nothing := v_nothing + 1; end case;
  end loop;
  if v_created + v_kept + v_decided <> 43 then raise exception 'E16 Layer 4: % routed, expected 43 (nothing: %)', v_created + v_kept + v_decided, v_nothing; end if;
  -- no duplicate: at most one pending course-link item per course
  select count(*) into v_n from (select i.entity_id from pipeline.layer4_review_items i join e16_l4 e on e.course_id = i.entity_id
                                  where i.entity_type = 'course' and i.field_code = 'official_course_url' and i.status = 'pending' group by 1 having count(*) > 1) z;
  if v_n <> 0 then raise exception 'E16 Layer 4: % courses would have two pending course-link items; rolled back', v_n; end if;
  insert into pipeline.admin_control_events(area, action, target, detail, actor)
  values ('layer4', 'e16_containment_routed', 'pipeline.layer4_review_items',
          jsonb_build_object('courses', 43, 'course_ids_md5', '107b9d74a91cfbd84cbb183df58534ab', 'item_created', v_created, 'pending_item_kept', v_kept, 'decided_before', v_decided,
                             'route', 'security.binding_refusal_route_v1 (lane e16_containment)', 'decision', 'E16 final disposition, Platform Admin 2 Nov 2026 07:21, section 2'), null);
  raise notice 'E16 Layer 4: created %, pending kept %, decided before %', v_created, v_kept, v_decided;
end $e16l4$;
-- read-back before commit: expect 43 rows, each pending = 1
select i.entity_id, count(*) filter (where i.status = 'pending') pending, count(*) total
  from pipeline.layer4_review_items i where i.entity_type = 'course' and i.field_code = 'official_course_url' and i.entity_id = any(array['02c7bc01-0cc8-40bd-a190-b6eea143f3a5','0d25903f-de8e-460c-b403-2648148fcadd','111079e4-ca8d-4a72-bca1-145a141e201d','196a1939-628d-4e86-8e4f-f40e0858be2e','1b78ba46-638c-4465-859e-8689e96295a8','20f2aa2c-1e7f-44c6-950c-47afa7881428','264c5b84-eff8-49ac-b03f-c8cf12708198','283a0dd2-0101-45c0-8a09-b0441f51d783','2be0fafe-c403-495c-96bc-32b9f181a1a2','2cf5c4ac-b56d-44e2-b69e-93b6ce39a475','2d6d3d1c-8f6f-4455-8228-91d3f32ca491','33ded954-9998-43ff-9384-c3ca6788d54f','40afad92-5a55-47d8-88e3-2015c41d11af','486ed99f-09f3-4ef5-9649-1dec1d9878d8','4ad16106-b97b-44e6-b0bb-aa1ebd3b21aa','51b27099-8086-4c68-9b9f-04c74af883f6','60ebab30-d9a8-47f9-bf7f-85aebc49039f','670b7ce1-719e-4cdb-91e1-4111d0eba767','6b5874f1-770f-4000-9614-56a6df194724','6d42acd7-35e9-4975-aa9f-2b7f400d341d','7cf958c9-c317-4a77-868c-3ba802174d1d','7e117900-eab0-4c4d-8104-11b9ffaf9b26','7f9cffdb-54ae-47e3-a595-edac98cd0dd6','87975d53-8b43-46c8-b209-9924fa43ea79','8a7a7b24-6ba1-4140-ac35-651552220afd','8c317304-0728-42ca-8e14-0b308a5ffbb2','95fcd50f-257e-43d6-9920-f3599cacf374','9f50f886-8d83-40b9-8607-28a5d46b44a4','a0195518-e6a5-4663-88d4-677bd9c8d0b1','a940f900-bfa0-43a8-bba1-1e60c922a699','b2226705-305a-4e88-9af5-fd8b404239c5','ba8d7def-6f2e-48aa-a314-70603abe8d9c','cdc06d73-f08b-40fc-9d30-1700df678e62','d25f60bb-bd10-4956-8337-cdefdff8b1ce','d5e7c833-7912-4046-8b6a-da966520a7c4','dd5f7176-0ca9-462c-b399-4f05d06c5e67','de86b0d9-bb66-4a7d-8b05-ff1fa2c6d9cd','e1596a78-53ad-463f-bd1a-1442109c6ac3','ebfc236d-1c66-4f5b-bd4d-815ad7655e33','f5baa817-87a6-4f2d-a57f-a02b9e9dd90a','fa955ff0-37d1-4c91-826a-89c812cde021','fcde61b0-f5fe-4618-814c-a76a4b4d1dc7','ff63eb8b-2705-4db7-8500-1db2c548216a']::uuid[]) group by 1;
commit;

-- Dedupe proof (optional, after commit): running the block above a second time returns 43 x 'pending_item_kept' and creates nothing (check (2)).
-- Rollback: an item is not deleted; a reviewer settles it ("keep the page we hold"), or the Platform Admin marks it superseded with a reason:
-- update pipeline.layer4_review_items set status = 'superseded' where entity_type = 'course' and field_code = 'official_course_url' and status = 'pending'
--    and change_control_ref like '%E16%' and entity_id = any(array['02c7bc01-0cc8-40bd-a190-b6eea143f3a5','0d25903f-de8e-460c-b403-2648148fcadd','111079e4-ca8d-4a72-bca1-145a141e201d','196a1939-628d-4e86-8e4f-f40e0858be2e','1b78ba46-638c-4465-859e-8689e96295a8','20f2aa2c-1e7f-44c6-950c-47afa7881428','264c5b84-eff8-49ac-b03f-c8cf12708198','283a0dd2-0101-45c0-8a09-b0441f51d783','2be0fafe-c403-495c-96bc-32b9f181a1a2','2cf5c4ac-b56d-44e2-b69e-93b6ce39a475','2d6d3d1c-8f6f-4455-8228-91d3f32ca491','33ded954-9998-43ff-9384-c3ca6788d54f','40afad92-5a55-47d8-88e3-2015c41d11af','486ed99f-09f3-4ef5-9649-1dec1d9878d8','4ad16106-b97b-44e6-b0bb-aa1ebd3b21aa','51b27099-8086-4c68-9b9f-04c74af883f6','60ebab30-d9a8-47f9-bf7f-85aebc49039f','670b7ce1-719e-4cdb-91e1-4111d0eba767','6b5874f1-770f-4000-9614-56a6df194724','6d42acd7-35e9-4975-aa9f-2b7f400d341d','7cf958c9-c317-4a77-868c-3ba802174d1d','7e117900-eab0-4c4d-8104-11b9ffaf9b26','7f9cffdb-54ae-47e3-a595-edac98cd0dd6','87975d53-8b43-46c8-b209-9924fa43ea79','8a7a7b24-6ba1-4140-ac35-651552220afd','8c317304-0728-42ca-8e14-0b308a5ffbb2','95fcd50f-257e-43d6-9920-f3599cacf374','9f50f886-8d83-40b9-8607-28a5d46b44a4','a0195518-e6a5-4663-88d4-677bd9c8d0b1','a940f900-bfa0-43a8-bba1-1e60c922a699','b2226705-305a-4e88-9af5-fd8b404239c5','ba8d7def-6f2e-48aa-a314-70603abe8d9c','cdc06d73-f08b-40fc-9d30-1700df678e62','d25f60bb-bd10-4956-8337-cdefdff8b1ce','d5e7c833-7912-4046-8b6a-da966520a7c4','dd5f7176-0ca9-462c-b399-4f05d06c5e67','de86b0d9-bb66-4a7d-8b05-ff1fa2c6d9cd','e1596a78-53ad-463f-bd1a-1442109c6ac3','ebfc236d-1c66-4f5b-bd4d-815ad7655e33','f5baa817-87a6-4f2d-a57f-a02b9e9dd90a','fa955ff0-37d1-4c91-826a-89c812cde021','fcde61b0-f5fe-4618-814c-a76a4b4d1dc7','ff63eb8b-2705-4db7-8500-1db2c548216a']::uuid[]);   -- expect 43
