# CourseFinder Master Project Plan v1.21

**Status:** AUTHORITATIVE PROGRAMME GOVERNANCE DOCUMENT  
**Supersedes:** `docs/coursefinder-master-project-plan-v1.20.md`  
**Last consolidated:** 18 August 2026  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.21.md`  
**Running build:** `docs/coursefinder-running-build-v2.23.md`

## Current position

- Layer 1: AU PASS; NZ PASS; CA ACTIVE/BLOCKED; GB/US/IE queued; DE deferred.
- CA Gate A Federal Provider Authority: PASS at 1,130 Providers / 1,130 DLI identifiers.
- Ontario Provider mapping: PASS 24/24.
- Institutional Course identity sub-gates passed: 20.
- Canonical CA Courses: 2,389.
- Full/current accepted source Courses: 2,117.
- Partial-source Courses: 80.
- Identity-full / lifecycle-currentness pending: 192.
- Scholarship core relational/API design: VALIDATED / FOUNDATION APPLIED.

## Phase 2 — Admin/PIM impact

Future Scholarship Admin UX must follow the relational domain rather than a single flat form.

Recommended Scholarship workspace:
- Overview;
- Source IDs;
- Offering Cycles;
- Application Windows;
- Applicability/Scopes;
- Eligibility;
- Award Tiers;
- Coverage;
- Evidence;
- History.

The UI must clearly separate:
- Course/Provider applicability;
- student eligibility;
- current application availability;
- award value/coverage.

## Phase 3 — Layer 2 Scholarship enrichment

Scholarships are confirmed as a Layer 2 enrichment domain.

Core model now supports:
- source/API-native identifiers independent of names;
- recurring annual/intake cycles without cloning canonical Scholarship identity;
- multiple application rounds;
- include/exclude applicability across Provider, Course, Course Collection, Study Level, Field, Country and Campus;
- nested AND/OR eligibility logic;
- cycle-specific award tiers, coverage, criteria and scopes;
- evidence/provenance on material facts.

Migration applied:
- `052_scholarship_relational_api_hardening.sql`.

Validation:
- `docs/m1-scholarship-api-validation-2026-08-17.md` — PASS for core database structure.

### Layer 2 Scholarship production gate

A source adapter is accepted only when it proves:
1. stable source scholarship identity;
2. source evidence capture;
3. canonical Scholarship reconciliation without title-based identity;
4. cycle/window reconciliation;
5. scope include/exclude correctness;
6. compound eligibility preservation;
7. award/coverage preservation;
8. bounded dry-run/APPLY/replay/idempotency;
9. history preservation across changed/closed cycles;
10. curated Admin/API projection after canonical UAT.

## Phase 6 — Search/API impact

Scholarship search is relational:

`Course -> Provider/Collection/Study Level/Field/Campus/Country -> Scholarship scopes`.

Applicability does not equal student eligibility. Eligibility must be evaluated separately from criteria groups.

Current availability should derive from active offering cycles/application windows, not only the legacy root `academic_year` and root deadline fields.

## Phase 7 — Hardening

The new Scholarship tables retain internal-schema/RLS/service-role boundaries. Post-migration performance validation shows no new unindexed Scholarship foreign keys. Existing unrelated advisor items remain in their respective workstreams.

## Immediate sequence

Primary Layer 1 sequence remains unchanged:
1. complete CA production gate;
2. GB;
3. US;
4. IE;
5. DE remediation.

Parallel approved work:
- build first Scholarship Layer 2 source adapter/dry-run against the v2.10.21 relational contract;
- progress Admin Scholarship workspace design;
- continue QILT/structured-outcomes Layer 2A work where non-blocking.

## Current programme decision

**Scholarship relational core design is accepted and applied. Scholarship enrichment is a Layer 2 workstream. CA remains the active Layer 1 blocker and programme sequence is unchanged.**
