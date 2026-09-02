# CF-CHG-20260902-071 — Layer 1 Operations Admin naming alignment

- **Initiated:** 2026-09-02T13:08:00+10:00
- **Origin:** CourseFinder — “can you fix up the Layer 1 admin UI as Layer 1 operations?”
- **Category:** 30-admin-pim-ux
- **Change class:** Browser-facing navigation / operational UX correction
- **Status:** APPLIED / TARGETED UAT ACTIVE

## Problem / requested outcome

The canonical Data Operations navigation still displayed **Layer 1 — Authority** even though the page is an operational control surface for regulatory, statistical and ranking ingestion. This created an information-architecture mismatch with Layer 2/3/4 and with the already accepted Layer 1 Operations model.

## Correction

Visible browser naming is standardised to:

- sidebar: **Layer 1 — Operations**;
- top-level page title: **Layer 1 — Operations**;
- embedded Layer 1 workspace header: **Layer 1 Operations**;
- description: country-first regulatory, statistical and ranking ingestion operations with governed source health, runs, Evidence, schedule and reconciliation.

Compatibility is preserved:
- `#layer-1-operations` is the canonical new route;
- historical `#layer-1-regulatory` and `#layer-1-authority` hashes resolve to the same Operations workspace.

## Semantic impact

Presentation / navigation only. No change to:
- Layer 1 source authority or identity semantics;
- source registry, ingestion parser, ranking/QILT/PRISMS adapters;
- execution roles or run authority;
- Evidence/provenance;
- Search, Publication, website or Zoho admission.

## Implementation

Coursefinder-Pilot:
- `src/mature-main.jsx` — navigation, page metadata, aliases and route render naming; UI version v2.15.29.
- `src/layer1-operations-entry.jsx` — workspace header/title and legacy-route compatibility.
- `src/pim-version-entry.js` — v2.15.29 operator release notes.
- `index.html` — browser title v2.15.29.

Implementation commits:
- `f22415d229838411067678352030dbf20e89d1fd`
- `46fbde662340a39ac609c224ead81fd4d31c4517`
- `cc3aba52cc3c693e45716c9798c844864a701afc`
- `c6e11bfb8b39f97cd4ba96a599482a830387e036`

## UAT

Targeted source/build/deployed validation to confirm:
1. Platform Admin sidebar shows **Layer 1 — Operations** under Data Operations.
2. Selecting it resolves `#layer-1-operations`.
3. page and embedded workspace headings use Operations naming.
4. historical Layer 1 hashes still resolve.
5. Layer 1 country/dataset/status controls and dataset cards still render.
6. no new browser console/HTTP 5xx errors.
7. release pill reports v2.15.29.

An intermediate deployed-UAT run on commit `46fbde...` was cancelled during cache restore due to parallel workflow concurrency and is not treated as a functional failure.

## Rollback

Revert the four UI/release commits above. No database rollback is required.

## Status

**APPLIED / TARGETED UAT ACTIVE**.
