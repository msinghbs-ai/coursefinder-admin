# Layer 4 Review skill — run and workstation export

Date: 28 October 2026; updated 30 October 2026  
Scope: operating instructions for the KBE/Kimi Work skill saved as `Layer-4-Review`; no Layer 4 decisions or catalogue writes performed.

## Canonical GitHub source

The reusable Skill source lives in the admin repository:

- `docs/platform/skills/cf-layer4-triage/SKILL.md`
- `docs/platform/skills/cf-layer4-triage/references/action-playbook.md`

`Layer-4-Review` is the display label; `cf-layer4-triage` remains the canonical Skill name. Update these GitHub source files rather than maintaining workstation-only variants.

## Qualify a new workstation by kind first

On a new workstation, an untested browser connection, or after any zero-decision/uncertain batch, invoke the Skill with:

```text
layer4-by-kind-qualify
```

This bounded workflow must:

1. Select one suitable existing kind in **Layer 4 Review → By kind**, preferring a conservative fee-keep or held-scholarship rejection supported by stored evidence.
2. Avoid official course-page replacement, archive, provider ownership/departure, conjoint/no-page, central-page and adapter decisions during qualification.
3. Review no more than 10 oldest items and submit no more than five decisions in that one kind.
4. Submit and verify the first real UI decision before continuing. Snapshots, planning and proposed actions do not qualify the write path.
5. Stop immediately for an uncertain first result, remaining queue item or UI/network failure; verify the original outcome before any retry.
6. Only after the first verified decision, complete up to four additional individually evidenced and verified decisions in the same kind.

Qualification proves UI submission and the selected kind's action route, not every Layer 4 route. When later work enters a different kind, verify its first decision before continuing. Record the stable UI item/ref id: a review-item UUID where applicable, otherwise the numeric or other kind-specific ref.

Until the Decided repair is released, verify through the current queue and lightweight items views; do not open the failing **Decided** view or substitute SQL.

## Run the full queue only after qualification

After the current environment has a verified decision write path, invoke the Skill with:

```text
layer4-clear-all
```

“Clear” means review, decide and reconcile through the existing Platform Admin UI. It does not mean delete records, bulk-approve uncertain evidence or force the queue to zero. Items lacking sufficient evidence remain pending as named exceptions with an owner and next action.

Before starting, use a connected browser with an authenticated Platform Admin session on **Data pipeline → Layer 4 Review**. The skill records a batch id, baseline counts and checkpoints; processes providers sequentially; uses stable item ids and stored evidence; submits supported decisions rather than stopping at proposals; and stops on shared write, authentication or queue-integrity failures. AI re-checks, Firecrawl and new source acquisition require separate explicit authorisation.

Useful variants:

```text
layer4-clear-all Federation University Australia
layer4-clear-all resume L4B-YYYYMMDD-HHMM
```

The first restricts the run to one exact provider. The second resumes an incomplete batch without repeating decided item ids. Keep the original batch id and supply its consolidated checkpoint when resuming elsewhere. If that checkpoint is not available on the current workstation, start a new bounded qualification run instead of claiming a portable resume.

Do not repeatedly start full-queue batches after zero-decision runs. Return to `layer4-by-kind-qualify` and identify the exact write-path blocker first.

## Audit trail and outcomes

Inbox submissions are recorded in `pipeline.admin_control_events` with `area = 'layer4'` and `action = 'inbox_decide'`. Applicable routed review items can also have `pipeline.layer4_decisions` rows. Do not expect every kind in both ledgers, and do not count an Inbox event plus its routed detail as two decisions.

Queue clearance remains separate from canonical admission. For example, a fee-check keep decision releases `pipeline.enrichment_flags` while retaining registered `catalogue.course_fees`; it does not admit the proposed page fee. A release result can allow the next Enrich fields task to include the course, so later re-raised work remains possible.

## Export and use on another workstation

The validated portable package is supplied in chat as `cf-layer4-triage.skill`. It contains only:

- `cf-layer4-triage/SKILL.md`
- `cf-layer4-triage/references/action-playbook.md`

On each workstation:

1. Open Kimi Desktop **Work** mode and use **Skills** to import/upload the `.skill` package. Replace the older copy so there is no ambiguity about the active version.
2. Install and connect **Kimi Browser Extension** separately. Sign in to Platform Admin in the connected Chrome/Edge browser; the package contains no login, cookies, browser session or Platform Admin access.
3. Run `layer4-by-kind-qualify` before any full-queue command on that workstation.
4. Copy any in-flight consolidated checkpoint separately if resuming work. The Skill package contains the workflow and evidence rules, not prior batch state.

For future changes, update the canonical GitHub source and rebuild/reissue the package from that source. Do not leave later edits only in one workstation's KBE or Kimi Work installation.
