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
| M242-FU-007 | Cancellation/recovery exposed stale-wave continuation and terminal-state resurrection risks; both were corrected. | Representative cancelled UQ batch `7fe8446f-f480-4e2e-a901-2b73952ad323`; reconcile preserves cancelled; runner rechecks live state per item. | M2.4.2 | Add permanent deployed UAT for cancel-during-wave + late reconciliation before Stage B. | FIXED / UAT OPEN |
| M242-FU-008 | Layer 2 Course apply contract emitted `TOEFL` while accepted reference data uses `TOEFL_IBT`. | First 153-record UQ apply failed transactionally with no partial mutation; mapping corrected and second apply passed 153/153. | M2.4.2 | Preserve migration and add reference-code regression coverage. | FIXED / REGRESSION OPEN |

## Rule

Do not close an item merely because independent M2.4.2 work can continue. Record exact runtime/commit/UAT evidence as it becomes available.
| M242-FU-009 | RMIT title-only search selection mapped legacy/current CRICOS records to the same current Course page; those selections are unsafe. | BH079: `079626B` + `110997A`; BH077: `079625C` + `110995C`. | M2.4.2 | Supersede all pre-v1.3.0 RMIT terminal decisions; require detail-page CRICOS verification before selection; rerun broad RMIT scope. | FIXED CONTRACT / FULL RERUN OPEN |
| M242-FU-010 | Detail-page CRICOS verifier must prove both positive and negative identity before broad RMIT restart. | Request `2164`: current `110997A` selected BH079 with verification Evidence; legacy `079626B` rejected. | M2.4.2 | Preserve permanent UAT/source mirror, then bounded broad rerun under v1.3.0. | TARGETED PASS |
| M242-FU-011 | Layer 2 Course refresh had generic request creation but no Course-profile dispatcher/reconciler. | New disabled profile policies + `layer2_refresh_scheduler_tick_impl`; dry-run 0/0. | M2.4.2 | Enable only accepted executable profiles after full-run metrics; keep Federation disabled/paused while source-limited. | SUBSTRATE PASS / ENABLEMENT OPEN |
| M242-FU-012 | Stale L2 jobs/provider attempts and quota/failure/stale-run conditions required governed operations handling. | Recovery-only housekeeping cron/manual PASS; computed rank-4 alerts surfaced in existing blockers panel; targeted UAT `33027788662` PASS; anon/rank-3 negatives PASS. | M2.4.2 | Preserve in Stage B and final advisor/ACL regression. | TARGETED PASS / FINAL REGRESSION OPEN |

| M242-FU-013 | A10 paged-filter/tablet-focus contract is platform-wide; M2.4.2 implements Layer 2 scope + Course filters first. | Pilot `f8e743c4...`; UAT `33030713534`; build `33030713535`; PIM decisions v1.17. | M2+ | Migrate any remaining large eager-loaded Provider/University/Campus/QILT/PRISMS/Evidence selectors to the shared 10-item server-paged pattern before their next acceptance gate. | TARGETED PASS / PLATFORM ROLLOUT CARRY-FORWARD |

| M242-FU-014 | A10 current large dynamic filter rollout | Course, Layer 2, Evidence, QILT, PRISMS moved to the shared 10-item server-paged contract; CI gate added. | M2.4.2 | Keep A10 as standing platform rule for any newly introduced >10-option domain. | CLOSED / PASS — Pilot `656999ef...`, UAT `33031938406`, build `33031938398` |

| M242-FU-015 | RMIT Inbound Internship source-limited residual | CRICOS 091377B and 091378A have no accepted current first-party Course page under the RMIT `/study-with-us/levels-of-study/` profile; separate inbound RMIT material exists but does not satisfy the current Course identity/page contract. | M2.4.2 / future source qualification | Qualify a separate first-party inbound-programme source/profile only if these non-award records must be enriched; do not weaken the current RMIT Course URL prefix. | OPEN / SOURCE-LIMITED |

| M242-FU-016 | RMIT canonical promotion gate | Exact terminal managed-run promotion set reconciled to 212 distinct latest source records; 212/212 identity-matched, 0 already applied, 0 unsafe. ChatGPT Supabase connector blocked invoking the apply-named RPC even with dry-run flag, so no bypass or mutation was attempted. | M2.4.2 | Execute the accepted `layer2_apply_course_candidate(id,false)` dry-run and, only if 212/212 resolves cleanly, apply the same frozen set through the authorised service/CI path; retain Search/Publication=false proof. | OPEN / NEXT CONSEQUENTAL GATE |
