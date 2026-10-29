# AER programme — live status (29–30 Oct 2026)

Durable checkpoint, kept current at each stage. Updated whenever a stage starts or finishes, at least every 15 minutes during long runs, and whenever a PR, migration, deployment or source batch completes. Report: `2026-10-29-aer-programme-consolidated-report.md`. Manifest: `2026-10-29-aer-layer4-manifest.md`.

**Labels:** PREPARING · VERIFYING · DELIVERED · BLOCKED · FAILED

## Current state: 00:45 AEDT, 30 Oct (mandate 30 Oct 00:01, Workstreams 1–8)

| WS | Owner, branch | State | Evidence or next step |
|---|---|---|---|
| 1 Health reconciliation | integrator, admin main | DELIVERED | `2026-10-30-enrichment-health-reconciliation.md`; complete gap list `2026-10-30-gap-causes-needs-a-change.md` |
| 2 Source finder, capture, slow reads | lane G, then integrator; `cf247-w30-int` | DELIVERED (v2.15.370) | W30 live, md5s `061d6252` / `748954a5` / `247e93da` |
| 3 Release health | lane J, then integrator; `cf247-w33-int` | PREPARING | W33 Universities paging dry run passed (first page 83 KB, 1.0 s); ships in v2.15.371 after .370 |
| 4 Identity and eligibility | lane H, then integrator; `cf247-w31-int` | PREPARING | Cause: the 29 Oct re-map binder displaced 714 code-proved AU pages. W31 dry run passed (0 of 1,230 proved pages touched). Recovery R1 BLOCKED on spend. |
| 5 Reader hardening | lane I, then integrator; in `cf247-w30-int` | DELIVERED (v2.15.370); bulk spec BLOCKED (decision A5) | W32 live (12 settings, worker v0.54.0); `2026-10-30-bulk-reread-newest-copy-spec.md` |
| 6 Layer 4 policy | integrator | DELIVERED (decision paper); decisions BLOCKED | `2026-10-30-platform-admin-decision-paper.md` Part A; role guides 5.6 |
| 7 Reporting freshness | integrator | DELIVERED (report prompt); panel change BLOCKED | Hourly report prompt updated; W30–W33 lodged in decision §8 |
| 8 Paid reads | integrator | BLOCKED (decision) | Decision paper Part B: B1–B5, R1, R2. The balance top-up (US$104.99) is not authority. |

**Sequence:** v2.15.370 (W30 + W32), then v2.15.371 (W31 + W33). One deploy at a time.

## Log

- 00:45 (30 Oct): **v2.15.370 DELIVERED** (#747, `85955c5e`): W30 and W32 live; md5s match the dry run; worker v0.54.0 answering; deployed UAT, release currentness and history contract green; `cf247-zoho-dryrun` = main. v2.15.371 (W31 + W33) full suite running.
- 00:38 (30 Oct; earlier updates were mislabelled about an hour ahead): all four lanes handed back; decisions W30–W33 lodged (`cb1974b9`); decision paper filed; three live dry runs passed and rolled back; hourly report prompt corrected; OpenRouter top-up seen (US$4.99 → 104.99 at 00:15), nothing queued.
- 00:05 (30 Oct): mandate received; PREPARING board; lanes G, H, I, J launched; Workstream 1 read-only.
- 20:00 — v2.15.369 (#745) and Workstream 4 (#746) delivered; handback filed; programme report Part C added.
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
