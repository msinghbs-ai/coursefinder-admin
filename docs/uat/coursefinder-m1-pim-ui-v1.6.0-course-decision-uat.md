# CourseFinder M1-PIM — UI v1.6.0 Course Decision UAT

**Date:** 19 August 2026  
**Scope:** Course decision-grid quality filters and Campus/Location cross-links  
**Status:** TECHNICAL PASS / LIVE BROWSER UAT PENDING

## Implemented

- UI version advanced to **v1.6.0**.
- Course catalogue adds canonical decision filters for:
  - Country;
  - State / Region;
  - Provider;
  - Study Level;
  - Field;
  - Delivery;
  - Has/Missing Fee;
  - Has/Missing Intake;
  - Has/Missing English requirement;
  - Has/Missing course-scoped Scholarship;
  - minimum Completeness;
  - Freshness / verification;
  - Lifecycle;
  - Publication.
- Course rows expose Campus count as a cross-click.
- Course drawer supports Summary / Campuses / Fees / Intakes / English tabs.
- Related Campus view preserves canonical Country/Subdivision/City/Delivery information and does not infer missing geography.

## Backend UAT

Authenticated read contract: PASS.

Observed checks:
- CA / Ontario Course filter: **3,286 Courses**.
- Ontario Provider option scope: **24 Providers**.
- Related Campus RPC returned a valid populated relation for sampled Course `ACT Year 12 Certificate`: **1 Campus**.
- Anonymous/PUBLIC execute remains revoked; authenticated/service role execute granted.

## Current data-quality signal

At the time of UAT, canonical structured Course enrichment contains:
- Course Fees: **0 Courses with structured fee rows**;
- Intakes: **0 Courses with structured intake rows**;
- English requirements: **0 Courses with structured English requirement rows**;
- Course-scoped Scholarship scopes: **0 Courses with included course scope**;
- Courses >= 75% current completeness projection: **0**;
- all current canonical Courses had a `last_verified_at` value in the sampled verification test.

This is not treated as a UI defect. UI v1.6.0 deliberately makes these missing-data conditions filterable so enrichment automation can use them as exception/work queues.

## Geography caveat

AU Provider/Campus authoritative subdivision mapping remains unpopulated. The UI must continue to show the State/Region coverage gap rather than derive AU state from free-text city/address data.

## Gate

- Backend read contracts: PASS
- Filter semantics: PASS
- Related Campus cross-link: PASS
- Security ACL: PASS
- Canonical identity model unchanged: PASS
- Live Cloudflare browser rendering: PENDING user UAT
