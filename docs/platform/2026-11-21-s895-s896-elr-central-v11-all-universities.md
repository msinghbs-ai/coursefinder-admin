# English language requirements from central English pages, second pass: `elr-central-v1.1` across all universities (s895 and s896)

**Session:** S1-ELR-Central-Policy · **Platform Admin request:** 21 Nov 2026 07:48 AEDT ("populate the remaining source-backed ELR gaps across all universities from each institution's central English proficiency page by study level at $0 AI and $0 Firecrawl spend, with no hardcoded university or provider coverage exclusions") · **Change control:** CF-CHG-20260915-247 · **Pilot:** #1443, migration `20261121080000` · **Spend:** US$0 · **Follows:** `2026-11-20-s884-s886-elr-central-policy-route.md`

## 1. Audit (live, rolled back, 21 Nov 2026 07:55 to 08:20 AEDT)

Table 1 holds the active AU, NZ and CA courses with no active English requirement and a stored course page bound. It is **5,930 courses**: AU 3,538, NZ 1,091, CA 1,301. The request's 5,151 is a narrower count; this record uses the live definition throughout. The s886 central sweep had read every stored central page, so the claim had 0 left.

| Route | Universities | Courses | What it needs |
|---|---:|---:|---|
| elr-central reading approved | 19 | 73 | Nothing: these courses are held by rule (another level, named course or regulated discipline) |
| elr-central reading waiting for a person | 28 | 730 | A person, in Universities › English. The reading has a conflict, another reading of the university is waiting, or it failed the course-page disagreement check |
| Approved policy only; the page added no level | 75 | 1,353 | A page that states the missing level (VET, research) |
| Page read, no proposal | 70 | 1,132 | v1.1 (this change) for the layouts v1.0 missed; a level-less page stays held |
| Central page found but not stored | 70 | 346 | Firecrawl: not in this $0 lane |
| No central page | 523 | 2,296 | Page discovery (348 private VET colleges, 92 schools, 35 HE institutes) |

- **The 319 pages with no value.** All 319 pages recorded as "the page states no English test requirement by tier" are stored Markdown, and several are genuine requirement pages (Waikato, Flinders, UNBC graduate). The likely causes are layouts v1.0 does not read: tables whose columns are study levels, values written before the test name, and English "band" schemes that assign courses to bands rather than to study levels.
- **No exclusions.** No provider or university is excluded by name, type or list anywhere in this route. The claim takes every university in an admission country that has a stored central English page and a course with no English requirement.

## 2. Change

- **s895, reader `elr-central-v1.1`:**
  - It reads tables whose columns are study levels and whose rows are tests, and quotes each row.
  - It reads "a score of 6.5 in IELTS", where the score comes before the test name, quoted by the original line.
  - It reports values found without a study level (`untiered`, `bands`, `values_found`) instead of using them.
  - Tiers stay strict: a value is never spread across levels.
- **s896, second pass:**
  - Every stored central page of a university without an elr-central reading is read again by v1.1. Reads are keyed by reader version; the v1.0 rows stay as history.
  - The writer records the new held reasons: "values without a study level" and "the page sorts courses into English bands or levels".
  - The route's parser name stays `elr-central-v1.0`, with the reader version in `proposal.reader`. Approval (`policy_auto_approve_v1`), the plan (VET tier, regulated-discipline holds), the apply runs and the Layer 4 holds are therefore unchanged.
  - No new job, table or setting; the work runs inside `elr-det-sweep`.

## 3. Guardrails

- Every replaced function is md5-checked first.
- G3: 75/48, checked before and after.
- Manual locks and the active cron count are compared before and after. The claim is held to 300 ms.
- No drop. Spend: US$0.
- The three safety rules from s885 still hold:
  - insert-only (no course rule or lock overwritten);
  - strict study-level tiers;
  - regulated disciplines held in Layer 4.

## 4. Validation before merge

- **Specs:** s895 and s896 5 of 5; s884, s885 and s886, s42, s57, s120 and the AI-models spec pass.
- **Rolled-back live dry run:** the PR's labelled dry run.

## 5. After merge (closing record)

(Filled in by the closing record.)

## 6. Comments and replies
