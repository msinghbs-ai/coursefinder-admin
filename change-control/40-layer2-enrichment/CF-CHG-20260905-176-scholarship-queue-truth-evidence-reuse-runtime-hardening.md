# CF-CHG-20260905-176 — Scholarship Queue Truth, Evidence Reuse & Runtime Hardening

**Status:** IMPLEMENTED / RUNTIME PASS  
**Milestone:** M2.4.5

## Review finding

The Scholarship runtime summary materially overstated executable detail work because historical acquired/superseded candidates retained the `detail_ready` classification. The Country/University detail batching service also reconsidered acquired and `catalogue_or_filter` rows during Start, allowing an already-known catalogue page to re-enter the detail queue. Duplicate catalogue observations further inflated the apparent work.

## Changes

### CF-176 — queue truth and reuse
- Evidence-backed canonical Provider/detail URLs are marked acquired without another fetch.
- External/non-first-party Scholarship pages remain review-only.
- A verified first-party `scholarship_url` can become the executable detail target when `detail_target_url` is absent.
- Duplicate Provider + normalised detail URL observations are superseded, retained for audit and never deleted.

### CF-177 — discovered-only detail batching
- Only `status=discovered` candidates can be reclassified or queued.
- Acquired/superseded history cannot re-enter automatic detail firing.

### CF-178 — navigation exclusion
- Navigation/support titles such as `Skip to main content`, `FAQ`, `Eligibility`, `Guidelines`, `menu`, and catalogue headings cannot execute as Scholarship details.

### CF-179 — terminal catalogue classification
- `catalogue_or_filter` is a terminal automatic-detail exclusion.
- Catalogue Evidence remains available for enumeration/provenance but cannot be promoted back to an individual Scholarship by keyword matching.

### CF-180 — existing source-record reuse
- When a first-party source record, Evidence and canonical unpublished Scholarship already exist for the same Provider/detail URL, the discovery candidate is closed as acquired and its acquisition trace is created/linked if missing.
- This repaired the stale CDU VCIHAS queue without another scraper call.

### CF-181 — active runtime statistics
- Admin `detail_ready` and `needs_review` summary metrics now count only `status=discovered` candidates.
- Historical acquired/superseded classifications remain auditable but no longer inflate executable queue statistics.

## Runtime result

Before review, the Admin summary reported 78 detail-ready records while the actual pending set was smaller. Direct inspection found 39 discovered/detail-ready rows:
- 31 already Evidence-backed/canonical and reusable;
- 6 external Think Swiss observations requiring review;
- 2 duplicate CDU VCIHAS observations.

After CF-176–181:
- active discovered/detail-ready queue: **0**;
- acquired candidates: **80**;
- discovered/needs-review candidates: **612**;
- total discovery inventory: **1,162**;
- canonical Scholarships: **221**, all international;
- automatically published: **0**.

The CDU VCIHAS detail already had a first-party source record, Evidence and canonical unpublished root. It was linked rather than fetched again.

## Safety

- No automatic publication is introduced.
- No Provider/Course eligibility is manufactured.
- Search/Website/Zoho projection is unchanged.
- Existing Evidence is preferred over repeat scraping.
- CF-102 Provider Logo architecture is untouched.

## Source reconciliation

Pilot migration:

`supabase/migrations/20260905001000_cf_176_181_scholarship_queue_truth_reuse_stats.sql`
