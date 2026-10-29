# AER programme — live status (29 Oct 2026)

Durable checkpoint, kept current at each stage. Updated whenever a stage starts or finishes, at least every 15 minutes during long runs, and whenever a PR, migration, deployment or source batch completes. Report: `2026-10-29-aer-programme-consolidated-report.md`. Manifest: `2026-10-29-aer-layer4-manifest.md`.

**Labels:** PREPARING · VERIFYING · DELIVERED · BLOCKED · FAILED

## Current state — 17:45 AEDT (mandate 29 Oct 2026 16:59: programme to governed completion)

| WS | Lane / owner | Branch or worktree | State | Now | Next action |
|---|---|---|---|---|---|
| 0 Scholarship deadlock | integrator | `cf247-search-writer-lock` (Pilot) | VERIFYING | The paste was applied at 16:57 on its second try (verified live; no reapplication needed). Root cause: no coordination between search-document writers; job 39's full rebuild crossed the paste. Fix W27 (migration `20261029110000`): local reproduction deadlocks before and not after; live dry run passed; targeted 22/22 | full suite → change control → merge → deployed md5 (`fb55e935`, `402c1dae`, `6f3e46a7`) → observe one job 39 run |
| 1 Provider sources | agent C | `cf247-aer-reread-newest-copy` (scratchpad clone) | PREPARING | inventory of every source; Read again → newest stored copy (W28); Otago two-copy test | handback → integrator numbers, dry-runs, merges |
| 2 Course-level and NZ | agent D | `cf247-aer-course-sliced-read` | PREPARING | coverage reconciliation; diagnosis of the 3 truncated Monash reads; sliced reading with fixtures (W29); NZ batch plans | handback; any paid read stays BLOCKED at the floor |
| 3 Resolver and consumer acceptance | integrator | — | PREPARING | read-only resolver and consumer reconciliation | after W27 |
| 4 Release health | agent E | `cf247-deployed-suite-health` | PREPARING | classify the 31 failing deployed specs; repair or formally retire them | handback |
| 5 Guides and website handoff | agent F | `aer-role-guides` (admin branch) | PREPARING | six role guides plus matrix; AER developer handoff | handback → integrator merges |

**Controls in force:**
- One shared Playwright lock.
- Agents: read-only on live, no AI spend, no Layer 4 action (Kimi Work is reviewing), no merges or deploys.
- The integrator owns numbering, dry runs, the suite, change control, merges and deploys.
- Course reading is stopped at the US$5 floor (balance US$5.40).

## Log

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
