# M2.4.5 NEXT CHAT

## Current pickup — 12 September 2026

- Milestone: **M2.4.5 ACTIVE / PRE-PRODUCTION HARDENING — CF-093 CODEX RECOVERY**.
- M2.5 remains PAUSED at P0; no Production Supabase exists.
- Accepted Pilot main: `63c7107cfce2d8f607fc378af4881d0ba28ca879`.
- Visible accepted release: v2.15.78.
- Pilot Supabase: `fxcwkweaxjtknorudmwp`.
- Active change: `CF-CHG-20260910-093`.
- PR #72: OPEN / DRAFT / mergeable but governance-blocked, current head `013b2878ce748c1a7196c74cb467ac55f5858cd6`.
- Last proven corrective head `c5226c2bcadd7ee7102935088130262ca2a3a2a2`: Frontend Build `34687938846` PASS and Cloudflare preview PASS.
- Current head adds only the reconstruction bootstrap + its regression test; obtain exact-head CI/Cloudflare/Codex before acceptance.
- `layer2-scope-discover-scheduled`: Edge v27 / worker v1.3.9 / SHA `15c958609f6f6787a4de2e449d15e3e3e9718480da4c8599743c0da92a3d4ef2`.

## Codex recovery

Codex returned nine actionable findings. Eight are forward-fixed and threads resolved. Forward runtime migrations applied and checked in:

- `20260912100539_cf_093_codex_async_token_identity_dedupe_hardening`;
- `20260912101339_cf_093_terminal_negative_basis_hardening`.

Worker v1.3.9 now requires exact Preview token on Preview-bound async discovery, revalidates binding identity before Evidence writes, fails unqualified 200/no-link pages transient, uses corrected regex boundaries, and uses token-aware continuation/handoff services. Dedupe/cancel/terminal-only Preview SQL defects are forward-fixed.

## Historical reconstruction P1 — proposed governed remedy

Applied migration `20260912005948_cf_093_uq_native_program_discovery_profile.sql` cannot replay from the repository foundation because the UQ v1 seed has no `discovery_strategy`; nested `jsonb_set` cannot create missing intermediate path elements and the unchanged configuration hash violates `unique(profile_id,configuration_hash)`.

Do **not** edit or retimestamp `20260912005948`.

PR #72 now contains a deliberately earlier, idempotent bootstrap:

`20260912005000_cf_093_uq_discovery_strategy_reconstruction_bootstrap.sql`

It runs before immutable `005948` on fresh reconstruction and creates only the missing `discovery_strategy` object with `type=first_party_search` through normal version governance. A runtime simulation using the actual UQ v1 seed proved that bootstrap + immutable `005948` produces a valid config and a distinct configuration hash.

Pilot already has the resulting qualified discovery strategy through its applied history, so this retroactive bootstrap must **not** be executed by direct history-table SQL. The remaining authorised remote-history action is the official Supabase CLI operation:

`supabase migration repair 20260912005000 --status applied --linked`

This official command updates migration tracking only; it does not run the migration SQL. The current connector does not expose `migration repair`, so that one history-sync action remains pending. Do not emulate it with direct INSERT/DELETE against `supabase_migrations.schema_migrations`.

## Discovery acceptance reopened

Migration `20260912101339` prevents legacy `current_page_not_found` from suppressing rediscovery. Current hardened snapshots:

| Cohort | Scoped | Queueable | Reopened discovery | Retained terminal negatives |
|---|---:|---:|---:|---:|
| UQ | 382 | 251 | 54 | 77 |
| RMIT | 500 | 263 | 27 | 210 |

UQ fingerprint: `2661fefb086294a948862eac08f0c297`.  
RMIT fingerprint: `cd360b3d2b6ba4ba8c2a5a9442cc761a`.

No corrective discovery run has been dispatched. Historical deterministic batches remain evidence only:

- UQ `5b2bac73-0cd4-4a7f-9487-2baf3ab1443f`: 248 `resolved_l2` + 3 `layer3_required`.
- RMIT `c8a33237-d2b5-47c3-a02b-2676cb6b820f`: 213 `resolved_l2` + 50 `layer3_required`.

## Layer 3

Previously inspected Layer 3 contract remains qualified/JWT-protected. Live acceptance is paused behind CF-093 reconstruction + reopened discovery. Generic scheduler Layer 3 remains prohibited.

## Exact next actions

1. Verify exact-head CI/Cloudflare for `013b2878...`.
2. Ask Codex to review the retroactive bootstrap design and all current corrections; keep merge blocked until review is clean.
3. Perform official `supabase migration repair 20260912005000 --status applied --linked` from an authorised CLI session; do not use direct SQL to fake it.
4. Confirm `supabase migration list` shows local/remote aligned and perform a fresh `supabase db reset`/reconstruction proof where available.
5. Through normal authenticated scheduler, rediscover only UQ 54 + RMIT 27 reopened Courses, then reconcile only newly selected/changed deterministic L2 work.
6. Prove no generic Layer 3/Layer 4 auto-approval/Search/Publication side effects.
7. Resume bounded authenticated Layer 3 only after CF-093 recovery gates close.
8. Merge/release remains prohibited until final Codex + exact-head CI/UAT/runtime + migration reconstruction + governance acceptance are clean.

## Pickup text

> Continue CF M2.4.5 / CF-CHG-20260910-093 from repository/runtime truth. Accepted Pilot main remains `63c7107cfce2d8f607fc378af4881d0ba28ca879`, release v2.15.78. PR #72 is draft/open at `013b2878ce748c1a7196c74cb467ac55f5858cd6`. Codex returned nine findings; eight are forward-fixed. Runtime migrations `20260912100539` and `20260912101339` are applied; worker v1.3.9 is Edge v27. A retroactive idempotent reconstruction bootstrap `20260912005000` now precedes immutable applied UQ migration `20260912005948`; simulation against the UQ v1 seed validates bootstrap+005948. Pilot already has the resulting schema semantics, but official Supabase `migration repair 20260912005000 --status applied --linked` remains required and must not be emulated with direct migration-history SQL. Discovery acceptance is reopened: UQ 54 + RMIT 27 need corrective authenticated rediscovery; 77/210 stronger negatives remain terminal. Verify exact-head CI/Codex, complete official migration-history sync/reconstruction proof, then run only reopened discovery scopes. Layer 3 remains paused; do not merge/release while any P1/gate remains.
