# CF-CHG-20260901-057 — M2.5 Universal Layer 4 Block Enforcement

**Status:** ACTIVE / CORRECTIVE IMPLEMENTATION  
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
