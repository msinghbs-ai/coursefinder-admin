# CF-CHG-20260910-093 — Scheduled Workflow Orchestrator

**Status:** ACTIVE — CODEX CORRECTIVE ACCEPTANCE  
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

Latest Codex review of Pilot head `cf9bd3cc9019cde321f215875c8ba99a33e2748c` produced five actionable findings:

1. P1 migration-ordering concern for `20260910213556_cf_093_resolved_actor_search_semantics.sql`.
2. P2 scheduler search must treat `%` and `_` literally.
3. P2 profile-scoped policies must preserve profile identity when `source_id` is also populated.
4. P2 successful run-on-demand must immediately refresh the queue/recent Jobs panels.
5. P2 independent supporting-panel failures must be surfaced rather than silently rendered as empty/stale.

## Repository/runtime reconciliation

Live Pilot Supabase migration history was checked before acting. It records:

- `20260910213556` — `cf_093_resolved_actor_search_semantics`
- `20260910215546` — `cf_093_scheduler_entity_labels`

Therefore the Codex P1 recommendation to remove/retimestamp the already-applied `20260910213556` migration was **not** accepted literally: doing so would create remote/local migration-history drift. The branch retains that applied migration identity. A temporary duplicate retimestamp created during investigation was removed after runtime reconciliation.

The remaining P2 findings were corrected with smallest-safe UI/read-contract changes. A forward literal-search migration was added rather than weakening deployment with `--include-all` or changing rank/security semantics.

## Current implementation evidence

Pilot corrective commits in this pass include:

- `564083b2cfb9e1b70b1c8420a6794c557bbb2ee2` — profile identity, panel error states, independent panel loading, post-run panel refresh.
- `c2a263d4aa1b2f08fa7f90a156c2c4b4f8905483` — forward literal scheduler-search migration.
- `deb60babfa42ca1998f4fb4eae60833d094bb1a6` / `3c49b3915c2a91efc56c327760b7bf33049db1ac` — reconcile branch migration identity to deployed Pilot truth and remove the temporary duplicate.

Current corrective head at the time of this record: `3c49b3915c2a91efc56c327760b7bf33049db1ac`.

## Acceptance sequence

Required before merge/deploy:

1. Pilot Frontend Build PASS.
2. Release History Contract PASS.
3. Focused CF-093 scheduler/search regression proof, including literal `%`/`_` search and profile/source combined-target presentation.
4. Pilot runtime migration-history reconciliation with no remote-only/local-only blocker introduced.
5. Apply only the forward runtime correction required for the current head.
6. Targeted deployed browser acceptance of Scheduled Tasks search, edit, run-on-demand, immediate queue refresh and supporting-panel failure semantics.
7. Security Advisor check with no new warning/error regression attributable to CF-093.
8. Fresh Codex re-review of the accepted corrective head.
9. Merge only after all required checks are green; then verify post-merge deployed currentness/acceptance.

## Rollback

- UI changes can be reverted independently to the previous PR head without altering accepted CF-092 runtime semantics.
- Do not delete or rewrite migration-history entries already applied to Pilot.
- Forward function corrections must be reverted through a new forward migration if required.

## Remaining gate

Do not merge while any required workflow, fresh Codex review, runtime migration reconciliation, targeted deployed acceptance or security gate is pending/red.
