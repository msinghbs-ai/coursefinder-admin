# AER programme — live status (29 Oct 2026)

Durable checkpoint, kept current at each stage. Updated whenever a stage starts or finishes, at least every 15 minutes during long runs, and whenever a PR, migration, deployment or source batch completes. Report: `2026-10-29-aer-programme-consolidated-report.md`. Manifest: `2026-10-29-aer-layer4-manifest.md`.

**Labels:** PREPARING · VERIFYING · DELIVERED · BLOCKED · FAILED

## Current state — 15:20 AEDT (programme paused at the credit floor; consolidated outcome reported)

| Lane | State | Result | PR / release |
|---|---|---|---|
| A1–A5 + B4 (overlay, scholarships, label levels, countries, phone, NZ identity) | DELIVERED | live and verified | #738 · v2.15.366 |
| B1 reader corrections | DELIVERED | worker v0.52.0 byte-identical to main; four sources re-read (Wollongong 220/24, Federation 69/7, UWA 177/8, Otago Polytechnic 104/30) | #739 · v2.15.367, #740 |
| C live acceptance + tour defects | DELIVERED | s167 post-merge desktop 2/2, phone 2/2; two display defects fixed | #741 · v2.15.368 |
| B3 course batch 4 | DELIVERED | 37 in review, 10 skipped, 3 failed (answer cut off, not retried); about US$0.29 | #742 |
| B3 course reading | BLOCKED (spend) | balance US$5.40, floor US$5; next batch estimate US$0.40 against measured US$0.29–0.45, so paused to avoid overrunning headroom | — |
| A2 scholarship links paste | BLOCKED (human) | `PASTE-20261029-scholarship-research-links-reapply.sql` ready (070000 is live) | — |
| Layer 4 | BLOCKED (human) | about 245 pending (57 matrix; 185 course after batch 4); manifest `2026-10-29-aer-layer4-manifest.md` | — |

**Next automatic action:** none. Course reading resumes only on a spend decision (programme report B9). `cf247-zoho-dryrun` is identical to main.

## Live counts (15:15)

- Matrix rows: active 343 (RMIT only) · proposed 2,186 (26 providers) · quarantined 20 · superseded 765.
- Course reading: 250 Monash courses plus DP020 and BH126 read; 4,977 AU and 421 NZ eligible.
- What reaches the website and Zoho: RMIT's 343 rows only. The consumer API is unchanged.

## Log

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
