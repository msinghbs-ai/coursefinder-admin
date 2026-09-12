# M2.4.5 SYSTEM METRICS

**Status:** ACTIVE METRICS LEDGER  
**Established:** 2026-09-12 AEST  
**Milestone:** M2.4.5 / CF-CHG-20260910-093  
**Pilot Supabase:** `fxcwkweaxjtknorudmwp`

## Recording rule

Record observed values only for consequential ingestion, discovery, enrichment, scheduler, UAT and recovery work. Preserve repository/runtime identity, scope, request/batch identifiers, elapsed time, dispositions, tooling/provider usage, CI/UAT evidence, Evidence counts and safety side effects. Metrics are evidence, not acceptance thresholds unless a Change Control explicitly promotes them.

## Current repository / runtime snapshot — 12 Sep 2026

- Accepted Pilot main: `63c7107cfce2d8f607fc378af4881d0ba28ca879`.
- Visible accepted release: v2.15.78.
- PR #72 branch: `m245/cf093-async-discovery-20260912`.
- Current candidate head: `edb115cca6f6a94957ff6a99aac12a6b235713aa`.
- Exact-head CF-093 Targeted Recovery `34690128803`: PASS.
- Exact-head Pilot Frontend Build `34690128811`: PASS.
- Exact-head Cloudflare commit/branch preview: PASS/deployed.
- Fresh exact-head Codex request comment: `5645499063`; no new technical review submission observed at reconciliation.
- Pilot worker: Edge v27 / `layer2-scope-discover-scheduled-v1.3.9` / SHA `15c958609f6f6787a4de2e449d15e3e3e9718480da4c8599743c0da92a3d4ef2`.
- Forward Pilot migration `20260912100539_cf_093_codex_async_token_identity_dedupe_hardening`: applied + checked in.
- Forward Pilot migration `20260912101339_cf_093_terminal_negative_basis_hardening`: applied + checked in.
- Retroactive source-only reconstruction bootstrap `20260912005000_cf_093_uq_discovery_strategy_reconstruction_bootstrap.sql`: checked in; Pilot history repair still pending.
- Runtime history observed: `20260912005948`, `20260912100539`, `20260912101339` present; `20260912005000` absent.
- PR remains draft/unmerged. Accepted main/release unchanged.

## CF-093 targeted recovery CI

Dedicated PR workflow `CF-093 Targeted Recovery` executes the seven current CF-093 contract files.

| Run | Candidate | Result | Observed detail |
|---|---|---|---|
| `34689908598` | earlier recovery head | FAIL | 13 pass / 4 fail — stale v1.3.8/pre-hardening assertions |
| `34690059287` | `121bbd28...` | FAIL | 16 pass / 1 fail — obsolete cancellation reason key assertion |
| `34690128803` | `edb115cc...` | **PASS** | full targeted recovery set clean |

The test-alignment commits changed assertions only; they did not modify deployed worker logic or applied migration SQL.

## Codex recovery safety evidence

### Exact Preview-token / identity

Current v1.3.9 + `20260912100539` requires exact `preview_token + actor + profile`, an active/unexpired binding, requested discovery IDs inside the bound set, and revalidation of profile version, identity fingerprint, queueable fingerprint and bound ID validity before discovery Evidence processing. Preview-bound continuation and handoff reuse the same exact token. Async handoff batch IDs are recorded for dedupe.

Dedupe returns a completion anchor only when every referenced direct/async batch exists and is reusable; cancelled/missing/non-terminal siblings fail closed. Multi-profile cancellation is set-based. Terminal-only Preview scopes are non-executable.

No browser/public privilege was broadened. Worker custom authentication remains the existing one-time nonce + service-RPC model.

### Terminal-negative authority

v1.3.9 no longer interprets HTTP 200/no required-prefix link as a terminal zero-result unless `discovery_strategy.zero_result_markers` is explicitly configured and matched. UQ/RMIT currently have zero such markers; none was manufactured.

`20260912101339` removes legacy/current v1.3.9 `current_page_not_found` from freshness suppression unless a later explicit qualified basis exists. `ambiguous` and `identity_mismatch` remain freshness-eligible terminal negatives.

## Reopened scope snapshot

| Cohort | Scoped | Queueable | Reopened discovery | Retained terminal negatives | Fingerprint |
|---|---:|---:|---:|---:|---|
| UQ | 382 | 251 | **54** | 77 | `2661fefb086294a948862eac08f0c297` |
| RMIT | 500 | 263 | **27** | 210 | `cd360b3d2b6ba4ba8c2a5a9442cc761a` |
| **Total** | **882** | **514** | **81** | **287** | — |

No corrective UQ/RMIT dispatch has been issued after the hardening.

## Historical UQ deterministic metrics — retained execution evidence

- Profile version `3d70516d-95d-49e6-b33e-e61bacfec275`.
- Preview `feddbf8a-482b-4826-889a-fcfb315ec861`.
- Historical fingerprint `66c66f1d04bbc289e3cec1f7cd7faf3d`.
- Batch `5b2bac73-0cd4-4a7f-9487-2baf3ab1443f`; dispatch `5882`; target 251.
- Elapsed ~14m13.5s.
- 248 `resolved_l2` + 3 `layer3_required`.
- Vendor units 251; recorded cost USD 0; Evidence records observed 502.
- Resolved mean response ~675.2ms; extraction ~1503.7ms.
- L3-required mean response ~242.3ms; extraction ~1449.7ms.
- Historical same-token replay and completion-dedupe proofs passed; one pre-correction duplicate was governed-cancelled with 0 processed items.
- No generic Layer 3/Search/Publication side effects observed.

Earlier discovery recorded 245 selected + 131 then-terminal negatives. Current hardening supersedes terminal acceptance: 54 reopen, 77 remain terminal.

## Historical RMIT deterministic metrics — retained execution evidence

- Profile `726918ee-10e9-41e3-9a2a-5dace20af754`; version `409b0f7c-4e04-4a33-8f4d-e173fc3f9c40`.
- Historical Preview `c3e73796-d2d3-486e-b3a4-83afc54b806d`.
- Earlier discovery: 2 selected + 237 then-terminal negatives; current hardening leaves 27 reopened + 210 terminal.
- Discovery elapsed ~6895s / 1h54m55s; ~2.08 Courses/min under unchanged `max_concurrency=1`.
- Batch `c8a33237-d2b5-47c3-a02b-2676cb6b820f`; handoff request `5967`; target 263.
- Created `2026-09-12 05:50:57.510697Z`; completed `2026-09-12 06:11:31.218367Z`; elapsed ~1234s / 20m34s; ~12.79 items/min.
- 213 `resolved_l2` + 50 `layer3_required`.
- Vendor units 263; recorded cost USD 0.
- Response mean 1647.0ms / p50 1621ms / p95 1884.2ms.
- Extraction mean 1730.6ms / p50 1672ms / p95 2114.6ms.
- 263 succeeded L2 jobs; zero Search refresh signals; no generic Layer 3 jobs; canonical/Search authority false.

## Repository reconstruction P1 evidence

Foundation `20260823102443_m2_1_layer2_platform_foundation.sql` seeds UQ v1 without `discovery_strategy`. Applied `20260912005948_cf_093_uq_native_program_discovery_profile.sql` uses nested `jsonb_set`; missing intermediate object means unchanged config, then duplicate configuration hash under `UNIQUE(profile_id,configuration_hash)` on fresh replay.

A read-only runtime simulation used the actual UQ v1 configuration and proposed bootstrap semantics:

- v1 config hash: `77dda7fa33501c67a046dff1e5385554a419853c64f12f5b56e1c23a63da0d72`;
- bootstrap adds only `discovery_strategy={"type":"first_party_search"}` when absent;
- immutable `005948` then adds its search URL template, `canonical_title_normalized` query field and `/study-options/programs/` prefix;
- resulting config validates **PASS** under `security.layer2_validate_profile_config`;
- resulting candidate hash: `1cb8d860cce8d907de5c326975fabfe11865861a3b5c75dee0ac4a54f91145e8`, distinct from v1.

Exact-head targeted CI includes the bootstrap ordering/regression test and passes.

Pilot already has the resulting qualified discovery strategy. Therefore the remaining remote-history operation is the official Supabase CLI tracking repair:

`supabase migration repair 20260912005000 --status applied --linked`

The connected Supabase tool does not expose migration repair. **No direct SQL INSERT/DELETE against `supabase_migrations.schema_migrations` was performed.** Exact CLI history repair + `supabase migration list` alignment + fresh reconstruction proof remain pending before this P1 can close.

## Layer 3 readiness — PAUSED

Previously inspected runtime contract remains qualified/JWT-protected. Historical cohort at inspection: 53 `layer3_required` items with 53 retained `text/html` Evidence, 0 interpretations. `layer3-interpret` v9 remains `verify_jwt=true` and caller-validated. This cohort predates reopened discovery and must be recalculated after corrective L2. Live Layer 3 acceptance is paused behind CF-093 reconstruction + reopened discovery.

## Next metrics capture

1. Official migration repair result and local/remote migration-list parity.
2. Fresh reconstruction/reset proof.
3. Fresh exact-head Codex outcome for `edb115cc...`.
4. Authenticated corrective rediscovery metrics for UQ 54 + RMIT 27 only.
5. Deterministic L2 only for newly selected/changed actionable work.
6. Explicit zero unauthorized Layer 3/Layer 4 auto-approval/Search/Publication side effects.
7. Only after CF-093 recovery: recalculated bounded authenticated Layer 3 calls/tokens/cost/latency/validator/Evidence lineage.
