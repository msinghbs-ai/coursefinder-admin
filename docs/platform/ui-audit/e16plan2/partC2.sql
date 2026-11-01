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
