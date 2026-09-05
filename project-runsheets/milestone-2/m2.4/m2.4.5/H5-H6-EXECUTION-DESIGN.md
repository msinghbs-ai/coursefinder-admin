# M2.4.5 H5–H6 Execution Design

**Status:** ACTIVE DESIGN / IMPLEMENTATION GATE  
**Date:** 5 September 2026  
**Milestone:** M2.4.5  
**Workstreams:** H5 Manual PIM Source-Backed Candidate Workflow; H6 Publication Controls  
**Governance:** CF-CHG-20260903-087; CF-CHG-20260905-210

## Objective

Finish H5 by providing one governed operator workflow for source-backed Provider, Course, Campus and Scholarship candidates, then introduce H6 publication controls as a separate consequential-action boundary.

The two workstreams must not be collapsed into a single create-and-publish action.

## H5 — Source-backed candidate workflow

### Operator journey

`Catalogue entity → Add source-backed candidate → identify authority/source → retain Evidence → validate → reconcile identity → review only when ambiguous → canonical apply → candidate closed/superseded`

### Supported entity types

- Provider
- Course
- Campus
- Scholarship

Provider Contacts, Important Links and Important Dates remain managed-record workflows and are not routed through this candidate path.

### Minimum create contract

Rank 5+ only.

Every candidate retains:

- entity type;
- country;
- canonical parent Provider where required;
- authoritative/first-party source class;
- source URL or selected governed Evidence object;
- source/stable identifier where published;
- operator reason;
- actor and created timestamp;
- acquisition/Evidence lineage;
- validation/reconciliation state;
- target canonical identity when matched;
- review disposition when ambiguous;
- terminal apply/reject/supersede state.

### State model

`draft → submitted → validating → reconciled | needs_review | rejected → ready_to_apply → applied | superseded`

Rules:

- `draft` is operator-local/incomplete and is not a canonical record.
- `submitted` is immutable as an intake event except through a superseding revision.
- validation failure never writes canonical identity.
- exact existing identity resolves to an update/reconciliation candidate rather than a duplicate create.
- ambiguous identity routes to the existing Layer 4 governed review boundary.
- `ready_to_apply` means identity/source validation passed; it does not mean published.
- `applied` means canonical mutation completed under the existing authority contract.
- all terminal actions retain actor/time/reason and Evidence lineage.

### No-bypass guarantees

H5 must not:

- expose direct `INSERT` into canonical Provider/Course/Campus/Scholarship tables;
- use name/title alone as identity;
- allow Layer 2/3 data to redefine Layer 1 identity;
- manufacture a campus/provider/course identifier;
- infer Scholarship eligibility absent source Evidence;
- publish to Search, Website, Zoho or another consumer as a side effect of Apply.

### UI pattern

Use one shared **Add source-backed candidate** action in Provider, Course, Campus and Scholarship catalogue workspaces for rank 5+.

The compact form must make the following visible without opening diagnostics:

- candidate status;
- source authority/type;
- source URL/Evidence;
- stable identifier;
- parent Provider where applicable;
- reason;
- validation result;
- identity match/review result;
- canonical Apply availability.

The UI must state: **Candidate only — canonical creation and publication are separate governed actions.**

## H6 — Publication controls

### Governing principle

Publication is a consequential derived-consumer decision. Canonical presence, completeness, verification, readiness and publication are distinct states.

Broad automatic publication remains disabled until the H6 gate passes.

### Publication targets

Controls must support explicit target selection rather than one global published flag:

- Search index/API;
- public Website API surface;
- Zoho consumer surface where approved;
- future consumers through the same governed target model.

No target is enabled merely because another target is enabled.

### Control modes

1. **Manual single-record publication** — privileged operator selects an eligible canonical record and a target.
2. **Manual mass publication** — privileged operator selects a bounded filtered cohort, previews the exact effect and confirms.
3. **Automatic publication policy** — disabled by default; may be enabled only for an explicitly governed policy/profile after acceptance.

### Required preflight

Every publication action must calculate a dry-run/preview before mutation:

- exact target consumer;
- exact eligible/ineligible record count;
- records newly admitted;
- records updated;
- records removed/withdrawn;
- blockers by reason;
- effective policy/profile/version;
- canonical/readiness snapshot used;
- expected Search/API invalidation or refresh scope.

The preview must be reproducible from retained inputs.

### Eligibility gate

Publication eligibility is server-side and must at minimum require:

- canonical identity exists;
- record is not deleted/retired/blocked under its entity lifecycle;
- applicable source-authority and Evidence requirements pass;
- no unresolved consequential Layer 4 block;
- required consumer fields pass the governed readiness profile;
- target-specific policy allows admission.

Completeness percentage alone must never equal publication approval.

### Rank boundary

- preview/read of publication state: rank 3+ where existing catalogue visibility permits;
- single-record publish/unpublish: rank 5+;
- mass publish/unpublish: rank 6 unless an accepted policy explicitly delegates a bounded cohort action;
- automatic-policy enable/disable/change: rank 6.

Server-side rank enforcement is mandatory; hiding controls in the browser is insufficient.

### Approval and execution

Manual publication requires:

`preview → explicit confirm → execute → retain immutable publication event → refresh/invalidate derived consumer → verify result`

Automatic publication requires:

`policy disabled → configure → preview against representative cohort → targeted acceptance → explicit rank-6 enable → bounded execution → telemetry/rollback proof`

### Audit event

Each publication mutation must retain:

- event ID;
- actor;
- timestamp;
- action (`publish`, `unpublish`, `republish`, `policy_enable`, `policy_disable`);
- entity type and canonical IDs or reproducible cohort selector;
- target consumer;
- policy/profile/version;
- preview ID/hash;
- counts/results;
- reason/comment;
- previous effective publication state;
- resulting effective state;
- rollback/superseding event reference where applicable.

### Rollback

Rollback is a first-class action, not an undocumented SQL procedure.

- single-record publication can be reversed by an audited unpublish/superseding event;
- mass publication must retain the exact affected ID set or deterministic snapshot reference so the operation can be reversed without touching unrelated records;
- automatic publication can be disabled without deleting canonical data;
- rollback must not delete Evidence or audit history;
- consumer refresh/invalidation must run after rollback.

### Mass-action safeguards

- filter/cohort is server-resolved;
- show exact record count before confirmation;
- hard cap each execution batch;
- no `Select all` that silently expands beyond the previewed server cohort;
- idempotent replay where practical;
- duplicate/concurrent execution protection;
- partial failure produces a resumable event with per-record disposition;
- destructive reset/truncate controls are prohibited.

## H5 → H6 dependency

H5 candidates never enter H6 directly.

Only a successfully applied canonical record can become publication-eligible. The publication service reads canonical/readiness/review state and does not accept a candidate ID as a bypass.

## Acceptance sequence

### H5 targeted acceptance

1. Rank 4 cannot create a core catalogue candidate.
2. Rank 5 can register valid source-backed candidates.
3. missing source/Evidence/reason is rejected server-side.
4. existing exact identity does not create a duplicate canonical record.
5. ambiguous identity routes to review.
6. Apply produces an audited canonical mutation with Evidence lineage.
7. Apply produces no Search/publication side effect.
8. replay/superseding revision remains auditable and idempotent at canonical identity.

### H6 targeted acceptance

1. broad automatic publication remains disabled by default.
2. rank-negative and anonymous mutation paths fail.
3. preview is non-mutating and returns exact bounded counts.
4. ineligible/readiness-blocked records cannot be forced through client parameters.
5. single publish/unpublish is audited and consumer state is verified.
6. mass action only affects the previewed cohort.
7. rollback restores the prior effective publication state for the exact affected set.
8. H5 candidate IDs cannot be submitted to publication mutation routes.
9. Search/consumer signal changes only after accepted publication mutation.

## Implementation order

1. Reuse/extend existing Evidence, reconciliation and Layer 4 primitives for the H5 candidate intake service.
2. Add shared catalogue candidate UI and server-side rank validation.
3. Close H5 targeted acceptance before enabling any H6 mutation control.
4. Implement H6 publication event/read/preview model with all mutation controls disabled.
5. Prove single-record manual publish/unpublish and rollback.
6. Prove bounded mass preview/execution/rollback.
7. Leave automatic publication disabled until its separate acceptance gate is explicitly passed.

## Gate status

- H5 governance/capability boundary: ACCEPTED under CF-210.
- H5 shared source-backed candidate workflow: IMPLEMENTATION REQUIRED.
- H6 control semantics: DEFINED HERE; runtime mutation remains DISABLED.
- H6 automatic publication: DISABLED / NOT ACCEPTED.
