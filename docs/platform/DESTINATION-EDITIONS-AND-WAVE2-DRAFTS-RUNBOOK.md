# Operator runbook: destination data editions and Wave 2 register drafts

**Version:** 1.3, 18 Nov 2026 (chat S1-RM-Design; asked by the Platform Admin 18 Nov 2026 07:39 AEDT; section 5 added for the multi-country schema lock, 11:28 AEDT).
**For:** the Platform Admin and Curators. **Screens:** Destination data, Layer 1 Register, Reference data.
**Status of the screens named:** live on Pilot at v2.16.35 (18 Nov 2026 11:55 AEDT). Not yet checked in a signed-in session.

Where a step says *Platform Admin*, the button is greyed for other roles and the server refuses the call as well. Every approval, publication and activation asks for a reason, which is kept with the decision.

## 1. Destination data: from a load to a published edition

| Step | Where | Who | What happens |
|---|---|---|---|
| 1. Load the edition | Platform health › Data delivery › Destination loads › Run now | The role shown on the job | The loader creates the edition (draft), its localities (draft), postcodes and figures (draft). Nothing is returned by the API yet. |
| 2. Settle postcodes | Destination data › Localities & postcodes, lower table; or Layer 4 Review › Inbox › Campus locality | Curator and above | A postcode that sits in more than one locality below the share is waiting for a person. Accept, choose a locality, or record none. One decision settles the postcode for every campus. |
| 3. Approve localities | Destination data › Localities & postcodes | Platform Admin | **Approve** on one row, or **Bulk Approve Drafts** for a whole dataset edition: every draft with a name and attribution text is approved with one reason; a draft without attribution text stays draft and is counted. |
| 4. Approve figures | Destination data › City metrics & costs | Platform Admin | **Approve** on one row, or **Bulk Approve Drafts** (v2.16.32) for a whole dataset edition: every draft figure with attribution text is approved with one reason; the rest stay draft and are counted. A figure is returned by the API once its locality is approved too. |
| 5. Record the terms | Destination data › Overview & editions › Record terms | Platform Admin | Sets the edition's terms of use: approved, pending or restricted. |
| 6. Publish the edition | Destination data › Overview & editions › Publish edition | Platform Admin | The edition becomes the published one for its country and domain; the earlier published edition is marked superseded. |

**What the server requires at step 6:** the edition is draft or in review, its terms are approved, and it holds at least one **approved** row. For a city profiles edition (18 Nov 2026, Pilot #1257, ref G7QN3W) the rows are its city profiles, the localities its load wrote (same country, `dataset_edition` equal to the edition label) and its figures that sit on another edition's localities (a figures-only edition such as climate averages); before that fix the count read only city profiles, so an ABS edition showed 0 rows and Publish edition refused it. Overview & editions shows rows, rows approved and figures. It does **not** require every locality or figure to be approved: rows that are not approved or published are simply never returned. The Publish dialog says how many rows are approved before you confirm.

**What the API returns:** the API v3 `destination` action, and `campuses[].locality` on the v3 `provider` action, return only approved or published rows.

**Undo:** Withdraw on a locality, figure, rule or outcome stops it being returned. A published edition is fixed; a change is a new edition.

**State on 18 Nov 2026 07:50 AEDT (read only):** one edition, Australia, city profiles, "ABS Regional population 2024-25", draft, terms approved; 102 localities and 102 figures, all draft, none without attribution text.

## 2. Wave 2 register drafts: from a draft to a paused source

Nine drafts were pre-staged on 17 Nov 2026 (Pilot #1228). A draft is not a source: nothing reads the web and nothing is scheduled until it is activated.

| Step | Where | Who | What to do |
|---|---|---|---|
| 1. Open the draft | Layer 1 Register › + Add source › Continue a draft | Curator and above | Choose the draft. The six steps show which are finished. |
| 2. Country & scheme | Step 1 | Curator and above | Check the target record type and the registration scheme. A scheme must be registered before this step can finish. All nine drafts have one since 18 Nov 2026 (S2-Build, Pilot #1240, registered `uk_hesa`, `uk_ukvi`, `ie_ilep` and `us_ipeds_completions`). |
| 3. Source & licence | Step 2 | Curator and above | Check the address and the connector. Upload a sample file. Record the licence name and set the terms once a person has confirmed them (REQ-68); the drafts are seeded as pending. |
| 4. Field mapping | Step 3 | Curator and above | AI Auto-Map proposes the mapping and the parser from the sample; correct it by hand. Mappings seeded as "expected name" must be checked against the sample. |
| 5. Cadence & retention | Step 4 | Curator and above | Cadence and Staging kept (days). The drafts carry 90 days. |
| 6. Dry-run preview | Step 5 | Curator and above | Shows "waiting for a reader" until a reader exists for the source. |
| 7. Activate | Step 6 | Platform Admin | Saves the source **paused** and writes the keep period to the per-source retention table. Running it is a separate decision on Layer 1 Register. |

**Before activating any of the drafts:**

- **Duplicates:** the older catalogue rows for the OfS Register, Discover Uni, the Irish Register of Qualifications and the UKVI sponsor register were retired on 18 Nov 2026 (S2-Build, Pilot #1240; checked live), and adding a source now checks for a duplicate by address and name.
- **ILEP:** kept and marked as a deprecating source. Move it to the TrustEd Ireland list of eligible programmes when that replaces the ILEP (expected about the end of 2026).
- **IRCC Designated Learning Institutions** is not a draft: it is already a live Layer 1 source.

## 3. Routing rule: where a source or dataset belongs

Decision of the Platform Admin, 18 Nov 2026 07:03.

| Kind | Belongs in | Examples |
|---|---|---|
| A source read on a schedule (ETL): provider, course or study-rules registers | Layer 1 Register | OfS Register, IPEDS, PGWP fields of study |
| A reference address or dataset that is not read on a schedule | Reference data | Grade scale conversions, the API field dictionary, key dates, reference sites |
| Locality and postcode tables | Destination data › Localities & postcodes | ABS localities and postcode shares |

## 4. API v3 fields: where to look them up

| Question | Where |
|---|---|
| Which fields does an API v3 action return, from which table and column, for which request? | Reference data › API field dictionary (search a field, endpoint, source column or request number). 2,085 fields on 17 Nov 2026. |
| What does a field mean and what is its status? | `docs/integrations/api-v3/API-V3-FIELD-DEFINITION.md` |
| Which course values are held today? | Catalogue › Courses: show Study load and Empty reason from Columns, or filter by them (v2.16.29). |
| Which campus is primary, and its locality? | Catalogue › Providers › Campuses: Primary and Locality columns (v2.16.29). |

**Handover (RM0B):** both v3 APIs are still in development, so the dictionary and handover documents are not issued to the developers yet. They are issued once, at v3 release.

**Study load (updated 18 Nov 2026 11:50 AEDT):** returned by API v3 on the `course`, `search` and Zoho `courses` actions since Pilot #1257 (migration `20261118133707`), with `empty_reason_code`, `campuses[].locality` and `provider.accreditations`; the provider action returns `accreditations`. The field dictionary lists them (2,179 fields; the next list, 2,216, adds the fields the live actions carried that it did not describe: Pilot #1264).

## 5. Multi-country schema lock: every destination in the shared tables

**Rule (Platform Admin, 18 Nov 2026 11:28):** one normalised schema serves every country. A country is a value in a `country_code` or `country_id` column, a scheme row (`ref.registration_schemes`) or an edition, never a table. **No table or view whose name starts with a country code may be created** (`au_`, `ca_`, `uk_`/`gb_`, `nz_`, `ie_`, `us_`, `de_`, `se_`, `fi_`, `dk_`, `es_`, `mt_`, `nl_`, `fr_`, `at_`, `ch_`, `pl_`, `hu_`, `it_`, `gr_`, `lv_`, `cy_`, `ae_`, `th_`, `sg_`, `my_`, `kr_`, `jp_` and the other codes in use). Enforced by Pilot spec `s627` (`tests/uat/cf-247-s627-no-country-prefixed-tables-contract.spec.mjs`), which fails the build on a migration that creates one or renames a table to one; a temporary table inside one migration is not schema and is allowed.

**Held before the lock (read live 18 Nov 2026), kept and never extended:** `pipeline.nz_cop_reads`, `pipeline.nz_cop_status`, `pipeline.ca_course_scope_keys`, `pipeline.au_nz_enrichment_backlog_v1`, `pipeline.au_nz_enrichment_backlog_summary_v1`, `ref.au_regional_postcode_ranges`. Four of them have no creating migration in Pilot (a governance gap already known: objects that exist only live).

**The destinations.** The Study Square destination workbook (10 Nov 2026; confidential to Study Square, held in the Claude project, not here) lists **28** destinations: the 20 scheduled as RM1 to RM25 and 8 unscheduled, now RM26 to RM33 (Poland, Italy, Greece, Cyprus, Thailand, Malaysia, South Korea, Japan). The numbers RM17, RM19, RM20, RM22 and RM24 stay unused.

### Where each part of a destination page lives (checked against the live schema, 18 Nov 2026)

| Workbook group | Table and columns | A new country needs | Fits today? |
|---|---|---|---|
| Institution register and identity (register ID, public or private, work-rights eligibility such as DLI and PGWP) | `catalogue.providers` (`country_id`), `catalogue.provider_registrations` (`registration_scheme`, `registration_code`, `provider_classification`), `ref.registration_schemes` (`kind`: course, provider, field of study, work eligibility) | scheme rows and register data | Yes |
| Campuses and city | `catalogue.campuses` (`country_id`, `postcode`, `is_primary`, `primary_basis`); locality by postcode in `destination.locality_postcodes` | data | Yes |
| Courses (level, field, delivery, study load, why a value is empty) | `catalogue.courses` (`delivery_mode`, `study_load`, `study_load_source`, `empty_reason_code`), `catalogue.course_registrations` | data | Yes. There is no `study_mode` column: delivery is `delivery_mode`; study load is `study_load`. |
| Entry requirements (academic, English, local language, admission tests) | `catalogue.course_entry_requirements` (`kind`, `country_id` of prior education, `min_grade`, `grade_scale`), `catalogue.course_english_requirements` (`english_test_id`, scores); grade conversions in `ref.grade_scale_conversions` | data | Yes. There is no `test_requirements` column: tests are rows of these two tables. |
| Tuition, intakes, scholarships | `catalogue.course_fees`, `catalogue.course_intakes`, the scholarship tables | data | Yes |
| Global rankings (QS, THE, ARWU) | `ranking.systems`, `ranking.editions` (accepted only), `ranking.observations`, `ranking.observation_provider_links` | data | **Partly.** `ranking.systems.code` allows only `qs_wur`, `the_wur`, `arwu`: the Financial Times needs that list widened. |
| Official national quality ratings (TEQSA, UK TEF, NZQA EER, TrustEd Ireland mark, KHDA stars, SETARA, FINEEC, ANVUR and others) | none | — | **No.** No table holds a rating. Not `catalogue.university_metrics` or `catalogue.university_rankings`: neither exists. A rating is not a rank, so it does not belong in `ranking`. |
| Business school accreditations (AACSB, EQUIS, AMBA; Triple Crown) | `catalogue.provider_accreditations` (`body_code` AACSB, EQUIS or AMBA; `status`; `expires_at`; `source_url`) | data | Yes. Triple Crown is worked out (all three active), not stored. |
| Student satisfaction and graduate outcomes (QILT, NSS, HESA, StudentSurvey.ie, HEA, IPEDS, Tahatū, UKÄ and others) | `ref.outcome_surveys` and `ref.outcome_metrics` (one row per survey and measure), `catalogue.provider_outcomes`, `catalogue.outcome_benchmarks` | survey and metric rows | Yes |
| Cities: population, 30-year climate normals, living costs | `destination.localities`, `destination.locality_postcodes`, `destination.locality_metrics` (`metric_category` population, climate or living_cost), editions in `destination.editions` (domain `city_profiles`) | data | Yes |
| Visa, funds, fee, processing time, work while studying, post-study work, application routes | `destination.study_rules` (`rule_category`, `state_code`, `applicant_scope`, effective dates), `destination.rule_applicability` (field-of-study and programme lists, for example PGWP CIP codes) | data | **Partly.** `rule_category` allows six values (application_route, visa_funds, work_rights, post_study_work, visa_fee, processing_time). **Dependants, minimum wage and the offer document for the visa have no category.** |
| Labour market: occupations, shortage lists, outlook, projections, earnings | `destination.career_outcomes` (`occupation_scheme`, `occupation_code`, `skill_shortage_status`, `job_outlook_rating`, `outlook_horizon_years`, `median_salary`, `geography_level`) | data | **Partly.** `occupation_scheme` allows ANZSCO, NOC and SOC only: OSCA 2024 (Australia's successor), NOL, ISCO-08 and the national ISCO-based schemes need the list widened. **Employment by industry has no table** (outcomes are per occupation). |
| Sources and licences | every row: `source_url`, `attribution_text`, evidence id; editions: `terms_status` (approved, pending, restricted); rankings: setting `website.rankings_display_approved`; registers: `pipeline.layer1_source_inductions.terms_status` | data | Yes. There is no `permission_status` column: the licence gate is the edition's `terms_status` and, for rankings, the display setting. |

### What would make a new country need a migration (to be closed once)

Fixed lists and two missing homes. Each is additive (no country table, no change to the frozen v2 consumer API) and is best made once, as reference lists, so that later countries need rows, not migrations:

1. `ranking.systems.code`: add the Financial Times rankings.
2. Three CHECK constraints are **in hand with S2-Build** (Pilot #1263; paste file `docs/paste/PASTE-20261118-29-destination-check-constraints.sql` for the Platform Admin, before Thursday 01:15 AEDT): `career_outcomes.occupation_scheme` gains ISCO, ESCO, KLDB, ROME, SSYK, DISCO, SSOC, MASCO, KSCO, JSCO and TSCO; `career_outcomes.state_code` accepts numeric ISO 3166-2 codes; `study_rules.rule_category` gains `health_insurance`, `language_requirement` and `admission_test`. **Still not covered after that file:** `rule_category` values for **dependants**, **minimum wage** and the **offer document** for the visa, and the occupation schemes **OSCA** (Australia, successor to ANZSCO) and **NOL** (New Zealand). Best added to the same paste file before it runs, so the constraints are relaxed once.
3. A shared table for official national quality ratings, keyed by provider, scheme and edition, with source and terms.
4. A shared table (or grain) for employment by industry and region.

Owner: the destination schema lanes (RM-Cities, RM-Study-Rules, RM-Careers, RM-Rankings); item 2 is S2-Build's. Logged as open work in `docs/CURRENT-STATE.md`.

### Publication gate

Nothing a destination page shows is published until its source is verified and its terms allow it. Open official-source checks are request rows REQ-84 to REQ-90 in `docs/integrations/CONSUMER-REQUESTS.csv`; the commercial licence gates (QILT, QS, THE, FT) are REQ-91, with REQ-68. A rule waiting on one of them stays draft.
