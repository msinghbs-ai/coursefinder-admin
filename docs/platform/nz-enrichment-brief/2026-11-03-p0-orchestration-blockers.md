# P0 orchestration blockers — live reconciliation (3 Nov 2026, 10:45 AEDT)

**Mandate:** Platform Admin, 3 Nov 10:44 (`2026-11-03-p0-continuous-orchestration-mandate-1044.md`).
**Live baseline:** v2.15.418 (last migration `20261103100000`). v2.15.419 is in its full suite.
**Issue tracker:** `pipeline.integration_issues` (the single defect register).

## Live reconciliation

- **Releases:** v2.15.410 to v2.15.418 are verified live (migration and function md5s; see each `…-deployed-state.md`).
- **IQ-00043:** closed 10:45 on real platform-run evidence. After the 10:37 `exit-awards-apply` run, the 13 restored links are still inactive and 13 attempts are recorded in `pipeline.course_link_rediscoveries`.
- **IQ-00055:** deployed. The description reader has not yet claimed the 3 queued reads; its next runs are at :56 and :06.

## Orchestration blockers

| Issue | Root cause | Country, provider, field | Backlog | Stopped or degraded | Workaround | Owner | Corrective release | Needs Platform Admin? |
|---|---|---|---|---|---|---|---|---|
| (new; to the queue with v2.15.419) | Each provider gets one automatic plan per 14 days (`plans.redo_days`); all were used 21–29 Oct | All countries; all providers; all plan steps | 1,589 universities held until 4 Nov 14:41; 12 never planned | **Degraded** (2 plans a day) | Operator Run now per provider | A (plans) | v2.15.419 (re-plan when gaps grow, ships at 0 an hour), then cf247-plan-lifecycle (evidence and retry triggers, fairness, no orphans) | **No.** The P0 mandate §3A authorises replacing the hold; the integrator will set `plans.replan_per_hour` after deploy |
| IQ-00031 | Standing gap queue time-out: its cross-check took 60 s of a 120 s limit | All; all fields | 12,528 items last run (10% filled) | **Degraded** (2 of 4 runs failed) | none | C (queue) | v2.15.419 (cross-check 25.6 s); cf247-lanes-and-gap-queue (checkpoints, keyset pagination) | No |
| (new) | No reader for course description and application deadline | AU 25,380 / NZ 6,495 / CA 3,815 courses | ~22,800 with a usable stored page | **Stopped** (no engine) | none | B (fields) | cf247-course-description-reader (v2.15.421 after rebase) | **Yes, two settings:** how many descriptions per provider go to Layer 4 before trust (built: 5), and the daily item cap (built: 500 per field) |
| IQ-00053 | `enrich_ai` writes time out on a `FOR KEY SHARE` lock held by the `admin-jobs` runner (`FOR UPDATE`, 1.5–1.8 min) | All; English and other AI fields | 2,240 items failed on 3 Nov 05:25 | **Degraded** | none | F (hidden failures) | cf247-hidden-failures-country-config (v2.15.420) | No. Re-running the 2,240 items is an operator action (Retry failed items in v2.15.419) or the standing queue |
| (new) | Page-fetching workers answer "idle" at the Firecrawl reserve. The vendor plan is 5,000 credits a month; the settings assume 25,000 a day | All; links, fees, new pages | ~1,500 course pages due | **Degraded** (paid acquisition) | Stored-evidence lanes must continue | C (lanes) | cf247-lanes-and-gap-queue (stored-evidence work never held by the paid lane; per-lane hold reasons) | **Spend only.** Raising the plan or budget needs explicit approval; the code separation does not |
| (new) | No scheduled course-level AER reading; fixed provider lists | AU/NZ (CA not configured); AER | 41 + 33 fixed providers; 539 in Layer 4 | **Stopped** (manual batches only) | Platform Admin Course-level reading | D (AER) | cf247-aer-scheduled-reading (ships paused) | **Yes:** activating the job (AI cost) |
| (new) | Layer 2 "Run on demand" has no processor; 206 requests queued since September | All | 206 requests | Dead control | none | C (queue) | v2.15.419 disables the button (lifecycle branch hides it) + paste file | **Status-only paste** (205 requests closed, 9 Layer 2 schedules off). The integrator will run it under P0 §3C/§7 after v2.15.419 unless told otherwise |
| IQ-00048 | Course-link search picker held by its own daily cap, counted as zero yield | All; links | 2,381 queued | Idle (cap), not failed | none | F | v2.15.420 (cap-held counts as idle) | No |
| (new) | nz_cop picker 12.3 s against the 8 s limit; its answers carry no item count | NZ; provider flags | 19 of the last 30 calls failed | **Degraded** | none | F | v2.15.420 | No |
| (new) | Ranking editions are never checked | All; rankings | THE 2027 not held; ARWU never imported | **Stopped** (refresh) | Datasets upload | F | v2.15.420 (check raises issues; ships paused) | Import needs licensed files (Platform Admin) |

## Counts for the unattended test

- **Claude-initiated enrichment actions since 09:32:** 0. Configuration only: the scholarship pilot settings (#28699–#28701) and the approved IQ-00043 paste (#28698).
- **Unattended cohort:** chosen after v2.15.419–v2.15.421 are live, so the platform runs it with the corrected plan, queue and field engines.
