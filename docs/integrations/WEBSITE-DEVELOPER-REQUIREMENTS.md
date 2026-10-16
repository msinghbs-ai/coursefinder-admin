# StudySearch – Website developer requirements register

**Version:** 1.9 (15 Oct 2026; faster full load: sync pages up to 200; guide issue 2 with expectations)
**Change control:** CF-247 · **Decisions:** 257 (website API v2), 258 (institution type)
**Owner:** Platform Admin. **Who updates it:** any chat that changes the website API or the data behind it, in the same change-control entry.
**Developer document:** `docs/integrations/developer-pack/StudySearch-Website-API-v2-Developer-Guide.md` (the master; Word, PDF, OpenAPI and Postman files beside it are what the developer receives, rebuilt with `build.sh`). The Version 2 handover (`coursefinder-wix-api-handover-v2.md`) is now the internal history and long-form reference as at 14 Oct 2026; it is no longer sent.
**How it works now:** `docs/platform/SYSTEM-REFERENCE.md` §4b (website API v2) and §4c (institution type).

This page is the single list of what the website developer has asked for, what the platform returns today, and what is still open. Start here before changing anything the website reads.

## Rules for any change the website reads

1. **Additive only.** `website-search-v2` keeps every field, filter and action it has. New fields and filters are added; nothing is renamed or removed. A breaking change needs a new contract (Version 3) and a Platform Admin decision.
2. **The provider Published switch is the control.** A provider switched off or archived is not returned by any action, with its courses, campuses and scholarships (`security.provider_hidden_v1`).
3. **Nothing is inferred.** null means not held. No defaults, no estimates, no currency conversion.
4. **Guard and record.** Every replaced website function is md5-guarded in its migration. `tests/uat/cf-247-website-api-v2-contract.spec.mjs` and `cf-247-institution-type-contract.spec.mjs` must pass.
5. **Reissue the developer pack** for any change the developer can see: edit the guide master, add a line to its section 13 (Changes to this guide), update `gen_api.py` if a field, filter or action changed, run `build.sh`, and check every example live. Update this register and System reference §4b in the same entry.
6. Keep repository names, commit hashes, internal tools and keys out of the developer pack. Keys go to the developer by a secure channel only.

## Requests and status

Sources: the website team's requests of 15 September and 1 October 2026, and later follow-ups.

| # | Request | Status | Where it is returned |
|---|---|---|---|
| R1 | One API for Course Finder, University Finder and Scholarship Finder | **Done** (8 Oct); nine actions from 14 Oct (sync added) | `website-search-v2`, same endpoint and key |
| R2 | Course search filters: keyword, country, state, city, study level, study area, intake month, English test and score, tuition range, regional category, university group, has scholarship | **Done** | `search` (handover 13.1) |
| R3 | Course fields: official link, intakes, English, tuition with its basis, campuses, scholarships | **Done**; coverage grows as data is admitted. New Zealand and Canada gained campuses, study area, duration and delivery on 14 Oct (O1) | `search`, `course` (13.2, 13.3); coverage in section 14 |
| R4 | A code to show visitors for every course | **Done** (14 Oct) | `display_code`, `display_code_kind`, `display_code_label`; `course` accepts it |
| R5 | Canada searchable | **Done** (8 Oct) | `country_codes` CA |
| R6 | University Finder: filters, rankings, logos | **Done**; rankings and logos **approved for display** (Platform Admin, 14 Oct 2026; `terms_status` approved, from Settings › Pipeline settings › Website API) | `providers`, `provider`, `rankings` (13.4, 13.6, 13.7) |
| R7 | Scholarship Finder with the website's field names | **Done**; `reference_code` is null (national registers no longer used) | `scholarships`, `scholarship` (13.5) |
| R8 | Provider statistics (QILT) | **Done** (14 Oct), provider grain only, Australia only | `outcomes` on `provider` and `course` detail |
| R9 | Institution type (university, TAFE, college) | **Done** (14 Oct) for Australia and New Zealand; Canada null | `institution_type {code, name, basis}`; filter `institution_types`; list in `reference` |
| R10 | Unpublished providers and courses must not reach the website | **Done** | Provider Published switch (rule 2) |
| R11 | Logo dark variant, brand colour | **Not held** | null |
| R12 | Academic entry requirements, specialisations | **Not held** | not returned |
| R13 | Average tuition per provider | **Not returned by decision** (no sound basis) | — |
| R14 | Website prototype table shapes | **Not provided by decision**; the website maps v2 fields once | — |
| R15 | Logos as file links Wix can store, with the longest practical validity (Platform Admin, 14 Oct 2026) | **Done** (14 Oct): signed links valid 365 days (`website.logo_link_days`), resent in the sync delta 30 days before they end | `logo.url`, `url_expires_at` (13.7); Step B2 |
| R16 | After a full load, later calls return only what changed, unless a full load is asked for (Platform Admin, 14 Oct 2026) | **Done** (14 Oct): action `sync` with a cursor; full load in pages, then new, changed and removed items | `sync` (13.8); acceptance tests 12a, 12b |
| R17 | A clean developer pack to send to the developers (Platform Admin, 15 Oct 2026) | **Done** (15 Oct): developer guide (Word, PDF), OpenAPI 3.1 file and Postman collection with no key; a separate developer key (`coursefinder_website_developer_pilot_v1`, own rate limit, v2 only), handed to the Platform Admin once | `docs/integrations/developer-pack/` |

## One path for the website (Platform Admin, 15 Oct 2026: "API first, platform after")

Website API v2 is the only path the website should use. From 16 Oct 2026 it has its own address, `website-api-v2` (own key, no contract field, every call logged; Platform Admin 11:43: "build the Website v2 URL as parallel without disturbing api v2 through v1 url with contract"). These are **marked for retirement once the developer is live on the new address**; nothing is removed now:

| Path | What it is | Retire when |
|---|---|---|
| `wix-course-api` without a contract (contract `wix-cache-v1`: sync_courses, reference_bundle, lookup, search, scholarships) | The first Wix path; answers the Wix key only | The website runs on v2 in Production and v1 calls have been zero for 14 days |
| Edge function `website-course-api` (contract `website-integration-v3.1-pilot`) | An earlier website path | Same; the usage audit showed no calls |
| `wix-course-api` with contract `website-search-v2` | The same answers as `website-api-v2` (same database functions), through the old address and key; not logged on Operations › API usage | The developer has moved to `website-api-v2` and the switch-off date is agreed |

Removal is a separate change: a paste file for the Platform Admin, never an applied migration.

## Open work (for the build chat)

| # | Item | Why it matters | Notes |
|---|---|---|---|
| O1 | ~~Recheck campus coverage for New Zealand and Canada in the API~~ **Done 14 Oct (v2.15.276, migration 20261014090000)** | Measured through the API: courses with a campus NZ 2,603, Canada 2,332 (with a city 1,928 and 1,807). Found and fixed on the way (Platform Admin decisions "Clear unproven NZ, keep CA" and "Refresh + delivery fix"): New Zealand campuses had taken the provider's head-office region (132 cleared; kept where the campus is in the provider's city); the search projection had not been refreshed, so study area, level and delivery from Enrich fields were not reaching the API (now NZ study area 6,053, delivery 3,868; Canada 4,601 and 3,204) | Handover section 14, the campus sentence and the 13.1 delivery note updated; reissued with a change-log line |
| O2 | Institution type for Canada — **Parked: pending data-enrichment task PE-1** (left empty, Platform Admin 14 Oct 20:39) | Canada is null (Platform Admin chose to leave it empty on 14 Oct) | Needs a Platform Admin decision on the source (for example IRCC DLI list and provincial registers) before any build |
| O3 | training.gov.au (national VET register) — **Parked: pending data-enrichment task PE-2** (left empty, Platform Admin 14 Oct 20:39) | Would confirm RTO status for Australian VET providers | Legacy web services need credentials; Platform Admin chose to ship without it |
| O4 | Five Australian providers have no institution type; Aviation Australia and Canning College are typed TAFE / Polytechnic — **Parked: pending data-enrichment task PE-3** (left empty, Platform Admin 14 Oct 20:39) | Visible to the website as null or as TAFE | Platform Admin to review; set by hand on Providers › Type, or change the rules on Settings › Pipeline settings |
| O5 | ~~Rankings and logos usage terms~~ **Done 14 Oct (v2.15.277)**: Platform Admin decision "Yes, approved to display" | Closed PE-4 | `terms_status` approved for rankings and logos; changed by a Yes/No setting with a reason |
| O6 | Filtered search timings | Institution type filter about 2.3 s cold (about 1.6 s without it). `reference` passed the 8 s limit under load (5.5–6.6 s): fixed 15 Oct with a copy rebuilt every 15 minutes | Watch; optimise only if the developer reports slowness |
| O8 | Provider detail is slow (about 0.5 s, up to 2.3 s in a sync page) | It builds the providers list to answer for one provider; sync pages hold 3 provider details so a page stays under the limit | Follow-up: build the provider detail directly by id; then raise the page back up |
| O7 | ~~Duration quality~~ **Done 14 Oct (migration 20261014100000, worker v0.23.2)** | Platform Admin decisions: "Undo and tighten rule" and "Keep null". The two New Zealand durations read from a fee line are withdrawn (items kept, reversible); the Enrich fields worker no longer admits a duration quote about the fee basis; 294 semester durations stay null in `duration_months` | Handover reissued: section 14 NZ duration 2,929, known data-quality line, change-log line |

## History

| Version | Date | Change |
|---|---|---|
| 2.0 | 16 Oct 2026 | Website API v2 at its own address, `website-api-v2` (Pilot PR #544, migration 20261016050000): its own key `website_developer_v2`, 300 calls a minute per key (setting `website.rate_per_minute`), every call logged on Operations › API usage; same nine actions and answers as the contract path, which is unchanged. Developer guide issue 3 (address, no contract field, `api_version`, error `message` and `detail`; figures re-measured) |
| 1.9 | 15 Oct 2026 | Faster Wix full load (Platform Admin 17:46, "Prepared items + bigger pages"): `sync` serves items stored by the change check; pages up to 200 items and about 550 KB; full load about 250 calls, about 5 minutes (was 1,426 calls, about 25 minutes). Guide issue 2: 6.1 what to expect, 6.2 what we expect from the sync job (Platform Admin 18:37); OpenAPI and Postman regenerated. |
| 1.8 | 15 Oct 2026 | Platform Admin 17:24: "Wix consumer developer Dont need to know fixes on the platform ... only detials about api changes from last version." Rule: the developer guide's section 13 lists API changes only (new field, filter, action or behaviour) against the previous issue; platform fixes and data corrections are not described to the developer; measured figures (section 8, examples, acceptance counts) are refreshed with each issue. Guide reissued: section 13 holds the first-issue line only; section 8 re-measured (15 Oct 2026). |
| 1.7 | 15 Oct 2026 | Developer pack refreshed and reissued (Platform Admin 17:02). Found while re-measuring: `reference` listed Sydney under Brisbane; each city now takes the metro area most of its campuses have, and two campuses with a wrong register state take the state their address names (migration 20261015090000). Acceptance counts refreshed (course example 78; providers with a logo 265 and rising). Contract unchanged. |
| 1.6 | 15 Oct 2026 | Bug fix (Platform Admin 12:31): Canadian courses with no campus take the provider's province in `subdivision_codes` (setting `search.region_from_provider_countries`, CA); intake months no longer repeated (guard on the table). Developer guide reissued with a change line. |
| 1.5 | 15 Oct 2026 | Developer pack (R17): guide, OpenAPI, Postman, developer key; rule 5 now reissues the pack; v1 and `website-course-api` marked for retirement; O6 note, O8 added. |
| 1.4 | 14 Oct 2026 | v2.15.277: R15 logo links 365 days, R16 sync action with cursor, R6 rankings and logos approved for display; O5 closed (PE-4). |
| 1.3 | 14 Oct 2026 | O2–O5 parked as pending data-enrichment tasks PE-1 to PE-4 (`docs/platform/FIELD-GAPS-AND-ENRICHMENT-PLAN.md` section 10); values stay empty until attended. |
| 1.2 | 14 Oct 2026 | O7 done: two fee-line durations withdrawn, worker rule tightened, semesters stay null. |
| 1.1 | 14 Oct 2026 | O1 done: New Zealand and Canadian campuses and Enrich fields values in the API, New Zealand campus regions only where proven; O7 added (duration quality). |
| 1.0 | 14 Oct 2026 | First issue: rules, requests R1–R14 with status, open work O1–O6 (after v2.15.276 institution type). |
