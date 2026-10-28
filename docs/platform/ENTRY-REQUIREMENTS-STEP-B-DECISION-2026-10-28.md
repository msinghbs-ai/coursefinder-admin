# Track C Step B — bounded RMIT vertical slice: decision record

**Lodged 28 Oct 2026, before any Pilot change.** Platform Admin mandate of 28 Oct 2026 20:36 ("return to the approved plan and deliver Track C Step B end to end today"), with the Platform Admin's answers of 28 Oct 2026 (below, section 2).

**Scope authority:** `docs/platform/ENTRY-REQUIREMENTS-IMPLEMENTATION.md`, Parts 2.3–2.5, and decisions 7–10 (25 Oct 2026 14:50). This record applies that plan to one bounded slice. It is not a new plan, roadmap or recovery programme.

## 1. What "Step B" means here

The mandate's B1–B5 are the course-level and serving parts of the approved plan:

| Label | Plan section | What it is |
|---|---|---|
| B1 | 2.3 (and the B1 spec in `nz-enrichment-brief/2026-10-24-nz-field-admission.md` section 5) | Course-level extraction into `catalogue.course_entry_requirements` |
| B2 | 2.4 | Additive consumer API keys on the existing course and provider payloads |
| B3 | 2.4 / ENTRY-REQUIREMENTS.md Part C | `edu_country` |
| B4 | ENTRY-REQUIREMENTS.md Part C, 2.4 developer pack | The consumer course display |
| B5 | Part 2 (admission and review) | The admin entry-requirements interface |

Two label clashes are noted, not acted on:
- The plan's own build-order "Step B" (2.5) is the PDF matrices. It is **not** part of this slice and stays unbuilt.
- The design's "B4" (`ENTRY-REQUIREMENTS.md` section A) is the scholarship minimum-academic field. It is **excluded** here (mandate: no new scholarship AER fields).

## 2. Evidence and the course chosen

**Course:** RMIT **Bachelor of Engineering (Honours)**, BH126.
- Catalogue course `09431698-3cfd-4c2b-8669-e924bc65c329`, CRICOS `0100714`, level BH, open to international students.
- Bound page: `https://www.rmit.edu.au/study-with-us/levels-of-study/undergraduate-study/honours-degrees/bachelor-of-engineering-honours-bh126`
- Identity proof: `cricos_code`.
- Stored copy: `source_snapshot`, captured 5 Oct 2026 12:53 UTC (text/html, gzip).

**Country:** India (IN). RMIT has 33 active India rows:
- 18 Bachelor band-ladder rows (bands 65%–90%);
- 9 Diploma/Associate rows;
- 6 Foundation / University Pathways Fast Track provider minimums.

**What the page publishes**, checked against the live page while choosing the course. The stored copy is what the reader reads, and every quote is checked against it.
- "2027 Guaranteed ATAR 75.00".
- VCE Units 3 and 4 prerequisites: English (study score 25, or 27 in EAL) and a mathematics study score of 20.
- Ranking and adjustment-factor rules.
- **No percentage band.** No sentence naming international applicants' academic requirements.

RMIT's India page says to "Locate the Australian score required for your preferred RMIT program". Its "Australian standard" column is printed in bands (50%–90%).

**Platform Admin decision (28 Oct 2026), option 2 — no mapping, honest fallback:**
> "Do not infer that Guaranteed ATAR 75.00 means RMIT's "75%" band. Store the printed ATAR as the course minimum with its exact basis and audience. For India, the resolution must fall through to step 5, "contact RMIT", because no source-supported band relationship exists. Continue building the slice with that honest result. Prove the band-ladder rule independently with valid fixtures/tests; do not claim this course demonstrates a live band-ladder resolution."

**Platform Admin decision (28 Oct 2026), B4 — developer pack only:**
> "The plan assigns consumer rendering to the website team. Deliver the additive API payload, rendering specification, resolution rules and worked example using the actual admitted data. Do not build an admin "consumer preview" and do not invent or locate another consumer repository. Record the consumer course-page rendering as website-team integration work. Therefore, report the platform Step B slice accurately; do not claim that a live consumer course-page display has shipped until the website team implements and verifies it."

**Expected example result (BH126, India):**
- Steps 1–4 find nothing source-supported:
  - no override;
  - no per-course India row;
  - no printed band, so the band ladder cannot be entered;
  - RMIT publishes no band-free Bachelor minimum for India.
- Step 5 then answers "Requirements for your qualification aren't published — contact RMIT".
- The resolver output says the provider does publish an India band table, but the course names no band to enter it with. The display must never read that as "no data".

## 3. Existing objects reused (no rebuild of Step A)

| Object | Use |
|---|---|
| `catalogue.course_entry_requirements` (0 rows today) | B1 rows; existing kinds, statuses (`proposed`, `active`, `inactive`, `superseded`), checks for a value needing a scale and a score needing a basis |
| `catalogue.provider_entry_matrix` (RMIT 343 active, 37 proposed, 20 quarantined) | Read only, by the resolver, admin view and API. Nothing in it is changed or admitted |
| Enrich fields lane: `pipeline.admin_jobs` kind `enrich_fields`, `pipeline.field_enrich_items`, `security.enrich_fields_slice_v1`, `security.enrich_ai_fire_v1`, worker mode `enrich_ai`, `public.svc_enrich_ai_next` / `svc_enrich_ai_record` | B1 reader. One new field code, `entry_requirements`. No new lane, job or worker mode |
| `pipeline.field_source_rules` | AU `entry_requirements` → `{ai_stored}` (stored course page only) |
| `pipeline.coverage_admission_countries` | AU gains `identities.entry_requirements` = `cricos_code`, `adapter_code`, `manual` (the strong proofs tuition uses) |
| `pipeline.layer4_review_items` + `security.layer4_review_decide_impl` | Human admission. New field code `course_entry_first_read` (entity course), decided by the existing Layer 4 actions; not a new status |
| `entry.matrix_model` (pinned `openai/gpt-4.1-mini`) | The one entry model, also for the course read |
| `pipeline.platform_toolset_settings` | New settings below; G2 |
| Existing admin Provider drawer and Course detail blade | B5 sections (no new dashboard) |
| `public.website_v2_course`, `public.website_v2_provider`, edge function `website-api-v2` | B2/B3 (consumer change, paste-reviewed) |

**Additive columns:** none are needed. The canonical model is already in place (Step A built every column in plan 2.1).

## 4. B1 — course-level extraction

**Field.** `entry_requirements` on the existing Enrich fields lane. It is **not** added to the field registry (`security.enrich_fields_v1`). So the standing gap queue, the automatic plans and Read with AI never ask for it. It is read only for a course a person (or this decided slice) names.

**Start.** `public.admin_entry_requirements('read', {course_id, reason})`:
- Platform Admin only (rank 6);
- one course per request, from a country in `entry.course_read_countries` (`["AU"]`);
- creates one `enrich_fields` task with one item. It reads the stored copy in use: no re-fetch, no Firecrawl and no fee re-check.

**The slice read.** The migration enqueues exactly one such item, for BH126, count-guarded (nothing if the course already has an entry item). The existing enrich tick then reads it. Expected cost is under US$0.02 (one call on a 60,000-character page at `gpt-4.1-mini` prices).

**Worker.** One AI call per course for this field, with its own prompt and schema:
- rows of `kind`, `audience`, `description`, `min_entry_score`, `min_entry_score_basis`, `benchmark_band`, `min_grade`, `confidence` and `quote`;
- page text up to `entry.course_page_chars`;
- each row's quote must be on the stored page, or the row is dropped (`quote_not_on_page`).

**Database admission rules** (`security.enrich_entry_record_v1`):
- **Identity:** AU proof `cricos_code`, `adapter_code` or `manual` only.
- **Kinds allowed:**
  - `minimum_grade` (course minimum score, with `min_entry_score` and its basis);
  - `subject_prerequisite`;
  - `portfolio_interview` (selection tasks);
  - `prior_qualification`;
  - `work_experience`;
  - `override` (only where the page states one);
  - `general_note`.
- **No numeric score without its basis:** the score's number and the basis words must both be printed in the quote (`score_without_basis`).
- **Band:** kept only when the quote prints it exactly. Otherwise it is null and the row is kept (`band_not_printed` noted). A band is never derived from an ATAR.
- **No English duplication:** a row naming an English test (IELTS, TOEFL, PTE, Duolingo, Cambridge, OET) or "English language requirement / proficiency" is dropped (`english_duplicate`). A school-subject prerequisite in English (VCE English study score) is an academic prerequisite and is kept.
- **Audience:**
  - `international` only when the quote names international or overseas applicants;
  - `domestic` when it names an Australian domestic route (VCE, ATAR, VTAC, STAT, Australian Year 12) and not international applicants;
  - otherwise `all`, meaning "published without naming a group". International applicability is never inferred.
- **Limits:** confidence ≥ `entry.min_confidence`; at most `entry.max_rows_per_course` rows.
- **Provenance:** reader, item, task, model, worker, prompt version. Evidence is the bound page's stored copy; `as_at` is its capture date.

**Human admission.**
- The rows land `proposed`, with one Layer 4 item `course_entry_first_read`. The enrich item goes to `review`.
- Approving admits the whole read and supersedes earlier reader rows for the course.
- Reject, more evidence or a return makes the rows `inactive`.
- Nothing is auto-approved. The 37 proposed RMIT matrix rows are untouched; they remain a separate Layer 4 task.

**Settings (G2, Settings › Pipeline settings › Entry requirements):**

| Key | Default | Range | Used by |
|---|---|---|---|
| `entry.course_read_countries` | ["AU"] | list | `admin_entry_requirements` read |
| `entry.max_rows_per_course` | 6 | 1–10 rows | `security.enrich_entry_record_v1` (B1 spec) |
| `entry.min_confidence` | 0.8 | 0.5–1 | `security.enrich_entry_record_v1` (B1 spec) |
| `entry.course_page_chars` | 60000 | 10000–120000 characters | worker `enrich_ai` (entry_requirements) |
| `entry.level_equivalents` | ["BH=BA"] | list of `course level=matrix level` | `security.entry_resolve_v1` (an honours bachelor uses the provider's "Bachelor degrees" rows) |

## 5. Five-rule resolver (`security.entry_resolve_v1(course, country)`)

The resolver is a pure lookup over **active** rows only. It never calculates eligibility.

1. **Course override:** an active `override` row of the course (audience international or all; the country, or no country).
2. **Per-course matrix row:** active matrix rows with `course_id` = the course, for the country.
3. **Band ladder:** the course's `benchmark_band` (from an active course row whose quote prints it) → the provider's active `band_ladder` rows for that band, country and course study level (or its `entry.level_equivalents`).
4. **Provider minimum:** the provider's active `provider_minimum` rows for the country and the course study level (or its equivalents).
5. **Contact the provider:** "Requirements for your qualification aren't published — contact the provider". Never invented.

**Output:**
- `outcome` is one of:
  - `minimum_published` — the rows carry a minimum;
  - `case_by_case` — a published row without a minimum: `min_grade` null, `scale` `none`. It renders as "this qualification is considered case by case" (decision 10), never as "no data", "contact provider" or a pass;
  - `contact_provider` — no published applicable row.
- `step` (1–5), `rule`, and the rows (qualification, minimum, scale, band, level, conditions, quote, `as_at`, edition).
- A `note` saying why a step could not apply (for example "the provider publishes a band table for this country; the course page prints no band").

## 6. B5 — admin interface (existing surfaces)

| Where | What |
|---|---|
| Catalogue › Providers › provider drawer, section **Academic entry requirements** | Matrix rows with filters (country, level, status: active, proposed, inactive, superseded), 50 a page. Columns: country, level, qualification, band, minimum, scale, conditions, quote, source link, evidence, `as_at` / edition, status and reason, run (state, hold or error) |
| Course detail blade, section **Academic entry requirements** | The course's rows (all statuses, with quote, source, evidence, `as_at`, audience, the Layer 4 item); the resolver for a chosen country (existing country reference list); the Platform Admin action "Read from the stored page" (with a reason) |

**Read path.** One RPC, `public.admin_entry_requirements(action, args)`, with actions `provider_matrix`, `course`, `resolve` and `read`.
- Reads are rank ≥ 1 (assigned role) and paged: at most 100 rows a call, always for one provider or one course.
- `read` is rank 6.
- There is no table editing, no arbitrary SQL and no second approval route. Admission stays in Layer 4.

## 7. B2 / B3 — consumer API (additive; paste-reviewed exception)

**Approval held:** Platform Admin 25 Oct 2026 14:36 / 14:50 (decision 7). Per the mandate and AGENT-OPERATING-MODEL rule 9 exception, the change comes to the Platform Admin as a paste file with a held PR, and is **never auto-merged**.

**Course payload** (`website_v2_course`). The item gains `entry`:

```
entry: {
  min_score, min_score_basis, benchmark_band,
  prerequisites: [{text, quote}],
  selection_tasks: [{text, quote}],
  requirements_note,
  resolution
}
```

- `min_score` / `min_score_basis` come from an active `minimum_grade` row with `min_entry_score`. The basis is as printed (e.g. "2027 Guaranteed ATAR").
- `benchmark_band` is non-null only when printed.
- `requirements_note` is the text of an active `general_note` or `override` row.
- `resolution` is the section 5 output for `edu_country`, and null when no country is given.
- Null means "not held" (Website API v2 rule).

**Provider payload** (`website_v2_provider`). The item gains `entry_matrix`:

```
entry_matrix: [{country, study_level, qualification, min_grade, scale, band, course_code?, conditions, as_at}]
```

These are active rows only. `study_level` is the provider's own label; `course_code` appears only on per-course rows.

**`edu_country` (B3):**
- Optional ISO 3166 alpha-2, checked against the existing `ref.countries`. An unknown code is `INVALID_INPUT`.
- On the course call it fills `entry.resolution`. On the provider call it narrows `entry_matrix` to that country.
- It is passed by the `website-api-v2` edge function to new two-argument forms of the same two payload functions. The one-argument forms keep their exact output plus the new key.
- Search is unchanged: the plan defines `edu_country` on the course and provider calls only. The website keeps the student's country in its session and passes it to those calls (Part C).

**Release obligations:**
- no existing key renamed, removed or retyped;
- `tests/uat/consumer-api-baseline.json` updated and `security.consumer_api_rebaseline_v1` re-taken in the paste;
- the developer guide reissued (section 13: the new fields and `edu_country`);
- the rendering note folded in;
- the worked example written from admitted rows only, after the Layer 4 admission.

## 8. B4 — consumer display

This is the website team's integration (Platform Admin, 28 Oct). We deliver:
- the payload;
- the rendering specification (`docs/integrations/developer-pack/ENTRY-REQUIREMENTS-RENDERING-NOTE.md`, extended);
- the resolution rules;
- the worked example from admitted data.

No consumer page is built here, and none is claimed live until the website team ships and verifies it.

## 9. Tests, migrations and gates

**Specs** (each `// Guards: … Track C Step B decision 28 Oct 2026`, registered under G4):
- **s114** — resolver contract: rule order, active rows only, case-by-case kept, contact-provider fallback, `edu_country` narrowing, no eligibility arithmetic.
- **s139** — B1 reader and admission:
  - field not in the registry;
  - stored page only;
  - quote on page;
  - no score without a basis;
  - no English duplication;
  - audience rule;
  - Layer 4 routing;
  - settings, not constants;
  - a bounded, count-guarded slice enqueue.
- **s140** — B5 admin reads: bounded and paged; rank checks; no table writes except the `read` request.
- **s113** — consumer additive keys and the baseline update (in the held consumer PR).

G2 / G3 / G4 / housekeeping stay with their central specs (s32, s57, s120, s42).

**Live dry runs, rolled back:**
- each migration, before merge;
- the resolver over fixtures in one rolled-back transaction, proving rules 1–5 separately. The band ladder is proved with a fixture course row whose quote prints a band, joined to RMIT's real active India rows. Also proved: `case_by_case` and `edu_country` narrowing.

**Gates:**
1. **Platform PR** (B1, resolver, B5): rule 9 — suite green with 0 failed and 0 skipped, live md5 of every edited function, dry run, change control written; then merge and deploy verification.
2. **The slice read** runs on the existing tick. **Human gate:** the Platform Admin decides the Layer 4 item `course_entry_first_read` for BH126.
3. **Consumer PR** (B2/B3): **human gate.** The Platform Admin applies the paste and approves the held PR.
4. **Worked example and developer guide:** after gates 2 and 3.

## 10. Exclusions (mandate)

Not part of this slice:
- AER PR B; Norway, UK, Nigeria and Vietnam;
- China and Germany quarantine remediation;
- the IB, GAC and Foundation-equivalency pages;
- any new RMIT country read or RMIT recovery;
- PDF, JavaScript-only or new-provider coverage;
- Step C automation;
- scholarship AER fields;
- unrelated Layer 4 triage, fees, scholarships or enrichment;
- new status values, parallel AER tables, new readers, uncounted jobs and arbitrary SQL.

**The 37 proposed RMIT matrix rows are not touched.**

## 11. Platform Admin decisions, 28 Oct 2026 22:44 (recorded before any further Pilot change)

1. **BH126 65% band, accepted as source support.** The sentence "You must have successfully completed a qualification recognised by RMIT as equivalent to the Victorian Certificate of Education (VCE) with a minimum average of 65%" is accepted as explicit source support for this course's 65% Australian-standard band.
   - This is not an ATAR conversion. Mapping Guaranteed ATAR 75.00 to a 75% band stays forbidden.
   - A 65% band may be stored only with that exact quote, in the BH126 academic-entry context.
   - It is not a provider-wide rule and creates no inference rule.
2. **"2026 ATAR 73.00".** It is a previous year's figure and must not be admitted as the current 2027 course minimum. It is excluded through the existing Layer 4 decision path.
3. **2027 Guaranteed ATAR 75.00.** Still required, with a verbatim on-page quote: no manual insert, no fixture as live data, no paraphrased quote.
4. **One bounded BH126 re-read.** The existing "Read from the stored page" action, with the current deployed reader (v0.49.1):
   - no reader-code change, no new provider, no RMIT matrix change, no recovery;
   - if valid, admit it in Layer 4 excluding the 2026 ATAR row, and reconcile item `cf71cca1` through its review path (no SQL, no duplicate active rows);
   - if one re-read cannot keep the required exact quotes, stop at the evidence gate. No repeated rereads.
5. **Consumer paste.** Applied once by the Platform Admin. Verify it, then merge draft PR #720 under its consumer-change authority once green, and verify the edge function deploy and release currentness.
6. **Developer pack.** Written from admitted live rows only.

**Claim allowed:** "Track C Step B platform RMIT vertical slice live", only after these checks pass. Consumer course-page rendering stays website-team work.
