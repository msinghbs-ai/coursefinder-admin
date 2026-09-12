# M2.4.5 CURRENT STATE

**Status:** ACTIVE / PRE-PRODUCTION HARDENING — CF-093 CODEX RECOVERY / ACCEPTANCE BLOCKED  
**Reconciled:** 2026-09-13 AEST  
**Accepted Pilot main:** `63c7107cfce2d8f607fc378af4881d0ba28ca879`  
**Visible accepted release:** v2.15.78  
**Pilot Supabase:** `fxcwkweaxjtknorudmwp`  
**Production:** not provisioned; M2.5 remains PAUSED at P0

## Active candidate

- PR #72 / branch `m245/cf093-async-discovery-20260912`.
- Exact head `1a2caf375b394e7723543642996e4dadfa52e3fe`.
- PR OPEN / DRAFT / mergeable but governance-blocked.
- Exact-head CF-093 Targeted Recovery `34693956788`: PASS.
- Exact-head Pilot Frontend Build `34693956789`: PASS.
- Exact-head CF-093 Fresh Reconstruction `34693956761`: PASS for the limited UQ bootstrap fixture only; it does **not** replay the complete CF-093 migration chain.
- Cloudflare exact-head preview: PASS/deployed at `1a2caf37`.
- Exact-head Codex review returned further actionable P1/P2 findings; merge remains prohibited.

## Runtime migration-history state

Pilot migration tracking now contains:

- `20260912005000_cf_093_uq_discovery_strategy_reconstruction_bootstrap`;
- `20260912005948_cf_093_uq_native_program_discovery_profile`;
- `20260912100539_cf_093_codex_async_token_identity_dedupe_hardening`;
- `20260912101339_cf_093_terminal_negative_basis_hardening`.

This closes the earlier observed runtime-history absence of `20260912005000`. The exact mechanism used to repair tracking is not inferred from the database row alone. Direct ad-hoc history mutation remains prohibited.

## Current Codex blockers

Exact-head review on `1a2caf...` identified additional unresolved defects. The important classes are:

- Preview-bound discovery outcomes are not yet proven to be correlated to the exact `scheduler_preview_token` through provider-attempt/job provenance.
- Binding identity is checked before network acquisition, but not yet atomically/reliably revalidated immediately before Evidence/candidate writes.
- Bound handoff can fall through to an unbound path when the exact binding is absent/cancelled.
- Completion dedupe can still suppress recovery when an async profile never produced a reusable handoff batch.
- Terminal-only completion/mixed-profile accounting still has fail-closed gaps.
- Qualified `current_page_not_found` terminal basis is not aligned with the worker metadata/version contract.
- Exact canonical-title matching must retain both original and prefix-stripped titles.
- Qualified zero-result provider-attempt telemetry can be overwritten by a later generic success finish.
- Acceptance workflow still has exact-head evidence defects: response status path, exact Cloudflare SHA proof and trigger coverage.
- Fresh reconstruction workflow currently proves only the UQ bootstrap + immutable `005948`, not the complete ordered CF-093 chain.
- Operator-cancel replay can overwrite the first cancellation audit.

No workaround may weaken identity, authority, Evidence, migration immutability or fail-closed behaviour.

## Discovery acceptance

Earlier UQ/RMIT deterministic outcomes remain historical evidence only while CF-093 is reopened:

- UQ `5b2bac73-0cd4-4a7f-9487-2baf3ab1443f`: 248 `resolved_l2` + 3 `layer3_required`.
- RMIT `c8a33237-d2b5-47c3-a02b-2676cb6b820f`: 213 `resolved_l2` + 50 `layer3_required`.

Previous hardened snapshots recorded UQ 54 and RMIT 27 as needing corrective rediscovery. Do **not** dispatch corrective rediscovery until the current exact-head P1/P2 authority/correlation defects are forward-fixed and revalidated, because a new run would not constitute governed acceptance evidence.

## Layer 3

Qualified JWT-protected Layer 3 remains separately governed. Live Layer 3 acceptance is paused behind CF-093. Generic scheduler Layer 3 remains prohibited and historical `layer3_required` counts do not authorise execution.

## Exact next gate

1. Implement the current unresolved Codex findings using smallest safe forward-only changes; do not rewrite or retimestamp applied migrations.
2. Extend fresh reconstruction to replay the complete ordered CF-093 migration chain against an appropriate reconstructed baseline.
3. Fix authenticated acceptance evidence so it proves exact workflow response shape, exact Cloudflare commit SHA and relevant exact-head triggering.
4. Deploy/apply only required forward changes, then obtain exact-head targeted CI, full-chain reconstruction, frontend build and fresh Codex review PASS.
5. Only then re-Preview and run bounded UQ/RMIT corrective discovery through the normal authenticated scheduler and prove exact-token/fingerprint/dedupe/side-effect boundaries.
6. Recalculate any eligible Layer 3 cohort only after deterministic Layer 2 acceptance closes.
7. Merge/release remains prohibited until every P1/P2 and runtime/governance gate is clean.

M2.4.4 remains CLOSED/PASS/FROZEN and M2.5 remains paused.