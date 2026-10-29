# Kimi Work prompt — Layer 4 By kind decision qualification run

Date: 29 October 2026  
Scope: operating prompt only; no Layer 4 decisions or catalogue writes performed.

This prompt implements the recommended next step while respecting the requested **By kind** workflow. It requires one real saved and verified decision before any further decisions, then bounds the remainder to four additional items in the same kind. It is a qualification run, not a full-queue clearance.

## Ready-to-paste prompt

In Kimi Desktop, open **Work → New Task**, type `/`, select **Layer-4-Review** / `cf-layer4-triage`, then paste:

```text
Use the installed Layer-4-Review skill and the connected Kimi Browser Extension to complete a bounded Layer 4 BY KIND decision qualification run through the existing authenticated Platform Admin UI.

The objective is REAL SAVED DECISIONS, not another preflight, snapshot collection or proposed-action report. Do not resume L4B-20261028-2216 or L4B-20261029-1607, and do not rely on snapshots from another workstation. Start one new batch.

SCOPE
- Work in Data pipeline → Layer 4 Review → By kind.
- Select ONE existing kind with pending items and stored evidence suitable for conservative item-level decisions.
- Prefer either:
  a) a fee-cross-check item where the evidence supports keeping the registered/CRICOS total; or
  b) a held-scholarship item where the stored official quote supports “Not for international students” or “Not a scholarship”.
- For this qualification run, do NOT choose an official course-page replacement, archive, provider-departure/ownership, conjoint/no-page, central-page or adapter decision.
- Review no more than the 10 oldest items in that kind and submit no more than 5 decisions in total.
- Process no other kind and no full-queue or provider-wide scan.

BEFORE THE FIRST DECISION
- Record a new L4B-YYYYMMDD-HHMM batch id, selected kind, pending count and current total queue count.
- Read each candidate’s stored quote, links, proposed value and existing context. Use stable review-item ids, never row positions.
- Select the first item whose evidence fully supports an existing permitted choice under the Skill’s action playbook.
- State briefly: exact kind, stable review-item id, subject/provider, intended existing UI choice and evidence basis.
- This prompt authorises you to submit that supported choice without another general confirmation. It grants no additional permissions.

FIRST DECISION — MANDATORY WRITE-PATH QUALIFICATION
- Submit that ONE decision through the existing Layer 4 UI. Do not merely recommend it.
- Include the new batch id and concise evidence basis in the decision reason.
- Verify through the current By kind queue and lightweight items view that the decision was saved and the item is no longer waiting.
- Refresh once if necessary. Do not open the failing Decided view and do not use SQL to verify or write.
- If the result is uncertain, the item remains waiting, or the UI/network fails, STOP. Report the exact last screen/error and do not retry until you have verified whether the original action succeeded.

CONTINUE ONLY AFTER THE FIRST DECISION IS VERIFIED
- Process up to FOUR additional eligible items in the SAME kind, one at a time.
- For every item, independently read the evidence, submit the supported existing UI choice, record the batch id/evidence reason, and verify that item’s queue outcome before continuing.
- Skip and leave pending any item with inadequate evidence, identity conflict, policy judgement, duplication or ownership uncertainty. Record its stable item id, reason, owner and next action.
- Stop after 5 submitted decisions, 10 reviewed items, or exhaustion of eligible items in the selected kind — whichever occurs first.

HARD BOUNDARIES
- No select-all, bulk approval or decisions based only on category-level patterns.
- No AI re-checks, Firecrawl or new source acquisition; stored evidence only.
- No SQL, direct database writes, deletion, direct canonical-value changes or provider mergers.
- No repeated approvals, rejections, archives, publishes or rebuilds when an earlier result is unclear.
- One transient UI/network retry only, after verifying the original result. Stop for repeated timeouts, authentication loss, uncertain writes or unreliable queue state.
- Do not interfere with AER, recovery, enrichment or other running work.

FINAL READ-ONLY RECONCILIATION AND REPORT
Stop after the bounded kind run and report:
1. new batch id and selected kind;
2. kind pending before/after and current total live queue count;
3. number of decisions ACTUALLY SUBMITTED AND VERIFIED;
4. stable review-item id, subject/provider, existing UI action and evidence basis for each decision;
5. actual admitted values, if any, and actions where no admission was expected;
6. reviewed items left pending, each with its blocker, owner and next action;
7. new/re-raised items and any uncertain outcomes;
8. saved checkpoint location and elapsed time;
9. AI/Firecrawl consumption, which must be zero.

If zero decisions were submitted, state that plainly and identify the exact blocker for the first candidate. Do not present local snapshots, helper files, planning or proposed decisions as Layer 4 progress.
```

After this run, the batch id can be checked independently in `pipeline.layer4_decisions`. A successful qualification must show at least one genuinely supported and verified decision; continuing beyond five decisions is deliberately withheld until that write path has been demonstrated.
