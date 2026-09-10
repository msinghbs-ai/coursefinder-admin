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
Current functional candidate head: `7c0a7be5d322c7539ade5bd07d5c18bc3161250e`  
Package candidate: `0.1.4`; visible Admin release remains v2.15.76 until release-currentness acceptance is complete.

Material implementation includes:
- `src/ScheduledJobsWorkspace.jsx` — search, business-readable task/source labels, Created By/Owner presentation, personal column visibility/order, technical-ID secondary display, request-generation sequencing, policy-search isolation from unrelated panels, post-edit page reset/clamp, and load-owned busy/error state;
- `src/scheduled-jobs-config.css` — operator toolbar, column chooser and sticky Actions treatment;
- `supabase/migrations/20260911052000_cf_093_scheduler_operator_attribution.sql` — creator/action snapshots and enriched rank-gated schedule read projection;
- `supabase/migrations/20260911053600_cf_093_codex_review_fixes.sql` — query-before-pagination search and deleted/banned account-state correction; this applied migration remains immutable;
- `supabase/migrations/20260910213556_cf_093_resolved_actor_search_semantics.sql` — repository reconciliation of the already-applied Pilot runtime correction that searches the resolved creator/owner display semantics;
- `tests/uat/cf-093-scheduled-workflow-operator-contract.spec.mjs` — additive source/security/operator UX contract including Codex regression checks.

Pilot runtime migration truth includes `20260910194125 cf_093_scheduler_operator_attribution`, `20260910194149 cf_093_codex_review_fixes`, and `20260910213556 cf_093_resolved_actor_search_semantics`. The current deployed bridge definition matches the resolved actor-search behaviour. No duplicate later reconciliation migration remains in the candidate branch.

## Codex review reconciliation — 11 September 2026

Initial review findings corrected:

1. **Search before pagination** — moved task search into the rank-gated scheduler list RPC so filtering occurs before `LIMIT/OFFSET`; filtered totals drive pagination.
2. **Refresh queue distinguishability** — UI falls back to the exact technical bounded target when the queue read does not carry source/profile labels.
3. **Deleted/disabled user state** — creator/owner state treats soft-deleted or currently banned users as former.
4. **Stale scheduler search responses** — policy loads carry a monotonic request generation; stale responses cannot update policy/search data or busy/error state.

Second Codex re-review findings on `e2f4e85fa33719882183366e6c6f8de9ee582eef` are also corrected:

5. **Post-submit busy race** — successful mutation no longer has an outer unconditional `setBusy(false)`; the sequenced policy load owns busy state, so a superseded post-submit load cannot re-enable actions while a newer search is still in flight.
6. **Resolved owner/creator search** — query predicates use the same snapshot/live/former-user resolved display semantics projected to the UI, so searching a visible active owner/creator name returns the policy.
7. **Post-edit pagination validity** — post-mutation refresh resets to page 0; list loading also clamps/refetches if an offset is beyond the returned filtered total.
8. **Policy-search isolation** — debounced/paged policy search executes only the scheduler list RPC. Overview, role context and recent Jobs are refreshed independently so unrelated panel failures cannot leave previous policy results actionable under a newer search string.

The public scheduler list wrapper remains `SECURITY INVOKER`, the private bridge independently rank-gates curator access, and stored email snapshots are not projected to the browser. Pilot runtime currently has 13 bounded Layer 1–3 policies; all are legacy/system-created at this point (`created_by`/owner null), so the UI correctly renders system/legacy attribution rather than inventing a human creator.

Candidate CI on `7c0a7be5...`: Pilot Frontend Build `34534171514` PASS; Release History Contract `34534171521` PASS. Final Codex re-review on the exact candidate is pending before merge/deploy.

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
