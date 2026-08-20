# CourseFinder Running Build v2.53

**Status:** CURRENT GOVERNED SOURCE BUILD — CLOUDFLARE RUNTIME OBSERVATION PENDING  
**Date:** 20 August 2026  
**Supersedes:** `docs/coursefinder-running-build-v2.52.md`  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.37.md`  
**Master plan:** `docs/coursefinder-master-project-plan-v1.49.md`  
**Scholarship UAT:** `docs/uat/coursefinder-m1-pim-gov-scholarship-v2.8.0-uat-2026-08-20.md`

## Build delta

v2.53 preserves the accepted Layer 1, Layer 2, Search, fee, Insights, Evidence, full-catalogue paging and PIM Admin v2.7 Course-detail state and adds `CF-CHG-20260820-011`: governed Scholarship compound semantics in **PIM Admin v2.8.0**.

## Scholarship semantic defect corrected

The canonical relational Scholarship model already preserved Offering Cycles, Application Windows, Scopes, Criterion Groups/Criteria, Award Tiers and Coverage. The prior Admin presentation did not preserve those relationships safely:

- cycle/window backend keys were not represented by the expected frontend sections;
- group and criterion raw tables hid parent/child and `all`/`any` logic;
- Scope targets were raw IDs;
- child provenance lacked semantic context;
- direct authenticated execution of legacy `ui_scholarship_detail` remained open.

No canonical Scholarship row was rewritten.

## Governed Scholarship read contract

Pilot migration:

`m1_pim_gov_scholarship_semantics_v1`

Repository mirror:

`supabase/production-migrations/065_m1_pim_gov_scholarship_semantics.sql`

`security.admin_scholarship_semantic_summary(uuid)` provides:

- Scholarship record provenance;
- cycle-nested Application Windows;
- resolved include/exclude Scopes;
- nested eligibility groups with direct criteria and parent/conjunction semantics;
- Award Tiers;
- Coverage/benefits;
- explicit unscoped child-observation bucket.

`public.admin_read('scholarship_detail',...)` remains the browser boundary.

Security after-state:

- `anon` helper execution false;
- authenticated helper execution true only to support the invoker wrapper; helper remains under non-exposed `security` and role-checks internally;
- direct authenticated legacy `public.ui_scholarship_detail(uuid)` false;
- authenticated `public.admin_read` true.

## PIM Admin v2.8.0

New component:

`src/ScholarshipSemanticDetail.jsx`

Presentation now includes:

- Scholarship provenance;
- Offering Cycles;
- Application Windows;
- Applicability Scopes;
- recursive Eligibility Logic with explicit **ALL of the following** / **ANY of the following**;
- Criteria with mandatory/machine-evaluable/confidence/source/evidence context;
- Award Tiers;
- Coverage / benefits;
- source-only closing text preservation;
- explicit no-Scope warning rather than universal-scope inference;
- Needs Attention for Scholarship-level/unscoped observations.

The v2.8 integration into `src/main.jsx` is deliberately minimal. Initial comparison against the v2.7 base showed:

- `src/ScholarshipSemanticDetail.jsx` added;
- `src/main.jsx`: 3 additions / 2 deletions;
- `package.json`: one version-line change;
- branch ahead 3 / behind 0 before governance/migration mirrors were added.

Visible/package version is `2.8.0`.

## Reference UAT — Australia Awards Scholarships

Authenticated governed read confirms:

- Offering Cycles: 1;
- Application Windows: 2;
- Eligibility Groups: 2;
- root General eligibility group: `all`, 7 direct criteria;
- child Participating-country pathway group: `any`, 2 direct criteria and correct parent;
- Coverage components: 9;
- structured Scope rows: 0;
- unscoped criteria: 0.

No Scope rows are interpreted as no structured Scope rows, not universal Provider/Course applicability.

## Reference UAT — RMIT David Phillips Memorial Scholarship

Authenticated governed read confirms:

- Offering Cycle: `recurring`;
- one Application Window;
- exact open/close timestamps absent;
- source closing text retained: `Mid September each year - check website for exact dates`;
- one include Provider Scope resolved to RMIT University (RMIT);
- one Award Tier: AUD 5,000 / annual;
- one eligibility group.

No approximate September date was manufactured.

## Governance outputs

- `CF-CHG-20260820-011`;
- PIM Admin Guide v1.4;
- Zoho Consumer Contract v1.2;
- Scholarship v2.8 UAT;
- repository migration 065;
- Change Control register updated.

## Preserved programme baselines

- AU CRICOS: 1,546 Providers / 26,648 active Courses;
- Layer 1 adapter: `layer1-au-depth-v1.6.0`;
- AU Course Facts: RMIT + UQ qualified / 10 bounded Courses;
- QUT: source-specific deferred HTTP 403;
- QILT/PRISMS accepted state unchanged;
- Scholarship canonical/source gate unchanged; only governed Admin semantics advanced;
- Search Course Documents: 33,105;
- fee/intake/English Search enrichment admitted: 0;
- vector Search remains not admitted.

## Deployment/build boundary

A source/DB UAT PASS is not represented as Cloudflare deployment/browser PASS. The current environment cannot independently observe the Worker runtime, and the execution container does not provide a reliable external-DNS path for an independent fresh Vite dependency/bootstrap build.

## Current open PIM governance state

`CF-CHG-001`, `005`, `006`, `007`, `008`, `009`, `010` and `011` all have their applicable technical/frontend source gates passed but remain open where deployed authenticated browser UAT is still required.

## Next work

1. publish v2.8 to `main` only by non-force fast-forward after final branch/main reconciliation;
2. complete deployed authenticated browser UAT when runtime observation is available;
3. audit lifecycle, publication, completeness/readiness and Search-state presentation as one semantic-state model;
4. create another Change Control only if a material semantic defect is proven;
5. keep Website/Zoho/Search admission independently governed.

Database Architecture remains v2.10.37 because no canonical relational model changed.
