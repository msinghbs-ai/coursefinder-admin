# QS 2027 source in API v3, THE 2027 readiness, and destination data readiness (s800)

**Date:** 20 Nov 2026 (S1-Build)
**Directive:** Platform Admin, 20 Nov 2026 05:42 AEDT, item 3: trace the table or view behind QS 2027 in API v3 and document B5 destination readiness, with no import.
**Method:** read-only queries through the rolled-back live dry run, plus the live function definitions (snapshot run 44591628011).
**Spend:** none.

## 1. Where QS 2027 comes from

Rankings are held in their own schema, `ranking`. The 19 Nov assessment looked at `catalogue.provider_rankings` and `pipeline.ranking_inline_evidence_payloads`; both are empty and **are not used** by the API. Its statement that rankings could not be found is withdrawn.

| Step | Object | What it does |
|---|---|---|
| 1 | `website-api-v3`, action `rankings` | Calls the function below |
| 2 | `public.website_v3_rankings(filters, page, page_size)` | A one-line wrapper over v2 (v3 only reads v2 and its data) |
| 3 | `public.website_v2_rankings(...)` (frozen v2, G3) | Chooses the edition, joins the rows, applies filters and paging |
| 4 | `ranking.systems` | `qs_wur`, `the_wur`, `arwu` |
| 5 | `ranking.editions` | One row per system and year. Only `status = 'accepted'` is served. With no `edition_year` filter, the latest accepted year per system |
| 6 | `ranking.observations` | One row per ranked institution in the edition (rank, tie, score) |
| 7 | `ranking.observation_provider_links` | Links an observation to a catalogue provider (`is_primary` breaks ties) |
| 8 | `ranking.indicator_observations` | Indicator scores shown under each row |
| 9 | `security.layer4_search_blocked_providers` | Providers held back from search are left out |

Provider and course answers use `api.website_v2_ranking_summary(provider)`: the latest accepted edition per system for that provider.

### Editions held now (read 20 Nov 2026)

| System | Year | Status | Observations | Linked to providers |
|---|---:|---|---:|---:|
| QS World University Rankings (`qs_wur`) | **2027** | accepted (**served by default**) | 1,504 | 71 |
| `qs_wur` | 2026 | accepted | 1,504 | 66 |
| `qs_wur` | 2025 | accepted (an earlier copy superseded) | 1,503 | 72 |
| THE World University Rankings (`the_wur`) | **2026** | accepted (**served by default**) | 3,118 | 75 |
| `the_wur` | 2016 to 2025 | accepted (2015 rejected) | 800 to 2,855 | 59 to 75 |

Providers linked in any edition: QS AU 40, NZ 8, CA 26; THE AU 40, NZ 8, CA 31.

## 2. THE 2027: ready to load next

Nothing in the code needs to change. When a THE 2027 edition is accepted, API v3 serves it as the latest THE edition automatically, as it did for QS 2027.

The governed load path is the same one THE 2026 used (`access_status = licensed_upload`, 3 Sep 2026):
1. **The licensed THE 2027 file (Platform Admin).** THE data is licensed. The platform does not crawl it, and no paid crawling is used.
2. **Register the file.** `svc_ranking_manual_import_register` writes `ranking.manual_imports` with the source, methodology and licensing notes, the file's hash and its stored evidence.
3. **Validate.** `svc_ranking_import_validation_update`.
4. **Load and link.** `svc_ranking_ingest_apply`, then `svc_ranking_ingest_finalize`. Rows are linked to providers through `ranking.publisher_institutions` and `ranking.provider_mappings`, which already hold the THE names of the 75 linked providers.
5. **Accept the edition.** `status = 'accepted'`. A passing validation never switches it on by itself.
6. **Read back** the v3 `rankings` action filtered to `system_codes = ['the_wur']`, and the provider summaries.

## 3. B5: destination data already held (assess only, nothing imported)

| Table (`destination`) | Rows | Note |
|---|---:|---|
| `career_outcomes` | 1,577 | One edition published |
| `localities` | 102 | All AU |
| `locality_postcodes` | 1,303 | |
| `locality_metrics` | 142 | |
| `abs_postcode_sua_shares` | 2,947 | |
| `study_rules` | 19 | Editions for AU, NZ and CA; some draft, some superseded |
| `rule_applicability` | 15 | |
| `page_facts` | 14 | |
| `climate_stations` | 8 | |
| `city_profiles` | 0 | Two editions are recorded as published but hold no rows |
| `editions` | 10 | city_profiles 2, career_outcomes 1, study_rules 7 |

**Readiness:**
- Career outcomes and AU localities are usable now.
- City profiles are empty, so their published editions should be checked before anything relies on them.
- There are no NZ or CA localities yet.
- No outside source was imported for this note.
