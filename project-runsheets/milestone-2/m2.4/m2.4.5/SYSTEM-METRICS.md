# M2.4.5 SYSTEM METRICS

**Status:** ACTIVE METRICS LEDGER  
**Established:** 2026-09-12 AEST  
**Reconciled:** 2026-09-13 AEST  
**Milestone:** M2.4.5 / CF-CHG-20260910-093  
**Pilot Supabase:** `fxcwkweaxjtknorudmwp`

## Recording rule

Record observed values only for consequential ingestion, discovery, enrichment, scheduler, UAT and recovery work. Metrics are evidence, not acceptance thresholds unless a Change Control explicitly promotes them.

## Current repository / runtime snapshot

- Accepted Pilot main: `63c7107cfce2d8f607fc378af4881d0ba28ca879`.
- Visible accepted release: v2.15.78.
- PR #72 branch: `m245/cf093-async-discovery-20260912`.
- Current candidate head: `a035714aa5bd9b4d88ae47a59c877b3514a1f287`.
- Exact-head CF-093 Targeted Recovery `34726688848`: **PASS**.
- Exact-head CF-093 Fresh Reconstruction `34726688865`: **PASS** — all PR-added CF-093 migrations replayed in order on fresh reconstructed dependency baseline.
- Exact-head Pilot Frontend Build `34726688863`: **PASS**.
- Exact-head Cloudflare preview: **PASS/deployed at `a035714a`**.
- Fresh exact-head Codex request: comment `5649524865`; technical review still pending at reconciliation.
- Worker: Edge v29 / `layer2-scope-discover-scheduled-v1.3.10` / SHA `665c56ade30fa89b517255bb023c8ce1a15f88df3935845baeeba17cca21c051`.
- Forward migration `20260912232827_cf_093_preview_provenance_terminal_dedupe_hardening`: applied + checked in.
- Temporary one-shot migration/deployment/source-alignment workflows removed after use.
- PR remains draft/unmerged; accepted main/release unchanged.

## Exact-head hardening evidence

Current source/runtime implements:

- exact `scheduler_preview_token` correlation through provider attempt/job provenance;
- post-network/pre-Evidence bound identity revalidation;
- fail-closed bound handoff when exact binding is missing/cancelled/expired/mismatched;
- completion-aware async dedupe requiring reusable completion for every `discovery_started` profile;
- explicit terminal-only and mixed actionable/terminal accounting;
- original + prefix-stripped exact title matching;
- qualified zero-result/terminal basis preservation;
- no second generic-success finalisation of a retained qualified zero-result attempt;
- preservation of the original cancellation timestamp/reason on idempotent replay.

No browser/public privilege was broadened. Worker custom authentication remains the existing one-time nonce/service-RPC model. Security Advisor after the forward changes reported no new critical CF-093 regression; existing informational RLS-with-no-policy inventory remains separately governed.

## Reconstruction evidence

Exact-head Fresh Reconstruction `34726688865` creates a fresh Postgres dependency baseline representing the accepted-main contracts needed by CF-093 and replays, in order, every PR-added migration from:

- `20260911231544_cf_093_scheduler_preview_bound_async_discovery`
through
- `20260912232827_cf_093_preview_provenance_terminal_dedupe_hardening`.

The replay verifies the historical UQ v1 hash `77dda7fa33501c67a046dff1e5385554a419853c64f12f5b56e1c23a63da0d72`, distinct governed profile versions, final first-party search configuration, async binding table creation, fail-closed exact handoff, and completion-aware dedupe function. This is complete CF-093 PR-chain reconstruction evidence, not a claim that unrelated historical operational-data migrations are independently reconstructable.

## Reopened scope snapshot — retained until fresh Preview

| Cohort | Scoped | Queueable | Reopened discovery | Retained terminal negatives | Fingerprint |
|---|---:|---:|---:|---:|---|
| UQ | 382 | 251 | **54** | 77 | `2661fefb086294a948862eac08f0c297` |
| RMIT | 500 | 263 | **27** | 210 | `cd360b3d2b6ba4ba8c2a5a9442cc761a` |
| **Total** | **882** | **514** | **81** | **287** | — |

No corrective UQ/RMIT dispatch has been issued after the current hardening. Fresh authenticated Previews must establish the next accepted counts.

## Historical UQ deterministic metrics — retained evidence

- Preview `feddbf8a-482b-4826-889a-fcfb315ec861`.
- Batch `5b2bac73-0cd4-4a7f-9487-2baf3ab1443f`; target 251.
- Elapsed ~14m13.5s.
- 248 `resolved_l2` + 3 `layer3_required`.
- Vendor units 251; recorded cost USD 0; Evidence records observed 502.
- Historical same-token replay/dedupe passed, but acceptance was reopened by later hardening.

## Historical RMIT deterministic metrics — retained evidence

- Preview `c3e73796-d2d3-486e-b3a4-83afc54b806d`.
- Batch `c8a33237-d2b5-47c3-a02b-2676cb6b820f`; target 263.
- Deterministic elapsed ~1234s / 20m34s; ~12.79 items/min.
- 213 `resolved_l2` + 50 `layer3_required`.
- Vendor units 263; recorded cost USD 0.
- Response mean 1647ms / p50 1621 / p95 1884.2.
- Extraction mean 1730.6ms / p50 1672 / p95 2114.6.
- Zero Search refresh signals and no generic Layer 3 jobs observed in that historical batch.

## Layer 3 readiness — PAUSED

Layer 3 remains separately governed/JWT-protected. Historical `layer3_required` counts predate the current corrective acceptance and do not authorise execution. Recalculate after CF-093 deterministic Layer 2 acceptance closes.

## Next metrics capture

1. Fresh exact-head Codex result for `a035714...`.
2. If code changes, replacement exact-head Targeted Recovery / Reconstruction / Frontend / Cloudflare evidence.
3. Fresh authenticated UQ and RMIT Preview counts.
4. Corrective rediscovery metrics for currently actionable scope only.
5. Deterministic L2 reconciliation for newly selected/changed work only.
6. Explicit zero unauthorised Layer3/Layer4/Search/Publication side effects.
7. Only after CF-093 closes: recalculated bounded Layer3 calls/tokens/cost/latency/validator/Evidence lineage.