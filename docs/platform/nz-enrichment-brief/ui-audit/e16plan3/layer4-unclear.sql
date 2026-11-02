-- CF-247 E16: governed Layer 4 ownership for the 9 "unclear" courses (Decision 2: "The nine inconclusive courses remain under governed
-- review"). PREPARED READ-ONLY 2 NOV 2026 12:45 AEDT. NOT RUN. Project fxcwkweaxjtknorudmwp only. Run as postgres in an allowed minute.
-- Live 2 Nov 12:17 AEDT: none of the 9 has ANY Layer 4 item (pending or historical) and no page rejection, hold or hand lock, so no
--   governed owner exists today. Each holds two active official links: one opaque handbook code (shared with a sibling or the parent) and
--   one own-named or course_url page.
--   Shown now: 7 show their own page (course_url), chosen by the E16-2 projection since refresh #7725; 2 still show the opaque page:
--   La Trobe 080515K (shows 2025/AMIDV; course_url 2024/acid) and 107087K (shows 2025/bm009; course_url 2022/BG004).
-- What this does: one pending course-link item (field official_course_url, review kind course_link, the same shape as
--   security.binding_refusal_route_v1) per course, proposing the opaque page, so a person confirms or refuses it.
--   It does NOT call binding_refusal_route_v1, because that function also writes a page rejection (negative evidence that is never
--   deleted) and these pages are not proved wrong. Nothing is withdrawn, no link changes, no consumer value changes.
-- Dedupe, as the route: advisory lock 'layer4 course link <course>' (the same key every lane uses); a pending official_course_url item ->
--   kept; any earlier item for the same page -> decided before. Expected: 9 created, 0 kept, 0 decided before. Second run: 9 kept.
-- Course ids md5: c88d5936b30660d357732503bf78dd79. Proposed link ids md5: 7c65a293a4d59c52209f373d60f05eda.

begin;
do $e16u$
declare r record; v_created int := 0; v_kept int := 0; v_decided int := 0; v_n int; v_md5 text;
begin
  create temp table e16_u(code text, course_id uuid, link_id uuid, url_md5 text, note text) on commit drop;
  insert into e16_u values
    ('041484B', 'fe4f81a5-9262-41f8-82c7-8fd2c1dee621'::uuid, '7efaa6cf-fb31-4880-8c91-7751fb6bad0a'::uuid, md5('https://handbook.unimelb.edu.au/2026/courses/439fs'), 'handbook code 439fs is shared with GC Food Science 042903B and held by Master of Food Science 061970M; own page gd-foodsc is held and shown'),
    ('042903B', '26f9b73e-f6e3-41bc-8ff0-b7df8a2ef428'::uuid, '314efb1f-a39c-4e2d-ae7d-2eb07fea9f4a'::uuid, md5('https://handbook.unimelb.edu.au/2026/courses/439fs'), 'handbook code 439fs is shared with GD Food Science 041484B and held by Master of Food Science 061970M; own page gc-foodsc is held and shown'),
    ('071684A', 'f013a634-9344-4ae8-8ae6-07c2310b3e93'::uuid, '3d1f5bb7-41ce-4b24-a14f-7659cc52e8fa'::uuid, md5('https://www.canberra.edu.au/course/309JA/4'), 'course code 309JA/4 does not name the award; the held page 844AA/6/2027 (course_url, shown) is also an opaque code'),
    ('075327A', '2bdf84a5-a806-469e-83a1-5e500559dfe4'::uuid, 'e4652887-b70e-4fea-ac45-c2736998003d'::uuid, md5('https://handbook.unimelb.edu.au/2026/courses/277aa'), 'handbook code 277aa is held by Master of Intellectual Property Law 075000B; the held page 276aa (course_url, shown) is also an opaque code'),
    ('075333C', 'f0052042-998a-4f05-843f-467ff76a021c'::uuid, '3f4458dc-1af0-45aa-9630-5e3e0e8aa976'::uuid, md5('https://handbook.unimelb.edu.au/2026/courses/195aa'), 'handbook code 195aa is held by Master of Construction Law 074998C; the held page 189aa (course_url, shown) is also an opaque code'),
    ('080515K', '488f50c4-e7d3-4b21-a8a1-8ed95fcc0a03'::uuid, 'b8141b8f-19f2-408e-83b9-45c7d80aa7e8'::uuid, md5('https://handbook.latrobe.edu.au/courses/2025/AMIDV'), 'SHOWN: handbook code 2025/AMIDV is shared with GD International Development 067404D and held by Master 079183B; the held page 2024/acid (course_url) is an older year'),
    ('107087K', 'ad154e70-d0aa-45e8-a2f3-76f84d5c2902'::uuid, '3a01b46b-6413-4a75-b91e-2192f067e2b5'::uuid, md5('https://handbook.latrobe.edu.au/courses/2025/bm009'), 'SHOWN: handbook code 2025/bm009 is shared with GC Marketing 113897C and held by Master of Marketing 093383K; the held page 2022/BG004 (course_url) is an older year'),
    ('113897C', '6bad09d8-f8a1-45e9-9f1c-f8ba258d74d2'::uuid, '30a279e0-076d-4f3d-bd24-e1cf6593e256'::uuid, md5('https://handbook.latrobe.edu.au/courses/2025/bm009'), 'handbook code 2025/bm009 is shared with GD Marketing 107087K; own named page graduate-certificate-in-marketing is held and shown'),
    ('120129G', '8bdf836f-7de2-4570-be80-d87864c3e7e2'::uuid, '6d6a1b11-c697-41ce-b0ad-2468ce4f11e3'::uuid, md5('https://handbook.unimelb.edu.au/2026/courses/244cw'), 'handbook code 244cw is held by Master of Public Health 020358D; own named page gc-pubhlth is held and shown');
  select count(distinct course_id), md5(string_agg(course_id::text, ',' order by course_id)) into v_n, v_md5 from e16_u;
  if v_n <> 9 or v_md5 <> 'c88d5936b30660d357732503bf78dd79' then raise exception 'E16 unclear guard 1: course set % / %', v_n, v_md5; end if;
  select md5(string_agg(link_id::text, ',' order by link_id)) into v_md5 from e16_u;
  if v_md5 <> '7c65a293a4d59c52209f373d60f05eda' then raise exception 'E16 unclear guard 1b: link set %', v_md5; end if;
  -- guard 2: each proposed link is still an active official link of the course at the same address, and the course still holds 2 active links
  select count(*) into v_n from e16_u e join catalogue.course_links l on l.id = e.link_id
   where l.course_id = e.course_id and l.link_type = 'official_course' and l.status = 'active' and md5(l.url) = e.url_md5
     and (select count(*) from catalogue.course_links o where o.course_id = e.course_id and o.link_type = 'official_course' and o.status = 'active') = 2;
  if v_n <> 9 then raise exception 'E16 unclear guard 2: % of 9 links are as read on 2 Nov; re-read', v_n; end if;
  -- guard 3: course active, not held, no hand lock
  select count(*) into v_n from e16_u e join catalogue.courses c on c.id = e.course_id
   where c.lifecycle_status = 'active' and not security.course_held_v1(e.course_id)
     and not exists (select 1 from pipeline.manual_locks k where k.entity = 'course' and k.entity_id = e.course_id and k.field in ('official_url', 'course_url'));
  if v_n <> 9 then raise exception 'E16 unclear guard 3: % of 9 courses are active, not held and unlocked', v_n; end if;

  for r in select e.*, l.url, l.evidence_id from e16_u e join catalogue.course_links l on l.id = e.link_id order by e.code loop
    perform pg_advisory_xact_lock(hashtext('layer4 course link ' || r.course_id::text));
    if exists (select 1 from pipeline.layer4_review_items i where i.entity_type = 'course' and i.entity_id = r.course_id and i.field_code = 'official_course_url' and i.status = 'pending') then
      v_kept := v_kept + 1; continue;
    end if;
    if exists (select 1 from pipeline.layer4_review_items i where i.entity_type = 'course' and i.entity_id = r.course_id and i.field_code = 'official_course_url'
                  and i.proposed_value->>'course_url' = r.url) then
      v_decided := v_decided + 1; continue;
    end if;
    insert into pipeline.layer4_review_items(entity_type, entity_id, field_code, evidence_id, before_value, proposed_value, layer2_state, layer3_state, status, escalation_reason, change_control_ref)
    values ('course', r.course_id, 'official_course_url', (select a.id from pipeline.evidence_artifacts a where a.id = r.evidence_id),
            (select coalesce(jsonb_agg(l.url order by l.is_primary desc, l.url), '[]'::jsonb) from catalogue.course_links l where l.course_id = r.course_id and l.link_type = 'official_course' and l.status = 'active'),
            jsonb_build_object('course_url', r.url),
            jsonb_build_object('source', 'e16 unclear', 'page', r.url, 'rule', 'e16_unclear', 'lane', 'e16_governed_review', 'check', jsonb_build_object('link_id', r.link_id, 'note', r.note)),
            '{}'::jsonb, 'pending',
            'This course holds two pages. This one uses a handbook code that does not name the award (' || r.note || '). If it is this course''s own page, choose Use the new page; otherwise keep the page we hold.',
            'CF-CHG-20260915-247; E16 Decision 2 (Platform Admin 2 Nov 2026 10:56): nine inconclusive courses under governed review');
    v_created := v_created + 1;
  end loop;
  if v_created + v_kept + v_decided <> 9 then raise exception 'E16 unclear: % routed, expected 9', v_created + v_kept + v_decided; end if;
  select count(*) into v_n from (select i.entity_id from pipeline.layer4_review_items i join e16_u e on e.course_id = i.entity_id
                                  where i.entity_type = 'course' and i.field_code = 'official_course_url' and i.status = 'pending' group by 1 having count(*) > 1) z;
  if v_n <> 0 then raise exception 'E16 unclear: % courses would have two pending course-link items; rolled back', v_n; end if;
  insert into pipeline.admin_control_events(area, action, target, detail, actor)
  values ('layer4', 'e16_unclear_routed', 'pipeline.layer4_review_items',
          jsonb_build_object('courses', 9, 'course_ids_md5', 'c88d5936b30660d357732503bf78dd79', 'item_created', v_created, 'pending_item_kept', v_kept, 'decided_before', v_decided,
                             'withdrawal', false, 'page_rejection', false, 'decision', 'Platform Admin consolidated decision pack 2 Nov 2026 10:56, Decision 2'), null);
  raise notice 'E16 unclear: created %, pending kept %, decided before %', v_created, v_kept, v_decided;
end $e16u$;
select i.entity_id, count(*) filter (where i.status = 'pending') pending, count(*) total
  from pipeline.layer4_review_items i where i.entity_type = 'course' and i.field_code = 'official_course_url'
   and i.entity_id = any(array['488f50c4-e7d3-4b21-a8a1-8ed95fcc0a03','ad154e70-d0aa-45e8-a2f3-76f84d5c2902','6bad09d8-f8a1-45e9-9f1c-f8ba258d74d2','fe4f81a5-9262-41f8-82c7-8fd2c1dee621','26f9b73e-f6e3-41bc-8ff0-b7df8a2ef428','2bdf84a5-a806-469e-83a1-5e500559dfe4','f0052042-998a-4f05-843f-467ff76a021c','8bdf836f-7de2-4570-be80-d87864c3e7e2','f013a634-9344-4ae8-8ae6-07c2310b3e93']::uuid[]) group by 1;   -- expect 9 rows, pending = 1
commit;
-- Rollback: items are not deleted; the Platform Admin marks them superseded with a reason:
-- update pipeline.layer4_review_items set status = 'superseded' where entity_type = 'course' and field_code = 'official_course_url' and status = 'pending'
--    and layer2_state->>'rule' = 'e16_unclear' and entity_id = any(<the 9 course ids>);   -- expect 9
