# CF-CHG-20260827-044 — M2.4.2 Layer 2 Full Enrichment, Operations Maturity & Performance

**Status:** PROPOSED / ACTIVE  
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

`Country → University / catalogue provider → Scope preview → Discover & sync / Sync now → Progress → Results`

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
- Drawer state is refreshed from the persisted provider record and provides a `Saved and verified` confirmation.
- Targeted UAT mutates Firecrawl concurrency only temporarily and restores its original value.

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
- `c10b330dc6b4db52d0c757ddab171b6903ae209e` — Firecrawl persistence targeted UAT;
- `ca190b245252d1a6464db51f785d2d04588800d3` — provider rate guard mirror;
- `c216a02292ab62c097363f6aa73f071b10aedc40` — service-only sync bridge mirror;
- `a575b02f5ad7289770039a06fde8dbd1cf37086a` — authenticated Edge sync source mirror;
- `f3740187597ea77cfffd93788db9eb9c1844e0d8` — browser sync routed through authenticated Edge bridge.

Current browser-facing candidate for this slice is still under targeted build/UAT; it is not an M2.4.2 acceptance candidate.

## UAT

Mandatory staged model remains:

1. Stage A targeted Layer 2 development validation, desktop unless responsive behaviour changes.
2. Stage B bounded desktop/mobile integration covering Layer 2 operations, Admin navigation, Layer 1 regression, Evidence, Data Quality/completeness, Jobs/Runs, Layer 2 performance, immediate Layer 3 fall-out, persistence/state and release notes.
3. Stage C exactly one frozen full permanent deployed desktop/mobile acceptance candidate plus frontend build/browser smoke, final Security/Performance Advisors, ACL/rank/anon negatives and exact runtime/repository reconciliation.

A8 targeted suite now covers:
- Country → university selector journey;
- AU RMIT/UQ/Federation authorised choices;
- scope preview counts and discovery-vs-sync action state;
- no routine bounded-trial control;
- explicit separation of run concurrency from acquisition-vendor concurrency;
- Firecrawl concurrency temporary edit → save/server re-read → close/reopen persistence → restore;
- no credential exposure through provider UI.

Earlier M2.4.2 Stage A operational workspace run `33001852982` remains PASS. The new A8 targeted candidate is awaiting its final current-head build/UAT result and must not be recorded PASS until complete.

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
| 27 Aug 2026 04:28 AEST | PROPOSED / ACTIVE | M2.4.2 initiated from accepted M2.4.1 baseline; no Layer 1 authority change authorised. | M2.4.2 chat |
| 27 Aug 2026 | ACTIVE / A8 | Operator-first sync addendum accepted into current M2.4.2 scope; Country → University/catalogue provider becomes routine launch path. | RUNSHEET Addendum A8 |
| 27 Aug 2026 | ACTIVE / SECURITY CORRECTED | Direct authenticated SECURITY DEFINER sync bridge rejected after Advisor WARN; replaced by authenticated Edge + service-only rank-checked helper. | `layer2-sync-control`, `m2_4_2_operator_sync_service_bridge` |

## Closure

**Final status:** OPEN  
**Closed at:** N/A  
**Outcome:** Pending A8 targeted UAT, full authorised-run evidence, Stage B, final Stage C and remaining M2.4.2 gates.