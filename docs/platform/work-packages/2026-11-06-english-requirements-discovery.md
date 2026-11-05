# English requirements: discovery and automation compatibility assessment

**Agent F (discovery only), 5 Nov 2026 19:51–20:10 AEDT.** Source decision: Platform Admin 5 Nov 2026 19:14 §4, §6, §7, §11. No code, migration or production write was made. Production was read with SELECT only, under the load policy (bulk counts at 19:56–19:58).

## 1. Summary

English requirements are a **mature, fully automated capability with two working routes**:

1. **University English policies.** Central pages are found, attached and read by the pinned AI. They are approved automatically when every score is quoted, then applied to courses by level every 10 minutes.
2. **Course-page reading.** Enrich fields reads the IELTS score from the stored course page, and `coverage-admit` admits it.

Every admitted row (30,568 active rows) carries evidence and a source key. The values are published to the website and Zoho through `english_requirements[]`.

The capability has **plateaued**: +22 AU courses with an English requirement in the last 7 days, and 0 in NZ.

| Country | Courses with an English requirement | Of active courses, published providers |
|---|---|---|
| AU | 16,083 (67.8%) | 23,732 |
| NZ | 2,381 (36.7%) | 6,495 |

The remaining gap is concentrated in two places:

- **Universities whose English rule is a faculty or course-group table.** The policy parser declines these by design. UNSW Sydney alone has 658 courses missing; Canterbury, Massey and Auckland together have 745.
- **Non-university providers.** The central-page route covers universities only: AU 5,626 courses missing, NZ 3,129.

The next bounded PR should extend the existing policy route to those two cases. It should not add a reader, a scheduler or a screen.

## 2. Inventory of existing work

### 2.1 Branches (all superseded: content released on main or archived)

None of these is an ancestor of `origin/main` because they were squash-merged. Each was checked file by file:

- Every migration in the 17 Oct–18 Oct branches is on main with the same name.
- The September–early October migrations are in `supabase/migrations-archive/` (archived by #452, readiness phase 4, after the baseline was proven) and applied live.

| Branch | Last commit | Purpose | On main |
|---|---|---|---|
| `cf247-d162-english-inspect` | 28 Sep | fee-schedule-etl v0.5.0 text inspect for English pages | yes |
| `cf247-d162-english-gate-double-degrees` | 28 Sep | UQ English Search gate; double degrees take the higher component | archived migrations |
| `cf247-intakes-english` | 2 Oct | v2.15.153 English policies and calendars panel (Decision 227); quote failures re-run (226) | partly archived; panel `src/ProviderPolicies.jsx` on main |
| `cf247-english-step3-mimo` | 2 Oct | English cascade step 3 on MiMo v2.6 Pro | archived |
| `cf247-english-uni-statements` | 2 Oct | robots.txt rule groups; worker v0.10.3 | archived |
| `cf247-central-english-propose` | 4 Oct | Central English rule written out by hand, as a proposal | archived |
| `cf247-hand-pages-english-unblocked` | 5 Oct | D254: central rules unblocked, hand-bound pages admitted (v2.15.193) | archived |
| `cf247-english-in-force` | 17 Oct | Decision 262: one policy in force per university and level; parser v0.2.5 | `20261017040000` |
| `cf247-english-level-map` | 17 Oct | Decision 264: English levels named on course pages | `20261017070000` |
| `cf247-english-level-own-differs` | 17 Oct | Decision 264 fix | `20261017080000` |
| `cf247-english-companion` | 17 Oct | Decision 265: companion pages, course-group rules, relink by rule | `20261018010000` |
| `cf247-english-companion-fix` | 17 Oct | Band 7.0 / 7+ wording | `20261018020000` |
| `cf247-english-acu-source` | 17 Oct | Person-added source read; Melbourne flags | `20261018030000` |
| `cf247-english-acu-policy` | 17 Oct | Decision 265: ACU English by course group (UAC) | `20261018040000` |
| `cf247-build-fee-english` | 18 Oct | Decision 267: readiness counts any English requirement as held | `20261018110000` |

All 15 branches can be deleted under housekeeping: no unique required work was found. Main also carries:

- `20261017050000_cf247_layer4_english_and_link_approve`;
- `20261023015000_cf247_gap_decisions_…_english_rules` (central pages found and auto-approved for every university, Platform Admin 23 Oct 12:40).

### 2.2 Code on main

**Worker:**

- `coverage-sweep`:
  - `policy.ts`: deterministic `englishPolicy` parser `provider-policy-v0.2.5`. It reads IELTS, PTE, TOEFL iBT, CAE and DET. It takes a default only where it applies to all courses of a level, and reports faculty tables and bands rather than turning them into a default.
  - `central.ts`: `english_policy` page kind.
  - `index.ts`: `enrich_ai` field `english`, IELTS overall or lowest band only.
  - `extract.ts`, `adapters.ts`.
- `fee-schedule-etl/elp.ts`: the D162 UQ ELP PDF parser. **No cron job or code on main calls `fee-schedule-etl` any more.** It is a candidate for a `retiring` check in the component register; verify edge function invocations before marking it.

**Database (live md5s, 5 Nov):**

| Function | md5 |
|---|---|
| `security.english_policy_in_force_all_v1(boolean)` | `bf32beb9bb284d4130101ffdaeb8eb40` |
| `security.english_level_apply_all_v1(boolean)` | `c568deddebc50ce2482362f73e5e2af1` |
| `security.policy_auto_approve_v1()` | `7b8f780d78c439546bcd4fc29da3bdb3` |
| `security.central_pages_attach_v1()` | `0e930780d50cbb65bea581d25a583356` |
| `security.enrich_fields_v1()` | `80ee183b324c196b4c9559cec6e3360f` |

Also used: `coverage_admission_gated_v1` and `coverage_identity_allowed`.

**Data:**

- `catalogue.course_english_requirements`: active rows IELTS 20,882, PTE 4,793, TOEFL iBT 3,191, CAE 1,027, DET 675. **100% have `evidence_id` and `source_requirement_key`.**
- `pipeline.provider_policy_proposals` (kind `english_policy`).
- `pipeline.provider_fact_sources`.

**Register:**

- `field_register.english`: reader `coverage`.
- `field_source_rules ALL:english`: `ai_stored` (Platform Admin 23 Oct 10:25).

**Layer 4:** `course_english` (1 pending, 12 approved, 2 edited, 7 rejected, 6,234 superseded). Policy approvals happen in Coverage › Attributes, English policies.

**Admin UI:**

| Screen | What it does |
|---|---|
| `src/ProviderPolicies.jsx` (English policies and academic calendars) | Policy review |
| `src/EnrichFields.jsx` | Enrich fields tasks |
| `src/course-coverage.jsx`, `GapCauses.jsx`, `UniversitiesCoverage.jsx` | Coverage and why values are missing |
| `src/Layer4Inbox.jsx` | Layer 4 cards |
| `src/PipelineSettings.jsx` | Settings |

**Tests:**

- `cf-247-d162-english-table-contract`;
- `cf-247-intakes-english-contract`;
- `cf-247-s54-layer4-english-link-contract`;
- `cf-247-s55-english-level-map-contract`;
- `cf-247-s56-english-companion-contract`.

**Consumer:** `english_requirements[]` (list and detail) in website v2 and Zoho, with `min_band_score` from `component_scores`. It is already published, and no G3 change is needed.

### 2.3 Settings (live)

| Toolset | Settings |
|---|---|
| `pipeline` | `central.auto_approve` true; `central.auto_approve_english_all` true; `central.max_disagree_pct` 50; `central.min_suggest_score` 4; `central.attach_per_kind` 3; `central.research_days` 7; `batch.coverage_admit` 500; `batch.policy_add_tests` 40; `batch.provider_facts_read` 20; `batch.provider_policy_refresh` 12; `retry.provider_facts_attempts` 3; `reading.answer_tokens.central_page` 1,500; `reading.answer_tokens.course_fields` 2,000; `enrich.focus_countries` [AU]; `enrich.focus_top_n` 50 |
| `firecrawl` | `daily_share_central` 2,500 credits |
| `openrouter` | `guard_central_ai` US$5 a day |

### 2.4 Jobs (live; runs in the last 7 days from `cron.job_run_details`)

| Job | Schedule | Rank | Runs (7 d) | Failed |
|---|---|---|---|---|
| `central-find` | 2-59/5 | 5 | 946 | 0 |
| `central-attach` | :48 hourly | 6 | 89 | 0 |
| `central-ai` (pinned GPT-4.1 mini) | */5 | 6 | 1,058 | 0 |
| `provider-facts` | */10 | — | (not counted) | — |
| `policy-auto-approve` | 5-59/10 | 6 | 529 | 0 |
| `provider-english-defaults` (in force → level apply → refresh plans) | 3-59/10 | 5 | 529 | 0 |
| `policy-add-tests` | :17 hourly | 4 | 88 | 0 |
| `coverage-admit` | 3-59/10 | 5 | 529 | 19 ("page set by hand on the course record": a Course Link matter, not English) |
| `field-gap-queue` | :23 hourly (due rule) | 6 | 60 | 2 (statement timeout) |

All the jobs are catalogued (G1).

### 2.5 Decisions and records (admin repo)

- Decisions 162, 226, 227, 254, 262 (`ENGLISH-POLICY-IN-FORCE-REPORT.md`), 264, 265 and 267.
- Platform Admin 23 Oct 10:25 (the course-page AI reads IELTS) and 12:40 (central pages found and auto-approved for every university).
- `nz-enrichment-brief/2026-11-02-missing-field-coverage-reconciliation.md` §English: proposes level-scoped rules for "rule approved but not for this level" (1,076 courses then).
- `2026-11-03-enrichment-autonomy-measurement.md`: English is Firecrawl-throttled; the standing gap run filled 13 of 3,290; IQ-00053 worker errors.
- The project's lessons docs in the claude.ai Project could not be read from this session; the Controller should check them before the PR is issued.

## 3. Measured production state (read-only, 5 Nov 2026 19:56–20:05 AEDT)

### 3.1 Coverage (active courses, published providers)

| Country / type | Courses | With English | Share | Providers |
|---|---|---|---|---|
| AU universities | 12,011 | 9,988 | 83.2% | 53 |
| AU other providers | 11,721 | 6,095 | 52.0% | 1,226 |
| **AU total** | **23,732** | **16,083** | **67.8%** | |
| NZ universities | 2,262 | 1,277 | 56.5% | 8 |
| NZ other providers | 4,233 | 1,104 | 26.1% | 281 |
| **NZ total** | **6,495** | **2,381** | **36.7%** | |

- Minimum band (component scores held): AU 8,605 (36.3%), NZ 2,191 (33.7%).
- Trend (`enrich_coverage_snapshots`, 19:00 daily): AU 16,328 on 29 Oct → 16,350 on 5 Nov (+22); NZ 2,357 → 2,381 (+24, of which 21 came from 6,474 → 6,495 courses in scope).

### 3.2 Coverage state (`course_attribute_coverage`, all active)

| State | AU | NZ |
|---|---|---|
| admitted | 16,350 | 2,381 |
| page states none (`not_on_page`) | 3,975 | 1,096 |
| site known, no course page | 3,713 | 2,661 |
| page found, not read | 765 | 272 |
| awaiting Layer 3 | 114 | 1 |
| in review | 55 | 3 |
| blocked | 96 | 48 |
| no website | 308 | 20 |

### 3.3 University policies (published, with active courses)

| Country | Universities | Approved English policy | Pending | Without a policy |
|---|---|---|---|---|
| AU | 53 | 39 | 4 | 10 |
| NZ | 8 | 5 | 0 | 3 |

The largest gaps by provider (courses missing English):

| Provider | Missing | Approved policy? | Why |
|---|---|---|---|
| UNSW Sydney | 658 | no | Proposals `rejected`: a faculty row, and the Bengaluru page (Platform Admin 17 Oct 15:01). The international entry page reads `no_values`. |
| Canterbury | 267 | no | `no_values` |
| Massey | 241 | no | |
| Auckland | 237 | no | Three pages, all `no_values` |
| NZIST Work-Based Learning | 231 | no | |
| UniMelb | 159 | yes | Courses outside the levels or groups of the rule |
| Flinders | 118 | yes | As above |
| Southern Institute of Technology | 112 | no | |
| Bond | 111 | yes | As above |

### 3.4 Last 7 days, course-page route (`field_enrich_items`, field `english`)

| Outcome | Items | Note |
|---|---|---|
| filled | 25 | |
| page does not state it | 2,508 | |
| failed, "no answer could be recorded after 3 tries" | 586 | All on 2 Nov (IQ-00053); none since |
| page is for another course | 553 | Course Link |
| page not proved | 453 | Course Link / E-rule |
| quote has no IELTS score | 163 | |
| other | 38 | |

AI cost: US$2.38 for the skipped items and US$0.02 for the filled items.

### 3.5 Top reasons for missing values

1. No course page (site known only): AU 3,713, NZ 2,661. This is acquisition, gated by Firecrawl spend (D1: paid course-page search stays off).
2. The course page does not state English, and no university or provider rule covers the course's level or group: AU 3,975, NZ 1,096.
3. Universities with faculty or course-group tables and no default: UNSW, Auckland, Canterbury, Massey.
4. Non-university providers: the central-page route attaches and auto-approves for universities only.
5. Wrong or unproven course page: about 1,000 a week. That belongs to Course Link, not English.

## 4. Gap analysis

| Done | Broken or weak | Missing | Retiring |
|---|---|---|---|
| Both routes automated and catalogued. One policy in force per university and level. Level map and companion pages. Course-group rules (ACU). Tests added after approval (DET). Evidence on 100% of rows. Consumer published. Settings under G2. Layer 4 kind. | 1. **The plateau:** +22 a week.<br>2. The course-page AI reads **IELTS only**. Other tests come only from policies.<br>3. The policy parser returns `no_values` for faculty and course-group tables, so the biggest universities stay uncovered.<br>4. 586 worker failures on 2 Nov, with no detail kept. That is resolved since, but the cause is not stored. | 1. **Course-group or faculty tables as proposals** for universities with no default (Decision 265 did this by hand for ACU; it is not general).<br>2. **The central English route for non-university providers** (TAFE, polytechnics, colleges), behind a scope setting.<br>3. **A per-provider "why no English rule" status** (pages tried, parser outcome, next try) on the existing English policies panel.<br>4. A consumer publication check for policy-applied rows. | `fee-schedule-etl` `elp.ts` (D162) has no caller on main. Verify and mark it `retiring` in `pipeline.component_register`. The archived MiMo step-3 cascade (2 Oct) is superseded by the pinned `central-ai`; confirm it is off live. |

## 5. Automation compatibility assessment

- **Reuses:**
  - `central-find` (`central.ts` `english_policy` kind), `central-attach`, `provider-facts`, `central-ai` (pinned model) and `policy-auto-approve`;
  - `provider-english-defaults` (in force, then level apply);
  - the Decision 265 course-group rules and relinking by rule;
  - `provider_policy_proposals` and `provider_fact_sources`;
  - the Layer 4 `course_english` kind;
  - `ProviderPolicies.jsx`;
  - the `guard_central_ai` and `daily_share_central` budgets;
  - generic Run Now.
- **Changes:**
  - `policy.ts`: report faculty and course-group tables as group rules, not defaults. A new parser version is needed.
  - `security.central_pages_attach_v1`: provider scope from a new setting `central.english_provider_types`, default `["university"]`, so behaviour is unchanged on release.
  - `security.policy_auto_approve_v1`: group rules always go to a person on first approval per provider.
  - `ProviderPolicies.jsx`: the why-no-rule status column.
- **Replaces:** nothing. The by-hand course-group rule path (Decision 265) stays and is the template.
- **Retires:** `fee-schedule-etl` `elp.ts`, once a live check confirms no caller (marked `retiring` with `replaced_by` = `coverage-sweep policy.ts`; dropped later by a paste file, not by a migration).
- **Conflicts:**
  1. `coverage-sweep` is owned by agent B until #877 is integrated (`index.ts`; `policy.ts` and `central.ts` sit in the same function deployment).
  2. The intake workstream shares `provider_policy_proposals` (academic calendars) and `provider-english-defaults` also refreshes calendar plans. Do not touch the calendar branches or the intake scheduler.
  3. The Firecrawl spend for non-university central pages needs a Platform Admin decision.
  4. `coverage-admit` failures on hand-set pages belong to Course Link.
- **Protects:**
  - one policy in force per university and level (Decision 262);
  - a course's own page score wins over its level rule when they differ (Decision 264);
  - double degrees take the higher component (D162);
  - research degrees held back;
  - Layer 4 for disagreements (`central.max_disagree_pct`);
  - no new automatic admission authority (the new group rules go to a person first);
  - the consumer shape (G3: rows only into `course_english_requirements`);
  - "a passing qualification never switches anything on".
- **Validates:**
  - s54, s55 and s56 and the intakes-English contract stay green;
  - a new spec for group rules and provider scope, against production-parity fixtures (live definitions with the md5s above; constraints, triggers and grants of `course_english_requirements`, `provider_policy_proposals` and `layer4_review_items`);
  - s32, s42, s57 and s120;
  - a measure: courses covered per week, plus a per-university before and after for UNSW, Auckland, Canterbury and Massey.

## 6. Proposed PR: "English requirements: course-group tables and provider scope" (one bounded PR)

**Branch:** `cf247-english-requirements-complete`.

**Migration family:** to be assigned by the Integration Controller. The suggested range is `20261106550000`–`20261106599999`.

**Scope:**

1. **Parser (`policy.ts`, after #877 is integrated).** A faculty or course-group English table is returned as a set of group rules: the group name as printed, the tests, the scores and a quote for each row. A new parser version is needed. Only the policies whose last reading was `no_values` or `rejected as a faculty row` are re-read, from their **stored** copies, so the re-read costs no Firecrawl.
2. **Database.**
   - Group-rule proposals bind to courses by the existing Decision 265 rule matcher (relinking by rule).
   - The first approval for each provider goes to a person (the English policies panel and Layer 4). After that, the existing auto-approval rules apply only if the Platform Admin approves (decision 2 below).
   - New setting `central.english_provider_types` (list; default `["university"]`), read by `central_pages_attach_v1` (md5 guard `0e930780…`) and `policy_auto_approve_v1` (md5 guard `7b8f780d…`).
   - A per-provider status function returns: pages tried, outcome, next try, and why there is no rule.
3. **Admin UI (existing screen only).** On `ProviderPolicies.jsx`:
   - a status column and filter: no page found, page read with no values, group table proposed, approved, rejected with reason;
   - a governed Run Now for the policy re-read through the existing `provider-facts` job;
   - a responsive check if the panel is reachable from a phone.
4. **Housekeeping.** Verify `fee-schedule-etl` has no live caller, then add the `retiring` component register row.
5. **Docs.** Admin SOP section for English policies (group tables, provider scope) and the test register.

**Tests (production-representative):**

- parser unit tests on real page layouts (UNSW faculty table, Auckland pages; stored copies, no user data);
- a Postgres spec on the parity fixture for the group binding and scope setting;
- s54, s55, s56 and s32, s42, s57, s120.

**Acceptance measures (14 days after release):**

- UNSW, Auckland, Canterbury and Massey each have an approved rule or a named reason;
- AU courses with English rise from 16,083 by at least 600 (UNSW alone is 658 missing);
- NZ universities at least 75% (from 56.5%);
- 0 policy overlaps (Decision 262 report stays 0 flags);
- 0 consumer shape changes;
- AI and Firecrawl spend within existing guards.

**Risks:**

- Group binding may mis-assign a course. This is mitigated by person approval first and the Decision 264 rule that the course's own score wins.
- The shared `provider-english-defaults` job also refreshes calendar plans, so the change must not touch that call.
- Extending to non-university providers raises central-page Firecrawl use: an estimated 3–8 credits a provider (not measured). 1,507 AU and NZ non-university providers is at most about 12,000 credits, spread under `daily_share_central` 2,500 a day.

**Platform Admin decisions needed:**

1. **Spend:** switch `central.english_provider_types` to include non-university providers (AU 5,626 and NZ 3,129 courses missing), within the existing `daily_share_central` (2,500 a day). The PR ships it **off**.
2. **Approval authority:** whether group-table rules may be auto-approved after a provider's first person approval, as university defaults are today (`central.auto_approve_english_all`). The PR ships person-only.
3. Optional and separate: extend the course-page AI reader beyond IELTS (PTE and TOEFL). This adds tests per course, not coverage. Recommended later.

No G3.

**Dependency:** `policy.ts`, `central.ts` and `index.ts` are in the `coverage-sweep` function owned by agent B until **#877 is integrated and released**. The database functions are not owned by B, but their release must follow #877 so the worker and the parser version ship together. Before release, check the intake workstream's ownership of the calendar side of `provider_policy_proposals`.
