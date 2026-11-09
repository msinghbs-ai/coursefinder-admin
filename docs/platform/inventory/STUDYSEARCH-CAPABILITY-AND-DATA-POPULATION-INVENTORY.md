# StudySearch — Live Capability, Function, Plan and Data-Population Inventory
**Production snapshot:** 8 November 2026 AEDT (multiple small read-only SQL queries, not one atomic transaction).
**Pilot head checked:** `d1a2b57595cd8aa394eec239f25b74f0c8041e75` (#921). Last visible UI release v2.15.494 (#919). Current live head may advance after this snapshot.
**Governance:** [Operating model](../AGENT-OPERATING-MODEL.md), [canonical register](../STUDYSEARCH-EXECUTION-REGISTER.md), [feature acceptance contract](../STUDYSEARCH-FEATURE-ACCEPTANCE.md), [derived status](../STUDYSEARCH-PROGRAMME-STATUS.md), [pipeline lineage](../PIPELINE-LINEAGE.md), [UI catalogue](../UI-CATALOGUE.md). This file is an inventory, **not a second issue/approval register**. Where the 25 October lineage differs from the live schema, code and live schema win.

## A. Exact inventory files (read-only production metadata)
- [All **2,317** SQL function identities](2026-11-08-production-functions.csv) — schema, function name, identity argument list; includes overloads, **not** the full function bodies or assertion that every function is live-used.
- [All **184** registered automation definitions](2026-11-08-production-automations.csv) — jobname, area, label, active state, cron schedule, description; 170 active and 14 in the registry not actively scheduled or not present in cron. An independent cron count at snapshot was **170 active / 13 inactive**: catalogue and cron are not a perfect 1:1 inventory (one catalogued job unscheduled, cron-only jobs possible).
- [All **1,236** configuration-setting definitions](2026-11-08-production-settings.csv) — toolset/key, description metadata, type, section, unit, used_by. **Current values deliberately omitted** from the public CSV to avoid exporting operational secrets or excessive configuration exposure.
- [All **1,792** recorded autonomous enrichment plans](2026-11-08-enrichment-plans.csv) — plan UUID, provider UUID, state/mode/outcome, timestamps and step types. These are **instances**, not 1,792 different programme features; no data payload or credentials exported.

**PostgreSQL function counts by schema:** `security` 1,438; `public` 786; `api` 43; `pipeline` 27; `scholarship` 9; `search` 9; `catalogue` 4; `ref` 1. **Total 2,317.** Function presence does not imply that a worker, schedule, UI action, human admission path or publication step is enabled and successful.

**Platform entities:** 3,103 providers; 44,396 courses in all lifecycle states, 35,689 with `lifecycle_status='active'`. `pipeline.field_register` has 24 active tracked fields (14 course + 10 provider).

## B. How a provider and its courses enter the catalogue
1. **Layer 1 — official registration/identity.** Australian CRICOS, NZQA NZ and applicable other regulator/provider sources establish provider, codes, country, authority and registered courses, levels, duration, registration and lifecycle evidence. Key records: `catalogue.providers`, `provider_identifiers`, `provider_registrations`, `courses`, `course_registrations`, `pipeline.layer1_register_row_state`. Jobs: `coursefinder-layer1-regulatory-scheduler`, `layer1-register-end-dates` (as catalogued), `provider-type-classify`. Function example: `security.layer1_register_end_dates_v1`. Do not mark a provider/course retired without the established authoritative process and human gates.
2. **Provider onboarding, first-party discovery (Layer 2).** Find and validate the provider's official site/host, course links, sitemap, official policy pages, campus, contacts, logos, scholarship listings. Read direct first when possible; Firecrawl `map`/`scrape`/reader only as authorised and within daily allocation. Records: `pipeline.provider_onboarding`, `coverage_provider_urls`, `provider_discovery_links`, `coverage_course_pages`, `provider_fact_sources`, `provider_central_search`, `provider_description_reads`. Jobs: `coverage-find-site` (verify live catalogue), `provider-onboarding`, `central-find`, `central-attach`, `provider-facts`, `provider-website-check`, `course-link-search`, `provider-contact-page`, `logo-find`, `provider-description-read`, `entry-matrix-read`, `fee-reader`.
3. **Adapters and typed reading (Layer 2).** University/site-specific adapters extract structured programme names, tuition, duration, campus, English and intake months from *bound* official course pages. Central academic calendars, English policies and fee schedules have independent source/proposal/applicability gates. A discovered site/URL alone does **not** authenticate each course or the correct audience.
4. **Layer 3 — AI enrichment only when necessary.** `enrich-plan-auto` identifies eligible providers, `enrich-plan-run` selects bounded steps; `field-gap-queue`/Enrich fields selects missing items; `security.enrich_fields_slice_v1` dispatches `coverage-sweep:enrich_ai` on stored official evidence. `public.svc_enrich_ai_record` records quote/value/confidence/reason; field-specific validation and identity rules apply. The worker is subject to `enrich.ai_calls_at_once` (8 at snapshot), leases, retries and actual HTTP-result monitoring. AI evidence is a *candidate*, not a blanket source of authority.
5. **Layer 4 — governed settlement.** Unsupported, first-admission, conflicting, high-impact or policy-sensitive proposals become item-level reviewer decisions. Existing Layer 4 Inbox, AER, fee, English, description and scholarship rules determine what requires a person. Preserve `pipeline.layer4_review_items`, evidence, source copies, manual locks and audit history. Some safe deterministic paths may admit under existing decisions; no AI may impersonate human approval.
6. **Canonical admission and consumer projection.** Approved/eligible fields land in `catalogue`, `scholarship`, etc.; search refresh/projection work populates existing Website/Zoho consumer sources, then the frozen Website API v2/Zoho API v2 contracts project them. Validate **canonical, stored Website, stored Zoho, authenticated HTTP and cache** separately; a successful scan or a value on an unpublished parent is NOT a published consumer gain.
7. **Autonomous feedback and recovery.** Existing first-run/progress observer, job-output contracts, issue queue, `pipeline.integration_issues`, alert delivery, retry/lease and settings provide closed-loop monitoring. A correct no-source/no-evidence refusal is durable and not endlessly repeated. The product schedules may run without Claude; novel code changes still require an authorised engineering controller/release process.

## C. All native provider fields — source, population and current snapshot
The live `catalogue.providers` table holds these field groups (plus IDs, timestamps and basis/source provenance). The rows below are the direct provider columns; related many-to-one details follow.

| Provider field group (actual columns) | How populated / authority | Production snapshot or gap |
|---|---|---|
| Stable identity: `id`, `stable_key`, `canonical_name`, `display_name`, `short_name` | Register identity; curated display name and aliases via existing Admin editing and identity reconciliation. Manual names are preserved. | 3,103 provider records. |
| Geography/type: `country_id`, `subdivision_id`, `provider_type_id`, `provider_type_basis`, `provider_type_set_at` | Regulator and type classification; country/subdivision reference; `provider-type-classify` and approved rule. | 1,957 have direct provider_type_id. |
| Official site: `website` | Register/provider official host, `coverage-find-site`/verification; `website_needed` Layer 4 on uncertainty. | 2,323 populated. |
| Description: `description` | Official About/provider page → `provider-description-read` → evidence/Layer 4 → canonical/admitted. | **0 non-empty**; `provider_description_reads` contains records for 5 distinct providers. Developed reader ≠ admission. |
| Address/location: `primary_city`, `address_line1`, `address_line2`, `postcode`, `latitude`, `longitude` | Register/site contact/location/campus proof and curated updates; never infer geographic coordinates without source. | 3,101 city values, 1,693 line-1 addresses. Geo completeness not measured. |
| Direct contact: `phone`, `email` | Register / official contact page; `provider-contact-page` and governed contact observations. | 1,518 providers have at least one direct column. Separate contacts observed for 11 providers in `pipeline.provider_contacts`. |
| Logo: `logo_url` | Official site logo-finder, with assets in related `catalogue.provider_assets`. | **0 direct `logo_url` values**, while 2,011 providers have linked asset records. Do not treat direct column as total logo coverage. |
| Established year: `established_year` | Where source-backed or manually captured; do not infer from registration period. | Current population count not measured in this snapshot. |
| Eligibility: `enrols_international`, `enrols_international_basis` | CRICOS/NZQA/signatory or other approved eligibility rule, conditional source proof. | 2,883 flags non-null; false and true both count as known. |
| Lifecycle/publication: `lifecycle_status`, `publication_status` | Registered status/controlled lifecycle decisions and publish eligibility; not every catalogue row is published. | 3,087 lifecycle active; 2,826 `publication_status='published'`. |
| Audit/provenance: `canonical_source_id`, `last_verified_at`, `created_at`, `updated_at` | Register/reader/admission and later verification events. | Presence of a timestamp alone does not establish current external reachability. |

**Linked provider entities** (not simple `providers` columns): `provider_aliases`, `provider_identifiers`, `provider_registrations`, `provider_register_facts`, `provider_assets`, `provider_associations`, `provider_entry_matrix`, `provider_fee_ranges`, `provider_rankings`, `provider_outcomes`, `pipeline.provider_contacts` and associated contact points/versions/observations. Scholarship tables associate awards, audiences and eligibility with providers. At snapshot, **27** providers had provider-entry-matrix rows, **0** had provider rankings, and **2,011** had assets; not necessarily all current/approved.

## D. All 24 tracked fields — how each fills
These are the exact keys in live `pipeline.field_register` (14 course, 10 provider). Their presence represents a *tracking rule*, not proof of a functioning reader. The reader/fills metadata requires verification against deployed code.

| Tracked field(s) | Source → reader/pipeline → landing |
|---|---|
| `official_url` | Verified official course page link → course-link-search/coverage identity proof → `catalogue.course_links`; `course-url-fill` fills an allowed bound link. |
| `level` | Official register/adapters; AI study-level from title/bound page when permitted → `catalogue.courses.study_level_id`. |
| `field_of_study` | Register (AU)/ASCED; bounded AI classification of course title → `catalogue.courses.primary_field_id`. |
| `duration` | CRICOS/register, adapters or course-page quoted duration → `catalogue.courses.duration_value/unit`. |
| `delivery` | Register/adapters/official course page → `public.svc_enrich_ai_record` → `catalogue.courses.delivery_mode`, course-campus link where proved. |
| `campus`, `campus_city` | Regulator/official campus list, provider enrichment and course-campus associations → `catalogue.campuses`, `course_campuses`; city derived from linked campus only when proved. |
| `international` | CRICOS/register, approved provider rules, quote-backed page → `catalogue.courses.open_to_international`. |
| `provider_tuition` | Course page/official fee schedule/adapter, fee identity and plausibility checks, human review where required → `catalogue.course_fees`. La Cité year-as-fee rows are still a known consumer-integrity blocker. |
| `registered_tuition` | CRICOS register only, distinct from the provider's actual yearly fee → `catalogue.course_fees`/registered fee structures; do not conflate the two authorities. |
| `intakes` | Official course-page month/term evidence + approved institution calendar **only when course/period/year/campus/audience applicability is proved** → `catalogue.course_intakes`; existing `intake-dates-apply`/Run & Validate. |
| `deadline` | Explicit course/application intake-related deadline evidenced by official page, semantic guard → `catalogue.course_intakes.application_deadline`; never use page publication/start dates as deadlines. |
| `english` | Course-specific page, else an approved provider/faculty-level policy without conflict; AI/central extraction → `catalogue.course_english_requirements`; Layer 4 where necessary. |
| `academic_entry` | Course entry evidence and provider-country qualification equivalence matrices, complete reader, E13/D-R2/D-R3, Layer 4 human decision → `catalogue.course_entry_requirements` and `catalogue.provider_entry_matrix`. |
| `description` | Stored bound course page → quote-backed AI extraction/read → Layer 4 review-first → `catalogue.courses.description`. |
| `p_website` | Provider register/site discovery → direct website field. |
| `p_address` | Register / official contact or About page → address/location fields. |
| `p_campuses` | Register campus and official provider/course location lists → provider campus records. |
| `p_type` | Register and institutional-type classification rules → provider_type_id and basis. |
| `p_international` | CRICOS/NZQA/IRCC-approved eligibility evidence → provider international flag/basis. |
| `p_logo` | Official website `logo-find` → provider assets. |
| `p_contact` | Register / official contact `provider-contact-page` → contact records/direct columns. |
| `p_scholarships` | Scholarship listing/detail sources, scholarship-ai/classification, human decision where required → `scholarship.scholarships` and related eligibility/audience. |
| `p_description` | Official provider About page, `provider-description-read`, governed review → provider description. **Registry currently says `reader=none`, “No reader yet” despite deployed reader and 5 provider-read records: confirmed metadata drift**. |

**Extra fields not represented as the 24 tracked field keys:** provider rankings from QS/THE editions and `ranking-link` → `catalogue.provider_rankings` (0 providers with rows); QILT graduate outcomes/PRISMS `svc_qilt_*` → `catalogue.provider_outcomes`, `outcome_benchmarks`; multi-country/qualification AER country matrices; provider and course regulatory status; logo asset/contacts histories; scholarship savings and provider financial profiles. These still need documented process and visibility, and should not be silently omitted from a completeness score.

## E. Current major functions, feature families and jobs
**Every exact SQL function signature is in the 2,317-row CSV.** Key *verified existing* functions include:
- **Planner / batch:** `security.enrich_plan_auto_v1`, `security.enrich_plan_v1`, `security.enrich_fields_slice_v1`, `public.svc_enrich_ai_record`, `security.enrich_worker_health_v1`; scheduled `enrich-plan-auto`, `enrich-plan-run`, `field-gap-queue`, `enrich-focus-refresh`.
- **Registration/links:** `security.layer1_register_end_dates_v1`, `security.course_url_fill_v1`; scheduled `coursefinder-layer1-regulatory-scheduler`, `coursefinder-layer1-housekeeping`, `course-link-search`, `course-url-fill`, `provider-website-check`, `provider-onboarding`.
- **Provider:** `security.provider_description_enqueue_v1`, `security.ranking_link_auto_v1`; scheduled `provider-description-read`, `provider-contact-page`, `logo-find`, `provider-type-classify`, `provider-field-daily`, `provider-facts`.
- **Fees:** `security.fee_reader_tick_v1`, `security.fee_plausibility_check_v1`; scheduled `fee-reader`, `fee-plausibility-guard`, `fee-period-settle`, `provider-fee-profiles-apply`, `fee-wording-rules`.
- **Intake:** `security.intake_dates_apply_v1`, `security.intake_dates_plan_v3`, `public.admin_intake_run_now_v1`, `public.admin_intake_progress_v1`; scheduled `intake-dates-apply`, `coverage-admit-intakes`; older `provider-calendar-intakes`/`provider-calendar-defaults` currently inactive/retiring.
- **English:** `security.provider_english_plan_v1`; scheduled `central-find`, `central-ai`, `provider-english-defaults`; grouped/faculty/level policies and Layer 4.
- **AER:** `security.entry_matrix_fire_v1`, `security.course_entry_review_apply_v1`, `security.layer4_readiness_items_v1`; scheduled `entry-matrix-read`, `aer-scheduled-read`, `aer-replay`; `aer-source-stored-find` exists but currently inactive.
- **Scholarships:** `security.scholarship_coverage_classify_v1`; scheduled `scholarship-discover`, `scholarship-listing`, `scholarship-read`, `scholarship-ai-extract`, `scholarship-coverage-classify`, `scholarship-coverage-recover`, `scholarship-auto-publish`, `scholarship-nationality`, `scholarship-savings`, `scholarship-transient-recover` (most have their own audience/source/review checks).
- **Health/first-run/consumer:** `security.progress_read_v1`; registered `platform-health`, `health-hourly`, `platform-alerts`, `course-coverage-snapshot`, `gap-causes`, `search-refresh-requested` plus the existing output contracts, Integration Queue, Website/Zoho synchronisation. A healthy cron is not a healthy downstream worker.

**Current critical G2 values (live read-only, snapshot):** `wc.aer_fair_on=0`, `aer.source_stored_find_on=0`, `entry.max_rows_per_course=6`, `entry.max_rows_by_provider=[]`, `english.default_after_withdrawn_reading=0`, `fees.guard_on=1`, `plans.stalled_onboarding_hold=1`, `intake_dates.apply_enabled=true`, `enrich.ai_calls_at_once=8`, `enrich.course_description_review_first=100000`. Disabled setting ≠ disabled scheduled job; read both. Changing settings requires a role-authorised audited action, not a bypass.

## F. Existing autonomous enrichment plans
**Ledger:** `pipeline.enrich_plan_runs`: **1,792** plan instances, `mode=auto` for all; **1,756 done**, **36 running** at snapshot. Run outcomes on done plans: 680 `succeeded_with_result`; 313 `succeeded_no_movement`; 312 `blocked_evidence`; 253 `failed_remediation`; 183 `failed_retryable`; 15 `blocked_policy`. **Outcome succeeded_with_result does NOT prove canonical field-count improvement**.
**Last 24 hours:** 71 completed; only 3 had `fields_before` and `fields_after` both present and different. The planner's six most recent hourly runs (through 10:41 UTC) each considered 12 providers and created 0 new plans; 36 open, 4 slots. This is not automatically a scheduler error without proof of eligible unblocked candidates.
**Currently running plan steps:** 36 Find course pages (34 waiting), 16 Build adapter, 9 Website/contacts/central pages (5 done), 7 Fill missing fields (3 done); these overlap by plan. Current sample plans show course-search share/day-budget/queued-url waits, followed by adapter and field steps. These plans are produced by `enrich-plan-auto` and executed by `enrich-plan-run`, not by an overnight Claude agent.

**Plan types, as operational activities:** source/site and official course link discovery; university adapter building/onboarding; central policy/fee/English/entry-page discovery and reading; missing field AI extraction; validation/review/admission where allowed; source rechecks, no-yield suppression and lifecycle recovery. They must be linked to field-gap and consumer results, and not merely counted as plans.

## G. Existing Admin functions and controls
- **Dashboard:** provider/course/scholarship/review totals; role-based next actions.
- **Catalogue:** Providers, Courses, Entry requirements, Scholarships, Rankings, source/history drill-down.
- **Layer 1:** registered source editions, reconciliation, approvals and lifecycle.
- **Layer 2/3 → Operations:** processing and lane funnels, Intake Run & Validate, Process results, policies/approved sources, review readiness and progress; currently existing `src/IntakeRunValidate.jsx` and `src/AutomationProgress.jsx`.
- **Layer 4:** governed item-level reviewer decisions, evidence, holds, approval and rejection.
- **Operations/Platform:** Scheduled jobs, Queues & yield, First-run/issue health, Models & services (Firecrawl credits), Pipeline settings/G2 limits, Platform health, alerts and releases.
- **External consumers:** existing Website API v2/Wix and Zoho API v2, frozen G3 API shape. Verify stored projections and authenticated HTTP separately.

## H. What autonomous sustainability would mean — exact definition
**Provider lifecycle closed-loop:** each registered and eligible provider is recognised → official identity and web source discovered or correctly held → all applicable fields considered with source/authority → valid values admitted under policy/Layer4 → consumer projections kept current → source/courses/registration revisions automatically trigger bounded refresh → dead/retired sources parked/archived under policy. No provider left out of the queue without a recorded legitimate reason.
**Self-healing processing:** automatic expired lease recovery, retries only for transient failures, source-gone classification, fallback to alternate authorised first-party sources, no repeated paid no-yield work, no stranded next stage, no ghost job successes. All exceptions route to an existing deduplicated integration issue with who/what/next safe action. Unknown facts remain unknown, never fabricated.
**Operator independence:** Admin UI shows field coverage by provider and domain; source, selected/candidate/held/review-ready/admitted/published stages, 24h/7d trends and net gain; next/last run, cost, caps, reason and controls; a suitably authorised user can Preview/Run Now/Verify for one course, a selected university or a bounded cohort, and follow a durable run ID without requiring Claude.
**Governance and budget:** G1–G4, manual locks and review authority remain; Firecrawl 100k plan/priority floor and model budgets are actual configurable settings, with yield per credit and hard stop/resume; no unauthorised purchase, no AI masquerading as a human reviewer, no uncontrolled destructive retirement.
**Consumer integrity:** every source-backed, approved canonical change is reflected appropriately in Website and Zoho, with independent stored/HTTP read-back and no unsupported dates/fees. Discrepancies automatically surface and are boundedly retried or held.
**Release/self-observation:** every changed job registered with a producer→consumer first-run output contract; at least two real unattended cycles verified, source-date/budget/identity and UI desktop/phone acceptance passed. Alerts distinguish generated, transport and recipient receipt. Engineering defects may still need a controlled release; the platform should neither wait for Claude to re-enqueue routine work nor claim that it autonomously rewrites production code.

### Current shortfalls (engineering present, acceptance incomplete)
1. **Provider descriptions 0/3,103 despite deployed reader and 5 providers attempted;** field register `p_description` metadata stale.
2. **Provider rankings 0 providers with entries** despite a discovered/listed ranking pipeline; source qualification/admission needed.
3. **AER scheduling fair mode OFF and stored-link source discovery OFF;** 605 review items against 600 cap, with human review still required.
4. **Course descriptions 163/44,396;** review-first `100000` and Layer4 reviewer capacity can prevent admission despite successful AI reads.
5. **Fee correctness unresolved:** 65 active La Cité calendar-year-as-fee rows require the existing exact guarded paste with human approval.
6. **Intake correctness and UI:** Deakin date-year fix deployed but course-specific eligibility and scoped one-course/selected-university Run & Validate not accepted.
7. **Plans often have no admitted field gain:** 71 finished last 24h, only 3 changed measured field counts. Correctly refused source evidence must be separated from wasted spend.
8. **Changed-job first-run output contracts incomplete** and worker response success can be hidden by green cron; #921 improves expired lease and concurrency, not all shared worker modes.
9. **Consumer HTTP and alert transport proof incomplete;** synchronised records are not necessarily publicly displayed or recipient-delivered.

## I. Maintenance mandate
- **Do not manually edit exported CSV snapshots to pretend to be live**; each carries its observation date. Regenerate only by read-only live metadata, current source control, and record commit/time.
- The active Integration Controller owns the singular execution register and updates existing IQ/SS + F-substep; no parallel issue queue.
- At every material release or independent validation, reconcile code, automation catalogue, actual cron job, G2 setting, actual source/field records, review decisions and consumer output. Update `PIPELINE-LINEAGE.md`, `UI-CATALOGUE.md`, [Feature Acceptance](../STUDYSEARCH-FEATURE-ACCEPTANCE.md) when the **design** changes, and [Programme Status](../STUDYSEARCH-PROGRAMME-STATUS.md) when production **state** changes.
- The existing hourly independent read-only validator checks for source/feature/implementation drift. A separately verified engineering scheduler is required for truly unattended Claude coding; it is not currently claimed.
