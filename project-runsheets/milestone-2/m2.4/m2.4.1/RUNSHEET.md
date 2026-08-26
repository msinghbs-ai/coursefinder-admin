# M2.4.1 — Layer 1 Regulatory Operations Maturity & Automation

**Status:** ACTIVE  
**Parent:** M2.4  
**Started:** 26 August 2026 20:52 AEST (+10:00)  
**Accepted starting Pilot:** `ba846abb8f55c0c28d65de9e676bd29ed09a3ab4`  
**Governance:** `PROJECT_INSTRUCTIONS.md`, M2 Standing Instructions, A1–A7

## Objective

Turn Layer 1 from an implementation/diagnostic surface into a mature regulatory-operations workspace for Platform Admin/operators, initially proving the complete lifecycle for Australia and New Zealand while preserving Layer 1 authority, canonical identity, Evidence/provenance and current security boundaries.

## Required operator journey

`Regulatory source → validate source → estimate/identify available records → approve/enable ingestion → queue/run → live progress → retained logs/Evidence → reconciliation → scheduled recheck → housekeeping`

## Reconciled starting state

- M2.4.0 CLOSED/PASS on Pilot `ba846abb…`; current Pilot `main` remains that exact SHA at M2.4.1 start.
- Normal Layer 1 entry is `Data Operations → Layer 1 — Regulatory` through `src/layer1-operations-entry.jsx`.
- The current normal workspace exposes configured/healthy source counts plus Country / Source / Status / Last success only.
- Browser reads use `public.admin_read` as a SECURITY INVOKER boundary, dispatching to private/security helpers with server-side role/rank checks.
- Existing Layer 1 workers create `pipeline.jobs`, retain `pipeline.evidence_artifacts`, source URL/hash and reconciliation details.
- `security.admin_pipeline_ops_read` already derives rich job status/count/failure/completion information, but the Layer 1 page does not surface it.
- AU primary source is `CRICOS Providers, Courses and Locations` at `https://data.gov.au/data/dataset/cricos`; current metadata already retains discovery URL, required resources, source hashes and cursor/batch state.
- NZ primary source is `NZQA Education Organisations` at `https://www.nzqa.govt.nz/providers/index.do`; current metadata already retains worker/hash/cursor state and `total_providers=409`.
- No accepted Layer 1 operations profile currently provides explicit authority-domain validation, source format contract, warn/block variance thresholds, next recheck, pause state, schedule-failure state or retained housekeeping policy.

## Gap matrix

| Target | Starting state | Gap | Priority |
|---|---|---|---|
| Governed source configuration | `pipeline.sources` exists; primary UI read-only | No production-shaped L1 operations profile/version contract | P0 |
| URL availability + authority validation | worker reachability checks | Reachability is not explicit authority/domain qualification | P0 |
| Expected count discovery | NZ metadata has total; AU workers discover totals | Not normalized/presented before unattended run | P0 |
| Variance guardrails | none explicit | Warn/block thresholds absent | P0 |
| Queue/concurrent protection | worker creates jobs | No explicit L1 queue/idempotency/concurrent-source gate | P0 |
| Progress/reconciliation | rich pipeline job projection exists | Not surfaced in normal L1 page; heartbeat incomplete | P0 |
| Evidence drill-through | Evidence linked to jobs | Normal L1 page lacks direct drill-through | P1 |
| Retry/resume/idempotency | bounded offsets/hash exist | No governed operator retry/resume contract | P0 |
| Scheduling/rechecks | M2.3 scheduler substrate exists | No L1 source-profile cadence/next action/pause visibility | P0 |
| Stale/stuck detection | pipeline read flags >30m running | Not L1-specific/operator-actionable | P1 |
| Housekeeping | no explicit L1 retention lifecycle | Must define safe transient cleanup excluding governed provenance | P0 |
| Alerts/telemetry | partial job timing/health | No consolidated L1 operational alert projection | P1 |
| UX | simple shell exists | Needs Source Health → Current/Next Job → Progress → Reconciliation → Evidence → Schedule → Actions | P0 |
| A7 UAT efficiency | A1–A6 implemented in M2.4.0 | Verify setup/cache/mobile cadence before substantial feature loops | P0 |

## Implementation sequence

1. **Slice 1 — control-plane data/read contract:** source operations profile/versioning, authority domains, formats, expected-count/variance policy, cadence/pause/health; safe read projection.
2. **Slice 2 — queue/job state:** duplicate/concurrent protection, idempotency key, heartbeat/stuck/progress/reconciliation projection.
3. **Slice 3 — validation/execution:** AU/NZ source validation/count discovery and variance decision before APPLY; unchanged/hash no-op.
4. **Slice 4 — retry/resume/scheduling/housekeeping:** governed retry/resume, recheck schedule, pause, stale/failed schedule visibility, transient cleanup policy.
5. **Slice 5 — Layer 1 UI:** progressive disclosure and Evidence/Jobs navigation; experimental/destructive controls stay outside the normal journey.
6. **Slice 6 — docs/UAT/security/performance:** targeted → bounded integration → one nominated desktop/mobile acceptance matrix.

## Required UAT

At minimum prove for AU and NZ:

- valid source validation;
- malformed/unapproved URL rejection;
- inaccessible source handling;
- record-count assessment and variance decision;
- queue creation and duplicate-run guard;
- successful end-to-end ingestion;
- progress state transitions;
- parser/validation failure rollback/no partial corruption;
- Evidence/log lineage;
- role/rank/anonymous negative access;
- secret leakage checks;
- replay/idempotency;
- retry/resume where supported;
- scheduled recheck contract;
- housekeeping cleanup without governed provenance deletion;
- desktop/mobile deployed UAT;
- frozen M1/M2 authority regression.

## UAT discipline

- Stage A is targeted during implementation; mobile is not the routine feedback loop unless the slice directly changes responsive Layer 1 behaviour.
- Stage B covers Layer 1 + Evidence + Jobs/Runs + Data Quality + immediate authority/security/replay contracts.
- Stage C is exactly one nominated final SHA full deployed desktop/mobile matrix.
- Deterministic navigation/DOM failures fail fast; long waits are reserved for deploy/ingestion/queue/schedule operations.
- A7 setup/dependency/browser-install overhead is reviewed before substantial repeated browser validation.

## Exit gate

M2.4.1 closes only when AU and NZ can be operated end-to-end from the mature Layer 1 UI with validated sources, governed pre-run count/variance, queue/progress, retained Evidence/logs, safe reconciliation, retry/resume/idempotency, scheduling/recheck/stale-source handling and housekeeping without relying on experimental controls or direct Supabase operations; security negatives, Stage A/B and exactly one Stage C candidate must PASS.
