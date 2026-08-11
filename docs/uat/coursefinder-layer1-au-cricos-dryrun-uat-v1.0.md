# Coursefinder — Layer 1 AU CRICOS Dry-Run UAT v1.0

**Environment:** coursefinder_Pilot — Mumbai (ap-south-1)  
**Date:** 2026-08-11  
**Worker:** layer1-v0.1.2  
**Mode:** Dry-run  
**Scope:** Australia / CRICOS / first 100 selected course records

## Result

**PASS — first successful Layer 1 regulatory dry-run.**

Verified from `pipeline.jobs`:

- Job ID: `39f345a3-0d4f-4f9f-899c-c39b3c518b16`
- Status: `completed`
- Source system: `au_cricos`
- Country: `AU`
- Apply mode: `false`
- Max records: `100`
- Parsed CRICOS course records: **26,738**
- Selected records: **100**
- Reconciliation records evaluated: **100**
- Conflicts: **0**
- Provider created: **0**
- Provider linked: **0**
- Course created: **0**
- Course linked: **0**
- Current provider CRICOS registrations after dry-run: **0**
- Current course CRICOS registrations after dry-run: **0**

## Evidence

Two authoritative CRICOS CSV resources were captured into the private Supabase `evidence` bucket:

1. `CRICOS Institutions.csv`
   - Evidence ID: `2e9a9f67-15b2-4bda-8db2-ae1cb59bbfd8`
   - SHA-256: `abe86484f715b8c7d24d2e5a2c6bcf02f14ad57697e473768d1f2b415419058a`

2. `CRICOS Courses.csv`
   - Evidence ID: `4414e5f1-4a10-4630-b595-68bba608b510`
   - SHA-256: `fc2f2ef81c0b3c63dd47e1b01c7e5cf22f708c892e70f71707dbb421baed6945`

Latest regulator resource timestamp reported by the dataset: `2026-08-04T08:04:20.717556`.

## Observed Pipeline Behaviour

The dry-run successfully exercised:

`Regulatory Settings → source resolver → Worker → CRICOS discovery → Institutions/Courses CSV acquisition → private evidence storage → SHA-256 hashing → parse → 100-record selection → job completion → source-health telemetry`

No catalogue mutation occurred, as designed for dry-run mode.

## Previous Failure and Remediation

The first attempt failed because the private `evidence` bucket did not allow MIME type `text/csv`.

Migration 033 added `text/csv` to the existing bucket MIME allow-list without changing privacy or other allowed types. The rerun then completed successfully.

## Next UAT Gate

Proceed with a **controlled 100-record apply**, then run the same 100 records a second time to validate idempotency and absence of duplicate provider/course/registration creation.

Before full AU ingestion, review reconciliation outcomes and add CRICOS Locations / Course Locations for campus relationships.
