# Execution Addendum A24 — Unified Layer Workspace Header Scheme

**Status:** ACTIVE — M2.4.4 ADDENDUM  
**Effective:** 31 August 2026  
**Change Control:** `CF-CHG-20260830-048`

## Purpose

Use the accepted Layer 2 header treatment as the permanent visual hierarchy for all four operational Layers.

## A24.1 — Shared visual architecture

Layer 1, Layer 2, Layer 3 and Layer 4 must use one governed workspace-header pattern:

- dark navy workspace header;
- violet/indigo uppercase eyebrow;
- white Layer title;
- muted light explanatory text;
- utility/refresh actions aligned at the right in the same dark treatment;
- content below returns to the normal light operational canvas.

The header must be part of the permanent page layout, not a floating modal or temporary banner.

## A24.2 — Layer identity

The colour architecture stays consistent across Layers; orientation comes from the text/eyebrow and iconography rather than four unrelated colour schemes.

Recommended eyebrow semantics:
- Layer 1 — AUTHORITATIVE / REGULATORY;
- Layer 2 — BACKGROUND ENRICHMENT;
- Layer 3 — EVIDENCE-BOUND AI INTERPRETATION;
- Layer 4 — GOVERNED HUMAN RESOLUTION.

## A24.3 — Responsive behaviour

- desktop/tablet: full-width header within the Layer workspace;
- mobile: title/actions wrap without horizontal overflow;
- header action controls remain reachable;
- no duplicate floating Layer header or experimental label is permitted.

## A24.4 — Acceptance

Permanent UAT must prove:
1. all four canonical Layer routes render the shared dark header;
2. each header has the correct Layer title and semantic eyebrow;
3. Layer workspaces remain embedded/non-floating;
4. header does not create horizontal overflow at tablet/mobile widths.
