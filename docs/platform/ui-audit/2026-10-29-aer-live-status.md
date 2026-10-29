# AER programme — live status (29 Oct 2026)

Durable checkpoint, kept current at each stage. Updated whenever a stage starts or finishes, at least every 15 minutes during long runs, and whenever a PR, migration, deployment or source batch completes. Report: `2026-10-29-aer-programme-consolidated-report.md`. Manifest: `2026-10-29-aer-layer4-manifest.md`.

**Labels:** PREPARING · VERIFYING · DELIVERED · BLOCKED · FAILED

## Current state — 14:40 AEDT

| Lane | Owner | State | Now | PR / release | Next automatic action |
|---|---|---|---|---|---|
| A1–A5 + B4 UX release v2.15.366 | integrator | DELIVERED | live and verified (md5s match; NZ eligible 421, AU unchanged; DP020 India rule 5 with the true reason) | #738 | — |
| B1 reader corrections v0.52.0 | integrator | DELIVERED | worker deployed, byte-identical to main | #739 · v2.15.367 | — |
| B1 re-reads + B3 course batch 3 | integrator | DELIVERED | four sources read once on v0.52.0 (kept/not kept: Wollongong 220/24, Federation 69/7, UWA 177/8, Otago Polytechnic 104/30); Monash batch 3: 47 in review, 3 skipped | #740 (migration `42467d13`) | — |
| C live acceptance + tour defects v2.15.368 | integrator | VERIFYING | live tour on real data: DP020 country order, India rule 5, 6 scholarships, 24-entry timeline, drawer opens and closes, banner inside, 0 console errors, list reads ≤100, 0 writes. Two display defects found and fixed (evidence "[object Object]"; phone country selector past the card). Full suite running; s167 deployed acceptance running live on the branch | branch `cf247-aer-live-acceptance-tour` | change control, merge, deploy, deployed acceptance on main |
| B3 course batch 4 | integrator | PREPARING | balance US$5.87, floor US$5, estimate US$0.43 for 50 Monash courses; migration drafted | — | after v2.15.368: suite, PR, merge |
| A2 scholarship links | Platform Admin | BLOCKED (human) | the cause is fixed in 070000 (live); existing wrong links go only by the paste file `PASTE-20261029-scholarship-research-links-reapply.sql` | — | report |

**Controls in force:** one shared lock serialises all Playwright runs. Only the integrator applies migrations, merges and deploys. AI spend is accounted centrally: balance US$5.87 at 14:35, floor US$5 (unchanged), measured US$0.0086 a course.

## Live counts (14:35)

- Matrix rows: active 343 (RMIT only) · proposed 2,186 (26 providers) · quarantined 20 · superseded 765.
- Course rows: proposed 589 (148 items).
- Layer 4 pending (AER): 205 (57 matrix, 148 course). Manifest refreshed (`bbc86183`).
- Sources: 102 (99 read, 3 failed).
- What reaches the website and Zoho: RMIT's 343 rows only.

## Log

- 14:40 — v2.15.367 (#739) and batch 3 (#740) delivered; corrected reads landed; live tour found two display defects (fixed in v2.15.368, verifying); manifest refreshed.
- 14:20 — Finding: Read again re-read both stored copies of the Otago Polytechnic page (two pending items for one source; the older one is marked stale in the manifest; about US$0.09 extra).
- 14:45 — #738 (v2.15.366) DELIVERED and verified live.
- 13:40 — #737 merged and live (programme batch 2).
- 13:55 — DP020 page read: no band printed, so the India result is confirmed as rule 5 with the true reason.
- 14:00 — Lane C review: a country-identity gap at Otago (a quote can cross into the next country's label); fix requested; not merged.

- 12:40 — FAILED, then fixed: the agent worktrees were created inside the admin repo and committed as embedded links (`362cefe5`). They were removed (next commit) and the agents moved to Pilot worktrees. No live change.
- 12:55 — A3 dry run passed; batch 2 dry run passed.
- 13:00 — Conflict found and prevented: every lane's tests share port 5173, so all runs are now serialised behind `/tmp/claude-pw.lock`.

- 12:25 — Section D received; execution board posted; sections A–C requested.
- 12:28 — DP020 diagnosed: a level-mapping gap (AS against DP), not a data gap.
