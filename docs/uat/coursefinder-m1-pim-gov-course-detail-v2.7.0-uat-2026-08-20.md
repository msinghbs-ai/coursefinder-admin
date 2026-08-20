# CourseFinder M1-PIM-GOV Course Detail Semantic UAT — PIM Admin v2.7.0

**Date:** 20 August 2026  
**Executed:** 20 August 2026 13:01 AEST (UTC+10)  
**Workstream:** `M1-PIM-GOV — Field Semantics, Change Control & Admin Guide`  
**Changes:** `CF-CHG-20260820-008`, `CF-CHG-20260820-009`, `CF-CHG-20260820-010`  
**Frontend release:** `PIM Admin v2.7.0`  
**Repository:** `msinghbs-ai/coursefinder-admin`  
**Feature branch:** `m1-pim-gov-course-detail-v2-7-20260820`  
**Status:** **DB/RPC/SECURITY + FRONTEND SOURCE UAT PASS — DEPLOYED AUTHENTICATED BROWSER UAT PENDING**

## 1. Purpose

Complete the source/frontend semantic presentation for the governed Course-detail read contracts established by the Campus, Intake/English and Taxonomy changes without altering canonical identity, canonical observations, Search admission or consumer publication.

## 2. Frontend scope

`PIM Admin v2.7.0` adds a dedicated semantic Course-detail component and preserves the existing fee, catalogue, QILT/PRISMS and Evidence behaviour.

Implemented sections:

1. **Course delivery campuses** — Course→Campus relationships are presented independently from Provider geography, with separate Campus provenance and Course→Campus relationship provenance.
2. **Intakes** — each Intake remains a separate observation with year, label, start date, deadline, optional Campus scope, status/confidence and source/evidence.
3. **English entry requirements** — each governed test remains separate; overall and component thresholds are not flattened.
4. **Taxonomy & source mapping** — Study Level and Field of Study expose original source vocabulary/code, mapping result, canonical taxonomy and evidence.
5. Existing **CRICOS registered fees / Current Provider fee / Needs semantic review** presentation is retained.
6. Visible/package version is `2.7.0`.

Frontend/source files in the release:

- `src/CourseSemanticDetail.jsx` — new semantic Course-detail component;
- `src/main.jsx` — component wiring and UI version only;
- `package.json` — version alignment only.

## 3. Source syntax and scope UAT

The new component and modified app source were parsed with the JSX/React parser with zero syntax diagnostics before publication.

The initial branch comparison against base `363233d6052996c84678cc80c78fc819881e2da7` showed exactly three frontend files and `ahead 3 / behind 0` before the ACL repository mirror was added.

No dependency version, canonical table, Search projection or source adapter changed.

## 4. Authenticated read-contract defect discovered during UAT

The first authenticated regression correctly failed before frontend publication:

`permission denied for function admin_course_entry_summary`

Root cause:

- `public.admin_read` is an invoker boundary;
- `security.admin_course_entry_summary(uuid)` and `security.admin_course_taxonomy_summary(uuid)` are role-checked `SECURITY DEFINER` helpers in the non-exposed `security` schema;
- direct `authenticated` EXECUTE had been revoked, preventing the invoker wrapper from reaching the helpers.

This was a browser-callability defect, not a canonical-data defect.

## 5. ACL repair

Pilot migration:

`m1_pim_gov_course_detail_helper_acl_fix_v1`

Repository mirror:

`supabase/production-migrations/064_m1_pim_gov_course_detail_helper_acl_fix.sql`

After the repair:

- `anon` EXECUTE — entry helper: false;
- `authenticated` EXECUTE — entry helper: true;
- `anon` EXECUTE — taxonomy helper: false;
- `authenticated` EXECUTE — taxonomy helper: true;
- `authenticated` EXECUTE — `public.admin_read(text,jsonb)`: true;
- `authenticated` EXECUTE — legacy `public.ui_course_detail(uuid)`: false.

The two helpers remain in the non-exposed `security` schema, use safe search paths and enforce assigned CourseFinder role through `security.current_role_rank()`.

## 6. Exact authenticated UAT — CRICOS 121174E

Executed as Postgres role `authenticated` with the assigned Platform Admin JWT subject.

Returned through `public.admin_read('course_detail',...)`:

- Course Code: `121174E`;
- CRICOS registered fee observations: 3;
- Course delivery Campus relationships: 1;
- Campus: Hawthorn Campus John Street Hawthorn Swinburne University;
- Campus evidence ID: `5d6ed80b-e7f4-483c-a268-fdc98af61534`;
- Course→Campus relationship evidence ID: `9f05c3b6-c575-4516-8c1c-fa2111bba379`;
- Study Level source value: `Bachelor Degree`;
- canonical Study Level: `Bachelor`;
- source Field code: `0201`;
- canonical Field code: `asced-0201`.

**Result:** PASS.

## 7. Exact authenticated UAT — CRICOS 102784C

Canonical Course UUID: `bd43cd91-a234-4b94-9e8e-df9d8cf74d92`.

Returned through `public.admin_read('course_detail',...)`:

- CRICOS registered fees: 3;
- Provider-current fee observations: 1;
- Provider-current tuition: AUD 60,952;
- Provider-current fee year: 2027;
- Provider-current basis: `indicative_annual`;
- Intake observations: 2 — Semester 1 and Semester 2;
- first Intake `campus_id=NULL`: preserved as true/unscoped;
- English requirement observations: 3 — IELTS, PTE and TOEFL iBT.

This proves CRICOS/Provider-current fee separation, one-to-many Intake grain, NULL Campus-scope semantics and one-to-many governed English-test grain through the authenticated browser contract.

**Result:** PASS.

## 8. Security Advisor regression

Supabase Security Advisors were rerun after the ACL DDL.

No new public-schema helper exposure was introduced by migrations 062–064. The new helpers remain in `security` and are not REST-facing public RPCs.

The Advisor continues to report pre-existing legacy `public.ui_*` SECURITY DEFINER direct-execute warnings, private-schema RLS-with-no-policy informational notices, and leaked-password-protection configuration debt. These remain separately governed PIM/security-hardening items and are not silently closed by v2.7.

## 9. Frontend semantic acceptance

Source inspection confirms v2.7 renders:

- Provider geography warning versus Course delivery geography;
- separate Campus and relationship evidence drill-down;
- explicit `Campus scope: Not supplied by source` for unscoped Intakes;
- separate IELTS/PTE/TOEFL observations and component thresholds;
- `Bachelor Degree → Bachelor` mapping lineage;
- `0201 / Computer Science → asced-0201 / Computer Science` mapping lineage;
- existing zero-safe CRICOS fees and separate Provider-current fees;
- visible `PIM Admin v2.7.0`.

**Frontend source semantic verdict:** PASS.

## 10. Deployment/browser boundary

Cloudflare runtime/deployment is not independently observable from the current tool environment. A GitHub publication is therefore not treated as proof that the Worker is serving v2.7.0.

Final deployed authenticated browser UAT must verify:

1. visible `PIM Admin v2.7.0`;
2. exact `121174E` lookup and existing fee semantics;
3. Course delivery Campus section shows Hawthorn Campus and does not label Provider State as Course State;
4. Campus and Course→Campus evidence are separately reachable;
5. exact `102784C` shows Semester 1 + Semester 2 separately;
6. both UQ Intakes show Campus scope not supplied rather than all campuses;
7. IELTS, PTE and TOEFL iBT are separate requirements with readable component thresholds;
8. `121174E` taxonomy section shows source `Bachelor Degree` → canonical Bachelor and source `0201` → canonical `asced-0201`;
9. existing QILT/PRISMS/Evidence/catalogue paging regressions remain intact.

## 11. Verdict

**DB/RPC semantic contracts:** PASS  
**Authenticated browser-call contract:** PASS  
**Security ACL regression:** PASS  
**Frontend source semantics:** PASS  
**Canonical data mutation:** NONE  
**Search/Website/Zoho admission change:** NONE  
**Deployed authenticated browser UAT:** PENDING

`CF-CHG-008`, `009` and `010` remain OPEN until deployed browser UAT passes.
