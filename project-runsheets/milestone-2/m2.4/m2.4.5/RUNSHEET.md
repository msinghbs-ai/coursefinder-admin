# M2.4.5 RUNSHEET — Admin/PIM Hardening & Pre-Production Operational Readiness

**Status:** ACTIVE / PRE-PRODUCTION HARDENING — CF-093 CORRECTIVE ACCEPTANCE  
**Opened:** 2026-09-03 10:28 AEST  
**Reconciled:** 2026-09-13 AEST  
**Predecessor:** M2.4.4 CLOSED / PASS / FROZEN  
**Successor:** M2.5 Production Readiness — PAUSED AT P0

## Current baseline

- Accepted Pilot main: `63c7107cfce2d8f607fc378af4881d0ba28ca879`.
- Visible accepted release: v2.15.78.
- Active candidate: PR #72 / `m245/cf093-async-discovery-20260912` / exact head `a035714aa5bd9b4d88ae47a59c877b3514a1f287`.
- CF-093 Targeted Recovery `34726688848`: PASS.
- CF-093 Fresh Reconstruction `34726688865`: PASS — complete ordered PR-added CF-093 migration chain.
- Pilot Frontend Build `34726688863`: PASS.
- Cloudflare exact-head preview: PASS/deployed at `a035714a`.
- Discovery worker: v1.3.10 / Edge v29 / SHA `665c56ade30fa89b517255bb023c8ce1a15f88df3935845baeeba17cca21c051`.
- Exact-head Codex review comment `5649541094`: CLEAN / no major issues on reviewed commit `a035714aa5`.
- Production Supabase: not provisioned.

## Gate A — exact-head recovery

- [x] Exact Preview-token provenance bound through provider attempt/job lineage.
- [x] Post-network/pre-Evidence bound-identity revalidation implemented.
- [x] Missing/cancelled exact Preview binding fails closed; no unbound fallback.
- [x] Async completion dedupe requires reusable handoff/terminal completion for every `discovery_started` profile.
- [x] Terminal-only and mixed actionable/terminal accounting implemented.
- [x] Qualified terminal-basis metadata aligned to worker v1.3.10 contract.
- [x] Exact title matching preserves original and prefix-stripped titles.
- [x] Qualified zero-result provider-attempt telemetry is not overwritten as generic success.
- [x] First cancellation timestamp/reason preserved on idempotent replay.
- [x] Forward migration `20260912232827_cf_093_preview_provenance_terminal_dedupe_hardening` applied and checked in.
- [x] Worker v1.3.10 deployed under existing custom auth boundary.
- [x] Exact-head Targeted Recovery PASS.
- [x] Exact-head Frontend Build PASS.
- [x] Exact-head Cloudflare preview deployed.
- [x] Exact-head Codex review clean; all prior P1/P2 inline threads reconciled/resolved.

## Gate B — reconstruction / migration currentness

- [x] Applied migrations remain immutable; no predecessor rewrite/retimestamp.
- [x] UQ bootstrap `20260912005000` precedes immutable `005948` in repository/runtime history.
- [x] Full reconstruction workflow replays all PR-added CF-093 migrations from `20260911231544` through `20260912232827` in order.
- [x] Exact-head full-chain reconstruction `34726688865` PASS.
- [x] Direct ad-hoc modification of `supabase_migrations.schema_migrations` remains prohibited.

## Gate C — authenticated acceptance evidence

- [x] Consequential workflow contract uses nested `dispatch.result.status`.
- [x] Exact-head Cloudflare deployment evidence identifies commit `a035714a`.
- [x] Code/reconstruction/Codex recovery gates are clean.
- [ ] Run consequential authenticated corrective acceptance through the maintained workflow or equivalent normal authenticated Admin/PIM path.

## Gate D — UQ corrective discovery

Historical batch retained as evidence: `5b2bac73-0cd4-4a7f-9487-2baf3ab1443f` = 248 `resolved_l2` + 3 `layer3_required`.
Previous hardened snapshot: 382 scoped / 251 queueable / 54 reopened discovery / 77 retained terminal negatives.

- [x] No corrective dispatch issued while recovery gates were open.
- [ ] Obtain a new authenticated Preview and run only the currently actionable UQ corrective discovery scope.
- [ ] Reconcile newly selected/changed work through deterministic L2 only.
- [ ] Prove exact-token/fingerprint/dedupe and zero generic Layer3/Layer4/Search/Publication side effects.

## Gate E — RMIT corrective discovery

Historical batch retained as evidence: `c8a33237-d2b5-47c3-a02b-2676cb6b820f` = 213 `resolved_l2` + 50 `layer3_required`.
Previous hardened snapshot: 500 scoped / 263 queueable / 27 reopened discovery / 210 retained terminal negatives.

- [x] No corrective dispatch issued while recovery gates were open.
- [ ] After UQ is clean, obtain a new authenticated Preview and run only the currently actionable RMIT corrective discovery scope.
- [ ] Reconcile newly selected/changed work through deterministic L2 only.
- [ ] Prove exact-token/fingerprint/dedupe and zero generic Layer3/Layer4/Search/Publication side effects.

## Gate F — bounded Layer 3

- [x] Qualified JWT-protected Course Layer 3 contract remains separate.
- [x] Generic scheduler Layer 3 remains disabled.
- [ ] Recalculate eligible Layer 3 cohort only after corrective discovery/L2 acceptance closes.
- [ ] Resume bounded authenticated Layer 3 only if still required and qualified.

## Gate G — final PR acceptance

- [x] Exact-head Codex P1/P2 gate clean.
- [x] Full migration-chain reconstruction clean.
- [x] Exact-head Targeted Recovery / Frontend Build / Cloudflare currentness clean at `a035714...`.
- [ ] Corrective UQ/RMIT discovery + changed deterministic L2 clean.
- [ ] Final security/authority/UAT/runtime clean.
- [ ] Governance continuity reconciled after consequential acceptance.
- [ ] Merge/release only after all required gates are clean.

## Exact next action

Run the existing authenticated UQ corrective acceptance against exact head `a035714...`. Do not bypass the maintained browser/authenticated scheduler path with direct database execution. Reconcile UQ before RMIT; keep Layer 3, merge and release paused until deterministic acceptance closes.