# M2.4.5 FOLLOW-UPS

| ID | Workstream | Item | Status | Next action |
|---|---|---|---|---|
| M245-FU-029 | Architectural hardening / CF-241 | Four-phase tooling/typing/domain/PIM hardening + forward CF-239 runtime reconciliation | CLOSED / PASS | CF-CHG-20260908-244; accepted Pilot `4a927057e86935f8c5e101e434355da0b8f9bf7d`; post-merge build `34224432855` PASS; deployed UAT `34224432694` PASS. Production unchanged. |
| M245-FU-028 | UI improvements / CF-242 | Scholarship Provider filter; fluid/sortable Scholarship/QILT/PRISMS/QS/THE datasets; Provider Compare latest/history/sticky identity; v2.15.73 currentness | CLOSED / PASS | Accepted head `82e1f13cd37508bec314bfbf882ecdcb4a89183c`; bounded `34093001623` PASS; deployed currentness `34093765349` PASS. CF-241 subsequently CLOSED/PASS under CF-244; Production unchanged. |
| M245-FU-001 | H1 | Admin menu/submenu/UI standardisation | CLOSED / TARGETED PASS | CF-088; build 33700864619 PASS; deployed UAT 33700864824 PASS |
| M245-FU-002 | H2 | Scraper Config complete enable/disable/control surface | TARGETED PASS | CF-089 UI/performance PASS; established QS/ARWU Parse.bot APIs were later authenticated/qualified under H13. Reopen only for a current control-surface defect. |
| M245-FU-003 | H2 | Scraper routing/Layer config UX | PARTIAL / UI TARGETED PASS | No duplicate routing writer; retain governed workload/profile separation. Any remaining generic adapter qualification belongs to H13 rather than reopening H2 by default. |
| M245-FU-004 | H3 | Scholarship grid/filter/order maturity | CLOSED / TARGETED PASS | CF-208; build 33950428195 PASS; deployed UAT 33950428173 PASS. |
| M245-FU-005 | H4 | Scheduler/Jobs operations | CLOSED / TARGETED PASS | CF-209; build 33950842781 PASS; deployed UAT 33950842779 PASS. Existing bounded scheduler/15-minute Layer 2 dispatcher, stale recovery, non-destructive housekeeping and server-paged Jobs telemetry accepted; generic retry/replay/reset remains intentionally disabled. |
| M245-FU-006 | H5 | Manual record creation across PIM | CLOSED / ACCEPTED / CF-211 | Source-backed Provider/Course/Campus/Scholarship candidate workflow accepted on canonical detail/Layer 4 surface; rank 5+, source/Evidence backed, no direct canonical writer, no publication side effect. Dedicated primary navigation not required. Accepted in visible Admin v2.15.66. |
| M245-FU-007 | H6 | Auto-publication + manual/mass controls | CLOSED / ACCEPTED / CF-211 | Preview → confirm → execute + rollback accepted for target-scoped manual decisions; automatic publication remains disabled; Search/API, Website, Zoho and Production cutover remain separately governed. Accepted in visible Admin v2.15.66. |
| M245-FU-008 | H7 | Production migration data/telemetry freshness | ACTIVE | Update migration manifest/snapshot after every material change |
| M245-FU-009 | H8 | Further Addenda/Bugs/Features | ACTIVE | Record each in WORK-ITEM-LEDGER with date/time and owning Change ID |
| M245-FU-010 | H9 | Faster UAT | OPEN | Audit current CI routing and remove unnecessary full-suite repeats |
| M245-FU-011 | H10 | Milestone meeting preparation | ACTIVE | Maintain achieved/failed/next, timeline, commits, UAT, runtime metrics |
| M245-FU-012 | H10 | Interaction/time evidence | ACTIVE | Record session timestamps; user-confirm billable hours separately |

| M245-FU-090 | Ranking import recovery | Recover already-uploaded THE 2026 Evidence through corrected Parse/validate service boundary, apply only after successful parser/reconciliation gate, then prove Statistics becomes data-backed | ACTIVE / TARGETED UAT | CF-090 |

| M245-FU-013 | H11 | Provider logo completeness & source discovery | CLOSED / PASS / CF-101 + CF-102 | Governed AU/NZ university cohort is 41 AU + 8 NZ with 49/49 approved primary logos. Provider/Course/Compare visual consumption and authenticated private-asset access accepted; reopen only for a new defect/freshness requirement. |
| M245-FU-014 | H12 | ARWU ranking integration | DESIGN/IMPLEMENTATION OPEN / CF-091 | **ACTIVE NEXT:** reconcile current implementation/runtime first, then complete ARWU editioned ingestion/read/UI and bounded AU/NZ real-data proof without duplicating already implemented CF-093–100 foundations. |
| M245-FU-015 | H12 | University Diversity Index / HDI | DESIGN/IMPLEMENTATION OPEN / CF-091 | Define/confirm contextual dataset source/reuse authority, schema/read/UI and Provider/Compare presentation; keep separate from QS/THE/ARWU ranking semantics. |
| M245-FU-016 | H13 | Ranking parser + API/Parse.bot dual acquisition | PARTIAL / ADAPTER FOUNDATION PASS | File-first parser, multi-file transport, same-edition country extension and established QS/ARWU Parse.bot APIs are implemented/qualified through CF-092–100; bounded historical backfill/replay remains pending. |

## Priority reconciliation — 8 September 2026

| Priority | Workstream | Immediate action | Status |
|---|---|---|---|
| Closed | H11 | Provider/university logo completeness and visual-consumption follow-through | CLOSED / PASS — 49/49 under CF-101/102 |
| 1 | H12 | Reconcile current ARWU implementation, then complete ARWU editioned real-data proof and separate Diversity contextual dataset semantics/read/UI | ACTIVE NEXT |
| 2 | H13 | Complete bounded 2015–2026 ranking backfill/replay using existing file/API foundations; retain Evidence/manual Apply | QUEUED NEXT |
| Continuous | H7-H10 | migration telemetry, work-item intake, UAT efficiency, meeting readiness | ACTIVE THROUGHOUT |
| Closed | H3-H6 | Scholarship/Scheduler/Jobs/manual PIM/publication controls | CLOSED / ACCEPTED |

| M245-FU-017 | H13 / CF-092 | QS established Parse.bot API 2015–2026 | API QUALIFIED / BACKFILL PENDING | Implement bounded 2015–2026 QS fetch using year + pagination response metadata; retain Evidence/staging/completeness before Apply |
| M245-FU-018 | H13 / CF-092 | ARWU established Parse.bot API 2015–2026 | API QUALIFIED / BACKFILL PENDING | Implement controlled ARWU 2015–2026 fetch using year + snapshot v10; retain Evidence/staging/completeness before Apply |

## H11 closure reconciliation — 8 September 2026

| ID | Workstream | Item | Status | Evidence |
|---|---|---|---|---|
| M245-FU-013A | H11 | Governed Provider asset coverage/read + Admin workspace | CLOSED / PASS | CF-101/102; final H11 build `33802561372` PASS; deployed H11 UAT `33802561541` PASS |
| M245-FU-013B | H11 | Final university-only denominator | CLOSED / PASS | Governed cohort established as 41 AU + 8 NZ universities; 49/49 primary-logo coverage |
| M245-FU-013C | H11 | Broad first-party/logo acquisition & fallback reconciliation | CLOSED / PASS | 49/49 approved primaries; Hotcourses/IDP own-brand/placeholders rejected; authenticated private-asset display accepted under CF-102 |

| M245-FU-019 | H12/H13 / CF-093 | Register QS 2026 via Admin Parse.bot URL import | READY / ADMIN SESSION REQUIRED | In authenticated Admin: QS → 2026 → Parse.bot URL → Parse import; review validation then Apply |
| M245-FU-020 | H12/H13 / CF-093 | Register ARWU 2026 via Admin Parse.bot URL import | READY / ADMIN SESSION REQUIRED | In authenticated Admin: ARWU → 2026 → Parse.bot URL → Parse import; review validation then Apply |
| M245-FU-021 | H12/H13 / CF-094 | Ranking recent-list refresh, success lock and duplicate-year warning | IMPLEMENTED / UAT ACTIVE | Confirm v2.15.50 deployed browser behaviour; then close |
| M245-FU-022 | H12/H13 / CF-095 | Release badge/version drift + QS 2027 unreadable Parse.bot error | CLOSED / TARGETED PASS | v2.15.51 deployed/current; QS defaults 2026; 2027 URL route blocked with readable upstream guidance |
| M245-FU-023 | H12/H13 / CF-096 | QS 2026 Parse.bot Evidence hand-off false Evidence-required error | CLOSED / TARGETED PASS | Import now validated; reconcile UTS + Victoria University review before Apply |
| M245-FU-024 | H12/H13 / CF-097 | Ranking workflow/job lineage and hidden THE history | CLOSED / TARGETED PASS | v2.15.53 restores all editions + Jobs; THE 2024–2015 ready for individual Apply; THE 2025/2026 review only |
| M245-FU-025 | H12/H13 / CF-098 | Reduce Parse.bot ranking API usage by supporting country/global publisher files | CLOSED / TARGETED PASS | File upload is primary; use Parse.bot only as optional metered fallback |
| M245-FU-026 | H12/H13 / CF-099 | Mobile multi-file ranking upload stopped after CORS preflight | IMPLEMENTED / DEPLOYED UAT PASS | Refresh to v2.15.55 and retry AU+NZ selection once; confirm acquisition Job/import registration |
| M245-FU-027 | H14 / CF-207 | External-consumer API key lifecycle + complete Wix handover versioning | OPEN / GOVERNED | Implement Administration → API Keys with create/rotate/expiry/disable/revoke, one-time Copy/Secure Handover, secret-free audit history and expiry enforcement; current Wix handover is `docs/integrations/coursefinder-wix-api-handover-v1.1.md` |
