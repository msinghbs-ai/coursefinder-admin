# CourseFinder Master Project Plan v1.48

**Status:** AUTHORITATIVE PROGRAMME GOVERNANCE DOCUMENT  
**Supersedes:** `docs/coursefinder-master-project-plan-v1.47.md`  
**Last consolidated:** 20 August 2026 13:01 AEST (UTC+10)  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.37.md`  
**Running build:** `docs/coursefinder-running-build-v2.52.md`

## Current programme position

The accepted AU Layer 1, Layer 2, Search isolation and Admin/PIM hardening baselines remain unchanged.

Current `M1-PIM-GOV` gates:

| Change | State |
|---|---|
| `CF-CHG-001` Fee semantics | Technical/frontend source PASS through v2.7; deployed browser UAT pending |
| `CF-CHG-005` QILT/PRISMS workspaces | Technical/frontend source PASS through v2.7; deployed browser UAT pending |
| `CF-CHG-006` Evidence provenance | Technical/frontend source PASS through v2.7; deployed browser UAT pending |
| `CF-CHG-007` Catalogue paging/exact identity | Technical/frontend source PASS through v2.7; deployed browser UAT pending |
| `CF-CHG-008` Provider/Course/Campus geography | DB/RPC/security + frontend source PASS in v2.7; deployed browser UAT pending |
| `CF-CHG-009` Intake/English semantics | DB/RPC/security + frontend source PASS in v2.7; deployed browser UAT pending |
| `CF-CHG-010` Taxonomy source lineage | DB/RPC/security + frontend source PASS in v2.7; deployed browser UAT pending |

## PIM Admin v2.7.0 semantic Course detail

v2.7.0 converts the accepted Course-detail read contracts into explicit Admin semantics without changing canonical data.

### Course delivery campuses

- Provider geography is not Course delivery geography.
- Course→Campus relationship grain is visible.
- Campus source/evidence and relationship source/evidence are separate drill-downs.
- NULL validity is not normalised into invented dates.

### Intakes

- one row per accepted Intake;
- year/label/start/deadline remain separate;
- `campus_id=NULL` is displayed as no Campus scope supplied, not all campuses;
- source/evidence/confidence/source key remain available.

### English requirements

- one row per governed test;
- overall score and component thresholds remain separate;
- validity/verification/confidence/source/evidence remain available.

### Taxonomy lineage

- Study Level shows exact source vocabulary → mapping status → canonical taxonomy → evidence;
- Field of Study shows source code/name → canonical taxonomy → evidence;
- source lineage belongs in detail/audit presentation rather than decision-grid clutter.

## Authenticated browser-call contract

The v2.7 regression found and corrected an ACL mismatch between the invoker `public.admin_read` and the new private `security` helpers.

Pilot migration `m1_pim_gov_course_detail_helper_acl_fix_v1` / repository migration 064 restores helper callability for authenticated assigned CourseFinder users while preserving:

- non-exposed `security` schema placement;
- internal role checks;
- safe search paths;
- `anon` denial;
- direct authenticated legacy `public.ui_course_detail` denial.

This defect was repaired before v2.7 publication and is included in the UAT/change history.

## Reference cases

### CRICOS 121174E

Authenticated governed read proves:

- three CRICOS fee concepts;
- one Hawthorn Course delivery Campus;
- Campus evidence and Course→Campus relationship evidence separately;
- source `Bachelor Degree` → canonical Bachelor;
- source Field `0201 / Computer Science` → canonical `asced-0201 / Computer Science`.

### CRICOS 102784C

Authenticated governed read proves:

- CRICOS registered fees separate from Provider-current AUD 60,952 / 2027 / indicative annual tuition;
- Semester 1 + Semester 2 remain separate 2027 Intakes;
- NULL Intake Campus scope remains unscoped;
- IELTS, PTE and TOEFL iBT remain three separate English requirements.

## Release verification boundary

Source parsing, branch-scope inspection and authenticated DB/RPC regression passed.

The current execution container cannot perform an independent clean Vite build because external DNS is unavailable. The Cloudflare runtime also remains unobservable from current tools. Therefore source publication is not represented as build/deployment/browser proof.

## Admin and consumer governance

Current semantic guides:

- PIM Admin Guide v1.3;
- Zoho Consumer Contract v1.1;
- v2.7 Course-detail UAT.

Zoho/Website/Search admission remains independent. No new field is consumer-admitted merely because Admin can display it.

## Preserved programme baselines

- AU CRICOS: 1,546 Providers / 26,648 active Courses;
- Layer 1 adapter: `layer1-au-depth-v1.6.0`;
- AU Course Facts: RMIT + UQ qualified / 10 bounded Courses;
- QUT: source-specific deferred HTTP 403;
- QILT, PRISMS and first Scholarship source accepted states unchanged;
- Search Course Documents: 33,105;
- fee/intake/English Search enrichment admitted: 0;
- vector Search remains rejected/not admitted.

## Next M1-PIM-GOV work

1. publish/verify the v2.7 source branch without force and preserve parallel history;
2. execute deployed authenticated v2.7 browser UAT when runtime observation becomes available;
3. audit Scholarship compound eligibility, scopes, cycles/windows, tiers and coverage presentation;
4. audit lifecycle, publication, completeness/readiness and Search-state presentation as one semantic-state model;
5. continue the curated Zoho consumer contract and create Change Control only where a material semantic defect is proven.

Database Architecture remains v2.10.37 because no canonical relational model changed.
