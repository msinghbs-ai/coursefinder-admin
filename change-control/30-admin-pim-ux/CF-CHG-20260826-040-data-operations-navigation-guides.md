# CF-CHG-20260826-040 — Streamlined Data Operations Navigation & Visible Guides

**Status:** APPROVED / IN PROGRESS  
**Category:** 30-admin-pim-ux  
**Initiated:** 26 August 2026 12:23 AEST (+10:00)  
**Origin chat/workstream:** CourseFinder Go 7 / M2.4 Admin information-architecture optimisation  
**Owner:** CourseFinder programme / Admin PIM UX  
**Change class:** UI / navigation / documentation / operations

## Trigger

User-directed M2.4 optimisation after M2.3 closure. The deployed menu remains structurally split across legacy groups and floating launchers: Layer 1 is still presented through Settings alongside qualification/destructive controls, Layer 2 has its own patched group, Layer 3/4/Onboarding/Scholarship Selection use floating launchers, and Guides are not visible in the primary Admin.

## Problem / requested outcome

Present one logical, streamlined Admin information architecture for ingestion and operations. Layers 1–4 must read as first-class governed operating capabilities, not experiments or disconnected overlays. Guides/Runbooks must be visible from the primary menu. Layer 1 must no longer appear to operators as a Settings/experimental feature.

## Affected surfaces / related workstreams

- `msinghbs-ai/Coursefinder-Pilot` primary sidebar and operational launchers;
- Layer 1 Regulatory workspace presentation;
- Layer 2 Operations, Layer 3 AI Interpretation, Layer 4 Human Resolution, Evidence, Jobs/Runs and Onboarding navigation;
- Scholarship Selection placement;
- Governance/Platform navigation and Users & Roles;
- in-product Guides & Runbooks;
- PIM Admin visible release/version notes;
- permanent desktop/mobile deployed UAT;
- `docs/coursefinder-admin-navigation-information-architecture-*` and current Running Build.

## Semantic impact

No canonical semantic change. No Layer authority, source precedence, Evidence, Search/Publication, role/rank, RPC or database contract changes are authorised by this Change Control. This is an information-architecture and operator-journey change only.

## Before

- primary sidebar uses Catalogue, Enrichment & Insights, Data Quality and Operations groups;
- a post-render patch creates `Data Enrichment` with only Layer 2 Operations and Evidence;
- Layer 1 Regulatory execution is reached through privileged Settings, where separate qualification/UAT controls also appear;
- Layer 3, Layer 4, Onboarding and Scholarship Selection are primarily floating launcher experiences;
- Jobs is hidden from the patched menu rather than integrated into a coherent operating group;
- Guides/Runbooks are repository documents only and not directly visible in the Admin shell.

## After

Primary order target:

1. Overview;
2. Catalogue;
3. Data Operations;
4. Insights;
5. Quality & Review;
6. Decision Tools;
7. Governance & Platform;
8. Help & Guides.

`Data Operations` exposes Layer 1 — Regulatory, Layer 2 — Enrichment, Layer 3 — AI Interpretation, Layer 4 — Human Resolution, Evidence & Provenance, Jobs & Runs and Onboarding. `Decision Tools` exposes Scholarship Selection. Governance keeps Sources, Attributes and Users & Roles. The legacy Settings menu is removed from the primary journey. Layer 1 primary navigation suppresses unrelated StatsCan qualification and destructive Pilot-reset controls so the normal regulatory workflow does not look experimental.

`Help & Guides` exposes an in-product Guides & Runbooks workspace with role-oriented quick guidance and direct launch links into the governed operating surfaces.

## Source authority / evidence

- `docs/coursefinder-admin-navigation-information-architecture-v1.3.md` already defines Layer 1–3 as first-class Data Operations and states trials must not make the platform look experimental.
- M2.3 accepted authority remains Layer 1 → Layer 2 → Layer 3 → terminal Layer 4.
- Accepted pre-change runtime: `msinghbs-ai/Coursefinder-Pilot@260ed6a0d19b80ad666d74b90aa13e735e802a6a`.

## Implementation references

- Supabase migration(s): none expected.
- Git repository/commit(s): pending.
- RPC/API objects: unchanged.
- UI version: target `PIM Admin v2.15.6`.

## UAT

Required before closure:

- primary group order and labels are correct on desktop/mobile;
- Layer 1 is visible as Data Operations, not Settings;
- normal Layer 1 view does not display StatsCan dry-run or Reset Pilot database controls;
- Layer 2, Layer 3, Layer 4, Evidence, Jobs/Runs and Onboarding open from Data Operations;
- Scholarship Selection opens from Decision Tools;
- Guides & Runbooks is visible and opens from primary navigation;
- floating operational launchers are suppressed when equivalent primary navigation exists;
- Insights retains QILT/PRISMS true contextual grain;
- Sources/Attributes/Users & Roles retain their existing role boundaries;
- existing M2.3 permanent browser, performance and release-notes suites remain green;
- full deployed Chromium desktop/mobile matrix passes without weakened tests.

## Rollback / reversion

Revert the Go 7 navigation/guide/version/test commits. No database rollback is required. The accepted M2.3 runtime remains the semantic fallback.

## Documentation impact

- PIM Admin Guide: update via visible in-product guide and maintained Data Operations guidance.
- Architecture: no database architecture change.
- Running build: update after deployed UAT PASS.
- Master plan: M2.4 moves from planned/unblocked to active while this Change Control executes.
- UAT/design docs: publish Admin Navigation IA v1.4 after accepted runtime.
- Zoho contract: none.

## Decision / status history

| Timestamp | Status | Decision / event | Reference |
|---|---|---|---|
| 26 Aug 2026 12:23 AEST | APPROVED / IN PROGRESS | User authorised Go 7 streamlined menu, visible guides and Layer 1 relocation | Go 7 chat |

## Closure

**Final status:** IN PROGRESS  
**Closed at:** N/A  
**Outcome:** Pending implementation and permanent deployed desktop/mobile UAT.