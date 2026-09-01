# CF-CHG-20260901-054 — M2.5 Layer 3 Source-Pattern Operator Execution & Deterministic Layer 2 Hand-back

**Status:** IMPLEMENTED / SOURCE+ROLLBACK PASS — POST-HTTP-RECONCILE TARGETED CI PENDING; DEPLOYED UI ACCEPTANCE BLOCKED BY PILOT CLOUDFLARE GIT DEPLOYMENT DRIFT  
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


## Implementation & UAT update — 1 September 2026

### Implementation references

Pilot source head after legacy HTTP→HTTPS same-host reconciliation:
`msinghbs-ai/Coursefinder-Pilot@5977642a5568fc2acbc061eacea608ca2fcde450`.

Database:
- `20260901091500_m2_5_layer3_source_pattern_operator_handback.sql` — commit `768ea48997ce23b2024845552d9a3104215cc05c`, deployed to Pilot;
- `20260901091800_m2_5_layer3_source_pattern_legacy_completion_guard.sql` — final syntax-corrected commit `35d1a8035a0f5ee66fe825178e13b123951063fb`, deployed to Pilot;
- `20260901092500_m2_5_layer3_source_pattern_legacy_http_host_reconcile.sql` — commit `5977642a5568fc2acbc061eacea608ca2fcde450`, deployed to Pilot; keeps candidates HTTPS-only while allowing retained legacy HTTP Evidence/source URLs to compare by exact hostname.

Edge:
- `supabase/functions/layer3-interpret/index.ts` — commit `4cd766baed84a3f21e097be7aff594bf559cabf2`;
- deployed Pilot Edge Function `layer3-interpret` **version 9**;
- `verify_jwt=true`;
- deployed SHA-256 `5d47c64f49275a513bebd6edd76562239a9970004cd14081e3ff2d30efb3fd92`.

Admin source:
- `src/m2-3-intelligence-entry.jsx` — commit `5b1d9b5ec884e810fe992973ff59bfdcf747e575`;
- source UI release **v2.15.17**;
- dedicated manual-governed Provider source-pattern queue; no run-all/background drain action.

Permanent contract:
- `tests/uat/m2-5-layer3-source-pattern-operator-contract.spec.mjs`;
- final targeted workflow run `33491843514`;
- job `99804902558`;
- **PASS** on Chromium desktop targeted tier;
- commit status `coursefinder/deployed-uat/targeted/chromium-desktop = success`.
This is a source/server contract gate; it does not prove the stale external Cloudflare Worker contains v2.15.17.

### Rollback-only live Pilot UAT

All consequential-path tests ran inside transactions and were rolled back.

Validated source-pattern candidate:
- synthetic interpretation `05400000-0000-0000-0000-000000000001`;
- governed UNSW request `b7ed5652-9255-4a8a-becf-4cadf6dab245`;
- candidate `https://www.unsw.edu.au/study`;
- generated one temporary CF-054 Layer 2 profile version;
- returned the Provider to the normal Layer 2 pattern-control path;
- generated a downstream bounded discovery request inside the transaction;
- Provider authority remained `qualification_candidate`;
- generic Layer 4 field-review rows = **0**;
- canonical mutation authority = **false**.

No-candidate path:
- synthetic interpretation `05400000-0000-0000-0000-000000000002`;
- interpretation status `no_candidate`;
- generic Layer 4 field-review rows = **0**;
- exactly one Provider source-resolution request created;
- Provider authority remained `qualification_candidate`;
- canonical mutation authority = **false**.

Idempotency:
- synthetic interpretation `05400000-0000-0000-0000-000000000003`;
- second hand-back returned `idempotent=true`.

Post-rollback verification:
- all three synthetic interpretations = **0 remaining**;
- CF-054 profile versions = **0 remaining**;
- original UNSW source-pattern request returned to `queued`;
- original UNSW qualification sample rows remained `layer3_required`.

Negative security proof:
- an actor with no governed role is rejected by the source-pattern request-context service;
- result: `curator_role_negative_pass`.

Post-change advisors:
- Security: 146 INFO / **0 WARN / 0 ERROR**;
- Performance: 173 INFO / **0 WARN / 0 ERROR**.

### Current backlog observation

At final reconciliation:
- Layer 2 Providers awaiting deterministic pattern dispatch: **233**;
- pending Layer 2 pattern controls: **60**;
- source-pattern Layer 3 requests: **390 queued / 0 completed / 0 failed**;
- live source-pattern interpretations: **0**.

This is intentional at this gate: CF-054 makes the manual-governed execution path usable but does not autonomously drain the queue or increase the model profile's 10/minute, 30/day limits.

### Additional rollback-only legacy HTTP→HTTPS proof

A live queued University of Sydney source-pattern request exposed a legacy source/Evidence origin using `http://sydney.edu.au`. The source-pattern candidate contract correctly remains HTTPS-only, but the original hand-back host parser accepted only `https://` on both sides and would reject a legitimate same-host HTTPS upgrade.

Correction:
- host extraction now accepts `http://` or `https://` for retained Evidence/source lineage;
- the Layer 3 candidate itself still must match `^https://`;
- same-host and exact Evidence-link validator flags remain mandatory.

Rollback-only proof:
- request `17b6d075-81d3-4add-b321-b9a3a9a0c30f`;
- Provider: The University of Sydney;
- retained Evidence origin: `http://sydney.edu.au`;
- synthetic candidate: `https://sydney.edu.au/study/study-areas/law.html`;
- hand-back returned `path=layer2_identity_control`;
- exactly three Layer 2 control Courses were selected;
- `provider_qualified=false`;
- canonical/Search/Publication mutation authority remained false;
- temporary profile version and dispatch state were fully rolled back;
- original request remained `queued` and all 10 qualification items remained `layer3_required`.

No-candidate rollback proof on the same request returned `path=layer4_source_resolution` with one governed Provider source-resolution handoff and no Provider qualification/canonical mutation.

Current post-correction checkpoint:
- pending deterministic Provider dispatch: **227**;
- pending Layer 2 pattern controls: **66**;
- source-pattern requests: **422 queued / 0 completed**;
- live source-pattern interpretations: **0**;
- no real model call and no bulk queue drain were performed;
- Security Advisor: **146 INFO / 0 WARN / 0 ERROR**;
- Performance Advisor: **172 INFO / 0 WARN / 0 ERROR**.

The post-09:25 targeted source-contract was triggered by Pilot commit `dbd7bdde61e28fa49170875786066d7015ccd77d`. At handback GitHub had not yet published a commit status/run ID. Per operating instruction, do not poll/wait in-chat; check that commit on the next user `Proceed` and record the resulting run/job.

### Post-reconcile targeted CI correction

Post-HTTP-reconcile trigger `dbd7bdde61e28fa49170875786066d7015ccd77d` produced workflow run `33492617096` / job `99807392499` = **FAIL**, but the failure was isolated to the permanent test harness:
- Playwright parser error: unterminated string constant in `m2-5-layer3-source-pattern-operator-contract.spec.mjs`;
- no CF-054 runtime assertion executed;
- no model call executed;
- no database/Edge regression was observed.

The malformed assertion was corrected on Pilot commit:
`1605d15bca7ccb46620ce5bd12ca01805a3f30f4`.

That commit is the clean targeted-rerun trigger. At handback GitHub had not yet attached a workflow status/run ID. Per operating instruction, do not poll in-chat; check `1605d15b...` first on the next Proceed.

### Deployed Admin blocker

The Pilot Admin source is v2.15.17, but the Cloudflare Worker is not publishing current `main`.

Reconciliation:
- `wrangler.jsonc` still declares Worker `coursefinder-pilot`;
- assets directory remains `./dist`;
- historical project records identify Cloudflare external Git integration as the deployment mechanism;
- the GitHub deployed-UAT workflow contains no Cloudflare deployment step;
- CF-053 browser run `33488961340` and rerun both proved the Worker was serving an older bundle.

No Cloudflare control-plane connector is available in the current execution environment, so the external Git integration cannot be repaired or inspected here. The correct next action is to reconcile the Cloudflare `coursefinder-pilot` Git integration against `msinghbs-ai/Coursefinder-Pilot` / `main`, then rerun CF-053 and CF-054 deployed browser acceptance without weakening either test.

## Current status decision

**IMPLEMENTED / SOURCE+ROLLBACK PASS — DEPLOYED UI ACCEPTANCE BLOCKED.**

No real source-pattern AI request was executed and the 390-item queue was not bulk-drained. M2.4 remains CLOSED/PASS.
