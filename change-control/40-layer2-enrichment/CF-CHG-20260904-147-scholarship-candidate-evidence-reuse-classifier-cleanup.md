# CF-CHG-20260904-147 — Scholarship Candidate Evidence Reuse & Classifier Cleanup

**Status:** IMPLEMENTED / RUNTIME PASS  
**Milestone:** M2.4.5

## Review finding

The Scholarship detail-ready queue still contained candidates whose first-party detail pages had already been acquired and linked to Evidence-backed canonical unpublished Scholarships. Re-firing those candidates would waste acquisition capacity. The international-first selector also allowed some non-international awards into the executable pool where generic catalogue text contained the word `global`.

## Change

- Existing candidates are marked `acquired` when the same Provider + first-party detail URL already has an Evidence-backed acquisition trace and canonical Scholarship linkage.
- The original classification is retained for audit; `classification_reason` records `reused_existing_evidence_backed_canonical_trace`.
- Generic `global` matches without explicit `international`, `ASEAN` or `overseas` wording are moved to `needs_review` instead of being fired automatically.
- No new scraper call is made for reused-Evidence candidates.
- No canonical Scholarship, Course eligibility, Publication, Search, Website or Zoho state is changed by the cleanup.

## Evidence principle

The retained Evidence provenance remains authoritative for acquisition history. When stored Evidence is reused, Admin Evidence must show the originating acquisition provider and the derived/reuse relationship rather than implying a fresh scraper call.

## Source reconciliation

Pilot migration:

`supabase/migrations/20260904064900_cf_147_scholarship_candidate_reuse_and_false_positive_cleanup.sql`
