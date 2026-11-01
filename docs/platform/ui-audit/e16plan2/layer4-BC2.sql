do $e16l4$
declare
  r record; v_res text; v_chk jsonb; v_url text; v_ev uuid;
  v_created int := 0; v_kept int := 0; v_decided int := 0; v_nothing int := 0; v_n int; v_md5 text;
begin
  create temp table e16_l4(part text, code text, course_id uuid, link_id uuid) on commit drop;
  insert into e16_l4 values
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
    ('C2', '085206E', '2be0fafe-c403-495c-96bc-32b9f181a1a2'::uuid, '7ec47cc4-83d8-4eda-a1a8-7ea313a4ab21'::uuid),
    ('C2', '085209B', '4ad16106-b97b-44e6-b0bb-aa1ebd3b21aa'::uuid, 'b374f0f2-d90e-43e9-9b2e-ad0af0d85440'::uuid);
  select count(distinct course_id), md5(string_agg(course_id::text, ',' order by course_id)) into v_n, v_md5 from e16_l4;
  if v_n <> 17 then raise exception 'E16 Layer 4 guard: course set % / %', v_n, v_md5; end if;
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
  if v_created + v_kept + v_decided <> 17 then raise exception 'E16 Layer 4: % routed, expected 17 (nothing: %)', v_created + v_kept + v_decided, v_nothing; end if;
  -- no duplicate: at most one pending course-link item per course
  select count(*) into v_n from (select i.entity_id from pipeline.layer4_review_items i join e16_l4 e on e.course_id = i.entity_id
                                  where i.entity_type = 'course' and i.field_code = 'official_course_url' and i.status = 'pending' group by 1 having count(*) > 1) z;
  if v_n <> 0 then raise exception 'E16 Layer 4: % courses would have two pending course-link items; rolled back', v_n; end if;
  insert into pipeline.admin_control_events(area, action, target, detail, actor)
  values ('layer4', 'e16_containment_routed', 'pipeline.layer4_review_items',
          jsonb_build_object('courses', 17, 'parts', 'B and C2', 'course_ids_md5', v_md5, 'item_created', v_created, 'pending_item_kept', v_kept, 'decided_before', v_decided,
                             'route', 'security.binding_refusal_route_v1 (lane e16_containment)', 'decision', 'E16 final disposition, Platform Admin 2 Nov 2026 07:21, section 2'), null);
  raise notice 'E16 Layer 4: created %, pending kept %, decided before %', v_created, v_kept, v_decided;
end $e16l4$;