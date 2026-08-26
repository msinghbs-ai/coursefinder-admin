# M2.4 Current State

**Status:** ACTIVE — GO 7 STREAMLINED DATA OPERATIONS UI UNDER DEPLOYED UAT  
**Updated:** 26 August 2026 12:50 AEST  
**Active Change Control:** CF-CHG-20260826-040

## Accepted baseline

- M1 CLOSED/PASS/FROZEN.
- M2.1 CLOSED/PASS.
- M2.2 CLOSED/PASS.
- M2.3 CLOSED/PASS with NZ first-party Layer 2 expansion deferred.
- Pre-Go7 accepted Pilot: `260ed6a0d19b80ad666d74b90aa13e735e802a6a`.

## Go 7 candidate

Pilot SHA `304da33d57f66059d33feb098455f749e438aac1`.

Visible release: PIM Admin `v2.15.6`.

Implemented primary IA:

1. Overview;
2. Catalogue;
3. Data Operations;
4. Insights;
5. Quality & Review;
6. Decision Tools;
7. Governance & Platform;
8. Help & Guides.

Data Operations unifies Layer 1 Regulatory, Layer 2 Enrichment, Layer 3 AI Interpretation, Layer 4 Human Resolution, Evidence & Provenance, Jobs & Runs and Onboarding according to existing role/rank availability. Scholarship Selection is under Decision Tools. Sources/Attributes/Users & Roles remain Governance & Platform. Guides & Runbooks is visible in-product.

Layer 1 no longer presents the normal operator journey as Settings. The normal Layer 1 view suppresses the separate StatsCan PSIS Layer 2A parser qualification and destructive Pilot reset controls. No underlying privilege or source-authority contract changed.

## Role visibility

Existing security remains authoritative. A lower-rank UAT identity will not see Platform-Admin-only Layer 1 or Users & Roles, and may not see operator-only Jobs & Runs. The Go 7 UAT therefore proves the correct lower-rank menu rather than lowering privileges to make all items visible. Platform Admin retains the additional governed entries.

## Documentation

- CF-CHG-20260826-040 open/in progress.
- Admin Navigation IA v1.4 published.
- Data Operations Admin Guide v1.1 published with the v2.15.6 navigation model.
- v2.15.6 release notes maintained in-product.

## CI/UAT

Frontend Build run `32923926233`:
- build PASS;
- browser smoke PASS.

Deployed UAT run `32923926200`:
- desktop executing;
- mobile queued at this state write.

Do not call Go 7 accepted until both deployed projects pass.

## Next gate

1. obtain deployed desktop/mobile outcome;
2. fix any real product/navigation regression without weakening acceptance;
3. when both pass, close CF-CHG-040, update Change Control REGISTER and publish Running Build v2.74;
4. transition M2.4 programme state to ACTIVE in the next versioned Master Project Plan if no newer parallel plan supersedes it;
5. update RUNSHEET/CURRENT-STATE/NEXT-CHAT to accepted truth.