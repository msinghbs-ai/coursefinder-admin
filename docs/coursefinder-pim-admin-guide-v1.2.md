# CourseFinder PIM Admin Guide v1.2

**Status:** LIVING GOVERNANCE GUIDE — INTAKE / ENGLISH SEMANTICS UPDATE  
**Date:** 20 August 2026  
**Supersedes:** `docs/coursefinder-pim-admin-guide-v1.1.md` for current semantic guidance  
**Change Control:** `CF-CHG-20260820-001`, `CF-CHG-20260820-008`, `CF-CHG-20260820-009`  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.37.md`

This version carries forward all unchanged v1.0/v1.1 governance rules and extends the Course-detail contract for Intake and English entry requirements.

## Course Intakes

### Business meaning

An Intake is a repeatable Course observation describing a source-published opportunity/start period for a Course. It is not a single scalar `Course Intake` field.

**Primary storage:** `catalogue.course_intakes`.

### Grain

The governed observation may contain:

- Course identity;
- Intake year;
- Intake/source label;
- start date;
- application deadline;
- optional Campus scope;
- status;
- confidence;
- source observation key;
- source/evidence.

Multiple Intakes for one Course/year remain multiple observations.

### Campus scope

`campus_id` is optional.

- populated `campus_id` means the Intake has an accepted Campus scope;
- `campus_id=NULL` means **no accepted Campus scope is recorded for that Intake**;
- NULL must not be displayed as `All campuses` unless a separate governed source rule explicitly proves that meaning;
- Provider geography must not be used to fill a missing Intake Campus scope.

### Dates

`intake_year`, `start_date` and `application_deadline` are separate fields.

Do not:

- infer a start date from an Intake label;
- treat the application deadline as an Intake/start date;
- collapse Semester 1 and Semester 2 into a single year-only value;
- invent an application deadline where the source does not supply one.

### Source / evidence / confidence

The Intake source, evidence artifact, evidence capture time/hash, confidence and `source_intake_key` are audit context. Confidence is not approval and does not replace authoritative evidence.

### Admin presentation

Use a repeating **Course Intakes** section. Each row/card should show:

- Intake label + year;
- start date;
- application deadline;
- Campus scope or explicit `No accepted Campus scope recorded`;
- status/confidence as secondary audit metadata;
- source/evidence drill-down.

An empty Intake collection means **No accepted Intake observation loaded**. It does not mean the Course has no real-world Intake.

## English entry requirements

### Business meaning

An English entry requirement is a repeatable Course-level observation associated with a governed English-test identity.

**Primary storage:** `catalogue.course_english_requirements` + `ref.english_tests`.

### Grain

One Course can have multiple accepted test requirements. Each test remains a separate observation.

Examples:

- IELTS Academic;
- PTE Academic;
- TOEFL iBT.

Never merge them into one generic `English score` field.

### Scores

`overall_score` and `component_scores` are distinct.

Examples:

- IELTS overall 6.5 with Reading/Writing/Speaking/Listening minimum 6;
- PTE overall 64 with minimum each 60;
- TOEFL iBT overall 87 with distinct component thresholds.

Do not calculate an overall score from components or substitute an overall score for missing component rules.

### Governed test identity

The test must resolve to `ref.english_tests`. Unsupported/free-text source tests must not be coerced into a known test solely for display convenience.

The Admin should show both the governed test label and enough source/evidence context to audit the mapping.

### Validity / verification

English observations may carry:

- `valid_from`;
- `valid_to`;
- `last_verified_at`;
- status;
- confidence.

`last_verified_at` means the observation was rechecked. It is not human approval.

An open-ended `valid_to=NULL` means no explicit end has been recorded; it must not be rendered as `permanent`.

### Scope

The current canonical English requirement model is Course-scoped. It has no Campus field. Do not invent Campus-specific English requirements from Provider/Campus context.

### Admin presentation

Use a repeating **English entry requirements** section. For each test show:

- governed test name;
- overall score;
- component thresholds rendered readably;
- notes where source-supported;
- status/validity/verification as secondary context;
- source/evidence drill-down.

An empty collection means **No accepted English requirement observation loaded**, not `English not required`.

## Reference case — UQ CRICOS 102784C

Course: Bachelor of Computer Science (Honours)  
CRICOS Course Code: `102784C`

Accepted 2027 Intakes:

1. Semester 1 — 22 February 2027 — application deadline 30 November 2026;
2. Semester 2 — 26 July 2027 — application deadline 31 May 2027.

Both currently have `campus_id=NULL`; Admin must not broaden that to all UQ campuses.

Accepted English requirements:

- IELTS Academic — overall 6.5; all four components minimum 6;
- PTE Academic — overall 64; minimum each 60;
- TOEFL iBT — overall 87; Reading 19, Writing 21, Speaking 19, Listening 19.

All three remain separate observations with UQ source/evidence and governed test identities.

## Consumer rule

Intakes and English requirements are repeating child collections in any curated API/Zoho contract.

Do not create ambiguous scalar fields such as:

- `Course Intake = 2027`;
- `English Score = 6.5`;
- `Campus = All` from NULL scope.

If a downstream system cannot support repeating observations without loss, that field class should remain unadmitted until a governed flattening rule is explicitly designed and UAT-approved.
