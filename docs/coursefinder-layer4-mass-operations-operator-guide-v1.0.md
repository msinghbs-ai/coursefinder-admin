# CourseFinder Layer 4 Mass Operations — Operator Guide v1.0

**Status:** CURRENT / CF-205  
**Effective:** 5 September 2026  
**Milestone:** M2.4.5  

## Purpose

Layer 4 is the terminal human-resolution layer. Routine operators should resolve repeatable work as governed cohorts, not thousands of one-to-one rows. The cohort must be defined by the same Scholarship/rule or the same Layer 4 entity/field/escalation reason.

## Scholarship Course-scope workflow

1. Open **Data Operations → Layer 4 — Human Resolution → Scholarship scope**.
2. Search by university, Scholarship, rule or Course.
3. Select **Preview cohort**.
4. Cross-check the cohort summary before deciding:
   - Evidence must cover the full cohort for mass acceptance;
   - Provider mismatch must be zero;
   - inspect already-mapped rows;
   - inspect study-level spread and the Course sample;
   - treat `Semantic scope warning` as a required source/rule check, especially for country eligibility, exclusions, eligible-program lists or missing explicit scope.
5. Choose one cohort action:
   - **Accept whole cohort** only where the source rule actually supports every Course in the cohort;
   - **Reject whole cohort** where the cohort rule is confirmed out of scope;
   - do not accept a broad Provider cohort merely because Evidence exists. Evidence proves the source; it does not prove every Course is eligible.
6. Enter an audited reason.
7. Type the exact live-count confirmation shown by the preview, for example `ACCEPT 382` or `REJECT 382`.
8. Apply the decision. The operation is retained in **Mass audit**.

Mass acceptance creates governed Course mappings with Evidence and actor attribution. It does not publish the Scholarship or authorise Website/Zoho/Production use.

## Generic Layer 4 review workflow

Use **Review queue** for repeated items that share the same entity type, field and escalation reason.

Available mass actions are:
- Reject cohort;
- Request more Evidence;
- Return to Layer 2;
- Return to Layer 3.

Bulk scalar approval is deliberately not offered because values may differ between records. Use the existing individual Layer 4 decision path where a specific effective value must be approved or edited.

## Errors & improvements

The **Errors & improvements** tab performs deterministic cross-checks for:
- missing Evidence;
- Scholarship/Course Provider mismatch;
- stale review work;
- accepted Scholarship candidates without a Course mapping;
- large review cohorts that should be simplified into a governed rule/decision.

A diagnostic can be promoted to the tracked findings register as:
- **Error** — integrity/safety defect that should block unsafe processing;
- **Issue** — operational condition requiring attention;
- **Improvement** — workflow or scale opportunity that is not itself incorrect data.

Resolve tracked findings only after the underlying condition or accepted operational decision is recorded. Add a concise resolution note.

## Permission model

- **Curator / rank 3+**: read, search, preview, cross-check and track/resolve findings.
- **Pipeline Operator / rank 4+**: all above plus mass mutation.

The underlying CF-205 audit/finding tables remain private and are reached through guarded RPCs only.

## Safety rules

- Never mass-accept a cohort with missing Evidence or Provider mismatch.
- Treat semantic eligibility/exclusion warnings separately from structural readiness.
- Do not manufacture Course eligibility from Provider ownership.
- Do not use mass operations to bypass Layer 1 identity or source authority.
- Publication remains a separate governed decision.
- If the cohort contains mixed rules, narrow/reclassify it rather than accepting a convenient broad group.
- Corrections should be auditable; do not delete mass-operation history.

## Current Pilot scale at introduction

At CF-205 introduction the existing 2,199 Scholarship Course-scope review rows are represented as 10 cohorts, plus one grouped generic Layer 4 cohort containing six review items. This is the intended operator pattern: cross-check the rule once, inspect representative data, and make one auditable cohort decision where the rule genuinely applies.
