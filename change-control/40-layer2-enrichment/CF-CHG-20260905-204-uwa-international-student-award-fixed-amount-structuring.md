# CF-CHG-20260905-204 — UWA International Student Award Fixed-Amount Structuring

**Status:** IMPLEMENTED / RUNTIME PASS  
**Milestone:** M2.4.5  
**Domain:** Scholarship financial semantics

## Change

The verified first-party UWA International Student Award is now represented as an explicitly evidenced annual fixed tuition reduction:

- `award_value_type = fixed_amount`;
- `award_amount = 5000`;
- `award_currency_code = AUD`;
- `award_applies_to_fee_type = tuition_fee`;
- `award_fee_basis = tuition_fee`;
- `award_duration_basis = annual_program_duration`.

The canonical Scholarship remains unpublished and its Course candidates remain `needs_review` because eligible-country and eligible-course rules are separate from the award amount.

## Boundary

The current Course financial calculator intentionally calculates percentage awards only. CF-204 therefore does **not** manufacture a net Course fee for this fixed annual award. Fixed-amount calculation support requires its own governed formula/basis gate.
