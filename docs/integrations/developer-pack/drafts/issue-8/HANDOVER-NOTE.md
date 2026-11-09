# StudySearch Website API v2 — Issue 8 handover note

**Version:** Issue 8, note 1.1 · **Release day:** the day it is released, announced in the cover note · **Status:** final, sent with the Issue 8 guide.

**For:** the StudySearch website developer (Wix).
**Address and key:** unchanged (`website-api-v2`, your existing key).

## What changes in Issue 8

1. **Provider campuses.** In `providers`, `provider` and `sync` provider items, `campuses[]` has one item per campus. Campuses that share a city are no longer merged into one item, so a provider can return more items (University of Auckland 1 to 9, RMIT 5 to 6, George Brown College 1 to 4), and the order of `campuses[]` changes: campus name, then `campus_id` (it was the database's own order). Key campuses by `campus_id`; do not rely on position or on `campuses[0]`. Each item keeps its six existing fields with the same values and gains `campus_id`, `campus_name` and `course_count` (guide 7.4).
2. **Scholarship nationality.** Each scholarship gains `nationality_eligibility_status`: `restricted`, `unrestricted`, `unknown` or `under_review` (guide 7.5). An empty `citizenship_eligibility` list means "not held", never "open to all".

Nothing is renamed or removed. Course `campuses[]` are unchanged. A client that ignores unknown fields keeps working; a client that reads `campuses[0]` or counts campuses must be checked.

## What to check on your side

- If you grouped a provider's campuses by city, group by `campus_id` instead. A city filter still works on `city`.
- Direct calls return the new fields from the release day. `sync` deltas pick the changes up over roughly 1.5 hours of rolling passes after the release, so a copy built from `sync` fills in during that time.
- After the release, providers and scholarships come again in the next `sync` deltas with the new fields (about 1,402 providers and 1,144 scholarships, about 22 MB uncompressed in all). No full load is needed and your cursor stays valid.
- `unrestricted` is not returned yet: it needs an explicit "any nationality" statement on the scholarship, and none is held today. Do not show "Open to all nationalities" unless you receive it.

## Your answers to the other requests

- **Ranking history:** already available. Every edition held is in the provider detail's `rankings[]`; QS 2021–2027, THE 2016–2026, subject to each institution's own history. See the sorting and missing-year example in 7.6. Adelaide University's history starts in 2026.
- **Academic entry requirements:** already available (`entry`, `entry_matrix[]`, `edu_country`, guide 7.9). Coverage grows as requirements are approved; hide the panel when nothing is held (7.9).
- **University-level costs:** not available. Show course tuition with its basis and year; link to the provider for other costs (7.8).

## What to do

1. Read sections 7.4, 7.5, 7.6, 7.8, 7.9 and 9 of the guide.
2. Plan the Wix mapping in section 9 (optional CF_Campuses collection; `nationalityStatus` on CF_Scholarships).
3. When the cover note says the release is live, run acceptance tests 25 and 26 (the new fields; test 27 checks ranking history, which already works) and send any failure with its `request_id`.

## Files

- The Issue 8 guide (Word and PDF)
- `StudySearch-Website-API-v2.openapi.json` (OpenAPI 3.1; schemas `ProviderCampus` and `NationalityEligibilityStatus`)
- `StudySearch-Website-API-v2.postman_collection.json` (set `apiKey`)
- `examples/campuses-before-after.json`, `examples/scholarship-nationality-before-after.json`
