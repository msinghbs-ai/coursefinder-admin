# CourseFinder Milestone 1 Frozen Architecture Baseline v1.0

**Status:** FROZEN — M1 PILOT BASELINE ACCEPTED  
**Effective:** 23 August 2026  
**Change Control:** `CF-CHG-20260823-028`  
**Underlying database architecture:** `docs/coursefinder-database-architecture-v2.10.40.md`

## 1. Purpose

This document freezes the accepted CourseFinder Milestone 1 Pilot architecture without redefining canonical semantics. It is a release baseline, not a replacement for the detailed database architecture, Admin design decisions or source-specific UAT records.

Any later change must explicitly state whether it extends, supersedes or invalidates this frozen baseline.

## 2. Accepted authority model

`Layer 1 Regulatory → Layer 2 Deterministic/Structured Enrichment → Layer 3 AI Suggestions → Layer 4 Human Resolution → Search Admission → Governed Publication → Consumer Channels`

Authority rules remain:

- stable source identifiers before names;
- Layer 2 does not redefine Layer 1 identity;
- source rows do not automatically become canonical or published data;
- Search, Website and Zoho are derived/curated consumers;
- evidence/version/source authority is preserved;
- source-null, zero, suppressed, not-applicable, rejected and not-yet-enriched remain distinct states;
- completeness/readiness is not truth or publication authority.

## 3. Repository responsibility boundary

### Admin repository

`msinghbs-ai/coursefinder-admin`

Authoritative for:

- programme governance;
- Change Control;
- master plan / running build;
- architecture and design decisions;
- UAT acceptance records;
- user/admin/operations guidance;
- release acceptance and baseline freeze.

### Pilot repository

`msinghbs-ai/Coursefinder-Pilot`

Authoritative for:

- deployed Pilot application/runtime implementation;
- Supabase migration mirrors;
- Edge Function source;
- automated browser UAT implementation;
- source-controlled runtime changes.

Frozen Pilot main at acceptance: `133b81734e435f9dea5ffb3ddd943e71d2930696`.

The final accepted deployed browser performance evidence is bound to `1bcb96d26f7c701ec6cf91d771016cb6405f51b2`; later Pilot commits are security-only layers and do not alter accepted PIM/Admin UI semantics.

## 4. Deployed data baseline

Live Supabase project: `coursefinder_Pilot` (`fxcwkweaxjtknorudmwp`) in Mumbai / `ap-south-1`.

Accepted counts:

- all-country Providers: 3,085;
- all-country Courses: 43,461;
- AU: 1,546 Providers / 26,648 Courses;
- NZ: 409 Providers / 6,457 Courses;
- AU+NZ Search projection: 33,105 Course documents;
- Evidence artifacts at final acceptance smoke: 1,567;
- Pipeline jobs at final acceptance smoke: 1,325.

Integrity smoke at freeze found zero bounded orphan/duplicate identity defects for Provider/Course/Search relationships and stable keys.

## 5. Canonical and enrichment baseline

Accepted M1 surfaces include:

- AU/NZ canonical Layer 1;
- CRICOS identity and regulated facts;
- QILT structured outcomes at governed provider/study-area grain;
- PRISMS student-flow/cohort observations at governed grain;
- governed Scholarship entities/scopes;
- UAT-approved first-party RMIT/UQ Course Facts;
- Course fee, intake, English requirement and official-link structures;
- Evidence/provenance and versioned source relationships.

QILT/PRISMS are not flattened to Course grain merely for Search convenience.

QUT first-party Course Facts remain explicitly deferred and are not part of this frozen accepted coverage.

## 6. Admin/PIM and operational capabilities

Frozen capability marker:

`PIM Admin v2.12 · Pipeline Ops v1.0 · Evidence v1.0 · Data Quality v1.0 · Access Admin v1.0 · Publication Governance v1.0 · governed`

Accepted role boundary:

1. Viewer;
2. Counsellor;
3. Curator;
4. Pipeline Operator;
5. PIM Admin;
6. Platform Admin.

Minimum operational ranks remain:

- Evidence / review: rank 3;
- Jobs / Sources / Pipeline: rank 4;
- PIM Configuration: rank 5;
- Settings / Access Admin: rank 6.

## 7. Search baseline

Accepted projection: `course-v3`.

Frozen semantic hashes:

- base: `cd2c8422da31f2fa298053a40563c947780ebdaf09d7b41ff983bc6ef9649d9b`;
- enrichment: `fb0585a82e9fe5bc43e9d34bb0f55968846fefba3cf5cc7a41cd0523814bfd3d`;
- combined: `b4660ebc15851620bd111c82a74a19899c43a4560e5d2eb571b40e3c64bf77ee`.

Generation at final acceptance: 22. Generation is operational, not a semantic freeze invariant.

Final dry-run at freeze:

- base: 0 new / 0 changed / 0 removed / 33,105 unchanged;
- enrichment: 0 changed / 33,105 unchanged.

Vector/hybrid remains outside M1 acceptance: 0 embeddings, 0 embedding jobs and 0 query embedding cache rows.

## 8. Publication / consumer baseline

Final Pilot state is intentionally closed:

- published Search documents: 0;
- `publishing.entity_states`: 0;
- broad catalogue publication: unauthorised.

The bounded publication-positive UAT capability does not itself authorise production or broad catalogue publication.

Website and Zoho remain governed consumers and are not canonical identity authorities.

## 9. Security baseline

Browser database/API boundary:

- only `public.admin_read(text,jsonb)` is executable by `authenticated` as an application browser RPC in `public`;
- it is SECURITY INVOKER;
- anon execution is denied;
- application tables are not directly exposed to browser roles under the accepted model.

Evidence Storage:

- bucket: `evidence`;
- private;
- 50 MiB object maximum;
- MIME restricted;
- signed-access path remains separately role checked.

Accepted Pilot residuals:

- leaked-password protection disabled: explicitly deferred for Pilot and mandatory before Production security sign-off;
- retired diagnostic/UAT Edge slugs may remain as JWT-protected HTTP 410 tombstones;
- retained custom-auth ingestion workers are Pilot-only service-control-plane exceptions with bounded nonce/key controls and require Production identity review;
- RLS/no-policy INFO findings are accepted only while direct browser table grants remain absent.

## 10. Performance baseline

Final accepted deployed run: `32622164346`.

Accepted budgets and evidence remain those in `docs/uat/coursefinder-m1-performance-responsiveness-technical-acceptance-2026-08-23.md`, including:

- interactive deployed RPC/detail operations <= 3,000 ms wall time;
- bounded list payloads;
- grid-contained horizontal scrolling at accepted laptop/desktop widths;
- deterministic Search dry-run preventing unnecessary rebuild churn.

Performance Advisor INFO-only unindexed-FK / unused-index observations are not baseline blockers unless future measured workload proves regression.

## 11. Operations/documentation baseline

Accepted operational documents:

- `docs/coursefinder-user-guide-v2.0.md`;
- `docs/coursefinder-pim-admin-guide-v1.15.md`;
- `docs/coursefinder-operations-runbook-v1.0.md`;
- `docs/coursefinder-data-quality-readiness-contract-v1.0.md`;
- `docs/coursefinder-publication-governance-contract-v1.0.md`.

## 12. Explicit post-M1 boundary

Outside the frozen M1 Pilot baseline:

- Production leaked-password protection enablement/UAT;
- vector/hybrid Search admission;
- QUT Course Facts acquisition;
- broad catalogue publication and Production channel cutover;
- physical deletion of retired Edge tombstones;
- Production identity redesign/revalidation for custom-auth ingestion workers;
- further country expansion and wider enrichment coverage;
- non-blocking performance-advisor optimisation.

## 13. Freeze decision

**CourseFinder Milestone 1 is frozen and accepted for the governed Pilot baseline.**

This baseline does not claim Production readiness. Production/cutover work must satisfy the separately governed Production gates and must not reinterpret this Pilot acceptance as permission to publish broadly or waive security controls.