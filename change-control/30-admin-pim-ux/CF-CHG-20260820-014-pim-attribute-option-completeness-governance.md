# CF-CHG-20260820-014 — PIM Attribute Options and Completeness Profile governance

**Status:** DB/RPC/SECURITY PASS + v2.10 FRONTEND PRESENTATION PASS — DEPLOYED BROWSER UAT PENDING  
**Category:** 30-admin-pim-ux  
**Initiated:** 20 August 2026  
**Origin:** `M1-PIM-GOV — Field Semantics, Change Control & Admin Guide`  
**Owner:** CourseFinder Admin/PIM governance

## Semantic decisions retained

- Attribute Family and Group organise governed PIM configuration; neither is an Attribute value.
- Attribute code is the durable semantic identifier; labels remain presentation.
- Attribute Options are governed vocabulary and must be visible rather than merely counted.
- Completeness Profiles are policy contexts, not truth or approval states.
- Completeness Requirements define the actual Profile logic.
- The current six-signal Course Admin readiness remains a separate display-only rule unless a governed PIM Profile explicitly supersedes it.

## Corrected read contract

The original draft migration used obsolete/nonexistent table names. Finalisation audited the live schema and corrected the repository mirror to:

- `pim.attribute_families`;
- `pim.attribute_groups`;
- `pim.attribute_definitions`;
- `pim.attribute_options`;
- `pim.completeness_profiles`;
- `pim.completeness_requirements` exposed as `completeness_profile_rules`;
- `pim.family_groups` and `pim.family_attributes` for governed relationships.

The rank-5 helper is `security.admin_pim_governance_read(jsonb)` and the browser path remains `public.admin_read('attributes', ...)`.

## v2.10 frontend presentation

PIM Admin v2.10 presents explicit sections for Families, Groups, Attributes, Options, Completeness Profiles and Completeness Requirements. Empty Options/Profiles/Requirements are shown as governed empty states rather than load failures or invented configuration.

Current Pilot counts during UAT were 3 Families, 13 Groups, 3 Attribute Definitions, 0 Options and 0 Completeness Profiles.

## Security UAT

- PIM Admin rank 5 is enforced server-side.
- An authenticated identity with no CourseFinder role is denied with SQLSTATE `42501`.
- legacy Attribute/PIM `public.ui_*` compatibility helpers are not browser executable.

## Closure

**Final status:** OPEN — deployed browser UAT pending.  
Frontend source/payload presentation is no longer the blocker; closure requires the deployed PIM Admin browser walkthrough.
