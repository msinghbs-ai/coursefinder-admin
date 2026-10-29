# AER programme — live status (29 Oct 2026)

Durable checkpoint, kept current at each stage. Updated whenever a stage starts or finishes, at least every 15 minutes during long runs, and whenever a PR, migration, deployment or source batch completes. Report: `2026-10-29-aer-programme-consolidated-report.md`. Manifest: `2026-10-29-aer-layer4-manifest.md`.

**Labels:** PREPARING · VERIFYING · DELIVERED · BLOCKED · FAILED

## Current state — 18:35 AEDT (mandate 29 Oct 2026 16:59)

| WS | Lane / owner | State | Evidence | Next action |
|---|---|---|---|---|
| 0 Scholarship deadlock | integrator | DELIVERED | Paste applied 16:57 (verified). W27 PR #743 (`15664910`): migration md5 `196c6d38` equals the file; functions `fb55e935`/`402c1dae`/`6f3e46a7`; job 39 ran 17:26 under the lock and succeeded; suite 1,187/0/0 | — |
| 1 Provider sources | lane C → integrator | DELIVERED (W28) | PR #744 (`33f53e50`): migration md5 `c464bb04`; `aer_reread_v1` `ad0fbd35`; Otago dry run re-queued exactly one run; suite 1,191/0/0. Inventory of 102 sources (only Otago has a stale pending item) | reviewer rejects `f14ae480` (Layer 4, human) |
| 2 Course-level and NZ | lane D → integrator | VERIFYING (W29, v2.15.369) | worker v0.53.0 sliced read; migration `20261029130000` dry run passed (record md5 `857102dc`); targeted 43/43 | full suite → change control → merge → worker verification; NZ batches and the 3 Monash re-reads BLOCKED (spend decision) |
| 3 Resolver and consumer | integrator | DELIVERED (read-only) | 6,030 course × country checks: payload equals resolver; proposed-only providers return 0 rows; RMIT India/Nepal/Singapore rule 5 explained | — |
| 4 Release health | lane E | PREPARING | classifying the 31 failing deployed specs | handback |
| 5 Guides and handoff | lane F → integrator | DELIVERED | `AER-ROLE-GUIDES.md` (merged `2b24140f`, 4.1 updated for W28); developer guide §7.9 clarified (no API change) | — |

**Counts (live, 18:30):**
- Eligible courses: 4,156 AU + 421 NZ. AU was 4,977 at 14:45; the drop comes from identity mismatches after the coverage pipeline's re-binding (investigation item).
- Course reads: 202 AU (184 review, 16 skipped, 3 failed).
- Matrix rows: active 343 (RMIT only).
- Balance: US$5.39 against the US$5 floor.

## Log

- 18:35 — W27 and W28 delivered; guides merged; resolver/consumer reconciliation done; W29 verifying; eligible-count drop found and attributed to coverage re-binding.
- 17:45 — Mandate 16:59 received. Paste found applied at 16:57 (verified live). Root cause found (job 39 full rebuild vs paste). W27 decision and reconciliation lodged (`84cd25ac`); fix proven locally and by live dry run. Lanes C, D, E and F launched.
- 15:20 — Batch 4 settled (37 review, 10 skipped, 3 failed: answer cut off at about 8,000 characters, not retried). Balance US$5.40; course reading paused at the floor (a fifth batch could overrun). v2.15.368 (#741) and batch 4 (#742) delivered; `cf247-zoho-dryrun` = main; report Part B filed.
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
