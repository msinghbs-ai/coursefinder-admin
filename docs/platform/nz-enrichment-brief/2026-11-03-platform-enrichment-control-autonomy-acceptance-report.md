# Platform Enrichment Control and Autonomy Acceptance Report

**Direction:** Platform Admin, 3 Nov 2026 09:32 (`2026-11-03-platform-led-enrichment-autonomy-mandate-0932.md`).
**Evidence:**
- `2026-11-03-enrichment-controls-audit.md`, the operator controls (Workstream F).
- `2026-11-03-enrichment-autonomy-measurement.md`, unattended throughput (Workstream F).

Both are read-only measurements of production on 3 Nov.
**Production:** v2.15.417.

## Verdict: not yet passed

**"If Claude stops working now, does StudySearch continue discovering, enriching, validating and publishing eligible data correctly?"**

**No, not for most fields.** Publication to the website and Zoho runs unattended. So do scholarship extraction and publishing, and intake dates from stored calendars. Everything that needs a new page, or that has no reader, stops or slows to almost nothing.

The programme is **not complete** until the items below are fixed and the acceptance test is repeated.

## Field matrix

**Key:** M = manual run from the UI; A = runs unattended.

| Field | Existing UI control | M | A | Verified in production | Known limitation | Corrective task (owner) |
|---|---|---|---|---|---|---|
| Course description | none | no | no | 163 of ~35,700 courses | No reader exists | Add `course_description` to the Enrich fields engine (stored page first, quoted, Layer 4 on first admission) (C) |
| Provider description | Coverage › Provider descriptions (retry) | partial | no | 0 published | Picker times out (IQ-00055); 5 fixed providers; lifetime US$1 ceiling | Picker fix (in build); eligibility rules instead of a fixed list; daily ceiling (C) |
| Official course link | Enrichment plan, Course sources | one provider | throttled | AU net loss of ~32/day (withdrawals) | Firecrawl budget; AU written into `enrich_focus_v1`; 2,668 in Layer 4 | Country setting (F); budget decision (Platform Admin) |
| Tuition and fees | Fee reader | partial | throttled | 135 in Layer 4 | Needs new pages | Budget decision |
| Intake month / year / date | Enrich fields; Stalled fields | yes | slow | ~13 per hour; pair reading on since 08:48 | 93% of each apply batch skipped; no operator control for dates | Measure the skip reasons; scoped control for dates (D) |
| Application deadline | none | no | no | 0 filled | No reader | Same engine as course description (C/D) |
| AER: course reads | Course-level reading (rank 6, preview, CSV) | yes | **no job** | 480 courses, all from the Platform Admin's batch | Fixed list of 41 providers; AU/NZ only; Canada not configured | Scheduled job (ships off) with eligibility rules; Canada gap logged (A) |
| AER: provider tables | AER workspace | yes | idle since 30 Oct | 38 of 40 held by D-R3 | Fixed list of 33 providers | Same scheduled job (A) |
| English requirements | Enrich fields | yes | throttled | 13 of 3,290 filled in the last run; 586 worker errors | `enrich_ai` errors hidden (IQ-00053) | Error fix (F) |
| Scholarships | Scholarships › Coverage "Find scholarships now" | yes | yes (extraction, publication); discovery throttled | 16 new in 24 h (8 published) | F1 picker not yet proven live; `scholarship-read` paused; AU priority in refill | Verify F1; setting for country priority (B) |
| Rankings | Datasets upload | yes | linking only | Website rankings last changed 14 Oct | No edition check or import; 15 not linked | Edition-check task to the integration queue (F) |
| Campus, duration, level, delivery, field, address | Enrich fields | yes | yes | — | — | — |
| Search projection, Website v2, Zoho | (automatic) | — | yes | 2,253 website and 1,098 Zoho changes in 24 h | 9 refresh time-outs | Already raised by the yield checks |

## Platform-wide blockers

1. **Firecrawl budget: needs a Platform Admin decision.**
   - The vendor plan is now 5,000 credits a month: about 3,600 usable, or about 120 a day.
   - The settings assume 25,000 a day, so every page-fetching worker answers "idle".
   - This is throttling, not a fault. Either the plan is raised, or the daily budget and its shares are set to what the plan can pay for. The platform then paces itself to that figure.
2. **No reader** for course description and application deadline.
3. **Work creation stalls between cycles.**
   - Each provider gets one automatic enrichment plan per 14 days, and all were used by 29 Oct; none is eligible until 4 Nov 14:41.
   - The standing gap queue timed out in 2 of its last 4 runs.
4. **No scheduled AER work.**
5. **Failures hidden behind a successful schedule:**
   - `enrich_ai` errors: a lock conflict with the `admin-jobs` runner, which held the task row `FOR UPDATE`. 2,240 items failed.
   - `nz_cop` was reported as never succeeding. **Corrected 3 Nov:** it works (63 NZQA files, 197 providers flagged), but its answer carried no item count and its picker took 12 s against an 8 s limit.
   - The active `cricos-peo` job calls its worker every minute with nothing due. **Corrected 3 Nov:** the job is active, not paused.
   - The provider-description picker (fixed in v2.15.418).

   Fixes for the first three: Workstream F branch `cf247-hidden-failures-country-config`.
6. **Controls that are missing or misleading:**
   - no "retry failed items" anywhere;
   - spend estimates and exports are missing from most controls;
   - Enrich fields tasks cannot be paused;
   - cancelling a plan leaves its tasks running;
   - "Run on demand" for Layer 2 does nothing (206 requests unprocessed since September);
   - manual and standing gap-queue work is not deduplicated.

## What depended on Claude as dispatcher (last 3 days)

| What | When | Effect | What replaces it |
|---|---|---|---|
| Firecrawl runs started by the integrator under the 16:39 authority | 2 Nov | 94% of 24-hour credits; 2,635 of the 2,668 waiting link items | Ended. Acquisition follows the budget decision through the platform's own lanes. |
| Scholarship discovery rows parked by hand | 3 Nov 00:23 | — | The F1 picker fix (v2.15.413) |
| Description re-queue | 3 Nov 08:47 | — | Stopped at 09:32. Re-reads go through "Read these again" or the schedule. |

## Country scalability

- **Shared engines with per-country settings:** fees, scholarships, enrichment plans and the gap queue.
- **Gaps:**
  - AU is written into course-link search and the scholarship refill;
  - CA is written into the `country-scope-gate` job command;
  - Canada has no AER configuration;
  - Canada has adapters for 48 of 1,130 providers;
  - the NZ code-of-practice reader has never worked.

  Each gap goes to the integration queue.

## Acceptance test status

| Test | Manual mode | Automatic mode |
|---|---|---|
| University description | Not possible yet (IQ-00055, fixed list) | Fails (picker) |
| Course description | Not possible (no reader) | Fails |
| Intake date | Ready: walkthrough §7, Monash | Runs; low yield |
| AER academic requirement | Ready: Monash course-level reading | Fails (no job) |
| Scholarship discovery | Ready: ACU, Charles Darwin | Runs; pilot of 8 non-university providers live 09:55 |
| Ranking refresh | Partial (needs a licensed file) | Fails (no edition check) |

**Manual mode needs a signed-in operator.** The Platform Admin runs the walkthrough in `2026-11-03-enrichment-controls-audit.md` §7. The integrator then verifies each run with read-only checks: job created, scope correct, evidence used, real work done, admission and Layer 4 respected, catalogue and API reconciled, audit and cost recorded.

## Engineering plan (extend existing controls; no new dashboards or scripts)

| # | Fix | Owner | Ships |
|---|---|---|---|
| 1 | Course description and application deadline as Enrich fields fields: stored course page first, quote-backed, Layer 4 on first admission, existing AI and Firecrawl budgets | C | release; standing gap queue picks it up |
| 2 | Provider-description picker time-out (IQ-00055) and eligibility rules instead of the 5-provider list | C | in build |
| 3 | Plans re-plan when a provider's gaps change (per-step windows); gap-queue time-out fixed; manual and standing work deduplicated; plan cancel cancels its tasks; retry failed items and export in Enrich fields and Enrichment plan; spend estimate before Start and before "Find scholarships now" | E/F | release |
| 4 | Scheduled AER course and table reading with eligibility rules (ships off with a daily cap); Canada gap logged | A | release, then activation decision |
| 5 | Hidden failures (`enrich_ai` errors, `nz_cop`, `cricos_peo` idle calls) fixed or switched off; AU and CA written into shared code moved to country settings | F | release |
| 6 | Layer 2 "Run on demand": mark retiring, hide the button, close stale requests (paste file) | E | release plus paste |
| 7 | Ranking edition check raises an integration-queue task | F | release |
| 8 | Intake apply skip reasons measured; scoped operator control for dates | D | release |
| 9 | Firecrawl budget aligned to the plan | Platform Admin decision | setting |
