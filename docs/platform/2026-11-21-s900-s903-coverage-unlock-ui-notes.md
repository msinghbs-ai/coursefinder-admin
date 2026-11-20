# Coverage unlock, counsellor notes and AER country filters (CF-247 s900 to s903)

**Date:** 21 Nov 2026 · **Chat:** S1-Coverage-Unlock-UI-Notes · **Directive:** Platform Admin 21 Nov 2026 07:48 AEDT, with the decisions answered at 08:20 AEDT · **Release:** v2.16.74

## 1. Decisions (Platform Admin, 21 Nov 2026)

| Question | Decision |
|---|---|
| How much may the coverage unlock spend? | **One on-demand window, up to 20,000 Firecrawl credits.** Scheduled limits unchanged; actual use reported after. |
| How should waiting university-wide entry rows be admitted? | **A new auto-admit rule, in shadow first for 24 hours.** |
| Where should university-wide entry inheritance surface? | **PIM Admin and Website API v3 only.** v2 stays frozen (G3). |
| IQ-00510 and IQ-00445 (2 AM audit) | **Approved:** alert levels 8,192 / 9,216 / 10,240 MiB; `VACUUM (ANALYZE)` of four tables; `coverage-reconcile` to :09; `scholarship-coverage-classify` to :40. Log retention unchanged. |

## 2. What the coverage audit found (read live, rolled back, 21 Nov 2026 08:10–09:40 AEDT)

**No coverage limit is written into code.**
- Every limit the directive named is already a setting (G2), changed on Settings › Toolsets & limits.
- None was changed by this work.

| Setting | Value | What it holds |
|---|---|---|
| `firecrawl.daily_budget_total` | 4,000 a day | All scheduled Firecrawl work |
| `firecrawl.daily_share_*` | scholarships 1,500 · course search 1,200 · reads 1,200 · central 1,000 · provider descriptions 300 · other 200 | Each purpose group's part of the day |
| `firecrawl.ondemand_credits_per_day` | 2,000 | The Enrichment plan screen's on-demand allowance |
| `firecrawl.scholarship_cap_per_uni` | 150 | Scholarship pages a university, a day |
| `firecrawl.target_countries` / `target_only` | AU, NZ, CA / on | Which countries are crawled |
| Firecrawl left on this month's plan | 67,214 credits | Read 08:57 AEDT |

**Other findings:**
- **The "38/40" figure is a coverage count**, not a cap: Australian universities with published scholarships.
- **The "0/40 planner slots" object does not exist** (noted 19 Nov in `OPS-QUEUE-LANE-CONTROL-AND-ON-DEMAND-RUNS-DESIGN.md`).

**Where the gaps are.** Of the 143 active universities (AU 40, NZ 8, CA 95):
- **128 hold no active entry table.**
  - Active university-wide entry rows exist at 23 providers, mostly colleges.
  - 3,245 university-wide rows wait as `proposed` at 55 providers.
- **63 have no published scholarship.**
- **109 universities (10,559 courses) have one gap or the other.** These are the on-demand window's providers.

**Charles Sturt University (CRICOS 00005F, 67 active courses):**
- **Entry requirements.** Its 7 university-wide rows wait in Layer 4; 14 more are superseded.
  - The machine admission stops the read at the completeness gate (D-R3). The reader dropped the Hong Kong row, so the whole read waits for a person.
  - Every check before the gate passes: no manual lock, no earlier rejection, a current stored copy, the official address, the university's own host, and no shared host.
- **Scholarships.** 85 published, mapped to all 67 courses. Scholarships already reach every Charles Sturt course.

**Why entry-matrix items wait** (79 items):

| Machine admission rule | Items |
|---|---|
| `gate_incomplete` (D-R3: the read dropped a published row) | 57 |
| `all_rows_held` | 9 |
| `change_of_admitted_table` (stays with a person) | 6 |
| `source_not_official_host` | 2 |
| `host_shared` | 2 |
| `no_rows`, `audit_sample`, `earlier_rejection` | 1 each |

**On-demand spend had no cap.** An open on-demand request let its providers' Firecrawl spend pass the daily shares. Only the monthly plan limit and the directory-site rule held it. So s903 adds the cap first, then opens the window.

## 3. The changes

| Change | Migration | What it does |
|---|---|---|
| **s900** (IQ-00510, IQ-00445) | `20261121090000` | Pilot alert levels 8,192 / 9,216 / 10,240 MiB. `coverage-reconcile` moves to :09 and `scholarship-coverage-classify` to :40, commands unchanged. **Live 08:28 AEDT** (Pilot #1444; history md5 matches the file). The `VACUUM (ANALYZE)` is paste file `docs/paste/PASTE-20261121-s900-vacuum-analyze.sql`, run one line at a time. |
| **s901** (notes and filters) | `20261121100000` | **Notes panel:** closed by default, on Course detail, Entry requirements and Scholarships. **Entry requirements › Provider entry matrix:** Destination country (new), Source country (was "Country"; it always filtered the student's country of prior education), Applies to (university-wide or one course). **Course detail › Entry requirements:** shows the university-wide table that applies. One md5-guarded edit of the admin function `public.admin_aer` (admin only). |
| **s902** (admission, shadow) | `20261121101000` | Rule `aer-uniwide-partial-shadow` of `admission-rule-runner`, hourly at :33, records only. **What it measures:** for an item stopped only by completeness, every proposed university-wide row that passes every machine row rule; the dropped countries stay with a person. **First run (dry run):** 73 items looked at; would admit 1,141 rows at 27 providers (36 items). Charles Sturt: 7 of 7 rows, Hong Kong left as a gap. Admits nothing. |
| **s903** (spend) | `20261121102000` | **The cap:** `security.on_demand_request_for_v2` (md5-guarded) stops covering spend once a request's recorded units reach `cap_firecrawl_units`. **The window:** the 109 gap universities, Firecrawl only, purpose groups central, scholarships and reads (course page search left out), 6 hours, capped at 20,000. |

**Messages that read differently** (counsellors and operators):

| Screen | Before | After |
|---|---|---|
| Entry requirements › Provider entry matrix, filter | Country | Source country, plus Destination country and Applies to |
| Entry requirements › Provider entry matrix, column | Country | Source country |
| Entry requirements › Course entry requirements, column | Country | Source country |
| Course detail › Around this course › Entry requirements | Course rows only | Course rows, then the university-wide entry table that applies (and rows waiting in Layer 4) |

## 4. Guardrails

**Unchanged:**
- G3: 75 functions and 48 tables, no drift; v2 is untouched.
- Manual locks: 7,585.
- No value is overwritten; nothing is dropped or deleted.
- No job is added; active cron jobs stay at 135 or fewer (ceiling 140).

**Two items not yet in force:**
- **The s902 cutover** is a separate change. It follows the 24-hour shadow report (`security.aer_uniwide_partial_shadow_report_v1()`) and the Platform Admin's decision.
  - Decision 276 freezes AER v1. s902 adds no reader, word list or recovery path; it measures admission over existing reads.
  - The cutover decision should confirm that partial admission is allowed under Decision 276.
- **The s903 window** (`ad97c846`, open 09:09 to 15:09 AEDT, 67,193 plan credits before) is closed with `security.on_demand_close_v1` after it has run. Its actual use and the credit left are reported then.

## 5. IQ-00445 follow-up

`IQ-00445` is closed after two clean unattended cycles at :09: run time under 100 seconds and no time-out. The first ran at 09:09 AEDT in 85.7 seconds (it took 136.2 seconds at :26 an hour earlier); the second is due at 10:09.
