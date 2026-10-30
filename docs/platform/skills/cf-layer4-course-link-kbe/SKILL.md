---
name: cf-layer4-course-link-kbe
description: Operate CourseFinder Platform Admin Layer 4 Review Course link items directly through the Kimi Browser Extension sidebar on the current authenticated web page. Use when asked to clear, triage, review, reconcile or drain university course links By kind, run layer4-course-links, or use the v5 Course link workflow without Kimi Work. Uses existing UI choices and stored evidence with individually verified writes; does not use SQL, local-agent setup, helper files or other Layer 4 pills.
---

# CourseFinder Layer 4 Course link — direct KBE

Operate directly in the open Platform Admin tab through the Kimi Browser Extension sidebar. Do not require Kimi Work, a local-agent connection, GitHub, SQL, uploads or local checkpoint files.

Reconcile **Data pipeline → Layer 4 Review → By kind → Course link** across universities. Clear means review, decide and verify; never delete items or force the count to zero. Derived from `cf-layer4-triage` v5, but intentionally limited to Course link.

## Invoke

- `layer4-course-links` — reconcile the current Course link kind, oldest first.
- `layer4-course-links resume` — continue only from a checkpoint visible in the current sidebar chat.
- Treat “clear Course link”, “triage university course links By kind” and equivalent requests as the first command.

Start after a short preflight. Do not produce a long plan, scan unrelated pills or stop at proposed actions.

## Preflight

1. Confirm the current tab is the authenticated Platform Admin **Layer 4 Review** page. Open **By kind → Course link** using the existing UI. If authentication or the required choices are unavailable, stop and report the exact screen/error.
2. Create batch id `L4B-YYYYMMDD-HHMM`. Record the visible total pending and Course link pending counts, start time and oldest-item setting. Use the batch id in every reason.
3. Use stored page evidence only. No AI re-checks, Firecrawl, paid reads or new source acquisition. Do not interfere with concurrent AER, recovery or enrichment work.
4. Read page text and controls first. Take a screenshot only when page state or an error is unclear.
5. Previous fee-check or held-scholarship qualification does not qualify Course link. Verify the first Course link decision in this browser session before continuing.

## Decide from item evidence

Read each item's stable UI ref, provider, course identity, held page, proposed page, stored quote and existing decision context. Never identify an item by its changing row position.

Use only the existing supported choice:

- **Keep the page we hold** when stored official evidence proves the held page is current for the exact course and study level. Newer is not automatically better.
- **Use the new page** only when the proposed official URL proves the same course and study level and is more current or correct than the held page. Never overwrite a manual binding.
- **Enter another address** only for a verified URL normalisation or exact official course page. For a held-fee course-link item, use the course's own HTTPS provider page so the existing read-again path can run. Do not use this workaround for a different page.

Leave the item pending when course code, title, level, provider ownership, page identity, newer active value or manual-binding status is conflicting or unproven. Record the stable ref, blocker, human owner and next action.

Use a concise reason:

`[L4B-id] Course link: <existing choice> — <official source/quote/course-identity basis>`

No select-all, generic bulk decision, identity inference from similar titles, replacement from memory or SQL/direct database write.

## Prove the first write

1. For the first eligible item, state its stable ref, provider/course, intended choice and evidence basis.
2. Submit that one decision. Do not merely recommend it.
3. Verify through the current By kind queue and lightweight items view that the exact ref left **Waiting for a person**. Refresh once only if needed. Do not open the failing **Decided** view.
4. If the result is uncertain, the ref remains waiting, or the UI/network fails, stop and report the exact ref, last screen and error. Check whether the original action saved before any retry.

Only after that verified decision, continue the kind batch.

## Reconcile the remaining items

1. Process oldest first across providers, one item at a time. Submit and verify each supported decision before proceeding.
2. Record actual page replacements and URL normalisations separately from kept pages. Treat any resulting read as downstream work, not an admitted result.
3. Leave unsupported items pending and continue other eligible items only while evidence and writes remain trustworthy.
4. Reconcile a newly raised item once when the same evidence and rule still apply. If it re-raises again, leave it pending, record a re-raise defect and move on. Never enter a keep/replace loop.
5. Retry a transient UI/network timeout at most once with backoff, after checking whether the original action saved.
6. Post a compact checkpoint in the current sidebar chat after every 10 submitted decisions, every 20 reviews without a decision and before stopping. Include batch id, pending before/current, verified refs and choices, actual page changes, downstream reads and exceptions. Do not create helper files.
7. Refresh once at completion or stop and reconcile the count. Do not attribute unrelated global movement to this batch.

Resume only when the relevant checkpoint is visible in the current sidebar chat. Otherwise start a new batch from current queue state; never repeat a ref that already left waiting.

## Stop conditions

Stop and preserve the chat checkpoint for:

- authentication or required-role loss;
- repeated uncertain writes or statement timeouts;
- a shared evidence/decision defect;
- unexpected consumer-visible changes;
- queue refs/counts that cannot be reconciled;
- a new or changed UI choice not covered above.

## Report once

Return one consolidated sidebar report with:

- Course link pending before/after and total reviewed;
- decisions actually submitted and verified, grouped by **Keep the page we hold**, **Use the new page** and **Enter another address**;
- stable refs, provider/course, evidence basis and ledger ids where the UI exposes them;
- pages actually replaced or normalised and downstream reads still running;
- new/re-raised items and unresolved exceptions, each with owner and next action;
- checkpoint location (this sidebar chat), elapsed time and AI/Firecrawl/new-source consumption, which must be zero;
- final live Course link count after one refresh.

State **reconciled**, **admitted/applied**, **left pending** and **newly raised** separately. Snapshots, navigation, screenshots and proposed actions are not decisions. If zero decisions saved, say so and give the exact blocker for each reviewed candidate.
