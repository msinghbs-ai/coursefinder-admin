# CF-CHG-20260905-211 — H5 Source-Backed Candidate Workflow & H6 Publication Controls

**Status:** H6 ACCEPTED / H5 CANONICAL DETAIL SURFACE IMPLEMENTED / PRIMARY NAV RELEASE STEP OPEN  
**Milestone:** M2.4.5  
**Workstreams:** H5, H6  
**Initiated:** 5 September 2026 17:10 AEST  
**Primary owner:** 30-admin-pim-ux  
**Related:** CF-CHG-20260905-210

## Objective

Implement the governed operator workflow defined by CF-210 without weakening source-authoritative identity, and add explicit previewed publication controls while keeping automatic publication and consumer cutover disabled.

## H5 implementation

Pilot migration `20260905073000_cf_211_h5_h6_candidate_publication_controls.sql` adds private `pipeline.pim_source_candidates` and rank-5 candidate operations exposed through authenticated browser RPC wrappers:

- `manual_pim_candidate_register`;
- `manual_pim_candidates_read`;
- `manual_pim_candidate_decide`.

Candidate states are `submitted`, `validated`, `needs_review`, `ready_for_acquisition`, `rejected`, `cancelled`.

Safety properties:

- Provider/Course/Campus/Scholarship canonical tables are not direct write targets;
- Course/Campus/Provider-owned Scholarship candidates require a canonical Provider;
- source URL or retained Evidence is mandatory;
- actor/reason/timestamps retained;
- active duplicate source identity is prevented;
- candidate decisions explicitly return `canonical_written=false` and `published=false`;
- `ready_for_acquisition` means hand-off to the existing governed acquisition/reconciliation path, not a generic canonical writer.

`src/ManualPimCandidateWorkspace.jsx` implements the rank-5 candidate registration/queue UI and now resolves the current operator rank from the governed context when rank is not explicitly supplied. It also accepts initial entity/provider context from an existing canonical record.

`src/Layer4Intervention.jsx` now exposes this workflow from the existing canonical Provider/Course/Campus/Scholarship detail surface under **Source-backed PIM candidate workflow**. This does not introduce a floating launcher or a second control plane. Provider context is inherited where available; canonical writes and publication remain separate.

A dedicated primary-navigation entry is still considered a release/IA refinement, not a blocker to the governed H5 workflow itself. If added, it must use the existing navigation registry under Quality & Review or Administration.

## H6 implementation and acceptance

The existing `layer4_publication_decide` remains the sole publication-decision primitive. CF-211 adds:

- `publication_control_preview` — non-mutating exact-cohort preview;
- `publication_control_execute` — requires the preview confirmation token before execution;
- maximum cohort size 100;
- explicit target scopes: `governed_publication`, `search_api`, `website`, `zoho`;
- actions: publish, unpublish, rollback;
- exact cohort token retained in Layer 4 approval context;
- `pipeline.publication_control_settings.auto_publication_enabled=false` by default and currently immutable from the Admin surface.

`src/Layer4Intervention.jsx` uses preview → operator confirmation → execute for single-record publication decisions and exposes target-scoped rollback.

The underlying Layer 4 decision still reports `publication_status_changed=false` / `consumer_cutover_authorised=false`; therefore this work does not silently activate Search, Website, Zoho or Production publication.

The hardened H6 baseline at Pilot commit `4eb5e158f33ad871d9dee7abd3fffd9d6f548ee4` passed both Pilot Frontend Build and CourseFinder Deployed UAT on 5 September 2026. H6 is therefore technically accepted. Consumer cutover remains a separate future decision.

## Security hardening

The first runtime migration used public `SECURITY DEFINER` functions with explicit server-side rank checks. Supabase Security Advisor correctly surfaced these as externally callable `SECURITY DEFINER` WARN findings.

Corrective migration `20260905074000_cf_211_h5_h6_private_impl_wrappers.sql` now follows the established CourseFinder private-implementation pattern:

- H5 privileged implementations moved to non-exposed `pim_api`;
- H6 privileged implementations moved to non-exposed `l4_api`;
- public browser RPCs are `SECURITY INVOKER` SQL wrappers;
- `PUBLIC` and `anon` EXECUTE revoked;
- authenticated wrapper access retained;
- private implementations continue to enforce `auth.uid()` and `security.current_role_rank()` server-side;
- candidate/settings tables retain RLS with direct `PUBLIC`, `anon` and `authenticated` table access revoked;
- no service-role key or private Evidence content enters browser code.

Live verification confirms the five public CF-211 browser functions are `security_definer=false`, while their private `pim_api` / `l4_api` implementations retain the privileged server-side boundary.

## Performance disposition

Performance Advisor identified one new CF-211-specific INFO finding: the `pipeline.pim_source_candidates.evidence_id` foreign key lacked a covering index.

Migration `20260905075000_cf_211_h5_candidate_evidence_index.sql` adds `pim_source_candidates_evidence_idx` for Evidence-backed review/query paths. Other Advisor INFO findings are pre-existing platform observations and are not introduced by CF-211.

## Verification

Live Pilot migrations applied successfully to `coursefinder_Pilot`:

1. `cf_211_h5_h6_candidate_publication_controls`;
2. `cf_211_h5_h6_private_impl_wrappers`;
3. `cf_211_h5_candidate_evidence_index`.

Runtime verification confirms:

- all five public CF-211 RPC wrappers are present;
- privileged implementations are outside the public schema;
- public wrappers are not `SECURITY DEFINER`;
- `auto_publication_enabled=false` remains live;
- no consumer cutover has been authorised.

Targeted source contract: `tests/uat/cf-211-h5-h6-candidate-publication-controls.spec.mjs`, extended to cover private wrappers, Evidence FK indexing, operator-context resolution and canonical detail-surface placement.

Verified baseline results:

- Pilot Frontend Build run `33952467996` — SUCCESS;
- CourseFinder Deployed UAT run `33952468057` — SUCCESS.

Current H5 detail-surface candidate head: `d7556a8a0aea078b19aacaa1051ddd98ebdcbf84`. Its fresh build/UAT run must pass before H5 is accepted.

## Remaining closure work

1. Confirm Frontend Build and Deployed UAT on `d7556a8a0aea078b19aacaa1051ddd98ebdcbf84`.
2. Run/confirm rank-4 negative and rank-5 positive browser behaviour for the source-backed candidate control.
3. Re-run Security Advisor after the final H5 browser candidate; CF-211 public `SECURITY DEFINER` findings must remain absent.
4. Decide whether a dedicated primary-nav entry is required for release; if yes, place it through the existing canonical navigation registry and bump the visible Admin version/release notes in the same change.
5. Reconcile M2.4.5 H5/H6 execution state after the final H5 browser gate.

## Rollback

- UI rollback: revert CF-211 component commits.
- Publication decisions are append-only/reversible through `rollback`; no consumer cutover was enabled.
- Database structural rollback, if ever required, must first confirm no retained candidate/audit history needs preservation. Prefer disabling/revoking the RPC surface rather than destructive deletion of governed history.
