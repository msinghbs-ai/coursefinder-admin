# CF-CHG-20260905-211 — H5 Source-Backed Candidate Workflow & H6 Publication Controls

**Status:** CLOSED / ACCEPTED  
**Milestone:** M2.4.5  
**Workstreams:** H5, H6  
**Initiated:** 5 September 2026 17:10 AEST  
**Closed:** 5 September 2026  
**Accepted visible Admin release:** **v2.15.66**  
**Primary owner:** 30-admin-pim-ux  
**Related:** CF-CHG-20260905-210

## Objective

Implement the governed operator workflow defined by CF-210 without weakening source-authoritative identity, and add explicit previewed publication controls while keeping automatic publication and consumer cutover disabled.

## H5 implementation and acceptance

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

`src/ManualPimCandidateWorkspace.jsx` implements the rank-5 candidate registration/queue UI and resolves the current operator rank from the governed context when rank is not explicitly supplied. It accepts initial entity/provider context from an existing canonical record.

`src/Layer4Intervention.jsx` exposes the workflow from the existing canonical Provider/Course/Campus/Scholarship detail surface under **Source-backed PIM candidate workflow**. This does not introduce a floating launcher or second control plane. Provider context is inherited where available; canonical writes and publication remain separate.

### Navigation decision

A dedicated primary-navigation entry is not required for H5 closure. The existing canonical detail/Layer 4 surface is the accepted operator entry point because it preserves entity/provider context and avoids a duplicate candidate control plane. A future consolidated queue may be added only by reusing the same H5 state/RPC model and may not become a parallel canonical writer.

Accepted H5 head:

- `d7556a8a0aea078b19aacaa1051ddd98ebdcbf84`.

Acceptance:

- Pilot Frontend Build run `33953096725` — SUCCESS;
- CourseFinder Deployed UAT run `33953096702` — SUCCESS.

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

The underlying Layer 4 decision reports `publication_status_changed=false` / `consumer_cutover_authorised=false`; therefore this work does not silently activate Search, Website, Zoho or Production publication.

The hardened H6 baseline at Pilot commit `4eb5e158f33ad871d9dee7abd3fffd9d6f548ee4` passed both Pilot Frontend Build and CourseFinder Deployed UAT. H6 is accepted. Consumer cutover remains a separate future decision.

Mass execution is supported server-side but no broad mass-publish UI is enabled. Any future mass UI must use the same exact preview token and bounded cohort.

## Security hardening

The first runtime migration used public `SECURITY DEFINER` functions with explicit server-side rank checks. Supabase Security Advisor correctly surfaced these as externally callable `SECURITY DEFINER` WARN findings.

Corrective migration `20260905074000_cf_211_h5_h6_private_impl_wrappers.sql` follows the established CourseFinder private-implementation pattern:

- H5 privileged implementations moved to non-exposed `pim_api`;
- H6 privileged implementations moved to non-exposed `l4_api`;
- public browser RPCs are `SECURITY INVOKER` SQL wrappers;
- `PUBLIC` and `anon` EXECUTE revoked;
- authenticated wrapper access retained;
- private implementations continue to enforce `auth.uid()` and `security.current_role_rank()` server-side;
- candidate/settings tables retain RLS with direct `PUBLIC`, `anon` and `authenticated` table access revoked;
- no service-role key or private Evidence content enters browser code.

Final Security Advisor re-check confirms the CF-211 browser functions remain absent from exposed `SECURITY DEFINER` WARN findings. Existing unrelated platform findings remain separate backlog items.

## Performance disposition

Migration `20260905075000_cf_211_h5_candidate_evidence_index.sql` adds `pim_source_candidates_evidence_idx` for Evidence-backed review/query paths.

Final Performance Advisor re-check no longer reports the H5 Evidence foreign key as unindexed. New H5 indexes may appear as unused INFO until representative runtime usage accumulates; unrelated platform INFO observations are outside CF-211 scope.

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

Targeted source contract: `tests/uat/cf-211-h5-h6-candidate-publication-controls.spec.mjs`, covering private wrappers, Evidence FK indexing, operator-context resolution and canonical detail-surface placement.

Final accepted results:

- Pilot Frontend Build run `33953096725` — SUCCESS;
- CourseFinder Deployed UAT run `33953096702` — SUCCESS;
- final Security Advisor check — no new CF-211 WARN/ERROR;
- final Performance Advisor check — CF-211 Evidence-FK issue resolved.

## Release reconciliation

The live Admin UI is confirmed at **v2.15.66**. Earlier governance notes identifying v2.15.57 as the current release were stale documentation and are superseded by this closure record. No artificial version bump or rollback is required solely to close H5/H6.

## Closure decision

### H5

**CLOSED / ACCEPTED.** The source-backed candidate workflow is source/Evidence-backed, rank-gated, auditable, identity-preserving and separate from canonical Apply and publication.

### H6

**CLOSED / ACCEPTED.** Previewed target-scoped publication decisions and rollback are accepted. Automatic publication remains disabled; Search/API, Website, Zoho and Production cutover remain separately governed.

## Rollback

- UI rollback: revert CF-211 component commits.
- Publication decisions are append-only/reversible through `rollback`; no consumer cutover was enabled.
- Database structural rollback, if ever required, must first confirm no retained candidate/audit history needs preservation. Prefer disabling/revoking the RPC surface rather than destructive deletion of governed history.
