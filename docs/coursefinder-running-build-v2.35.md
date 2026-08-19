# CourseFinder Running Build v2.35

**Status:** CURRENT RUNNING BUILD  
**Date:** 19 August 2026  
**Supersedes:** `docs/coursefinder-running-build-v2.34.md`  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.33.md`  
**Master plan:** `docs/coursefinder-master-project-plan-v1.33.md`  
**Completeness design:** `docs/coursefinder-au-layer1-regulatory-completeness-design-v1.0.md`

## Build delta

The AU CRICOS Layer 1 adapter consolidation remains accepted and the completeness model is now formally separated into:
- source representation correctness;
- regulatory attribute coverage;
- publication/Search readiness.

The next serial gate has been corrected from Layer 2 to residual Layer 1 completeness remediation.

## Primary AU Layer 1 worker

Accepted operational entrypoint:
- `layer1-au-depth-v1.5.1`;
- streamed/bounded processing;
- maximum 500 active Courses per invocation;
- internally invokes `layer1-au-cricos-facts-v1.1.0` as a Layer 1 child phase;
- no per-batch Search rebuild.

## Verified live AU state

- Providers: 1,546
- active Courses: 26,648
- current CRICOS regulatory observations: 26,648
- active CRICOS registered-total-course fee observations: 79,562
- current/year-specific Provider fee rows: 0
- Search Documents: 33,105
- Search `has_fee=true`: 0
- running AU Layer 1 jobs after UAT: 0

## Adapter replay UAT

500-record dry-run: PASS.

500-record APPLY/replay: PASS:
- 500 existing Courses;
- 500 existing Providers;
- 11 existing Campuses;
- 515 existing Course-location links;
- 500 facts unchanged;
- 1,488 fee observations unchanged;
- zero identity/fact/fee creates or updates;
- zero misses/conflicts.

Final boundary offset 26,500: PASS:
- 148 selected;
- `hasMore=false`;
- 148 facts unchanged;
- 444 fee observations unchanged;
- zero creates/updates/misses/conflicts.

Detailed UAT: `docs/coursefinder-au-cricos-layer1-adapter-consolidation-uat-v1.1.md`.

## Regulatory completeness

Current 13-dimension regulatory coverage profile:
- average: 99.22%;
- 24,239 Courses at 100%;
- 26,448 Courses >=90%;
- 200 Courses <90%.

Coverage by residual dimensions:
- Study Level: 24,367 / 26,648;
- Campus relationship: 26,614 / 26,648;
- Tuition Fee: 26,457 / 26,648;
- Non Tuition Fee: 26,457 / 26,648;
- all other dimensions in the current profile: 26,648 / 26,648.

## Gap classification

Layer 1 remediation targets:
- 2,281 Courses without mapped `study_level_id`;
- 34 Courses without canonical campus relationship, pending classification as source absence versus deterministic mapping defect.

Source coverage gaps, not automatically adapter defects:
- 191 Courses without CRICOS Tuition Fee;
- 191 Courses without CRICOS Non Tuition Fee.

No value may be manufactured to improve coverage.

## Publication/Search completeness

No AU publication completeness score is currently formalised/populated through `publishing.entity_states`.

The existing Search/PIM completeness value therefore remains null/unchanged.

Regulatory completeness must not be copied into publication readiness.

## Search posture

- Course Documents: 33,105
- `has_fee=true`: 0
- `courses/course_fee`: BLOCKED

CRICOS registered total-course fee observations remain catalogue/governance facts only until a separate Search admission gate passes.

## Current gate

**Immediate primary:** `M1-L1-AU-CRICOS-COMPLETENESS`.

Required outcome:
- resolve/classify all 2,281 study-level gaps;
- resolve/classify all 34 campus gaps;
- repeat full dry-run/APPLY/replay/idempotency UAT;
- recalculate regulatory completeness with source-gap versus adapter-defect attribution;
- preserve 1,546 Provider / 26,648 Course identity and Search isolation.

Only after this gate passes does the serial data lane proceed to `M1-L2-AU-COURSE-FACTS`.
