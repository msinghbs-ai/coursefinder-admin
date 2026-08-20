# CourseFinder Running Build v2.52

**Status:** CURRENT GOVERNED SOURCE BUILD — CLOUDFLARE RUNTIME OBSERVATION PENDING  
**Date:** 20 August 2026  
**Supersedes:** `docs/coursefinder-running-build-v2.51.md`  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.37.md`  
**Master plan:** `docs/coursefinder-master-project-plan-v1.48.md`  
**Course-detail UAT:** `docs/uat/coursefinder-m1-pim-gov-course-detail-v2.7.0-uat-2026-08-20.md`

## Build delta

v2.52 preserves all accepted Layer 1, Layer 2, Search, fee, Insights, Evidence and full-catalogue paging state and advances the governed Course-detail semantic frontend to **PIM Admin v2.7.0**.

This release consolidates the frontend presentation portions of:

- `CF-CHG-20260820-008` — Provider / Course / Campus geography semantics;
- `CF-CHG-20260820-009` — Intake and English requirement semantics;
- `CF-CHG-20260820-010` — Course taxonomy source lineage.

## PIM Admin v2.7.0

Course detail now has explicit semantic sections for:

1. CRICOS registered fees vs Provider-current fees;
2. Course delivery campuses with Campus provenance separate from Course→Campus relationship provenance;
3. repeatable Intakes with explicit nullable Campus scope;
4. repeatable governed English-test requirements with separate overall/component thresholds;
5. Taxonomy & source mapping showing source vocabulary/code → mapping → canonical taxonomy → evidence.

Visible/package version is `2.7.0`.

Frontend source delta is intentionally narrow:

- `src/CourseSemanticDetail.jsx` — new semantic Course-detail component;
- `src/main.jsx` — component wiring + UI version;
- `package.json` — package version.

No canonical table, source adapter, Search projection or consumer-admission contract changed.

## Authenticated read-contract ACL repair

Authenticated regression UAT found that the new private Entry/Taxonomy helpers could not be called by the invoker `public.admin_read` after their authenticated EXECUTE had been fully revoked.

Pilot migration:

`m1_pim_gov_course_detail_helper_acl_fix_v1`

Repository mirror:

`supabase/production-migrations/064_m1_pim_gov_course_detail_helper_acl_fix.sql`

After repair:

- `anon` cannot execute either helper;
- `authenticated` can call the non-exposed `security` helpers so `public.admin_read` can dispatch to them;
- each helper retains the internal CourseFinder role check and safe search path;
- direct authenticated legacy `public.ui_course_detail(uuid)` remains false;
- `public.admin_read(text,jsonb)` remains the browser API boundary.

## Exact reference regression — CRICOS 121174E

Authenticated Course-detail read confirms:

- CRICOS fee rows: 3;
- one Hawthorn Course delivery Campus;
- Campus evidence and Course→Campus relationship evidence both present;
- source Study Level `Bachelor Degree` → canonical `Bachelor`;
- source Field `0201` → canonical `asced-0201`.

Fee semantics from `CF-CHG-001` remain retained, including numeric zero and source-not-supplied fee year.

## Exact Provider-current regression — CRICOS 102784C

Authenticated Course-detail read confirms:

- CRICOS registered fee rows: 3;
- Provider-current fee rows: 1;
- Provider-current tuition: AUD 60,952 / 2027 / `indicative_annual`;
- Intakes: Semester 1 + Semester 2, both retaining `campus_id=NULL` scope semantics;
- English requirements: IELTS, PTE and TOEFL iBT as three distinct observations.

## Source/build verification

Passed:

- JSX/React parser diagnostics: zero;
- branch scope initially exactly three frontend files before governance/migration mirrors;
- authenticated role-context DB/RPC regression for both reference Courses;
- ACL assertions for browser/public/private surfaces.

A clean Vite build could not be independently executed in the current container because external DNS resolution to GitHub is unavailable. This is recorded as an execution-environment limitation, not represented as a production-build PASS.

## Security Advisor state

Security Advisors were rerun after migration 064. No new public RPC surface was created by the v2.7 helpers; they remain under `security`.

Existing legacy `public.ui_*` SECURITY DEFINER warnings, private-schema RLS informational findings and leaked-password-protection configuration debt remain separately governed. v2.52 does not claim those are resolved.

## Preserved programme baselines

- AU CRICOS: 1,546 Providers / 26,648 active Courses;
- Layer 1 adapter: `layer1-au-depth-v1.6.0`;
- AU Course Facts: RMIT + UQ qualified / 10 bounded Courses;
- QUT: source-specific deferred HTTP 403;
- QILT/PRISMS/Scholarship accepted gates unchanged;
- Search Course Documents: 33,105;
- fee/intake/English Search enrichment admitted: 0;
- vector Search remains not admitted.

## Change Control

- `CF-CHG-001`, `005`, `006`, `007`: prior technical/frontend source PASS retained through v2.7; deployed browser UAT pending;
- `CF-CHG-008`: DB/RPC/security + frontend source PASS; deployed browser UAT pending;
- `CF-CHG-009`: DB/RPC/security + frontend source PASS; deployed browser UAT pending;
- `CF-CHG-010`: DB/RPC/security + frontend source PASS; deployed browser UAT pending.

## Remaining runtime gate

The current tool environment cannot independently observe the Cloudflare Worker runtime. GitHub publication is not treated as deployment proof.

Final browser UAT must prove v2.7.0, `121174E` Campus/taxonomy/fee presentation and `102784C` Intake/English/fee separation on the deployed authenticated UI before the open records close.

Database Architecture remains v2.10.37 because no canonical relational model changed.
