# CF-CHG-20260905-208 — Scholarship PIM Maturity Acceptance

**Status:** IMPLEMENTED / SOURCE CONTRACT ADDED / DEPLOYED UAT ADDED / CI PENDING  
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

Treat H3 as an acceptance/continuity gap rather than a missing feature. Protect the existing mature-shell implementation with dedicated CF-208 source and deployed acceptance contracts before closing the follow-up.

## Pilot acceptance added

- `tests/uat/cf-208-scholarship-pim-maturity-contract.spec.mjs`
- `tests/uat/cf-208-scholarship-pim-maturity-deployed.spec.mjs`

Implementation commits:

- `ad898fc795b01a321d0284f5b44526c76c88e8aa` — source contract
- `8de7287c6e79a1006d229bc560e5e882b1775c6b` — deployed acceptance

## Acceptance gate

Source contract must prove that the mature shell continues to wire Scholarships to the governed catalogue/read boundary and retains filter/sort/pagination/detail controls.

Deployed UAT must prove that an authenticated operator can open Scholarships, receives a populated catalogue, sees Country/Lifecycle/Publication controls, and receives rows without server errors.

Do not mark H3 CLOSED/PASS until CI/deployed acceptance reports success.

## Safety

- No Scholarship eligibility is inferred.
- Provider ownership alone remains review-only for Course eligibility.
- Publication/Search admission remains separate from Scholarship PIM inspection.
- No database, Edge Function, credential, Production resource or canonical record mutation is introduced by CF-208.

## Next

After CF-208 passes, close M245-FU-004 and move the active PIM completion sequence to H4 Scheduler/Jobs operations, while H14 API-key lifecycle remains independently governed under CF-207.
