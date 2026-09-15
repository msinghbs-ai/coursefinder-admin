# CF-CHG-20260915-246 — M2.4.6 Production Operations Contract

**Status:** CLOSED / PASS  
**Milestone:** M2.4.6 — Production Operations Model  
**Opened:** 2026-09-15 AEST  
**Closed:** 2026-09-15 AEST  
**Accepted Pilot:** `90ddbdf28bfad57eb8d5a0ede1b8e506e252908a`  
**Pilot Supabase:** `fxcwkweaxjtknorudmwp`

## Objective and stop rule

Close only demonstrated operational gaps that directly block safe bounded enrichment/admission. A newly discovered issue blocks only when it directly prevents safe deterministic admission, required security/identity/Layer authority, Search/API correctness, or bounded recovery from an active failure. Other improvements move to their owning later gate.

## Accepted corrections

### G1 — active wave-request idempotency

Applied migration: `20260915083840_cf_246_layer2_wave_request_idempotency_v1`.

- active identity is country + scope type + scope id + route mode;
- partial unique index protects active states;
- same-scope starts are serialized;
- repeated start reuses the existing active request;
- active duplicate groups after apply: 0;
- direct authenticated execute remains denied; service-role execution remains allowed.

### G2 — bounded-wave continuation

A bounded runtime exercise exposed that `continue` could dispatch another wave even when `schedule_remaining=false`. This violated the operator-selected bound and therefore met the stop rule.

Applied migration: `20260915084229_cf_246_wave_schedule_remaining_guard_v1`.

- a bounded request may dispatch exactly one wave;
- later continuation reconciles terminal state but dispatches 0 additional work;
- terminal request retains the deliberately unprocessed remainder for later explicit work;
- no scheduler cadence, concurrency, provider routing, Evidence, Layer authority or publication semantics changed.

## Final clean runtime acceptance

Fresh AU university managed request: `59857937-89e9-4c7c-be18-e96008a92e1d`.

- requested/accepted wave: 5;
- immediate repeated `start` returned `active_wave_reused` with the same request id;
- one batch only;
- 5/5 processed;
- 5 bounded Layer 3 handoffs;
- 0 blocked;
- provider cost: USD 0;
- terminal `continue`: `bounded_wave_complete`, `dispatched_now=0`;
- final request: completed, 5 completed, 0 failed, 258 scope items deliberately unprocessed, no next wave;
- `single_wave_limit_enforced=true`.

Pilot PR #96 (`CF-246: enforce idempotent bounded Layer 2 waves`) merged to main as `90ddbdf28bfad57eb8d5a0ede1b8e506e252908a`.

Pilot Frontend Build `34948479991`: PASS.

## Admission-first progress retained

The accepted CF-245 admission path was reused without new semantics:

- 272 latest qualified official-URL candidates checked;
- 269 eligible/applied;
- 122 canonical changes;
- Search projection applied 122 changed rows;
- website/Search official-course-URL coverage: **527**;
- website v3.1 `has_link=true` runtime search returns total **527**.

Current deterministic observed-Evidence replay has 0 additional intake and 0 additional English candidates. The 457 provider-current-tuition candidates remain in the existing bounded Layer 3 validation backlog and are not a prerequisite for website handover.

## Deferred non-blocking work

Shared-fetch reuse configuration and a generic cross-wave retry taxonomy remain evidence-led M2.4.7+ follow-ups only. They must not be reopened as M2.4.6 blockers without measured scale evidence.

## Security and authority invariants

CF-093 remains closed. AU qualification is not copied into NZ. No generic Layer 3 auto-approval was introduced. Layer 4, private Evidence, rank/identity, RLS, scheduler cadence/concurrency and Search/publication authority were preserved.

## Closure

M2.4.6 has a proven minimum production-like operating contract and is CLOSED / PASS / FROZEN. Successor: **M2.4.7 — Controlled Operational Scale**.
