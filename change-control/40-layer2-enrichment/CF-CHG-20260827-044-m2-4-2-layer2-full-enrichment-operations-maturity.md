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

## Affected surfaces / related workstreams

- `pipeline.layer2_source_profiles` and immutable profile versions;
- `pipeline.layer2_acquisition_providers` and profile-provider routes;
- `pipeline.layer2_execution_policies`;
- `pipeline.layer2_provider_attempts`;
- `pipeline.layer2_run_batches` / `pipeline.layer2_run_items`;
- Layer 2 discovery/candidate/completeness state;
- `pipeline.jobs` and `pipeline.evidence_artifacts`;
- Layer 2 Edge/server acquisition/extraction runtimes;
- `public.admin_read` Layer 2 dispatch and governed Layer 2 control bridges;
- Data Operations → Layer 2 browser workspace;
- Evidence, Jobs/Runs, Data Quality and immediate Layer 3 fall-out contracts;
- M2.4 guides/runbooks/release notes and staged UAT.

Related standing controls: CF-CHG-20260826-042, CF-CHG-20260826-043, M24-FU-002, M24-FU-005, M24-FU-006, M24-FU-007.

## Semantic impact

No canonical identity or Layer 1 authority change is authorised. Layer 2 remains deterministic acquisition/extraction and may create governed facts/Evidence only through accepted contracts. Layer 3 receives governed unresolved fall-out only. Layer 4, Search and Publication authority remain unchanged. NZ first-party Layer 2 Course enrichment remains deferred unless separately source-qualified and authorised.

Operational semantics may be extended additively for run state, provider telemetry, cost/quota classification, recovery, schedules, housekeeping and Layer 3 fall-out visibility.

## Before

- Accepted M2.1/M2.3 Layer 2 platform exists with source profiles, providers/routes, attempts, Evidence and trial/completeness tooling.
- Deployed reconciliation at M2.4.2 start: 6 source profiles, 13 profile versions, 6 acquisition providers, 26 routes, 103 provider attempts, 4 execution policies, 1 run batch, 3 run items and 1,699 Evidence artifacts.
- Full authorised Layer 2 enrichment and production-shaped run management are not yet proven.

## After

Layer 2 can be operated as a bounded routine enrichment service across authorised scope, with pre-run eligibility counts, queue/run progress, provider/source performance, deterministic extraction outcomes, Evidence/provenance, completeness/fall-out, governed retry/resume/recovery, scheduling/concurrency, cost/quota/throughput visibility, safe housekeeping, alerts and measured full-run performance.

## Source authority / evidence

- `PROJECT_INSTRUCTIONS.md`;
- M2 Standing Instructions and A1–A7;
- `docs/coursefinder-database-architecture-v2.10.42.md`;
- `docs/coursefinder-master-project-plan-v1.75.md`;
- `docs/coursefinder-running-build-v2.75.md`;
- M2.4 and M2.4.1 current-state/follow-up records;
- accepted Pilot baseline `ed41ea4d7d6672e871cd4ce401bfca24fe3eb64d`;
- deployed Pilot Supabase project `coursefinder_Pilot` reconciled at start.

## Implementation references

- Supabase migration(s): pending
- Edge functions: pending
- Git repository/commit(s): pending
- RPC/API objects: pending additive reconciliation of existing Layer 2 contracts
- UI version: baseline PIM Admin v2.15.7; next browser-facing version pending

## UAT

Mandatory staged model:

1. Stage A targeted Layer 2 development validation, desktop unless responsive behaviour changes.
2. Stage B bounded desktop/mobile integration covering Layer 2 operations, Admin navigation, Layer 1 regression, Evidence, Data Quality/completeness, Jobs/Runs, Layer 2 performance, immediate Layer 3 fall-out, persistence/state and release notes.
3. Stage C exactly one frozen full permanent deployed desktop/mobile acceptance candidate plus frontend build/browser smoke, final Security/Performance Advisors, ACL/rank/anon negatives and exact runtime/repository reconciliation.

Required positive/negative/recovery/regression cases are maintained in the M2.4.2 runsheet and evidence record.

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

## Closure

**Final status:** OPEN  
**Closed at:** N/A  
**Outcome:** Pending implementation, staged UAT, security/performance gates and full authorised-run evidence.