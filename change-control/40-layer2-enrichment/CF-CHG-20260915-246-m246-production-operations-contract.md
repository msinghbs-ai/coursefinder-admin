# CF-CHG-20260915-246 — M2.4.6 Production Operations Contract

**Status:** OPEN — MINIMUM CORRECTION APPLIED / ACCEPTANCE PENDING  
**Milestone:** M2.4.6 — Production Operations Model  
**Opened:** 2026-09-15 AEST  
**Pilot:** `msinghbs-ai/Coursefinder-Pilot`  
**Pilot Supabase:** `fxcwkweaxjtknorudmwp`

## Objective

Close only demonstrated operational gaps that directly block safe bounded enrichment/admission. Do not turn M2.4.6 into an open-ended logic-hardening exercise.

## Permanent stop rule

A newly discovered issue blocks this Change Control only when it directly prevents safe deterministic admission, required security/identity/Layer authority, Search/API correctness, or bounded recovery from an active failure. Otherwise defer it to the owning later gate and continue.

## Reconciled existing operating model

The accepted runtime already provides server-owned/rank-gated wave dispatch, scope eligibility checks, platform wave-size clamping, per-profile serialization, scheduled continuation, stale recovery, Evidence capture, telemetry, provider controls and explicit NZ Course-enrichment blocking.

## Demonstrated gaps

### G1 — active wave-request idempotency

Historical runtime contained same-scope/same-route duplicate wave requests. Existing per-profile batch serialization limited duplicate execution, but request creation itself was not idempotent.

**Disposition:** blocking minimum correction; fixed under this Change Control.

Applied Pilot migration:

`20260915083840_cf_246_layer2_wave_request_idempotency_v1`

Implementation:

- active request identity is country + scope type + scope id + route mode;
- a partial unique index protects active states;
- same-scope starts are serialized with a transaction advisory lock;
- a repeated start reuses the existing active request instead of creating another;
- scheduler frequency, concurrency, provider routing, budgets, Evidence, Layer authority and Search/publication semantics are unchanged.

Runtime proof:

- migration apply: PASS;
- active duplicate groups after apply: 0;
- AU managed read-only preview: 553 queueable courses, 20,540 missing-URL courses; requested 25 / accepted 25;
- direct `authenticated` execute privilege: false;
- `service_role` execute privilege: true.

Pilot PR: `#96 — CF-246: make active Layer 2 wave starts idempotent`.

### G2 — shared Evidence reuse configuration

Shared-fetch reuse capability exists in the acquisition runtime, but qualified AU Course profiles do not currently enable it.

**Disposition:** non-blocking unless the bounded operational exercise proves unnecessary repeated acquisition materially prevents safe progress. Do not add configuration merely for optimisation.

### G3 — generic retry/parking classification

Existing paths have stale recovery, bounded attempts and fail-closed blocked outcomes, but no single generic retry-classification contract across all wave failures.

**Disposition:** non-blocking unless the bounded operational exercise exposes a repeatable failure that cannot safely recover through existing accepted controls. Do not redesign retry logic speculatively.

## Admission-first progress carried into this Change Control

The accepted CF-245 admission path was reused without new semantics:

- 272 latest qualified official-URL candidates checked;
- 269 eligible/applied;
- 122 canonical changes;
- Search projection applied 122 changed rows;
- website/Search official course URL coverage increased to 527;
- website v3.1 runtime search with `has_link=true` returns total 527.

Observed Evidence replay is currently exhausted for deterministic intake/English additions: 0 additional intake courses and 0 additional English courses. The remaining 457 provider-current-tuition candidates stay in the existing Layer 3 validation backlog and do not block website handover of already-admitted fields.

## Security and authority invariants

This Change Control must not:

- reopen CF-093;
- weaken rank/identity/RLS/private Evidence boundaries;
- copy AU qualification assumptions into NZ;
- introduce generic Layer 3 auto-approval;
- bypass Layer 4 consequential authority;
- change scheduler frequency/concurrency merely to increase throughput;
- merge acquisition with canonical/Search publication authority;
- delay website use of already-admitted data while non-blocking optimisations are investigated.

## Exact next gate

1. Accept/merge Pilot PR #96 after targeted CI/runtime review.
2. Run one bounded qualified AU operational exercise through the existing managed path.
3. Fix only a defect that actually blocks that exercise under the stop rule.
4. If green, close CF-246/M2.4.6 and move immediately to M2.4.7 controlled scale while website handover proceeds in parallel.
