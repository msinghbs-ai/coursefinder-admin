# CF-CHG-20260910-093 — Scheduled Workflow Orchestrator

**Status:** ACTIVE — FRESH CODEX RE-REVIEW PENDING  
**Initiated:** 2026-09-10 AEST  
**Category:** 30-admin-pim-ux  
**Parent:** CF-CHG-20260910-092  
**Pilot PR:** #67 (`m245/scheduled-workflow-orchestrator-20260910`)

## Objective

Extend the accepted CF-092 Scheduled Tasks workspace with task-first operator labels, server-side search, durable creator/owner attribution, per-user column preferences and bounded run/schedule follow-through without changing the authority/security model.

## Preserved authority and security boundaries

- Browser scheduler reads/actions remain on governed public/rank-gated RPC contracts.
- SECURITY INVOKER browser wrappers and private SECURITY DEFINER bridges remain independently rank-gated.
- Layer 3 remains Evidence/profile/model/revalidation governed.
- Layer 4 remains explicit human-resolution work.
- Search/Publication admission is not an implicit result of ingestion or run-on-demand.
- No service-role key, provider credential or private Evidence is exposed to browser code.

## Codex corrective pass — 11 Sep 2026

Codex review of Pilot head `cf9bd3cc9019cde321f215875c8ba99a33e2748c` produced five actionable findings:

1. P1 migration-ordering concern for `20260910213556_cf_093_resolved_actor_search_semantics.sql`.
2. P2 scheduler search must treat `%` and `_` literally.
3. P2 profile-scoped policies must preserve profile identity when `source_id` is also populated.
4. P2 successful run-on-demand must immediately refresh the queue/recent Jobs panels.
5. P2 independent supporting-panel failures must be surfaced rather than silently rendered as empty/stale.

## Repository/runtime reconciliation

Live Pilot Supabase migration history was checked before deployment action. It already records:

- `20260910213556` — `cf_093_resolved_actor_search_semantics`
- `20260910215546` — `cf_093_scheduler_entity_labels`

Accordingly, the Codex P1 recommendation was reconciled against runtime truth rather than applied literally. Removing or retimestamping either already-applied migration would create remote/local history drift. The branch retains those canonical applied identities. A duplicate later entity-label migration was removed.

The forward literal-search correction was applied to Pilot through the governed Supabase migration service and recorded by runtime as:

- `20260910221808` — `cf_093_literal_scheduler_search`

The repository migration filename was reconciled to that exact applied runtime identity. No `--include-all` bypass is used.

## Current implementation evidence

Key corrective commits:

- `564083b2cfb9e1b70b1c8420a6794c557bbb2ee2` — profile identity, panel error states, independent panel loading and post-run panel refresh.
- `07ff6f82c1e136b8dd7283564a44d8d52084ee3a` — remove duplicate applied entity-label migration from branch history.
- `8062ed9a862989fa06b9bcabd5d6cf619b7e889a` — release-history reconciliation for the Codex corrections.
- `407f63effb255c9214638c61cf7df4645b2fc0dd` — current corrective head; repository migration identity reconciled to Pilot runtime `20260910221808`.

## Targeted acceptance evidence

Current Pilot candidate head: `407f63effb255c9214638c61cf7df4645b2fc0dd`.

- Pilot Frontend Build run `34536800843` — PASS; build, UAT suite discovery, local browser smoke and smoke-evidence upload all passed.
- Release History Contract run `34536800985` — PASS.
- Live scheduler literal-search proof after runtime migration: `%` returned 0 rows; `_` returned 3 rows versus 13 unfiltered rows, proving wildcard input no longer expands to all policies. Normal search `AU` returned 11 rows.
- Live policy projection returned three policies carrying both `source_profile_id` and `source_id`, with profile keys preserved alongside source identity.
- Security Advisor rerun after migration: no new CF-093 warning/error regression; existing project-wide `rls_enabled_no_policy` findings remain informational and pre-existing in scope.
- `src/lib/supabase.js` confirms the Recent Jobs panel continues through the governed `admin_read('jobs')` browser boundary and throws read errors to the caller, allowing CF-093 panel-specific failure state to surface them.

## Acceptance sequence

Completed:

1. Repository/runtime migration identity reconciliation.
2. Forward Pilot runtime correction only.
3. Focused runtime search/profile projection proof.
4. Pilot Frontend Build + local browser smoke PASS.
5. Release History Contract PASS.
6. Security Advisor check with no new CF-093 warning/error regression.
7. CHANGELOG/release metadata reconciliation.

Pending before merge:

8. Fresh Codex re-review of exact head `407f63effb255c9214638c61cf7df4645b2fc0dd` with no new actionable findings.
9. Merge PR #67 only after the re-review gate is clean.
10. Post-merge deployment and nominated deployed acceptance/currentness verification.

## Rollback

- UI changes can be reverted independently to the previous accepted PR head without altering accepted CF-092 runtime semantics.
- Do not delete or rewrite migration-history entries already applied to Pilot.
- Forward function corrections must be reverted through a new forward migration if required.

## Remaining gate

**BLOCKER:** fresh Codex re-review for exact head `407f63effb255c9214638c61cf7df4645b2fc0dd` has been requested but no result is present yet. PR #67 must remain unmerged and production deployment must not proceed until that gate is clean.
