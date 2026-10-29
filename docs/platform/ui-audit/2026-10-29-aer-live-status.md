# AER programme — live status (29–30 Oct 2026)

Durable checkpoint, kept current at each stage. Updated whenever a stage starts or finishes, at least every 15 minutes during long runs, and whenever a PR, migration, deployment or source batch completes. Report: `2026-10-29-aer-programme-consolidated-report.md`. Manifest: `2026-10-29-aer-layer4-manifest.md`.

**Labels:** PREPARING · VERIFYING · DELIVERED · BLOCKED · FAILED

## Current state: 08:33 AEDT, 30 Oct (mandate 30 Oct 06:53): close-out

Handback: `2026-10-30-aer-enrichment-handback-2.md`. **Not complete:**
- 1,014 AER items await human review;
- B5 is not approved, so 4,132 AU courses remain unread;
- 46 long pages are held, pending decision D1.

| Step | State | Evidence |
|---|---|---|
| B1: three source re-reads (≤ US$0.05) | DELIVERED | #749. US$0.0155; 21 rows proposed; 3 items pending (human) |
| B2: three Monash reads (≤ US$0.10) | BLOCKED (D1) | Held at US$0: pages over `entry.course_page_chars` |
| R1: 714 recovery reads (≤ 714 credits, no AI) | DELIVERED | #750. 679 bound again (677 eligible); 35 remain (D3); 3 credits; no AI |
| B3: 500 AU courses (≤ US$6) | DELIVERED | #752–#754. US$2.6874; 424 to review; 33 skipped; 43 QUT held (D1) |
| B4: 421 NZ courses (≤ US$4.50) | DELIVERED | #755, #756, #758. US$0.8207; 348 to review; 71 skipped; 2 AUT held |
| Batch size back to 50 | DELIVERED | #759, verified live 08:27 |
| v2.15.372: A1–A3, A5 | DELIVERED | #751 |
| v2.15.373: W34, W35 snapshots and gap-cause run time | DELIVERED | #757. Local 1,252/0/0; deployed weekly `40956651633`: 79/79 desktop and 80/80 phone, with the four former reds passing |
| A4 guides | DELIVERED | Role guides §5.2, requirements O9 (the API marker is decision D5) |
| Stuck-drafts paste | PREPARED, not executed | `pastes/PASTE-20261030-stuck-adapter-drafts.sql` (D7) |
| Capacity assessment | DELIVERED (read-only) | `2026-10-30-edge-capacity-assessment.md` (D8) |
| Branch cleanup | Partly BLOCKED | zoho-dryrun = main; deleting 3 verified-redundant branches is refused by the proxy (D9) |

## Log

- 08:33 (30 Oct): B3 and B4 complete within ceilings (US$2.69, US$0.82); QUT paused on page size; v2.15.373 live, and the deployed weekly run is green (the four former reds pass); batch size restored; handback 2 lodged.
- 08:06 (30 Oct): B3 complete; B4 batch 1 queued; stuck-drafts paste and capacity assessment lodged.
- 07:46 (30 Oct): B3 batch 1 settled (QUT held); batch 2 limited to RMIT; W35 dry run passed in parts.
- 07:27 (30 Oct): B1 delivered (US$0.0155); B2 held at US$0 (page size, decision); R1 queued 07:18 and recovering; lanes K, L and M2 handed back; A5 found a role-check defect (fixed in v2.15.372); decisions §9 and §10 lodged.
- 06:55 (30 Oct): mandate 06:53 received; PREPARING with the paid-read lock; lanes K, L, M, M2 and N launched.
- 01:20 (30 Oct): handback filed. Weekly deployed run: Universities regression fixed; 4 load-timing failures left red (decision). Source finder ran clean at 00:56 (3 universities, no failure).
- 00:55 (30 Oct): **v2.15.371 DELIVERED** (#748, `cd97b53d`): W31 and W33 live; md5s `ec5087e3` and `604b67d3` match the dry runs; worker v0.54.1 answering; post-merge checks green.
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
