# CF-CHG-20260904-143 — Fixed Layer Navigation Sequence

**Status:** IMPLEMENTED / TARGETED PASS  
**Milestone:** M2.4.5

## Operator sequence
The operational Layer menu is a fixed execution sequence and must not be reordered by later UI changes:

1. **Layer 1 — Operations**
2. **Layer 2 — Enrichment**
3. **Layer 3 — AI Interpretation**
4. **Layer 4 — Human Resolution**

Evidence and Jobs remain after the four execution Layers.

## Administration
The Administration section strip now maintains operational shortcuts immediately after Overview in the same L1 → L2 → L3 → L4 order. Configuration sections follow those shortcuts.

This prevents the previous failure mode where Layer 2 was appended at the end of the Administration strip or disappeared when independent menu injectors/re-renders ran.

## Implementation invariant
A single sequence reconciler owns Layer shortcut position for both:
- sidebar **Data Operations**; and
- Administration sub-navigation.

The reconciler is idempotent and MutationObserver-safe. It reuses existing Layer buttons when present, creates a missing shortcut only when required, and then restores the canonical order. Future features must extend after the sequence rather than insert between L1–L4.

## Authority
Navigation order does not alter Layer authority. The execution model remains:
Layer 1 authority → Layer 2 deterministic acquisition/extraction → Layer 3 Evidence interpretation → Layer 4 human resolution → downstream Publication/Search.
