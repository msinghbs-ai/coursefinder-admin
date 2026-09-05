# CF-CHG-20260905-203 — UNSW International Student Award Structuring & Course Review

**Status:** IMPLEMENTED / RUNTIME PASS — COURSE SCOPE REVIEW REQUIRED  
**Milestone:** M2.4.5  
**Domain:** Scholarship financial semantics / Course scope

## Change

The verified first-party UNSW International Student Award root was structured from its captured official detail Evidence as:

- `award_value_type = percentage`;
- `award_percentage = 20`;
- `award_applies_to_fee_type = tuition_fee`;
- `award_fee_basis = tuition_fee`;
- `award_duration_basis = program_duration`.

The canonical row remains unpublished.

## Course scope

Active UNSW Courses are staged only as `needs_review` mapping candidates. The award has eligible-country and program exclusions, so Course mappings are not accepted automatically and net-fee calculations remain blocked until governed Course scope is resolved.

## Boundary

This change does not publish the Scholarship, infer eligibility for a student, auto-accept Course mappings, or manufacture a Course fee. Financial calculations still require an accepted Scholarship→Course mapping plus a semantically aligned current tuition fee/year/basis.
