# Coursefinder Admin Guide v1.6

## Layer 1 — Australia / CRICOS

AU full-volume Layer 1 has passed its Mumbai phase gate under the approved v2.9.1 architecture.

Accepted canonical baseline:

| Measure | Count |
|---|---:|
| Providers | 1,546 |
| Courses | 26,648 |
| Campuses | 3,922 |
| Course↔Campus links | 47,671 |
| Search Documents | 26,648 |

The accepted regulatory source snapshot is the data.gov.au consolidated CRICOS resource `CRICOS Providers, Courses, and Locations`, last modified `2026-08-04T01:15:34.464772`.

## Identity Rule — Mandatory

Regulatory identity is identifier-first.

### Providers
Identity is determined by:

`country + registration scheme + regulator provider code`

The corresponding stable key is generated from the regulator code.

**Never merge Providers because their names match.** Different CRICOS provider codes remain different canonical Providers even where trading names are identical.

### Courses
Identity is determined by:

`provider + registration scheme + regulator course code`

The corresponding stable key is generated from provider code + course code.

**Never merge Courses because their titles match.**

The implementation is recorded in migration `041_layer1_identifier_identity_hardening.sql`.

## Security Boundary

`public.svc_layer1_apply_register_records` is service-only.

Validated EXECUTE grants:
- `postgres`;
- `service_role`.

Browser roles (`anon` and `authenticated`) do not execute this reconciliation RPC directly.

The normal UI/Edge path must continue to require:
1. Supabase JWT authentication.
2. Platform Admin server-side authorisation.
3. Server-held service-role execution for internal reconciliation/evidence writes.

## Full AU Execution Pattern

Do not run the complete CRICOS dataset in a single Edge request. Full-scale UAT demonstrated both Edge execution-time and memory ceilings.

Use this sequence.

### 1. Prepare source + evidence
- Resolve the current CRICOS consolidated ZIP from CKAN discovery.
- Record resource ID/name/last-modified metadata.
- Store the ZIP in private evidence storage.
- Store Institutions, Courses, Locations and Course Locations as separate evidence artifacts.
- Compute/store SHA-256 hashes.
- Create one Pipeline Job for the accepted snapshot.

The same evidence snapshot must be used by every batch in a single full run.

### 2. Providers + Courses
- Parse active CRICOS Courses.
- Reconcile deterministic ranges.
- Maximum tested Edge range: **5,000 source records**.
- Database reconciliation sub-chunk: **250 records**.
- Do not use provider name or course title for identity.

Expected final AU counts for the accepted 4 August 2026 snapshot:
- 1,546 Providers / Provider CRICOS registrations.
- 26,648 Courses / Course CRICOS registrations.

### 3. Locations
- Reconcile all eligible Locations after Provider/Course core is complete.
- Accepted result: 3,922 canonical Campuses from 3,927 eligible source rows.
- The difference represents repeated rows resolving to existing stable campus identities.
- Missing Provider and conflict counts must be zero.

### 4. Course Locations
- Reconcile Course Locations after Campuses exist.
- Accepted source population: 47,677 eligible/deduplicated records.
- Accepted canonical result: 47,671 Course↔Campus links.
- The difference is existing duplicate-equivalent relationships correctly recognised during ingestion.

For normal bounded execution:
- use deterministic ranges;
- 5,000-record slices passed during initial apply;
- for concurrent/repeat validation prefer **2,500-record slices**;
- keep concurrency low.

Do **not** start ten heavy Course Location reconciliation ranges simultaneously. This caused PostgreSQL statement timeouts during UAT despite the data being valid.

## Finalise Search

Only after canonical reconciliation completes:

1. run `svc_layer1_finalize_catalogue()`;
2. confirm Search Documents = canonical active Courses;
3. confirm zero empty search-text rows;
4. confirm Search Projection generation advances;
5. execute representative FTS checks.

Accepted AU performance evidence:
- full Search Projection rebuild: ~3.74 s;
- ranked `engineering` top-20 query: ~4.28 ms;
- query used `course_documents_tsv_idx`.

## Required Full-Run Gate

A full AU job is not accepted until all checks pass.

### Counts
- Providers = CRICOS Provider registrations.
- Courses = CRICOS Course registrations.
- Search Documents = Courses.
- Campus and Course↔Campus counts reconcile to the source snapshot.

### Idempotency
Re-run the same complete snapshot and require:
- Providers created = 0;
- Courses created = 0;
- Campuses created = 0;
- Course↔Campus links created = 0;
- conflicts = 0.

### Integrity
Require zero:
- duplicate provider registration keys;
- duplicate course registration keys;
- duplicate course-campus pairs;
- provider-registration orphans;
- course-registration orphans;
- campus-provider orphans;
- course-campus orphans;
- Providers without CRICOS registration;
- Courses without CRICOS registration.

### Evidence / lineage
- Pipeline Job references the accepted source snapshot.
- All five evidence artifacts exist privately.
- hashes and resource metadata are retained.
- completed job result contains final counts and gate result.

## Pilot Reset — Clean Execution Seed

The destructive Pilot reset returns catalogue/runtime data to the clean Layer 1 execution baseline while preserving:
- Auth/RBAC and Platform Admin access;
- reference/PIM configuration;
- Regulatory Sources/integration configuration;
- Layer 1 seed snapshots;
- database schema/functions/migrations;
- private evidence bucket definition.

The validated clean baseline is:
- Providers: 0;
- Courses: 0;
- Campuses: 0;
- Course↔Campus links: 0;
- Search Documents: 0;
- 5 Layer 1 seed snapshots preserved.

Reset is a Pilot/UAT control and must not become a general production user action.

## Temporary Full-Gate Helper

`layer1-au-full-gate` was used only to execute the autonomous full-volume phase gate. After sign-off it was deliberately disabled and returned to `verify_jwt=true`.

It now returns HTTP 410 and must not be used for routine ingestion.

Use the approved authenticated Layer 1 operational path and the bounded execution pattern above.

## Advisor Follow-Up

Layer 1 identity grants passed security validation. Supabase advisor findings outside the AU ingestion change remain separate hardening work:
- authenticated `public.ui_*` `SECURITY DEFINER` warnings;
- leaked-password protection disabled;
- informational RLS-with-no-policy notices on intentionally internal schemas;
- informational unused-index notices.

Do not remove indexes solely because the Pilot advisor reports them unused; re-evaluate after representative production workloads exist.

## AU Phase Status

**Layer 1 AU Full CRICOS Ingestion: COMPLETE / PASS.**

Pipeline evidence job: `97a1ef94-b6cf-4eaf-9b53-52bd370d47da`.
