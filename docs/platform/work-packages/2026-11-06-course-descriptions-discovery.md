# Course descriptions: discovery and automation compatibility assessment

**Agent F (discovery only), 5 Nov 2026 19:51–20:10 AEDT.** Source decision: Platform Admin 5 Nov 2026 19:14 §4, §6, §7, §11 (`docs/platform/2026-11-05-centralise-development-claude-parallel-agents-1914.md`). No code, migration or production write was made. Production was read with SELECT only, under the load policy (bulk counts at 19:56–19:58).

## 1. Summary

The course description reader **already exists and runs** (v2.15.422, PR #817, merge `36282707`, 3 Nov 2026). It is not missing. It is **stalled at admission**:

- **0 course descriptions have been admitted since release.** AU published courses with a description: 163 (unchanged since 3 Nov; all are old adapter values with no evidence).
- **851** descriptions wait in Layer 4 (`course_description_first_read`) across 339 providers. **None has ever been decided.**
- That is by decision: `enrich.course_description_review_first` = 100,000 (Platform Admin D5, 3 Nov 08:44: "Layer 4 review continues … a future trust policy comes back for explicit authorisation").
- About **half the AI readings are held by the checks**: too long 476, too many sentences 360, unsupported claim 484, other 320.

The next bounded PR should therefore **not** build a reader. It should make the existing one productive and governed. Four parts:

1. Bring the held readings within the rules with one bounded re-ask.
2. Separate the course claim-word list from the provider list that #877 is tightening.
3. Show the held reasons on the existing screens.
4. Put the trust rule to the Platform Admin as a measured decision pack.

## 2. Inventory of existing work

### 2.1 Branches

| Branch | On `origin/main`? | Last commit | Purpose | Disposition |
|---|---|---|---|---|
| `cf247-course-description-reader` | Content released (squash in #817, v2.15.422). Every file it adds is on main; the files that differ have since moved on in main. | 3 Nov 2026 | Workstream C: course description and application deadline as Enrich fields | Superseded by main. Can be deleted under housekeeping (no unique work). |
| `cf247-course-description-reader-v2` | Same (v2.15.422 release commit: SOP, release notes) | 3 Nov 2026 | v2.15.422 release packaging | Superseded by main. Can be deleted. |
| `codex/provider-description-autonomy` (PR #877, agent B) | Not merged | 5 Nov 2026 (`af24cbcd`) | Provider (university) descriptions | **Dependency.** It edits the shared `description.ts` and `index.ts`, plus `Layer4Inbox.jsx` and `FieldCoverage.jsx`. |
| `cf247-p1-provider-descriptions`, `cf247-provider-description-reader`, `cf247-pdesc-*` | Provider descriptions (not course) | — | — | Agent B's scope. |

### 2.2 Code on main

| Layer | Object | Notes |
|---|---|---|
| Migration | `20261103110000_cf247_course_description_deadline_fields.sql` (md5 `94ec9f79…` verified at release) | Adds the fields to `security.enrich_fields_v1` and the settings. Edits the gap queue, Layer 4 and coverage functions. Description and deadline share it. |
| Gap selection | `security.enrich_course_text_gaps_v1(text[])` live md5 `a6d0da8f6d6fd7d31c6c39c707e2d824` | Active courses with a stored, identity-proved page. At most `enrich.course_text_items_per_day` (500) new standing items a day per field. |
| Admission check | `security.course_description_check_v1(uuid,jsonb)` live `ff3d6dd7b0f88c85b1fdff6c8a8cd86b` | The provider description rules: quote on page, `pdesc.superlatives`, `pdesc.claim_words`, `pdesc.support_min_share`, `pdesc.duplicate_share`. It also checks sentence and character limits and fragments. |
| Record | `security.enrich_course_text_record_v1(bigint,jsonb)` live `b47c00b19bc6eaa36828dbe4d2371501` | Layer 4 on first admission, the pending cap, and admission into `catalogue.courses.description` (never over a held value or a hand lock). |
| Trust | `security.course_description_trusted_v1(uuid)` live `3f056fa4495963ec1d3bca61bfe0642d` | Trust starts after the provider's latest N decisions are all approvals. N = `enrich.course_description_review_first`. |
| Layer 4 apply | `security.layer4_course_description_apply_v1(uuid,uuid,jsonb,text)` live `ba97236f3010e248bac44a0a7c09611a` | Called from `layer4_review_decide_impl`. |
| Other live md5s | `enrich_fields_v1` `80ee183b324c196b4c9559cec6e3360f` (unchanged since v2.15.422); `field_gap_queue_tick_v1` `9bb80b419ee26a049b99a35fb278e272` and `field_gap_queue_run_v1` `429835d4d27375da95901104838a0cad` (changed after v2.15.422 by Release B and the orchestration follow-ups) | A PR must guard on these live values, not on the v2.15.422 values. |
| Worker | `coverage-sweep` `course-text.ts` (v0.59.4), mode `enrich_ai`, uses `description.ts` (`descriptionSentences`, `descriptionPageText`) | One call per course on the stored page. The limits are stated to the model. Every quote is checked against the page. **Owned by agent B until #877 is integrated.** |
| Admin UI | `src/EnrichFields.jsx` (shows the value), `src/Layer4Inbox.jsx` (Course description card), `src/course-coverage.jsx` | Run Now uses the generic `public.admin_job_run_now_v1` → `security.job_run_now_v1`, rank-gated by `automation_catalogue.control_rank`. `field-gap-queue` is rank 6. |
| Tests | `tests/uat/cf-247-s233-course-description-deadline-contract.spec.mjs`, `tests/fixtures/course-text/` (live definitions captured 3 Nov) | The fixture's `live/` definitions are older than the current live md5s above. They must be re-captured. |
| Consumer | `public.website_v2_course` reads `catalogue.courses.description` (detail only, not search items) | No G3 change is needed: the reader writes only into an existing column. |

### 2.3 Settings (`pipeline` toolset, live)

| Key | Value |
|---|---|
| `enrich.course_text_items_per_day` | 500 |
| `enrich.course_description_min_sentences` / `max_sentences` | 1 / 4 |
| `enrich.course_description_min_chars` / `max_chars` | 80 / 700 |
| `enrich.course_description_min_quote_chars` | 20 |
| `enrich.course_description_review_first` | **100,000** (held by D5) |
| `enrich.course_description_pending_max` | 10 per provider |
| `enrich.course_description_duplicate_window` | 500 |
| `reading.answer_tokens.course_text` | 1,500 |

Shared with provider descriptions: `pdesc.superlatives`, `pdesc.claim_words`, `pdesc.support_min_share`, `pdesc.duplicate_share`.

### 2.4 Jobs (live `cron.job`, `pipeline.automation_catalogue`)

There is **no dedicated job, by design.** Items come from:

- `field-gap-queue` (hourly at :23 with an internal due rule; rank 6);
- `enrich-plan-run` (every 5 minutes; rank 6);
- `enrich-plan-auto` (hourly at :41; rank 6);
- Enrich fields tasks started by a person.

### 2.5 Decisions and records (admin repo)

- Platform Admin direction 3 Nov 09:32 and acceptance report item 1: the reader.
- `nz-enrichment-brief/2026-11-03-v2.15.421-422-deployed-state.md`: `review_first` was raised to 100,000 (event #28716).
- `2026-11-03-platform-admin-decisions-0844.md` D5: Layer 4 continues, and a trust policy comes back for explicit authorisation.
- `2026-11-02-missing-field-coverage-reconciliation.md`: the 163 held values are page meta descriptions with no evidence.
- `skills/cf-layer4-triage/references/action-playbook.md`: the Layer 4 pill.
- Execution register 4 Nov 17:12: 662 were pending then. There are 851 now.
- The project's lessons docs (`claude/coursefinder-enrichment-lessons.md` and others) are held in the claude.ai Project and could not be read from this session. The Controller should check them before the PR is issued.

## 3. Measured production state (read-only, 5 Nov 2026 19:56–20:05 AEDT)

### 3.1 Coverage of active courses, published providers

| Country | Courses | With description | Share |
|---|---|---|---|
| AU | 23,732 | 163 | 0.7% |
| NZ | 6,495 | 0 | 0% |

The AU unpublished providers have 1,648 courses and none has a description. `enrich_coverage_snapshots` at 19:00 each day reads AU 163 on 3, 4 and 5 Nov: **no change**.

### 3.2 Coverage state (`pipeline.course_attribute_coverage`, all active)

| State | AU | NZ |
|---|---|---|
| admitted | 163 | 0 |
| in review (Layer 4) | 487 | 299 |
| page found, not yet read | 18,498 | 1,120 |
| site known, no course page | 4,913 | 2,882 |
| not on page / identity unresolved / evidence pending | 750 | 2,138 |
| blocked | 261 | 36 |
| no website | 308 | 20 |

### 3.3 Last 7 days (`pipeline.field_enrich_items`, field `description`)

| Outcome | Items | AI cost |
|---|---|---|
| Admitted (`filled`) | **0** | — |
| In Layer 4 (`review`) | 851 | US$0.95 |
| Passed the checks but held because the provider already had 10 waiting (`held_first_admission`) | 522 | included below |
| Held by a check | about 1,640 | US$2.36 for all skipped items |
| No proven or correct page (no AI call) | 601 (unproven 453, another course 87, no source 61) | — |
| Page does not describe the course | 60 | — |
| Failed: "no answer could be recorded after 3 tries" | 180 (all 3 Nov, none since) | 0 |

Held by a check, broken down:

| Rule | Items | Detail |
|---|---|---|
| `unsupported_claim` | 484 | |
| `length` | 476 | 701–798 characters: 295; 800–991: 155; over 1,000: 26 |
| `sentence_count` | 360 | 5 sentences: 192; 6: 86; 7 or more: 82 |
| `unsupported_sentence` and `quote_not_on_page` | about 270 | |
| `duplicate_other_course` | 10 | |
| `incomplete_sentence` | 7 | |

Of about 3,070 AI readings, **about 45% passed every check** (851 + 522) and about 53% were held.

The Layer 4 queue is 851 pending: oldest 3 Nov, newest 5 Nov, 339 providers, **0 decided ever**.

## 4. Gap analysis

| Done | Broken or weak | Missing | Retiring |
|---|---|---|---|
| Reader, prompt, quote checks, the provider-description rules, Layer 4 on first admission, the pending cap, the standing gap queue, plan steps, settings (G2), the s233 contract, consumer column already published | 1. **Nothing is admitted.** That is the D5 hold, not a defect, but the result is that the capability has no output.<br>2. **The length and count limits miss for 836 readings.** The model is told the limits but overshoots, and the reading is held, never cut. The AI spend on these is wasted.<br>3. **The `unsupported_claim` rule holds 484.** The provider list `pdesc.claim_words` is shared, and #877 asks for it to be **stricter**, which would raise course holds silently.<br>4. 180 "no answer" failures on 3 Nov: no detail of the cause is persisted. | 1. A **trust policy decision pack** with measured evidence (D5 asks for it).<br>2. **Held reasons on the existing coverage and Enrich fields screens.** At present they show only in raw items.<br>3. **Consumer publication verification** (a website v2 course detail probe after the first admission).<br>4. A responsive check of the Course description Layer 4 card (s121 screens). | Nothing in this capability. The 163 old adapter descriptions have no evidence. They are kept: there is no deletion. A later decision may re-read them. |

## 5. Automation compatibility assessment

- **Reuses:**
  - the existing Enrich fields engine (`enrich_fields_v1`, `field_enrich_items`, worker mode `enrich_ai`, `course-text.ts`);
  - `field-gap-queue`, `enrich-plan-run` and `enrich-plan-auto`;
  - the Layer 4 kind `course_description_first_read` and its apply function;
  - the `guard_enrich_fields` AI guard;
  - the stored pages (no Firecrawl);
  - the `enrich_coverage_snapshots` and `course_attribute_coverage` measures;
  - the existing Enrich fields, Coverage and Layer 4 screens;
  - generic Run Now.
- **Changes:**
  - `course-text.ts`: one bounded re-ask when the answer breaks `length` or `sentence_count`. The re-ask sends the previous answer and the limit and is counted against a new setting. It is never a cut.
  - `security.course_description_check_v1`: reads a new course-specific claim-word list.
  - `security.enrich_course_text_record_v1`: persists the failure detail.
  - The coverage reason breakdown on the existing screen.
- **Replaces:** the shared use of `pdesc.claim_words` by course descriptions, with `enrich.course_description_claim_words`. It is seeded with today's value, so behaviour is identical on the day of release.
- **Retires:** nothing.
- **Conflicts:**
  1. PR #877 (agent B) owns `description.ts` and `index.ts` and edits `Layer4Inbox.jsx` and `FieldCoverage.jsx`.
  2. #877 asks the Platform Admin for a stricter `pdesc.claim_words`, which today also drives course descriptions.
  3. Agent C owns `src/mature-main.jsx`, so no catalogue-column work goes in here.
  4. The trust rule is a Platform Admin decision (D5), not an engineering change.
- **Protects:**
  - D5: `review_first` stays 100,000 unless the Platform Admin authorises otherwise;
  - "held, never cut";
  - a hand lock or held value is never overwritten;
  - the consumer API shape (G3: an existing column only);
  - the AI guard and daily caps;
  - "a passing qualification never switches anything on".
- **Validates:**
  - s233 extended;
  - a new spec for the re-ask and the claim-list split, against production-parity fixtures (live definitions re-captured with the md5s above);
  - s32, s42, s57 and s120;
  - s121, if the Layer 4 card is touched;
  - a post-release measure: share of readings passing the checks (target at least 70%, from about 45%) and AI cost per passing reading.

## 6. Proposed PR: "Course descriptions: productive and governed" (one bounded PR)

**Branch:** `cf247-course-descriptions-complete`.

**Migration family:** to be assigned by the Integration Controller. The suggested range is `20261106500000`–`20261106549999`, which is not in the ownership table yet.

**Scope:**

1. **Worker (`course-text.ts`, after #877 is integrated).** If the answer breaks only `length` or `sentence_count`, re-ask once on the same stored page. The re-ask sends the stated limits and the previous sentence count and length. The second answer goes through every check again, and nothing is cut. New setting: `enrich.course_description_reask_max` (0–2, default 1; label, range, unit and `used_by` per G2). The cost is recorded per call as now.
2. **Database.** New setting `enrich.course_description_claim_words`, seeded from today's `pdesc.claim_words`. `course_description_check_v1` reads it, with an md5 guard on `ff3d6dd7…`. `enrich_course_text_record_v1` (md5 guard `b47c00b1…`) keeps the failure detail: the worker error class and whether the answer was cut by the token limit.
3. **Admin UI (existing screens only).**
   - The held-reason breakdown for description on the existing Field coverage, Why values are missing view. Coordinate with #877, which also edits `FieldCoverage.jsx`.
   - The Layer 4 Course description card shows the check results (sentences, characters, support).
   - No new dashboard.
4. **Decision pack** (admin doc, not code): trust policy options for D5, with the measured approval rate once a sample of the 851 is decided.
5. **Consumer verification.** A read-only probe of `public.website_v2_course` for an admitted course in an `@deployed` spec. No consumer object changes.
6. **Docs.** Admin SOP section and operator SOP for the description lane. Regenerate the test register.

**Tests (production-representative):**

- Re-capture `tests/fixtures/course-text/live/*` from production: functions, constraints, triggers and grants of `field_enrich_items`, `layer4_review_items` and `catalogue.courses`.
- Run s233 plus a new spec with a `// Guards:` line naming this decision, using real held readings shapes (no user data).

**Acceptance measures (7 days after release):**

- share of AI readings passing every check at least 70%;
- `length` + `sentence_count` holds down at least 60%;
- no rise in `unsupported_*` admits in Layer 4 rejections;
- 0 overwritten held or locked values;
- AI cost per passing reading reported.

**Risks:**

- The re-ask doubles the cost for about 27% of readings (about US$0.0008 each; within the existing guard).
- The claim-list split must be identical on the day of release.
- Admission stays zero until the Platform Admin decides D5. The PR improves readiness but does not by itself publish descriptions.

**Platform Admin decisions needed:**

1. **D5 trust policy.** Keep 100,000, or allow trusted admission after N approvals per provider. A decision on a Layer 4 sample (for example 50 across 10 providers) is needed first.
2. Whether `max_chars` 700 and `max_sentences` 4 stay. 450 of the 476 length holds are 701–991 characters. This is a settings change, not code.
3. Confirm that course descriptions keep their own claim-word list when #877's stricter `pdesc.claim_words` is decided.

No spend increase. No G3.

**Dependency:** the worker and `FieldCoverage.jsx` / `Layer4Inbox.jsx` parts wait for **#877 integration**, because B owns `coverage-sweep` (`description.ts`, `index.ts`, `course-text.ts` shares the matcher). The database-only parts (settings, the check function, failure detail) could be written first, but should be released after #877 so the md5 guards are taken against the post-#877 live state.
