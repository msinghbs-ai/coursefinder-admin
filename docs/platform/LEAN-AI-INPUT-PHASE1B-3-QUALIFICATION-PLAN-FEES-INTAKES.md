# Lean AI Input Phase 1b-3: qualification plan for fees and intakes (draft for approval)

Prepared 14 Nov 2026 for the Platform Admin. **Nothing in this plan runs until it is approved.** A pass records a qualification result only. Switching a service to the selected input is step 1b-4, a separate per-service setting the Platform Admin changes.

## 1. What is being qualified

| Field | Live reader (service) | Pinned model | Today's input | Candidate input |
|---|---|---|---|---|
| Fees | `fee_reader` (worker mode `fee_ai`) | qwen/qwen3-30b-a3b-instruct-2507 | page text, first 40,000 characters (`fees.page_chars`) | lean-sections-v2 selection for `fees`, `[B# @offset]` blocks, whole page when nothing is selected |
| Intakes | `course_other_fields` (Enrich fields) | qwen/qwen3-30b-a3b-instruct-2507 | page data plus main text, first 24,000 characters (`enrich.page_chars`) | lean-sections-v2 selection for `intakes`, as above |

The candidate needs a new prompt version for each service: the same instructions, plus one line saying the text arrives as `[B#]` blocks and each quote must come from one of them. Same model and same answer schema. That is why it must be qualified and cannot just be switched on.

**Correction to the earlier figure:** the fee reader reads up to 40,000 characters, not 24,000. The 14 fee values "beyond the cut" in run B are beyond 24,000 characters. Not all of them are beyond what the fee reader sees today. Qualification measures against the fee reader's real 40,000-character window.

## 2. Sample (minimal, all from stored evidence)

| Set | Fees | Intakes | Source |
|---|---|---|---|
| Positives (value in the reader's text) | 257 | 228 | Run B labelled cases (tested adapter readings) |
| Of which: long pages (over the reader's window) | 43 pages over 40,000 characters | 9 values beyond 24,000 characters | Run B |
| Negatives (no value on the page) | up to 100 | up to 100 | Layer 4 "not stated" decisions; if fewer than 50 exist, structurally verified absences (fee table with no international row, no dates block) |

Each page is read twice in the same session: once with today's input (baseline) and once with the candidate input. Same model, same day. No Firecrawl: stored copies only.

## 3. Estimated spend

Rates fitted from 364 live calls on the pinned model, 14 Nov 2026: about **US$0.10 per million input tokens and US$0.30 per million output tokens**. Tokens estimated at four characters each, plus about 1,000 prompt tokens per call.

| Reads | Calls | Typical input tokens | Output tokens | Estimate (US$) |
|---|---|---|---|---|
| Fees baseline | 357 | about 5,000 (p95 11,000) | about 600 | 0.25 |
| Fees candidate | 357 | about 3,300 (p95 11,000) | about 600 | 0.19 |
| Intakes baseline | 328 | about 5,100 (p95 7,000) | about 200 | 0.19 |
| Intakes candidate | 328 | about 3,000 (p95 9,400) | about 200 | 0.12 |
| **Total** | **1,370** | | | **about US$0.75** (p95 basis about US$1.30) |

**Proposed hard ceiling: US$2.00.** The run is opened with `security.on_demand_open_v1('claude_session', 'Lean AI 1b-3 qualification: fees, intakes', …, estimate)`, scoped to these two services, and closed with the actual spend reported. The OpenRouter credit floor (US$0.50) and the daily service caps (`fee_reader` US$5, `course_other_fields` US$2) still apply. Balance on 14 Nov 04:45Z was US$34.49. Nothing else is started.

## 4. Acceptance criteria (per field; all must hold)

1. **No loss:** the candidate finds the labelled value in every positive where the baseline finds it (0 net losses). Any loss is listed for a person to review.
2. **Long-page gain:** on the long-page set, the candidate finds at least as many labelled values as the baseline.
3. **No new wrong values:** no candidate value contradicts a label the baseline got right. On negatives, candidate false values do not exceed the baseline's.
4. **Evidence:** 100% of candidate values carry a quote found in the `[B#]` block it cites (the existing quote checks).
5. **Shape:** at least 99% schema-valid answers on the first attempt, with retries counted.
6. **Cost:** median input tokens per retained valid value lower than the baseline. Reported, not a pass/fail gate for fees, where large fee pages stay large.
7. **Admission unchanged:** both readers' results go to a qualification table only. Nothing is admitted, published or sent to Layer 4 from this run.

## 5. What has to be built first (one PR, one rehearsal)

- Worker mode `lean_qualify`: reads the qualification cases, builds both inputs, calls the pinned route through `cascadeFetch` for the two services, and records both answers. It uses the existing answer checks and is time-budgeted.
- Migration: a qualification case and result table, the two candidate prompt versions (recorded, not active), the case seed from run B or run C, and a read-only report. Switches ship off. G1/G2/s42 as usual.
- Rehearsal and CI, then the run under the on-demand ceiling above, then a report against section 4.

## 6. Out of scope

Entry requirements, delivery and campus (below the gate, or labels need cleaning); scholarship pages (not covered by the selector); any activation (1b-4).

## Result, 14 Nov 2026 19:45 AEDT (run phase1b-3-fees-intakes-2026-11-14; Pilot PR #1144, worker v0.95.0)

Approved by the Platform Admin 14 Nov 2026 17:20. On-demand request `0ffb47ab-4c67-45d5-9960-e4f779fb566d`, opened 07:21Z and closed 08:44Z. The switch is off again.

- **Spend:** US$0.6763 recorded = US$0.6763 traced, over 1,161 calls on the pinned qwen/qwen3-30b-a3b-instruct-2507. The ceiling was US$2.00. No Firecrawl, nothing admitted.
- **Pages:** 597 read. 87 intakes negatives were set aside as not clean (the page shows a start-date signal). 1 fee positive ran out of time twice.

| Field | Set | Pages | Baseline found | Candidate found | Lost / won | Candidate quotes in text | Median input tokens (base → candidate) | Valid answers |
|---|---|---|---|---|---|---|---|---|
| Fees | positive | 256 | 194 | 180 | 47 / 33 | 186 / 208 | 5,281 → 4,013 (−24%) | 100% |
| Fees | negative | 100 | 74 pages with a value | 79 | — | 64 / 79 | 4,619 → 4,036 | 100% |
| Intakes | positive | 228 | 153 | 150 | 11 / 8 | 152 / 226 | 3,638 → 2,932 (−19%) | 100% |
| Intakes | negative (clean) | 13 | 1 page with a value | 0 | — | — | 835 → 1,088 | 100% |

**Verdict: neither field qualifies.** Both fail "no loss" and "quotes in text". Fees also fails "no new false values" (79 against 74). Nothing is switched on.

**Why:**
1. **Quotes across blocks.** With the page sent as labelled `[B#]` lines, the model quotes real page words that run across two or more blocks (list items, table rows). The candidate's quote check is against the labelled text, so those quotes fail. For fees the existing reader rule then drops the row: 43 of the 47 lost fee cases are rows dropped this way with the right amount. For intakes the value is usually right but the quote fails (74 of 226).
2. **Weak fee negatives.** The fee negatives (pages the fee reader once read with no row found) are not clean: today's baseline finds a fee on 74 of them. That criterion needs person-confirmed negatives before it can gate anything.
3. **Labelled months vs semesters.** The intakes judge counts a value such as "Semester 1, Semester 2" as not finding a labelled "February, July". This affects both arms equally.

**Options for a candidate v2 (each about US$0.6 to re-run, Platform Admin to choose):**
- **A.** Send the selection as plain text (no `[B#]` labels; offsets kept on our side) for readers that do not cite blocks (fees, intakes). Quotes validate as they do today.
- **B.** Keep the labels but validate quotes against the blocks' joined words, the same way the recall matcher does.
- Either way, take fee negatives from person-confirmed "not stated" decisions.
