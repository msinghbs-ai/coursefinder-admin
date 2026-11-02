-- CF-247 housekeeping H05 / H13 / H20 (+ H23 reuse): route uncertain values into the EXISTING Layer 4 review, no duplicates, no withdrawals.
-- Project fxcwkweaxjtknorudmwp ONLY. PREPARED READ-ONLY 2 Nov 2026 12:15-12:17 AEDT. NOT RUN. The integrator runs it in an allowed minute
--   (admission jobs at :x3/:x5/:x9 since the 2 Nov stagger: use :x6-:x8, never :35-:42; re-check cron.job first).
-- Authority: Platform Admin consolidated decision pack 2 Nov 2026 10:56, Decision 6: "H05/H13/H20: Route uncertain values into existing Layer 4
--   review without duplicating items or automatically withdrawing unproved values." and "H23: Reuse existing pending review items."
-- Replaces: nothing. Retires: nothing. Writes ONLY new pending rows in pipeline.layer4_review_items (+ one audit event). No link, fee, course,
--   projection or consumer value changes. Nothing is deleted. G3 untouched.
-- RUN AFTER H01-H03-H04-H09-duplicate-link-tranche.sql (or not at all before it): H13 includes tranche courses (e.g. 104952J shows a 2023 page,
--   kept primary). A new pending official_course_url item on such a course makes the tranche's guard refuse to run.
--
-- WHY NOT security.binding_refusal_route_v1: that route also writes pipeline.page_rejections (source binding_check), which stops lanes binding the
--   page again and is the E16 containment path for REFUSED pages. These values are UNPROVED candidates (H13/H20 are judged from the address year
--   only; H05 is a course_url disagreement), so recording a rejection would pre-judge them. This file raises the same item kind with the route's
--   own dedupe, copied exactly: (1) pg_advisory_xact_lock(hashtext('layer4 course link ' || course)); (2) a pending official_course_url item on the
--   course -> reuse, add nothing; (3) Decision 263: any official_course_url item ever raised for this course and this page -> add nothing.
--   Fee checks use field provider_current_tuition_validation (the fee reader's existing item) with the same three steps (lock key
--   'layer4 fee check ' || course; pending fee-check on the course -> reuse; an item ever proposing this amount -> add nothing).
-- REVIEWER EFFECT (read before running): link items show "Keep the page we hold / Use the new page / Enter another address". For H13 the
--   proposed page IS the page shown, so "Keep" or "Use" both keep it; "Enter another address" sets the current-year page. For a fee check,
--   "admit" records the human decision on the fee (security.layer4_tuition_apply_impl, live-only, not in git); "do not admit" does NOT
--   withdraw the active fee (inferred from the 1 Nov fee-check card change; verify before relying). Any withdrawal needs its own authority
--   (E1 pattern). That is intended: "No withdrawals."
--
-- MEASURED 2 Nov 12:15-12:17 AEDT (keyed by course_id halves):
--   H05 one active link, course_url names a different page (normalised): 28 + 28 = 56 courses (= reconciliation), md5 A 412a0229f8c55b9c8ffe2c10da11d3c6,
--       B 451ae71cac4d79889ef3a4bc8dcea0cf. Shown = the link on 56/56; 32 carry an active provider fee. E16 0, locked 0.
--       Existing pending official_course_url item (REUSED) 11 + 12 = 23. Decided before for that page (Decision 263, not raised) 16 + 16 = 32.
--       NEW items 1 + 0 = 1 (md5 A 67224396c18f6449037d3237ee3dad43).
--   H13 shown page year <= 2024 on an automated link, not E16, not hand-entered/locked: 94 + 99 = 193 (= reconciliation), md5 A
--       342286d1afd7fa665edc43392cf7cb33, B 9e9502cee7f67c057c65782ed667fa45. Excluded: E16 1 + 1 = 2; hand-entered and locked (H14) 11 + 13 = 24.
--       REUSED pending item 0 + 1 = 1 (UniMelb). Decided before (Decision 263) 2 + 2 = 4. NEW items 92 + 96 = 188 (md5 A be7e9c3869cd1b85ae9b20204e41e615,
--       B 6259d0d7dba35bdf65d321300e320435).
--   H20 active provider_current_tuition fees whose evidence source_url is an H13 shown page: 20 + 18 = 38 fees on 38 courses (= reconciliation),
--       md5 A b9bb906f70e684ccedebba16cd20b8b3, B 162d2de13dce8c493b33fabdb654d0d5. Pending fee check on the course 0; decided before 0; NEW 38.
--   H23 (27 fee-check items pending since 25 Oct, T5 14-day limit 8 Nov): REUSED as they are; no new item on those courses (none is in H20).
--   Expected totals: NEW 1 + 188 + 38 = 227 items; REUSED 23 + 1 (+27 H23) ; not raised (decided before) 32 + 4.
--   An H05 course that is also in H13 would get one item only (lock + pending check); the guard allows for that overlap.

begin;
do $route$
declare v_n int; v_x text; r record; v_new int := 0; v_kept int := 0; v_decided int := 0; v_fnew int := 0; v_fkept int := 0; v_fdecided int := 0;
begin
  create temp table hk_h05(half text, course_id uuid, shown_link text, cu text, new_item boolean) on commit drop;
  create temp table hk_h13(half text, course_id uuid, u text, yr int, link_id uuid, evidence_id uuid, pending_kept boolean, decided_before boolean, new_item boolean) on commit drop;
  create temp table hk_h20(half text, fee_id uuid, course_id uuid, amount numeric, currency_code text, basis text, fee_year int, audience text, evidence_id uuid, u text, yr int, new_item boolean) on commit drop;
  with e16 as materialized (select unnest(array['004b6c5c-4a6a-4b65-9f8d-1093049ea150','02c7bc01-0cc8-40bd-a190-b6eea143f3a5','0d25903f-de8e-460c-b403-2648148fcadd','111079e4-ca8d-4a72-bca1-145a141e201d','169b5258-0e1a-471a-807d-8473bdd0dcf2','196a1939-628d-4e86-8e4f-f40e0858be2e','19b048c5-3474-46d2-88a4-44b7c7eea8f5','1a8df22a-2739-4226-8856-10dd228e0033','1b78ba46-638c-4465-859e-8689e96295a8','1bfad09c-0734-4ef2-802a-52381c9d2ffa','20f2aa2c-1e7f-44c6-950c-47afa7881428','227e6abf-8897-4e35-9d6f-98de5c5a1160','264c5b84-eff8-49ac-b03f-c8cf12708198','26f9b73e-f6e3-41bc-8ff0-b7df8a2ef428','283a0dd2-0101-45c0-8a09-b0441f51d783','2bdf84a5-a806-469e-83a1-5e500559dfe4','2be0fafe-c403-495c-96bc-32b9f181a1a2','2cf5c4ac-b56d-44e2-b69e-93b6ce39a475','2d6d3d1c-8f6f-4455-8228-91d3f32ca491','33ded954-9998-43ff-9384-c3ca6788d54f','40afad92-5a55-47d8-88e3-2015c41d11af','4241f004-3144-4fd4-8468-960854850e38','43cb1105-82cd-4479-a1ed-48478514b94f','486ed99f-09f3-4ef5-9649-1dec1d9878d8','488f50c4-e7d3-4b21-a8a1-8ed95fcc0a03','4ad16106-b97b-44e6-b0bb-aa1ebd3b21aa','4e6f8c56-07cc-468b-97ff-5264276360ce','51b27099-8086-4c68-9b9f-04c74af883f6','5b6f8b6d-40c3-42ab-9d5a-52fb01f25c58','5cee7974-a3bf-416e-bd0e-a262bc56e955','60ebab30-d9a8-47f9-bf7f-85aebc49039f','670b7ce1-719e-4cdb-91e1-4111d0eba767','6b5874f1-770f-4000-9614-56a6df194724','6bad09d8-f8a1-45e9-9f1c-f8ba258d74d2','6d42acd7-35e9-4975-aa9f-2b7f400d341d','6f60c044-d710-420a-aed5-c6567c275f13','76339427-bad5-499f-94f0-3b158b6ff057','7cf958c9-c317-4a77-868c-3ba802174d1d','7e117900-eab0-4c4d-8104-11b9ffaf9b26','7f9cffdb-54ae-47e3-a595-edac98cd0dd6','87975d53-8b43-46c8-b209-9924fa43ea79','8a7a7b24-6ba1-4140-ac35-651552220afd','8b731ff6-2518-45a7-b73d-e6d03f22c405','8bdf836f-7de2-4570-be80-d87864c3e7e2','8c317304-0728-42ca-8e14-0b308a5ffbb2','8d1f1afd-96e1-44b3-bc61-a4dc42f54536','95fcd50f-257e-43d6-9920-f3599cacf374','98610bb2-1c02-49cf-a7ce-0d4ab8fc137f','9f50f886-8d83-40b9-8607-28a5d46b44a4','a0195518-e6a5-4663-88d4-677bd9c8d0b1','a021a3df-3ad0-43c1-a9b2-54d479473078','a940f900-bfa0-43a8-bba1-1e60c922a699','ad154e70-d0aa-45e8-a2f3-76f84d5c2902','b2226705-305a-4e88-9af5-fd8b404239c5','b444c1b8-9820-4cc9-a1b0-cb92beb56be1','b86828bb-9b14-46b4-a9bc-50a8de61fa39','ba8d7def-6f2e-48aa-a314-70603abe8d9c','bf8dd977-b939-4138-a6cc-744cd5e3dedf','cdc06d73-f08b-40fc-9d30-1700df678e62','d122606b-fe48-4a1a-b030-c9b84ea11ec1','d25f60bb-bd10-4956-8337-cdefdff8b1ce','d3443473-9636-4a37-a6ed-e531c863a101','d5e7c833-7912-4046-8b6a-da966520a7c4','d7d1890f-a7f0-44c0-b16a-97f9f7445be8','da0667c1-9818-4ab3-bbf7-c047f5de404d','dd5f7176-0ca9-462c-b399-4f05d06c5e67','de86b0d9-bb66-4a7d-8b05-ff1fa2c6d9cd','e1596a78-53ad-463f-bd1a-1442109c6ac3','e5822674-6fca-47a7-980f-dce5b054859d','ebfc236d-1c66-4f5b-bd4d-815ad7655e33','f0052042-998a-4f05-843f-467ff76a021c','f013a634-9344-4ae8-8ae6-07c2310b3e93','f5baa817-87a6-4f2d-a57f-a02b9e9dd90a','fa955ff0-37d1-4c91-826a-89c812cde021','fcde61b0-f5fe-4618-814c-a76a4b4d1dc7','fe4f81a5-9262-41f8-82c7-8fd2c1dee621','ff63eb8b-2705-4db7-8500-1db2c548216a']::uuid[]) id),
  one as materialized (select l.course_id, min(l.url) url from catalogue.course_links l
     where l.course_id >= '00000000-0000-0000-0000-000000000000'::uuid and l.course_id < '80000000-0000-0000-0000-000000000000'::uuid and l.link_type='official_course' and l.status='active' group by l.course_id having count(*)=1),
  x as materialized (select one.*, c.course_url cu, (one.course_id in (select id from e16)) e16,
     (select count(*) from pipeline.manual_locks m where m.entity='course' and m.entity_id=one.course_id) locks,
     (select count(*) from pipeline.layer4_review_items i where i.entity_type='course' and i.entity_id=one.course_id and i.field_code='official_course_url' and i.status='pending') l4p,
     (select count(*) from pipeline.layer4_review_items i where i.entity_type='course' and i.entity_id=one.course_id and i.field_code='official_course_url' and i.proposed_value->>'course_url'=c.course_url) decided_before
   from one join catalogue.courses c on c.id=one.course_id
   where c.course_url is not null
     and regexp_replace(regexp_replace(regexp_replace(lower(c.course_url),'^https?://(www\.)?',''),'[?#].*$',''),'/+$','')
      <> regexp_replace(regexp_replace(regexp_replace(lower(one.url),'^https?://(www\.)?',''),'[?#].*$',''),'/+$',''))
  insert into hk_h05(half, course_id, shown_link, cu, new_item)
  select 'A', course_id, url, cu, (not e16 and locks=0 and l4p=0 and decided_before=0) from x;
  with e16 as materialized (select unnest(array['004b6c5c-4a6a-4b65-9f8d-1093049ea150','02c7bc01-0cc8-40bd-a190-b6eea143f3a5','0d25903f-de8e-460c-b403-2648148fcadd','111079e4-ca8d-4a72-bca1-145a141e201d','169b5258-0e1a-471a-807d-8473bdd0dcf2','196a1939-628d-4e86-8e4f-f40e0858be2e','19b048c5-3474-46d2-88a4-44b7c7eea8f5','1a8df22a-2739-4226-8856-10dd228e0033','1b78ba46-638c-4465-859e-8689e96295a8','1bfad09c-0734-4ef2-802a-52381c9d2ffa','20f2aa2c-1e7f-44c6-950c-47afa7881428','227e6abf-8897-4e35-9d6f-98de5c5a1160','264c5b84-eff8-49ac-b03f-c8cf12708198','26f9b73e-f6e3-41bc-8ff0-b7df8a2ef428','283a0dd2-0101-45c0-8a09-b0441f51d783','2bdf84a5-a806-469e-83a1-5e500559dfe4','2be0fafe-c403-495c-96bc-32b9f181a1a2','2cf5c4ac-b56d-44e2-b69e-93b6ce39a475','2d6d3d1c-8f6f-4455-8228-91d3f32ca491','33ded954-9998-43ff-9384-c3ca6788d54f','40afad92-5a55-47d8-88e3-2015c41d11af','4241f004-3144-4fd4-8468-960854850e38','43cb1105-82cd-4479-a1ed-48478514b94f','486ed99f-09f3-4ef5-9649-1dec1d9878d8','488f50c4-e7d3-4b21-a8a1-8ed95fcc0a03','4ad16106-b97b-44e6-b0bb-aa1ebd3b21aa','4e6f8c56-07cc-468b-97ff-5264276360ce','51b27099-8086-4c68-9b9f-04c74af883f6','5b6f8b6d-40c3-42ab-9d5a-52fb01f25c58','5cee7974-a3bf-416e-bd0e-a262bc56e955','60ebab30-d9a8-47f9-bf7f-85aebc49039f','670b7ce1-719e-4cdb-91e1-4111d0eba767','6b5874f1-770f-4000-9614-56a6df194724','6bad09d8-f8a1-45e9-9f1c-f8ba258d74d2','6d42acd7-35e9-4975-aa9f-2b7f400d341d','6f60c044-d710-420a-aed5-c6567c275f13','76339427-bad5-499f-94f0-3b158b6ff057','7cf958c9-c317-4a77-868c-3ba802174d1d','7e117900-eab0-4c4d-8104-11b9ffaf9b26','7f9cffdb-54ae-47e3-a595-edac98cd0dd6','87975d53-8b43-46c8-b209-9924fa43ea79','8a7a7b24-6ba1-4140-ac35-651552220afd','8b731ff6-2518-45a7-b73d-e6d03f22c405','8bdf836f-7de2-4570-be80-d87864c3e7e2','8c317304-0728-42ca-8e14-0b308a5ffbb2','8d1f1afd-96e1-44b3-bc61-a4dc42f54536','95fcd50f-257e-43d6-9920-f3599cacf374','98610bb2-1c02-49cf-a7ce-0d4ab8fc137f','9f50f886-8d83-40b9-8607-28a5d46b44a4','a0195518-e6a5-4663-88d4-677bd9c8d0b1','a021a3df-3ad0-43c1-a9b2-54d479473078','a940f900-bfa0-43a8-bba1-1e60c922a699','ad154e70-d0aa-45e8-a2f3-76f84d5c2902','b2226705-305a-4e88-9af5-fd8b404239c5','b444c1b8-9820-4cc9-a1b0-cb92beb56be1','b86828bb-9b14-46b4-a9bc-50a8de61fa39','ba8d7def-6f2e-48aa-a314-70603abe8d9c','bf8dd977-b939-4138-a6cc-744cd5e3dedf','cdc06d73-f08b-40fc-9d30-1700df678e62','d122606b-fe48-4a1a-b030-c9b84ea11ec1','d25f60bb-bd10-4956-8337-cdefdff8b1ce','d3443473-9636-4a37-a6ed-e531c863a101','d5e7c833-7912-4046-8b6a-da966520a7c4','d7d1890f-a7f0-44c0-b16a-97f9f7445be8','da0667c1-9818-4ab3-bbf7-c047f5de404d','dd5f7176-0ca9-462c-b399-4f05d06c5e67','de86b0d9-bb66-4a7d-8b05-ff1fa2c6d9cd','e1596a78-53ad-463f-bd1a-1442109c6ac3','e5822674-6fca-47a7-980f-dce5b054859d','ebfc236d-1c66-4f5b-bd4d-815ad7655e33','f0052042-998a-4f05-843f-467ff76a021c','f013a634-9344-4ae8-8ae6-07c2310b3e93','f5baa817-87a6-4f2d-a57f-a02b9e9dd90a','fa955ff0-37d1-4c91-826a-89c812cde021','fcde61b0-f5fe-4618-814c-a76a4b4d1dc7','fe4f81a5-9262-41f8-82c7-8fd2c1dee621','ff63eb8b-2705-4db7-8500-1db2c548216a']::uuid[]) id),
  one as materialized (select l.course_id, min(l.url) url from catalogue.course_links l
     where l.course_id >= '80000000-0000-0000-0000-000000000000'::uuid and l.course_id <= 'ffffffff-ffff-ffff-ffff-ffffffffffff'::uuid and l.link_type='official_course' and l.status='active' group by l.course_id having count(*)=1),
  x as materialized (select one.*, c.course_url cu, (one.course_id in (select id from e16)) e16,
     (select count(*) from pipeline.manual_locks m where m.entity='course' and m.entity_id=one.course_id) locks,
     (select count(*) from pipeline.layer4_review_items i where i.entity_type='course' and i.entity_id=one.course_id and i.field_code='official_course_url' and i.status='pending') l4p,
     (select count(*) from pipeline.layer4_review_items i where i.entity_type='course' and i.entity_id=one.course_id and i.field_code='official_course_url' and i.proposed_value->>'course_url'=c.course_url) decided_before
   from one join catalogue.courses c on c.id=one.course_id
   where c.course_url is not null
     and regexp_replace(regexp_replace(regexp_replace(lower(c.course_url),'^https?://(www\.)?',''),'[?#].*$',''),'/+$','')
      <> regexp_replace(regexp_replace(regexp_replace(lower(one.url),'^https?://(www\.)?',''),'[?#].*$',''),'/+$',''))
  insert into hk_h05(half, course_id, shown_link, cu, new_item)
  select 'B', course_id, url, cu, (not e16 and locks=0 and l4p=0 and decided_before=0) from x;
  with e16 as materialized (select unnest(array['004b6c5c-4a6a-4b65-9f8d-1093049ea150','02c7bc01-0cc8-40bd-a190-b6eea143f3a5','0d25903f-de8e-460c-b403-2648148fcadd','111079e4-ca8d-4a72-bca1-145a141e201d','169b5258-0e1a-471a-807d-8473bdd0dcf2','196a1939-628d-4e86-8e4f-f40e0858be2e','19b048c5-3474-46d2-88a4-44b7c7eea8f5','1a8df22a-2739-4226-8856-10dd228e0033','1b78ba46-638c-4465-859e-8689e96295a8','1bfad09c-0734-4ef2-802a-52381c9d2ffa','20f2aa2c-1e7f-44c6-950c-47afa7881428','227e6abf-8897-4e35-9d6f-98de5c5a1160','264c5b84-eff8-49ac-b03f-c8cf12708198','26f9b73e-f6e3-41bc-8ff0-b7df8a2ef428','283a0dd2-0101-45c0-8a09-b0441f51d783','2bdf84a5-a806-469e-83a1-5e500559dfe4','2be0fafe-c403-495c-96bc-32b9f181a1a2','2cf5c4ac-b56d-44e2-b69e-93b6ce39a475','2d6d3d1c-8f6f-4455-8228-91d3f32ca491','33ded954-9998-43ff-9384-c3ca6788d54f','40afad92-5a55-47d8-88e3-2015c41d11af','4241f004-3144-4fd4-8468-960854850e38','43cb1105-82cd-4479-a1ed-48478514b94f','486ed99f-09f3-4ef5-9649-1dec1d9878d8','488f50c4-e7d3-4b21-a8a1-8ed95fcc0a03','4ad16106-b97b-44e6-b0bb-aa1ebd3b21aa','4e6f8c56-07cc-468b-97ff-5264276360ce','51b27099-8086-4c68-9b9f-04c74af883f6','5b6f8b6d-40c3-42ab-9d5a-52fb01f25c58','5cee7974-a3bf-416e-bd0e-a262bc56e955','60ebab30-d9a8-47f9-bf7f-85aebc49039f','670b7ce1-719e-4cdb-91e1-4111d0eba767','6b5874f1-770f-4000-9614-56a6df194724','6bad09d8-f8a1-45e9-9f1c-f8ba258d74d2','6d42acd7-35e9-4975-aa9f-2b7f400d341d','6f60c044-d710-420a-aed5-c6567c275f13','76339427-bad5-499f-94f0-3b158b6ff057','7cf958c9-c317-4a77-868c-3ba802174d1d','7e117900-eab0-4c4d-8104-11b9ffaf9b26','7f9cffdb-54ae-47e3-a595-edac98cd0dd6','87975d53-8b43-46c8-b209-9924fa43ea79','8a7a7b24-6ba1-4140-ac35-651552220afd','8b731ff6-2518-45a7-b73d-e6d03f22c405','8bdf836f-7de2-4570-be80-d87864c3e7e2','8c317304-0728-42ca-8e14-0b308a5ffbb2','8d1f1afd-96e1-44b3-bc61-a4dc42f54536','95fcd50f-257e-43d6-9920-f3599cacf374','98610bb2-1c02-49cf-a7ce-0d4ab8fc137f','9f50f886-8d83-40b9-8607-28a5d46b44a4','a0195518-e6a5-4663-88d4-677bd9c8d0b1','a021a3df-3ad0-43c1-a9b2-54d479473078','a940f900-bfa0-43a8-bba1-1e60c922a699','ad154e70-d0aa-45e8-a2f3-76f84d5c2902','b2226705-305a-4e88-9af5-fd8b404239c5','b444c1b8-9820-4cc9-a1b0-cb92beb56be1','b86828bb-9b14-46b4-a9bc-50a8de61fa39','ba8d7def-6f2e-48aa-a314-70603abe8d9c','bf8dd977-b939-4138-a6cc-744cd5e3dedf','cdc06d73-f08b-40fc-9d30-1700df678e62','d122606b-fe48-4a1a-b030-c9b84ea11ec1','d25f60bb-bd10-4956-8337-cdefdff8b1ce','d3443473-9636-4a37-a6ed-e531c863a101','d5e7c833-7912-4046-8b6a-da966520a7c4','d7d1890f-a7f0-44c0-b16a-97f9f7445be8','da0667c1-9818-4ab3-bbf7-c047f5de404d','dd5f7176-0ca9-462c-b399-4f05d06c5e67','de86b0d9-bb66-4a7d-8b05-ff1fa2c6d9cd','e1596a78-53ad-463f-bd1a-1442109c6ac3','e5822674-6fca-47a7-980f-dce5b054859d','ebfc236d-1c66-4f5b-bd4d-815ad7655e33','f0052042-998a-4f05-843f-467ff76a021c','f013a634-9344-4ae8-8ae6-07c2310b3e93','f5baa817-87a6-4f2d-a57f-a02b9e9dd90a','fa955ff0-37d1-4c91-826a-89c812cde021','fcde61b0-f5fe-4618-814c-a76a4b4d1dc7','fe4f81a5-9262-41f8-82c7-8fd2c1dee621','ff63eb8b-2705-4db7-8500-1db2c548216a']::uuid[]) id),
  d as materialized (select d.course_id, d.official_course_url u, (substring(d.official_course_url from '/(20[12][0-9])(/|$|\?)'))::int yr
     from search.course_documents d where d.course_id >= '00000000-0000-0000-0000-000000000000'::uuid and d.course_id < '80000000-0000-0000-0000-000000000000'::uuid and d.official_course_url ~ '/(20[12][0-9])(/|$|\?)'),
  x as materialized (select d.*, l.id link_id, l.evidence_id, s.source_type st, (d.course_id in (select id from e16)) e16,
     (select count(*) from pipeline.manual_locks m where m.entity='course' and m.entity_id=d.course_id) locks,
     (select count(*) from pipeline.layer4_review_items i where i.entity_type='course' and i.entity_id=d.course_id and i.field_code='official_course_url' and i.status='pending') l4p,
     (select count(*) from pipeline.layer4_review_items i where i.entity_type='course' and i.entity_id=d.course_id and i.field_code='official_course_url' and i.proposed_value->>'course_url'=d.u) decided_before
   from d left join catalogue.course_links l on l.course_id=d.course_id and l.link_type='official_course' and l.status='active' and l.url=d.u
   left join pipeline.sources s on s.id=l.source_id where d.yr<=2024)
  insert into hk_h13(half, course_id, u, yr, link_id, evidence_id, pending_kept, decided_before, new_item)
  select 'A', course_id, u, yr, link_id, evidence_id, l4p>0, (l4p=0 and decided_before>0), (l4p=0 and decided_before=0)
    from x where not e16 and coalesce(st,'')<>'manual_entry' and locks=0;
  with e16 as materialized (select unnest(array['004b6c5c-4a6a-4b65-9f8d-1093049ea150','02c7bc01-0cc8-40bd-a190-b6eea143f3a5','0d25903f-de8e-460c-b403-2648148fcadd','111079e4-ca8d-4a72-bca1-145a141e201d','169b5258-0e1a-471a-807d-8473bdd0dcf2','196a1939-628d-4e86-8e4f-f40e0858be2e','19b048c5-3474-46d2-88a4-44b7c7eea8f5','1a8df22a-2739-4226-8856-10dd228e0033','1b78ba46-638c-4465-859e-8689e96295a8','1bfad09c-0734-4ef2-802a-52381c9d2ffa','20f2aa2c-1e7f-44c6-950c-47afa7881428','227e6abf-8897-4e35-9d6f-98de5c5a1160','264c5b84-eff8-49ac-b03f-c8cf12708198','26f9b73e-f6e3-41bc-8ff0-b7df8a2ef428','283a0dd2-0101-45c0-8a09-b0441f51d783','2bdf84a5-a806-469e-83a1-5e500559dfe4','2be0fafe-c403-495c-96bc-32b9f181a1a2','2cf5c4ac-b56d-44e2-b69e-93b6ce39a475','2d6d3d1c-8f6f-4455-8228-91d3f32ca491','33ded954-9998-43ff-9384-c3ca6788d54f','40afad92-5a55-47d8-88e3-2015c41d11af','4241f004-3144-4fd4-8468-960854850e38','43cb1105-82cd-4479-a1ed-48478514b94f','486ed99f-09f3-4ef5-9649-1dec1d9878d8','488f50c4-e7d3-4b21-a8a1-8ed95fcc0a03','4ad16106-b97b-44e6-b0bb-aa1ebd3b21aa','4e6f8c56-07cc-468b-97ff-5264276360ce','51b27099-8086-4c68-9b9f-04c74af883f6','5b6f8b6d-40c3-42ab-9d5a-52fb01f25c58','5cee7974-a3bf-416e-bd0e-a262bc56e955','60ebab30-d9a8-47f9-bf7f-85aebc49039f','670b7ce1-719e-4cdb-91e1-4111d0eba767','6b5874f1-770f-4000-9614-56a6df194724','6bad09d8-f8a1-45e9-9f1c-f8ba258d74d2','6d42acd7-35e9-4975-aa9f-2b7f400d341d','6f60c044-d710-420a-aed5-c6567c275f13','76339427-bad5-499f-94f0-3b158b6ff057','7cf958c9-c317-4a77-868c-3ba802174d1d','7e117900-eab0-4c4d-8104-11b9ffaf9b26','7f9cffdb-54ae-47e3-a595-edac98cd0dd6','87975d53-8b43-46c8-b209-9924fa43ea79','8a7a7b24-6ba1-4140-ac35-651552220afd','8b731ff6-2518-45a7-b73d-e6d03f22c405','8bdf836f-7de2-4570-be80-d87864c3e7e2','8c317304-0728-42ca-8e14-0b308a5ffbb2','8d1f1afd-96e1-44b3-bc61-a4dc42f54536','95fcd50f-257e-43d6-9920-f3599cacf374','98610bb2-1c02-49cf-a7ce-0d4ab8fc137f','9f50f886-8d83-40b9-8607-28a5d46b44a4','a0195518-e6a5-4663-88d4-677bd9c8d0b1','a021a3df-3ad0-43c1-a9b2-54d479473078','a940f900-bfa0-43a8-bba1-1e60c922a699','ad154e70-d0aa-45e8-a2f3-76f84d5c2902','b2226705-305a-4e88-9af5-fd8b404239c5','b444c1b8-9820-4cc9-a1b0-cb92beb56be1','b86828bb-9b14-46b4-a9bc-50a8de61fa39','ba8d7def-6f2e-48aa-a314-70603abe8d9c','bf8dd977-b939-4138-a6cc-744cd5e3dedf','cdc06d73-f08b-40fc-9d30-1700df678e62','d122606b-fe48-4a1a-b030-c9b84ea11ec1','d25f60bb-bd10-4956-8337-cdefdff8b1ce','d3443473-9636-4a37-a6ed-e531c863a101','d5e7c833-7912-4046-8b6a-da966520a7c4','d7d1890f-a7f0-44c0-b16a-97f9f7445be8','da0667c1-9818-4ab3-bbf7-c047f5de404d','dd5f7176-0ca9-462c-b399-4f05d06c5e67','de86b0d9-bb66-4a7d-8b05-ff1fa2c6d9cd','e1596a78-53ad-463f-bd1a-1442109c6ac3','e5822674-6fca-47a7-980f-dce5b054859d','ebfc236d-1c66-4f5b-bd4d-815ad7655e33','f0052042-998a-4f05-843f-467ff76a021c','f013a634-9344-4ae8-8ae6-07c2310b3e93','f5baa817-87a6-4f2d-a57f-a02b9e9dd90a','fa955ff0-37d1-4c91-826a-89c812cde021','fcde61b0-f5fe-4618-814c-a76a4b4d1dc7','fe4f81a5-9262-41f8-82c7-8fd2c1dee621','ff63eb8b-2705-4db7-8500-1db2c548216a']::uuid[]) id),
  d as materialized (select d.course_id, d.official_course_url u, (substring(d.official_course_url from '/(20[12][0-9])(/|$|\?)'))::int yr
     from search.course_documents d where d.course_id >= '80000000-0000-0000-0000-000000000000'::uuid and d.course_id <= 'ffffffff-ffff-ffff-ffff-ffffffffffff'::uuid and d.official_course_url ~ '/(20[12][0-9])(/|$|\?)'),
  x as materialized (select d.*, l.id link_id, l.evidence_id, s.source_type st, (d.course_id in (select id from e16)) e16,
     (select count(*) from pipeline.manual_locks m where m.entity='course' and m.entity_id=d.course_id) locks,
     (select count(*) from pipeline.layer4_review_items i where i.entity_type='course' and i.entity_id=d.course_id and i.field_code='official_course_url' and i.status='pending') l4p,
     (select count(*) from pipeline.layer4_review_items i where i.entity_type='course' and i.entity_id=d.course_id and i.field_code='official_course_url' and i.proposed_value->>'course_url'=d.u) decided_before
   from d left join catalogue.course_links l on l.course_id=d.course_id and l.link_type='official_course' and l.status='active' and l.url=d.u
   left join pipeline.sources s on s.id=l.source_id where d.yr<=2024)
  insert into hk_h13(half, course_id, u, yr, link_id, evidence_id, pending_kept, decided_before, new_item)
  select 'B', course_id, u, yr, link_id, evidence_id, l4p>0, (l4p=0 and decided_before>0), (l4p=0 and decided_before=0)
    from x where not e16 and coalesce(st,'')<>'manual_entry' and locks=0;
  insert into hk_h20(half, fee_id, course_id, amount, currency_code, basis, fee_year, audience, evidence_id, u, yr, new_item)
  select t.half, f.id, f.course_id, f.amount, f.currency_code, f.basis, f.fee_year, f.audience, f.evidence_id, t.u, t.yr,
         not exists (select 1 from pipeline.layer4_review_items i where i.entity_type='course' and i.entity_id=f.course_id and i.field_code='provider_current_tuition_validation' and i.status='pending')
     and not exists (select 1 from pipeline.layer4_review_items i where i.entity_type='course' and i.entity_id=f.course_id and i.field_code in ('provider_current_tuition_validation','provider_current_tuition') and (i.proposed_value->>'amount')::numeric = f.amount)
    from hk_h13 t join catalogue.course_fees f on f.course_id=t.course_id and f.fee_type='provider_current_tuition' and f.status='active'
    join pipeline.evidence_artifacts e on e.id=f.evidence_id and e.source_url=t.u;

  -- Guards: the cohorts are exactly as measured
  select count(*), md5(string_agg(course_id::text, ',' order by course_id::text)) into v_n, v_x from hk_h05 where half='A';
  if v_n <> 28 or v_x <> '412a0229f8c55b9c8ffe2c10da11d3c6' then raise exception 'H05 A: % / %', v_n, v_x; end if;
  select count(*), md5(string_agg(course_id::text, ',' order by course_id::text)) into v_n, v_x from hk_h05 where half='B';
  if v_n <> 28 or v_x <> '451ae71cac4d79889ef3a4bc8dcea0cf' then raise exception 'H05 B: % / %', v_n, v_x; end if;
  select count(*), md5(string_agg(course_id::text, ',' order by course_id::text)) into v_n, v_x from hk_h05 where new_item;
  if v_n <> 1 or v_x <> '67224396c18f6449037d3237ee3dad43' then raise exception 'H05 new: % / %', v_n, v_x; end if;
  select count(*), md5(string_agg(course_id::text, ',' order by course_id::text)) into v_n, v_x from hk_h13 where half='A';
  if v_n <> 94 or v_x <> '342286d1afd7fa665edc43392cf7cb33' then raise exception 'H13 A: % / %', v_n, v_x; end if;
  select count(*), md5(string_agg(course_id::text, ',' order by course_id::text)) into v_n, v_x from hk_h13 where half='B';
  if v_n <> 99 or v_x <> '9e9502cee7f67c057c65782ed667fa45' then raise exception 'H13 B: % / %', v_n, v_x; end if;
  select count(*), md5(string_agg(course_id::text, ',' order by course_id::text)) into v_n, v_x from hk_h13 where half='A' and new_item;
  if v_n <> 92 or v_x <> 'be7e9c3869cd1b85ae9b20204e41e615' then raise exception 'H13 A new: % / %', v_n, v_x; end if;
  select count(*), md5(string_agg(course_id::text, ',' order by course_id::text)) into v_n, v_x from hk_h13 where half='B' and new_item;
  if v_n <> 96 or v_x <> '6259d0d7dba35bdf65d321300e320435' then raise exception 'H13 B new: % / %', v_n, v_x; end if;
  select count(*), md5(string_agg(fee_id::text, ',' order by fee_id::text)) into v_n, v_x from hk_h20 where half='A';
  if v_n <> 20 or v_x <> 'b9bb906f70e684ccedebba16cd20b8b3' then raise exception 'H20 A: % / %', v_n, v_x; end if;
  select count(*), md5(string_agg(fee_id::text, ',' order by fee_id::text)) into v_n, v_x from hk_h20 where half='B';
  if v_n <> 18 or v_x <> '162d2de13dce8c493b33fabdb654d0d5' then raise exception 'H20 B: % / %', v_n, v_x; end if;
  select count(*) into v_n from hk_h20 where not new_item; if v_n <> 0 then raise exception 'H20: % fees already have a fee check', v_n; end if;

  -- Route: links (H05 then H13), the route's own three dedupe steps per course
  for r in select 'H05' src, course_id, cu page, null::int yr, null::uuid ev from hk_h05 where new_item
           union all
           select 'H13', course_id, u, yr, evidence_id from hk_h13 where new_item order by 1, 2 loop
    perform pg_advisory_xact_lock(hashtext('layer4 course link ' || r.course_id::text));
    if exists (select 1 from pipeline.layer4_review_items i where i.entity_type='course' and i.entity_id=r.course_id and i.field_code='official_course_url' and i.status='pending') then
      v_kept := v_kept + 1; continue; end if;
    if exists (select 1 from pipeline.layer4_review_items i where i.entity_type='course' and i.entity_id=r.course_id and i.field_code='official_course_url' and i.proposed_value->>'course_url' = r.page) then
      v_decided := v_decided + 1; continue; end if;
    insert into pipeline.layer4_review_items(entity_type, entity_id, field_code, evidence_id, before_value, proposed_value, layer2_state, layer3_state, status, escalation_reason, change_control_ref)
    values ('course', r.course_id, 'official_course_url', (select e.id from pipeline.evidence_artifacts e where e.id = r.ev),
            (select coalesce(jsonb_agg(l.url order by l.is_primary desc, l.url), '[]'::jsonb) from catalogue.course_links l where l.course_id = r.course_id and l.link_type = 'official_course' and l.status = 'active'),
            jsonb_build_object('course_url', r.page),
            jsonb_build_object('source', 'housekeeping ' || r.src, 'page', r.page, 'rule', case when r.src = 'H05' then 'course_url_differs' else 'address_year' end, 'year', r.yr,
                               'decision', 'Decision 6 (Platform Admin 2 Nov 2026 10:56)'),
            '{}'::jsonb, 'pending',
            case when r.src = 'H05'
                 then 'The course record names a different page from the one we show. If that page is this course''s own page, choose Use the new page; otherwise keep the page we hold.'
                 else 'The page we show carries the year ' || r.yr || ' in its address and may be an archived handbook. Keep it if it is still the current page; otherwise enter the current page.' end,
            'CF-CHG-20260915-247; Decision 6 (Platform Admin 2 Nov 2026 10:56) ' || r.src);
    v_new := v_new + 1;
  end loop;
  if v_new + v_kept <> 189 or v_new < 188 or v_decided <> 0 then
    raise exception 'links: created %, reused-by-overlap %, decided %; expected 189 in all (188 or 189 created, 0 decided)', v_new, v_kept, v_decided; end if;

  -- Route: fee checks (H20)
  for r in select * from hk_h20 where new_item order by course_id, fee_id loop
    perform pg_advisory_xact_lock(hashtext('layer4 fee check ' || r.course_id::text));
    if exists (select 1 from pipeline.layer4_review_items i where i.entity_type='course' and i.entity_id=r.course_id and i.field_code='provider_current_tuition_validation' and i.status='pending') then
      v_fkept := v_fkept + 1; continue; end if;
    if exists (select 1 from pipeline.layer4_review_items i where i.entity_type='course' and i.entity_id=r.course_id and i.field_code in ('provider_current_tuition_validation','provider_current_tuition') and (i.proposed_value->>'amount')::numeric = r.amount) then
      v_fdecided := v_fdecided + 1; continue; end if;
    insert into pipeline.layer4_review_items(entity_type, entity_id, field_code, evidence_id, before_value, proposed_value, layer2_state, layer3_state, status, escalation_reason, change_control_ref)
    values ('course', r.course_id, 'provider_current_tuition_validation', r.evidence_id, '{}'::jsonb,
            jsonb_build_object('amount', r.amount, 'currency_code', r.currency_code, 'basis', r.basis, 'fee_year', r.fee_year, 'audience', r.audience, 'course_fee_id', r.fee_id),
            jsonb_build_object('source', 'housekeeping H20', 'page', r.u, 'year', r.yr, 'note', 'active fee read from a page whose address carries the year ' || r.yr,
                               'decision', 'Decision 6 (Platform Admin 2 Nov 2026 10:56)'),
            '{}'::jsonb, 'pending',
            'Fee read from a page whose address carries the year ' || r.yr || ' (possibly an archived handbook). Admit it only if it is the current fee. The fee stays shown until a separately authorised change.',
            'CF-CHG-20260915-247; Decision 6 (Platform Admin 2 Nov 2026 10:56) H20');
    v_fnew := v_fnew + 1;
  end loop;
  if v_fnew <> 38 or v_fkept <> 0 or v_fdecided <> 0 then raise exception 'fees: created %, reused %, decided %; expected 38 / 0 / 0', v_fnew, v_fkept, v_fdecided; end if;

  -- Proof of no duplicates: no course holds more than one pending item of either field
  select count(*) into v_n from (select entity_id, field_code from pipeline.layer4_review_items
     where status='pending' and entity_type='course' and field_code in ('official_course_url','provider_current_tuition_validation')
       and entity_id in (select course_id from hk_h05 union select course_id from hk_h13)
     group by entity_id, field_code having count(*) > 1) z;
  if v_n <> 0 then raise exception 'duplicate pending items on % course/field pairs', v_n; end if;

  insert into pipeline.admin_control_events(area, action, target, detail, actor)
  values ('layer4', 'h05_h13_h20_route', 'pipeline.layer4_review_items',
          jsonb_build_object('links_created', v_new, 'links_reused_overlap', v_kept, 'fee_checks_created', v_fnew,
                             'h05_reused_pending', (select count(*) from hk_h05 where not new_item) - 32, 'h05_decided_before', 32,
                             'h13_reused_pending', (select count(*) from hk_h13 where pending_kept), 'h13_decided_before', (select count(*) from hk_h13 where decided_before),
                             'withdrawals', 0, 'authority', 'Platform Admin decision pack 2 Nov 2026 10:56, Decision 6 (H05/H13/H20, H23)'), null);
end $route$;

-- Read-back (expect 189 link items and 38 fee checks created by this run; 0 duplicates):
select field_code, layer2_state->>'source' src, count(*) from pipeline.layer4_review_items
 where status='pending' and change_control_ref like 'CF-CHG-20260915-247; Decision 6 (Platform Admin 2 Nov 2026 10:56)%' group by 1, 2 order by 1, 2;
-- If not as expected: rollback;  otherwise: commit;

-- ROLLBACK after commit (no delete; the items are closed with the existing status 'superseded', only while still pending and undecided):
-- update pipeline.layer4_review_items set status = 'superseded', escalation_reason = escalation_reason || ' [Withdrawn from the queue: H05/H13/H20 routing rolled back]'
--  where status = 'pending' and decided_at is null and change_control_ref like 'CF-CHG-20260915-247; Decision 6 (Platform Admin 2 Nov 2026 10:56)%';  -- expect up to 227
