-- PASTE FILE (PROPOSAL) — RMIT UP: close 23 duplicate scholarship reviews whose pages belong to RMIT University (CF-247)
-- For: Platform Admin. NOT applied by the agent; returned for a separate provider-binding decision (mandate 27 Oct 2026 12:27, item 4).
-- Record: admin docs/platform/reports/2026-10-27/RMIT-UP-scholarship-binding-proposal.md.
--
-- Finding (live, 27 Oct 12:4x, read only):
--   * RMIT University (CRICOS 00122A, www.rmit.edu.au, 507 active courses, 315 scholarships, 47 published) and RMIT University Pathways / RMIT UP
--     (CRICOS 01912G, www.rmit.edu.au/up, 3 active courses, 0 scholarships) are separate registered providers.
--   * RMIT UP holds 402 scholarship page candidates, all found by one sitemap run on 2 Oct, none under /up; 401 are the same pages as RMIT
--     University's 407 candidates. All 402 are admit_status 'rejected'; RMIT UP has 0 scholarships, so nothing is consumer-facing twice today.
--   * The 23 pending RMIT UP reviews are all rmit.edu.au/scholarships pages already handled under RMIT University:
--       17 refused under RMIT (26 Oct night triage or 24 Oct), 1 admitted under RMIT (1570 <-> 1967, the published Vietnam PhD, School of SET),
--       1 still pending under RMIT (1576 <-> 1965, Australia Awards, approved pending technical resolution),
--       2 whose RMIT candidate was withdrawn (1592 ARC CoE COMBS: international not stated; 1631 H&H Group Indigenous: domestic only),
--       2 whose RMIT candidate is a 'duplicate' of a scholarship RMIT already holds (1605 RMIT PhD Scholarship in Vietnam; 1613 RMIT Vietnam
--       PhD Scholarship (STEM)).
--   * Admitting any of the 23 under RMIT UP would create a second scholarship for the same page under the pathways provider (and its 3 courses).
-- Recommendation: retain the RMIT University decisions as the only ones; close the 23 RMIT UP reviews as 'superseded' (existing status), each
-- noting its RMIT counterpart. No provider change, no merge, no transfer, no AI or Firecrawl spend, nothing deleted. Review 1965 is untouched.
-- Guards: exactly these 23 reviews are pending under RMIT UP, each with the RMIT counterpart state listed; 23 closed; event logged.
begin;
do $paste$
declare v_n int;
begin
  create temporary table _m(up_review int, rmit_ref text, rmit_state text) on commit drop;
  insert into _m values
    (1636,'review 1969','refused'),(1627,'review 1816','refused'),(1641,'review 1809','refused'),(1623,'review 1968','refused'),
    (1622,'review 1959','refused'),(1610,'review 1320','refused'),(1603,'review 1317','refused'),(1612,'review 1318','refused'),
    (1437,'review 1802','refused'),(1579,'review 1314','refused'),(1502,'review 1298','refused'),(1590,'review 2027','refused'),
    (1609,'review 1369','refused'),(1611,'review 1297','refused'),(1453,'review 1310','refused'),(1591,'review 1786','refused'),
    (1368,'review 1955','refused'),(1570,'review 1967','admitted'),(1576,'review 1965','pending'),
    (1592,'candidate 140','withdrawn'),(1631,'candidate 254','withdrawn'),(1605,'candidate 32','duplicate'),(1613,'candidate 44','duplicate');
  select count(*) into v_n from _m join pipeline.scholarship_ai_reviews r on r.id = _m.up_review
   where r.provider_id = '30b81368-9003-4775-81af-60439fc3b109' and r.status = 'pending';
  if v_n <> 23 then raise exception 'guard 1: % of 23 RMIT UP reviews still pending; nothing changed', v_n; end if;
  if (select count(*) from pipeline.scholarship_ai_reviews where provider_id = '30b81368-9003-4775-81af-60439fc3b109' and status = 'pending') <> 23 then
    raise exception 'guard 1: RMIT UP pending reviews changed; nothing changed';
  end if;
  select count(*) into v_n from _m join pipeline.scholarship_ai_reviews r on _m.rmit_ref = 'review ' || r.id
   where r.provider_id = '8e1adb6c-e069-43db-9584-bd054255e702' and r.status = _m.rmit_state;
  select v_n + count(*) into v_n from _m join pipeline.scholarship_page_candidates c on _m.rmit_ref = 'candidate ' || c.id
   where c.provider_id = '8e1adb6c-e069-43db-9584-bd054255e702' and c.admit_status = _m.rmit_state;
  if v_n <> 23 then raise exception 'guard 2: % of 23 RMIT counterparts in the listed state; nothing changed', v_n; end if;

  update pipeline.scholarship_ai_reviews r set status = 'superseded', decided_at = now(),
         note = coalesce(r.note || ' | ', '') || format('Closed 27 Oct 2026 (Platform Admin paste): RMIT University page reviewed under RMIT University (%s, %s); RMIT UP binding came from a shared-host sitemap.', _m.rmit_ref, _m.rmit_state)
    from _m where r.id = _m.up_review and r.status = 'pending';
  get diagnostics v_n = row_count; if v_n <> 23 then raise exception 'guard 3: closed %, expected 23; rolled back', v_n; end if;

  insert into pipeline.admin_control_events(area, action, target, detail, actor)
  values ('scholarship_ai', 'close_duplicates_paste', 'RMIT UP (30b81368) scholarship reviews',
          jsonb_build_object('closed', 23, 'kept_under', 'RMIT University 8e1adb6c', 'review_1965', 'untouched',
                             'reason', 'Platform Admin decision on the 27 Oct provider-binding proposal'), '63ba56cb-48d4-4169-98c2-7c4d1f72925b');
end $paste$;
commit;
