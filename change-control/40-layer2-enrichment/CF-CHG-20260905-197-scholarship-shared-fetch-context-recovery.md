# CF-CHG-20260905-197 — Scholarship Shared-Fetch Context Recovery

**Status:** IMPLEMENTED / RUNTIME PASS  
**Milestone:** M2.4.5  
**Layer:** Layer 2 — Evidence/cache reuse

## Problem

Scoped Scholarship catalogue jobs are provider/scope oriented and historically did not persist `profile_id` and `target_url` into the parent job payload. `public.scholarship_catalogue_shared_fetch_from_evidence()` therefore returned `incomplete_registration_context` after successful catalogue acquisition even though immutable Evidence contained the required source lineage.

## Correction

The helper now recovers missing registration context from the captured Evidence:

- profile from `evidence_artifacts.source_id → layer2_source_profiles`;
- source URL from `evidence_artifacts.source_url`;
- acquisition provider from Evidence metadata;
- content hash/mime type from the Evidence artifact.

It remains service-role/postgres only; `public`, `anon` and `authenticated` execute access is revoked.

## Runtime proof

The CF-196 UNSW, UQ and UWA catalogue Evidence records were retro-registered successfully into shared fetch:

- UNSW shared fetch `40dedc60-c7d7-4ab5-8804-73f091e40c21`
- UQ shared fetch `a2519a36-ca82-456a-bd84-098a0ab2b8e2`
- UWA shared fetch `69c66321-5bb7-4884-beb5-03e09fae67c1`

All registrations report `context_source=evidence_lineage`.

## Governance boundary

This change improves Evidence reuse only. It does not enumerate links, create canonical Scholarships, change Course mappings or authorise Publication.
