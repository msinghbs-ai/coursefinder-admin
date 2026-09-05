# CF-CHG-20260905-208 — Scholarship PIM Maturity Acceptance

**Status:** CLOSED / TARGETED PASS  
**Milestone:** M2.4.5  
**Type:** ACCEPTANCE / ADMIN-PIM UX / GOVERNANCE  
**Initiated:** 5 September 2026 16:30 AEST  
**Originating workstream:** CF M2.4.5 — Scholarships Acquisition & PIM Completion — Part 2  
**Primary owner:** 30-admin-pim-ux  
**Related:** CF-185–206 Scholarship acquisition, semantic hardening and Layer 4 controls

## Finding

H3 was still recorded as open in M2.4.5 continuity, but the current mature Admin shell already implements the required Scholarship catalogue behaviour. The deployed route uses `ScholarshipWorkspace`, which embeds the common governed `Catalogue` with `type="scholarship"`.

The existing implementation provides:

- governed `scholarships_page` reads and `scholarship_detail` drill-through;
- operator search;
- Country, Lifecycle and Publication filters;
- server-side sort/direction;
- 50-row pagination;
- persisted per-user screen state;
- row selection and detail drawer;
- explicit separation of structural candidate scoring from verified student eligibility.

No duplicate Scholarship grid or second PIM control plane is required.

## Decision

Treat H3 as an acceptance/continuity gap rather than a missing feature. Protect the existing mature-shell implementation with dedicated CF-208 source and deployed acceptance contracts.

## Pilot acceptance

- `tests/uat/cf-208-scholarship-pim-maturity-contract.spec.mjs`
- `tests/uat/cf-208-scholarship-pim-maturity-deployed.spec.mjs`

Implementation commits:

- `ad898fc795b01a321d0284f5b44526c76c88e8aa` — source contract
- `8de7287c6e79a1006d229bc560e5e882b1775c6b` — deployed acceptance

Final evidence:

- Pilot Frontend Build `33950428195` — SUCCESS;
- CourseFinder Deployed UAT `33950428173` — SUCCESS.

## Safety

- No Scholarship eligibility is inferred.
- Provider ownership alone remains review-only for Course eligibility.
- Publication/Search admission remains separate from Scholarship PIM inspection.
- No database, Edge Function, credential, Production resource or canonical record mutation is introduced by CF-208.

## Gate

H3 is CLOSED / TARGETED PASS. Continue PIM completion through H4/H5 while H14 API-key lifecycle remains independently governed under CF-207.
