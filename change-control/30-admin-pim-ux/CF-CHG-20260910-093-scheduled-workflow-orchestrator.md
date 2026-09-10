# CF-CHG-20260910-093 — Scheduled Workflow Orchestrator

**Status:** IMPLEMENTATION / TARGETED ACCEPTANCE ACTIVE  
**Initiated:** 2026-09-10 21:44 AEST  
**Origin:** Scheduled Tasks operator UX review  
**Owner:** CourseFinder programme  
**Primary category:** 30-admin-pim-ux  
**Related categories:** 20-layer1-regulatory-ingestion, 40-layer2-enrichment, 80-uat-release-operations

## Problem

The accepted v2.15.76 Scheduled Tasks surface exposes bounded policies using raw source/profile UUID targets. Operators cannot reliably determine which dataset or business workflow a schedule represents, and on-demand execution can only replay an existing bounded policy rather than present a task-first target builder.

## Requested outcome

Add one governed task-first workflow-orchestration experience that can be reused across Layer 1 authoritative/statistical ingestion, Layer 2 deterministic enrichment, conditional Layer 3 Evidence interpretation and Layer 4 exception routing without weakening layer authority boundaries.

The operator model is:

`Job / Dataset -> Country -> Scope -> Target -> Processing mode -> Run now or Schedule`

Human-readable business labels must be primary. Technical policy/source/profile IDs remain available only under progressive-disclosure technical details.

## Initial governed workflow catalogue

- Layer 1 regulatory/reference: AU CRICOS, NZQA, QILT, PRISMS, QS, THE and future qualified ranking/reference datasets.
- Layer 2 deterministic enrichment: Course facts/URLs/fees/intakes/requirements, Scholarships, Provider Assets and supporting Evidence acquisition.
- Combined L2 -> conditional L3: Course fields requiring Evidence interpretation, Provider international contacts and other profile-qualified interpretation work.
- L2 -> conditional L3 -> L4 exceptions: ambiguous contacts, eligibility/scope or other unresolved governed interpretations.
- L1 -> conditional L4: ambiguous Provider mapping for publisher ranking/reference datasets.
- Search/Publication remain downstream consequences and are not ingestion stages.

## Authority / safety rules

1. Layer 1 identity/authority cannot be redefined by L2/L3/L4 shortcuts.
2. Layer 3 may run only against governed Evidence/profile/model/revalidation contracts.
3. Layer 4 is exception/human resolution and must preserve source/Evidence/history.
4. Scholarship Provider ownership alone must not manufacture Course eligibility.
5. On-demand execution must not silently alter recurring cadence/next-run state.
6. Browser reads/writes remain through governed RPC/control surfaces; no service-role or provider secrets are exposed.
7. Existing v2.15.76 CF-092 scheduler acceptance remains the baseline; changes extend rather than bypass its policy/audit/idempotency semantics.

## Operator experience additions — 11 September 2026

The scheduler is also an operational catalogue, therefore CF-093 includes:

- durable **Created By** attribution for schedules and durable actor display snapshots for schedule actions;
- no destructive dependency on a live user-directory row: removed users retain historical attribution as a former user while the immutable actor UUID remains available for audit;
- system/bootstrap/legacy schedules remain explicitly identified and are never assigned a fabricated person;
- optional **Owner** presentation distinct from creator attribution so future operational ownership transfer can be added without rewriting creator history;
- fast task search over dataset/source, country, target, owner/creator and technical ID;
- user-selectable columns and column ordering, with reset to governed defaults;
- personal UI layout state kept separate from scheduler execution policy;
- sticky/frozen Actions for wide operational tables;
- technical UUIDs visible as secondary support/audit information rather than primary task names.

Identity snapshots may retain internal email for audit continuity, but scheduler browser list responses expose display attribution only. Account deletion/disablement must not make historical task or action records anonymous.

## Implementation evidence

Pilot branch: `m245/scheduled-workflow-orchestrator-20260910`  
Pilot PR: `#67`  
Current functional candidate head: `029a56480d72898f083e1d7d873df7237dceab4b`  
Package candidate: `0.1.4`; visible Admin release remains v2.15.76 until release-currentness acceptance is complete.

Material implementation includes:
- `src/ScheduledJobsWorkspace.jsx` — search, business-readable task/source labels, Created By/Owner presentation, personal column visibility/order, technical-ID secondary display, request-generation sequencing, policy-search isolation from unrelated panels, post-edit page reset/clamp, per-panel unavailable state, and load-owned busy/error state;
- `src/scheduled-jobs-config.css` — operator toolbar, column chooser and sticky Actions treatment;
- `supabase/migrations/20260911052000_cf_093_scheduler_operator_attribution.sql` — creator/action snapshots and enriched rank-gated schedule read projection;
- `supabase/migrations/20260911053600_cf_093_codex_review_fixes.sql` — query-before-pagination search and deleted/banned account-state correction; this applied migration remains immutable;
- `supabase/migrations/20260910213556_cf_093_resolved_actor_search_semantics.sql` — repository reconciliation of the already-applied Pilot runtime correction that searches the resolved creator/owner display semantics;
- `supabase/migrations/20260910215546_cf_093_scheduler_entity_labels.sql` — canonical Provider/Course/Campus/Scholarship labels for entity-scoped scheduler policies;
- `supabase/migrations/20260910221808_cf_093_literal_scheduler_search.sql` — Pilot-applied literal scheduler search correction for `%`, `_` and escape characters;
- `supabase/migrations/20260911054000_cf_093_scheduler_search_finalizer.sql` — forward fresh-replay finalizer after the later CF-093 bridge definitions so clean migration replays preserve literal search, canonical entity labels and resolved actor semantics;
- `tests/uat/cf-093-scheduled-workflow-operator-contract.spec.mjs` — additive source/security/operator UX contract including current Codex regression checks and reconciled migration paths.

Pilot runtime migration truth includes `20260910194125 cf_093_scheduler_operator_attribution`, `20260910194149 cf_093_codex_review_fixes`, `20260910213556 cf_093_resolved_actor_search_semantics`, `20260910215546 cf_093_scheduler_entity_labels` and `20260910221808 cf_093_literal_scheduler_search`. The live bridge already has the final literal/entity/actor semantics. The repository-only fresh-replay finalizer intentionally preserves reproducibility without rewriting already-applied Pilot migration history.

## Codex review reconciliation — 11 September 2026

Initial review findings corrected:

1. **Search before pagination** — moved task search into the rank-gated scheduler list RPC so filtering occurs before `LIMIT/OFFSET`; filtered totals drive pagination.
2. **Refresh queue distinguishability** — UI falls back to the exact technical bounded target when the queue read does not carry source/profile labels.
3. **Deleted/disabled user state** — creator/owner state treats soft-deleted or currently banned users as former.
4. **Stale scheduler search responses** — policy loads carry a monotonic request generation; stale responses cannot update policy/search data or busy/error state.

Second Codex re-review findings are corrected:

5. **Post-submit busy race** — successful mutation no longer has an outer unconditional `setBusy(false)`; the sequenced policy load owns busy state.
6. **Resolved owner/creator search** — query predicates use the same snapshot/live/former-user resolved display semantics projected to the UI.
7. **Post-edit pagination validity** — post-mutation refresh resets to page 0; list loading also clamps/refetches if an offset is beyond the returned filtered total.
8. **Policy-search isolation** — debounced/paged policy search executes only the scheduler list RPC. Overview, role context and recent Jobs refresh independently.

Subsequent Codex review corrections are also implemented:

9. **Entity-scoped labels** — Provider, Course, Campus and Scholarship policies resolve canonical business labels and are searchable by those labels.
10. **Profile identity preservation** — when a policy carries both source and source profile, profile identity is primary and the technical target retains both profile and source IDs.
11. **Literal search** — scheduler search escapes PostgreSQL LIKE metacharacters so `%` and `_` are operator literals rather than unintended wildcards.
12. **Run-now follow-through** — successful run-on-demand refreshes the independent queue/Jobs/context panels rather than leaving stale queue state.
13. **Panel failure truthfulness** — overview/context/Jobs failures are surfaced per panel rather than being rendered as false empty data.
14. **Fresh migration replay ordering** — a forward finalizer after `20260911053600` restores the combined final bridge definition during clean repository replay without mutating Pilot-applied migration history.
15. **Post-run query race** — policy reload starts before awaiting panel refresh; a later debounced search receives a newer generation and cannot be overwritten by the old captured query.
16. **Focused UAT currentness** — the contract references the reconciled entity/literal/finalizer migration files and the current run-now sequencing.

The public scheduler list wrapper remains `SECURITY INVOKER`, the private bridge independently rank-gates curator access, and stored email snapshots are not projected to the browser. Layer 3 remains Evidence/profile/model-qualified and is not made generically runnable from Scheduled Tasks.

Exact-head CI on `029a56480d72898f083e1d7d873df7237dceab4b`: Pilot Frontend Build `34540590328` PASS; Release History Contract `34540590332` PASS. Exact-head Codex re-review was requested in PR #67 comment `5626630031` and remains the current pre-merge gate. Do not merge/deploy or promote the visible release until that review has no actionable finding and the governed release/currentness sequence is completed.

## Acceptance target

- task-first human-readable Scheduled Tasks UI;
- universal scope/target builder using only server-authorised options;
- explicit processing modes: automatic governed pipeline, acquisition only, reprocess governed Evidence where eligible;
- run preview before consequential dispatch;
- durable operator reason/audit;
- durable creator attribution including former-user fallback;
- task search and personal column visibility/order reset behaviour;
- stale/debounced search responses cannot replace newer task results or operation state;
- direct follow-through to resulting Job and Evidence;
- scheduler/history tables show business workflow labels, scope and latest result rather than raw UUIDs;
- UUIDs available under Technical details;
- negative/rank/browser security paths preserved;
- targeted contract/build/UAT then nominated deployed acceptance;
- visible release/version and CHANGELOG updated for browser-facing behaviour;
- RUNSHEET/CURRENT-STATE/FOLLOW-UPS/NEXT-CHAT reconciled before closure.

## Implementation note

Implementation must first inventory currently executable runtime source/profile/policy contracts. Do not expose a workflow option merely because a future design exists. Unsupported country/state/provider granularity must be disabled or clearly marked unavailable rather than simulated client-side.
