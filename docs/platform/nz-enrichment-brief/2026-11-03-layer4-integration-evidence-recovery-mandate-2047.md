# StudySearch — Layer 4 Integration, Evidence Recovery and Parallel Review

Continue as the **active StudySearch Integration Controller**. This is an execution handover, not a new development programme.

**Primary mandate — read and follow completely:**
https://raw.githubusercontent.com/msinghbs-ai/coursefinder-admin/main/docs/platform/nz-enrichment-brief/2026-11-03-layer4-integrator-handover-prompt.md

Read its supporting records, decision CSV, execution register, action playbook v6 and canonical operating model. Their existing rules remain authoritative.

## 1. Reconcile and continue

Reconcile live production, current Pilot main, integration issues and active parallel workstreams before making changes.

The handover references v2.15.439. Verify the actual deployed version rather than assuming it remains current.

Record this mandate against the existing execution register before code. Do not duplicate issues or restart completed work.

Keep one Integration Controller responsible for integration, merges, deployments and production verification.

## 2. P0/P1 — Fee integrity first

Investigate and correct the fee-reader unit/credit-point defect, particularly Murdoch 096011C and the 15 affected rows, including the six UNSW candidates.

Ensure AI-generated fees respect existing fee holds, exclusions, course identity, audience and year-specific evidence.

Independently verify whether incorrect values reach Website API v2 or Zoho. If consumer-visible incorrect financial data is confirmed, treat it as P0 and follow existing containment and correction governance.

Check downstream scholarship savings derived from affected fees.

Preserve manual values and use authorised, auditable remediation. Verify corrected production data and consumer read-back.

## 3. Course Link — Coordinate with ChatGPT browser review

A separate ChatGPT browser session is already reviewing and admitting Course Link items **university by university**.

Treat it as an active parallel reviewer.

Maintain a single ownership register for review refs:

- Claude-owned items.
- ChatGPT-owned items.
- Engineering-only items.
- Already decided or superseded items.

Before every Layer 4 decision or rule execution, reload current state and confirm that the item remains pending and has not been claimed or changed elsewhere.

Do not submit a competing decision for a ChatGPT-owned item.

Engineering can continue during browser settlement unless a deployment changes review controls, evidence interpretation, admission functions or manual-lock behaviour. Pause affected review writes until compatibility is validated.

## 4. Approved university-level Course Link rules

Execute the recorded Platform Admin decisions through the approved logged-rule mechanism:

- Adelaide University — 207 candidate items: retain the verified held page.
- University of Canberra — 100 candidate items: use the verified no-year page.
- Simon Fraser University — 59 candidate items: use the verified no-term page.

Validate every item in each group for exact course identity, source evidence, audience, current binding and manual-lock restrictions.

A failed item remains pending with its reason.

Group-rule execution is not blanket approval. Preserve per-item decisions, audit history and verification.

Do not act on the remaining Simon Fraser items merely because the first 59 pass.

## 5. Course page needed and evidence visibility

Implement the approved Decision 179 workflow.

For a refused proposed page with no held page:

- Preserve the rejection and history.
- Stop generating redundant individual Layer 4 review items.
- Route the course to the existing or approved "Course page needed" workflow, grouped by university.
- Provide the supported actions: add verified page, search again, or record evidence-backed absence.

Retain Layer 4 review where an existing held page is genuinely disputed.

Link existing stored page evidence to Course Link and fee review items, avoiding new paid reads where evidence already exists.

Correct misleading reason wording, including CRICOS references on non-Australian providers.

## 6. Scholarships and source ownership

Perform the approved VU 1323 and Bond 1230 reads through the normal scholarship acquisition path.

Bond requires a fresh source read, not silent reuse of its historical copy. Verify whether the scholarship round remains applicable.

Resolve Macquarie duplicate ref 1184 through a supported reviewed outcome.

Investigate provider ownership conflicts, staging URLs and shared course bindings through governed housekeeping.

Do not reassign scholarships or change active course ownership without evidence and the applicable approval.

## 7. Continuous validation and development feedback

Maintain existing V1–V4 validation and the integration feedback loop.

After each release or governed rule batch, record:

- Issue and review reference IDs.
- Previous and new production state.
- Source and stored evidence.
- Expected versus actual outcome.
- Submitted, saved and admitted counts.
- Items excluded or left pending.
- New arrivals and net queue change.
- Consumer publication result.
- Errors, regressions and next remediation.
- Release, PR and verification evidence.
- Firecrawl/AI credits actually consumed.

Do not count a queued read, completed deployment or reduced queue as an admitted value.

Return failed verification to the existing integration queue.

## 8. Durable reporting

Maintain the canonical execution register:

https://github.com/msinghbs-ai/coursefinder-admin/blob/main/docs/platform/STUDYSEARCH-EXECUTION-REGISTER.md

Maintain the university decision ledger:

https://github.com/msinghbs-ai/coursefinder-admin/blob/main/docs/platform/nz-enrichment-brief/2026-11-03-layer4-university-review.csv

Treat the CSV as append-only audit history. Never overwrite existing decision events. Use stable batch IDs, item refs and decision IDs for reconciliation and duplicate prevention.

Provide concise milestone checkpoints in the Admin repository so ChatGPT Independent Validation can cross-check Claude's work against production.

## 9. Completion criteria

Continue authorised parallel development, admission support and remediation until:

1. Incorrect fees are contained and corrected.
2. Fee holds cannot be bypassed.
3. Existing stored evidence is visible to reviewers.
4. Approved Course Link rules have item-level verified outcomes.
5. The Course page needed workflow prevents recurring unnecessary reviews.
6. Approved scholarship reads have verified outcomes.
7. Provider ownership and duplicate cases are reconciled or validly blocked.
8. The browser review session and Claude have not created conflicting decisions.
9. All results are recorded in the decision CSV and execution register.
10. Production verification and consumer consistency checks pass.

Preserve the existing programme and workstream priorities. Do not stop unrelated development or request repeated general approval.

**Execute the approved mandate, coordinate parallel review safely, maintain continuous feedback and report actual production outcomes rather than implementation activity.**