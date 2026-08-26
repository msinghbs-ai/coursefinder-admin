# CF-CHG-20260826-040 — Streamlined Data Operations Navigation & Visible Guides

**Status:** CLOSED / PASS  
**Category:** 30-admin-pim-ux  
**Initiated:** 26 August 2026 12:23 AEST (+10:00)  
**Closed:** 26 August 2026 20:43 AEST (+10:00)  
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
- Admin Navigation IA and Running Build.

## Semantic impact

No canonical semantic change. No Layer authority, source precedence, Evidence, Search/Publication, role/rank, RPC or database contract changes were introduced by this Change Control.

## Accepted operating model

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

Visible browser release: PIM Admin `v2.15.6`.

## M2.4.0 reconciliation

The original Go 7 full matrix exposed distributed test/navigation coupling rather than a reason to restore obsolete navigation. Under CF-CHG-20260826-042 and A1–A6, M2.4.0 completed the rebase:

- permanent UAT was migrated to shared primary-navigation adapters;
- obsolete `Layer 2 Operations` and floating-launcher dependencies were removed from permanent acceptance;
- deterministic navigation failures were bounded rather than allowed to accumulate 45–50 second selector waits;
- UX/content audit capture was separated from permanent functional acceptance;
- CI was staged as targeted → integration → one nominated acceptance matrix;
- Layer 1 primary navigation was separated from privileged Platform Settings rather than weakening the rank boundary;
- first Course-page rendering was prioritised ahead of filter metadata to remove first-load contention without changing data or security semantics.

## Acceptance evidence

### Targeted

Working implementation SHA: `ecc81dfbf5e6e985eb84b4974c50b0657aac10a0`  
Run `32954022764`:

- desktop `98131600073` — PASS;
- mobile `98131600295` — PASS.

### Bounded integration

Integration marker SHA: `70244120258cf47d25575bc8af4dbb71fee0daf3`  
Run `32958008107`:

- desktop `98143894774` — PASS;
- mobile `98143894861` — PASS.

Retained desktop performance evidence proves first `courses_page` at **1,985 ms** against the unchanged **3,000 ms** contract, with 80,557-byte page payload and 257,659-byte filter metadata payload. No threshold was widened.

### Full deployed acceptance

**Accepted Pilot SHA:** `ba846abb8f55c0c28d65de9e676bd29ed09a3ab4`

- Frontend Build `32958795576` — PASS;
- deployed UAT `32958795547` — PASS;
- desktop `98146317262` — PASS;
- mobile `98146317373` — PASS.

The permanent matrix traversed accepted user-facing navigation and included Data Quality, performance, Layer 2 platform/provider/trials, Course Detail polish, screen-state persistence, Layer 3/4 intelligence, Layer 3 credential governance, Scholarship Selection and release notes.

## Security / authority disposition

- No database DDL was introduced by M2.4.0.
- No RLS, grant, role/rank, Edge authentication, Vault/provider-credential, private Evidence, Layer authority or Search/Publication boundary was weakened.
- Platform Settings/destructive controls remain separately privileged; Layer 1 normal operator navigation does not grant Platform Admin authority.

## Rollback / reversion

If the accepted M2.4.0 navigation/runtime regresses, revert the browser/navigation/test changes to the last accepted M2.3 Pilot runtime `260ed6a0d19b80ad666d74b90aa13e735e802a6a` or the specific pre-change source commit. No database rollback is required for this UI/read-order/test architecture change.

## Documentation

Maintained/retained:

- Admin Navigation IA v1.4;
- M2.4 Data Operations Admin Guide v1.1;
- Go 7 navigation/performance/content audit and screenshots;
- M2.4.0 runsheet and staged-UAT evidence;
- visible release notes PIM Admin v2.15.6;
- Running Build / Master Plan / Change Register updated after acceptance.

## Decision / status history

| Timestamp | Status | Decision / event |
|---|---|---|
| 26 Aug 2026 12:23 AEST | APPROVED / IN PROGRESS | User authorised streamlined menu, visible guides and Layer 1 relocation. |
| 26 Aug 2026 | UAT FAILED / INTEGRATION DEBT | Initial full matrix exposed stale permanent navigation selectors and floating-launcher dependency. |
| 26 Aug 2026 18:00 AEST | ACCEPTANCE REBASE REQUIRED | Programme adopted A1–A6 and mandatory M2.4.0 cleanup before feature expansion. |
| 26 Aug 2026 20:43 AEST | CLOSED / PASS | Targeted, bounded integration and one nominated full desktop/mobile deployed acceptance matrix PASSed on `ba846abb…`. |

## Closure

**Final status:** CLOSED / PASS  
**Closed at:** 26 August 2026 20:43 AEST (+10:00)  
**Outcome:** Streamlined primary Admin information architecture, Layer 1 operator journey and visible Guides are accepted on Pilot SHA `ba846abb8f55c0c28d65de9e676bd29ed09a3ab4`; permanent UAT no longer depends on obsolete/floating launch architecture.
