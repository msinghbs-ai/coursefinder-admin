# `target_only` audit — result (throughput record section 3.2; standing order: audit → O10 → R2)

| | |
|---|---|
| Date | 24 Oct 2026, 19:40 (Melbourne) |
| Change control | CF-CHG-20260915-247 |
| Method | One read-only SQL pass over live (no migration). Derived reasons in the order of section 3.2: `robots` (home-page check refused or no answer, or at least half of a university's page reads refused by robots.txt) → `deliberate_list` (`search.skip_providers` or unpublished/archived) → `past_failure` (`fc_search_stopped_for_v1`) → `never_evaluated` (group B) → `rule_false_no_reason` (group A) → `other` |
| Audit file | `docs/platform/wrong-page-values/PASTE-20261024-target-only-audit.csv` (one row per provider, with evidence) |
| Write-back | `docs/platform/wrong-page-values/PASTE-20261024-target-only-audit-writeback.sql` — records the reason in `override_reason` on the 87 group-A cache rows; **releases nothing**; count-guarded (exactly 87); dry run on live passed (rolled back) |

## Populations (re-counted 24 Oct; section 3.1 counted 23 Oct)

| Group | Definition | Providers | Courses with no bound page |
|---|---|---|---|
| A | In `firecrawl_target_cache`, `included = false` | 87 (AU 15, CA 72) | 58 |
| B | Not in the cache, with at least one active course that has no bound page | 455 (AU 387, NZ 63, CA 5) | 2,150 |

Section 3.1's 349 / 1,445 for group B (and 388 for A) counted a different course set on 23 Oct; this audit uses "active course, no bound page" throughout.

## Result

| Group | Derived reason | Providers | Courses with no bound page | Proposed outcome (after O10) |
|---|---|---|---|---|
| A | `rule_false_no_reason` | 85 (all published; AU 13, CA 72) | 58 | Re-run the domain rule, then release in the first ramp batch (paste file) |
| A | `deliberate_list` | 2 (UniSA, Adelaide: unpublished, 0 courses) | 0 | Keep excluded, reason recorded |
| B | `deliberate_list` | 334 (all unpublished or archived) | 1,257 | Keep held (published switch decides) |
| B | `never_evaluated` | 120 (all published) | 891 | Run `firecrawl-targets` for them; release those passing the domain rule |
| B | `robots` | 1 | 2 | Keep excluded, reason recorded |
| — | `past_failure`, `other` | 0 | 0 | — |

AU group-A universities (rule false, no reason, published): Murdoch College (17 unbound), Victoria University (10), SAE University College (8), Western Sydney University International College (6), Australian University of Theology (5), Excelsia (5), ACAP (3), UWS College (2), Avondale (1), University of Southern Queensland (1), RMIT University Pathways, University of Divinity, Australian University College of Divinity (0 each).

## Decision for the Platform Admin — O10

1. Apply the write-back paste file (reasons only, nothing released).
2. Sign O10: approve (a) re-running the domain rule for the 85 `rule_false_no_reason` providers and releasing those that pass, and (b) running `firecrawl-targets` for the 120 `never_evaluated` providers. Both go out as one count-guarded paste file after sign-off, then R2 (Q1 at `search.daily_picked_cap = 100`).

## Thread — Platform Admin decisions 24 Oct 19:12, and what happened

### 1 Write-back — applied, then overwritten by design (no harm; nothing released)

- **Applied** 24 Oct ~19:11 (08:11 UTC) through the database tool, text as in the paste file (md5 `d9195b7f…`). Guards held: 87 rows annotated. Verified at 08:13:39 UTC: the provider ids per reason match the audit CSV exactly (deliberate_list 2 `0c424b41…`, rule_false_no_reason 85 `20de5c97…`); `included` unchanged on all 87.
- **Overwritten at 08:14:00 UTC by job `firecrawl-targets`** (every minute): `security.firecrawl_targets_refresh_v1` rebuilds every cache row from `security.firecrawl_targets_v1()`, writing `override_reason = pipeline.firecrawl_targets.reason` — null for these 87, which have no override row. The cache is derived; a reason written to it cannot persist. Section 3.2's write-back design ("written back as `override_reason` on the cache row") was wrong. My error in not reading the refresh before proposing it.
- **Durable alternative (needs a small migration, not done):** `firecrawl_targets_v1()` returns the rule clause that failed as the reason when there is no override (e.g. "rule: name has an excluded word", "rule: fewer than 100 active courses"), so every exclusion carries its reason from then on — the audit's intent — without writing override rows.

### 2 O10 — approved with conditions; **none of the 205 passes the current target rule**

The target rule (`firecrawl_targets_v1`, settings in Toolsets & limits › Firecrawl): country in AU/NZ/CA, name matches `universit(y|ies)`, name does not match `college|pathway|senior|language cent|divinity|theology`, active courses ≥ AU 100 / NZ 100 / CA 30, international registration (CRICOS, NZQA, IRCC DLI) or enrols internationals. It is re-checked every minute already.

| Group | Providers | Pass now | Fails on |
|---|---|---|---|
| A rule-blocked (published) | 85 (AU 13, CA 72) | 0 | 25 excluded word in the name (college, pathway, divinity, theology); 60 below the course minimum |
| B never evaluated (published) | 120 (AU 52, NZ 63, CA 5) | 0 | 120 the name does not contain "university" (colleges, institutes, polytechnics, NZ private training establishments) |

So "release those that pass" releases **nobody**, and a release paste file would change nothing. I have not written one. Releasing any of them needs one of:

| Option | How | Effect |
|---|---|---|
| a. Keep the rule | Nothing | 949 unbound courses at these 205 stay off Firecrawl search; R2 proceeds with today's targets |
| b. Change the rule's settings | Platform Admin edits the settings with a reason (e.g. add institute/polytechnic/wānanga to the name pattern; lower a minimum) | Every provider that then passes is included at the next minute, through the standard search → AI-match path, cap and stops |
| c. Named overrides | Count-guarded paste inserting `pipeline.firecrawl_targets(provider_id, included = true, reason, set_by)` rows for chosen providers | Exactly those providers, durable, each with its reason |

Under the O10 conditions any release flows through the standard search → AI-match path with negative evidence, the 100/day cap and the same per-course stops; none of the options bypasses those. **Decision needed: a, b (which settings) or c (which providers).** R2 does not depend on it and can proceed.

### 3 Platform Admin decisions 24 Oct 19:23 — staged (c)-then-(b), and what was done

| Decision | Done |
|---|---|
| **D1.1 Tranche 1 override paste**, ≤25 providers from the 120 never evaluated: the re-established polytechnics + top private-provider chains by active courses; list for review before applying; excluded words and minimums unchanged for everyone else | `PASTE-20261024-target-tranche-1-overrides.sql` (this folder), **for review, not applied**. Finding: **12 NZ polytechnics / institutes of technology are already targets** through existing override rows (SIT, EIT, Otago Polytechnic, Ara, Toi Ohomai, NMIT, Wintec, MIT, Unitec, NorthTec, Whitireia and WelTec, WITT); only **3** polytechnics are among the 120 (UCOL, Open Polytechnic, Tai Poutini). Tranche = those 3 + the 22 largest private providers by active courses (581 already-queued searches, about 1,160 credits). Left out on purpose and listed in the file: public TAFEs, wānanga, industry training organisations. Guards: R2 live (`search.daily_picked_cap` exists), exactly 25 eligible without an override, exactly 25 inserted. Dry run on live with a stand-in R2 setting: 25 rows, all 25 included at the next refresh |
| D1.2 Normal search only (100/day cap, per-course stops, negative evidence; no task bypass) | Built into the file: override rows only; no task, no re-queue; the guard refuses to run before R2's cap exists |
| D1.3 (b) proposal after about two weeks of ledger data, paired with the O8/O9 budget review | Due about two weeks after the tranche is applied |
| **D1.4 Rule reports the failing condition** (own release) | **v2.15.349, PR #691, merged and live.** Column `firecrawl_target_cache.rule_reason`, filled each minute; screens say "not matched by the rule: <reason>". Live: all 87 excluded carry a reason (25 excluded word, 57 under 30 courses (CA), 5 under 100 (AU)). Migration md5 `ebdcaf97…` = repo file. Suite 1,896 passed (4 legacy). Finding: 951 of the included targets are included by hand-set overrides, not the rule |
| Weekly line until (b): correct-page rate + credit burn for tranche providers | Scheduled task "Tranche 1 weekly report", Mondays 08:36 Melbourne (first 26 Oct; says "not applied yet" until the tranche is in); appends under "## Weekly tranche 1 line" in this file |
