# CF-CHG-20260826-039 — Repository Run Sheet & Cross-Chat Continuity

**Status:** APPLIED  
**Category:** 00-governance-programme  
**Initiated:** 26 August 2026 07:07 AEST  
**Origin chat/workstream:** CourseFinder M2 continuation/governance planning  
**Owner:** CourseFinder programme governance  
**Change class:** governance / operations / documentation

## Trigger

User decision to stop using long ChatGPT conversation history as the operational handoff mechanism and instead maintain milestone/phase execution state, sequence, outcomes and follow-ups in the authoritative Admin repository.

## Problem / requested outcome

Long implementation chats approach context limits and make later continuation difficult. Existing Change Controls are durable semantic/change records but are not intended to be a chronological execution run sheet. The required outcome is a lightweight repository-backed ledger that lets any new chat reconstruct current work from GitHub without asking the user to refer back to prior conversations.

## Affected surfaces / related workstreams

- programme governance and cross-chat operating process;
- M2.3 execution/handoff;
- Change Control handoff discipline;
- CI/UAT evidence continuity;
- future milestone/phase workstreams.

## Semantic impact

No canonical data, identity, source-authority, Search/publication or downstream semantic change.

Operational effect: repository state becomes the durable execution/handoff mechanism for milestone/phase continuation; conversation history is supporting context only.

## Before

Project state was governed in repository documentation and Change Controls, but detailed execution sequence and exact next-chat handoff could still depend on lengthy conversation context or bespoke copy/paste prompts.

## After

A standard `project-runsheets/` hierarchy provides, per active phase:

- append-only execution history in `RUNSHEET.md`;
- replaceable reconciled truth in `CURRENT-STATE.md`;
- compact dependency-ordered continuation instructions in `NEXT-CHAT.md`.

Future chats are expected to reconcile these files against current source/deployed truth, execute autonomously, then update them before handoff.

## Source authority / evidence

- User instruction in the originating CourseFinder conversation, 26 August 2026 07:07 AEST.
- Existing cross-chat authority rules in `PROJECT_INSTRUCTIONS.md` and `change-control/README.md`.

## Implementation references

- `project-runsheets/README.md`
- `project-runsheets/milestone-2/m2.3/RUNSHEET.md`
- `project-runsheets/milestone-2/m2.3/CURRENT-STATE.md`
- `project-runsheets/milestone-2/m2.3/NEXT-CHAT.md`
- Git commits: `47acb5e0775cf6b3007cf966d23fbc6ac5249966`, `87a2606b31af5b6784374050ecaf84301df0fa54`, `5eb202b6ffcd64333564f53e68cdf3ab16729d31`, `51e0538ba3cbfb6e9dc56bb2fadd06c6f21c8a43`
- UI version: N/A

## UAT

Process/documentation UAT:

- M2.3 continuation requirements are captured without requiring prior chat history.
- Next-chat prompt explicitly requires fresh reconciliation of GitHub, deployed Supabase/runtime, CI/UAT and open Change Controls before acting on stale SHAs or assumptions.
- Handoff requirements explicitly require run-sheet/current-state/next-chat updates before ending future execution chats.

Result: PASS for governance mechanism establishment.

## Rollback / reversion

Delete `project-runsheets/` and revert this governance record if the programme adopts another durable execution-ledger mechanism. This does not affect deployed runtime or canonical data.

## Documentation impact

- PIM Admin Guide: none.
- Architecture: none.
- Running build: no runtime status change from this governance mechanism alone.
- Master plan: no scope change.
- UAT/design docs: supporting operating process only.
- Zoho contract: none.

## Decision / status history

| Timestamp | Status | Decision / event | Reference |
|---|---|---|---|
| 2026-08-26 07:07 AEST | PROPOSED | User requested repository-backed milestone/phase run sheet and copy/paste continuation model | Origin chat |
| 2026-08-26 07:07 AEST | APPLIED | Run-sheet governance structure and initial M2.3 files created | Git commits listed above |

## Closure

**Final status:** APPLIED — REGISTER UPDATE PENDING  
**Closed at:** N/A  
**Outcome:** Repository-backed execution ledger is active for M2.3; register/index reference remains to be added during the next governance reconciliation if not added in this session.

## 6 November 2026 extension — AI controller continuity (Admin #382)

**Initiated:** 2026-11-06T09:03:00Z (execution identifier); decision record published 2026-11-06T09:10:24Z.
**Origin/owner:** Codex execution `codex-weekend-20261106-0903Z`, WS-382; schema agent WS-382-SCHEMA.
**Authority:** Platform Admin weekend mandate; [decision before code](../../docs/platform/nz-enrichment-brief/2026-11-06-weekend-controller-continuity.md).
**State:** GOVERNANCE APPLIED / PASS via Admin #383 (`fdaac3bc`); operational ownership and production adoption BLOCKED.

The existing StudySearch execution register now carries the concise controller handover.
A versioned JSON checkpoint and schema beside it provide actual execution identity,
production evidence, PR/branch ownership, decisions, queues, blockers and safe continuation.
The existing operating model and index route successors there. The historical milestone
files remain historical; no competing execution or operational issue register was created.

Atomic coordination is a dedicated `studysearch-controller` Git ref, with one-parent
commits and nonforced server fast-forward updates. It begins in reconciliation; no
active owner/lease is claimed. The protocol records prepare/publish/accept/verify/complete,
persistent in-flight operations and terminal recovery proof. Expiry never clears an
operation or independently permits takeover. All production mutators must adopt it
before exclusive production enforcement is claimed; that adoption is not deployed.

**Reuses → Changes → Replaces → Retires → Conflicts → Protects → Validates:**
- Reuses this CF-039 record, the operating model, StudySearch register, GitHub and live integration queue.
- Changes controller onboarding, checkpoint/handover validation and ownership coordination.
- Replaces reliance on conversation memory and vendor-specific controller wording.
- Retires no runtime component; deploys no duplicate platform scheduler/controller.
- Reconciles November staffing authority with earlier Claude-only records; preserves current release holds.
- Protects release approvals, G3, destructive actions, spending and human admission.
- Validates schema/semantic coherence, false completion/heartbeat rejection, two-controller contention,
  expiry with in-flight work, matching operation recovery and successor acceptance.

**Implementation:** dedicated branches `cf247-controller-continuity` and
`cf247-controller-schema` (`a9292c7e57c8146b38fdf95dd5bb113162813e38`).
Schema tests 17 pass locally; ownership tests 11 pass locally including actual competing
nonforced Git pushes. The governance CI workflow runs these and validates the actual
checkpoint/register. Remote exact-head CI result is recorded at the integration gate.

**Production effect/UI version:** none. No production mutation or deployment.
Named P0 readbacks and feature-review blockers are linked from the current handover;
operational issue closure is not inferred. Configured weekend/Monday AI resumptions
have not executed at this checkpoint.

**Recovery/reversion:** preserve the coordination ref and checkpoint history. A rejected
CAS requires re-read/reconciliation, never force. Revert a faulty governance code change
through reviewed Git history without erasing operational evidence; do not delete
historical continuity or unmerged branch work. Production adoption is a separate
governed Pilot change, with no release authority granted by this extension.

