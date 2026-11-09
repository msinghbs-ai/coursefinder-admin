# AU complete course holdings export — 2 November 2026

## Mandate and outcome

Platform Admin mandate: prepare the complete AU-only course-field exports held in the database, including scholarships, rankings and entry requirements. Broad read load authorised; no development active.

Completed a read-only extraction from live Pilot project `fxcwkweaxjtknorudmwp`: **1,000,919 records across 84 datasets**. No database writes, migrations, API changes, source acquisition, settlement decisions or deployments. This record is the only repository change.

The full CSV/JSONL pack is the complete scoped data export. The Excel workbook is a basic index of all courses, with the field inventory and dataset counts; all detailed records remain in the complete pack.

| Holding | Records |
|---|---:|
| AU courses, all lifecycle states | 26,912 |
| AU providers | 1,556 |
| Scholarships | 1,805 |
| Academic entry requirement records | 2,649 |
| English requirement records | 27,134 |
| Ranking observations | 730 |
| Ranking indicator records | 5,053 |
| Course fee records | 179,621 |
| Course–scholarship mappings, all stored states | 101,422 |

## Scope and joins

AU providers are selected through `catalogue.providers.country_id → ref.countries.iso_alpha2 = 'AU'`. All courses of those providers are included, including inactive courses. Course children follow those course IDs; provider children follow those provider IDs. Scholarships follow AU-provider ownership or explicit AU provider/course/country scope. All scholarship scope rows are retained, including provider, study-level and country scopes with no course ID. Course mappings, mapping candidates and financial calculations follow AU course IDs. A live anti-join found zero AU mapping rows referring to a scholarship outside the exported scholarship set.

Rankings follow AU-provider links or the publisher's explicit Australia designation. Shared lookup definitions are included for interpretation; they may mention other countries but no non-AU course catalogue is exported. Every filter is supplied in `export_queries.sql`.

The source model was inspected live. The older `catalogue.provider_rankings` and `ref.ranking_sources` are empty. Actual rankings are in `ranking.observations`, `ranking.indicator_observations`, `ranking.editions`, `ranking.systems` and their mapping/link tables. An additional Australian QS observation for Central Queensland University Australia (CQUniversity) has no provider link. It is included as unlinked; no link was invented. Rankings remain institutional/subject records, not course ranks.

## Stored coverage

Counts below include all stored statuses. Having a stored row does not establish admission, validity, publication, currentness or student eligibility.

| Dataset | Records | Courses with records | Courses without records |
|---|---:|---:|---:|
| `catalogue.course_fees` | 179,621 | 26,912 | 0 |
| `catalogue.course_campuses` | 48,732 | 26,881 | 31 |
| `catalogue.course_entry_requirements` | 2,649 | 648 | 26,264 |
| `catalogue.course_english_requirements` | 27,134 | 17,191 | 9,721 |
| `catalogue.course_links` | 20,247 | 19,093 | 7,819 |
| `catalogue.course_intakes` | 28,437 | 10,537 | 16,375 |
| `catalogue.course_identifiers` | 26,912 | 26,912 | 0 |
| `catalogue.course_registrations` | 26,912 | 26,912 | 0 |
| `catalogue.course_field_observations` | 28,574 | 26,912 | 0 |
| `catalogue.course_regulatory_observations` | 56,513 | 26,912 | 0 |
| `catalogue.course_study_level_observations` | 56,513 | 26,912 | 0 |
| `scholarship.course_mappings` | 101,422 | 11,649 | 15,263 |
| `scholarship.course_mapping_candidates` | 37,200 | 6,396 | 20,516 |
| `scholarship.course_financial_calculations` | 26,709 | 8,207 | 18,705 |

The AU provider entry matrix currently has zero rows. Academic entry records cover 648 courses; no requirements were manufactured for the other 26,264 courses. Source null, empty text, false and numeric zero remain distinct in JSONL and the dictionary. CSV uses a documented null marker. The workbook leaves source nulls blank. No placeholder or review-state text was written into factual fields.

Course lifecycle states: active 25,380, inactive 1,532. The stored course `publication_status` is `unpublished` for all 26,912 rows; this export makes no inference about Wix eligibility from that column alone. Scholarship publication states: unpublished 865, published 892, withdrawn 48. The export is a holdings view, not the consumer API projection.

## Delivery and verification

- 84 complete CSV files and 84 complete JSONL files. Empty datasets retain CSV column headers.
- Field dictionary: 1,198 database columns, with types, available precision/nullability metadata and null/empty/populated/zero counts.
- Nested JSON field-path inventory, original read filters, live relationship constraints, source column metadata, file hashes and a join/semantics README.
- Source rows preserve audience, year, currency, fee type/basis, validity, status, quote, provenance and source/evidence references. Binary evidence objects, credentials, auth tables, unrelated settings and operational histories outside the inventory are outside this deliverable.
- Row counts reconcile for all 84 datasets. Primary/key checks found no duplicates; required columns are present. Course and scholarship reference checks passed.
- All 84 generated CSV files were parsed and their row/column counts and CSV hashes verified. The ZIP CRC check passed for all 182 entries. No errors.
- Excel provides a basic index of all 26,912 courses (ID, title, code, provider), the full field inventory and dataset counts. All 23 base course columns and every detailed related record remain complete in CSV/JSONL. The spreadsheet engine failed while exporting the larger detailed workbooks, so the Excel deliverable is an index, not the complete data container. No data was removed from the full export pack.
- The saved index workbook passed native XLSX CRC, row-count, frozen-header and unexpected-formula checks: four worksheets, no failures. Its four views were rendered and visually reviewed.

First saved extraction page: 2026-11-01T22:27:05.468Z. Last saved page: 2026-11-01T22:53:15.302Z. Validation: 2026-11-01T22:54:17.206Z. This is an interval extraction, **not a transactionally atomic database backup**. Core subject control counts were independently rechecked and matched. Background processing can change data after extraction. Large response transport failures were recovered with smaller pages; the final row/key/column reconciliation passed.

| Deliverable | Bytes | SHA-256 |
|---|---:|---|
| `StudySearch_AU_Course_Export_Index_2026-11-02.xlsx` | 1,711,606 | `041709b97793bd2ea2f1330bc0addfc13e6b389f2eac1d237e53a2645d02525c` |
| `StudySearch_AU_Complete_Course_Data_2026-11-02.zip` | 227,717,103 | `0038fb48b78e54bd38676cae477918cf2681eecf847483607ba80406c8fad7e0` |

## Dataset inventory

| Dataset | Exported rows |
|---|---:|
| `catalogue.campuses` | 3,987 |
| `catalogue.course_academic_options` | 0 |
| `catalogue.course_campuses` | 48,732 |
| `catalogue.course_collection_memberships` | 0 |
| `catalogue.course_collections` | 0 |
| `catalogue.course_english_requirements` | 27,134 |
| `catalogue.course_entry_requirements` | 2,649 |
| `catalogue.course_fees` | 179,621 |
| `catalogue.course_field_observations` | 28,574 |
| `catalogue.course_identifiers` | 26,912 |
| `catalogue.course_intakes` | 28,437 |
| `catalogue.course_links` | 20,247 |
| `catalogue.course_registrations` | 26,912 |
| `catalogue.course_regulatory_observations` | 56,513 |
| `catalogue.course_specialisations` | 0 |
| `catalogue.course_study_level_observations` | 56,513 |
| `catalogue.courses` | 26,912 |
| `catalogue.outcome_benchmarks` | 0 |
| `catalogue.provider_aliases` | 22 |
| `catalogue.provider_assets` | 1,286 |
| `catalogue.provider_collection_memberships` | 26 |
| `catalogue.provider_entry_matrix` | 0 |
| `catalogue.provider_fee_ranges` | 1,142 |
| `catalogue.provider_identifiers` | 1,556 |
| `catalogue.provider_outcomes` | 3,164 |
| `catalogue.provider_rankings` | 0 |
| `catalogue.provider_register_facts` | 2,142 |
| `catalogue.provider_registrations` | 1,556 |
| `catalogue.providers` | 1,556 |
| `catalogue.student_flow_observations` | 0 |
| `scholarship.application_windows` | 51 |
| `scholarship.audience_readings` | 1,780 |
| `scholarship.award_tiers` | 761 |
| `scholarship.country_onboarding` | 1 |
| `scholarship.course_financial_calculations` | 26,709 |
| `scholarship.course_mapping_candidates` | 37,200 |
| `scholarship.course_mappings` | 101,422 |
| `scholarship.coverage` | 30 |
| `scholarship.criteria` | 4,512 |
| `scholarship.criterion_groups` | 144 |
| `scholarship.identifiers` | 1,899 |
| `scholarship.nationality_readings` | 1,780 |
| `scholarship.offering_cycles` | 188 |
| `scholarship.register_listings` | 333 |
| `scholarship.registers` | 2 |
| `scholarship.scholarships` | 1,805 |
| `scholarship.scopes` | 8,900 |
| `pipeline.claims` | 0 |
| `public.field_values` | 0 |
| `pipeline.course_completeness` | 25,380 |
| `pipeline.course_field_source` | 25,380 |
| `pipeline.aer_course_outcomes` | 25,380 |
| `pipeline.layer4_course_field_resolutions` | 0 |
| `pipeline.course_credential_reads` | 0 |
| `pipeline.course_remediation_holds` | 174 |
| `pipeline.course_no_page` | 1,250 |
| `pipeline.course_page_blocks` | 107 |
| `pipeline.course_fact_source_records` | 39,427 |
| `pipeline.layer4_review_items` | 21,968 |
| `pipeline.enrichment_flags` | 44,825 |
| `pipeline.field_enrich_items` | 52,443 |
| `pipeline.coverage_course_pages` | 24,240 |
| `ref.countries` | 249 |
| `ref.subdivisions` | 38 |
| `ref.study_levels` | 24 |
| `ref.fields_of_study` | 102 |
| `ref.english_tests` | 5 |
| `ref.ranking_sources` | 0 |
| `ref.provider_types` | 10 |
| `ref.identifier_schemes` | 5 |
| `ref.course_link_types` | 6 |
| `ref.course_code_schemes` | 33 |
| `ref.institution_collections` | 4 |
| `ref.outcome_metrics` | 21 |
| `ref.outcome_surveys` | 10 |
| `public.pim_attribute_definitions` | 0 |
| `ranking.observations` | 730 |
| `ranking.observation_provider_links` | 748 |
| `ranking.indicator_observations` | 5,053 |
| `ranking.provider_mappings` | 87 |
| `ranking.publisher_institutions` | 87 |
| `ranking.editions` | 20 |
| `ranking.systems` | 3 |
| `catalogue.provider_associations` | 0 |

