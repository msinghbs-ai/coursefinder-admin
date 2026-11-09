-- CF-247 housekeeping H05 / H13 / H20 (+ H23 reuse): route uncertain values into the EXISTING Layer 4 review. VERSION 2 (drift-tolerant).
-- Project fxcwkweaxjtknorudmwp ONLY. PREPARED READ-ONLY 2 Nov 2026 16:07-16:27 AEDT (re-measured in :x6 windows). NOT RUN.
-- Supersedes H05-H13-H20-layer4-route.sql (v1), which refused at 16:06 on its first guard ("H05 A: 42 / c2a43377...", expected 28 / 412a0229...).
-- Authority: Platform Admin consolidated decision pack 2 Nov 2026 10:56, Decision 6: "H05/H13/H20: Route uncertain values into existing Layer 4
--   review without duplicating items or automatically withdrawing unproved values." and "H23: Reuse existing pending review items."
-- Replaces: nothing. Retires: nothing. Writes ONLY new pending rows in pipeline.layer4_review_items (+ one audit event). No link, fee, course,
--   projection or consumer value changes. Nothing is deleted. G3 untouched. Run in :x6-:x8 (admission jobs at :x3/:x5/:x9), never :35-:42.
--
-- WHY v1 REFUSED (live 16:07-16:27): job course-url-fill (security.course_url_fill_v1, cron '23 2 * * *' UTC = 13:23 AEDT; run 2 Nov 13:23
--   succeeded in 2.4 s; admin_control_events action 'course_url_filled' 13:23: filled 45, emptied 20, refilled 22, retracted 20; by country NZ 40,
--   CA 4, AU 1) wrote course_url on 25 courses that have one active official link to a DIFFERENT page (the fill uses the proven coverage
--   binding, the link is the older sweep page). Half A +14 (AU5502, AU4090, AU4055, AU5658, AU0092, AU0371, AU0408, AU0047, AU0087, AU0059,
--   AU4105, AU0354, AU0025, AU5752; identity basis adapter_title 12, degree_name 2; none retracted), half B +11. Not E16 group (a), not the
--   tranche, not the :37 exit-award lane, not admission. ALL 42 + 39 H05 courses carry a live course_url_fills row: H05 is fed by this job daily
--   (fill days: 24 Oct 19,089; 27 Oct 131; 28 Oct 146; 30 Oct 1,280; 1 Nov 306; 2 Nov 45). It is ONGOING DRIFT, so v2 does not freeze the cohort.
--   Each of the 25 newcomers already had a pending official_course_url item, so they need no new item (pending rose 11 -> 25 and 12 -> 23).
--
-- HOW v2 TOLERATES DRIFT SAFELY:
--   * It routes ONLY the measured id lists below (embedded; their md5s are checked first, so a transcription error refuses).
--   * Each listed row is re-checked live: still eligible (same rule as the measurement), not E16, not locked, then the route's own dedupe
--     (advisory lock per course; pending item -> reuse; Decision 263 -> not raised). Rows that are no longer eligible are skipped and counted.
--   * Guard: if more than 10% of a list is skipped (no longer eligible or newly reused), the run refuses: the world moved too far, re-measure.
--   * EXTRAS: courses that now qualify but are not in the lists and have no pending/decided item are COUNTED and written to the audit event
--     (h05_extras_unrouted, h13_extras_unrouted), not routed. They go to the next measured tranche. Nothing outside the measured set is created.
--
-- MEASURED 2 Nov 16:16-16:27 AEDT (keyed by course_id halves):
--   H05: A 42 (md5 c2a433775d22ec3595e21a543ae5a19b) + B 39 (md5 382e8222666a3423b060f7c8e3b1e86b) = 81 courses. Pending item REUSED 25 + 23 = 48.
--        Decided before (Decision 263, not raised) 16 + 16 = 32. NEW 1 + 0 = 1 (3a6b6c47-..., OO0524, unchanged since 12:15). Filled by course-url-fill: 81/81.
--   H13: A 94 (342286d1...) + B 99 (9e9502ce...) = 193, UNCHANGED since 12:15. Excluded E16 2, H14 24. REUSED 0 + 1 = 1. Decided 2 + 2 = 4. NEW 92 + 96 = 188.
--   H20: A 20 (b9bb906f...) + B 18 (162d2de1...) = 38 fees on 38 courses, UNCHANGED. NEW 38.
--   Embedded lists: H05 1 (md5 67224396c18f6449037d3237ee3dad43), H13 188 (md5 caa6dcbaf608efb9fd0c7c34a5c3865d), H20 38 fees (md5 327a8c2e060ca7fe540cf1ee3f5e2df8).
--   Expected result: 227 new items (1 + 188 link, 38 fee checks), 0 duplicates, 0 withdrawals; extras reported (expected 0 at 16:27).
--
-- REVIEWER EFFECT: unchanged from v1 (link items: Keep / Use the new page / Enter another address; on an H13 item the proposed page is the
--   shown page. Fee check: "do not admit" does NOT withdraw the active fee (inferred; security.layer4_tuition_apply_impl is not in git)).

begin;
do $route$
declare
  v_e16 uuid[] := array['004b6c5c-4a6a-4b65-9f8d-1093049ea150','02c7bc01-0cc8-40bd-a190-b6eea143f3a5','0d25903f-de8e-460c-b403-2648148fcadd','111079e4-ca8d-4a72-bca1-145a141e201d','169b5258-0e1a-471a-807d-8473bdd0dcf2','196a1939-628d-4e86-8e4f-f40e0858be2e','19b048c5-3474-46d2-88a4-44b7c7eea8f5','1a8df22a-2739-4226-8856-10dd228e0033','1b78ba46-638c-4465-859e-8689e96295a8','1bfad09c-0734-4ef2-802a-52381c9d2ffa','20f2aa2c-1e7f-44c6-950c-47afa7881428','227e6abf-8897-4e35-9d6f-98de5c5a1160','264c5b84-eff8-49ac-b03f-c8cf12708198','26f9b73e-f6e3-41bc-8ff0-b7df8a2ef428','283a0dd2-0101-45c0-8a09-b0441f51d783','2bdf84a5-a806-469e-83a1-5e500559dfe4','2be0fafe-c403-495c-96bc-32b9f181a1a2','2cf5c4ac-b56d-44e2-b69e-93b6ce39a475','2d6d3d1c-8f6f-4455-8228-91d3f32ca491','33ded954-9998-43ff-9384-c3ca6788d54f','40afad92-5a55-47d8-88e3-2015c41d11af','4241f004-3144-4fd4-8468-960854850e38','43cb1105-82cd-4479-a1ed-48478514b94f','486ed99f-09f3-4ef5-9649-1dec1d9878d8','488f50c4-e7d3-4b21-a8a1-8ed95fcc0a03','4ad16106-b97b-44e6-b0bb-aa1ebd3b21aa','4e6f8c56-07cc-468b-97ff-5264276360ce','51b27099-8086-4c68-9b9f-04c74af883f6','5b6f8b6d-40c3-42ab-9d5a-52fb01f25c58','5cee7974-a3bf-416e-bd0e-a262bc56e955','60ebab30-d9a8-47f9-bf7f-85aebc49039f','670b7ce1-719e-4cdb-91e1-4111d0eba767','6b5874f1-770f-4000-9614-56a6df194724','6bad09d8-f8a1-45e9-9f1c-f8ba258d74d2','6d42acd7-35e9-4975-aa9f-2b7f400d341d','6f60c044-d710-420a-aed5-c6567c275f13','76339427-bad5-499f-94f0-3b158b6ff057','7cf958c9-c317-4a77-868c-3ba802174d1d','7e117900-eab0-4c4d-8104-11b9ffaf9b26','7f9cffdb-54ae-47e3-a595-edac98cd0dd6','87975d53-8b43-46c8-b209-9924fa43ea79','8a7a7b24-6ba1-4140-ac35-651552220afd','8b731ff6-2518-45a7-b73d-e6d03f22c405','8bdf836f-7de2-4570-be80-d87864c3e7e2','8c317304-0728-42ca-8e14-0b308a5ffbb2','8d1f1afd-96e1-44b3-bc61-a4dc42f54536','95fcd50f-257e-43d6-9920-f3599cacf374','98610bb2-1c02-49cf-a7ce-0d4ab8fc137f','9f50f886-8d83-40b9-8607-28a5d46b44a4','a0195518-e6a5-4663-88d4-677bd9c8d0b1','a021a3df-3ad0-43c1-a9b2-54d479473078','a940f900-bfa0-43a8-bba1-1e60c922a699','ad154e70-d0aa-45e8-a2f3-76f84d5c2902','b2226705-305a-4e88-9af5-fd8b404239c5','b444c1b8-9820-4cc9-a1b0-cb92beb56be1','b86828bb-9b14-46b4-a9bc-50a8de61fa39','ba8d7def-6f2e-48aa-a314-70603abe8d9c','bf8dd977-b939-4138-a6cc-744cd5e3dedf','cdc06d73-f08b-40fc-9d30-1700df678e62','d122606b-fe48-4a1a-b030-c9b84ea11ec1','d25f60bb-bd10-4956-8337-cdefdff8b1ce','d3443473-9636-4a37-a6ed-e531c863a101','d5e7c833-7912-4046-8b6a-da966520a7c4','d7d1890f-a7f0-44c0-b16a-97f9f7445be8','da0667c1-9818-4ab3-bbf7-c047f5de404d','dd5f7176-0ca9-462c-b399-4f05d06c5e67','de86b0d9-bb66-4a7d-8b05-ff1fa2c6d9cd','e1596a78-53ad-463f-bd1a-1442109c6ac3','e5822674-6fca-47a7-980f-dce5b054859d','ebfc236d-1c66-4f5b-bd4d-815ad7655e33','f0052042-998a-4f05-843f-467ff76a021c','f013a634-9344-4ae8-8ae6-07c2310b3e93','f5baa817-87a6-4f2d-a57f-a02b9e9dd90a','fa955ff0-37d1-4c91-826a-89c812cde021','fcde61b0-f5fe-4618-814c-a76a4b4d1dc7','fe4f81a5-9262-41f8-82c7-8fd2c1dee621','ff63eb8b-2705-4db7-8500-1db2c548216a']::uuid[];
  v_h05 uuid[] := array['3a6b6c47-2bde-4ec5-848a-3cb0d155352f']::uuid[];
  v_h13 uuid[] := array['00672193-d1d5-4548-a3da-adfff3329a07','0308497a-70cd-4b1f-9d19-52bb40673ec2','0345dedc-8c16-44a5-9b79-614a9990ac7f','03782b45-dfb2-452d-9f1c-8bc7988c628d','03c8690c-2ac7-490e-a8a9-3dbe9c0a8204','04584645-4c93-4f03-9afd-15b0af0e8e95','0939c490-afb4-41e1-80a3-be925d3dea09','096c33d2-9c45-4ada-9cc8-c7dc1e024a3d','0b4a931c-1a04-4a3e-9600-af3cf1106245','0c11a778-7c82-49f0-aeb5-050c4b5c0c5e','0ca996fc-f821-4a51-a72d-b9ac640f54c5','10134ec6-2f3b-4cca-9812-06c804b2d30c','10af37ea-70b6-421a-9ec0-aa3bdd6f64bf','11360d6b-811b-4159-bfaa-2febf782576e','13977379-ad15-44b4-b5ef-bad7a23e47a0','14cac806-060c-456e-8d2f-a2c8ac70b168','15654df6-e1a5-4d92-8989-0d44d7425f13','19fa1249-f694-479a-8602-0ba0bd7b69f3','19fa8aba-d1cc-4ef7-bd0c-efc11c811084','1ab39695-9fcc-4650-9ce1-ee285649ab1e','1af1d355-7d40-4433-b7d4-fa9740a14e3f','1b1c45c8-efa5-453e-a7a0-87f819c02725','1df66b2c-ea0c-4319-ad5c-847b021a1a45','1e6873e8-d31a-4870-bcd0-c67d42ce5114','1ee0c7d6-7563-4d35-b958-3eb1ce82c2eb','1f75fcbf-ffab-41b4-896b-761acbdd0784','2093cf8a-fafb-4ad3-9eb3-dd3d6cb20dde','227c9d01-cf1b-4e14-b531-9b11dcc67549','235145c2-deed-45ac-83d5-d83ddcb595ea','24ca41dd-b0bd-4448-8216-d80d6174c857','25455235-3928-4978-997d-8da352f818ce','26dc6bb3-63d2-4f34-9fc4-c97fada808fc','27aabd6a-6ef2-4622-9750-3108d54e3f1d','2a1e11f4-0338-4b24-b116-56f755c8343c','2a553f76-b8bf-4e2b-9cf9-a90ac2f10f4d','2e308366-3606-4b5d-83a2-04fa82fd1d1e','2fd9d6b2-882b-48e1-b613-59b3e2dc055c','304cf714-4594-472b-8bec-803cf95f065d','31d65c50-eb73-4202-aa48-cf2cd0819de0','32d06ebb-9c45-4536-980a-3764e25767ca','340a864c-c7a4-4f77-a502-4d9731f968a7','346ffb41-bc21-4b9c-a623-c78aa724428d','34ecd360-a2cd-4fc3-a956-84c8ca252fae','352434ea-302a-44f6-868b-c1666fdbd372','35f86e12-ef6e-457b-ba27-8a3228524131','36f68220-9c8f-4136-ba2d-3e933fb456c6','388dc598-f757-4dd9-8a1b-a81c0ea30a52','39c0178b-f240-45ed-a9b0-bf31dc8289e2','3b2f115e-8c15-40e7-8d8b-3d641fa35fbc','3b45b0f9-00d7-435f-9df4-72a5fe764720','3b6627a1-3ebb-4ac0-a86b-28864f97997d','3c51e4d7-1cf7-452b-983b-fcf23e678b80','3e597ef7-9088-4465-b186-beff75e16375','3efc9d20-85da-4e6b-9557-a5981f4994b7','411f56f0-d49b-40cf-a036-afdf7b1a25bc','418df251-a3cb-44ec-8d3d-2096ce7bd7bd','43f2ae10-efd0-4ddd-ac02-4b2f50955fc7','4584f2b2-f0b6-4311-95ce-5dd3559bd79b','46b275e1-8d4d-48b2-8b48-602d30e9f469','47c687b2-0fed-43a2-bf2c-41caab14582c','47d65fef-3088-4880-98c7-a5a0f47dede1','47e8bf6b-f403-4dca-8c62-eebe39e84642','483be5e6-42fa-4812-9366-19c2cf1ea4d4','494c7dcb-6aa0-4731-ac4d-fd1f26f8fb05','4a9f475f-2e3d-4515-8968-bf8c5eeff431','4d655a4d-d9ce-4904-83c0-bb582e9fb800','4fd6e73d-e74a-4e2b-919f-b9be2fa4928a','50536796-134a-4833-bfe2-121153ac5365','51437ad8-37e3-4eeb-b5c8-f748e97b7a7d','5262dae2-09e9-42ab-8d89-530910ee5975','56d3ec29-7676-4df5-a138-293927dad494','5ab1a2d8-0fa3-48cd-a433-01ea53ed9451','5b0b8a81-dd10-4fab-8536-2a950815c7d9','5b4eafc2-3120-4852-8b34-aea92eafced6','5e056230-63f5-45f7-841c-bf64e3ea3646','62754bbb-df38-4b53-887e-625e1d69abb0','66b20bad-fc43-41b8-a2c1-af480f7cc1af','66bd77ac-136b-464b-903e-f5300afb4a89','6ac15398-0c48-434e-8b9b-eda3d831cb26','6eca4212-680f-45bd-9fbc-3ea461010bd5','6f09af38-fd80-4379-a651-f1eba91b4c76','714af4eb-a848-41a5-845b-e6cd7eccdec5','7181dcca-8e96-47e0-9748-794fa06d4d15','754a145a-151c-4cc5-85e4-a8249a0892bd','75595a96-1ef3-4b60-809a-58f694b83767','75a44644-5a41-42f7-b4fd-3cc0e1a2c130','782658e0-8b8a-43a1-aad8-ca04c738752b','7a86378c-fa97-4141-a722-4b1463c0bf43','7af5afc3-94f5-4d54-ae30-e0948b983a89','7ddd9ede-05a7-4918-bf8b-9af0f853aa68','7e2b0a42-87f7-4041-8122-2e111d013db5','7ed92575-778d-46a2-884a-8fae21ebb097','805dfb22-0d09-45e3-9e27-d93c7cc9bcba','80e31a16-d07e-461a-822e-c712c78c9c2a','810e61d9-7748-4300-9670-15d0f0e827df','81cbe543-a201-4755-8e69-eb8eec8bb304','838ac8da-e014-4e97-8902-4e502f985785','8532f8d8-e86e-4efe-a493-a2411ff06495','85e5f8f0-b0da-417d-ae58-0f88c9bb4525','88b3b1ca-4459-4cac-ba6e-68b3f6e93ac5','89f4f15d-53c2-47ec-87aa-1f42f2b5213d','8d074513-2adf-49a2-b13e-9e04e03c4e37','8f169a2a-37f5-462f-b037-15907b1e024a','8f2e0cba-0559-42ca-95c8-a19625392476','8f4cddfa-0e97-4a13-9c95-72eeda8872b9','8f84a4e0-4b65-49dc-a8ee-5bdcc72a89f9','90c131b3-5c17-4b71-8700-401c7e0770f8','91faf178-7174-4c58-bf6f-b93041083689','93e2f173-bc64-495a-a765-c00df44d0bcc','94cdd599-f921-4f24-8e0e-8e419cf80969','94cf402d-126f-4651-a87f-96160ea10394','95197341-a04d-40bf-841f-f25a45958dc3','966640e4-c9fb-4920-a262-c6243e0316bc','98827746-e0f3-4ff7-ab84-332d004b607f','98cd43ea-7578-46d1-91e6-00e2700a8f5a','9aa9e3da-d993-4b8b-9423-4f2f3dd9feb2','9c0af620-2c5c-4aae-89f2-1357fbea9b29','9c1a2732-73a1-43d5-be7a-daa66feb4b12','a380a17b-9c97-42ee-9eda-30cf9383d2ca','a39cf5b9-1503-4226-a99f-7260eaaad9d9','a3f6886e-b303-401a-aa4b-39924b575fef','a7a014d6-5e2b-4af1-9705-d59fb865cc06','a7b1548e-2b5c-45d9-aa06-7d1a3b776c8e','a9926adb-ee9a-4264-b11b-008dbafe854d','a99f1363-cedd-4f55-9654-8b713b82cd03','a9e40593-c250-4f50-bf3b-ccc535f4cade','ab7c70f4-336f-4e79-b079-67c29a301c6c','abc9f601-76a1-4bf3-821f-96e3244f1700','adeb47ff-e228-466f-b6bd-44823e4dff42','aec28043-9a11-4ddf-9ec3-afdbce37e43e','b053dc16-510b-4e7a-9757-ae42d99b7b18','b12446d0-1495-4ebb-a379-55adba08834f','b2437adb-be28-4a2d-8800-e4c20e365143','b3278b5a-5276-412f-acae-6f03ea2f7c22','b45f3f0c-980c-4f4d-af25-e3dc8b1bacf9','b464c419-3d05-4ec8-8396-a6e9a12f9d4b','b61793d2-71de-423a-8931-88c2c8734b80','b973e326-edae-4dc0-9375-a35b48cfd497','bbebbde2-9b55-4eae-8ca3-8b122f0a7428','bedb9d22-1d9a-4894-8b80-4130f9ad51a6','bfa2d298-b0cb-4f7b-8e1a-b11e8f16e6ea','c0659343-6ded-41f1-b54d-6778b16a1f4b','c203a437-f6c7-4c26-a255-89ca41910e4e','c4f9a1d7-9812-45e6-aeab-3a533d1de061','c562cc8a-2604-4996-a2a6-3cbf852a02c7','c604bdd6-e90d-40ff-ad95-b7efee2d80e9','c89f1107-ee51-43eb-83b8-860789df3428','c987da20-ab69-4d2f-8206-8ab43a6935f2','c9a4f605-fdc4-4d89-bed6-a971f8869bd0','ca6b0d5e-2b93-4715-b56b-7027c9dcb4cf','cac905c1-759b-4d30-8430-485210ab4cde','cbf2cecc-e52a-4930-80d5-1dde4d5013c0','cbf3d60a-693b-4899-ba0c-f031fd072734','cda77da6-2ddc-4fcd-8bee-b848027b1195','cf3da2d7-d6ac-4680-a2b6-d2a50b91052c','cf4ec762-70ee-41e8-aca1-99d88683a526','d01bacf2-0f67-4306-90e5-a9218d36bf65','d22232e4-7e56-4404-8f8b-ba49dee8def2','d2d63fe5-86cd-4a80-8a95-ff5729c61e50','d46ad811-9251-4132-b211-185d2b4e993c','d5dcff8a-73fe-4752-a3af-18285386c5a8','d88baca2-fbc6-4ea2-aea6-64a3759d2edb','d8e4e4f7-8bae-44da-a361-3b060d2fd6fa','d952bf31-7355-46ff-96e8-195a9891c8fd','dbb32d4f-c248-4c49-a8b6-5439499b68be','dceec3bb-31d7-450c-b435-0115f2c91936','dd194132-6be7-4b09-8ccc-bc49aa8ff289','de1a8b45-c4c3-411f-a95d-31c14ef9678c','deec6618-1c75-44ad-a8d0-4db782b15fe5','e01a5c16-5a54-4e24-a3ec-cadae17ba8a1','e0c85317-8371-4256-8d51-ef01e4e332e7','e111f397-eb54-41aa-b977-41ff17c1452a','e12cb2f2-20e1-4f34-9b07-1ace1b2e0a65','e582f2c3-7cce-4042-82c9-b10d015b2b15','e6110c3c-aced-45ab-935e-a90911e625bb','e87a12c9-0714-4244-a6af-5b729f3e1534','e9ec6e0b-52d2-4831-9982-1f5e0b99f41e','ee25e83b-019d-46d3-96d0-93837f6bde7c','ee28e758-2477-4283-bb4f-cff61963413b','f0d48ad2-eb54-4041-95cd-21cbdc6ad687','f451d06f-136d-4665-9e5a-19414d73e40d','f651ebac-cd64-479c-ba1e-5df187ff0f45','f68b30f1-0d7b-4f0f-a98a-b12157120912','f6b6cd10-3168-497d-ac02-b64dcdea2f9b','f7cb950e-268c-430d-bd83-33984b99eaa5','f7ed7fc7-bcbc-4c67-8389-444199812607','f9969d88-1de3-4957-be1e-c844285b878f','fc7aeb99-aaca-414c-adcf-d220cc460854']::uuid[];
  v_h20 uuid[] := array['14a1b480-1358-4b39-94bf-7fbc3f89d17d','26bc5b0d-04a0-4fdc-875c-49a9f2ee055e','36c55001-203c-4f6d-aeee-fde052636164','45cdacb4-1ef9-462e-af73-517e6073bf21','511f3d43-09e4-4a0f-8533-d66fffecd5ac','57b89c77-2123-438a-a89c-d1665b9598e3','5f2049ef-0ef3-406c-97ea-d92b27ad83d0','6137c1d5-9cfb-42a0-951c-d793083ca2b0','67b1cd84-9b6c-4201-ae89-ca2bab8a0d99','7eb107cb-a7fa-4bde-8380-daaf4403b46c','867d89c8-9b49-42f7-96fd-5d9cd6c514bf','8956f9c4-7753-4485-9720-23cb2c546732','8aeac37f-63f8-4a15-a89c-1588122a0211','93148770-5c80-4994-bea0-84b8e68387fc','9390a75e-2ddc-4992-802a-bcbf6d5a0bd0','9ae677ab-97f3-4b9c-8bb8-162475b8a59e','a97de971-801c-4986-ac10-a34fb56dbaaa','bb88d52c-eb14-40fd-a938-d2798a035dd0','c8a826af-4e28-4f41-aa8d-ac6f7514de46','cce67486-1d6c-4dd7-a650-aa075546ac54','033d3291-61cc-4bc8-b4af-0a4c78614172','0dc67957-5c4f-47f4-aaf4-2d4b38ddfa2c','1ee5193c-132d-4991-bd58-1baa5d1864c4','28151771-b059-42eb-b87a-2e8f79ca85b3','296401b7-7d58-4557-a278-c05087852b39','39f1ad41-1ac8-40bc-90fc-4dd70e11bfa7','4d9a62d5-0a9a-4f02-be35-4cbfc97f384e','4fca7beb-915d-4d1b-9703-24f681b253d6','62d08ec2-b49a-4579-b6b3-c050472bcf6e','641b718a-f30f-47a7-bae7-eba614ee46ad','6d961c89-c38e-4fd8-bff1-3e52adad935e','9d91e1ec-0b77-426d-a8fa-bc5d6c2670b3','a2ae1626-ebef-49d3-bddb-223f49930098','a3e1997a-a491-40db-906b-dab0f8cf2fbb','ce9a71e5-c8c7-4a5a-8a62-6df836b6da4e','dd29ae82-b01e-41dd-aaf9-14b7b50549d2','f4870b25-0296-4c94-8bf1-c90910229bf6','f86ac659-1d05-4bb8-9fc6-4e4a59da2596']::uuid[];
  r record; v_n int; v_x text;
  v_new int := 0; v_kept int := 0; v_decided int := 0; v_gone int := 0;
  v_fnew int := 0; v_fkept int := 0; v_fdecided int := 0; v_fgone int := 0;
  v_x05 int; v_x13 int; v_seen int := 0; v_fseen int := 0;
begin
  -- Guard 0: the embedded lists are exactly the measured ones
  select md5(string_agg(x::text, ',' order by x::text)), count(*) into v_x, v_n from unnest(v_h05) x;
  if v_n <> 1 or v_x <> '67224396c18f6449037d3237ee3dad43' then raise exception 'H05 list % / %', v_n, v_x; end if;
  select md5(string_agg(x::text, ',' order by x::text)), count(*) into v_x, v_n from unnest(v_h13) x;
  if v_n <> 188 or v_x <> 'caa6dcbaf608efb9fd0c7c34a5c3865d' then raise exception 'H13 list % / %', v_n, v_x; end if;
  select md5(string_agg(x::text, ',' order by x::text)), count(*) into v_x, v_n from unnest(v_h20) x;
  if v_n <> 38 or v_x <> '327a8c2e060ca7fe540cf1ee3f5e2df8' then raise exception 'H20 list % / %', v_n, v_x; end if;

  -- Links: each listed course re-checked live, then the route's dedupe
  for r in
    select 'H05' src, c.id course_id, c.course_url page, null::int yr, null::uuid ev,
           ( (select count(*) from catalogue.course_links l where l.course_id=c.id and l.link_type='official_course' and l.status='active') = 1
             and c.course_url is not null
             and regexp_replace(regexp_replace(regexp_replace(lower(c.course_url),'^https?://(www\.)?',''),'[?#].*$',''),'/+$','')
              <> (select regexp_replace(regexp_replace(regexp_replace(lower(l.url),'^https?://(www\.)?',''),'[?#].*$',''),'/+$','') from catalogue.course_links l where l.course_id=c.id and l.link_type='official_course' and l.status='active' limit 1)
             and not (c.id = any(v_e16)) and not exists (select 1 from pipeline.manual_locks m where m.entity='course' and m.entity_id=c.id) ) eligible
      from catalogue.courses c where c.id = any(v_h05)
    union all
    select 'H13', d.course_id, d.official_course_url, (substring(d.official_course_url from '/(20[12][0-9])(/|$|\?)'))::int, l.evidence_id,
           ( d.official_course_url ~ '/(20[12][0-9])(/|$|\?)' and (substring(d.official_course_url from '/(20[12][0-9])(/|$|\?)'))::int <= 2024
             and coalesce(s.source_type,'')<>'manual_entry' and not (d.course_id = any(v_e16))
             and not exists (select 1 from pipeline.manual_locks m where m.entity='course' and m.entity_id=d.course_id) ) is true
      from search.course_documents d
      left join catalogue.course_links l on l.course_id=d.course_id and l.link_type='official_course' and l.status='active' and l.url=d.official_course_url
      left join pipeline.sources s on s.id=l.source_id
     where d.course_id = any(v_h13)
    order by 1, 2
  loop
    v_seen := v_seen + 1;
    if not r.eligible then v_gone := v_gone + 1; continue; end if;
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
  v_gone := v_gone + (189 - v_seen);  -- a listed course that no longer has a search document or course row counts as gone
  -- tolerance: at most 10% of the 189 listed courses may have moved (no longer eligible, or reused/decided since measurement)
  if v_gone + v_kept + v_decided > ceil(0.10 * 189) then
    raise exception 'links: % listed courses moved since 16:27 (gone %, now pending %, decided %); more than 10%%, re-measure', v_gone + v_kept + v_decided, v_gone, v_kept, v_decided; end if;

  -- Fee checks (H20): each listed fee re-checked live (still active, evidence page still the shown wrong-year page)
  for r in
    select f.id fee_id, f.course_id, f.amount, f.currency_code, f.basis, f.fee_year, f.audience, f.evidence_id, d.official_course_url u,
           (substring(d.official_course_url from '/(20[12][0-9])(/|$|\?)'))::int yr,
           (f.status='active' and f.fee_type='provider_current_tuition' and e.source_url = d.official_course_url
            and (substring(d.official_course_url from '/(20[12][0-9])(/|$|\?)'))::int <= 2024 and not (f.course_id = any(v_e16))) is true eligible
      from catalogue.course_fees f left join pipeline.evidence_artifacts e on e.id=f.evidence_id left join search.course_documents d on d.course_id=f.course_id
     where f.id = any(v_h20) order by f.course_id, f.id
  loop
    v_fseen := v_fseen + 1;
    if not r.eligible then v_fgone := v_fgone + 1; continue; end if;
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
  v_fgone := v_fgone + (38 - v_fseen);
  if v_fgone + v_fkept + v_fdecided > ceil(0.10 * 38) then
    raise exception 'fees: % listed fees moved since 16:27 (gone %, pending %, decided %); more than 10%%, re-measure', v_fgone + v_fkept + v_fdecided, v_fgone, v_fkept, v_fdecided; end if;

  -- Extras: qualify now, not in the lists, no pending or decided item. Counted and reported only; not routed.
  select count(*) into v_x05 from (
      with one as materialized (select l.course_id, min(l.url) url from catalogue.course_links l where l.link_type='official_course' and l.status='active' group by l.course_id having count(*)=1)
      select count(*) from one join catalogue.courses c on c.id=one.course_id
       where c.course_url is not null and not (one.course_id = any(v_e16)) and not (one.course_id = any(v_h05))
         and not exists (select 1 from pipeline.manual_locks m where m.entity='course' and m.entity_id=one.course_id)
         and not exists (select 1 from pipeline.layer4_review_items i where i.entity_type='course' and i.entity_id=one.course_id and i.field_code='official_course_url' and (i.status='pending' or i.proposed_value->>'course_url'=c.course_url))
         and regexp_replace(regexp_replace(regexp_replace(lower(c.course_url),'^https?://(www\.)?',''),'[?#].*$',''),'/+$','')
          <> regexp_replace(regexp_replace(regexp_replace(lower(one.url),'^https?://(www\.)?',''),'[?#].*$',''),'/+$','')) z;
  select count(*) into v_x13 from (
      select count(*) from search.course_documents d
        left join catalogue.course_links l on l.course_id=d.course_id and l.link_type='official_course' and l.status='active' and l.url=d.official_course_url
        left join pipeline.sources s on s.id=l.source_id
       where d.official_course_url ~ '/(20[12][0-9])(/|$|\?)' and (substring(d.official_course_url from '/(20[12][0-9])(/|$|\?)'))::int <= 2024
         and not (d.course_id = any(v_e16)) and not (d.course_id = any(v_h13)) and coalesce(s.source_type,'')<>'manual_entry'
         and not exists (select 1 from pipeline.manual_locks m where m.entity='course' and m.entity_id=d.course_id)
         and not exists (select 1 from pipeline.layer4_review_items i where i.entity_type='course' and i.entity_id=d.course_id and i.field_code='official_course_url' and (i.status='pending' or i.proposed_value->>'course_url'=d.official_course_url))) z;
  -- (the two selects above are counted as sub-selects below)

  -- No duplicates: no listed course holds more than one pending item of either field
  select count(*) into v_n from (select entity_id, field_code from pipeline.layer4_review_items
     where status='pending' and entity_type='course' and field_code in ('official_course_url','provider_current_tuition_validation')
       and entity_id in (select unnest(v_h05) union select unnest(v_h13))
     group by entity_id, field_code having count(*) > 1) z;
  if v_n <> 0 then raise exception 'duplicate pending items on % course/field pairs', v_n; end if;

  insert into pipeline.admin_control_events(area, action, target, detail, actor)
  values ('layer4', 'h05_h13_h20_route', 'pipeline.layer4_review_items',
          jsonb_build_object('version', 2, 'links_created', v_new, 'links_reused', v_kept, 'links_decided_before', v_decided, 'links_no_longer_eligible', v_gone,
                             'fee_checks_created', v_fnew, 'fee_checks_reused', v_fkept, 'fee_decided_before', v_fdecided, 'fees_no_longer_eligible', v_fgone,
                             'h05_extras_unrouted', v_x05, 'h13_extras_unrouted', v_x13, 'withdrawals', 0,
                             'measured', '2 Nov 2026 16:16-16:27 AEDT',
                             'authority', 'Platform Admin decision pack 2 Nov 2026 10:56, Decision 6 (H05/H13/H20, H23)'), null);
  raise notice 'route v2: links created %, reused %, decided %, gone %; fee checks created %, reused %, decided %, gone %; extras unrouted H05 %, H13 %',
    v_new, v_kept, v_decided, v_gone, v_fnew, v_fkept, v_fdecided, v_fgone, v_x05, v_x13;
end $route$;

-- Read-back (expect at 16:27 state: link items 189 = H05 1 + H13 188, fee checks 38; extras 0; 0 duplicates):
select field_code, layer2_state->>'source' src, count(*) from pipeline.layer4_review_items
 where status='pending' and change_control_ref like 'CF-CHG-20260915-247; Decision 6 (Platform Admin 2 Nov 2026 10:56)%' group by 1, 2 order by 1, 2;
select detail from pipeline.admin_control_events where action = 'h05_h13_h20_route' order by id desc limit 1;
-- If not as expected: rollback;  otherwise: commit;

-- ROLLBACK after commit (no delete; items closed with the existing status 'superseded', only while still pending and undecided):
-- update pipeline.layer4_review_items set status = 'superseded', escalation_reason = escalation_reason || ' [Withdrawn from the queue: H05/H13/H20 routing rolled back]'
--  where status = 'pending' and decided_at is null and change_control_ref like 'CF-CHG-20260915-247; Decision 6 (Platform Admin 2 Nov 2026 10:56)%';  -- expect up to 227
