# Platform throughput, gap detection at hours, and schema additions — plan and estimate

**Date:** 23 Oct 2026, 22:40 AEDT
**Status:** plan and estimate only. Nothing built, applied or scheduled until the Platform Admin approves.
**Supersedes:** the sequencing in the thread of [2026-10-23-nz-brief-decisions.md](2026-10-23-nz-brief-decisions.md) (section 7, entries 21:49 and 21:56). The diagnostic findings those entries hold remain the evidence base for this plan.
**Mandate:** Platform Admin, 23 Oct 2026 22:11 (consolidated mandate, quoted in section 9).

Every figure below was read from the live project (`fxcwkweaxjtknorudmwp`) on 23 Oct 2026 between 22:15 and 22:35, read-only.

---

## 1. Final ordered work plan

Effort is one person's elapsed working days, including dry run, full suite, apply, live verification and change control. Nothing here starts before approval, and each item is its own release unless marked "same release".

| # | Item | What ships | Depends on | Effort |
|---|---|---|---|---|
| 1 | **Q2 Empty-tick backoff** | `security.mode_backoff_v1(mode)` read by `svc_worker_settings_v1`: a mode whose last N ticks found nothing skips ticks on a rising schedule (settings `tick.backoff_after_empty` 5 [2–20], `tick.backoff_max_minutes` 15 [1–60]). Any new eligible work resets it. No cron change. | none | 0.5 day |
| 2 | **Q4 Publish-readiness hardening** | Clear the three stuck lanes: central AI (99, blocked on `central_ai_settings.enabled` and leases), onboarding (12), companion read (failing each run). Each gets a lease-expiry sweep and a per-lane "why idle" line in `admin_queue_watch()`. | none | 0.5 day |
| 3 | **Q3 Durable per-mode ledger** | Schema change 4 (`pipeline.mode_outcome_ledger`), written by `svc_worker_report_v1` at the end of every worker call, 90-day retention through the existing `retention-worker` job. | none | 1 day |
| 4 | **Q1 Search scheduler release** (section 3) | Per-course stop replaces the per-provider stop; daily picked-courses cap `search.daily_picked_cap` 100 [10–2,000]; `target_only` audit and staged release. Ships after one week of ledger data (item 3) so the cap can be ramped on evidence. | 3, C-Q1b audit signed off | 1.5 days (0.5 audit, 1 build) |
| 5 | **S2 Freshness in the readers** | Schema changes 1 and 2; fee reader points the older year's row at its successor (`superseded_by`) and sets `status = 'superseded'` (existing value); English and intake readers set `as_at` from the page year, else the read date; a fee year more than `fees.max_years_ahead` (1 [0–3]) ahead goes to Layer 4. | none (schema first) | 1.5 days |
| 6 | **Speed 1 handoff on bind** (section 4) | Row trigger on `coverage_course_pages` status → `bound`, gated by setting `handoff.on_bind` (off until switched on deliberately). | 3 (so the effect is measurable) | 1 day |
| 7 | **Speed 2 hourly delta** (section 4) | Schema change 5 (`pipeline.health_snapshots`), `security.health_hourly_v1()` at minute 11, rendered by the existing hourly report panel (no new panel). Headline metric target set from the first full ledger week. | 3, 5 (for the freshness rows) | 1.5 days |
| 8 | **S1 Negative evidence and circuit breaker** | `pipeline.page_rejections` (the one persisted exception the mandate allows) plus `next_attempt_at` on `coverage_course_pages`; read by `svc_course_link_search_next`, `coverage_ai_match_*` and `source_find` (all three verified by a contract test that plants a rejection and proves each lane skips it); after `pages.max_distinct_wrong` (8 [3–20]) the course goes to Layer 4 as `needs_person` through the existing reason catalogue. | 3 | 2 days |
| 9 | **S3 Config-over-code CI check** | `scripts/check-settings-literals.mjs` run in the deployed workflow: a new numeric literal in a pool, timeout, limit, retry, batch or token position in `supabase/functions/**` fails the PR unless the line reads a setting or carries `// fixed:`; the top 20 literals moved to settings in the same release. | none | 1.5 days |
| 10 | **Speed 3 weekly matrix** | Existing `enrich-coverage-snapshot` and `gap-causes` extended with per-field unblock levers and the 0 % fields (entry requirements academic, scholarship-to-course match, EER/work-rights when approved). Written to `pipeline.enrichment_coverage_snapshots` (exists). | 7 | 1 day |
| 11 | **S5 Country-readiness generator** (section 6) | `security.country_readiness_v1(iso2)` returning every settings key, identity rule, floor, calendar, currency and admission row a country needs, with present / missing. Run on CA as the acceptance test. | none | 1.5 days |
| 12 | **O2 / O3 / O6 30-day reviews** | Rows in the hourly delta (item 7) flag CA sub-floor Layer 4 volume and the item 5 retraction rate; the Platform Admin decides. | 7 | in 7 |

**Total: 14 days.** Critical path: 3 → 4 (one-week ledger baseline) → 7. Items 1, 2, 5, 9 and 11 are independent and can run in the gaps.

Not in this plan, by the mandate's constraints: no new admin panels, no new SOPs or guides (the runbook addition is section 8 of this file), no new status values, no gap-flag booleans on catalogue rows.

---

## 2. The `bound_at` finding

**Confirmed present; nothing to add.** `pipeline.coverage_course_pages` already has `bound_at timestamptz`, and it has no `updated_at` column at all. Live check:

| Check | Result |
|---|---|
| Rows with `status = 'bound'` | 27,925 |
| of which `bound_at` is null | **0** |
| latest `bound_at` | 2026-10-23 10:51 UTC |
| Rows with other statuses (`mismatch` 7,105, `ambiguous` 540) | 7,645, all with `bound_at` set |
| Triggers on the table | one (`coverage_page_refused_host_guard`, a host guard, not a timestamp) |

Every bind path in the migrations sets `bound_at = now()` on the status change (`course_page_rebind_v1`, the programme-list bind, the manual bind, the calendar refind). So schema change 3 is **dropped**; the hourly "bound but empty > 12 h" set uses `bound_at` directly. Today that set is **3,675 courses** (bound more than 12 hours ago with no active fee and no active English requirement), which is the Speed 2 starting number.

---

## 3. Q1 release design: daily cap and the `target_only` audit

### 3.1 What the gate actually holds (re-counted for the audit)

The diagnostic's "1,130 courses not a Firecrawl target" splits into two very different groups once `pipeline.firecrawl_target_cache` is read directly:

| Group | Providers | Unbound courses | What the cache says |
|---|---|---|---|
| A. In the cache, `included = false` | 87 | 388 | `rule_match = false` on every row; `override_reason` is **null on every row** |
| B. Not in the cache at all | 349 | 1,445 | never evaluated by `firecrawl-targets` |

So no exclusion carries a recorded reason today. By country: AU 15 excluded providers (386 courses), CA 72 excluded providers (2 courses), NZ 0 excluded. Group B is where most of the held courses are.

### 3.2 Audit approach (C-Q1b), read-only, before any release

One SQL pass writes a paste file (`docs/platform/wrong-page-values/PASTE-<date>-target-only-audit.csv`, no migration) with one row per provider in groups A and B and a derived reason:

| Derived reason | Test | Outcome |
|---|---|---|
| `robots` | `provider_website_checks` last result shows robots or a blocked home page | keep excluded, record the reason |
| `deliberate_list` | provider is in `search.skip_providers` or `provider_hidden` | keep excluded, record the reason |
| `past_failure` | `fc_search_stopped_v1` style history: 30 searches with no correct page in the last 7 days | keep excluded, record the reason; S1 takes it from here |
| `never_evaluated` | group B | run `firecrawl-targets` for the provider; release if it passes the domain rule |
| `rule_false_no_reason` | group A with nothing above | release in the first ramp batch; the domain rule is re-run first |
| `other` | anything left | listed for the Platform Admin, not released |

The audit result is written back as `override_reason` on the cache row (a text column that already exists; no schema change), so every exclusion carries its reason from then on. Providers whose reason no longer holds are released by setting `included = true` in a paste file the Platform Admin runs, never by the migration.

### 3.3 The daily cap (C-Q1)

| Setting | Default | Range | Unit | Section |
|---|---|---|---|---|
| `search.daily_picked_cap` | 100 | 10–2,000 | courses per UTC day | Course page search |
| `search.stop_per_course_after` | 6 | 3–20 | distinct wrong pages | Course page search |

`svc_course_link_search_next` gains one gate before the budget gates: picks today (counted from the ledger, item 3) `< search.daily_picked_cap`. The provider-level `search_stop_after` (30) stays as a ceiling but stops being the first gate; the per-course stop takes over. Ramp: 100 for the first ledger week, then the Platform Admin raises it from the Settings page on the ledger's correct-page rate.

### 3.4 Release order for Q1

1. Audit paste file produced and read by the Platform Admin.
2. Settings rows and the gate change (migration, md5-guarded edit of the picker).
3. Paste file releasing the `never_evaluated` and `rule_false_no_reason` providers, run by the Platform Admin.
4. Ledger week; cap raised deliberately.

---

## 4. Three-speed gap detection

### 4.1 Speed 1 — minutes: handoff on bind

**Trigger mechanism:** an `after update of status on pipeline.coverage_course_pages for each row when (new.status = 'bound' and old.status is distinct from 'bound')` trigger calling `security.page_bound_handoff_v1(new.course_id)`. The function does only what existing lanes already understand:

| Reader | How it is enqueued today | Handoff action |
|---|---|---|
| Page extraction (English, intakes, duration, campus, delivery come from the page read) | `next_read_at`, `read_attempts` on the page row; `course_priority` | `next_read_at = now()`, `read_attempts = 0`, `course_priority` row (same as `admin_course_read_now`) |
| Fee reader | `pipeline.fee_course_requests` consumed by `fee_course_pages_enqueue_v1` | insert the request row (`requested_at = now()`) |
| Enrich fields (AI) | `enrich-plan-run` picks bound pages with gaps | nothing extra; the gap query sees the bind |
| Central policy (English policy, calendar) | `central_ai_enqueue_v1(provider)` | call it once per provider per hour (guarded by `handoff.central_min_minutes` 60 [10–1,440]) |

Gate: setting `handoff.on_bind` (boolean, default false). Switching it on is a separate, deliberate step after item 3 shows the lanes can take the load. Estimated change: one function, one trigger, three settings rows, one contract test (bind a course in the dry run, prove a fee request and a reset page row appear). **1 day.**

### 4.2 Speed 2 — hourly delta

**Job:** `health-hourly` at `11 * * * *`. Minute 11 is quiet: in the live `cron.job` table only the every-minute lanes fire at :11 (no `*/2`, `*/3`, `*/5`, `x-59/10` or `x-59/15` schedule lands on it). The job is SQL-only (no worker call, no Firecrawl, no AI), so it takes no reader slot; it runs after `gap-causes` (:55) and `coverage-snapshot` (:47) of the previous hour and reads their rows rather than recomputing them.

**Writes to:** `pipeline.health_snapshots` (schema change 5), one row per (at, country, metric). The existing hourly report panel (`layer2_enrichment_hourly_admin_cache_v1` renderer) reads it through `admin_pipeline_health_read` with no new panel.

| Metric | Source | Threshold (settings, not schema) |
|---|---|---|
| `headline` proven pages in the last 24 h that admitted ≥ 1 value | ledger + `bound_at` + fee/English/intake rows | `health.headline_target`, set after the first ledger week |
| `bound_empty_12h` top 50 by provider with gap cause | `coverage_course_pages.bound_at` + `gap_cause_snapshots` | `health.bound_empty_hours` 12 [2–72] |
| `admitted_1h`, `admitted_24h` per field per country | ledger (`landed`) | — |
| `binding_pct_delta` | ledger vs previous day | `health.binding_drop_pct` 10 [1–50] |
| `queue_stuck` lanes with no progress > 4 h | `admin_queue_watch()` | `health.stuck_hours` 4 [1–24] |
| `quarantine_growth`, `layer4_growth` per country | `course_fees.status = 'unverified'`, `layer4_review_items` pending | `health.growth_pct` 20 [5–100] |
| `budget_burn` Firecrawl and OpenRouter day share used | `svc_fc_spend` ledger, `openrouter-balance` | `health.burn_warn_pct` 80 [50–100] |
| O2 / O3 / O6 flags | CA sub-floor Layer 4 count, item 5 retraction % | existing settings |

### 4.3 Speed 3 — weekly (unchanged cadence)

Extends `enrich-coverage-snapshot` (:07) and `gap-causes` (:55) on their existing rows with per-provider, per-field unblock levers (the gate name that holds the course, from section 3.1 and S1), and lists the defined-but-never-populated fields at 0 %. Written to `pipeline.enrichment_coverage_snapshots`; the existing weekly report renders it.

---

## 5. The schema changes as draft migrations (not applied)

Four migrations (change 3 is dropped, section 2). Each carries `-- Replaces:` and `-- Retires:` lines, a `comment on table`, the catalogue row before any `cron.schedule`, and `component_register` rows. No drop, delete or truncate. Thresholds are settings rows, not columns.

### 5.1 `20261024010000_cf247_requirements_as_at.sql` (change 1)

```sql
-- Replaces: nothing
-- Retires: nothing
-- as_at: the date the page stated the requirement or intake for (else the read date); the reader sets it (S2)
alter table catalogue.course_english_requirements add column if not exists as_at date;
alter table catalogue.course_intakes add column if not exists as_at date;
comment on column catalogue.course_english_requirements.as_at is 'date the page stated this requirement for; set by the reader from the page year, else the read date (CF-247 S2)';
comment on column catalogue.course_intakes.as_at is 'date the page stated this intake for; set by the reader from the page year, else the read date (CF-247 S2)';
create index if not exists course_english_requirements_course_as_at_idx on catalogue.course_english_requirements (course_id, as_at desc);
create index if not exists course_intakes_course_as_at_idx on catalogue.course_intakes (course_id, as_at desc);
insert into pipeline.component_register (component, kind, owner, note) values
  ('catalogue.course_english_requirements.as_at', 'column', 'reader', 'S2 freshness'),
  ('catalogue.course_intakes.as_at', 'column', 'reader', 'S2 freshness')
on conflict do nothing;
-- Backfill of as_at from evidence read dates is a paste file, not this migration (31,895 English rows, 30,675 intake rows).
```

Live baseline: English `valid_from` is set on 26 of 31,895 active rows; intakes have `intake_year` and `start_date` on 0 of 30,675. `as_at` is added rather than reusing `valid_from`, which means "valid from" in the consumer API (frozen, G3) and cannot change meaning.

### 5.2 `20261024011000_cf247_course_fees_superseded_by.sql` (change 2)

```sql
-- Replaces: nothing
-- Retires: nothing (status 'superseded' already exists on course_fees)
alter table catalogue.course_fees add column if not exists superseded_by uuid references catalogue.course_fees (id);
comment on column catalogue.course_fees.superseded_by is 'the newer fee row that closed this one; the reader sets it with status superseded (CF-247 S2)';
create index if not exists course_fees_superseded_by_idx on catalogue.course_fees (superseded_by) where superseded_by is not null;
insert into pipeline.platform_toolset_settings (toolset_key, key, value, min, max, unit, section, note) values
  ('pipeline', 'fees.max_years_ahead', '1', 0, 3, 'years', 'Fee reader', 'a fee year further ahead than this goes to Layer 4 instead of being admitted')
on conflict (toolset_key, key) do nothing;
insert into pipeline.component_register (component, kind, owner, note) values
  ('catalogue.course_fees.superseded_by', 'column', 'reader', 'S2 freshness')
on conflict do nothing;
-- The reader change (md5-guarded edit of security.coverage_apply_course_v1 and svc_fee_ai_record) ships in the S2 release once the
-- live md5s are re-taken at build. The 34 AU courses whose only active row is an older year are listed in a paste file for re-read.
```

### 5.3 `20261024012000_cf247_mode_outcome_ledger.sql` (change 4, Q3)

```sql
-- Replaces: nothing (edge_request_log stays; it is capped at 50,000 rows and is not an outcome ledger)
-- Retires: nothing
create table if not exists pipeline.mode_outcome_ledger (
  id bigint generated always as identity primary key,
  run_at timestamptz not null default now(),
  mode text not null,
  country text,
  items integer not null default 0,
  ok integer not null default 0,
  failed integer not null default 0,
  wait_ms integer,              -- median queue wait of the items this call took
  landed jsonb not null default '{}'::jsonb,  -- {"fees": n, "english": n, "intakes": n, "pages_bound": n, ...}
  worker text,
  detail jsonb
);
comment on table pipeline.mode_outcome_ledger is 'one row per worker call: what the mode processed, how much succeeded and where it landed; 90-day retention (CF-247 Q3)';
create index if not exists mode_outcome_ledger_run_at_idx on pipeline.mode_outcome_ledger (run_at desc);
create index if not exists mode_outcome_ledger_mode_run_at_idx on pipeline.mode_outcome_ledger (mode, run_at desc);
insert into pipeline.platform_toolset_settings (toolset_key, key, value, min, max, unit, section, note) values
  ('pipeline', 'retention.mode_outcome_ledger_days', '90', 30, 365, 'days', 'Retention', 'rows older than this are removed by retention-worker')
on conflict (toolset_key, key) do nothing;
insert into pipeline.component_register (component, kind, owner, note) values
  ('pipeline.mode_outcome_ledger', 'table', 'worker', 'Q3 per-mode outcome ledger')
on conflict do nothing;
-- security.svc_worker_report_v1(mode, items, ok, failed, wait_ms, landed, worker, detail) is created in the same file (security definer,
-- service role only). retention-worker gains one md5-guarded edit to delete by retention.mode_outcome_ledger_days (the delete lives in
-- the function, not in this migration).
```

### 5.4 `20261024013000_cf247_health_snapshots.sql` (change 5)

```sql
-- Replaces: nothing (progress_snapshots and gap_cause_snapshots stay; this is the hourly delta rollup)
-- Retires: nothing
create table if not exists pipeline.health_snapshots (
  at timestamptz not null,
  country text not null default 'ALL',
  metric text not null,
  value jsonb not null,
  primary key (at, country, metric)
);
comment on table pipeline.health_snapshots is 'hourly delta rollups for the health report: headline metric, bound-but-empty set, admissions per field, negative movers, budget burn; 90-day retention (CF-247 Speed 2)';
create index if not exists health_snapshots_metric_at_idx on pipeline.health_snapshots (metric, at desc);
insert into pipeline.platform_toolset_settings (toolset_key, key, value, min, max, unit, section, note) values
  ('pipeline', 'retention.health_snapshots_days', '90', 30, 365, 'days', 'Retention', 'rows older than this are removed by retention-worker'),
  ('pipeline', 'health.bound_empty_hours', '12', 2, 72, 'hours', 'Health report', 'a bound page with no admitted value after this long is listed'),
  ('pipeline', 'health.stuck_hours', '4', 1, 24, 'hours', 'Health report', 'a lane with no progress for this long is a negative mover'),
  ('pipeline', 'health.binding_drop_pct', '10', 1, 50, '%', 'Health report', 'binding rate fall against the previous day that is a negative mover'),
  ('pipeline', 'health.growth_pct', '20', 5, 100, '%', 'Health report', 'quarantine or Layer 4 growth per day that is a negative mover'),
  ('pipeline', 'health.burn_warn_pct', '80', 50, 100, '%', 'Health report', 'day share of Firecrawl or OpenRouter used that is warned'),
  ('pipeline', 'health.headline_target', '0', 0, 100000, 'pages per 24 h', 'Health report', 'set from the first full ledger week; 0 means not yet set')
on conflict (toolset_key, key) do nothing;
insert into pipeline.job_catalogue (job, purpose, schedule, owner) values
  ('health-hourly', 'hourly delta rollup into pipeline.health_snapshots', '11 * * * *', 'platform')
on conflict (job) do nothing;
insert into pipeline.component_register (component, kind, owner, note) values
  ('pipeline.health_snapshots', 'table', 'platform', 'Speed 2 hourly delta'),
  ('security.health_hourly_v1', 'function', 'platform', 'Speed 2 hourly delta')
on conflict do nothing;
-- cron.schedule('health-hourly', '11 * * * *', $$select security.health_hourly_v1()$$) follows the catalogue row, after the function
-- body (written at build against the live column names of gap_cause_snapshots and the ledger).
```

The exact column lists of `platform_toolset_settings`, `job_catalogue` and `component_register` are re-read from the live schema at build; the inserts above show intent, and the dry run proves them.

---

## 6. CA test case: what is still country-shaped in code

Measured against "a third country in a week with settings and seed data only". Country-specific Layer 1 adapters (`layer1-ca-*`, `layer1-au-*`) are per-source readers and are expected to be code; they are not blockers. These are:

| # | Still in code | Where | Blocks a new country? | Move to |
|---|---|---|---|---|
| 1 | Page identity proof per country: AU = CRICOS code on the page, NZ = labelled NZQA number or NZQA title, CA = `.ca` site naming the provider or printing its DLI number | `coverage-sweep/index.ts` (identity checks at ~line 606 and the v0.9.1 rule), `FC_TRUSTED_BASIS` list | **Yes** | `pipeline.country_identity_rules` seed rows (regex, label, register name); the identity function reads the row for the provider's country |
| 2 | The AU/NZ reciprocal "not international" audience rule (`h === "AU" ? ["NZ"] …`) | `coverage-sweep/index.ts` line 182 | Yes for any country with a reciprocal neighbour | setting `audience.domestic_pairs` (jsonb list) |
| 3 | Register lookups for finding a provider's website: training.gov.au and TEQSA for AU, name search for NZ and "any other country" | `find_site` mode | Partly (works, but by name only) | `layer1_source_operations` row per country naming the register and the code field |
| 4 | Currency words in the fee extractor (AUD 58 mentions, CAD 57, NZD 14) | `coverage-sweep/extract.ts`, `fees.ts` | Yes for a fourth currency | `ref.countries.currency_code` plus a per-country symbol list setting; the extractor takes the list |
| 5 | `cricos_peo` mode (AU-only regulator contact) | `coverage-sweep/index.ts` ~line 798 | No (AU-only by design) | leave; mark as AU in the component register |
| 6 | NZ Code of Practice mode (`nz_cop`) and `nz.*` settings | worker, settings | No (NZ-only by design) | leave |
| 7 | Country lists already in settings: `fees.countries`, `search.priority_countries`, `search.site_check_countries`, `search.region_from_provider_countries`, `pages.render_countries` | settings | No, but each needs a row for the new country | the readiness generator lists them |
| 8 | Admission floors, admission countries, calendars, English defaults | `coverage_admission_countries`, `provider_calendar_defaults`, `provider_english_defaults` | No (seed rows) | the readiness generator lists them |

**Answer:** not yet. Items 1, 2 and 4 are code and would each need a release for a fourth country. After S5 (the generator) and the three moves above (about 3 days, not in the 14-day plan until approved), onboarding becomes: readiness generator run → seed the missing rows it lists → Layer 1 source rows → no migration.

---

## 7. Open items carried forward (awaiting input or time)

| # | Item | Awaiting | From |
|---|---|---|---|
| O1 | NZIST transition sources | closed 20:52 | decisions file |
| O2 | CA floor 30-day review: Layer 4 volume for CA fees under CA$8,000; fix per-term and per-credit normalisation in the reader if flooding | time (30 days after Release 1); flagged by item 7 | decisions file |
| O3 | Item 5 retraction rate at 30 days against `course_url.max_retraction_pct` | time; flagged by item 7 | decisions file |
| O4 | NZQA directory cadence back to 30 days after 31 Mar 2027 | Platform Admin, 1 Apr 2027 | decisions file |
| O5 | Signatory list page URL confirmed and robots-checked (Release 1 item 3) | Platform Admin: the URL | decisions file |
| O6 | AU/CA sub-floor rows (109 AU, 66 CA) reviewed after O2 | with O2 | decisions file |
| O7 | Health headline target (`health.headline_target`) | the first full week of ledger data after item 3 | this file |
| O8 | Firecrawl plan tier and monthly credit cap | **Platform Admin input** (the platform holds only the self-set 200,000 search cap and 25,000 daily units) | diagnostic Q5 |
| O9 | OpenRouter plan tier and monthly spend cap | **Platform Admin input** (the platform holds only the US$10 low-balance warning) | diagnostic Q5 |
| O10 | `target_only` audit sign-off (section 3.2) before any provider is released | Platform Admin, after the paste file is produced | this file |

---

## 8. Runbook addition (the one section allowed)

**Reading the hourly health row.** Open the hourly report; the first line is `headline` (proven pages in the last 24 hours that admitted at least one value) against `health.headline_target`. Below it: `bound_empty_12h` (top 50 providers; the gap cause names the lane to look at), negative movers (each names its setting and the value that tripped it), and budget burn. A lane in `queue_stuck` is read with `admin_queue_watch()`; its `why` column names the gate. Thresholds are changed on the Settings page, never in SQL. If `headline` is 0 for two consecutive hours and no lane is stuck, the search lane's gates (section 3.1) are the first place to look.

---

## 9. Mandate as received (23 Oct 2026, 22:11)

> Consolidated mandate — throughput, gap detection at hours, and schema additions. This supersedes the sequencing in the thread file. Dump your full response as a NEW file at `docs/platform/nz-enrichment-brief/2026-10-23-platform-throughput-gap-schema.md` (do not append to the decisions file; link both ways). Plan and estimate only — nothing built until I approve.
>
> **1. Approvals** — in this order: Q2 and Q4 first, independent. Q1 with C-Q1 (daily picked-courses cap setting, default 100, min 10, max 2,000, ramping after a week's ledger data) and C-Q1b (exclusion audit of all 1,130 `target_only` courses before release; release only those whose reason no longer holds). Q3 before or with S4; the health metric's target set from the first full week of ledger baseline. S1–S5 after quick wins; S1's negative-evidence list must be consumed by search, AI match and the finder — verify all three.
>
> **2. Gap detection — three speeds:** Speed 1 (minutes) extend the Read-with-AI handoff so a bind/re-read immediately enqueues fee, English, intake, duration, campus readers; name the trigger mechanism and estimate. Speed 2 (hourly delta on the existing hourly report and gap-cause snapshots): bound-but-empty > 12 h with gap cause (top 50 by provider); admissions last hour/day per field per country; negative movers; headline one-number metric. Speed 3 (weekly, unchanged): full per-provider coverage matrix with unblock levers and the never-populated fields at 0 %.
>
> **3. Schema additions (exactly these):** (1) `as_at` on English requirements and intakes; (2) `superseded_by` self-FK on `course_fees`; (3) `bound_at` on `coverage_course_pages` only if `updated_at` is not reliably maintained — confirm first; (4) `pipeline.mode_outcome_ledger` (90-day retention); (5) `pipeline.health_snapshots` (90-day retention). No new status values; no gap-flag booleans on catalogue rows; thresholds are settings rows.
>
> **4. Country scaling:** using CA, list what is still NZ/AU-shaped in code; target country onboarding = settings + seed data only.
>
> **5. Constraints:** every tunable is a settings key with min/max/unit/section or the change is rejected; no new admin panels; no new SOPs or guides (runbook addition is one section in the new file); the hourly job must not displace reader work.
>
> **Output:** ordered work plan with effort and dependencies; the `bound_at` finding; Q1 release design; three-speed trigger/cron design; five schema changes as draft migrations; CA answer; open items O1–O5 plus the metric target and the plan tiers as awaiting input. Reply in chat with the 5-line summary.

---

## 10. Re-sequence and sweep log

### 23 Oct 2026, 22:24 — Platform Admin (hours-scale execution)

> NOW: run the bound-but-empty sweep (3,675 courses) through existing mechanisms; report admissions per hour within 24 h. SAME DAY, one release: items 1, 2 (no central-AI enable) and 3 together; then the `target_only` audit paste file for sign-off; on sign-off apply Q1 settings and the picker change and release at `search.daily_picked_cap = 100` immediately (the ledger week gates only the cap raise). SAME DAY: build health-hourly (item 7, dependency on item 5 dropped) with a provisional `health.headline_target` from its first hours; recalibrate daily, lock at day 7. Unchanged, own releases: items 5, 6 (`handoff.on_bind` off until the Q1 ramp is stable), 8, 9, 10, 11. Cap stays 100 until 3 days of ledger evidence. Audit sign-off (O10) precedes any release. If anything conflicts with the sweep, the sweep wins.

### 23 Oct 2026, 22:31 — Claude (sweep run)

Ran live, one transaction, SQL kept at `docs/platform/wrong-page-values/PASTE-20261023-bound-but-empty-sweep.sql`.

| Step | Result |
|---|---|
| Set | 3,675 courses (CA 2,499, NZ 1,176; AU 0) |
| Fee requests inserted | 3,675; pages already read (2,985) dated just before their read so they queue without a re-read |
| First enqueue tick | 2,735 queued to the fee reader, 250 `not_admitted` (identity basis not allowed for tuition), 690 wait for the page read |
| Fee reader queue | 2,703 queued (was 0) |
| Page re-reads | 3,675 reset first in line (`next_read_at = now()`, `read_attempts = 0`, priority row); the read lane did 2,132 pages in the previous 24 h with 2,349 already due, so the re-reads (which feed English and intakes) take 2–3 days at today's rate |
| Baseline | 0 fees admitted in the hour before the sweep |

Admissions per hour are reported back at about 02:30 and 22:00 on 24 Oct. The 250 `not_admitted` courses are the first S1-style list: their providers' identity basis is not accepted for tuition, which no re-read fixes.

**Re-sequenced order (supersedes section 1's order; efforts unchanged):** R1 = items 1 + 2 + 3 one release → audit paste file → sign-off → R2 = Q1 at cap 100 → R3 = health-hourly with a provisional target → items 5, 6, 8, 9, 10, 11 as their own releases.
