# CF-CHG-20260827-044 — M2.4.2 Layer 2 Full Enrichment, Operations Maturity & Performance

**Status:** ACTIVE — A9 TARGETED PASS / FULL-RUN GATES OPEN  
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
