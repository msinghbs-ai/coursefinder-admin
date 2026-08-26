# M2.4.2 — Follow-ups

## Active carry-forward

| ID | Origin | Item | Impact / risk | Next action | Target | Status |
|---|---|---|---|---|---|---|
| M24-FU-002 | M2.3 | NZ first-party Layer 2 Course enrichment remains deferred pending source qualification/onboarding. | False coverage claim / authority breach if ignored. | Preserve explicit NZ deferral in scope, UI, docs and UAT. | Future governed NZ L2 gate | DEFERRED |
| M24-FU-005 | M2.4 | Capture full-run Layer 2 performance, provider economics, Evidence growth and Layer 3 fall-out before tuning schedules/concurrency. | Performance/cost tuning would otherwise be assumption-based. | Baseline then execute representative/full authorised AU run and retain metrics. | M2.4.2 | ACTIVE / PRIORITY |
| M24-FU-006 | M2.4 | Layer 2 alerts for stuck jobs, stale sources, provider quota/spend and abnormal behaviour. | Operational failures may remain invisible. | Reconcile existing alert substrate and add bounded L2 signals where missing. | M2.4.2/4 | ACTIVE / PRIORITY |
| M24-FU-007 | M2.4 | Guides, Runbooks, release notes and state files must match deployed behaviour. | Operator/documentation drift. | Update as implementation becomes accepted. | Every sub-milestone | STANDING |
| M24-FU-004 | M2.4.1/4 | Layer 1 housekeeping accepted; cross-layer housekeeping remains for later consolidation. | L2 cleanup must not delete governed Evidence/history. | Implement only safe L2 transient cleanup; preserve M2.4.4 consolidation. | M2.4.2/4 | CARRY-FORWARD |

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