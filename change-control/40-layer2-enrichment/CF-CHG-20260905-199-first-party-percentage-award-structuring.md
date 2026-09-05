# CF-CHG-20260905-199 — First-Party Percentage Award Structuring

**Status:** IMPLEMENTED / RUNTIME PASS  
**Milestone:** M2.4.5  
**Domain:** Scholarship financial semantics

## Change

Converted only unambiguous, Evidence-backed, unpublished first-party award text matching an exact percentage tuition/reduction pattern into structured percentage semantics.

Eligible patterns are limited to exact values such as `20% of tuition`, `25% of tuition`, `50% of tuition`, `100% of tuition` and `25% reduction`. Tiered, `up to`, stipend and generic monetary awards are excluded.

Structured fields:

- `award_value_type = percentage`
- `award_percentage = explicit value`
- `award_applies_to_fee_type = tuition_fee`
- `award_fee_basis = tuition_fee`

For UQ International Excellence, first-party detail explicitly supports the percentage for the program duration, so `award_duration_basis = program_duration` is retained. Other records remain duration-unresolved unless independently evidenced.

## Runtime result

Ten first-party Scholarships were safely structured across Griffith, UQ and UTS. No Course mapping, net-fee calculation or Publication was fabricated.

## Boundary

A structured Scholarship percentage does not itself prove Course eligibility. Course scope and fee-year/basis matching remain separate governed gates before financial calculation.
