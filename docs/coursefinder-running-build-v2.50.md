# CourseFinder Running Build v2.50

**Status:** CURRENT GOVERNED SOURCE BUILD — CLOUDFLARE RUNTIME OBSERVATION PENDING  
**Date:** 20 August 2026  
**Supersedes:** `docs/coursefinder-running-build-v2.49.md`  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.37.md`  
**Master plan:** `docs/coursefinder-master-project-plan-v1.46.md`  
**Entry semantics UAT:** `docs/uat/coursefinder-m1-pim-gov-intake-english-semantics-uat-2026-08-20.md`

## Build delta

v2.50 preserves v2.49 and adds `CF-CHG-20260820-009`: governed Intake and English requirement read semantics.

## Intake / English read-contract correction

Pilot migration:

`m1_pim_gov_intake_english_semantics_v1`

Repository mirror:

`supabase/production-migrations/062_m1_pim_gov_intake_english_semantics.sql`

New private helper:

`security.admin_course_entry_summary(uuid)`

The governed Course-detail response now includes `entry_summary` with:

- repeating Intakes: year, label, start date, application deadline, optional Campus scope, status, confidence, source/evidence and source observation key;
- repeating English requirements: governed test identity, overall score, component scores, status, confidence, validity, verification, source/evidence and source observation key.

No canonical observations were rewritten.

## Reference case — UQ CRICOS 102784C

Accepted 2027 Intakes remain separate:

- Semester 1 — start 22 February 2027 — deadline 30 November 2026;
- Semester 2 — start 26 July 2027 — deadline 31 May 2027.

Both have `campus_id=NULL`; this is governed as **no accepted Campus scope recorded**, not `all campuses`.

Accepted English test observations remain separate:

- IELTS Academic — overall 6.5, Reading/Writing/Speaking/Listening minimum 6;
- PTE Academic — overall 64, minimum each 60;
- TOEFL iBT — overall 87, Reading 19 / Writing 21 / Speaking 19 / Listening 19.

All three preserve Provider source/evidence, confidence, validity and latest verification.

## Security after-state

- authenticated direct `public.ui_course_detail(uuid)` EXECUTE: false;
- authenticated direct private Entry helper EXECUTE: false;
- authenticated `public.admin_read(text,jsonb)` EXECUTE: true.

Browser access therefore remains through the hardened Admin read boundary.

## Frontend state

Current source remains **PIM Admin v2.6.0**.

A subsequent **v2.7.0 semantic Course-detail release** is planned to implement both open presentation changes:

- `CF-CHG-008`: dedicated Course delivery campuses with Campus-vs-relationship provenance;
- `CF-CHG-009`: dedicated repeating Intake and English sections.

v2.50 does not claim frontend source PASS for those two changes.

## PIM/consumer governance

Current semantic documents:

- PIM Admin Guide v1.2;
- Zoho Consumer Contract v1.1.

Both explicitly preserve repeating Campus/Intake/English cardinality and prohibit Provider-geography or scalar-field flattening.

## Preserved programme state

- AU CRICOS Providers: 1,546;
- active AU CRICOS Courses: 26,648;
- Layer 1 adapter: `layer1-au-depth-v1.6.0`;
- qualified Provider-current source classes: RMIT + UQ;
- bounded Provider-current Courses: 10;
- Search Course Documents: 33,105;
- Search fee/intake/English enrichment admitted: 0.

## Change Control

- `CF-CHG-001` — technical/source PASS / deployed browser pending;
- `CF-CHG-005` — technical/source PASS / deployed browser pending;
- `CF-CHG-006` — technical/source PASS / deployed browser pending;
- `CF-CHG-007` — technical/source PASS / deployed browser pending;
- `CF-CHG-008` — DB/RPC/SECURITY PASS / frontend presentation pending;
- `CF-CHG-009` — DB/RPC/SECURITY PASS / frontend presentation pending.

## Documentation decision

Updated:

- Running Build → v2.50;
- Master Plan → v1.46;
- PIM Admin Guide → v1.2;
- Zoho Consumer Contract → v1.1;
- Entry semantic UAT;
- Change Control register / `CF-CHG-009`;
- repository migration 062.

Database Architecture remains v2.10.37 because the canonical Course Intake/English relational model did not change.

## Next PIM-GOV sequence

1. implement the v2.7 semantic Course-detail frontend;
2. audit Study Level and Field of Study source vocabulary/mapping presentation;
3. audit Scholarship scope/eligibility semantics;
4. audit lifecycle/publication/Search state separation;
5. complete deployed browser UAT when Cloudflare runtime observation is available.
