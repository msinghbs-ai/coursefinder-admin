# M2.4.5 NEXT CHAT

## Current pickup — 12 September 2026

- Milestone: **M2.4.5 ACTIVE / PRE-PRODUCTION HARDENING — CF-093 CODEX RECOVERY**.
- M2.5 remains PAUSED at P0; no Production Supabase exists.
- Accepted Pilot main: `63c7107cfce2d8f607fc378af4881d0ba28ca879`.
- Visible accepted release: v2.15.78.
- Pilot Supabase: `fxcwkweaxjtknorudmwp`.
- Active change: `CF-CHG-20260910-093`.
- PR #72: OPEN / DRAFT / mergeable but governance-blocked, head `c5226c2bcadd7ee7102935088130262ca2a3a2a2`.
- Exact-head Frontend Build `34687938846`: PASS.
- Exact-head Cloudflare preview: PASS/deployed.
- `layer2-scope-discover-scheduled`: Edge v27 / worker v1.3.9 / SHA `15c958609f6f6787a4de2e449d15e3e3e9718480da4c8599743c0da92a3d4ef2`.

## Codex result and recovery

Codex returned nine actionable findings on predecessor head `a7283139...`. Eight now have forward fixes and their review threads are resolved:

- exact Preview token through bound discovery context/continuation/handoff;
- identity fingerprint revalidation before Evidence writes;
- no unqualified HTTP-200/no-link terminal zero result;
- escaped course-code regex word boundaries;
- async handoff batch recording for completion dedupe;
- all referenced batches must be reusable for dedupe;
- set-based multi-profile cancellation;
- terminal-only Preview blocking + stale worker-version UAT correction.

Forward runtime migrations:

- `20260912100539_cf_093_codex_async_token_identity_dedupe_hardening`;
- `20260912101339_cf_093_terminal_negative_basis_hardening`.

No applied migration was rewritten or retimestamped.

## Open P1 — repository reconstruction

One Codex P1 remains intentionally unresolved: applied migration `20260912005948_cf_093_uq_native_program_discovery_profile.sql` assumes `discovery_strategy` already exists. Repository foundation `20260823102443` seeds UQ without that object. PostgreSQL nested `jsonb_set` therefore leaves the configuration unchanged and the migration attempts to reinsert the existing configuration hash; runtime schema has `unique(profile_id,configuration_hash)`, so fresh reconstruction aborts.

Do **not** edit/retimestamp `20260912005948` and do not mutate `supabase_migrations.schema_migrations` ad hoc. Establish a governed reconstruction/baseline solution before merge.

## Discovery acceptance reopened

Codex showed the earlier worker could classify a first-party HTTP 200 page with no required-prefix link as terminal `current_page_not_found` without an explicit qualified zero-result marker. Worker v1.3.9 now fails that case transient unless the profile defines a matching `discovery_strategy.zero_result_markers`. UQ/RMIT currently define none; do not invent markers.

Migration `20260912101339` prevents legacy `current_page_not_found` rows from suppressing rediscovery. Current hardened snapshots:

| Cohort | Scoped | Queueable | Reopened discovery | Retained terminal negatives |
|---|---:|---:|---:|---:|
| UQ | 382 | 251 | 54 | 77 |
| RMIT | 500 | 263 | 27 | 210 |

UQ fingerprint: `2661fefb086294a948862eac08f0c297`.  
RMIT fingerprint: `cd360b3d2b6ba4ba8c2a5a9442cc761a`.

Historical deterministic executions remain evidence, not current discovery acceptance:

- UQ `5b2bac73-0cd4-4a7f-9487-2baf3ab1443f`: 248 `resolved_l2` + 3 `layer3_required`.
- RMIT `c8a33237-d2b5-47c3-a02b-2676cb6b820f`: 213 `resolved_l2` + 50 `layer3_required`.

No corrective UQ/RMIT run has been dispatched yet. Do not rerun the entire 382/500 scope unnecessarily; after reconstruction P1 is resolved, use the normal authenticated scheduler surface and rediscover only the reopened 54 + 27 Courses.

## Layer 3

Previously inspected Course Layer 3 contract remains qualified and JWT-protected, with 53 historical UQ/RMIT `layer3_required` Evidence items and no interpretation at inspection time. **Layer 3 acceptance is paused behind CF-093 recovery.** Generic scheduler Layer 3 remains prohibited.

## Exact next actions

1. Resolve the repository reconstruction P1 through a governed baseline/reconstruction strategy without changing immutable applied history.
2. Request/review fresh Codex on the final corrective head; leave the reconstruction thread open until genuinely fixed.
3. Run authenticated corrective rediscovery for **UQ 54 + RMIT 27 only**.
4. Reconcile newly selected/changed actionable work through deterministic L2 and verify exact-token/fingerprint/dedupe/cancel semantics naturally.
5. Prove no generic Layer 3, Layer 4 auto-approval, Search or Publication side effects.
6. Update metrics and governance from actual outcomes.
7. Resume bounded authenticated Layer 3 only after CF-093 discovery/reconstruction gates are clean.
8. Merge/release remains prohibited until final Codex + exact-head CI/UAT/runtime + governance acceptance are all clean.
9. After CF-093 closes: Monash → Melbourne → ANU → UTS → UWA → Sydney → UNSW through normal qualification only.

## Pickup text

> Continue CF M2.4.5 / CF-CHG-20260910-093 from repository/runtime truth. Accepted Pilot main remains `63c7107cfce2d8f607fc378af4881d0ba28ca879`, visible release v2.15.78. PR #72 is draft/open at `c5226c2bcadd7ee7102935088130262ca2a3a2a2`; Frontend Build `34687938846` and Cloudflare preview PASS. Codex returned nine findings; eight are forward-fixed and threads resolved. Forward migrations `20260912100539` and `20260912101339` are applied; worker v1.3.9 is Edge v27. One P1 remains: applied UQ migration `20260912005948` cannot replay from repository foundation because `discovery_strategy` is absent; do not rewrite/retimestamp it or mutate migration history ad hoc. Discovery acceptance is reopened: UQ 54 and RMIT 27 Courses require corrective rediscovery; 77/210 stronger negatives remain terminal. Resolve reconstruction first, then run only the reopened scopes through normal authenticated scheduler, reconcile deterministic L2 changes, and only then resume Layer 3. Do not merge/release while any P1 remains.
