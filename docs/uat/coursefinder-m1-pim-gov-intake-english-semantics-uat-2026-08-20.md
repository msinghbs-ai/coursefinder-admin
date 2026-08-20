# CourseFinder M1-PIM-GOV — Intake and English Requirement Semantic UAT

**Date:** 20 August 2026  
**Change Control:** `CF-CHG-20260820-009`  
**Workstream:** `M1-PIM-GOV — Field Semantics, Change Control & Admin Guide`  
**Status:** **DB/RPC/SECURITY PASS — FRONTEND/DEPLOYED BROWSER UAT PENDING**

## Purpose

Validate that Course Intakes and English entry requirements remain repeatable governed observations with source/evidence and scope semantics, rather than being flattened into ambiguous scalar Course fields.

## Reference identity

Exact Course reconciliation used CRICOS Course Code `102784C` under The University of Queensland. No title-only resolution was used.

Course: Bachelor of Computer Science (Honours).

## Intake observations

Live canonical state contains two separate 2027 Intake observations:

| Intake | Start date | Application deadline | Campus scope |
|---|---|---|---|
| Semester 1 | 22 Feb 2027 | 30 Nov 2026 | NULL / no accepted Campus scope recorded |
| Semester 2 | 26 Jul 2027 | 31 May 2027 | NULL / no accepted Campus scope recorded |

Both retain:

- active status;
- confidence 1.0;
- The University of Queensland official program pages as source;
- accepted source evidence page;
- evidence capture timestamp/hash;
- stable source intake key.

`campus_id=NULL` was not interpreted as `all campuses`.

## English requirement observations

Live canonical state contains three separate governed test observations:

| Test | Overall | Component threshold |
|---|---:|---|
| IELTS Academic | 6.5 | Reading 6; Writing 6; Speaking 6; Listening 6 |
| PTE Academic | 64 | Minimum each 60 |
| TOEFL iBT | 87 | Reading 19; Writing 21; Speaking 19; Listening 19 |

All retain:

- governed `ref.english_tests` identity;
- active status;
- Course scope;
- confidence 1.0;
- `valid_from=20 August 2026`;
- open-ended `valid_to`;
- latest verification timestamp;
- UQ source and evidence;
- evidence capture timestamp/hash;
- stable source requirement key.

Overall and component scores remain separate.

## Applied read contract

Pilot migration:

`m1_pim_gov_intake_english_semantics_v1`

Private helper:

`security.admin_course_entry_summary(uuid)`

The helper returns:

- `intakes[]` with timing, Campus scope, status, confidence, source/evidence and source key;
- `english_requirements[]` with test identity, scores, components, validity, verification, confidence, source/evidence and source key.

`public.admin_read('course_detail',...)` appends this as `entry_summary` without altering canonical rows.

## Security UAT

After migration:

- `authenticated` direct EXECUTE on `public.ui_course_detail(uuid)`: **false**;
- `authenticated` direct EXECUTE on `security.admin_course_entry_summary(uuid)`: **false**;
- `authenticated` EXECUTE on governed `public.admin_read(text,jsonb)`: **true**.

Role-context execution under the assigned Platform Admin identity returned the full two-Intake / three-English observation payload.

**Result:** PASS.

## Semantic assertions

| Assertion | Result |
|---|---|
| Exact CRICOS Course identity used | PASS |
| Multiple Intakes preserved | PASS |
| Intake year/label/start/deadline remain distinct | PASS |
| NULL Campus scope not broadened to all campuses | PASS |
| Intake source/evidence/confidence/source key retained | PASS |
| Multiple English test identities preserved | PASS |
| Overall/component scores remain separate | PASS |
| English validity and verification retained | PASS |
| English source/evidence/confidence/source key retained | PASS |
| No canonical rows rewritten | PASS |
| Direct legacy Course-detail browser surface removed | PASS |

## Frontend acceptance requirements

### Intakes

1. dedicated repeating Intake section;
2. year and Intake label shown together without collapsing observations;
3. start date and application deadline separately labelled;
4. Campus scope shown explicitly;
5. NULL Campus scope shown as `No accepted Campus scope recorded`, not `All campuses`;
6. source/evidence accessible.

### English

1. dedicated repeating English requirement section;
2. governed test name visible;
3. overall score visible;
4. component thresholds rendered readably and separately;
5. validity/verification context accessible;
6. source/evidence accessible;
7. no generic single English-score flattening.

## Verdict

**Canonical model:** PASS / unchanged  
**Read-contract semantics:** PASS  
**Source/provenance:** PASS  
**Security boundary:** PASS  
**Frontend semantic presentation:** PENDING  
**Deployed authenticated browser UAT:** PENDING
