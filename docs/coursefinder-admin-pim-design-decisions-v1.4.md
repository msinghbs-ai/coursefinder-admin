# CourseFinder Admin / PIM Design Decisions v1.4

**Status:** AUTHORITATIVE CROSS-CHAT UX / OPERATING CONTRACT  
**Date:** 19 August 2026  
**Supersedes:** `docs/coursefinder-admin-pim-design-decisions-v1.3.md`

## UI baseline

Current Pilot reference implementation: **UI v1.6.0**.

## Course decision-workspace standard

Course Admin must support progressive drill-down with the same searchable combobox primitive used elsewhere:

`Country -> State/Region -> Provider -> Study Level -> Field of Study -> Delivery -> data-quality/freshness -> governance status`

The course list is a decision surface, not a passive catalogue.

### Required quality / readiness filters

Where canonical data exists, support:
- Has Fee / Missing Fee;
- Has Intake / Missing Intake;
- Has English requirement / Missing English requirement;
- Has Scholarship / Missing Scholarship;
- minimum completeness threshold;
- Never Verified;
- recently modified;
- stale verification;
- Lifecycle;
- Publication.

These filters must remain evidence-backed. Zero-result states are valid and must not be filled with inferred or fabricated data.

## Related-record cross-click standard

Course rows and drawers should expose directly related records with minimal navigation:
- Provider;
- Campuses / Locations;
- Fees;
- Intakes;
- English requirements;
- Scholarships;
- Evidence;
- later outcomes / student-flow observations where relevant.

Related-record clicks should open a filtered/condensed related view in the same workspace rather than requiring ordinary validation to navigate to a separate full page.

## Data-quality interpretation

A missing structured fact is itself an Admin decision signal. `No fee`, `No intake`, `No English requirement`, or `No course-scoped scholarship` should be filterable so enrichment agents and human reviewers can work by exception.

Do not confuse missing structured enrichment with a claim that the real-world course has no fee/intake/English requirement/scholarship. The UI label describes canonical structured-data availability only.

## Geography rule

State/Region filtering is authoritative only when Provider/Campus subdivision mapping exists in the canonical model. Do not infer subdivision from city/address text silently.

## Uniform interaction contract

All comparable Admin screens should continue to share:
- searchable comboboxes;
- fluid semantic table sizing;
- sortable column headers;
- server-side pagination for high-volume data;
- country flag + ISO code;
- currency code where relevant;
- cross-click related records;
- compact right-side drawer;
- preserved page/filter/sort context;
- visible UI version.

## Automation / agent operating rule

Course data-quality filters should become natural work queues for deterministic jobs and bounded agents. Preferred pattern:

`detect missing/stale -> reacquire/extract -> compare -> auto-apply safe evidence-backed facts -> queue exceptions -> verify -> update completeness/change signals`

Human operators should focus on ambiguity and exceptions, not manually inspect every course.
