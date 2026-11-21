# Continuous Delivery Master Plan

**Version:** 0.1 (draft for Platform Admin review)
**Drafted:** 21 Nov 2026 21:30 AEDT by Claude (S1-API-Frontend-Delivery), from the Platform Admin's Lane 1 brief of 21 Nov 2026 21:15 AEDT. The brief is the only source so far. Parts it does not cover are marked *to be confirmed*.
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
| 1 | Zoho API v3 export: TOEFL iBT, Cambridge CAE, DET and OET (`score_grade`, `subtest_grades`) columns on the course export (Z2); NZ and CA in `zoho.sync_countries` (Z3) | REQ-34, REQ-35 | In progress: s955 built, merging | Pilot #1465 |
| 2 | India app feedback backlog of 20 Nov: UI fixes, label corrections, endpoint adjustments; checked signed in on desktop and at 375 px | REQ-92 to REQ-108 | Not started | |
| 3 | Scholarship hygiene: 23 contradicting value notes; the last 3 text-only scholarships re-read; no expired scholarship marked open after the Melbourne-date round-state refresh | REQ-64, REQ-71, REQ-72 | Not started | |
| 4 | Pre-production acceptance: Australia page golden fixtures (one verified record per section, Admin and Website API v3); 10-provider QA including research scholarships | RM1K, REQ-59 | Not started | |
| 5 | Close the loop: registers, Drive `Monitoring` and `M3`, park | all of the above | Repeats after each item | |

## 5. Lane 2 status

Lane 2 (`S2-Data-Destination-Continuous`) works from the Platform Admin's brief of 21 Nov 2026 21:16 AEDT. The Platform Admin chose the first item at 21:19: AU rule drafts. Each item ships as one admin and Pilot pull request pair, live on deploy. Approving rules and publishing editions stay with the Platform Admin.

| # | Item | Roadmap / requests | Status | Releases |
|---|---|---|---|---|
| 1 | Australian rule drafts: application routes (RM1C), Home Affairs and Fair Work rules (RM1H), Hobart living costs (RM1I) | RM1C, RM1H, RM1I | RM1C: draft edition with 5 official routes (direct, agent, UAC NSW/ACT, VTAC VIC, SATAC SA/NT), state scope, $0 (s960); QTAC and TISC are gaps. RM1H: Home Affairs rules are published; the Fair Work minimum-wage edition is draft with terms restricted (Platform Admin). RM1I: no living-cost reader yet (next) | Pilot #1466 |
| 2 | Australian datasets waiting on the Platform Admin | RM1A, RM1D, RM1J | RM1A: the 1,953 CRICOS rows were applied on 17 Nov; 701 departures wait for approval. RM1D: JSA careers published (1,577 rows); QILT permission gates outcomes. RM1J: needs the THE 2027 file uploaded | |
| 3 | Human and rule queues; NZ and CA course-campus geography | RM1E, RM2A, RM4B, REQ-39, REQ-81 | Not started: 82 unset primary campuses and 5 central English items (a person), 28 ambiguous postcodes; NZQA and DLI geography; `struct-det` and `fid-det` drain checks | |
| 4 | NZ and CA recognition and classification | RM4A, RM4C, RM2B | Not started. NZQA reuse terms flagged for management | |
| 5 | Wave 2 sources: UK, Ireland, USA | RM3A, RM5A, RM6A | Not started. Needs an approved AI Auto-Map budget (this lane runs at $0 AI) | |
| 6 | Close the loop: registers, Drive `Monitoring` and `M3`, park | all | After each item | |

The `destination-abs-load`, `destination-climate-load` and `destination-page-facts-load` jobs are paused live. Static page facts are read on deploy by workflow "Destination page facts (static read)" ($0).

### Items handed between lanes

| Date | From | To | Item | State |
|---|---|---|---|---|
| 21 Nov 2026 | Lane 2 | Platform Admin | RM1C edition terms, approval and publish; RM1A 701 departures; RM1J THE 2027 file; Wave 2 AI Auto-Map budget | Waiting (IR-003 to IR-006) |

## 6. Status log

One line per session before it parks: date and time (AEDT), lane, what shipped (pull requests), what is next.

- 21 Nov 2026 21:30 AEDT, Lane 1: plan v0.1 drafted from the brief; standing rule added to `CLAUDE.md` and `AGENTS.md` in both repositories; `docs/integrations/INTERNAL-REQUESTS.csv` created. Next: item 1.
- 21 Nov 2026 22:00 AEDT, Lane 2: started; section 5 filled in; s960 RM1C application routes recorded before merge (Pilot #1466). Next: merge, static read on deploy, then RM1I living costs.
