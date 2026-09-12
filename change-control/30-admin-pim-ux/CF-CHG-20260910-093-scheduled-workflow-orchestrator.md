# CF-CHG-20260910-093 — Scheduled Workflow Orchestrator

**Status:** ACTIVE — CODEX RECOVERY / DISCOVERY ACCEPTANCE REOPENED / MERGE BLOCKED  
**Initiated:** 2026-09-10 AEST  
**Reconciled:** 2026-09-12 AEST  
**Category:** 30-admin-pim-ux  
**Parent:** CF-CHG-20260910-092  
**Accepted Pilot main:** `63c7107cfce2d8f607fc378af4881d0ba28ca879`  
**Active Pilot PR:** #72 (`m245/cf093-async-discovery-20260912`)  
**Candidate head:** `c5226c2bcadd7ee7102935088130262ca2a3a2a2`  
**Visible accepted release:** v2.15.78

## Objective

Complete the bounded Scheduled Tasks run-on-demand contract for large AU Course Facts scopes without weakening Layer 1 authority, deterministic Layer 2 Evidence truth, Layer 3 Evidence/profile/model/revalidation governance, Layer 4 human resolution, Search/Publication separation or rank/ACL boundaries.

## Current decision

The earlier UQ/RMIT deterministic Layer 2 batch evidence remains valid evidence of what executed, but **large-university discovery acceptance is reopened** after exact-head Codex review identified fail-closed/correlation defects and an unsafe terminal zero-result assumption. Layer 3 acceptance is paused until CF-093 discovery/reconstruction blockers close. PR #72 must not merge and no visible release may be advanced.

## Codex review — 12 Sep 2026

Codex returned nine actionable findings on the prior exact head: three P1 authority/reconstruction defects and six P2 correctness/recovery defects.

Forward corrections now address eight findings:

1. exact Preview token is mandatory through Preview-bound discovery context, continuation and deterministic handoff;
2. bound profile/course identity fingerprint is revalidated before any new discovery Evidence write;
3. first-party HTTP 200/no required-prefix-link is transient unless an explicit profile-qualified zero-result marker is observed;
4. course-code regex word boundaries use an escaped `String.raw` contract;
5. async handoff batch IDs are persisted into Preview job result so completion-anchored dedupe includes discovery-backed batches;
6. dedupe reuse requires every referenced batch to exist and be completed/partial; cancelled/missing siblings fail closed;
7. operator cancellation is set-based across all bindings for a multi-profile Preview;
8. terminal-only scopes are non-executable at Preview; stale worker-version UAT was updated.

The historical UQ migration reconstruction P1 remains OPEN: `20260912005948_cf_093_uq_native_program_discovery_profile.sql` performs nested `jsonb_set` against a repository-seeded UQ configuration that has no `discovery_strategy` object. On fresh reconstruction the update is ineffective and the subsequent version insert reuses the current configuration hash, violating `unique(profile_id, configuration_hash)`. This migration is already applied in Pilot and **must not be rewritten or retimestamped**. No ad-hoc mutation of `supabase_migrations.schema_migrations` is authorised. A governed reconstruction/baseline remedy is required before merge.

## Forward Pilot corrections

### Migration `20260912100539_cf_093_codex_async_token_identity_dedupe_hardening`

Applied forward-only to Pilot and checked into PR #72. It adds exact-token service wrappers, identity revalidation, async handoff batch recording, all-batch completion dedupe, set-based cancellation and terminal-only Preview blocking.

### Worker v1.3.9 / Edge v27

`layer2-scope-discover-scheduled` deployed as Edge v27, worker `layer2-scope-discover-scheduled-v1.3.9`, runtime SHA `15c958609f6f6787a4de2e449d15e3e3e9718480da4c8599743c0da92a3d4ef2`.

The existing one-time nonce/service authentication model is unchanged (`verify_jwt=false` remains the already-governed custom-auth boundary). Preview-bound executions require `scheduler_preview_token`; missing token fails closed. Worker uses only exact-token context/continuation/handoff services for scheduler-bound discovery.

A first-party search page with no required-prefix links is no longer terminal solely because it returned HTTP 200. It requires an explicit configured `discovery_strategy.zero_result_markers` match. Current UQ/RMIT profiles do not define such markers, so no marker was fabricated.

### Migration `20260912101339_cf_093_terminal_negative_basis_hardening`

Applied forward-only and checked into PR #72. Legacy `current_page_not_found` rows no longer suppress rediscovery. `ambiguous` and `identity_mismatch` remain recognised terminal negatives. A future `current_page_not_found` may only become freshness-eligible after a future worker contract records explicit terminal basis; the current v1.3.9 worker does not grant that freshness.

## Reopened UQ/RMIT scope

After terminal-basis hardening, current runtime snapshots are:

| Cohort | Scoped | Queueable | Reopened discovery | Retained governed terminal negatives |
|---|---:|---:|---:|---:|
| UQ | 382 | 251 | 54 | 77 |
| RMIT | 500 | 263 | 27 | 210 |

Thus only **81 Courses** are reopened (54 UQ + 27 RMIT); the stronger existing `ambiguous`/`identity_mismatch` outcomes remain terminal. No new UQ/RMIT execution has been dispatched from this corrective step.

Previous deterministic batch evidence remains retained:

- UQ batch `5b2bac73-0cd4-4a7f-9487-2baf3ab1443f`: 248 `resolved_l2` + 3 `layer3_required`.
- RMIT batch `c8a33237-d2b5-47c3-a02b-2676cb6b820f`: 213 `resolved_l2` + 50 `layer3_required`.

These are historical execution outcomes, not current discovery acceptance after the zero-result correction.

## Current repository / deployment evidence

- Candidate head `c5226c2bcadd7ee7102935088130262ca2a3a2a2`.
- Pilot Frontend Build `34687938846`: PASS.
- Cloudflare exact-head preview: deployment successful.
- PR remains draft/open/mergeable but **governance-blocked from merge**.
- Eight corrected Codex threads resolved; historical migration reconstruction P1 remains open.
- Accepted main/release remain unchanged.

## Authority boundaries retained

- Browser scheduler reads/actions remain rank-gated governed RPCs.
- Layer 1 identity/source authority remains unchanged.
- Layer 2 discovery/acquisition remains deterministic and Evidence-preserving.
- No URL/profile/route/zero-result marker was manufactured.
- `layer3_required` remains an L2 disposition only; generic scheduler Layer 3 remains prohibited.
- Search/Publication remains separately governed.
- No applied migration was rewritten or retimestamped.

## Exact next gates

1. Obtain fresh Codex review on the corrected exact head, specifically including the still-open reconstruction P1.
2. Establish a governed repository reconstruction/baseline remedy that does not rewrite/retimestamp `20260912005948` or mutate migration history ad hoc.
3. Through the normal authenticated scheduler surface, run a bounded rediscovery acceptance for the reopened 54 UQ and 27 RMIT Courses; do not recreate whole-university work unnecessarily.
4. Recompute deterministic handoff only for newly selected/changed actionable work; preserve prior Evidence and idempotency.
5. Reconfirm no generic Layer 3/Search/Publication side effects.
6. Only after CF-093 is clean may the bounded authenticated Layer 3 acceptance resume.
7. Merge/release remains prohibited until all P1s, exact-head CI/UAT/runtime, and Codex acceptance are clean.

## Next AU qualification wave

Monash → Melbourne → ANU → UTS → UWA → Sydney → UNSW remains deferred until CF-093 closes. Cohort membership is not authority to manufacture configuration.
