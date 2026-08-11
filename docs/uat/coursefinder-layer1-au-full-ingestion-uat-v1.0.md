# Coursefinder — Layer 1 AU Full CRICOS Ingestion UAT v1.0

**Architecture:** v2.9.1  
**Runtime:** `coursefinder_Pilot` — Mumbai (`ap-south-1`)  
**Status:** **PASS**  
**Pipeline job:** `97a1ef94-b6cf-4eaf-9b53-52bd370d47da`

## 1. Scope

Validate full Australian Layer 1 CRICOS ingestion from a clean Mumbai runtime, including:
- Institutions;
- Courses;
- Locations;
- Course Locations;
- evidence and lineage;
- canonical identity;
- idempotency;
- integrity;
- performance;
- Search Projection.

Starting state was confirmed as:
- Providers 0;
- Courses 0;
- Campuses 0;
- Course↔Campus links 0;
- Search Documents 0;
- five Layer 1 seed snapshots preserved.

## 2. Source Snapshot

Live CKAN discovery returned:
- Resource: `CRICOS Providers, Courses, and Locations`.
- Resource ID: `fe0e12a5-e72e-401a-8a63-6a11e0e2a12c`.
- Last modified: `2026-08-04T01:15:34.464772`.

Evidence:

| Artifact | Evidence ID | SHA-256 |
|---|---|---|
| Consolidated ZIP | `5a929973-129f-46f1-9fb7-0d1714cbe4f8` | `aeb635f3204a1c414e1ac5f972f522e72a9fa807b79678d426a9f40d6e96fb3c` |
| Institutions CSV | `21771b5a-30ca-4df9-b820-bfb98253440a` | `abe86484f715b8c7d24d2e5a2c6bcf02f14ad57697e473768d1f2b415419058a` |
| Courses CSV | `8628928e-40e8-40b6-9682-f0ad6232caf4` | `fc2f2ef81c0b3c63dd47e1b01c7e5cf22f708c892e70f71707dbb421baed6945` |
| Locations CSV | `6117dc63-9f0f-43e1-ad5e-d287e9b55441` | `66e9e307c11aa8fca7fe7efd4cc39cb87bb057993aa134a039eba895822a5019` |
| Course Locations CSV | `9f05c3b6-c575-4516-8c1c-fa2111bba379` | `0917855d85f58c1fdc9bd88c502f90954e02ce2993b53321c430291669ca3dc2` |

All evidence was stored in the private evidence boundary.

## 3. Defect Found During Full-Scale UAT

The first full-volume pass exposed an identity defect in `svc_layer1_apply_register_records`.

Previous behaviour could resolve:
- unseen Providers by normalised Provider name;
- Courses by normalised Course title.

This caused distinct regulatory entities sharing a name/title to collapse into the same canonical entity. Examples included same-named institutions with different CRICOS Provider codes.

This violated v2.9.1 principle: **names never act as identity**.

### Correction

Provider identity now resolves by:

`country + registration_scheme + regulator_provider_code`

Course identity now resolves by:

`provider + registration_scheme + regulator_course_code`

Stable keys are generated from those regulatory identifiers. Provider names and Course titles are descriptive only.

Git migration: `041_layer1_identifier_identity_hardening.sql`.

Privilege check after correction:
- `postgres`: EXECUTE;
- `service_role`: EXECUTE;
- browser roles: no direct EXECUTE.

## 4. Full Apply Results

### Core

| Measure | Result |
|---|---:|
| CRICOS course source records | 26,648 |
| Providers created | 1,546 |
| Provider CRICOS registrations | 1,546 |
| Courses created | 26,648 |
| Course CRICOS registrations | 26,648 |
| Provider name-based links | 0 |
| Course title-based links | 0 |
| Conflicts | 0 |

### Locations

| Measure | Result |
|---|---:|
| Eligible Location records | 3,927 |
| Canonical Campuses | 3,922 |
| Provider missing | 0 |
| Conflicts | 0 |

Five repeated Location rows resolved to existing stable campus identities.

### Course Locations

| Measure | Result |
|---|---:|
| Eligible/deduplicated source records | 47,677 |
| Canonical Course↔Campus links | 47,671 |
| Missing Provider | 0 |
| Missing Course | 0 |
| Missing Campus | 0 |
| Conflicts | 0 |

Six source relationships were already recognised as existing equivalent canonical links.

## 5. Idempotency UAT

The same complete snapshot was rerun.

Required and observed result:

| Check | Expected | Actual |
|---|---:|---:|
| New Providers | 0 | 0 |
| New Courses | 0 | 0 |
| New Campuses | 0 | 0 |
| New Course↔Campus links | 0 | 0 |
| Conflicts | 0 | 0 |

Core rerun recognised all 26,648 Course records as existing.

Locations rerun recognised all 3,927 eligible Location rows as existing canonical Campus identities.

Course Location rerun recognised all 47,677 source relationships as existing.

### Concurrency finding

Ten concurrent 5,000-record Course Location idempotency ranges caused PostgreSQL statement timeouts on the first three ranges. Seven other ranges completed with zero creates.

The timed-out first 15,000 records were then rerun in deterministic 2,500-record slices. Every slice passed with:
- 0 links created;
- all records recognised as existing;
- 0 missing entities;
- 0 conflicts.

Conclusion: idempotency **PASS**; high concurrency is an operational throughput constraint.

## 6. Integrity UAT

Final counts:

| Entity | Count |
|---|---:|
| Providers | 1,546 |
| Provider CRICOS registrations | 1,546 |
| Courses | 26,648 |
| Course CRICOS registrations | 26,648 |
| Campuses | 3,922 |
| Course↔Campus links | 47,671 |

All integrity checks returned **0**:
- duplicate Provider registration keys;
- duplicate Course registration keys;
- duplicate Course↔Campus pairs;
- Provider registration orphans;
- Course registration orphans;
- Campus→Provider orphans;
- Course↔Campus orphans;
- Providers without CRICOS registration;
- Courses without CRICOS registration.

Five Layer 1 seed snapshots remained preserved.

## 7. Search UAT

Search Projection was rebuilt after canonical ingestion.

| Measure | Result |
|---|---:|
| Search Documents | 26,648 |
| Distinct Courses | 26,648 |
| Distinct Providers | 1,546 |
| Empty search text | 0 |
| Courses with mapped study level | 24,367 |
| Search generation | 2 |
| Rebuild execution | ~3.74 seconds |

Representative FTS checks:
- `bachelor business`: 681 matches;
- `nursing`: 274 matches;
- `engineering`: 1,223 matches.

Ranked top-20 `engineering` query:
- execution ~4.28 ms;
- used `course_documents_tsv_idx` via Bitmap Index Scan.

Search UAT: **PASS**.

## 8. Runtime / Performance Findings

### Monolithic request
A full four-file ingestion in one Edge invocation exceeded the Supabase Edge execution ceiling at approximately 152 seconds and returned HTTP 546 after durable partial writes.

### Evidence memory
An early evidence-only helper unnecessarily materialised all four parsed datasets and hit an Edge resource limit. Splitting parsing by phase resolved the issue.

### Accepted batching model
- Capture source/evidence once.
- Core Provider/Course Edge batches: up to 5,000 source records.
- Database reconciliation sub-chunk: 250.
- Locations: bounded pass.
- Course Locations: deterministic bounded ranges.
- Prefer 2,500 Course Location records when requests are concurrent.
- Keep concurrency controlled.
- Search rebuild only after canonical ingestion completes.

Performance gate: **PASS with bounded execution model**.

## 9. Advisor Review

### Security
The Layer 1 reconciliation function itself passed the intended service-role privilege boundary.

Supabase advisor also reports pre-existing broader platform warnings:
- authenticated access to several `public.ui_*` `SECURITY DEFINER` functions;
- leaked-password protection disabled;
- informational RLS-enabled/no-policy notices on internal schemas.

These were not introduced by the AU Layer 1 identity change and do not invalidate the AU data gate. They remain separate platform-hardening work.

### Performance
Performance advisor reported informational unused-index notices only. No index was removed during this phase because Pilot usage statistics are not yet representative of production workload.

## 10. Closure

Pipeline job `97a1ef94-b6cf-4eaf-9b53-52bd370d47da` was closed as `completed` with `phase_gate=PASS` and the final reconciliation/search metrics recorded in its result.

The temporary `layer1-au-full-gate` UAT Edge Function was then:
- set back to `verify_jwt=true`;
- disabled;
- changed to return HTTP 410;
- removed from operational use.

## Phase Gate Result

# PASS — Layer 1 Full AU CRICOS Ingestion

The Mumbai AU catalogue is accepted as the current canonical Layer 1 AU baseline under architecture v2.9.1.
