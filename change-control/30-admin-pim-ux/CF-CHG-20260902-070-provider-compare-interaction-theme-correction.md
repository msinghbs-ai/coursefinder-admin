# CF-CHG-20260902-070 — Provider Compare Interaction & Theme Correction

**Status:** IMPLEMENTED / TARGETED UAT PENDING  
**Initiated:** 2 September 2026 11:36 AEST  
**Primary category:** 30-admin-pim-ux  
**Related:** CF-061, CF-064, CF-069  
**Origin:** User UAT — Provider Compare reported as non-working; Compare header colour inconsistent with the established CourseFinder Admin theme.

## Defect

The Compare workspace relied on the hash-route update to become the sole source of truth after Add / Remove / Clear. This made Provider selection unnecessarily dependent on a subsequent browser routing event and could present as a dead click or stale selection during UAT.

Separately, the Compare hero used a bespoke dark-indigo/teal gradient and magenta active treatment instead of the established Admin/layer header palette.

The server read itself remains valid:
- `public.admin_read('contextual_compare', ...)` returns Provider comparison data;
- `security.admin_contextual_compare(jsonb)` retains the six-entity boundary;
- CF-069 restored the authenticated SECURITY INVOKER execution chain.

## Correction

Pilot source **v2.15.28**:
- updates Provider/Course selection state immediately before persisting it into the Compare route;
- de-duplicates and bounds selected IDs to six;
- resets stale comparison data while the next governed read loads;
- synchronises Add / Remove / Clear / type switch through one `commitSelection` path;
- adds an explicit accessible search label and a stable compare-picker data marker;
- retains route persistence so refresh/deep-link behaviour remains available.

Theme:
- Compare header now uses the same `#172033` dark navy background as the permanent layer header;
- border matches `#25324a`;
- eyebrow and body copy use the same indigo/slate header tones;
- Provider/Course active toggle uses the CourseFinder indigo accent rather than the former magenta treatment.

## Authority boundary

No QILT, PRISMS, QS, THE, Layer 1 identity, Search, Publication, Website or Zoho authority changes are introduced.

## UAT

Targeted deployed regression must prove:
1. Provider detail → Compare opens with one selected Provider.
2. Searching and adding a second Provider updates **2 / 6 selected** immediately.
3. Route persists selected IDs.
4. Governed `contextual_compare` response returns the two requested Providers.
5. Header computed colour is the accepted CourseFinder navy/border palette.
6. Tablet/mobile comparison remains bounded.
7. No unexpected HTTP 5xx.

Permanent regression:
`tests/uat/cf-061-qilt-prisms-comparison-deployed.spec.mjs`.

## Rollback

Frontend-only interaction/theme correction can be reverted independently. CF-069 ACL restoration and CF-061 comparison read contracts are not rolled back by this UI change.
