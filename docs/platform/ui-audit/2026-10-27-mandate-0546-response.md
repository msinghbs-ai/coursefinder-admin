# Response record: Platform Admin mandate of 27 Oct 2026 05:46

"Close the AER defects, then recover AU coverage by cause". This is the one dated record for this mandate. Evidence for each part is kept in the existing lane records:
- `docs/platform/aer-v1.1-build-log.md` and the CF-247 change-control set (AER);
- `docs/platform/ui-audit/2026-10-26-au-wave-checkins.md` (check-ins);
- `docs/platform/ui-audit/2026-10-25-standing-rules-and-merges.md` (merges).

All times are AEDT and are the actual event times.

## Workstream 1: AER (closed under this mandate)

| Step | Result |
|---|---|
| D5 (#713) | Merged 06:24:57 and verified (worker 213). Checkpoint 1 sent |
| D4 (#714) | Merged 06:49:32 and verified (worker 214; release currentness `ba1cce46` passed) |
| Controlled recovery | 06:54–06:57. D3 re-read Kuwait, Mexico, Denmark and Colombia. The queued runs and Qatar were read. The 12 complete pages were not re-read, and the 3 D2 pages stayed terminal. Cost at most US$0.157 |
| Outcome (36 pages) | 25 complete in review, 3 non-country terminal, 0 legitimate source hold, 8 still defective with a named reason, 1 not read (Qatar). 363 proposed rows with 363 identities; 0 duplicates, 0 active, 0 silent partial reads |
| Stop | New defect classes found: G1 guard column tie, P2 repeated header row and R2 bare-number scale. D4 also did not resolve Nigeria or Vietnam. No D6+ was started. RMIT has been out of scope since 07:02:15, and `entry-matrix-read` has been back on for UTS and WSU since 07:02:22. AER expansion is frozen |
| Checkpoint 2 | Sent 06:59 |

The exit condition ("no unexplained parser/reader hold") is **not met**. The 8 remaining holds are explained and named, but not fixed. Fixing them needs a new Platform Admin decision.

## Workstream 2: AU measurement and source recovery

### Priority 1A: intakes, 9,987 → 9,391 (all 596 explained)

Workbook: `docs/platform/reports/2026-10-27/AU-intakes-596-reconciliation-2026-10-27.xlsx` (one row per course, plus a by-provider sheet).

| Movement, 20 Oct → 26 Oct | Courses | Writer and reason |
|---|---|---|
| Lost | 868 − x | Calendar-derived intake rows withdrawn by migration `20261022042000_cf247_intakes_page_only` (event 20396, 22 Oct 22:50 AEDT), carrying out the Platform Admin decision "Page-only months, no API change". 841 courses lost `calendar_default` rows and 27 lost semester `calendar` rows. Nothing on their course pages replaced them. Spread over 44 providers; the largest are Sydney 105, TAFE NSW 100, Flinders 72, Wollongong 60 and WSU 60 |
| Withdrawn but kept | 59 + 8 | Refilled from their own pages by the AI reader (59), or kept a page row (8) |
| Gained | 248 + (24 − x) | 23 new page or adapter rows and 225 AI-reader rows from course pages |
| **Net** | **−596** | Exact. x is between 0 and 24: 24 calendar-only courses got rows on 21 Oct, and `course_intakes` has no timestamps to tell them apart |

- Checked live:
  - the daily series (9,285 → 9,987 on 18 Oct → 10,015 → 9,097 → 9,391);
  - 868 AU courses with a withdrawn calendar row and no active row;
  - 67 with both;
  - event 20396.
- Retirement, re-yearing, reclassification, identity refusal and defective writes each account for 0.
- **Verdict:** supersession by a deliberate policy change, not a writer defect, so there is no PR.
- The withdrawn values are not legitimate under the page-only rule, so nothing is restored through the admission path. The 9,987 figure was itself inflated by about 900 calendar-default courses; the like-for-like page-only baseline on 20 Oct is about 9,084, so page-only intakes **grew by about 307**.
- **Governance gap:** `catalogue.course_intakes` has no insert time or writer column.

### Priority 1B: delivery, 72.6% → 63.5% (baseline verified; the fall is real)

| Date | Numerator | Denominator | % |
|---|---|---|---|
| 20 Oct (first delivery snapshot) | 18,960 | 26,103 | 72.6 |
| 22 Oct | 19,067 | 26,103 | 73.0 |
| 23 Oct | 16,562 | 26,103 | 63.4 |
| 26 Oct | 16,574 | 26,103 | 63.5 |

- **Lineage:**
  - The 19 Oct row is missing only because delivery was added to the coverage build by `20261021110000`; its first snapshot is 20 Oct.
  - Same definition (`courses.delivery_mode` not blank) and same denominator on both dates.
  - **Not a history or attribute defect.**
- **The fall is a genuine, deliberate take-back.** On 23 Oct, 2,590 values the AI reader had read from another course's page were cleared on Platform Admin instruction (`20261023017000`, `20261023019000`). 2,518 are still blank.
- **Where the 2,518 stand now:**

| Group | Courses |
|---|---|
| On a page now marked as another course's (mismatch) | 1,686 |
| Bound page, but "no allowed source had a value" (the page's identity proof is not accepted for delivery) | 821 |
| Page does not state it | 11 |

  796 of the 2,518 belong to unpublished providers, so they wait for the publish paste.

### Priority 2A: morning pastes (Platform Admin gate)

Checked once at 07:05. All three are **pending**; their guards were still valid at that time:
1. Retirements: run b8a541af departures are still held; 0 retired.
2. Publish: 1,056 providers are still eligible and unpublished.
3. Fee re-apply: not applied. Its own guard 1 stops it unchanged if any of the 372 pairs has moved.

They are not polled again.

### Priority 2B: fee residue

| Item | Outcome | Owner |
|---|---|---|
| 68 older `found` fee-schedule rows | Triaged. All 68 belong to unpublished providers (590 active courses) and were added by hand on 11–19 Oct. The reader skips hidden providers by design (`svc_provider_facts_read_next`), so none is stuck | **Platform Admin (publish paste)** |
| 1 fee-reader item at its attempt limit | **Settled** to failed at 07:02:04 (event 21715). It was Nexus Institute, Bachelor of IT (Software Development), and the course already has admitted provider tuition, so no value was lost. Cause: `svc_fee_ai_next` never settles an expired lease at the limit. The cause is named; no code change under this mandate | Cleared |
| 284-page wave | **Reconciled:** 284 = 12 parsed + 155 no values + 110 `target_list_refused` + 7 no content. All 167 read pages went through the AI fee reader (US$0.60): 44 gave 1,086 rows. 121 courses were admitted, 104 sent to Layer 4 review, 24 matched an existing value, 5 conflicted, 29 were not yearly, 85 were domestic-only and 84 rows had no matching course | Cleared. The 104 review items are with a person in Layer 4 |
| 110 `target_list_refused` | **Proposal prepared, not applied.** `docs/platform/reports/2026-10-27/AU-fee-target-list-proposal-2026-10-27.xlsx` and `docs/platform/pastes/PASTE-20261027-fee-target-list-proposal.sql`: 42 providers, 54 HTML tuition pages, 400 courses without provider tuition. About 54 Firecrawl credits (at most 162) and about US$0.20 of AI reading. Excluded: 22 PDFs, 33 pages that are not tuition schedules, 1 duplicate. Count guards checked live at 07:1x (0 existing target rows; 54 pages). **Risk:** the target list is per provider, so these providers also become eligible for other Firecrawl lanes | **Platform Admin decision** |

### Priority 3: source inventories for Sydney, UNSW, Macquarie, ANU and Melbourne (done)

Files: `docs/platform/reports/2026-10-27/AU-top5-source-inventories.xlsx` and `.md`. These follow the 26 Oct report format: a Read me, provider summary, one detail sheet per provider and 21 ranked actions. Read only. The main figures were spot-checked live at 07:3x: fee, intakes and English counts per provider, and the UNSW English approval history.

| Out of active courses | Sydney 655 | UNSW 667 | Macquarie 461 | ANU 423 | Melbourne 441 |
|---|---|---|---|---|---|
| Official page in place | 402 | 467 | 272 | 421 | 386 |
| Page address dead / page is another course's | 155 / 21 | 84 / 79 | 138 / 35 | 0 / 2 | 2 / 33 |
| International fee admitted | 0 | 298 | 0 | 365 | 323 |
| English (from central policy) | 613 (608) | 431 (422) | 371 (112) | 400 (400) | 281 (124) |
| Intakes | 70 | 465 | 93 | 21 | 182 |
| Delivery | 374 | 470 | 111 | 401 | 383 |
| Entry-requirements sources (HTML/PDF) | none registered | none | none | none | none |

**Ranked actions (top six, by recoverable courses and evidence quality):**
1. **Sydney, 246 postgraduate and research courses: calendar months.**
   - Gate: Platform Admin. It reverses the 19 Oct "Undergraduate only" rule and makes an exception to the 22 Oct page-only rule.
   - The evidence is an own-domain page with dated quotes, but it gives semester dates, not level-specific starts.
2. **Melbourne, 188 courses:** the same action, gate and caveat.
3. **Sydney, 91 undergraduate courses with a page:** calendar months. Gate: a Platform Admin exception to the 22 Oct rule.
4. **Macquarie, 90 courses held by the English plan:** 76 of them are double degrees. Gate: a Platform Admin decision on the plan rule.
5. **Sydney, 62 pages need a rendered read:** this uses the existing "Read pages again" job, which a Platform Admin starts.
6. **ANU, 45 courses:** Layer 4 review of values already read from the course's own page.

**Quality risk found:**
- UNSW's approved central English source (2 Oct, IELTS 6.0, used by 422 courses) is the **UNSW Bengaluru (India campus)** page. On 17 Oct a later reading of that same page was rejected as "India campus page, not the Sydney policy", but the 2 Oct approval is still in force.
- This is for a Platform Admin decision. It is not counted as recovery.

**Other findings:**
- 448 of the courses with no usable page have already been finished "no page" by the re-link lane, so no existing lane has more to try for them.
- 19 English and intake items are still marked as waiting for Layer 3, which was retired on 15 Oct. They will not move by themselves.
- Only Melbourne's fee table carries a course matching key (CRICOS code). Sydney's and UNSW's fee pages can only be matched by title. Sydney's 26 Oct read gave 41 rows whose quotes were not found on the page.

### Priority 4: recovery through existing lanes

| Lane | State | Gate |
|---|---|---|
| Tuition | Fee re-apply paste: +79 courses get a fee, plus 57 duplicates and 236 rows for another year. Target-list proposal: up to 400 courses. 104 fee items from the 26 Oct wave are in Layer 4 | Platform Admin (paste, proposal); a person (Layer 4) |
| Intakes | Regression resolved (above). Calendar MARK-FILEs are unmarked: the top-20 file covers 429 undergraduate courses under rule (b) and 1,291 postgraduate under rule (c); the approvals file covers 30 calendars and 17 courses | Platform Admin |
| English | Approvals MARK-FILE: 5 English policies, 10 courses. The system recommends rejecting 4 of them, because course pages contradict them. UNSW Bengaluru risk (above) | Platform Admin |
| Official pages | Searched only where evidence shows a page exists. Lanes run automatically for published providers. 448 top-five courses are finished "no page". The publish paste opens the 1,056 eligible providers | Platform Admin (publish paste) |
| Delivery | No new reader. Of the 2,518 still blank after the take-back: 1,686 are on another course's page (identity), 821 have no accepted identity proof for delivery (policy) and 11 are silent. The 20-page silent sample is listed below; it could not be checked by hand from here | Identity lanes; Platform Admin (publish paste) |

**Delivery 20-page silent sample** (pool of 1,476 "the page does not state it" on a bound page; fixed-seed sample):
- From the addresses alone, 6 of the 20 are not the course's own page. They are a provider fee list (USC), a general fees page (UMA), a learning-system category (George Brown) and a learning-system topic (JPIC), plus two multi-course listing pages (Envirotech marine and conservation).
- So part of the "genuinely silent" class is a binding (identity) problem, not a silent source.
- The other 14 need a person with a browser. Web reads of these addresses are blocked from this session, and the stored copies cannot be read with SQL.
- **The class is not declared exhausted.**

### Admitted-value movement under this mandate (05:46 → 07:3x)

| Field | 26 Oct (last snapshot) | Now (live) | Change | Accuracy | Cost |
|---|---|---|---|---|---|
| Provider tuition | 8,454 / 26,103 | 8,454 / 26,103 | 0 | n/a | US$0 (the 26 Oct wave's US$0.60 predates the mandate) |
| Intakes | 9,391 | 9,391 | 0 | n/a | 0 |
| English | 16,917 | 16,917 | 0 | n/a | 0 |
| Official pages | 18,622 | 18,622 | 0 | n/a | 0 |
| Delivery | 16,574 | 16,574 | 0 | n/a | 0 |
| Entry requirements (AER) | 0 active | 0 active | 0 (363 rows proposed and in review; none admitted) | 25 pages complete against their source tables | ≤ US$0.157 |

**No admitted AU value moved under this mandate.** Every recovery step that would move one waits on a gate:
- the three morning pastes;
- the target-list proposal;
- the two MARK-FILEs and the rule decisions;
- the UNSW English decision;
- Layer 4 review.

### Remaining gaps, by class

| Class | Gaps |
|---|---|
| **Source** | 14 of the 20 sampled silent delivery pages need a hand check. 448 top-five courses are finished "no page". 22 fee-schedule PDFs (PDF work not authorised) |
| **Policy** | 821 delivery values lack an accepted identity proof for delivery. Postgraduate calendar months (rule (c)). Withdrawn-before block (rule (b)) |
| **Identity** | 1,686 delivery values on another course's page. 170 top-five courses held on another course's page. 379 dead page addresses. The MIT provider pair sharing one fee page |
| **Reader** | AER G1, P2 and R2, plus D4 unresolved on Nigeria and Vietnam (frozen; new decision needed). The fee-reader lease-settle gap (named; no change) |
| **Platform Admin decision** | The three morning pastes; the target-list proposal; the two MARK-FILEs; UNSW Bengaluru English; the 19 items waiting for retired Layer 3; any D6+ |
| **Governance gaps logged** | `catalogue.course_intakes` has no timestamps or writer; `svc_fee_ai_next` does not settle an expired lease at the limit |

### 07:25 pre-apply check of the morning pastes (scheduled)

- Combined rolled-back dry run of the three pastes, applied in order on live and rolled back. Run 40395838726, branch `cf247-zoho-dryrun` at `aa169687`.
- Files checked (md5): retirements `0b1a26d2…`, publish `936ce8b4…`, fee re-apply `a360d3e1…`.
- **Every guard passed:**
  - 563 courses retired;
  - all 1,056 providers published (0 eligible left unpublished);
  - fee re-apply: 372 fees live (its guard 2), and its control event written.
- Afterwards, at 07:28:50, live was unchanged:
  - run b8a541af departures still held, with 0 retirement rows;
  - 1,056 providers still eligible and unpublished;
  - 0 re-apply events;
  - the dry-run version is not in the migration history.
- The dry-run branch was reset to `main`.
- **No paste changed; all three are ready for 08:00.**
