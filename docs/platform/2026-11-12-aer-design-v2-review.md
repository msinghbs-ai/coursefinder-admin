# Review of AER design v2 (v0.2), 12 Nov 2026 17:10 AEDT

Reviews: `AER-DESIGN-V2-PROPOSAL.md` v0.2 (#443) against the production evidence of 11–12 Nov 2026 (Pilot #1034 to #1058; `nz-enrichment-brief/2026-11-12-aer-mandate-0923-response.md`). Integration Controller review; nothing is built or switched on by it.

## Verdict
The direction is right for HTML pages and course pages (one versioned prompt, one small strict verifier, reference data instead of word lists, labelled examples from Layer 4). Approve steps 0–1 with the five amendments below. They keep what today's production runs proved and close two safety gaps in the proposal.

## Figures checked on live (12 Nov 2026 17:05 AEDT)
| Figure in v0.2 | Live | Note |
|---|---|---|
| 780 eligible courses with admitted academic entry | 818 courses with active course-level rows | counts course-scoped rows only |
| (not counted) | 4,153 courses at the 16 providers with an active country table | resolver rule 4 (provider minimum) applies to every course there |
| 16 providers with an active table | 16 | agrees |
| `aer.machine_daily_max` 300 | 300 | agrees |
| 568 Layer 4 AER items waiting | 531 entry items pending | moving; agrees in size |

Coverage must have one definition before v2 is measured against v1: a course is covered for an applicant country when `security.entry_resolve_v1(course, country)` returns `minimum_published`. Report it over the top applicant countries (for example the 20 largest by enquiries), not as "course has a row".

## Amendments
1. **Proven structure is a record source, not only a converter option.** When the converter proves a table's structure (the aligned grid: every value in exactly one column, fail closed), records come from the structure and go through the same verifier; the model does not re-extract them. Evidence: UNSW, Sydney and UQ, 5,526 minimums, 0 dropped, no model cost, values exact; the earlier model reads of the same PDFs were held. A model emitting about 2,000 quoted records for one PDF is slower, costlier and less exact. Pages without proven structure go to the prompt.
2. **Completeness stays independent of the model.** The model's own "seen but not mapped" list cannot catch rows it skips silently. For tables, keep a check computed from the converted page (rows and country or qualification labels printed against records returned). For course pages the model's list is enough.
3. **Safety gate is precision, throughput gate is pass rate.** Activation needs no new false admission on the labelled set and an audit error rate no higher than v1's. The 70% pass rate is a throughput target: below it v2 is slower, not less safe. Measure both in step 1; set the pass-rate target from the measured v1 baseline.
4. **Carry the production lessons into the verifier and the reader contract.** These came from failures on live this week and must not be lost in the simplification:
   - the printed course is part of a row's identity (streams of one CRICOS course);
   - a per-course qualification minimum is never admitted as the provider's;
   - every course minimum maps to one catalogue course (CRICOS, exact title and level, then a person; AI only suggests);
   - a rank (ATAR) is a course fact, not a qualification's minimum;
   - one large stored PDF per worker call, and a recording that fits the 8 s API statement limit;
   - D1 host and shared-host checks.
5. **Freeze v1 now.** Bug fixes only: no new layout readers, lists or recovery paths while v2 is in shadow. That stops the rule growth the design describes without pausing the reads that are working.

## Position on the decisions (section 8)
| Decision | Recommendation |
|---|---|
| 1. v2 direction, steps 0–1 (shadow, about US$10–20, no Firecrawl) | Approve, with amendments 1 to 5 |
| 2. Raise `aer.machine_daily_max` (300) | Approve: reads it admits already pass today's rule, so it is a brake, not a gate. Proposed 1,000, with the 5% audit and withdrawal unchanged; review after one week |
| 3. Country packs as the only home of country wording | Approve; the heading list, country aliases and qualification aliases move into the packs (ATAR as a course fact is a policy rule recorded there) |
| 4. Five jobs; Fill entry requirements | Approve |
| 5. Course-page activation gate | Replace "70% pass" with amendment 3 (no new false admission, audit error no higher than v1); keep 70% as a target |
| 6. Qualification rows in the consumer API | Later, held under Operating Model v1.15 until the Wix and Zoho developers are told |

## Work that should not wait for v2
- Layer 4 decisions waiting now: Sydney (approve as read), UWA and Adelaide (Approve except), UTas (approve 5284a753, reject 73615b9a), UNSW 21 and UQ 5 course links: about 5,700 minimums and 1,705 courses.
- Source discovery for the 12 providers read from overview pages, QUT and Macquarie (sources never read) and the 17 with no source: in v2 terms this is `aer-find` and can start on v1 now.
