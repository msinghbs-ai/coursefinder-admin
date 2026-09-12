# M2.4.5 SYSTEM METRICS

**Status:** ACTIVE METRICS LEDGER  
**Established:** 2026-09-12 AEST  
**Milestone:** M2.4.5 / CF-CHG-20260910-093  
**Pilot Supabase:** `fxcwkweaxjtknorudmwp`

## Recording rule

For consequential ingestion, discovery, enrichment, scheduler, UAT and recovery runs, retain measurable system/tooling evidence here or in a linked milestone metrics record. Record observed values only; do not manufacture unavailable cost, latency or token data. Each snapshot should preserve the applicable repository head, runtime/worker versions, scope, job/batch/request identifiers, elapsed time where derivable, disposition counts, provider/tool routing, CI/UAT result and any cost/usage telemetry exposed by the governed runtime.

Metrics are evidence, not acceptance criteria unless a Change Control explicitly promotes a threshold to a gate.

## Standard capture fields

| Area | Capture |
|---|---|
| Repository | Pilot/Admin commit or PR head; release where applicable |
| Runtime | Supabase project, Edge Function version, worker/runtime version |
| Scope | country/state/provider/university, Layer, record count |
| Scheduler | Preview token, binding, pg_net/request IDs, continuation count |
| Discovery | attempted, selected, terminal-negative, transient/unattempted, disposition split |
| Deterministic L2 | batch ID, target count, terminal status split, elapsed time, observed throughput |
| Layer 3 | eligible count, provider/model/profile version, calls/tokens/cost/latency when exposed |
| Acquisition tooling | provider keys/routes, vendor units, request cost estimate, response latency when exposed |
| Evidence | evidence counts/types and visual/screenshot coverage where relevant |
| CI/UAT | workflow/run ID, exact tested head, result, duration where available |
| Platform | Edge deployment version/hash, Cloudflare preview/deploy state, relevant database migration IDs |
| Safety | canonical mutation, Search/Publication and generic Layer3 effects explicitly checked |

## Current repository / CI snapshot — 12 Sep 2026

- Accepted Pilot main: `63c7107cfce2d8f607fc378af4881d0ba28ca879`.
- Visible accepted release: v2.15.78.
- Active PR #72 branch: `m245/cf093-async-discovery-20260912`.
- Exact PR head: `a7283139a9e6088933be68fa69f75d2e9eb71fbe`.
- Exact-head Pilot Frontend Build: GitHub Actions `34681032426` — PASS.
- Exact-head Cloudflare commit/branch preview: PASS/deployed.
- Exact-head Codex review: unavailable because the account has reached its code-review usage limit; this is a tool-quota blocker, not a review outcome.
- Intermediate head `eec6fbbfe04709d81150825fe70e31eb3cc8f7f9` / run `34677940824`: FAILED at UAT suite discovery because CF-093 freshness UAT referenced nonexistent migration alias `20260912032000...`; corrected at `a7283139...` to applied `20260912031356...`.

## CF-093 — UQ 382-course acceptance snapshot

### Runtime/tooling

- `layer2-scope-discover-scheduled`: Edge Function v26; worker `layer2-scope-discover-scheduled-v1.3.8` during accepted run.
- `layer2-batch-runner`: Edge Function v8 during accepted run.
- UQ source-profile version: `3d70516d-95d5-49e6-b33e-e61bacfec275`.
- Security boundary retained: scheduled discovery remained under the existing one-time nonce/service-RPC contract; no browser/public privilege broadening.

### Corrected discovery / handoff

Initial v1.3.7 acceptance exposed a zero-result terminal-classification defect. Worker v1.3.8 corrected first-party usable empty search results to governed `current_page_not_found` Evidence without fabricating a URL. Targeted requests `5847`–`5854` closed the remaining 42 unresolved courses with zero worker failures.

Final original bound-discovery set:

| Outcome | Courses |
|---|---:|
| CRICOS-verified selected current URL | 245 |
| Governed terminal negative | 131 |
| **Total** | **376** |

The corrected fresh-preview contract then represented the 382-course scope as 251 executable + 131 fresh terminal negatives, with zero rediscovery of those negatives.

### Corrected deterministic rerun / replay

- Preview token: `feddbf8a-482b-4826-889a-fcfb315ec861`.
- Exact scope fingerprint: `66c66f1d04bbc289e3cec1f7cd7faf3d`.
- Batch: `5b2bac73-0cd4-4a7f-9487-2baf3ab1443f`.
- Dispatch request: `5882`.
- Target count: 251.
- Policy-derived dedupe horizon: 30 minutes.
- Same-token replay: PASS, `idempotent_replay=true`, no duplicate batch.
- Batch elapsed: approximately 14m13.5s.
- Terminal: 248 `resolved_l2` + 3 `layer3_required`; no failures/outstanding items.
- Vendor units: 251.
- Recorded vendor cost: USD 0.
- Evidence records observed for the rerun: 502.
- Resolved-item mean response: approximately 675.2ms.
- Resolved-item mean extraction: approximately 1503.7ms.
- 3 L3-required items mean response: approximately 242.3ms; mean extraction approximately 1449.7ms.

A pre-correction fresh-preview dedupe attempt created duplicate batch `f4436f47...`; it was governed-cancelled with zero processed items. Completion-anchored dedupe was then corrected and the fresh-preview proof reused `5b2bac73...` with `existing_recent_dispatch=true`; no third execution was created.

Safety checks: no generic Layer 3 interpretations/jobs, Search refresh signals, Layer 4 publication decisions, publication events or publication approvals from the scheduler/L2 path.

## CF-093 — RMIT 500-course acceptance snapshot

### Preview / binding

- Profile: `726918ee-10e9-41e3-9a2a-5dace20af754`.
- Profile version: `409b0f7c-4e04-4a33-8f4d-e173fc3f9c40`.
- Preview token: `c3e73796-d2d3-486e-b3a4-83afc54b806d`.
- Actor: `63ba56cb-48d4-4169-98c2-7c4d1f72925b`.
- University scope ID: `8e1adb6c-e069-43db-9584-bd054255e702`.
- Scope fingerprint: `14ff4e15dd39bc46f785f4e03ca3b3dc`.
- Catalogue scope: 500 Courses.
- Initial queueable: 261.
- Preview-bound discovery: 239.
- Invalid-profile / execution-policy / acquisition-route / oversize / discovery-config gaps: 0.
- Binding activated: `2026-09-12 03:56:02.406678Z`.
- Execution expiry: `2026-09-12 09:56:02.406678Z`.
- Initial discovery request: `5909`.
- Processing mode: `acquisition_only`.
- Existing execution policy remained `max_concurrency=1`; it was not changed mid-acceptance.

### Discovery

The serial governed discovery chain used the existing RMIT route and was materially slower than UQ. Terminal request `5965` failed closed because 15 courses remained transient/unattempted: 10 had no current attempt and 5 retained transient `candidate` state. No threshold or identity rule was relaxed.

A bounded retry redispatched exactly those 15 under the same active binding as request `5966`:

- processed: 15;
- selected: 0;
- failed: 0;
- remaining: 0;
- continuation: none;
- all 15 ended an allowed terminal-negative status.

Final 239-course discovery:

| Outcome | Courses |
|---|---:|
| CRICOS-verified selected current URL | 2 |
| Governed terminal negative | 237 |
| **Total** | **239** |

- Discovery wall clock from binding activation to handoff: approximately 6895s / 1h54m55s.
- Observed discovery throughput: approximately 2.08 Courses/minute.
- This figure reflects serial source acquisition/fallback behaviour and is not an SLA.

### Deterministic Layer 2

- Batch: `c8a33237-d2b5-47c3-a02b-2676cb6b820f`.
- Handoff request: `5967`.
- Batch target: 263 = 261 prior queueable + 2 newly selected.
- Requested scope: 500.
- Terminal negatives excluded from L2 target: 237.
- Batch created: `2026-09-12 05:50:57.510697Z`.
- Batch completed: `2026-09-12 06:11:31.218367Z`.
- Elapsed: approximately 1234s / 20m34s.
- Observed throughput: approximately 12.79 items/minute.
- Batch terminal state: `partial`.

| L2 item status | Count |
|---|---:|
| `resolved_l2` | 213 |
| `layer3_required` | 50 |
| **Total** | **263** |

Acquisition telemetry across the 263 L2 items:

| Metric | Observed |
|---|---:|
| Vendor units | 263 |
| Recorded vendor cost | USD 0 |
| Mean response latency | 1647.0 ms |
| p50 response latency | 1621 ms |
| p95 response latency | 1884.2 ms |
| Mean extraction latency | 1730.6 ms |
| p50 extraction latency | 1672 ms |
| p95 extraction latency | 2114.6 ms |

### Safety / boundary evidence

- 263 succeeded `layer2_acquisition_v2` jobs during the deterministic run.
- No generic Layer 3 job type was created by the scheduler/L2 path.
- Search refresh signals during the deterministic batch window: 0.
- Runtime async handoff explicitly recorded `canonical_mutation_authorised=false`.
- Runtime async handoff explicitly recorded `search_publication_authorised=false`.
- `layer3_required` is a deterministic L2 terminal disposition only; it does not prove or authorise Layer 3 execution.

### Replay/dedupe evidence limitation

RMIT same-token/fresh-preview live replay was not executed before the 30-minute completion-anchored recent-dispatch window elapsed. Do not create another 500-course batch solely to recreate that expired timing proof. The accepted UQ run provides live same-token and fresh-preview dedupe evidence for the same corrected scheduler contract, and targeted CF-093 UAT covers applied terminal-negative/completion-dedupe migration identities. Repeat the RMIT-style replay proof naturally on a future governed execution if it falls within the live window.

## Comparative observations: UQ vs RMIT

- RMIT discovery was substantially slower and selected a much smaller fraction of discovery-required Courses than UQ. Treat this as source/profile/tooling behaviour requiring future qualification evidence, not grounds to weaken identity rules.
- RMIT deterministic L2 throughput (~12.79 items/min) was lower than the earlier UQ accepted run (~18.4 items/min) and the corrected UQ rerun. These are observed acceptance figures, not capacity commitments.
- RMIT produced 50/263 (~19.0%) `layer3_required`, materially above UQ's 3/251 (~1.2%). The next Layer 3 gate should inspect whether this reflects source content structure, field coverage, profile semantics or expected deterministic fall-out before broadening AI use.
- Both runs preserved Search/Publication separation and did not trigger generic Layer 3.

## Next metrics capture

For the bounded Layer 3 gate, capture eligible Evidence count, exact profile/model/provider/revalidation version, calls, success/failure disposition, tokens, recorded cost, response latency, evidence consequences and zero unauthorized publication/Search effects. Do not infer token/cost values that the runtime does not expose.
