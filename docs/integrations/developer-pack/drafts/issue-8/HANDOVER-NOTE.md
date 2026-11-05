# StudySearch Website API v2 — Issue 8 handover note (DRAFT)

**Status: PROPOSED — not live.** Prepared 3 November 2026; revised 5 November 2026 (figures and examples re-measured). Not to be sent to the website developer until StudySearch confirms the release; the released note will carry the release date.

**For:** the StudySearch website developer (Wix).
**Address and key:** unchanged (`website-api-v2`, your existing key).

## What changes in Issue 8 (when released)

1. **Provider campuses.** In `providers`, `provider` and `sync` provider items, `campuses[]` has one item per campus. Campuses that share a city are no longer merged. Each item keeps its fields and gains `campus_id`, `campus_name` and `course_count` (guide 7.4).
2. **Scholarship nationality.** Each scholarship gains `nationality_eligibility_status`: `restricted`, `unrestricted`, `unknown` or `under_review` (guide 7.5). An empty `citizenship_eligibility` list means "not held", never "open to all".

Nothing is renamed or removed. Course `campuses[]` are unchanged.

## Your answers to the other requests

- **Ranking history:** already available. Every edition held is in the provider detail's `rankings[]`; QS 2021–2027, THE 2016–2026, subject to each institution's own history. See the sorting and missing-year example in 7.6. Adelaide University's history starts in 2026.
- **Academic entry requirements:** already available (`entry`, `entry_matrix[]`, `edu_country`, guide 7.9). Coverage grows as requirements are approved; hide the panel when nothing is held (7.9).
- **University-level costs:** not available. Show course tuition with its basis and year; link to the provider for other costs (7.8).

## What to do

1. Read sections 7.4, 7.5, 7.6, 7.8, 7.9 and 9 of the guide.
2. Plan the Wix mapping in section 9 (optional CF_Campuses collection; `nationalityStatus` on CF_Scholarships).
3. When we confirm the release: keep your sync running. Providers and scholarships come again in the following deltas with the new fields; no full load is needed.
4. Run acceptance tests 25 to 27 and send any failure with its `request_id`.

## Files

- `StudySearch-Website-API-v2-Developer-Guide-Issue-8-DRAFT.md` (guide)
- `StudySearch-Website-API-v2.openapi.json` (OpenAPI 3.1; schemas `ProviderCampus` and `NationalityEligibilityStatus`)
- `StudySearch-Website-API-v2.postman_collection.json` (set `apiKey`; three new requests)
- `examples/campuses-before-after.json`, `examples/scholarship-nationality-before-after.json`
