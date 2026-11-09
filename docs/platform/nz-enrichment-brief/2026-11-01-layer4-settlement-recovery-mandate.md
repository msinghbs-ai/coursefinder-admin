# StudySearch — Layer 4 Settlement Recovery and Continuous Execution: Platform Admin mandate (verbatim)

**Received:** 1 Nov 2026, 11:28 AEDT. Saved verbatim before implementation (operating model).

---

# StudySearch — Layer 4 Settlement Recovery and Continuous Execution

## Primary objective

Restore reliable Layer 4 review operation after the documented database timeout safety stop, then complete as much eligible stored-evidence settlement as possible across all 17 kinds.

**Mandatory incident reference:**
https://github.com/msinghbs-ai/coursefinder-admin/blob/main/docs/platform/nz-enrichment-brief/2026-11-01-layer4-all-kinds-settlement-timeout-stop.md

Read this document completely before proceeding.

Also read the canonical Admin operating model, `cf-layer4-kbe` controller, v5 action playbook and these related records:

- `2026-11-01-chatgpt-work-layer4-settlement-L4B-1020.md`
- `2026-11-01-course-link-118-review-register.md`

Repository: `msinghbs-ai/coursefinder-admin`.

## 1. Recover from the safety stop

The prior batch `L4B-20261101-1051` stopped because:

- Niagara College Canada's central-page approval data failed to load.
- Stored evidence lookup timed out twice, references VK2DWH and ZKEMAX.
- The source was `https://www.niagaracollege.ca/dualcredit/dates`.
- The visible calendar entry was not sufficient to establish provider-wide scope.
- No decision was submitted.

Do not assume the issue has been fixed.

Before resuming writes, obtain evidence that the timeout has been remediated or that the affected route has been reliably restored.

Verify that the authenticated UI can load the central approval data and newest stored evidence correctly.

The earlier ANU rank/qualification-score interpretation issue also remains unresolved. Do not approve affected AER reads based on misleading proposed interpretations.

If reliability cannot be established, preserve the safety stop, document the blocker and identify the exact engineering remediation needed. Do not bypass it through SQL, unverified evidence or repeated retries.

## 2. Resume settlement after compatibility clearance

Once the relevant UI and evidence paths have been verified reliable:

1. Authenticate as Platform Admin.
2. Reconcile the live queue and its kind counts.
3. Establish a new batch identifier.
4. Reconcile previous saved decisions using stable references.
5. Do not resubmit previously completed or uncertain decisions.
6. Select By kind and work oldest eligible items first.
7. Follow the exact v5 action playbook.
8. Submit one decision at a time and verify its saved result.
9. Complete linked destination corrections before counting an admission.
10. Continue automatically between items and kinds.

Existing authorisation covers evidence-supported UI decisions. It does not cover bulk approvals, paid acquisition, AI re-checks, provider mergers or overriding policy and identity conflicts.

## 3. Mandatory start-to-finish dashboard

At the beginning of the session and each substantial checkpoint, display:

**StudySearch Layer 4 Settlement — [date/time]**

- Opening pending: current live count.
- Reviewed: X
- Decisions saved and verified: X
- Reconciled without admission: X
- Actual destination admissions: X
- Downstream awaiting completion: X
- Deferred: X
- Remaining pending: X
- New or re-raised: X
- Eligible work remaining: X, or unknown if not yet classified.
- Kinds completed: X/17.
- Current kind and next kind.
- Active blocker, if any.

Show a progress bar based on verified settlement of the opening cohort. Reconcile newly raised and re-raised items separately, so queue growth does not distort progress.

Never calculate completion merely from items reviewed, navigation or submitted but unverified actions.

Checkpoint every 10 saved decisions, every 20 reviews without a decision and at each kind transition.

## 4. Execution efficiency

Avoid repeated broad scans and unnecessary revisits.

Use stable refs, stored evidence, existing UI controls and the canonical action rules.

For each materially different decision route, verify one successful saved outcome before repeating it.

Skip unchanged blockers after recording their cause, owner and next action. Do not repeatedly inspect the same item without new evidence.

Complete one full pass, refresh once, and reconcile newly eligible work once.

Do not force the queue to zero.

## 5. Parallel engineering boundary

Claude may continue unrelated StudySearch engineering.

If Claude changes the Layer 4 decision path, evidence retrieval, admission logic or relevant database functions, verify deployment compatibility before resuming browser writes.

Do not independently alter schema, migrations, APIs or operating settings through this review session.

Record the exact release/version used for every batch.

## 6. Preserve previous progress

The timeout-stop record reports:

- Previous successful batch: 4 saved decisions.
- 22 destination rows independently verified Active.
- 13 approved rows awaiting destination verification.
- Stopped batch: 0 decisions submitted.
- Last refreshed queue: 1,870 pending.

Reconcile these against current records. Do not carry them forward as newly completed work.

## 7. Continuous operation

Proceed with authorised settlement without asking for routine confirmation.

If a genuine safety stop occurs, preserve the checkpoint, record the exact cause, and do not retry unreliable writes.

If a failure affects only a demonstrably isolated route, follow the canonical controller's batch-wide stop rules before considering other routes. Do not silently override those rules.

Do not promise unattended execution after this Work session ends.

## 8. Final reporting and Admin records

Maintain a dated batch response and exception register in the Admin repository.

Report:

- Live counts before and after.
- Decisions saved and verified.
- Actual rows/fields admitted.
- Reconciliations without admission.
- Deferred and downstream work.
- Outstanding items by kind and cause.
- Engineering blockers and owners.
- Exact release, commit and batch references.

**Begin with the timeout-stop compatibility assessment. Do not resume production review writes until the documented reliability boundary is cleared. Once cleared, proceed continuously through all eligible kinds without another general GO.**