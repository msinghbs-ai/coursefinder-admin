# CourseFinder Master Project Plan v1.47

**Status:** AUTHORITATIVE PROGRAMME GOVERNANCE DOCUMENT  
**Supersedes:** `docs/coursefinder-master-project-plan-v1.46.md`  
**Last consolidated:** 20 August 2026  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.37.md`  
**Running build:** `docs/coursefinder-running-build-v2.51.md`

## Current programme position

The accepted AU Layer 1, Layer 2, Search isolation and Admin/PIM hardening baselines remain unchanged.

Current `M1-PIM-GOV` semantic gates:

| Change | State |
|---|---|
| `CF-CHG-001` Fee semantics | Technical/frontend source PASS; deployed browser UAT pending |
| `CF-CHG-005` QILT/PRISMS workspaces | Technical/frontend source PASS; deployed browser UAT pending |
| `CF-CHG-006` Evidence provenance | Technical/frontend source PASS; deployed browser UAT pending |
| `CF-CHG-007` Catalogue paging/exact identity | Technical/frontend source PASS; deployed browser UAT pending |
| `CF-CHG-008` Provider/Course/Campus geography | DB/RPC/security PASS; frontend presentation pending |
| `CF-CHG-009` Intake/English semantics | DB/RPC/security PASS; frontend presentation pending |
| `CF-CHG-010` Taxonomy source lineage | DB/RPC PASS; frontend presentation pending |

## Taxonomy decision

Canonical taxonomy labels do not replace original source vocabulary.

Course detail must be able to demonstrate:

- Study Level: source scheme/registration/source value → mapping status → canonical Study Level → evidence;
- Field of Study: source code/name → canonical Field → primary/status → evidence.

For Australian CRICOS Courses, a populated CRICOS Course Level is authoritative for Layer 1 mapping; title inference is not allowed.

## Reference case — CRICOS 121174E

- source Course Level: `Bachelor Degree`;
- canonical Study Level: `bachelor` / `Bachelor`;
- mapping status: `mapped`;
- source Field: `0201` / `Computer Science`;
- canonical Field: `asced-0201` / `Computer Science`;
- source/evidence retained.

## Governed read

Pilot migration `m1_pim_gov_taxonomy_semantics_v1` and repository migration 063 add `taxonomy_summary` to the governed Course-detail response through `public.admin_read`.

No canonical taxonomy or Course rows were changed.

## Planned frontend semantic release

Current frontend remains PIM Admin v2.6.0.

The next semantic Course-detail release should combine:

1. dedicated Course delivery campuses (`CF-CHG-008`);
2. repeating Course Intakes and English requirements (`CF-CHG-009`);
3. compact Taxonomy & source mapping (`CF-CHG-010`).

No change closes until source UAT and, where required, deployed authenticated browser UAT pass.

## Consumer boundary

PIM Admin Guide v1.3 is current. Zoho Consumer Contract v1.1 remains the curated contract baseline; Search/Website/Zoho admission is not granted by Admin visibility.

## Programme baselines preserved

- AU CRICOS: 1,546 Providers / 26,648 active Courses;
- Layer 1 adapter: `layer1-au-depth-v1.6.0`;
- AU Course Facts: RMIT + UQ qualified / 10 bounded Courses;
- QUT: source-specific deferred HTTP 403;
- QILT/PRISMS/Scholarship accepted gates unchanged;
- Search documents: 33,105;
- fee/intake/English Search enrichment admitted: 0;
- vector Search remains not admitted.

## Next work

1. implement/source-test the planned semantic Course-detail frontend;
2. audit Scholarship relational/compound presentation;
3. audit lifecycle, publication, completeness and Search-state presentation together;
4. continue curated Zoho field semantics;
5. complete deployed browser UAT when the Cloudflare runtime can be independently observed.

Database Architecture remains v2.10.37 because no canonical relational model changed.
