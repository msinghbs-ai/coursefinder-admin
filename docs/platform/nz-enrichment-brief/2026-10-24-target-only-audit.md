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
