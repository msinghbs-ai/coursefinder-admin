# CF-CHG-20260820-009 — Intake and English requirement semantics

**Status:** APPLIED / DB-RPC-SECURITY + FRONTEND SOURCE PASS — DEPLOYED BROWSER UAT PENDING  
**Category:** 30-admin-pim-ux  
**Initiated:** 20 August 2026 12:35 AEST (UTC+10)  
**Origin chat/workstream:** `M1-PIM-GOV — Field Semantics, Change Control & Admin Guide`  
**Owner:** CourseFinder Admin/PIM governance  
**Change class:** semantic read contract / provenance / one-to-many presentation / security ACL

## Trigger

The Course semantic audit showed that Course-detail presentation reduced Intake and English observations to a thin display subset even though canonical storage retained source/evidence, confidence, stable source observation keys, optional Campus scope for Intakes, and validity/verification for English requirements.

Flattening these observations to a date/label or test/score hides business meaning and is unsafe for Admin and downstream consumers.

## Semantic decisions

### Intakes

1. Intake is a repeatable Provider-current Course observation, not a scalar Course field.
2. `campus_id=NULL` means no accepted Campus scope is recorded; it does not mean every Campus.
3. Year, label, start date and application deadline are separate concepts.
4. Multiple Intakes in one year remain separate observations.
5. Source/evidence/confidence/source observation key are part of the audit contract.
6. Canonical presence does not imply Search/Website/Zoho admission.

### English requirements

1. English requirement repeats by governed test identity.
2. Overall score and component thresholds remain separate.
3. Unlike tests must not be merged into one generic English score.
4. Validity, verification, confidence, source/evidence and source requirement key are part of observation meaning.
5. Current observations are Course scoped; Campus scope is not invented.
6. `last_verified_at` is verification, not approval.

## Reference case — UQ CRICOS 102784C

Canonical Course UUID: `bd43cd91-a234-4b94-9e8e-df9d8cf74d92`  
Course: Bachelor of Computer Science (Honours)

### Intakes

- Semester 1 — 2027 — start 22 February 2027 — deadline 30 November 2026;
- Semester 2 — 2027 — start 26 July 2027 — deadline 31 May 2027.

Both have `campus_id=NULL`; Admin must show an explicit unscoped/source-not-supplied state, never `All campuses`.

### English requirements

- IELTS Academic — overall 6.5 — Reading/Writing/Speaking/Listening minimum 6;
- PTE Academic — overall 64 — minimum each 60;
- TOEFL iBT — overall 87 — Reading 19, Writing 21, Speaking 19, Listening 19.

They remain separate Provider-current observations with source/evidence, confidence, validity/verification and stable source keys.

## Applied read contract

Pilot migration: `m1_pim_gov_intake_english_semantics_v1`  
Repository mirror: `supabase/production-migrations/062_m1_pim_gov_intake_english_semantics.sql`

`security.admin_course_entry_summary(uuid)` supplies the `entry_summary` collection through `public.admin_read('course_detail',...)`.

No canonical Intake or English row was rewritten.

## Authenticated-call ACL correction

Authenticated v2.7 regression UAT exposed that the invoker `public.admin_read` could not call the private helper after authenticated EXECUTE had been revoked.

Pilot repair: `m1_pim_gov_course_detail_helper_acl_fix_v1`  
Repository mirror: `supabase/production-migrations/064_m1_pim_gov_course_detail_helper_acl_fix.sql`

After repair:

- `anon` cannot execute the entry helper;
- `authenticated` may execute the non-exposed `security` helper so the invoker wrapper can call it;
- the helper still enforces assigned CourseFinder role internally;
- authenticated `public.admin_read` remains executable;
- legacy public `ui_course_detail` remains non-executable by authenticated users.

## Frontend release — PIM Admin v2.7.0

### Intakes

The dedicated Intakes section preserves one row per observation and displays label/year, start date, application deadline, explicit Campus scope, status/confidence and source/evidence.

For `campus_id=NULL`, v2.7 displays **Campus scope: Not supplied by source** rather than implying every Campus.

### English entry requirements

The dedicated section preserves one row per governed test, displays overall and component thresholds separately, and exposes validity/verification/confidence/source/evidence.

No generic English-score flattening is used.

## UAT

Technical UAT: `docs/uat/coursefinder-m1-pim-gov-intake-english-semantics-uat-2026-08-20.md`  
Combined v2.7 UAT: `docs/uat/coursefinder-m1-pim-gov-course-detail-v2.7.0-uat-2026-08-20.md`

Authenticated `admin_read` UAT for `102784C` confirms:

- CRICOS fee rows: 3;
- Provider-current fee rows: 1, AUD 60,952 / 2027 / `indicative_annual`;
- Intakes: 2 — Semester 1 + Semester 2;
- first Intake remains `campus_id=NULL`;
- English requirements: 3 — IELTS, PTE, TOEFL iBT.

**Technical/frontend source verdict:** PASS.

## Consumer / Zoho consequence

Intakes and English requirements remain repeating child objects under the curated consumer contract. This change does not grant consumer admission.

## Rollback

Frontend rollback restores the preceding Course detail. Backend rollback restores the prior governed helper/wrapper ACL. Do not modify or collapse canonical Intake/English observations.

## Decision / status history

| Timestamp | Status | Event |
|---|---|---|
| 20 Aug 2026 12:35 AEST | OPEN / AUDITED | One-to-many Intake/English semantics formalised |
| 20 Aug 2026 | APPLIED / TECHNICAL PASS | Rich entry-summary read contract applied |
| 20 Aug 2026 13:01 AEST | DEFECT FOUND / REPAIRED | Authenticated invoker could not call private helper; migration 064 corrected helper ACL without reopening legacy public Course detail |
| 20 Aug 2026 13:01 AEST | FRONTEND SOURCE PASS | PIM Admin v2.7.0 repeating Intake/English presentation passed authenticated regression UAT |

## Closure

**Final status:** OPEN — DB/RPC/SECURITY + FRONTEND SOURCE PASS / DEPLOYED BROWSER UAT PENDING  
**Closed at:** N/A  
**Outcome:** Intake/English grain, scope and provenance are preserved through canonical storage, governed read and v2.7 source presentation. Closure requires deployed authenticated browser UAT.
