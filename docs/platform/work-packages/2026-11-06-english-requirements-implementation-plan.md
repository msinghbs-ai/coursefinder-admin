# English requirements: implementation plan, fixture and refreshed coverage

**Agent H, 6 Nov 2026, 08:24 to 09:00 AEDT.** This is planning and validation preparation only. The Platform Admin direction of 6 Nov 2026 08:12 was: "continue safe parallel planning and independent validation for course descriptions and English requirements without modifying shared reader functions currently owned by #877".

- No PR was opened, and no migration, function or worker change was made.
- Production was read with SELECT only, in the load windows:
  - catalogue reads at 08:25–08:34 and 08:43–08:45;
  - bulk counts at 08:56–08:57.
- The input is the discovery report, `2026-11-06-english-requirements-discovery.md`.
- This plan corrects the discovery where live reads showed something different (§1).

**Pilot branch (test and fixture work only, no PR):** `cf247-english-requirements-complete` at `a9c735d7`. It holds:

- the parity manifest, the stored evidence, a database round trip and a baseline spec (§12);
- the test register, updated for the new spec.

## Contents

1. [Corrections to the discovery](#1-corrections-to-the-discovery-measured-6-nov)
2. [Refreshed coverage](#2-refreshed-coverage-read-only-6-nov-0856-aedt)
3. [The one bounded PR](#3-the-one-bounded-pr-english-requirements-complete)
4. [Exact functions and files](#4-exact-functions-and-files-live-md5s-6-nov-0831-aedt)
5. [What waits for #877 and what is database-only](#5-what-waits-for-877-and-what-is-database-only)
6. [Spend: measured, shipped off](#6-spend-measured-shipped-off)
7. [Layer 4](#7-layer-4)
8. [Consumer publication verification](#8-consumer-publication-verification-no-g3-change)
9. [Acceptance measures](#9-acceptance-measures-14-days-after-release-measured-baselines)
10. [Risks](#10-risks)
11. [Decisions needed](#11-decisions-needed-platform-admin)
12. [Production-parity fixture and baseline](#12-production-parity-fixture-and-baseline-status)

## 1. Corrections to the discovery (measured 6 Nov)

| # | Discovery said | Live state | Consequence for the plan |
|---|---|---|---|
| C1 | "The central-page route covers universities only." | **No provider-type filter exists anywhere on the route.** The university wording is in comments and the AI prompt only. `central_pages_attach_v1`, `central_ai_enqueue_v1`, `svc_provider_policy_record` and `policy_auto_approve_v1` take every provider type. Approved English policies today: AU 39 universities, plus **71 other AU providers** (HEI 19, private VET 43, TAFE 10, university college 2); NZ 5 universities, plus **8 other NZ providers** (polytechnic 7, private 1). | If the scope setting ships university-only, it **switches off working automation** for these providers' future pages, which the 19:14 §6 assessment forbids. The PR ships the setting with **today's behaviour** (every type) and it changes nothing (§3.2; decision D1). |
| C2 | "No cron job or code on main calls `fee-schedule-etl`." | Two live jobs call it: `provider-document-check-monthly` (`23 21 1 * *`) and `provider-document-check-weekly-q4` (`23 21 * 10-12 1`), mode `check_documents`. The last call was 2 Nov 21:23 UTC. The edge request log (30 Oct–5 Nov, 50,000 slots) shows **no `elp_dry_run` or `elp_apply` call**. | The edge function stays. Only the English parts retire: the modes `elp_dry_run` and `elp_apply`, `elp.ts`, `svc_english_table_preview`, `svc_english_table_apply` and `security.english_table_plan_v1` (§3.4). |
| C3 | `central-find` ran 946 times in 7 days. | The `central-find` job is **inactive now** (`cron.job.active = false`). The central maps of AU/NZ providers were taken 11–22 Oct. | Universities that need a new English page (Canterbury, Massey) get none until it is switched back on or a page is attached by hand. That is a Controller and Platform Admin matter, not this PR's. |
| C4 | UNSW, Canterbury, Massey and Auckland are "faculty-table" universities. | Only **UNSW** has a stored faculty table. **Canterbury's** only stored page is the Education faculty's IELTS test-centre page (the wrong page). **Massey** has no English page stored; its only candidate is an English-language-courses page that scored 3.7, below the attach score of 4. **Auckland's** three stored pages were read by the AI as course-specific with no values. | Group-table reading helps UNSW (and Auckland only if its verbatim page shows a table). Canterbury and Massey need a page first, which is decision D4. |
| C5 | The UNSW gain is 658 courses. | Group rules applied through `english_level_apply_v1` reach only courses whose page was read (`g.read_status = 'read'`): **454 of UNSW's 658** missing. All 658 have a field of education (`primary_field_id`). | The group rule binds through the plan and apply route (§3.1), which covers every active course. Otherwise the AU +600 target is out of reach. |

## 2. Refreshed coverage (read only, 6 Nov 08:56 AEDT)

The scope is the same as the discovery: active courses at active, published (not hidden) providers.

| Country / group | Courses | With English | Share | With minimum band | From a policy | Providers |
|---|---|---|---|---|---|---|
| AU universities (incl. university colleges) | 12,011 | 9,988 | 83.2% | 6,723 | 4,686 | 53 |
| AU other | 11,721 | 6,095 | 52.0% | 1,882 | 247 | 1,226 |
| **AU** | **23,732** | **16,083** | **67.8%** | | | |
| NZ universities | 2,262 | 1,277 | 56.5% | 1,262 | 808 | 8 |
| NZ other | 4,233 | 1,104 | 26.1% | 929 | 94 | 281 |
| **NZ** | **6,495** | **2,381** | **36.7%** | | | |

**No change since the discovery (5 Nov 19:56).** The `enrich_coverage_snapshots` trend is flat:

| Country | 27 Oct | 3 Nov | 5 Nov | Change |
|---|---|---|---|---|
| AU | 16,291 | 16,350 | 16,350 | +59 |
| NZ | 2,357 | 2,381 | 2,381 | +24 (21 of them from the course scope growing from 6,474 to 6,495) |

**`course_attribute_coverage` (English):**

| State | AU | NZ |
|---|---|---|
| admitted | 16,350 | 2,381 |
| not on page | 3,975 | 1,109 |
| site known, no course page | 3,713 | 2,663 |
| page found, not read | 765 | 270 |
| awaiting Layer 3 | 114 | 1 |
| no website | 308 | 20 |
| blocked | 96 | 48 |
| in review | 55 | 3 |
| candidate | 4 | 0 |

**Where each provider stands on the policy route.** Providers, with missing courses in brackets:

| Stage | AU universities | AU other | NZ universities | NZ other |
|---|---|---|---|---|
| 1 Rule approved | 39 (1,239) | 71 (978) | 5 (240) | 8 (461) |
| 2 Rule proposed, waiting | 1 (6) | 10 (63) | 0 | 4 (178) |
| 3 Page stored, no rule (re-read costs nothing) | **6 (752)** | **77 (858)** | **2 (504)** | **14 (316)** |
| 4 Page attached, not stored | 4 (23) | 76 (376) | 0 | 8 (102) |
| 6 Only candidates scored under 4 | 0 | 12 (40) | 1 (241, Massey) | 3 (23) |
| 7 Site mapped, no English page found | 3 (3) | 822 (2,648) | 0 | 198 (1,583) |
| 8 Site not mapped | 0 | 158 (663) | 0 | 46 (466) |

**The four universities:**

| University | Active courses | With English | Missing | Missing with a read course page | Missing with a field of education |
|---|---|---|---|---|---|
| UNSW Sydney | 667 | 9 | 658 | 454 | 658 |
| Canterbury | 280 | 13 | 267 | 195 | 265 |
| Massey | 265 | 24 | 241 | 141 | 239 |
| Auckland | 458 | 221 | 237 | 79 | 237 |

**A further lever, outside this PR.** Providers with an approved rule still miss AU 2,217 and NZ 701 courses. The plan function records why each one is held: named in the policy, double degree, research, exit award, or a level the default does not cover. VET certificates and diplomas map to no level group, so the non-university part is probably mostly that, but the split by reason was not measured in this pass. A VET level group is a separate decision. It is not in this PR.

## 3. The one bounded PR: "English requirements complete"

- **Branch:** `cf247-english-requirements-complete`.
- **Migrations:** `20261106550000`–`20261106599999`, one migration file plus, if needed, one fix-forward.
- **Prerequisite:** it starts after #877 is released, and after the course-descriptions PR if that one also edits `coverage-sweep/index.ts` (both wait for #877; the Controller orders them).

### 3.1 Group-table rules (faculty and course-group tables)

**Parser: `coverage-sweep/policy.ts`, `provider-policy-v0.3.0` (waits for #877).**

- Where v0.2.5 today sets `by_faculty` or `bands` and drops the rows (the baseline proves this, §12), v0.3.0 also returns `groups`. Each group is `{ group_name (as printed), level (undergraduate | postgraduate | research | null), reqs[] (every test, with the cell quoted) }`. This covers both table shapes:
  - columns are levels, rows are faculties (UNSW);
  - columns are tests, rows are course groups.
- `defaults`, `exceptions`, `named`, `caveats` and `signals` keep their v0.2.5 meaning, so `policy-add-tests` and in-force are unaffected.
- A row headed "All programs except where specified" stays a default, as today.
- `POLICY_PARSER` changes, so the proposal key `(fact_source_id, parser, content_hash)` allows a new row. The fixture proves that the same parser cannot add a second row.

**Re-read from stored copies only (waits for #877).**

- New worker mode `provider_facts_reparse`. It takes `svc_provider_policy_reparse_next(p_parser, p_limit)` (new). That function lists English documents with stored evidence whose latest reading is `no_values`, or `rejected` with a faculty note, and that have no proposal from the current parser.
- The worker downloads the stored copy, as `provider_facts_add_tests` already does, and records the result through `svc_provider_policy_record`.
- **No Firecrawl call and no AI call.**
- It is scheduled by adding a second submit to the existing `policy-add-tests` job command, sized by `security.pipeline_num_v1('batch.policy_reparse', 20)`. There is no new job; the catalogue row's description is updated. The Controller may prefer a separate catalogued job; that is decision D5.

**Database.**

1. **`svc_provider_policy_record`** (md5 guard `16b04b31…`). A reading with non-empty `groups` is filed as status `proposed` with style `course_groups`. It is not `no_values`, which is what makes it a proposal today. The status check allows only `proposed`, `no_values`, `approved`, `rejected` and `superseded`; the fixture proves that a new status is refused.
2. **The first approval for each provider is always a person's.** `policy_auto_approve_v1` approves only `parser like 'ai:%'` (and dated calendars), so a deterministic group proposal is never auto-approved. The baseline spec asserts this. The PR adds no new authority.
   - After the first approval, auto-approval of later group readings from the same provider happens only if decision D2 says so. It would come through a new setting `central.auto_approve_english_groups` (0 = off, shipped off), read in `policy_auto_approve_v1` (md5 guard `7b8f780d…`).
3. **Binding groups to courses.**
   - The approving person confirms or edits a binding for each group. A binding is a list of fields of education (ASCED codes) and an optional title pattern; the existing `level_rules` shape is extended with `fields`.
   - New RPC `admin_provider_english_groups_set_v1(p_proposal_id, p_bindings, p_reason)` (Platform Admin, logged in `admin_control_events`).
   - The proposal shows suggested bindings, computed from the faculty name against `ref` field names and the provider's own course titles. They are only suggestions.
4. **Applying through the plan and apply route,** not only `english_level_apply_v1`.
   - `security.provider_english_plan_v1` (md5 guard `60f58926…`) gains a step before the default. A course matched by an approved group binding takes that group's requirements, with plan `group` and reason "for this course group (name)".
   - The existing order still holds, so that **a course's own page beats a central rule, and central rules only fill gaps**:
     - named course;
     - held cases (research, exit award, double degree at different levels, locks, in review, page waiting);
     - `agrees` / `differs` / `other_value` for courses that already have a reading.
   - `provider_english_apply_v1` (`760c173d…`) writes `group` rows with `source_requirement_key = 'policy:<id>:<test>'` and a note naming the group, through `coverage_apply_course_v1`, as today.
   - Because of the `(course_id, english_test_id)` unique key, a withdrawn row is reused, never duplicated. The fixture proves the second insert is refused.
5. **One policy in force (Decision 262).** `english_policy_in_force_v1` (`7add799e…`) compares defaults per level, and it stays unchanged. A group proposal carries its page's default row, if any, as its `defaults`, so the existing in-force rule chooses between documents as before. Group rows apply only to bound courses. The Decision 262 report must stay at 0 overlaps.

### 3.2 Provider-type scope setting (G2)

- **New setting:** `central.english_provider_types`, toolset `pipeline`, kind list. Range: the active `ref.provider_types` codes, or `*`. Label: "Central English pages: provider types". Unit: "provider types". `used_by`: `security.central_pages_attach_v1; security.central_ai_enqueue_v1`.
- **Shipped value: `["*"]`, today's behaviour (C1).** The function reads it, so a later change is a setting change with a reason, not a migration.
- It is read in `central_pages_attach_v1` (`0e930780…`) when attaching new pages, and in `central_ai_enqueue_v1` (`e2cf9db0…`) when queuing AI readings.
- It does not touch approvals already made, and nothing is withdrawn.
- If the Platform Admin wants "university-only" literally, that is decision D1, with its stated consequence (C1).

The spend lever for non-universities is a **separate, new switch**, shipped **off**: `central.english_search_non_university` (0/1), with `batch.english_search_non_university`.

- It seeds `pipeline.provider_fact_search` rows of kind `english_policy` for providers at stages 7 and 8 (§2).
- The provider's own website host is the search domain. Today `svc_provider_facts_search_next` (`14c68d372eb6…`) joins `course_link_recipes`, which only about 150 providers have; it gains a fallback to the website host.
- It runs inside the existing `provider-facts` job and the `daily_share_central` budget. That budget is checked by `useFcWhy`, so the database records any refusal.
- The worker is unchanged: `provider_facts` already searches, reads, stores and records.

### 3.3 "Why no rule" on the existing English policies panel

- **New read function `security.english_policy_status_v1(p_provider uuid default null)`** (STABLE, SECURITY DEFINER, Pipeline Operator and above through the existing `admin_provider_policies_read`). It returns one row per provider with:
  - `stage`: the eight stages of §2;
  - `pages_tried`: URL, status and attempts;
  - `last_reading`: parser, status, style and note;
  - `why`, in plain words. Examples:
    - "Only page found is an IELTS test centre page";
    - "Faculty table: waiting for a person to bind groups";
    - "Site mapped on 11 Oct; no English page";
    - "Not searched: provider type out of scope";
  - `next_try`: due date from `central.research_days` or `central_refresh_days`, or "needs a person".
- **`admin_provider_policies_read`** (`fd6fdad2…`) adds a `why_no_rule` list. This is additive; it is not part of the consumer API.
- **`src/ProviderPolicies.jsx`, English branch only:**
  - a "No rule yet" view with the stage, why and next try, filterable by stage;
  - a governed Run Now ("Read stored pages again") that calls the existing `job_run_now_v1` for the reparse step;
  - the group-binding editor, inside the existing review row.
- The **intake workstream owns the calendar branch** of this file, so the PR edits only the `english` branches.
- The panel subtitle "parsed without AI" is out of date; AI readings exist since 12 Oct. It is corrected.
- The panel is not one of the phone-operated screens (`s121`). One `@responsive` check is added only if the Controller says the panel is used from a phone.

### 3.4 Retiring the old English parser in `fee-schedule-etl` (D162)

- **Live check done (C2).** No `elp_*` call appears in the edge request log window. No job or Admin UI code calls those modes. The UQ rows it wrote stay: they are data, with evidence, and are not withdrawn.
- **Edge function `fee-schedule-etl` v0.9.0:**
  - removes the `elp_dry_run` and `elp_apply` modes and the `elp.ts` import;
  - keeps `inspect`, `dry_run`, `apply` and `check_documents`.
- **`pipeline.component_register`:** `retiring` rows with `replaced_by = 'coverage-sweep policy.ts (provider-policy-v0.3.0)'` and `retire_after` = release + `hygiene.retire_after_days` (14), for:
  - `fee-schedule-etl:elp`;
  - `public.svc_english_table_preview`;
  - `public.svc_english_table_apply`;
  - `security.english_table_plan_v1`.
- The functions are dropped later by a **paste file**, never by the migration.
- **G4:**
  - `cf-247-d162-english-table-contract` is retired in the same PR, with the reason in the register's retirement log;
  - `cf-247-d162-fee-schedule-contract` is updated for the version line.
- **Before release:** re-read the edge request log on the day, because its window is about 7 days, and record the result in the PR.

## 4. Exact functions and files (live md5s, 6 Nov 08:31 AEDT)

The PR's migration guards each one on its live md5 before replacing it. All of them are in the committed manifest; the baseline spec pins the eight starred ones.

| Object | md5 | PR action |
|---|---|---|
| `public.svc_provider_policy_record(uuid,jsonb)` * | `16b04b3170fae3fc97a5c632d7111fe5` | replace: `groups` gives `proposed` |
| `security.policy_auto_approve_v1()` * | `7b8f780d78c439546bcd4fc29da3bdb3` | replace: D2 setting, off |
| `security.central_pages_attach_v1()` * | `0e930780d50cbb65bea581d25a583356` | replace: reads `central.english_provider_types` |
| `security.central_ai_enqueue_v1(uuid)` | `e2cf9db03152405152d9a1edd94a9a67` | replace: reads the same setting |
| `security.provider_english_plan_v1(uuid)` * | `60f5892657ef976634b12914d91f24a9` | replace: `group` step |
| `security.provider_english_apply_v1(uuid)` | `760c173d759c77e0cfa9fa8c04355e14` | replace: writes `group` rows, note |
| `public.admin_provider_policies_read(text,uuid)` * | `fd6fdad2d073a4530d61e4f7d274ef31` | replace: adds `why_no_rule` and group bindings |
| `public.svc_provider_facts_search_next(integer)` | `14c68d372eb69d1487e5a887d4a81d20` (light read, 6 Nov 09:0x; add to the manifest in the PR) | replace: website-host fallback behind the D3 switch |
| `security.english_level_apply_v1(uuid,boolean)` * | `271a9600d80d8e6e3aa1e5644bd7ae80` | unchanged: guarded as read |
| `security.english_policy_in_force_v1(uuid,boolean)` | `7add799eb55048372f61239f3648fcc3` | unchanged |
| `security.english_policy_in_force_all_v1(boolean)` * | `bf32beb9bb284d4130101ffdaeb8eb40` | unchanged (job `provider-english-defaults`) |
| `security.english_level_apply_all_v1(boolean)` * | `c568deddebc50ce2482362f73e5e2af1` | unchanged |
| `security.provider_policy_refresh_one_v1(uuid)` | `c29c87dc0b8f024bd6f51c6ec0be47d9` | unchanged |
| `public.svc_central_ai_record(bigint,jsonb,numeric,text)` | `652cb70460b903b106b51edf157d27f4` | unchanged (calendar branch belongs to intake) |
| `public.svc_provider_english_add_tests_v1(uuid,text,jsonb,text)` | `5f8b4c1b36708c735bbf1ec902f4b0ea` | unchanged (must ignore `groups`; spec) |
| `security.layer4_course_english_apply_impl(uuid,uuid,jsonb,text)` | `eecfed536853b6ba16165e4c78cd166c` | unchanged |
| `public.admin_provider_english_propose(uuid,jsonb,text,text)` | `436b0bec1a5fbf6430c03b1106fa8e17` | unchanged (hand path; D4 uses it) |
| `public.svc_english_table_preview` / `svc_english_table_apply` / `security.english_table_plan_v1` | `446eb9ea…` / `e894ba7f…` / `14602af7…` | `retiring` (§3.4) |
| new: `security.english_policy_status_v1`, `public.svc_provider_policy_reparse_next`, `public.admin_provider_english_groups_set_v1` | none yet | new |

**Files:**

- `supabase/functions/coverage-sweep/policy.ts` (v0.3.0) and `index.ts` (mode `provider_facts_reparse`, worker version line).
- `supabase/functions/fee-schedule-etl/index.ts` (v0.9.0); `elp.ts` is left in place, marked retiring, and removed with the paste.
- `src/ProviderPolicies.jsx` (English branch).
- `supabase/migrations/2026110655xxxx_cf247_english_requirements_complete.sql`.
- `tests/uat/cf-247-english-groups-contract.spec.mjs` (new).
- `tests/fixtures/english-requirements/*` (this branch).
- `docs/platform/TEST-REGISTER.md`.
- Admin: SOP section "English policies: course groups and provider scope".

## 5. What waits for #877 and what is database-only

| Part | Needs `coverage-sweep`? | Can be prepared now |
|---|---|---|
| Parser v0.3.0 (`policy.ts`) and mode `provider_facts_reparse` (`index.ts`) | **Yes. Waits for #877.** #877 changes `index.ts` and `description.ts`; `policy.ts` ships in the same deployment. | Parser unit tests against the verbatim stored pages, once the Controller fetches them (§12). |
| `svc_provider_policy_record` filing `groups`; plan and apply `group` step; bindings RPC; status function; panel read | No: database and UI | Yes, on this branch, against the parity fixture. They must not be released before the parser, or they do nothing (harmless, but untestable live). |
| Scope setting `central.english_provider_types` (`["*"]`) | No | Yes |
| Non-university search switch (off) and `svc_provider_facts_search_next` fallback | No: the worker's `provider_facts` mode is unchanged | Yes |
| `fee-schedule-etl` English retirement | No, but it is a deploy of another edge function | Yes |
| `ProviderPolicies.jsx` | No. #877 does not touch it; the intake workstream shares the file (calendar branch). | Yes |

**Recommendation.** One PR, opened only after #877 is released. Its database and UI half can be built and tested on this branch beforehand, and the parser half is added after the rebase. Releasing the database half first as its own release would break the "one active PR per capability" rule. It is not proposed.

## 6. Spend: measured, shipped off

**Measured unit costs (`coverage_vendor_usage`, last 45 days, 6 Nov 08:56):**

| Purpose | Credits per event | Credits per provider | Events (all types) |
|---|---|---|---|
| `central_map` (non-university) | 1.00 | **3.56** | 6,313 over 1,774 providers |
| `provider_facts_search` (Firecrawl search) | **2.00** | 6.00 (3 kinds) | |
| `provider_facts_scrape` (non-university) | **2.91** (PDF pages raise it) | | |
| `provider_facts_scrape` (universities) | 1.40 | | |

**Already stored, so re-reading costs 0 credits and $0 (deterministic parser, no AI):**

- 6 AU universities (752 missing courses);
- 2 NZ universities (504);
- 77 AU other providers (858);
- 14 NZ other providers (316).

These are covered by §3.1 with no spend decision.

**Non-university central search (decision D3, shipped off).** Estimate built from the measured unit costs and the measured counts in §2:

| Stage | Providers | Missing courses | Credits a provider | Credits |
|---|---|---|---|---|
| 7 Mapped, no English page (AU 822, NZ 198) plus 6 Candidate under 4 (AU 12, NZ 3) | 1,035 | 4,294 | 1 search (2.00) plus 1 to 3 pages (2.91 each): 4.9 to 10.7 | **5,100 to 11,100** |
| 8 Not mapped (AU 158, NZ 46) | 204 | 1,129 | map (3.56) plus 1 to 3 pages: 6.5 to 12.3 | **1,300 to 2,500** |
| 4 Attached, not stored (AU 76, NZ 8): retry | 84 | 478 | 1 page (2.91) | **about 250** |
| **Total** | | | | **about 6,650 to 13,850** |

- At `daily_share_central` (2,500 a day), that is **3 to 6 days** of the central share, if nothing else uses it.
- **The yield is unproven.** The whole-site map found any English candidate for only about 16% of the non-university AU/NZ providers it mapped (219 of about 1,400 with a completed map, read 6 Nov 08:27, all providers with active courses). Small VET providers usually state English on course pages, not on a central page.
- **Recommendation: a pilot first.** Take 50 stage-7 providers, largest missing first, for about 250 to 535 credits. Measure the found-page rate and the approved-rule rate, then decide the rest.
- The AI reading cost stays inside `guard_central_ai` (US$5 a day): central-ai, pinned GPT-4.1 mini, one call a page.

## 7. Layer 4

- **No new Layer 4 kind.** Course rows written by a group rule follow `course_english`, as policy rows do today.
- A course whose own page disagrees is handled by the existing `differs` outcome and Decision 264: the course's own reading is never replaced, and the policy row is withdrawn.
- A move in force (Decision 262) still raises `course_english` items.
- Approving and binding groups happens on the English policies panel (Coverage › Attributes / Adapter builder), the same place policies are approved today. `admin_provider_policy_decide` (`5ba211ff…`) is unchanged.
- **`src/Layer4Inbox.jsx` is not touched.** #877 changes it.
- **Group rules never go to Layer 4 for approval.** A person approves the proposal itself. Layer 4 sees only course-level disagreements.

## 8. Consumer publication verification (no G3 change)

**Path.** Rows land in `catalogue.course_english_requirements`, through `coverage_apply_course_v1`. Then `search.refresh_course_enrichment_scoped_v1`, already called by the apply functions, refreshes the projections. From there they reach:

- `api.website_v2_course_item(uuid,text[],text[])` (`8f2a0ac9…`) and `website_edge_course_search_v1` (`c238f70f…`): `english_requirements[]` on list and detail;
- `zoho_v2_export_page` (`96f85530…`) and `api.zoho_course_lookup_v1` (`ae31644b…`): Zoho.

**Verification after release (read only):**

- For 20 courses written by group rules (UNSW first), call `api.website_v2_course_item` and `api.zoho_course_lookup_v1` with SELECT. Compare test code, overall and `min_band_score` with the catalogue rows.
- The `consumer-api-guard` job must stay clean, and `s57` must stay green.
- **Any consumer function or table shape change fails the PR.**

## 9. Acceptance measures (14 days after release; measured baselines)

| Measure | Baseline (6 Nov) | Target |
|---|---|---|
| AU courses with English | 16,083 | **≥ 16,683 (+600)**. UNSW group binding over every active course (658 missing) plus the 5 other stored-page AU universities (94). |
| UNSW | 9 of 667 | Approved group rule; at least 600 with English, or a named reason each |
| NZ universities | 1,277 of 2,262 (56.5%) | ≥ 75% **only if D4** (Canterbury and Massey pages attached). Without D4, Auckland gets a rule or a named reason, and Canterbury and Massey show their reason on the panel. |
| Every AU/NZ provider without a rule | not visible | Has a stage and a "why" on the panel |
| Policy overlaps (Decision 262 report) | 0 | 0 |
| Consumer shape changes | 0 | 0 (`s57`, `consumer-api-guard`) |
| Automatic approvals of group rules | n/a | 0 unless D2 |
| Firecrawl credits for non-universities | 0 | 0 unless D3; within the approved pilot if D3 |
| `fee-schedule-etl` English modes called | 0 (log window) | 0; `retiring` rows present |

## 10. Risks

1. **A group binding mis-assigns a course.**
   - Mitigation: a person approves the bindings, the bindings are suggestions only, and Decision 264 stops a course's own score from being replaced.
   - Every group row's note names the group, so a wrong binding is undone by editing the binding. Rows are withdrawn, not deleted.
2. **Scope setting shipped university-only (C1).** It would stop new central English pages for the about 1,500 published AU/NZ non-university providers, 79 of which already have an approved rule from this route. Mitigation: ship `["*"]`, D1.
3. **`provider-english-defaults` also refreshes calendar plans.** The PR does not change that job's command or the calendar functions (intake workstream, closed). The `svc_central_ai_record` calendar branch is untouched.
4. **Same-file overlap.**
   - `coverage-sweep/index.ts` is shared with #877 and the course-descriptions PR. Rebase after both and re-run `s56` and `intakes-english`.
   - `ProviderPolicies.jsx` is shared with intake (calendar branch).
5. **The unique key `(course_id, english_test_id)`.** A group write must update a withdrawn row, not insert one. It is proven refused in the fixture, and `coverage_apply_course_v1` must be checked for this in the PR spec.
6. **Verbatim pages are not yet in the fixture** (§12). The parser change must not be accepted on the layout stand-in alone. That would be synthetic-only acceptance, which rule 9 forbids.
7. **The edge request log window is about 7 days**, so the retirement claim must be re-checked on release day.
8. **`central-find` is inactive (C3).** The stage counts for "not mapped" will not move without it.

## 11. Decisions needed (Platform Admin)

| # | Decision | Recommendation |
|---|---|---|
| D1 | Scope setting value. The direction said "shipped university-only", but the live route already serves every type (C1). | **Ship `["*"]` (no change).** University-only would stop new central English pages for non-university providers. |
| D2 | May group-table rules be auto-approved after a provider's first person approval? | **Ship off (person-only).** Decide after 14 days of approvals. |
| D3 | Firecrawl search for non-university providers' central English pages. | **Pilot of 50 providers (about 250 to 535 credits)**, then decide the rest (about 6,650 to 13,850 credits; 3 to 6 days of the central share). |
| D4 | Canterbury and Massey have no usable English page. Attach one by hand (`admin_provider_english_propose`, found_via manual), or turn `central-find` back on (Controller). | **Attach by hand.** About 2 pages, 0 search credits. The NZ 75% target depends on it. |
| D5 | Reparse scheduling: a second submit inside `policy-add-tests`, or its own catalogued job. | **Inside `policy-add-tests`** (no new scheduler). |
| D6 | A VET level group for courses outside undergraduate, postgraduate and research (part of the AU 2,217 and NZ 701 missing at providers that already have a rule; measure the split by plan reason first). | **A separate bounded item, not this PR.** |

## 12. Production-parity fixture and baseline: status

**Pilot branch `cf247-english-requirements-complete`, commit `a9c735d7`.** Test and fixture work only; no PR.

### Manifest

`tests/fixtures/english-requirements/manifests/english-path.json` was built with `scripts/prod-parity-capture.mjs` from production on 6 Nov 08:31 AEDT, read only:

- **Target tables:** `course_english_requirements`, `provider_policy_proposals`, `provider_fact_sources`, `central_ai_queue`, `layer4_review_items`.
- **Lookups:** `ref.english_tests`, `ref.provider_types`, `ref.study_levels`.
- **Referenced tables:** 4.
- **Functions:** 38, each md5-verified.
- **Facts:** 282.
- **Missing:** 0.

### Database round trip: `run.sh` (local PostgreSQL 16, database `h_english_fixture`) passes

- The fixture checks clean against the manifest. The one allowed difference is the PostgreSQL 17 `MAINTAIN` grant.
- The five functions this plan replaces carry their live md5.
- The production constraints refuse, each on its named constraint:
  - a new proposal status;
  - a new `found_via`;
  - a duplicate proposal key;
  - a second row for a course and test.
- Today's stored cases are filed through the live copy of `svc_provider_policy_record`:
  - the UNSW faculty table, read by today's parser, gives `no_values`;
  - the 17 Oct UNSW AI reading gives `proposed`;
  - the three Auckland AI readings give `no_values`.

### Baseline spec

`tests/uat/cf-247-english-baseline-contract.spec.mjs` (Guards: decision 19:14 §8) has 5 tests. They pass, together with `s32`, `s42`, `s57` and `s120`: 23 passed. The test register is updated, with 1 spec and 5 tests added.

### Stored evidence

`stored-outcomes.json` holds the fact sources, content hashes, storage paths and every proposal for UNSW, Auckland, Canterbury and Massey. It was read with SELECT and contains no personal data.

### Open: verbatim pages

The page bodies are in the private `evidence` bucket. Agents cannot read them without a dispatch, so the parser baseline uses only the UNSW cells that the database holds verbatim, inside a layout stand-in.

- **Next step for the Controller:** run the read-only worker mode `provider_facts_inspect` for the six fact sources listed in the fixture README.
- The returned text is checked against `sha256 = content_hash`, then added as `pages/<id>.md`. The parser regression base then becomes verbatim.

### Tool defect, reported to agent E

`prod-parity-capture.mjs` prints a `public` function's signature without its schema, so the fixture creates stray schemas named after those functions. It is harmless, and the check is clean.
