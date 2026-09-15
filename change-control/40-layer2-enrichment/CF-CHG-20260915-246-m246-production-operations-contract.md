# CF-CHG-20260915-246 — M2.4.6 Production Operations Contract

**Status:** OPEN / GATE B RECONCILED — BOUNDED CORRECTION REQUIRED  
**Milestone:** M2.4.6 — Production Operations Model  
**Opened:** 15 September 2026 AEST  
**Category:** 40-layer2-enrichment  
**Accepted predecessor:** M2.4.5 / CF-245 CLOSED-PASS at Pilot `e62c01cadaf43efa8c3d8ea57625c23874d1b010`  
**Pilot Supabase:** `fxcwkweaxjtknorudmwp`  
**Production:** not provisioned; M2.5 remains paused until M2.4.9 GO

## Purpose

Prove and harden the practical Layer 2 production-like operating contract before broad AU/NZ scale. This Change Control is limited to gaps demonstrated by repository/runtime reconciliation. It does not authorise throughput expansion, NZ Course enrichment, generic Layer 3 auto-approval, broad publication or Production provisioning.

## Reconciled existing operating model

The accepted runtime already provides:

- rank-gated server-side `layer2_wave_scope_service` for country/state/university scopes;
- wave-size clamp: requested size is capped at 1,000 Courses;
- managed route Direct HTTP → Firecrawl → governed fallback, plus qualified scraper-first routing;
- `requested_by` actor attribution on wave requests and batch creation;
- `svc_layer2_wave_scheduler()` every 15 minutes for `schedule_remaining` requests;
- per-profile active-batch serialisation in `security.layer2_wave_dispatch_request`;
- execution-policy snapshots with batch size, routing strategy, paid-attempt ceiling, vendor-unit/cost ceilings where configured, Layer 3 handoff flag, identity-mismatch stop flag and concurrency;
- stale batch recovery before execution;
- item-level retry counters/attempt timestamps and CF-245 operational telemetry;
- `layer2-acquire-v2` shared-fetch reuse capability, provider budgets, cost-known checks, Evidence retention and content-hash duplicate cleanup;
- current hard block on NZ Layer 2 Course execution;
- operational owner on qualified AU Course profiles: `PIM/Data Operations`.

## Demonstrated gaps

### G1 — wave-request idempotency / duplicate active request protection

`public.layer2_wave_scope_service(..., p_action='start', ...)` inserts a new wave request without checking for an already-active equivalent request. Historical runtime contains same-scope/same-route wave requests created at identical timestamps. Batch-level profile serialisation reduces simultaneous execution but does not make the request layer idempotent.

Required correction:

- equivalent active country/state/university wave requests must deduplicate server-side;
- a repeated start returns/reuses the active request rather than creating another request ledger;
- completed historical requests remain immutable evidence;
- dedupe must not merge different route modes or materially different scope identity.

### G2 — Evidence reuse capability exists but is disabled on qualified AU Course profiles

`layer2-acquire-v2` already supports `reuse_shared_fetch=true` plus `shared_fetch_ttl_hours`, but current qualified AU Course profiles (RMIT, Federation, UQ) do not set either field. All three have a governed freshness SLA of 168 hours.

Required correction:

- introduce a governed profile-version update enabling shared-fetch reuse only within a bounded TTL that cannot exceed the profile freshness SLA;
- preserve URL/profile/source authority and Evidence lineage;
- reuse must report zero new provider cost/units and retain explicit shared-fetch provenance;
- expired or non-matching Evidence must fall through to normal provider acquisition.

The initial candidate TTL for acceptance is **24 hours**, deliberately below the accepted 168-hour freshness SLA. It must be validated against existing source/profile semantics before APPLY.

### G3 — failure state is fail-closed but retry/parking semantics are implicit

The batch runner currently marks acquisition/normalisation/extraction/runtime failures `blocked`. Retry counters exist, but there is no generic wave-level automatic retry loop or explicit parked state. This is safer than uncontrolled retries but is operationally ambiguous.

Required correction:

- define retryable versus terminal failure classes server-side;
- keep deterministic/identity/security/qualification failures terminal/blocked;
- permit bounded retry only for explicitly transient classes and never beyond the existing policy ceiling;
- when retry ceiling is reached, retain a parked/blocked terminal state and actionable reason rather than cycling indefinitely;
- stale recovery remains separate from provider retry;
- no browser-side retry loop.

## Gate sequence

1. **B1 — contract design:** exact active-request identity, Evidence reuse TTL, retryable failure classes and terminal stop conditions documented.
2. **B2 — runtime correction:** implement server-side active-request dedupe and bounded retry/parking semantics; version only explicitly qualified AU profiles for Evidence reuse.
3. **B3 — targeted security/contract UAT:** operator-rank negative path, idempotent repeated start, route/scope separation, Evidence hit/miss/expiry, retry ceiling, terminal failure and stale recovery.
4. **B4 — bounded integration:** one qualified AU provider/course cohort; no broad scale.
5. **B5 — telemetry reconciliation:** request/batch/item owner, reused Evidence, attempts, vendor units/cost, stop reason and resulting coverage/outcome remain observable.
6. **B6 — deployed browser acceptance:** normal operator journey from primary Layer 2/Scheduled Tasks/Jobs/Evidence surfaces as applicable.
7. **B7 — close Gate B and carry resource-control/ownership evidence into M2.4.6 Gates C–E.

## Security / authority invariants

- service-role and operator-rank boundaries remain unchanged;
- Layer 1 identity remains authoritative;
- Layer 2 remains deterministic acquisition/extraction;
- Layer 3 consumes governed Evidence and receives no generic canonical-write authority;
- Layer 4 remains terminal human resolution for consequential ambiguity;
- Search/Publication remain downstream consumers;
- no public/anon access to private operational/Evidence tables;
- no new secret exposure;
- NZ Course enrichment remains blocked pending independent qualification;
- no scheduler frequency or concurrency increase is authorised by this Change Control.

## Rollback

- revert new migration/profile versions/Edge changes introduced by CF-246;
- restore predecessor function/profile versions;
- retain created operational/Evidence history for audit rather than deleting it;
- if Evidence reuse causes unexpected source-currentness behaviour, disable reuse on the affected profile and fall back to the accepted acquisition route while preserving captured Evidence.

## Exact next action

Implement G1 first because it is a request-ledger safety/idempotency correction independent of provider calls. Then implement G2 profile-version changes and G3 bounded retry classification under targeted tests before any runtime exercise.
