# CF-CHG-20260902-072 — Layer 1 source configuration card UI restoration

- **Initiated:** 2026-09-02T13:15:00+10:00
- **Origin:** CourseFinder — “Proceed” following UAT evidence that Administration → Layer 1 sources still rendered unstyled fields.
- **Category:** 30-admin-pim-ux
- **Change class:** Browser-facing UI defect correction
- **Status:** APPLIED / TARGETED UAT ACTIVE

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

**v2.15.30**

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

**APPLIED / TARGETED UAT ACTIVE**
