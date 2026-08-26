# CF-CHG-20260826-040 — Streamlined Data Operations Navigation & Visible Guides

**Status:** APPROVED / IMPLEMENTED WORKING STATE — ACCEPTANCE REBASE REQUIRED  
**Category:** 30-admin-pim-ux  
**Initiated:** 26 August 2026 12:23 AEST (+10:00)  
**Origin chat/workstream:** CourseFinder Go 7 / M2.4 Admin information-architecture optimisation  
**Owner:** CourseFinder programme / Admin PIM UX  
**Change class:** UI / navigation / documentation / operations

## Trigger

User-directed M2.4 optimisation after M2.3 closure. The deployed menu was structurally split across legacy groups and floating launchers: Layer 1 was presented through Settings alongside qualification/destructive controls, Layer 2 had its own patched group, Layer 3/4/Onboarding/Scholarship Selection used floating launchers, and Guides were not visible in the primary Admin.

## Requested outcome

Present one logical, streamlined Admin information architecture for ingestion and operations. Layers 1–4 must read as first-class governed operating capabilities, not experiments or disconnected overlays. Guides/Runbooks must be visible from the primary menu. Layer 1 must no longer appear to operators as a Settings/experimental feature.

## Affected surfaces

- `msinghbs-ai/Coursefinder-Pilot` primary sidebar and operational launchers;
- Layer 1 Regulatory presentation;
- Layer 2/3/4, Evidence, Jobs/Runs and Onboarding navigation;
- Scholarship Selection placement;
- Governance/Platform and Users & Roles;
- Guides & Runbooks;
- release notes/version;
- permanent desktop/mobile UAT;
- Admin Navigation IA and current Running Build.

## Semantic impact

No canonical semantic change. No Layer authority, source precedence, Evidence, Search/Publication, role/rank, RPC or database contract changes are authorised by this Change Control.

## Implemented working model

Primary order:

1. Overview;
2. Catalogue;
3. Data Operations;
4. Insights;
5. Quality & Review;
6. Decision Tools;
7. Governance & Platform;
8. Help & Guides.

`Data Operations` exposes Layer 1 — Regulatory, Layer 2 — Enrichment, Layer 3 — AI Interpretation, Layer 4 — Human Resolution, Evidence & Provenance, Jobs & Runs and Onboarding according to role. `Decision Tools` exposes Scholarship Selection. Governance retains configuration/access functions. The legacy Settings journey is removed from primary operations. Layer 1 normal presentation suppresses unrelated qualification and destructive reset controls. `Help & Guides` exposes in-product operator guidance.

Visible release target remains PIM Admin `v2.15.6`.

## Acceptance evidence and failure classification

Go 7-specific navigation tests passed, proving the new menu/guide contract itself was reachable.

However, the full deployed permanent matrix on Pilot `eabb7d99f93acf6260c06b33c852ed4b0bb6fd8a` failed because inherited permanent suites still searched for removed `Layer 2 Operations` navigation and floating `M2.3 Intelligence` launchers. These deterministic missing selectors waited roughly 45–50 seconds and retried across many tests.

The failure therefore exposed **distributed test/navigation coupling and CI feedback-loop debt**. It does not justify restoring obsolete floating launchers or legacy menu labels.

The user stopped the long execution because it was disrupting momentum. Post-stop Pilot test/audit commits now exist through `c63442ea9ae44382b88f17fd0e01974cf5c6b469`; they remain unaccepted working state until M2.4.0 reconciliation.

## Replanned UAT under CF-CHG-20260826-042

CF-CHG-20260826-042 and A1–A6 now govern completion:

1. M2.4.0 inventories stale/floating dependencies;
2. shared primary-navigation test adapters replace distributed launch logic;
3. targeted desktop/mobile navigation/workspace tests must PASS;
4. affected Layer 1–4 integration/security/performance tests must PASS;
5. only then is one SHA nominated for one complete deployed desktop/mobile matrix;
6. this Change Control closes only on that accepted SHA.

Permanent UAT must not depend on floating operational launchers.

## Rollback / reversion

If M2.4.0 cannot produce an accepted integrated runtime, revert Go 7 navigation/guide/version changes to the last accepted M2.3 runtime. No database rollback is required.

## Documentation

Already retained in working governance:

- Admin Navigation IA v1.4;
- M2.4 Data Operations Admin Guide v1.1;
- Go 7 navigation/performance/content audit and screenshots;
- M2 meeting progress record.

Running Build must not declare Go 7 accepted until M2.4.0 final acceptance passes.

## Decision / status history

| Timestamp | Status | Decision / event |
|---|---|---|
| 26 Aug 2026 12:23 AEST | APPROVED / IN PROGRESS | User authorised streamlined menu, visible guides and Layer 1 relocation. |
| 26 Aug 2026 | UAT FAILED / INTEGRATION DEBT | Full matrix exposed stale permanent navigation selectors and floating-launcher dependency. |
| 26 Aug 2026 18:00 AEST | ACCEPTANCE REBASE REQUIRED | User stopped long run; programme adopted A1–A6 and mandatory M2.4.0 cleanup before feature expansion. |

## Closure

**Final status:** ACCEPTANCE REBASE REQUIRED  
**Closed at:** N/A  
**Outcome:** Working UI/navigation implemented; final acceptance deferred to M2.4.0 cleanup/integration checkpoint.
