# AER programme — live status (29–30 Oct 2026)

Durable checkpoint, kept current at each stage. Updated whenever a stage starts or finishes, at least every 15 minutes during long runs, and whenever a PR, migration, deployment or source batch completes. Report: `2026-10-29-aer-programme-consolidated-report.md`. Manifest: `2026-10-29-aer-layer4-manifest.md`.

**Labels:** PREPARING · VERIFYING · DELIVERED · BLOCKED · FAILED

## Current state: 11:30 AEDT, 30 Oct (mandate 30 Oct 08:45): close-out

Handback: `2026-10-30-aer-handback-3.md`. **Not complete:** 1,055 AER items await human review; 0 course rows are admitted.

| Item | State | Evidence |
|---|---|---|
| Layer 4 review enablement | DELIVERED (manifest); review is human | 1,055 pending; 0 decided in 24 h |
| D1 long pages | BLOCKED (ceiling) | 41 read, all complete, US$1.6891. 125 QUT pages need about US$4.69 against US$4.31 left |
| D3 R1 leftovers | DELIVERED, 0 restored | 0 credits. The render path needs a decision; 13 Flinders pages not restored (evidence gap) |
| D4 supersede rule | DELIVERED v2.15.374 (#763) | md5s match the dry run; deployed green |
| D5 `scale_stated` | BLOCKED (Platform Admin paste) | `pastes/PASTE-20261030-d5-scale-stated-marker.sql`; PR branch `cf247-d5-lane` |
| D6 role check | DELIVERED v2.15.374, s183 fixed (#764) | Deployed 80/80 and 81/81 |
| D7 stuck drafts | DELIVERED 08:50:59 | 5 drafts set to `error` |
| D8 capacity | DELIVERED (paper) | No production change |
| D9 branches | BLOCKED (proxy) | Operator command in handback 3 §5 |
| B5 | HELD (prepared) | Handback 3 §8 |

## Log

- 11:30 (30 Oct): v2.15.374 live and deployed green after the s183 premise fix (#764); D5 paste awaits the Platform Admin; handback 3 lodged.
- 09:12 (30 Oct): D1 stopped at the ceiling check after the probe and step 2 (US$1.69); manifest lodged (1,019 pending); D8 paper lodged; D3 queued; D7 delivered; D9 blocked.
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

## 30 Oct 16:48 AEDT: baseline before review (mandate 16:45)

| Measure | Value |
|---|---|
| D5 paste | **Not live** on fxcwkweaxjtknorudmwp: `entry_matrix_payload_v1` `be5478d0`, `entry_resolve_v1` `492ece03` (pre-paste md5s). BLOCKED until the Platform Admin confirms which project the editor ran on and sends its output |
| Layer 4 AER pending | 1,055 (997 course reads, 54 provider-table first runs, 4 change items) |
| Decided today | 0 |
| Course-level rows active | 0 |
| Provider matrix rows active | 343 (RMIT) |
| Ingestion | Held: no D1 resumption, no B5, no recovery reads |
| Reviewer pack | `ui-audit/2026-10-30-layer4-review-pack-1.md` (manifest steps 1–2) |

## 30 Oct 17:01 AEDT: D5 paste, first run rolled back; reissued

- **What happened:** the Platform Admin's run raised `security.entry_matrix_payload_v1(uuid,text) after the edit has md5 99dfa649…, expected c1f83b82…`.
  - The guard worked as designed: the transaction rolled back.
  - Live is unchanged: `be5478d0` / `492ece03`, and there is no D5 baseline row.
- **Cause:** the editor or clipboard turned the line breaks inside the inserted text into CRLF.
  - Reproduced exactly in a rolled-back dry run: CRLF on edit 1 gives `99dfa649`.
  - The same edits sent with LF give `c1f83b82` / `74d48db0`.
- **Fix:** `edit_once` now strips carriage returns from each edit before applying it (a `-- fixed:` line).
  - Reissued paste md5: `e6dad471`.
  - The lane migration carries the identical text (branch `cf247-d5-lane`).
- **Dry run of the reissued paste with CRLF simulated** (rolled back): both edits reached the expected md5s; 343 active matrix items, all keyed (310 true, 33 null).
- **Action:** the Platform Admin re-runs the reissued paste. Nothing is to be undone first.
