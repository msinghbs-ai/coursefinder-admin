# CF-CHG-20260820-009 — Intake and English requirement semantics

**Status:** APPLIED / DB-RPC-SECURITY PASS — FRONTEND PRESENTATION PENDING  
**Category:** 30-admin-pim-ux  
**Initiated:** 20 August 2026 12:35 AEST (UTC+10)  
**Origin chat/workstream:** `M1-PIM-GOV — Field Semantics, Change Control & Admin Guide`  
**Owner:** CourseFinder Admin/PIM governance  
**Change class:** semantic read contract / provenance / one-to-many presentation / security ACL

## Trigger

The Course semantic audit showed that the existing Course-detail payload reduced Intake and English observations to a thin display subset. Canonical storage already retained stronger semantics including source/evidence, confidence, stable source observation keys, optional Campus scope for Intakes, and validity/verification for English requirements.

Flattening these observations to a date/label or test/score hides important business meaning and makes downstream Admin/Zoho interpretation unsafe.

## Semantic decisions

### Intakes

1. Intake is a repeatable Provider-current Course observation, not a scalar Course field.
2. `campus_id` is optional scope. `NULL` means no accepted Campus scope is recorded for that Intake; it does not mean every Campus.
3. `intake_year`, `intake_label`, `start_date` and `application_deadline` are separate concepts.
4. Multiple Intakes for the same year must remain separate observations.
5. Source/evidence/confidence/source observation key are part of the audit contract.
6. A stored Intake does not imply Search/Website/Zoho admission.

### English requirements

1. English requirement is repeatable by governed test identity.
2. Overall score and component thresholds must remain separate.
3. Different tests are alternatives/requirements published by the Provider and must not be merged into one generic English score.
4. `valid_from`, `valid_to`, `last_verified_at`, confidence, source/evidence and source requirement key are part of the observation meaning.
5. Current schema records these as Course-scoped observations; no Campus scope should be invented.
6. `last_verified_at` means re-verification, not approval.

## Reference case — UQ CRICOS 102784C

Course: Bachelor of Computer Science (Honours)  
CRICOS Course Code: `102784C`

### Intakes

Two distinct accepted 2027 observations are retained:

- Semester 1 — start 22 February 2027 — application deadline 30 November 2026;
- Semester 2 — start 26 July 2027 — application deadline 31 May 2027.

Both have `campus_id=NULL`. Admin must display that as **No accepted Campus scope recorded for this Intake**, not `All campuses`.

Both are sourced from The University of Queensland official program pages and retain source/evidence, confidence and source intake keys.

### English requirements

Three separate governed test observations are retained:

- IELTS Academic — overall 6.5 — Reading/Writing/Speaking/Listening minimum 6;
- PTE Academic — overall 64 — minimum each 60;
- TOEFL iBT — overall 87 — Reading 19, Writing 21, Speaking 19, Listening 19.

All are active, Provider-current observations with source/evidence, confidence 1.0, `valid_from=20 August 2026`, open-ended `valid_to`, latest verification timestamp and stable source requirement keys.

## Applied read-contract correction

Pilot migration:

`m1_pim_gov_intake_english_semantics_v1`

Repository mirror:

`supabase/production-migrations/062_m1_pim_gov_intake_english_semantics.sql`

New private role-checked helper:

`security.admin_course_entry_summary(uuid)`

Course detail through `public.admin_read('course_detail',...)` now receives `entry_summary` containing:

- `intakes` with dates/deadlines/Campus scope/status/confidence/source/evidence/source key;
- `english_requirements` with governed test identity/score scale/overall/component scores/status/confidence/validity/verification/source/evidence/source key.

No canonical Intake or English row was rewritten.

## Security correction

The old `public.ui_course_detail(uuid)` remained directly executable by `authenticated` even though the hardened Admin path is `public.admin_read`.

After this change:

- direct authenticated `ui_course_detail` EXECUTE: false;
- direct authenticated private entry-summary EXECUTE: false;
- authenticated `public.admin_read` EXECUTE: true.

## Required frontend presentation

Replace generic raw JSON presentation with dedicated sections.

### Course Intakes

For each Intake show:

- Intake label and year;
- start date;
- application deadline;
- Campus scope, with explicit unscoped state where `campus_id=NULL`;
- status/confidence as secondary context;
- source/evidence drill-down.

Do not collapse the two 2027 UQ Intakes into a single `2027` value.

### English entry requirements

For each test show:

- governed test name;
- overall score;
- component thresholds in readable labels;
- validity and last verification context;
- source/evidence drill-down.

Do not display only a single generic English score and do not merge unlike tests.

## Consumer / Zoho consequence

Both Intakes and English requirements are repeating observation collections. They should be exposed as curated child/repeating objects, not ambiguous scalar Course fields.

Consumer admission remains separately governed.

## UAT

Technical assertions passed for exact `102784C`:

- two Intakes retained separately;
- no Campus scope invented for `campus_id=NULL`;
- Intake source/evidence/confidence/source keys retained;
- IELTS/PTE/TOEFL retained as three governed test identities;
- overall and component thresholds retained separately;
- English validity/verification/source/evidence/confidence retained;
- direct browser execution of legacy Course detail removed;
- canonical rows unchanged.

Detailed evidence: `docs/uat/coursefinder-m1-pim-gov-intake-english-semantics-uat-2026-08-20.md`.

## Closure

**Final status:** OPEN — DB/RPC/SECURITY PASS / FRONTEND PRESENTATION PENDING  
**Closed at:** N/A  
**Outcome:** Intake and English semantics are now available through the governed Course-detail read without flattening provenance or observation grain. Frontend semantic presentation and deployed browser UAT remain required.
