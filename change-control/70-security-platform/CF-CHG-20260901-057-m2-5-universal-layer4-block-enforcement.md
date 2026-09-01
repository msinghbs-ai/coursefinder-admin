# CF-CHG-20260901-057 — M2.5 Universal Layer 4 Block Enforcement

**Status:** IMPLEMENTED / RUNTIME PASS — TARGETED CI PENDING  
**Category:** 70-security-platform  
**Initiated:** 1 September 2026, Australia/Melbourne  
**Owner:** M2.5 security/platform maturity  
**Parent readiness gate:** `CF-CHG-20260901-049`  
**Related follow-up:** `M25-FU-012`  
**Depends on:** `CF-CHG-20260901-051` Layer 4 block-decision foundation  
**M2.4 baseline:** remains CLOSED/PASS; this change does not reopen it.

## Trigger

CF-051 introduced append-only Layer 4 block decisions with independent scopes:
- `operational`;
- `publication`;
- `search`;
- `data_quality_quarantine`.

The ledger and effective-state helper are deployed, but live function inventory on 1 September 2026 proved that no owning mutation/publication/Search/data-quality path currently calls the block predicate. The ledger is therefore advisory rather than enforceable.

## Accepted semantics

### Reversible governance state

Blocking:
- is append-only state;
- does not delete source data;
- does not rewrite canonical values merely to represent the block;
- preserves actor, reason, time, expiry/review and supersession history;
- is independently reversible per scope.

### Provider inheritance

For operational, publication, Search and quarantine evaluation:
- a direct entity block applies to that entity;
- a Provider block also applies to its child Courses and Campuses;
- a Provider block applies to Provider-owned Scholarships;
- Provider-contact records inherit their Provider's state.

The Provider decision remains visible as Provider-level governance; child canonical records are not rewritten.

### Layer 1 authority remains ingestible

An `operational` block does **not** suppress authoritative Layer 1 regulatory observations. Regulatory truth must continue to be recordable so CourseFinder does not lose source-of-truth history while an entity is under operational restriction.

Operational enforcement instead applies to:
- Layer 2 enrichment/application;
- Layer 3 model reservation/execution;
- scheduled/non-regulatory enrichment paths as they are brought under owning gates.

Human Layer 4 governance actions remain available so an authorised operator can correct/review/unblock an entity.

## Enforcement owners

### Operational

Server-side hard gate:
- `public.svc_coursefacts_apply_record(...)` — reject `p_apply=true` for Course or inherited Provider operational block;
- `public.layer3_reserve_interpretation_service(...)` — return/raise blocked before reserving an external model call;
- `public.layer3_source_pattern_request_context_service(...)` — Provider source-pattern request becomes non-executable while operationally blocked.

No model call or Layer 2 canonical enrichment mutation may begin after the effective block is observed.

### Publication

- `publishing.course_publication_readiness_v1(...)` must emit a Layer 4 publication blocker for a directly/inherited blocked Course;
- `publishing.set_course_publication_v1(...)` already requires readiness for `published` / `internal`, so the new readiness blocker prevents those transitions;
- `l4_api.publication_decide(...)` may still record `not_publishable` / `revert`, but must reject a new `publishable` decision while the effective publication block is active.

### Search / consumer

All active Website/Zoho/legacy API reads that expose Provider/Course/Campus/Scholarship search or lookup must exclude entities with an effective Search block.

Course/Campus/Provider-owned Scholarship reads inherit a Provider Search block.

Internal Admin/PIM reads and retained Search projection rows remain available for diagnosis. Search blocking is a read/admission rule, not projection-row deletion.

### Data-quality quarantine

Add a secured quarantine read owner exposed through the existing Data Quality dispatch boundary.

The quarantine read must:
- return current blocked entities;
- identify direct vs inherited Provider quarantine;
- expose reason/review/expiry context;
- not rewrite canonical completeness/readiness values;
- not automatically imply publication or Search block because scopes are independent.

## Performance

Block checks must use the existing indexed ledger and latest-effective-state semantics.

Consumer APIs remain under existing hard budgets:
- detail/RPC <= 3,000 ms;
- management/page payload <= 250 kB;
- filter/options <= 60 kB.

A rollback-only blocked-entity canary must prove Search filtering without leaving retained block rows.

## Security

- block/unblock mutation remains rank-5 PIM Admin only;
- consumer APIs receive only allow/deny consequence, not private block comments unless already inside secured Admin reads;
- no browser receives direct table access to `pipeline.layer4_block_decisions`;
- no service-role/browser boundary is weakened;
- block evaluation must be server-side.

## UAT

1. direct Course Search block removes that Course from Website and Zoho course search/lookup;
2. Provider Search block removes the Provider and its child Courses from consumer reads;
3. Search unblock restores visibility without canonical rewrite;
4. publication readiness returns a block reason and cannot transition to published/internal while blocked;
5. `publishable` Layer 4 decision is rejected while blocked; non-publishable/revert remain available;
6. Layer 2 `p_apply=true` is rejected by an operational Course/Provider block;
7. Layer 3 reservation/source-pattern execution is rejected/non-executable under operational block before any external call;
8. Layer 1 regulatory apply contracts are unchanged;
9. Data Quality secured quarantine read exposes direct/inherited current quarantine state;
10. rollback leaves no synthetic block rows or canonical/search/publication changes;
11. Security and Performance Advisors remain 0 WARN / 0 ERROR.

## Explicit non-goals

- no automatic deletion;
- no canonical status rewrite merely to represent a block;
- no implicit coupling between Search, publication and quarantine scopes;
- no autonomous unblock;
- no Production deployment/cutover;
- no broad Publication;
- no M2.4 reopening.

## Rollback

Restore prior owning function definitions. The append-only block ledger remains valid historical governance state. No data deletion is required.


## Implementation & rollback-only Pilot proof — 1 September 2026

### Pilot implementation

Migration:
`supabase/migrations/20260901211500_m2_5_universal_layer4_block_enforcement.sql`

Pilot commit:
`f97c1aa2040890e9a49c1ddf38a9755700b0fee3`.

The migration applied successfully to Pilot as:
`m2_5_universal_layer4_block_enforcement`.

Implemented:
- effective latest non-expired block view;
- inherited Provider block resolution;
- Search-blocked Provider/Course/Campus/Scholarship secured views;
- `security.layer4_entity_or_parent_blocked(...)`;
- secured Data Quality quarantine read;
- Layer 2 Course Fact apply operational gate;
- Layer 3 interpretation reservation operational gate;
- Layer 3 source-pattern request operational gate;
- publication-readiness blocker;
- Layer 4 `publishable` decision rejection while publication-blocked;
- Search filtering across all 20 inventoried Website/Zoho/legacy API search/lookup/reference-manifest functions.

Layer 1 `svc_layer1_*` regulatory ingestion definitions are not replaced by CF-057. Authoritative source observations remain recordable.

### Consumer API coverage

Live definition inspection after migration:
- **20/20** inventoried API functions contain `layer4_search_blocked_*` enforcement;
- publication readiness owner = enforced;
- publication decision owner = enforced;
- Layer 2 Course Facts apply owner = enforced;
- Layer 3 reservation owner = enforced;
- source-pattern request owner = enforced;
- Data Quality quarantine dispatch owner = enforced.

### Rollback-only canary

All synthetic decisions used reason `CF057_UAT` and ran inside an explicit transaction which was rolled back.

Baseline:
- chosen Course visible through Zoho exact lookup;
- chosen Course visible through Website exact preview;
- chosen Provider visible through Zoho exact lookup.

Direct Course Search block:
- effective blocked-Course view = true;
- Zoho Course lookup hidden;
- Website Course lookup hidden;
- Website Search preview no longer returns the target Course;
- legacy role-gated Course list hides the target.

Course Search unblock:
- effective blocked view cleared;
- Zoho and Website exact lookup restored.

Provider Search block:
- Provider hidden from Zoho lookup;
- child Course inherited Search block;
- child Course hidden from Zoho and Website Course reads.

Provider Search unblock:
- Provider and child Course visibility restored without canonical rewrite.

Publication block:
- readiness returned `layer4_publication_block`;
- `signals.layer4_publication_blocked=true`;
- `publishable` Layer 4 decision rejected with `42501`;
- `not_publishable` decision remained allowed;
- `publishing.set_course_publication_v1(...,'internal',...)` rejected;
- canonical publication state remained unchanged.

Operational Course block:
- `layer2_apply_course_candidate(...,true)` rejected before Course Fact apply;
- error = `course operationally blocked by Layer 4`.

Operational Provider block on a live queued CF-054 source-pattern request:
- request context returned `executable=false`;
- reason = `layer4_operational_block`;
- interpretation reservation returned `call_required=false`;
- reason = `layer4_operational_block`;
- new source-pattern interpretations during the transaction = **0**;
- no external model call executed.

Data-quality quarantine:
- Provider quarantine appears as a direct Provider quarantine;
- child Course appears through inherited Provider quarantine;
- Search remains visible when only quarantine is active, proving block-scope independence.

Post-rollback verification:
- retained `CF057_UAT` decisions = **0**;
- total live Layer 4 block decisions = **0**;
- no synthetic canonical/Search/publication state remains.

### Advisors

After deployed enforcement:
- Security: **146 INFO / 0 WARN / 0 ERROR**;
- Performance: **171 INFO / 0 WARN / 0 ERROR**.

### Permanent UAT

Added:
`tests/uat/m2-5-layer4-block-enforcement-contract.spec.mjs`
(commit `8e06e0c106eff6c6ea137d201f9568140b80deda`).

Workflow routing:
`1df7c2d0ce995895468b727cc6e8003dd95a47c7`.

The permanent contract verifies:
- independent operational/publication/Search/quarantine ownership;
- Provider inheritance;
- all 20 consumer contracts carry Search filtering;
- no Search projection deletion;
- no Layer 1 regulatory-function rewrite.

## Current status decision

**IMPLEMENTED / RUNTIME PASS — TARGETED CI PENDING.**

Cloudflare deployment drift does not block this source/server contract. Canonical Admin UI for block management remains a separate FU-011 UX item.
