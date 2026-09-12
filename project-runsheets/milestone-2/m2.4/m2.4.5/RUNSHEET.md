# M2.4.5 RUNSHEET — Admin/PIM Hardening & Pre-Production Operational Readiness

**Status:** ACTIVE / PRE-PRODUCTION HARDENING — CF-093 CODEX RECOVERY / RECONSTRUCTION SYNC PENDING  
**Opened:** 2026-09-03 10:28 AEST  
**Reconciled:** 2026-09-12 AEST  
**Predecessor:** M2.4.4 CLOSED / PASS / FROZEN  
**Successor:** M2.5 Production Readiness — PAUSED AT P0

## Current baseline

- Accepted Pilot main: `63c7107cfce2d8f607fc378af4881d0ba28ca879`.
- Visible accepted release: v2.15.78.
- Active candidate: PR #72 / `m245/cf093-async-discovery-20260912` / head `edb115cca6f6a94957ff6a99aac12a6b235713aa`.
- Exact-head CF-093 Targeted Recovery `34690128803`: PASS.
- Exact-head Pilot Frontend Build `34690128811`: PASS.
- Cloudflare exact-head preview: PASS/deployed.
- Pilot Supabase: `fxcwkweaxjtknorudmwp`.
- Worker: Edge v27 / v1.3.9 / SHA `15c958609f6f6787a4de2e449d15e3e3e9718480da4c8599743c0da92a3d4ef2`.
- Production Supabase: not provisioned.
- PR remains draft/open; merge prohibited until all gates below close.

## Gate A — Codex recovery / runtime hardening

- [x] Exact Preview-token bound async discovery context/continuation/handoff.
- [x] Identity fingerprint revalidation before discovery Evidence writes.
- [x] No unqualified first-party HTTP-200/no-link terminal zero result.
- [x] Regex word-boundary correction.
- [x] Async handoff batch completion anchoring.
- [x] All-batch reusable requirement for dedupe.
- [x] Set-based multi-profile cancellation.
- [x] Terminal-only Preview non-executable.
- [x] Legacy `current_page_not_found` freshness invalidated by forward migration `20260912101339` unless later explicitly qualified.
- [x] Forward migration `20260912100539` applied + checked in.
- [x] Exact-head targeted recovery `34690128803` PASS.
- [x] Exact-head Frontend Build `34690128811` PASS and Cloudflare preview PASS.
- [ ] Fresh exact-head Codex technical outcome for `edb115cc...`; request comment `5645499063` is pending.

Targeted CI history retained as diagnostic evidence:
- `34689908598`: 13 pass / 4 stale-assertion failures;
- `34690059287`: 16 pass / 1 stale cancellation-key assertion failure;
- `34690128803`: PASS after assertions were aligned to the current immutable + forward-hardened contract.

## Gate B — repository reconstruction / migration currentness

- [x] Confirmed reconstruction failure mechanism in immutable applied `20260912005948`: missing `discovery_strategy` intermediate object → unchanged config hash → unique violation.
- [x] Preserved `20260912005948` unchanged/unretimestamped.
- [x] Added retroactive idempotent bootstrap `20260912005000_cf_093_uq_discovery_strategy_reconstruction_bootstrap.sql` ordered before `005948`.
- [x] Read-only simulation against actual UQ v1 seed: validation PASS and distinct candidate configuration hash.
- [x] Added reconstruction ordering/regression UAT and included it in exact-head targeted PASS.
- [ ] From authorised Supabase CLI: `supabase migration repair 20260912005000 --status applied --linked`.
- [ ] Verify `supabase migration list` local/remote parity.
- [ ] Prove fresh reconstruction / `supabase db reset` succeeds through CF-093 chain.
- [x] Keep direct SQL mutation of `supabase_migrations.schema_migrations` prohibited.

## Gate C — UQ corrective discovery

Historical deterministic batch retained as evidence: `5b2bac73-0cd4-4a7f-9487-2baf3ab1443f` = 248 `resolved_l2` + 3 `layer3_required`.

Current hardened snapshot:
- 382 scoped;
- 251 queueable;
- **54 reopened discovery**;
- 77 retained terminal negatives;
- fingerprint `2661fefb086294a948862eac08f0c297`.

- [ ] Normal authenticated Preview/run for reopened UQ discovery only, after Gate B closes.
- [ ] Reconcile changed/newly selected actionable work through deterministic L2 only.
- [ ] Prove exact-token/fingerprint/dedupe and side-effect boundaries.

## Gate D — RMIT corrective discovery

Historical deterministic batch retained as evidence: `c8a33237-d2b5-47c3-a02b-2676cb6b820f` = 213 `resolved_l2` + 50 `layer3_required`.

Current hardened snapshot:
- 500 scoped;
- 263 queueable;
- **27 reopened discovery**;
- 210 retained terminal negatives;
- fingerprint `cd360b3d2b6ba4ba8c2a5a9442cc761a`.

- [ ] Normal authenticated Preview/run for reopened RMIT discovery only, after Gate B closes.
- [ ] Reconcile changed/newly selected actionable work through deterministic L2 only.
- [ ] Prove exact-token/fingerprint/dedupe and side-effect boundaries.

## Gate E — bounded Layer 3

Paused while Gates A–D remain open.

- [x] Qualified JWT-protected Course Layer 3 contract inspected.
- [x] Historical cohort at inspection: 53 `layer3_required` text/html Evidence items, 0 interpretations.
- [ ] Recalculate eligible Layer 3 cohort after corrective discovery/L2 closes.
- [ ] Resume one-call bounded authenticated live-provider acceptance only after CF-093 recovery is clean.
- [x] Generic scheduler Layer 3 remains disabled.

## Gate F — final PR acceptance

- [ ] All Codex P1/P2 findings closed on final exact head.
- [ ] Migration history/reconstruction proof clean.
- [ ] Corrective UQ/RMIT discovery + changed deterministic L2 clean.
- [ ] Exact-head CI/UAT/runtime clean.
- [ ] Final PR acceptance summary reconciled.
- [ ] Merge only after all required gates are clean; no visible release bump before acceptance.

## Continuous M2.4.5 gates

- H7 production migration/telemetry inventory remains active; Production target states pending.
- H8 bugs/addenda/features remain Change-Controlled.
- H9 targeted validation precedes bounded integration.
- H10 meeting/status evidence remains maintained.
- QS ranking recovery remains independent.
- H14 external-consumer API-key lifecycle remains separately governed.

## Exact next action

Complete the authorised official Supabase migration-history repair for `20260912005000`, prove local/remote migration parity and fresh reconstruction/reset, while awaiting the exact-head Codex outcome. Only after those gates close may the reopened UQ 54 + RMIT 27 discovery scope run through the normal authenticated scheduler. Layer 3 remains paused.
