# CF-CHG-20260905-156–158 — International Scholarship Scale Wave

**Status:** IMPLEMENTED / RUNTIME PASS  
**Milestone:** M2.4.5  
**Domain:** Scholarships / Layer 2 acquisition  
**Publication:** unchanged / no automatic publication

## Objective

Increase Scholarship acquisition throughput without scraping large domestic-only inventories or weakening the first-party Evidence model. Scholarship automatic firing remains restricted to international-plausible candidates; ambiguous or domestic-looking catalogue observations are parked for review.

## Scale wave

Provider-scoped Scholarship acquisition was fired through the governed Admin/runtime service for idle executable university routes rather than duplicating providers that already had active jobs.

Wave results included:

- Charles Sturt University — 19 Scholarship links written from first-party catalogue Evidence;
- Deakin University — 6 Scholarship links;
- RMIT University — 30 links observed; existing governed Scholarship candidates were retained rather than duplicated;
- Curtin University — 28 Scholarship links;
- Edith Cowan University — 18 Scholarship links;
- Charles Darwin University — 9 Scholarship links.

The catalogue wave therefore surfaced more than 80 first-party Scholarship candidate links while retaining publication=false.

## CF-156 — International-only bulk candidate gate

A deterministic pre-fire gate was applied to the new first-party catalogue inventory.

- explicit international / overseas / regional-nationality cues remain `detail_ready`;
- candidates without an explicit international eligibility cue are moved to `needs_review` before any detail scraper firing;
- no candidates are deleted;
- no eligibility is manufactured.

This is an acquisition-efficiency gate, not a publication decision.

## CF-157 — Governed detail batch dispatch

`public.scholarship_scope_job_execution_context(uuid)` now permits a Scholarship job to carry an explicit governed `profile_id` and `target_url` in its payload. Existing provider-catalogue jobs retain their original fallback behaviour.

For international-plausible detail candidates the migration creates/reuses:

- `pipeline.sources` rows of type `scholarship_detail`;
- `pipeline.layer2_source_profiles` with first-party authority;
- validated profile versions;
- normal Layer 2 acquisition-provider routes and Evidence policy;
- queued `scholarship_scope_acquisition` jobs with `international_only=true` and `publication_authorised=false`.

Runtime generated **34 bounded detail jobs across five universities**. They were dispatched in bounded waves rather than as one unbounded burst. At verification time **33 had succeeded and one ECU job remained running**, with no failed CF-157 jobs.

## CF-158 — Filter/search page guard

The larger wave exposed a classifier edge case: filtered Scholarship search URLs containing `International` in their query string could be mistaken for individual Scholarship detail pages.

CF-158 reclassifies such URLs as `catalogue_or_filter` when they match search/filter query patterns. These pages remain useful enumeration Evidence but are not individual Scholarship records and must not be sent through the detail acquisition path again.

## Provider asset / CF-102 protection

The shared provider-page fanout also observed generic SVG/icon assets on some pages. The governed CF-102 primary-logo asset remains unchanged. RMIT still resolves to its approved stored primary logo:

`providers/8e1adb6c-e069-43db-9584-bd054255e702/logo/a69ce30f74ee9b54045337b34ac23d8a3d6c1ce714ce3415cf9369719200a804.png`

Generic page-image candidates must not replace an approved primary Provider logo without the Provider Asset promotion/verification gate.

## Evidence and cost behaviour

- Catalogue acquisition reuses shared fetch/Evidence where available.
- Direct HTTP is preferred where successful; normal Layer 2 fallback routes remain available.
- Detail jobs are bounded and Evidence-first.
- Catalogue/filter pages are retained rather than repeatedly scraped as details.
- No Search/Website/Zoho publication is introduced by CF-156–158.

## Replay artefacts

Pilot migrations:

- `20260905071600_cf_156_international_only_bulk_candidate_gate.sql`
- `20260905071700_cf_157_international_scholarship_detail_batch_dispatch.sql`
- `20260905071800_cf_158_scholarship_filter_page_guard.sql`
