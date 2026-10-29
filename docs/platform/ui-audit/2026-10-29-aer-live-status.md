# AER programme — live status (29 Oct 2026)

Durable checkpoint, kept current at each stage. Updated whenever a stage starts or finishes, at least every 15 minutes during long runs, and whenever a PR, migration, deployment or source batch completes. Report: `2026-10-29-aer-programme-consolidated-report.md`. Manifest: `2026-10-29-aer-layer4-manifest.md`.

**Labels:** PREPARING · VERIFYING · DELIVERED · BLOCKED · FAILED

## Current state — 12:30 AEDT

| Lane | State | Now | PR / release | Next automatic action |
|---|---|---|---|---|
| Main integrator | PREPARING | live-status file; DP020 diagnosis | — | integrate lanes A to C |
| A. DP020 / AER country behaviour | PREPARING | Root cause found: RMIT India rows "Diploma/Associate degrees" map to AS only, and DP020 (Diploma, DP) finds no row at its level, so it shows "none for this course's level" | — | design the level fix (decision before code) |
| B. Phone drawer + shared banner | PREPARING | live phone tap opens no drawer; OpenRouter banner clips its first letter at phone width | agent branch `cf247-aer-phone-drawer-banner` | agent hands back a fix and a test; integrator merges |
| C. Reader corrections | PREPARING | Federation, Otago Polytechnic and Wollongong (quote not on page); UWA (band not in quote) | agent branch `cf247-aer-reader-corrections` | agent hands back fixture-proven worker changes; integrator dry-runs and re-reads |
| D. NZ identity / course rollout | BLOCKED | NZ identity rule needs a Platform Admin decision; course reads are at the OpenRouter floor (US$7.37 balance, US$5 floor) | — | prep only |
| Course evidence overlay / Scholarships | BLOCKED | Sections A–C of the 29 Oct mandate not received (only D) | — | wait for the text |

## Live counts (11:45)

- Matrix rows: active 343 · proposed 1,786 (26 providers) · quarantined 20 · superseded 340.
- Course rows: proposed 200.
- Layer 4 pending (AER): 106.
- Sources: 102; held 15.
- What reaches the website and Zoho: RMIT's 343 rows only.

## Log

- 12:25 — Section D received; execution board posted; sections A–C requested.
- 12:28 — DP020 diagnosed: a level-mapping gap (AS against DP), not a data gap.
