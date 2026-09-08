# M2.4.5 NEXT CHAT

## Accepted active baseline — 8 September 2026

- Pilot visible release remains **v2.15.74**.
- Accepted Pilot `main` head is **`4a927057e86935f8c5e101e434355da0b8f9bf7d`** after PR #48 / CF-241 closure.
- CF-242 UI package and CF-243 Compare UI correction remain CLOSED / PASS.
- Four-phase architectural hardening is complete for the accepted scope under CF-CHG-20260908-244.
- CF-241 forward runtime reconciliation is **CLOSED / PASS**.
- H11 Provider logo completeness/source discovery is already **CLOSED / PASS** under CF-101/CF-102 with **49/49 approved primary AU/NZ university logos**.
- Post-merge Pilot Frontend Build `34224432855` PASS.
- Post-merge CourseFinder Deployed UAT `34224432694` PASS.
- Production untouched; M2.5 remains paused until M2.4.5 closes.

Recommended chat name:

`CF M2.4.5 — CF-241 Closed, H12 ARWU & Diversity Completion — 2026-09-08`

Continue CourseFinder M2.4.5 from repository/runtime truth. Do not use superseded v2.15.72 recovery history, CF-239 as a unit, or stale chat memory as the active baseline.

## Mandatory start

1. Read `PROJECT_INSTRUCTIONS.md` and `docs/README.md`.
2. Read the PIM operating principles and troubleshooting/bugfix/recovery protocol.
3. Read Milestone 2 Standing Instructions and applicable execution addenda.
4. Read `change-control/README.md`, `change-control/REGISTER.md`, CF-240, CF-242, CF-243, CF-CHG-20260908-244 and CF-091/CF-101/CF-102.
5. Read current M2.4.5 `RUNSHEET.md`, `CURRENT-STATE.md`, `FOLLOW-UPS.md`, `WORK-ITEM-LEDGER.md`, `MEETING-READINESS.md`, `CF-241-CLOSURE-STATE-2026-09-08.md` and this file.
6. Reconcile the current Pilot `main` head, deployed Worker currentness, Pilot Supabase migrations/runtime and latest CI/UAT evidence before changing shared foundations.

## What is now closed

### Architectural hardening / CF-241

- TypeScript migratory mode, ESLint and Vitest guardrails are active.
- Typed API/PIM/domain boundaries and logical `src/data`, `src/domain`, `src/components/pim` separation are established.
- Governed Course PIM dynamic rendering is deployed without duplicating hardcoded core fields.
- Dedicated Course PIM deployed UAT verifies the exact deployed Git revision before testing.
- `evidence_page` is back on governed `security.admin_evidence_page(...)`.
- `layer2_ops_overview` is back on governed `security.admin_layer2_ops_read(...)`.
- Missing Evidence lineage/entity-link replay dependencies are represented in migration history.
- Course PIM and consumer API boundaries remain intact.

### H11 Provider assets

- Governed AU/NZ university cohort: **41 AU + 8 NZ**.
- Approved primary logo coverage: **49/49**.
- Provider detail, Course detail and comparison surfaces use approved primary logos through authenticated private-asset access.
- Hotcourses/IDP remain discovery/reconciliation/fallback provenance only; their own branding/placeholders are not canonical Provider assets.
- CF-101 and CF-102 are CLOSED / PASS. Do not reacquire or re-promote this cohort unless a new defect/freshness requirement is opened.

## Next governed action — H12

The next genuinely open feature gate is **H12 ARWU & University Diversity Statistics**:

1. Reconcile current ranking schema/import/read/UI truth first; do not assume the 3 September design backlog is unimplemented.
2. Complete ARWU as a first-class editioned ranking system with bounded AU/NZ real-data proof and retained multi-year semantics.
3. Complete the separate University Diversity/HDI contextual dataset only under explicit source/reuse authority; do not flatten it into QS/THE/ARWU semantics.
4. Preserve Provider crosswalk/equivalence, edition/year, Evidence, source/version and manual Apply gates.
5. Verify Statistics & Rankings plus Provider/Compare presentation using targeted → bounded UAT.
6. Keep Website/Zoho/Search admission separate; no automatic consumer exposure.

After H12, continue H13 bounded ranking backfill/acquisition work and the remaining continuous/open M2.4.5 gates in `FOLLOW-UPS.md` unless a newer governed priority supersedes them.

## Standing guardrails

- inspect repository/runtime truth before implementation;
- preserve security, Evidence, source authority, publication and consumer boundaries;
- do not repeat CLOSED/PASS H11 work without a new defect/change record;
- do not promote commercial-aggregator values as canonical without explicit source/reuse authority;
- do not weaken tests to make them pass;
- keep visible release currentness synchronized only for browser-visible accepted changes;
- Production remains a separate explicit-authorisation trust boundary.

## Pickup text

> Continue CourseFinder M2.4.5 from repository/runtime truth. Accepted Pilot main is `4a927057e86935f8c5e101e434355da0b8f9bf7d`; CF-241 and the four-phase architectural hardening are CLOSED/PASS under CF-CHG-20260908-244. H11 is also CLOSED/PASS under CF-101/CF-102 with 49/49 AU/NZ university primary logos. Post-merge build `34224432855` and deployed UAT `34224432694` are PASS. Production is untouched and M2.5 remains paused. Start the next genuinely open gate, H12 ARWU & University Diversity Statistics, by reconciling current implementation/runtime truth before adding anything.

## Before ending the continuation

- update owning Change Controls and M2.4.5 continuity records;
- record exact source/runtime/migration/UAT evidence;
- record rollback/recovery path;
- return concise Achieved / Blocked / Next.
