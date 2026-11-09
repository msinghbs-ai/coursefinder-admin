-- PASTE FILE — UNSW Sydney: withdraw the English values written from the UNSW Bengaluru (India campus) page (CF-247)
-- For: Platform Admin, to apply in the Supabase SQL editor of project fxcwkweaxjtknorudmwp (NOT coursefinder-demo). Never applied by the agent.
-- Mandate: Platform Admin 27 Oct 2026 08:15, item 6 ("Prepare one count-guarded supersession/withdrawal paste ... return it for explicit authority").
-- Record: admin docs/platform/ui-audit/2026-10-27-mandate-0815-response.md.
--
-- Background: English policy proposal b75bcad5 (approved 2 Oct 2026, no decision note) reads
-- https://www.unsw.edu.au/bengaluru/study-with-us/english-language-requirements, the India-campus page (IELTS 6.0 overall, 5.5 each; TOEFL iBT 79;
-- PTE 50; C1 Advanced 169, for undergraduate and postgraduate). The Platform Admin rejected a later reading of the SAME page (proposal 032db5f6,
-- same URL and content hash) on 17 Oct 2026: "India campus page, not the Sydney policy". The 2 Oct approval was contained on 27 Oct 08:18
-- (status superseded, event 21722), so it writes nothing new; the values it had written are still live.
-- Audit (27 Oct, live): 422 active UNSW Sydney courses (all open to international students; 241 undergraduate, 181 postgraduate coursework)
-- hold 1,688 active rows from it (IELTS 6.0 x422, TOEFL iBT, PTE, C1 Advanced), and no English row from any other source.
-- The current UNSW Sydney page (https://www.unsw.edu.au/study/how-to-apply/english-language-requirements, read 27 Oct) sets IELTS Academic by
-- faculty and level: 6.5 overall (6.0 each) at the lowest, 7.0 for Business and Law & Justice, higher for named programs. No UNSW Sydney
-- faculty or level asks for 6.0. Independently confirmed by the correct source: 0 of 422. Supported only by the India-campus page: 422 of 422.
--
-- What it does (one transaction; raises and changes nothing if the live state differs):
--   guard 1  proposal b75bcad5 is 'superseded' (the containment) and its URL is the Bengaluru page;
--   guard 2  exactly 422 active courses hold active rows from it (course-list md5 39f816cd…) and exactly 1,688 active rows (row-list md5 d1203628…);
--   act      the 1,688 rows become 'withdrawn' (kept, not deleted), each with a note; the 422 courses' search projection is refreshed;
--   guard 3  1,688 rows withdrawn; 0 active rows left from proposal b75bcad5;
--   log      one admin_control_events row.
-- Before/after: UNSW Sydney English admitted 431 -> 9 of 667 active courses; AU English admitted 16,917 -> 16,495 (of 26,103), from the next
--   hourly coverage build. Consumer API: no shape change; the 422 courses' English requirement becomes null ("not held") until a correct source
--   fills it (the course-page reader, or a Platform Admin decision on a faculty-level UNSW Sydney policy).
-- Undo: the rows can be set back to 'active' by their ids (kept), if the Platform Admin decides so.

begin;

do $paste$
declare v_n int; v_h text; v_r int; v_rh text; v_ids uuid[];
begin
  if not exists (select 1 from pipeline.provider_policy_proposals where id = 'b75bcad5-8dd0-4263-9134-f8b4ab7defc9' and status = 'superseded'
                   and url = 'https://www.unsw.edu.au/bengaluru/study-with-us/english-language-requirements') then
    raise exception 'guard 1: proposal b75bcad5 is not the contained (superseded) Bengaluru policy; nothing changed';
  end if;
  select count(*), md5(string_agg(course_id::text, ',' order by course_id)) into v_n, v_h from (
    select distinct cr.course_id from catalogue.course_english_requirements cr join catalogue.courses c on c.id = cr.course_id
     where cr.source_requirement_key like 'policy:b75bcad5-8dd0-4263-9134-f8b4ab7defc9:%' and cr.status = 'active' and c.lifecycle_status = 'active') d;
  select count(*), md5(string_agg(id::text, ',' order by id)) into v_r, v_rh from catalogue.course_english_requirements
   where source_requirement_key like 'policy:b75bcad5-8dd0-4263-9134-f8b4ab7defc9:%' and status = 'active';
  if v_n <> 422 or v_h <> '39f816cdced13612882d9a01b438edd9' or v_r <> 1688 or v_rh <> 'd12036287031dd07aaf66b68645e253a' then
    raise exception 'guard 2: % courses (md5 %) and % rows (md5 %), expected 422 (39f816cd…) and 1688 (d1203628…); nothing changed. Ask the agent to regenerate.', v_n, v_h, v_r, v_rh;
  end if;

  with w as (
    update catalogue.course_english_requirements e set status = 'withdrawn', last_verified_at = now(),
           notes = coalesce(e.notes, '') || ' Withdrawn 27 Oct 2026 (Platform Admin paste): written from the UNSW Bengaluru (India campus) page, not UNSW Sydney evidence; UNSW Sydney requires at least IELTS 6.5 overall.'
     where e.source_requirement_key like 'policy:b75bcad5-8dd0-4263-9134-f8b4ab7defc9:%' and e.status = 'active'
    returning e.course_id)
  select count(*), array_agg(distinct course_id) into v_r, v_ids from w;
  if v_r <> 1688 or cardinality(v_ids) <> 422 then raise exception 'guard 3: withdrew % rows on % courses, expected 1688 on 422; rolled back', v_r, cardinality(v_ids); end if;
  if exists (select 1 from catalogue.course_english_requirements where source_requirement_key like 'policy:b75bcad5-8dd0-4263-9134-f8b4ab7defc9:%' and status = 'active') then
    raise exception 'guard 3: active rows from b75bcad5 remain; rolled back';
  end if;

  perform search.refresh_course_enrichment_scoped_v1(v_ids, true);
  update pipeline.provider_policy_proposals set apply_summary = coalesce(apply_summary, '{}'::jsonb) || jsonb_build_object('withdrawn_rows', 1688, 'withdrawn_courses', 422, 'withdrawn_at', now()), updated_at = now()
   where id = 'b75bcad5-8dd0-4263-9134-f8b4ab7defc9';
  insert into pipeline.admin_control_events(area, action, target, detail, actor)
  values ('policies', 'withdraw_paste', 'english_policy: https://www.unsw.edu.au/bengaluru/study-with-us/english-language-requirements',
          jsonb_build_object('proposal_id', 'b75bcad5-8dd0-4263-9134-f8b4ab7defc9', 'courses', 422, 'rows', 1688, 'course_list_md5', '39f816cdced13612882d9a01b438edd9',
                             'row_list_md5', 'd12036287031dd07aaf66b68645e253a', 'reason', 'Platform Admin: India-campus page is not UNSW Sydney English evidence (17 Oct rejection of the same page)'),
          '63ba56cb-48d4-4169-98c2-7c4d1f72925b'::uuid);
  raise notice 'withdrew 1688 rows on 422 courses';
end $paste$;

commit;
