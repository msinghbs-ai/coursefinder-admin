# StudySearch consolidated decision pack (31 Oct 2026, afternoon)

**Prepared by:** Claude, under the Executive Execution Mandate (31 Oct 2026 12:38).
**Evidence:** `2026-10-31-studysearch-transformation.md` §18 to §21. **Register:** `../STUDYSEARCH-EXECUTION-REGISTER.md`.
**Rule:** each item states what is already approved and the one new authority needed. Nothing below has been executed.

## Summary

| # | Task | New authority requested | Recommendation | Consumer impact |
|---|---|---|---|---|
| D1 | SS-007 batch A | Run the prepared correction of 177 bindings (167 wrong official links become null) | Approve | Data only; no API change |
| D2 | SS-007 batch B | Decide 125 school and ELICOS-level bindings | Keep them (reclassify as genuine shared pages) | None if kept |
| D3 | SS-008 | Retire Rule 4 (low agreement, page wins) | Retire | None |
| D4 | SS-009 | Add `entry.min_scores[]` (additive) | Approve, as specified in §16.1 | Additive field; guide issue 7 |
| D5 | SS-010 | (a) Hold futile enrichment re-queues; (b) re-queue 67 withdrawn values that now have a proven page | Approve both | None directly |
| D6 | SS-011 → SS-012 | Output-identical speed-up of two consumer search functions | Approve the build and proof; release after a second look | None intended (byte-identical proof) |

---

## D1. SS-007 batch A: correct 177 bindings on shared fee, application and course-list pages

- **Already approved:**
  - Option 2 with controls (11:53);
  - Option C, plus building the hold, tests, dry runs and change control (12:38).
- **Built and live in v2.15.379:**
  - **the hold:** one table, enforced through the existing binding guard, the one search stop gate, AI match preparation and the link-search send path;
  - **the correction function:** Platform Admin only, per provider, count-guarded and reversible.
- **Per-binding verification (source evidence, not the URL alone):**
  - each of the 29 pages is shared by 3 to 36 different qualifications;
  - almost all were bound by a search that found the course's CRICOS code (or title) printed on a fee table, application form or course list;
  - for each page, the HTTP status, whether a stored copy exists and the set of courses bound to it were checked (record §18.2).
- **Dry run (live, rolled back):**
  - 177 re-roled in 0.4 s, 0 held back;
  - all five lanes refuse the held courses;
  - 167 published links → 0;
  - one course restored exactly.
- **New authority requested:** run `docs/platform/pastes/PASTE-20261031-ss007-batch-a-re-role.sql` (25 blocks, one per provider). I will run it block by block after approval, verify each batch, and stop on any unexpected change.
- **Guide line:** the Platform Admin's 15 Oct rule keeps data corrections out of developer guide §13. The handover note is the developer notice.
  - **Recommendation:** no guide reissue.
  - **If you want a guide line anyway,** a proposed one is in the handover note §3.
- **Handover:** `docs/integrations/handover/2026-10-31-SS-007-official-link-corrections-HANDOVER.md`, with the course list CSV.
- **Risk:** low.
  - Every course can be restored.
  - Job `course-url-fill`'s 30-day take-back rate rises to about 4.1% (stop at 5%). Measured in the dry run: 862 of 21,012.

## D2. SS-007 batch B: 125 bindings on school international pages and ELICOS level pages

- **What they are:**
  - 114 courses at 36 schools: year-level courses such as "Junior Secondary 7–10" on the school's international students page;
  - 11 courses on two ELICOS pages that describe every level of one programme (MEI General English I–V and EAP I–III; Greenwich Cambridge preparation).
- **Why they are held, not changed:**
  - a school publishes one international page for all its CRICOS courses, so there is no better official page to find;
  - the ELICOS pages are the programme's own page.
  - Re-roling would remove 115 links that are probably the best available, so these bindings are "uncertain" under your 11:53 control.
- **Recommendation:** keep them as genuine shared pages; there is no change and no consumer impact.
- **Alternatives:**
  - re-role them as for D1 (115 links become null);
  - a person reviews them school by school.

## D3. SS-008: Rule 4 (low agreement, page wins)

- **Already approved:** keep paused (11:28); paused in v2.15.378.
- **Evidence (record §14):**
  - across all 1,185 adapters it would admit 1 field today;
  - it has made 22 admissions ever, and none since 24 Oct;
  - it failed daily at its time limit.
- **New authority requested:** retire it.
  - Mark job and function `retiring` in the component register.
  - Unschedule the job by paste after the 14-day retirement window.
- **Recommendation:** retire. The value is negligible, and a low-agreement field belongs in Layer 4 review rather than automatic admission.

## D4. SS-009: multiple entry scores

- **Already approved:** review first, no field yet (11:28). The review is done (record §16, §16.1).
- **New authority requested:** add the additive field `entry.min_scores[]` (items: score, basis, audience, quote, as_at), with `min_score` unchanged. It ships with developer guide issue 7, a version line, the compatibility assessment and a handover note.
  - **Prerequisite in the same change:** fix the weak and duplicate rows found in the review.
- **Recommendation:** approve. All 24 affected courses (Monash) hold genuine alternative routes, and today `min_score` shows one of them at random.

## D5. SS-010: enrichment recovery

- **Measured (live, 31 Oct):**
  - Enrich still skips 1,648 (30 Oct) and 2,204 (29 Oct) items a day as "no correct course page". These are re-queues of courses whose page is a mismatch. They cost $0 but hide the real constraint.
  - Of the 2,023 course-fields withdrawn on 23 Oct "to be read again":
    - 110 refilled;
    - 67 now have a proven page with a stored copy;
    - 665 have a bound page with no copy (a paid read, held);
    - 846 have no bound page.
- **New authority requested:**
  - **(a)** Extend `security.enrich_item_held_v1` so a course is held out of the gap queue while its page is `mismatch`. This tightens an enrichment hold, so it is a hold change and needs your approval.
  - **(b)** Re-queue exactly the 67 ready course-fields once. This is AI enrichment, estimated under US$1, count-guarded.
- **Not requested:** the 665 paid reads and the 846 searches. They wait for the SS-007 verification-read decision.

## D6. SS-011: website search speed

- **Measured (14 days, `pipeline.api_requests`, excluding 24 to 26 Oct):**

| Search request | Requests | p50 | p95 |
|---|---:|---:|---:|
| 50 items | 24,869 | 3.1 s | 6.9 s |
| 1 to 20 items | 597 | 0.8 s | 4.8 s |

  - First request after 10 minutes idle: p50 4.5 s.
- **In the database (31 Oct):**
  - a broad 50-item search took 2.2 s, a 20-item search 1.6 s and a 1-item search 1.1 s;
  - building each item costs about 11 to 22 ms;
  - the course display code is computed 3 times per item, and the published check runs once per item (about 2 ms each);
  - the base query sorts and counts every matching document on each request (0.4 to 1.1 s).
- **Cross-region round trips:** at most about 90 ms each, so a minor part.
- **Root cause:** the website asks for 50 items per page, and both the item builder and the full sort and count scale with that.
- **Options:**
  1. **Ask the website to request 20 items per page.** About 1.5 s faster at the median, with no platform change; it is the website team's choice.
  2. **Output-identical refactor of `public.website_v2_course_search` and `api.website_v2_course_item`:**
     - compute the display code once;
     - check publication once per page;
     - count without sorting every row.
     - **Estimate:** 30 to 45% less database time per page.
     - These are frozen consumer API functions, so this needs your approval, a byte-identical before/after proof over a fixed sample, re-baselining and a handover note (no API change).
- **New authority requested:** approve building option 2 with its proof. Release comes back to you with the proof.
- **Recommendation:** do both options.
