# CF-CHG-20260915-246 — M2.4.6 Production Operations Contract

**Status:** OPEN — MINIMUM CORRECTIONS APPLIED / FINAL ACCEPTANCE IN PROGRESS  
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

## Demonstrated blocking corrections

### G1 — active wave-request idempotency

Historical runtime contained same-scope/same-route duplicate wave requests. Existing per-profile batch serialization limited duplicate execution, but request creation itself was not idempotent.

Applied Pilot migration:

`20260915083840_cf_246_layer2_wave_request_idempotency_v1`

Implementation and proof:

- partial unique active-request identity on country + scope type + scope id + route mode;
- same-scope starts serialized with a transaction advisory lock;
- repeated start reuses the existing active request;
- runtime active duplicate groups after apply: 0;
- direct `authenticated` execute: false; `service_role` execute: true;
- fresh 5-item AU university wave repeated-start proof returned `active_wave_reused` with the same request id and still only 5 dispatched items.

### G2 — bounded-wave continuation respected

The first bounded exercise exposed a genuine stop-rule defect: calling continuation after a completed first wave dispatched another wave even though `schedule_remaining=false`.

Applied Pilot migration:

`20260915084229_cf_246_wave_schedule_remaining_guard_v1`

Correction:

- a request with `schedule_remaining=false` may dispatch exactly one wave;
- subsequent continuation may reconcile terminal state but must dispatch 0 new items;
- terminal bounded requests are marked completed with `single_wave_limit_enforced=true` and remaining unprocessed scope retained in metadata;
- no scheduler cadence, concurrency, provider routing, Layer authority or publication semantics changed.

Runtime proof on the defect-exposing request:

- after the already-dispatched second batch completed, continuation returned `bounded_wave_complete`;
- `dispatched_now=0`;
- repeated continuation did not create another batch;
- request terminal state: completed, 20 completed, 0 failed, 243 deliberately unprocessed, no next wave.

A fresh post-fix 5-item AU university wave was then started with `schedule_remaining=false`. Immediate duplicate start reused the same request rather than creating duplicate work. Terminal batch proof is the final acceptance item.

## Non-blocking follow-ups

### Shared Evidence reuse configuration

Shared-fetch reuse capability exists in the acquisition runtime, but qualified AU Course profiles do not currently enable it.

**Disposition:** defer unless operational evidence proves repeated acquisition materially blocks safe scale. Do not make this a M2.4.6 prerequisite.

### Generic retry/parking classification

Existing paths have stale recovery, bounded attempts and fail-closed blocked outcomes, but no single generic retry-classification contract across all wave failures.

**Disposition:** defer unless a repeatable failure cannot recover through existing accepted controls. Do not redesign retry logic speculatively.

## Admission-first progress

The accepted CF-245 admission path was reused without new semantics:

- 272 latest qualified official-URL candidates checked;
- 269 eligible/applied;
- 122 canonical changes;
- Search projection applied 122 changed rows;
- website/Search official course URL coverage increased to **527**;
- website v3.1 runtime search with `has_link=true` returns total **527**.

Observed Evidence replay is exhausted for deterministic intake/English additions: 0 additional intake courses and 0 additional English courses. The remaining 457 provider-current-tuition candidates remain in the existing Layer 3 validation backlog and do not block website handover of already-admitted fields.

## Security and authority invariants

This Change Control must not reopen CF-093; weaken rank/identity/RLS/private Evidence boundaries; copy AU qualification assumptions into NZ; introduce generic Layer 3 auto-approval; bypass Layer 4; change scheduler frequency/concurrency merely for throughput; merge acquisition with publication authority; or delay website use of already-admitted data while non-blocking optimisations are investigated.

## Repository / CI

Pilot PR: `#96 — CF-246: make active Layer 2 wave starts idempotent`.

Current PR head: `8c970b683dc2995e88ff655cf2a1586624ac63ee`.

Pilot Frontend Build run `34948479991`: PASS.

## Exact next gate

1. Finish the fresh 5-item post-fix bounded wave and prove terminal continuation dispatches 0 additional work.
2. Merge Pilot PR #96 if the runtime proof remains green.
3. Close CF-246/M2.4.6 and move to M2.4.7 controlled scale.
4. Website handover continues in parallel on the already-live v3.1 dataset; do not wait for enrichment perfection.
