# CF-CHG-20260904-148 — Scholarship Detail Candidate Dedupe

**Status:** IMPLEMENTED / RUNTIME PASS  
**Milestone:** M2.4.5

## Review finding

The detail-ready Scholarship queue contained duplicate rows for the same canonical Provider + first-party detail URL. This was particularly visible for Edith Cowan University, where multiple catalogue observations pointed to the same Scholarship detail page.

## Change

- Before acquisition, retain one discovered `detail_ready` candidate per canonical Provider + `detail_target_url`.
- Mark repeated candidates `superseded` with reason `duplicate_provider_detail_url_superseded_before_acquisition`.
- Preserve every duplicate row for audit/history; no row is deleted.
- Do not consume scraper/API capacity for superseded candidates.
- No canonical Scholarship, Course eligibility, Publication, Search, Website or Zoho state changes.

## Runtime result

After dedupe in the current priority set:

- Edith Cowan University: 6 executable detail-ready candidates remain; 10 duplicate rows superseded.
- Charles Darwin University: 1 executable detail-ready candidate remains; 1 duplicate row superseded.
- Australian National University: 4 detail-ready candidates; no duplicate URL rows detected.
- Monash University: 252 detail-ready candidates after prior Evidence-reuse and false-positive cleanup.

## Source reconciliation

Pilot migration:

`supabase/migrations/20260904065300_cf_148_scholarship_detail_candidate_dedupe.sql`
