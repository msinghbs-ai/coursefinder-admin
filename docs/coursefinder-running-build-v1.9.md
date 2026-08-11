# Coursefinder Running Build v1.9

## Current Phase
Phase 3 — Layer 1 Regulatory Pipeline.

**AU CRICOS full-ingestion phase gate: COMPLETE / PASS.**

## Runtime Boundary
- Runtime: `coursefinder_Pilot` in Mumbai (`ap-south-1`).
- Architecture baseline: v2.9.1.
- Cloudflare: React/Vite SPA delivery only.
- Supabase Auth: user authentication and Platform Admin identity.
- Supabase Edge Functions: authenticated Layer 1 execution and controlled Pilot reset.
- PostgreSQL: canonical catalogue, PIM, job state, reconciliation and Search Projection.
- Supabase Storage: private regulatory evidence.

## AU Full CRICOS Baseline
Live CKAN discovery resolved the data.gov.au resource `CRICOS Providers, Courses, and Locations`, last modified `2026-08-04T01:15:34.464772`.

Pipeline job: `97a1ef94-b6cf-4eaf-9b53-52bd370d47da`.

Five immutable evidence artifacts were retained with SHA-256 hashes:
- consolidated ZIP;
- Institutions CSV;
- Courses CSV;
- Locations CSV;
- Course Locations CSV.

Final Mumbai counts:

| Measure | Count |
|---|---:|
| Providers | 1,546 |
| CRICOS Provider Registrations | 1,546 |
| Courses | 26,648 |
| CRICOS Course Registrations | 26,648 |
| Campuses | 3,922 |
| Eligible Course Location records | 47,677 |
| Canonical Course↔Campus links | 47,671 |
| Search Documents | 26,648 |
| Preserved Layer 1 seed snapshots | 5 |

## Identity Defect Found and Corrected
Full-scale UAT exposed a material defect in the previous reconciliation function: an unseen provider could be matched by normalised provider name and a course by normalised course title.

That violated v2.9.1: **names never act as identity**.

The accepted Layer 1 identity contract is now:
- Provider = country + registration scheme + regulator provider code, backed by stable key.
- Course = provider + registration scheme + regulator course code, backed by stable key.
- Provider names are descriptive and cannot merge different regulator IDs.
- Course titles are descriptive and cannot merge different regulator IDs.

The change is Git-tracked in `041_layer1_identifier_identity_hardening.sql`.

`svc_layer1_apply_register_records` execution was verified as restricted to `postgres` and `service_role`.

## Full Idempotency — PASS
A complete AU rerun produced:
- New Providers: **0**.
- New Courses: **0**.
- New Campuses: **0**.
- New Course↔Campus links: **0**.
- Conflicts: **0**.

Registration and relationship duplicate checks also returned zero.

Course Location reruns demonstrated that excessive concurrency can hit PostgreSQL statement timeout. Ten simultaneous 5,000-record requests were too aggressive; the affected ranges passed in bounded 2,500-record slices. This is now an operational batching requirement, not a data-integrity exception.

## Integrity — PASS
Validated zero:
- provider-registration orphans;
- course-registration orphans;
- campus-provider orphans;
- course-campus orphans;
- duplicate CRICOS provider registration keys;
- duplicate CRICOS course registration keys;
- duplicate course-campus pairs;
- providers without CRICOS registrations;
- courses without CRICOS registrations.

## Search — PASS
Search Projection finalisation produced:
- 26,648 Search Documents for 26,648 Courses.
- 1,546 distinct Providers represented.
- 0 empty search text rows.
- 24,367 Courses with mapped study level.
- Search generation 2.
- Full Search Projection rebuild: approximately **3.74 seconds**.

FTS validation:
- `bachelor business`: 681 matches.
- `nursing`: 274 matches.
- `engineering`: 1,223 matches.
- Ranked `engineering` top-20 query: approximately **4.28 ms**, using `course_documents_tsv_idx`.

## Full-Scale Runtime Rule
Do not perform full AU ingestion as one monolithic Edge invocation. Full-scale UAT demonstrated both Edge execution-time and memory ceilings.

Use deterministic phases:
1. Resolve/download source and capture evidence once.
2. Core Provider/Course reconciliation in bounded batches, maximum 5,000 source records per request with 250-record database sub-chunks.
3. Reconcile Locations.
4. Reconcile Course Locations in bounded ranges; use 2,500-record ranges when requests are concurrent.
5. Keep concurrency controlled rather than launching all ranges simultaneously.
6. Rebuild Search Projection only after canonical reconciliation completes.
7. Run full idempotency/integrity checks before accepting the job.

## Advisor Status
Supabase performance advisor returned informational unused-index notices only.

Security advisor still reports pre-existing platform warnings for several authenticated `public.ui_*` `SECURITY DEFINER` RPCs and leaked-password protection being disabled. These are broader platform-hardening items and were not introduced by the AU Layer 1 identity change.

## UAT Helper Closure
The temporary `layer1-au-full-gate` Edge Function used for autonomous full-volume UAT is now:
- `verify_jwt=true`;
- deliberately disabled;
- returns HTTP 410;
- not an operational ingestion endpoint.

Operational Layer 1 execution remains through the approved authenticated worker path.

## Gate
**AU Layer 1 Full CRICOS Ingestion — COMPLETE / PASS.**

Next work can proceed to the next Layer 1 country adapter and/or production automation of the accepted bounded orchestration pattern.
