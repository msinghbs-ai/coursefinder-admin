# Course entry requirements: model comparison and proposed acceptance criteria

**Status:** decided by the Platform Admin, 25 Nov 2026 18:26 AEDT: gpt-4.1-mini on the whole page; criteria approved; converter fix after the windows. **Prepared:** S1-Build, 25 Nov 2026 18:05 AEDT, from the Platform Admin's 15:40 AEDT direction. **Release:** Pilot s1151 (#1614).

## Summary

- On the source-verified labels, **gpt-4.1-mini reading the whole page** is the only setup that finds at least 90% of academic requirements (95%) and of pathway and conditional statements (94%). It also returns the fewest rows that match no label (34 of 203). It costs about US$0.0018 a page.
- On the v6 selection, no model reaches 90% academic recall. Qwen3 30B comes closest (87%) but returns 339 rows that match no label out of 521. gpt-4.1-mini drops to 81% on the selection, and 26 of its 29 lost labels were inside the selected text.
- GPT-5 mini and GPT-5 nano cannot be used under the current extraction contract. OpenRouter answers HTTP 404 to the request as sent (temperature 0, all provider parameters required). Nothing was spent on them.
- Using gpt-4.1-mini on the whole page needs two Platform Admin decisions: approve the acceptance criteria below, and allow course entry reads an exception to mandatory preprocessing (Agent Operating Model v1.24).

## How it was measured

- **Cohort:** the 83 benchmark pages (53 with earlier paid answers, 30 with rows a person accepted in Layer 4). Every model was given the same prompt (`course-entry-v1`), output schema and request.
- **Two reads per page:** each page was read once as the whole page and once as its selection.
- **Reused results:** DeepSeek V4 Flash (two runs), Qwen3 30B, MiMo v2.6 Flash and Mistral Small 3.2 were not read again. Those models were read under selectors v3 to v5, not v6.
- **The label set:** 216 label rows, each confirmed to be on its stored page. They were reviewed one by one: 119 academic, 61 other admission conditions, 25 inherent or placement requirements and 11 not entry requirements at all (uniform and placement costs, completion rules, phase-out notices). File: `2026-11-25-course-entry-source-verified-labels.tsv`.
- **Recall** is counted over academic labels, and over academic plus admission-condition labels. Inherent, placement and not-a-requirement labels are not counted.
- **Pathway and conditional labels** (89) are lines such as "may be admitted", "OR", "Non-Year 12", "work and life experience" and "may also be considered". They are scored separately.
- **Unsupported rows** are rows whose quote was not in the text sent. The existing reader check already removes them before anything is stored.
- **Rows matching no label** may still be genuine requirements that the labels lack, so treat that count as an upper bound on wrong rows.

## Results (83 pages)

| Model, input | Academic recall | Academic + conditions | Pathways | Pages with every requirement | Rows (unsupported, no label) | Requirement type right | Audience right | US$ per 83 pages |
|---|---|---|---|---|---|---|---|---|
| **gpt-4.1-mini, whole page** | **95%** | **92%** | **94%** | **71** | 203 (39, 34) | 92% | 77% | 0.152 |
| gpt-4.1-mini, v6 selection | 81% | 79% | 84% | 53 | 210 (15, 62) | 86% | 71% | 0.104 |
| Qwen3 30B, selection (v3–v5) | 87% | 89% | 87% | 70 | 521 (32, 339) | 76% | 70% | 0.032 |
| Qwen3 30B, whole page | 87% | 88% | 88% | 68 | 486 (80, 297) | 77% | 68% | 0.047 |
| MiMo v2.6 Flash, whole page | 87% | 88% | 92% | 65 | 351 (32, 185) | 78% | 71% | 0.055 |
| MiMo v2.6 Flash, selection (v3–v5) | 83% | 82% | 91% | 58 | 349 (7, 190) | 79% | 70% | 0.038 |
| DeepSeek V4 Flash, whole page | 82% | 83% | 88% | 58 | 263 (17, 107) | 79% | 70% | 0.041 |
| DeepSeek V4 Flash, v6 selection | 81% | 81% | 87% | 56 | 277 (5, 126) | 75% | 72% | 0.025 |
| Mistral Small 3.2, selection (v3–v5) | 74% | 70% | 81% | 44 | 213 (18, 85) | 88% | 65% | 0.020 |
| GPT-5 mini, GPT-5 nano | not served under the contract (HTTP 404) | | | | | | | 0.000 |

- **Scores:** too few labels carry a minimum score to compare them (9 to 29 per model). gpt-4.1-mini matched 9 of 22 on the whole page, the most of any model.
- **Tokens:** the selection halves input tokens for every model (DeepSeek 283k to 169k; gpt-4.1-mini 283k to 173k).
- **Consistency:** DeepSeek read the same whole page twice and gave the same outcome on 153 of 180 labels (85%). On labels inside the selection, the whole-page read and the selection read agreed on 148 of 177 (DeepSeek) and 145 of 177 (gpt-4.1-mini).
- **Spend:** the s1151 run cost US$0.256, all of it gpt-4.1-mini. Platform AI spend today was US$2.67 of US$5.00 at 18:02 AEDT.

## Proposed acceptance criteria (for Platform Admin approval)

These replace "no loss against one other AI read", which a model fails against itself: the same whole page read twice differed on 21 of 83 pages.

1. **Academic recall** of at least 90% on the source-verified labels of the benchmark pages.
2. **Pathway and conditional recall** of at least 90%.
3. **Unsupported rows** are all removed by the existing reader quote check. This is unchanged: nothing unquoted is stored.
4. **Rows matching no label** stay at or below 25% of the rows returned. Each one remains a Layer 4 decision, as today.
5. **Every answer is valid** (schema and complete) on every page, through the pinned model with provider data collection denied.
6. **Cost** fits inside the US$5.00 daily platform limit for the window being activated.

Under these criteria only gpt-4.1-mini on the whole page qualifies (95%, 94%, rows matching no label 17%).

## Activation it would allow (prepared, not applied)

- **Route and model:** `course_entry_requirements` on gpt-4.1-mini, switched on with a US$0 daily cap, so the scheduled reader stays held. One on-demand request covers the 20 providers of the 172 courses.
- **Input:** `reading.course_entry_sections_on` set to 0, so course entry reads send the whole page. Recorded as a preprocessing exception for this one service.
- **Window 1:** the 172 courses queued through the entry Read now. Estimate US$0.31 (US$0.0018 a page), then the route switches off.
- **Window 2:** the 267 queued items, the same way. Estimate US$0.48.
- **Unchanged:** Layer 4 decisions, manual locks, the 152 inactive rows, G3, cron and Firecrawl ($0).

## Three missed selector lines (s1152)

- **Where they are lost:** two of the three lines (CTI, Holmesglen) are lost when the page becomes lean text; the third (SP Jain) is in the lean text but its block is not selected.
- **Diagnostic:** s1152 (worker v1.0.45) records where each one sits on the stored page, and the fix follows from that.
- **If the whole page is chosen:** course entry reads no longer depend on the selector. The fix still matters to the other readers that use it.

## s1152 findings (25 Nov 2026 18:20 AEDT)

- **CTI:** the Diploma line is inside an HTML comment, so it is never shown. The label is wrong, and the lean text is right to leave it out (reclassified in the label file).
- **SP Jain:** "Graduate with an / AUSTRALIAN DEGREE (AQF Level 9)" is a card about the award a graduate receives, not an entry requirement. The label is wrong (reclassified).
- **Holmesglen:** the requirements are published as escaped HTML (`&lt;br&gt;`). The lean converter strips tags before decoding entities, so `<br>` stays in the text. The fix is a new converter version `lean-md-v3`, shared by the AER v2 readers. The Platform Admin chose to ship it after Windows 1 and 2, once it is checked that no lane reads pages again because the converter version changed.

## lean-md-v3 (s1195, 26 Nov 2026)

- **Fix:** the shared converter takes out an escaped tag of a known HTML element (`&lt;br&gt;`, `&lt;/strong&gt;`, `&lt;a href=&#34;…&#34;&gt;`) like a real tag. Text such as "a &lt; b" stays text. Nothing else in the conversion changes. Worker v1.0.47.
- **Checked on the stored Holmesglen markup:** s1152 recorded it. The missed line "You may also be considered if you have: • Completed an Australian Diploma …" is now in the lean text.
- **No page is read again for the new version.** Checked live at 26 Nov 10:55 AEDT: no function, job or setting names a converter. The name is only recorded in `pipeline.ai_input_observations` and `pipeline.lean_section_eval_cases`.
- **Holmesglen now:** 43 international courses; 25 have entry requirements. Of the 21 entry reads not filled, 10 failed on the OpenRouter weekly key limit before the windows, 1 found no answer, and 10 were skipped for other reasons (identity, Layer 4, the page states none). No targeted re-read is run: the existing queue retries them, and every future read uses v3.
