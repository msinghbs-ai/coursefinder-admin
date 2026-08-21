# CourseFinder M1-DATA-QUALITY-READINESS — Technical Acceptance UAT

**Date:** 21 August 2026  
**Change Control:** `CF-CHG-20260821-018`  
**Workstream:** `M1-DATA-QUALITY-READINESS — Completeness, Freshness, Exceptions & Decision-Queue Gate`  
**Technical result:** **PASS**  
**Overall gate:** **BLOCKED — deployed authenticated browser acceptance cannot be executed from the current environment**

## 1. Acceptance scope

Validate a governed Data Quality operational workspace across Provider, Course, Campus, Scholarship and enrichment domains without manufacturing missing values or replacing country/source-specific authority with an equal-weight generic score.

Required domains:

- identity completeness;
- regulatory completeness;
- geography/delivery;
- taxonomy;
- regulatory fee;
- current Provider fee;
- Course URL;
- Intake;
- English requirement;
- Scholarship;
- evidence;
- verification/freshness;
- Search admission;
- publication readiness.

Required states:

`present / source_null / not_applicable / zero / suppressed / not_yet_enriched / stale / ambiguous / rejected`.

## 2. Reconciliation before implementation

The workstream was reconciled before change against:

- `PROJECT_INSTRUCTIONS.md`;
- current Change Control register/categories;
- Master Project Plan v1.58;
- Running Build v2.61;
- Database Architecture v2.10.38;
- Admin/PIM Design Decisions v1.11;
- PIM Admin Guide v1.12;
- accepted controls 012, 014, 015, 016 and 017;
- `coursefinder-admin/main` at `179af497c56673c9bd2089b71e2891d89b65a840`;
- `Coursefinder-Pilot/main` at `fda4270f3c440b8253b87da1a8c35a4b2769413e`;
- live Supabase project `fxcwkweaxjtknorudmwp`.

The accepted Pilot branch did not move during implementation before PR creation/merge, so no parallel frontend work was overwritten.

## 3. Composite-score decision

The cross-domain composite percentage is **not exposed**.

Live API policy returns:

- `composite_score = not_exposed`;
- ready states = `present`, `zero`;
- `not_applicable` excluded from denominator;
- reason: equal weighting conflates regulatory authority, enrichment coverage, Search admission and publication state.

The legacy six-signal Course percentage can remain as a backward-compatible catalogue display/history signal; it is not the authoritative Data Quality product score.

**Result: PASS.**

## 4. Live migration / read-contract implementation

Live Supabase migration ledger:

| Version | Migration |
|---|---|
| `20260821050044` | `m1_data_quality_readiness_v1` |
| `20260821050313` | `m1_data_quality_readiness_course_base_fast_v1` |
| `20260821050457` | `m1_data_quality_readiness_overview_fast_v2` |
| `20260821050825` | `m1_data_quality_readiness_exceptions_fast_v2` |
| `20260821050846` | `m1_data_quality_readiness_runtime_memory_v1` |

Browser operations added to the existing dispatcher:

- `public.admin_read('data_quality_overview', p_args)`;
- `public.admin_read('data_quality_exceptions', p_args)`.

Internal implementation remains under `security.*`.

Repository reconciliation note: the accepted Pilot repository does not currently mirror several immediately preceding live PIM/Evidence/Pipeline migration files either (including `m1_pipeline_ops_safe_source_projection_v1` and `m1_evidence_ux_country_source_filter_v1`). This gate therefore records the authoritative live Supabase migration ledger rather than inventing a Data-Quality-only migration-storage convention. Executable frontend source is committed in `Coursefinder-Pilot`.

**Result: PASS under current programme migration-recording pattern.**

## 5. AU+NZ semantic UAT

Technical scope:

- Providers: 1,955;
- Courses: 33,105;
- Campuses: 3,922;
- Scholarships: 4;
- Search Course documents: 33,105.

### Identity completeness

Scoped Provider/Course/Campus/Scholarship identity returned 100% present.

No title/name inference was introduced.

**PASS.**

### Regulatory completeness

Scoped AU+NZ Provider/Course Layer 1 regulatory identity returned 100% present under the accepted CRICOS/NZQA country contracts.

**PASS.**

### Geography / delivery

Course states:

- present: 26,614;
- AU `source_null`: 34;
- NZ `not_yet_enriched`: 6,457.

The 34 AU exceptions match the accepted CRICOS residual UAT proving current CRICOS Course Locations contains no relationship for those Courses. No synthetic Campus was created.

**PASS.**

### Regulatory fee

Course states:

- positive/present: 26,326;
- zero: 131;
- AU source-null: 191;
- NZ not-applicable: 6,457.

The 191 AU gaps match accepted CRICOS source-absence evidence. NZ is excluded because the accepted NZQA Layer 1 contract has no CRICOS-equivalent regulatory tuition dimension.

The 131 zero values count as ready rather than missing.

**PASS.**

### Layer 2 Course facts

Current accepted Course coverage:

- Provider-current fee: 10 present / 33,095 not-yet-enriched;
- Course URL: 10 present / 33,095 not-yet-enriched;
- Intake: 10 Courses present / 33,095 not-yet-enriched;
- English requirement: 10 Courses present / 33,095 not-yet-enriched.

The unenriched majority is not fabricated as source-null.

**PASS.**

### Scholarship

Course Scholarship applicability:

- present: 500;
- not-yet-enriched: 32,605.

Scholarship remains relational enrichment rather than a mandatory Course identity field.

**PASS.**

### Evidence

Evidence/entity lineage returned present for all scoped Provider/Course/Campus/Scholarship entities in the readiness aggregate.

Evidence drill-down remains role-gated through the accepted Evidence workspace.

**PASS.**

### Verification / freshness

Provider/Course/Campus current verification states are reported from governed verification timestamps. Scholarship verification is not inferred from `updated_at`; current Scholarship rows therefore remain not-yet-enriched for explicit verification.

**PASS.**

### Search admission

All 33,105 accepted AU+NZ Courses are present in the governed Search projection.

No Search rebuild or publication decision was performed by this workstream.

**PASS.**

### Publication readiness

No Search projection row is treated as evidence of publication. Current canonical/channel progression remains independent and is not manufactured into a published/ready state.

**PASS.**

### Suppressed / ambiguous / rejected vocabulary

Current sampled AU+NZ aggregate counts are zero for these states, but all remain explicit states in the API and UI contract rather than disappearing from the model.

**PASS.**

## 6. Drill-down UAT

Bounded call:

`data_quality_exceptions(entity_type=course, domain=regulatory_fee, state=source_null, country_code=AU)`

returned:

- total = 191;
- bounded page payload;
- entity UUID/name/stable key;
- Provider/country context;
- Source ID/label;
- Evidence ID where available;
- verification/update timestamps;
- Review ID where an open review exists.

Frontend route review found and corrected one defect before promotion: Evidence navigation initially used `#evidence?id=...`; the accepted Evidence workspace consumes `evidence_id`. Final Pilot code uses `#evidence?evidence_id=...`.

No page-level per-row detail RPC is issued. Canonical entity, Evidence and Review navigation are explicit operator actions.

**PASS.**

## 7. ACL / role UAT

Live privileges after implementation:

| Function | anon EXECUTE | authenticated EXECUTE | service_role EXECUTE |
|---|---|---|---|
| `public.admin_read` | no | yes | yes |
| `security.admin_data_quality_read` | no | yes | yes |
| `security.data_quality_overview_impl` | no | no | no |
| `security.data_quality_exceptions_impl` | no | no | no |
| `security.data_quality_course_base` | no | no | no |
| `security.data_quality_provider_base` | no | no | no |
| `security.data_quality_campus_base` | no | no | no |
| `security.data_quality_scholarship_base` | no | no | no |

An authenticated Platform Admin simulation successfully returned an AU overview with 30 domain/entity metrics and `composite_score = not_exposed`.

No internal helper was promoted as a browser RPC surface.

**PASS.**

## 8. Existing dispatcher regression

Authenticated bounded regression returned:

- `dashboard` → valid object;
- AU `courses_page` → total 26,648;
- `evidence_page` → valid page, total 1,567 at test time;
- `pipeline_overview` → valid object;
- `publication_overview` → valid object;
- Data Quality regulatory-fee source-null → total 191.

No existing Catalogue/Evidence/Pipeline/Publication dispatcher route was replaced.

**PASS.**

## 9. Performance UAT

The first implementation was rejected during UAT because the full AU+NZ overview measured approximately 9.0 s and spilled temporary buffers.

Optimisation narrowed/remodelled the read path and added bounded function-local work memory.

Observed final samples:

| Query | Result | Temp spill |
|---|---:|---:|
| full AU+NZ overview, final warm sample | **~836.6 ms** | 0 |
| AU regulatory-fee source-null, 50 rows, final warm sample | **~155.8 ms** | 0 |
| earlier final cold overview after spill removal | ~4.0 s | 0 |

The Admin therefore uses one aggregate RPC and one paged exception RPC rather than an N+1 page pattern.

**PASS.**

## 10. Supabase advisor UAT

Security advisor after implementation reports the existing private-schema `RLS enabled / no policy` INFO pattern and the previously known leaked-password-protection warning. No Data Quality table was introduced and no new Data Quality-specific advisor finding was created.

Performance advisor reports pre-existing unrelated unindexed-FK/unused-index INFO items. No new Data Quality table/index finding is present.

These programme-level findings are not reclassified as defects introduced by this gate.

**PASS for change-specific advisor regression.**

## 11. Frontend source/build/promotion UAT

Pilot implementation files:

- `src/data-quality-entry.jsx`;
- `src/data-quality.css`;
- `index.html` runtime integration/marker.

The workspace intercepts the accepted `Completeness` navigation action before the legacy component issues its old two-`courses_page` reads and routes to `#data-quality-readiness`.

GitHub PR:

`msinghbs-ai/Coursefinder-Pilot#18`

Production build:

- workflow: `Pilot Frontend Build`;
- run ID: `32450608567`;
- run number: 103;
- Node setup: PASS;
- dependency install: PASS;
- `vite build`: PASS;
- overall conclusion: SUCCESS.

PR #18 was merged after technical UAT.

Promoted Pilot main commit:

`d2e59771e52b6664c1da7427e4d8125d54963e0b`

Visible runtime marker in source:

`PIM Admin v2.12 · Pipeline Ops v1.0 · Evidence v1.0 · Data Quality v1.0 · governed`

**Source/build/promotion result: PASS.**

## 12. Deployed authenticated browser gate

Correct runtime from accepted prior recovery UAT:

`coursefinder-pilot.techm.workers.dev`

This execution environment has:

- no Cloudflare control-plane connector;
- no Wrangler authentication/runtime network access;
- no authenticated browser session for the Pilot application;
- public-web tooling that cannot directly open the unindexed Worker URL from connector-derived context.

GitHub does not expose a Cloudflare deployment status on the merged commit through the available commit-status surface.

Therefore source merge is **not** represented as proof that Cloudflare completed deployment, and the authenticated UI interaction cannot be fabricated.

Required final deployed checks remain:

1. hard-refresh the live Worker and confirm the Data Quality v1.0 marker/current bundle;
2. authenticated `Completeness` navigation opens the domain-readiness workspace;
3. AU+NZ overview loads;
4. clicking AU regulatory tuition source-null opens the 191-row exception population with paging;
5. canonical Course navigation opens correctly;
6. Evidence navigation opens the selected `evidence_id` for Curator+ roles;
7. Review navigation remains role-gated;
8. browser telemetry uses `/rest/v1/rpc/admin_read` and no direct private Data Quality helper;
9. existing Dashboard/Catalogue/Evidence/Pipeline pages remain functional in the deployed bundle.

**Result: BLOCKED — execution environment cannot supply the required deployed authenticated browser evidence.**

## 13. Search/data mutation isolation

This workstream did not:

- create/delete Provider, Course, Campus or Scholarship identity;
- manufacture Course location, fee, URL, intake, English or Scholarship values;
- rebuild Search;
- change Search admission;
- change publication state;
- change Review decisions;
- change Evidence artifacts or private Storage.

**PASS.**

## 14. Verdict

| Gate | Result |
|---|---|
| Governance reconciliation | PASS |
| Domain/state semantics | PASS |
| No manufactured values | PASS |
| Aggregate-to-exception drill-down | PASS |
| ACL/private-helper boundary | PASS |
| Existing dispatcher regression | PASS |
| AU+NZ performance / no N+1 | PASS |
| Advisor regression | PASS |
| Frontend production build | PASS |
| Pilot source promotion | PASS |
| Deployed authenticated browser | **BLOCKED** |

### Overall `M1-DATA-QUALITY-READINESS`

**BLOCKED WITH EVIDENCE — only the deployed authenticated browser gate remains unproven.**

The blocker is not a canonical-data, Supabase-contract, security, performance or frontend-build defect. The candidate is already promoted to the correct Pilot source repository and is rollback-safe/additive, but CourseFinder governance does not treat source publication as deployed-browser proof.
