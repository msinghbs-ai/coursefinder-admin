# CF-CHG-20260910-093 — Scheduled Workflow Orchestrator

**Status:** ACTIVE — EXACT-HEAD CODEX RECOVERY / DISCOVERY ACCEPTANCE BLOCKED  
**Initiated:** 2026-09-10 AEST  
**Reconciled:** 2026-09-13 AEST  
**Category:** 30-admin-pim-ux  
**Parent:** CF-CHG-20260910-092  
**Accepted Pilot main:** `63c7107cfce2d8f607fc378af4881d0ba28ca879`  
**Active Pilot PR:** #72 (`m245/cf093-async-discovery-20260912`)  
**Candidate head:** `1a2caf375b394e7723543642996e4dadfa52e3fe`  
**Visible accepted release:** v2.15.78

## Objective

Complete the bounded Scheduled Tasks run-on-demand contract for large AU Course Facts scopes without weakening Layer 1 authority, deterministic Layer 2 Evidence truth, Layer 3 Evidence/profile/model/revalidation governance, Layer 4 human resolution, Search/Publication separation or rank/ACL boundaries.

## Current decision

PR #72 remains OPEN / DRAFT / mergeable but governance-blocked. Earlier UQ/RMIT deterministic Layer 2 outcomes remain retained historical evidence only. Corrective discovery and Layer 3 remain paused because fresh exact-head Codex review identified unresolved authority/correlation and acceptance-proof defects. No visible release may advance until all exact-head P1/P2, reconstruction, runtime and governance gates close.

## Current exact-head evidence

- Candidate head `1a2caf375b394e7723543642996e4dadfa52e3fe`.
- CF-093 Targeted Recovery `34693956788`: PASS.
- Pilot Frontend Build `34693956789`: PASS.
- CF-093 Fresh Reconstruction `34693956761`: PASS only for the limited UQ bootstrap fixture; not a complete CF-093 migration-chain replay.
- Cloudflare preview: PASS/deployed at `1a2caf37`.
- Pilot migration history records `20260912005000`, `20260912005948`, `20260912100539`, `20260912101339`.
- Fresh exact-head Codex review returned additional actionable P1/P2 findings; no merge approval exists.

## Authority boundaries retained

- Layer 1 identity/source authority remains unchanged.
- Layer 2 remains deterministic, Evidence-preserving and fail-closed.
- `layer3_required` remains an L2 disposition only; generic scheduler Layer 3 is prohibited.
- Layer 4 human resolution remains separate.
- Search/Publication remains separately governed.
- No URL/profile/route/zero-result marker may be manufactured for acceptance.
- Applied migrations remain immutable; semantic corrections to applied functions require new forward migrations.
- Direct ad-hoc mutation of `supabase_migrations.schema_migrations` remains prohibited.

## Exact-head Codex recovery requirements

The current head still requires forward correction for these material findings:

1. **Preview-token provenance P1** — accepted selected/terminal discovery outcomes must prove they belong to the exact bound `scheduler_preview_token` through provider attempt/job provenance. Course/profile/time alone is insufficient.
2. **Post-fetch identity P1** — identity must be revalidated after network acquisition and before the first committed Evidence/candidate write, or writes must be atomically token-aware.
3. **Bound-handoff fail-closed P1** — when a Preview token is supplied but the exact binding is absent/cancelled, handoff must raise/fail closed and may not fall through to unbound batch dispatch.
4. **Async completion dedupe P2** — a completed direct sibling must not dedupe a `discovery_started` profile that never produced a reusable handoff batch.
5. **Terminal-only/mixed-scope accounting P2** — terminal-only discovery completion must close its binding successfully without creating an empty batch, and mixed scopes must not roll back actionable siblings.
6. **Terminal-basis contract P2** — `current_page_not_found` freshness qualification must match the actual deployed worker metadata/version and persist the qualified result-page/zero-result basis.
7. **Title identity P1** — exact matches must be evaluated against both original and prefix-stripped canonical titles.
8. **Provider-attempt telemetry P2** — a retained qualified `discovery_zero_results` attempt must not later be overwritten as generic success.
9. **Acceptance workflow P1** — assert the nested `dispatch.result.status`, prove the served Cloudflare deployment matches `GITHUB_SHA`, and trigger the acceptance workflow for every relevant implementation exact head.
10. **Fresh reconstruction P1** — the reconstruction gate must replay the complete ordered CF-093 chain against an appropriate reconstructed baseline, not only bootstrap + immutable UQ `005948`.
11. **Cancellation audit P2** — idempotent cancellation replay must preserve the original cancellation time/reason when no binding changed.

## Reconstruction / migration currentness

The earlier runtime-history absence of `20260912005000_cf_093_uq_discovery_strategy_reconstruction_bootstrap` is no longer present: Pilot migration tracking now contains `005000` before immutable `005948`, plus `100539` and `101339`.

The current reconstruction workflow nevertheless remains insufficient for final acceptance because it hand-builds a minimal UQ fixture and applies only `005000` and `005948`. Fresh exact-head Codex correctly requires a complete ordered CF-093 chain replay so syntax, dependency and function-replacement failures in later migrations cannot be hidden by a green partial fixture.

## Historical large-university evidence

Retain for evidence only:

- UQ batch `5b2bac73-0cd4-4a7f-9487-2baf3ab1443f`: 248 `resolved_l2` + 3 `layer3_required`.
- RMIT batch `c8a33237-d2b5-47c3-a02b-2676cb6b820f`: 213 `resolved_l2` + 50 `layer3_required`.

Previous hardened snapshots recorded:

| Cohort | Scoped | Queueable | Reopened discovery | Retained terminal negatives |
|---|---:|---:|---:|---:|
| UQ | 382 | 251 | 54 | 77 |
| RMIT | 500 | 263 | 27 | 210 |

Do not dispatch these corrective scopes while the current exact-head provenance/write-time identity/terminal-accounting defects remain open. The next accepted counts must come from new Previews after the forward fixes land.

## Exact next gates

1. Implement the unresolved exact-head Codex findings with the smallest safe forward-only changes.
2. Extend reconstruction to the complete ordered CF-093 migration chain and prove clean replay.
3. Correct authenticated acceptance evidence for nested response shape, exact Cloudflare SHA and relevant exact-head trigger coverage.
4. Apply/deploy only required forward runtime changes, then obtain exact-head Targeted Recovery, full-chain reconstruction, Frontend Build and fresh Codex review PASS.
5. Only after those gates close, run new authenticated UQ/RMIT Previews and bounded corrective discovery through the normal scheduler contract.
6. Reconcile only newly selected/changed deterministic Layer 2 work and prove exact-token/fingerprint/dedupe/cancel behaviour plus zero generic Layer 3/Layer 4 auto-approval/Search/Publication side effects.
7. Recalculate Layer 3 eligibility only after CF-093 deterministic Layer 2 acceptance closes.
8. Merge/release remains prohibited until every P1/P2, runtime, UAT, security/authority and governance gate is clean.

## Next AU qualification wave

Monash → Melbourne → ANU → UTS → UWA → Sydney → UNSW remains deferred until CF-093 closes. Cohort membership is not authority to manufacture configuration.