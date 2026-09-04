# CF-CHG-20260904-126 — Layer 2 navigation restoration and AU Scholarship fill

**Status:** IMPLEMENTED / TARGETED PASS

## Objective
Restore an unambiguous operator path to **Layer 2 — Enrichment** from the current Administration experience and continue the M2.4.5 Scholarship data-fill wave through governed first-party acquisition.

## UI correction
The canonical sidebar still defines `Data Operations → Layer 2 — Enrichment`, but the current Administration view can obscure the operational entry point. A small runtime-safe navigation reconciler now:
- ensures the Data Operations group contains `Layer 2 — Enrichment`;
- adds a direct `Layer 2 — Enrichment` shortcut to the Administration section strip;
- routes to the existing `#layer-2-enrichment` workspace rather than creating a second control plane;
- does not alter Layer authority, role gates, acquisition policy, publication or Search admission.

Pilot source commits:
- `0fcdc15c7b533861d2ab2036fbc89af0ccb0dc84` — navigation reconciler;
- `8d5979518f3f3b571dedf6fa8b657ffc205ebebc` — load reconciler from the current app shell.

## AU Scholarship fill run
The country-scope Scholarship acquisition preview reported:
- canonical AU Providers: **1,546**;
- executable first-party Scholarship profiles: **11**;
- qualification/catalogue-route gap: **1,535**.

A governed AU country-scope Start dispatched exactly the 11 executable profiles. All 11 completed successfully and retained Evidence. No canonical Scholarship or publication mutation was authorised by the acquisition run.

Successful Providers:
- Australian Catholic University;
- Australian National University;
- Charles Darwin University;
- Charles Sturt University;
- Curtin University;
- Deakin University;
- Edith Cowan University;
- Federation University Australia;
- Monash University;
- RMIT University;
- The University of Melbourne.

Routes used included Direct HTTP, Firecrawl fallback, and shared-fetch reuse.

## Catalogue enumeration
The newly acquired first-party catalogue Evidence was normalised and enumerated where applicable. Fresh catalogue results included:
- ANU: 22 candidates;
- CDU: 5;
- Charles Sturt: 14;
- Curtin: 14;
- Deakin: 6;
- ECU: 12;
- Melbourne: 20;
- Monash: 339;
- ACU: 0 from the current catalogue page and retained as `needs_review` rather than manufacturing candidates.

Federation and RMIT already used shared-fetch fan-out in the same wave and produced fresh discovery candidates.

## Governance boundary
This fill is **discovery/acquisition only**. Candidate discovery does not equal canonical acceptance. Detail acquisition, extraction, duplicate reconciliation, Layer 4 scope resolution and publication remain governed downstream gates. First-party university pages remain authority; landscape discovery remains private completeness context only.
