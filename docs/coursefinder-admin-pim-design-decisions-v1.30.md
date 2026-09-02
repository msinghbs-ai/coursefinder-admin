# CourseFinder Admin/PIM Design Decisions v1.30

**Status:** CURRENT M2 DESIGN DECISIONS  
**Date:** 3 September 2026  
**Supersedes:** v1.29  
**Change Controls:** CF-CHG-20260902-063, CF-CHG-20260902-064, CF-CHG-20260902-080, CF-CHG-20260902-081, CF-CHG-20260903-083

## Decisions 38–68
Decisions 38–68 from v1.29 remain authoritative and unchanged.

## Decision 69 — Catalogue and detail are different Scholarship grains
A Provider catalogue/search page is not a Scholarship. Admin operations must show catalogue discovery/completeness separately from individual Scholarship detail candidates.

## Decision 70 — Provider Scholarship completeness is measurable
The Scholarship workspace should expose per-Provider counts such as catalogue discovered, unique candidates, acquired details, canonical current records, pending scope review, rejected and failed. Zero discovered from a successfully fetched source must not automatically display “complete”.

## Decision 71 — Stable first-party detail URL can anchor identity
When the Provider exposes no stronger source-native identifier, the official detail URL is the accepted source identifier. Title matching cannot establish identity.

## Decision 72 — Scope review precedes course applicability
The PIM may show an unpublished Scholarship root while applicability is pending. Course/Provider views must not show it as applicable until scope resolution is accepted.

## Decision 73 — Layer 4 owns ambiguous Scholarship scope
Scholarship `scope_resolution` uses the existing Layer 4 review workspace, Evidence context and terminal decision model. Do not create a parallel Scholarship-only human-review queue.

## Decision 74 — Provider logo promotion is governed
Logo discovery and logo promotion are separate actions. Promotion requires a first-party candidate, managed asset copy and hash. Failed CDN download remains a review state and does not justify bypassing controls.

## Decision 75 — Consumer presentation derives from governed state
Provider cards may eventually show approved logos and Scholarship aggregates, but only from approved/published consumer projections. Internal candidate/review counts remain Admin/PIM information.
