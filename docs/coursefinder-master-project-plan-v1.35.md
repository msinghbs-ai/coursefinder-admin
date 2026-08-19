# CourseFinder Master Project Plan v1.35

**Status:** AUTHORITATIVE PROGRAMME GOVERNANCE DOCUMENT  
**Supersedes:** `docs/coursefinder-master-project-plan-v1.34.md`  
**Last consolidated:** 20 August 2026  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.35.md`  
**Running build:** `docs/coursefinder-running-build-v2.39.md`  
**Completeness UAT:** `docs/coursefinder-au-cricos-layer1-adapter-consolidation-uat-v1.2.md`

## Current programme position

| Workstream | Status | Decision |
|---|---|---|
| AU Layer 1 CRICOS identity/geography/field | PASS / ACCEPTED | Preserve 1,546 Provider / 26,648 active Course substrate |
| AU CRICOS regulatory Course facts | PASS / ACCEPTED | Preserve accepted fact/fee model and registered-total-course semantics |
| AU Layer 1 primary adapter consolidation | PASS / ACCEPTED | `layer1-au-depth-v1.6.0` owns governed complete CRICOS refresh path |
| **AU Layer 1 residual completeness remediation** | **PASS / COMPLETE** | 26,648/26,648 Study Levels governed; all residual gaps classified; zero unexplained mapping defects |
| **AU first-party Course facts** | **NEXT ELIGIBLE / PRE-STAGED / NOT YET APPLIED** | `M1-L2-AU-COURSE-FACTS` may proceed only as its own bounded gate from the accepted Layer 1 baseline |
| NZ Layer 1 NZQA | PASS / ACCEPTED | Preserve accepted substrate |
| AU QILT Layer 2A | PASS / ACCEPTED | Maintain governed outcomes |
| AU PRISMS Layer 2A | PASS / ACCEPTED | Maintain time-scoped observations |
| AU Scholarships | PASS / FIRST-SOURCE ACCEPTED | Controlled expansion only |
| Publication/Search completeness | NOT YET FORMALISED FOR AU | Do not conflate regulatory coverage with consumer readiness |
| Search governed projection + FTS | PASS / ACCEPTED | 33,105 documents; unchanged by Layer 1 completeness gate |
| Vector/semantic Search | REJECTED / NOT ADMITTED | Existing `gte-small` candidate rejection remains in force |
| Search enrichment readiness | BLOCKED / SEPARATE GATE | Provider fees/links/intakes/English require separate admission UAT |
| Admin/PIM hardening | PASS / COMPLETE | Existing operational/security acceptance remains in force |

## M1-L1-AU-CRICOS-COMPLETENESS — PASS

The immediate serial AU Layer 1 completeness gate is complete.

Accepted outcomes:

- exactly **1,546 Providers** retained;
- exactly **26,648 active CRICOS Courses** retained;
- all **26,648** populated CRICOS Course Level values mapped deterministically from exact source vocabulary;
- previous missing Study Level count reduced from 2,281 to **0**;
- exact raw vocabulary, source snapshot and evidence retained;
- Course-title inference prohibited where CRICOS Course Level is populated;
- **34** missing Campus relationships classified as authoritative source absence after reconciliation against CRICOS Course Locations;
- **191** missing Tuition Fee values classified as authoritative source absence;
- **191** missing Non Tuition Fee values classified as authoritative source absence;
- no synthetic Campus and no manufactured fee values;
- zero unresolved identity, ambiguity or adapter-defect items;
- Search unchanged and not republished.

## Study Level mapping result

The old 2,281 null Study Levels are fully explained by official CRICOS vocabulary:

- Non AQF Award: 1,755
- Primary School Studies: 246
- Junior Secondary Studies: 241
- Vocational Short Course: 39

The gate also repaired pre-existing semantic collapse for detailed Certificate I-IV, Advanced Diploma, Bachelor Honours, Graduate Certificate, Graduate Diploma and Masters variants.

Total canonical Study Level corrections predicted by full dry-run and reconciled by APPLY: **17,266**.

## Regulatory completeness governance

The programme continues to distinguish:

1. **Source representation completeness** — every populated accepted source fact is represented or explicitly classified.
2. **Regulatory attribute coverage** — accepted Layer 1 regulatory dimensions have usable values or explicit source-gap attribution.
3. **Publication/Search completeness** — separate consumer readiness/freshness/admission criteria.

Current AU regulatory result across 13 accepted dimensions:

- total cells: 346,424
- source-gap cells: 416
- unexplained adapter-defect cells: 0
- regulatory completeness: **99.88%**

Course-level result:

- 26,423 Courses = 13/13
- 34 Courses = 12/13 due only to Campus source absence
- 191 Courses = 11/13 due only to Tuition + Non Tuition source absence

Source absence must remain distinct from adapter defect and must never trigger data manufacture merely to improve completeness.

## UAT acceptance

Full bounded gate UAT is accepted:

- full dry-run: 54 batches / 26,648 Courses / 0 unresolved mappings;
- full APPLY reconciliation: 26,648 mapped / 17,266 semantic corrections reconciled;
- full replay: 54/54 successful, 26,648 observations unchanged, 0 creates, 0 updates, 0 canonical changes;
- Search fingerprint and document count unchanged;
- no running Layer 1 jobs at handover.

Authoritative evidence: `docs/coursefinder-au-cricos-layer1-adapter-consolidation-uat-v1.2.md`.

## Search boundary

Layer 1 completeness does not authorise Search admission.

Verified unchanged Search state:

- Search Documents: 33,105
- accepted embeddings: 0
- fingerprint: `c3cf5dd66a6b69e58f41c72abb4f1e94`

The existing vector candidate rejection remains unchanged. CRICOS registered fees remain distinct from future provider-current fees and still require separate Search admission semantics.

## Next serial gate

With `M1-L1-AU-CRICOS-COMPLETENESS` accepted, the immediate serial prerequisite for `M1-L2-AU-COURSE-FACTS` is satisfied.

`M1-L2-AU-COURSE-FACTS` is now **eligible to proceed**, but this programme update does not count its pre-staged design or prior bounded experiments as an accepted Layer 2 APPLY. The next gate must independently prove authoritative Provider/University mapping by published CRICOS Course code or another governed stable identifier, current fee/intake/English evidence, ambiguity handling, bounded APPLY/replay/idempotency and Search admission separation.

All parallel accepted/rejected workstream decisions from v1.34 remain unchanged unless explicitly superseded above.
