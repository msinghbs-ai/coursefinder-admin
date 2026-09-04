# CF-CHG-20260904-115 — Scholarship Percentage → Course Financial Calculation

**Status:** IMPLEMENTED / RUNTIME PASS  
**Milestone:** M2.4.5  
**Date:** 4 September 2026

## Requirement

When a Scholarship publishes a percentage award, CourseFinder must retain the original percentage and support an auditable Course-level calculation of the Scholarship saving and resulting net fee.

## Decision

Percentage awards are structured separately from display text:

- `award_value_type`
- `award_percentage`
- `award_amount`
- `award_currency_code`
- `award_applies_to_fee_type`
- `award_fee_basis`
- `award_duration_basis`

A derived row in `scholarship.course_financial_calculations` records the exact Course fee row used and retains:

- source `course_fee_id`;
- fee amount, currency, fee type, basis and year;
- Scholarship percentage/amount snapshot;
- calculated Scholarship saving;
- calculated net fee;
- calculation formula and status/reason;
- Scholarship and fee Evidence IDs;
- calculation timestamp.

## Guardrails

A percentage alone is not sufficient to calculate a fee reduction.

CourseFinder calculates only when first-party Scholarship evidence has established the applicable fee type and fee basis and there is one unambiguous matching governed Course fee row. CRICOS registered total-course tuition and provider-current annual tuition are never treated as interchangeable.

Unresolved cases remain explicitly classified, including `award_scope_unresolved`, `fee_not_found`, `fee_ambiguous` and `currency_mismatch`.

The original `award_value_text` is retained unchanged in canonical storage. The guarded Course Scholarship read may additionally present `Saving` and `Net fee` when the calculation status is `calculated`.

## Runtime verification

Existing pure percentage strings were structurally recognised without inferring their fee scope. The first batch refresh produced 503 `award_scope_unresolved` rows and zero fabricated calculations, proving the fail-closed rule.

## Security

`scholarship.course_financial_calculations` has RLS enabled, no browser-role table grants, and service-role-only refresh functions. Course reads continue through the existing guarded Admin Scholarship read boundary.

## Source reconciliation

Pilot migrations:

- `20260904123000_cf_115_scholarship_course_financial_calculation_fields.sql`
- `20260904123200_cf_116_course_scholarship_calculated_display.sql`
- `20260904123400_cf_117_scholarship_financial_calculation_refresh_batch.sql`
