# M2.4.5 NEXT CHAT

## Current pickup — 12 September 2026

- Milestone: **M2.4.5 ACTIVE / PRE-PRODUCTION HARDENING — CF-093 CODEX RECOVERY**.
- M2.5 remains PAUSED at P0; no Production Supabase exists.
- Accepted Pilot main: `63c7107cfce2d8f607fc378af4881d0ba28ca879`.
- Visible accepted release: v2.15.78.
- Pilot Supabase: `fxcwkweaxjtknorudmwp`.
- Active change: `CF-CHG-20260910-093`.
- PR #72: OPEN / DRAFT / mergeable but governance-blocked, exact head `013b2878ce748c1a7196c74cb467ac55f5858cd6`.
- Exact-head Frontend Build `34688257411`: PASS.
- Exact-head Cloudflare preview: PASS/deployed.
- `layer2-scope-discover-scheduled`: Edge v27 / worker v1.3.9 / SHA `15c958609f6f6787a4de2e449d15e3e3e9718480da4c8599743c0da92a3d4ef2`.

## Codex recovery

Codex returned nine actionable findings. Eight are forward-fixed and threads resolved. Runtime migrations `20260912100539` and `20260912101339` are applied and checked in. Worker v1.3.9 enforces exact Preview token, identity revalidation before Evidence writes, fail-transient unqualified 200/no-link pages, corrected regex boundaries and token-aware continuation/handoff. Dedupe/cancel/terminal-only Preview defects are forward-fixed.

## Reconstruction P1 — source remedy prepared / history sync pending

Immutable applied `20260912005948_cf_093_uq_native_program_discovery_profile.sql` cannot replay from repository foundation because UQ v1 lacks `discovery_strategy`. Missing intermediate JSON path leaves config unchanged and collides with `UNIQUE(profile_id,configuration_hash)`.

Do not edit/retimestamp `005948`.

PR #72 contains retroactive idempotent bootstrap `20260912005000_cf_093_uq_discovery_strategy_reconstruction_bootstrap.sql`. It runs before `005948` on fresh reconstruction, adds only `discovery_strategy={"type":"first_party_search"}` through normal profile-version governance, and has regression coverage. Read-only simulation against actual UQ v1 proved validation PASS and a distinct hash.

Pilot already has the resulting strategy semantics. Remaining authorised history step:

`supabase migration repair 20260912005000 --status applied --linked`

The connector does not expose this official CLI action. Do not emulate it with direct SQL against `supabase_migrations.schema_migrations`. After authorised repair, prove `supabase migration list` parity and fresh `supabase db reset`/reconstruction.

## Discovery acceptance reopened

| Cohort | Scoped | Queueable | Reopened discovery | Retained terminal negatives |
|---|---:|---:|---:|---:|
| UQ | 382 | 251 | 54 | 77 |
| RMIT | 500 | 263 | 27 | 210 |

UQ fingerprint `2661fefb086294a948862eac08f0c297`; RMIT `cd360b3d2b6ba4ba8c2a5a9442cc761a`.

No corrective discovery has been dispatched. Historical deterministic batches remain evidence only: UQ `5b2bac73...` = 248 resolved + 3 L3-required; RMIT `c8a33237...` = 213 resolved + 50 L3-required.

## Layer 3

Qualified JWT-protected contract remains available but live acceptance is paused behind CF-093 recovery. Generic scheduler Layer 3 remains prohibited.

## Exact next actions

1. Request/review fresh Codex on exact head `013b2878...`.
2. Perform authorised official Supabase `migration repair 20260912005000 --status applied --linked`, then migration-list parity and fresh reconstruction proof.
3. Through normal authenticated scheduler, rediscover only UQ 54 + RMIT 27 reopened Courses.
4. Reconcile only newly selected/changed deterministic L2 work; prove exact-token/fingerprint/dedupe/cancel and zero generic L3/Layer4 auto-approval/Search/Publication effects.
5. Resume bounded authenticated Layer 3 only after CF-093 recovery gates close.
6. Merge/release remains prohibited until final Codex + exact-head CI/UAT/runtime + migration reconstruction + governance acceptance are clean.
7. After CF-093 closes: Monash → Melbourne → ANU → UTS → UWA → Sydney → UNSW through normal qualification only.

## Pickup text

> Continue CF M2.4.5 / CF-CHG-20260910-093 from repository/runtime truth. Accepted Pilot main is `63c7107cfce2d8f607fc378af4881d0ba28ca879`, release v2.15.78. PR #72 is draft/open at exact head `013b2878ce748c1a7196c74cb467ac55f5858cd6`; Frontend Build `34688257411` and Cloudflare preview PASS. Codex returned nine findings; eight are forward-fixed. Migrations `20260912100539` and `20260912101339` are applied; worker v1.3.9 is Edge v27. Retroactive reconstruction bootstrap `20260912005000` now precedes immutable applied UQ migration `20260912005948`; simulation validates bootstrap+005948, but official `supabase migration repair 20260912005000 --status applied --linked` plus migration-list/reset proof remains required and must not be emulated via direct history SQL. Discovery acceptance is reopened: UQ 54 + RMIT 27 need corrective authenticated rediscovery. Layer 3 remains paused. Do not merge/release while any gate remains.
