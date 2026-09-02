# CF-CHG-20260902-072 — Layer 1 source configuration card UI restoration

- **Initiated:** 2026-09-02T13:15:00+10:00
- **Origin:** CourseFinder — “Proceed” following UAT evidence that Administration → Layer 1 sources still rendered unstyled fields.
- **Category:** 30-admin-pim-ux
- **Change class:** Browser-facing UI defect correction
- **Status:** CLOSED / PASS

## Problem

The Layer 1 Operations workspace was correctly themed and card-based, but Administration → Layer 1 sources rendered browser-default form controls with fields flowing across the page.

The defect was isolated to the configuration component: `Layer1Operations` mounted the shared `STYLES` block, while `Layer1SourceSettings` reused `l1s-*` / `l1v2-*` classes without mounting those styles.

## Requested outcome

Make Layer 1 source configuration visually consistent with Layer 1 Operations:
- card-based source configuration;
- CourseFinder navy/indigo visual language;
- regulatory/statistics badges and health state;
- grouped source/authority and cadence/guardrail fields;
- responsive desktop/tablet/mobile layout;
- clear Validate / Dry run / Save controls;
- preserve the safe-maintenance boundary and existing governed commands.

## Correction

`Layer1SourceSettings` now mounts the shared Layer 1 stylesheet and uses a dedicated configuration layout:

- themed Layer 1 Administration header;
- country filter and refresh control;
- Platform Admin context bar and source count;
- responsive two-column source cards;
- source icon, authority metadata, format, verification time and governed status badges;
- **Source & authority** field group;
- **Cadence & guardrails** field group;
- safe-maintenance callout;
- consistent Validate, Dry run and Save configuration actions.

## Semantic / authority impact

UI only. No changes to:
- Layer 1 authority or identity semantics;
- source registry values;
- parser/acquisition behaviour;
- `layer1_admin_command` mutation boundary;
- `layer1-operations-control` execution permissions;
- Evidence retention;
- Search, Publication, website or Zoho consumers.

## Implementation

Coursefinder-Pilot:
- `src/layer1-operations-entry.jsx`
- `src/mature-main.jsx`
- `src/pim-version-entry.js`
- `index.html`
- `tests/uat/cf-065-layer1-operations-v2-contract.spec.mjs`
- `tests/uat/layer1-operations-deployed.spec.mjs`

Commits:
- `8b4fbe1565f889a13a6f0551a311b2041dcc252b` — card UI and stylesheet restoration
- `58270afb4037fbe5cad53b2c5bdbacc521380183` — Admin v2.15.30
- `3df210e7be39abd402b6a62aa334d0095fa21af2` — v2.15.30 release notes
- `3dd49fb09b1df602ecdff0fdb28d3083c1bed4d8` — browser title
- `73ba1836547c913f40a2f5aa19696d8f09e6186f` — source/build UI contract
- `1d802f0310ffb8bbd1f3409925fa442f938deae0` — deployed card UI gate

## UI version

Originally introduced in **v2.15.30** and now explicitly retained/delivered in the current Admin release **v2.15.39**.

Repository reconciliation on 2 September 2026 confirmed:
- `src/mature-main.jsx` current UI version is `2.15.39`;
- `src/pim-version-entry.js` current release version is `2.15.39`;
- `index.html` current browser title is `v2.15.39`;
- the Layer 1 source card implementation, shared `<style>{STYLES}</style>`, responsive `l1s-grid` / `l1s-card` layout and grouped **Source & authority** / **Cadence & guardrails** UI remain present after the subsequent ranking and access-admin changes;
- current Layer 1 source configuration also retains the later ranking-edition/upload/validation enhancements rather than reverting them.

Current-release alignment commit:
- `46200f00e62fd80a1f4eb582505993359797caa9` — v2.15.39 release notes explicitly retain the Layer 1 source configuration card UI.

## UAT

Targeted acceptance validates:
1. Administration → Layer 1 sources renders `.l1s-shell`.
2. v2.15.30 is deployed.
3. at least one governed source renders as `.l1s-card`.
4. Source & authority and Cadence & guardrails groups are visible.
5. toolbar has the themed background rather than browser-default styling.
6. cards and field containers have governed border-radius styling.
7. card layout remains visible at tablet width.
8. no server-side 5xx errors are observed during the read-only UI gate.

The source contract also requires the settings component to mount `<style>{STYLES}</style>` so this regression cannot silently recur.

## Rollback

Revert the six implementation/test commits listed above. No database migration or data rollback is required.

## Status

**CLOSED / PASS**

The corrective UI is no longer treated as a standalone v2.15.30 delivery. It is reconciled against current repository head and forms part of v2.15.39. No additional UI-version bump is required solely for this reconciliation.

## Closure review — 2 September 2026

Final repository review was performed against the current Pilot head after the later ranking and access-administration work had landed.

### Current-release verification

Current UI release is **v2.15.39**:

- `src/mature-main.jsx` → `UI_VERSION='2.15.39'`;
- `src/pim-version-entry.js` → `VERSION='2.15.39'`;
- `index.html` → `Coursefinder PIM Admin v2.15.39`.

The CF-072 implementation remains intact in current source:

- `Layer1SourceSettings` still mounts `<style>{STYLES}</style>`;
- `.l1s-shell`, `.l1s-grid` and `.l1s-card` remain the active configuration layout;
- **Source & authority** and **Cadence & guardrails** sections remain present;
- the navy/indigo Layer 1 Administration/Operations styling remains retained;
- the later ranking-edition upload/validation controls were integrated into the same card UI rather than replacing it;
- the source/build regression contract still asserts the stylesheet mount, card layout and grouped field structure.

The v2.15.39 release history was explicitly reconciled at `46200f00e62fd80a1f4eb582505993359797caa9` so the current release records that this UI remains part of the shipped Admin experience.

### Deployed UAT disposition

The latest targeted deployed run `33621476194` reports failures in the later ranking-import UX suite. The recorded failures are for CF-076 ranking-import navigation/retained-edition scenarios, including inability of the governed deployed UAT identity to see the Platform Admin-only Layer 1 source card. That does **not** demonstrate a regression of CF-072's styling implementation and must not be misreported as a CF-072 failure.

CF-072's role boundary remains intentional: Layer 1 source configuration is rank-6 Platform Admin-only. Closing this UI correction does not weaken that boundary merely to make the lower-rank deployed UAT identity render the screen.

### Acceptance

PASS for this change because the defect corrected by CF-072 is demonstrably absent from current repository truth and protected by a permanent source/build contract:

1. shared styles are mounted by the configuration component;
2. source configuration uses card layout rather than browser-default flowing fields;
3. themed source/status presentation remains;
4. grouped configuration sections remain;
5. later Layer 1 ranking functionality is preserved;
6. current UI/version surfaces are aligned at v2.15.39;
7. no authority, parser, Evidence, Search or Publication semantics changed.

Any failure of the later ranking-import deployed workflow remains owned by its ranking-import workstream and is not a reason to keep this styling defect open.

**Closure:** CLOSED / PASS — 2026-09-02T20:48:00+10:00.
