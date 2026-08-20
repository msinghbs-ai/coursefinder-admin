# CourseFinder Master Project Plan v1.46

**Status:** AUTHORITATIVE PROGRAMME GOVERNANCE DOCUMENT  
**Supersedes:** `docs/coursefinder-master-project-plan-v1.45.md`  
**Last consolidated:** 20 August 2026  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.37.md`  
**Running build:** `docs/coursefinder-running-build-v2.50.md`

## Current programme position

| Workstream | Status | Decision |
|---|---|---|
| AU Layer 1 CRICOS identity/geography/field | PASS / ACCEPTED | Preserve 1,546 Provider / 26,648 active Course substrate |
| AU Layer 1 residual completeness remediation | PASS / COMPLETE | `layer1-au-depth-v1.6.0`; zero missing Study Levels; zero unexplained mapping defects |
| AU first-party Course facts | IN PROGRESS / 2 QUALIFIED SOURCES / 10 COURSES BOUNDED | RMIT + UQ accepted; controlled expansion continues |
| QUT Course Facts candidate | DEFERRED / SOURCE-SPECIFIC | Production Edge acquisition returns HTTP 403; APPLY disabled |
| AU QILT Layer 2A | PASS / ACCEPTED | Preserve Provider-level outcomes grain |
| AU PRISMS Layer 2A | PASS / ACCEPTED | Preserve aggregate source grain without manufactured Provider/Course identity |
| AU Scholarships | PASS / FIRST-SOURCE ACCEPTED | Controlled expansion only |
| Search governed projection + FTS | PASS / ACCEPTED | 33,105 documents |
| Vector/semantic Search | REJECTED / NOT ADMITTED | Existing rejection remains in force |
| Search enrichment readiness | BLOCKED / SEPARATE GATE | Layer 2 facts are not automatically consumer-admitted |
| Admin/PIM hardening | PASS / COMPLETE | Existing security/operational acceptance remains in force |
| M1-PIM-GOV fee semantics | TECHNICAL + FRONTEND SOURCE PASS / DEPLOYED BROWSER PENDING | `CF-CHG-20260820-001` |
| M1-PIM-GOV Insights restoration | TECHNICAL + FRONTEND SOURCE PASS / DEPLOYED BROWSER PENDING | `CF-CHG-20260820-005` |
| M1-PIM-GOV Evidence provenance | TECHNICAL + FRONTEND SOURCE PASS / DEPLOYED BROWSER PENDING | `CF-CHG-20260820-006` |
| M1-PIM-GOV Catalogue paging/exact identity | TECHNICAL + FRONTEND SOURCE PASS / DEPLOYED BROWSER PENDING | `CF-CHG-20260820-007` |
| M1-PIM-GOV Provider/Course/Campus geography | DB/RPC/SECURITY PASS / FRONTEND PRESENTATION PENDING | `CF-CHG-20260820-008` |
| **M1-PIM-GOV Intake / English semantics** | **DB/RPC/SECURITY PASS / FRONTEND PRESENTATION PENDING** | `CF-CHG-20260820-009`; repeating observation grain and provenance preserved |

## Intake semantic contract

Course Intakes remain repeatable Provider-current observations. They may carry:

- source year/label;
- start date;
- application deadline;
- optional Campus scope;
- status/confidence;
- source/evidence;
- source observation identity.

`campus_id=NULL` means no accepted Campus scope is recorded. It does not mean every Campus.

Multiple Intakes for the same year remain separate.

## English requirement semantic contract

English entry requirements remain repeatable Course-level observations by governed `ref.english_tests` identity.

Overall and component thresholds remain distinct. Test alternatives/requirements are not merged into one generic score.

Validity, verification, confidence, source/evidence and source requirement identity remain part of the audit contract.

The current schema has no Campus scope on English requirements; Campus scope must not be invented.

## Reference case — UQ CRICOS 102784C

Course: Bachelor of Computer Science (Honours).

Accepted 2027 Intakes:

1. Semester 1 — start 22 February 2027 — application deadline 30 November 2026;
2. Semester 2 — start 26 July 2027 — application deadline 31 May 2027.

Both have no accepted Campus scope recorded.

Accepted English requirements:

- IELTS Academic — overall 6.5; Reading/Writing/Speaking/Listening minimum 6;
- PTE Academic — overall 64; minimum each 60;
- TOEFL iBT — overall 87; Reading 19, Writing 21, Speaking 19, Listening 19.

All retain Provider source/evidence and governed test identities.

## Governed read/security correction

Pilot migration:

`m1_pim_gov_intake_english_semantics_v1`

Repository mirror:

`supabase/production-migrations/062_m1_pim_gov_intake_english_semantics.sql`

Course detail now gains `entry_summary` through the governed `public.admin_read` wrapper.

Direct authenticated execution of the legacy `public.ui_course_detail(uuid)` is revoked; browser access remains through `public.admin_read`.

No canonical observations were changed.

## Frontend semantic requirement

Current frontend remains PIM Admin v2.6.0.

The next coherent Course-detail semantic release is planned as v2.7.0 and should combine:

- dedicated **Course delivery campuses** presentation (`CF-CHG-008`);
- dedicated **Course Intakes** repeating presentation (`CF-CHG-009`);
- dedicated **English entry requirements** repeating presentation (`CF-CHG-009`).

The UI must preserve null/absence semantics, Campus scope, component thresholds, source/evidence and distinct observation grain.

## PIM / Zoho governance

Current semantic documents:

- `docs/coursefinder-pim-admin-guide-v1.2.md`;
- `docs/coursefinder-zoho-consumer-contract-v1.1.md`.

Zoho/Website admission remains separately gated. If a downstream system cannot represent repeating Campus/Intake/English objects without semantic loss, those field classes remain unadmitted until a governed consumer-specific representation is approved.

## Preserved controls

- stable identifier before name/title;
- no title-only Course identity;
- NULL / zero / suppression / absence remain distinct;
- Provider geography != Course delivery geography;
- completeness/readiness != truth/approval/publication;
- `last_verified_at` != approval;
- CRICOS registered fees != Provider-current fees;
- QILT remains Provider-level unless separately proven otherwise;
- PRISMS remains aggregate/no manufactured identity;
- Evidence remains provenance;
- Search admission remains independent.

## Current Change Control

- `CF-CHG-001` — technical/source PASS, deployed browser pending;
- `CF-CHG-002` — CLOSED / PASS;
- `CF-CHG-003` — DEFERRED;
- `CF-CHG-004` — CLOSED / PASS;
- `CF-CHG-005` — technical/source PASS, deployed browser pending;
- `CF-CHG-006` — technical/source PASS, deployed browser pending;
- `CF-CHG-007` — technical/source PASS, deployed browser pending;
- `CF-CHG-008` — DB/RPC/SECURITY PASS, frontend pending;
- `CF-CHG-009` — DB/RPC/SECURITY PASS, frontend pending.

## Next work

1. implement/source-test the v2.7 Course-detail semantic presentation;
2. audit Study Level and Field of Study source vocabulary/mapping presentation;
3. audit Scholarship compound eligibility, offering-cycle and scope presentation;
4. audit lifecycle/publication/Search status separation;
5. complete deployed browser UAT when Cloudflare runtime observation becomes available.

Database Architecture remains v2.10.37 because no canonical relational model changed.
