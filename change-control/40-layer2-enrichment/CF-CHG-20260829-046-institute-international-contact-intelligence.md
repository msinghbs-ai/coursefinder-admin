# CF-CHG-20260829-046 — Institute International Contact Intelligence

**Status:** ACTIVE — A15 IMPLEMENTATION / TARGETED UAT
**Category:** 40-layer2-enrichment
**Initiated:** 29 August 2026
**Origin chat/workstream:** M2.4.3 addendum — institute manager / international contact details
**Owner:** M2.4.3 workstream
**Change class:** schema/enrichment/privacy/UI/UAT/operations

## Trigger

User requested Provider/Institute detail to include institute manager / international-course contact details, deterministic scraping of university International/Regional Manager contact pages across AU/NZ, and optional licensed professional enrichment/job-title change monitoring.

## Governing design

A15 introduces **international contact intelligence** without creating a new identity authority.

1. First-party university pages are preferred and stored as governed Layer 2 Evidence-backed observations.
2. Licensed professional enrichment (for example Apollo/ZoomInfo-equivalent APIs) is secondary context and must never overwrite first-party university-published contact facts.
3. LinkedIn HTML scraping is not authorised. Any LinkedIn-derived field must arrive through a licensed/authorised enrichment provider or a first-party university page that links to the profile.
4. Personal-email/mobile reveal is disabled by default. The initial provider adapter searches title/domain and stores professional profile/title context only.
5. Provider/Course identity, Search and Publication authority are unchanged.
6. Every contact retains source class, source URL/provider, observed/verified timestamps, territory text/codes, and Evidence where available.
7. Job-title/contact changes create explicit watch events rather than silently replacing history.
8. A14 telemetry extends to contact discovery/enrichment attempts: provider, calls, units/credits where available, latency, cost where available, outcome and timestamps.

## Initial target cohort

Derived from governed catalogue rather than a hard-coded list:
- AU: 52 providers with governed website and University naming;
- NZ: 8 providers with governed website and University/Te Pūkenga naming;
- total initial profiles: 60.

## UI

Provider detail receives a dedicated **International contacts** section above generic object dumps:
- name / team;
- job title;
- territory/market assignment;
- work email / work phone when first-party or licensed business-contact data permits;
- source class badge;
- source/provider link;
- observed/verified freshness;
- Evidence link for first-party scrape;
- recent title/contact-change signals.

Course detail may later consume Provider contact context read-only, but A15 first acceptance is Provider-detail only.

## Acceptance

Targeted automated UAT must prove:
- profile seed count by AU/NZ;
- anonymous/direct-table negatives;
- Provider detail read projection;
- first-party precedence over licensed enrichment;
- no personal-email/phone reveal in the Apollo search adapter;
- change-watch event creation;
- browser Provider blade rendering;
- Security/Performance Advisors no new WARN/ERROR;
- no canonical/Search/Publication mutation.
