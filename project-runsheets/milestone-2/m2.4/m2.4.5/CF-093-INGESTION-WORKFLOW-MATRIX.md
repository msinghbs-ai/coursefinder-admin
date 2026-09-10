# CF-093 — Ingestion workflow orchestration matrix

**Status:** IMPLEMENTATION WORKING NOTE  
**Change Control:** CF-CHG-20260910-093

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

Processing modes:
- **Automatic governed pipeline** — run deterministic acquisition first, invoke Layer 3 only where the governed profile requires Evidence interpretation, and create Layer 4 work only for unresolved eligible items.
- **Acquisition only** — stop after the authorised deterministic stage.
- **Reprocess governed Evidence** — no source reacquisition; available only where an accepted Layer 3 profile/model/revalidation contract exists.

Search and Publication are downstream governed consequences, never selectable ingestion layers.

## Implementation boundary

The UI catalogue must be derived from executable server-authorised source/profile/policy metadata. It must not advertise state/provider/entity scopes that the underlying runtime cannot enforce. Raw UUIDs remain audit identifiers under Technical details only.
