# CF-CHG-20260905-211 — H5 Source-Backed Candidate Workflow & H6 Publication Controls

**Status:** IMPLEMENTED / TARGETED RUNTIME PASS / UI INTEGRATION PARTIAL  
**Milestone:** M2.4.5  
**Workstreams:** H5, H6  
**Initiated:** 5 September 2026 17:10 AEST  
**Primary owner:** 30-admin-pim-ux  
**Related:** CF-CHG-20260905-210

## Objective

Implement the governed operator workflow defined by CF-210 without weakening source-authoritative identity, and add explicit previewed publication controls while keeping automatic publication and consumer cutover disabled.

## H5 implementation

Pilot migration `20260905073000_cf_211_h5_h6_candidate_publication_controls.sql` adds private `pipeline.pim_source_candidates` and authenticated rank-5 RPCs:

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

`src/ManualPimCandidateWorkspace.jsx` implements the rank-5 candidate registration/queue UI. Canonical shell placement remains the remaining H5 UI integration step; it must be added to the existing navigation registry rather than through a floating launcher.

## H6 implementation

The existing `layer4_publication_decide` remains the sole publication-decision primitive. CF-211 adds:

- `publication_control_preview` — non-mutating exact-cohort preview;
- `publication_control_execute` — requires the preview confirmation token before execution;
- maximum cohort size 100;
- explicit target scopes: `governed_publication`, `search_api`, `website`, `zoho`;
- actions: publish, unpublish, rollback;
- exact cohort token retained in Layer 4 approval context;
- `pipeline.publication_control_settings.auto_publication_enabled=false` by default and currently immutable from the Admin surface.

`src/Layer4Intervention.jsx` now uses preview → operator confirmation → execute for single-record publication decisions and exposes target-scoped rollback.

The underlying Layer 4 decision still reports `publication_status_changed=false` / `consumer_cutover_authorised=false`; therefore this work does not silently activate Search, Website, Zoho or Production publication.

## Security

- private candidate/settings tables: RLS enabled and direct `PUBLIC`, `anon`, `authenticated` table access revoked;
- public RPCs revoke `PUBLIC`/`anon` EXECUTE and grant `authenticated` only;
- every RPC re-checks `auth.uid()` and `security.current_role_rank()` server-side;
- H5/H6 mutation requires rank 5+;
- no service-role key or private Evidence content enters browser code.

## Verification

Live Pilot migration applied successfully to project `coursefinder_Pilot`.

Runtime verification confirms all five CF-211 RPCs are present and only `authenticated` has explicit EXECUTE among `PUBLIC`/`anon`/`authenticated`.

Targeted source contract: `tests/uat/cf-211-h5-h6-candidate-publication-controls.spec.mjs`.

A local clone-based test attempt was unavailable because the execution container has no external DNS. This does not invalidate the live database verification; normal repository CI/deployed UAT remains the closure gate.

## Remaining closure work

1. Wire `ManualPimCandidateWorkspace` into the canonical Admin/PIM navigation registry, preferably under Quality & Review or Administration according to the accepted IA decision.
2. Bump visible Admin version/release notes for the browser-facing H5/H6 controls.
3. Run frontend build + targeted deployed UAT including rank-4 negative, rank-5 positive, duplicate candidate rejection, preview-token mismatch and rollback.
4. Run security/performance advisors and disposition any new WARN/ERROR.
5. Update M2.4.5 CURRENT-STATE/FOLLOW-UPS and close H5/H6 only after deployed browser acceptance.

## Rollback

- UI rollback: revert CF-211 component commits.
- Publication decisions are append-only/reversible through `rollback`; no consumer cutover was enabled.
- Database structural rollback, if ever required, must first confirm no retained candidate/audit history needs preservation. Prefer disabling/revoking the RPC surface rather than destructive deletion of governed history.
