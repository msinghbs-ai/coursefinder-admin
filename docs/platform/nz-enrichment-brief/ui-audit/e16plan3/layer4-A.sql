-- CF-247 E16 group (a): Layer 4 routing of the 12 courses contained by contain-links-A.sql, through security.binding_refusal_route_v1
-- (the layer4-BC2.sql pattern, executed 10:25 as event #28608). PREPARED READ-ONLY 2 NOV 2026. NOT RUN. Project fxcwkweaxjtknorudmwp only.
-- Run as postgres AFTER contain-links-A.sql has committed, in an allowed minute (:x6-:x8 with today's stagger; never :35-:42).
-- Authority: Platform Admin consolidated decision pack 2 Nov 2026 10:56, Decision 1 ("Route unresolved course links through the existing
--   Layer 4 review mechanism"; "The project must not wait for all 12 replacement URLs to be found").
-- Why it must be raised here: no lane raises these items itself. contain-links-A adds a page rejection, so exit_awards_apply_v2 stops
--   before its own route call (and none of the 12 has an award row the lane applies: 8 have no award row; Collarts 118491G/118493E,
--   Flinders 105122F and Torrens 089932J have adapter rows with register_check 'fail' that the lane skips); the binding guard routes only a page being bound or re-bound.
-- Dedupe (the function's own, live md5 488ef1836fa2ba842009168b9e499d73 at 09:25; re-checked by guard 0):
--   advisory lock 'layer4 course link <course>'; a pending official_course_url item -> 'pending_item_kept'; an earlier item for this page ->
--   'decided_before'. Live 2 Nov 11:05: 0 official_course_url items (any status) on the 12 courses; the only Layer 4 rows on them are
--   superseded items of other kinds (course_english, course_intake, provider_current_tuition_validation). Expected: 12 created, 0 kept, 0 decided.
-- The route's own page_rejections insert is 'on conflict do nothing', so the e16_containment row from contain-links-A is kept.
-- Course ids md5 (sorted, comma-joined): c32e8f7a59dc91d1927e9f96d5ecf032.

begin;
do $e16l4a$
declare
  r record; v_res text; v_chk jsonb;
  v_created int := 0; v_kept int := 0; v_decided int := 0; v_nothing int := 0; v_n int; v_md5 text;
begin
  -- guard 0: the route function is the definition this file was written against
  if md5(pg_get_functiondef('security.binding_refusal_route_v1(uuid,text,jsonb,text,uuid)'::regprocedure)) <> '488ef1836fa2ba842009168b9e499d73' then
    raise exception 'E16 Layer 4 A guard 0: security.binding_refusal_route_v1 differs from the definition read on 2 Nov; re-read';
  end if;
  create temp table e16_l4a(part text, code text, course_id uuid, link_id uuid) on commit drop;
  insert into e16_l4a values
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
    ('A', '118493E', '02c7bc01-0cc8-40bd-a190-b6eea143f3a5'::uuid, '1fd3852b-481b-4d3a-b2bc-b745bcab1b26'::uuid);
  select count(distinct course_id), md5(string_agg(course_id::text, ',' order by course_id)) into v_n, v_md5 from e16_l4a;
  if v_n <> 12 or v_md5 <> 'c32e8f7a59dc91d1927e9f96d5ecf032' then raise exception 'E16 Layer 4 A guard: course set % / %', v_n, v_md5; end if;
  -- the containment ran first: none of the links is still active, and each carries the e16_containment_a rejection
  select count(*) into v_n from e16_l4a e join catalogue.course_links l on l.id = e.link_id where l.status = 'active';
  if v_n <> 0 then raise exception 'E16 Layer 4 A guard: % links are still active; run contain-links-A.sql first', v_n; end if;
  select count(*) into v_n from e16_l4a e join catalogue.course_links l on l.id = e.link_id
    join pipeline.page_rejections pr on pr.course_id = e.course_id and pr.url = l.url and pr.source = 'e16_containment' and pr.signals->>'tag' = 'e16_containment_a';
  if v_n <> 12 then raise exception 'E16 Layer 4 A guard: % of 12 contained pages carry the e16_containment_a rejection', v_n; end if;
  for r in select e.*, l.url, l.evidence_id from e16_l4a e join catalogue.course_links l on l.id = e.link_id order by e.code loop
    v_chk := security.course_page_check_v1(r.course_id, r.url);
    v_res := security.binding_refusal_route_v1(r.course_id, r.url,
               jsonb_build_object('verdict', 'refuse', 'rule', 'e16_containment',
                 'reason', 'the page is another programme''s page (a sibling award, a double degree or the parent master), so it was taken off the course pending review',
                 'checks', coalesce(v_chk->'checks', '{}'::jsonb) || jsonb_build_object('page_check_verdict', v_chk->>'verdict', 'page_check_rule', v_chk->>'rule', 'e16_part', r.part, 'link_id', r.link_id)),
               'e16_containment', r.evidence_id);
    case v_res when 'item_created' then v_created := v_created + 1; when 'pending_item_kept' then v_kept := v_kept + 1;
               when 'decided_before' then v_decided := v_decided + 1; else v_nothing := v_nothing + 1; end case;
  end loop;
  if v_created + v_kept + v_decided <> 12 then raise exception 'E16 Layer 4 A: % routed, expected 12 (nothing: %)', v_created + v_kept + v_decided, v_nothing; end if;
  -- no duplicate: at most one pending course-link item per course
  select count(*) into v_n from (select i.entity_id from pipeline.layer4_review_items i join e16_l4a e on e.course_id = i.entity_id
                                  where i.entity_type = 'course' and i.field_code = 'official_course_url' and i.status = 'pending' group by 1 having count(*) > 1) z;
  if v_n <> 0 then raise exception 'E16 Layer 4 A: % courses would have two pending course-link items; rolled back', v_n; end if;
  insert into pipeline.admin_control_events(area, action, target, detail, actor)
  values ('layer4', 'e16_containment_routed', 'pipeline.layer4_review_items',
          jsonb_build_object('courses', 12, 'parts', 'A', 'course_ids_md5', v_md5, 'item_created', v_created, 'pending_item_kept', v_kept, 'decided_before', v_decided,
                             'route', 'security.binding_refusal_route_v1 (lane e16_containment)', 'decision', 'Platform Admin consolidated decision pack 2 Nov 2026 10:56, Decision 1'), null);
  raise notice 'E16 Layer 4 A: created %, pending kept %, decided before %', v_created, v_kept, v_decided;
end $e16l4a$;
-- read-back before commit: expect 12 rows, each pending = 1
select i.entity_id, count(*) filter (where i.status = 'pending') pending, count(*) total
  from pipeline.layer4_review_items i where i.entity_type = 'course' and i.field_code = 'official_course_url'
   and i.entity_id = any(array['7cf958c9-c317-4a77-868c-3ba802174d1d','a940f900-bfa0-43a8-bba1-1e60c922a699','f5baa817-87a6-4f2d-a57f-a02b9e9dd90a','a0195518-e6a5-4663-88d4-677bd9c8d0b1','02c7bc01-0cc8-40bd-a190-b6eea143f3a5','486ed99f-09f3-4ef5-9649-1dec1d9878d8','7f9cffdb-54ae-47e3-a595-edac98cd0dd6','1b78ba46-638c-4465-859e-8689e96295a8','0d25903f-de8e-460c-b403-2648148fcadd','33ded954-9998-43ff-9384-c3ca6788d54f','51b27099-8086-4c68-9b9f-04c74af883f6','dd5f7176-0ca9-462c-b399-4f05d06c5e67']::uuid[]) group by 1;
commit;

-- Dedupe proof (optional, after commit): running the block a second time returns 12 x 'pending_item_kept' and creates nothing.
-- Rollback: an item is not deleted; a reviewer settles it ("keep the page we hold"), or the Platform Admin marks it superseded with a reason:
-- update pipeline.layer4_review_items set status = 'superseded' where entity_type = 'course' and field_code = 'official_course_url' and status = 'pending'
--    and change_control_ref like '%E16%' and entity_id = any(<the 12 course ids above>);   -- expect 12
