# Speed programme: reconfiguration mandate (decision record and response)

Platform Admin, 25 Oct 2026, 22:05 AEDT. CF-247.

## Mandate as given

The mandate replaces the current throughput model:
- binding moves from search-per-course to map-then-match;
- search queries get a quality programme;
- the spend stops get calibrated;
- velocity becomes visible (S5, extended by S6: live visibility built into the existing UI).

**The accuracy gates do not change:** quote-on-page, floors, identity per kind, Layer 4 first runs, and the learning loop. Speed comes from better targeting, never from looser admission.

The guardrails stand as stated:
- config over code, with a settings key for every tunable;
- quarantine, not delete;
- manual bindings are never touched;
- count guards;
- one release at a time;
- the 60% correct-page rule gates every speed increase;
- PIPELINE-LINEAGE.md is updated in the same PR (a binding model change touches sections 2 and 4).

The rest of this record is the response. Read-only work started at 22:05; nothing has been applied, merged or switched on.

---

## Headline finding (changes the shape of S1)

**Map-then-match already exists and has already been run over almost every unbound course.** The lane is `coverage_ai_match`:
1. A provider URL inventory (`pipeline.coverage_provider_urls`) is filled from Firecrawl maps, site maps and course lists.
2. A token pre-match shortlists up to 25 candidates.
3. The pinned AI picks one.
4. The reidentify / bind path decides.

For the unbound courses at published providers, by the latest AI match state (live, 22:20):

| Unbound course class | AU | NZ | CA |
|---|---|---|---|
| A. Provider has **no inventory** (a map is needed) | 120 | **426** | 60 |
| B. Conjoint / combined / double degree (usually no page of its own) | 332 | 173 | 118 |
| C. Research degree / higher doctorate | 585 | 30 | 42 |
| D. Exit award, micro-credential, non-award, exchange | 146 | 0 | 0 |
| E. AI chose a page; the identity check refused it (mismatch) | 243 | 410 | 293 |
| F. Inventory holds no candidate at all | 145 | 354 | 65 |
| G. AI saw about 17–20 candidates and said **none is this course** | 2,082 | **2,010** | 572 |
| H. Never matched (other) | 61 | 29 | 0 |
| **Unbound** | **3,714** | **3,432** | **1,150** |
| **Bound %** (official link active, published providers; the tracker's definition) | 75.1% | **47.0%** | 69.8% |

**Class G is the biggest block, and it is not a search problem.** I sampled 142 NZ class-G courses, leaving out conjoint, research and exit titles:
- only **9 (6%)** have a page in the provider's inventory whose address carries the course's own title;
- most of those 9 are regulations or "apply" pages, not course pages;
- the Waikato inventory holds 3,112 mapped addresses, and its class-G courses are mostly conjoint degrees and higher doctorates, which have no page of their own.

The inventories are full. What is mostly missing is **a published page for that qualification**. Many NZ register entries (the provider is approved to deliver the qualification) have no live page on the provider's site.

**So:**
1. A fresh `/map` per provider is still the right first move where the inventory is **missing or thin**: NZ 216 providers / 1,310 courses; AU 75 / 500; CA 10 / 110. It costs about 1–2 credits a provider.
2. The **"no page published by the provider"** class must become a recorded gap cause, verified once in Layer 4 per provider, so the binding % stops counting courses that cannot be bound. It must not be searched forever.
3. Conjoint / combined degrees need an **explicit rule** (bind to the provider's conjoint page or to both component pages, decided per provider in a Layer 4 first run). Today they burn searches and AI calls.
4. The **NZ 75% in 30 days** target is only reachable if (2) takes the no-page courses out of the denominator (or reports them as "no page by provider") **and** (1) and (3) land.

   Class A plus the conjoint rule are worth at most about +9 points on the current denominator (599 of 6,474 NZ courses, if every one binds). The rest of the movement is honest classification, not binding. I will put the projected curve in the S1 PR rather than promise 75 on today's definition.

**Metric note:** the INDEX and PIPELINE-LINEAGE quote "NZ 53.5%"; live tonight it is **47.0%** on the tracker's definition. I could not reproduce 53.5% from the current tables. The velocity spec (S5) fixes one definition: the tracker's (official link active, published provider).

---

## S0: order (as decided)

S1 (#694) merges first. This programme is then the **primary track**; Track B release 1 and Track C (#695) keep their merge positions.

**Merge queue as I read it (22:05):** #694 → Track B R1 (with S5 + S6, below) → #695 → speed release SP-1 → SP-2 … (superseded at 22:27, see Decisions below)

**One question for you (D-S0):** should SP-1 (the mislabel fix + map-then-match widening, small and mostly settings and SQL) go **before** #695, given it is now the primary track? Track C has no running dependency (its reader is off), so moving SP-1 ahead of it costs nothing. My recommendation is **yes**. Until you say so, the queue stays as written.

---

## S1: map-then-match binding (design)

**Reuse, not rebuild.** The lane exists (above). SP-1 changes four things, all through settings:

| # | Change | Setting (new unless noted) | Default |
|---|---|---|---|
| 1 | **Fresh map for missing or thin inventories:** one Firecrawl `/map` (1 credit; plus 1 for a targeted `search` map when the course words find too few). Recorded in `coverage_provider_urls` with `source = map`. The provider queue is below | `bind.map_refresh_days` (re-map after), `bind.map_thin_below` (addresses), `bind.maps_per_day` | 30 days · 50 · 60 a day |
| 2 | **Widen the AI match gate** from focus providers + course-list providers to **tranche + top-N by unbound courses** | `bind.match_scope_top_n` | 100 providers |
| 3 | **No-page classification:** a course stays unmatched after (a) a fresh full map plus course list (inventory age < `bind.map_refresh_days`) and (b) two AI match passes that say "none". It is then proposed as **"no page published by provider"**. The first run per provider goes to Layer 4 with 5 sample courses beside the provider's course list. After approval the provider's later cases are recorded automatically, gated by the 60% rule on that provider's sample. The course leaves the search queue (negative evidence consumed) and the gap cause becomes `no_page_by_provider`. **Never deleted; a later map that finds a page re-opens it** | `bind.no_page_after_passes` | 2 |
| 4 | **Conjoint rule:** a conjoint / combined / double title is matched to the provider's conjoint or double-degree page, or to both component degree pages, as one **Layer 4 first run per provider**. After approval it binds by that pattern | `bind.conjoint_rule_on` | 0 until the first runs are approved |

- **Accuracy gates unchanged:** identity per kind on the bound page, quote-on-page for every value read later, `page_rejections` consumed, manual bindings untouched. New pattern means verified once, then trusted by evidence rate (the same 60% rule as tranches).
- **course_events:** every bind, reject and no-page decision is logged once Track B R1 lands.

### Provider queue and budget (read-only, live 22:20)

| Country | Inventory state | Providers | Unbound courses | Already Firecrawl targets |
|---|---|---|---|---|
| NZ | none | 19 | 426 (NZIST Work-Based Learning 231, NZIST 72, Skills Update 31, Ama Training 20) | 18 |
| NZ | thin (< 50 addresses) | 197 | 884 (Skills Group Training 63, Te Rūnanga-o-Tūranganui-a-Kiwa 32, Tai Poutini 31, Skills Active 30) | 156 |
| AU | none | 10 | 120 (SCEI 27, Holmes Institute ×3 rows 25/20/8) | 10 |
| AU | thin | 65 | 380 (Murdoch 43, AIT 31, AAPoly 27, AIM 23, CIT 20) | 29 |
| CA | none + thin | 10 | 110 (College of the North Atlantic 54, Burman 27) | 8 |
| | **Total** | **301** | **1,920** | 221 |

**Budget:** about 301 providers × 1–2 credits = **300–600 credits once**, then re-maps every 30 days. At `bind.maps_per_day` 60, that is about 5 days and about 100 credits a day. This is inside today's spend with no change to the daily budget (S3).

Providers outside the target list need Tranche 2 (S4) before they are mapped. The map lane uses the same `svc_fc_spend` gate.

**Targets as asked:**
- NZ binding % against the tracker baseline (47.0% today); AU and CA measured from the tracker;
- values admitted a day from the velocity number (S5).

The 200-a-day search cap stays for the residual search lane; map-then-match is additive, not a cap raise.

---

## S2: search-query quality programme (baseline + first iteration)

**Baseline (course searches since R2, 24 Oct 00:00 UTC; 1,075 completed):**

| Outcome | Searches | Share |
|---|---|---|
| Found and bound | 98 | 9% |
| **No results at all** | 148 | 14% |
| **Results returned, all refused by the URL picker** (`security.course_link_pick_v1`: only addresses matching the provider's `course_link_recipes` patterns pass) | **829** | **77%** |

What the baseline shows:
- **Queries are already site-scoped and title-quoted (100%).** The `site:provider-domain` lever in the mandate is in place.
- The "88% no candidate" is mostly **the picker refusing real results**, not empty searches.
- **28% of the "none" searches are shapes with no page of their own** (151 conjoint/double, 99 research/doctorate, 26 exchange/exit of 977). These should not be searched at all (S1 #3 and #4).
- **Three providers took 534 searches (50%) for 20 finds:** UNSW 198/4, Macquarie 190/15, VU 146/1. All three are AU universities already 75%+ bound, and the residue is combined and research degrees.
- **Data defect:**
  - Humber College's website is `humberetc.ca`, a student-newspaper domain, so its searches return news articles (21 of 37 had zero results). The fix is a provider website correction through the existing site-check path, a person-decided change (manual bindings untouched).
  - Holmes Institute (3 rows) and SCEI return **zero** results for every query: 72 + 27 searches, 0 found. Site search does not index them, so they belong in the map lane (S1 queue), not search.
- **There is no per-result verdict log.** The picker returns only the accepted URLs, so nobody can learn which refused results were in fact course pages. That is the learning gap.

**Iteration 1 (SP-1, settings + SQL):**
1. **Do not search** conjoint, research, exchange and exit shapes. They go to S1 #3/#4. Expected effect: about 28% fewer wasted searches.
2. **Log query → result → verdict** for every result. Add `pipeline.course_link_search_results` (course, url, rank, title, verdict: `recipe_match` | `recipe_miss` | `off_domain` | `rejected_page`), kept 90 days.
3. **Recipe widening from evidence.** Every week the picker's misses are grouped by address pattern. A pattern that is a course page in ≥ 60% of a Layer 4 sample (5 addresses) is proposed as a recipe addition, decided by a person. There is no automatic widening.
4. **Title variants:** strip "(Level n)" and NZQF suffixes; for NZ, try the provider's own wording from its course list (lineage map vocabulary) when the register title has no hit.
5. **Provider-level stop:** a provider whose last 30 searches found under 10% goes to the map lane, not the search lane (`search.provider_low_yield_pct` 10, `search.provider_low_yield_window` 30).

**Target:** the no-candidate rate falls from 88% to under 50% in 14 days, measured on ordinary titles only (shapes excluded), with the 60% correct-page rule still gating. The search cap is reviewed only against the improved yield.

---

## S3: calibrate the stops

**Waiting on your O8 / O9 plan tiers (due in the morning).**

I will then propose, with the existing spend watchdog:
- the Firecrawl daily budget split across the map lane (new), the search lane and the central lane;
- the AI stop with headroom over the observed peak.

Tonight's observed spend for scale: Firecrawl 429 credits from 18:00 to 21:00; AI US$0.53 on the UTC day. The map lane needs about 100 credits a day for 5 days. **The daily budget is not raised on the old model.**

---

## S4: decisions recorded (Platform Admin 22:05)

| # | Decision | Action |
|---|---|---|
| S4-1 | **CA fee-schedule gap (7 providers, 109 courses) goes into Tranche 2:** one override paste, not a policy change. TAFEs, wānanga and ITOs ride the same Tranche 2 batch, **selected from the worst-named list in the weekly line**, not by size | Paste file `docs/platform/nz-enrichment-brief/PASTE-20261026-target-tranche-2-overrides.sql`. **Part A (written):** the 7 CA providers by stable key, count-guarded, plus re-queueing their 18 failed fee pages (status `failed` → `found`, attempts 0; nothing deleted). Dry-run on live, rolled back: 7 override rows and 18 pages, guards passed. **Part B (TAFE / wānanga / ITO): an empty, guarded block.** The weekly line's worst-named list does not exist yet: it runs Monday 08:36 and has not run since tranche 1. I will not pick them by size. Part B is filled from that list on Monday and comes to you then |
| S4-2 | **Unpublished AU:** the 08:00 report quantifies; you decide publish or hold per provider type (registered + live site → publish; registered + no site → hold with cause; deregistered → register-sync question) | First cut tonight (below). The 08:00 report adds **live-site** status from the provider website checks |
| S4-3 | **Fix the mislabelled stall:** target-list refusals are recorded as "budget"; rename to `target_list_refused` everywhere it surfaces | Specification below; code in SP-1 |

### Unpublished AU, first cut (live 22:30)

| Provider type | CRICOS id | Website on record | Providers | Active courses |
|---|---|---|---|---|
| private_vet | current | yes | 839 | 9,380 |
| school | current | yes | 301 | 839 |
| private_vet | current | no | 95 | 537 |
| other | current | yes | 73 | 359 |
| other | current | no | 9 | 24 |
| (no type) | current | yes / no | 14 | 25 |
| higher_education_institute | current | yes | 1 | 9 |
| **Total** | | | **1,332** | **11,173** |

**Caveat for 08:00:** every row reads "CRICOS current" because no CRICOS identifier carries an end date in `catalogue.provider_identifiers`. The register sync does not write deregistration there. So "deregistered" cannot be told apart tonight. The 08:00 report will cross-check against the last CRICOS register replay, and "website on record" will be replaced by the live-site check.

### S4-3: mislabel fix, specification (SP-1)

`useFc` in the worker returns a bare `false` for six different causes, and three lanes record all of them as "budget" or "credit budget". The fix:

1. `useFc` returns a reason:
   - `target_list_refused`: provider not in the target list while `target_only` is on;
   - `credits_reserve`: the account reserve;
   - `scholarship_share`;
   - otherwise the database's own reason from `svc_fc_spend`, which gains a v2 that returns the reason (`share`, `day_total`, `university_cap`, `not_due`, `search_stopped`, `directory_site`, `not_eligible`, `on_demand_allowance`).
2. **Target-list refusals are written to `pipeline.firecrawl_budget_refusals` and `firecrawl_refusals_by_provider`** with reason `target_list_refused`, so the Firecrawl panel counts them. Today they are invisible there: 0 refusals recorded while 256 pages were turned away.
3. **Where it surfaces:**
   - provider-facts fetch (`provider_fact_sources.parse_summary.error`);
   - provider-facts search;
   - course search (`p_error`; a target refusal is not re-queued forever);
   - central find (evidence note);
   - the entry reader;
   - Task manager stall cause;
   - gap causes;
   - the hourly report.

   All use the named reason. "budget" stays only for a true budget stop.
4. A contract test fails if any worker call site records a bare "budget" for a `useFc` refusal.

---

## S5: velocity number (ships with Track B release 1)

"Values admitted (24h), by field" on the Task manager live line and the hourly report headline:
- **Source:** `pipeline.course_events` (Track B R1), event kind `value_admitted` by field.
- **Fallback until R1 lands** (stated on the line as "from apply counters"):
  - `catalogue.course_fees` (active, created in 24h);
  - course intakes (created);
  - `catalogue.course_english_requirements` (`last_verified_at`);
  - `catalogue.course_links` (official, active, created).

---

## S6: live visibility built into the existing UI (spec; ships with S5 in Track B R1)

**Surfaces:**
- the Task manager **Live line** (already refreshes every 20 s);
- the **Dashboard header**;
- the **hourly report headline**.

Chips and one-line counters only: no tables, no new pages, nothing to navigate to.

| Line | Shows | Source (named; listed in PIPELINE-LINEAGE "Visible numbers") |
|---|---|---|
| 1 Velocity | "Admitted 24h: N (fees · intakes · English · links)" | `course_events` (fallback: apply counters, as S5) |
| 2 Binding | "Bound: 47.0% · bound today: N · searching now: N providers (map / search phase)" | `course_links` (tracker definition), `course_link_search` + map lane leases |
| 3 Queues | Per-lane waiting / running chip. Green: moving. Amber: waiting with reason (idle guard pause, cap reached, backoff). **Red always shows a named cause** (`credits_refused`, `target_list_refused`, `backoff`, `cap reached 11:00 AEDT`, `stalled: no call in N min`); never bare red | the R1 per-mode ledger, `enrichment_flags` (idle_paused), `link_search_block_v1`, `firecrawl_budget_refusals` |
| 4 Budget | "Credits today X / Y · AI $a / $b · cap resets 11:00 AEDT" | `coverage_vendor_usage`, `daily_budget_total`, `ai_spend_today_v1`, the AI stop |
| 5 Next unlock | One line naming what unblocks next work, e.g. "Tranche 2 paste awaits apply · entry reader off · unpublished AU: 11,173 courses held" | pending paste register, settings switches, the S4-2 count |

**Fail-proof rules (the specification):**
- **a. Every number carries its age** ("· 40 s ago"). Past `ui.visibility_stale_seconds` (default 120, range 30–900) the numbers grey and a banner shows: "Live feed stale since <time> — data may not reflect the machine." The panel never shows old data as current.
- **b. Zero-state honesty:**
  - quiet and healthy: "Quiet — last value admitted 21:47 · eligible queues drained";
  - dead feed: the stale banner from (a).

  The two are visibly different.
- **c. Self-watching:** a new Platform health check, "visibility feed age within threshold". It surfaces in Platform health and the Monday weekly line.
- **d. Source discipline:**
  - every number names its source table in the "Visible numbers" table added to PIPELINE-LINEAGE.md;
  - the lineage contract test (s104, Track B R1) also fails a PR that removes or renames a source a visible number depends on.
- **e. Cost ceiling:**
  - the feed reads **one materialised row**, `pipeline.visibility_snapshot` (jsonb + `computed_at`), refreshed by the existing every-minute `admin-jobs` tick when `ui.visibility_refresh_seconds` (default 60) has passed;
  - no new cron job, no heavy query per refresh;
  - the Task manager read stays within today's time (measured before and after; HOTFIX 3 is the baseline).
- **f. No alert fatigue:** nothing pops up and nothing emails. The only push stays the Monday 08:36 line.

**Acceptance (extension-verified before merge):** on a quiet hour, Task manager must show within five seconds which of three states holds, each rendered distinctly and timestamped:
1. **done** (quiet, healthy);
2. **throttled, with the named reason**;
3. **feed dead** (stale banner).

All three are rendered in a browser check with the feed stopped deliberately for (3).

**Scope note (recommendation):** S5 and S6 ride in Track B R1, because they share `course_events` and the Pipeline strip. If you would rather keep R1 as specified, S6 becomes R1.1, merged right after R1 and before #695.

---

## Output checklist

| # | Output | State |
|---|---|---|
| 1 | Map-then-match design + provider queue + budget | Above (S1) |
| 2 | Query-quality baseline + first iteration | Above (S2) |
| 3 | Calibrated stops proposal | Waiting on O8 / O9 (S3) |
| 4 | Mislabel fix spec; Tranche 2 paste; unpublished AU quantification | Spec above; paste Part A written; Part B on Monday after the weekly line; AU first cut above, liveness in the 08:00 report |
| 5 | Velocity number spec | Above (S5) |
| 6 | INDEX updated: this programme is the primary track | Done in the same commit |

## Decisions for the Platform Admin

1. **D-S0:** SP-1 ahead of #695? (Recommended: yes.)
2. **D-S1-3:** the "no page published by provider" gap cause, verified per provider in Layer 4 and then trusted at the 60% rule. Is this the right way to stop counting unbindable courses?
3. **D-S6:** S5 + S6 inside Track B R1 (recommended), or R1.1 right after?
4. **Tranche 2 Part A:** apply when ready. Part B follows Monday's weekly line.

## Decisions 25 Oct 2026 22:27 (Platform Admin)

**Naming (recorded everywhere):** PR #694 is **"gate consolidation"**, never "S1", so it no longer collides with this programme's S1. Speed releases are named **SP-x** only.

| # | Decision (as given, in short) | Consequence |
|---|---|---|
| D-S0 | **SP-1 goes ahead of #695: YES.** Queue: #694 (gate consolidation, the Platform Admin's first review on 26 Oct) → SP-1 → #695 | Merge queue: **#694 → SP-1 → #695**. Track B release 1 keeps its place and takes the release slot when it is ready; one release at a time |
| D-S1-3 | **"No page published by the provider" gap cause: APPROVED exactly as designed**: first case per provider to Layer 4, then the 60% rule, re-opened by any later map that finds a page, never deleted. **Conjoint rule per provider in Layer 4: approved.** "These two convert a permanent search tax into a recorded fact" | Both go in SP-1 with S1 items 1–2 and the S4-3 mislabel fix |
| D-S6 | **S5 / S6 ship inside Track B release 1**, on one condition: if bundling would push release 1 past its estimate by more than a day, S5 / S6 split into **release 1.1, merged immediately after**, not later | The release 1 plan states its estimate with and without S5 / S6; the split is decided against that line, not later |
| D-T2 | **Tranche 2 Part A: the Platform Admin applies the paste now** (7 Canadian colleges). Part B stays empty until Monday's worst-named list | Verification of the applied rows and of the 18 fee pages fetched follows in the overnight record |
