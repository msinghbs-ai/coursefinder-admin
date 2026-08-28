# M2.4.2 — Follow-ups

## Active carry-forward

| ID | Origin | Item | Impact / risk | Next action | Target | Status |
|---|---|---|---|---|---|---|
| M24-FU-002 | M2.3 | NZ first-party Layer 2 Course enrichment remains deferred pending source qualification/onboarding. | False coverage claim / authority breach if ignored. | Preserve explicit NZ deferral in scope, UI, docs and UAT. | Future governed NZ L2 gate | DEFERRED |
| M24-FU-005 | M2.4 | Capture full-run Layer 2 performance, provider economics, Evidence growth and Layer 3 fall-out before tuning schedules/concurrency. | Performance/cost tuning would otherwise be assumption-based. | Baseline then execute representative/full authorised AU run and retain metrics. | M2.4.2 | ACTIVE / PRIORITY |
| M24-FU-006 | M2.4 | Layer 2 alerts for stuck jobs, stale sources, provider quota/spend and abnormal behaviour. | Operational failures may remain invisible. | Preserve computed stale-run/paused/blocked/failure-streak/quota alerts through Stage B/final security regression. | M2.4.2/4 | IMPLEMENTED / UAT PASS INPUT |
| M24-FU-007 | M2.4 | Guides, Runbooks, release notes and state files must match deployed behaviour. | Operator/documentation drift. | Update as implementation becomes accepted. | Every sub-milestone | STANDING |
| M24-FU-004 | M2.4.1/4 | Layer 1 housekeeping accepted; cross-layer housekeeping remains for later consolidation. | L2 cleanup must not delete governed Evidence/history. | M2.4.2 recovery-only housekeeping is implemented and verified zero-delete for governed history; preserve cross-layer consolidation for M2.4.4. | M2.4.2/4 | L2 PASS / CONSOLIDATION CARRY-FORWARD |

## M2.4.2 discoveries

| ID | Problem / decision | Evidence | Owner | Next action | Status |
|---|---|---|---|---|---|
| M242-FU-001 | Deployed Layer 2 operational run model is still trial-scale at milestone start: 1 batch / 3 items despite 103 provider attempts. | Start reconciliation 27 Aug 2026. | M2.4.2 | Mature orchestration/visibility before full-run claim. | ACTIVE |
| M242-FU-002 | Ordered routing, terminal states and controlled Direct → Firecrawl fallback are proven. | Job `cf96948e-9103-4afd-ad05-377df5ca267c`: Direct HTTP 404 attempt 1 → Firecrawl 200/succeeded attempt 2; temporary 404 fallback restored immediately. | M2.4.2 | Preserve route-order/fallback proof in Stage B/full-run evidence; test next-provider only if Firecrawl failure is observed or a safe bounded diagnostic is needed. | TARGETED PASS |
| M242-FU-003 | Country / State / University scope resolution and routine-screen cleanup are implemented and targeted deployed UAT passes. | AU=1,072/3; VIC=690/2; QLD=404/2; RMIT=500/1; UAT `33016596722`. | M2.4.2 | Preserve in Stage B/mobile and full-run evidence; refine only from measured operator/runtime evidence. | TARGETED PASS / STAGE B OPEN |



| M242-FU-004 | UQ full-run deterministic enrichment is now proven end-to-end for 153/156 governed URLs; three Courses remain explicit Layer 3 fall-out. | UQ discovery 382/382; managed batch `eb52b6e2-c33b-4dfc-9e87-c107834218e0`; canonical apply 153/153; vendor cost USD 0. | M2.4.2 | Preserve 3 Layer 3 exceptions; use UQ run for performance/Evidence/economics baseline and Stage B evidence. | FULL-RUN PASS / ACCEPTANCE INPUT |
| M242-FU-005 | Federation deterministic discovery remains source-limited after full 190-Course evaluation; only 10 identity-verified governed URLs are currently queueable. | 190/190 evaluated; 10 governed URL seeds; 180 source-limited. | M2.4.2 | Enrich/apply the 10 governed Courses; preserve the remaining 180 as explicit source limitation unless a separately qualified first-party mapping source is accepted. | ACTIVE / SOURCE-LIMITED |
| M242-FU-006 | RMIT full discovery is authorised after BP350 control passed with detail-path and Honours disambiguation guards. | RMIT control CRICOS `110982H` → BP350 selected under worker v1.2.4; full request `2138` started for remaining 499 Courses. | M2.4.2 | Complete bounded RMIT discovery, validate URL identity/duplicates/provider economics, then managed enrich/apply only governed selections. | ACTIVE / PRIORITY |
| M242-FU-007 | Cancellation/recovery exposed stale-wave continuation and terminal-state resurrection risks; both were corrected. | Representative cancelled UQ batch `7fe8446f-f480-4e2e-a901-2b73952ad323`; permanent rollback-only deployed contract now proves cancel-during-wave + late reconcile and stale recovery, with no retained test state. | M2.4.2 | Preserve this contract in Stage B/final acceptance. | CLOSED / REGRESSION PASS |
| M242-FU-008 | Layer 2 Course apply contract emitted `TOEFL` while accepted reference data uses `TOEFL_IBT`. | First 153-record UQ apply failed transactionally with no partial mutation; mapping corrected and second apply passed 153/153. Live regression confirms TOEFL_IBT exists, legacy TOEFL does not, apply function maps TOEFL→TOEFL_IBT and remains service-only. | M2.4.2 | Preserve in final acceptance. | CLOSED / REGRESSION PASS |

## Rule

Do not close an item merely because independent M2.4.2 work can continue. Record exact runtime/commit/UAT evidence as it becomes available.
| M242-FU-009 | RMIT title-only search selection mapped legacy/current CRICOS records to the same current Course page; those selections are unsafe. | BH079: `079626B` + `110997A`; BH077: `079625C` + `110995C`. | M2.4.2 | Supersede all pre-v1.3.0 RMIT terminal decisions; require detail-page CRICOS verification before selection; rerun broad RMIT scope. | FIXED CONTRACT / FULL RERUN OPEN |
| M242-FU-010 | Detail-page CRICOS verifier must prove both positive and negative identity before broad RMIT restart. | Request `2164`: current `110997A` selected BH079 with verification Evidence; legacy `079626B` rejected. | M2.4.2 | Preserve permanent UAT/source mirror, then bounded broad rerun under v1.3.0. | TARGETED PASS |
| M242-FU-011 | Layer 2 Course refresh had generic request creation but no Course-profile dispatcher/reconciler. | New disabled profile policies + `layer2_refresh_scheduler_tick_impl`; dry-run 0/0. | M2.4.2 | Enable only accepted executable profiles after full-run metrics; keep Federation disabled/paused while source-limited. | SUBSTRATE PASS / ENABLEMENT OPEN |
| M242-FU-012 | Stale L2 jobs/provider attempts and quota/failure/stale-run conditions required governed operations handling. | Recovery-only housekeeping cron/manual PASS; computed rank-4 alerts surfaced in existing blockers panel; targeted UAT `33027788662` PASS; anon/rank-3 negatives PASS. | M2.4.2 | Preserve in Stage B and final advisor/ACL regression. | TARGETED PASS / FINAL REGRESSION OPEN |

| M242-FU-013 | A10 paged-filter/tablet-focus contract is platform-wide; M2.4.2 implements Layer 2 scope + Course filters first. | Pilot `f8e743c4...`; UAT `33030713534`; build `33030713535`; PIM decisions v1.17. | M2+ | Migrate any remaining large eager-loaded Provider/University/Campus/QILT/PRISMS/Evidence selectors to the shared 10-item server-paged pattern before their next acceptance gate. | TARGETED PASS / PLATFORM ROLLOUT CARRY-FORWARD |

| M242-FU-014 | A10 current large dynamic filter rollout | Course, Layer 2, Evidence, QILT, PRISMS moved to the shared 10-item server-paged contract; CI gate added. | M2.4.2 | Keep A10 as standing platform rule for any newly introduced >10-option domain. | CLOSED / PASS — Pilot `656999ef...`, UAT `33031938406`, build `33031938398` |

| M242-FU-015 | RMIT Inbound Internship source-limited residual | CRICOS 091377B and 091378A have no accepted current first-party Course page under the RMIT `/study-with-us/levels-of-study/` profile; separate inbound RMIT material exists but does not satisfy the current Course identity/page contract. | M2.4.2 / future source qualification | Qualify a separate first-party inbound-programme source/profile only if these non-award records must be enriched; do not weaken the current RMIT Course URL prefix. | OPEN / SOURCE-LIMITED |

| M242-FU-016 | RMIT canonical promotion gate | Frozen runtime set re-proved from terminal batches as 212 distinct `resolved_l2` source URLs → 212 latest provider `00122A` source records; 212/212 identity-matched, 0 unsafe, 0 applied; frozen ID-set fingerprint `627bb7daa62fe3bbfc3047ce2b57a88e`. The apply RPC remains executable only by `postgres`/`service_role`. Current governed Edge inventory has no exact frozen-set promotion executor; legacy `coursefacts-au-rmit` is a separate two-record source worker and is not valid for this set. The ChatGPT Supabase connector blocks invoking the apply-capable RPC even with `p_apply=false`; no bypass was created. | M2.4.2 / follow-on authorised executor | Keep RMIT refresh disabled. Execute dry-run → identical apply → Search/Publication=false proof only when an already authorised service/CI executor is available; do not create a privileged bypass solely for connector convenience. | FORMALLY BLOCKED / NO AUTHORISED EXECUTOR AVAILABLE IN CURRENT GOVERNED PATH |

| M242-FU-017 | AU/NZ Layer 2 scale-out strategy | UQ/RMIT/Federation evidence shows bespoke university-by-university engineering will not scale; the platform now has enough evidence to define a reusable qualification and exception model. | M2.4.2 / follow-on AU-NZ rollout | Adopt sample → qualify → automated full discovery/enrichment → safe promotion → L3/L4 exception handoff. Process AU in multi-university waves; qualify 2–3 NZ source patterns against NZQA before NZ wave rollout. Preserve 100% identity safety for auto-selection/promotion; accept explicit source-limited/ambiguous/L3/L4 outcomes rather than weakening rules. | ACCEPTED STRATEGY / IMPLEMENTATION NEXT |

| M242-FU-018 | Full Layer 1 catalogue exposure + A11 qualification-wave POC | Layer 2 selector scope previously came only from executable profiles, hiding most Layer 1 providers/states/countries. Live A11 now exposes AU 1,546/26,648, CA 82/10,356, NZ 286/6,457; AU 8 subdivisions, CA 10, NZ 0 due current L1 subdivision linkage. Cross-country 5-provider × 10-Course qualification waves created with canonical/Search/Publication=false; second AU wave proved 0 provider overlap. | M2.4.2 | Connect planned qualification items to governed deterministic acquisition/Evidence, classify source-pattern success/fall-out, auto-create/promote reusable L2 profiles only after identity-safe qualification, then exercise multi-university full-run wave. | POC PASS / EXECUTION EVIDENCE NEXT |

| M242-FU-019 | Layer 3 source-pattern interpretation handoff | Dedicated source-pattern profile/task is implemented and isolated. Best Nemotron benchmark `579a52d5...` reached 3/4 live + 3/3 controls at USD 0 but retained one empty completion; alternate `openai/gpt-oss-20b:free` returned runtime 404. Profile remains paused and 8 requests remain blocked. | Layer 3 / M2.4.2 handoff | Qualify a reliable specific model without lowering the 4/4 live + 3/3 control threshold. Only after PASS may candidates return to Layer 2 3/3 identity controls. | BLOCKED / MODEL RELIABILITY-AVAILABILITY |
| M242-FU-020 | Provider source-seed resolution | A11 produced 7 provider-level source-limited cases: AU Adelaide, CA five-provider POC cohort, NZ Auckland. Missing/malformed Layer 1 provider website data prevented safe Layer 2 qualification. | Layer 4 / Layer 1 data quality | Resolve and verify first-party Provider Course source seeds; do not guess or manufacture URLs. Re-enter resolved providers into a later A11 qualification wave. | OPEN / CROSS-LAYER |

| M242-FU-021 | A12 contextual insight integration | Provider/Course detail now receives bounded Student outcomes / International student flow / Scholarships context behind `admin_read`; RMIT Provider returns 36 QILT + 452 VIC PRISMS context + 3 Scholarships, representative RMIT Course returns Provider-context outcomes + governed Scholarships while PRISMS remains explicitly not mapped. | M2.4.2 | Preserve A12 in Stage B/final acceptance and country-counterpart rollout. Do not relabel Provider/regional data as Course facts. | TARGETED PASS — UAT `33080519873`, Pilot `c58cff17…` |

| M242-FU-022 | Layer 2 refresh-policy acceptance split | Live policy reconciliation shows UQ weekly Course refresh enabled; RMIT disabled pending canonical promotion; Federation disabled with source profile paused/source-limited. | M2.4.2 | Preserve UQ schedule; enable RMIT only after clean 212-record promotion; keep Federation disabled until a separately accepted source qualification changes its disposition. | PARTIAL ACCEPTANCE / RMIT DECISION OPEN |
| M242-FU-023 | Stage B integration regression | A12 targeted gate is accepted and the stable M2.4.2 non-mutating runtime slice has been nominated for desktop/mobile Stage B through `.github/m2-4-integration-candidate` at Pilot `75e77c05…`. | M2.4.2 | Retain broader Layer 1/2/Admin Navigation/Evidence/Data Quality/A10/A12/M2.3 regression evidence; do not create Stage C until the canonical-promotion blocker and docs/release freeze are resolved. | RUNNING / STAGE B |

| M242-FU-024 | A13 Course filter stability + Layer 2 demo trace | Tablet filter centre-popup traced to explicit <=980px fixed-centre CSS. Layer 2 single-button routing was technically governed but opaque to operators. | M2.4.2 | Preserve trigger-anchored filters, coarse-pointer no-autofocus and bounded paging; expose Direct→Firecrawl→fallback route and linked recent Evidence. Dedicated tablet/demo browser UAT required. | IMPLEMENTED + UQ SCREENSHOT CAPTURED / TARGETED UAT RUNNING |

| M242-FU-025 | A13 screenshot Evidence thumbnails | Firecrawl already requested screenshot output but older acquisition workers did not persist the hosted visual. Future acquisition/discovery now stores screenshot Evidence; accepted UQ source Evidence was backfilled to screenshot Evidence `48733f50-959b-43fb-b495-71aa518a10e8` (PNG, 281,129 bytes). | M2.4.2 | Require Evidence drawer thumbnail/full-view browser PASS and preserve screenshot as secondary visual Evidence only. | IMPLEMENTED / TARGETED UAT RUNNING |

| M242-FU-026 | A12 Course detail decision-workspace UX | Narrow Course drawer and generic stacked QILT/PRISMS cards were functionally correct but poor for operator/demo use. | M2.4.2 | Preserve Course-only wide drawer, responsive summary layout, QILT benchmark cards, PRISMS contextual market panel, Scholarships scope panel and same-metric-only trend semantics. | IMPLEMENTED / DEPLOYED UAT RUNNING |

| M242-FU-027 | Post-demo UAT reconciliation | Stakeholder demo received very positive reception, but latest visual-uplift UAT is not accepted: A12 run `33157407844` failed on stale wording/layout assertions; A13 run `33156550691` failed because test still depends on hidden `.l2o-launcher`. | M2.4.2 | Update UAT to the accepted new UI semantics/primary navigation without weakening authority assertions; rerun targeted desktop/mobile. | OPEN / NEXT CHAT PRIORITY |

| M242-FU-028 | Demo follow-up targeted acceptance | A13 primary-navigation/filter/Evidence suite passed deployed at Pilot `c63db2db…`, run `33174990072`; A12 redesign reconciliation rerun is tracked separately before Stage B. | M2.4.2 | Preserve the accepted UI; proceed to Stage B only after A12 is clean. | A13 PASS / A12 RERUN IN PROGRESS |


## A14 Layer 2 / Layer 3 telemetry retention — 29 August 2026

A14 is now a standing M2 rule. Layer 2 must retain scraper/provider attempts, route/fallback outcome, latency, retries, vendor units/credits where measurable, estimated/measured cost, Evidence count/bytes, fields resolved and L3 fall-out. Layer 3 must retain exact model/profile, external calls, prompt/input tokens, completion/output tokens, latency, validator outcome and estimated/measured cost when the provider/runtime supplies them. Missing usage metadata remains explicit unavailable and is never manufactured.

Runtime checkpoint at adoption:
- 3,065 retained Layer 2 provider attempts; all have a metrics object and 3,012 already retain attempt latency;
- historical attempt-level vendor-unit/cost fields were not consistently populated, although managed-run/item metrics retained vendor usage/cost;
- `layer2-acquire-v2.9` now retains per-attempt provider key, request-unit usage basis, vendor units, latency and estimated request cost when available;
- Layer 3 accepted production interpretations remain 0, so production token totals are correctly 0;
- retained Layer 3 benchmark runs already record external-call count, input/output tokens, configured/returned model, cost and maximum latency;
- Security Advisor remains 131 INFO / 0 WARN / 0 ERROR and Performance Advisor 167 INFO / 0 WARN / 0 ERROR after the Edge update.

A new scraper/model execution path is not acceptable if it silently bypasses this telemetry contract.


## Stage B reconciliation — 29 August 2026

Stage B run `33210173798` completed desktop with 34 PASS, 6 FAIL and 1 flaky; mobile was not run because desktop failed. The six failures were traced to stale/timing-sensitive UAT contracts rather than lost Layer 2 profiles or weakened runtime controls: obsolete navigation copy, exact State-option label shape, pre-A14 worker version assertions, non-deterministic advanced-profile filter waits, and pre-A9 provider-guard wording. These were reconciled in Pilot without weakening QILT/PRISMS exclusion, paging, authority, secret, telemetry, or source-profile assertions. A13 Evidence-detail returned one transient HTTP 500 and passed on retry; it remains visible as flaky rather than being suppressed.

New frozen Stage B source: `0ae8fd85e42691e6074497157f3fb8c221ab57dc`; integration marker: `da970aa95e11368e68994a73a2ce4a8eec5a7ebb`. Stage C remains unauthorised until this candidate is desktop/mobile PASS.


## Authoritative Stage B disposition — 29 August 2026

This section supersedes stale Stage B/A12/A13 statuses earlier in this file.

- A12 targeted acceptance: PASS.
- A13 targeted acceptance: PASS.
- Stage B final integration: **desktop PASS / mobile PASS**, run `33214733610`.
- Final frozen Pilot source before Stage B marker: `69cb9b465de0a00247db381bcbffcc98a6b1f30a`.
- Stage B marker: `e2eec9b8de0187a5373b506342316ea457b79a0b`.
- RMIT 212-record promotion: **FORMALLY BLOCKED / NO AUTHORISED EXACT FROZEN-SET EXECUTOR**; do not bypass.
- Source-pattern Layer 3 benchmark: BLOCKED independently and carried forward.
- UQ refresh: ENABLED.
- RMIT refresh: DISABLED.
- Federation refresh/profile: DISABLED / PAUSED / SOURCE-LIMITED.
- Stage C: NOT YET CREATED at this checkpoint; exactly one final acceptance candidate remains.


## Final Stage C follow-up — 29 August 2026

- Stage C candidate: `91b115ddf64b020563c7ae6bbd1ea395db866d3f`.
- Acceptance run: `33215640328`.
- Result: desktop FAIL (45 PASS / 1 FAIL); mobile skipped.
- Sole failure: stale pre-A12 Course-card reorder assertion.
- Runtime behaviour is correct one-step movement; test contract corrected at Pilot `60e9e25a86a48522dbae7a29d6c2955c9d295761`.
- No second Stage C candidate/run is authorised under the frozen M2.4.2 rule.

**Status: BLOCKED / GOVERNANCE DECISION REQUIRED BEFORE ANY FUTURE FINAL-ACCEPTANCE REOPENING.**

Do not close CF-CHG-044 or advance Running Build/Master Plan from this state.
