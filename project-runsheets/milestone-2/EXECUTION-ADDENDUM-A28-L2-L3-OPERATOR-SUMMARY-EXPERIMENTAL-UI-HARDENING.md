# M2 Execution Addendum A28 — Layer 2/3 Operator Summary & Experimental UI Hardening

**Status:** ACTIVE / REQUIRED FOR M2.4.4 CLOSURE  
**Effective:** 1 September 2026  
**Primary Change Control:** `CF-CHG-20260830-048`  
**Applies to:** Layer 2 and Layer 3 canonical workspaces, Jobs & Runs summaries, Evidence summaries, blocker/info messages, diagnostics and browser-facing bug fixes.

## Purpose

Reassess the information architecture and usefulness of the Layer 2 and Layer 3 operational summaries before M2.4.4 closure.

Normal operator pages must present current, actionable operational information rather than experimental, duplicated or debug-oriented content.

## A28.1 — Layer 2 blocker / info-message assessment

The existing end-of-page Layer 2 `Blockers / required actions` area must be reviewed against actual operator need.

Rules:
- retain only messages that represent a real current blocker, required operator decision, budget/quota condition, stale/stuck state, failed/retry condition, or other actionable operational exception;
- do not treat ordinary background qualification, scheduled continuation or healthy automated processing as a blocker;
- informational status that does not require operator action should move to the relevant progress/run summary or concise help/context text;
- duplicate messages already represented in Dashboard, Jobs & Runs or the active-run panel should not be repeated as blockers;
- when no actionable blocker exists, use a compact healthy state rather than a large empty panel;
- avoid alarm styling for expected/normal background operations.

## A28.2 — Jobs / Runs summary

Layer 2 and Layer 3 canonical workspaces should contain a concise, current Jobs/Runs summary that is useful without opening the full Jobs workspace.

At minimum, where supplied by runtime:
- current parent run/job ID;
- current phase/status;
- selected / processed / completed counts;
- resolved / escalated / blocked / failed counts appropriate to the layer;
- heartbeat / last progress;
- runtime;
- scheduled continuation or next action;
- latest terminal run result;
- direct link to the full Jobs & Runs workspace.

The summary must use the same run/job lineage as A26 and must not show unrelated historical jobs as current state.

## A28.3 — Evidence summary

Layer 2 and Layer 3 should expose a concise operational Evidence summary rather than only a raw total.

Where runtime data exists, show:
- Evidence count related to the active/latest run;
- latest capture time;
- Evidence types/formats at a useful aggregate level;
- Evidence awaiting review/interpretation where that concept is valid;
- missing-Evidence condition only when it is actually abnormal;
- direct link to Evidence filtered/scoped to the relevant layer/run where supported.

Preserve A25 type-aware preview and exact lineage requirements.

## A28.4 — Experimental/debug information

Review Layer 2 and Layer 3 browser-facing content for experimental/debug remnants.

Normal operator routes must not expose:
- pilot/experimental build labels;
- developer probes;
- qualification/test-only descriptions that confuse production semantics;
- hidden-launcher instructions;
- stale demo-only labels;
- raw implementation details that belong under Administration/diagnostics;
- duplicated configuration controls;
- debug counters without clear operator meaning;
- temporary bug-workaround text.

Useful diagnostics may remain under progressive disclosure / Administration / Jobs detail if they are role-appropriate and maintained.

## A28.5 — Layer 3 parity

Apply the same information-quality standard to Layer 3:
- clear current run/queue/interpretation status;
- meaningful model/usage metrics under A14;
- concise Evidence-input/output summary;
- actionable blockers only;
- no experimental/benchmark-only controls dominating the normal workspace;
- model/profile configuration remains under Administration;
- AI interpretation authority remains suggestion/interpretation-bound and does not silently mutate canonical truth.

## A28.6 — Bug-fix sweep

Before M2.4.4 closure, perform a bounded Layer 2/Layer 3 UI defect sweep covering:
- stale labels;
- broken or dead buttons/links;
- duplicate headings;
- layout overflow;
- loading flashes;
- blank/empty panels;
- incorrect alert severity;
- inconsistent counts between page summary, Dashboard, Jobs & Runs and Evidence;
- inaccessible click/keyboard targets;
- legacy/floating/experimental elements accidentally reintroduced.

Fix demonstrated defects without weakening authority, security, Evidence, quota or performance acceptance contracts.

## Acceptance

A28 is not accepted until targeted deployed UAT proves:
1. Layer 2 normal healthy background processing is not shown as a blocker;
2. actionable blockers remain visible and correctly styled;
3. Layer 2 and Layer 3 Jobs/Runs summaries reconcile with the full Jobs workspace;
4. Layer 2 and Layer 3 Evidence summaries reconcile with governed Evidence lineage;
5. experimental/debug-only content is absent from routine operator routes;
6. no dead controls or blank summary panels remain;
7. desktop/tablet/mobile layouts remain usable;
8. A14/A21/A23/A25/A26/A27 contracts remain intact.

## Sequencing

A28 should be implemented in the same M2.4.4 corrective cycle as A26 and A27 before the next bounded integration candidate.
