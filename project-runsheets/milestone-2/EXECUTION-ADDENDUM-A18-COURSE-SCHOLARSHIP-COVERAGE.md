# Execution Addendum A18 — Course Scholarship Coverage & Runnable Fill Workflow

**Status:** CLOSED / PASS — ACCEPTED M2.4.4 STANDING BEHAVIOUR
**Effective:** 30 August 2026  
**Change Control:** `CF-CHG-20260830-048`

## Purpose

Make Scholarships useful at Course level rather than only as a standalone catalogue.

## A18.1 — Data model and mapping

Scholarships remain first-class governed records. Course applicability is a governed relationship, not copied free text.

The mapping workflow must:
- use Provider identity first;
- use explicit Scholarship scope/coverage rules where present;
- preserve source URL, Evidence, cycle/year, audience, value and eligibility scope;
- distinguish `eligible/mapped`, `provider-level candidate`, `needs_review`, and `not_applicable/not_mapped`;
- never infer Course eligibility merely because a Scholarship exists for the Provider.

## A18.2 — Runnable operator workflow

Admin must expose **Fill Course Scholarships** now.

Operator chooses Country, Provider or all currently qualified scope and can:
1. **Preview mapping** — count Courses, Scholarships, direct mappings, candidates and unresolved rows.
2. **Fill mapped scholarships** — materialise only deterministic/explicit mappings.
3. **Queue unresolved for review** — preserve candidates without publication.
4. Re-run idempotently.

The Course blade must show mapped Scholarships with provenance and explicit unavailable/not-mapped state.

## A18.3 — Acceptance

A18 requires:
- runnable Preview and Fill actions;
- idempotent relationship writes;
- zero manufactured Scholarship eligibility;
- Course detail projection showing mapped scholarships;
- counts available on Dashboard/Completeness;
- targeted DB/API/browser UAT before new integration/final acceptance.

## Closure disposition — 1 September 2026
- Accepted under closed `CF-CHG-20260830-048` / M2.4.4.
- Replacement final acceptance `33468512515` PASS on desktop and mobile.
- This addendum remains standing behavioural/governance guidance where applicable, but does not keep M2.4.4 open.
