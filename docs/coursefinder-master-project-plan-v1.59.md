# CourseFinder Master Project Plan v1.59

**Status:** **AUTHORITATIVE PROGRAMME GOVERNANCE — DATA QUALITY v1.0 ACCEPTED**  
**Supersedes:** `docs/coursefinder-master-project-plan-v1.58.md`  
**Last consolidated:** 22 August 2026 13:41 AEST  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.38.md`  
**Running build:** `docs/coursefinder-running-build-v2.62.md`  
**Admin/PIM decisions:** `docs/coursefinder-admin-pim-design-decisions-v1.12.md`  
**Admin Guide:** `docs/coursefinder-pim-admin-guide-v1.13.md`

## Current programme position

- M1-PIM-FINALISATION — **CLOSED / PASS**.
- M1-PIPELINE-OPS (`CF-CHG-20260821-016`) — **CLOSED / PASS**.
- M1-EVIDENCE-UX (`CF-CHG-20260821-017`) — **CLOSED / PASS**.
- M1-DATA-QUALITY-READINESS (`CF-CHG-20260821-018`) — **CLOSED / PASS**.

Accepted operational journey remains:

`Layer 1 Regulatory → Layer 2 Deterministic/Structured Enrichment → Layer 3 AI Suggestions → Layer 4 Human Resolution → Search Admission → Publication`

Data Quality v1.0 now provides the accepted cross-entity operational readiness layer without collapsing these authorities.

## Current accepted implementation authority

Pilot source/head:

`msinghbs-ai/Coursefinder-Pilot@72721c57d2a11a5fb79288c9eadf4e14602a2e14`

Visible runtime marker:

`PIM Admin v2.12 · Pipeline Ops v1.0 · Evidence v1.0 · Data Quality v1.0 · governed`

## Data Quality accepted model

CourseFinder does not use one equal-weight completeness score as truth. Readiness is reported by domain across Provider, Course, Campus and Scholarship.

Accepted states:

`present / source_null / not_applicable / zero / suppressed / not_yet_enriched / stale / ambiguous / rejected`

Present and legitimate numeric zero are ready; not-applicable is excluded from the denominator. Source-null requires governed source evidence. Missing later enrichment is not-yet-enriched. No values are manufactured to improve readiness.

Historical Course completeness remains available only as explicitly labelled `Legacy presence`.

## Data Quality operational acceptance

The deployed Worker has passed:

- AU and all-country Catalogue regression;
- Data Quality AU+NZ overview/state rendering;
- regulatory-fee source-null = 191;
- legitimate numeric zero = 131;
- NZ regulatory-fee not-applicable = 6,457;
- all four bounded exception pages;
- canonical Course navigation;
- real Evidence link navigation to a CRICOS Regulatory Snapshot/private Evidence detail workspace.

Accepted browser path:

`Domain readiness → Exception → canonical entity → Evidence / Review where real`

Review remains conditional on real governed Review rows; none were fabricated for UAT.

## Current technical baselines

- AU Providers / Courses: 1,546 / 26,648;
- NZ Providers / Courses: 409 / 6,457;
- AU+NZ Providers / Courses: 1,955 / 33,105;
- all-country Courses: 43,461;
- Campuses: 3,922;
- Scholarships: 4;
- Search Course Documents: 33,105;
- Data Quality regulatory-fee states: 26,326 present positive / 191 source-null / 6,457 not-applicable / 131 zero.

## Read/security boundary

`Supabase Auth → public.admin_read(text,jsonb) → server-side role/rank check → governed internal read`

Data Quality overview/exceptions are assigned-role reads. Evidence remains Curator+ rank 3. Pipeline remains Pipeline Operator+ rank 4. Private Data Quality/Evidence/Pipeline schemas are not exposed as generic browser CRUD APIs.

## Architecture position

Database Architecture v2.10.38 remains current. Data Quality changes governed read semantics and Admin UX but does not alter canonical identity, source authority, Evidence grain or core database architecture.

## Follow-on UAT operating model

The manual screenshot sequence needed to close CF-CHG-018 demonstrated that release acceptance is too operator-intensive. The next governed workstream is:

`M1-UAT-HARNESS — Automated Operational Acceptance`

It will automate repeatable browser/RPC regression, preserve real authentication/RBAC, collect Playwright screenshots/traces/network evidence and retain human review only for semantic/visual judgement. The harness is a release-process improvement and must not weaken authentication or introduce service-role credentials into the browser.

## Current governing references

- `CF-CHG-20260821-016` — CLOSED / PASS;
- `CF-CHG-20260821-017` — CLOSED / PASS;
- `CF-CHG-20260821-018` — CLOSED / PASS;
- Data Quality contract v1.0;
- Data Quality technical UAT;
- Data Quality deployed-browser UAT;
- PIM Admin Guide v1.13;
- Admin/PIM Design Decisions v1.12;
- Running Build v2.62.

## Baseline for subsequent work

Use:

- Master Project Plan v1.59;
- Running Build v2.62;
- Database Architecture v2.10.38;
- Admin/PIM Design Decisions v1.12;
- PIM Admin Guide v1.13;
- Pilot head `72721c57d2a11a5fb79288c9eadf4e14602a2e14`.

Future Data Quality semantic changes require a new/applicable Change Control; browser automation under the UAT Harness must validate, not silently redefine, these accepted semantics.