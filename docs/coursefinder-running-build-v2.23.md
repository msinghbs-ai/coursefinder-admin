# CourseFinder Running Build v2.23

**Date:** 18 August 2026  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.21.md`  
**Master plan:** `docs/coursefinder-master-project-plan-v1.21.md`

## Current programme position

- Layer 1: AU PASS; NZ PASS; CA ACTIVE/BLOCKED; GB/US/IE queued; DE deferred.
- CA Gate A Provider Authority: PASS at 1,130 Providers / 1,130 DLI identifiers.
- Ontario Provider mapping: PASS 24/24.
- Institutional identity sub-gates passed: 20.
- Canonical CA Courses: 2,389.
- Full/current accepted source Courses: 2,117.
- Partial-source Courses: 80.
- Identity-full / lifecycle-currentness pending: 192.

## Scholarship core-domain validation

The live Scholarship domain was empty at validation time, allowing non-destructive relational hardening before Layer 2 population.

Migration `052_scholarship_relational_api_hardening.sql` is applied.

New tables:
- `scholarship.identifiers`;
- `scholarship.offering_cycles`;
- `scholarship.application_windows`;
- `scholarship.criterion_groups`.

Existing child tables extended with cycle-aware relationships:
- `scholarship.scopes`;
- `scholarship.criteria`;
- `scholarship.award_tiers`;
- `scholarship.coverage`.

Additional hardening:
- criteria can attach to nested `all`/`any` groups;
- award tiers now retain source/evidence lineage;
- scope rows are database-validated so the declared `scope_type` matches exactly one target entity;
- new internal tables have RLS enabled, direct anon/authenticated access revoked and explicit service-role write access;
- FK indexes required by the new model are present.

Validation result: PASS for core relational structure. No Scholarship records were fabricated or ingested.

Detailed validation:
- `docs/m1-scholarship-api-validation-2026-08-17.md`

## Scholarship Layer 2 next gate

Before production enrichment:
1. choose/validate a real Scholarship source/API;
2. confirm stable source identifier behaviour;
3. dry-run recurring cycles, multiple windows, scope include/exclude and compound eligibility;
4. prove APPLY/replay/idempotency/evidence;
5. add curated Admin/API projection only after ingestion UAT passes.

## Current blocker

`CA_FEDERATED_COURSE_SOURCE_COVERAGE_BLOCKER` remains the active Layer 1 programme blocker. Scholarship Layer 2 design work is parallel and does not alter the CA gate sequence.
