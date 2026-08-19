# CourseFinder Running Build v2.39

**Status:** CURRENT RUNNING BUILD  
**Date:** 20 August 2026  
**Supersedes:** `docs/coursefinder-running-build-v2.38.md`  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.35.md`  
**Master plan:** `docs/coursefinder-master-project-plan-v1.35.md`  
**UAT:** `docs/coursefinder-au-cricos-layer1-adapter-consolidation-uat-v1.2.md`

## Build delta

`M1-L1-AU-CRICOS-COMPLETENESS` is now **PASS / COMPLETE**.

The prior v2.38 Search Vector rejection and v2.37 Admin/PIM hardening PASS remain accepted unchanged. Search remains governed FTS only with zero accepted embeddings.

The AU Layer 1 serial prerequisite for `M1-L2-AU-COURSE-FACTS` is satisfied. Layer 2 was not advanced or applied by this build.

## Verified AU Layer 1 state

- Providers: **1,546**
- active CRICOS Courses: **26,648**
- governed Study Level: **26,648 / 26,648**
- missing Study Level: **0**
- missing canonical Campus: **34**, all authoritative source absence
- missing CRICOS Tuition Fee: **191**, authoritative source absence
- missing CRICOS Non Tuition Fee: **191**, authoritative source absence
- unexplained Layer 1 mapping defects: **0**
- regulatory completeness: **99.88%**

No Provider/Course identity count changed.

## Accepted CRICOS Study Level implementation

Primary AU adapter:

- `layer1-au-depth-v1.6.0`
- carries exact CRICOS `course_level_raw`;
- resolves through governed exact source-value mappings;
- persists raw vocabulary/evidence/history;
- fails closed for unmapped/review-required values or identity misses;
- never uses title inference when CRICOS Course Level is populated.

Bounded gate replay worker:

- `layer1-au-completeness-v1.1.0`
- one-time nonce controlled;
- private evidence artifact + SHA-256 required;
- maximum 500 active Courses per invocation;
- same production Study Level RPC;
- no Search action.

## Database delta

Applied production migrations:

- `20260819225529_m1_l1_au_cricos_study_level_governance_v1`
- `20260819231043_m1_l1_evidence_descriptor_service_v1`
- `20260819231907_m1_l1_au_cricos_study_level_evidence_index_v1`

New governed structures/services:

- `ref.study_level_source_mappings`
- `catalogue.course_study_level_observations`
- `public.svc_layer1_apply_course_study_levels(...)`
- `public.svc_layer1_evidence_descriptor(...)`

## UAT result

### Full dry-run

- 54 bounded batches
- 26,648 Courses selected
- 26,648 exact Study Level mappings
- unmapped: 0
- review-required: 0
- Course identity misses: 0
- predicted semantic corrections: **17,266**
- core conflicts: 0

### APPLY

- 54/54 focused bounded batches successful
- 26,648 mapped
- total semantic corrections reconciled: **17,266**
- unresolved mappings: 0

### Replay / idempotency

- 54/54 successful
- 26,648 mapped
- 26,648 observations unchanged
- observations created: 0
- observations updated: 0
- canonical Study Level changes: 0
- Course identity misses: 0

## Exact source vocabulary inventory

The current source contains 20 Course Level values; all are governed. The previous 2,281 missing canonical Study Levels are exactly explained by:

- Non AQF Award: 1,755
- Primary School Studies: 246
- Junior Secondary Studies: 241
- Vocational Short Course: 39

The remediation also corrected pre-existing semantic over-collapse for detailed Certificate, Advanced Diploma, Honours, Graduate and Masters variants.

## Campus and fee source-gap classification

All 34 Campus gaps have zero corresponding current CRICOS Course Location rows and remain source absent. No synthetic Campus was created.

Fresh source audit reconfirms 191 blank Tuition Fee and 191 blank Non Tuition Fee values. The same 191 Courses lack both. No fee was manufactured or annualised.

Current active CRICOS fee observations remain:

- estimated total: 26,648
- tuition: 26,457
- non-tuition: 26,457
- total: 79,562

Semantics remain AUD / international / registered total course / no fee year / not annualised.

## Search state unchanged

Before and after the gate:

- Search Documents: **33,105**
- accepted embeddings: **0**
- Search fingerprint: `c3cf5dd66a6b69e58f41c72abb4f1e94`
- max Search `updated_at`: `2026-08-19 04:54:40.774052+00`

No Search projection rebuild or enrichment admission occurred.

## Security/performance verification

New mapping and observation tables are RLS-enabled and service-role operated. The new SECURITY DEFINER services have explicit service-role guards, fixed `search_path` and no browser-role execution grants.

The gate-created missing FK index finding was corrected with `course_study_level_observations_evidence_idx`. Remaining advisor items are pre-existing programme-level findings outside this gate.

## Current serial programme position

1. `M1-L1-AU-CRICOS-COMPLETENESS` — **PASS / COMPLETE**
2. `M1-L2-AU-COURSE-FACTS` — **NEXT ELIGIBLE / NOT STARTED BY THIS BUILD**
3. Search enrichment admission — remains separately governed and blocked until its own UAT/admission gate

The v2.38 vector rejection remains in force; no semantic/vector candidate has been admitted.
