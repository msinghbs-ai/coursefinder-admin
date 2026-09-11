# CF-093 — Ingestion workflow orchestration matrix

**Status:** ACTIVE IMPLEMENTATION AUTHORITY  
**Change Control:** CF-CHG-20260910-093  
**Updated:** 11 September 2026

| Workflow | Operator scope | L1 | L2 | L3 | L4 | Default orchestration |
|---|---|---:|---:|---:|---:|---|
| AU CRICOS regulatory ingestion | AU authority dataset | yes | no | no | exception only | L1 validate/dry-run/apply only |
| NZQA regulatory ingestion | NZ authority dataset | yes | no | no | exception only | L1 only |
| QILT statistical ingestion | AU dataset/edition | yes operational | no | no | mapping exception | L1 statistical run |
| PRISMS statistical ingestion | AU dataset/edition | yes operational | no | no | mapping exception | L1 statistical run |
| QS/THE publisher rankings | edition / publisher | yes reference | no | no | ambiguous mapping | L1 -> deterministic mapping -> L4 exceptions |
| Course facts enrichment | country/state/provider/course cohort | no | yes | conditional | conditional | L2 -> L3 only when profile requires -> L4 unresolved |
| Course URL discovery | country/state/provider/course cohort | no | yes | normally no | ambiguous identity | L2 deterministic identity verification |
| Current tuition/intakes/requirements | country/state/provider/course cohort | no | yes | conditional | conditional | L2 -> conditional L3 -> L4 unresolved |
| Scholarships acquisition | country/source/bounded target | no | yes | conditional | conditional | L2 -> conditional L3 -> L4 unresolved |
| Scholarship course mapping | provider/course governed scope | no | yes deterministic | conditional unresolved semantics | yes unresolved | explicit deterministic mapping; no inferred eligibility |
| Scholarship maintenance | qualified source/bounded target | no | yes | conditional | no by default | source/hash check -> affected L2/L3 only |
| Provider international contacts | country/state/provider | no | yes acquisition | yes interpretation | yes unresolved | L2 Evidence -> L3 extraction -> L4 exceptions |
| Provider assets/logos | country/state/provider | no | yes | normally no | approval/review | L2 -> conditional L4 |
| Supporting screenshot Evidence | source/profile target | no | yes support | no | no | supporting Evidence job only |
| Course learning outcomes / careers | country/provider/course | no | future/conditional | future/conditional | future/conditional | only when source/profile is qualified |

## Universal operator target model

`Job / Dataset -> Country -> Scope Type -> Target -> Processing Mode -> Run now / Schedule`

Processing modes are governed capabilities, not client-side switches:

- **Automatic governed pipeline** — deterministic acquisition first, Layer 3 only where a qualified Evidence/profile/model contract requires interpretation, and Layer 4 only for unresolved eligible items.
- **Acquisition only** — stop after the authorised deterministic stage.
- **Reprocess governed Evidence** — no source reacquisition; available only through an accepted Evidence/profile/model/revalidation contract.

Search and Publication remain downstream governed consequences, never selectable ingestion layers.

## Current executable slice

As of Pilot runtime migration `20260911021144 cf_093_scheduler_workflow_builder_slice`, Scheduled Tasks may build and preview only **AU Layer 2 Course Facts** targets using the existing server-authorised Layer 2 scope services:

- Country = AU;
- Scope = Country, State/Territory, or University/Provider;
- Run mode = **Acquisition + deterministic Layer 2** only;
- preview returns catalogue, queueable, discovery-needed and active-run counts;
- execution delegates to the existing governed `layer2_operator_scope_service` rather than manufacturing browser-side targets;
- a durable dispatch record is written to governed Jobs.

Not yet executable from this builder:

- NZ Layer 2 Course enrichment;
- automatic generic L2 -> L3 -> L4 orchestration;
- generic Layer 3 Evidence reprocessing;
- arbitrary L1 dataset construction;
- country/state recurring schedule creation;
- any scope the worker cannot enforce server-side.

University recurring scheduling is only **potentially eligible** after a verified single-profile mapping. It is not enabled by the current UI/runtime slice.

## Implementation boundary

The UI catalogue must be derived from executable server-authorised source/profile/policy metadata. It must never advertise a country/state/provider/entity scope simply because a future design exists. Raw UUIDs remain audit identifiers under Technical details only.
