# Handover note: provider campus names and course counts (R23), scholarship nationality status (R24)

**Version:** handover note 1.1 for developer guide **issue 8** (1.0: 9 Nov 2026 release candidate; 1.1: formal authorisation recorded, Issue 8 final).
**Status (9 Nov 2026 19:18 AEDT): G3 formally authorised by the Platform Admin; release in progress; not yet released, not yet sent.** Record: approval package `../../platform/approvals/2026-11-06-g3-r23-r24-approval-package.md` §9 and §11.1. Pilot release PR: #945 (with the approval-setting step in PR #948). The release day and the verification at release are added when the change is live.
**Audience:** the website developer. Zoho's provider list and scholarship passthrough return the changed items: see section 7, the Zoho developer note.
**Guide:** `../developer-pack/drafts/issue-8/StudySearch-Website-API-v2-Developer-Guide-Issue-8.md` (final; Word and PDF beside it): §7.4, §7.5, §9, acceptance tests 25 and 26, and the §13 line. Cover emails (ready to send): `2026-11-09-R23-R24-cover-email-wix-developer.md` and `2026-11-09-R23-R24-cover-email-zoho-developer.md`. The developer-facing summary is `../developer-pack/drafts/issue-8/HANDOVER-NOTE.md`.

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
- Key campuses by `campus_id`, never by position: `campuses[0]` is a different campus from before for 283 providers, and the order is now campus name, then `campus_id`.
- Show `campus_name` as printed; where it is null show the city only. Hide a campus with `course_count` 0 if the page lists courses by campus. Do not add up the counts to get a provider's course count.
- Show the scholarship status as in guide §7.5 (`restricted`: the codes, or "restrictions apply"; `unknown` and `under_review`: "check the scholarship page"; `unrestricted`: "open to all nationalities"). `unrestricted` is not produced yet.

## 3. Compatibility assessment

| Check | Result |
|---|---|
| Existing keys, types and values of `campuses[]` | Unchanged for every campus item. With the three new keys removed, the distinct items are exactly the items returned before (live sample of 57 providers: 0 differ; fixture: all cases) |
| Number and order of `campuses[]` items | **Can grow, and the order changes.** More items per provider because campuses are no longer merged by city (University of Auckland 1 to 9, RMIT 5 to 6, George Brown College 1 to 4). The order was the database's own sort order; it is now campus name, then `campus_id`. Measured 9 Nov 2026: for 489 of 1,620 providers the array differs at some position (258 return more items, 231 the same campuses in a new order); for 283 the first item is a different campus. A client must key by `campus_id` and must not rely on `campuses[0]`. Measured 9 Nov 2026: Australia 3,074 to 3,525, New Zealand 170 to 221, Canada 52 to 67 (3,296 to 3,813 in all; 258 of 1,402 providers with a campus return more items). A consumer that keyed campuses by city sees more items; a consumer that ignores unknown keys and reads `city` keeps working |
| Existing keys, types and values of scholarship items | Unchanged (live sample: 91 built items byte-identical apart from the new key; fixture: 13 cases and the wrappers) |
| `citizenship_eligibility`, `eligible_countries_list`, filter `nationality_codes` | Unchanged. Region codes (`R-*`) keep their meaning |
| Course `campuses[]` (search, course detail) | Unchanged (decision P3) |
| Endpoints, actions, filters, identifiers, errors | Unchanged. No edge function file changes |
| Search, rankings, logos, tuition, entry | Unchanged |
| Breaking change | None for a client that ignores unknown keys (acceptance test 18). The item count change above is the one behaviour to read |
| Zoho | **Affected** (corrected 9 Nov 2026 after independent QA, twice). `zoho_v2_providers` (the provider list) passes the website `campuses[]` items through, so the item count, the order and the three new keys change there (489 of 1,620 providers, about 3 in 10). **The Zoho provider sync items change too:** `security.zoho_v2_provider_item_v1` builds each from `pipeline.website_sync_items`, which includes `campuses[]` (live 9 Nov 2026: 1,279 Zoho provider sync items, 1,278 with a non-empty `campuses[]`); after the release the website pass re-hashes them and `zoho_sync_check_v1` emits about 1,278 Zoho provider sync items once more (about 5.1 MB plus about 0.6 MB), with `campuses[]` changed in count, order and the three keys. `zoho_v2_passthrough` `scholarships` and `scholarship` return the new `nationality_eligibility_status` key. Not affected: `zoho_v2_provider` (provider detail; it replaces `campuses` with its own list; 10 samples byte-identical), `zoho_edge_*`, the Zoho course functions and the edge functions. See the Zoho developer note (section 7) |
| Sync | The next `sync` deltas carry the changed providers (about 1,402, those that hold a campus) and every scholarship (about 1,144) once more: about 22 MB uncompressed in all (about 6 MB providers, 16 MB scholarships, measured as stored item text on 9 Nov 2026; gzip cuts it to roughly a seventh). No cursor reset, no full load |
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

At release (to be recorded here by the Integration Controller): migration applied and md5s; `consumer_api_check_v1` shows no drift; `provider:nzqa:7001` returns 9 campuses and `provider:cricos:00122a` 6; representative scholarship statuses; one `sync` delta; the developer's acceptance tests 25 and 26 (test 27, ranking history, already works).

## 6. Not validated yet

The migration has not been applied to any live database. The developer's side (Wix read-back, display) has not been seen. The course coverage table in guide §8 is as at 31 Oct 2026.

## 7. Zoho developer note (to send to the Zoho developer before the release)

What changes for Zoho when R23 and R24 are released. In plain terms:

1. **Provider list** (`providers`, the Zoho v2 provider list). Each provider's `campuses[]` now has one item per campus. Before, campuses in the same city were joined into one item with no name. Each item also gains three keys: `campus_id`, `campus_name` and `course_count`. The existing keys keep their values. The number of items and their order change for 489 of 1,620 providers (about 3 in 10). If a Zoho mapping reads the first campus or counts campuses, please check it, and key campuses by `campus_id`.
2. **Scholarships** (`scholarships` and `scholarship` through the Zoho v2 passthrough). Each item gains one key, `nationality_eligibility_status`: `restricted`, `unrestricted`, `unknown` or `under_review`. `unknown` means nothing is held; it does not mean open to all nationalities. The existing keys (including `citizenship_eligibility`) are unchanged.
3. **Provider sync items** (the Zoho sync feed). Each provider sync item carries the same `campuses[]`, so the provider items change in count, order and the three new keys. After the release the feed sends about 1,278 provider items once more (about 5.7 MB). Direct calls change on the release day; the sync feed picks the changes up over roughly 1.5 hours of rolling passes.
4. **Not changed:** provider detail (it already returns its own campus list), the Zoho course search and detail, and the `zoho_edge_*` functions.

Nothing needs to change for Zoho to keep working if it ignores keys it does not know, but a mapping that reads the first campus or counts campuses, in the list or in the sync feed, must be checked. The release day is in the cover email (`2026-11-09-R23-R24-cover-email-zoho-developer.md`). Status: **drafted, not yet sent** (release precondition C, approval package section 9.2).

## 8. Formal G3 authorisation (recorded 9 Nov 2026 19:18 AEDT)

| Field | Value |
|---|---|
| Authorised by | Platform Admin (Mandeep Singh) |
| Date and time | 9 Nov 2026 19:18 AEDT, in chat |
| Words | "I approve the Website API R23/R24 consumer contract change in #945, including the documented campus-array content and ordering changes for 489 providers. Record this as formal G3 authorisation. Complete Wix Issue 8, the versioned developer handover, Zoho notification, final QA and live checks. Apply the required approval setting through the authorised, audited mechanism, then merge and deploy if all release gates pass."  |
| Scope | The R23/R24 consumer contract change in Pilot PR #945, including the documented `campuses[]` content and ordering changes for 489 providers (258 return more items, 231 the same campuses in a new order). Course `campuses[]` (P3) and the nationality reader improvement (P4) are not part of it |
| Approval line (first line of migration `20261109160000`) | `-- Consumer API change approved: Platform Admin (Mandeep Singh), 9 Nov 2026 19:18 AEDT, in chat: formal G3 authorisation of Website API v2 R23 and R24 including the documented campus-array content and ordering changes for 489 providers` |
| Approval setting | Defined at 0 by migration `20261109155000` (PR #948); changed to 1 on Settings > Pipeline settings with a reason by the Platform Admin route (audited in `pipeline.admin_control_events`); migration `20261109160000` then applies |
| Developer communication | Wix cover email and Zoho cover email drafted, to be sent by the Integration Controller or Mandeep; not sent by the author |
