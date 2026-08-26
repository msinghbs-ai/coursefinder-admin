# M2.4.0 — Integration Cleanup, Test-Liability Removal & Acceptance Rebase

**Status:** NEXT / MANDATORY BEFORE M2.4.1  
**Parent:** M2.4  
**Governance:** inherit `PROJECT_INSTRUCTIONS.md`, `STANDING-INSTRUCTIONS.md` and A1–A6.

## Objective

Clear the Go 7 navigation/test integration liability before further feature work. Produce one stable, primary-navigation-based test architecture and one accepted Pilot checkpoint so M2.4.1 can mature Layer 1 without inheriting stale launchers, duplicate navigation or expensive CI feedback loops.

## Starting facts

- M2.3 accepted baseline remains `260ed6a0d19b80ad666d74b90aa13e735e802a6a`.
- Go 7 introduced PIM Admin v2.15.6 and the streamlined menu.
- Go 7 navigation-specific tests passed, but full deployed UAT on `eabb7d99f93acf6260c06b33c852ed4b0bb6fd8a` failed because inherited suites still searched for removed `Layer 2 Operations` and floating `M2.3 Intelligence` launchers.
- After the user stopped the long run, additional Pilot test/audit commits exist through `c63442ea9ae44382b88f17fd0e01974cf5c6b469`; these are **unaccepted working state** and must be reconciled before any new feature implementation.
- No full-matrix rerun is authorised as the first cleanup action.

## Cleanup scope

1. Inventory every permanent test and UI module that references:
   - legacy `Layer 2 Operations` primary-nav label;
   - `.m23-launcher`, `.l2*-launcher`, `.ops-launcher`, `.ss-launcher` or other floating operational entry points;
   - Settings as the normal Layer 1 operator path;
   - duplicated workspace-opening logic.
2. Introduce shared primary-navigation adapters for Layer 1/2/3/4, Evidence, Onboarding, Guides and Governance provider configuration.
3. Migrate affected permanent functional suites to shared adapters while retaining their existing security/data assertions.
4. Remove or explicitly classify remaining floating/experimental launcher code:
   - delete when superseded;
   - retain only if diagnostic/temporary and impossible to confuse with accepted operator navigation;
   - permanent UAT must not depend on it.
5. Review post-Go7 audit commits and keep only useful evidence/audit code that does not re-couple the permanent matrix to screenshot collection.
6. Separate lightweight UX/performance evidence capture from functional acceptance according to A5.
7. Review workflow triggers and prepare a targeted/integration/acceptance CI structure. Do not create overlapping full matrices during cleanup.

## Testing sequence

### Gate A — Static/inventory
- search-based legacy-selector inventory;
- test discovery;
- build/lint/syntax where present;
- confirm no permanent test depends on hidden/floating launchers.

### Gate B — Targeted desktop/mobile
Run only:
- streamlined navigation;
- Layer 2 platform/provider/trial navigation entry;
- Layer 3/4/Onboarding workspace entry;
- Layer 3 provider governance entry;
- Guides;
- release notes;
- responsive menu interaction.

Fail deterministic missing selectors quickly.

### Gate C — Integration
Run affected Layer 1–4 functional/security suites plus performance paths that depend on navigation. Do not run unrelated frozen suites repeatedly while Gate B is red.

### Gate D — Full acceptance
Only after A–C are green, nominate one SHA and run one complete deployed desktop/mobile permanent matrix. That SHA becomes the M2.4.0 accepted checkpoint.

## Exit gate

M2.4.0 closes only when:

- no permanent UAT depends on floating operational launchers or obsolete menu names;
- shared navigation adapters are in place;
- targeted desktop/mobile and integration suites PASS;
- one full desktop/mobile deployed matrix PASSes on one nominated SHA;
- CF-CHG-20260826-040 is reconciled to that accepted runtime;
- CI execution plan follows targeted → integration → acceptance;
- CURRENT-STATE/NEXT-CHAT/FOLLOW-UPS identify M2.4.1 as the next feature gate.

Do not start M2.4.1 implementation before this exit gate is met.
