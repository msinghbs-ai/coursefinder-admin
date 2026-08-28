# CF-CHG-20260827-044 — M2.4.2 Layer 2 Full Enrichment, Operations Maturity & Performance

**Status:** CLOSED / PASS — corrective Stage C desktop/mobile PASS
**Category:** 40-layer2-enrichment  
**Initiated:** 27 August 2026 04:28 AEST (+10:00)  
**Origin chat/workstream:** M2.4.2 — Layer 2 Full Enrichment, Operations Maturity & Performance  
**Owner:** M2.4.2 workstream  
**Change class:** data/schema/enrichment/UI/security/operations/UAT/documentation

## Trigger

Authorised M2.4.2 programme gate after M2.4.1 CLOSED/PASS.

## Problem / requested outcome

Layer 2 has an accepted deterministic acquisition/extraction substrate, source profiles, provider routing, Evidence, provider attempts and initial run-batch objects, but current deployed operating evidence remains trial-scale. M2.4.2 must mature this into a production-shaped service across the authorised catalogue with clear scope, queue/progress, provider/source performance, cost/quota, completeness/fall-out, retry/resume/recovery, scheduling, housekeeping, security and performance evidence.

Operator feedback on 27 August 2026 additionally identified that the routine sync journey exposed too much Layer 2 implementation detail and that a Firecrawl concurrency edit did not remain visibly/persistently saved. Addendum A8 therefore makes country → university/catalogue-provider selection the normal sync journey and moves acquisition-vendor tuning to Advanced controls.

A subsequent runtime review and operator direction created Addendum A9. A9 broadens routine scope selection to Country / State / University, separates catalogue scope from acquisition routing, standardises the default provider chain as Direct HTTP → Firecrawl → remaining enabled providers in configured order, and requires further cleanup of the routine Layer 2 screen.

## Affected surfaces / related workstreams

- `pipeline.layer2_source_profiles` and immutable profile versions;
- `pipeline.layer2_acquisition_providers` and profile-provider routes;
- `pipeline.layer2_execution_policies`;
- `pipeline.layer2_provider_attempts`;
- `pipeline.layer2_run_batches` / `pipeline.layer2_run_items`;
- Layer 2 discovery/candidate/completeness state;
- `pipeline.jobs` and `pipeline.evidence_artifacts`;
- Layer 2 Edge/server acquisition/extraction runtimes;
- authenticated `layer2-sync-control` Edge bridge and service-only operator sync helper;
- Data Operations → Layer 2 browser workspace;
- advanced Layer 2 acquisition-provider editor;
- Evidence, Jobs/Runs, Data Quality and immediate Layer 3 fall-out contracts;
- M2.4 guides/runbooks/release notes and staged UAT.

Related standing controls: CF-CHG-20260826-042, CF-CHG-20260826-043, M24-FU-002, M24-FU-005, M24-FU-006, M24-FU-007.

## Semantic impact

No canonical identity or Layer 1 authority change is authorised. Layer 2 remains deterministic acquisition/extraction and may create governed facts/Evidence only through accepted contracts. Layer 3 receives governed unresolved fall-out only. Layer 4, Search and Publication authority remain unchanged. NZ first-party Layer 2 Course enrichment remains deferred unless separately source-qualified and authorised.

Routine operator semantics are simplified to:

`Country → Fetch scope (Country / State / University) → Scope value → Scope preview → Discover & sync / Sync now / Recheck → Progress → Results`

Acquisition-vendor choice remains automatic under governed route policy for normal operation. Firecrawl/Scrape.do/etc. credentials, route priority, vendor concurrency/rate/timeout and qualification controls remain Advanced.

## Before

- Accepted M2.1/M2.3 Layer 2 platform exists with source profiles, providers/routes, attempts, Evidence and trial/completeness tooling.
- Deployed reconciliation at M2.4.2 start: 6 source profiles, 13 profile versions, 6 acquisition providers, 26 routes, 103 provider attempts, 4 execution policies, 1 run batch, 3 run items and 1,699 Evidence artifacts.
- Full authorised Layer 2 enrichment and production-shaped run management are not yet proven.
- Firecrawl stored vendor concurrency was `2`; the previous editor did not provide an exact post-save/server-re-read confirmation contract.

## Current implemented state

### Operator sync A8
- Routine Layer 2 UI now begins with Country and University/catalogue-provider selectors.
- Scope card exposes Catalogue, Ready to sync, Needs discovery and Run concurrency before execution.
- If governed Course URLs are absent, the single primary action becomes `Discover & sync`; it invokes the accepted deterministic discovery substrate rather than inferring URLs.
- If governed selected Course URLs exist, the same action becomes `Sync now` and builds a managed run from current-version discovery candidates.
- Existing active-run protection remains authoritative in the database bridge.
- NZ Course enrichment remains deferred/non-launchable.

### Provider persistence correction
- Provider editor distinguishes acquisition-vendor concurrency from source-profile/run concurrency.
- Vendor concurrency is bounded 1–20; timeout 1–120 seconds; rate limit is null/default or 1–10000 requests/minute.
- Save now re-reads provider state and rejects the operation visibly if concurrency/rate/timeout do not exactly match persisted server values.
- Drawer state is refreshed from the persisted provider record and provides a `Saved and verified` confirmation for authorised Platform Admin edits.
- A direct persistence probe temporarily changed Firecrawl vendor concurrency from 2 to 3, confirmed the persisted database value, then explicitly restored Firecrawl to `2 / 30 per minute / 90 seconds`. No canonical or Evidence state was affected by the configuration probe.
- Standard deployed UAT deliberately does not mutate these settings because its permanent identity is below the Platform Admin edit boundary.

### Security correction
- An initial browser-callable SECURITY DEFINER sync RPC was rejected after Security Advisor raised `authenticated_security_definer_function_executable`.
- That RPC was removed before acceptance.
- Browser writes now go through `layer2-sync-control` with `verify_jwt=true`, which rechecks authenticated context/rank server-side.
- The database helper is `layer2_operator_sync_service(...)`, restricted to `service_role`, and independently rechecks the supplied actor rank.
- Security Advisor was rerun after correction; the new SECURITY DEFINER WARN is gone and remaining findings are INFO-level existing private-table/RLS patterns.

## Source authority / evidence

- `PROJECT_INSTRUCTIONS.md`;
- M2 Standing Instructions and A1–A7;
- M2.4.2 RUNSHEET Addendum A8;
- `docs/coursefinder-database-architecture-v2.10.42.md`;
- `docs/coursefinder-master-project-plan-v1.75.md`;
- `docs/coursefinder-running-build-v2.75.md`;
- M2.4 and M2.4.1 current-state/follow-up records;
- accepted Pilot baseline `ed41ea4d7d6672e871cd4ce401bfca24fe3eb64d`;
- deployed Pilot Supabase project `coursefinder_Pilot` reconciled throughout implementation.

## Implementation references

### Supabase migrations
- `20260827092000_m2_4_2_operator_sync_bridge.sql` — initial operator bridge; superseded before acceptance by the service-only security architecture;
- `20260827092500_m2_4_2_provider_rate_guard.sql` — acquisition-provider rate guard;
- `20260827093000_m2_4_2_operator_sync_service_bridge.sql` — removes the browser-callable privileged bridge and installs service-only rank-checked sync helper.

### Edge functions
- `layer2-sync-control` v1 — authenticated/rank-rechecking operator sync bridge, `verify_jwt=true`.

### Pilot implementation commits during A8
- `25a006912e8191e0287554bbbabe8cd42a2a23be` — initial governed operator sync migration mirror;
- `432de835a71f1d2fe263d99df61ac7da8b576af6` — simplified Layer 2 sync UI;
- `0f1f3c7da5c27304c94e294b11ea90fe6c4e7c90` — provider persistence verification;
- `1264784529e70b43bb462bdd6a6148410c5100f3` — selector/sync responsive styling;
- `c10b330dc6b4db52d0c757ddab171b6903ae209e` — initial Firecrawl persistence targeted-UAT attempt;
- `ca190b245252d1a6464db51f785d2d04588800d3` — provider rate guard mirror;
- `c216a02292ab62c097363f6aa73f071b10aedc40` — service-only sync bridge mirror;
- `a575b02f5ad7289770039a06fde8dbd1cf37086a` — authenticated Edge sync source mirror;
- `f3740187597ea77cfffd93788db9eb9c1844e0d8` — browser sync routed through authenticated Edge bridge;
- `db8ff542d275962c4f97ff1c8d37cffe736039cf` — corrected targeted UAT preserving Platform Admin provider-edit authority.

A8 current tested Pilot head: `db8ff542d275962c4f97ff1c8d37cffe736039cf`. It is a targeted development candidate, not the M2.4.2 final acceptance candidate.

## UAT

Mandatory staged model remains:

1. Stage A targeted Layer 2 development validation, desktop unless responsive behaviour changes.
2. Stage B bounded desktop/mobile integration covering Layer 2 operations, Admin navigation, Layer 1 regression, Evidence, Data Quality/completeness, Jobs/Runs, Layer 2 performance, immediate Layer 3 fall-out, persistence/state and release notes.
3. Stage C exactly one frozen full permanent deployed desktop/mobile acceptance candidate plus frontend build/browser smoke, final Security/Performance Advisors, ACL/rank/anon negatives and exact runtime/repository reconciliation.

### A8 targeted evidence

- Earlier first operational-workspace Stage A: `33001852982` — PASS.
- A8 security-corrected frontend build/browser smoke: `33004496198` — PASS.
- A8 corrected targeted deployed desktop UAT: `33004496331` — PASS.
- Preceding run `33004179270` — FAIL by test design only: Country/university selector and concurrency-separation tests passed, while the Firecrawl test incorrectly expected the lower-rank permanent UAT user to have Platform Admin provider-edit controls. No security role was weakened; the test was corrected to assert that those edit controls are absent for the lower-rank identity.

The current targeted suite proves:
- Country → university selector journey;
- AU RMIT/UQ/Federation authorised choices;
- scope preview counts and discovery-vs-sync action state;
- no routine bounded-trial control;
- explicit separation of run concurrency from acquisition-vendor concurrency;
- Firecrawl vendor limits are visible while edit controls remain Platform Admin privileged;
- no credential exposure through provider UI;
- no browser/server runtime errors in the targeted slice.

## A9 implementation and targeted evidence

- Scope-first UI and service contract implemented for Country / State / University.
- AU Country preview: 1,072 Courses / 3 universities.
- VIC State preview: 690 Courses / 2 universities.
- QLD State preview: 404 Courses / 2 universities.
- RMIT University preview: 500 Courses / 1 university.
- AU Course route order is Direct HTTP → Firecrawl → remaining configured providers.
- Discovery and managed batches now use the existing ordered runtime route list; managed runs no longer force a preselected provider.
- Corrected Federation discovery job `e5055e66-8711-4a24-a2c3-d926d681cc15`: 5 processed / 0 runtime failures / 0 unsafe selections.
- Firecrawl governed acquisition trial `dd48db0c-db0d-4403-ba7f-de2a5482004c`: PASS with Evidence `ea932ca9-5fa2-4889-a0fb-9103ac4ed374`, no canonical mutation.
- Current targeted Pilot: `638970c0b6fe323ba93260289301218a7f218aff`.
- Deployed targeted desktop UAT `33016596722`: PASS.
- Frontend build + local browser smoke `33016596701`: PASS.
- Security Advisor: INFO-only (129), no WARN/ERROR.
- Performance Advisor: INFO-only (167), no WARN/ERROR.
- Controlled Direct-failure → Firecrawl automatic transition remains a pre-broad-run gate; this record does not claim that transition has yet been forced in runtime.

## Performance / advisor evidence

- Security Advisor: current A8 architecture has no new WARN/ERROR; the rejected direct authenticated SECURITY DEFINER bridge finding was eliminated before the PASS candidate.
- Performance Advisor: INFO-only existing Layer 2 FK-indexing and unused-index observations remain inputs to the representative/full-run tuning gate. No performance threshold was widened and no index is added solely to silence an INFO finding without measured workload evidence.

## Rollback / reversion

Prefer additive migrations and independently reversible frontend/Edge changes. Roll back browser release to the last accepted M2.4.1 SHA if an unrecoverable UI/runtime regression occurs. Do not delete governed Evidence/profile versions/provider-attempt history/canonical history during rollback. Any operational schema rollback must preserve audit/history data or explicitly migrate it to the prior accepted representation.

## Documentation impact

- Data Operations Admin Guide: required
- PIM Admin Guide: required where operator/field semantics change
- Operations Runbook/troubleshooting: required
- release notes: required for browser-facing changes
- Architecture: update only for accepted architecture changes
- Running Build/Master Plan: update only at final acceptance
- M2.4.2 RUNSHEET/CURRENT-STATE/FOLLOW-UPS/NEXT-CHAT: mandatory

## Decision / status history

| Timestamp | Status | Decision / event | Reference |
|---|---|---|---|
| 27 Aug 2026 04:28 AEST | ACTIVE | M2.4.2 initiated from accepted M2.4.1 baseline; no Layer 1 authority change authorised. | M2.4.2 chat |
| 27 Aug 2026 | ACTIVE / A8 | Operator-first sync addendum accepted into current M2.4.2 scope; Country → University/catalogue provider becomes routine launch path. | RUNSHEET Addendum A8 |
| 27 Aug 2026 | ACTIVE / SECURITY CORRECTED | Direct authenticated SECURITY DEFINER sync bridge rejected after Advisor WARN; replaced by authenticated Edge + service-only rank-checked helper. | `layer2-sync-control`, `m2_4_2_operator_sync_service_bridge` |
| 27 Aug 2026 | ACTIVE / A8 TARGETED PASS | Corrected A8 candidate passes frontend build/browser smoke and targeted deployed desktop UAT. | Pilot `db8ff542...`; runs `33004496198`, `33004496331` |
| 27 Aug 2026 07:13 AEST | ACTIVE / A9 | Latest Federation discovery run reviewed: 5/5 failed at invalid provider-attempt terminal status and only Direct HTTP was attempted. A9 adopts Country/State/University scope, ordered Direct → Firecrawl → remaining-provider routing, and routine-screen cleanup. | Job `c7dd414e-487a-4861-a9f3-defbfd9458f2`; RUNSHEET A9 |
| 27 Aug 2026 | ACTIVE / A9 TARGETED PASS | Scope-first UI, ordered routing, bounded continuation and service-only scope contracts implemented. Targeted deployed UAT and frontend/browser build pass; broad run remains gated on controlled fallback and full-run evidence. | Pilot `638970c0...`; UAT `33016596722`; build `33016596701` |

## Closure

**Final status:** OPEN  
**Closed at:** N/A  
**Outcome:** A9 targeted scope-first/routing/UI slice PASS; pending controlled fallback UAT, full authorised discovery/enrichment evidence, scheduling/recovery/housekeeping/performance gates, Stage B, final Stage C and remaining M2.4.2 requirements.

## Full-run evidence update — 27 August 2026

### UQ full deterministic enrichment
- Full current-profile discovery evaluated 382/382 UQ Courses.
- Governed selected URLs: 156; ambiguous: 31; identity mismatch: 79; current page not found: 116; duplicate selected URL groups: 0.
- Representative pre-fix managed run exposed deterministic fee-confidence fall-out and was deliberately cancelled. Cancellation/reconcile/runtime fixes were implemented before continuing.
- Deterministic Course extractor v2.5 corrected international-fee confidence using explicit AUD/A$, international/CRICOS proximity and retained domestic/CSP/HECS negative guards.
- Regression batch `7fb8c4a9-b6d0-499e-9503-8eb13c424c80`: 3/3 previously problematic UQ Courses resolved 5/5 fields.
- Fresh full managed batch `eb52b6e2-c33b-4dfc-9e87-c107834218e0`: 156 processed, 153 resolved_l2, 3 Layer 3 required, 0 blocked, 156 vendor units, USD 0 vendor cost.
- Three Layer 3 exceptions remain explicit: CRICOS `027288A`, `082599G`, `094716G`.
- Bulk dry-run of the 153 resolved candidates proved 153/153 exact provider/Course CRICOS resolution through `layer2_apply_course_candidate(...,false)`.
- First canonical apply attempt failed transactionally because extracted `TOEFL` did not match accepted reference code `TOEFL_IBT`; post-failure canonical counts confirmed no partial mutation.
- Apply contract mapping corrected to `TOEFL_IBT`; second apply passed 153/153:
  - 153 official links;
  - 153 guarded international fee rows;
  - 488 intake rows;
  - 453 English requirement upserts;
  - 153 Course descriptions;
  - Search mutation false;
  - Publication mutation false.
- UQ Layer 2 off-domain link check: 0 bad links.

### Recovery and cancellation hardening
- `layer2_run_batch_reconcile` now preserves terminal `cancelled` state during late in-flight reconciliation.
- `layer2-batch-runner` now rechecks live batch/item status before each item and stops at a cancellation boundary.
- Governed Evidence/history from the cancelled representative run is retained.

### Federation
- 190-Course legacy discovery evaluation produced no governed selected URLs.
- 10 previously applied identity-verified first-party Course URLs were seeded into the current immutable profile version with existing Evidence/provenance.
- Current queueability is 10/190; remaining 180 are source-limited unless a separately qualified first-party mapping source is accepted.
- Managed enrichment for the 10 governed Courses has been dispatched as batch `fef3ab42-de28-469d-84a2-22c908f0fad1`; broad current-version discovery remains under observation and must not weaken identity matching.

### RMIT
- RMIT profile now requires `/study-with-us/levels-of-study/` detail URLs.
- Direct HTTP search responses without qualifying links fall through to Firecrawl.
- Discovery worker v1.2.4 fixes provider-suffix/Honours ambiguity: CRICOS `110982H` correctly selects BP350 while the Honours page remains unselected.
- Full bounded RMIT discovery request `2138` started for 499 remaining Courses.
- Early broad-run telemetry: Direct HTTP extraction-failed as expected for rendered search; Firecrawl rendered results successfully; no duplicate selected URL groups observed in the early cohort.

### Acceptance status
M2.4.2 remains ACTIVE. UQ now provides broad end-to-end deterministic discovery → managed acquisition/extraction → governed canonical apply evidence. RMIT/Federation final disposition, schedule/recheck/alerts/housekeeping, full performance/security regression, Stage B and exactly one final Stage C remain open.


## RMIT identity-safety correction and operational maturity update — 27 August 2026

A broad RMIT discovery review found that search-result title similarity alone can map legacy and current CRICOS Course records to the same current first-party Course page. BH079 and BH077 provided concrete examples. Pre-v1.3.0 RMIT discovery decisions are therefore **superseded** as acceptance evidence.

Worker `layer2-scope-discover-scheduled-v1.3.0` now requires the top candidate's current first-party detail page to contain the expected CRICOS before `selected=true`. Detail verification:
- uses the existing governed provider chain;
- retains separate native verification HTML Evidence;
- retains provider-attempt telemetry;
- records `detail_cricos_verified`;
- performs no canonical mutation.

All pre-v1.3.0 terminal RMIT current-version candidate decisions were retained historically but invalidated to non-selected `candidate` rows with their prior status preserved in `match_basis`.

Targeted identity control request `2164`:
- `110997A` → current BH079: PASS, selected and verified;
- `079626B` → current BH079: PASS negative, not selected / identity mismatch because the first-party page does not contain the legacy CRICOS;
- 2 processed / 1 selected / 0 runtime failures / no continuation.

RMIT is paused while this contract is frozen into permanent source/UAT; broad RMIT discovery/enrichment must be repeated under v1.3.0.

Additional M2.4.2 operational maturity now deployed:
- terminal discovery restart idempotency;
- bounded continuation set subtraction and hard invocation/Course time budgets;
- Layer 2 Course refresh dispatcher and reconciler using the existing managed-batch service;
- disabled weekly profile-scoped refresh policies pending full-run acceptance;
- non-destructive Layer 2 housekeeping with zero governed-history deletion;
- cron scheduling for refresh dispatch and housekeeping;
- computed rank-4 Layer 2 alerts for stale runs, paused profiles, blocked items, provider failure streak and quota reserve;
- alert browser exposure only through accepted `admin_read` governance, with no credential exposure.

M2.4.2 remains ACTIVE. No Stage B or Stage C candidate has been nominated.


## RMIT v1.3.0 targeted acceptance update

Corrected post-v1.3.0 targeted browser/runtime gate:
- Pilot `a6e09ccd84a1d39e1911f37fbd793d48cf52cdb8`;
- deployed targeted UAT `33027788662` PASS;
- frontend build/browser smoke `33027788651` PASS.

The preceding targeted failure was caused by stale UAT expectations plus an alert-helper ACL grant that had been rolled back with its validation transaction; no runtime security boundary was weakened. The durable ACL is mirrored in `20260827225500_m2_4_2_layer2_alert_acl_reconcile.sql`. The primary Layer 2 sync UI now loads independently of the alert feed.

Security negatives:
- anon cannot execute alert, housekeeping or Layer 2 refresh-dispatch helpers;
- authenticated users cannot execute housekeeping/refresh helpers;
- rank-3 authenticated alert read is rejected;
- rank-4 authenticated alert read succeeds through the private helper and internal rank check.

RMIT duplicate-title/multi-CRICOS cohort:
- 20/20 terminal;
- 6 selected;
- 6/6 selected detail-CRICOS verified;
- 0 unverified selections;
- 0 duplicate selected URL groups;
- 4 ambiguous / 10 identity mismatch / 0 runtime failures;
- bounded continuation `2165 → 2166 → 2167 → 2168`.

Full RMIT university rerun began through the normal operator scope contract as request `2169`; early waves remain bounded with zero runtime failures and no unverified/duplicate selected URLs. Final full-run disposition remains open.


## A8 release/version surface cleanup

CF-CHG-044 now inherits Milestone 2 Addendum A8.

The obsolete persistent runtime/footer marker that listed PIM Admin and implementation component versions is removed from the normal operator UI. The top-right PIM Admin version control and governed Release Notes overlay are now the single operator-facing release surface.

Browser/UAT readiness has been migrated off the footer marker. Permanent tests require the marker to remain absent and continue to verify the accessible version/release overlay.

No M2.4.2 release-version bump is made until the current full-run/runtime slice is frozen.


A8 targeted deployed evidence: Pilot `27f56ddb944569e3ca1061ce6d27f760642e58e0`, deployed UAT `33029342740` PASS, frontend build `33029342761` PASS. The footer/runtime marker is absent and no longer used by deployment-readiness helpers.


## A10 platform-wide paged-filter / tablet-focus scope

CF-CHG-044 inherits Milestone 2 Addendum A10.

Current implementation moves the Course catalogue's large dynamic filters to a server-paged option contract capped at 10 results per request, retains client-side 10-row paging for shared filters, removes unconditional filter search auto-focus on touch/tablet contexts, and makes Layer 2 State scope visibly enumerate its included universities in 10-row pages.

This is a browser/performance UX change only; Layer 1 identity, Layer 2 authority, Search/Publication boundaries and provider credential controls are unchanged.


A10 targeted deployed evidence is PASS: Pilot `f8e743c417df26ead234523718a2b8024e415646`, deployed UAT `33030713534`, frontend build `33030713535`. Course dynamic filters are server-paged at a hard maximum of 10 options, touch/coarse-pointer filter opening does not auto-focus search, and Layer 2 State scope visibly enumerates included universities. Platform-wide semantics are accepted in Admin/PIM Design Decisions v1.17.


### A10 platform-wide acceptance

A10 is PASS on Pilot `656999ef5f92f74b850482e559f418beb93ac9bc`: deployed UAT `33031938406` PASS and frontend build `33031938398` PASS. The 10-item server-paged option contract is implemented for Layer 2 State/University, Course dynamic filters, Evidence Source, QILT Provider/Metric and PRISMS Study Area. Legacy bulk bundles no longer backload those growing domains. Coarse-pointer browser UAT proves no automatic search focus. The dedicated A10 suite is permanently routed by CI and included in integration/acceptance.

A10 post-DDL Advisor check: Security Advisor 0 material WARN/ERROR/new executable-function findings for the paging functions; Performance Advisor 0 material WARN/ERROR findings for A10. Existing INFO-class project notices remain unchanged.


### RMIT representative full-run discovery gate

RMIT current-profile discovery plus exact non-terminal retry completed with 498/500 terminal outcomes and 261/261 selected URLs detail-CRICOS verified. No non-RMIT selected URLs, duplicate selected URLs or canonical Course URL mutations were accepted. Residual CRICOS `091377B`/`091378A` (`RMIT Inbound Internship`) remain source-limited because the accepted `/study-with-us/levels-of-study/` contract does not cover RMIT's separate inbound internship estate; no routing or identity rule was weakened. Primary managed batch `6abe8558-e1b9-4a6f-ba97-47481ba488bb` contains the initial 240 verified selections; 21 retry recoveries remain queued for a second bounded batch after the primary batch terminates.


Managed-run observability correction: `retry_count` previously counted the first normal acquisition as a retry and response/extraction timing fields were not populated. Migration `20260827234000_m2_4_2_run_item_observability_fix.sql` and `layer2-batch-runner` v6 correct retry semantics and add service-only response/extraction/outcome telemetry without changing routing or extraction behaviour. Deployed verification shows retry_count=0 for first attempts and populated timing/outcome fields on v6-processed items.


### RMIT full managed-run evidence

Representative RMIT full-profile gate completed: 498/500 deterministic discovery terminal outcomes; 261/261 selected URLs detail-CRICOS verified; 261/261 managed enrichment items processed across two bounded batches; 212 resolved L2, 49 governed Layer 3 fall-outs, 0 blocked, 0 item retries, USD 0 recorded vendor cost. Timing sample after observability correction: acquisition ~1.45s average / 1.81s p95; deterministic normalise+extract ~1.52s average / 1.89s p95. Evidence footprint since full discovery began: 1,355 objects / ~823 MB. No canonical Course URL mutation, non-RMIT selected URL or duplicate selected URL was accepted. Completed PARTIAL batches are now terminal history rather than active-run blockers. Post-DDL Advisor review found 0 material security/performance findings for these changes.


## Scale-out decision — AU/NZ (27 August 2026)

Accepted scope interpretation is amended to prevent M2.4.2 becoming a serial university-by-university implementation project.

UQ, RMIT and Federation are the initial evidence/qualification cohort. M2.4.2 must use those results to prove the reusable operating contract, then transition remaining providers into controlled wave onboarding.

Accepted rollout pattern:

`bounded sample → qualify source/profile → automated full discovery → managed enrichment → safe canonical promotion → governed L3/L4 exceptions`

Controls:
- 100% identity safety is mandatory for any automatic selection/promotion;
- coverage may be incomplete and must be represented honestly as ambiguous, identity-mismatch, source-limited, L3-required or L4-required;
- unresolved coverage must not trigger weaker identity/source controls;
- Australian rollout should batch multiple universities where execution policy permits;
- NZ rollout begins with a 2–3-provider first-party source-pattern qualification cohort anchored to NZQA Layer 1 identity, then expands by reusable source pattern;
- Layer 3/4 may consume the Evidence-backed exception stream in parallel once generated;
- Search/Publication authority is unchanged.

Change-control closure does not require every AU/NZ university to be individually enriched. It requires representative broad evidence, safe scalable onboarding, measurable operations, governed exceptions, cross-layer handoff and the remaining M2.4.2 security/UAT/documentation gates.


## A11 deployed scale-scope proof (27 August 2026)

The Layer 2 routine scope contract now reads from the full Layer 1 catalogue instead of only existing executable Layer 2 profiles.

Verified live catalogue:
- AU — 1,546 institutions / 26,648 Courses / 8 represented subdivisions;
- CA — 82 institutions / 10,356 Courses / 10 represented subdivisions;
- NZ — 286 institutions / 6,457 Courses / no current Layer 1 subdivision linkage.

The UI/API now distinguishes:
- Layer 1 catalogue scope;
- Layer 2 qualified/executable institutions;
- qualification-required institutions;
- governed URL readiness.

Bounded non-mutating A11 proof created 5-institution × 10-Course qualification waves in AU, CA and NZ. A second AU wave selected another five institutions with zero overlap, proving active-wave deduplication. Qualification creation explicitly records canonical mutation=false, Search mutation=false and Publication mutation=false.

This proves catalogue visibility and scalable wave orchestration. It does not yet qualify the selected institutions’ first-party sources. The next gate is governed deterministic acquisition/Evidence over those samples followed by reusable source-pattern/profile promotion where identity safety passes.


## A11 qualification execution result (27 August 2026)

The full-Layer-1 scale POC has now executed its first governed source-qualification cohort.

Across AU/CA/NZ, the initial 15-provider / 150-Course sample produced:
- 8 providers with retained first-party Layer 2 Evidence requiring source-pattern interpretation;
- 7 providers with missing/malformed Layer 1 first-party source seeds and therefore explicit source-limited outcomes;
- 0 unsafe automatic provider-profile promotions.

The Evidence-backed deterministic pattern candidates were subjected to the existing v1.3.0 Course-detail identity verifier with three Layer 1 controls per provider. No candidate achieved the mandatory 3/3 identity-safe threshold. The platform therefore handed them to Layer 3 rather than introducing provider-specific Layer 2 rules or weakening identity matching.

A service-only cross-layer handoff now records:
- 8 Layer 3 provider/source-pattern requests, blocked pending a dedicated benchmarked source-pattern model profile;
- 7 Layer 4/provider-source-resolution requests.

The accepted existing Layer 3 model profile is not modified because its quality benchmark covers Course fact task classes, not provider source-pattern interpretation. A dedicated profile must be benchmarked before those requests can execute.

This result validates the A11 scale strategy: Layer 2 performs bounded deterministic qualification, produces Evidence, promotes only when identity controls pass, and exports unresolved work to the correct downstream layer. Canonical/Search/Publication mutation remain false throughout this qualification path.


## A11 Layer 3 benchmark blocker + independent regression closure (27 August 2026)

A dedicated `source_pattern` Layer 3 profile was implemented with exact-Evidence-link, same-host, HTTPS-only validators and a separate quality gate. The existing accepted Course-fact model profile was not modified.

Best benchmark candidate: `579a52d5-f4c2-4995-ab42-0adc4754cef2` — 3/4 live Evidence cases + 3/3 controls, exact configured model, USD 0. One real Massey case still produced an empty completion after bounded retry. An alternate current free structured-output endpoint returned OpenRouter 404 in the Pilot runtime. The threshold was not lowered; the profile remains paused and all eight A11 Layer 3 requests remain blocked.

No canonical/Search/Publication mutation occurred. New benchmark helpers are service-only and post-change Security/Performance Advisors remain INFO-only.

Independent M2.4.2 regression gates were continued:
- rollback-only cancel-during-wave + late-reconcile PASS;
- rollback-only stale recovery PASS;
- TOEFL→TOEFL_IBT reference/apply-contract regression PASS;
- immutable-profile terminal discovery restart/idempotency PASS.

The Layer 3 blocker therefore remains recorded without stopping unrelated M2.4.2 closure work.


## A12 contextual insight integration

CF-CHG-044 inherits Milestone 2 Addendum A12. The existing QILT, PRISMS and Scholarship workspaces remain valid bulk operational views, but M2.4.2 must also surface relevant governed outcomes/student-flow/funding context from Provider and Course detail blades. The contextual projection is read-only, must preserve source granularity/provenance, and must not imply Course-specific truth from Provider/state/sector aggregates. Country-equivalent source families must use the same generic blade contract when later available.


## A12 targeted acceptance evidence

A12 contextual insight integration is implemented and targeted-PASS:
- bounded read-only contextual projection behind `public.admin_read`;
- Provider/Course detail semantic groups: outcomes/benchmarks, international student flow, Scholarships/funding;
- RMIT Provider live proof: 36 QILT outcome rows, 452 VIC PRISMS regional-context observations, 3 Scholarships;
- representative RMIT Course: Provider-context outcomes + 3 governed Provider-scope Scholarships; PRISMS remains explicit `not_mapped` where no defensible Course relationship exists;
- UQ Provider: 36 QILT outcome rows plus regional PRISMS context;
- rank-0/anon negative PASS;
- Security Advisor 0 WARN/0 ERROR; Performance Advisor 0 WARN/0 ERROR;
- targeted deployed UAT `33080519873` PASS at Pilot `c58cff1790e8be59b7256ce30e68aa8a1d7a1be0`.

The contextual projection does not authorise canonical, Search or Publication mutation.

## Refresh-policy disposition

Measured profile-specific disposition replaces any blanket assumption that all Course-profile refresh is disabled:
- UQ weekly Course refresh is enabled after accepted full-run/canonical evidence;
- RMIT weekly Course refresh remains disabled pending its frozen 212-record canonical promotion;
- Federation weekly Course refresh remains disabled with its profile paused/source-limited.

## Stage B nomination

Pilot `75e77c0599a32c77e8e890de9fc2ce2ba8c10a3c` updates the integration-candidate marker after A12 targeted PASS. This is Stage B only; it does not authorise final Stage C. RMIT canonical promotion remains open and no connector-safety bypass is authorised.


## A13 filter stability and Layer 2 demo trace

CF-CHG-044 inherits A13. The Course tablet filter must stay anchored to its trigger and must not use viewport-centred modal positioning. The routine Layer 2 screen retains one execution action but now makes the governed acquisition chain and recent provider attempts visible. An accepted UQ Firecrawl attempt is exposed as a meeting/demo proof with a deep link to governed private Evidence. This is a read/UX change only; no new canonical/Search/Publication authority is introduced and screenshots are not fabricated where screenshot Evidence is absent.


## A13 screenshot Evidence extension

Rendered Firecrawl acquisition now persists provider-returned screenshots as separate private `layer2_screenshot` Evidence linked to the same provider attempt. The image is secondary visual Evidence; HTML/raw Evidence remains authoritative for extraction. Visual capture failure does not invalidate a successful source acquisition.

Evidence detail exposes the related screenshot through the existing authenticated private signed-access service and renders it as a thumbnail. An accepted UQ Bachelor of Arts acquisition was backfilled without canonical extraction: source Evidence `eb305cd4-577e-4ced-988b-243fc3318f6e` → screenshot Evidence `48733f50-959b-43fb-b495-71aa518a10e8` (PNG, 281,129 bytes). No canonical/Search/Publication mutation occurred.


## Post-demo targeted acceptance and closure disposition

Targeted post-demo UAT is now clean:
- A12 deployed UAT `33175425752` PASS at Pilot `859b030c…`;
- A13 deployed UAT `33174990072` PASS at Pilot `c63db2db…`.

The accepted UI direction is preserved: wider Course decision workspace, contextual QILT/PRISMS/Scholarship panels, one-action Layer 2 operator journey, explicit governed route, and secondary screenshot Evidence through private signed access. PIM Admin v2.15.8 records the browser-facing change through the existing top-right release overlay only.

RMIT promotion has been formally dispositioned BLOCKED for this gate. The frozen cohort is 212/212 identity matched, 0 unsafe, 0 applied, fingerprint `627bb7daa62fe3bbfc3047ce2b57a88e`. The apply RPC remains `postgres`/`service_role` only and no already-authorised exact frozen-set service/CI executor exists in the currently inspected governed paths. No connector-safety bypass was introduced. RMIT weekly refresh remains disabled.

Live refresh disposition remains:
- UQ weekly Course refresh ENABLED;
- RMIT DISABLED pending future authorised canonical promotion;
- Federation DISABLED / profile paused / source-limited.

Security Advisor: 131 INFO / 0 WARN / 0 ERROR.
Performance Advisor: 167 INFO / 0 WARN / 0 ERROR.

Replacement Stage B is nominated at Pilot marker commit `5e0eea7784571bab79146342d3dbfb9eae9a86b3`, frozen source `c6756f2f96ecb8f766a0e14194446944a9adfd7c`. Final Stage C remains prohibited until Stage B PASS and final source/docs/runtime freeze.


## A14 telemetry retention — 29 August 2026

CF-CHG-044 now inherits Execution Addendum A14.

Layer 2 provider/scraper and Layer 3 AI usage/performance metrics are retained as operational evidence rather than one-off test output. The required contract covers provider/model identity, attempts/calls, latency, retries/fall-out, vendor units/quota, cost, Evidence footprint, fields resolved and Layer 3 input/output tokens where returned by the provider/runtime.

Initial runtime baseline is retained at `project-runsheets/milestone-2/m2.4/m2.4.2/TELEMETRY-BASELINE.md`.

At adoption:
- 3,065 Layer 2 provider attempts were retained; 3,012 already had attempt latency;
- managed Layer 2 history retained 483 aggregate vendor units across 7 batches;
- historical provider-attempt unit/cost telemetry was incomplete and is not backfilled by inference;
- deployed `layer2-acquire-v2.9` now records provider key, request-unit usage basis, vendor units, latency and estimated request cost when available;
- Layer 3 production interpretations remain zero; benchmark history retains model, external-call count, input/output tokens, latency and cost;
- Security Advisor remains 0 WARN / 0 ERROR and Performance Advisor remains 0 WARN / 0 ERROR after the Edge update.

This telemetry is read/operations evidence only and grants no canonical, Search or Publication authority.


### A14 scheduled-discovery telemetry completion

The A14 audit identified and closed the separate scheduled-discovery telemetry path. `layer2-scope-discover-scheduled-v1.3.2` (deployed Edge version 19) now records provider key, request-unit usage basis, vendor units, latency and estimated request cost where available for scheduled discovery, fallback/failure and Course detail identity-verification attempts. Security remains 131 INFO / 0 WARN / 0 ERROR; Performance remains 167 INFO / 0 WARN / 0 ERROR.


### A14 active-path audit completion

Active Edge audit confirms exactly three current Layer 2 functions start provider attempts: `layer2-acquire-v2` v9, `layer2-scope-discover-scheduled` v19 and `layer2-scale-qualify-scheduled` v3. All three now retain vendor-unit usage and estimated-cost fields where available in addition to provider/latency/outcome telemetry. No other active Layer 2 provider-attempt starter was found. Post-deploy Security remains 131 INFO / 0 WARN / 0 ERROR; Performance remains 167 INFO / 0 WARN / 0 ERROR.


### A14 Layer 3 active-call audit completion

Active chat-completion audit confirms three current Layer 3 model callers: `layer3-interpret` v3, `layer3-provider-control` v2 and `layer3-source-pattern-benchmark` v7. All retain model identity, external-call count, input/output tokens, latency and cost where available. Interpretation failures now retain call count/latency, and credential verification retains its small token/cost footprint rather than hiding it. New nullable telemetry columns preserve unavailable provider usage without inference. Post-DDL/Edge Security remains 131 INFO / 0 WARN / 0 ERROR; Performance remains 167 INFO / 0 WARN / 0 ERROR.


## Final Stage B integration PASS — 29 August 2026

The final M2.4.2 Stage B integration gate is PASS:
- frozen Pilot source before marker: `69cb9b465de0a00247db381bcbffcc98a6b1f30a`;
- integration marker: `e2eec9b8de0187a5373b506342316ea457b79a0b`;
- deployed UAT run: `33214733610`;
- chromium-desktop: PASS;
- chromium-mobile: PASS.

The final reconciliation preserved all accepted controls:
- A10 paged State/University scope remains capped at 10 options/items per page;
- A12 Course decision-workspace geometry is explicitly tested across desktop/tablet/mobile;
- A13 Firecrawl/Evidence screenshot path remains governed and private;
- transient Evidence-detail 5xx responses are retried only with bounded 5xx-only logic, retained as recovered runtime evidence when a subsequent 2xx succeeds, and remain hard failures if unrecovered;
- no Layer 1 identity, canonical, Search, Publication or secret authority was broadened.

RMIT canonical promotion remains formally BLOCKED with the frozen 212-record cohort unchanged (212/212 identity matched, 0 unsafe, 0 applied; fingerprint `627bb7daa62fe3bbfc3047ce2b57a88e`). This blocker is accepted as a separately carried-forward governed item and does not authorise bypass.

Exactly one final Stage C acceptance candidate remains before CF-CHG-044 can close.


## Final Stage C acceptance result — BLOCKED

The one authorised final Stage C candidate was Pilot `91b115ddf64b020563c7ae6bbd1ea395db866d3f`.

Deployed acceptance run `33215640328`:
- desktop: FAIL;
- mobile: skipped by workflow after desktop failure;
- desktop result: 45 PASS / 1 FAIL.

The only failure was the Course decision-card reorder persistence assertion. A12 had inserted the accepted `Related insights & funding` card between Fees and Locations. The test still assumed the older card topology and expected one `Move Locations up` action to move Locations two positions to first. Runtime correctly performs a one-position swap.

The stale test contract was corrected after the failed gate at Pilot `60e9e25a86a48522dbae7a29d6c2955c9d295761`. This corrective commit does **not** replace, erase or convert the failed Stage C result.

CF-CHG-044 status is therefore:

**BLOCKED — SINGLE FINAL STAGE C FAILED / GOVERNANCE REOPENING REQUIRED**

No second final candidate or silent rerun is authorised. Running Build/Master Project Plan must remain at the prior accepted baseline until an explicit governance decision authorises any future final-acceptance reopening.


## Explicit governance reopening — corrective Stage C

**Authorisation:** User explicitly authorised one corrective M2.4.2 Stage C acceptance run using the corrected UAT contract on 29 August 2026.

Scope of reopening:
- permits exactly **one** corrective Stage C acceptance candidate/run;
- uses corrected Pilot source beginning at `60e9e25a86a48522dbae7a29d6c2955c9d295761`;
- does not erase or replace historical Stage C failure `33215640328`;
- does not broaden Layer 1 identity, canonical, Search, Publication, Evidence, secret or provider authority;
- preserves the RMIT 212-record canonical-promotion BLOCK and Layer 3 source-pattern benchmark BLOCK;
- preserves A14 telemetry;
- if the corrective acceptance run fails, M2.4.2 remains BLOCKED and no further Stage C attempt is authorised without another explicit governance decision;
- if desktop and mobile both PASS, CF-CHG-044/M2.4.2 may close and the Running Build/Master Project Plan may advance.


## Corrective Stage C PASS / M2.4.2 CLOSED — 29 August 2026

The explicitly authorised corrective Stage C is PASS.

- corrected UAT source: `60e9e25a86a48522dbae7a29d6c2955c9d295761`;
- corrective Stage C candidate / accepted Pilot: `093010fada8391c93626b59e59c678064f4961c3`;
- deployed acceptance run: `33219089690`;
- chromium-desktop: **45/45 PASS**;
- chromium-mobile: **45/45 PASS**.

Historical Stage C failure `33215640328` remains retained as immutable evidence. It was not rewritten or removed; the explicit governance reopening authorised exactly one corrective run after the stale pre-A12 reorder assertion was corrected.

Final post-acceptance runtime:
- Security Advisor: 131 INFO / 0 WARN / 0 ERROR;
- Performance Advisor: 167 INFO / 0 WARN / 0 ERROR;
- UQ weekly Course refresh ENABLED;
- RMIT weekly Course refresh DISABLED;
- Federation weekly Course refresh DISABLED; source profile PAUSED/source-limited;
- RMIT frozen cohort remains 212/212 identity matched, 0 unsafe, 0 applied, fingerprint `627bb7daa62fe3bbfc3047ce2b57a88e`;
- RMIT canonical promotion remains separately BLOCKED pending an already-authorised exact frozen-set executor;
- Layer 3 source-pattern benchmark remains separately BLOCKED under its unchanged quality threshold;
- A14 telemetry remains standing and carries into M2.4.3.

M2.4.2 is **CLOSED / PASS** for its accepted Pilot scope.

Accepted programme documents:
- Running Build: `docs/coursefinder-running-build-v2.76.md`;
- Master Project Plan: `docs/coursefinder-master-project-plan-v1.76.md`.

Next gate: **M2.4.3 — Layer 3 AI Operations Maturity**.
