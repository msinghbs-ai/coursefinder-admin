# M2.4.5 CURRENT STATE

**Status:** ACTIVE / PRE-PRODUCTION HARDENING — CF-093 CODEX RECOVERY / RECONSTRUCTION HISTORY SYNC PENDING  
**Reconciled:** 2026-09-12 AEST  
**Accepted Pilot main:** `63c7107cfce2d8f607fc378af4881d0ba28ca879`  
**Visible accepted release:** v2.15.78  
**Pilot Supabase:** `fxcwkweaxjtknorudmwp`  
**Production:** not provisioned; M2.5 remains PAUSED at P0

## Active candidate

- PR #72 / branch `m245/cf093-async-discovery-20260912`.
- Exact head `013b2878ce748c1a7196c74cb467ac55f5858cd6`.
- PR OPEN / DRAFT / mergeable but governance-blocked.
- Exact-head Frontend Build `34688257411`: PASS.
- Cloudflare exact-head preview: PASS/deployed.
- Worker Edge v27 / v1.3.9 / SHA `15c958609f6f6787a4de2e449d15e3e3e9718480da4c8599743c0da92a3d4ef2`.

## Codex recovery

Nine actionable findings were returned. Eight have forward fixes and resolved review threads. Applied/checked-in runtime corrections:

- `20260912100539_cf_093_codex_async_token_identity_dedupe_hardening`;
- `20260912101339_cf_093_terminal_negative_basis_hardening`.

They enforce exact Preview-token propagation, identity fingerprint revalidation before Evidence writes, async batch-aware all-batch dedupe, set-based cancellation, terminal-only Preview rejection and hardened terminal-negative freshness. Worker v1.3.9 fails first-party HTTP 200/no-link pages transient unless a configured zero-result marker matches; UQ/RMIT have no such markers.

## Reconstruction P1 — bootstrap prepared, history sync pending

Applied migration `20260912005948_cf_093_uq_native_program_discovery_profile.sql` is immutable but cannot replay from repository foundation because UQ v1 has no `discovery_strategy`. Missing intermediate JSON path leaves the config unchanged and collides with `UNIQUE(profile_id,configuration_hash)`.

PR #72 now includes earlier idempotent bootstrap `20260912005000_cf_093_uq_discovery_strategy_reconstruction_bootstrap.sql`, which creates only the missing `first_party_search` strategy object before `005948`. Read-only simulation against actual UQ v1 proved validation PASS and distinct candidate hash (`1cb8d860cce8d907de5c326975fabfe11865861a3b5c75dee0ac4a54f91145e8` vs v1 `77dda7fa33501c67a046dff1e5385554a419853c64f12f5b56e1c23a63da0d72`).

Pilot already has the resulting schema semantics. Official Supabase history tracking must therefore be synchronised via:

`supabase migration repair 20260912005000 --status applied --linked`

The connected tool does not expose that CLI action. No direct modification of `supabase_migrations.schema_migrations` has been made or authorised. Migration-list parity and fresh reconstruction/reset proof remain required before this P1 closes.

## Discovery acceptance reopened

Current hardened snapshots:

| Cohort | Scoped | Queueable | Reopened discovery | Retained terminal negatives |
|---|---:|---:|---:|---:|
| UQ | 382 | 251 | 54 | 77 |
| RMIT | 500 | 263 | 27 | 210 |

Historical deterministic outcomes remain evidence only:

- UQ `5b2bac73-0cd4-4a7f-9487-2baf3ab1443f`: 248 `resolved_l2` + 3 `layer3_required`.
- RMIT `c8a33237-d2b5-47c3-a02b-2676cb6b820f`: 213 `resolved_l2` + 50 `layer3_required`.

No corrective rediscovery has been dispatched yet.

## Layer 3

Previously inspected JWT-protected Layer 3 contract remains qualified. Live acceptance is paused behind CF-093 reconstruction and reopened discovery. Generic scheduler Layer 3 remains prohibited.

## Exact next gate

1. Fresh Codex review on `013b2878...`.
2. Authorised official Supabase migration repair for `20260912005000`, then `migration list` parity + fresh reconstruction/reset proof.
3. Authenticated scheduler rediscovery of UQ 54 + RMIT 27 only.
4. Deterministic L2 only for newly selected/changed actionable work; prove no generic L3/Layer4 auto-approval/Search/Publication side effects.
5. Resume bounded authenticated Layer 3 only after CF-093 recovery gates close.
6. Merge/release remains prohibited until all final gates are clean.

M2.4.4 remains CLOSED/PASS/FROZEN and M2.5 remains paused.
