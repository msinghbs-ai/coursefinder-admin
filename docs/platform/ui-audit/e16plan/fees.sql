-- CF-247 E16 fee suppression: withdraw the 31 provider fees read from a sibling-award page (E1 pattern: status 'inactive', note, valid_to).
-- PASTE FILE PREPARED READ-ONLY ON 2 NOV 2026. NOT RUN. Not a migration (Pilot CLAUDE.md: changes of this kind go to the Platform Admin as a paste file).
-- Authority: Platform Admin 2 Nov 2026 07:21 AEDT, E16 final disposition decision, section 2 action 4 ("suppress unsupported fees where provenance
--   verifies a wrong-course source, using approved reversible correction controls"). The classification is a candidate assessment, not proof.
-- Cohort: docs/platform/ui-audit/e16-sibling-variant-cohort-2026-11-02.csv; fee ids md5 fa15331cda52edbb2d4ea0cff1cd6c26 (sorted ids joined with ',').
-- Proof per row: the fee's own evidence (catalogue.course_fees.evidence_id) is a stored source_snapshot whose source_url, ignoring any #fragment,
--   is exactly the sibling page the course showed on 2 Nov (expected values are frozen below and re-checked live).
-- DECISION NEEDED FIRST (see e16plan/report.md, D2): 29 of the 31 were written deliberately by the exit-award rule (security.exit_awards_apply_v2:
--   "annual fee as the course" of the parent award). Two (Flinders 105122F, UQ 116548M) are direct reads of the wrong page.
-- PRECONDITION (guard 5): the hourly job exit-awards-apply (:37) re-writes a withdrawn exit-award fee as 'active' within the hour. This file refuses to
--   run while any of the 31 courses still has an exit-award row the job would apply. Switch those rows off first (public.admin_exit_awards 'off',
--   Platform Admin, reason logged; reversible with 'on'), or remove guard 5 only on a recorded Platform Admin decision.
-- Rollback: the second block at the end of this file (same ids, inactive -> active, same guards).

begin;
do $e16f$
declare
  v_ids uuid[] := array[
  '191d4b0e-bbba-4c36-bc18-102fc00c5906',
  '266cfa9b-802f-42a5-91b4-288f526a6cfa',
  '34b2de4c-7f3b-4016-8850-e6c19c60f680',
  '36fb521a-a62b-4749-9aed-d3f099f78e7e',
  '37b7a8f9-aa04-42a6-8114-acb9ca8274bc',
  '4942e2ea-c735-427a-b4c9-0f29a58a9866',
  '4b53cb71-d5a6-43f9-9073-c353a60e60bc',
  '548b8ad7-3110-4490-97ad-ffd0344dea76',
  '5802ffe3-a74b-474b-b532-dec6d89f1fb7',
  '59b3859c-818e-4779-97e7-a3435528e9af',
  '5fb48e19-49c2-4adf-9649-a33125cafe4f',
  '6462dc9f-8a18-4ae9-82f3-4d6b3f2926c2',
  '67841648-642d-434c-a923-e4a9327a8ab3',
  '68c9a341-b444-4201-b3e2-5d7ed715a530',
  '69c6da38-c3b0-4a76-be90-242f047e05ae',
  '712a5368-8841-435a-a3ac-5c6eb31a9a91',
  '7253f4a7-3138-44c0-9213-33468ce5dbe0',
  '8d9a1c5d-8131-46a3-9404-7ff0c5968963',
  '8ecb865a-6d90-407c-beba-df39c5a83c62',
  '8f6a080a-f8e5-49ae-8832-d971191885ab',
  '98cc7c9b-a8b6-4b95-853a-22570d478223',
  '9f056cbf-f183-469d-959a-556cd122ce92',
  '9fbb1d35-1e83-45f8-999b-936ad132173f',
  'e630b018-ec0f-4b8a-ad9d-f95aadb1f662',
  'e79c15a7-7a67-4181-b317-9a9c9598e409',
  'eb97e07d-1aca-499b-906f-b61064634f34',
  'ed928df0-7176-4736-a726-67d4e2b47564',
  'f14eb0b2-9d1c-4cc8-8e81-efc6358f0e6a',
  'faceaf44-c841-4109-8511-8271e84fe61b',
  'fd2134f9-9c34-4ebd-800a-66c220f52a57',
  'fd5c87a9-11ec-47f2-a0e6-e09e3b9a2a95'
  ]::uuid[];
  v_n int; v_md5 text; v_upd int;
begin
  -- guard 1: the id set
  select count(distinct x), md5(string_agg(x::text, ',' order by x)) into v_n, v_md5 from unnest(v_ids) x;
  if v_n <> 31 or v_md5 <> 'fa15331cda52edbb2d4ea0cff1cd6c26' then
    raise exception 'E16 fee guard 1: expected 31 ids with md5 fa15331c..., got % (%)', v_n, v_md5;
  end if;
  -- guard 2: every row is still the active provider fee on the same course, amount, year and evidence as read on 2 Nov
  -- guard 3: its evidence source_url (without #fragment) is still exactly the sibling page
  select count(*) into v_n
    from (values
    ('191d4b0e-bbba-4c36-bc18-102fc00c5906'::uuid, '283a0dd2-0101-45c0-8a09-b0441f51d783'::uuid, '5ab4c7b5-aa3e-4fca-b966-a3b28a97fc1e'::uuid, 'https://www.rmit.edu.au/study-with-us/levels-of-study/postgraduate-study/masters-by-coursework/master-of-urban-design-mc193', 54060, 2027)  -- 103218C,
    ('266cfa9b-802f-42a5-91b4-288f526a6cfa'::uuid, 'ebfc236d-1c66-4f5b-bd4d-815ad7655e33'::uuid, '59988fcd-bd8d-4dee-b562-6fbc62c316b1'::uuid, 'https://www.griffith.edu.au/study/degrees/master-of-public-health-5263', 41000, 2027)  -- 046442E,
    ('34b2de4c-7f3b-4016-8850-e6c19c60f680'::uuid, 'cdc06d73-f08b-40fc-9d30-1700df678e62'::uuid, '755bcbef-97fd-4b53-bbfd-cc0fab8f9445'::uuid, 'https://www.rmit.edu.au/study-with-us/levels-of-study/postgraduate-study/masters-by-coursework/master-of-justice-and-criminology-mc223', 41280, 2027)  -- 103228A,
    ('36fb521a-a62b-4749-9aed-d3f099f78e7e'::uuid, 'e1596a78-53ad-463f-bd1a-1442109c6ac3'::uuid, '1afa1229-dca9-4de7-96b0-a21194c144ee'::uuid, 'https://www.griffith.edu.au/study/degrees/master-of-international-law-studies-5738', 47000, 2027)  -- 0101621,
    ('37b7a8f9-aa04-42a6-8114-acb9ca8274bc'::uuid, '2cf5c4ac-b56d-44e2-b69e-93b6ce39a475'::uuid, 'b40fcbbf-3234-4d48-8e1e-c420f6b8f366'::uuid, 'https://www.griffith.edu.au/study/degrees/master-of-integrated-water-management-5766', 41000, 2027)  -- 114091M,
    ('4942e2ea-c735-427a-b4c9-0f29a58a9866'::uuid, 'ff63eb8b-2705-4db7-8500-1db2c548216a'::uuid, 'd5d6c905-9f3b-4326-b157-18392fa5816d'::uuid, 'https://www.rmit.edu.au/study-with-us/levels-of-study/postgraduate-study/masters-by-coursework/master-of-communication-design-mc250', 45120, 2027)  -- 103223F,
    ('4b53cb71-d5a6-43f9-9073-c353a60e60bc'::uuid, '40afad92-5a55-47d8-88e3-2015c41d11af'::uuid, 'd9b11f97-1310-4e51-8c48-547200d09bab'::uuid, 'https://www.rmit.edu.au/study-with-us/levels-of-study/postgraduate-study/masters-by-coursework/master-of-marketing-mc197', 50880, 2027)  -- 014891M,
    ('548b8ad7-3110-4490-97ad-ffd0344dea76'::uuid, '004b6c5c-4a6a-4b65-9f8d-1093049ea150'::uuid, '84146b56-6739-493d-a8bc-8e94de4b31d8'::uuid, 'https://www.rmit.edu.au/study-with-us/levels-of-study/postgraduate-study/masters-by-coursework/master-of-communication-mc248', 45120, 2027)  -- 103221H,
    ('5802ffe3-a74b-474b-b532-dec6d89f1fb7'::uuid, '111079e4-ca8d-4a72-bca1-145a141e201d'::uuid, '8064084b-c81e-42e5-aa04-3313c1610780'::uuid, 'https://www.griffith.edu.au/study/degrees/master-of-finance-5592', 43000, 2027)  -- 082403B,
    ('59b3859c-818e-4779-97e7-a3435528e9af'::uuid, '196a1939-628d-4e86-8e4f-f40e0858be2e'::uuid, '89b533a7-1ab9-474c-9491-3cd0581235a7'::uuid, 'https://www.rmit.edu.au/study-with-us/levels-of-study/postgraduate-study/masters-by-coursework/master-of-finance-mc201', 50880, 2027)  -- 060584G,
    ('5fb48e19-49c2-4adf-9649-a33125cafe4f'::uuid, 'd3443473-9636-4a37-a6ed-e531c863a101'::uuid, 'e98b5b80-9571-4bf2-a240-1b91859bbeda'::uuid, 'https://www.rmit.edu.au/study-with-us/levels-of-study/postgraduate-study/masters-by-coursework/master-of-advertising-mc249', 45120, 2027)  -- 103222G,
    ('6462dc9f-8a18-4ae9-82f3-4d6b3f2926c2'::uuid, '264c5b84-eff8-49ac-b03f-c8cf12708198'::uuid, '6216d4a3-0252-40fb-9041-8c7e3b63372c'::uuid, 'https://www.griffith.edu.au/study/degrees/master-of-urban-and-environmental-planning-5576', 46500, 2027)  -- 061457F,
    ('67841648-642d-434c-a923-e4a9327a8ab3'::uuid, 'fa955ff0-37d1-4c91-826a-89c812cde021'::uuid, '6942a32e-21da-4572-88dd-84f9b2681639'::uuid, 'https://study.unimelb.edu.au/find/courses/graduate/graduate-diploma-in-science-advanced/', 60992, 2026)  -- 085950F,
    ('68c9a341-b444-4201-b3e2-5d7ed715a530'::uuid, '1bfad09c-0734-4ef2-802a-52381c9d2ffa'::uuid, '4d600602-6ad4-484b-9333-8345c0fece6a'::uuid, 'https://www.rmit.edu.au/study-with-us/levels-of-study/postgraduate-study/masters-by-coursework/master-of-energy-efficient-and-sustainable-building-mc209', 48000, 2027)  -- 103226C,
    ('69c6da38-c3b0-4a76-be90-242f047e05ae'::uuid, '1b78ba46-638c-4465-859e-8689e96295a8'::uuid, '35e7642f-2d26-4a32-9e50-89f4c195895c'::uuid, 'https://study.uq.edu.au/study-options/programs/bachelor-nutrition-sciences-master-dietetics-studies-2534', 60952, 2027)  -- 116548M,
    ('712a5368-8841-435a-a3ac-5c6eb31a9a91'::uuid, '2d6d3d1c-8f6f-4455-8228-91d3f32ca491'::uuid, '542cac32-f97d-41ea-bb51-2ac45182a8e3'::uuid, 'https://www.rmit.edu.au/study-with-us/levels-of-study/postgraduate-study/masters-by-coursework/master-of-professional-accounting-mc194', 50880, 2027)  -- 055528B,
    ('7253f4a7-3138-44c0-9213-33468ce5dbe0'::uuid, '486ed99f-09f3-4ef5-9649-1dec1d9878d8'::uuid, '7be3c2d1-99f9-46b0-a487-9d5420892bd2'::uuid, 'https://www.flinders.edu.au/study/courses/postgraduate-master-computer-science', 42900, 2026)  -- 105122F,
    ('8d9a1c5d-8131-46a3-9404-7ff0c5968963'::uuid, '7e117900-eab0-4c4d-8104-11b9ffaf9b26'::uuid, '643764b9-72c9-4dd5-9637-1df8bbd7865f'::uuid, 'https://www.griffith.edu.au/study/degrees/master-of-professional-accounting-5683', 42500, 2027)  -- 107421A,
    ('8ecb865a-6d90-407c-beba-df39c5a83c62'::uuid, '4241f004-3144-4fd4-8468-960854850e38'::uuid, 'f96aa4da-79c7-4c6e-a563-42135327fb0c'::uuid, 'https://www.latrobe.edu.au/courses/master-of-art-therapy', 44800, 2027)  -- 043153E,
    ('8f6a080a-f8e5-49ae-8832-d971191885ab'::uuid, 'b86828bb-9b14-46b4-a9bc-50a8de61fa39'::uuid, '8d30c69d-1b8d-4c97-8663-b9eea8777326'::uuid, 'https://study.unimelb.edu.au/find/courses/graduate/master-of-arts-thesis-only/', 50976, 2026)  -- 031944F,
    ('98cc7c9b-a8b6-4b95-853a-22570d478223'::uuid, 'b2226705-305a-4e88-9af5-fd8b404239c5'::uuid, 'f1d69aaa-d049-421a-8ff4-5e4d5cf4430c'::uuid, 'https://www.scu.edu.au/study/courses/master-of-teaching-1209001/', 27000, 2026)  -- 121356K,
    ('9f056cbf-f183-469d-959a-556cd122ce92'::uuid, '6b5874f1-770f-4000-9614-56a6df194724'::uuid, 'b14c9ac1-887b-4a6b-992a-d9d39a18ea80'::uuid, 'https://www.rmit.edu.au/study-with-us/levels-of-study/postgraduate-study/masters-by-coursework/master-of-arts-arts-management-mc280', 43200, 2027)  -- 103236A,
    ('9fbb1d35-1e83-45f8-999b-936ad132173f'::uuid, 'd25f60bb-bd10-4956-8337-cdefdff8b1ce'::uuid, '683a1955-fcb3-4952-8e46-66b0873dc99d'::uuid, 'https://www.rmit.edu.au/study-with-us/levels-of-study/postgraduate-study/masters-by-coursework/master-of-interior-design-mc275', 50880, 2027)  -- 103229M,
    ('e630b018-ec0f-4b8a-ad9d-f95aadb1f662'::uuid, 'ba8d7def-6f2e-48aa-a314-70603abe8d9c'::uuid, '0f1a4927-22f0-4b83-bfcd-9a8b5583da1b'::uuid, 'https://www.rmit.edu.au/study-with-us/levels-of-study/postgraduate-study/masters-by-coursework/master-of-animation-games-and-interactivity-mc232', 45120, 2027)  -- 103220J,
    ('e79c15a7-7a67-4181-b317-9a9c9598e409'::uuid, 'a021a3df-3ad0-43c1-a9b2-54d479473078'::uuid, '9323583a-0a5e-4ce2-8ec5-27daba912a92'::uuid, 'https://www.rmit.edu.au/study-with-us/levels-of-study/postgraduate-study/masters-by-coursework/master-of-writing-and-publishing-mc262', 45120, 2027)  -- 103224E,
    ('eb97e07d-1aca-499b-906f-b61064634f34'::uuid, '95fcd50f-257e-43d6-9920-f3599cacf374'::uuid, 'b40fcbbf-3234-4d48-8e1e-c420f6b8f366'::uuid, 'https://www.griffith.edu.au/study/degrees/master-of-integrated-water-management-5766', 41000, 2027)  -- 114089E,
    ('ed928df0-7176-4736-a726-67d4e2b47564'::uuid, '6d42acd7-35e9-4975-aa9f-2b7f400d341d'::uuid, 'db32d95f-694e-4b74-96ac-6978f1347b4a'::uuid, 'https://www.rmit.edu.au/study-with-us/levels-of-study/postgraduate-study/masters-by-coursework/master-of-business-information-technology-mc200', 50880, 2027)  -- 076022K,
    ('f14eb0b2-9d1c-4cc8-8e81-efc6358f0e6a'::uuid, 'de86b0d9-bb66-4a7d-8b05-ff1fa2c6d9cd'::uuid, 'f07f31b5-6923-47b7-a480-4a389c485c8c'::uuid, 'https://www.rmit.edu.au/study-with-us/levels-of-study/postgraduate-study/masters-by-coursework/master-of-urban-planning-and-environment-mc221', 41280, 2027)  -- 103227B,
    ('faceaf44-c841-4109-8511-8271e84fe61b'::uuid, '6f60c044-d710-420a-aed5-c6567c275f13'::uuid, '035830d0-fa1b-45a1-b54e-8b635abae494'::uuid, 'https://www.rmit.edu.au/study-with-us/levels-of-study/postgraduate-study/masters-by-coursework/master-of-media-mc188', 45120, 2027)  -- 103217D,
    ('fd2134f9-9c34-4ebd-800a-66c220f52a57'::uuid, 'da0667c1-9818-4ab3-bbf7-c047f5de404d'::uuid, '652214c1-df09-4575-96a0-aea0b8be813a'::uuid, 'https://www.latrobe.edu.au/courses/master-of-digital-health', 43000, 2027)  -- 102427B,
    ('fd5c87a9-11ec-47f2-a0e6-e09e3b9a2a95'::uuid, '60ebab30-d9a8-47f9-bf7f-85aebc49039f'::uuid, 'ca52d51e-d9d1-42e6-8a59-187f97e5ee38'::uuid, 'https://www.rmit.edu.au/study-with-us/levels-of-study/postgraduate-study/masters-by-coursework/master-of-design-innovation-and-technology-mc231', 48960, 2027)  -- 104982C
         ) e(fee_id, course_id, evidence_id, url, amount, fee_year)
    join catalogue.course_fees f on f.id = e.fee_id
    join pipeline.evidence_artifacts a on a.id = f.evidence_id
   where f.course_id = e.course_id and f.evidence_id = e.evidence_id and f.amount = e.amount and f.fee_year = e.fee_year
     and f.status = 'active' and f.fee_type = 'provider_current_tuition' and f.audience = 'international' and f.valid_to is null
     and split_part(a.source_url, '#', 1) = e.url;
  if v_n <> 31 then raise exception 'E16 fee guard 2/3: % of 31 rows are exactly as read on 2 Nov; nothing changed', v_n; end if;
  -- guard 4: no hand lock on any of the courses' fees
  select count(*) into v_n from pipeline.manual_locks k join catalogue.course_fees f on f.course_id = k.entity_id
   where f.id = any(v_ids) and k.entity = 'course' and k.field in ('tuition', 'fee', 'fees');
  if v_n <> 0 then raise exception 'E16 fee guard 4: % fee locks set by hand; stop and re-read', v_n; end if;
  -- guard 5: the exit-award job would not write any of these fees back (see header)
  select count(*) into v_n
    from catalogue.course_fees f
    join pipeline.course_exit_awards x on x.child_course_id = f.course_id and x.active and x.evidence_id is not null
    join pipeline.uni_adapters u on u.provider_id = x.provider_id and u.enabled and u.admit and 'exit_awards' = any(u.admit_fields) and 'fee' = any(u.admit_fields)
   where f.id = any(v_ids)
     and not (x.register_check = 'fail' and x.set_by <> 'hand')
     and not security.layer4_entity_or_parent_blocked('course', f.course_id, 'operational')
     and not security.own_page_value_v1(f.course_id, 'fee')
     and not security.uni_adapter_excluded(f.course_id, 'fee');
  if v_n <> 0 then raise exception 'E16 fee guard 5: % of these courses still have an exit-award row the hourly job would apply; switch them off first', v_n; end if;

  perform set_config('cf.manual_edit', 'on', true);  -- fixed: the change is a recorded human decision, not a pipeline write
  update catalogue.course_fees f
     set status = 'inactive', updated_at = now(), valid_to = current_date,
         notes = concat_ws(' | ', f.notes, 'E16 withdrawn ' || to_char(now() at time zone 'Australia/Melbourne', 'DD Mon YYYY HH24:MI') ||
                 ' AEDT: fee read from a sibling-award page (evidence source is another course''s page); E16 final disposition 2 Nov 2026')
   where f.id = any(v_ids) and f.status = 'active';
  get diagnostics v_upd = row_count;
  if v_upd <> 31 then raise exception 'E16 fee guard: updated % rows, expected 31; rolled back', v_upd; end if;

  insert into pipeline.admin_control_events(area, action, target, detail)
  values ('layer4', 'e16_fee_withdrawal', 'catalogue.course_fees',
          jsonb_build_object('count', v_upd, 'ids_md5', 'fa15331cda52edbb2d4ea0cff1cd6c26', 'decision', 'E16 final disposition 2 Nov 2026 07:21',
                             'cohort', 'docs/platform/ui-audit/e16-sibling-variant-cohort-2026-11-02.csv'));
  insert into search.refresh_requests(requested_by) values ('E16 fee withdrawal (31 sibling-page fees)');
end $e16f$;
-- Read-back before commit: expect 31 inactive.
select status, count(*) from catalogue.course_fees where id = any(array[
  '191d4b0e-bbba-4c36-bc18-102fc00c5906',
  '266cfa9b-802f-42a5-91b4-288f526a6cfa',
  '34b2de4c-7f3b-4016-8850-e6c19c60f680',
  '36fb521a-a62b-4749-9aed-d3f099f78e7e',
  '37b7a8f9-aa04-42a6-8114-acb9ca8274bc',
  '4942e2ea-c735-427a-b4c9-0f29a58a9866',
  '4b53cb71-d5a6-43f9-9073-c353a60e60bc',
  '548b8ad7-3110-4490-97ad-ffd0344dea76',
  '5802ffe3-a74b-474b-b532-dec6d89f1fb7',
  '59b3859c-818e-4779-97e7-a3435528e9af',
  '5fb48e19-49c2-4adf-9649-a33125cafe4f',
  '6462dc9f-8a18-4ae9-82f3-4d6b3f2926c2',
  '67841648-642d-434c-a923-e4a9327a8ab3',
  '68c9a341-b444-4201-b3e2-5d7ed715a530',
  '69c6da38-c3b0-4a76-be90-242f047e05ae',
  '712a5368-8841-435a-a3ac-5c6eb31a9a91',
  '7253f4a7-3138-44c0-9213-33468ce5dbe0',
  '8d9a1c5d-8131-46a3-9404-7ff0c5968963',
  '8ecb865a-6d90-407c-beba-df39c5a83c62',
  '8f6a080a-f8e5-49ae-8832-d971191885ab',
  '98cc7c9b-a8b6-4b95-853a-22570d478223',
  '9f056cbf-f183-469d-959a-556cd122ce92',
  '9fbb1d35-1e83-45f8-999b-936ad132173f',
  'e630b018-ec0f-4b8a-ad9d-f95aadb1f662',
  'e79c15a7-7a67-4181-b317-9a9c9598e409',
  'eb97e07d-1aca-499b-906f-b61064634f34',
  'ed928df0-7176-4736-a726-67d4e2b47564',
  'f14eb0b2-9d1c-4cc8-8e81-efc6358f0e6a',
  'faceaf44-c841-4109-8511-8271e84fe61b',
  'fd2134f9-9c34-4ebd-800a-66c220f52a57',
  'fd5c87a9-11ec-47f2-a0e6-e09e3b9a2a95'
  ]::uuid[]) group by status;
commit;

-- After the next search refresh, check the consumer projection (expect 0 rows still showing a withdrawn amount as the provider fee):
-- select d.course_id, d.provider_annual_tuition_amount from search.course_documents d join catalogue.course_fees f on f.course_id = d.course_id
--  where f.id = any(<the 31 ids>) and d.provider_tuition_options @> jsonb_build_array(jsonb_build_object('amount', f.amount, 'fee_year', f.fee_year));


-- ===================== ROLLBACK (run only to undo the block above) =====================
-- begin;
-- do $e16r$
-- declare
--   v_ids uuid[] := array[
--     '191d4b0e-bbba-4c36-bc18-102fc00c5906',
--     '266cfa9b-802f-42a5-91b4-288f526a6cfa',
--     '34b2de4c-7f3b-4016-8850-e6c19c60f680',
--     '36fb521a-a62b-4749-9aed-d3f099f78e7e',
--     '37b7a8f9-aa04-42a6-8114-acb9ca8274bc',
--     '4942e2ea-c735-427a-b4c9-0f29a58a9866',
--     '4b53cb71-d5a6-43f9-9073-c353a60e60bc',
--     '548b8ad7-3110-4490-97ad-ffd0344dea76',
--     '5802ffe3-a74b-474b-b532-dec6d89f1fb7',
--     '59b3859c-818e-4779-97e7-a3435528e9af',
--     '5fb48e19-49c2-4adf-9649-a33125cafe4f',
--     '6462dc9f-8a18-4ae9-82f3-4d6b3f2926c2',
--     '67841648-642d-434c-a923-e4a9327a8ab3',
--     '68c9a341-b444-4201-b3e2-5d7ed715a530',
--     '69c6da38-c3b0-4a76-be90-242f047e05ae',
--     '712a5368-8841-435a-a3ac-5c6eb31a9a91',
--     '7253f4a7-3138-44c0-9213-33468ce5dbe0',
--     '8d9a1c5d-8131-46a3-9404-7ff0c5968963',
--     '8ecb865a-6d90-407c-beba-df39c5a83c62',
--     '8f6a080a-f8e5-49ae-8832-d971191885ab',
--     '98cc7c9b-a8b6-4b95-853a-22570d478223',
--     '9f056cbf-f183-469d-959a-556cd122ce92',
--     '9fbb1d35-1e83-45f8-999b-936ad132173f',
--     'e630b018-ec0f-4b8a-ad9d-f95aadb1f662',
--     'e79c15a7-7a67-4181-b317-9a9c9598e409',
--     'eb97e07d-1aca-499b-906f-b61064634f34',
--     'ed928df0-7176-4736-a726-67d4e2b47564',
--     'f14eb0b2-9d1c-4cc8-8e81-efc6358f0e6a',
--     'faceaf44-c841-4109-8511-8271e84fe61b',
--     'fd2134f9-9c34-4ebd-800a-66c220f52a57',
--     'fd5c87a9-11ec-47f2-a0e6-e09e3b9a2a95'
--   ]::uuid[];
--   v_n int; v_md5 text; v_upd int;
-- begin
--   select count(distinct x), md5(string_agg(x::text, ',' order by x)) into v_n, v_md5 from unnest(v_ids) x;
--   if v_n <> 31 or v_md5 <> 'fa15331cda52edbb2d4ea0cff1cd6c26' then raise exception 'E16 rollback guard: id set changed (% / %)', v_n, v_md5; end if;
--   select count(*) into v_n from catalogue.course_fees where id = any(v_ids) and status = 'inactive' and notes like '%E16 withdrawn %';
--   if v_n <> 31 then raise exception 'E16 rollback guard: % of 31 rows are in the withdrawn state; nothing changed', v_n; end if;
--   perform set_config('cf.manual_edit', 'on', true);  -- fixed: recorded human decision
--   update catalogue.course_fees set status = 'active', valid_to = null, updated_at = now(),
--          notes = notes || ' | E16 withdrawal rolled back ' || to_char(now() at time zone 'Australia/Melbourne', 'DD Mon YYYY HH24:MI') || ' AEDT'
--    where id = any(v_ids) and status = 'inactive';
--   get diagnostics v_upd = row_count;
--   if v_upd <> 31 then raise exception 'E16 rollback guard: updated %, expected 31', v_upd; end if;
--   insert into pipeline.admin_control_events(area, action, target, detail)
--   values ('layer4', 'e16_fee_withdrawal_rollback', 'catalogue.course_fees', jsonb_build_object('count', v_upd, 'ids_md5', 'fa15331cda52edbb2d4ea0cff1cd6c26'));
--   insert into search.refresh_requests(requested_by) values ('E16 fee withdrawal rollback (31 fees)');
-- end $e16r$;
-- commit;
-- (All 31 had valid_to null before; rollback restores null.)
