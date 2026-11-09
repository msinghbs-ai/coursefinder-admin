# G3 approval package — Website API v2 R23 (campus names and course counts) and R24 (scholarship nationality status)

**Status: AWAITING PLATFORM ADMIN G3 APPROVAL. Nothing is approved, merged or deployed.**

| | |
|---|---|
| Change control | CF-247 |
| Rules | G3 (Decision 266: the consumer API is frozen); Decisions 257 and 258 (Website API v2 is additive only) |
| Request | Website developer feedback of 5 Nov 2026, as recorded in Platform Admin decision 5 Nov 2026 19:14 §5 (`docs/platform/2026-11-05-centralise-development-claude-parallel-agents-1914.md`) |
| Design | Proposal of 3 Nov 2026 (`docs/platform/nz-enrichment-brief/2026-11-03-website-api-v2-change-proposal.md` §2 and §3), under mandate 3 Nov 2026 11:46 |
| Prepared by | Agent A (Developer API), 5 Nov 2026, for the Integration Controller |
| Pilot | Draft PR on branch `cf247-devapi-r23-r24`. Migration `supabase/migrations/20261106100000_cf247_website_api_v2_r23_r24.sql`. Spec `tests/uat/cf-247-website-api-v2-r23-r24-contract.spec.mjs`. Fixture `tests/fixtures/website-api-v2-r23-r24/`. CI workflow `website-api-v2-r23-r24-fixture.yml` |
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
| Zoho | Not affected. Zoho does not read provider campuses, and Zoho scholarships use their own function | | |
| Grants | Unchanged. `CREATE OR REPLACE` keeps `postgres=X/postgres` on both builders (checked in the fixture) | | |

Not changed (decision P3): course search and detail `campuses[]`. The course item builder also feeds Zoho.

## 5. Edge function baseline

No edge function file changes, so the five hashes in `tests/uat/consumer-api-baseline.json` stay as they are. G3 asks for the baseline file to be updated with an approved consumer change. The branch therefore carries the prepared file `tests/fixtures/website-api-v2-r23-r24/consumer-api-baseline.on-approval.json`. It has the same five hashes, and its note adds one sentence (marked "PREPARED, NOT APPLIED") that records the change and its approval. On approval, the Controller copies it over `tests/uat/consumer-api-baseline.json` and fills in the date and time. The spec checks that its hashes equal the current baseline. The database baseline (`pipeline.consumer_api_baseline`) is re-taken by `security.consumer_api_rebaseline_v1` in the migration, but only after approval (§9).

## 6. Risk

| Risk | Assessment | Mitigation |
|---|---|---|
| A consumer that keyed campuses by city now sees more items (258 providers) | The shape is additive and the values are unchanged. A city filter still works on `city` | Guide Issue 8 §7.4 tells the developer to key by `campus_id`. The developer asked for this behaviour |
| Wix collection churn | Next sync: about 1,620 provider upserts and 1,151 scholarship upserts once. No cursor reset and no full load | Guide §9 sync guidance |
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
| s57 (G3) | **FAILS, as intended:** "20261106100000_cf247_website_api_v2_r23_r24.sql touches a consumer API function". s57 now treats a `PENDING` approval line as no approval (new test). It will pass only when the Platform Admin's approval line replaces the placeholder |
| Live (read-only) whole-population checks and benchmarks | §3 and §6 |
| CI | Workflow `website-api-v2-r23-r24-fixture.yml` runs the fixture on PostgreSQL 17.6 (the live version). The full suite runs in PR CI, where s57 fails until approval |

## 9. What the Platform Admin is asked to approve, and the exact approval line

Decisions:

- **P1 (R23):** approve the additive `campus_id`, `campus_name` and `course_count` on provider `campuses[]`, with one item per campus (no merging by city or postcode) and items ordered by campus name. Yes / No.
- **P2 (R24):** approve the additive `nationality_eligibility_status` with the four values and the derivation in §2.2. Yes / No.
- **P3:** course search and detail `campuses[]`. Recommended: decide later. Unchanged here.
- **P4:** the nationality reader improvement, as separate platform work. It is what makes `unrestricted` and `under_review` meaningful.

Approval line. The Integration Controller replaces the migration's first line with this text, completed and signed:

```
-- Consumer API change approved: Platform Admin, <date time> (decision 5 Nov 2026 19:14 §5, developer requests R23/R24; G3 approval package admin docs/platform/approvals/2026-11-06-g3-r23-r24-approval-package.md, P1 and P2): additive campus_id, campus_name, course_count on provider campuses[] (one item per campus) and nationality_eligibility_status on scholarships; no removal, rename or retype
```

On approval, the Controller also:

1. Replaces the migration's closing comment with `select security.consumer_api_rebaseline_v1('R23/R24 (decision 5 Nov 2026 19:14 §5): additive provider campus fields and nationality_eligibility_status; approved Platform Admin <date time>');`.
2. Copies `consumer-api-baseline.on-approval.json` over `tests/uat/consumer-api-baseline.json`, filling in the date and time.
3. Has the approval paste create the gate setting (a Platform Admin write, not the migration):

```sql
insert into pipeline.platform_toolset_settings(toolset_key, key, label, kind, value, min_value, max_value, unit, section, used_by, help, reason)
values ('pipeline', 'api.v2_r23_r24_approved', 'Website API v2 R23/R24 consumer change: approved', 'number', '1', 0, 1, 'flag', 'Website API',
        'migration 20261106100000 (G3 approval gate)', '1 = the Platform Admin approved R23/R24 (approval package §9). The migration refuses to apply otherwise.',
        '<Platform Admin approval, date time>');
```

4. Re-reads the live md5s in §4, which must still be the "before" values. Runs the full suite. Deploys through the release. Verifies representative payloads and Wix read-back. Issues developer guide Issue 8 from the draft.

| Field | Value |
|---|---|
| Approved by | |
| Date and time | |
| Decisions | P1 ☐ P2 ☐ P3 ☐ P4 ☐ |
| Conditions | |
| Release version | (set at release) |

## 10. Open questions for the Platform Admin

1. **The developer's 5 Nov feedback text is not in the admin repo.** Only the summary in decision 19:14 §5 is held, so the field names were taken from the 3 Nov design. Please file the original message, or confirm that the summary is complete.
2. **The R24 field name.** Decision 19:14 §5 lists the four values but not the key. The prepared key is `nationality_eligibility_status`, as written in mandate 3 Nov 2026 11:46 §3. Please confirm.
3. **Behaviour within R23.** One item per campus (258 providers return more items) and the order by campus name were proposed on 3 Nov but are not yet approved. P1 covers both. Please confirm them explicitly.
4. **The count rule.** `course_count` uses the course-search exclusion (`layer4_search_blocked_courses`). The provider's own `course_count` does not exclude course-level Layer 4 blocks. Today both count the same courses (0 search documents differ), but the two rules could diverge if a course-level search block is ever held on a course that still has a search document. Please confirm that the course-search rule is the intended one.
5. **Campus data quality (not an API matter).** Some New Zealand campuses look like the same campus held twice ("City" / "City Campus" / "Auckland / City"; "Grafton" / "Grafton Campus"). They have different stable keys and are returned as held. The fix belongs to the governed campus identity process, not to the API.
