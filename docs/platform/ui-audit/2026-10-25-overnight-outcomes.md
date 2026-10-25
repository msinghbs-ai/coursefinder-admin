# Overnight execution mandate — outcomes, tracked per course (25–26 Oct 2026) — decision record

Platform Admin, 25 Oct 2026 18:02 AEDT: "Overnight execution mandate — outcomes only, tracked per course, no silent empty fields. This starts NOW and runs round the clock; report at 08:00 AEDT. … Budget authority: up to 30,000 Firecrawl credits and $25 AI across this mandate, spent per the table below; stop-and-report at 75% of either. Every initiative reports spend against its line."

Outcomes O1–O7 and the tracker are as given in the mandate:

| Outcome | Field | Budget line |
|---|---|---|
| O1 | fees | 3–6k credits |
| O2 | intakes | — |
| O3 | descriptions | ~500 credits + $2 |
| O4 | NZ entry matrices | ~1.5k credits |
| O5 | scholarships second pass | ~500 credits |
| O6 | searches (cap raised on ≥ 60 % correct-page) | — |
| O7 | titles (Defect 1 NZ pass) | — |

The tracker is `docs/platform/COURSE-WISE-TRACKER.md`. Rules:
- nothing auto-resolves past Layer 4;
- quarantine, not delete;
- quote on page;
- stored copies before fetches;
- settings keys for every tunable;
- one release at a time;
- PRs ready by morning go to the Platform Admin.

**Clarification, Platform Admin 18:05:** "Track A (S1 + 8a) and Track B release 1 continue uninterrupted — the outcomes mandate is ADDITIVE, not a replacement. If capacity forces a choice, outcomes first EXCEPT S1's gate consolidation, which holds its schedule. Nothing else changes."

## How it is being run (unattended reading, stated up front)

1. **Operational outcomes run tonight through existing, catalogued mechanisms only:**
   - settings within their ranges;
   - tasks (`admin_jobs`);
   - queue requests (`fee_course_requests`, central-page discovery);
   - AI re-checks that only propose.

   Each action is logged in `pipeline.admin_control_events` with the reason "Overnight outcomes mandate 25 Oct 2026". Nothing new is admitted without the existing gates; Layer 4 decides the rest.
2. **New code is release work.** It ships as a PR for review, never merged overnight. Under the standing "one release at a time, merged and alive before the next" rule, only **one** release PR can be in flight. Order, per the 18:05 clarification:
   - **S1's gate consolidation** holds its schedule and takes the release slot first;
   - outcome releases follow: O4 NZ entry matrices (step A), then O3 descriptions (Part E provider reader, B2), then O5 (B4), then O7 (Defect 1 writes);
   - Track B release 1 keeps its place;
   - outcome fields that need an unmerged reader are reported at 08:00 as "blocked: reader in PR #…", never as silently empty.
3. **AI budget reality.**
   - The OpenRouter balance at 18:00 AEDT is **US$20.77** (latest `openrouter_balance` read). The $25 authority is above the money available.
   - The working AI stop is set at **US$15 spent** (balance floor about US$5), so the live AI lanes (central policy, Enrich fields, fee reader, scholarships) do not run dry overnight.
   - This sits below the mandate's 75 % ($18.75).
4. **Firecrawl baseline** at 18:00 AEDT: **336,089 credits remaining** (plan 500,000; period ends 2 Nov). Stop-and-report at 22,500 used, i.e. at 313,589 remaining.

## Baseline at 18:00 AEDT (25 Oct, 07:00 UTC)

- Active courses: AU 26,103 · NZ 6,474 · CA 3,814.
- Firecrawl used today (UTC day): 290.
- Gap-cause snapshot: 06:00 UTC.

**Biggest single cause** across NZ fields: "no page: search and AI page match found none". NZ courses affected:

| Field | NZ courses |
|---|---|
| Fee | 2,030 |
| Intakes | 2,031 |
| Official page | 2,002 |
| Duration | 2,017 |
| Delivery | 2,004 |
| Campus | 1,826 |

Binding is the lever under every NZ field.

**Course search since R2 (24 Oct 00:00 UTC):**
- 977 sent;
- 864 found **no candidate at all** (88 %);
- 102 candidates pending;
- 10 verified.

Of the pages read:
- 14 correct (bound, read, identity proven);
- 7 wrong (5 not a course page, 2 identity mismatch);
- 79 waiting for a browser render (`retry.course_page_render_hours` 24);
- 12 blocked / fetch failed.

So the correct-page rate is **67 %** (14 of 21 decided), but the search yield is **1.4 %** (14 pages from 977 searches). See O6.

## Track C: entry requirements (opened 18:54, Platform Admin)

Platform Admin, 18:54: "Entry requirements — run as TRACK C in parallel, with boundaries". Recorded as given:

- **Tonight: read-only and branch work only.**
  - Byte-check the Part 1 quotes against raw page text and make them the reader's test data.
  - Draft the Step A migrations, the matrix reader and the catalogued job on branch `cf247-entry-matrix`.
  - **No merge.**
- **File boundary (declared).** Entry work touches only:
  - the matrix and course-requirement tables (`catalogue.provider_entry_matrix`, `catalogue.course_entry_requirements`) and their `entry.*` settings;
  - the new reader (worker mode `entry_ai`, `supabase/functions/coverage-sweep/entry.ts`, its svc next/record functions);
  - central-page discovery's page-type list (adds `entry_requirements`);
  - Layer 4 first-run items for matrix rows.

  It touches **nothing** in the search picker, the stop gates, `course_events`, or the blade.
- **Merge position (fixed):** Track A (S1, PR #694) → Track B release 1 → Track C Step A. The Track C PR waits in that queue even if it is ready earlier.
- **Extraction runs** (AI over the stored pages of the 19 HTML providers) start only after Track B release 1 lands. The catalogued job ships **inactive**. Tonight is code, test data and byte-checks only.
- **Budget:** within the existing AI stop (US$15) and the Firecrawl balance. The runs are stored-pages-first, so they are mostly AI-only.

### Byte-check results (19:00)

32 Part 1 quotes were checked against the raw page text: 25 verified, 7 not reachable.

| Result | Count | Providers |
|---|---|---|
| Exact | 17 | UNSW, Sydney, UQ, UWA, UTS, Flinders, Macquarie, Wollongong, VU, Waikato, VUW, Massey, Unitec, MIT, Otago Polytechnic, Ara, SIT |
| Exact after whitespace | 6 | Adelaide, ANU, RMIT, Curtin, Auckland, Wintec |
| **Corrected** | 2 | EIT: the page has no final full stop. NMIT: the first letter is split in markup ("S enior"), so the reader joins markup-split words, which the worker's existing `flat()` quote check already does |
| Fetch refused | 7 | Monash 403, Melbourne 403, AUT 403, Otago 403, Lincoln 403, Western Sydney 406, Swinburne network unreachable. These stay `unverified` in the fixtures and are not pass/fail cases |

The corrections are made in `ENTRY-REQUIREMENTS-IMPLEMENTATION.md` (section 1.3 table and new section 1.3a) in this same commit, as doc-as-code.

The byte-check workflow ran on the scratch branch `cf247-zoho-dryrun` and was removed in the same flow. The scratch tree has 0 byte-check files (rule 8).

## Execution log

(Entries appended through the night: time, initiative, action, spend.)

| Time (AEDT) | Initiative | Action (existing mechanism) | Result | Spend |
|---|---|---|---|---|
| 18:07 | O6 searches | `search.daily_picked_cap` 100 → 200 (`admin_toolsets_write`, reason logged) | Rule met: correct-page rate 67% (14 of 21 decided) ≥ 60%. **Numbers to note:** 88% of searches since R2 found no candidate at all (864 of 977), so yield is 1.4%. The raise adds about 14 correct pages a day at about 200 extra credits. The real lever is the empty-search rate, not the cap. Pending Monday's weekly line | — |
| 18:09 | O1 fees | `fees.provider_types` [university] → [university, tafe_polytechnic, other] (reason logged) | Root cause of the no-fee gap at the top providers: the fee reader covered NZ universities only. CA providers have no type (3,142 no-fee); NZ polytechnics are typed tafe_polytechnic (2,004 no-fee). Within 15 minutes the fee reader added 338 fee-schedule sources across 174 providers (CA 331, NZ 7). Of those, 96 sources at 43 providers have courses, and the reader picks those first (course count order). The other 242 belong to providers with no active courses: read last, at low cost, noted. Gates unchanged (auto-admit at 0.85 confidence, floor, identity; below that, Layer 4) | O1 line |
| 18:12 | O2 intakes | Enrich fields task `cc7f0ae4…` (intakes) for 16 universities with an approved calendar, whose pages read before the 23 Oct period→month route named only a study period | 354 items (39 to AI, 315 skipped at once for no stored page or already answered) | O2 |
| 18:14 | O5 scholarships | AI re-check queued (proposal only, nothing published) on 372 held scholarship pages never re-checked that have a stored copy; 50 without a stored copy stay | `scholarship-recheck` job picks them, 12 per run every 2 minutes | O5 line |
| 18:15 | Tracker | `docs/platform/COURSE-WISE-TRACKER.md` edition 1 (baseline) and its generator `docs/platform/tracker/course-wise-tracker.sql` | 0 courses empty without a cause in any of AU, NZ and CA. AU's large blocked blocks are unpublished providers (enrichment paused by design) | — |
| 18:15 | O3, O4, O7 | Need new readers; release work, not an overnight lever | Reported in the tracker as "blocked: reader not built", with the release order above | — |
| 18:55 | Track A S1 part 1 (release slot) | PR #694, v2.15.352: one refused-page predicate (rejections ∪ blocks) asked by every automatic binding path; one course-search stop gate for the picker, the credit check and the stall walk | Live dry run (rolled back): 0 of 1,822 queued rows behave differently under the new gate; a planted rejection was skipped by the search result and refused by the binder. Suite 1,912 passed (4 legacy). **Not merged: for the morning review.** The next release (O4 NZ entry matrices, step A) starts only after #694 merges (one release at a time) | — |
| 18:55 | Progress since 18:00 | O1: 345 new fee-schedule sources (307 waiting to be fetched, 38 read with no values); 77 schedule pages through the fee reader so far, giving 102 domestic rows, 36 with no matching course and 11 to Layer 4 review. O2: 15 courses gained intakes. O5: 12 re-checks done or leased, 312 queued. O6: 200 searches sent today (cap 200) | Firecrawl 243, AI US$0.23 |
| 19:02 | Track C opened | Byte-check of the Part 1 quotes (scratch-branch workflow, removed after use); design doc corrected (EIT, NMIT); branch `cf247-entry-matrix` created from main | 17 exact, 6 after whitespace, 2 corrected, 7 fetch refused. Boundary and merge position recorded above. No merge | Firecrawl 0 (direct GET from the runner), AI 0 |
