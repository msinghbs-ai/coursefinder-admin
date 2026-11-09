# `cf-layer4-triage` v4 versus the Layer 4 filter pills

Date: 30 October 2026  
Scope: explain what the current triage Skill does that the Layer 4 Review filter pills do not, and which UI categories the Skill can or cannot process. Read-only comparison; no queue or canonical changes.

## Short answer

The **filter pills navigate the queue**; the **Skill operates a controlled decision workflow through the existing UI**.

Clicking **Course link**, **Held scholarship**, **Fee fails the check** or another pill only filters the waiting items. It does not choose an outcome, submit a decision, verify a save or produce an audit checkpoint. The Skill adds those operating steps, but it does not turn the pills into one-click bulk-clear buttons and it does not automate every category.

## What v4 solves operationally

| Operating need | Filter pills / ordinary UI | Current `cf-layer4-triage` Skill |
|---|---|---|
| Find work | Filters by kind; By university and By kind views navigate items | Uses those views for scoped work, oldest first |
| Choose an outcome | A person reads the evidence and chooses an existing action | Applies the category action playbook and item-level stored evidence to the same existing choices |
| Submit work | A person enters the reason and confirms each action | Submits real UI decisions rather than stopping at snapshots or proposed actions |
| Prove progress | The person refreshes and inspects the queue | Verifies that each decided item leaves **Waiting for a person** and reconciles counts |
| Avoid false success | A snapshot or count can be mistaken for a decision | Requires stable UI item/ref ids, actual submitted decisions and verified outcomes |
| Audit and resume | The ordinary filter view does not provide a portable batch checkpoint | Records batch id, item refs, outcomes, exceptions and checkpoints; supports safe resume without repeating decided refs |
| Handle failures | A person decides when to retry or stop | Verifies uncertain writes before retrying, stops repeated shared failures and avoids keep/rebuild loops |
| Protect canonical data | UI role checks and existing action rules apply | Adds no SQL/direct-write path, no select-all approval, no deletion and no evidence-free admission; existing role limits still apply |
| Control scope and cost | Manual work is whatever the operator opens | Supports bounded qualification, one-provider and resumable provider batches; stored evidence only by default, with no AI re-check or Firecrawl unless explicitly authorised |

The previous fee qualification illustrates the difference: the pill showed five fee items; the Skill submitted and verified five real `keep` decisions. The pill itself did none of that work.

## Commands are not equivalent to clicking pills

- **`layer4-by-kind-qualify`** is not “drain the selected pill”. It reviews at most 10 oldest eligible items and submits at most five decisions in one suitable kind. Its purpose is to prove that kind's write path.
- **`layer4-clear-all <provider>`** processes one exact provider sequentially. It is not the same as clicking **All**, and it must not merge sibling provider records.
- **`layer4-clear-all`** is a resumable provider-by-provider workflow only after the environment has a verified decision write path. It is not select-all approval and does not promise a zero queue.
- **`layer4-clear-all resume <batch-id>`** resumes from checkpoints and stable item refs; the pills have no equivalent resume function.

A fee-check qualification does not qualify every route. When work enters another kind, its first decision must be verified before continuing.

## Pill-by-pill coverage

“Playbook-covered” means the Skill has an evidence rule for using the existing UI action. It does not mean every item is decidable, automatically approved or suitable for initial qualification.

| Layer 4 pill | What the current Skill does |
|---|---|
| **All** | Not a decision category. The Skill instead scopes work by provider or runs the bounded qualification; it never treats All as bulk approval. |
| **Course link** | Playbook-covered for exact course/page identity: keep the held page, use a proven replacement or enter a verified official address. Official page replacement is excluded from initial qualification; conflicts stay pending. |
| **Held scholarship** | Playbook-covered. Conservative **Not for international students** or **Not a scholarship** outcomes can be used for qualification when evidence supports them. **Publish** requires scholarship, value/benefit, provider and international-eligibility proof plus duplicate checks. Verify this route's first decision separately. |
| **Fee fails the check** | Playbook-covered and proven by batch `L4B-20261030-0938`. It can keep the registered total and release the hold without admitting the page fee; page-fee admission still requires all existing identity, amount, currency and year gates. |
| **Website needed** | Conditionally playbook-covered: use an existing website/source action only when an adequate official source is known and authorised; otherwise record the source gap and leave it pending. Not an initial qualification route. |
| **Course pages not found** | Conditionally playbook-covered with the same source requirement. Existing source/rebuild actions are not a substitute for evidence and must not be looped. |
| **Too few course pages** | Conditionally playbook-covered with the same source requirement; inadequate sources remain pending. |
| **Adapter has nothing ready** | Conditionally playbook-covered: queue an existing rebuild at most once when supported. A queued rebuild is not a completed admission; repeated failure remains for platform review. Excluded from initial qualification. |
| **Adapter proposal failed** | Same conditional rebuild/try-again discipline; no repeated autonomous repair. Excluded from initial qualification. |
| **Central pages to approve** | Playbook-covered only for a current official provider source with compatible scope/level and a quote. The existing builder/approval route and role limits still apply. Excluded from initial qualification. |
| **Course not offered** | Playbook-covered for evidence-based keep/archive decisions. Archive requires current official evidence and the existing archive rule; reader failure or a 404 alone is insufficient. Excluded from initial qualification. |
| **Course not on the university's site** | Same evidence-based keep/archive discipline; register-versus-provider conflicts and possible replacements stay pending. Excluded from initial qualification. |
| **No page published: first run** | Playbook-covered only for verified legitimately page-less cases under the existing rule. Discovery/reader failure is not proof of no page. Excluded from initial qualification. |
| **Conjoint or double degrees: first run** | Playbook-covered only where official evidence explicitly supports the shared-page/page-less identity. Similar titles are insufficient. Excluded from initial qualification. |
| **Provider left the register** | Limited playbook coverage. Current authoritative register evidence is required; ownership, merger, successor and conflicting-register cases remain human decisions. Excluded from initial qualification. |
| **Entry requirements (AER)** | **Not automated by the current Skill playbook.** The UI defines this as Platform Admin, one item at a time, never bulk. `v2.15.374` changes AER decision semantics; it does not make the Skill an AER-clearing workflow. |
| **Website not answering** | **No category-specific Skill playbook rule.** Leave for the existing manual UI process rather than inventing an automated outcome. |
| **Counsellor report** | **No category-specific Skill playbook rule.** Leave for the existing manual UI process, including any course correction and report closure. |
| **Any future/unlisted kind** | Leave pending with an owner and reason. The Skill must not infer a new action merely because a new pill appears. |

## What v4 does not solve

- It does not remove the need for item-level evidence or human judgement.
- It does not guarantee that every pill reaches zero; unresolved, conflicting and unauthorised items should remain waiting.
- It does not bypass rank/role restrictions, existing admission gates or consumer-visible change controls.
- It does not make AER, Website not answering or Counsellor report supported automation categories.
- It does not repair a failing reader, apply path or queue display by itself.
- It does not treat a queue-count decrease alone as proof of its own decisions; stable refs and verified outcomes are required.

## Practical interpretation

Use the pills to inspect a category. Use the Skill to execute an authorised, bounded and auditable workflow through that UI. Start with the bounded By kind qualification on an untested setup, then use provider-scoped batches; verify the first decision for each new action route. Do not expect v4 to clear every visible pill in one run.

## Sources

- Admin `docs/platform/skills/cf-layer4-triage/SKILL.md`: invocation, per-kind qualification, provider batches, resume and hard boundaries.
- Admin `docs/platform/skills/cf-layer4-triage/references/action-playbook.md`: category evidence rules and stop conditions.
- Pilot `src/Layer4Inbox.jsx`: filter-pill behaviour and one-item-at-a-time AER UI.
- Live read-only `security.layer4_inbox_kinds_v1()`: current pill labels, choices, role limits and action consequences, checked 30 October 2026.
- Admin `docs/platform/nz-enrichment-brief/2026-10-30-layer4-batch-0938-verification.md`: independently verified fee-check qualification and its limited scope.
