# Track C Step B — bounded RMIT slice: report

**Mandate:** Platform Admin, 28 Oct 2026 20:36 ("return to the approved plan and deliver Track C Step B end to end today").
**Decision record:** `docs/platform/ENTRY-REQUIREMENTS-STEP-B-DECISION-2026-10-28.md`. Lodged 20:54 AEDT, before any Pilot change; admin `63126bd3`.
**Report written:** 28 Oct 2026, about 22:4x AEDT.

## Status in one line

**The platform slice is live: B1, resolver and B5.** Two gates are open, and both need the Platform Admin:
- the Layer 4 admission of the BH126 read;
- the paste-reviewed consumer change (B2/B3, held PR #720).

The consumer course page (B4) is website-team work. **"Track C Step B RMIT vertical slice live" is therefore not claimed.**

## What the Platform Admin decides next

| # | Gate | Where | What to look at |
|---|---|---|---|
| 1 | **Layer 4 item `cf71cca1-ee7b-46ad-bd01-bdd8ab7c1890`** (Course entry first read, RMIT Bachelor of Engineering (Honours)) | Layer 4 Review | Three proposed rows, listed under B1 below. **Row 1 is "2026 ATAR 73.00": the previous year's ATAR, not a published minimum.** It is probably one to leave out (Approve except), but that is your call. The 2027 Guaranteed ATAR (75.00) was **not** kept: the model's quote was paraphrased, so it was dropped as `quote_not_on_page` |
| 2 | **A finding for your judgement.** The page prints: "You must have successfully completed a qualification recognised by RMIT as equivalent to the Victorian Certificate of Education (VCE) with a minimum average of 65%." | — | The B1 basis rule dropped it (`score_without_basis`), and nothing was mapped. Under your 28 Oct decision, India stays at step 5. If you judge that sentence to be source support for RMIT's 65% band, that is a new decision; I have not acted on it |
| 3 | **Consumer change (B2/B3):** held PR #720 (draft) and `docs/platform/pastes/PASTE-20261028-entry-consumer-api.sql` (file md5 `fd69acc1…`) | Supabase SQL editor, then merge #720 on your word | Additive keys only (dry-run proof below). After the paste, #720 is merged so the `website-api-v2` edge function deploys |

After gates 1 and 3, I verify the live payload. I then write the developer guide's worked example from the admitted rows, reissue the guide (section 7.9 drafted; section 13 lists the new fields), and refresh the measured figures.

## B1 — course-level extraction

- **Deployed:**
  - #717 (`c6fd9207`, v2.15.361, worker v0.49.0, migration `20261028001000`, history md5 `2f0e922a…`, equal to the file);
  - #718 (`3f264dc7`, worker v0.49.1, migration `20261028003000`, md5 `204f3380…`);
  - #719 (`3c681ac3`, migration `20261028004000`, md5 `f0cffece…`).
- **Path:** the existing Enrich fields lane, field `entry_requirements`.
  - It is not in the field registry, so no automatic plan or gap queue asks for it.
  - AU stored page only (`{ai_stored}`), with strong AU identity proofs.
  - The model is the pinned `entry.matrix_model`.
  - No new job, status, table or reader lane.
- **Course and country:** RMIT Bachelor of Engineering (Honours) BH126, course `09431698…`, CRICOS 0100714, India. Stored copy captured 5 Oct 2026; identity `cricos_code`.
- **Reads (US$0.006892 in total):**
  1. **21:39:10, taken by the previous worker v0.48.8 (US$0.0024; recorded as found).** Deploy-on-merge applies migrations before it deploys functions, so the slice item enqueued by #717's migration was read by the old worker as a generic field: "the page does not state it".
     - **Lesson recorded:** a migration that enqueues work for a new worker path must not ride the same merge as the worker.
     - #718 made a read release the field's no-value hold. It also reads the whole page text, not only `<main>`, as a precaution.
     - #719 re-enqueued the read only after v0.49.1 answered live (22:06:03).
  2. **22:18:18, worker v0.49.1 (US$0.0045).** Three rows proposed and two dropped:

| Proposed row (all `proposed`, audience `domestic`, confidence 1) | Quote (on the stored page) |
|---|---|
| minimum_grade: 73, basis "2026 ATAR" | "2026 ATAR 73.00" |
| subject_prerequisite: mathematics study score 20 | "Victorian Certificate of Education (VCE) units 3 and 4: a study score of at least 20 in one of Maths: General Mathematics, Maths: Mathematical Methods or Maths: Specialist Mathematics or equivalent studies." |
| subject_prerequisite: English (VCE subject, not an English test) | "Victorian Certificate of Education (VCE) units 3 and 4: a study score of at least 25 in English other than EAL; or a study score of at least 27 in English as an Additional Language (EAL) or equivalent studies." |

| Dropped | Reason |
|---|---|
| "For Semester 1 2027 applicants, this course has a Guaranteed ATAR (excluding adjustment factors) of 75.00." | `quote_not_on_page` (paraphrased) |
| "… equivalent to the Victorian Certificate of Education (VCE) with a minimum average of 65%." | `score_without_basis` |

- **Admitted course-requirement rows:** **0.** They wait in Layer 4 (gate 1). Nothing was auto-approved.
- **Rules held:**
  - quote on page;
  - a score only with its printed basis;
  - a band only when printed (none was);
  - no English test row;
  - audience from the quote (no international applicability inferred);
  - settings for every threshold (`entry.max_rows_per_course`, `entry.min_confidence`, `entry.course_page_chars`, `entry.course_read_countries`, `entry.level_equivalents`).

## Resolver

`security.entry_resolve_v1(course, country)` applies the five rules, in order, over active rows. It is a pure lookup.

- **Live result for BH126 / India (now):** step 5, `contact_provider`. Note: "The provider publishes a band table for this country, but the course page prints no band to enter it with." This stays the result after admission, because no row prints a band (Platform Admin decision 28 Oct).
- **Each rule proved in a rolled-back live dry run with fixtures** (the band-ladder rule is **not** claimed live for this course):

| Rule | Proof |
|---|---|
| 3 band ladder | A printed 75% band joined RMIT's real active India rows: AISSC 75%, ISC 75%, State Boards 80% (BH=BA) |
| 4 provider minimum, case by case | Step 4, `case_by_case` |
| 2 per-course row | Step 2 |
| 1 override | Step 1. A proposed override is ignored (step 2) |
| Validation | `ZZ` refused as `INVALID_INPUT` |

## B5 — admin interface

- **Deployed:** v2.15.361, `src/EntryRequirements.jsx`, `public.admin_entry_requirements`.
- **Admin UI paths:**
  - **Catalogue › Providers › provider drawer › Academic entry requirements.** RMIT: 343 active rows (50 a page), filters for status, country and level, each row with its quote, source, stored copy, as-at date and run/Layer 4 state.
  - **Catalogue › Courses › course › Academic entry requirements.** The course rows (the 3 proposed rows show "waiting in Layer 4"), the last read with what was not kept, the resolver by country, and the Platform Admin's "Read from the stored page".
- **Bounded:** at most 100 rows a call, one provider or course. No table editing, no SQL, no second approval route.
- **Dry run:** India narrowed to 34 of 34 rows with page size capped at 100; all rows paged 50 of 569 (fixtures included); course view with `can_read`.
- **Live UI check:** release currentness and CourseFinder Deployed UAT passed for #717, #718 and #719. The new sections were not opened by a signed-in person in this session (no UAT login here). **Please glance at both sections.**

## B2 — additive consumer API

- **Held PR #720 (draft), migration `20261028005000`, paste file above.**
- **Course** gains `entry`; **provider** gains `entry_matrix`. Every other key is identical, and no separate AER function is added.
- **Payload evidence** (live dry run, rolled back, with an admitted fixture read):
  - course keys added: only `entry`, rest identical;
  - provider keys added: only `entry_matrix`, rest identical;
  - `entry` = {min_score 75, basis "2027 Guaranteed ATAR", band null, 1 prerequisite} (a fixture);
  - matrix 343 rows;
  - baseline re-taken: 75 functions, 48 relations.
- **Tests:** s113. Suite on the PR branch: 1,082 passed, 0 failed, 0 skipped.

## B3 — edu_country

- `website_v2_course(text, text)` and `website_v2_provider(text, text)`; `website-api-v2` passes `edu_country` for `course` and `provider`.
- **Dry run:**
  - course `IN` → step 5;
  - provider `IN` → 33 rows, India only;
  - invalid codes refused.
- Search is unchanged (the plan defines `edu_country` on course and provider only).
- **Not live** until gate 3.

## B4 — consumer display

- Website-team integration (Platform Admin 28 Oct). No consumer page is built or claimed.
- **Delivered:** the rendering rules (section 7.9 drafted for the developer guide; decision 10's case-by-case rule kept).
- **Waiting:** the worked example. It is written from admitted rows only, after gates 1 and 3.

## Tests, dry runs, md5 and deployment checks

| Check | Result |
|---|---|
| Suite | #717 1,077; #718 1,078; #719 1,079 — each 0 failed, 0 skipped. Build OK |
| Register | Regenerated (s113 / s114 / s139 / s140) |
| Live md5 before merge | `svc_enrich_ai_record` `c3685d7a…`, `svc_enrich_ai_next` `0ad1ad53…`, `layer4_review_decide_impl` `a438f594…`, `course_entry_read_enqueue_v1` `77053f34…`; consumer edits guarded on `website_v2_course` `ad9ba388…` and `website_v2_provider` `2411c7e4…` |
| Migration md5 | Live history equals each file (#717, #718, #719) |
| Workers | v0.49.0 answered from 21:40:06; v0.49.1 from 22:06:03 |
| Consumer API now | Unchanged: 0 changed, 0 new, 0 relations changed |
| Unexpected work | No AER matrix run created or changed today; RMIT still 343 active, 37 proposed, 167 superseded, 20 quarantined; `entry.providers` UTS and WSU. Only the two B1 items above ran, US$0.0069 in total |
| Scratch branch | `cf247-zoho-dryrun` left identical to `main` |

## Limitations and remaining approvals

1. **Layer 4 decision** on the BH126 read (gate 1). The ATAR row needs your judgement.
2. **Consumer change** paste and #720 merge (gate 3). Then I verify live, write the worked example and reissue the developer guide.
3. **The 65% sentence** (finding 2) is a possible source for a band. It is left alone unless you decide otherwise.
4. **B4** is the website team's work.
5. **The 37 proposed RMIT matrix rows** remain a separate Layer 4 task, untouched.

---

## Update 28 Oct 2026, 22:5x (after the Platform Admin's 22:44 decisions)

- **Decisions recorded first:** decision record section 11 (admin `e816b590`).
- **Consumer change: verified and live.**
  - The paste history md5 `fd69acc1…` equals the file. `website_v2_course(text)` and `website_v2_provider(text)` equal their earlier definitions plus one key each (`entry`, `entry_matrix`). The new functions' bodies equal the PR's.
  - Live: `IN` gives step 5; the provider matrix has 343 rows, or 33 with `in` (IN only); `ZZ` and `IND` are refused with `22023 INVALID_INPUT`.
  - Baseline re-taken: 75 functions, 48 relations; 0 drift.
  - #720 merged 22:46:42 (`09dca1b6`). `website-api-v2` deployed and matches the repo (edge drift check). Release currentness and Deployed UAT passed.
- **Waiting for the Platform Admin's session** (no SQL, by decision):
  1. Layer 4 `cf71cca1`: Approve except `dab50fa7…` (2026 ATAR 73.00).
  2. BH126 › Read from the stored page.
- **Expectation:** the same reader, prompt, model and copy produced the paraphrased ATAR quote and the dropped 65% row at 22:18. A repeat stops Step B at the evidence gate.
- **Not yet claimed:** "Track C Step B platform RMIT vertical slice live".
