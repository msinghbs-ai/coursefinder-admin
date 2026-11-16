# Layer 4 clearance and model benchmark (16 Nov 2026)

**Asked by:** Platform Admin, Mon 16 Nov 2026 14:06 AEDT (Layer 4 triage and safe clearance; a controlled benchmark of qualified models only). Follow-up instructions 15:56, 16:00, 16:47, 18:01 and 18:44 AEDT.
**Done by:** the Course Module session (S2-CF), 14:10 to 16:40 AEDT; the official URL resolution (§7) 16:50 to 19:45 AEDT.
**Live system:** Supabase project `fxcwkweaxjtknorudmwp` only. Every audit query ran `set transaction read only` with `statement_timeout` 20 s.
**Not touched:** tonight's PR 1 cutover (22:30), the 23:15 PR 3 task, Tuesday's PR 2 cutover (22:30), Wednesday's 09:15 and 09:30 tasks.

## 1. Summary

| | Result |
|---|---|
| Layer 4 waiting | **5,172** at 14:20 AEDT; **5,136** at 16:28 AEDT after the reconcile switch (read back). The ~7,057 quoted came from the telemetry sheet and was out of date by the time it was measured. |
| Created, decided and superseded | 15 Nov: 5,855 created, 3,861 decided, 1,016 superseded. 16 Nov to 14:20: 281 created, 892 decided, 1,205 superseded. Since 16 Nov, items are decided or superseded faster than they arrive. |
| Cleared by a deterministic rule | **36** items on retired courses. `layer4.reconcile_supersede_on` was set to 1 at 16:00 AEDT on the Platform Admin's approval. A window defect kept the job from reaching them; it was fixed through the setting `layer4.reconcile_batch` and the items were settled at 16:27 AEDT (§3.1). |
| Official URL batch (§3.2, §7) | **836 of 856 closed** (16 Nov 19:20 AEDT): 751 by rule `l4-link-refusal-v1`, 28 audit-sample items verified, 56 live-link conflicts verified valid (live link kept), 1 refused. **20 left open**: their evidence proves neither way. Layer 4 waiting **4,916** at 19:20 AEDT. |
| Owned by the AER session | **2,578** `course_entry_first_read` items. 1,604 need a corrected read, not a person; 488 are the 5% audit sample and stay with a person (§3.4). |
| Model benchmark | Round 2 on the frozen 50-case AER set with four pinned models. **No model qualifies.** Nothing was admitted or switched on. Best value: Mistral Small 3.2. Highest accuracy, tied: Gemini 2.5 Flash and MiMo v2.6 Flash (§4). |
| Spend | **US$0.459** in answers (estimate $0.60); 0 Firecrawl. On-demand request `ca8dee01` is closed. Both eval switches are back to 0. |

## 2. The backlog as measured (14:20 AEDT)

| Field (queue) | Waiting | New in 24 h | Older than 7 days | Oldest | Owner |
|---|---|---|---|---|---|
| `course_entry_first_read` | 2,578 | 55 | 300 | 29 Oct | AER session |
| `official_course_url` | 2,196 | 67 | 2,051 | 31 Oct | S2-CF (course data) |
| `provider_current_tuition_validation` | 146 | 0 | 134 | 25 Oct | Fees |
| `provider_description` | 88 | 1 | 2 | 2 Nov | S2-CF |
| `entry_matrix_first_run` | 77 | 0 | 14 | 28 Oct | AER session |
| `no_page_first_run` | 55 | 0 | 55 | 30 Oct | S2-CF |
| `course_description_first_read` | 15 | 6 | 9 | 3 Nov | S2-CF |
| `entry_matrix_change`, `provider_current_tuition`, `conjoint_rule_first_run`, `course_english` | 17 | 0 | 11 | | AER, Fees |

Layer 4 has no `identity_margin_thin` or `binding_ambiguous` items. Those holds belong to the course description machine rule and to page binding (`pipeline.coverage_course_pages`), not to Layer 4.

## 3. Clearance

Every route below either settles an item through an existing machine rule or waits for a person. No item was approved, rejected or bulk-updated by SQL.

### 3.1 Applied: retired-course supersession (36)

- **Mechanism:** `security.layer4_reconcile_v1(kind, limit)`, which already existed (3 Nov 2026), called by `security.layer4_readiness_tick_v1` (job `layer4-readiness`, :22 and :52).
  - It supersedes waiting items of the platform kinds (`layer4.platform_kinds`) when `security.layer4_resolution_v1` says the platform can settle them: a repeat, already decided with no new evidence, already the active value, or the course or provider retired.
  - It records the reason in `change_control_ref` and in `pipeline.layer4_supersessions`.
  - It never approves or rejects. It had been held off since 3 Nov ("removes work from the queue, so it ships off").
- **Rolled-back dry run, 14:45 AEDT:** 2,348 items examined; 36 `official_course_url` items on retired courses resolvable and superseded; 5,172 → 5,136. Nothing else matched.
  - The 29 items whose proposed address equals the stored `course_url` are not "already the active value" under the platform's own rule, so they are not claimed.
- **Applied, 16:00 AEDT:** `layer4.reconcile_supersede_on` 0 → 1. Reason recorded in Settings: "Platform Admin 16 Nov 2026 15:56 AEDT approved …".
- **Defect found on the first live run (bucket A):** the 16:22 AEDT `layer4-readiness` run succeeded but settled **0**.
  - `layer4_reconcile_v1` takes the oldest `layer4.reconcile_batch` waiting platform-kind items (`order by created_at`) and examines only those. The setting's help text says "at most this many superseded in one run", but the code uses it as the number *examined*.
  - At 200, the oldest 200 items are always items for a person, so the run never reaches a settleable item further down the queue.
- **Fixed by a setting, 16:27 AEDT:** `layer4.reconcile_batch` 200 → 3,000 (range 1 to 5,000), with the reason recorded. One run now examines all 2,348 waiting platform-kind items, which takes 1.4 s (rolled-back timing).
  - The function was then run once with that setting: examined 2,348, superseded 36 (`entity_retired`).
  - Function md5 `4453480bb9f418e6e8d37b91c4392a1f`, unchanged.
- **Read back, 16:28 AEDT:**
  - 5,136 waiting (from 5,172); `official_course_url` 2,196 → 2,160.
  - 36 items superseded with "settled by the platform (entity_retired)"; 0 waiting official URL items on retired courses.
- **Code fix proposed (Pilot, not made here):** rotate the window (examine the items least recently examined first), or select only items that `layer4_resolution_v1` can settle. Also correct the setting's label. Until then, keep `layer4.reconcile_batch` above the number of waiting platform-kind items.
- From now on, an item for a course or provider that is retired is settled without a person.

### 3.2 For one batch decision: 859 `official_course_url` items the machine proved wrong

In every one of these items the course-link finder found a page and refused to link it, because the page is demonstrably for something else. **177** of the 856 courses hold an active official link. (The first issue of this report said 33; that count used `catalogue.courses.course_url`, not `catalogue.course_links`.) For 73 of them the proposed page *is* the live official link (§7). So "close" means: refuse this candidate, add it to the finder's refusal memory, and leave the course without an official page until a better page is found. It never means linking anything.

| Hold reason (exact wording starts "The page found automatically was not linked: …") | Items | Providers | Hold an official page | Older than 7 days |
|---|---|---|---|---|
| **A. Another course's page**: "the page address is another course's at this provider" | 360 | 59 | 3 | 343 |
| A. "the page address or title shows another course's code" | 7 | 4 | 1 | 6 |
| A. "the page is another programme's page (a sibling award, a double degree …)" | 10 | 7 | 0 | 10 |
| **B. Another qualification level**: "the page is for another qualification level (DIP, ADV, M, GD, GC, B, C3, D …)" | 253 | 105 | 19 | 227 |
| **C. Another version of the award**: "the page is for another version of the award (honours, advanced, professional, research)" | 91 | 44 | 4 | 86 |
| **D. Older handbook year**: "the page is the [year] handbook entry, older than the handbook years …" or "… this course already has a [newer] entry" or "another award or an older handbook year" | 101 | 44 | 4 | 100 |
| **E. Another campus**: "the page is for another campus" (25 are Durham College) | 37 | 5 | 2 | 6 |
| **Total** | **859** | | 33 | 778 |

3 of the 859 are on retired courses and are settled by §3.1, which leaves 856.

**Options for the single decision:**

1. **Close all of A to E as "candidate refused"** (856 items). This is the recommended option: each item already carries the negative evidence.
   - Built as a new machine rule in its own migration.
   - Runs in shadow first, recording "would close". A separate switch activates it.
   - The 5% audit sample of what it closes goes to a person.
2. **Close A, C, D and E only (603)** and leave B (253 other-level items) for the grid. This is the option if a level mismatch is sometimes a stored-level error rather than a wrong page.
3. **No rule.** All 856 go to the Phase 5 grid's `Official URLs` view, grouped by provider.

### 3.3 The remaining backlog: which buckets a rule can clear and which wait for the Phase 5 grid

| Bucket | Items | How it clears | Waits for |
|---|---|---|---|
| Retired courses (`official_course_url`) | 36 | §3.1 rule | Done |
| Candidate proved wrong (`official_course_url`, A–E) | 856 | §3.2 rule, shadow first | Platform Admin decision |
| Not linked: the address and title do not name the programme | 476 | Person, one decision per provider pattern | Phase 5 grid, `Official URLs` view |
| Not linked: the page is shared, a list, a fee or an application page | 420 | Person, one decision per provider pattern | Phase 5 grid, `Official URLs` view |
| A CRICOS-coded page is at a different address | 204 | Person; the CRICOS proof is strong, but the official URL identity rule keeps it human | Phase 5 grid |
| The page we show carries an old year (archived handbook) | 188 | A newer-year re-read could settle most of them, but official URLs are never read again (15 Nov rule) | Phase 5 grid, or a rule change |
| Other official URL reasons | 16 | Person | Phase 5 grid |
| `course_entry_first_read`: quote_not_on_page | 1,604 | A corrected read (AER v2 prompt v3), once a model qualifies | AER session |
| `course_entry_first_read`: 5% audit sample | 488 | **Always a person** | Phase 5 grid, `AER Audit Samples` view |
| `course_entry_first_read`: shared page, low confidence, no bound page, score without basis | 310 | Re-read or rebind | AER session |
| `course_entry_first_read`: all rows held, other | 176 | Person | Phase 5 grid |
| `entry_matrix_first_run` and `entry_matrix_change` | 83 | Drain supersedes 8 when newer reads land; the rest need a person | AER session, then the grid |
| `provider_current_tuition_validation` | 146 | The drain already re-reads 100. The rest (outside range 73, title differs 33, match not sure 32, per-year unclear 8) need a person | Grid, `Provider Blockers` |
| `provider_description` | 88 | Machine text refused 46; first sentence 28; other validation 14. A person, one per provider | Grid, `Provider Blockers` |
| `no_page_first_run` | 55 | One approved sample per provider; the 60% trust rule then records later cases | Grid (one decision per provider) |
| `course_description_first_read` (evidence_moved) | 15 | Clears itself: the field gap queue re-reads them and the new reading supersedes them | None |
| `provider_current_tuition`, `conjoint_rule_first_run`, `course_english` | 11 | Person | Grid |

Total after §3.1: 5,136. Clearable without a person once decided and in shadow: 856 (§3.2) plus 15 (self-clearing). A further 1,914 depend on the AER session's corrected reads. Must stay human: the 488 audit sample. The rest is grid work, grouped by provider.

### 3.4 AER-owned queues (handed to the AER session; not changed here)

- The latest machine admission row gives the reasons: quote_not_on_page 1,604; audit_sample 488; the stored page also belongs to other programmes 176; all_rows_held 102; low_confidence 72; no bound page 37; score_without_basis 25; other 74.
- AER v1 is frozen (Decision 276). The corrected read is AER v2 prompt v3, which needs a qualified model (§4).
- **No gold exists for the held cases.** Among decided `course_entry_first_read` items, none was a quote_not_on_page decision. The benchmark therefore used the frozen person-labelled set, with the verifier's quote-on-page rate standing in for "would this held read pass".

## 4. Model benchmark (AER v2 prompt `aer-v2-course-v3`, frozen 50-case set 5)

**Setup.**
- Pilot #1176 (`20261116100000`) added a Gemini 2.5 Flash prompt row identical to the others (same system text and sha). It opened candidate runs 17 (Gemini 2.5 Flash), 18 (MiMo v2.6 Flash), 19 (Mistral Small 3.2) and 20 (Qwen3 30B, the round 1 reference).
- Each model is pinned with provider routing and fallbacks off. No `auto` routing.
- The answers were recorded by the `coverage-sweep` worker in `aer_v3_eval` mode, with the eval switches on for the run only, and scored with `security.ai_eval_score_v1`.
- Writes went only to the eval tables. No catalogue row was read for writing or changed. Gemini 3 Flash is not in `pipeline.ai_model_catalogue`, so it was not run.

**10 of the 50 cases are pages longer than `reading.aer_v2_page_chars` (60,000).** They fail `page_too_long` on every model, and they are the same 10 cases for all four. Round 1 (14 Nov, runs 6 to 8) ran with the limit raised for the test, so round 2 is not directly comparable. The 40-case columns compare the models on what every model could read.

| Model (pinned) | Right, 50 | Right, 40 | Valid first answer, 40 | Quote on page (of valid) | Errors on the 40 | Source integrity | False positives | Wall time p50 / p95 | Cost | Cost per valid answer | Cost per right answer |
|---|---|---|---|---|---|---|---|---|---|---|---|
| `google/gemini-2.5-flash` (Vertex, AI Studio) | 11 (22%) | 11 (27.5%) | 37 (92.5%) | 21 (57%) | 3 output truncated | 66.7% | 6 pts | **5.5 s / 26 s** | $0.348 | $0.0094 | $0.0317 |
| `xiaomi/mimo-v2.6-flash` | 11 (22%) | 11 (27.5%) | 35 (87.5%) | 15 (43%) | 4 timeouts, 1 truncated | 50% | 6 pts | 19.9 s / 85 s | $0.058 | $0.0017 | $0.0053 |
| `mistralai/mistral-small-3.2-24b-instruct` | 10 (20%) | 10 (25%) | 35 (87.5%) | 16 (46%) | 5 timeouts | **83.3%** | **2 pts** | 13.1 s / 57 s | **$0.032** | **$0.0009** | **$0.0032** |
| `qwen/qwen3-30b-a3b-instruct-2507` | 2 (4%) | 2 (5%) | 22 (55%) | 7 (32%) | 18 timeouts | 100% (2 right) | 0 pts | 33.0 s / 72 s | $0.021 | $0.0009 | $0.0104 |

Round 1 for reference (set 5, longer pages allowed): MiMo 30%, Mistral 30%, Qwen 2%.

**Qualification verdict:** no model passes.
- The framework's gate requires 100% source integrity (`ai_eval.min_source_integrity_pct`) with no fall in accuracy against the baseline. Only Qwen has 100% integrity, and that is on 2 right answers.
- A pass would not switch anything on by itself in any case.

**Recommended pins:**
- **AER v2 primary candidate: Mistral Small 3.2.** It has the best source integrity and fewest false positives of the models that answer. Its cost per right answer is lowest, and its accuracy is within one case of the leaders.
- **Second candidate, for the quality ceiling: Gemini 2.5 Flash.** It is the fastest and has the most valid first answers, at about 10 times Mistral's cost per right answer.
- **Retire from the AER path: Qwen3 30B.** 18 of 40 answers timed out within the worker's time and 45% of answers were invalid. Keep its prompt row for history only.
- **MiMo v2.6 Flash:** ties on right answers, but has the weakest source integrity (50%) and the slowest p95. It stays "not qualified".
- **Next step:** round 3 must fix the long-page problem before more models are tried (§5, lessons 1 and 2). Accuracy below 30% means prompt v3 itself needs work on strata T1 to T3 (no model scored on T1 or T2).

**Spend and credit.**
- Answers in round 2 cost US$0.459. AER v3 spend over all time is about $0.64 of the $2 cap (`ai_eval.aer_v3_max_usd`).
- On-demand `ca8dee01`: estimate $0.60, 0 Firecrawl. Closed 16:02 AEDT.
- OpenRouter balance went from $18.60 to $17.98. That drop covers all lanes, including the course description re-reads running at the same time.
- Both switches, `ai_eval.offline_runs_on` and `ai_eval.aer_v3_runs_on`, were restored to 0 at 16:03 AEDT, with a reason.

## 5. Lessons learned (for any agent starting from this repository)

1. **Freeze the reading settings with the benchmark set.** Round 1 raised `reading.aer_v2_page_chars` for the test; round 2 ran at 60,000 and lost the same 10 cases on every model. Record the page limit and max tokens in each run's metrics, and compare rounds only under the same limits. Long pages need splitting into sections in the reader, not a larger limit.
2. **The harness counts a timeout as a wrong answer and never retries it.** That measures "answers within the worker's time", which matches production, but it hides slow models' real accuracy. Read error counts beside accuracy.
3. **Layer 4 holds have no gold.** No decided quote_not_on_page case exists, so held items cannot be scored. The Phase 5 grid's `AER Audit Samples` view should collect about 30 person-decided quote_not_on_page cases for the next benchmark set.
4. **Check "ships off" switches first in any triage, then read back the first live run.** `layer4.reconcile_supersede_on` was ready but held off for 13 days. Once switched on, it still settled nothing, because the batch setting caps the items examined, not the items settled. A dry run with a large limit hid this. Dry-run with the job's own settings as well.
5. **Measure live.** The ~7,057 backlog figure came from the daily sheet; the live figure was 5,172.
6. **Do not claim what the platform's own rule does not.** The 29 "proposed equals stored" URL items look settled, but `security.layer4_resolution_v1` does not treat them as active, so they stay.
7. **Lease timing.** A partial worker call holds a 30-minute lease, so four models over 200 answers took about 75 minutes of wall time. Plan the run window around the leases.
8. **Only catalogue-allowed, individually pinned models.** No `auto` routing and no provider fallback across models, so each result is bound to one model.

## 6. Decision and follow-up (Platform Admin, Mon 16 Nov 2026 16:52)

**Asked:** pin Mistral Small 3.2, with MiMo v2.6 Flash as fallback, as the qualified AER route; drop Qwen3 30B; fix the 60,000-character truncation; clear the 2,090 held AER items.

**Raised before building:**
- No model passed the gate (§4). Mistral's source integrity is 83.3% (the gate needs 100%) and its error rate is 30 points (at most 10). MiMo's integrity is 50%.
- A fallback across models breaks the per-result binding (lesson 8).
- Qwen3 30B is the only qualified model on the two live AER v1 entry routes. Over 48 hours it gave 1,357 answers and 726 failed attempts on `course_entry_requirements`.
- 2,484 of the 2,578 pending `course_entry_first_read` items came from gpt-4.1-mini (29 Oct to 13 Nov), not Qwen. The 488 audit-sample items stay with a person by rule.
- Page length is not stored with the evidence, so the share of held items on long pages cannot be measured in SQL.

**Decision:** "Stop Qwen, shadow Mistral". In order:

| Step | Change | State |
|---|---|---|
| 1 | Pilot #1178, migration `20261116120000`:<br>• `course_entry_requirements` and `entry_matrices` switched off.<br>• Qwen3 30B unqualified on both and on the v2 shadow.<br>• `entry_requirements_v2_shadow` cascade = Mistral Small 3.2 alone (`pending`, provisional); route and `aer.v2_shadow_on` stay off.<br>• 7 log entries. | Merged 16 Nov 17:49 AEDT. Read back: all three routes held `off`; no entry-reading AI call since. Rolled-back dry run first; G3 unchanged. |
| 2 | Pilot #1179, worker v1.0.6 and migration `20261116130000`:<br>• A page over `reading.aer_v2_page_chars` sends only its entry requirement sections (`lean-sections-v3`), with the page's own block numbers, when `reading.aer_v2_long_page_sections_on` = 1.<br>• The answer is verified against the whole page. A page is never cut. | Merged 16 Nov 18:02 AEDT; worker v1.0.6 live from 18:05; the switch is 0. |
| 3 | Round 3 on the frozen set 5, under the same limits, with the long-page switch on: Mistral, MiMo, Gemini 2.5 Flash, each pinned. | **Done 17 Nov 07:45–09:07 AEDT** (Pilot #1191 and #1192; §6.1). |
| 4 | Only if Mistral passes the gate: the Platform Admin qualifies it, switches the shadow on, and the held items are re-read through the normal admission rule. | **Path B (17 Nov 09:15 AEDT):** Mistral failed the gate (§6.1). Nothing qualified or switched on; no re-reads; no further spend. |

AER v1 entry reading waits for a qualified model. The AER v1 prompt (`course-entry-v1`) has no benchmark with Mistral, so it cannot be qualified from round 2.

### 6.1 Round 3 results (Tue 17 Nov 2026)

**Setup.**
- Pilot #1191 (migration `20261117020000`) opened runs 24 (Gemini 2.5 Flash), 25 (MiMo v2.6 Flash) and 26 (Mistral Small 3.2). Each model was pinned without fallback.
- Same as round 2: the frozen set 5, prompt `aer-v2-course-v3` (same sha-256), `reading.aer_v2_page_chars` 60,000 and `reading.aer_v2_max_tokens` 12,000.
- New: `reading.aer_v2_long_page_sections_on` = 1, worker `coverage-sweep` v1.0.6.
- Rolled-back live dry runs passed with the consumer API check unchanged, for both #1191 and #1192.
- Answered 07:50–08:56 AEDT by seven worker calls. Partial calls hold a 30-minute lease (lesson 7).
- Scored by the `ai-eval` job; evidence was written to `pipeline.ai_route_qualifications` as `pending`.
- Pilot #1192 (migration `20261117030000`) restored the three switches to 0 at 08:58 and closed on-demand `349feb5b`.

| Model (pinned) | Right, 50 (round 2) | Right, 40 short pages (round 2) | Long pages: read / right, of 10 | Errors | Error rate | Source integrity | False positives | Cost | Cost per right answer |
|---|---|---|---|---|---|---|---|---|---|
| `mistralai/mistral-small-3.2-24b-instruct` | **13 (26%)** (10) | 11 (10) | 6 / 2 | 11 timeouts | **22 pts** (30) | **85.7%** (83.3%) | **1** (1) | $0.041 | $0.0032 |
| `google/gemini-2.5-flash` | 14 (28%) (11) | 11 (11) | 9 / 3 | 4 output truncated | 8 pts (26) | 75% (66.7%) | 2 (3) | $0.514 | $0.0367 |
| `xiaomi/mimo-v2.6-flash` | 12 (24%) (11) | 9 (11) | 7 / 3 | 10 timeouts, 1 truncated | 22 pts (30) | 50% (50%) | 3 (3) | $0.058 | $0.0049 |

**Gate on Mistral Small 3.2 (criteria recorded with the run).** Source integrity 100%, error rate at most 10 points, no false positives. **Failed on all three:** 85.7%, 22 points, 1 false positive. **Path B**, as pre-authorised on 16 Nov 20:14:
- AER live admission and the v2 shadow stay off.
- No model is qualified. No held item is re-read.
- No further spend.

**What the long-page switch did.**
- **Page too long:** no case is left with this error (10 per model in round 2).
- **Long pages:** answers on the 10 long pages had **100% source integrity and no false positives** on every model, and 2 to 3 of them were right.
- **Accuracy:** the round-3 gains come almost entirely from the long pages. On the 40 short pages, Mistral gained one right answer, Gemini was level and MiMo lost two.

**What blocks qualification now.**
1. **Timeouts at the 90-second call limit.** Mistral 11 (5 in round 2), 4 of them on long pages; MiMo 10. Every timeout counts as a failed answer.
2. **Quotes not found on the page.** All are on short pages: the long-page answers were 100% on the page. Mistral's source integrity is 85.7%.
3. **Missed rows (false negatives 24 to 30).** Accuracy stays under 30% on every model; prompt v3 still misses most printed rows.

**Recommendation (for the Platform Admin; nothing is changed).**
- Keep AER v1 and the v2 shadow off.
- Before another round: raise the per-call time limit for long section prompts, or split the 90-second limit, so slow answers are measured, not dropped.
- Revise prompt v3 for the rows it misses, using the person-decided cases the Phase 5 `AER Audit Samples` view collects (lesson 3).
- Re-run on set 5 under the same limits.

**Spend and credit.**
- Round 3 answers cost **$0.613**: Gemini $0.514, Mistral $0.041, MiMo $0.058.
- AER v3 spend over all time is **$1.238** of the $2 cap (`ai_eval.aer_v3_max_usd`).
- On-demand `349feb5b`: estimate $0.60, 0 Firecrawl.
- OpenRouter balance went from $14.49 to $13.84; that drop covers all lanes over the window.

## 7. Official URL resolution: all 856 items (Platform Admin 16 Nov 2026 16:47, 18:01 and 18:44 AEDT)

**Asked:** close the 856 wrong-candidate official URL items (report §3.2, option 1). Then resolve the 73 live-link conflicts and the 32 audit-sample items against stored page evidence: refuse a proven wrong proposal; close a proven valid live link without changing it; leave anything unproven open. Any deletion of a refusal record goes to a paste file.

### 7.1 Release

| | |
|---|---|
| Pilot #1177 | Merged 16 Nov 18:09 AEDT. **Not applied.** Its version `20261116110000` had been taken an hour earlier by #1162, so deploy on merge refused the file and ran nothing. |
| Pilot #1180 | The same migration renumbered to **`20261116143000`**. Rolled-back live dry run passed at 18:46 AEDT: the migration ran twice; 8 items closed and 32 marked, with 0 failures; consumer API check unchanged; drift `[]`; file md5 `d467a8517c4bd292eab1bd89fb8bb164`. Merged 18:47 AEDT; deploy succeeded. |
| Read back | Live history holds `20261116143000` with md5 `d467a8517c4bd292eab1bd89fb8bb164`. `security.layer4_reconcile_v1` body md5 is `641ff18954c6c5006b3f7dacca6cdf1e`. Settings: `layer4.reconcile_batch` 200, `layer4.reconcile_examine_max` 5000, `layer4.link_refusal_rule_on` 1, batch 200, time budget 7 s, audit 5%. |
| Reconcile fix | `p_limit` (`layer4.reconcile_batch`) now caps items **settled**. `layer4.reconcile_examine_max` caps items **checked**. `pipeline.layer4_reconcile_cursor` continues from where the last run stopped and wraps to the oldest, so no settleable item waits behind items for a person. In the dry run, one run checked 2,304 items. |
| Test register | **S2 - SS Build regenerates the test register** for #1176, #1177 and #1180 (spec `s560`). This session cannot: Playwright is not installed and package installs are off. |

### 7.2 Outcome by bucket

| Bucket | Items | Outcome | How |
|---|---|---|---|
| Rule `l4-link-refusal-v1`: negative evidence, refusal on record, page not the live link | 751 | **Closed** (rejected) | Runs 1 to 4, 168 + 200 + 200 + 183, 0 failures. "Refuse this proposal" under the system automation account. By group: A another course 332, B another level 238, C another award version 74, D older handbook 96, E another campus 11. |
| 5% audit sample of the rule, confirmed | 28 | **Closed** (rejected) | Run 5. Each stored page title and level was checked against the course record. Each decision's reason records the comparison, for example "stored page *advanced diploma of hospitality management* (ADV) against *Diploma of Hospitality Management* (DIP)". |
| 5% audit sample, not proven | 4 | **Open** | TAFE Queensland, AD Applied Technologies (Cyber Security): the page is the parent programme. UNSW, Diploma in Science and Technology: the page is the Diploma in Science. Deakin, Master of Construction Management: the page is the Professional version and names the course. Manitoba, MMus: the address says MMus, the title says research MA. |
| Live-link conflict, verified valid | 56 | **Closed** ("Keep the page we hold"); live link **not changed** | Run 6. The proposed page is already the course's active official page, and the stored check proves it. 26 "another campus" objections name the **provider itself** as the other campus (Durham College 16, University of Calgary 5, The University of Melbourne 4, UNE 1): a finder defect. 30 "another course's address" objections where the page title names this exact course (ACU double degrees 21, Wollongong 6, Durham Dental Assisting, Melbourne MA, Newcastle Electrical Engineering). Read back: 0 links and 0 course records changed; 57 live links still active. |
| Live-link conflict, refused | 1 | **Closed** (refused); listed for unlink review | Lead College, Graduate Diploma of Management (Learning), CRICOS 107328J. **The evidence conflicts:** the live address `leadcollege.edu.au/courses/graduate-diploma-of-management-learning/` names the course, but the stored copy of that address is titled "Advanced Diploma of Leadership and Management". The page may redirect to another course, or the stored title may be wrong. Recommendation: **keep the link** until someone opens the page. |
| Live-link conflict, not proven | 16 | **Open** | ACU BA/B Global Studies and Psych Sci/BA (address only, no stored title); Lead College Cert III in Pathology (page is "Pathology Collection"); Wollongong IT/Laws; version cases: Curtin 2 (honours), Flinders 4 (generic PhD and EdD research pages), Monash 2 (honours page for an Advanced course), RMIT 1 (a PDF), TAFE SA 1 (Advanced Networking), Wollongong 2 (graduate entry, fast track). |
| **Total** | **856** | **836 closed, 20 open** | |

### 7.3 For the Platform Admin

1. **Paste file `docs/paste/PASTE-20261116-l4-lift-false-link-refusals.sql`** (md5 `1ac93dd83ccb7f872bc947f4fa19aec1`).
   - It deletes the finder's 59 false refusals (56 courses; 3 Wollongong pages are stored with and without a trailing slash) of live pages verified valid.
   - It stops, changing nothing, unless exactly 59 `binding_check` rows match. Checked read-only at 19:30 AEDT: 59 match.
   - Until it is run, the finder treats each of these live pages as refused for its course.
2. **Unlink review list:** 1 course, Lead College 107328J (above). Recommendation: keep.
3. **Finder defects to fix in the course-link finder:**
   - **Campus check names the provider itself as "another campus".** 26 false conflicts, and the likely source of more.
   - **The "another course's address" check misreads double-degree and Dean's Scholar addresses** as the single degree's.
4. **20 open items** stay in the Inbox for the Phase 5 grid (`Official URLs` view).

### 7.4 Layer 4 counts (read back)

| Time (AEDT) | Waiting | `official_course_url` |
|---|---|---|
| 14:20 | 5,172 | 2,196 |
| 16:28 (36 retired settled) | 5,136 | 2,160 |
| 18:48 (before the rule; new items had arrived from other work) | 5,787 | — |
| 19:00 (751 closed by rule) | 5,036 | 1,409 |
| 19:20 (28 audit and 57 live-link closed) | **4,916** | **1,328** |

The ~4,280 target assumed no new arrivals. 651 items arrived from other work between 16:28 and 18:48.
