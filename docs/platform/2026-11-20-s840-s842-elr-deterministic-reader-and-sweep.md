# English language requirements (ELR): runner-b fix, deterministic reader `elr-det-v1.0`, gated promotion and scheduled sweep (s840 to s842)

**Session:** S1-ELR · **Platform Admin request:** 20 Nov 2026 15:10 and 15:21 AEDT (lane block s840 to s849) · **Change control:** CF-CHG-20260915-247 · **Pilot:** #1428, migration `20261120170000` · **Spend:** US$0 (no model, no Firecrawl)

This lane covers English language requirements only. Academic entry requirements (AER) stay with S1-AER, which runs its own `aer-det` pipeline.

## 1. Baseline (live, read only, 20 Nov 2026 15:12 AEDT)

This was read through the rolled-back dry-run workflow (`db-migration-dry-run.yml`, dispatched with a probe expression), so no interactive SQL was used. At the time of reading, the head was `20261120143000` with 2,219 history rows. G3 was 75 functions / 48 relations, and there were 7,585 manual locks.

| Country | Active courses | With an active English requirement | Table 1: no requirement, stored page bound | Table 2: no requirement, no stored page |
|---|---:|---:|---:|---:|
| AU | 25,703 | 16,427 | 3,780 | 5,496 |
| NZ | 6,514 | 2,392 | 1,094 | 3,028 |
| CA | 3,814 | 2,017 | 1,341 | 456 |
| **Total** | **36,031** | **20,836** | **6,215** | **8,980** |

- Active requirement rows by test: IELTS 20,992, PTE 4,807, TOEFL iBT 3,203, Cambridge (CAE) 1,032, Duolingo (DET) 682, OET 256, CELPIP 80. Most of them came from policies (`policy:` keys, 14,258), then `cf245` (1,054) and `d162-elp` (229).
- Of the 6,215 Table 1 courses, 6,151 have a page that has been read. The identities are CRICOS code 2,868, exact title 2,047, title and level 290, adapter title 270, manual 235, field and award 224, degree name 196, NZQA code 20 and adapter code 1. 541 of the courses sit on 234 pages that are bound to more than one course.
- Table 2 needs a course page before it can be read. That is a page-discovery task, not this reader's job.

## 2. admission-rule-runner-b time-outs (s840)

- **Symptom:** `call security.admission_rule_tick_v1('b')` failed with `canceling statement due to statement timeout`. The context was `SQL function "english_group_match_v1" statement 1`, inside `security.provider_english_plan_v1`. There were 2 such failures in the 24 hours before 15:12 AEDT. The lane's English rule `provider-english-defaults` ran at a median of 52 s and a maximum of 119 s against its 122 s budget.
- **Cause:** the plan called `english_group_match_v1` once for every course of the provider (`grp_hits`), and again for every course × every other approved policy of the provider (`other_group`). That function carries `SET search_path`, which stops it being inlined, so each call pays the full overhead. None of the 180 approved English policies has a course-group binding, so every one of those calls returned `[]`. The title key (`security.english_title_key`, which also carries `SET`) was worked out for every course as well.
- **Fix:**
  - The two match calls now run only when this policy, or another approved policy of the provider, has bindings. That is read once, at the top of the plan.
  - The title key expression is written out in place.
  - The live text is md5-checked (`6fec9e65…`) before it is replaced. The post-check runs the plans of the 8 largest providers before and after, and requires the same rows. It also proves the written-out key equals `english_title_key` for all of their active courses.
- **Measured** in the same rolled-back transaction for the same eight plans: 230 to 5,649 ms before, 151 to 676 ms after, with one run reaching 2,223 ms while other lanes' sweeps were loading the database. The query itself took 176 ms by EXPLAIN on the largest provider's 655 courses. The timing is reported rather than enforced in the migration, because the shared database swings with other lanes' load. The steady cost is read back live after the merge (section 7).

## 3. The reader `elr-det-v1.0` (s841)

The module is Pilot `supabase/functions/coverage-sweep/elr-det-reader.ts`, used by the read-only worker mode `elr_det_read`. It uses no model, makes no fetch and writes nothing.

| Test | What is read | Names recognised |
|---|---|---|
| IELTS | Overall band (4 to 9, in halves); a "no band below" floor (written to all four skills); or each skill named | IELTS, International English Language Testing System |
| TOEFL iBT | Total (32 to 120); section minimums (0 to 30) | TOEFL, TOEFL iBT, Test of English as a Foreign Language (PBT, ITP and Essentials are skipped) |
| PTE Academic | Overall (30 to 90, decimals kept, for example 58.5); skill minimums | PTE, PTE Academic, Pearson Test of English (General, Core and Home are skipped) |
| OET | Grade (A, B, C+, C) or a score of 300 to 500 in each sub-test | OET, Occupational English Test |
| CELPIP | Level (4 to 12), overall or in each component | CELPIP, Canadian English Language Proficiency Index Program |
| Cambridge | Scale score (160 to 230), skill minimums, C1 Advanced or C2 Proficiency | Cambridge English, C1 Advanced, C2 Proficiency, CAE, CPE |

How a reading is taken:

- **Quote:** every reading's quote is a line or sentence of the page, checked to be on the page word for word.
- **Value window:** a value is read only from the words between its test's name and the next test or qualification named on the line. Duolingo, LANGUAGECERT, Michigan, CAEL, CanTEST, NCUK, TOEIC, iTEP, Password, ATAR, GPA, A-levels, IB, NCEA and University Entrance all end the window.
- **Collapsed-line guard:** a line naming two or more programme titles, or giving one test two different values, is skipped and never cross-assigned.
- **Flags:**
  - `pathway` means the quote is about a foundation, pathway, ELICOS or English course. It is never promoted.
  - `no_minimum` means the quote has no minimum or requirement words.
  - `section` means the line follows an "English language requirements" heading within 8 lines. A bare list under that heading counts as a stated requirement.

## 4. Promotion and the scheduled sweep (s842)

The writer is the single function `security.elr_det_record_v1`. It records every page and reading (`pipeline.elr_det_pages`, `pipeline.elr_det_readings`), then decides each course as follows.

**Page and course gates.** If any of these fails, every reading on the page is held with its reason:

- The page is still the course's bound, read page (same evidence).
- Its identity is accepted for English by `security.coverage_identity_allowed`, or is manual, CRICOS, NZQA or an adapter code.
- The page is not refused.
- The course is active, in an admission country and not held by Layer 4.
- The course holds no active English requirement (no overwrite).
- The course has no manual lock on `english`, `english_requirements` or `course_english`.
- No English review is already pending for the course.

**Test gates,** checked per test on the page:

- Every non-pathway reading agrees (one value).
- It states a minimum.
- Its values are printed in its own quote (`security.elr_det_quote_ok_v1`).
- It is complete (an overall score, or for OET a grade or all four sub-test scores).

**Layer 4** (`course_english`, the existing approve path) receives three kinds of course:

- a conflict, such as two IELTS values for different levels or programmes;
- a page shared by several courses;
- the audit sample (`elr_det.audit_pct`, 5%).

Each item carries a plain reason, the proposed requirements and the conflicting quotes.

**Promotion** is an insert only (`on conflict do nothing`). The manual-lock trigger still has the last word. The key is `source_requirement_key = 'elr-det:<test>'`, with `confidence = 1` and the page's evidence and source. The search projection is then refreshed for the promoted courses through `search.refresh_course_enrichment_scoped_v1`. If the writer lock is busy, the scheduled projection picks those courses up instead.

**The job `elr-det-sweep`** (every 5 minutes, catalogued) runs `security.elr_det_sweep_tick_v1()`:

1. It reads back its earlier worker calls' answers from `net._http_response` and records them.
2. It gives up any call with no answer after `elr_det.request_lost_minutes`, and those pages go back to the queue.
3. It sends the next indexed keyset batch (`security.elr_det_claim_v1`, by course id after the cursor in `pipeline.elr_det_state`) to the worker, in calls of `elr_det.pages_per_call`. No more than `elr_det.in_flight_max` calls are open at once.

At the defaults (200 pages a run, 25 a call, 8 open), the 6,151 read Table 1 pages drain in about 2.6 hours.

**Settings** (Settings › Pipeline settings › Admission checks):

| Setting | Default | Range |
|---|---|---|
| `batch.elr_det_sweep` | 200 pages | 25 to 250 |
| `elr_det.pages_per_call` | 25 | 5 to 40 |
| `elr_det.in_flight_max` | 8 | 1 to 12 |
| `elr_det.audit_pct` | 5% | 0 to 50 |
| `elr_det.promote_on` | 1 | 0 or 1 |
| `elr_det.sweep_on` | 1 | 0 or 1 |
| `elr_det.request_lost_minutes` | 30 | 10 to 360 |

**Run Now and status:** workflow `elr-det-read.yml` (`status`, or `run` for N minutes), and `security.elr_det_status_v1()`.

## 5. Guardrails kept

- **G1:** the job is catalogued and in the component register.
- **G2:** every size and limit is a setting, and the job command holds no number.
- **G3:** 75/48, checked before and after. No public function, table or view was added; everything is in `pipeline` and `security`.
- **Locks and no-overwrite:** the 7,585 manual locks are compared before and after, and nothing is written over an existing requirement.
- **Spend:** US$0.
- **Untouched:** nothing is dropped or deleted, and nothing in AER is touched.

## 6. Validation before merge

- **Local specs:** s841 (reader) 7 of 7, and s840 to s842 (migration) 6 of 6. s42, s57, s120, s616 and s828 pass. s32's contract tests pass; its browser test needs Chromium, which CI runs.
- **Rolled-back live dry runs** of the final file passed, with the plans unchanged row for row.
- **Synthetic writer run** inside a rolled-back transaction, on 40 real gap pages with one IELTS reading each: 29 promoted, 9 to Layer 4 (shared page or audit sample) and 2 held, with the search refresh working. Nothing was kept.

## 7. After merge (filled in by the closing record)

- Read back the deployed worker (`elr_det_read` answers with `elr-det-v1.0`), the job and the first ticks.
- Record promoted courses and rows, Layer 4 items and held reasons, and the runner-b and `provider-english-defaults` timings over the next runs.
- Re-measure Table 1 and Table 2.

## 8. Comments and replies

(Every later comment and reply on this lane is appended here.)
