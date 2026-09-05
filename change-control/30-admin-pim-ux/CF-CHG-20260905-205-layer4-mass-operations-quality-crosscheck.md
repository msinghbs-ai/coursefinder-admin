# CF-CHG-20260905-205 — Layer 4 Mass Operations & Quality Cross-check

**Status:** CLOSED / PASS — RUNTIME + BUILD + DEPLOYED UAT  
**Milestone:** M2.4.5  
**Type:** FEATURE / OPERATIONS / ADMIN-PIM UX  
**Initiated:** 5 September 2026 13:12 AEST  
**Closed:** 5 September 2026 13:25 AEST  
**Originating workstream:** CF M2.4.5 — Scholarships Acquisition & PIM Completion  
**Primary owner:** 30-admin-pim-ux  
**Affected surfaces:** Layer 4 Human Resolution, Scholarship Course scope, Evidence, Layer 2/3 returns, operator quality review, release/UAT  

## Requested outcome

Replace impractical one-record-at-a-time Layer 4 handling with a simple, safe cohort workflow for repeatable review work. Operators must be able to cross-check structural errors, issues and improvement opportunities before making one audited mass decision for a governed cohort.

## Before

- Scholarship Course-scope review exposed 2,199 `needs_review` candidates individually.
- The generic Layer 4 queue had six pending Scholarship scope items but the UI remained row-oriented.
- Operators lacked a single operational cross-check for missing Evidence, Provider mismatch, stale review, accepted-without-mapping integrity and large cohorts.
- Existing Layer 4 terminal approval semantics only safely support Course scalar facts, so generic bulk approval could not be assumed.

## Implemented workflow

### Cohort operations

Scholarship Course-scope candidates are grouped by exact `scholarship_id + candidate_reason`. Current Pilot state resolves the 2,199 rows into 10 operator cohorts instead of 2,199 individual decisions.

Each cohort preview shows candidate count, Evidence coverage, missing Evidence, Scholarship/Course Provider mismatch, existing Course mappings, study-level spread, semantic-scope warning and a bounded Course sample.

Mass accept/reject requires Pipeline Operator rank or higher, an audited reason, exact typed confirmation (`ACCEPT N` / `REJECT N`) based on the live cohort count, and zero missing Evidence/provider mismatch for acceptance.

Accepted cohorts create governed `scholarship.course_mappings` with Evidence, actor and `layer4_mass_review:<operation_id>` basis. Rejected cohorts remain traceable through candidate state and the mass-operation ledger. Publication and Search refresh remain separate.

### Generic Layer 4 queue

Pending generic review items are grouped by exact `entity_type + field_code + escalation_reason` and may be mass rejected, returned to Layer 2, returned to Layer 3 or sent for more Evidence.

The implementation deliberately does **not** bulk-approve generic scalar review items because proposed values can differ and the existing terminal apply contract is Course-scalar-specific.

### Errors / issues / improvements

Layer 4 now exposes deterministic diagnostics for missing Scholarship-scope Evidence, Scholarship/Course Provider mismatch, stale Scholarship-scope review, stale generic Layer 4 review, accepted candidates without a corresponding canonical Course mapping, and large cohorts that should be handled as one governed rule/decision rather than row-by-row.

Operators can promote a diagnostic into a private tracked finding classified as `error`, `issue` or `improvement`, then resolve it with a note. Mass-operation history is separately retained for audit.

## Runtime objects

Private tables:
- `pipeline.layer4_mass_operations`
- `pipeline.layer4_quality_findings`

Guarded RPCs:
- `public.layer4_mass_summary()`
- `public.layer4_scholarship_scope_groups(integer)`
- `public.layer4_scholarship_scope_preview(uuid,text)`
- `public.layer4_scholarship_scope_bulk_decide(uuid,text,text,text,text)`
- `public.layer4_review_groups(integer)`
- `public.layer4_review_bulk_decide(text,text,text,text,text,text,integer)`
- `public.layer4_quality_diagnostics()`
- `public.layer4_quality_finding_upsert(text,text,text,text,text,jsonb)`
- `public.layer4_quality_finding_resolve(uuid,text,text)`
- `public.layer4_quality_findings_read(text,integer)`
- `public.layer4_mass_operations_history(integer)`

Runtime migrations:
- `cf_205_layer4_mass_operations_quality_workflow`
- `cf_205_layer4_semantic_warning_precision`

Repository replay migrations:
- `supabase/migrations/20260905031200_cf_205_layer4_mass_operations_quality_workflow.sql`
- `supabase/migrations/20260905031800_cf_205_layer4_semantic_warning_precision.sql`

## UI

Added:
- `src/layer4-mass-operations-entry.jsx`
- `src/layer4-mass-operations.css`

The workspace mounts inside the existing `Layer 4 — Human Resolution` route and does not add a floating launcher or second navigation pattern.

Tabs:
1. Scholarship scope
2. Review queue
3. Errors & improvements
4. Mass audit

Visible release: **v2.15.65**.

Operator guide:
- `docs/coursefinder-layer4-mass-operations-operator-guide-v1.0.md`

## Security / authority

- New tables have RLS enabled.
- Direct table access is revoked from public, anon and authenticated roles.
- Curator rank (`>=3`) can read/preview and manage findings.
- Pipeline Operator rank (`>=4`) is required for mass mutation.
- Exact live-count confirmation prevents stale-screen bulk decisions.
- Mass Scholarship acceptance fails closed on missing Evidence or Provider mismatch.
- No browser secret exposure was introduced.
- No direct canonical Provider/Course identity mutation was added.
- No automatic Publication, Website, Zoho or Production cutover is authorised.

## Runtime verification — 5 September 2026

Pilot summary after CF-205:
- Scholarship Course-scope pending: **2,199**
- Scholarship Course-scope cohorts: **10**
- Generic Layer 4 pending: **6**
- Generic Layer 4 cohorts: **1**
- Missing Evidence blockers: **0**
- Provider mismatch blockers: **0**
- Stale Scholarship-scope review: **0**
- Current large-cohort improvement signals: **5**
- Mass mutations executed during implementation: **0**
- Publication changed: **false**

Sample cohort checks include UNSW 665, UQ 382 and UWA 324+324 rows with full retained Evidence coverage and zero Provider mismatch. Eligibility/exclusion/no-explicit-scope semantics are visibly warned for operator cross-check rather than silently accepted.

## Regression protection

CF-102 Provider logo display, private signed access and UI cache behaviour are not touched by CF-205 and are explicitly retained in v2.15.65 release notes.

Source contract:
- `tests/uat/cf-205-layer4-mass-operations-contract.spec.mjs`

## Implementation refs

Pilot commits:
- `c6d68aef6a85027d85028c2a02b7531593d46f4a` — mass operations workspace
- `d101de36ec6545d53bcf15aec52d7f553d2f8d5e` — workspace styling
- `e2849b378a4fd78a274347a1a09b960922d283dd` — load workspace / v2.15.65 title
- `d40f5d7bf9a992257b1817ca96b22f564b6ff903` — v2.15.65 release currentness
- `8d03371ac3d11805f0b65771d6e412567ad4f69e` — replay-safe CF-205 core migration
- `da2ef599b8e82468b0caa3f15da1298f3c588047` — legacy scope-warning precision
- `1d0ee2de86d3f9bd67e95d409776ba27f0edc8e9` — CF-205 source contract

CI acceptance at final Pilot source `da2ef599b8e82468b0caa3f15da1298f3c588047`:
- Pilot Frontend Build run **1642 / 33941727763 — PASS**
- CourseFinder Deployed UAT run **1517 / 33941727752 — PASS**

## Rollback / recovery

UI rollback can remove the CF-205 entry script and stylesheet while leaving audit data intact. RPC exposure may be revoked independently. Do not destructively delete executed mass-operation history. Any accepted/rejected cohort decision requiring reversal must use a governed corrective operation with Evidence and audit rather than deleting mappings or decision records directly.

## Final gate

Runtime read/preview/security invariants PASS. Source/build PASS. Deployed UAT PASS. No Scholarship cohort was mass-accepted or rejected during implementation; the workflow is available for governed operator decisions without changing Publication.
