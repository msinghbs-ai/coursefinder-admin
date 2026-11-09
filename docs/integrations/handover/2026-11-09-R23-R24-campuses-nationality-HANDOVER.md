# Handover note: provider campus names and course counts (R23), scholarship nationality status (R24)

**Version:** handover note 1.0 for developer guide **issue 8**.
**Status (9 Nov 2026): prepared, not released, not sent.** G3 approved by the Platform Admin on 9 Nov 2026 on conditions (approval package `../../platform/approvals/2026-11-06-g3-r23-r24-approval-package.md` §11). Pilot release candidate: draft PR #945. The release date and the verification at release are added when the change is live.
**Audience:** the website developer. Zoho is not affected.
**Guide:** `../developer-pack/drafts/issue-8/StudySearch-Website-API-v2-Developer-Guide-Issue-8-RC.md`: §7.4, §7.5, §9, acceptance tests 25 and 26, and the §13 line. The developer-facing summary is `../developer-pack/drafts/issue-8/HANDOVER-NOTE.md`.

## 1. What is new

| Where | New key | Type | Meaning |
|---|---|---|---|
| Provider `campuses[]` items (actions `providers`, `provider`, and `sync` provider items) | `campus_id` | string | The campus's permanent identifier; the key to store |
| | `campus_name` | string or null | The stored campus name; null when none is held |
| | `course_count` | integer, 0 or more | Courses the API returns that are linked to this campus. 0 is a real value |
| Scholarship items (actions `scholarships`, `scholarship`, and `sync` scholarship items) | `nationality_eligibility_status` | string, always present | `restricted`, `unrestricted`, `unknown` or `under_review`. `unknown` is not "open to all" |

One behaviour changes with the keys: **campuses that share a city, postcode, state and regional class are no longer merged.** Each campus is one item. The items that were returned before are still there (see 3).

## 2. How to show it

- Key a provider's campuses by `campus_id`, not by city. A `city` filter still works on `city`.
- Show `campus_name` as printed; where it is null show the city only. Hide a campus with `course_count` 0 if the page lists courses by campus. Do not add up the counts to get a provider's course count.
- Show the scholarship status as in guide §7.5 (`restricted`: the codes, or "restrictions apply"; `unknown` and `under_review`: "check the scholarship page"; `unrestricted`: "open to all nationalities"). `unrestricted` is not produced yet.

## 3. Compatibility assessment

| Check | Result |
|---|---|
| Existing keys, types and values of `campuses[]` | Unchanged for every campus item. With the three new keys removed, the distinct items are exactly the items returned before (live sample of 57 providers: 0 differ; fixture: all cases) |
| Number of `campuses[]` items | **Can grow** (more items per provider because campuses are no longer merged by city). Measured 9 Nov 2026: Australia 3,074 to 3,525, New Zealand 170 to 221, Canada 52 to 67 (3,296 to 3,813 in all; 258 of 1,402 providers with a campus return more items). A consumer that keyed campuses by city sees more items; a consumer that ignores unknown keys and reads `city` keeps working |
| Existing keys, types and values of scholarship items | Unchanged (live sample: 91 built items byte-identical apart from the new key; fixture: 13 cases and the wrappers) |
| `citizenship_eligibility`, `eligible_countries_list`, filter `nationality_codes` | Unchanged. Region codes (`R-*`) keep their meaning |
| Course `campuses[]` (search, course detail) | Unchanged (decision P3) |
| Endpoints, actions, filters, identifiers, errors | Unchanged. No edge function file changes |
| Search, rankings, logos, tuition, entry | Unchanged |
| Breaking change | None for a client that ignores unknown keys (acceptance test 18). The item count change above is the one behaviour to read |
| Zoho | Not affected: no Zoho function reads either builder |
| Sync | The next `sync` deltas carry every provider and scholarship once more (about 1,600 providers and 1,150 scholarships). No cursor reset, no full load |
| Size | Provider campus JSON grows by about 0.6 MB across all providers (measured 5 Nov 2026) |
| Null handling | A name not held is null; nothing is invented. A count of 0 is a count |

## 4. Coverage (live, 9 Nov 2026)

| Measure | Australia | New Zealand | Canada | Total |
|---|---|---|---|---|
| Campus items returned (after) | 3,525 | 221 | 67 | 3,813 |
| Items with `course_count` 0 | 2 | 46 | 13 | 61 |
| Items with `campus_name` null | 0 | 0 | 0 | 0 |
| Scholarships returned | 911 | 162 | 71 | 1,144 |
| `restricted` | 80 | 10 | 2 | 92 |
| `unknown` | 831 | 152 | 69 | 1,052 |
| `unrestricted`, `under_review` | 0 | 0 | 0 | 0 |

`unrestricted` and `under_review` are 0 today (live has no explicit "any nationality" reading and no pending review item for these fields). 16 `restricted` scholarships (all Australia) have an empty list because the restriction is held but its list is not yet read; 13 name a region. The count of scholarships returned fell from 1,151 (5 Nov) to 1,144; the change does not select scholarships.

## 5. Verification

Before release (done, 9 Nov 2026): approval package §11.3 (fixture on PostgreSQL 16 and 17.6; rolled-back live comparison of 57 providers and 112 scholarships, 3 provider and 6 scholarship details).

At release (to be recorded here by the Integration Controller): migration applied and md5s; `consumer_api_check_v1` shows no drift; `provider:nzqa:7001` returns 9 campuses and `provider:cricos:00122a` 6; representative scholarship statuses; one `sync` delta; the developer's acceptance tests 25 to 27.

## 6. Not validated yet

The migration has not been applied to any database. The developer's side (Wix read-back, display) has not been seen. The course coverage table in guide §8 is as at 31 Oct 2026.
