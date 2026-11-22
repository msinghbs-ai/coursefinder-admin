# Continuous Delivery Master Plan

**Version:** 0.1 (draft for Platform Admin review)
**Drafted:** 21 Nov 2026 21:30 AEDT by Claude (S1-API-Frontend-Delivery), from the Platform Admin's Lane 1 brief of 21 Nov 2026 21:15 AEDT. The brief is the only source so far. Parts it does not cover are marked *to be confirmed*.
**Updated:** 22 Nov 2026 13:20 AEDT: Lane 1 item 6 (rankings) delivered for THE; QS access route waits on the Platform Admin (IR-011).
**Copies:** this file is the source of truth. Google Drive `M3 / CONTINUOUS-DELIVERY-MASTER-PLAN.md` is a mirror, refreshed whenever this file changes.

## 1. How every session uses this plan

1. **At start.** Read this plan after `docs/CURRENT-STATE.md` and `docs/README.md`. Find your lane in section 3 and keep to its touch boundaries.
2. **While working.** Work only on your lane's items, in the order given. If something belongs to another lane, record it in section 5 for that lane; do not change it yourself.
3. **Before parking.** Update your lane's status table (section 4) and add one line to the status log (section 6). Do it in the same admin pull request that records the release, then refresh the Drive `M3` copy.

The standing rule "Continuous Delivery Master Plan" in `CLAUDE.md` and `AGENTS.md` (both repositories) makes this mandatory.

## 2. Mandates that apply to every lane

These repeat the rules in `CLAUDE.md`, which win if the two ever differ.

| Mandate | What it means |
|---|---|
| No `.zip` hand-offs | Everything lands through pull requests merged by the `automerge` label. |
| Immediate live activation | Fixes take effect on deploy: no unrequested shadow mode, off-by-default flag or delayed cutover. |
| Repo first, admin first | Rebase onto `origin/main` in both repositories. Claim spec and migration numbers above every existing and open one. Re-check the live migration head right before merge. Merge `coursefinder-admin` first, then Pilot, on green CI and a passing rolled-back `live-dry-run`. Delete throwaway branches. |
| Migration collisions | If another lane has a `live-dry-run` running in GitHub Actions, wait for it to finish (up to 15 to 20 minutes) before claiming the next migration number. |
| Guardrails | G3 consumer API frozen at 75 functions / 48 tables with no drift; 7,585 manual locks untouched; active cron jobs ≤ 140, none unregistered; $0 unapproved AI and $0 Firecrawl. |
| Live lookups and keys | No hard-coded provider lists, country arrays, intake years or API version cards. One key per (consumer, API version). |
| Closed-loop records | Before parking: request registers, `ROADMAP-ENGAGEMENTS.csv`, `TEST-REGISTER.md`, `CURRENT-STATE.md`, this plan, and the Drive `Monitoring` sync (engagements, hours summary, latest-only backup pair). |

## 3. Lanes and touch boundaries

| Lane | Chat | Owns (may change) | Must not change |
|---|---|---|---|
| **Lane 1: API and front end delivery** | `S1-API-Frontend-Delivery` | `zoho-api-v3` export views and functions; Admin and front-end UI components; `docs/integrations/`; `docs/platform/`; test fixtures; register CSVs and documents | Layer 1 adapters and sources; `destination.*` tables; the background deterministic sweep workers (`aer`, `elr`, `fid`, `struct`) |
| **Lane 2: data and destination (continuous)** | `S2-Data-Destination-Continuous` | Layer 1 adapters and sources; `destination.*` tables; the deterministic sweep workers (`aer`, `elr`, `fid`, `struct`) | Lane 1's areas (*to be confirmed by the Platform Admin*) |

Other lanes: *to be confirmed*. A session that is not named here asks the Platform Admin which lane it is in before changing anything.

## 4. Lane 1 delivery sequence and status

Order of work: each item ships as one admin and Pilot pull request pair, live on deploy.

| # | Item | Requests | Status | Releases |
|---|---|---|---|---|
| 1 | Zoho API v3 export: TOEFL iBT, Cambridge CAE, DET and OET (`score_grade`, `subtest_grades`) columns on the course export (Z2); NZ and CA in `zoho.sync_countries` (Z3) | REQ-34, REQ-35 | Done 21 Nov 22:50 (REQ-34 Live in v3, REQ-35 Delivered) | Pilot #1465, admin #766 |
| 2 | India app feedback backlog of 20 Nov: UI fixes, label corrections, endpoint adjustments; checked signed in on desktop and at 375 px | REQ-92 to REQ-108 | In progress: 12 of 17 Delivered (REQ-92, 93, 96, 97, 98, 100, 101, 102, 103, 104, 106, 107); next REQ-105 (Courses load 3 to 8 s: cache the filter catalogue); REQ-94, 95, 99 with Lane 2; REQ-108 waits on scope | Pilot #1467 to #1471 |
| 3 | Scholarship hygiene: 23 contradicting value notes; the last 3 text-only scholarships re-read; no expired scholarship marked open after the Melbourne-date round-state refresh | REQ-64, REQ-71, REQ-72 | Done 22 Nov 02:15: 28 values by the rule upper figure marked up to (REQ-64 Delivered); 0 text-only; 0 expired open | Pilot #1470 |
| 4 | Pre-production acceptance: Australia page golden fixtures (one verified record per section, Admin and Website API v3); 10-provider QA including research scholarships | RM1K, REQ-59 | In progress: acceptance read done (every section served by v3, `docs/platform/2026-11-22-rm1k-australia-golden-acceptance.md`); next a deployed spec of the golden records; 10-provider QA waits on Saurabh and Sujata's list and pass criteria | admin docs |
| 5 | Close the loop: registers, Drive `Monitoring` and `M3`, park | all of the above | Repeats after each item | |
| 6 | Rankings: automated Layer 1 readers for THE and QS World University Rankings from the publishers' public JSON, published live with attribution; no publisher file or terms hold (Platform Admin 22 Nov 2026 09:22). Taken from Lane 2 on the Platform Admin's instruction | IR-005, RM1J, REQ-91 | THE delivered live 22 Nov 00:49 UTC: THE 2027 public and attributed, 3,146 rows, 77 AU/NZ/CA linked; REQ-91 Delivered. QS reader live but every read met a Cloudflare challenge (no bypass); uploaded QS 2027 stays published; access route waits on the Platform Admin (IR-011) | Pilot #1473 to #1476, s970 |

## 5. Lane 2 status

Lane 2 (`S2-Data-Destination-Continuous`) works from the Platform Admin's brief of 21 Nov 2026 21:16 AEDT. The Platform Admin chose the first item at 21:19: AU rule drafts. Each item ships as one admin and Pilot pull request pair, live on deploy. Approving rules and publishing editions stay with the Platform Admin.

| # | Item | Roadmap / requests | Status | Releases |
|---|---|---|---|---|
| 1 | Australian rule drafts: application routes (RM1C), Home Affairs and Fair Work rules (RM1H), Hobart living costs (RM1I) | RM1C, RM1H, RM1I | RM1C: **live as drafts** 21 Nov 22:40, 5 official routes (direct, agent, UAC NSW/ACT, VTAC VIC, SATAC SA/NT) with state scope, $0 (s960); waiting for the Platform Admin to set terms and publish (IR-003); QTAC and TISC are gaps (IR-007). RM1H: Home Affairs rules are published; the Fair Work minimum-wage edition is draft with terms restricted (Platform Admin). RM1I: IR-008 approved 22 Nov 00:11; 75 draft Tasmania-wide weekly living-cost figures from Migration Tasmania (15 for each of 5 Tasmanian localities), **live as drafts** 22 Nov 01:40, $0 (s965); waiting for the Platform Admin to sign off terms and approve | Pilot #1466 (`de3ddba5`), admin #767; Pilot #1472 (`34e31e05`), admin #774 |
| 2 | Australian datasets waiting on the Platform Admin | RM1A, RM1D, RM1J | RM1A: the 1,953 CRICOS rows were applied on 17 Nov; 701 departures wait for approval. RM1D: JSA careers published (1,577 rows); QILT permission gates outcomes. RM1J: taken by Lane 1 on 22 Nov (Platform Admin 09:22: automated THE and QS readers, no upload; s966) | |
| 3 | Human and rule queues; NZ and CA course-campus geography | RM1E, RM2A, RM4B, REQ-39, REQ-81 | Audited 22 Nov (read-only): nothing rule-resolvable at $0. 82 primary-campus ties (all multi-campus), 160 postcodes and 69 waiting campuses, and 5 English readings are for a person (IR-010). NZ 2,692 of 6,514 and CA 2,290 of 3,825 courses have a campus; the rest carry reasons (mostly not published by the provider), and the NZQA and DLI registers do not link courses to sites (IR-009). `fid-det` running; `struct-det` has read what it holds | `docs/platform/2026-11-22-lane2-item3-queues-and-nz-ca-geography-audit.md` |
| 4 | NZ and CA recognition and classification | RM4A, RM4C, RM2B | Not started. NZQA reuse terms flagged for management | |
| 5 | Wave 2 sources: UK, Ireland, USA | RM3A, RM5A, RM6A | Not started. Needs an approved AI Auto-Map budget (this lane runs at $0 AI) | |
| 6 | Close the loop: registers, Drive `Monitoring` and `M3`, park | all | After each item | |

The `destination-abs-load`, `destination-climate-load` and `destination-page-facts-load` jobs are paused live. Static page facts are read on deploy by workflow "Destination page facts (static read)" ($0).

### Items handed between lanes

| Date | From | To | Item | State |
|---|---|---|---|---|
| 22 Nov 2026 | Lane 1 | Platform Admin | IR-011: QS access route for the public reader (QS API key or allowlisting, or continued upload); the reader never bypasses a challenge | Waiting |
| 22 Nov 2026 | Platform Admin | Lane 1 | IR-005 / RM1J: THE and QS rankings as attributed public data, read by automated Layer 1 readers (a Layer 1 item, done by Lane 1 on the Platform Admin's instruction of 09:22); the THE 2027 upload request is withdrawn | Done for THE (live); QS waits on IR-011 |
| 22 Nov 2026 | Lane 2 | Platform Admin | RM1C edition terms, approval and publish (IR-003); RM1A 701 departures (IR-004); RM1J THE 2027 file (IR-005); Wave 2 AI budget, $0 this cycle (IR-006); RM1I figures terms and approval; NZ and CA course-campus decision (IR-009); person queues (IR-010) | Waiting |
| 21 Nov 2026 | Lane 1 | Lane 2 | REQ-94 (course-level entry rows for providers missing from Course entry requirements), REQ-95 (scholarship pages for providers with none published), REQ-99 (accepted English tests missing on courses): data work | Open |
| 21 Nov 2026 | Lane 1 | Lane 2 | OET letter grades (`score_grade`, `subtest_grades`): none stored yet; the Zoho v3 export columns are ready (REQ-34) | Open |
| 21 Nov 2026 | Lane 1 | Platform Admin | REQ-108 premium placement statistics: scope and priority | Waiting |

## 6. Status log

One line per session before it parks: date and time (AEDT), lane, what shipped (pull requests), what is next.

- 21 Nov 2026 21:30 AEDT, Lane 1: plan v0.1 drafted from the brief; standing rule added to `CLAUDE.md` and `AGENTS.md` in both repositories; `docs/integrations/INTERNAL-REQUESTS.csv` created. Next: item 1.
- 21 Nov 2026 22:00 AEDT, Lane 2: started; section 5 filled in; s960 RM1C application routes recorded before merge (Pilot #1466). Next: merge, static read on deploy, then RM1I living costs.
- 21 Nov 2026 22:50 AEDT, Lane 2: s960 live (admin #767, Pilot #1466 `de3ddba5`): 5 RM1C routes are draft rules with state scope, read at $0; RM1I needs a source decision (IR-008). Parked. Next: item 3 (queues and NZ/CA geography) while IR-003 and IR-008 wait.
- 21 Nov 2026 22:55 AEDT, Lane 1: item 1 done (s955 live, admin #766, Pilot #1465 `ffb11140`; REQ-34 Live in v3, REQ-35 Delivered). Item 2 first part s956 (Pilot #1467, v2.16.79) merging. Next: REQ-93, 96, 98, 100, 104, 105.
- 22 Nov 2026 00:05 AEDT, Lane 1: s956 live (v2.16.79, Pilot #1467 `12cafeee`; migration renumbered to `20261122050000` after Lane 2's s960 took `20261122040000`). s957 (Pilot #1468, v2.16.80) merging. Next: REQ-100, REQ-105.
- 22 Nov 2026 01:00 AEDT, Lane 1: s957 live (v2.16.80, Pilot #1468 `46b2319f`): REQ-93, 96, 98, 104 Delivered. s958 (Pilot #1469, v2.16.81, REQ-100) merging. Next: REQ-105, then item 3.
- 22 Nov 2026 01:40 AEDT, Lane 1: s958 live (v2.16.81, Pilot #1469 `088736a1`); s959 (Pilot #1470, v2.16.82: item 3 and the one-page level fix) merging. Next: item 4 (needs Saurabh and Sujata's 10-provider list and pass criteria, REQ-59).
- 22 Nov 2026 02:20 AEDT, Lane 1: s959 live (Pilot #1470 `cb4b33a4`): item 3 done. RM1K acceptance read done. v2.16.83 (Pilot #1471, Entry levels in one list) merging. Next: the RM1K deployed spec; REQ-105 (Courses load); REQ-59 when its list arrives.
- 22 Nov 2026 01:00 AEDT, Lane 2: IR-008 approved; s965 RM1I Tasmania-wide living costs as 75 draft figures recorded before merge (Pilot #1472); item 3 audited, nothing rule-resolvable at $0 (IR-009, IR-010).
- 22 Nov 2026 02:45 AEDT, Lane 1: v2.16.83 live (Pilot #1471 `7aead3bf`): REQ-100 Delivered. Parked. Next session, in order: REQ-105 (Courses load), the RM1K deployed spec, REQ-59 once its list arrives; REQ-108 waits on the Platform Admin's scope.
- 22 Nov 2026 01:45 AEDT, Lane 2: s965 live (admin #774, Pilot #1472 `34e31e05`): 75 draft Tasmania-wide living-cost figures read back; parked. Next: item 4 (NZQCF, NZSCED, CIP).
- 22 Nov 2026 10:20 AEDT, Lane 1: Platform Admin 09:22 decision on rankings recorded (standing rule "Attributed Public Rankings (THE and QS)" in `CLAUDE.md` and `AGENTS.md`, both repositories); s966 (THE and QS public readers, `ranking-layer1-etl` v1.8.0, migration `20261122110000`) recorded before merge. Next: merge, the initial runs on deploy, read back on Website v3.
- 22 Nov 2026 13:20 AEDT, Lane 1: item 6 delivered for THE (s966 to s969 live, Pilot #1473 to #1476): THE 2027 public and attributed, 3,146 rows, 77 AU/NZ/CA linked; QS public read challenged by Cloudflare on every read (no bypass), uploaded QS 2027 stays live (IR-011 for the Platform Admin); s970 (preview skipped on apply) merging. Next session: REQ-105 (Courses load), the RM1K deployed spec, REQ-59 when its list arrives.
