# CF-CHG-20260901-054 — M2.5 Layer 3 Source-Pattern Operator Execution & Deterministic Layer 2 Hand-back

**Status:** ACTIVE / CORRECTIVE IMPLEMENTATION  
**Category:** 40-layer2-enrichment  
**Initiated:** 1 September 2026, Australia/Melbourne  
**Owner:** M2.5 Pilot operations maturity  
**Related:** CF-CHG-20260901-053, CF-CHG-20260829-047, CF-CHG-20260830-048  
**Closed M2.4 baseline remains closed:** yes

## Trigger

CF-053 corrected Layer 2 qualification-finalizer starvation. Once deterministic finalization began progressing, the next live bottleneck became visible:

- source-pattern Layer 3 refresh requests are being created correctly;
- those requests are explicitly `manual_governed` / `queued_for_governed_operator_execution`;
- the benchmark-passed `openrouter-source-pattern-v1` profile is enabled and unpaused;
- the Layer 3 operator UI does not expose these Provider-level requests;
- the general `layer3-interpret` Edge Function does not validate `source_pattern` candidates;
- no source-pattern interpretation has ever executed.

Live snapshot at opening:
- Layer 2 pending deterministic pattern dispatch: 257 Providers;
- Layer 2 pending pattern controls: 36 Providers;
- Layer 3 source-pattern refresh queue: 286 queued / 0 completed;
- Layer 3 `source_pattern` interpretations: 0 total.

This is an execution-path defect, not permission to make Layer 3 autonomous.

## Accepted authority preserved

The accepted A23 contract remains authoritative:

- Layer 2 finalization **must not** call `layer3-interpret` directly;
- source-pattern work remains `manual_governed`;
- an authenticated Curator-or-higher operator initiates the model call;
- Layer 3 consumes only governed retained Layer 2 Evidence;
- a Layer 3 URL candidate cannot qualify a Provider by itself;
- a validated Layer 3 candidate must return to Layer 2 deterministic identity controls;
- unresolved/low-confidence/no-candidate outcomes route onward for human source resolution;
- no direct canonical Course URL, Search, Publication or Layer 1 identity mutation is authorised.

## Required corrective flow

### 1. Operator queue

Expose queued `requested_layer=3` / `A23-SOURCE-PATTERN:*` requests in canonical Layer 3 Operations.

Each row must retain:
- refresh request ID;
- Provider/entity ID;
- country;
- source/profile;
- Evidence ID/source URL;
- Layer 3 profile;
- revalidation reference;
- created timestamp;
- status.

### 2. Evidence-bound model execution

Extend the existing `layer3-interpret` worker for `source_pattern`.

For this task only:
- candidate shape = HTTPS URL string or null;
- candidate must use the exact governed first-party host;
- candidate must be an exact link present in retained Evidence;
- the model must be shown a bounded list of governed Evidence links; raw HTML hrefs must not disappear during text normalisation;
- no identity/fee/intake/Search/Publication fields may be requested or returned.

### 3. Completion semantics

The normal Layer 4 field-review creation path is not correct for a valid source-pattern URL because the candidate must first pass deterministic Layer 2 controls.

For `source_pattern`:
- valid candidate → no Layer 4 field review yet;
- no candidate / low confidence → Layer 4 Provider-source resolution;
- provider/model error or validation rejection → original request remains explicitly retryable/blocked; never silently completed.

### 4. Deterministic Layer 2 hand-back

A validated Layer 3 source-pattern candidate must be revalidated server-side, then:
- create a new governed `course_facts` source-profile version;
- set the candidate only as the discovery/catalogue entry point;
- choose the existing three qualification control Courses;
- restore the affected qualification Provider to pattern-control state;
- dispatch the normal Layer 2 discovery control worker;
- require existing exact/likely + CRICOS detail verification;
- only the existing Layer 2 reconciler can promote `authority_class='first_party_qualified'`.

No Layer 3 code may directly set Provider qualification.

### 5. Refresh request lifecycle

- operator claim/execution is bounded and auditable;
- valid hand-back marks the Layer 3 refresh request completed with the downstream Layer 2 dispatch reference;
- unresolved/no-candidate marks it completed only after Layer 4 source-resolution handoff exists;
- failures retain error state and retry context.

## Security requirements

- queue read: authenticated Curator+ only;
- execution: current signed-in Curator+ actor, not service-role impersonation from the browser;
- model credential remains server-side;
- all completion/hand-back helpers that mutate pipeline state are service-role only;
- exact request ↔ Evidence ↔ Provider ↔ model-profile ↔ interpretation ↔ qualification-run linkage must be rechecked server-side;
- candidate URL must be HTTPS, same-host and Evidence-link bound;
- no browser access to private Evidence storage objects;
- no direct canonical/Search/Publication mutation.

## UAT

Minimum targeted gate:

1. source contract proves A23 still forbids automatic Layer 2 → Layer 3 execution;
2. `source_pattern` validator rejects off-host and non-Evidence URLs;
3. queue read exposes governed Provider requests only;
4. zero-call unchanged/in-flight behaviour remains intact;
5. validated test candidate creates no Layer 4 field review;
6. validated test candidate returns to Layer 2 three-control discovery, not Provider auto-qualification;
7. no-candidate/low-confidence path produces Layer 4 source-resolution handoff;
8. request lifecycle is idempotent;
9. anonymous/insufficient-rank operator execution fails;
10. Security and Performance Advisors remain 0 WARN / 0 ERROR;
11. deployed browser UAT when the Pilot Worker deployment path is current.

## Rollback

Restore prior Layer 3 worker/UI/helper definitions. Retained Evidence, interpretations and refresh-request audit rows are not deleted. Any already-created Layer 2 profile version/control dispatch remains governed historical lineage and must not be destructively removed.

## Explicit non-goals

- autonomous/background Layer 3 model execution;
- bulk draining all 286 requests;
- increasing OpenRouter RPM/day limits;
- changing model/profile benchmark;
- bypassing Layer 4 for unresolved source decisions;
- canonical Course URL mutation;
- Search or Publication admission;
- reopening M2.4.
