# G3 approval package — Website API v2 R23 (campus names and course counts) and R24 (scholarship nationality status)

**Status (9 Nov 2026 19:18 AEDT): G3 FORMALLY AUTHORISED by the Platform Admin (section 9 and 11.1). Release in progress: not yet merged, applied or deployed. The release steps in section 11.4 are followed by the Integration Controller.**

The first version of this package (5 Nov 2026) is kept below as written, with the migration number updated (`20261106100000` became `20261109150000`, then `20261109160000` on 9 Nov 2026 17:50 because the AER selector fix took `20261109160000` and is applied live). Section 9 is completed with the formal authorisation of 9 Nov 2026 19:18 AEDT; section 10 is overtaken by the approval record in section 11.

| | |
|---|---|
| Change control | CF-247 |
| Rules | G3 (Decision 266: the consumer API is frozen); Decisions 257 and 258 (Website API v2 is additive only) |
| Request | Website developer feedback of 5 Nov 2026, as recorded in Platform Admin decision 5 Nov 2026 19:14 §5 (`docs/platform/2026-11-05-centralise-development-claude-parallel-agents-1914.md`) |
| Design | Proposal of 3 Nov 2026 (`docs/platform/nz-enrichment-brief/2026-11-03-website-api-v2-change-proposal.md` §2 and §3), under mandate 3 Nov 2026 11:46 |
| Prepared by | Agent A (Developer API), 5 Nov 2026, for the Integration Controller |
| Pilot | Draft PR #890 on branch `cf247-devapi-r23-r24` (the first version), superseded by the release candidate: draft PR #945 on branch `cf247-devapi-r23-r24-release` (9 Nov 2026). First version: Migration `supabase/migrations/20261109160000_cf247_website_api_v2_r23_r24.sql`. Spec `tests/uat/cf-247-website-api-v2-r23-r24-contract.spec.mjs`. Fixture `tests/fixtures/website-api-v2-r23-r24/`. CI workflow `website-api-v2-r23-r24-fixture.yml` |
| Supersedes | The prepared, unmerged branch `cf247-website-api-v2-campus-nationality` (migration `20261103180000`, never opened as a PR and never applied). It carries the same design, re-based on main `cf77ef78` and checked again against live |
| Evidence | Live project `fxcwkweaxjtknorudmwp`, read-only SELECT and EXPLAIN ANALYZE only, 5 Nov 2026 19:18–20:08 AEDT. Heavy reads ran only in the allowed minutes. MCP session search_path: `"$user", public, extensions` (not changed) |

## 1. What is asked for

The developer confirms that the Wix integration works. They ask for two additions:

- **R23: campus names and course counts.** Add the approved-design provider campus fields `campus_id`, `campus_name` and `course_count`.
- **R24: scholarship nationality status.** Add the values `restricted`, `unrestricted`, `unknown` and `under_review`.

Every existing response field stays as it is. The only changes are the additions proposed here.

## 2. Exact before and after response shape

### 2.1 R23: provider `campuses[]`

This applies to the actions `providers` and `provider` and to `sync` provider items. All three use the same builder.

| | Before (live, Issue 7) | After (proposed, Issue 8) |
|---|---|---|
| Item keys | `city`, `postcode`, `subdivision_code`, `metro_area`, `regional_category`, `regional_category_name` | Same six keys with the same values, **plus** `campus_id` (string), `campus_name` (string or null), `course_count` (integer ≥ 0) |
| Items | Campuses that share city, postcode, state and regional class are merged into one item (`jsonb_agg(distinct …)`) | One item per campus, keyed by its stable identity (`catalogue.campuses.stable_key`). Campuses are never merged by city or postcode |
| Which campuses | A city is held and the campus is not `inactive` | Unchanged |
| Order | Not guaranteed | By `campus_name` (blank names last), then `campus_id` |
| Empty | `[]` | `[]` |

Field contract:

| Field | Type | Meaning |
|---|---|---|
| `campus_id` | string | The campus's stable key, for example `campus:cricos:00122a:point-cook-campus-raaf-williams-base`. It never changes for a campus |
| `campus_name` | string or null | The stored campus name. It is `null` when the name is blank (null means not held). On 5 Nov 2026, 0 of the 3,812 returned campuses had a blank name |
| `course_count` | integer ≥ 0 | Distinct courses the API returns that are linked to this campus. A course is counted when it is in `search.course_documents` for this provider and is not in `security.layer4_search_blocked_courses`. That view covers Layer 4 search blocks, providers whose Published switch is off or which are not active, and courses that are not active. Course search (`website_v2_course_search`) uses the same exclusion. A course offered at three campuses counts once at each. A course linked to one campus in two delivery modes counts once. `0` is a real value: the campus is held, but no returned course is linked to it |

Exact example (live, 5 Nov 2026): University of Auckland, `provider:nzqa:7001`. The provider has 458 returned courses.

Before:

```json
"campuses": [ { "city": "Auckland", "postcode": null, "metro_area": null, "subdivision_code": "NZ-AUK", "regional_category": null, "regional_category_name": null } ]
```

After (9 items; the first three are shown here):

```json
"campuses": [
  { "city": "Auckland", "postcode": null, "campus_id": "campus:studysearch:e096aba7-e1eb-4903-9a63-2bfb71e9a8b8:auckland-city", "metro_area": null, "campus_name": "Auckland / City", "course_count": 2, "subdivision_code": "NZ-AUK", "regional_category": null, "regional_category_name": null },
  { "city": "Auckland", "postcode": null, "campus_id": "campus:studysearch:e096aba7-e1eb-4903-9a63-2bfb71e9a8b8:city", "metro_area": null, "campus_name": "City", "course_count": 53, "subdivision_code": "NZ-AUK", "regional_category": null, "regional_category_name": null },
  { "city": "Auckland", "postcode": null, "campus_id": "campus:studysearch:e096aba7-e1eb-4903-9a63-2bfb71e9a8b8:city-campus", "metro_area": null, "campus_name": "City Campus", "course_count": 219, "subdivision_code": "NZ-AUK", "regional_category": null, "regional_category_name": null }
]
```

RMIT University (`provider:cricos:00122a`, 507 returned courses) goes from 5 items to 6. Melbourne becomes two campuses: "RMIT University - 124 Latrobe Street, Melbourne" (438) and "Melbourne Cricket Education Academy - 124 La Trobe St MELBOURNE VIC 3000" (1). The other four campuses are Brunswick 30, Bundoora 112, Bendigo 3 and Point Cook 6. The developer pack draft has full before and after examples (`docs/integrations/developer-pack/drafts/issue-8/examples/`).

### 2.2 R24: scholarships

This applies to the `scholarships` list items, the `scholarship` detail item and `sync` scholarship items. All three use the same builder.

| | Before | After |
|---|---|---|
| Keys | Every existing key | Every existing key, unchanged, **plus** `nationality_eligibility_status` (string, always present) |
| `citizenship_eligibility`, `eligible_countries_list` | Codes as held; region codes `R-*` keep their region meaning | Unchanged |
| Filter `nationality_codes` | Matches the nationality reading | Unchanged |

Derivation. Every input is data the platform already holds about scholarship eligibility, and none of it is invented. The first rule that applies wins:

| Value | Rule | Source (existing) |
|---|---|---|
| `under_review` | A **pending** Layer 4 item on who the scholarship is for. That is a `pipeline.layer4_review_items` row with `entity_type = 'scholarship'`, `status = 'pending'` and `field_code` in `nationalities`, `nationality`, `citizenship_eligibility`, `audience` or `student_type`. It also applies when a **pending** scholarship AI review (`pipeline.scholarship_ai_reviews`) has the reason "who it is for is not proven by a quote on the page" | Layer 4 queue and AI review queue |
| `restricted` | Any one of three cases: (a) the list the API returns (`citizenship_eligibility`, taken from `scholarship.nationality_readings.codes` and falling back to the codes of the active criteria) names at least one country or region code; (b) an active `scholarship.criteria` row of type `nationality` or `citizenship_and_residency` names codes (its quote is in `human_text`) although the list is still empty; (c) the API's own `student_type` is `domestic` (domestic students only) | Nationality reader `scholarship-nationality-v1`, extracted criteria and student-type criteria (shown on the Admin "Eligibility and award" panel, `ScholarshipEligibility`) |
| `unrestricted` | No code is held, and the nationality reading holds an explicit "any nationality" phrase (key `ANY` in `phrases`) | Nationality reading |
| `unknown` | Otherwise: nothing on nationality is held. **An empty list is never read as unrestricted.** "Open to international students" sets `student_type` and leaves nationality `unknown` | — |

Exact examples (live, 5 Nov 2026):

| Scholarship | Before (unchanged) | After adds |
|---|---|---|
| Faculty of Engineering Research Scholarship for South Asia (The University of Sydney) | `"citizenship_eligibility": ["R-SASIA"], "eligible_countries_list": ["R-SASIA"], "student_type": "international"` | `"nationality_eligibility_status": "restricted"` |
| University of Auckland China High Achievers Scholarship | `["CN"]`, `["CN"]`, `"international"` | `"restricted"` |
| UTS Southeast Asia International Scholarship | `[]`, `[]`, `"international"` (criterion names ID, KH, LA, MM, MY, PH, SG, TH, TL, VN) | `"restricted"` (the list stays `[]`) |
| University of Auckland MBChB Graduate Entry - International Student Scholarship | `[]`, `[]`, `"international"` | `"unknown"` |

## 3. Live measures (5 Nov 2026, read-only)

**R23: every provider the API returns (1,620).** The proposed body was evaluated inline beside the live function. Nothing was replaced.

| Country | Providers | Items before → after | Providers with more items | Existing values changed | Σ course_count | Campuses with count 0 | Names null | Campus count above the provider's course_count |
|---|---|---|---|---|---|---|---|---|
| AU | 1,279 | 3,074 → 3,525 | 230 | 0 | 43,336 | 2 | 0 | 0 |
| NZ | 289 | 169 → 220 | 20 | 0 | 2,903 | 46 | 0 | 0 |
| CA | 52 | 52 → 67 | 8 | 0 | 1,689 | 13 | 0 | 0 |
| **All** | **1,620** | **3,295 → 3,812** | **258** | **0** | **47,928** | **61** | **0** | **0** |

"Existing values changed 0" means the following for every provider. Take the new items, remove the three new keys, and the set of distinct items is exactly the set returned today.

Provider campus JSON across all providers grows from 560 KB to 1,186 KB, about 0.6 MB more on a full `sync` load.

Search documents that a campus count would exclude: 0 held back by Layer 4 or a hidden provider, and 0 inactive (of 34,042). On live data, therefore, the campus count uses the same course set as the provider's `course_count`.

**R24: published, returned scholarships (1,151).**

| Status | All | AU | NZ | CA | Notes |
|---|---|---|---|---|---|
| `restricted` | 95 | 83 | 10 | 2 | 16 with the list still empty (restricted by an extracted criterion); 14 name a region code |
| `unknown` | 1,056 | 835 | 152 | 69 | All with an empty list |
| `unrestricted` | 0 | 0 | 0 | 0 | No reader writes "any nationality" evidence yet (proposal §3.5, decision P4) |
| `under_review` | 0 | 0 | 0 | 0 | No pending Layer 4 item on a scholarship. There are 19 pending AI reviews with the reason "who it is for", none of them on a returned scholarship |
| Domestic only | 0 | | | | The rule is in place |

## 4. Affected objects

| Object | Change | Live md5 before (5 Nov 2026) | md5 after (fixture: PostgreSQL 16 locally; CI repeats on 17.6) |
|---|---|---|---|
| `api.website_v2_provider_campuses(uuid)` | Whole replacement, md5-guarded | `57115d3b8ddbc40729ec04078ee15d41` | `698afad0bc236a314fb356632938c403` |
| `api.website_v2_scholarship_item(uuid)` | One md5-guarded edit (one key inserted after the two lists) | `d1792cc7161101ce8c22abad70ecbd36` | `04532402307717c6dab17567551364e1` |
| `public.website_v2_providers`, `public.website_v2_provider` (through `website_v2_providers`), `public.website_v2_scholarships`, `public.website_v2_scholarship`, `public.website_v2_sync` (stored items) | None. They embed the builder output as it is. The migration pins the first, third and fourth: `73ba533ee2f4c20b840c4cf172c17912`, `b3a616d8ec31a86ffa3e770cf24db0af`, `79131c22331c7439438177517bd1ba12` | unchanged | unchanged |
| Read and pinned, not changed | `security.place_presentable(text)` `a7b720fc9b34203d0a23315376fd483a`. Views `security.layer4_search_blocked_courses` `35cdaa19a775ffaaf60fc2be302affec`, `security.layer4_active_blocks` `300ac7ca5fe9b72b13e2647a861ea8c6` and `security.provider_hidden_v1` `c8e2c132cc6fa8a52dccdbb04317707b` | | |
| Edge functions `website-api-v2`, `wix-course-api` (and the other three) | None. They pass the payload through. Live hashes match `tests/uat/consumer-api-baseline.json` (`a833301f…`, `c7e1182b…`) | | |
| Internal readers of the scholarship builder (`security.scholarship_coverage_items_v1`, `security.har_sch_value_verify_v1`) | None. They only test `is not null`, so an extra key changes nothing | | |
| Zoho (corrected 9 Nov 2026 after independent QA, twice; the first version of this row was wrong) | **Affected.** `public.zoho_v2_providers` (provider list) calls `website_v2_providers` and passes `campuses[]` through: the item count, order and the three new keys change (489 of 1,620 providers, about 3 in 10). **The Zoho provider sync items change too:** `security.zoho_v2_provider_item_v1` builds each from `pipeline.website_sync_items`, which includes `campuses[]` (live 9 Nov 2026: `pipeline.zoho_sync_items` holds 1,279 provider items, AU only, 1,278 with a non-empty `campuses[]`; RMIT `00122a`: 5 campuses in both, identical arrays today). After the release the website pass re-hashes the website items and `zoho_sync_check_v1` re-emits about 1,278 Zoho provider sync items (about 5.1 MB plus about 0.6 MB) whose `campuses[]` change in count, order and the three keys. `public.zoho_v2_passthrough` actions `scholarships` and `scholarship` call `website_v2_scholarships` and `website_v2_scholarship`: the new `nationality_eligibility_status` key appears. Not affected: `public.zoho_v2_provider` (detail; it removes `campuses` and returns its own list; 10 samples byte-identical), `zoho_edge_*`, the Zoho course functions and the Zoho edge functions. The change is additive for Zoho too. See the Zoho developer note in the handover (§7) | | |
| Grants | Unchanged. `CREATE OR REPLACE` keeps `postgres=X/postgres` on both builders (checked in the fixture) | | |

Not changed (decision P3): course search and detail `campuses[]`. The course item builder also feeds Zoho.

## 5. Edge function baseline

No edge function file changes, so the five hashes in `tests/uat/consumer-api-baseline.json` stay as they are. G3 asks for the baseline file to be updated with an approved consumer change. The branch therefore carries the prepared file `tests/fixtures/website-api-v2-r23-r24/consumer-api-baseline.on-approval.json`. It has the same five hashes, and its note adds one sentence (marked "PREPARED, NOT APPLIED") that records the change and its approval. On approval, the Controller copies it over `tests/uat/consumer-api-baseline.json` and fills in the date and time. The spec checks that its hashes equal the current baseline. The database baseline (`pipeline.consumer_api_baseline`) is re-taken by `security.consumer_api_rebaseline_v1` in the migration, but only after approval (§9).

## 6. Risk

| Risk | Assessment | Mitigation |
|---|---|---|
| A consumer that keyed campuses by city now sees more items (258 providers) | The shape is additive and the values are unchanged. A city filter still works on `city` | Guide Issue 8 §7.4 tells the developer to key by `campus_id`. The developer asked for this behaviour |
| Wix collection churn | Next sync: about 1,402 provider upserts (providers that hold a campus) and 1,144 scholarship upserts once; about 22 MB uncompressed (about 6 MB providers, 16 MB scholarships; the QA estimate of 9 to 12 MB is too low because scholarship items average 14 KB). No cursor reset and no full load | Guide §9 sync guidance; gzip |
| Order of `campuses[]` changes | Before: the database's own order, undocumented. After: campus name, then `campus_id`. For 489 of 1,620 providers the array differs at some position (AU 454, NZ 25, CA 10): 258 gain items and 231 are reordered with the same items; for 283 the first item is a different campus (measured 9 Nov 2026, live, read-only). A client that reads `campuses[0]` could show a different campus | Guide §7.4 and §13 say so; key by `campus_id`. Examples: Auckland 1 to 9, RMIT 5 to 6, George Brown 1 to 4 |
| Zoho provider list, Zoho provider sync items and scholarship passthrough output changes | See the §4 Zoho row. Additive keys; the item count and order of `campuses[]` change | Zoho developer note (handover §7) sent before the release (precondition C) |
| Database time | Live, the 50 Australian providers with the most campuses: about 3.5 ms each today, about 11 ms each with R23 (560 ms for all 50, EXPLAIN ANALYZE). The anti-join alternative was slower live (650 ms), so the per-link form was kept. Scholarship item: live today 8.6 ms per item (1,151 items in 9.85 s, EXPLAIN ANALYZE); the status adds indexed EXISTS checks, +0.07 to +0.15 ms per item in the fixture (under 2%), and the same checks across all 1,151 scholarships take 12.7 ms on live | A `providers` page of 50 of the largest providers gains about 0.4 s of database time; a typical page under 0.1 s |
| Live definition drifts before deploy | The migration refuses and changes nothing | md5 guards on 2 changed and 7 pinned objects |
| Status semantics misread (`unknown` read as "open to all") | Documented in the guide and the handover note | `unrestricted` needs explicit evidence |
| `unrestricted` is never produced today | True: 0 until the nationality reader writes "any nationality" evidence (P4) | Documented, not a defect |
| The nightly `consumer-api-guard` raises drift | It would if the functions changed without a re-baseline | The re-baseline sits in the same migration, after approval |

## 7. Rollback and forward recovery

- **Before deploy:** nothing to undo. While the line says PENDING, the build fails (s57), and the migration refuses to apply on any database without the approval setting.
- **After deploy (forward recovery):** a migration restores the two "before" definitions and re-takes the baseline with the reason. The texts are byte-exact in `tests/fixtures/website-api-v2-r23-r24/live/website_v2_provider_campuses.sql` and `live/website_v2_scholarship_item.sql`. The restore uses `replace_once` with before = the after md5s in §4 and after = the before md5s. Wix keeps working because unknown keys are ignored. Extra campus items remain in Wix until the next sync sends the merged form again.
- Nothing is dropped, deleted or renamed in either direction.

## 8. Test evidence (Pilot branch `cf247-devapi-r23-r24`)

| Test | Result (5 Nov 2026) |
|---|---|
| Production parity. The fixture database equals live for 45 relations: columns, constraints, foreign keys inside the fixture, indexes, triggers, row level security, grants and view text, by per-relation fingerprint (`check-live-parity.sql` against `parity-live-2026-11-05.txt`). It also equals live for 18 functions (md5 and privileges, `functions-live.tsv`). The live trigger that publishes active providers is loaded with its live body | PASS |
| The migration refuses without the approval setting and changes nothing. With approval it applies both guarded changes and the after md5s match. A second run reports already applied and changes nothing. Privileges are unchanged | PASS |
| R23 cases: same-city campuses kept apart; a course in two delivery modes counted once; not in search documents, Layer 4 search block, block then unblock, withdrawn course, another provider's course, and Published switch off (provider hidden) all handled; blank name gives null; no-city and inactive campuses excluded as before; existing values equal for every provider | PASS |
| R24 cases (13): country, region (kept as `R-SASIA`), domestic only, criteria only with an empty list, explicit any, pending Layer 4 on audience and on nationalities (precedence over restricted), pending AI "who it is for" review, unrelated or closed reviews ignored, withdrawn criterion, hidden provider, unpublished (null). Every other field byte-identical (`jsonb::text`) | PASS |
| End to end as `service_role`, the edge function's role. `website_v2_providers` (2 requests): every key except `campuses` byte-identical, and campuses as above. `website_v2_scholarships` (2 requests, including `nationality_codes`) and `website_v2_scholarship` (14 ids, including not found): byte-identical apart from `nationality_eligibility_status`. A provider with Published off is not returned. `service_role` cannot call either builder directly | PASS |
| Specs run locally (new R23/R24 contract 6 tests, s32, s42, s57, s120, website-api-v2 contract, institution-type contract) | 39 passed, 1 failed (the s57 test below) |
| s57 (G3) | **FAILS, as intended:** "20261109160000_cf247_website_api_v2_r23_r24.sql touches a consumer API function". s57 now treats a `PENDING` approval line as no approval (new test). It will pass only when the Platform Admin's approval line replaces the placeholder |
| Live (read-only) whole-population checks and benchmarks | §3 and §6 |
| CI | Workflow `website-api-v2-r23-r24-fixture.yml` runs the fixture on PostgreSQL 17.6 (the live version). The full suite runs in PR CI, where s57 fails until approval |

## 9. What the Platform Admin is asked to approve, and the exact approval line

Decisions:

- **P1 (R23):** approve the additive `campus_id`, `campus_name` and `course_count` on provider `campuses[]`, with one item per campus (no merging by city or postcode) and items ordered by campus name. Yes / No.
- **P2 (R24):** approve the additive `nationality_eligibility_status` with the four values and the derivation in §2.2. Yes / No.
- **P3:** course search and detail `campuses[]`. Recommended: decide later. Unchanged here.
- **P4:** the nationality reader improvement, as separate platform work. It is what makes `unrestricted` and `under_review` meaningful.

Approval line, as recorded on the first line of migration `20261109160000_cf247_website_api_v2_r23_r24.sql` (done 9 Nov 2026; the template in the 5 Nov version of this section is replaced):

```
-- Consumer API change approved: Platform Admin (Mandeep Singh), 9 Nov 2026 19:18 AEDT, in chat: formal G3 authorisation of Website API v2 R23 and R24 including the documented campus-array content and ordering changes for 489 providers
```

On approval, the Controller also:

1. Replaces the migration's closing comment with `select security.consumer_api_rebaseline_v1('R23/R24 (decision 5 Nov 2026 19:14 §5): additive provider campus fields and nationality_eligibility_status; approved Platform Admin <date time>');`.
2. Copies `consumer-api-baseline.on-approval.json` over `tests/uat/consumer-api-baseline.json`, filling in the date and time.
3. (Replaced 9 Nov 2026: two steps.) The gate setting is **defined at 0** by migration `20261109155000_cf247_r23_r24_approval_setting.sql` (Pilot PR #948; it appears on Settings › Pipeline settings, section Website API), and the Platform Admin route then **changes it to 1 with a reason** (below). The 5 Nov paste, kept for the record only, inserted the row at 1:

```sql
insert into pipeline.platform_toolset_settings(toolset_key, key, label, kind, value, min_value, max_value, unit, section, used_by, help, reason)
values ('pipeline', 'api.v2_r23_r24_approved', 'Website API v2 R23/R24 consumer change: approved', 'number', '1', 0, 1, 'flag', 'Website API',
        'migration 20261109160000 (G3 approval gate)', '1 = the Platform Admin approved R23/R24 (approval package §9). The migration refuses to apply otherwise.',
        '<Platform Admin approval, date time>');
```

4. Re-reads the live md5s in §4, which must still be the "before" values. Runs the full suite. Deploys through the release. Verifies representative payloads and Wix read-back. Issues developer guide Issue 8 from the draft.

| Field | Value |
|---|---|
| Approved by | Platform Admin (Mandeep Singh) |
| Date and time | 9 Nov 2026 19:18 AEDT, in chat (formal G3 authorisation) |
| Decisions | P1 ☒ P2 ☒ P3 ☐ (not decided: unchanged) P4 ☐ (not decided: separate platform work). P1 includes the documented `campuses[]` content and ordering changes for 489 providers |
| Conditions | None further. Instruction: complete Wix Issue 8, the versioned developer handover, Zoho notification, final QA and live checks; apply the approval setting through the authorised, audited mechanism; then merge and deploy if all release gates pass |
| Words | "I approve the Website API R23/R24 consumer contract change in #945, including the documented campus-array content and ordering changes for 489 providers. Record this as formal G3 authorisation. Complete Wix Issue 8, the versioned developer handover, Zoho notification, final QA and live checks. Apply the required approval setting through the authorised, audited mechanism, then merge and deploy if all release gates pass." |
| Release version | The release number is set at integration (no release number before integration) |

### 9.1 Dated record lines (templates; each is completed when the event happens, with the time of day)

```
- 9 Nov 2026 19:18 AEDT: Platform Admin formal G3 authorisation (P1 and P2) recorded: Mandeep Singh, in chat, no further conditions; approval line on migration `20261109160000`; recorded in section 11.1 and the handover section 8
- <dd Mon yyyy hh:mm AEDT>: Issue 8 and cover email (`docs/integrations/handover/2026-11-09-R23-R24-cover-email-wix-developer.md`) sent to the Wix developer with the release day <dd Mon yyyy>; acknowledgement received <dd Mon yyyy hh:mm AEDT> from <name>, <channel>
- <dd Mon yyyy hh:mm AEDT>: Zoho developer note (`docs/integrations/handover/2026-11-09-R23-R24-cover-email-zoho-developer.md`) sent to <name>, <channel>
- <dd Mon yyyy hh:mm AEDT>: migration `20261109155000` applied (setting defined at 0) by <release>
- <dd Mon yyyy hh:mm AEDT>: Platform Admin changed api.v2_r23_r24_approved from 0 to 1 on Settings › Pipeline settings (Website API), by <who>; reason quotes the 9 Nov 2026 19:18 AEDT authorisation; the event is in `pipeline.admin_control_events` (target `pipeline.api.v2_r23_r24_approved`)
- <dd Mon yyyy hh:mm AEDT>: release PR merged by <who>; md5 re-check <result>; newest migration <number>; migration applied <hh:mm AEDT>
- <dd Mon yyyy hh:mm AEDT>: consumer_api_check_v1 = no drift; payloads checked (section 11.4 step 5); guide Issue 8 issued
```

The approval of 9 Nov 2026 is recorded in §11.1 (in principle, earlier on 9 Nov) and in the table above (formal authorisation, 19:18 AEDT). Record the other lines in this section (or in the handover's release record) as they happen; the time of day is part of the record.

### 9.2 Release preconditions

The release PR must not be merged until all four hold:

- **A. The developer has the release candidate.** Issue 8 RC (guide, OpenAPI, Postman, examples, handover note) has been sent to the Wix developer with a release date, and the developer's acknowledgement is recorded (dated line above).
- **B. The approval setting is 1 before the migration applies, in two steps.** (1) Pilot PR #948 (migration `20261109155000`) defines `api.v2_r23_r24_approved` at 0 and is merged and applied first. (2) The Platform Admin route changes it to 1 on Settings › Pipeline settings (Website API) with a reason that quotes the 19:18 AEDT authorisation; that write is audited in `pipeline.admin_control_events`. Only then does the release PR (#945) merge. If #945 applies while the value is 0 (or the row is missing), the migration stops at step 0 and, because migrations apply in order, blocks every later migration. The author does not write the value.
- **C. The Zoho note has been sent.** The Zoho developer note (handover §7) has been sent to the Zoho developer.
- **D. At merge:** re-check the md5 guards of the nine objects in §4 against live (they must still be the "before" values), re-check that the newest migration on main and live is still before `20261109160000` and that `20261109160000` is free (renumber if not), then follow §11.4.

## 10. Open questions for the Platform Admin

1. **The developer's 5 Nov feedback text is not in the admin repo.** Only the summary in decision 19:14 §5 is held, so the field names were taken from the 3 Nov design. Please file the original message, or confirm that the summary is complete.
2. **The R24 field name.** Decision 19:14 §5 lists the four values but not the key. The prepared key is `nationality_eligibility_status`, as written in mandate 3 Nov 2026 11:46 §3. Please confirm.
3. **Behaviour within R23.** One item per campus (258 providers return more items) and the order by campus name were proposed on 3 Nov but are not yet approved. P1 covers both. Please confirm them explicitly.
4. **The count rule.** `course_count` uses the course-search exclusion (`layer4_search_blocked_courses`). The provider's own `course_count` does not exclude course-level Layer 4 blocks. Today both count the same courses (0 search documents differ), but the two rules could diverge if a course-level search block is ever held on a course that still has a search document. Please confirm that the course-search rule is the intended one.
5. **Campus data quality (not an API matter).** Some New Zealand campuses look like the same campus held twice ("City" / "City Campus" / "Auckland / City"; "Grafton" / "Grafton Campus"). They have different stable keys and are returned as held. The fix belongs to the governed campus identity process, not to the API.

---

# 11. Approval record, compatibility evidence and release steps (9 Nov 2026)

Added 9 Nov 2026 by the author of Pilot draft PR #945 (release candidate), for the QA agent and the Integration Controller. Sections 1 to 10 above are the 5 Nov version, kept as the record of what was asked and measured then.

## 11.1 Approval record

**Formal authorisation (9 Nov 2026 19:18 AEDT, in chat), recorded by the author of the release PRs:** Platform Admin (Mandeep Singh): "I approve the Website API R23/R24 consumer contract change in #945, including the documented campus-array content and ordering changes for 489 providers. Record this as formal G3 authorisation. Complete Wix Issue 8, the versioned developer handover, Zoho notification, final QA and live checks. Apply the required approval setting through the authorised, audited mechanism, then merge and deploy if all release gates pass." This supersedes the "in principle" wording below for the approval line and the migration's first line; the earlier record is kept as written.

Earlier record (9 Nov 2026, before 19:18):

| Field | Value |
|---|---|
| Approved by | Platform Admin (Mandeep Singh) |
| Date and time | 9 Nov 2026, in chat (the time of day was not part of the instruction given to the author) |
| Words | "G3 change is approved in principle. Complete the required API compatibility tests, developer guide, versioned handover and record the formal G3 approval before merging. Do not release an unvalidated consumer contract change." |
| Decisions | P1 (R23) approved as written in §2.1. P2 (R24) approved as written in §2.2. P3 (course `campuses[]`) not decided: unchanged. P4 (nationality reader improvement) not decided: separate platform work |
| Conditions | 1. API compatibility tests. 2. Developer guide (Issue 8). 3. Versioned handover. 4. The formal G3 approval recorded before merging. 5. No release of an unvalidated consumer contract change |
| Release version | Set at release |

The approval line now recorded on the first line of migration `20261109160000_cf247_website_api_v2_r23_r24.sql` (Pilot PR #945; it replaced the conditional line `...9 Nov 2026, in chat: G3 change approved for R23 and R24 on condition of API compatibility tests, developer guide and versioned handover`):

```
-- Consumer API change approved: Platform Admin (Mandeep Singh), 9 Nov 2026 19:18 AEDT, in chat: formal G3 authorisation of Website API v2 R23 and R24 including the documented campus-array content and ordering changes for 489 providers
```

Points the Platform Admin did not answer separately, and how the release treats them. The formal authorisation of 19:18 AEDT approves the change as documented (this includes the `campuses[]` content and ordering changes for 489 providers), so §10 questions 2 to 4 are treated as confirmed by it; question 1 stays open:

- §10 question 1 (the developer's original 5 Nov message is not in the repository): still open. The field names come from the 3 Nov design.
- §10 questions 2 to 4 (key name `nationality_eligibility_status`; one item per campus and the order by campus name; the `course_count` rule): built as written in §2. They are the behaviour that was approved in principle.
- §10 question 5 (possible duplicate New Zealand campuses): a data matter, not an API one. Returned as held.

## 11.2 What the release candidate changes from the 5 Nov version

| Change | Why |
|---|---|
| Migration renumbered `20261106100000` to `20261109160000` | Newest on live is `20261109150000` (the AER selector fix, applied 9 Nov 2026; it took the number first, and the first renumbering to `20261109160000` was superseded) |
| First line is the formal authorisation above (was PENDING, then the conditional line) | `s57` reads this line |
| The approval setting is defined at 0 by its own migration `20261109155000` (Pilot PR #948), and the Platform Admin route changes it to 1 | A migration must not approve itself, and the Platform Admin approves through the audited Settings route. Release steps in 11.4 |
| The gate message no longer says "PENDING". The gate itself is unchanged: setting `api.v2_r23_r24_approved` must be 1 | The value 1 is a Platform Admin write on Settings (the fixture's `approval-setting.sql` stands in for it); a migration must not approve itself. A missing setting, or 0, makes the migration refuse |
| The setting uses unit `on (1) / off (0)` (the package said `flag`), range 0 to 1, section Website API, sort 307 | That is how other on/off settings are shown on Settings › Pipeline settings |
| The migration re-takes the consumer baseline (`security.consumer_api_rebaseline_v1`) as its last step, after refusing if any consumer API function other than the two approved ones differs from the baseline | The guard function can only be called by a migration. Re-taking over an unrelated difference would hide it. Same pattern as the D4, D5 and D6 migrations |
| `consumer-api-baseline.on-approval.json` removed; `tests/uat/consumer-api-baseline.json` not changed | No edge function file changes, so none of the five edge hashes changes |
| Fixture re-checked against live on 9 Nov 2026 | See 11.3 |
| Compatibility tests extended | See 11.3 |

## 11.3 Compatibility evidence

### A. Fixture re-check against live (9 Nov 2026, read-only catalogue lookups, 17:11 to 17:20 AEDT)

| Check | Result |
|---|---|
| Live md5 of the two functions to change and the seven pinned objects | All nine equal the guards in the migration (campuses `57115d3b…`, scholarship item `d1792cc7…`, `place_presentable` `a7b720fc…`, the three wrappers, the three views) |
| 18 functions of the fixture (md5 and privileges) | All equal `functions-live.tsv` |
| 45 relations (fingerprint) | 44 equal. **One drift: `catalogue.providers` has a new index `providers_site_host_active_idx` (an expression index on `security.site_host_v1(website)`)**, added after 5 Nov. It does not touch anything the two builders read. The fixture now carries the index and the live function (`live/site_host_v1.sql`, md5 `04938c20…`), and the reference file is `parity-live-2026-11-09.txt`. The fixture holds 45 relations and 19 functions equal to live |
| Newest migration on live / on main | `20261109140000` / `20261109140000` |
| Setting `api.v2_r23_r24_approved` on live | Does not exist (as expected) |

### B. Isolated PostgreSQL fixture (PostgreSQL 16 locally; CI repeats on 17.6)

`bash tests/fixtures/website-api-v2-r23-r24/run.sh` passes. It proves, in order:

1. Parity with live (A above).
2. The migration refuses without the approval setting and changes nothing.
3. With the approval paste as written (`approval-setting.sql`), an unrelated consumer function that differs from the baseline makes the migration refuse, and nothing changes. After that difference is undone, the migration applies both guarded changes; the after md5s are `698afad0…` (campuses) and `04532402…` (scholarship item); privileges are unchanged.
4. The baseline is re-taken: the two functions hold the new md5s, no other consumer function differs from it, and the guard method finds no difference.
5. A second run reports already applied and changes nothing.
6. Every R23 case and every R24 case (13), the end-to-end wrapper calls as `service_role` (every key byte-identical apart from the new ones), and the benchmark.

### C. Live comparison in rolled-back transactions (9 Nov 2026)

The migration text (header comments removed) and the approval paste were run as one multi-statement request on the live project, after capturing the current output of the builders and the wrappers for a bounded sample into temporary tables, and ended by an unconditional error that carries the report, so nothing could commit. After the runs, live still showed the current md5s, no `api.v2_r23_r24_approved` row, and the baseline unchanged (last taken 31 Oct 2026, no R23/R24 rows).

Run 2 (successful report, about 17:25 AEDT; run 1 about 17:24 stopped at a report-formatting error after the migration steps had passed, and was also rolled back):

| Check | Result |
|---|---|
| md5 before / after (inside the transaction) | campuses `57115d3b…` to `698afad0…`; scholarship item `d1792cc7…` to `04532402…`. Both guards passed on live |
| R23, 57 providers (the 40 with most campuses, the 3 named examples, 16 spread by hash) | Items 980 before, 1,190 after. For every provider the new items with the three new keys removed are exactly (as text) the distinct items returned before: 0 providers differ. Every item has the 9 keys; `campus_id` text, `campus_name` text or null, `course_count` number. `campus_name` null 0 of 1,190; `course_count` 0 on 31 items |
| R24, 112 scholarships (40 with codes, 30 criteria-only, review queues, 60 hashed) | 21 are not built (not published): the same as before. For the 91 built: the item minus `nationality_eligibility_status` is byte-identical (`jsonb::text`) to the current output for every one; statuses `unknown` 57, `restricted` 34 (none in the sample is `under_review` or `unrestricted`: live has none today). No `unknown` or `unrestricted` item has a non-empty list |
| Wrappers, live | `website_v2_provider`: 3 providers (Auckland, RMIT, Adelaide University) identical outside `campuses`; Auckland 1 to 9 items, RMIT 5 to 6, Adelaide University 9 to 9. `website_v2_scholarship`: 6 scholarships identical apart from the new key. 0 differences |
| The approval paste on live | Accepted by the table constraints and the trigger; `security.pipeline_num_v1('api.v2_r23_r24_approved', 0)` reads 1 afterwards |
| The baseline step on live | No consumer function other than the two differs from the baseline (the check passed), and after the re-take there are 0 differences |

Run 3 (about 17:45 AEDT, same method, bounded to the providers the API returns): the figures behind the developer guide, measured with the new builders inside the rolled-back transaction. The approval paste, both guards and the other-drift check passed again before the report.

| Measure (9 Nov 2026) | Australia | New Zealand | Canada | Total |
|---|---|---|---|---|
| Providers the API returns (active, published, with courses) | 1,279 | 289 | 52 | 1,620 |
| of which with at least one campus | 1,278 | 95 | 29 | 1,402 |
| `campuses[]` items before (merged by city) | 3,074 | 170 | 52 | 3,296 |
| `campuses[]` items after (one per campus) | 3,525 | 221 | 67 | 3,813 |
| Providers that return more items | 230 | 20 | 8 | 258 |
| Items with `course_count` 0 | 2 | 46 | 13 | 61 |
| Items with `campus_name` null | 0 | 0 | 0 | 0 |
| Sum of `course_count` (a course at several campuses counts at each) | 43,336 | 2,906 | 1,688 | 47,930 |
| Scholarships returned | 911 | 162 | 71 | 1,144 |
| `nationality_eligibility_status` `restricted` | 80 | 10 | 2 | 92 |
| `unknown` | 831 | 152 | 69 | 1,052 |
| `unrestricted`, `under_review` | 0 | 0 | 0 | 0 |

- Search documents: 34,041; none held back by Layer 4 or a hidden provider today.
- `restricted` with an empty list: 16 (all Australia). `restricted` naming a region: 13 (Australia 12, New Zealand 1). No scholarship is `domestic` only. Every `unknown` item has an empty list.
- The scholarships returned fell from 1,151 (5 Nov) to 1,144: the change adds one key and does not choose which scholarships are returned (in the sample, the built and not built scholarships were the same before and after).
- Named examples (current output compared with new output in the same transaction): `provider:nzqa:7001` 1 to 9 items; `provider:cricos:00122a` 5 to 6; `provider:ca:ircc_dli:o19283850612` 1 to 4. Scholarship examples: South Asia research scholarship `restricted` (list `R-SASIA`), China High Achievers `restricted` (`CN`), UTS Southeast Asia `restricted` (list empty), MBChB graduate entry `unknown`. For all four, the item minus the new key is identical to the current item.
- After the run, live again showed the current md5s and no approval row: nothing was committed.

**Run 4 (9 Nov 2026, 18:27 and 18:46 AEDT, inside the `:x6` to `:x8` window; read-only, nothing written)** after the independent QA. All figures come from the live data with the new builder evaluated beside the live one:

| Measure | Result |
|---|---|
| Order of `campuses[]` (all 1,620 returned providers; the new items minus the three new keys against the old array) | Differs at some position for 489 (AU 454, NZ 25, CA 10): 258 gain items, 231 have the same items in a new order. First item differs for 283. The set of distinct items is identical for all 1,620 (0 differ) |
| Sync stored items, live (excluding removed) | 38,327: courses 34,041, providers 1,620, scholarships 1,144, logos 1,465, ranking sets 56, reference 1. Stored text 108 MB (courses 83.9 MB, scholarships 16.2 MB, providers 5.9 MB, rankings 1.1 MB, logos 0.8 MB) |
| Delta after the release | About 1,402 providers (those holding a campus, about 5.1 MB now plus about 0.6 MB of new campus JSON) and 1,144 scholarships (16.2 MB): about 22 MB uncompressed. Higher than the QA estimate of 9 to 12 MB because each scholarship item is about 14 KB |
| Guide figures re-measured through the same wrappers | Logos 1,465 (was 1,463); AU universities 45; Go8 8; QS 2027 AU 38; search example 35; nursing Melbourne 107; courses AU 23,732, NZ 6,495, CA 3,814; `provider:cricos:00025b` 48 QILT rows. Not re-measured (dated in the guide): QILT 116 providers, ranking coverage 72/77 providers, the section 8 coverage table |
| Live guards re-read 9 Nov 2026 about 18:15 | Both builders at their "before" md5s, the three wrappers, `place_presentable` and the three views as in §4; newest migration on live `20261109150000`, so `20261109160000` is free; no `api.v2_r23_r24_approved` row |

### D. Tests in the Pilot candidate (all run with `npx playwright test --project=chromium-desktop`)

| Spec | What it proves |
|---|---|
| `cf-247-website-api-v2-r23-r24-contract.spec.mjs` (7 tests) | Approval line exact and not PENDING; gate before any change; baseline re-taken once, last, after the other-drift check; md5 guards; R23 and R24 definitions; the fixture's proofs are present; no edge change; the approval paste carries label, range, unit and `used_by` |
| `cf-247-website-api-v2-contract.spec.mjs` (+3 tests) | Additive only: every existing key and its value expression kept, exactly three new campus keys; the scholarship change is a pure insertion of one key; the migration replaces or edits two builders and no wrapper, edge function, table or view |
| `cf-247-institution-type-contract.spec.mjs` (+1 test) | Institution type is untouched |
| `cf-247-s57-consumer-api-frozen.spec.mjs` | G3: the approval line is accepted; a PENDING placeholder is not |
| `s32` (G2), `s42` (housekeeping), `s120` (G4) | Pass |

### E. What has not been validated

- **Nothing has run against a deployed system.** The migration has not been applied to any database. The compatibility evidence is the isolated fixture and the rolled-back live runs.
- **The edge functions were not re-hashed against live in this session.** No file changes (the five hashes in `tests/uat/consumer-api-baseline.json` are untouched, `s57` passes); the `website-api-v2` source read from live passes the database answer through unchanged apart from signing logos. The nightly `consumer-api-guard` and `edge-drift-check` are the live checks.
- **Zoho was mis-stated twice.** The first version said "not affected". The second (after QA) said the Zoho sync items were unaffected; that was wrong too: `security.zoho_v2_provider_item_v1` builds the Zoho provider sync items from the website sync items, which include `campuses[]` (see the §4 Zoho row). The §4 row, the handover, the migration header comment and the Zoho developer note are corrected; the Zoho developer has not yet been sent the note. The Zoho sync feed was not called; the effect is read from the live function definitions and counts of 9 Nov 2026.
- **Wix read-back and the website developer's acceptance tests 25 and 26** (and 27, ranking history, which already works) can only run after the release.
- **The live sample is bounded** (57 providers, 112 scholarships, 3 provider details, 6 scholarship details). The whole-population figures in 11.3 C use set-based reads and the builder under the load policy, not a comparison of every provider.
- **The course coverage table in guide section 8 (courses holding a value, 31 Oct 2026) was not refreshed.** Its queries are not held in the repository and were not reproduced.
- **Load policy.** The two rolled-back runs above started at about 17:24 and 17:25, outside the `:x6` to `:x8` window for heavy reads (each ran for a few seconds and called the builders about 220 times). `cron.job_run_details` showed no failed job in the previous nine minutes.

## 11.4 Release steps (for the Integration Controller; none has been done)

1. QA agent verification of Pilot draft PR #945 and the admin draft PR; Integration Controller decision to merge. The author does not merge.
2. **Release preconditions A to D in §9.2 hold, and the approval is given in two steps.** (a) Merge Pilot PR #948 (migration `20261109155000`, the setting defined at 0) and let the release apply it. (b) Verify the row exists at 0: Settings › Pipeline settings › Website API › "Website API v2 R23/R24 consumer change: approved" (0 to 1, "on (1) / off (0)"). (c) The Platform Admin route changes the value to 1 on that page, with a reason that quotes the 9 Nov 2026 19:18 AEDT authorisation (Save is enabled once a reason of four or more characters is typed; the change is kept in `pipeline.admin_control_events`). (d) Verify the page shows 1. Only then merge Pilot PR #945. Without (c) the migration stops at step 0 and, because migrations apply in order, blocks every later migration.
3. Immediately before applying, re-read the live md5s listed in §4 (they must still be the "before" values) and the newest migration number; if main has gained a later migration, keep this one in order. `20261109155000` and `20261109160000` were free on main and in live `schema_migrations` on 9 Nov 2026 (newest live `20261109150000`).
4. Apply through the release. The migration re-takes the consumer baseline itself as its last step (`security.consumer_api_rebaseline_v1`, only a migration can call it). **Do not re-take the baseline by hand before or after.** Verify afterwards that `select security.consumer_api_check_v1()` returns no drift and that the `consumer-api-guard` hard flag is not raised on its next daily run.
5. Verify representative payloads against §2 and the guide examples: `provider:nzqa:7001` returns 9 campuses, RMIT 6, a scholarship with `R-SASIA` returns `restricted`, `unknown` where nothing is held; existing keys byte-identical; check one `sync` delta carries the provider and scholarship items.
6. Issue the developer guide: follow `docs/integrations/developer-pack/drafts/issue-8/README.md` (set the release date, remove the release-candidate banner, copy over the master, rebuild with `build.sh`, send with the handover note). Update this register (R23 and R24 to Done) and System reference §4b in the same entry.
7. Forward recovery as §7, with the migration number `20261109160000`.
