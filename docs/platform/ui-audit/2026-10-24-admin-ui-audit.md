# Audit This Admin App.

> Exported 2026-10-24 11:13 · AI-generated content. Check before relying on it

## Audit this admin app. Visit every panel …

Audit this admin app. Visit every panel in the navigation and produce: panel name, what
data it shows, which platform tables it reads (infer from content/labels), and any panel
that appears duplicated, unused or empty. Flag anything that shows raw IDs, JSON or
internal state a user shouldn't see. Output as a markdown table I can paste into the repo.

I'll audit each of the 19 navigation panels. Starting with the Dashboard, then moving down the nav in order.

The Providers panel is loaded. I'll use a faster approach for the remaining panels — clicking via script and reading the result.

Archived tab has content (the text reader missed it; checked via DOM). Moving on to Provider contacts.

Layer 2/3 exposes a raw PL/pgSQL error — notable finding. Continuing to Layer 4 Review.

All 19 panels audited. Here's the complete report.

#### Panel inventory

| # | Panel | What it shows | Inferred tables read | Flags |
|---|-------|---------------|----------------------|-------|
| 1 | **Dashboard** | Inbox queue counts by issue kind (12 kinds, 1,975 items), entity totals (providers 3,101, courses 44,370, scholarships 2,059), failed jobs/automations | `inbox_items`, `providers`, `courses`, `scholarships`, `jobs` | Duplicates Layer 4 Review counts (intentional summary, but two sources of truth for the same numbers) |
| 2 | **Courses** | Course catalogue (44,370 records) with filters for country, level, field, fee, freshness, status | `courses`, `providers`, `course_attributes` | ⚠️ Raw composite internal keys shown under every name (`course:ca:ircc_dli:o19361259712:bc_epbc_program_guid:3068b02c-…`); COURSE CODE column displays raw GUIDs; internal jargon filter "MIN LEGACY PRESENCE"; at least one row with a blank course name |
| 3 | **Providers** (tabs: Providers / Campuses / Logos & assets / Archived) | Provider catalogue (3,091), campuses (4,332), logo coverage, archived providers (10) + inactive courses (7,979) | `providers`, `campuses`, `provider_assets`, `courses` | ⚠️ Raw provider IDs (`provider:cricos:00098g`), campus IDs (`campus:cricos:02664k:1-city-view-road-…`); internal adapter states ("Admitting", "Testing") and "Auto (register rules)" shown verbatim; truncated provider name ("…BMIHMS at To"); archived provider literally named "N/A" |
| 4 | **Provider contacts** | Recruitment contacts (31 active, 11 providers) with verification & provenance | `provider_contacts`, `providers` | ⚠️ Staff PII (names, personal-looking emails, phone numbers) — intended function, but confirm role-gating; raw provider IDs repeated; header rendered twice ("Provider contacts" + "CATALOGUE MODULE Provider Contacts") |
| 5 | **Scholarships** (tabs: Scholarships / Coverage) | Published scholarships (1,106 of 1,436 held), per-provider coverage vs listing pages | `scholarships`, `scholarship_links`, `providers` | Near-duplicate rows ("2026 ECU Sri Lanka Undergraduate Scholarship" vs "…for International Students"); dashboard count (2,059) vs panel count (1,436 held) never reconciled on screen |
| 6 | **Rankings & statistics** (tabs: Overview / Compare / QILT / PRISMS / Datasets) | QILT (3,164 obs), PRISMS (1,135 obs), QS/THE editions, dataset registry, ranking file imports | `qilt_observations`, `prisms_observations`, `ranking_observations`, `ranking_imports`, `evidence` | ⚠️ Raw import filenames (`THE_year2024.txt`), internal job names ("Layer1 Ranking Etl"), raw date grain (`2025-01-01 → 2025-12-31`); import UI headed "REFERENCE DATA / RANKING IMPORTS" — appears duplicated/mislabelled vs the Reference data panel |
| 7 | **Reference data** (tabs: All / Key dates / Reference sources) | Key dates (deadlines/intakes), 59 third-party reference sites with health checks | `key_dates`, `reference_sites` | ⚠️ Raw HTTP status codes shown to users (`HTTP 200`, `HTTP 403`); internal use-flags ("Never a university website") as data values |
| 8 | **Coverage & completeness** (tabs: Courses / Attributes / Progress) | Completeness score (57.6%), attribute-admission histogram, daily trend snapshots | `course_attribute_states`, `coverage_snapshots` | ⚠️ "Fully complete courses" drops 5,660 → 0 between 19–20 Oct with no explanation — metric looks broken; pipeline jargon ("admitted", "Layer 2 attribute") in user-facing copy |
| 9 | **Layer 1 Register** (tabs: Registers / All layers / Needs attention) | Source registry: 38 sources, health, schedules, last/next run | `sources`, `source_runs` | 10 Canadian college sources "Needs attention / Not run" since Aug — possibly dead/unused source configs |
| 10 | **Layer 2/3 Build & enrich** (9 tabs: Operations … Scholarships) | Pipeline stage funnel, stopped/failing work, onboarding pace | `universities`, `adapters`, `jobs`, `inbox_items` | 🔴 **Raw database error exposed**: `ERROR: the link must be a full https:// web address CONTEXT: PL/pgSQL function layer4_course_link_apply_impl(uuid,uuid,jsonb,text) line 10`; internal vendor name ("firecrawl") and job slug (`coverage-admit`) in user-facing alerts |
| 11 | **Layer 4 Review** (tabs: By university / By kind / Decided) | Human review inbox: 1,975 items across 697 universities | `inbox_items`, `universities`, `courses` | Content duplicates Dashboard counts (by design); otherwise clean |
| 12 | **Platform health** (tabs: Health checks / Work queues / Storage & retention) | 15 automated checks, open issues, queue watchdogs | `health_checks`, `job_runs`, `queues` | 🔴 Raw cron expression (`*/10 * * * *`), schema-qualified SQL function in error text (`security.layer4_course_link_…`), raw ISO timestamps (`2026-10-23T23:51:21.788982+00:00`), internal route fragments (`#layer-2-discovery?tab=operations`); permanent nav badge "Something is broken" duplicates the in-page alert |
| 13 | **Scheduled jobs** (tabs: Automations / Jobs / Task manager) | 134 automations, run history (37,388 runs/24 h), per-job schedules | `jobs`, `job_runs`, `automations` | 🔴 Raw job slugs (`coverage-admit`, `provider-basis-rule-admit`), same raw PL/pgSQL error as Layer 2/3; internal memo references ("Decision 262", "Decision 241") in descriptions |
| 14 | **Evidence** | 171,239 saved artifacts with extraction/integrity status | `evidence_artifacts`, `extractions`, `jobs` | 🔴 Raw artifact hashes (`8086f584…`), storage SHA fragments (`5ac9fc86371a…`), internal job slug (`provider_course_page_sweep`), raw state strings ("Missing Extraction", "No Policy", "Current Or Unversioned", "Private object present") |
| 15 | **Settings** (tabs: Settings / API usage / Backup & restore) | Pipeline settings: budgets, page-identity proofs per country, institution-type rules | `settings`, `institution_type_rules` | ✅ Keys explicitly never shown — good; cleanest panel |
| 16 | **Models & services** (tabs: Services / AI & OpenRouter / Toolsets & limits / Fetchers) | AI model registry (10/32 on), OpenRouter config, vendor credits | `ai_models`, `model_qualifications`, `service_configs` | ⚠️ Vendor account balances exposed (OpenRouter "US$21.21 left", Firecrawl "339,038 of 500,000 left"); raw model IDs (`qwen/qwen3-30b-a3b-instruct-2507`); Services tab is only 4 summary cards — looks unfinished |
| 17 | **Go-live checklist** | Production cutover checklist: env targets, secrets strategy, migration manifest | `environment_config`, `checklist_items` | 🔴 Infrastructure internals: env var names (`VITE_SUPABASE_PUBLISHABLE_KEY`, `VITE_SUPABASE_URL`), Supabase project refs, Vault key strategy, edge-function URLs, pg_cron; 🔴 raw Postgres error banner `canceling statement due to statement timeout` at top of panel |
| 18 | **Users & roles** | 9 auth users, roles, effective role, audit trail of access changes | `auth.users`, `user_roles`, `audit_events` | ⚠️ User UUID fragments (`c3456df4…f07f`), personal Gmail addresses, internal system account (`automation@system.coursefinder.invalid`), audit actor emails; 🔴 same raw `canceling statement due to statement timeout` banner |
| 19 | **Guides** (tabs: Platform guide / Admin SOP / Operator SOP) | Static documentation, role matrix, daily routine | none (static content) | 🔴 Same raw statement-timeout banner leaks onto a docs page; "What changed" section references release internals |

#### Cross-cutting findings

| Finding | Severity | Panels affected |
|---------|----------|-----------------|
| Raw Postgres error `canceling statement due to statement timeout` rendered as a global banner | 🔴 High | Go-live checklist, Users & roles, Guides (recurs across panels) |
| Raw PL/pgSQL error with internal function signature `layer4_course_link_apply_impl(uuid,uuid,jsonb,text)` shown to users | 🔴 High | Layer 2/3, Platform health, Scheduled jobs |
| Internal composite IDs shown as data (`course:ca:ircc_dli:…`, `provider:cricos:…`, `campus:cricos:…`, artifact/SHA hashes, user UUID fragments) | 🟠 Medium | Courses, Providers/Campuses, Provider contacts, Evidence, Users & roles |
| Infrastructure/vendor internals exposed (env var names, Supabase refs, Vault, cron syntax, OpenRouter/Firecrawl credit balances, model IDs, job slugs) | 🟠 Medium | Go-live checklist, Platform health, Models & services, Scheduled jobs, Layer 2/3 |
| Duplicated functionality: inbox counts on both Dashboard and Layer 4; ranking-import UI labelled "REFERENCE DATA" inside Rankings › Datasets | 🟡 Low | Dashboard / Layer 4; Rankings / Reference data |
| Unused/stale config: 10 Layer 1 sources never run since Aug; 6 paused automations; Models & services › Services tab effectively empty | 🟡 Low | Layer 1, Scheduled jobs, Models & services |
| Data-quality leaks: archived provider named "N/A", blank course-name row, near-duplicate scholarships, truncated provider name, "fully complete" metric dropping to 0 overnight | 🟡 Low | Providers › Archived, Courses, Scholarships, Coverage |
| Version mismatch: inner-panel header shows **v2.15.340** while title bar/Dashboard show **v2.15.339** | 🟡 Low | All inner panels vs Dashboard |

**Top three to fix first:** (1) suppress raw database/SQL errors behind a generic message + error reference ID, (2) strip internal identifiers and hashes from list views (move behind an "inspect" drawer), (3) hide infrastructure config (env vars, project refs, cron syntax) from the Go-live checklist or gate it to a deployment-only role.
