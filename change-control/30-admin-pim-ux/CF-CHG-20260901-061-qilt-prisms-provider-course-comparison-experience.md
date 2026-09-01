# CF-CHG-20260901-061 — QILT / PRISMS Provider & Course Comparison Experience

**Status:** IMPLEMENTED / PILOT RUNTIME + SOURCE/BUILD + DEPLOYED DESKTOP TARGETED PASS — RESPONSIVE RECHECK PENDING  
**Initiated:** 1 September 2026 23:13 AEST  
**Primary category:** 30-admin-pim-ux  
**Origin:** CourseFinder project chat — user supplied ComparED provider/detail/comparison mobile references.

## Objective

Upgrade the existing QILT/PRISMS contextual presentation so the already-imported governed statistics can be consumed as a first-class decision and comparison experience from Catalogue Provider and Course journeys.

The visual benchmark is the interaction pattern demonstrated by ComparED: compact outcome cards, provider-to-provider columns, source/period labels, benchmark values, study-level context, and a dedicated compare workspace. CourseFinder must use its own UI implementation and governed data model rather than copying ComparED assets or presenting source-grain data as Course facts.

## Required UX

### Provider detail
- Add a prominent **Student outcomes & benchmarks** section.
- Present available QILT metrics as cards with metric value, confidence interval where stored, national/sector benchmark where stored, response count where stored, survey name/period, study level and source label.
- Add a **Compare provider** action.
- Preserve explicit unavailable/not-mapped/suppressed/null states.

### Provider comparison
- Allow up to **6 providers** per comparison session.
- Sticky provider header/identity row; scrollable metric groups below.
- Group QILT metrics into operator-friendly tabs/sections such as:
  - Current student experience;
  - Recent graduate satisfaction;
  - Graduate employment & salary.
- Show like-for-like values in aligned columns, with source period and national/sector comparator.
- Display the source grain prominently; comparisons must not imply direct equivalence when study level/study area/survey period differs.
- Responsive: desktop wide matrix; tablet horizontal provider strip with sticky metric labels; mobile stacked/swipeable provider columns.

### Course detail
- Surface QILT only when a defensible governed relationship exists:
  - direct Course observation; or
  - compatible Provider + study-level/study-area context.
- Label contextual values **Provider/study-area context**, never Course outcome unless the source is genuinely Course-grain.
- Add PRISMS contextual cards for Provider/state/sector/cohort observations relevant to the selected Course, clearly labelled by source grain.
- Keep Course facts/fees/entry requirements visually primary.

### Course comparison
- Reuse the same comparison shell for selected Courses.
- Compare direct Course facts normally.
- Render QILT/PRISMS in a separate **Context / outcomes** area using each observation's true grain.
- Do not manufacture missing values or force mismatched survey/study-level observations into a common row.

## Visual direction

Use a CourseFinder-native interpretation of the supplied ComparED references:
- dark navy/indigo comparison header;
- teal/blue-green statistical values and contextual panels;
- magenta/pink selection/tab accents;
- white metric cards on subtle neutral sections;
- strong typography and whitespace;
- source/period text directly adjacent to each metric group;
- responsive cards and horizontal comparison behaviour.

Do not copy ComparED logos, illustrations, icons, text, CSS or brand assets.

## Data/authority rules

- QILT remains contextual Provider/study-area statistical data, not Layer 1 Course truth.
- PRISMS remains contextual student-flow data at its accepted Provider/state/sector/cohort grain.
- Existing Layer 1 Provider/Course identity remains unchanged.
- Search/Publication/Zoho admission is unaffected by this UI change.
- Statistics must be rendered from governed stored values; no recalculated or inferred figures unless an explicitly accepted read projection defines the calculation.
- Preserve survey/collection period, study level, study area, benchmark, confidence interval, response count and Evidence/provenance when available.

## Read/API requirements

Prefer bounded comparison projections rather than N independent browser reads.

Required read surfaces should support:
- provider summary by provider_id;
- course contextual summary by course_id;
- provider comparison by <=6 provider_ids;
- course comparison by <=6 course_ids;
- metric/survey/study-level normalisation metadata sufficient to identify like-for-like rows.

Any new RPC/read contract must remain behind the accepted `adminRead` boundary and preserve role/ACL/security constraints.

## UAT

Targeted acceptance must cover:
- Provider detail QILT cards;
- Course contextual QILT/PRISMS rendering with correct granularity labels;
- select/remove/reorder up to six comparison entities;
- like-for-like metric alignment and mismatch labelling;
- source/period/benchmark/confidence interval/response-count rendering where present;
- explicit missing/suppressed/not-mapped states;
- desktop/tablet/mobile responsive comparison;
- anonymous/insufficient-rank negative paths;
- bounded read count/performance;
- no Layer 1/Search/Publication mutation.

## Rollback

Frontend comparison components can be reverted independently. New read projections/RPC wrappers, if required, must be independently reversible and read-only. No imported QILT/PRISMS source rows are to be deleted or rewritten for rollback.


## Implementation — 1 September 2026

Pilot implementation is now present on `msinghbs-ai/Coursefinder-Pilot`.

Frontend:
- `src/ComparisonWorkspace.jsx` — bounded Provider/Course comparison workspace, maximum six selected entities;
- `src/mature-main.jsx` — Compare route, Catalogue entry action and Provider/Course detail action;
- `src/ContextualInsights.jsx` — QILT confidence interval, response-count and national-benchmark presentation;
- Admin source/release version **v2.15.21**.

Pilot database:
- `20260901133212_cf_061_contextual_compare_qilt_prisms.sql`;
- `20260901134059_cf_061_contextual_compare_provider_city_fix.sql`;
- `20260901134137_cf_061_contextual_insights_study_area_code_fix.sql`.

Read contract:
- `security.admin_contextual_insights_v2(text,uuid)`;
- `security.admin_contextual_compare(jsonb)`;
- browser route remains `public.admin_read('contextual_compare', ...)`;
- direct private helper execution remains unavailable to `anon` / `authenticated`;
- authenticated Catalogue Reader+ is required;
- comparison is rejected above six entities.

Two schema-name defects were found during live Pilot verification immediately after initial APPLY (`providers.city` and `external_study_areas.code`). Both were corrected through additive follow-up migrations rather than rewriting migration history.

## Runtime verification

Rollback-only / read-only Pilot verification proves:
- three selected Providers return in caller-requested order;
- QILT metric payload contains stored confidence interval / response-count fields when the source supplied them;
- two selected Courses return successfully;
- Course outcome grain remains `provider_context`;
- PRISMS context remains at its governed returned grain and is not converted to a Course outcome;
- a seven-entity request is rejected with `maximum six comparison entities`;
- a request without authenticated JWT context is rejected with `authentication required`;
- no canonical, Search, Publication or Zoho mutation was introduced.

Post-DDL advisors:
- Security: **147 INFO / 0 WARN / 0 ERROR**;
- Performance: **175 INFO / 0 WARN / 0 ERROR**.

Permanent source/build contract:
`tests/uat/cf-061-qilt-prisms-comparison-contract.spec.mjs`.

Workflow routing is included in `.github/workflows/deployed-uat.yml`.

Source/build targeted proof:
- trigger `b423af67af6917ae3407e3f5137dcd403d0da225`;
- workflow `33515174810`;
- job `99880438005`;
- targeted Chromium desktop **PASS**;
- the permanent CF-061 source/build contract includes a full `npm run build`.

Dedicated deployed-browser comparison proof:
- test `tests/uat/cf-061-qilt-prisms-comparison-deployed.spec.mjs`;
- trigger `35fef88e07cff9e7d6e568d740c31722c3c3720e`;
- workflow `33515683960`;
- job `99882055173`;
- targeted Chromium desktop **PASS**;
- deployed release pill explicitly proved **v2.15.21**;
- Provider comparison (Charles Darwin University + Curtin University) returned two aligned governed entities;
- Course detail/comparison retained QILT `provider_context` grain.

The deployed test has subsequently been extended with explicit 900px tablet and 390px mobile viewport checks plus document-level overflow protection. Trigger `90123d162103e707473ac8eb7a7a226cade51280` is the responsive recheck candidate; its status was not attached at the last bounded check.

## Remaining acceptance

Cloudflare currentness to v2.15.21 is now proven by the deployed comparison test. Keep final CF-061 responsive acceptance open only until the explicit tablet/mobile viewport recheck on trigger `90123d162103e707473ac8eb7a7a226cade51280` is terminal.
