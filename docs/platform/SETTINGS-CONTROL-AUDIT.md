# Can the platform be run from its settings? Audit of settings against hard-coded values

**Version:** 1.0 (13 Oct 2026, platform release v2.15.268)
**Change control:** CF-247
**Asked by:** Platform Admin, 13 Oct 2026 21:34: "Validate that mocked up UI can control the platform from settings and variable available and no hard coded or further settings are in the code that drives the platform."
**Basis:** read from the live database (project fxcwkweaxjtknorudmwp) and the deployed worker code (`coverage-sweep` v0.21.6), 13 Oct 2026. Measurement only; nothing was changed.
**Scope:** what drives the platform: the 91 scheduled jobs, the database functions they and the worker call, and the worker. The admin app only reads and writes through admin functions, so it is covered through them.

## 1. Answer in brief

**Not yet.** The money limits are controllable from screens today. These are the Firecrawl daily budget and its shares, the per-university and monthly caps, the OpenRouter guards and floor, and the adapter allowance. The mock-up shows all of them.

Four kinds of value that drive the platform are still fixed in code or have no screen:

| Gap | How many | Example |
|---|---|---|
| Batch sizes written into job schedules | 26 jobs | "Admit official page and English" takes 500 courses a run; only 4 jobs can be changed on Pipeline settings |
| Timing rules written into functions | about 30 values in 14 functions | Scholarship pages are read again after 90 days, while the setting "Read again after" says 30 |
| Settings tables with no screen | 10 tables | Provider fee profiles, scholarship AI settings, capacity policy |
| Values fixed in the worker | 6 groups | Firecrawl reads use the "basic" proxy in 13 places, while the "Proxy" setting only affects manual Firecrawl runs |

There are also settings on screen that do nothing today:
- the Layer 3 items on Pipeline settings;
- two settings tables that nothing reads.

Job schedules (how often each job runs) can be paused and resumed but not changed on any screen.

Some values should stay in code. These are the safety timers that free a stuck claim (5–20 minutes) and the pinned AI models. Section 7 explains why.

## 2. What can be controlled from a screen today

| Settings store | Screen that changes it | What it controls | In the mock-up |
|---|---|---|---|
| Toolset settings (87 values) | Models & services › Toolsets & limits | Firecrawl daily budget and shares, per-university scholarship cap, search stop rule, target universities, page reading, adapter builder allowance and model, adapter evaluation thresholds, OpenRouter guards and floor, notices, Serper and ScrapingBee plans | Services & limits (budgets shown; the rest under "More settings") |
| Course-page search settings | Scheduled jobs › Priority queue (search budget) and Pipeline settings | Monthly search cap (200,000) | Services & limits |
| Scholarship layer settings (9) | Layer 2 › Scholarships | Discovery, listing and read batch sizes, overall Firecrawl cap and reserve, auto-publish, re-read days | Not shown: needs a home (Discovery & reading › Scholarships) |
| Onboarding settings | Layer 2 › Onboarding | Universities at once (100), auto-admit, auto-start | Not shown: needs a home (Onboarding page header) |
| Scholarship AI extraction settings and models | Scholarships › Extraction | Model order, instructions, qualification | Settings › AI models |
| Central pages AI settings | Models & services › AI & OpenRouter | Central pages model | Settings › AI models |
| Adapter shadow settings | Layer 2 › Adapters | Shadow reading | Discovery & reading |
| Award link and fee range settings | Layer 2 › Adapters | Exit award and fee range tolerances | Pipeline settings |
| Link refresh policies, fee wording rules, scholarship skip rules | Automations, Fee rules, Scholarships coverage | Re-check cadence of course links, fee wording, pages to skip | Pipeline settings and Review |
| Environment settings and keys | Settings | Service keys, environment gates | Services & limits (keys per service) |
| Pipeline settings (screen) | Settings › Pipeline settings | Matcher batch and concurrency, link search per minute, course read batch, identity rules | Pipeline settings |

## 3. Settings tables with no screen

These are read by the platform but can only be changed by a database change.

| Table | Read by | Recommendation |
|---|---|---|
| `provider_fee_profiles` | Apply provider fee profiles (hourly) | Add to Pipeline settings › Fees |
| `provider_fee_basis_rules` | Admit tuition under provider fee rules | Add to Pipeline settings › Fees |
| `scholarship_ai_settings` | Scholarship AI (4 functions) | Add to Settings › AI models |
| `platform_capacity_policy` | Capacity reading | Add to Storage & capacity |
| `retention_class_policies` | Retention | Make them editable on Storage & retention |
| `evidence_capacity_policy` | Evidence capacity | Storage & capacity |
| `acquisition_policies` | 2 functions | Check use; retire if Layer 2 trials only |
| `admission_lifecycle_policy` | 1 function | Check use; retire or Pipeline settings |
| `publication_control_settings` | nothing | Retire (unused) |
| `scholarship_runtime_settings` | nothing | Retire (unused) |

## 4. Batch sizes written into job schedules

How much each run takes is written into the job itself. Only `coverage-ai-match`, `coverage-ai-match-prepare`, `course-link-search-worker` and `coverage-read` can be changed (on Pipeline settings). The scholarship jobs read their sizes from the scholarship settings.

| Job | Fixed value | What it means |
|---|---|---|
| coverage-admit | 500, and the extractor version `coverage-sweep-v0.5.6` | Courses admitted a run; the version is a fixed text that must change with the extractor |
| coverage-admit-intakes | 300 | Courses a run |
| adapter-overwrite | 200 | Values a run |
| fee-period-settle | 500 | Fees a run |
| link-refresh | 500 | Links a run |
| provider-basis-rule-admit | 200 | Fees a run |
| course-link-reverse | 30 | Universities a minute |
| course-link-search | 20 | Courses queued a minute |
| coverage-bind | 30 | Universities a run |
| provider-english-defaults | 12 | Policies a run |
| admin-jobs | 10 | Task items a minute |
| layer1-run-driver | 3 | Register runs a minute |
| coursefinder-layer1-regulatory-scheduler | 20 | Sources an hour |
| coursefinder-m2-3-refresh-intelligence-tick | 100 | Policies an hour |
| layer2-onboarding-snapshot | 100 | Universities |
| coverage-discover / coverage-discover-2 | 20 / 8 | Sites mapped a minute (two workers) |
| coverage-find-site | 5 | Websites looked for a run |
| coverage-reextract | 200 | Saved pages re-read a minute |
| coverage-reidentify | 300 | Pages re-identified a minute |
| central-find | 4 | Universities a run |
| provider-facts | 12 searches, 20 reads | A run |
| provider-contact-page | 8 | Providers a run |
| cricos-peo | 2 | A minute |
| evidence-link-index | 200 | A run |
| evidence-storage-dedupe-daily | 100 | Files a day |

**Recommendation:** one "Throughput" section on Pipeline settings, grouped by step, with each job's size, its range and the reason for any change. It should use the same mechanism Pipeline settings already uses for four jobs.

## 5. Timing rules written into functions

These decide how often things are read again and how long a university waits. They are business rules, not technical ones.

| Area | Fixed values | Where | Recommendation |
|---|---|---|---|
| Course pages | Read again after 7 days; retry a failed read after 6 hours | `svc_coverage_read_record` | Pipeline settings › Reading |
| University sites | Map again after 30 days; retry a failed map after 6 hours | `svc_coverage_discovery_record` | Pipeline settings › Reading |
| Website finder | Try again for a provider with no website after 30 days | `svc_coverage_site_next`, `svc_coverage_site_record` | Pipeline settings › Websites |
| Scholarship pages | Read again after **90 days**; blocked pages after 2 days; failed reads after 6 hours; name mismatch after 30 days | `svc_scholarship_read_record` | Use the existing "Read again after" setting (30 days). Today the two disagree; decide which is right |
| Scholarship candidate pages | Check again after 90 days; failed after 6 hours | `svc_scholarship_candidate_record` | Scholarship settings |
| Scholarship listing pages | Read again after 7 days | `svc_scholarship_listing_record` | Scholarship settings |
| Scholarship AI | Read with AI again after 90 days; retry after 10 or 30 minutes | `svc_scholarship_ai_record` | AI models (re-read); retries stay in code |
| Course search stop | Counts searches over the last 7 days (the count of 30 is a setting) | `fc_search_stopped_v1` | Add "over the last N days" next to the existing setting |
| Onboarding | Re-check a university waiting for course pages after 1 hour; step time-outs of 10 to 90 minutes; repeat a step after 7 days; at most 2 adapter proposals; 300 sample courses; 250 universities checked a minute | `provider_onboarding_step_v1`, `provider_onboarding_tick_v1` | Onboarding settings: re-check interval, proposal attempts, sample size. Time-outs stay in code |
| Provider facts | At most 3 attempts; retry after 20 minutes | `svc_provider_facts_search_next`, `svc_provider_facts_read_next` | Pipeline settings › Central pages |
| CRICOS contacts | Check again after 180 days | `svc_cricos_peo_next` | Pipeline settings |

## 6. Values fixed in the worker (`coverage-sweep` v0.21.6)

| Value | Where | Effect | Recommendation |
|---|---|---|---|
| Firecrawl proxy "basic" | 13 scrape calls (course pages, scholarships, central pages, website finder, adapter samples) | The "Proxy" setting on Toolsets › Firecrawl › Read pages only applies to manual Firecrawl runs | Pass the setting to every read, or relabel the setting "Manual runs only" |
| Firecrawl map size 500, search results 8, page waits | Site mapping and search | Credits a university uses | Move to Toolsets › Firecrawl (Find pages) |
| Time-outs of 8 to 60 seconds per call, and 110 seconds per run | Every call | Technical | Keep in code |
| AI course-page matching model (`qwen3-30b`) and the page-identity model list | `AI_MATCH_MODEL`, `PAGE_ID_MODELS` | Pinned on purpose: results are bound to a qualified model | Keep pinned. Show it read-only on AI models; changing it is a release with a qualification |
| Directory and keyword lists, month names | Extraction | Reading rules | Keep in code (rules of reading, versioned with the extractor) |
| Extractor and worker version texts | Every record | Audit trail | Keep in code |

## 7. What should stay in code, and why

- **Claim and lease timers (4 to 20 minutes) and stuck-work recovery.** They stop two workers taking the same item. Changing them by hand risks double reads and double spend.
- **Fire guards (3 minutes) and duplicate windows.** Same reason.
- **Pinned AI models.** A model change must be qualified first. A passing qualification never switches a model on by itself.
- **Reading rules and extractor versions.** They are versioned with the code so every value can be traced to the rule that produced it.

## 8. Settings on screen that do nothing today

| Setting | Where | Why | Recommendation |
|---|---|---|---|
| Layer 3 route limit, concurrency, requests a day, daily US$ and credit floor | Settings › Pipeline settings | Layer 3 retired 12 Oct; the jobs they change no longer exist | Remove from the screen |
| Read pages: proxy, wait, time-out, location, formats; Runs: calls at once, batch | Toolsets › Firecrawl | Only manual Firecrawl runs use them | Label "Manual Firecrawl runs" or apply them everywhere (section 6) |
| `publication_control_settings`, `scholarship_runtime_settings` | No screen | Nothing reads them | Retire |

## 9. How this maps to the mock-up

| Mock-up screen | Already controls | Needs adding |
|---|---|---|
| Services & limits | Firecrawl budget and shares, caps, search stop rule, OpenRouter guards, plans | Proxy and map size for all reads (section 6); keys per service |
| Settings › AI models | Scholarship and central pages models, guards | Scholarship AI settings table; pinned models shown read-only |
| Settings › Pipeline settings | Matcher, link search, course read | Throughput for the other 26 jobs (section 4); timing rules (section 5); fee profiles and basis rules |
| Onboarding (page header) | Universities at once, auto-admit, auto-start | Re-check interval, proposal attempts, sample size |
| Discovery & reading › Scholarships | Scholarship settings | Listing, candidate and AI re-read days; resolve the 30 or 90 days conflict |
| Jobs & schedules | Pause, resume, run now | Change how often a job runs (with a reason) |
| Storage & capacity | Purge | Capacity, retention and evidence policies |

## 10. Recommended next steps

1. Decide the scholarship re-read rule: 30 days (the setting) or 90 days (the code).
2. Build one settings register (key, section, value, range, unit, which job or function uses it, last change and reason) behind Pipeline settings. Move sections 4 and 5 into it, so every business value has one home and an audit trail.
3. Remove the Layer 3 items from Pipeline settings, and relabel or apply the Firecrawl read settings.
4. Add a "Change schedule" action on Jobs & schedules (Platform Admin, with a reason).
5. Retire the two unused settings tables (a paste file, as they drop tables).
