# Milestone 2.4 Run Sheet

**Status:** ACTIVE  
**Milestone:** M2.4 — AI/Data Quality Optimisation, UX Consolidation, Full-Stack Regression & Pre-Blackout Checkpoint  
**Active Change Control:** CF-CHG-20260826-040

## 2026-08-26 12:23 AEST — Go 7 streamlined Data Operations navigation

**Intent:** Replace the fragmented ingestion/operations navigation with one logical operating model, move Layer 1 out of Settings/experimental presentation, and expose Guides/Runbooks in-product.

**Starting state:**
- M2.3 CLOSED/PASS on Pilot SHA `260ed6a0d19b80ad666d74b90aa13e735e802a6a`.
- M2.4 PLANNED/UNBLOCKED.
- Admin Navigation IA v1.3 already defines Layer 1–3 as first-class Data Operations.
- Deployed menu still patched Layer 2 into `Data Enrichment`, retained Layer 1 under Settings, and used floating launchers for M2.3/Scholarship Selection.

**Actions:**
- Opened CF-CHG-20260826-040.
- Reworked `src/data-acquisition-nav-entry.js` to the ordered groups Overview → Catalogue → Data Operations → Insights → Quality & Review → Decision Tools → Governance & Platform → Help & Guides.
- Data Operations now presents Layer 1 Regulatory, Layer 2 Enrichment, Layer 3 AI Interpretation, Layer 4 Human Resolution, Evidence & Provenance, Jobs & Runs and Onboarding according to existing role availability.
- Legacy Settings/Review Queue and equivalent floating launchers are removed from the primary journey.
- Layer 1 primary journey suppresses unrelated StatsCan PSIS qualification and destructive Pilot-reset panels while preserving the existing privileged backend authority.
- Scholarship Selection moved to Decision Tools.
- Added in-product Guides & Runbooks with role quick guides and direct workflow links.
- Advanced visible PIM Admin release to v2.15.6 and maintained release notes.
- Updated permanent navigation/release/Course Detail/Layer3-credential UAT to the new primary navigation contract.

**Current evidence:**
- Go 7 candidate SHA: `304da33d57f66059d33feb098455f749e438aac1`.
- Frontend build run `32923926233`: build job PASS; browser smoke still executing at this checkpoint.
- Deployed UAT run `32923926200`: desktop executing; mobile queued.

**Outcome:** PARTIAL — implementation committed and build PASS; deployed desktop/mobile acceptance remains.

**Follow-up:**
- resolve any deployed navigation/mobile regression without weakening tests;
- publish IA v1.4 and final Running Build only after desktop/mobile PASS;
- close CF-CHG-040 and reconcile Register/M2.4 current state.