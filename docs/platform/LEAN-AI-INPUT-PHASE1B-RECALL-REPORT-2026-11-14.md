# Lean AI Input Phase 1b step 1: recall report (run phase1b-step1b-2026-11-14)

Worker coverage-sweep v0.91.0, selector lean-sections-v1 over lean-blocks-v1. 2,800 of 2,800 labelled cases done (14 Nov 2026 04:01Z), 0 failed, 0 AI and 0 Firecrawl calls. Stored copies only.

## Basis

Recall is measured on the **2,326 cases where the labelled value is in the text the current reader is given** (113 more are only in the raw HTML). A page with nothing selected counts as sent whole, as the design says. Labels: values accepted by a person in Layer 4 (entry requirements) and values read by tested university adapters.

## Results

| Field (label source) | Cases | Current 24k cut | Converted page | Selection | Beyond the cut: held / total | Net vs cut |
|---|---|---|---|---|---|---|
| Fees (adapter) | 257 | 0.9455 | 1.0000 | 0.9961 | 14 / 14 | +13 |
| Intakes (adapter) | 228 | 0.9605 | 0.9956 | 0.9956 | 9 / 9 | +8 |
| Entry requirements (person-accepted) | 400 | 0.9325 | 0.9775 | 0.9375 | 25 / 27 | +2 |
| Entry requirements (adapter) | 376 | 0.9362 | 0.9707 | 0.9388 | 21 / 24 | +1 |
| Duration (adapter) | 358 | 0.9860 | 1.0000 | 0.9804 | 5 / 5 | −2 |
| Campus (adapter) | 352 | 0.9943 | 0.9744 | 0.9432 | 2 / 2 | −18 |
| Delivery (adapter) | 355 | 0.9887 | 0.9887 | 0.9239 | 4 / 4 | −23 |
| **All** | **2,326** | **0.9635** | **0.9854** | **0.9553** | **80 / 85** | **−19** |

Median page 13,289 characters; median selection 6,218; selection is 0.64 of what is sent today.

## Findings

1. **The 24,000-character cut hides values.** 85 labelled values are past it in the reader's own text. The converted page holds all 85 and the selection holds 80.
2. **Fees and intakes meet the gate** (at least 99.5% recall, every beyond-cut value held). This makes them first candidates for 1b-3 qualification, which is a separate approval and involves paid calls. Nothing is switched on.
3. **Entry requirements** are slightly better than the cut but below the gate. Of the 51 misses, 28 are selector misses (headings "Assumed knowledge", "Advanced standing", literacy and numeracy, age and checks), addressed in lean-sections-v2. 20 are converter misses (score lines such as "70 Guaranteed ATAR or equivalent") in aer-v2.ts `aerV3Blocks`, which belongs to S1-AER and is referred to that build. A few are label artefacts (HTML entities stored in adapter labels).
4. **Delivery and campus adapter labels are noisy.** Delivery values are often campus names ("Campus Burwood Duration", "Hamilton City Campus", "MELBOURNE CITY", "Research"), and some campus values are delivery text. The selector is not tuned to these. They need cleaner labels before they can gate anything.
5. **Operational:** batches of 120 fee cases exceeded the edge CPU-time limit. Batches of 40 ran cleanly, so `batch.lean_sections_eval` is set to 40 in the step 2 bundle. The fire guard depends on pg_net responses, some of which are not recorded; it then holds for its 4-minute window.

## Next (bundle, Pilot PR #1139)

Step 2 shadow beside live reads, lean-sections-v2, and run phase1b-step1c-2026-11-14 (the same 2,800 cases, zero spend). 1b-3 and 1b-4 stay separate approvals.

## Update 14 Nov 2026 17:20 AEDT: runs C and D, lean-md-v2, Curtin and Swinburne

All offline, stored copies only, 0 AI and 0 Firecrawl calls. Run C: 2,800 of 2,800 done. Run D: 2,800 of 2,800 done. Curtin/Swinburne set: 1,079 of 1,079 done. 0 errors.

- **Run C** (worker v0.92.0, then v0.93.0 from 05:22:47Z) is mixed: entry (person-accepted), campus and delivery were read with lean-md-v1, the rest with lean-md-v2.
- **Run D** (worker v0.93.0, lean-md-v2, selector lean-sections-v2, entity-decoded labels) is the clean result.
- The Curtin/Swinburne set holds every person-accepted entry label on stored HTML for Curtin University (480) and Swinburne University of Technology (599). It was seeded with seed step 1's own insert, filtered to the two providers (run label `phase1b-step1d-curtin-swinburne-2026-11-14`).

### Run D: six fields, lean-md-v2 (basis: value in the reader's text; nothing selected = whole page)

| Field (labels) | Cases | 24k cut | Converted page | Selection | Beyond the cut: held / total | Selection share of sent |
|---|---|---|---|---|---|---|
| Fees (adapter) | 257 | 0.9455 | 1.0000 | 0.9961 | 14 / 14 | 0.83 |
| Intakes (adapter) | 228 | 0.9605 | 0.9956 | 0.9956 | 9 / 9 | 0.76 |
| Entry requirements (person-accepted) | 400 | 0.9325 | 0.9925 | 0.9650 | 27 / 27 | 0.77 |
| Entry requirements (adapter) | 378 | 0.9365 | 1.0000 | 0.9815 | 24 / 24 | 0.74 |
| Duration (adapter) | 358 | 0.9860 | 1.0000 | 0.9832 | 5 / 5 | 0.49 |
| Campus (adapter) | 349 | 0.9943 | 0.9914 | 0.9599 | 2 / 2 | 0.64 |
| Delivery (adapter) | 354 | 0.9887 | 0.9915 | 0.9266 | 4 / 4 | 0.43 |
| **All** | **2,324** | **0.9634** | **0.9957** | **0.9703** | **85 / 85** | **0.66** |

### Entry requirements (person-accepted, the same 400 cases) across runs

| Run | Converter / selector | Converted page | Selection | Converter misses | Beyond the cut held |
|---|---|---|---|---|---|
| B | lean-md-v1 / v1 | 0.9775 | 0.9375 | 9 | 25 / 27 |
| C | lean-md-v1 / v2 + entity fix | 0.9775 | 0.9525 | 9 | 26 / 27 |
| D | lean-md-v2 / v2 + entity fix | **0.9925** | **0.9650** | **3** | **27 / 27** |

### Curtin and Swinburne (every person-accepted entry label, lean-md-v2)

| Provider | Cases | 24k cut | Converted page | Selection | Selector misses |
|---|---|---|---|---|---|
| Curtin University | 480 | 1.0000 | 1.0000 | 0.9979 | 1 |
| Swinburne University of Technology | 599 | 1.0000 | 1.0000 | 0.8965 | 62 |

54 of Swinburne's 62 selector misses are score lines ("70.0 Guaranteed Entry ATAR or more entry options"). lean-md-v2 now keeps them as one block, but the selector does not pick that block: it is longer than a label and the entry preflight does not count it as a signal. This affects only a reader that is sent the selection.

### What this means for AER v3

AER v3 (`aerV3User`) is sent the **whole page in blocks**, not the selection, so its input recall is the converted-page figure: **1.0000 for Curtin (480/480) and Swinburne (599/599), 0.9925 on the 400-case person-accepted sample**. The selector's Swinburne gap does not affect AER v3.

One risk for the 50-case run: the AER v3 quote check requires each quote to sit inside **one** block (`aerFlat(blk.text).includes(quote)`). This check joins adjacent blocks, so a person-accepted quote that spans two blocks counts as held here but would fail AER v3's single-block quote check. The share of such quotes is not measured yet.

### Shadow check (Phase 1b step 2)

Deployed with worker v0.92.0 (kept in v0.93.0) and rehearsed (txid 17223165). **0 live observations so far**, because no Enrich fields AI read has run since the deploy (financial containment). It completes on the first Enrich run, which is a paid run needing approval.
