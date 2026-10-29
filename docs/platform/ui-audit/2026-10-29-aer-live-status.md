# AER programme — live status (29 Oct 2026)

Durable checkpoint, kept current at each stage. Updated whenever a stage starts or finishes, at least every 15 minutes during long runs, and whenever a PR, migration, deployment or source batch completes. Report: `2026-10-29-aer-programme-consolidated-report.md`. Manifest: `2026-10-29-aer-layer4-manifest.md`.

**Labels:** PREPARING · VERIFYING · DELIVERED · BLOCKED · FAILED

## Current state — 14:45 AEDT

| Lane | Owner | State | Now | PR / release | Next automatic action |
|---|---|---|---|---|---|
| B2 + B3 programme batch 2 | integrator | DELIVERED | #737 merged (`98355c53`); migration md5 `b65de5e8` equals the file; deploy succeeded | #737 | reads progressing: ANU 4 of 9 done (11 rows each, was 1); Melbourne ×3 and UTS fetched as HTML; Monash batch 2: 50 in review (US$0.42); DP020 read: 4 rows in review, no band printed |
| A1–A5 + B4 UX release v2.15.366 | integrator | DELIVERED | #738 merged (`faebdef1`); suite 1,166 passed / 0 failed / 0 skipped; 5 deploy workflows green; live md5 060000 `29e2d550`, 070000 `1b4d0c0a`, 080000 `6c371a42` equal the files; course reading AU+NZ, eligible 5,398 (AU 4,977 unchanged, NZ 421); DP020 India = rule 5, precise reason; RMIT active 343 unchanged | #738 · v2.15.366 | deployed live tour (phone) |
| B1 reader corrections v0.52.0 | integrator | PREPARING | Otago gap closed by agent C (`59689c76`); being rebased onto main | `cf247-aer-reader-corrections` | suite, change control, merge, deploy worker, one re-read each |
| A2 scholarship links | Platform Admin | BLOCKED (human) | the cause is fixed in 070000 (live); existing wrong links are removed only by the paste file `PASTE-20261029-scholarship-research-links-reapply.sql`, now ready to run | — | report |

**Controls in force:** one shared lock serialises all Playwright runs (port 5173). Only the integrator applies migrations, merges and deploys. AI spend is accounted centrally: balance US$7.05 at 12:15, floor US$5, measured US$0.0089 a course.

## Live counts (11:45)

- Matrix rows: active 343 · proposed 1,786 (26 providers) · quarantined 20 · superseded 340.
- Course rows: proposed 200.
- Layer 4 pending (AER): 106.
- Sources: 102; held 15.
- What reaches the website and Zoho: RMIT's 343 rows only.

## Log

- 14:45 — #738 (v2.15.366) DELIVERED and verified live.
- 13:40 — #737 merged and live (programme batch 2).
- 13:55 — DP020 page read: no band printed, so the India result is confirmed as rule 5 with the true reason.
- 14:00 — Lane C review: a country-identity gap at Otago (a quote can cross into the next country's label); fix requested; not merged.

- 12:40 — FAILED, then fixed: the agent worktrees were created inside the admin repo and committed as embedded links (`362cefe5`). They were removed (next commit) and the agents moved to Pilot worktrees. No live change.
- 12:55 — A3 dry run passed; batch 2 dry run passed.
- 13:00 — Conflict found and prevented: every lane's tests share port 5173, so all runs are now serialised behind `/tmp/claude-pw.lock`.

- 12:25 — Section D received; execution board posted; sections A–C requested.
- 12:28 — DP020 diagnosed: a level-mapping gap (AS against DP), not a data gap.
