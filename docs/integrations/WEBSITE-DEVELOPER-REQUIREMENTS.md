# StudySearch – Website developer requirements register

**Version:** 1.1 (14 Oct 2026, platform release v2.15.276, O1 done)
**Change control:** CF-247 · **Decisions:** 257 (website API v2), 258 (institution type)
**Owner:** Platform Admin. **Who updates it:** any chat that changes the website API or the data behind it, in the same change-control entry.
**Developer document:** `docs/integrations/coursefinder-wix-api-handover-v2.md` (Version 2; the Word copy beside it is what the developer receives).
**How it works now:** `docs/platform/SYSTEM-REFERENCE.md` §4b (website API v2) and §4c (institution type).

This page is the single list of what the website developer has asked for, what the platform returns today, and what is still open. Start here before changing anything the website reads.

## Rules for any change the website reads

1. **Additive only.** `website-search-v2` keeps every field, filter and action it has. New fields and filters are added; nothing is renamed or removed. A breaking change needs a new contract (Version 3) and a Platform Admin decision.
2. **The provider Published switch is the control.** A provider switched off or archived is not returned by any action, with its courses, campuses and scholarships (`security.provider_hidden_v1`).
3. **Nothing is inferred.** null means not held. No defaults, no estimates, no currency conversion.
4. **Guard and record.** Every replaced website function is md5-guarded in its migration. `tests/uat/cf-247-website-api-v2-contract.spec.mjs` and `cf-247-institution-type-contract.spec.mjs` must pass.
5. **Reissue the developer document** for any change the developer can see: Version 2, same file, new date and a line in section 21 (change log). Update this register and System reference §4b in the same entry.
6. Keep repository names, commit hashes and internal tools out of the developer document.

## Requests and status

Sources: the website team's requests of 15 September and 1 October 2026, and later follow-ups.

| # | Request | Status | Where it is returned |
|---|---|---|---|
| R1 | One API for Course Finder, University Finder and Scholarship Finder | **Done** (8 Oct) | `website-search-v2`, 8 actions, same endpoint and key |
| R2 | Course search filters: keyword, country, state, city, study level, study area, intake month, English test and score, tuition range, regional category, university group, has scholarship | **Done** | `search` (handover 13.1) |
| R3 | Course fields: official link, intakes, English, tuition with its basis, campuses, scholarships | **Done**; coverage grows as data is admitted. New Zealand and Canada gained campuses, study area, duration and delivery on 14 Oct (O1) | `search`, `course` (13.2, 13.3); coverage in section 14 |
| R4 | A code to show visitors for every course | **Done** (14 Oct) | `display_code`, `display_code_kind`, `display_code_label`; `course` accepts it |
| R5 | Canada searchable | **Done** (8 Oct) | `country_codes` CA |
| R6 | University Finder: filters, rankings, logos | **Done**; display of rankings and logos waits for management's usage-terms decision | `providers`, `provider`, `rankings` (13.4, 13.6, 13.7); `terms_status` |
| R7 | Scholarship Finder with the website's field names | **Done**; `reference_code` is null (national registers no longer used) | `scholarships`, `scholarship` (13.5) |
| R8 | Provider statistics (QILT) | **Done** (14 Oct), provider grain only, Australia only | `outcomes` on `provider` and `course` detail |
| R9 | Institution type (university, TAFE, college) | **Done** (14 Oct) for Australia and New Zealand; Canada null | `institution_type {code, name, basis}`; filter `institution_types`; list in `reference` |
| R10 | Unpublished providers and courses must not reach the website | **Done** | Provider Published switch (rule 2) |
| R11 | Logo dark variant, brand colour | **Not held** | null |
| R12 | Academic entry requirements, specialisations | **Not held** | not returned |
| R13 | Average tuition per provider | **Not returned by decision** (no sound basis) | — |
| R14 | Website prototype table shapes | **Not provided by decision**; the website maps v2 fields once | — |

## Open work (for the build chat)

| # | Item | Why it matters | Notes |
|---|---|---|---|
| O1 | ~~Recheck campus coverage for New Zealand and Canada in the API~~ **Done 14 Oct (v2.15.276, migration 20261014090000)** | Measured through the API: courses with a campus NZ 2,603, Canada 2,332 (with a city 1,928 and 1,807). Found and fixed on the way (Platform Admin decisions "Clear unproven NZ, keep CA" and "Refresh + delivery fix"): New Zealand campuses had taken the provider's head-office region (132 cleared; kept where the campus is in the provider's city); the search projection had not been refreshed, so study area, level and delivery from Enrich fields were not reaching the API (now NZ study area 6,053, delivery 3,868; Canada 4,601 and 3,204) | Handover section 14, the campus sentence and the 13.1 delivery note updated; reissued with a change-log line |
| O2 | Institution type for Canada | Canada is null (Platform Admin chose to leave it empty on 14 Oct) | Needs a Platform Admin decision on the source (for example IRCC DLI list and provincial registers) before any build |
| O3 | training.gov.au (national VET register) | Would confirm RTO status for Australian VET providers | Legacy web services need credentials; Platform Admin chose to ship without it |
| O4 | Five Australian providers have no institution type; Aviation Australia and Canning College are typed TAFE / Polytechnic | Visible to the website as null or as TAFE | Platform Admin to review; set by hand on Providers › Type, or change the rules on Settings › Pipeline settings |
| O5 | Rankings and logos usage terms | The developer must not display them until management decides | No build; `terms_status` changes when decided |
| O6 | Filtered search timings | Institution type filter about 2.3 s cold (about 1.6 s without it) | Watch; optimise only if the developer reports slowness |
| O7 | Duration quality | Two New Zealand durations were read from fee lines ("fee displayed is for 1 year of study"); 294 New Zealand and Canadian durations are stated in semesters, so `duration_months` is null for them | Platform Admin to decide: undo the two values (and tighten the duration quote rule as was done for international), and whether semesters stay null |

## History

| Version | Date | Change |
|---|---|---|
| 1.1 | 14 Oct 2026 | O1 done: New Zealand and Canadian campuses and Enrich fields values in the API, New Zealand campus regions only where proven; O7 added (duration quality). |
| 1.0 | 14 Oct 2026 | First issue: rules, requests R1–R14 with status, open work O1–O6 (after v2.15.276 institution type). |
