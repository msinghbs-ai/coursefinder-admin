# CF-CHG-20260910-093 — Scheduled Workflow Orchestrator

**Status:** ACTIVE — CODEX RECOVERY / DISCOVERY ACCEPTANCE REOPENED / RECONSTRUCTION HISTORY SYNC PENDING  
**Initiated:** 2026-09-10 AEST  
**Reconciled:** 2026-09-12 AEST  
**Category:** 30-admin-pim-ux  
**Parent:** CF-CHG-20260910-092  
**Accepted Pilot main:** `63c7107cfce2d8f607fc378af4881d0ba28ca879`  
**Active Pilot PR:** #72 (`m245/cf093-async-discovery-20260912`)  
**Candidate head:** `013b2878ce748c1a7196c74cb467ac55f5858cd6`  
**Visible accepted release:** v2.15.78

## Objective

Complete the bounded Scheduled Tasks run-on-demand contract for large AU Course Facts scopes without weakening Layer 1 authority, deterministic Layer 2 Evidence truth, Layer 3 Evidence/profile/model/revalidation governance, Layer 4 human resolution, Search/Publication separation or rank/ACL boundaries.

## Current decision

Earlier UQ/RMIT deterministic Layer 2 batch evidence remains retained, but large-university **discovery acceptance is reopened** after exact-head Codex identified authority/correlation and terminal-zero-result defects. Layer 3 acceptance is paused. PR #72 must not merge and no visible release may advance until reconstruction, corrective discovery, final Codex and exact-head gates close.

## Codex review and forward corrections

Codex returned nine actionable findings on predecessor head `a7283139...`. Eight findings are forward-corrected and their review threads are resolved:

1. exact Preview token required through Preview-bound discovery context, continuation and deterministic handoff;
2. bound profile/course identity fingerprint revalidated before any new discovery Evidence write;
3. HTTP 200/no required-prefix-link is transient unless an explicit profile-qualified zero-result marker matches;
4. course-code regex uses escaped `String.raw` word boundaries;
5. async handoff batch IDs persisted into Preview job result for completion-anchored dedupe;
6. dedupe requires every referenced batch to be reusable; cancelled/missing siblings fail closed;
7. cancellation is set-based across all bindings for a multi-profile Preview;
8. terminal-only scopes are non-executable at Preview and stale worker-version UAT is corrected.

Forward Pilot migrations:

- `20260912100539_cf_093_codex_async_token_identity_dedupe_hardening` — applied and checked in;
- `20260912101339_cf_093_terminal_negative_basis_hardening` — applied and checked in.

`layer2-scope-discover-scheduled` is Edge v27 / worker v1.3.9 / SHA `15c958609f6f6787a4de2e449d15e3e3e9718480da4c8599743c0da92a3d4ef2`. Existing nonce/service authentication remains unchanged. Current UQ/RMIT profiles have no zero-result markers; none was fabricated.

## Reconstruction P1 — source fix prepared, official history sync pending

Codex correctly identified that already-applied `20260912005948_cf_093_uq_native_program_discovery_profile.sql` cannot replay from repository foundation: UQ v1 has no `discovery_strategy`, nested `jsonb_set` cannot create the missing intermediate object, and the unchanged hash violates `unique(profile_id,configuration_hash)`.

The applied migration itself remains immutable and was not edited or retimestamped.

PR #72 now contains an earlier, idempotent reconstruction bootstrap:

`20260912005000_cf_093_uq_discovery_strategy_reconstruction_bootstrap.sql`

On a fresh replay it runs before immutable `005948`, adds only `discovery_strategy={"type":"first_party_search"}` when absent through normal profile-version governance, then allows `005948` to add its own URL/query/prefix values. A read-only simulation against the actual UQ v1 configuration proved:

- v1 hash `77dda7fa33501c67a046dff1e5385554a419853c64f12f5b56e1c23a63da0d72`;
- resulting config validation PASS;
- candidate hash `1cb8d860cce8d907de5c326975fabfe11865861a3b5c75dee0ac4a54f91145e8`, distinct from v1.

Pilot already has the resulting discovery-strategy semantics through existing applied history. The retroactive bootstrap therefore requires the **official Supabase migration-history repair**, not direct SQL:

`supabase migration repair 20260912005000 --status applied --linked`

The connected Supabase tool does not expose `migration repair`; no direct INSERT/DELETE against `supabase_migrations.schema_migrations` has been performed. After the authorised CLI action, `supabase migration list` parity and a fresh reconstruction/reset proof are required. This gate remains open until that evidence exists.

## Reopened UQ/RMIT scope

After terminal-basis hardening:

| Cohort | Scoped | Queueable | Reopened discovery | Retained governed terminal negatives |
|---|---:|---:|---:|---:|
| UQ | 382 | 251 | 54 | 77 |
| RMIT | 500 | 263 | 27 | 210 |

No corrective discovery run has yet been dispatched. Historical deterministic outcomes remain evidence only:

- UQ `5b2bac73-0cd4-4a7f-9487-2baf3ab1443f`: 248 `resolved_l2` + 3 `layer3_required`;
- RMIT `c8a33237-d2b5-47c3-a02b-2676cb6b820f`: 213 `resolved_l2` + 50 `layer3_required`.

## Current repository / deployment evidence

- Exact candidate head `013b2878ce748c1a7196c74cb467ac55f5858cd6`.
- Pilot Frontend Build `34688257411`: PASS.
- Cloudflare exact-head preview: PASS/deployed.
- PR remains OPEN / DRAFT / mergeable but governance-blocked.
- Eight corrected Codex review threads are resolved; reconstruction/history-sync gate remains open pending fresh review + CLI repair/reconstruction proof.
- Accepted main/release unchanged.

## Authority boundaries retained

- Layer 1 identity/source authority unchanged.
- Layer 2 remains deterministic, Evidence-preserving and fail-closed.
- No URL/profile/route/zero-result marker was manufactured.
- `layer3_required` remains an L2 disposition only; generic scheduler Layer 3 remains prohibited.
- Search/Publication remains separately governed.
- No applied migration was rewritten or retimestamped.
- No migration-history tracking row was directly inserted/deleted.

## Exact next gates

1. Obtain fresh Codex review of exact head `013b2878...`, specifically the retroactive bootstrap and forward async/terminal corrections.
2. From an authorised Supabase CLI session, execute official `supabase migration repair 20260912005000 --status applied --linked`; then prove local/remote `migration list` parity and fresh reconstruction/reset.
3. Through normal authenticated scheduler, rediscover only 54 UQ + 27 RMIT reopened Courses.
4. Reconcile deterministic Layer 2 only for newly selected/changed actionable work and prove exact-token/fingerprint/dedupe/cancel behavior naturally.
5. Prove zero generic Layer 3, Layer 4 auto-approval, Search or Publication side effects.
6. Resume bounded authenticated Layer 3 only after CF-093 recovery gates close.
7. Merge/release remains prohibited until all P1s, final Codex, exact-head CI/UAT/runtime and governance gates are clean.

## Next AU qualification wave

Monash → Melbourne → ANU → UTS → UWA → Sydney → UNSW remains deferred until CF-093 closes. Cohort membership is not authority to manufacture configuration.
