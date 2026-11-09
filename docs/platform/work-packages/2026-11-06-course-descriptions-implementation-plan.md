# Course descriptions: implementation plan (one bounded PR, after #877)

**Agent G (planning and validation only), 6 Nov 2026 08:24–09:12 AEDT.** Platform Admin direction 6 Nov 2026 08:12: "continue safe parallel planning and independent validation for course descriptions and English requirements without modifying shared reader functions currently owned by #877."

- No PR was opened. No migration, edge function or shared reader file was changed.
- Production was read with SELECT only:
  - catalogue reads outside :35–:42 and :47–:48;
  - the bounded measurement at 08:56 AEDT 6 Nov 2026.
- Builds on: the discovery (`2026-11-06-course-descriptions-discovery.md`, agent F) and PR #877 (`codex/provider-description-autonomy`, head `cf3f245b`, agent B).
- Pilot branch with the fixture and baseline test only: `cf247-course-descriptions-complete`, head `96f48a4a` (pushed, no PR).
- English requirements (also named in the 08:12 direction) is a separate workstream with its own discovery and range. It is not covered here.

## 1. Summary

The reader exists, runs and costs little. Nothing reaches the website for three reasons:

1. **D5 holds every description in Layer 4.** `enrich.course_description_review_first` = 100,000, and none of the 857 waiting items has ever been decided.
2. **The checks hold 53% of AI readings (1,642 of 3,083).** Half of those holds are a length or sentence-count overshoot (839). Another 486 are `unsupported_claim`, and **483 of those are the single word "students"** from the shared provider claim list, used where the page says "you".
3. **Held reasons are not visible on the screens operators use.**

The PR is one bounded change in four parts, with no new reader, job, screen or consumer change:

| Part | What | Waits for #877? |
|---|---|---|
| A. Database | A course-only claim-word list (`enrich.course_description_claim_words`), seeded identical to today's `pdesc.claim_words`, read by `course_description_check_v1`. A re-ask setting. A held-reasons read for the existing Enrich fields screen. | **No.** It can be written and tested now. Release after #877, with the md5s re-read then. |
| B. Worker | `course-text.ts` and the `enrich_ai` block of `coverage-sweep/index.ts`: re-ask once when the answer breaks only the length or sentence limits. The second answer is checked again in full. Nothing is cut. | **Yes.** `index.ts` and `description.ts` belong to #877. |
| C. Admin UI | The Layer 4 Course description card shows its check results (sentences, characters, limits). Enrich fields shows the held-reason breakdown for description. | `Layer4Inbox.jsx`: **yes** (#877 edits it). `EnrichFields.jsx`: no. |
| D. Decisions | The D5 trust-policy pack (§8), the limits and the claim list. | Platform Admin |

## 2. Live state verified (6 Nov 2026, read only)

### 2.1 Function definitions

Light catalogue reads at 08:25–08:29 and 08:43 AEDT. All match the discovery report of 5 Nov 19:51.

| Object | Live md5 | Touched by #877? | This PR |
|---|---|---|---|
| `security.course_description_check_v1(uuid,jsonb)` | `ff3d6dd7b0f88c85b1fdff6c8a8cd86b` | No (#877 states it leaves it and `pdesc.claim_words` alone) | **Replace** (md5 guard) |
| `security.enrich_course_text_record_v1(bigint,jsonb)` | `b47c00b19bc6eaa36828dbe4d2371501` | No | Unchanged (the re-ask detail rides in `value`, which it already stores) |
| `security.course_description_trusted_v1(uuid)` | `3f056fa4495963ec1d3bca61bfe0642d` | No | Unchanged |
| `security.layer4_course_description_apply_v1(uuid,uuid,jsonb,text)` | `ba97236f3010e248bac44a0a7c09611a` | No | Unchanged |
| `security.course_description_release_held_v1(uuid)` | `dd4b178afcd26b696d70710038e34f1c` | No | Unchanged (it re-runs the check, so it picks up the new list) |
| `security.course_description_review_trg_v1()` | `d143eba24f5896f36a3a93e8e5c075aa` | No | Unchanged |
| `security.enrich_course_text_gaps_v1(text[])` | `a6d0da8f6d6fd7d31c6c39c707e2d824` | No | Unchanged |
| `security.enrich_fields_v1()` | `80ee183b324c196b4c9559cec6e3360f` | No | Unchanged |
| `security.field_gap_queue_tick_v1()` / `_run_v1()` | `9bb80b419ee26a049b99a35fb278e272` / `429835d4d27375da95901104838a0cad` | No | Unchanged |
| `security.layer4_review_decide_impl(uuid,text,text,jsonb)` | `55353f1903c97b268255c8c1e4f5ca6f` | No | Unchanged |
| `security.pdesc_has_term_v1` / `pdesc_support_v1` / `pdesc_similarity_v1` / `pdesc_words_v1` | `b2b8d649…` / `adedab4f…` / `357a9ebf…` / `1a18bd60…` | No (#877 adds `pdesc_claim_check_v1` and `pdesc_present_support_v1` beside them) | Unchanged (shared helpers) |
| `public.admin_enrich_fields(text,jsonb)` | `476062fa6437a4266ab6716fad0021c4` | No | **Replace** (md5 guard): read action `held_reasons` |
| `public.svc_worker_settings_v1()` | `5ef1c297c311ea346d95d04b2d430c34` | No | Unchanged: it already returns every `pipeline` `enrich.%` key |
| `public.website_v2_course(text)` / `(text,text)` | `50d22c3ccfc2a00bedb5c9cee762eec4` / `1c10b34fc4ea57398638d26ac9e21279` | No | **Read only** (G3). The 2-argument form calls the 1-argument form, which reads `catalogue.courses.description`. |

### 2.2 Worker source

| File | State |
|---|---|
| `coverage-sweep/course-text.ts` (main) | 124 lines; `COURSE_TEXT_PROMPT_VERSION = "course-text-v1"` |
| `coverage-sweep/index.ts` | `textRead` at about line 2605 on main (about 2636 on #877); worker `coverage-sweep-worker-v0.59.8` |
| `description.ts`: `descriptionSentences` and `descriptionPageText` | Byte-identical on main and on #877 (body md5 `8617d434…` and `c8307790…`). #877 only adds `providerDescriptionSentences`, `descriptionClaimCheck`, `descriptionSourceIdentity` and `descriptionCostQuote`. |

## 3. How this builds on #877 (no conflict)

| #877 does | Effect on course descriptions | This plan |
|---|---|---|
| Adds `pdesc.evidence_claim_words` (campus, scholarship, guarantee), read only by `provider_description_validate_v1` through `pdesc_claim_check_v1`. Its comment says: "pdesc.claim_words is NOT changed … course descriptions keep their own behaviour." | None today | Takes the next step: courses get their own list, so the two lists can evolve apart. |
| `provider_description_signature_v1` hashes `pdesc.claim_words` and `pdesc.superlatives` into every provider cohort signature | Any edit to the shared list for course reasons would invalidate provider cohorts | Course work never edits `pdesc.*` again. |
| Edits `description.ts`, `index.ts`, `Layer4Inbox.jsx`, `FieldCoverage.jsx`; migration `20261106200000` | `course-text.ts` imports `description.ts`. The `textRead` block sits in `index.ts`. | Parts B and C1 start from #877's merged head. Nothing in `FieldCoverage.jsx` is needed: held reasons go on the Enrich fields screen instead. |
| Leaves `descriptionSentences`, the course check and the shared pdesc helpers untouched | — | The baseline (§11) pins today's behaviour, so a later accidental change is caught. |

## 4. Part A: database (migration `20261106500000_cf247_course_descriptions_complete.sql`)

The migration is in range `20261106500000`–`20261106549999`. It can be written now, against the fixture in §11. It is released after #877, and every guard is re-read immediately before release.

```
-- Replaces: security.course_description_check_v1 (reads enrich.course_description_claim_words instead of the shared pdesc.claim_words);
--           public.admin_enrich_fields (adds the read action held_reasons)
-- Retires: the course-description use of pdesc.claim_words (the setting itself stays for provider descriptions); nothing dropped
```

1. **Setting `enrich.course_description_claim_words`** (list, words; section "Course description and deadline"; `used_by` `security.course_description_check_v1`).
   - Seeded by `insert … select value from pipeline.platform_toolset_settings where key = 'pdesc.claim_words'`, so it is identical on the day of release whatever the value is then.
   - `on conflict do nothing`.
   - Same update: `pdesc.claim_words.used_by` loses "course_description_check_v1". This is a metadata-only change, made with a reason.
2. **Setting `enrich.course_description_reask_max`** (number, 0–2, unit "re-asks", `used_by` "worker coverage-sweep enrich_ai (course-text.ts)").
   - **Ships at 0.** The re-ask changes behaviour and adds spend, so the Platform Admin switches it to 1 on Settings › Pipeline settings, with a reason, as the release acceptance step.
   - CLAUDE.md: "a passing qualification never switches anything on by itself."
3. **`security.course_description_check_v1`.**
   - Guard: abort unless the live md5 is `ff3d6dd7b0f88c85b1fdff6c8a8cd86b`, or the after-md5 is already in place (re-run safe).
   - One line changes:
     - before: `toolset_setting('pipeline','pdesc.claim_words')`
     - after: `coalesce(toolset_setting('pipeline','enrich.course_description_claim_words'), toolset_setting('pipeline','pdesc.claim_words'))`
   - Nothing else changes: the order of rules, the messages and the return shape stay as they are.
   - The baseline's 16 cases plus the real held readings must give identical outcomes before and after (§11).
4. **`public.admin_enrich_fields`.**
   - Guard on the live md5. Adds one read action, `held_reasons`, for field `description` and a country. For a held reading, it returns per day:
     - rule;
     - count;
     - for `length`, a character band;
     - for `unsupported_claim`, the word.
   - Rank-gated like the existing reads. No new table and no job, so G1 is untouched. Bounded by a setting, `enrich.course_description_held_days` (1–30 days, default 7).
5. **If D-5 is approved: `enrich.course_description_marketing_words`.**
   - Seeded from `pdesc.superlatives` in the same way.
   - Read through `coalesce(…)` on the `unsupported_marketing` line of the same function.
   - One more changed line. The same baseline proves no outcome changes.
6. No `comment on table` is needed: the new settings are rows, and there is no new table.
7. `pipeline.component_register`: the course use of `pdesc.claim_words` is marked `retiring`, `replaced_by` `enrich.course_description_claim_words`.

Not in this PR:

- `enrich_course_text_record_v1` does not change.
- The 180 "no answer could be recorded after 3 tries" failures were all on 3 Nov, with none since. That is not enough to justify editing the record function.
- The failure detail is noted under Risks.

## 5. Part B: worker (waits for #877)

### 5.1 `course-text.ts` (new exports, with tests in s233 or the new spec)

1. `courseTextBreach(a, page, length, minQuote)`.
   - It counts sentences and characters exactly as the database does:
     - sentences = the `descriptionSentences` output;
     - characters = `length(string_agg(btrim(text), ' '))`.
   - It returns `null`, or `{ rule: 'sentence_count' | 'length', sentences, chars }`. A reading below the minimum is never re-asked.
2. `courseTextReaskUser(provider, title, page, prev, breach, length)`. It asks for the description only, with:
   - the previous sentences;
   - the measured count and length;
   - the limits.

   The instruction says: "Rewrite as at most N sentences and at most C characters, using only facts in the page; every sentence keeps an exact quote." It never asks the model to shorten by cutting, and the worker never cuts.
3. `COURSE_TEXT_PROMPT_VERSION` becomes `course-text-v2`.

### 5.2 `index.ts` `textRead`

- **When.** After the first answer, if `want` includes `description`, `courseTextBreach(…)` is not null, and `wsNum('enrich.course_description_reask_max', 0) > 0`: make at most that many further calls.
- **Each call:**
  - same pinned model;
  - same stored page;
  - same answer-token setting;
  - `want = ['description']`;
  - the cost added to the item;
  - the deadline taken from the first answer.
- **What is stored.** The answer recorded is the last one. `value.reask` = `{ n, first: { rule, sentences, chars } }`. `record_v1` stores `value` as given.
- **No truncation anywhere.** A second answer that still breaks a limit is held exactly as today (`held: length` or `held: sentence_count`), with `reask` showing it was tried.
- **Spend** stays under the existing `guard_enrich_fields` AI guard and daily caps. No new budget.
- **Worker version:** `coverage-sweep-worker-v0.60.0`.

### 5.3 Why the worker re-asks before recording (not after a database hold)

The worker already has the limits through `courseTextLength(ws)`. It can measure the breach with the same arithmetic as the database. One record call per item keeps `field_enrich_items` single-state and needs no new lease or retry state.

The cost of this choice: a reading that breaks the length limit and also, say, a claim word is re-asked and still held. The measured share is in §9. A `sentence_count` hold has had no per-sentence check yet (the check stops at the first rule).

## 6. Part C: Admin UI (existing screens only)

1. **Layer 4 › Course description card** (`src/Layer4Inbox.jsx`; waits for #877).
   - The card already shows each sentence with its quote. It gains one line from `proposed_value.checks`, already stored: "N sentences, C characters (limits 1–4, 80–700)". When `value.reask` is present, it also says "rewritten once to fit the limits".
   - It is an s121 phone screen. The PR runs `s121` and adds an `@responsive` assertion that the line wraps at phone width.
2. **Enrich fields › description row** (`src/EnrichFields.jsx`; not touched by #877, so it can be prepared now).
   - A "Held, by reason" breakdown from `admin_enrich_fields('held_reasons')`. Example: "too long 476 · too many sentences 360 · claim word not in quote 484".
   - Each reason links to the existing items list, filtered.
3. Not changed:
   - no new dashboard;
   - no `FieldCoverage.jsx` change (avoids #877);
   - no `mature-main.jsx` (agent C);
   - no `nav-map.js`.

## 7. Settings (G2)

| Key | Kind | Range | Unit | Default at release | `used_by` | New? |
|---|---|---|---|---|---|---|
| `enrich.course_description_claim_words` | list | — | words | = `pdesc.claim_words` at release | `security.course_description_check_v1` | New |
| `enrich.course_description_marketing_words` (only if D-5) | list | — | words | = `pdesc.superlatives` at release | `security.course_description_check_v1` | New |
| `enrich.course_description_reask_max` | number | 0–2 | re-asks | **0** (Platform Admin sets 1) | worker coverage-sweep enrich_ai (course-text.ts) | New |
| `enrich.course_description_held_days` | number | 1–30 | days | 7 | `public.admin_enrich_fields` (held_reasons) | New |
| `enrich.course_description_max_chars` / `max_sentences` | number | 200–4000 / 1–12 | characters / sentences | 700 / 4 (unchanged unless decision D-3) | check; worker | Existing |
| `enrich.course_description_review_first` | number | 1–100000 | descriptions | 100000 (unchanged unless decision D-1) | trusted_v1, record_v1 | Existing |
| `pdesc.claim_words` | list | — | words | unchanged | `used_by` drops the course check | Existing |

No operational number is written in code. The worker reads every key through `svc_worker_settings_v1`, which already returns `enrich.%`.

## 8. Layer 4 interaction and the D5 trust-policy decision pack

### 8.1 How Layer 4 works today (verified in the live definitions)

1. A reading that passes every check goes to Layer 4 (`course_description_first_read`), at most `pending_max` = 10 per provider.
   - Readings beyond that are `held_first_admission`, with the reading and its check kept.
2. Approve:
   - `layer4_course_description_apply_v1` writes `catalogue.courses.description`. This happens only if the value is still the one shown, there is no hand lock, and the description is not edited ("approve as read, or reject").
   - The trigger marks the item `filled` and calls `course_description_release_held_v1`.
3. Release:
   - only when `course_description_trusted_v1` is true, that is, the provider's latest N decisions are all approvals;
   - every held reading is checked again before admission;
   - a held value or a hand lock is never overwritten.
4. With N = 100,000, no provider can become trusted. Approving items one by one is the only path to the website.

### 8.2 Measured evidence (08:56 AEDT 6 Nov 2026)

All since release (3 Nov 2026). The source is `pipeline.field_enrich_items`, field `description`, plus Layer 4. Measured at 08:56 AEDT on 6 Nov, read only.

**Readings and Layer 4**

| Measure | Value |
|---|---|
| AI readings recorded with a check | 3,083 (2,806 on 3 Nov, then about 500 a day) |
| Passed every check | **1,379 (44.7%)**: 857 in Layer 4 and 522 `held_first_admission` (the provider already has 10 waiting) |
| Held by a check | **1,642 (53.3%)**, listed in the next table |
| Not about the course | 60 |
| Layer 4 `course_description_first_read` | **857 pending, 340 providers, 0 ever decided**: AU 487 (270 providers), NZ 305 (46), CA 65 (24). Oldest 3 Nov 13:46, newest 6 Nov 08:46 AEDT. |
| Descriptions shown by the website | AU 163 of 25,380 active courses; NZ 0 of 6,495; CA 0 of 3,815 (`enrich_coverage_snapshots`, 6 Nov 08:07). All 163 are older adapter values. |
| AI cost | US$3.32 in total; US$0.0011 a reading; US$0.0024 a passing reading |
| Failed ("no answer could be recorded after 3 tries") | 180, all on 3 Nov; none since |

**Held by a check**

| Rule | Held | Detail |
|---|---|---|
| `unsupported_claim` | 486 | The word **"students" accounts for 483**. Other words: facilities 3, employment 2, and 1 each for award, awards, employed, employers, accreditation, employability and state-of-the-art. 478 (98%) involve only people words. |
| `length` | 478 | 701–800 characters: 299 (63%); 801–900: 109; 901–1,000: 45; over 1,000: 25; under 80: 0. All of them passed every per-sentence check, because length is checked last. |
| `sentence_count` | 361 | 5 sentences: 193; 6: 86; 7 or more: 82. 309 (86%) would pass every per-sentence check; 95 of those are also within 700 characters. 20 fail only on a claim word. |
| `quote_not_on_page` | 192 | |
| `unsupported_sentence` | 108 | |
| `duplicate_other_course` | 10 | |
| `incomplete_sentence` | 7 | |

What-if on the fixture (§11), nothing changed in production: with "students" removed from the claim list, the three real `unsupported_claim` readings fall to their next rule (`quote_not_on_page` once, `length` twice). They do not pass. The claim-list split and the re-ask work together; neither alone admits these readings.

### 8.3 Options

| Option | Rule | What reaches the website | Reviewer load | Risk |
|---|---|---|---|---|
| **O1. Keep the hold** (today) | `review_first` = 100,000 | Only what a person approves, one at a time | 857 now, growing by up to 10 per provider | None to quality. The capability publishes almost nothing. |
| **O2. Per-provider trust after N approvals** (as built; built default 5) | `review_first` = N (3 or 5) | After a provider's latest N decisions are all approvals: its held and later readings that pass every check. Any rejection returns the provider to Layer 4. | N × providers decisions (3 × 340 ≈ 1,020; 5 × 340 ≈ 1,700) | A provider whose first N happen to be good. Bounded by the checks and the automatic return on rejection. |
| **O3. Sample-gated O2** (recommended) | A person decides the sample of 50 in §8.4. If at most 1 is rejected for a content reason, set `review_first` = 3. Otherwise keep O1 and fix the cause first. | As O2, once the sample passes | 50 decisions now, then as O2 with N = 3 | The sample is the evidence D5 asks for. |

### 8.4 The sample of 50

Ten providers, five items each, drawn from the pending queue:

- spread across AU and NZ, roughly in proportion to the queue;
- spread across description length (under 300, 300–500, over 500 characters).

The selection query is read-only and deterministic. It is in Appendix A.

**Why 50.** With 0 rejections in 50, the 95% upper bound on the rejection rate is 5.8%. With 1 rejection, it is 9.3% (exact Clopper-Pearson). Ten items would only bound it at 26%.

**Who decides.** The decisions are a person's, in Layer 4. No agent decides an item.

**What the measure does not cover.** The sample measures what the checks let through, not the held readings.

**What to record per item:**

- approve, or reject, and the reason class:
  - wrong course;
  - not supported by the page;
  - marketing;
  - fragment;
  - other;
- the time taken.

### 8.5 What is not an option

- Admitting without Layer 4 on the strength of the checks alone, before any human evidence. D5 rules it out.
- Editing a description in Layer 4. Not allowed: an edited sentence has no quote.

## 9. Re-ask once (length and sentence limits; no truncation)

| Rule | Detail |
|---|---|
| Trigger | Only `sentence_count` or `length` above the maximum, measured by the worker as the database measures it. Below the minimum, or any other rule: no re-ask. |
| Calls | At most `enrich.course_description_reask_max` (0 at release; 1 once switched on) extra calls per item. Same pinned model and page, description only. |
| Result | The last answer is recorded and checked in full by the unchanged rules. If it still breaks a limit, it is held whole, as today. |
| Never | The worker or the database cuts, joins or completes a sentence; the limits are relaxed silently; the deadline is re-read. |
| Measured upper bound | Of 361 sentence-count holds, 309 (86%) would pass every other check (if rewritten within the limits); 20 fail only on a claim word. All 478 length holds already passed every per-sentence check (length is checked last); 299 (63%) are 701–800 characters. |
| Cost | About US$0.0011 per extra call, for at most about 950 (27% of about 500 a day) readings a week at today's rate. Within the existing AI guard. |

## 10. Consumer publication verification (G3: read only)

- No consumer object changes. `website_v2_course(text)` already returns `'description', (select c.description from catalogue.courses c where c.id = v_id)`. Search items do not carry the description.
- An `@deployed` read-only spec (not `@live-acting`):
  1. Takes the most recent course whose description came from this reader. That is a `field_enrich_items` row in state `filled` for field `description`, read through the existing read-only admin path.
  2. Calls the existing `website-api-v2` course detail for its identifier.
  3. Asserts that `description` equals `catalogue.courses.description`, byte for byte.
  4. Skips only for a missing environment (G4), never for "nothing admitted yet". Until the first admission, it asserts the 163 existing values are returned unchanged for one sampled course.
- `s57` (consumer API frozen) runs unchanged and must pass. No rebaseline.

## 11. Production-parity fixture and baseline (built now)

Pilot branch `cf247-course-descriptions-complete`, folder `tests/fixtures/course-description-parity/`:

| File | What |
|---|---|
| `manifest.json` | Captured from production with `scripts/prod-parity-capture.mjs`, read only, 6 Nov 08:29 AEDT. `save` verified every definition against its md5. |
| `settings.sql` | The 14 live settings the course path reads, verbatim from 08:27 (no actor columns) |
| `baseline.sql` | 16 representative cases plus trust and claim-list assertions |
| `held-real.sql` | 9 real held readings from production (public course-page text, no user data). Each must still get the rule production recorded. |
| `run.sh` | Builds the fixture, requires zero differences from the manifest and the six live md5s, seeds the settings, runs both baselines |
| `tests/uat/cf-247-s355-course-description-baseline-contract.spec.mjs` | Source contract (`// Guards:` line) |
| `.github/workflows/course-descriptions-test.yml` | Runs `run.sh` on PostgreSQL 17.6 (new file; no existing workflow edited) |

What the manifest holds:

- **Tables:** `catalogue.courses`, `pipeline.field_enrich_items`, `pipeline.layer4_review_items` and `pipeline.platform_toolset_settings`, each with columns, check, foreign-key and unique constraints, indexes, triggers, RLS and grants.
- **Referenced tables, keys only:** `catalogue.providers`, `pim.entity_registry`, `pipeline.admin_jobs`, `pipeline.evidence_artifacts`, `pipeline.layer3_interpretations`, `pipeline.platform_toolsets`, `ref.study_levels` and `ref.fields_of_study`.
- **28 functions:**
  - the six course-description functions;
  - the four shared pdesc helpers;
  - `pipeline_num_v1`, `toolset_setting` and `course_title_key`;
  - the 14 trigger functions;
  - `ops_remedy_guard_active_v1`.

What the baseline pins (today's behaviour, the regression base):

- **The check reports only the first rule broken**, in this order:
  1. not_stated;
  2. sentence_count;
  3. per sentence: quote_not_on_page, unsupported_marketing, unsupported_claim, incomplete_sentence, unsupported_sentence;
  4. length;
  5. duplicate_other_course.
- So **a length hold has passed every sentence check, and a sentence-count hold has had none run** (cases 4 and 6).
- **"Students …" phrased by the page as "You will …" is held as an unsupported claim** (case 7). The same sentence with "Students" in its quote passes (case 8).
- **Nothing is cut:** no held case returns text.
- **No provider is trusted under the D5 hold.**

Results, local PostgreSQL 16:

- `run.sh`: parity has 0 differences, except the documented `MAINTAIN` privilege, which PostgreSQL 16 cannot grant.
- 6/6 live md5s confirmed.
- 16/16 cases and 9/9 real readings pass.
- s355 and governance specs: s355 4/4; s32, s42, s57 and s120 18/18 (local, 6 Nov 08:37–08:58).

Gaps found in the tooling (for agent E):

1. `prod-parity-capture` does not follow functions called by **index expressions**: `courses_provider_title_slug_active_idx` calls `security.course_title_key`. Workaround: name it in `--functions`.
2. The `field_enrich_items` insert trigger `field_enrich_items_gate` calls `security.enrich_item_held_v1`, which is not a trigger-function dependency. A fixture that inserts items must add it, with `coverage_course_pages`, `manual_locks`, `evidence_artifacts` and `search.refresh_requests`, for `record_v1`.
   - The PR extends this manifest's scope when it adds the record-path test.
   - The baseline here calls the check and trust functions directly.

## 12. Tests in the PR

1. `run.sh` before and after the migration:
   - all 16 baseline cases and the real readings give identical rules;
   - setting `enrich.course_description_claim_words` to a shorter list changes only the claim cases;
   - `pdesc.claim_words` edits no longer change course outcomes.
2. A re-run of the migration changes nothing (md5 already-applied path).
3. `course-text.ts` unit cases:
   - `courseTextBreach` equals the database count on the baseline shapes;
   - the re-ask prompt carries the limits and the previous text;
   - with `reask_max` 0, no second call is made;
   - a second answer still over the limit is recorded unchanged, never cut.
4. `s233` updated (prompt `course-text-v2`), `s355` extended.
5. Governance specs: `s32`, `s42`, `s57`, `s120`, `s121` (Layer 4 card). Regenerate the test register.

## 13. Acceptance measures (7 days after release with `reask_max` = 1)

| Measure | Today (08:56 AEDT 6 Nov 2026) | Target |
|---|---|---|
| AI readings passing every check | 44.7% (1,379 of 3,083) | at least 70% |
| `length` + `sentence_count` holds per 1,000 readings | 272 (839 of 3,083) | down at least 60% |
| `unsupported_claim` holds | 486 | reported by word; any change only by decision D-2 |
| Re-asks that end within limits | — | reported (no target) |
| AI cost per reading that passes | US$0.0024 | reported; within the existing guard |
| Held or hand-locked values overwritten | 0 | 0 |
| Consumer API drift (`consumer-api-guard`, s57) | none | none |
| Descriptions published (AU) | 163 | depends on D-1 (Layer 4 decisions); not a PR target |

## 14. Risks

1. **The re-ask raises cost** for the breached share (about 27% of readings). It ships off, and the existing AI guard caps it.
2. **The second answer may still break a claim or quote rule.** It is held as today, and the attempt is recorded.
3. **The seed of the new claim list must be identical on the day of release.** It is copied in SQL at migration time, and the baseline proves no outcome changes.
4. **Ordering risk with #877.** If #877 changes the shared pdesc helpers late, the md5s in this plan are stale. Re-read them all immediately before release (`run.sh` fails otherwise).
5. **Admission stays at zero until D-1.** The PR improves readiness only.
6. **Layer 4 queue growth.** A higher pass rate fills the per-provider cap (10) sooner. The rest wait as `held_first_admission`, with no extra AI spend.
7. **The 3 Nov failures are unexplained** ("no answer could be recorded after 3 tries", 180 items, US$0). Not reproduced since. If they recur, a separate fix records the worker error class.

## 15. Decisions needed from the Platform Admin

| # | Decision | Options | Recommendation |
|---|---|---|---|
| D-1 | D5 trust policy | O1 keep 100,000 · O2 per-provider N · O3 sample of 50 then N = 3 | **O3.** Decide the 50-item sample in Layer 4 first. |
| D-2 | The course claim-word list | (a) a copy of `pdesc.claim_words`, behaviour identical; (b) the copy without `students`, which alone causes 483 of 486 claim holds; (c) (b) and also without `staff`, `alumni`, `employment` and `employers`, keeping rankings, salary, accreditation and facilities | Ship (a): no change on the day of release. Then decide (b) as a settings change on Settings › Pipeline settings, with a reason. Evidence: "Students learn…" against a page that says "You will learn…" is not a claim. (c) only if the D-1 sample shows those words cause false holds. Note: (b) alone admits few readings unless the re-ask is on (§8.2 what-if). |
| D-3 | Length limits | Keep 700 characters and 4 sentences, or raise to 800 and 5 | Keep. Measure the re-ask first, and decide after 7 days. |
| D-4 | Switch on the re-ask | `enrich.course_description_reask_max` 0 → 1 after release | Yes, as the release acceptance step, with a reason |
| D-5 | Marketing-word list | Keep it shared, or split like claim words | Split in the same PR (seeded identical), so course work never touches `pdesc.*` |

## 16. Sequence

1. **Now (no PR):** this plan; the fixture and baseline on `cf247-course-descriptions-complete`; the D-1 sample decided by a person.
2. **#877 integrated:**
   - rebase the branch on main;
   - re-read the md5s;
   - write the migration (Part A), the worker (Part B) and the UI (Part C);
   - open **one** draft PR.
3. **Release:**
   - Controller deploys;
   - verify the md5s and settings live;
   - the Platform Admin sets `reask_max` = 1 (D-4) and decides D-1 and D-2;
   - the 7-day measure (§13).

## Appendix A: sample selection (read only)

Run on 6 Nov at 08:56 AEDT, it gave **50 items from 10 providers**:

- by country: AU 15, NZ 30, CA 5;
- by length: under 300 characters 3, 300–500 characters 28, over 500 characters 19.

Providers with at least 5 pending: AU 18, NZ 26, CA 6. NZ is over-weighted because more NZ providers have 5 or more waiting, and the quota counts only those providers.

**Before the sample is decided, the Platform Admin chooses one of these:**

- this spread; or
- quotas taken from the whole queue (AU 57%, NZ 36%, CA 8%). That variant changes `quota` to count over all of `p`.

Re-run the query at decision time: the queue changes.

```sql
-- D-1 sample: 10 providers x 5 pending course descriptions, deterministic (md5 order), spread by country and length. Read only.
with p as (
  select r.id, c.provider_id, k.iso_alpha2 cc, length(r.proposed_value->>'description') chars,
         case when length(r.proposed_value->>'description') < 300 then 'a<300' when length(r.proposed_value->>'description') <= 500 then 'b300-500' else 'c>500' end band
    from pipeline.layer4_review_items r join catalogue.courses c on c.id = r.entity_id join catalogue.providers pr on pr.id = c.provider_id join ref.countries k on k.id = pr.country_id
   where r.entity_type = 'course' and r.field_code = 'course_description_first_read' and r.status = 'pending'),
prov as (select provider_id, cc, count(*) n from p group by 1, 2 having count(*) >= 5),
pick as (select provider_id, cc, row_number() over (partition by cc order by md5(provider_id::text)) k from prov),
quota as (select cc, greatest(1, round(10.0 * count(*) / sum(count(*)) over ()))::int q from p where provider_id in (select provider_id from prov) group by cc),
chosen as (select k.provider_id, k.cc from pick k join quota q on q.cc = k.cc where k.k <= q.q order by k.cc, k.k limit 10),
items as (select p.*, row_number() over (partition by p.provider_id order by p.band, md5(p.id::text)) j from p join chosen using (provider_id))
select provider_id, cc, band, chars, id review_item_id from items where j <= 5 order by cc, provider_id, band, chars
```
