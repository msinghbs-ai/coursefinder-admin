# M2.4.5 NEXT CHAT

## Current pickup — 13 September 2026

- Milestone: **M2.4.5 ACTIVE / PRE-PRODUCTION HARDENING — CF-093 EXACT-HEAD CODEX RECOVERY**.
- M2.5 remains PAUSED at P0; no Production Supabase exists.
- Accepted Pilot main: `63c7107cfce2d8f607fc378af4881d0ba28ca879`.
- Visible accepted release: v2.15.78.
- Pilot Supabase: `fxcwkweaxjtknorudmwp`.
- Active change: `CF-CHG-20260910-093`.
- PR #72: OPEN / DRAFT / mergeable but governance-blocked, exact head `1a2caf375b394e7723543642996e4dadfa52e3fe`.
- CF-093 Targeted Recovery `34693956788`: PASS.
- Pilot Frontend Build `34693956789`: PASS.
- CF-093 Fresh Reconstruction `34693956761`: PASS only for the limited UQ bootstrap fixture; it does not replay the complete CF-093 migration chain.
- Cloudflare exact-head preview: PASS/deployed at `1a2caf37`.
- Fresh exact-head Codex review returned multiple unresolved P1/P2 findings. Do not merge.

## Runtime migration history

Pilot runtime history now records `20260912005000`, `20260912005948`, `20260912100539` and `20260912101339`. The earlier missing-bootstrap tracking state is no longer present. Do not infer how that tracking row was created solely from the database; direct ad-hoc mutation of `supabase_migrations.schema_migrations` remains prohibited.

## Current exact-head defects to fix

1. Accepted selected/terminal discovery outcomes must be bound to the exact `scheduler_preview_token` through provider attempt/job provenance.
2. Revalidate bound identity immediately after network acquisition and before first Evidence/candidate write, or make the write path atomically token-aware.
3. If a Preview token is supplied and the exact binding is absent/cancelled, bound handoff must fail closed and must not fall through to unbound dispatch.
4. Completion dedupe must not suppress a `discovery_started` profile that never produced a reusable handoff batch.
5. Terminal-only completion and mixed-profile terminal/actionable scope accounting need explicit successful no-op/closure semantics.
6. Persist actual qualified zero-result/result-page basis and align `current_page_not_found` freshness checks with the deployed worker metadata/version contract.
7. Preserve exact canonical-title matching against both original and prefix-stripped titles.
8. Do not overwrite a retained `discovery_zero_results` provider attempt as generic success.
9. Acceptance workflow must assert `dispatch.result.status`, prove the served Cloudflare commit equals `GITHUB_SHA`, and trigger on all relevant implementation exact heads.
10. Fresh Reconstruction must replay the complete ordered CF-093 chain, not only bootstrap + immutable UQ `005948`.
11. Idempotent cancellation replay must preserve the first cancellation timestamp/reason.

## Discovery acceptance

Historical outcomes remain evidence only:

- UQ batch `5b2bac73-0cd4-4a7f-9487-2baf3ab1443f`: 248 resolved + 3 `layer3_required`.
- RMIT batch `c8a33237-d2b5-47c3-a02b-2676cb6b820f`: 213 resolved + 50 `layer3_required`.

Previous hardened snapshots showed UQ 54 and RMIT 27 requiring corrective rediscovery. Do not run them yet. Current exact-head provenance/write-time-binding/terminal-accounting defects mean a new run would not be acceptable evidence.

## Layer 3

Qualified JWT-protected Layer 3 remains separately governed but paused behind CF-093. Generic scheduler Layer 3 remains prohibited. Historical `layer3_required` counts do not authorise Layer 3 execution.

## Exact next actions

1. Implement the unresolved Codex P1/P2 findings as the smallest safe forward-only corrections; never rewrite/retimestamp applied migrations.
2. Extend reconstruction to the complete CF-093 migration chain on an appropriate reconstructed baseline.
3. Correct authenticated acceptance workflow evidence and trigger coverage.
4. Apply/deploy only required forward changes; run exact-head targeted CI, full-chain reconstruction, frontend build and fresh Codex review.
5. Only after those pass, obtain new authenticated UQ/RMIT Previews and run the currently actionable corrective discovery scopes.
6. Reconcile only newly selected/changed deterministic Layer 2 work and prove zero generic Layer3/Layer4/Search/Publication side effects.
7. Recalculate Layer 3 eligibility after Layer 2 acceptance closes.
8. Merge/release remains prohibited until all exact-head gates are clean.

## Pickup text

> Continue CF M2.4.5 / CF-CHG-20260910-093 from repository/runtime truth. Accepted Pilot main is `63c7107cfce2d8f607fc378af4881d0ba28ca879`, release v2.15.78. PR #72 remains draft/open at exact head `1a2caf375b394e7723543642996e4dadfa52e3fe`. Exact-head CF-093 Targeted Recovery `34693956788`, Pilot Frontend Build `34693956789` and Cloudflare preview PASS. Fresh Reconstruction `34693956761` passes only the limited UQ bootstrap fixture and is not a complete CF-093 chain replay. Pilot migration history now records `20260912005000`, `005948`, `100539`, `101339`. Fresh exact-head Codex review returned unresolved P1/P2 defects in Preview-token provenance, post-fetch identity revalidation, bound-handoff fail-closed handling, async completion dedupe, terminal-only/mixed-scope accounting, terminal-basis metadata, title matching, zero-result telemetry, acceptance workflow evidence/triggering, full-chain reconstruction and cancellation audit replay. Do not run corrective UQ/RMIT discovery or Layer 3 yet. Fix forward-only, re-run exact-head gates, obtain clean Codex review, then resume bounded corrective acceptance.