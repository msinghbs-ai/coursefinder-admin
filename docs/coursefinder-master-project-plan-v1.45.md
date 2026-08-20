# CourseFinder Master Project Plan v1.45

**Status:** AUTHORITATIVE PROGRAMME GOVERNANCE DOCUMENT  
**Supersedes:** `docs/coursefinder-master-project-plan-v1.44.md`  
**Last consolidated:** 20 August 2026  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.37.md`  
**Running build:** `docs/coursefinder-running-build-v2.49.md`

## Current programme position

| Workstream | Status | Decision |
|---|---|---|
| AU Layer 1 CRICOS identity/geography/field | PASS / ACCEPTED | Preserve 1,546 Provider / 26,648 active Course substrate |
| AU Layer 1 residual completeness remediation | PASS / COMPLETE | `layer1-au-depth-v1.6.0`; zero missing Study Levels; zero unexplained mapping defects |
| AU first-party Course facts | IN PROGRESS / 2 QUALIFIED SOURCES / 10 COURSES BOUNDED | RMIT + UQ accepted; controlled expansion continues |
| QUT Course Facts candidate | DEFERRED / SOURCE-SPECIFIC | Production Edge acquisition returns HTTP 403; APPLY disabled |
| AU QILT Layer 2A | PASS / ACCEPTED | Preserve governed Provider-level outcomes |
| AU PRISMS Layer 2A | PASS / ACCEPTED | Preserve aggregate source-grain observations without invented identity |
| AU Scholarships | PASS / FIRST-SOURCE ACCEPTED | Controlled expansion only |
| Search governed projection + FTS | PASS / ACCEPTED | 33,105 documents |
| Vector/semantic Search | REJECTED / NOT ADMITTED | Existing rejection remains in force |
| Search enrichment readiness | BLOCKED / SEPARATE GATE | Layer 2 facts are not automatically consumer-admitted |
| Admin/PIM hardening | PASS / COMPLETE | Existing security/operational acceptance remains in force |
| M1-PIM-GOV fee semantics | TECHNICAL + FRONTEND SOURCE PASS / DEPLOYED BROWSER PENDING | `CF-CHG-20260820-001` |
| M1-PIM-GOV Insights restoration | TECHNICAL + FRONTEND SOURCE PASS / DEPLOYED BROWSER PENDING | `CF-CHG-20260820-005` |
| M1-PIM-GOV Evidence provenance | TECHNICAL + FRONTEND SOURCE PASS / DEPLOYED BROWSER PENDING | `CF-CHG-20260820-006` |
| M1-PIM-GOV Catalogue paging/exact identity | TECHNICAL + FRONTEND SOURCE PASS / DEPLOYED BROWSER PENDING | `CF-CHG-20260820-007` |
| **M1-PIM-GOV Provider/Course/Campus geography** | **DB/RPC/SECURITY PASS / FRONTEND PRESENTATION PENDING** | `CF-CHG-20260820-008`; Provider geography must never substitute Course delivery geography |

## Provider / Course / Campus semantic decision

Provider geography, Campus geography and Course→Campus delivery relationships are separate governed concepts.

Canonical model remains:

- Provider identity/geography: `catalogue.providers`;
- Campus identity/geography: `catalogue.campuses`;
- Course delivery relationship: `catalogue.course_campuses`.

The model was already correct; the material gap was Admin read/presentation provenance.

## Course Campus read-contract correction

Pilot migration:

`m1_pim_gov_course_campus_semantics_v1`

Repository mirror:

`supabase/production-migrations/061_m1_pim_gov_course_campus_semantics.sql`

The governed Course Campus payload now preserves:

- Campus stable identity;
- Campus country/subdivision/city/address/postcode;
- Campus status/publication/validity/verification;
- Course→Campus delivery mode and primary flag;
- Campus source/evidence;
- Course→Campus relationship source/evidence.

Direct authenticated execution of the public helper has been removed. Browser consumption remains through `public.admin_read`.

## Reference audit — CRICOS 121174E

Exact Course:

- Swinburne University of Technology;
- Bachelor of Artificial Intelligence;
- CRICOS Course Code `121174E`;
- stable key `course:cricos:00111d:121174e`.

Provider geography includes AU / AU-VIC / HAWTHORN.

The Course separately relates to the canonical Hawthorn Campus through `catalogue.course_campuses`:

- AU / AU-VIC / HAWTHORN;
- delivery mode `on_campus`;
- `is_primary=false`;
- Campus active;
- Campus unpublished;
- Campus and relationship evidence separately retained.

Matching geography in this case does not authorise flattening the Provider and Course Campus concepts.

## Admin presentation contract

The frontend must use a dedicated **Course delivery campuses** presentation rather than a generic Campus JSON block.

It must:

1. use Campus geography, not Provider geography, for Course delivery location;
2. preserve one-to-many Campus relationships;
3. display relationship delivery mode and primary flag without reinterpretation;
4. keep Campus lifecycle/publication separate from Course lifecycle/publication;
5. distinguish Campus source/evidence from Course→Campus relationship source/evidence;
6. show explicit absence when no accepted relationship exists;
7. never create or imply a synthetic Campus to improve completeness.

Current frontend source remains PIM Admin v2.6.0; no newer UI version is claimed until that presentation is implemented.

## PIM Admin Guide / consumer semantics

`docs/coursefinder-pim-admin-guide-v1.1.md` becomes the current geography semantic guide.

Downstream curated contracts must not expose an ambiguous Course `State` field that silently combines Provider and Campus geography. Repeating Course Campus observations must remain repeating when more than one Campus is accepted.

No Website/Zoho/Search admission is authorised by this semantic definition alone.

## Preserved semantic controls

- exact stable identifiers before names/titles;
- no title-only Course reconciliation;
- NULL, zero, suppressed, absent and not-applicable remain distinct;
- completeness/readiness is not truth or publication approval;
- `last_verified_at` is verification, not approval;
- regulatory and Provider-current fee semantics remain separate;
- QILT remains Provider-level unless a more specific mapping is explicitly proven;
- PRISMS remains aggregate source grain without manufactured Provider/Course identity;
- Evidence remains provenance, not approval;
- Search admission remains independent.

## Current Change Control

- `CF-CHG-20260820-001` — fee semantics/Admin Guide — technical + source PASS, deployed browser pending;
- `CF-CHG-20260820-002` — CLOSED / PASS;
- `CF-CHG-20260820-003` — DEFERRED;
- `CF-CHG-20260820-004` — CLOSED / PASS;
- `CF-CHG-20260820-005` — Insights restoration — technical + source PASS, deployed browser pending;
- `CF-CHG-20260820-006` — Evidence provenance — technical + source PASS, deployed browser pending;
- `CF-CHG-20260820-007` — catalogue paging/exact identity — technical + source PASS, deployed browser pending;
- `CF-CHG-20260820-008` — Provider/Course/Campus geography — DB/RPC/SECURITY PASS, frontend presentation pending.

## Next PIM-GOV work

1. implement dedicated Course delivery-campus presentation and source-test it;
2. audit Intake and English requirement semantics, especially one-to-many grain, Campus scope, source/evidence and NULL/absence behaviour;
3. audit Study Level and Field of Study source vocabulary/mapping presentation;
4. audit Scholarship compound eligibility/scope presentation;
5. audit lifecycle/publication/Search state separation;
6. complete deployed browser UAT when Cloudflare runtime observation is available.

Database Architecture remains v2.10.37 because no canonical relational model changed.
