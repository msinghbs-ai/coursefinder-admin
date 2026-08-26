# Milestone 2.4 Run Sheet

**Status:** ACTIVE — M2.4.0 CLEANUP GATE  
**Milestone:** M2.4 — AI/Data Quality Optimisation, UX Consolidation, Full-Stack Regression & Pre-Blackout Checkpoint  
**Active Change Controls:** CF-CHG-20260826-040, CF-CHG-20260826-042

## 2026-08-26 12:23 AEST — Go 7 streamlined Data Operations navigation

**Intent:** Replace fragmented ingestion/operations navigation with one logical operating model, move Layer 1 out of Settings/experimental presentation, and expose Guides/Runbooks in-product.

**Implemented working model:** Overview → Catalogue → Data Operations → Insights → Quality & Review → Decision Tools → Governance & Platform → Help & Guides; Layers 1–4/Evidence/Jobs/Onboarding under Data Operations; Scholarship Selection under Decision Tools; Guides visible; v2.15.6 release notes maintained.

## Go 7 full-matrix outcome / liability discovered

Full deployed UAT on Pilot `eabb7d99f93acf6260c06b33c852ed4b0bb6fd8a` did **not** pass. Navigation-specific Go 7 tests passed, but inherited Layer 2 and M2.3 intelligence suites still searched for removed `Layer 2 Operations` and floating `M2.3 Intelligence` launchers. Deterministic missing selectors then consumed ~45–50 second waits/retries across many tests, producing a long disruptive matrix rather than fast development feedback.

This is classified as an integration/test architecture liability. The correction is **not** to restore floating launchers or legacy labels.

The user stopped the work because the feedback loop took too long. Additional test/audit commits now exist on Pilot through `c63442ea9ae44382b88f17fd0e01974cf5c6b469`; these remain unaccepted working state until explicitly reconciled.

## 2026-08-26 18:00 AEST — execution-governance replan

Actions:

- created permanent `EXECUTION-ADDENDA-A1-A6.md`;
- A1 establishes targeted → integration → one nominated full acceptance matrix;
- A2 prohibits accepted operational architecture/UAT from depending on floating launchers;
- A3 requires shared navigation/test adapters;
- A4 controls CI/full-matrix triggering;
- A5 separates UX/performance screenshot auditing from functional acceptance;
- A6 separates permanent addenda from Go execution identifiers;
- inserted mandatory **M2.4.0 — Integration Cleanup, Test-Liability Removal & Acceptance Rebase** before M2.4.1;
- retained original M2.4.1 Layer 1 and M2.4.2 Layer 2 plans unchanged in purpose;
- created prompt pack for M2.4.0 through M2.4.4;
- updated PROJECT_INSTRUCTIONS and M2 Standing Instructions to inherit A1–A6;
- updated CURRENT-STATE, FOLLOW-UPS and NEXT-CHAT to make cleanup the only authorised next gate.

## Next dependency

Run M2.4.0 only. Reconcile the post-Go7 Pilot working state, remove stale/floating test dependencies, establish shared primary-navigation adapters, run targeted desktop/mobile and bounded integration, then run one full deployed matrix on one nominated SHA. Only after that PASS does M2.4.1 start.
