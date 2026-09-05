# M2.4.5 FOLLOW-UPS

| ID | Workstream | Item | Status | Next action |
|---|---|---|---|---|
| M245-FU-001 | H1 | Admin menu/submenu/UI standardisation | CLOSED / TARGETED PASS | CF-088; build 33700864619 PASS; deployed UAT 33700864824 PASS |
| M245-FU-002 | H2 | Scraper Config complete enable/disable/control surface | TARGETED PASS / PARSE.BOT AUTH BLOCKED | CF-089 UI/performance PASS; rotate valid Parse.bot API key then rerun connection probe |
| M245-FU-003 | H2 | Scraper routing/Layer config UX | PARTIAL / UI TARGETED PASS | No duplicate routing writer; Parse.bot generated API qualification remains blocked behind valid API key |
| M245-FU-004 | H3 | Scholarship grid/filter/order maturity | IMPLEMENTED / CF-208 ACCEPTANCE PENDING | Mature Scholarship catalogue already provides governed search, Country/Lifecycle/Publication filters, sort, pagination and detail; CF-208 source + deployed acceptance added. Close after CI/deployed PASS. |
| M245-FU-005 | H4 | Scheduler/Jobs operations | OPEN | Reconcile cron, scheduler RPCs, Jobs workspace, retries/lineage/telemetry |
| M245-FU-006 | H5 | Manual record creation across PIM | OPEN | Define entity capability matrix + rank/audit/evidence semantics |
| M245-FU-007 | H6 | Auto-publication + manual/mass controls | DESIGN REQUIRED | Keep disabled; design explicit safe enablement/preview/approval/rollback |
| M245-FU-008 | H7 | Production migration data/telemetry freshness | ACTIVE | Update migration manifest/snapshot after every material change |
| M245-FU-009 | H8 | Further Addenda/Bugs/Features | ACTIVE | Record each in WORK-ITEM-LEDGER with date/time and owning Change ID |
| M245-FU-010 | H9 | Faster UAT | OPEN | Audit current CI routing and remove unnecessary full-suite repeats |
| M245-FU-011 | H10 | Milestone meeting preparation | ACTIVE | Maintain achieved/failed/next, timeline, commits, UAT, runtime metrics |
| M245-FU-012 | H10 | Interaction/time evidence | ACTIVE | Record session timestamps; user-confirm billable hours separately |


| M245-FU-090 | Ranking import recovery | Recover already-uploaded THE 2026 Evidence through corrected Parse/validate service boundary, apply only after successful parser/reconciliation gate, then prove Statistics becomes data-backed | ACTIVE / TARGETED UAT | CF-090 |

| M245-FU-013 | H11 | Provider logo completeness & source discovery | OPEN / CF-091 | Build canonical Provider coverage matrix; first-party logos primary; evaluate Hotcourses sitemap/navigation as discovery/reconciliation only |
| M245-FU-014 | H12 | ARWU ranking integration | DESIGN/IMPLEMENTATION OPEN / CF-091 | Add ARWU 2025 + multi-year editioned ingestion, validation, Statistics card/history and Provider crosswalk |
| M245-FU-015 | H12 | University Diversity Index / HDI | DESIGN/IMPLEMENTATION OPEN / CF-091 | Define contextual dataset semantics, source/reuse authority, schema/read/UI and Provider/Compare presentation |
| M245-FU-016 | H13 | Ranking parser + API/Parse.bot dual acquisition | DESIGN/IMPLEMENTATION OPEN / CF-091 | Unify file-parser and API/Parse.bot paths into shared staging/validate/apply contract; edition/year replay + Evidence/cost telemetry |


## Priority override — 2026-09-03 12:59 AEST

| Priority | Workstream | Immediate action | Status |
|---|---|---|---|
| 1 | H11 | Build Provider/university logo coverage matrix and bounded first-party acquisition/promotion cohort; evaluate Hotcourses discovery gaps | ACTIVE NEXT |
| 2 | H12 | Implement ARWU 2025/multi-year and Diversity contextual dataset foundations, ingestion/read/UI contracts | QUEUED NEXT |
| 3 | H13 | Unify parser/API acquisition contract; proceed with file/parser path now; Parse.bot live path waits for valid credential | QUEUED NEXT / PARSE.BOT PARTIAL BLOCK |
| Parked | H2 | Remaining Parse.bot 401 qualification | PARKED UNTIL H13 LIVE API STEP |
| Parked | H3-H6 | Scholarship, Scheduler/Jobs, manual PIM, publication controls | OPEN / AFTER H13 |
| Continuous | H7-H10 | migration telemetry, work-item intake, UAT efficiency, meeting readiness | ACTIVE THROUGHOUT |


| M245-FU-017 | H13 / CF-092 | QS established Parse.bot API 2015–2026 | API QUALIFIED / BACKFILL PENDING | Implement bounded 2015–2026 QS fetch using year + pagination response metadata; retain Evidence/staging/completeness before Apply |
| M245-FU-018 | H13 / CF-092 | ARWU established Parse.bot API 2015–2026 | API QUALIFIED / BACKFILL PENDING | Implement controlled ARWU 2015–2026 fetch using year + snapshot v10; retain Evidence/staging/completeness before Apply |


## H11 execution update — 2026-09-03 13:39 AEST

| ID | Workstream | Item | Status | Next action |
|---|---|---|---|---|
| M245-FU-013A | H11 | Governed Provider asset coverage/read + Admin workspace | IMPLEMENTED / LIVE READ PASS / CI RUNNING | Close targeted source/deployed UAT; retain v2.15.48 evidence |
| M245-FU-013B | H11 | Final university-only denominator | OPEN / DATA MODEL GAP IDENTIFIED | Establish governed university/provider scope because current Provider Type is null across catalogue; do not label all active Providers universities |
| M245-FU-013C | H11 | Broad first-party logo acquisition | ACTIVE NEXT | Expand from current 7-Provider candidate cohort using first-party websites/shared L2 Evidence; prioritise missing AU/NZ university cohort; Hotcourses discovery only |


| M245-FU-019 | H12/H13 / CF-093 | Register QS 2026 via Admin Parse.bot URL import | READY / ADMIN SESSION REQUIRED | In authenticated Admin: QS → 2026 → Parse.bot URL → Parse import; review validation then Apply |
| M245-FU-020 | H12/H13 / CF-093 | Register ARWU 2026 via Admin Parse.bot URL import | READY / ADMIN SESSION REQUIRED | In authenticated Admin: ARWU → 2026 → Parse.bot URL → Parse import; review validation then Apply |

| M245-FU-021 | H12/H13 / CF-094 | Ranking recent-list refresh, success lock and duplicate-year warning | IMPLEMENTED / UAT ACTIVE | Confirm v2.15.50 deployed browser behaviour; then close |

| M245-FU-022 | H12/H13 / CF-095 | Release badge/version drift + QS 2027 unreadable Parse.bot error | CLOSED / TARGETED PASS | v2.15.51 deployed/current; QS defaults 2026; 2027 URL route blocked with readable upstream guidance |

| M245-FU-023 | H12/H13 / CF-096 | QS 2026 Parse.bot Evidence hand-off false Evidence-required error | CLOSED / TARGETED PASS | Import now validated; reconcile UTS + Victoria University review before Apply |

| M245-FU-024 | H12/H13 / CF-097 | Ranking workflow/job lineage and hidden THE history | CLOSED / TARGETED PASS | v2.15.53 restores all editions + Jobs; THE 2024–2015 ready for individual Apply; THE 2025/2026 review only |

| M245-FU-025 | H12/H13 / CF-098 | Reduce Parse.bot ranking API usage by supporting country/global publisher files | CLOSED / TARGETED PASS | File upload is primary; use Parse.bot only as optional metered fallback |

| M245-FU-026 | H12/H13 / CF-099 | Mobile multi-file ranking upload stopped after CORS preflight | IMPLEMENTED / DEPLOYED UAT PASS | Refresh to v2.15.55 and retry AU+NZ selection once; confirm acquisition Job/import registration |

| M245-FU-027 | H14 / CF-207 | External-consumer API key lifecycle + complete Wix handover versioning | OPEN / GOVERNED | Implement Administration → API Keys with create/rotate/expiry/disable/revoke, one-time Copy/Secure Handover, secret-free audit history and expiry enforcement; current Wix handover is `docs/integrations/coursefinder-wix-api-handover-v1.1.md` |
