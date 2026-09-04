# CF-CHG-20260904-150 — CDU Australia Awards Canonical Unpublished Reconciliation

**Status:** IMPLEMENTED / RUNTIME PASS  
**Milestone:** M2.4.5

## Change

The Evidence-backed CDU Australia Awards source record was reconciled into the governed Scholarship model as a canonical **unpublished** international Scholarship.

## Rules applied

- canonical identity is Provider + first-party detail identity;
- the first-party Evidence/source record is retained in the acquisition trace;
- publication remains `unpublished`;
- no award amount, percentage or Course financial calculation is created because the acquired Evidence did not safely establish a numeric financial value;
- Course eligibility remains unresolved until authoritative scope can be mapped;
- no Search, Website or Zoho admission occurs automatically.

## Result

The corresponding Layer 2 discovery candidate is marked acquired and linked through:

`candidate → first-party detail → Evidence/source record → canonical unpublished Scholarship → acquisition trace`.

## Source reconciliation

Pilot migration:

`supabase/migrations/20260904065900_cf_150_cdu_australia_awards_canonical_unpublished.sql`
