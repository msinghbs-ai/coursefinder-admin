# CF-CHG-20260824-031 — Course Detail Operator Polish

**Status:** APPLIED — DEPLOYED BROWSER UAT PENDING  
**Category:** 30-admin-pim-ux  
**Initiated:** 24 August 2026 14:00 AEST (+10:00)  
**Origin chat/workstream:** M2.1 — Layer 2 Platform / Admin cross-check  
**Owner:** M2.1 Layer 2 Platform + Admin/PIM UX workstreams

## Trigger

Manual Admin cross-check of Federation University Australia `Bachelor of Arts` (`085611C`) after Layer 2 canonical enrichment showed that the underlying data was present but the Course Detail drawer remained too implementation-oriented for management/PIM use.

Observed defects:

- `Course URL` displayed blank because the legacy scalar `catalogue.courses.course_url` was read instead of the active governed `catalogue.course_links` official-course observation;
- fees appeared twice (`Fee semantics` plus generic `Fees`) and the generic record rendering exposed implementation vocabulary;
- empty `Categories`, `Collections` and `Academic Options` sections occupied space;
- Evidence cards were not directly navigable to the Evidence workspace;
- Layer 1 regulatory observations were rendered as raw field/value text;
- generic scalar/object rendering exposed internal IDs, stable keys and rough machine-oriented text before the decision-useful facts.

## Requested outcome

Keep Course Detail concise and management-friendly while preserving drill-down evidence and exact semantic separation:

1. show the governed official first-party Course URL;
2. show one fee section only, separating registered CRICOS course-cost facts from Provider-current tuition;
3. suppress empty optional sections;
4. make Evidence artifacts directly clickable;
5. present Regulatory Facts in plain business language;
6. put decision-useful Course facts first and internal detail behind Evidence/drill-down rather than raw object dumps.

## Semantic impact

No canonical fee semantics change.

- CRICOS registered tuition/non-tuition/estimated-total-course-cost remain Layer 1 `registered_total_course` facts.
- Provider-current tuition remains a separate Layer 2/current Provider fact.
- `course_url` in the Admin read contract may resolve from the active `official_course` `catalogue.course_links` observation when the legacy Course scalar is empty.
- Search/publication authority is unchanged.
- Layer 1 QILT/PRISMS and regulatory authority are unchanged.

## Implementation

### Live Supabase

Migration applied:

- `m2_1_admin_course_detail_enrichment_presentation_contract`

Changes:

- `public.ui_course_detail(uuid)` now resolves Course URL from the active official Course link when the legacy scalar is null/empty;
- Course Detail Evidence union now includes `catalogue.course_links.evidence_id` and PIM attribute-value Evidence for the matching Course entity;
- Evidence rows use consistent `evidence_type` naming for the dedicated Course renderer.

Federation BA validation after the change:

- official Course URL: `https://www.federation.edu.au/courses/dhm5-bachelor-of-arts/`;
- registered CRICOS fee rows: `3`;
- Provider-current fee rows: `0`;
- distinct supporting Evidence rows in the Course Detail evidence union: `3`.

### Pilot UI

Visible PIM version: **v2.13.0**.

Implementation refs:

- `src/CourseDetailPolish.jsx` — dedicated concise Course-detail renderer;
- `src/mature-main.jsx` — Course Detail dispatches to dedicated renderer; visible PIM version v2.13.0;
- `index.html` — visible runtime marker/title v2.13;
- `supabase/migrations/20260824140100_m2_1_admin_course_detail_enrichment_presentation_contract.sql` — repository read-contract mirror;
- `tests/uat/course-detail-polish-deployed.spec.mjs` — exact Federation Bachelor of Arts acceptance;
- `.github/workflows/deployed-uat.yml` — desktop/mobile deployed UAT includes the new test;
- `tests/uat/data-quality-deployed.spec.mjs` — prior `Fee semantics` expectation updated to the new single `Fees` section.

Key commits include:

- `6cae5a53254e75a0cbe2356f1925d51f6f4467ac` — dedicated Course renderer;
- `739fdf8fe9f8f5800673c213cd0e82a8d3dba455` — PIM v2.13 integration;
- `dba8b0b640849bc6f465f4dfeba76f5f280e26fa` — visible runtime marker;
- `a96d4495f650683a331b138a88eaba3685ed35de` — Federation deployed Course-detail test;
- `46c2c1e8c1bc8e1e15749ccb4e3370b406c9ea00` — deployed-UAT workflow inclusion.

## UI behaviour after

Default Course Detail order:

1. concise Course overview — Provider, CRICOS/Course code, level, field, duration, delivery, lifecycle, publication, verification and first-party Course URL;
2. canonical Course description;
3. one `Fees` section with separate `Registered CRICOS course cost` and `Current Provider tuition` columns;
4. Intakes & English;
5. Campuses;
6. optional Academic Options / Categories / Collections only when populated;
7. Regulatory Facts with plain-language labels and Evidence action;
8. Evidence — each artifact opens the Evidence workspace;
9. compact Operational State.

The generic raw Course object renderer is no longer used for Course details.

## UAT

### Backend contract

PASS:

- governed Federation official URL exists in `catalogue.course_links` and is selected by the new read contract;
- no Provider-current fee is manufactured for Bachelor of Arts;
- registered CRICOS fee count remains 3;
- Course-link and description Evidence are included in Course Detail evidence lineage;
- no Search/publication mutation.

### Deployed browser acceptance

Pending SHA-bound GitHub Actions acceptance on:

- Chromium desktop;
- Chromium mobile.

New test explicitly verifies:

- PIM v2.13 runtime marker;
- Bachelor of Arts drawer opens;
- official first-party URL is visible/clickable;
- exactly one `Fees` heading;
- CRICOS/current Provider fee semantics are visually separated;
- empty Categories/Collections/Academic Options are suppressed;
- Regulatory Facts uses business wording;
- an Evidence row opens the Evidence workspace/artifact.

## Rollback

- revert the PIM v2.13 Pilot commits to restore the generic Course Detail renderer;
- restore the previous `public.ui_course_detail`/`security.admin_read_impl` definitions if the read-contract fallback or Evidence expansion causes regression;
- canonical Layer 2 facts, Course links and Evidence do not need rollback because this change is presentation/read-contract focused.

## Current gate

**APPLIED — DEPLOYED BROWSER UAT PENDING.**

This record does not close M2.1 by itself. `CF-CHG-20260823-029` remains the parent Layer 2 acceptance gate until its deployed desktop/mobile acceptance is PASS.
