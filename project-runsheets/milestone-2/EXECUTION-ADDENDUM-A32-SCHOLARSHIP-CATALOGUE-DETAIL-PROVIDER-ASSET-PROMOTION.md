# Execution Addendum A32 — Scholarship Catalogue→Detail Acquisition & Provider Asset Promotion

**Status:** ACTIVE / IMPLEMENTED IN PILOT  
**Date:** 3 September 2026  
**Change:** CF-CHG-20260903-083  
**Builds on:** A31

## Standing rule — catalogue is not scholarship identity
A page containing many Scholarships must never be extracted as one Scholarship.

Required path:
1. acquire first-party catalogue using normal Layer 2 routing;
2. retain private Evidence and content hash;
3. enumerate stable candidate/detail URLs;
4. record catalogue completeness metrics;
5. acquire each selected first-party detail URL separately;
6. extract detail facts against that Evidence;
7. identify Scholarship using stable source identifier/official detail URL, never title alone;
8. create only unpublished canonical identity/facts that are supported;
9. route ambiguous scope/applicability to Layer 4;
10. publish only through a later governed consumer/publication admission.

## Catalogue completeness
`pipeline.scholarship_catalogue_runs` is the operational completeness ledger.

Track at minimum:
- Provider;
- source/profile/version;
- Evidence/content hash;
- discovered count;
- unique candidate count;
- duplicates;
- run status;
- observation time.

A zero-result run is `needs_review` unless the source itself proves zero Scholarships. Do not infer completeness from successful HTTP acquisition alone.

## Detail identity
For first-party Scholarship detail pages, the stable official detail URL is the source-native identity when no stronger source-native identifier exists. Content hash is Evidence versioning, not Scholarship identity. Title matching alone is prohibited.

## Scope
Provider/Course/Study Level/Field/Campus/Country applicability stays separate from eligibility.

Do not expand broad Provider/study-level/field rules into Scholarship×Course Cartesian rows. Resolve broad include/exclude scopes dynamically after acceptance.

When scope semantics are ambiguous, create/retain the unpublished Scholarship root and park `scope_resolution` in the existing Layer 4 review queue with exact Evidence.

## Provider assets
Provider logo promotion requires:
- already-resolved canonical Provider;
- first-party candidate;
- approved/high-confidence candidate state;
- successful asset fetch;
- supported image mime;
- bounded size;
- SHA-256;
- private managed copy;
- one approved primary asset.

External logo hot-linking is not the canonical asset state. Failed source fetch is not grounds to weaken network/security controls.

## Acquisition economy
Preserve A31:
- reusable Evidence first;
- Direct HTTP first;
- Parse.bot disabled until qualified;
- Firecrawl rendered fallback;
- governed terminal fallback.

Catalogue enumeration/detail extraction must not cause repeat vendor acquisition when valid captured Evidence is already available.

## Consumer rule
Scholarships under Layer 4 scope review and Provider assets not admitted by a consumer contract remain internal/PIM-only.
