# Kimi Work prompt — bounded single-provider Layer 4 triage

Date: 29 October 2026  
Scope: operating prompt only; no Layer 4 decisions or catalogue writes performed.

## Why the previous prompt does not triage

The supplied handback prompt is deliberately read-only. It instructs Kimi not to resume scanning or change canonical values, so invoking the triage Skill with that prompt will still produce only a status report. It cannot submit Layer 4 decisions under those instructions.

The replacement below starts a new batch, selects one small exact provider record, expressly authorises the Skill's supported item-level UI decisions, and stops after that provider. It does not resume yesterday's read-only batch or depend on snapshots stored on another workstation.

## Ready-to-paste prompt

In Kimi Desktop, open **Work → New Task**, type `/`, select **Layer-4-Review** / `cf-layer4-triage`, then paste:

```text
Use the installed Layer-4-Review skill and the connected Kimi Browser Extension.

Do not resume batch L4B-20261028-2216 and do not rely on snapshots or checkpoints from another workstation. Start a new, bounded single-provider batch.

STEP 1 — READ-ONLY PREFLIGHT
Through the authenticated Platform Admin UI at Data pipeline → Layer 4 Review:
- Confirm the current live queue count.
- Identify the exact provider record with the smallest non-zero pending-item count. If several have the same count, choose the one whose oldest item has waited longest.
- State the selected provider’s exact name and pending-item count.
- If that provider has more than 10 pending items, stop and report instead of widening the run.

STEP 2 — TRIAGE THAT ONE PROVIDER
After the preflight, proceed without waiting for another general confirmation. This instruction authorises the item-level UI decisions already permitted by the Skill and action playbook, but no additional permissions.

Run the equivalent of:

layer4-clear-all <the exact provider name selected above>

For this provider only:
- Record a new L4B-YYYYMMDD-HHMM batch id and the provider’s baseline item ids, categories and counts.
- Process its items individually using stable review-item ids, stored quotes, links, proposed values and existing decision context.
- Submit each supported decision through the existing Layer 4 UI; do not merely describe decisions that could be made.
- Include the new batch id and concise evidence basis in every submitted decision reason.
- Leave an item pending when its evidence, identity, policy, duplicate or ownership issue is unresolved. Record the item-specific reason, owner and next action rather than forcing a decision.
- Verify submitted outcomes through the current queue and lightweight universities/items views. Do not open the failing Decided view.
- Checkpoint after the provider with pending before/after, submitted decision count, stable review-item ids, actions, actual canonical outcomes and exceptions.

HARD BOUNDARIES
- Process no other provider and do not start a full-queue scan.
- Do not switch to bulk By kind scanning or decisions.
- Use stored evidence only: no AI re-checks, Firecrawl or new source acquisition.
- No SQL, direct database writes, deletion, provider mergers, select-all approval or direct canonical-value changes.
- Retry one transient UI/network timeout once only after checking whether the original action succeeded. Stop for repeated timeouts, uncertain writes, authentication loss or unreliable queue state.
- Do not repeat an approval, rejection, archive, publish or rebuild merely because its earlier result is unclear.
- Do not interfere with AER, recovery, enrichment or other running work.

STEP 3 — STOP AND REPORT
Stop after this one provider. Return one concise report showing:
1. new batch id and exact provider name;
2. pending before/after for that provider and the current total live queue count;
3. number of decisions actually submitted, with stable review-item ids and existing UI actions;
4. values actually admitted, courses archived and adapter rebuilds queued, distinguishing queued from completed;
5. items left pending, with item-specific reason, owner and next action;
6. new or re-raised items;
7. saved checkpoint location and elapsed time;
8. AI/Firecrawl consumption, which must be zero.

If zero decisions were submitted, say so explicitly and explain the blocker for each reviewed item. Do not present snapshot collection, planning or local helper files as Layer 4 progress.
```

This prompt bounds the run to one provider and at most ten pending items. It authorises actual supported UI decisions, but it does not guarantee a particular number of decisions: items that fail the evidence or policy rules must remain pending. That is a valid triage outcome, not something to bypass to make the queue count fall.
