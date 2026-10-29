# D5 design note: `scale_stated` marker on Website API v2 entry rows

**Lane:** D5 · **Branch:** `cf247-d5-lane` from `origin/main` c4c49979 · **Date:** 30 Oct 2026
**Authority:** Platform Admin approval 30 Oct 2026 08:45 (D5), under decision A4 (admin `docs/platform/AER-OPERATIONS-WORKSPACE-DECISION-2026-10-29.md` §9) and register row O9.
**Status:** design only, for lodging. Nothing is built or applied. All figures below were read live from `fxcwkweaxjtknorudmwp` on 30 Oct 2026 (read-only queries).

---

## 1. Where an entry grade reaches a consumer today

### 1.1 Database functions (live md5 of `pg_get_functiondef`)

| Function | Live md5 | In consumer baseline? | Carries a grade? | D5 change |
|---|---|---|---|---|
| `public.website_v2_course(text)` | `50d22c3ccfc2a00bedb5c9cee762eec4` | yes (matches) | via `entry` (calls `entry_course_payload_v1(id, null)`) | **none** |
| `public.website_v2_course(text,text)` | `1c10b34fc4ea57398638d26ac9e21279` | yes (matches) | via `entry.resolution` | **none** |
| `public.website_v2_provider(text)` | `0894cdb1d4b14ac8af2f5aa07c9f7ebb` | yes (matches) | via `entry_matrix` (calls `entry_matrix_payload_v1(pid, null)`) | **none** |
| `public.website_v2_provider(text,text)` | `3f622be6721d89289866c459cf178079` | yes (matches) | via `entry_matrix` narrowed | **none** |
| `security.entry_course_payload_v1(uuid,text)` | `80fdfabb84a90fab25df36970dea696a` | no | `min_score` + `min_score_basis` (basis always printed, B1 rule); `resolution` from the resolver | **none** |
| `security.entry_matrix_payload_v1(uuid,text)` | `be5478d0402620cbc4c701a1e590856e` | no | `min_grade`, `scale` per matrix row | **adds `scale_stated`** |
| `security.entry_resolve_v1(uuid,text)` | `492ece033520ad81cd0046c5a851bedb` | no | `rows[]`: steps 2–4 `min_grade`, `scale`, `case_by_case`; step 1 `min_grade`, `min_score`, `min_score_basis`, `case_by_case` | **adds `scale_stated`; makes `case_by_case` null-safe** |

The four `public.website_v2_*` functions are **not edited**: the marker is shaped inside the two `security.*` payload parts they already call, so their md5s (and the consumer baseline rows for them) stay byte-identical. `website_v2_sync`, `website_v2_providers` and `website_v2_course_search` carry no entry requirements and are untouched.

Admin-only readers of the same columns (`public.admin_aer`, `public.admin_entry_requirements`, `security.aer_row_v1`, `security.aer_review_read_v1`) are not consumer surfaces and are not changed by the marker itself (see §6 for the optional recording path).

### 1.2 Edge functions (repo sha256 = `tests/uat/consumer-api-baseline.json`)

| Edge function | sha256 (repo, = baseline) | Live version / ezbr | Entry data | D5 change |
|---|---|---|---|---|
| `website-api-v2` | `a833301f…3a4660` | v3 / `ea8d8ec5…` | passes `item` through unchanged; only passes `edu_country` | **none** (does not shape the field) |
| `wix-course-api` | `c7e1182b…a071a0ee` | v7 / `37aca28a…` | calls one-argument `website_v2_course` / `website_v2_provider` and passes `item` through, so it already returns `entry` (no resolution) and `entry_matrix` | **none** to code; its `entry_matrix` items gain the key automatically (stated explicitly here because it is a consumer) |
| `website-course-api` | `463457cb…f899ba413` | v3 / `beaebbd2…` | no entry data | none |
| `zoho-api-v2` | `187f5e70…fbde264` | v5 / `891bd9b1…` | no entry data (role guide 6.3) | **untouched** |
| `zoho-course-api` | `c621615…3036b192` | v14 / `9bfff460…` | no entry data | **untouched** |

No edge function is changed, so the five sha256 values in `consumer-api-baseline.json` stay as they are; only its `note` gains the D5 approval line.

### 1.3 Governance gap found (not fixed by D5; for the integrator)

`security.entry_matrix_payload_v1`, `security.entry_course_payload_v1`, `security.entry_resolve_v1` and the tables `catalogue.provider_entry_matrix` / `catalogue.course_entry_requirements` are read by the consumer API but are **not** in `pipeline.consumer_api_baseline` (123 rows; `security.consumer_api_functions_v1()` lists only the `public`/`api` entry points). So job `consumer-api-guard` would not see a change to the entry payload shape. D5 goes through the full G3 process regardless. Adding these to the guard's lists is a separate change needing its own approval.

---

## 2. Semantics

### 2.1 The three-way distinction (per row)

| Row state (stored, active) | `min_grade` | `scale` (unchanged key) | `case_by_case` (resolution rows, unchanged meaning) | **`scale_stated`** |
|---|---|---|---|---|
| Printed grade **with** a stated scale | printed | `percentage` / `points` / `aggregate` / `gpa` / `letter` / `rank` | `false` | **`true`** |
| Printed grade **with no stated scale** (A4) | printed, as printed | `null` (not held) | `false` | **`false`** |
| Case by case (no minimum stated) | null, or the provider's words | `"none"` | `true` | **`null`** |
| No published requirement | no row (resolution step 5, `rows: []`) | — | — | — (no row) |

Choice: **`null`, key always present**, not absent, for case by case.
- It keeps every `entry_matrix` item and every `resolution.rows[]` item the same shape, which suits the website's stored collections; the only key that is ever absent today is `course_code`, and that marks a different kind of row (one course), not a value.
- It follows "null means not held": for a case-by-case row no minimum on a scale exists, so there is no scale statement to hold. `false` is never a default; it appears only where a person has recorded "no scale stated on the page".
- The website rule is then one test: show the A4 wording **only when `scale_stated === false`**. `true` and `null` keep today's rendering.

`scale_stated: false` rows are **not** case by case: a minimum is published. The resolution `outcome` for such a row is therefore `minimum_published` (an existing value; no new outcome is added).

### 2.2 Placement

- **Provider detail `entry_matrix[]` items:** one new key `scale_stated`, beside `scale`.
- **Course detail `entry.resolution.rows[]` items:**
  - steps 2–4 (matrix rows): `scale_stated`, computed as for `entry_matrix`;
  - step 1 (course override rows from the course page): `scale_stated: null`. Course-page rows hold no scale: their score is always held with its printed basis (`min_score_basis`, B1 rule), and `catalogue.course_entry_requirements.grade_scale` is never written by the course reader (null on all 3,334 rows), so it must not be read as "not stated".
- **Course detail `entry` top level:** no change (`min_score` always carries its printed basis).
- `search`, `sync`, `providers`, `reference`: no change.

### 2.3 No existing key changes meaning

- `scale`: unchanged expression in both functions. It is already `null` for a row whose stored scale is null; such a row cannot exist today (0 rows). From D5 on, `null` is the documented "scale not held" value under the API-wide rule "null means not held". `"none"` keeps meaning "no minimum stated" (case by case).
- `case_by_case`: same meaning ("states no minimum on a scale": `min_grade` null or `scale` `"none"`). The expression becomes null-safe (`m.grade_scale is not distinct from 'none'` instead of `= 'none'`) so a no-scale row gives `false`, not JSON `null`, and does not fall through to an outcome of `case_by_case`. For every row that exists today the value is identical (no stored scale is null).
- `outcome`, `step`, `rule`, `note`, `contact`, `min_grade`, `band`, `conditions`, `as_at`, `quote`, `edition`: unchanged. The dry run (Step 2) will show every pre-existing key byte-identical.

---

## 3. How it is computed (stored data only, no inference)

The stored representation of "printed grade, no stated scale" is a matrix row with **`min_grade` printed and `grade_scale` null** (and therefore `min_value` null: the existing check `provider_entry_matrix_value_needs_scale` already forbids a numeric value without a real scale, so no number is ever held without its scale).

```sql
'scale_stated', case when m.min_grade is null or m.grade_scale = 'none' then null   -- case by case
                     else m.grade_scale is not null end                              -- true: a scale is held; false: none stated
```

- No text is parsed, no scale guessed, no percentage, ATAR conversion or band produced. The marker reads only `min_grade` and `grade_scale` as a person admitted them.
- `true` means "the admitted row carries a scale". It does not re-check the page. Rows admitted before A4 (30 Oct) were checked against "a number has its scale" (role guide 5.2); a row later found to carry a reader-assigned scale is corrected by a person (§6), never by the marker.
- `grade_scale` null is never written by any path today (reader and workspace both use `coalesce(…, 'none')`), so null is free and unambiguous for matrix rows. It is **not** used for course-page rows (§2.2).

---

## 4. Live counts (30 Oct 2026)

**Active matrix rows (what the API returns): 343, all RMIT (`provider:cricos:00122a`).**

| Class | Rows | Marker after D5 |
|---|---|---|
| Printed grade, stated scale | **310** (percentage 156, points 74, GPA 58, letter 22) | `true` |
| Printed grade, no stated scale | **0** (no stored form exists yet; A4 rows are excluded in Layer 4) | `false` |
| Case by case | **33** (all with the provider's words in `min_grade`, scale `none`: 17 without a digit, for example "Completion of High School Diploma"; 16 with a digit, for example "Achieved NCEA Level 3 with Merit average"; 0 with `min_grade` null) | `null` |

So on the day D5 applies, the live payload changes only by the new key (`true` on 310 rows, `null` on 33); no row shows `false` until a person records one.

**Not reaching the API (context):**
- 20 RMIT China Gao Kao rows are `unverified`, quarantined 27 Oct as "bare numbers with no printed scale" (scale `points`, `min_value` held, for example 375, 397, 419). These are the first real A4 candidates. They become `scale_stated: false` only if a person corrects them (scale not stated, value cleared) and restores them; D5 does not touch them.
- 2,205 proposed matrix rows: 264 have printed `min_grade` with scale `none`, of which 60 contain a digit (for example "1st Division"); 422 have no `min_grade` and scale `none`. Classifying them is Layer 4 work under role guide 5.2.
- Course-page rows: 0 active, 3,334 proposed; `grade_scale` null on all (course reader stores no scale).

---

## 5. Files (Step 2)

### 5.1 Code repo (this branch)

| File | Content |
|---|---|
| `supabase/migrations/20261030XXXXXX_cf247_d5_scale_stated_marker.sql` (unnumbered; integrator numbers) | Header with `-- Consumer API change approved: Platform Admin, 30 Oct 2026 08:45 (D5): additive Website API v2 marker scale_stated on entry_matrix items and entry.resolution rows; no existing key changed; decision A4 wording; applied by the Platform Admin through the paste-reviewed consumer-change process`, `-- Replaces: security.entry_matrix_payload_v1, security.entry_resolve_v1 (same names, md5-guarded edits)`, `-- Retires: nothing`. `pg_temp.edit_n` md5-guarded edits: `security.entry_matrix_payload_v1(uuid,text)` guard `be5478d0402620cbc4c701a1e590856e`, one edit ×1 (the line holds `\r\n`; the edit fragment stays inside one line); `security.entry_resolve_v1(uuid,text)` guard `492ece033520ad81cd0046c5a851bedb`: step-1 row gains `'scale_stated', null` ×1; steps 2–4 row `'case_by_case', m.min_grade is null or m.grade_scale = 'none')` → null-safe plus `'scale_stated', …` ×1. Updated `comment on function` for both. No table, column, job, setting or status. `component_register` rows unchanged (same names). Ends with `select security.consumer_api_rebaseline_v1('D5 (30 Oct 2026): additive scale_stated marker …; approved Platform Admin 30 Oct 2026 08:45')`. No `drop`, `rename`, `alter column`. |
| `tests/uat/consumer-api-baseline.json` | `note` gains the D5 line; the five sha256 values unchanged (no edge function changes). |
| `tests/uat/cf-247-s182-entry-scale-stated-marker-contract.spec.mjs` (s180 and s181 go to the other lanes) | `// Guards: Platform Admin approval 30 Oct 2026 08:45 (D5) under decision A4 (admin AER-OPERATIONS-WORKSPACE-DECISION-2026-10-29.md §9; register O9): additive scale_stated marker on Website API v2 entry_matrix items and entry.resolution rows; printed grade without a stated scale distinct from case by case and no published requirement; no inferred scale; no existing key changed (G3 itself is guarded by s57)`. Asserts: approval line; md5 guards and edit counts; the exact `scale_stated` expression in both functions; step-1 `scale_stated` null; null-safe `case_by_case`; existing key expressions (`'scale', case when m.min_grade is null then 'none' else m.grade_scale end`, etc.) still present unchanged; no `website_v2_*` function or edge file edited; no text parsing / scale words / ATAR / band arithmetic in the new code (no regex on `min_grade`/`quote`); rebaseline call. **Resolver fixtures**: a table of fixture rows (stated, no-scale, case-by-case with words, case-by-case with null grade) with expected `scale`, `case_by_case`, `scale_stated` and `outcome`, evaluated by a small JS mirror of the two SQL expressions *and* matched against the literal SQL text, so the fixture and the migration cannot drift; the same fixtures are what the live dry run checks. |
| `tests/uat/cf-247-s113-…`, `s114-…` | Unchanged and still pass (they read their own migrations, which are not edited). `cf-247-website-api-v2-contract` and `cf-247-institution-type-contract`: unchanged, must stay green. |
| Test register | Regenerated with `node scripts/test-register.mjs` (one spec added); output handed to the integrator for the admin repo. |
| `D5-devguide.md`, `D5-requirements-O9.md`, `D5-role-guide.md` (worktree root) | Admin-repo text drafts (below); integrator commits. |

### 5.2 Developer guide (issue 6) — draft text

§7.9, after the `entry_matrix[]` field list and in the `resolution` `rows[]` row:

> `scale_stated` (in each `entry_matrix` item and each `resolution.rows[]` item): whether the provider states the grading scale of `min_grade`.
> - `true`: the scale is stated; show the row as today, with its `scale`.
> - `false`: the provider prints a grade but states no grading scale on the page. `scale` is `null`. Show: **"Published requirement: [min_grade]. The provider does not state a grading scale on this page; check the source or contact the provider."** Do not add a percentage, an ATAR equivalent, a band or any other scale.
> - `null`: no minimum on a scale is stated (case by case, `scale` `"none"`); render as case by case. A step 1 row (the course's own rule) always has `null`.
>
> A row with `scale_stated` `false` is not case by case: `case_by_case` is `false` and the `outcome` is `minimum_published`.

Example (shape only; no live row yet, so it is labelled as illustrative): one `entry_matrix` item with `"min_grade": "375", "scale": null, "scale_stated": false`. §7.9 measured examples refreshed with the new key (`true` on the India percentage rows, `null` on the Taiwan `none` row). Acceptance test 23: "`provider` `provider:cricos:00122a` returns `scale_stated` on every `entry_matrix` item (`true` or `null` on 30 Oct 2026); a row with `false` is shown with the 'does not state a grading scale' wording". `gen_api.py`: no field list for entry rows today, so no change; OpenAPI and Postman rebuilt by `build.sh` with the issue date.

§13 line:
> | DD Month 2026 (issue 6) | `entry_matrix[]` items and `entry.resolution.rows[]` items gain `scale_stated`: `false` when the provider prints a grade but states no grading scale (show the "does not state a grading scale" wording; `scale` is `null`), `true` when a scale is stated, `null` for case by case. Section 7.9 and acceptance test 23 updated |

`ENTRY-REQUIREMENTS-RENDERING-NOTE.md`: one paragraph with the same three-way rule.

### 5.3 Register O9 update — draft text

O9 row: **Done (D5, migration `20261030XXXXXX`, guide issue 6)**: "Website API v2 `entry_matrix[]` items and `entry.resolution.rows[]` items carry `scale_stated` (`false` printed grade with no stated scale, `true` stated scale, `null` case by case). Computed from the admitted row (`min_grade` printed, `grade_scale` null); nothing inferred. Rendering stays with the website team (guide §7.9). On 30 Oct 2026: 310 rows `true`, 33 `null`, 0 `false`." Version 2.5 header and a History line.

### 5.4 Role guide — draft text

- **1.4 Scale:** add "No scale stated: a printed grade whose page states no scale is held with the grade as printed and no scale (shown 'Not stated on the page'); the API marks it `scale_stated: false`. Different from `none` (case by case)."
- **5.2 A4 block:** replace "Until the API carries a marker … excluded" with: exclude a row with an inferred scale (unchanged, Approve except, reason "no grading scale stated on the page"); then a Curator records it correctly (3.1 / 3.3) with scale "Not stated on the page" and no numeric value, which reaches the website with the A4 wording. *(If the recording path in §6 is not approved, the exclusion rule stays as it is and only the 6.x text changes.)*
- **3.5:** add the third case beside "case by case" and "contact the provider".
- **6.1 / 6.2:** `scale_stated` in what reaches the consumer; the website renders `false` with the A4 wording; Zoho unchanged.

---

## 6. Decision needed before Step 2: how a "no stated scale" row gets stored

The marker is computed from stored data, but **no path writes a matrix row with a printed grade and no scale today** (reader and workspace both force `none`), so without a recording path `scale_stated: false` can never appear and reviewers must keep excluding A4 rows.

| Option | What | Effect |
|---|---|---|
| **R0** consumer marker only | §5 exactly | API and docs ready; `false` never appears until a later change; role guide keeps "exclude". |
| **R1** (recommended) marker + governed workspace recording | `public.admin_aer` matrix edit and add accept scale `not_stated` → stores `grade_scale` null; allowed only with `min_grade` printed and `min_value` null; same reason, audit and optimistic-concurrency path as other edits; `src/AerWorkspace.jsx` adds "Not stated on the page" to the scale list. md5-guarded edit of `public.admin_aer` (admin, not consumer). | A person can record A4 rows (for example the 20 quarantined Gao Kao rows, after checking the page); nothing changes automatically. |
| R2 | R1 plus the matrix reader emitting "no scale" instead of a guessed one | Needs a worker change and redeploy in `coverage-sweep`; larger; separate lane. |

Recommendation: **R1** within D5 (small, admin-side, keeps "no admission is automatic"); R2 later. Please confirm R0 or R1 with "proceed".
