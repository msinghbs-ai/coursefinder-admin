# CF-247 Scholarship Coverage Recovery — Workstream A build: F1–F10 and two eligibility proposals (built off)

**Authority:**
- Platform Admin mandate *CF-247 Scholarship Coverage Recovery* (2 Nov 2026 17:41), §4, §5, §7, §8 and §13.
- Overnight direction (2 Nov 2026 23:24), §1 Scholarships, §3 and §4.
- Integration Controller assignment to Workstream B (after event #28668).

**Design and evidence:**
- `2026-11-02-scholarship-unsw-diagnosis.md` (Workstream A: RC1–RC11, F1–F10).
- `2026-11-02-scholarship-coverage-baseline.md` (Workstream Bp: RC1–RC11).

**Branch:** Pilot `cf247-scholarship-recovery`, off `origin/main` `f9c13bbb` (v2.15.408).
**Commits:** `869d3d12`, `c88c3783` (pushed). **Release:** none yet. Release ceremony and deployment are the integrator's.

**Not done by this workstream:** no production writes, AI calls or Firecrawl calls; nothing merged or deployed.

## 1. What changes

### 1.1 Files

| Part | File |
|---|---|
| Migration | `supabase/migrations/20261102140000_cf247_scholarship_recovery.sql` |
| Worker | `supabase/functions/coverage-sweep/index.ts` (v0.58.0), new `catalogue.ts`, `scholarship.ts` (listing item limit as a parameter) |
| Central guard | `tests/uat/cf-247-s224-scholarship-coverage-recovery-contract.spec.mjs` (8 tests) |
| Changed guards | `s7` (the render wait is now the setting `waitMs`); `s3`, `s9`, `s216` (anchors moved with worker v0.58.0) |
| Fixtures | `tests/fixtures/scholarship-recovery/` (`run.sh`, live definitions, before/after cases, UNSW umbrella page) |

### 1.2 Fixes

| Fix | Root cause | Change |
|---|---|---|
| F1 | Pickers timed out. 6.8 s live; 15–18 s on the fixture with the live definition. | `svc_scholarship_discover_next` orders a window of `scholarship.discover_pick_window` (60) rows by the stored `tier` column. It checks holds only on that window. A held row waits `retry.scholarship_discovery_held_hours` (6). `svc_scholarship_candidate_next` checks holds once per provider in a window of `scholarship.candidate_pick_window` (600). Skip rules run when candidates are recorded and hourly, not on every pick. The tier is refreshed by the hourly refill (`batch.scholarship_tier_refresh` 500). |
| F2 | A scheduler "succeeded" hid worker 500s and zero-work runs. | Every call in `pipeline.mode_outcome_ledger` gets an `outcome`: succeeded, idle, zero_work_error or failed. A 500, `ok:false` or an error is **failed**. No work done with a refusal or error, or items that only waited, is **zero_work_error**. `security.job_outcomes_v1(hours)` gives outcomes per mode, with the cron jobs that call that mode. Job `worker-outcome-check` runs every 10 minutes and is **created paused**. After `worker.outcome_failed_runs` (3) bad runs in a row it opens one issue, `worker:<mode>`; it updates that issue rather than duplicating it, and resolves it on the next good run. |
| F3 | A refused map became a final "empty". | A refused or failed map is **deferred**. It is retried after `retry.scholarship_discovery_deferred_hours` (6), and its last count is kept. A map that ran is due again after `reread.scholarship_discovery_days` (30); existing mapped and empty rows get their date on the first refill. |
| F4 | Only the website was mapped. | The picker returns the provider's sources: website, then active listing sources (manual first, then auto; never suggested). The worker maps each one, up to `scholarship.sources_per_provider_max` (5), each through the daily budget. |
| F5 | Listing items were never candidates; umbrella pages were refused whole. | `svc_scholarship_listing_record_v2` keeps membership in `pipeline.scholarship_listing_members` and turns each new on-site item into a candidate, once. An award with no page of its own becomes a section candidate `<page>#award-<code>`. The worker reads that award's section only. The admission uses the section address as the record's identity, so ten awards make ten records. The same award found on its own page is a duplicate by name, not a new record. Settings: `scholarship.listing_fanout_on` and `scholarship.umbrella_sections_on`, both on. |
| F6 | Catalogues were read one page at a time, with no stop condition. | Listing sources are read page by page with the catalogue wait (`scholarship.catalogue_render_wait_ms` 5000). The reader follows `rel="next"`, a Next link, `page=N` and `startRank`/`numRanks` in the query or the fragment, up to `scholarship.listing_pages_max` (10) pages per run. A source is **complete** only when the pagination ended by itself: no next page, the stated total reached, or an empty page. Otherwise it is **partial**, keeps `next_url` and continues after `retry.scholarship_listing_partial_hours` (1). A partial read never marks an item absent. |
| F7 | Stale and redirected addresses were read as pages. | A candidate that now opens the catalogue home, a listing or a search page is refused as `redirected_away`, with no AI read. A scholarship page whose final address differs is recorded in `pipeline.scholarship_source_moves` (moved or redirected_away), once per address. Nothing is withdrawn by this. |
| F8 | A hidden all-time cap of 60,000 credits. | `scholarship.lifetime_cap_on` is off. The worker's ceiling becomes used + the daily scholarship share, and `svc_fc_spend` remains the limit (daily budget, share, per-university cap, monthly plan). **Nothing becomes unlimited.** |
| F9 | Closed rounds and ended scholarships were not told apart. | `pipeline.scholarship_round_states` holds one of: open, opening_soon, closed_round, ended or no_dates. It is set hourly by the refill (`batch.scholarship_round_state` 1000). It is a report only: publication is unchanged. See §2. |
| F10 | Literal sizes. | Task sizes are the Scholarships settings. The worker caps, item and page limits, render waits, map candidate cap and tier course threshold (`firecrawl.scholarship_tier_courses` 30) are all settings. `svc_worker_settings_v1` returns the `pipeline` `scholarship.*` keys. |

Housekeeping:
- `svc_scholarship_listing_record` is marked retiring, replaced by `_v2`.
- The new tables have purposes recorded.
- The new job is catalogued.
- Nothing is dropped or deleted.

## 2. F9 and the consumer API (G3: no change)

`api.website_v2_scholarship_item` already reports `current_status`. Its values are:

| `current_status` | When |
|---|---|
| `closed` | The close date has passed |
| `opening_soon` | The open date is in the future |
| `open` | Within the window |
| `check_provider` | No close date |

A past round is therefore never shown as open, and past scholarships stay as records shown as closed.

**Proposal only (not built; needs Platform Admin approval under G3):** an additive field, `round_state`, with the values `closed_round` and `ended`, read from `pipeline.scholarship_round_states`. It would let the website say "next round expected" rather than "closed". No existing field changes.

## 3. Eligibility proposals (built OFF, overnight direction §1; Platform Admin to approve)

| Proposal | Setting (shipped) | When switched on |
|---|---|---|
| P1 Non-university providers through provider-type governance | `scholarship.non_university_admission` = **false**; types `["university_college","higher_education_institute","tafe_polytechnic","private_vet","wananga"]` | A provider of a listed active type may have scholarships admitted if it has: a recorded `provider_type_basis`, its own website that is not a directory site, and a country switched on for scholarships. Schools are never eligible. The refill also queues such providers overseas. |
| P2 Evidence-based legitimacy instead of the 30-course minimum | `scholarship.legitimacy_checks_on` = **false**; `scholarship.legitimacy_min_courses` 1 | `fc_sch_eligible_v1` uses `security.scholarship_legitimacy_v1` instead. The provider must be active and published, must not refuse international enrolment, must have a governed active type that is not a school, must have its own website that is not a directory site, and must have at least N active courses. |

On the fixtures:
- With P1 off, UNSW College is refused exactly as today.
- With P1 on, UNSW College is allowed. It is not allowed without a recorded type basis, and a school never is.
- With P2 off, the 30-course minimum holds.
- With P2 on, the legitimacy evidence decides.

## 4. Firecrawl after expiry (direction §4)

- No new setting raises spend. Every new knob that reads pages or maps sites sits inside the daily scholarship share.
- **Integrator to restore and verify** the values raised under the 16:39 authority. These are live and noted "restore after 3 Nov 02:57":
  - `firecrawl.daily_budget_on` (false → true);
  - `firecrawl.scholarship_cap_per_uni` (5000 → 150);
  - `firecrawl.scholarship_min_courses` (0 → 30);
  - `firecrawl.map_limit_scholarships` (100000 → its before value);
  - `scholarship_layer_settings.firecrawl_cap` (100000 → 60000, per diagnosis §7 step 1).
- With this release, `firecrawl_cap` is no longer read while `scholarship.lifetime_cap_on` is off.
- The step-2 leases from the diagnosis have expired by themselves.

## 5. Validation

**Fixtures** (`tests/fixtures/scholarship-recovery/run.sh`, PostgreSQL 16 scratch database):
- All 26 live definitions were loaded from their live text, and every md5 equals the live md5.
- The defects reproduce on the live definitions:
  - The picker evaluated all 1,500 pending rows and returned 0, in 15–18 s.
  - A refused map was recorded as `empty` with `url_count` 0.
  - The cap was 60000.
  - The task limit was the literal 6.
- The migration applied 14 changes, and a second run reported 14 "already applied" with nothing changed.
- 44 cases pass, covering F1–F10, P1, P2 and the shipped state.

**UNSW regression case:**
- The umbrella page gives ten awards. The two held ones are not added again. Nine become section candidates; PUCA1024 is included because live it is only an inactive retired-register record.
- Two awards of the page become two records.
- The same award on its own page is a duplicate.
- The legacy `/scholarships/id/102` address is recorded as redirected away.

**Tests:**
- `s224`: 8 tests pass.
- Central guards pass: `s32`, `s42`, `s57` and `s7`.
- Full local suite (`--project=chromium-desktop --grep-invert @deployed`, 1,489 tests, run in two parts on a host at load 26-29 on 2 cores):
  - every test passes on its own;
  - the earlier failures were of two kinds:
    - seven specs that run `npm run build` under a fixed 60 s limit (`cf-061`, `cf-065`, `cf-142-143`, `m2-5-evidence-lineage`, `m2-5-jobs-workspace`, `m2-5-platform-maturity`, `m245`): all seven pass when re-run with a longer limit, applied locally and reverted, not committed;
    - mocked-browser timeouts under load (`builder-sampling`, `fetch-area-sweep`, `s179`, `s18`): they pass when re-run alone;
  - three regression specs whose literal anchors moved with this change were updated in commit `c88c3783`: `s3` (listing item limit parameter), `s9` (`readSchPage`, a map per source) and `s216` (later worker versions);
  - the integrator's CI run is the authoritative 0 failed / 0 skipped gate.
- Release contract PASS; `npm run build` PASS.

## 6. After deployment (integrator)

1. Confirm the 14 live md5s equal the after values in the migration, and that the worker answers `coverage-sweep-worker-v0.58.0`.
2. `scholarship_discover` answers 200 within the statement time-out. `select * from security.job_outcomes_v1(2)` shows `scholarship_discover` succeeded or idle.
3. Switch on `worker-outcome-check` (a deliberate step, with a reason).
4. Read the UNSW Term 1 2027 source, listing id for `.../scholarships/id/1988`. Expect 9 section candidates and the AI admission queue to fill within the US$14/day AI ceiling.
5. Re-take the test register (`node scripts/test-register.mjs`): `s224` is added and `s7`'s assertion has changed.
