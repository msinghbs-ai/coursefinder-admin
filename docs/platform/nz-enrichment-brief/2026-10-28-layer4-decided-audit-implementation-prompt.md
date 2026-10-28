# Claude implementation prompt — Layer 4 Decided audit view

Date: 28 October 2026

Implement the following CourseFinder Platform Admin change. Treat this as a separate mandate from the AER implementation currently in progress.

## 0. Non-interference gate — satisfy this before any work

AER implementation is active in the execution repository. Do **not** edit files, create migrations, commit, rebase, merge, deploy or run live-acting tests for this mandate while that work is active.

Start only after the AER work is complete or explicitly handed over and the execution working tree is clean. If it is still active, stop and report this mandate as queued. Do not stash, reset, amend, cherry-pick or otherwise rearrange AER work. Do not combine the two changes in a branch, PR, migration or deployment.

Execution repository: `msinghbs-ai/Coursefinder-Pilot`. Decisions and audit records: `msinghbs-ai/coursefinder-admin`.

## 1. Read the governing sources first

Read and follow:

1. `coursefinder-admin/docs/platform/AGENT-OPERATING-MODEL.md`.
2. `coursefinder-admin/docs/platform/nz-enrichment-brief/INDEX.md`.
3. `coursefinder-admin/docs/platform/nz-enrichment-brief/2026-10-28-layer4-decision-audit.md` — the requirements baseline and validated decision-audit query.
4. `coursefinder-admin/docs/platform/LAYER4-INBOX-DESIGN.md` — Decided is the existing history/audit view.
5. `Coursefinder-Pilot/CLAUDE.md` — all CF-247 rules.
6. `coursefinder-admin/docs/platform/PIPELINE-LINEAGE.md`, sections 5–6, before naming or using logging/audit objects.
7. The current `src/Layer4Inbox.jsx`, the implementation and migration history of `public.admin_layer4_inbox`, `src/EvidenceWorkspace.jsx`, `src/nav-map.*`, and the existing Layer 4/Evidence UAT specs.

Before any Pilot code change, write the required admin decision/thread entry for this mandate. Record the approved scope, non-goals and root-cause-unknown starting point. Decision before code; do not backfill the decision after implementation.

Cite real objects only. Verify every table, function, column and route against current code, lineage sections 5–6 or the live database. Do not invent an audit table, status or outcome field.

## 2. Mandate

Repair and enhance the existing **Layer 4 → Decided** view so an authorised Platform Admin user can audit what Layer 4 and the KBE skill decided, then distinguish queue clearance from actual canonical outcomes.

Use the existing authenticated admin path:

- UI: `src/Layer4Inbox.jsx` and its existing `Decided` component.
- RPC: `public.admin_layer4_inbox` with action `decided`.
- Decision ledger: `pipeline.layer4_decisions`.
- Original item and current review state: `pipeline.layer4_review_items`.
- Supporting source artifact: `pipeline.evidence_artifacts`, opened through the existing Evidence screen by `evidence_id`.

Do not create another panel, replace Decided with a new workspace, add a Layer 4 filter to Evidence, or query pipeline tables directly from the browser. Extend the existing admin-only RPC additively if its current response is insufficient.

## 3. Diagnose before editing

Reproduce the current Decided failure through the authenticated Platform Admin UI. Capture:

- the exact visible/RPC error;
- the request action and arguments;
- the failing SQL/function path and the smallest root-cause explanation;
- whether the failure is in data shaping, permissions, SQL, frontend rendering, or a combination.

Use read-only diagnosis. Do not mutate a decision, review item, canonical course/provider value or evidence artifact to make the view work. Fix the demonstrated root cause rather than hiding the error, bypassing the RPC or substituting pending-count deltas.

Record the root cause and evidence in the mandate file.

## 4. Required Decided behaviour

### Filters and result identity

Provide useful filters for:

- batch;
- decision date from/to;
- provider;
- category/kind.

Batch filtering must recognise a reason beginning with the skill prefix `L4B-YYYYMMDD-HHMM`; an empty batch filter must not exclude ordinary manual or automatic Layer 4 decisions. Do not treat every Layer 4 decision as skill-generated. Keep the full reason available for audit.

Return and use stable identifiers, including `decision_id` and `review_item_id`; do not key rows by array position. Preserve existing response fields needed by current callers and add fields rather than renaming established ones. Provide truthful total/pagination behaviour instead of silently presenting the first 100 rows as complete history.

Include clear loading, error, empty and reset-filter states. Keep the existing Platform Admin visual language and make the view usable at desktop and real phone widths.

### Decision facts

For each result, expose enough detail to audit:

- decision id, review-item id and decision timestamp;
- actor;
- provider and subject/entity identifiers, including course code where applicable;
- category/kind and action/choice;
- decided/final value;
- full reason and parsed skill batch id where present;
- evidence id, including an explicit empty state when null;
- the review item's **current** review state.

### Decision is not outcome

Keep these concepts visibly separate:

1. **Decided** — proved by the decision-ledger row.
2. **No longer waiting** — proved by the original review item's current state; this does not prove admission.
3. **Currently admitted/applied** — proved only by the relevant canonical row matching the intended decision.
4. **Re-raised** — a newer pending item for the same entity and field after the decision; treat this as new work or a defect, not as erasure of the original decision.

Do not introduce new stored status values. UI labels must be derived from real returned facts. Never infer “applied”, “read”, “published”, “archived” or “rebuilt” merely because a decision exists or an item left the queue. A rejected fee proposal is a completed decision with no admission expected, not a failed apply.

Use the canonical outcome sources already identified in the audit guide, including:

- course link: `catalogue.courses.course_url`, `catalogue.course_links`, and `pipeline.coverage_course_pages` binding/read state;
- fee: current `catalogue.course_fees`;
- scholarship: current `scholarship.scholarships` state and relevant audience/value fields;
- archive: current `catalogue.courses.lifecycle_status`;
- conjoint/no-page: the actual rule/no-page outcome and any newer pending item, not merely `parent_url` in the decision;
- adapter rebuild: existing task/build state, distinguishing queued from completed.

Where a safe automatic outcome check is not available for a kind, say that it is not automatically verified and provide the available canonical follow-path. Do not manufacture a generic success state.

### Follow-paths

From a decision row, provide working links to:

- the current canonical entity/outcome through an existing Platform Admin route;
- the supporting Evidence artifact by `evidence_id`, when present.

Use the existing navigation map and Evidence evidence-ID search/deep-link mechanism. If Evidence lacks a usable evidence-ID deep link, add only the smallest additive deep-link support needed. Do **not** change Evidence into a decision ledger or add Layer 4 source/layer filters.

## 5. Explicit non-goals and safety boundaries

This is an audit/read-path change only. Do not:

- change Layer 4 decision semantics or write paths;
- alter `security.layer4_review_decide_impl` or `security.layer4_course_link_apply_impl` to fix the separately recorded course-link apply-path issue;
- retire old links, request fresh page reads, rebuild adapters or clean up Federation data;
- repair or report the Sydney conjoint decision as applied without its own canonical proof;
- approve, reject, reverse, delete, re-raise or bulk-clear any review item;
- backfill or rewrite decision reasons to manufacture batch ids;
- create a replacement ledger, audit table, panel, SOP or status enum;
- weaken authentication, authorisation or existing role checks;
- touch the frozen consumer API, Website API v2, Zoho API shapes or their underlying contract;
- overwrite manual bindings or platform settings;
- make destructive schema/data changes.

If the root cause genuinely requires a consumer-visible or destructive change, stop and prepare the required approval/paste-file gate instead of applying it.

Keep migrations additive and include CF-247 housekeeping lines. Do not create a new background job for this view. Follow settings-not-hardcoded rules for any new operational tunable; do not add settings merely to make the audit feature configurable.

## 6. Governed tests and acceptance coverage

Add the smallest effective regression coverage for the demonstrated root cause and the new audit contract. Every new/changed spec must have a meaningful `// Guards:` line naming this Layer 4 Decided decision-first audit mandate or the existing rule it guards. Regenerate `docs/platform/TEST-REGISTER.md` with `node scripts/test-register.mjs` when required. Do not duplicate central CF-247 guards.

Cover, using controlled read-only fixtures/test data rather than live mutation:

- the original Decided failure cannot recur;
- all decisions appear when no batch filter is set;
- exact skill batch isolation and rejection of lookalike/non-prefix batch text;
- date, provider and category filters, reset and pagination;
- stable decision/review-item ids and null-evidence handling;
- decision versus cleared versus canonically applied outcomes;
- a rejected fee decision is not shown as an admitted fee;
- a newer pending item is shown as re-raised without rewriting history;
- course-link outcome/read state is not inferred from the decision timestamp;
- working canonical and Evidence follow-paths;
- authorised access and unchanged consumer API contract;
- desktop and real phone behaviour for Layer 4 Review under the existing `s121` responsive governance.

Run the complete required suite. Nothing red or skipped may be carried. Phone runs remain limited to the governed `@responsive`/deployed paths. Do not enable live-acting tests for this read-only mandate.

Acceptance examples from the current ledger:

- `L4B-20261028-1752`: three Federation University Australia official-course-link decisions, each traceable to its decision id, current review state, canonical course outcome and evidence id.
- `L4B-20261028-1441`: two Sydney decisions; the fee rejection must show no admission expected, and the conjoint decision must not be labelled applied without canonical proof.
- Decisions without an `L4B-` reason remain auditable through the non-batch filters.

These examples verify presentation and drill-down only; do not change their underlying data.

## 7. Change control, deployment and live verification

Complete the admin change-control entry before merge. Follow the operating model for PR, full-suite, live-function md5 and dry-run gates where applicable. Do not merge or deploy while AER is still active or its release state is unresolved.

After the governed release, verify read-only against the authenticated live Platform Admin UI:

1. Decided opens without the original error and reports complete/paginated results truthfully.
2. Each filter and reset works, including both known skill batches and non-skill decisions.
3. Federation rows show decision facts separately from current link/binding/read outcomes; any old-link or stale-read discrepancy remains visible rather than being cosmetically “fixed”.
4. Sydney fee rejection and conjoint rows have truthful outcome labels.
5. Evidence links open the correct artifact by id; null evidence is handled clearly.
6. Canonical links open the intended current entity.
7. Desktop and phone layouts remain operable.
8. No queue, decision, canonical or evidence data changed during verification, and no consumer API drift occurred.
9. Confirm the expected release/current version strings as required by the operating model.

Update the mandate record with root cause, decision entry, PR/migration identifiers, test-register impact, full-suite result, deployment/version evidence, live verification and any remaining limitations. Lodge the full implementation response in the admin repository before the chat summary.

## 8. Required handback

Report concisely:

- the proven root cause;
- the admin decision record and Pilot files changed;
- RPC/UI compatibility and security posture;
- filters, outcome distinctions and follow-paths delivered;
- tests added/retired and full-suite result;
- PR/release and live verification evidence;
- anything deliberately left unfixed, especially the separate course-link apply-path issue and any canonical outcome that remains unverified.
