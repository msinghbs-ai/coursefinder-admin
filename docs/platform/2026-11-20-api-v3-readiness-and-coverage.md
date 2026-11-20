# Website API v3 – readiness, coverage and data gaps (20 Nov 2026)

**Asked by:** Platform Admin, 20 Nov 2026 23:02 AEDT: "Check website developer v3 api readiness, coverage and update relating documents and api. Generate api v3 document for developers and prepare an email and update Request register and Roadmap register. i need to highlight data gap and number of source missing to collect and admit data and some of the data awaiting human".
**Lane:** S1-RM-Design (requirements and registers). No schema migration and no API change in this package.
**Read:** live Supabase `fxcwkweaxjtknorudmwp`, read only, 20 Nov 2026 23:05–23:20 AEDT. Coverage source: `pipeline.field_coverage_daily` (snapshot 20 Nov, written 20:08 AEDT by `platform-health`), `security.api_v3_daily_admittance_v1`, `pipeline.course_attribute_coverage`, `pipeline.layer4_review_items`, `pipeline.api_usage_daily`, and the `public.website_v3_*` functions called directly.

## 1. Verdict

**Ready for developer integration.** Website API v3 answers all ten actions; v3 is v2 plus additions with no difference on v2 fields (the guide's example search returns 36 at both); the field dictionary covers 910 website fields. The website has made **no v3 calls in the last 14 days** (all 3,000+ website calls were v2), so v3 stays open (Decision 277) until the Platform Admin records the website's go-live date.

| Check | Result |
|---|---|
| Ten actions answer (reference, search, course, providers, provider, rankings, scholarships, scholarship, sync, destination) | Yes, called live through `public.website_v3_*` |
| v3 = v2 plus additions | Search total 36 = 36; course and search key sets are v2 plus `study_load`, `study_load_basis`, `empty_reason_code`, `recognition`, `field_of_study_codes` (course) and `description_excerpt` (search) |
| `sync` carries v3 fields | Course items carry `study_load`, `study_load_basis`, `empty_reason_code`, `campuses[].locality`; provider items carry `accreditations`, `accreditation_crown`, `scholarships_page_url`; scholarship items carry the v3 scholarship fields. `description_excerpt` is search only |
| Timing (database, warm) | Example search 941 ms v3 vs 437 ms v2; course with `edu_country` 1,200 vs 1,067 ms; scholarships list 397 ms; destination 34 ms |
| Consumer use | 0 v3 calls in 14 days (website v2: search 688, providers 845, scholarships 566, sync 692) |
| Field dictionary | 910 website fields, 2 pending (`reference.ranking_systems[].editions`, a type constraint) |

**Gaps in the API shape (not blockers):**
1. `reference` does not return the v3 closed value lists (start-date statuses, nationality eligibility statuses, award types, application methods) that the field definition planned. The guide lists the values instead (section 7.11). An additive `reference.v3` block would need an S2-Build migration; recommended, not urgent.
2. The field definition's section 3 placeholders (`teaching_language`, `post_study_work`, `admission_tests`, `entry_conditions`, `application_route`, `logo_dark`, `brand_colour`) are **not keys** in the deployed v3 (13 Nov decision: keep the deployed shape, no null placeholders). The guide says so.
3. The field dictionary described `primary_basis` with `cricos_head_office` only; live data also uses `highest_course_count` (1,261 of 1,617 main campuses). The developer CSV carries the corrected meaning; the Pilot dictionary should be re-synced (S2-Build).
4. v3 search is about twice as slow as v2 on the guide example (0.94 s against 0.44 s). Acceptable with the 15-minute cache the guide requires; worth a look before go-live.

## 2. Daily admittance (telemetry contract, admission plan §7)

| Field | REQ | Admitted | Eligible | % | Gain since 19 Nov |
|---|---|---|---|---|---|
| `v3_study_load` | REQ-52 | 29,430 | 36,031 | 81.7 | +18,033 |
| `v3_empty_reason` | REQ-53 | 5,372 | 5,377 | 99.9 | −257 (denominator fell as campuses were found) |
| `v3_campus_primary` | REQ-75 | 1,614 | 1,696 | 95.2 | +1,260 |
| `v3_accreditations` | REQ-57 | 40 | 1,886 | 2.1 | +40 (only business schools can hold one) |
| `v3_grade_normalised` | REQ-19 | 0 | 5,576 | 0.0 | 0 |
| `v3_destination` | REQ-65, 67, 68 | 1,586 | 1,596 | 99.4 | 0 |
| official_url | core | 24,071 | 36,031 | 66.8 | +5 |
| description | core | 15,791 | 36,031 | 43.8 | +488 |
| academic_entry | core | 1,400 | 36,031 | 3.9 | 0 |
| english | core | 20,866 | 36,031 | 57.9 | +32 |
| intakes | core | 13,493 | 36,031 | 37.4 | +33 |
| provider_tuition | core | 10,804 | 36,031 | 30.0 | +7 |
| registered_tuition | core | 25,522 | 25,703 | 99.3 | 0 |
| p_entry_matrix | core | 26 | 1,886 | 1.4 | 0 |
| p_registrations | core | 1,886 | 1,886 | 100.0 | 0 |

## 3. Coverage by country (`pipeline.field_coverage_daily`, 20 Nov)

| Course field | AU (25,703) | NZ (6,514) | CA (3,814) |
|---|---|---|---|
| Official course page | 18,268 | 3,066 | 2,737 |
| English | 16,456 | 2,393 | 2,017 |
| Intakes | 9,566 | 2,221 | 1,706 |
| Application deadline | 56 | 33 | 214 |
| Provider tuition | 8,576 | 1,496 | 732 |
| Registered tuition | 25,522 | — | — |
| Description | 12,475 | 1,795 | 1,521 |
| Duration | 25,703 | 2,546 | 1,574 |
| Delivery | 16,693 | 2,741 | 2,360 |
| Campus | 25,672 | 2,692 | 2,290 |
| Study load | 25,637 | 2,340 | 1,453 |
| Academic entry (course) | 919 | 481 | 0 |

| Provider field | AU (1,544) | NZ (290) | CA (52) |
|---|---|---|---|
| Main campus | 1,464 | 105 / 107 | 45 / 45 |
| Accreditation | 25 | 7 | 8 |
| Entry matrix | 18 | 8 | 0 |
| Logo | 1,280 | 245 | 45 |
| Description | 947 | 223 | 41 |
| Scholarships | 93 | 19 | 15 |
| Institution type | 1,541 | 290 | 0 |

Scholarships (published): AU 826 of 1,637, NZ 113 of 280, CA 131 of 274. Destination editions published: AU 4 of 7, NZ 0 of 1, GB 1 of 1.

## 4. Data gaps: where each missing value sits (all countries, courses)

States from `pipeline.course_attribute_coverage`: **to collect** = `site_known` + `no_website` (the course page is not found yet); **read, awaiting checks** = `page_found` + `candidate` + `awaiting_l3`; **awaiting a person** = `in_review`; **not published** = `not_on_page`; **blocked** = robots, directory or manual lock.

| Field | Admitted | To collect | Read, awaiting checks | Awaiting a person | Not published by provider | Blocked |
|---|---|---|---|---|---|---|
| Official course page | 24,071 | 9,348 | 1,952 | 19 | 348 | 293 |
| English | 20,891 | 7,272 | 2,219 | 67 | 5,436 | 146 |
| Intakes | 13,530 | 9,359 | 2,828 | 392 | 9,623 | 299 |
| Provider tuition | 10,808 | 9,223 | 3,615 | 549 | 11,555 | 281 |
| Description | 15,795 | 8,671 | 2,542 | 160 | 8,723 | 140 |
| Academic entry | 1,400 | 34,631 with no reader (AER v1 frozen; v2 decides) | — | — | — | — |

By country (to collect / read awaiting checks / awaiting a person):
- Official page: AU 5,399 / 1,490 / 8; NZ 3,172 / 172 / 9; CA 777 / 290 / 2.
- English: AU 4,182 / 926 / 63; NZ 2,759 / 202 / 4; CA 331 / 1,091 / 0.
- Intakes: AU 5,399 / 1,930 / 344; NZ 3,181 / 235 / 36; CA 779 / 663 / 12.
- Provider tuition: AU 5,318 / 2,272 / 410; NZ 3,161 / 255 / 56; CA 744 / 1,088 / 83.
- Description: AU 4,959 / 2,028 / 103; NZ 2,950 / 136 / 48; CA 762 / 378 / 9.

## 5. Sources missing to collect and admit

| Source gap | Count |
|---|---|
| Providers with no website on record | 71 (all AU; 326 courses) |
| Providers whose website is known but no course page is found yet | 447 (AU 310, NZ 133, CA 4) |
| Providers with no admitted course page at all | 625 (AU 473, NZ 146, CA 6) |
| Courses whose page is still to be found | 9,348 (AU 5,399, NZ 3,172, CA 777) |
| Providers with no admitted academic entry table | 1,860 of 1,886 |
| Courses with no academic entry reader | 34,631 of 36,031 |
| Grade normalisation (REQ-19) | 0 of 5,576 entry rows; scales waiting for the AER session's decision |
| Destination datasets not yet published | AU 3 of 7; NZ 1 of 1; 26 further destinations not started |
| Business accreditations | 40 providers hold one; not a gap (only business schools qualify) |

## 6. Awaiting a person (Layer 4, pending, 20 Nov 23:10)

| Item | Pending | Entities |
|---|---|---|
| Course academic entry, first read | 1,065 | 1,065 courses |
| Official course link | 267 | 267 courses |
| Course description, first read | 159 | 159 courses |
| Provider tuition validation (+5 tuition) | 145 | 145 courses |
| Duration | 102 | 102 courses |
| Provider entry matrix first run (+6 changes, +5 conjoint rules) | 84 | 70 providers |
| Provider with no page found, first run | 55 | 55 providers |
| Provider description | 48 | 48 providers |
| Course English | 21 | 21 courses |
| Study load | 10 | 10 courses |
| **Total** | **1,956** | |

Also waiting for a person outside that queue: 82 main campuses (AU 80, NZ 2) and 28 campus locality matches held by rule `l4-campus-locality-v1` (69 open locality items in all).

## 7. What changed in the documents

- New developer pack, admin `docs/integrations/developer-pack/v3/`: guide (md, docx, pdf, 15 pages), field dictionary CSV (910 website fields, internal references removed, `primary_basis` corrected), OpenAPI 3.1 and Postman (22 requests including `destination`, linked-course paging and `has_academic_entry`), and the build scripts `build-v3.sh`, `gen_api_v3.py`, `polish-v3.py`.
- Email to the website developers drafted in Gmail (reply on the 14 Nov "StudySearch API – progress update, request register and API v3" thread, to the AI Automation Team, cc Sujata Sherpa and Saurabh Baid, with the four files attached). **Not sent**: the Platform Admin sends it.
- Request register: REQ-76, REQ-51, REQ-52, REQ-53, REQ-57, REQ-65, REQ-67 and REQ-75 logged. Statuses unchanged until the email is sent (REQ-76 moves to Live in v3 then, as approved 20 Nov 05:42).
- Roadmap: RM0B next action updated; one engagement row (Handover, 15 min).
- `API-V3-FIELD-DEFINITION.md` deployed-state note, `WEBSITE-DEVELOPER-REQUIREMENTS.md` note, `docs/README.md` router row, `docs/CURRENT-STATE.md`, and the CF-247 entry in the five runsheet files.

## 8. Next steps

1. Platform Admin: review and send the Gmail draft; then set REQ-76 to Live in v3 and log "told Raghav with the v3 guide" on REQ-52, 53, 57, 65, 67 and 75.
2. Platform Admin: record the website's v3 go-live date when Raghav switches; v3 then joins the G3 frozen list, the baseline and `s57` in the same change.
3. S2-Build (optional, additive): `reference.v3` closed lists; re-sync the field dictionary `primary_basis` meaning; look at v3 search time.
4. Pipeline: the gaps in sections 4 to 6 close through the existing jobs and the Layer 4 queue; the next issue of the guide refreshes section 8.
