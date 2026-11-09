-- CF-247 housekeeping H01 / H03 / H04 / H09: ONE count-guarded duplicate-link consolidation tranche. Project fxcwkweaxjtknorudmwp ONLY.
-- PREPARED READ-ONLY 2 Nov 2026 11:45-12:07 AEDT. NOT RUN. The integrator runs it in an allowed minute: after the 2 Nov stagger the admission jobs
--   run at :x3, :x5 and :x9 (25-55 s), so use :x6-:x8 (never :35-:42). Re-check cron.job first.
-- Authority: Platform Admin consolidated decision pack 2 Nov 2026 10:56, Decision 6: "H01/H03/H04/H09: Prepare one count-guarded duplicate-link
--   consolidation tranche with before/after read-back, keeping the validated link and existing history. Do not execute consumer-visible changes
--   without their required approval." Findings: 2026-11-02-housekeeping-reconciliation.md A1/A3 (H01, H03, H04, H09). Pattern: E15 part 1 (1 Nov).
-- Replaces: nothing. Retires: nothing. NOTHING IS DELETED: superseded links become status 'inactive' (existing value) and stay as history.
-- G3: no consumer-API object is touched. Live check 11:45: no function in schema api or named website_v2_/website_edge_/website_api_v2_/zoho_edge_
--   reads catalogue.course_links; the website and Zoho read the link only through search.course_documents.official_course_url (the projection).
--
-- RULES (from the task, applied exactly):
--   Kept link   = the active official link whose URL the projection already shows (search.course_documents.official_course_url).
--   Validated   = the kept link is primary, OR it equals catalogue.courses.course_url AND passes security.course_page_check_v1 (verdict 'pass').
--   In tranche  = H01 (reviewer link + other, neither primary) or H03 (a primary + others) or H04 (same page spelled differently, normalised
--                 scheme/www/query/trailing slash/case) or H09 (an older-year link beside a newer one), AND kept link validated, AND
--                 not E16 (77-course cohort, Decisions 1-2), no manual lock (H14/H26), no open SS-007 hold, no pending official_course_url
--                 Layer 4 item, exactly one shown link, and NO other active link that is itself validated (that would be a consumer choice).
--   Action      = superseded duplicates -> 'inactive', is_primary false; kept link -> is_primary true where not already.
--   Consumer    = unchanged by construction: the kept link is the shown link, it stays active and becomes the only active official link.
--                 The write block re-checks after the projection refresh and raises (rolling everything back) if any shown URL differs.
--
-- MEASURED 2 Nov 12:06-12:07 AEDT (keyed by course_id halves; page checks 11:55-11:56 in batches of <=70):
--   All courses with >1 active official link: 239 courses, 491 links (equals the reconciliation's A1: 239 / 491).
--   | Disposition                                  | Half A (<8000...) | Half B (>=8000...) | Total courses (links) |
--   |----------------------------------------------|------------------:|-------------------:|----------------------:|
--   | IN THIS TRANCHE                              | 52 (105)          | 49 (108)           | 101 (213)             |
--   | E16 cohort - excluded, Decisions 1-2         | 18                | 20                 | 38                    |
--   | Hand-locked course (121389A, 121391G, 121394D, 121390H, 121393E, 121395C) - excluded, H26 | 4 | 2 | 6     |
--   | No search document (041111J) - excluded      | 1                 | 0                  | 1                     |
--   | Kept link not validated by the rule - HELD   | 41 (82)           | 52 (105)           | 93 (187)              |
--   | Consumer-visible change candidates           | 0                 | 0                  | 0                     |
--   Tranche detail: superseded links to 'inactive' 53 + 59 = 112; kept links made primary 46 + 37 = 83; kept already primary 6 + 12 = 18.
--   Validated by: primary 6 + 12 = 18; course_url + page check pass 46 + 37 = 83.
--   Tags inside the tranche (overlapping): H01 38 + 27 = 65; H03 6 + 12 = 18; H04 10 + 21 = 31; H09 11 + 11 = 22.
--   md5 (sorted, comma-joined, text):
--     Half A courses 05528955becdafe84abbb20005913b0a  kept eb9fb756b269f262be52814e264c5398  superseded 15c6b04522c9fc2f4d0e9cc68cc3c0d2
--     Half B courses 1ddb5647e02d83ce4bfe436c87af545f  kept 8eb8523dbe65c49ccfae42b22bcd78aa  superseded c4e99f89175ade771b7c6850e7e04616
--   HELD (93, all H01; 85 also H09): the reviewer link is shown but catalogue.courses.course_url names a different page (or is null on 8), so the
--     rule "primary, or equal to course_url and passing the page check" is not met. Consolidating them would NOT change what consumers see,
--     but it needs the Platform Admin to accept the Layer 4 reviewer decision as the validation (or to settle H07 first). md5 Half A
--     bac0e6ca5736e302b709bd2189ac6987, Half B c43b9dd6eb0e99e7d8ce457fb909623d. 7 of the 93 show a link the page check now REFUSES
--     (454bb36d..., 95fc1a5d..., 97dbcc4e..., 980fb700..., b3cadedc..., ef8a4b5b..., f16381f9...: rules shared_page, variant x2, sibling,
--     old_year x2, shared_page); those are routed to Layer 4 in the H05/H13/H20 file, not consolidated.
--   The 9 links the page check refused at 11:55 are embedded below as `refused` (they can never count as validated).
--
-- RUN ORDER: step 0 (read-only, two queries + two page-check queries) -> step 1 (write, one transaction) -> read-back -> commit or rollback.

-- ===== STEP 0 (read-only pre-flight). Expect: Half A 52 / 05528955... / eb9fb756... / 46; Half B 49 / 1ddb5647... / 8eb8523d... / 37 =====
-- 0a Half A
set statement_timeout = '9s';
with e16 as materialized (select unnest(array['004b6c5c-4a6a-4b65-9f8d-1093049ea150','02c7bc01-0cc8-40bd-a190-b6eea143f3a5','0d25903f-de8e-460c-b403-2648148fcadd','111079e4-ca8d-4a72-bca1-145a141e201d','169b5258-0e1a-471a-807d-8473bdd0dcf2','196a1939-628d-4e86-8e4f-f40e0858be2e','19b048c5-3474-46d2-88a4-44b7c7eea8f5','1a8df22a-2739-4226-8856-10dd228e0033','1b78ba46-638c-4465-859e-8689e96295a8','1bfad09c-0734-4ef2-802a-52381c9d2ffa','20f2aa2c-1e7f-44c6-950c-47afa7881428','227e6abf-8897-4e35-9d6f-98de5c5a1160','264c5b84-eff8-49ac-b03f-c8cf12708198','26f9b73e-f6e3-41bc-8ff0-b7df8a2ef428','283a0dd2-0101-45c0-8a09-b0441f51d783','2bdf84a5-a806-469e-83a1-5e500559dfe4','2be0fafe-c403-495c-96bc-32b9f181a1a2','2cf5c4ac-b56d-44e2-b69e-93b6ce39a475','2d6d3d1c-8f6f-4455-8228-91d3f32ca491','33ded954-9998-43ff-9384-c3ca6788d54f','40afad92-5a55-47d8-88e3-2015c41d11af','4241f004-3144-4fd4-8468-960854850e38','43cb1105-82cd-4479-a1ed-48478514b94f','486ed99f-09f3-4ef5-9649-1dec1d9878d8','488f50c4-e7d3-4b21-a8a1-8ed95fcc0a03','4ad16106-b97b-44e6-b0bb-aa1ebd3b21aa','4e6f8c56-07cc-468b-97ff-5264276360ce','51b27099-8086-4c68-9b9f-04c74af883f6','5b6f8b6d-40c3-42ab-9d5a-52fb01f25c58','5cee7974-a3bf-416e-bd0e-a262bc56e955','60ebab30-d9a8-47f9-bf7f-85aebc49039f','670b7ce1-719e-4cdb-91e1-4111d0eba767','6b5874f1-770f-4000-9614-56a6df194724','6bad09d8-f8a1-45e9-9f1c-f8ba258d74d2','6d42acd7-35e9-4975-aa9f-2b7f400d341d','6f60c044-d710-420a-aed5-c6567c275f13','76339427-bad5-499f-94f0-3b158b6ff057','7cf958c9-c317-4a77-868c-3ba802174d1d','7e117900-eab0-4c4d-8104-11b9ffaf9b26','7f9cffdb-54ae-47e3-a595-edac98cd0dd6','87975d53-8b43-46c8-b209-9924fa43ea79','8a7a7b24-6ba1-4140-ac35-651552220afd','8b731ff6-2518-45a7-b73d-e6d03f22c405','8bdf836f-7de2-4570-be80-d87864c3e7e2','8c317304-0728-42ca-8e14-0b308a5ffbb2','8d1f1afd-96e1-44b3-bc61-a4dc42f54536','95fcd50f-257e-43d6-9920-f3599cacf374','98610bb2-1c02-49cf-a7ce-0d4ab8fc137f','9f50f886-8d83-40b9-8607-28a5d46b44a4','a0195518-e6a5-4663-88d4-677bd9c8d0b1','a021a3df-3ad0-43c1-a9b2-54d479473078','a940f900-bfa0-43a8-bba1-1e60c922a699','ad154e70-d0aa-45e8-a2f3-76f84d5c2902','b2226705-305a-4e88-9af5-fd8b404239c5','b444c1b8-9820-4cc9-a1b0-cb92beb56be1','b86828bb-9b14-46b4-a9bc-50a8de61fa39','ba8d7def-6f2e-48aa-a314-70603abe8d9c','bf8dd977-b939-4138-a6cc-744cd5e3dedf','cdc06d73-f08b-40fc-9d30-1700df678e62','d122606b-fe48-4a1a-b030-c9b84ea11ec1','d25f60bb-bd10-4956-8337-cdefdff8b1ce','d3443473-9636-4a37-a6ed-e531c863a101','d5e7c833-7912-4046-8b6a-da966520a7c4','d7d1890f-a7f0-44c0-b16a-97f9f7445be8','da0667c1-9818-4ab3-bbf7-c047f5de404d','dd5f7176-0ca9-462c-b399-4f05d06c5e67','de86b0d9-bb66-4a7d-8b05-ff1fa2c6d9cd','e1596a78-53ad-463f-bd1a-1442109c6ac3','e5822674-6fca-47a7-980f-dce5b054859d','ebfc236d-1c66-4f5b-bd4d-815ad7655e33','f0052042-998a-4f05-843f-467ff76a021c','f013a634-9344-4ae8-8ae6-07c2310b3e93','f5baa817-87a6-4f2d-a57f-a02b9e9dd90a','fa955ff0-37d1-4c91-826a-89c812cde021','fcde61b0-f5fe-4618-814c-a76a4b4d1dc7','fe4f81a5-9262-41f8-82c7-8fd2c1dee621','ff63eb8b-2705-4db7-8500-1db2c548216a']::uuid[]) id),
refused as materialized (select unnest(array['34ebc7b9-24fb-4e7a-be05-6caafb0ecc58','66e8fa58-d631-453b-b99f-65e373c3bfe3','a20e2487-1ce1-4e23-95ba-a2eddb2174b3','14acba8a-8c29-48bc-a5d3-ef49ca5962bc','68aebf97-de88-4f37-ad76-7a9eb606595c','53d7e7c0-c852-4374-b36a-813316690a72','7f88ce4a-23a5-4bff-9a55-6294041a5e37','84955c3e-b359-4a0b-84e3-15101904e7a6','b85c3795-7c89-4fba-af9b-56f57084accb']::uuid[]) id),
lk as materialized (select l.course_id from catalogue.course_links l
   where l.course_id >= '00000000-0000-0000-0000-000000000000'::uuid and l.course_id < '80000000-0000-0000-0000-000000000000'::uuid and l.link_type='official_course' and l.status='active'
   group by l.course_id having count(*)>1),
al as materialized (select l.id, l.course_id, l.url, l.is_primary, s.source_type st, substring(l.url from '/(20[12][0-9])(/|$|\?)') yr,
     regexp_replace(regexp_replace(regexp_replace(lower(l.url),'^https?://(www\.)?',''),'[?#].*$',''),'/+$','') nu
   from lk join catalogue.course_links l on l.course_id=lk.course_id and l.link_type='official_course' and l.status='active' left join pipeline.sources s on s.id=l.source_id),
c as materialized (
 select co.id, co.course_code code, co.course_url cu, d.official_course_url shown, d.course_id is not null hasdoc,
   (co.id in (select id from e16)) e16,
   (select count(*) from pipeline.manual_locks m where m.entity='course' and m.entity_id=co.id) locks,
   (select count(*) from pipeline.course_remediation_holds h where h.course_id=co.id and h.lifted_at is null) holds,
   (select count(*) from pipeline.layer4_review_items i where i.entity_type='course' and i.entity_id=co.id and i.field_code='official_course_url' and i.status='pending') l4p,
   (select count(*) from al where al.course_id=co.id) nact,
   (select count(*) from al where al.course_id=co.id and al.is_primary) nprim,
   (select count(*) from al where al.course_id=co.id and al.st='layer4_human_review') nrev,
   (select count(distinct nu) from al where al.course_id=co.id) ndist,
   (select max(yr)>min(yr) from al where al.course_id=co.id) oldyr,
   (select array_agg(al.id) from al where al.course_id=co.id and al.url=d.official_course_url) kept,
   (select bool_or(al.is_primary) from al where al.course_id=co.id and al.url=d.official_course_url) kprim,
   (select bool_or(al.url=co.course_url and al.id not in (select id from refused)) from al where al.course_id=co.id and al.url=d.official_course_url) kcheck,
   (select bool_or(al.is_primary or (al.url=co.course_url and al.id not in (select id from refused))) from al where al.course_id=co.id and al.url is distinct from d.official_course_url) other_valid
 from lk join catalogue.courses co on co.id=lk.course_id left join search.course_documents d on d.course_id=co.id),
k as materialized (select c.*,
   case when e16 then 'x_e16' when locks>0 then 'x_locked' when holds>0 then 'x_hold' when l4p>0 then 'x_l4_pending'
        when not hasdoc or cardinality(coalesce(kept,'{}'))<>1 then 'x_no_shown_link'
        when not (nprim>=1 or (nrev>=1 and nprim=0) or ndist<nact or coalesce(oldyr,false)) then 'x_out_of_scope_h02_type'
        when coalesce(other_valid,false) then 'x_consumer_change'
        when coalesce(kprim,false) or coalesce(kcheck,false) then 'tranche'
        else 'x_kept_not_validated' end cat
 from c)
select now() at time zone 'Australia/Melbourne' t, count(*) filter (where cat='tranche') tranche,
  md5(string_agg(id::text, ',' order by id::text) filter (where cat='tranche')) md5_courses,
  md5(string_agg(kept[1]::text, ',' order by kept[1]::text) filter (where cat='tranche')) md5_kept,
  count(*) filter (where cat='tranche' and not coalesce(kprim,false)) make_primary
from k;
-- 0b Half B
set statement_timeout = '9s';
with e16 as materialized (select unnest(array['004b6c5c-4a6a-4b65-9f8d-1093049ea150','02c7bc01-0cc8-40bd-a190-b6eea143f3a5','0d25903f-de8e-460c-b403-2648148fcadd','111079e4-ca8d-4a72-bca1-145a141e201d','169b5258-0e1a-471a-807d-8473bdd0dcf2','196a1939-628d-4e86-8e4f-f40e0858be2e','19b048c5-3474-46d2-88a4-44b7c7eea8f5','1a8df22a-2739-4226-8856-10dd228e0033','1b78ba46-638c-4465-859e-8689e96295a8','1bfad09c-0734-4ef2-802a-52381c9d2ffa','20f2aa2c-1e7f-44c6-950c-47afa7881428','227e6abf-8897-4e35-9d6f-98de5c5a1160','264c5b84-eff8-49ac-b03f-c8cf12708198','26f9b73e-f6e3-41bc-8ff0-b7df8a2ef428','283a0dd2-0101-45c0-8a09-b0441f51d783','2bdf84a5-a806-469e-83a1-5e500559dfe4','2be0fafe-c403-495c-96bc-32b9f181a1a2','2cf5c4ac-b56d-44e2-b69e-93b6ce39a475','2d6d3d1c-8f6f-4455-8228-91d3f32ca491','33ded954-9998-43ff-9384-c3ca6788d54f','40afad92-5a55-47d8-88e3-2015c41d11af','4241f004-3144-4fd4-8468-960854850e38','43cb1105-82cd-4479-a1ed-48478514b94f','486ed99f-09f3-4ef5-9649-1dec1d9878d8','488f50c4-e7d3-4b21-a8a1-8ed95fcc0a03','4ad16106-b97b-44e6-b0bb-aa1ebd3b21aa','4e6f8c56-07cc-468b-97ff-5264276360ce','51b27099-8086-4c68-9b9f-04c74af883f6','5b6f8b6d-40c3-42ab-9d5a-52fb01f25c58','5cee7974-a3bf-416e-bd0e-a262bc56e955','60ebab30-d9a8-47f9-bf7f-85aebc49039f','670b7ce1-719e-4cdb-91e1-4111d0eba767','6b5874f1-770f-4000-9614-56a6df194724','6bad09d8-f8a1-45e9-9f1c-f8ba258d74d2','6d42acd7-35e9-4975-aa9f-2b7f400d341d','6f60c044-d710-420a-aed5-c6567c275f13','76339427-bad5-499f-94f0-3b158b6ff057','7cf958c9-c317-4a77-868c-3ba802174d1d','7e117900-eab0-4c4d-8104-11b9ffaf9b26','7f9cffdb-54ae-47e3-a595-edac98cd0dd6','87975d53-8b43-46c8-b209-9924fa43ea79','8a7a7b24-6ba1-4140-ac35-651552220afd','8b731ff6-2518-45a7-b73d-e6d03f22c405','8bdf836f-7de2-4570-be80-d87864c3e7e2','8c317304-0728-42ca-8e14-0b308a5ffbb2','8d1f1afd-96e1-44b3-bc61-a4dc42f54536','95fcd50f-257e-43d6-9920-f3599cacf374','98610bb2-1c02-49cf-a7ce-0d4ab8fc137f','9f50f886-8d83-40b9-8607-28a5d46b44a4','a0195518-e6a5-4663-88d4-677bd9c8d0b1','a021a3df-3ad0-43c1-a9b2-54d479473078','a940f900-bfa0-43a8-bba1-1e60c922a699','ad154e70-d0aa-45e8-a2f3-76f84d5c2902','b2226705-305a-4e88-9af5-fd8b404239c5','b444c1b8-9820-4cc9-a1b0-cb92beb56be1','b86828bb-9b14-46b4-a9bc-50a8de61fa39','ba8d7def-6f2e-48aa-a314-70603abe8d9c','bf8dd977-b939-4138-a6cc-744cd5e3dedf','cdc06d73-f08b-40fc-9d30-1700df678e62','d122606b-fe48-4a1a-b030-c9b84ea11ec1','d25f60bb-bd10-4956-8337-cdefdff8b1ce','d3443473-9636-4a37-a6ed-e531c863a101','d5e7c833-7912-4046-8b6a-da966520a7c4','d7d1890f-a7f0-44c0-b16a-97f9f7445be8','da0667c1-9818-4ab3-bbf7-c047f5de404d','dd5f7176-0ca9-462c-b399-4f05d06c5e67','de86b0d9-bb66-4a7d-8b05-ff1fa2c6d9cd','e1596a78-53ad-463f-bd1a-1442109c6ac3','e5822674-6fca-47a7-980f-dce5b054859d','ebfc236d-1c66-4f5b-bd4d-815ad7655e33','f0052042-998a-4f05-843f-467ff76a021c','f013a634-9344-4ae8-8ae6-07c2310b3e93','f5baa817-87a6-4f2d-a57f-a02b9e9dd90a','fa955ff0-37d1-4c91-826a-89c812cde021','fcde61b0-f5fe-4618-814c-a76a4b4d1dc7','fe4f81a5-9262-41f8-82c7-8fd2c1dee621','ff63eb8b-2705-4db7-8500-1db2c548216a']::uuid[]) id),
refused as materialized (select unnest(array['34ebc7b9-24fb-4e7a-be05-6caafb0ecc58','66e8fa58-d631-453b-b99f-65e373c3bfe3','a20e2487-1ce1-4e23-95ba-a2eddb2174b3','14acba8a-8c29-48bc-a5d3-ef49ca5962bc','68aebf97-de88-4f37-ad76-7a9eb606595c','53d7e7c0-c852-4374-b36a-813316690a72','7f88ce4a-23a5-4bff-9a55-6294041a5e37','84955c3e-b359-4a0b-84e3-15101904e7a6','b85c3795-7c89-4fba-af9b-56f57084accb']::uuid[]) id),
lk as materialized (select l.course_id from catalogue.course_links l
   where l.course_id >= '80000000-0000-0000-0000-000000000000'::uuid and l.course_id <= 'ffffffff-ffff-ffff-ffff-ffffffffffff'::uuid and l.link_type='official_course' and l.status='active'
   group by l.course_id having count(*)>1),
al as materialized (select l.id, l.course_id, l.url, l.is_primary, s.source_type st, substring(l.url from '/(20[12][0-9])(/|$|\?)') yr,
     regexp_replace(regexp_replace(regexp_replace(lower(l.url),'^https?://(www\.)?',''),'[?#].*$',''),'/+$','') nu
   from lk join catalogue.course_links l on l.course_id=lk.course_id and l.link_type='official_course' and l.status='active' left join pipeline.sources s on s.id=l.source_id),
c as materialized (
 select co.id, co.course_code code, co.course_url cu, d.official_course_url shown, d.course_id is not null hasdoc,
   (co.id in (select id from e16)) e16,
   (select count(*) from pipeline.manual_locks m where m.entity='course' and m.entity_id=co.id) locks,
   (select count(*) from pipeline.course_remediation_holds h where h.course_id=co.id and h.lifted_at is null) holds,
   (select count(*) from pipeline.layer4_review_items i where i.entity_type='course' and i.entity_id=co.id and i.field_code='official_course_url' and i.status='pending') l4p,
   (select count(*) from al where al.course_id=co.id) nact,
   (select count(*) from al where al.course_id=co.id and al.is_primary) nprim,
   (select count(*) from al where al.course_id=co.id and al.st='layer4_human_review') nrev,
   (select count(distinct nu) from al where al.course_id=co.id) ndist,
   (select max(yr)>min(yr) from al where al.course_id=co.id) oldyr,
   (select array_agg(al.id) from al where al.course_id=co.id and al.url=d.official_course_url) kept,
   (select bool_or(al.is_primary) from al where al.course_id=co.id and al.url=d.official_course_url) kprim,
   (select bool_or(al.url=co.course_url and al.id not in (select id from refused)) from al where al.course_id=co.id and al.url=d.official_course_url) kcheck,
   (select bool_or(al.is_primary or (al.url=co.course_url and al.id not in (select id from refused))) from al where al.course_id=co.id and al.url is distinct from d.official_course_url) other_valid
 from lk join catalogue.courses co on co.id=lk.course_id left join search.course_documents d on d.course_id=co.id),
k as materialized (select c.*,
   case when e16 then 'x_e16' when locks>0 then 'x_locked' when holds>0 then 'x_hold' when l4p>0 then 'x_l4_pending'
        when not hasdoc or cardinality(coalesce(kept,'{}'))<>1 then 'x_no_shown_link'
        when not (nprim>=1 or (nrev>=1 and nprim=0) or ndist<nact or coalesce(oldyr,false)) then 'x_out_of_scope_h02_type'
        when coalesce(other_valid,false) then 'x_consumer_change'
        when coalesce(kprim,false) or coalesce(kcheck,false) then 'tranche'
        else 'x_kept_not_validated' end cat
 from c)
select now() at time zone 'Australia/Melbourne' t, count(*) filter (where cat='tranche') tranche,
  md5(string_agg(id::text, ',' order by id::text) filter (where cat='tranche')) md5_courses,
  md5(string_agg(kept[1]::text, ',' order by kept[1]::text) filter (where cat='tranche')) md5_kept,
  count(*) filter (where cat='tranche' and not coalesce(kprim,false)) make_primary
from k;
-- 0c / 0d: page check of every non-primary kept link (expect Half A checked 46 pass 46, Half B checked 37 pass 37; not_pass null). Any not_pass: STOP.
-- 0c Half A
set statement_timeout = '9s';
with e16 as materialized (select unnest(array['004b6c5c-4a6a-4b65-9f8d-1093049ea150','02c7bc01-0cc8-40bd-a190-b6eea143f3a5','0d25903f-de8e-460c-b403-2648148fcadd','111079e4-ca8d-4a72-bca1-145a141e201d','169b5258-0e1a-471a-807d-8473bdd0dcf2','196a1939-628d-4e86-8e4f-f40e0858be2e','19b048c5-3474-46d2-88a4-44b7c7eea8f5','1a8df22a-2739-4226-8856-10dd228e0033','1b78ba46-638c-4465-859e-8689e96295a8','1bfad09c-0734-4ef2-802a-52381c9d2ffa','20f2aa2c-1e7f-44c6-950c-47afa7881428','227e6abf-8897-4e35-9d6f-98de5c5a1160','264c5b84-eff8-49ac-b03f-c8cf12708198','26f9b73e-f6e3-41bc-8ff0-b7df8a2ef428','283a0dd2-0101-45c0-8a09-b0441f51d783','2bdf84a5-a806-469e-83a1-5e500559dfe4','2be0fafe-c403-495c-96bc-32b9f181a1a2','2cf5c4ac-b56d-44e2-b69e-93b6ce39a475','2d6d3d1c-8f6f-4455-8228-91d3f32ca491','33ded954-9998-43ff-9384-c3ca6788d54f','40afad92-5a55-47d8-88e3-2015c41d11af','4241f004-3144-4fd4-8468-960854850e38','43cb1105-82cd-4479-a1ed-48478514b94f','486ed99f-09f3-4ef5-9649-1dec1d9878d8','488f50c4-e7d3-4b21-a8a1-8ed95fcc0a03','4ad16106-b97b-44e6-b0bb-aa1ebd3b21aa','4e6f8c56-07cc-468b-97ff-5264276360ce','51b27099-8086-4c68-9b9f-04c74af883f6','5b6f8b6d-40c3-42ab-9d5a-52fb01f25c58','5cee7974-a3bf-416e-bd0e-a262bc56e955','60ebab30-d9a8-47f9-bf7f-85aebc49039f','670b7ce1-719e-4cdb-91e1-4111d0eba767','6b5874f1-770f-4000-9614-56a6df194724','6bad09d8-f8a1-45e9-9f1c-f8ba258d74d2','6d42acd7-35e9-4975-aa9f-2b7f400d341d','6f60c044-d710-420a-aed5-c6567c275f13','76339427-bad5-499f-94f0-3b158b6ff057','7cf958c9-c317-4a77-868c-3ba802174d1d','7e117900-eab0-4c4d-8104-11b9ffaf9b26','7f9cffdb-54ae-47e3-a595-edac98cd0dd6','87975d53-8b43-46c8-b209-9924fa43ea79','8a7a7b24-6ba1-4140-ac35-651552220afd','8b731ff6-2518-45a7-b73d-e6d03f22c405','8bdf836f-7de2-4570-be80-d87864c3e7e2','8c317304-0728-42ca-8e14-0b308a5ffbb2','8d1f1afd-96e1-44b3-bc61-a4dc42f54536','95fcd50f-257e-43d6-9920-f3599cacf374','98610bb2-1c02-49cf-a7ce-0d4ab8fc137f','9f50f886-8d83-40b9-8607-28a5d46b44a4','a0195518-e6a5-4663-88d4-677bd9c8d0b1','a021a3df-3ad0-43c1-a9b2-54d479473078','a940f900-bfa0-43a8-bba1-1e60c922a699','ad154e70-d0aa-45e8-a2f3-76f84d5c2902','b2226705-305a-4e88-9af5-fd8b404239c5','b444c1b8-9820-4cc9-a1b0-cb92beb56be1','b86828bb-9b14-46b4-a9bc-50a8de61fa39','ba8d7def-6f2e-48aa-a314-70603abe8d9c','bf8dd977-b939-4138-a6cc-744cd5e3dedf','cdc06d73-f08b-40fc-9d30-1700df678e62','d122606b-fe48-4a1a-b030-c9b84ea11ec1','d25f60bb-bd10-4956-8337-cdefdff8b1ce','d3443473-9636-4a37-a6ed-e531c863a101','d5e7c833-7912-4046-8b6a-da966520a7c4','d7d1890f-a7f0-44c0-b16a-97f9f7445be8','da0667c1-9818-4ab3-bbf7-c047f5de404d','dd5f7176-0ca9-462c-b399-4f05d06c5e67','de86b0d9-bb66-4a7d-8b05-ff1fa2c6d9cd','e1596a78-53ad-463f-bd1a-1442109c6ac3','e5822674-6fca-47a7-980f-dce5b054859d','ebfc236d-1c66-4f5b-bd4d-815ad7655e33','f0052042-998a-4f05-843f-467ff76a021c','f013a634-9344-4ae8-8ae6-07c2310b3e93','f5baa817-87a6-4f2d-a57f-a02b9e9dd90a','fa955ff0-37d1-4c91-826a-89c812cde021','fcde61b0-f5fe-4618-814c-a76a4b4d1dc7','fe4f81a5-9262-41f8-82c7-8fd2c1dee621','ff63eb8b-2705-4db7-8500-1db2c548216a']::uuid[]) id),
refused as materialized (select unnest(array['34ebc7b9-24fb-4e7a-be05-6caafb0ecc58','66e8fa58-d631-453b-b99f-65e373c3bfe3','a20e2487-1ce1-4e23-95ba-a2eddb2174b3','14acba8a-8c29-48bc-a5d3-ef49ca5962bc','68aebf97-de88-4f37-ad76-7a9eb606595c','53d7e7c0-c852-4374-b36a-813316690a72','7f88ce4a-23a5-4bff-9a55-6294041a5e37','84955c3e-b359-4a0b-84e3-15101904e7a6','b85c3795-7c89-4fba-af9b-56f57084accb']::uuid[]) id),
lk as materialized (select l.course_id from catalogue.course_links l
   where l.course_id >= '00000000-0000-0000-0000-000000000000'::uuid and l.course_id < '80000000-0000-0000-0000-000000000000'::uuid and l.link_type='official_course' and l.status='active'
   group by l.course_id having count(*)>1),
al as materialized (select l.id, l.course_id, l.url, l.is_primary, s.source_type st, substring(l.url from '/(20[12][0-9])(/|$|\?)') yr,
     regexp_replace(regexp_replace(regexp_replace(lower(l.url),'^https?://(www\.)?',''),'[?#].*$',''),'/+$','') nu
   from lk join catalogue.course_links l on l.course_id=lk.course_id and l.link_type='official_course' and l.status='active' left join pipeline.sources s on s.id=l.source_id),
c as materialized (
 select co.id, co.course_code code, co.course_url cu, d.official_course_url shown, d.course_id is not null hasdoc,
   (co.id in (select id from e16)) e16,
   (select count(*) from pipeline.manual_locks m where m.entity='course' and m.entity_id=co.id) locks,
   (select count(*) from pipeline.course_remediation_holds h where h.course_id=co.id and h.lifted_at is null) holds,
   (select count(*) from pipeline.layer4_review_items i where i.entity_type='course' and i.entity_id=co.id and i.field_code='official_course_url' and i.status='pending') l4p,
   (select count(*) from al where al.course_id=co.id) nact,
   (select count(*) from al where al.course_id=co.id and al.is_primary) nprim,
   (select count(*) from al where al.course_id=co.id and al.st='layer4_human_review') nrev,
   (select count(distinct nu) from al where al.course_id=co.id) ndist,
   (select max(yr)>min(yr) from al where al.course_id=co.id) oldyr,
   (select array_agg(al.id) from al where al.course_id=co.id and al.url=d.official_course_url) kept,
   (select bool_or(al.is_primary) from al where al.course_id=co.id and al.url=d.official_course_url) kprim,
   (select bool_or(al.url=co.course_url and al.id not in (select id from refused)) from al where al.course_id=co.id and al.url=d.official_course_url) kcheck,
   (select bool_or(al.is_primary or (al.url=co.course_url and al.id not in (select id from refused))) from al where al.course_id=co.id and al.url is distinct from d.official_course_url) other_valid
 from lk join catalogue.courses co on co.id=lk.course_id left join search.course_documents d on d.course_id=co.id),
k0 as materialized (select c.*,
   case when e16 then 'x_e16' when locks>0 then 'x_locked' when holds>0 then 'x_hold' when l4p>0 then 'x_l4_pending'
        when not hasdoc or cardinality(coalesce(kept,'{}'))<>1 then 'x_no_shown_link'
        when not (nprim>=1 or (nrev>=1 and nprim=0) or ndist<nact or coalesce(oldyr,false)) then 'x_out_of_scope_h02_type'
        when coalesce(other_valid,false) then 'x_consumer_change'
        when coalesce(kprim,false) or coalesce(kcheck,false) then 'tranche'
        else 'x_kept_not_validated' end cat
 from c),
pcx as materialized (select k0.id, k0.kept[1] link_id, k0.shown from k0 where k0.cat='tranche' and not coalesce(k0.kprim,false) order by k0.id limit 50)
select count(*) checked, count(*) filter (where r->>'verdict'='pass') pass,
  jsonb_agg(jsonb_build_object('course',id,'link',link_id,'verdict',r->>'verdict','rule',r->>'rule')) filter (where r->>'verdict' is distinct from 'pass') not_pass
from (select pcx.*, security.course_page_check_v1(pcx.id, pcx.shown) r from pcx) z;
-- 0d Half B
set statement_timeout = '9s';
with e16 as materialized (select unnest(array['004b6c5c-4a6a-4b65-9f8d-1093049ea150','02c7bc01-0cc8-40bd-a190-b6eea143f3a5','0d25903f-de8e-460c-b403-2648148fcadd','111079e4-ca8d-4a72-bca1-145a141e201d','169b5258-0e1a-471a-807d-8473bdd0dcf2','196a1939-628d-4e86-8e4f-f40e0858be2e','19b048c5-3474-46d2-88a4-44b7c7eea8f5','1a8df22a-2739-4226-8856-10dd228e0033','1b78ba46-638c-4465-859e-8689e96295a8','1bfad09c-0734-4ef2-802a-52381c9d2ffa','20f2aa2c-1e7f-44c6-950c-47afa7881428','227e6abf-8897-4e35-9d6f-98de5c5a1160','264c5b84-eff8-49ac-b03f-c8cf12708198','26f9b73e-f6e3-41bc-8ff0-b7df8a2ef428','283a0dd2-0101-45c0-8a09-b0441f51d783','2bdf84a5-a806-469e-83a1-5e500559dfe4','2be0fafe-c403-495c-96bc-32b9f181a1a2','2cf5c4ac-b56d-44e2-b69e-93b6ce39a475','2d6d3d1c-8f6f-4455-8228-91d3f32ca491','33ded954-9998-43ff-9384-c3ca6788d54f','40afad92-5a55-47d8-88e3-2015c41d11af','4241f004-3144-4fd4-8468-960854850e38','43cb1105-82cd-4479-a1ed-48478514b94f','486ed99f-09f3-4ef5-9649-1dec1d9878d8','488f50c4-e7d3-4b21-a8a1-8ed95fcc0a03','4ad16106-b97b-44e6-b0bb-aa1ebd3b21aa','4e6f8c56-07cc-468b-97ff-5264276360ce','51b27099-8086-4c68-9b9f-04c74af883f6','5b6f8b6d-40c3-42ab-9d5a-52fb01f25c58','5cee7974-a3bf-416e-bd0e-a262bc56e955','60ebab30-d9a8-47f9-bf7f-85aebc49039f','670b7ce1-719e-4cdb-91e1-4111d0eba767','6b5874f1-770f-4000-9614-56a6df194724','6bad09d8-f8a1-45e9-9f1c-f8ba258d74d2','6d42acd7-35e9-4975-aa9f-2b7f400d341d','6f60c044-d710-420a-aed5-c6567c275f13','76339427-bad5-499f-94f0-3b158b6ff057','7cf958c9-c317-4a77-868c-3ba802174d1d','7e117900-eab0-4c4d-8104-11b9ffaf9b26','7f9cffdb-54ae-47e3-a595-edac98cd0dd6','87975d53-8b43-46c8-b209-9924fa43ea79','8a7a7b24-6ba1-4140-ac35-651552220afd','8b731ff6-2518-45a7-b73d-e6d03f22c405','8bdf836f-7de2-4570-be80-d87864c3e7e2','8c317304-0728-42ca-8e14-0b308a5ffbb2','8d1f1afd-96e1-44b3-bc61-a4dc42f54536','95fcd50f-257e-43d6-9920-f3599cacf374','98610bb2-1c02-49cf-a7ce-0d4ab8fc137f','9f50f886-8d83-40b9-8607-28a5d46b44a4','a0195518-e6a5-4663-88d4-677bd9c8d0b1','a021a3df-3ad0-43c1-a9b2-54d479473078','a940f900-bfa0-43a8-bba1-1e60c922a699','ad154e70-d0aa-45e8-a2f3-76f84d5c2902','b2226705-305a-4e88-9af5-fd8b404239c5','b444c1b8-9820-4cc9-a1b0-cb92beb56be1','b86828bb-9b14-46b4-a9bc-50a8de61fa39','ba8d7def-6f2e-48aa-a314-70603abe8d9c','bf8dd977-b939-4138-a6cc-744cd5e3dedf','cdc06d73-f08b-40fc-9d30-1700df678e62','d122606b-fe48-4a1a-b030-c9b84ea11ec1','d25f60bb-bd10-4956-8337-cdefdff8b1ce','d3443473-9636-4a37-a6ed-e531c863a101','d5e7c833-7912-4046-8b6a-da966520a7c4','d7d1890f-a7f0-44c0-b16a-97f9f7445be8','da0667c1-9818-4ab3-bbf7-c047f5de404d','dd5f7176-0ca9-462c-b399-4f05d06c5e67','de86b0d9-bb66-4a7d-8b05-ff1fa2c6d9cd','e1596a78-53ad-463f-bd1a-1442109c6ac3','e5822674-6fca-47a7-980f-dce5b054859d','ebfc236d-1c66-4f5b-bd4d-815ad7655e33','f0052042-998a-4f05-843f-467ff76a021c','f013a634-9344-4ae8-8ae6-07c2310b3e93','f5baa817-87a6-4f2d-a57f-a02b9e9dd90a','fa955ff0-37d1-4c91-826a-89c812cde021','fcde61b0-f5fe-4618-814c-a76a4b4d1dc7','fe4f81a5-9262-41f8-82c7-8fd2c1dee621','ff63eb8b-2705-4db7-8500-1db2c548216a']::uuid[]) id),
refused as materialized (select unnest(array['34ebc7b9-24fb-4e7a-be05-6caafb0ecc58','66e8fa58-d631-453b-b99f-65e373c3bfe3','a20e2487-1ce1-4e23-95ba-a2eddb2174b3','14acba8a-8c29-48bc-a5d3-ef49ca5962bc','68aebf97-de88-4f37-ad76-7a9eb606595c','53d7e7c0-c852-4374-b36a-813316690a72','7f88ce4a-23a5-4bff-9a55-6294041a5e37','84955c3e-b359-4a0b-84e3-15101904e7a6','b85c3795-7c89-4fba-af9b-56f57084accb']::uuid[]) id),
lk as materialized (select l.course_id from catalogue.course_links l
   where l.course_id >= '80000000-0000-0000-0000-000000000000'::uuid and l.course_id <= 'ffffffff-ffff-ffff-ffff-ffffffffffff'::uuid and l.link_type='official_course' and l.status='active'
   group by l.course_id having count(*)>1),
al as materialized (select l.id, l.course_id, l.url, l.is_primary, s.source_type st, substring(l.url from '/(20[12][0-9])(/|$|\?)') yr,
     regexp_replace(regexp_replace(regexp_replace(lower(l.url),'^https?://(www\.)?',''),'[?#].*$',''),'/+$','') nu
   from lk join catalogue.course_links l on l.course_id=lk.course_id and l.link_type='official_course' and l.status='active' left join pipeline.sources s on s.id=l.source_id),
c as materialized (
 select co.id, co.course_code code, co.course_url cu, d.official_course_url shown, d.course_id is not null hasdoc,
   (co.id in (select id from e16)) e16,
   (select count(*) from pipeline.manual_locks m where m.entity='course' and m.entity_id=co.id) locks,
   (select count(*) from pipeline.course_remediation_holds h where h.course_id=co.id and h.lifted_at is null) holds,
   (select count(*) from pipeline.layer4_review_items i where i.entity_type='course' and i.entity_id=co.id and i.field_code='official_course_url' and i.status='pending') l4p,
   (select count(*) from al where al.course_id=co.id) nact,
   (select count(*) from al where al.course_id=co.id and al.is_primary) nprim,
   (select count(*) from al where al.course_id=co.id and al.st='layer4_human_review') nrev,
   (select count(distinct nu) from al where al.course_id=co.id) ndist,
   (select max(yr)>min(yr) from al where al.course_id=co.id) oldyr,
   (select array_agg(al.id) from al where al.course_id=co.id and al.url=d.official_course_url) kept,
   (select bool_or(al.is_primary) from al where al.course_id=co.id and al.url=d.official_course_url) kprim,
   (select bool_or(al.url=co.course_url and al.id not in (select id from refused)) from al where al.course_id=co.id and al.url=d.official_course_url) kcheck,
   (select bool_or(al.is_primary or (al.url=co.course_url and al.id not in (select id from refused))) from al where al.course_id=co.id and al.url is distinct from d.official_course_url) other_valid
 from lk join catalogue.courses co on co.id=lk.course_id left join search.course_documents d on d.course_id=co.id),
k0 as materialized (select c.*,
   case when e16 then 'x_e16' when locks>0 then 'x_locked' when holds>0 then 'x_hold' when l4p>0 then 'x_l4_pending'
        when not hasdoc or cardinality(coalesce(kept,'{}'))<>1 then 'x_no_shown_link'
        when not (nprim>=1 or (nrev>=1 and nprim=0) or ndist<nact or coalesce(oldyr,false)) then 'x_out_of_scope_h02_type'
        when coalesce(other_valid,false) then 'x_consumer_change'
        when coalesce(kprim,false) or coalesce(kcheck,false) then 'tranche'
        else 'x_kept_not_validated' end cat
 from c),
pcx as materialized (select k0.id, k0.kept[1] link_id, k0.shown from k0 where k0.cat='tranche' and not coalesce(k0.kprim,false) order by k0.id limit 50)
select count(*) checked, count(*) filter (where r->>'verdict'='pass') pass,
  jsonb_agg(jsonb_build_object('course',id,'link',link_id,'verdict',r->>'verdict','rule',r->>'rule')) filter (where r->>'verdict' is distinct from 'pass') not_pass
from (select pcx.*, security.course_page_check_v1(pcx.id, pcx.shown) r from pcx) z;

-- ===== STEP 1 (write; one transaction; every guard raises and rolls back everything) =====
begin;
do $h01$
declare v_n int; v_x text; v_c uuid[];
begin
  create temp table h01_t(half text, course_id uuid, code text, shown text, kept uuid, kprim boolean, superseded uuid[]) on commit drop;
  with e16 as materialized (select unnest(array['004b6c5c-4a6a-4b65-9f8d-1093049ea150','02c7bc01-0cc8-40bd-a190-b6eea143f3a5','0d25903f-de8e-460c-b403-2648148fcadd','111079e4-ca8d-4a72-bca1-145a141e201d','169b5258-0e1a-471a-807d-8473bdd0dcf2','196a1939-628d-4e86-8e4f-f40e0858be2e','19b048c5-3474-46d2-88a4-44b7c7eea8f5','1a8df22a-2739-4226-8856-10dd228e0033','1b78ba46-638c-4465-859e-8689e96295a8','1bfad09c-0734-4ef2-802a-52381c9d2ffa','20f2aa2c-1e7f-44c6-950c-47afa7881428','227e6abf-8897-4e35-9d6f-98de5c5a1160','264c5b84-eff8-49ac-b03f-c8cf12708198','26f9b73e-f6e3-41bc-8ff0-b7df8a2ef428','283a0dd2-0101-45c0-8a09-b0441f51d783','2bdf84a5-a806-469e-83a1-5e500559dfe4','2be0fafe-c403-495c-96bc-32b9f181a1a2','2cf5c4ac-b56d-44e2-b69e-93b6ce39a475','2d6d3d1c-8f6f-4455-8228-91d3f32ca491','33ded954-9998-43ff-9384-c3ca6788d54f','40afad92-5a55-47d8-88e3-2015c41d11af','4241f004-3144-4fd4-8468-960854850e38','43cb1105-82cd-4479-a1ed-48478514b94f','486ed99f-09f3-4ef5-9649-1dec1d9878d8','488f50c4-e7d3-4b21-a8a1-8ed95fcc0a03','4ad16106-b97b-44e6-b0bb-aa1ebd3b21aa','4e6f8c56-07cc-468b-97ff-5264276360ce','51b27099-8086-4c68-9b9f-04c74af883f6','5b6f8b6d-40c3-42ab-9d5a-52fb01f25c58','5cee7974-a3bf-416e-bd0e-a262bc56e955','60ebab30-d9a8-47f9-bf7f-85aebc49039f','670b7ce1-719e-4cdb-91e1-4111d0eba767','6b5874f1-770f-4000-9614-56a6df194724','6bad09d8-f8a1-45e9-9f1c-f8ba258d74d2','6d42acd7-35e9-4975-aa9f-2b7f400d341d','6f60c044-d710-420a-aed5-c6567c275f13','76339427-bad5-499f-94f0-3b158b6ff057','7cf958c9-c317-4a77-868c-3ba802174d1d','7e117900-eab0-4c4d-8104-11b9ffaf9b26','7f9cffdb-54ae-47e3-a595-edac98cd0dd6','87975d53-8b43-46c8-b209-9924fa43ea79','8a7a7b24-6ba1-4140-ac35-651552220afd','8b731ff6-2518-45a7-b73d-e6d03f22c405','8bdf836f-7de2-4570-be80-d87864c3e7e2','8c317304-0728-42ca-8e14-0b308a5ffbb2','8d1f1afd-96e1-44b3-bc61-a4dc42f54536','95fcd50f-257e-43d6-9920-f3599cacf374','98610bb2-1c02-49cf-a7ce-0d4ab8fc137f','9f50f886-8d83-40b9-8607-28a5d46b44a4','a0195518-e6a5-4663-88d4-677bd9c8d0b1','a021a3df-3ad0-43c1-a9b2-54d479473078','a940f900-bfa0-43a8-bba1-1e60c922a699','ad154e70-d0aa-45e8-a2f3-76f84d5c2902','b2226705-305a-4e88-9af5-fd8b404239c5','b444c1b8-9820-4cc9-a1b0-cb92beb56be1','b86828bb-9b14-46b4-a9bc-50a8de61fa39','ba8d7def-6f2e-48aa-a314-70603abe8d9c','bf8dd977-b939-4138-a6cc-744cd5e3dedf','cdc06d73-f08b-40fc-9d30-1700df678e62','d122606b-fe48-4a1a-b030-c9b84ea11ec1','d25f60bb-bd10-4956-8337-cdefdff8b1ce','d3443473-9636-4a37-a6ed-e531c863a101','d5e7c833-7912-4046-8b6a-da966520a7c4','d7d1890f-a7f0-44c0-b16a-97f9f7445be8','da0667c1-9818-4ab3-bbf7-c047f5de404d','dd5f7176-0ca9-462c-b399-4f05d06c5e67','de86b0d9-bb66-4a7d-8b05-ff1fa2c6d9cd','e1596a78-53ad-463f-bd1a-1442109c6ac3','e5822674-6fca-47a7-980f-dce5b054859d','ebfc236d-1c66-4f5b-bd4d-815ad7655e33','f0052042-998a-4f05-843f-467ff76a021c','f013a634-9344-4ae8-8ae6-07c2310b3e93','f5baa817-87a6-4f2d-a57f-a02b9e9dd90a','fa955ff0-37d1-4c91-826a-89c812cde021','fcde61b0-f5fe-4618-814c-a76a4b4d1dc7','fe4f81a5-9262-41f8-82c7-8fd2c1dee621','ff63eb8b-2705-4db7-8500-1db2c548216a']::uuid[]) id),
  refused as materialized (select unnest(array['34ebc7b9-24fb-4e7a-be05-6caafb0ecc58','66e8fa58-d631-453b-b99f-65e373c3bfe3','a20e2487-1ce1-4e23-95ba-a2eddb2174b3','14acba8a-8c29-48bc-a5d3-ef49ca5962bc','68aebf97-de88-4f37-ad76-7a9eb606595c','53d7e7c0-c852-4374-b36a-813316690a72','7f88ce4a-23a5-4bff-9a55-6294041a5e37','84955c3e-b359-4a0b-84e3-15101904e7a6','b85c3795-7c89-4fba-af9b-56f57084accb']::uuid[]) id),
  lk as materialized (select l.course_id from catalogue.course_links l
     where l.course_id >= '00000000-0000-0000-0000-000000000000'::uuid and l.course_id < '80000000-0000-0000-0000-000000000000'::uuid and l.link_type='official_course' and l.status='active'
     group by l.course_id having count(*)>1),
  al as materialized (select l.id, l.course_id, l.url, l.is_primary, s.source_type st, substring(l.url from '/(20[12][0-9])(/|$|\?)') yr,
       regexp_replace(regexp_replace(regexp_replace(lower(l.url),'^https?://(www\.)?',''),'[?#].*$',''),'/+$','') nu
     from lk join catalogue.course_links l on l.course_id=lk.course_id and l.link_type='official_course' and l.status='active' left join pipeline.sources s on s.id=l.source_id),
  c as materialized (
   select co.id, co.course_code code, co.course_url cu, d.official_course_url shown, d.course_id is not null hasdoc,
     (co.id in (select id from e16)) e16,
     (select count(*) from pipeline.manual_locks m where m.entity='course' and m.entity_id=co.id) locks,
     (select count(*) from pipeline.course_remediation_holds h where h.course_id=co.id and h.lifted_at is null) holds,
     (select count(*) from pipeline.layer4_review_items i where i.entity_type='course' and i.entity_id=co.id and i.field_code='official_course_url' and i.status='pending') l4p,
     (select count(*) from al where al.course_id=co.id) nact,
     (select count(*) from al where al.course_id=co.id and al.is_primary) nprim,
     (select count(*) from al where al.course_id=co.id and al.st='layer4_human_review') nrev,
     (select count(distinct nu) from al where al.course_id=co.id) ndist,
     (select max(yr)>min(yr) from al where al.course_id=co.id) oldyr,
     (select array_agg(al.id) from al where al.course_id=co.id and al.url=d.official_course_url) kept,
     (select bool_or(al.is_primary) from al where al.course_id=co.id and al.url=d.official_course_url) kprim,
     (select bool_or(al.url=co.course_url and al.id not in (select id from refused)) from al where al.course_id=co.id and al.url=d.official_course_url) kcheck,
     (select bool_or(al.is_primary or (al.url=co.course_url and al.id not in (select id from refused))) from al where al.course_id=co.id and al.url is distinct from d.official_course_url) other_valid
   from lk join catalogue.courses co on co.id=lk.course_id left join search.course_documents d on d.course_id=co.id),
  k as materialized (select c.*,
     case when e16 then 'x_e16' when locks>0 then 'x_locked' when holds>0 then 'x_hold' when l4p>0 then 'x_l4_pending'
          when not hasdoc or cardinality(coalesce(kept,'{}'))<>1 then 'x_no_shown_link'
          when not (nprim>=1 or (nrev>=1 and nprim=0) or ndist<nact or coalesce(oldyr,false)) then 'x_out_of_scope_h02_type'
          when coalesce(other_valid,false) then 'x_consumer_change'
          when coalesce(kprim,false) or coalesce(kcheck,false) then 'tranche'
          else 'x_kept_not_validated' end cat
   from c)
  insert into h01_t(half, course_id, code, shown, kept, kprim, superseded)
  select 'A', k.id, k.code, k.shown, k.kept[1], coalesce(k.kprim,false),
         array(select al.id from al where al.course_id=k.id and al.id<>k.kept[1] order by al.id::text) from k where k.cat='tranche';
  with e16 as materialized (select unnest(array['004b6c5c-4a6a-4b65-9f8d-1093049ea150','02c7bc01-0cc8-40bd-a190-b6eea143f3a5','0d25903f-de8e-460c-b403-2648148fcadd','111079e4-ca8d-4a72-bca1-145a141e201d','169b5258-0e1a-471a-807d-8473bdd0dcf2','196a1939-628d-4e86-8e4f-f40e0858be2e','19b048c5-3474-46d2-88a4-44b7c7eea8f5','1a8df22a-2739-4226-8856-10dd228e0033','1b78ba46-638c-4465-859e-8689e96295a8','1bfad09c-0734-4ef2-802a-52381c9d2ffa','20f2aa2c-1e7f-44c6-950c-47afa7881428','227e6abf-8897-4e35-9d6f-98de5c5a1160','264c5b84-eff8-49ac-b03f-c8cf12708198','26f9b73e-f6e3-41bc-8ff0-b7df8a2ef428','283a0dd2-0101-45c0-8a09-b0441f51d783','2bdf84a5-a806-469e-83a1-5e500559dfe4','2be0fafe-c403-495c-96bc-32b9f181a1a2','2cf5c4ac-b56d-44e2-b69e-93b6ce39a475','2d6d3d1c-8f6f-4455-8228-91d3f32ca491','33ded954-9998-43ff-9384-c3ca6788d54f','40afad92-5a55-47d8-88e3-2015c41d11af','4241f004-3144-4fd4-8468-960854850e38','43cb1105-82cd-4479-a1ed-48478514b94f','486ed99f-09f3-4ef5-9649-1dec1d9878d8','488f50c4-e7d3-4b21-a8a1-8ed95fcc0a03','4ad16106-b97b-44e6-b0bb-aa1ebd3b21aa','4e6f8c56-07cc-468b-97ff-5264276360ce','51b27099-8086-4c68-9b9f-04c74af883f6','5b6f8b6d-40c3-42ab-9d5a-52fb01f25c58','5cee7974-a3bf-416e-bd0e-a262bc56e955','60ebab30-d9a8-47f9-bf7f-85aebc49039f','670b7ce1-719e-4cdb-91e1-4111d0eba767','6b5874f1-770f-4000-9614-56a6df194724','6bad09d8-f8a1-45e9-9f1c-f8ba258d74d2','6d42acd7-35e9-4975-aa9f-2b7f400d341d','6f60c044-d710-420a-aed5-c6567c275f13','76339427-bad5-499f-94f0-3b158b6ff057','7cf958c9-c317-4a77-868c-3ba802174d1d','7e117900-eab0-4c4d-8104-11b9ffaf9b26','7f9cffdb-54ae-47e3-a595-edac98cd0dd6','87975d53-8b43-46c8-b209-9924fa43ea79','8a7a7b24-6ba1-4140-ac35-651552220afd','8b731ff6-2518-45a7-b73d-e6d03f22c405','8bdf836f-7de2-4570-be80-d87864c3e7e2','8c317304-0728-42ca-8e14-0b308a5ffbb2','8d1f1afd-96e1-44b3-bc61-a4dc42f54536','95fcd50f-257e-43d6-9920-f3599cacf374','98610bb2-1c02-49cf-a7ce-0d4ab8fc137f','9f50f886-8d83-40b9-8607-28a5d46b44a4','a0195518-e6a5-4663-88d4-677bd9c8d0b1','a021a3df-3ad0-43c1-a9b2-54d479473078','a940f900-bfa0-43a8-bba1-1e60c922a699','ad154e70-d0aa-45e8-a2f3-76f84d5c2902','b2226705-305a-4e88-9af5-fd8b404239c5','b444c1b8-9820-4cc9-a1b0-cb92beb56be1','b86828bb-9b14-46b4-a9bc-50a8de61fa39','ba8d7def-6f2e-48aa-a314-70603abe8d9c','bf8dd977-b939-4138-a6cc-744cd5e3dedf','cdc06d73-f08b-40fc-9d30-1700df678e62','d122606b-fe48-4a1a-b030-c9b84ea11ec1','d25f60bb-bd10-4956-8337-cdefdff8b1ce','d3443473-9636-4a37-a6ed-e531c863a101','d5e7c833-7912-4046-8b6a-da966520a7c4','d7d1890f-a7f0-44c0-b16a-97f9f7445be8','da0667c1-9818-4ab3-bbf7-c047f5de404d','dd5f7176-0ca9-462c-b399-4f05d06c5e67','de86b0d9-bb66-4a7d-8b05-ff1fa2c6d9cd','e1596a78-53ad-463f-bd1a-1442109c6ac3','e5822674-6fca-47a7-980f-dce5b054859d','ebfc236d-1c66-4f5b-bd4d-815ad7655e33','f0052042-998a-4f05-843f-467ff76a021c','f013a634-9344-4ae8-8ae6-07c2310b3e93','f5baa817-87a6-4f2d-a57f-a02b9e9dd90a','fa955ff0-37d1-4c91-826a-89c812cde021','fcde61b0-f5fe-4618-814c-a76a4b4d1dc7','fe4f81a5-9262-41f8-82c7-8fd2c1dee621','ff63eb8b-2705-4db7-8500-1db2c548216a']::uuid[]) id),
  refused as materialized (select unnest(array['34ebc7b9-24fb-4e7a-be05-6caafb0ecc58','66e8fa58-d631-453b-b99f-65e373c3bfe3','a20e2487-1ce1-4e23-95ba-a2eddb2174b3','14acba8a-8c29-48bc-a5d3-ef49ca5962bc','68aebf97-de88-4f37-ad76-7a9eb606595c','53d7e7c0-c852-4374-b36a-813316690a72','7f88ce4a-23a5-4bff-9a55-6294041a5e37','84955c3e-b359-4a0b-84e3-15101904e7a6','b85c3795-7c89-4fba-af9b-56f57084accb']::uuid[]) id),
  lk as materialized (select l.course_id from catalogue.course_links l
     where l.course_id >= '80000000-0000-0000-0000-000000000000'::uuid and l.course_id <= 'ffffffff-ffff-ffff-ffff-ffffffffffff'::uuid and l.link_type='official_course' and l.status='active'
     group by l.course_id having count(*)>1),
  al as materialized (select l.id, l.course_id, l.url, l.is_primary, s.source_type st, substring(l.url from '/(20[12][0-9])(/|$|\?)') yr,
       regexp_replace(regexp_replace(regexp_replace(lower(l.url),'^https?://(www\.)?',''),'[?#].*$',''),'/+$','') nu
     from lk join catalogue.course_links l on l.course_id=lk.course_id and l.link_type='official_course' and l.status='active' left join pipeline.sources s on s.id=l.source_id),
  c as materialized (
   select co.id, co.course_code code, co.course_url cu, d.official_course_url shown, d.course_id is not null hasdoc,
     (co.id in (select id from e16)) e16,
     (select count(*) from pipeline.manual_locks m where m.entity='course' and m.entity_id=co.id) locks,
     (select count(*) from pipeline.course_remediation_holds h where h.course_id=co.id and h.lifted_at is null) holds,
     (select count(*) from pipeline.layer4_review_items i where i.entity_type='course' and i.entity_id=co.id and i.field_code='official_course_url' and i.status='pending') l4p,
     (select count(*) from al where al.course_id=co.id) nact,
     (select count(*) from al where al.course_id=co.id and al.is_primary) nprim,
     (select count(*) from al where al.course_id=co.id and al.st='layer4_human_review') nrev,
     (select count(distinct nu) from al where al.course_id=co.id) ndist,
     (select max(yr)>min(yr) from al where al.course_id=co.id) oldyr,
     (select array_agg(al.id) from al where al.course_id=co.id and al.url=d.official_course_url) kept,
     (select bool_or(al.is_primary) from al where al.course_id=co.id and al.url=d.official_course_url) kprim,
     (select bool_or(al.url=co.course_url and al.id not in (select id from refused)) from al where al.course_id=co.id and al.url=d.official_course_url) kcheck,
     (select bool_or(al.is_primary or (al.url=co.course_url and al.id not in (select id from refused))) from al where al.course_id=co.id and al.url is distinct from d.official_course_url) other_valid
   from lk join catalogue.courses co on co.id=lk.course_id left join search.course_documents d on d.course_id=co.id),
  k as materialized (select c.*,
     case when e16 then 'x_e16' when locks>0 then 'x_locked' when holds>0 then 'x_hold' when l4p>0 then 'x_l4_pending'
          when not hasdoc or cardinality(coalesce(kept,'{}'))<>1 then 'x_no_shown_link'
          when not (nprim>=1 or (nrev>=1 and nprim=0) or ndist<nact or coalesce(oldyr,false)) then 'x_out_of_scope_h02_type'
          when coalesce(other_valid,false) then 'x_consumer_change'
          when coalesce(kprim,false) or coalesce(kcheck,false) then 'tranche'
          else 'x_kept_not_validated' end cat
   from c)
  insert into h01_t(half, course_id, code, shown, kept, kprim, superseded)
  select 'B', k.id, k.code, k.shown, k.kept[1], coalesce(k.kprim,false),
         array(select al.id from al where al.course_id=k.id and al.id<>k.kept[1] order by al.id::text) from k where k.cat='tranche';
  -- Guards: exactly the cohort measured on 2 Nov 12:06-12:07
  select count(*) into v_n from h01_t where half='A'; if v_n <> 52 then raise exception 'H01: half A tranche %, expected 52', v_n; end if;
  select count(*) into v_n from h01_t where half='B'; if v_n <> 49 then raise exception 'H01: half B tranche %, expected 49', v_n; end if;
  select md5(string_agg(course_id::text, ',' order by course_id::text)) into v_x from h01_t where half='A'; if v_x <> '05528955becdafe84abbb20005913b0a' then raise exception 'H01: half A course md5 %', v_x; end if;
  select md5(string_agg(course_id::text, ',' order by course_id::text)) into v_x from h01_t where half='B'; if v_x <> '1ddb5647e02d83ce4bfe436c87af545f' then raise exception 'H01: half B course md5 %', v_x; end if;
  select md5(string_agg(kept::text, ',' order by kept::text)) into v_x from h01_t where half='A'; if v_x <> 'eb9fb756b269f262be52814e264c5398' then raise exception 'H01: half A kept md5 %', v_x; end if;
  select md5(string_agg(kept::text, ',' order by kept::text)) into v_x from h01_t where half='B'; if v_x <> '8eb8523dbe65c49ccfae42b22bcd78aa' then raise exception 'H01: half B kept md5 %', v_x; end if;
  select md5(string_agg(s::text, ',' order by s::text)), count(*) into v_x, v_n from h01_t, unnest(superseded) s where half='A';
  if v_x <> '15c6b04522c9fc2f4d0e9cc68cc3c0d2' or v_n <> 53 then raise exception 'H01: half A superseded % / %', v_n, v_x; end if;
  select md5(string_agg(s::text, ',' order by s::text)), count(*) into v_x, v_n from h01_t, unnest(superseded) s where half='B';
  if v_x <> 'c4e99f89175ade771b7c6850e7e04616' or v_n <> 59 then raise exception 'H01: half B superseded % / %', v_n, v_x; end if;
  select count(*) into v_n from h01_t where not kprim; if v_n <> 83 then raise exception 'H01: % kept links to make primary, expected 83', v_n; end if;
  select count(*) into v_n from catalogue.course_links l join h01_t t on l.id = any(t.superseded) where l.is_primary or l.status <> 'active';
  if v_n <> 0 then raise exception 'H01: % superseded links are primary or not active', v_n; end if;

  -- 1. superseded duplicates -> inactive (kept as history)
  update catalogue.course_links l set status = 'inactive', is_primary = false, updated_at = now()
    from h01_t t where l.id = any(t.superseded) and l.status = 'active' and not l.is_primary;
  get diagnostics v_n = row_count; if v_n <> 112 then raise exception 'H01: made % links inactive, expected 112', v_n; end if;
  -- 2. kept link -> primary (the projection already shows it)
  update catalogue.course_links l set is_primary = true, updated_at = now()
    from h01_t t where l.id = t.kept and not t.kprim and l.status = 'active' and not l.is_primary;
  get diagnostics v_n = row_count; if v_n <> 83 then raise exception 'H01: made % links primary, expected 83', v_n; end if;
  -- 3. rebuild the projection for the 101 courses and prove the consumer value did not change
  select array_agg(course_id) into v_c from h01_t;
  perform search.refresh_course_enrichment_scoped_v1(v_c, true);
  select count(*) into v_n from h01_t t left join search.course_documents d on d.course_id = t.course_id where d.official_course_url is distinct from t.shown;
  if v_n <> 0 then raise exception 'H01: % shown URLs changed after the refresh; consumer-visible change, rolled back', v_n; end if;
  select count(*) into v_n from h01_t t where (select count(*) from catalogue.course_links l where l.course_id = t.course_id and l.link_type = 'official_course' and l.status = 'active') <> 1
     or not exists (select 1 from catalogue.course_links l where l.id = t.kept and l.status = 'active' and l.is_primary);
  if v_n <> 0 then raise exception 'H01: % courses do not end with exactly one active, primary kept link', v_n; end if;

  insert into pipeline.admin_control_events(area, action, target, detail, actor)
  select 'housekeeping', 'h01_duplicate_link_tranche', 'catalogue.course_links',
         jsonb_build_object('courses', count(*), 'made_inactive', (select jsonb_agg(s) from h01_t, unnest(superseded) s),
                            'made_primary', jsonb_agg(kept) filter (where not kprim), 'kept_already_primary', jsonb_agg(kept) filter (where kprim),
                            'course_ids', jsonb_agg(course_id), 'consumer_values_changed', 0,
                            'authority', 'Platform Admin decision pack 2 Nov 2026 10:56, Decision 6 (H01/H03/H04/H09)'), null
    from h01_t;
end $h01$;

-- Read-back inside the transaction (expect: 101 courses, 101 active links, 101 primary, 101 shown = active link; 112 inactive superseded):
select count(distinct l.course_id) courses, count(*) filter (where l.status='active') active_links, count(*) filter (where l.status='active' and l.is_primary) primary_links,
       count(*) filter (where l.status='active' and l.url = d.official_course_url) shown_equals_active, count(*) filter (where l.status='inactive') inactive_links
  from pipeline.admin_control_events e cross join lateral jsonb_array_elements_text(e.detail->'course_ids') cid
  join catalogue.course_links l on l.course_id = cid::uuid and l.link_type = 'official_course'
  left join search.course_documents d on d.course_id = l.course_id
 where e.action = 'h01_duplicate_link_tranche';
-- NOTE: "inactive_links" also counts any link that was already inactive before today on these courses; the guard above is the exact 112.
-- If anything is not as expected: rollback;   otherwise: commit;

-- ===== ROLLBACK after commit (restores the 2 Nov 12:07 state; run as one transaction; the audit event holds the ids) =====
-- begin;
-- select count(*) from pipeline.admin_control_events where action = 'h01_duplicate_link_tranche';  -- must be 1
-- update catalogue.course_links set is_primary = false, updated_at = now()
--  where id in (select jsonb_array_elements_text(detail->'made_primary')::uuid from pipeline.admin_control_events where action = 'h01_duplicate_link_tranche') and is_primary;  -- expect 83
-- update catalogue.course_links set status = 'active', updated_at = now()
--  where id in (select jsonb_array_elements_text(detail->'made_inactive')::uuid from pipeline.admin_control_events where action = 'h01_duplicate_link_tranche') and status = 'inactive';  -- expect 112
-- select search.refresh_course_enrichment_scoped_v1(array(select jsonb_array_elements_text(detail->'course_ids')::uuid from pipeline.admin_control_events where action = 'h01_duplicate_link_tranche'), true);
-- (security.no_page_reopen_link_trg_v1 may refuse to re-activate a link whose page has since been rejected; that row then stays inactive, which is the safer state.)
-- commit;
