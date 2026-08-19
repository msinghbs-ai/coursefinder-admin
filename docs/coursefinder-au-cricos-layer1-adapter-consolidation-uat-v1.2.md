# CourseFinder AU CRICOS Layer 1 Adapter Consolidation UAT v1.2

**Status:** PASS / ACCEPTED  
**Gate:** `M1-L1-AU-CRICOS-COMPLETENESS`  
**Date:** 20 August 2026  
**Supersedes:** `docs/coursefinder-au-cricos-layer1-adapter-consolidation-uat-v1.1.md`  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.34.md`  
**Completeness design:** `docs/coursefinder-au-layer1-regulatory-completeness-design-v1.0.md`

## 1. Acceptance statement

The Australia CRICOS residual Layer 1 completeness gate is PASS. The accepted AU substrate remains exactly 1,546 Providers and 26,648 active CRICOS Courses. All populated CRICOS Course Level values now resolve through exact governed source-value mappings; no title inference is used. The remaining Campus and fee gaps are explained authoritative-source absences, not unresolved adapter defects. Search was not rebuilt or refreshed and remains unchanged.

`M1-L2-AU-COURSE-FACTS` is eligible to proceed after this PASS but was not started by this gate.

## 2. Accepted source and evidence

- Authority: current CRICOS structured data on data.gov.au.
- CRICOS Courses snapshot: `2026-08-04T08:04:20.717556Z`.
- Accepted Courses SHA-256: `fc2f2ef81c0b3c63dd47e1b01c7e5cf22f708c892e70f71707dbb421baed6945`.
- Approved private evidence artifact: `522c1103-47d2-42d8-af4f-21e93fb1acfc`.
- Active source Courses: 26,648.
- Active canonical Providers represented by those Courses: 1,546.

## 3. Defect found and repaired

The accepted `layer1-au-depth-v1.5.1` used a regex Course Level mapper and then passed canonical-looking strings into `svc_layer1_apply_register_records`. The RPC subsequently interpreted those strings as free text. This caused both missing values and silent semantic collapse. Examples included `graduate_certificate` falling through to generic `certificate` and `graduate_diploma` falling through to generic `diploma`.

The corrected contract is `layer1-au-depth-v1.6.0`:

- carries the exact CRICOS `Course Level` value as `course_level_raw`;
- resolves it only through `ref.study_level_source_mappings`;
- persists the raw vocabulary, source snapshot, evidence and mapping result in `catalogue.course_study_level_observations`;
- updates `catalogue.courses.study_level_id` only for a governed exact mapping;
- rejects any populated unmapped/review-required CRICOS level at the gate;
- never infers a level from Course title when CRICOS supplies `Course Level`.

## 4. Complete current CRICOS Course Level inventory

| CRICOS Course Level | Active Courses | Governed Study Level |
|---|---:|---|
| Diploma | 4,170 | `diploma` |
| Bachelor Degree | 4,023 | `bachelor` |
| Masters Degree (Coursework) | 3,395 | `masters_coursework` |
| Certificate III | 2,388 | `certificate_iii` |
| Certificate IV | 1,978 | `certificate_iv` |
| Non AQF Award | 1,755 | `non_aqf_award` |
| Advanced Diploma | 1,679 | `advanced_diploma` |
| Bachelor Honours Degree | 1,556 | `bachelor_honours` |
| Graduate Diploma | 1,556 | `graduate_diploma` |
| Graduate Certificate | 1,071 | `graduate_certificate` |
| Doctoral Degree | 948 | `doctorate` |
| Masters Degree (Research) | 854 | `masters_research` |
| Senior Secondary Certificate of Education | 327 | `senior_secondary_certificate` |
| Primary School Studies | 246 | `primary_school_studies` |
| Associate Degree | 241 | `associate_degree` |
| Junior Secondary Studies | 241 | `junior_secondary_studies` |
| Certificate II | 104 | `certificate_ii` |
| Masters Degree (Extended) | 71 | `masters_extended` |
| Vocational Short Course | 39 | `vocational_short_course` |
| Certificate I | 6 | `certificate_i` |
| **Total** | **26,648** | **all mapped** |

The previous 2,281 null Study Levels are explained exactly by:

- Non AQF Award: 1,755;
- Primary School Studies: 246;
- Junior Secondary Studies: 241;
- Vocational Short Course: 39.

Total: 2,281.

## 5. Taxonomy changes

Stable detailed levels added to `ref.study_levels`:

- `primary_school_studies`
- `junior_secondary_studies`
- `senior_secondary_certificate`
- `certificate_i`
- `certificate_ii`
- `certificate_iii`
- `certificate_iv`
- `vocational_short_course`
- `advanced_diploma`
- `bachelor_honours`
- `masters_coursework`
- `masters_research`
- `masters_extended`
- `non_aqf_award`

Existing governed levels were reused where they already expressed the exact regulatory meaning, including `diploma`, `bachelor`, `graduate_certificate`, `graduate_diploma`, `associate_degree` and `doctorate`.

## 6. Campus reconciliation

All 34 active CRICOS Courses without a canonical Campus relationship were checked against the current CRICOS Course Locations authority. The current source contains no Course Location row for any of these codes. Classification for all 34 is `source_absent`.

No synthetic Campus was created.

Affected CRICOS Course codes:

`010223B`, `016179G`, `021354M`, `027642K`, `027647E`, `028849J`, `034950F`, `034960D`, `047698F`, `055565G`, `055579B`, `055604F`, `055689G`, `055690C`, `069094G`, `069095G`, `071256K`, `072165E`, `075467M`, `077035G`, `077036G`, `081796K`, `082683M`, `084191D`, `088932F`, `091558G`, `096003C`, `096807M`, `099037B`, `102203G`, `114041K`, `116768K`, `117353C`, `118116H`.

Classification totals:

- source absence: 34;
- identity-resolution issue: 0;
- review-required ambiguity: 0;
- adapter defect: 0.

## 7. Fee gap reconciliation

A fresh audit of the current CRICOS Courses source reconfirmed:

- missing Tuition Fee: 191 active Courses;
- missing Non Tuition Fee: 191 active Courses.

The same 191 Courses lack both fields. These are `source_absent` gaps. No value was manufactured, annualised or inferred.

Accepted fee semantics remain unchanged:

- currency: AUD;
- audience: international;
- `fee_year`: null;
- basis: `registered_total_course`;
- annualised: false.

Current active CRICOS fee observations remain:

- Estimated Total Course Cost: 26,648;
- Tuition Fee: 26,457;
- Non Tuition Fee: 26,457;
- total fee observations: 79,562.

## 8. Additional source-quality classification

The existing regulatory facts parser reported five invalid numeric cells. Fresh source inspection proved these are source values rather than parser defects:

- four active Courses publish `Work Component Weeks = -1`;
- one of those also publishes `Work Component Total Hours = -20`.

The parser correctly refuses to turn these invalid/sentinel negatives into positive canonical durations. The raw values remain preserved in source evidence. Classification: authoritative-source anomaly, not adapter defect.

Affected Courses include `038585A`, `056057J`, `066770A` and `071515G`.

## 9. Full bounded dry-run

Production adapter under test: `layer1-au-depth-v1.6.0`.

- 54 bounded batches;
- offsets 0 through 26,500;
- 53 batches of 500 plus a final batch of 148;
- total selected: 26,648;
- exact source hash matched throughout;
- mapped Study Levels: 26,648;
- unmapped: 0;
- review-required: 0;
- Course identity misses: 0;
- core conflicts: 0;
- invalid fee values: 0;
- invalid boolean values: 0;
- predicted canonical Study Level corrections: 17,266.

**Dry-run result: PASS.**

## 10. APPLY execution and recovery evidence

The first concurrent full-adapter APPLY attempt exposed an operational timeout in already-accepted core/facts work. Two bounded calls exceeded statement/HTTP limits; this was recorded as failed UAT and was not treated as a pass. Some early Study Level subphase writes had already committed transactionally.

The residual write path was then narrowed to the exact new production Study Level RPC using the approved private CRICOS Courses evidence artifact. `layer1-au-completeness-v1.1.0`:

- requires a one-time Pilot nonce;
- requires the approved evidence ID and expected SHA-256;
- downloads only from the private `evidence` bucket;
- verifies evidence descriptor hash and bytes hash before processing;
- processes a maximum of 500 active Courses;
- uses the same `svc_layer1_apply_course_study_levels` production RPC;
- performs no Search action.

Focused APPLY result:

- 54/54 bounded batches successful;
- 26,648/26,648 mapped;
- unmapped: 0;
- review-required: 0;
- identity misses: 0;
- remaining canonical changes written by focused path: 16,616;
- earlier committed canonical changes recovered as unchanged: 650;
- total semantic corrections: 17,266, exactly matching full dry-run prediction.

**APPLY result: PASS.**

## 11. Full replay / idempotency

The same 54 offsets were replayed with APPLY enabled against the same approved evidence hash.

- responses: 54/54 successful;
- selected: 26,648;
- mapped: 26,648;
- observation unchanged: 26,648;
- observation created: 0;
- observation updated: 0;
- canonical Study Level changed: 0;
- unmapped: 0;
- review-required: 0;
- Course identity misses: 0.

**Replay/idempotency result: PASS.**

## 12. Final completeness

Across the accepted 13 Layer 1 regulatory completeness dimensions:

- total dimension cells: 346,424;
- explained missing source cells: 416;
- unexplained adapter-defect cells: 0;
- regulatory completeness: **99.88%**.

Course-level distribution after repair:

- 26,423 Courses: 13/13 = 100%;
- 34 Courses: 12/13 = 92.31% (Campus source absence only);
- 191 Courses: 11/13 = 84.62% (Tuition + Non Tuition source absence);
- Courses with unexplained mapping defects: 0.

Residual gap attribution:

| Dimension | Missing | Source absent | Adapter defect | Review/identity |
|---|---:|---:|---:|---:|
| Study Level | 0 | 0 | 0 | 0 |
| Campus | 34 | 34 | 0 | 0 |
| Tuition Fee | 191 | 191 | 0 | 0 |
| Non Tuition Fee | 191 | 191 | 0 | 0 |
| **Total missing cells** | **416** | **416** | **0** | **0** |

## 13. Search isolation proof

Before and after the Layer 1 repair:

- Search Documents: 33,105;
- Search aggregate fingerprint: `c3cf5dd66a6b69e58f41c72abb4f1e94`;
- Search max `updated_at`: `2026-08-19 04:54:40.774052+00`.

No Search projection rebuild, refresh or enrichment admission was performed.

**Search isolation result: PASS.**

## 14. Database/security checks

New governed surfaces:

- `ref.study_level_source_mappings`;
- `catalogue.course_study_level_observations`;
- `public.svc_layer1_apply_course_study_levels(...)`;
- `public.svc_layer1_evidence_descriptor(...)`.

Security posture:

- RLS enabled on both new tables;
- no anon/authenticated table grants;
- service-role-only table access;
- SECURITY DEFINER functions use fixed `search_path` and explicit service-role guards;
- public/anon/authenticated EXECUTE revoked.

The performance advisor initially identified the new `course_study_level_observations.evidence_id` FK without a covering index. `course_study_level_observations_evidence_idx` was added and the unindexed-FK finding cleared. Remaining advisor findings are pre-existing project-level items and are not introduced by this gate.

## 15. Gate decision

### PASS — `M1-L1-AU-CRICOS-COMPLETENESS`

Acceptance conditions met:

- exactly 1,546 Providers retained;
- exactly 26,648 active Courses retained;
- all 26,648 populated CRICOS Course Level values mapped deterministically;
- exact CRICOS vocabulary/evidence preserved;
- zero unexplained Study Level mapping defects;
- all 34 Campus gaps classified as authoritative source absence;
- all 191 Tuition and 191 Non Tuition gaps classified as authoritative source absence;
- no synthetic Campuses or manufactured fees;
- full dry-run/APPLY/replay/idempotency passed;
- Search unchanged;
- zero running Layer 1 jobs at handover.

`M1-L2-AU-COURSE-FACTS` remains not started by this gate and may only proceed from this accepted PASS baseline.
