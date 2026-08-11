# Coursefinder Running Build v2.0

## Current Phase
Phase 3 — Layer 1 Regulatory ETL.

**Australia / CRICOS full-ingestion gate: COMPLETE / PASS.**

## Execution Runtime
- Cloudflare serves the Pilot SPA only.
- Supabase Edge Functions provide authenticated Layer 1 execution and controlled Pilot reset.
- PostgreSQL holds the canonical catalogue, regulatory registrations, Pipeline Jobs and Search Projection.
- Supabase Storage retains private evidence.
- Runtime region: Mumbai (`ap-south-1`).
- Architecture baseline: v2.9.1.

## Accepted AU Source Snapshot
Live data.gov.au CKAN discovery resolved:
- Resource: `CRICOS Providers, Courses, and Locations`.
- Last modified: `2026-08-04T01:15:34.464772`.
- Pipeline job: `97a1ef94-b6cf-4eaf-9b53-52bd370d47da`.

Evidence retained with SHA-256 hashes:
- consolidated CRICOS ZIP;
- Institutions CSV;
- Courses CSV;
- Locations CSV;
- Course Locations CSV.

## Accepted AU Catalogue
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

## Identity Hardening
Full-volume UAT found that the prior reconciliation contract could merge unseen regulatory entities by normalised provider name or course title. That violated v2.9.1 because names must never act as identity.

The accepted rule is now identifier-first:
- Provider identity = country + registration scheme + regulator provider code, backed by stable key.
- Course identity = provider + registration scheme + regulator course code, backed by stable key.
- Provider names and Course titles remain descriptive only.

Git migration: `041_layer1_identifier_identity_hardening.sql`.

Runtime privilege validation confirms `svc_layer1_apply_register_records` is executable only by `postgres` and `service_role`.

## Full Idempotency — PASS
Complete rerun outcome:
- Providers created: 0.
- Courses created: 0.
- Campuses created: 0.
- Course↔Campus links created: 0.
- Conflicts: 0.

Duplicate registration/relationship checks: 0.

A ten-way concurrent Course Location rerun caused statement timeouts on the first three 5,000-record ranges. Those exact ranges passed in bounded 2,500-record slices with zero creates and all records resolving to existing relationships. This is an operational concurrency limit, not an idempotency failure.

## Integrity — PASS
All returned zero:
- provider-registration orphans;
- course-registration orphans;
- campus-provider orphans;
- course-campus orphans;
- duplicate CRICOS Provider keys;
- duplicate CRICOS Course keys;
- duplicate Course↔Campus pairs;
- Providers without CRICOS registration;
- Courses without CRICOS registration.

## Search — PASS
- Search Documents: 26,648 / 26,648 Courses.
- Distinct Providers represented: 1,546.
- Empty `search_text`: 0.
- Courses with mapped study level: 24,367.
- Search generation: 2.
- Search Projection rebuild: ~3.74 seconds.
- `engineering` ranked top-20 FTS query: ~4.28 ms using `course_documents_tsv_idx`.
- FTS matches: `bachelor business` 681; `nursing` 274; `engineering` 1,223.

## Full-Volume Operating Pattern
A full AU run MUST NOT be executed as one monolithic Edge request. Full-scale UAT demonstrated Edge execution-time and memory ceilings.

Accepted pattern:
1. Resolve/download source and capture evidence once.
2. Reconcile Provider/Course records in deterministic batches up to 5,000 records, with 250-record database sub-chunks.
3. Reconcile Locations.
4. Reconcile Course Locations in deterministic bounded ranges; use 2,500 records where concurrent execution is used.
5. Keep concurrency controlled. Do not launch ten heavy reconciliation requests simultaneously.
6. Finalise Search Projection after canonical ingestion completes.
7. Run idempotency + integrity gate before accepting the Pipeline Job.

## Security and Advisor Status
The Layer 1 identity RPC itself is service-role-only and passed privilege validation.

Supabase security advisor continues to report broader pre-existing warnings for authenticated `public.ui_*` `SECURITY DEFINER` functions and leaked-password protection being disabled. These are tracked platform-hardening concerns, not regressions caused by AU Layer 1.

Performance advisor returned informational unused-index notices only.

## UAT Helper Closure
The temporary `layer1-au-full-gate` function used for the autonomous phase gate is now JWT-protected and deliberately disabled with HTTP 410. It is not an operational ingestion endpoint.

## Phase Gate
**AU Layer 1 Full CRICOS Ingestion = PASS.**

The accepted Mumbai AU catalogue can now be treated as the Layer 1 AU baseline. Next work can proceed to the next country adapter and/or automation of the bounded full-run orchestration pattern.
