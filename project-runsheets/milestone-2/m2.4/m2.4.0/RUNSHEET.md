# M2.4.0 — Integration Cleanup, Test-Liability Removal & Acceptance Rebase

**Status:** ACTIVE — GATE A COMPLETE / GATE B RUNNING  
**Parent:** M2.4  
**Governance:** inherit `PROJECT_INSTRUCTIONS.md`, `STANDING-INSTRUCTIONS.md` and A1–A6.

## Objective

Clear the Go 7 navigation/test integration liability before further feature work. Produce one stable, primary-navigation-based test architecture and one accepted Pilot checkpoint so M2.4.1 can mature Layer 1 without inheriting stale launchers, duplicate navigation or expensive CI feedback loops.

## Starting facts

- M2.3 accepted baseline remains `260ed6a0d19b80ad666d74b90aa13e735e802a6a`.
- Go 7 introduced PIM Admin v2.15.6 and the streamlined menu.
- Go 7 navigation-specific tests passed, but full deployed UAT on `eabb7d99f93acf6260c06b33c852ed4b0bb6fd8a` failed because inherited suites still searched for removed `Layer 2 Operations` and floating `M2.3 Intelligence` launchers.
- After the user stopped the long run, additional Pilot test/audit commits existed through `c63442ea9ae44382b88f17fd0e01974cf5c6b469`; these were treated as **unaccepted working state**, not as a baseline.
- The pre-cleanup full run `32930647800` proved desktop green and isolated mobile failures to off-viewport primary-menu interaction, the coupled screenshot/content audit, one `courses_page` performance-budget miss, and one screen-state restore flake. No security assertion was weakened.

## Gate A — inventory/static cleanup — COMPLETE

Implemented on Pilot working `main` after `c63442e…`:

- removed the `Layer 2 Operations` compatibility alias from permanent navigation support;
- introduced `tests/uat/support/navigation.mjs` with shared adapters for Layer 1, Layer 2, Layer 2 Advanced/Providers/Trials, Layer 3, Layer 4, Evidence, Onboarding, Guides, Governance Provider and Scholarship Selection;
- migrated affected permanent Layer 2, M2.3, provider-governance, Scholarship and navigation suites onto accepted primary-navigation adapters;
- removed permanent UAT assertions against `.m23-launcher`, `.l3cred-launcher` and other hidden launcher selectors;
- set deterministic primary-navigation/UI timeout to 6 seconds while retaining long bounds only for authentication, provider/acquisition and other genuinely asynchronous operations;
- made primary-navigation interaction mobile-safe by opening/scrolling the sidebar instead of waiting for an off-viewport element to become visible by itself;
- separated `m2-4-navigation-content-audit.spec.mjs` from the permanent acceptance matrix and created `.github/workflows/m2-4-ux-audit.yml` for lightweight audit capture;
- changed `.github/workflows/deployed-uat.yml` to targeted → integration → acceptance tiers. Normal commits no longer trigger the complete permanent matrix.

### Transitional runtime launcher classification

Go 7 currently hides several legacy launcher controls and the accepted primary menu may bridge to those already-existing workspace entry controls internally. They are **not accepted operator navigation**, are hidden by the primary information architecture, and permanent UAT no longer references them. Removing those implementation bridges is not allowed to become a risky workspace rewrite inside M2.4.0; their complete deletion remains part of the cleanup/quarantine review and must not reappear as a second visible architecture.

Layer 1's operator journey is the primary `Layer 1 — Regulatory` entry. The underlying legacy host reuse is an implementation detail; Settings is not exposed as the normal operator path.

## Supabase/runtime reconciliation

- Pilot Supabase project `coursefinder_Pilot` / `fxcwkweaxjtknorudmwp` is `ACTIVE_HEALTHY`.
- Current Security Advisor contains INFO-only `RLS enabled/no policy` notices on intentionally non-direct-access schemas; no new public `SECURITY DEFINER` warning class was observed during this cleanup reconciliation.
- Current Performance Advisor remains INFO-only technical debt (unindexed foreign keys / unused indexes / Auth connection-strategy advice). M2.4.0 introduces no DDL and does not weaken RLS, grants, role/rank checks, Edge authentication or credential boundaries to address navigation/testing concerns.

## Gate B — targeted desktop/mobile — RUNNING

Latest working Pilot commit at this update: `cba72ca187a5da4f73b8072fd9534e8cb55bd601`.

Targeted workflow run: `32950523478` — queued/running at time of this runsheet update. Required targeted coverage includes:
- streamlined navigation contract;
- Layer 2 platform/provider/trial entry;
- Layer 3/4/Onboarding;
- Layer 3 provider governance;
- Scholarship Selection;
- Guides;
- release notes;
- desktop/mobile primary-navigation interaction.

Do not promote this SHA merely because it is current `main`.

## Gate C — bounded integration — NOT STARTED

Start only after Gate B is green. Include:
- changed UI and immediate upstream/downstream suites;
- Data Quality;
- Evidence/navigation paths;
- M2.3 Layer 3/4 invariants;
- role/rank negative paths;
- screen-state persistence;
- performance budgets, including the existing 3,000 ms `courses_page` budget.

The previous mobile `courses_page` result (3.177 s then 5.720 s on retry) remains a real assertion to revalidate. Do **not** raise the threshold merely to obtain PASS.

## Gate D — one full acceptance matrix — NOT STARTED

Only after Gates B and C are green:
1. nominate one acceptance SHA;
2. run exactly one complete deployed permanent desktop/mobile matrix for that SHA;
3. update Running Build / Register / CF-CHG-040 only if that matrix passes.

Any Pilot source/test change after nomination invalidates that candidate.

## Exit gate

M2.4.0 closes only when:

- no permanent UAT depends on floating operational launchers or obsolete menu names;
- shared navigation adapters are in place;
- deterministic UI failures fail fast;
- targeted desktop/mobile validation PASSes;
- bounded integration regression PASSes;
- one nominated SHA PASSes one full desktop/mobile deployed permanent matrix;
- no authority/security boundary was weakened;
- CF-CHG-20260826-040 is reconciled to that accepted runtime;
- CF-CHG-20260826-042 records the staged-testing outcome;
- CURRENT-STATE/NEXT-CHAT/FOLLOW-UPS identify M2.4.1 as the next feature gate;
- Running Build / Register change only after proof.

Do not start M2.4.1 implementation before this exit gate is met.
