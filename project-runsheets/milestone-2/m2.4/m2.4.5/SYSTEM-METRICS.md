# M2.4.5 SYSTEM METRICS

**Status:** ACTIVE METRICS LEDGER  
**Established:** 2026-09-12 AEST  
**Milestone:** M2.4.5 / CF-CHG-20260910-093  
**Pilot Supabase:** `fxcwkweaxjtknorudmwp`

## Recording rule

Record observed values only for consequential ingestion, discovery, enrichment, scheduler, UAT and recovery work. Preserve repository/runtime identity, scope, request/batch identifiers, elapsed time, dispositions, tooling/provider usage, CI/UAT evidence, Evidence counts and safety side effects. Metrics are evidence, not acceptance thresholds unless a Change Control explicitly promotes them.

## Current repository / CI / runtime snapshot — 12 Sep 2026

- Accepted Pilot main: `63c7107cfce2d8f607fc378af4881d0ba28ca879`.
- Visible accepted release: v2.15.78.
- PR #72 branch: `m245/cf093-async-discovery-20260912`.
- Corrective exact head: `c5226c2bcadd7ee7102935088130262ca2a3a2a2`.
- Exact-head Pilot Frontend Build `34687938846`: **PASS**.
- Exact-head Cloudflare preview: **PASS/deployed**.
- Pilot worker `layer2-scope-discover-scheduled`: Edge v27 / `layer2-scope-discover-scheduled-v1.3.9` / SHA `15c958609f6f6787a4de2e449d15e3e3e9718480da4c8599743c0da92a3d4ef2`.
- Forward migration `20260912100539_cf_093_codex_async_token_identity_dedupe_hardening`: applied + checked in.
- Forward migration `20260912101339_cf_093_terminal_negative_basis_hardening`: applied + checked in.
- Codex predecessor-head review: nine actionable findings. Eight corrected threads resolved; one P1 repository-reconstruction thread remains open.
- PR remains draft/unmerged. Accepted main/release unchanged.

## Codex recovery metrics / safety changes

### Exact Preview-token / identity correction

Observed prior defect: Preview-bound worker payload carried `scheduler_preview_token`, but v1.3.8 used tokenless discovery context, continuation dispatch and final handoff. A late continuation could attach to a newer active binding for the same actor/profile/scope. The context also did not compare the bound identity fingerprint before new Evidence writes.

Current v1.3.9 / migration `20260912100539`:

- exact `preview_token + actor + profile` binding required;
- bound status must be active and execution lease unexpired;
- requested discovery IDs must be a subset of bound discovery IDs;
- profile version, identity fingerprint, queueable fingerprint, all-ID validity and discovery-subset validity are recomputed before discovery Evidence processing;
- continuation and final deterministic handoff receive the exact Preview token through transaction-local governed context;
- async handoff batch IDs are recorded in Preview job result;
- dedupe reuse requires every referenced batch to exist and be `completed`/`partial` with completion timestamp;
- cancelled/missing/non-terminal sibling batch causes dedupe to fail closed;
- cancellation is set-based across all bindings for the Preview/actor;
- Preview with zero actionable queueable+discovery work is non-executable.

No browser/public privilege was broadened. Existing worker custom authentication remains one-time nonce + service RPC; `verify_jwt=false` is unchanged from the accepted worker boundary.

### Terminal-negative authority correction

Codex identified that v1.3.8 could convert any first-party HTTP 200 page with no required-prefix links into a terminal `current_page_not_found`, including challenge/consent/changed-markup pages.

Current v1.3.9 behavior:

- HTTP 200/no required-prefix link is transient unless profile `discovery_strategy.zero_result_markers` exists and the first-party page explicitly contains a qualified marker;
- UQ/RMIT currently have **0 configured zero-result markers**; none was invented;
- course-code anchor matching uses escaped `String.raw` word boundaries.

Migration `20260912101339` removes legacy/current v1.3.9 `current_page_not_found` rows from freshness suppression. `ambiguous` and `identity_mismatch` remain accepted freshness-eligible terminal evidence. Future `current_page_not_found` freshness is intentionally reserved for a future explicit terminal-basis worker contract; current v1.3.9 does not grant it.

## Reopened scope snapshot after hardening

| Cohort | Scoped | Queueable | Reopened discovery | Retained terminal negatives | Current fingerprint |
|---|---:|---:|---:|---:|---|
| UQ | 382 | 251 | **54** | 77 | `2661fefb086294a948862eac08f0c297` |
| RMIT | 500 | 263 | **27** | 210 | `cd360b3d2b6ba4ba8c2a5a9442cc761a` |
| **Total** | **882** | **514** | **81** | **287** | — |

No corrective UQ/RMIT dispatch was issued during this hardening step.

## Historical UQ execution metrics — retained evidence, discovery acceptance superseded

Worker during earlier consequential run: Edge v26 / v1.3.8. UQ profile version `3d70516d-95d5-49e6-b33e-e61bacfec275`.

Earlier discovery evidence recorded 245 CRICOS-verified selected current URLs + 131 then-classified terminal negatives. After current terminal-basis hardening, only 77 negatives remain freshness-authoritative and 54 Courses reopen for rediscovery.

Historical deterministic rerun:

- Preview token `feddbf8a-482b-4826-889a-fcfb315ec861`.
- Historical fingerprint `66c66f1d04bbc289e3cec1f7cd7faf3d`.
- Batch `5b2bac73-0cd4-4a7f-9487-2baf3ab1443f`.
- Dispatch `5882`.
- Target 251.
- Elapsed ~14m13.5s.
- Terminal: 248 `resolved_l2` + 3 `layer3_required`.
- Vendor units 251; recorded vendor cost USD 0.
- Evidence records observed 502.
- Resolved mean response ~675.2ms; mean extraction ~1503.7ms.
- L3-required mean response ~242.3ms; mean extraction ~1449.7ms.
- Same-token replay historically PASS; completion-anchored fresh Preview dedupe historically PASS after one governed-cancelled duplicate with 0 processed items.
- No generic Layer 3/Search/Publication side effects observed.

These deterministic results remain historical execution evidence. They do not close the currently reopened 54-course discovery gate.

## Historical RMIT execution metrics — retained evidence, discovery acceptance superseded

Profile `726918ee-10e9-41e3-9a2a-5dace20af754`; version `409b0f7c-4e04-4a33-8f4d-e173fc3f9c40`.

Earlier Preview `c3e73796-d2d3-486e-b3a4-83afc54b806d`: 500 scoped / 261 queueable / 239 discovery. Earlier discovery recorded 2 selected + 237 then-classified terminal negatives. After current terminal-basis hardening, 210 remain freshness-authoritative and 27 Courses reopen.

Historical discovery timing:

- binding activated `2026-09-12 03:56:02.406678Z`;
- handoff after ~6895s / 1h54m55s;
- observed throughput ~2.08 Courses/minute;
- existing policy `max_concurrency=1` was not changed.

Historical deterministic batch `c8a33237-d2b5-47c3-a02b-2676cb6b820f`:

- handoff request `5967`;
- target 263;
- created `2026-09-12 05:50:57.510697Z`;
- completed `2026-09-12 06:11:31.218367Z`;
- elapsed ~1234s / 20m34s;
- throughput ~12.79 items/minute;
- 213 `resolved_l2` + 50 `layer3_required`;
- vendor units 263; recorded cost USD 0;
- response mean 1647.0ms / p50 1621ms / p95 1884.2ms;
- extraction mean 1730.6ms / p50 1672ms / p95 2114.6ms;
- 263 succeeded `layer2_acquisition_v2` jobs;
- zero Search refresh signals;
- no generic Layer 3 jobs;
- canonical mutation and Search/Publication authority false.

These deterministic results remain historical execution evidence. They do not close the currently reopened 27-course discovery gate.

## Open P1 — repository reconstruction evidence

Repository foundation migration `20260823102443_m2_1_layer2_platform_foundation.sql` seeds UQ configuration without `discovery_strategy`. Applied migration `20260912005948_cf_093_uq_native_program_discovery_profile.sql` uses nested `jsonb_set` directly on `{discovery_strategy,...}` paths. PostgreSQL does not create a missing intermediate object, leaving the seed configuration unchanged. Runtime schema confirms `pipeline.layer2_source_profile_versions` has `UNIQUE (profile_id, configuration_hash)`, so a fresh repository replay attempts to insert the unchanged hash and aborts.

This is a repository-reconstruction P1, not a current Pilot runtime outage. `20260912005948` is already applied and must not be edited/retimestamped. No ad-hoc migration-history mutation is authorised. Metric/state: **1 unresolved P1**, merge blocked.

## Layer 3 readiness — PAUSED

Previously inspected runtime contract remains:

- profile `openrouter-free-router-v1`, id `0b02920e-a021-48f5-ba47-75082fdcce13`;
- OpenRouter pinned `nvidia/nemotron-3-nano-omni-30b-a3b-reasoning:free`;
- enabled/unpaused, Pilot `pilot_qualified`;
- benchmark `a8e4b6c8-8a7b-45b4-a8df-c5a3bb4e8407`: 5/5 provider semantic + 13/13 controls, 5 calls, 315 input / 462 output tokens, USD 0 observed cost, max latency 2811ms;
- 20 RPM / 50 day / retry 1 / timeout 30s / USD0 ceiling;
- `layer3-interpret` v9 ACTIVE, `verify_jwt=true`, validates `auth.getUser()`;
- historical UQ/RMIT cohort at inspection: 53 `layer3_required` items with 53 retained `text/html` Evidence and 0 interpretations.

Layer 3 live acceptance is paused behind CF-093 reconstruction and reopened discovery. No live-provider metrics were manufactured.

## Next metrics capture

1. Reconstruction/baseline remedy identity and proof without editing applied migration history.
2. Fresh exact-head Codex outcome.
3. Corrective authenticated rediscovery: UQ 54 + RMIT 27 only — attempted, selected, terminal/transient, requests, latency/tooling and exact Preview token/fingerprint evidence.
4. Deterministic L2 only for newly selected/changed actionable work.
5. Explicit zero generic Layer 3/Layer 4 auto-approval/Search/Publication side effects.
6. Only after CF-093 recovery: bounded authenticated Layer 3 calls/tokens/cost/latency/validator/Evidence lineage.
