# AER programme — live status (29 Oct 2026)

Durable checkpoint, kept current at each stage. Updated whenever a stage starts or finishes, at least every 15 minutes during long runs, and whenever a PR, migration, deployment or source batch completes. Report: `2026-10-29-aer-programme-consolidated-report.md`. Manifest: `2026-10-29-aer-layer4-manifest.md`.

**Labels:** PREPARING · VERIFYING · DELIVERED · BLOCKED · FAILED

## Current state — 13:05 AEDT (full mandate A–D received 12:23)

| Lane | Owner | State | Now | PR / release | Next automatic action |
|---|---|---|---|---|---|
| B2 + B3 programme batch 2 | integrator | VERIFYING | migration `20261029050000`: dry run passed (13 sources accepted, Monash batch of 50 at US$0.44, DP020 read queued); s165 passing; full suite running under the shared test lock | branch `cf247-aer-programme-batch-2` | change control, merge, deploy, watch the reads |
| A3 DP020 / level labels | integrator | VERIFYING | W19 lodged (`362cefe5`). Migration `20261029060000` dry run: labels map to all named levels; DP020 for India reaches the true reason (band table exists, no course band); 92 of 2,535 RMIT pairs changed their note, 0 changed their rule | branch `cf247-aer-dp020-levels` | s160; joins the UI release |
| A1 + A5 overlay, phone drawer, banner | agent B | PREPARING | shared accessible overlay; real phone defect; banner | `cf247-aer-phone-drawer-banner` | handback, then integration |
| A2 + A4 scholarships, country order | agent A | PREPARING | DP020 scholarship trace; India › Nepal › Singapore › A–Z helper | `cf247-aer-scholarships-countries` | handback |
| B1 reader corrections | agent C | PREPARING | Federation, Wollongong, Otago Polytechnic, UWA | `cf247-aer-reader-corrections` | handback, then worker deploy and one re-read each |
| B4 NZ identity | agent D | PREPARING | already-approved NZ proofs; title-only refused | `cf247-aer-nz-course-identity` (migration `20261029080000`) | handback, then dry run before activation |
| Decisions | integrator | DELIVERED | W19–W26 lodged before code (`2222b60f`) | — | — |

**Controls in force:** one shared lock serialises all Playwright runs (port 5173). Only the integrator applies migrations, merges and deploys. AI spend is accounted centrally: balance US$7.05 at 12:15, floor US$5, measured US$0.0089 a course.

## Live counts (11:45)

- Matrix rows: active 343 · proposed 1,786 (26 providers) · quarantined 20 · superseded 340.
- Course rows: proposed 200.
- Layer 4 pending (AER): 106.
- Sources: 102; held 15.
- What reaches the website and Zoho: RMIT's 343 rows only.

## Log

- 12:40 — FAILED, then fixed: the agent worktrees were created inside the admin repo and committed as embedded links (`362cefe5`). They were removed (next commit) and the agents moved to Pilot worktrees. No live change.
- 12:55 — A3 dry run passed; batch 2 dry run passed.
- 13:00 — Conflict found and prevented: every lane's tests share port 5173, so all runs are now serialised behind `/tmp/claude-pw.lock`.

- 12:25 — Section D received; execution board posted; sections A–C requested.
- 12:28 — DP020 diagnosed: a level-mapping gap (AS against DP), not a data gap.
