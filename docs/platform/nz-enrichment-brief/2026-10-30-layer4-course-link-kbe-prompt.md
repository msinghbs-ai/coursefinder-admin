# KBE prompt — Layer 4 Course link by kind (v5)

Date: 30 October 2026
Skill: `cf-layer4-triage` v5
Workflow: `layer4-clear-kind course_link`

## Copy-paste prompt for Kimi Work

```text
Use the installed cf-layer4-triage v5 Skill and the connected Kimi Browser Extension. Read its SKILL.md and references/action-playbook.md, then execute:

layer4-clear-kind course_link

Scope: Data pipeline → Layer 4 Review → By kind → Course link, across universities. Reconcile every eligible item in this kind, oldest first and one item at a time. Do not process any other pill and do not run layer4-clear-all.

PREFLIGHT
1. Use the connected, authenticated Platform Admin browser session. If the browser connection or required access is unavailable, stop and report the exact screen/error. Never substitute SQL or direct database writes.
2. Start a new batch with id L4B-YYYYMMDD-HHMM. Record workflow, exact scope, start time, live total pending, live course_link pending, category counts and the oldest-item setting. Use the batch id in every decision reason.
3. Use stored evidence only. Do not invoke AI re-checks, Firecrawl, paid reads or new source acquisition. Do not interfere with concurrent AER, recovery or enrichment work.
4. Previous fee-check or held-scholarship qualification does not qualify Course link. Prove the first Course link decision before continuing.

DECISION RULES
Read each item's stable UI ref, provider, course identity, held page, proposed page, stored quote and existing decision context. Use only the existing UI choice supported by the evidence:

- Keep the page we hold: use when stored official evidence proves the held page is current for the exact course and study level. Newer is not automatically better.
- Use the new page: use only when the proposed official URL proves the same course and study level and is more current or correct than the held page. Never overwrite a manual binding.
- Enter another address: use only for a verified URL normalisation or an exact official course page. For a held-fee course-link item, use the course's own HTTPS provider page so the existing read-again path can run. Do not use this workaround to bind a different page.
- Leave the item pending when course code, title, level, provider ownership, page identity, newer active value or manual-binding status is conflicting or unproven. Record the blocker, human owner and next action.

Do not select all, bulk-approve, infer identity from similar titles, replace a page from memory, or treat navigation/planning as a decision.

FIRST-DECISION QUALIFICATION
For the first eligible item, state its stable ref, provider/course, intended existing choice and evidence basis. Submit that one decision with a concise reason in this form:

[L4B-id] Course link: <existing choice> — <official source/quote/course-identity basis>

Verify through the current By kind queue and lightweight items view that the decision saved and that exact ref left Waiting for a person. Refresh once if needed. Do not open the failing Decided view and do not use SQL.

If the first result is uncertain, the ref remains waiting, or the UI/network fails, stop and report the exact ref, last screen and error. Verify whether the original action succeeded before any retry.

CONTINUE THE KIND BATCH
Only after the first verified Course link decision, continue through the remaining eligible course_link items across universities:

1. Snapshot pending stable refs, providers and course identities. Never identify work by changing row position.
2. Submit one supported decision at a time and verify that exact ref leaves waiting before proceeding.
3. Record actual page replacements or URL normalisations separately from decisions that merely keep the held page. If the existing action starts a downstream read, record it as downstream work, not as an admitted result.
4. Leave unsupported items pending with stable ref, exception cause, owner and next action; continue other eligible items only while evidence and writes remain trustworthy.
5. Reconcile a newly raised item once when the same evidence and rule still apply. If it re-raises again, leave it pending, record a re-raise defect and move on. Never enter a keep/replace loop.
6. Retry a transient UI/network timeout at most once with backoff, and only after verifying whether the original action saved.
7. Checkpoint after every 10 submitted decisions, after every 20 reviewed items without a decision, and before any scope change. Preserve completed checkpoints if the batch stops.

STOP CONDITIONS
Stop the batch for authentication/access loss, repeated uncertain writes, a shared evidence/decision defect, unexpected consumer-visible changes, queue refs/counts that cannot be reconciled, or a changed/new UI choice not covered by v5. Do not force the pill to zero.

FINAL REPORT
Return one consolidated report, not proposed actions:

- pending before/after and total reviewed;
- decisions actually submitted and verified, grouped by Keep the page we hold, Use the new page and Enter another address;
- stable refs, provider/course, evidence basis and ledger event/decision ids where the UI exposes them;
- pages actually replaced or normalised, plus any downstream reads still running;
- new/re-raised items and remaining exceptions by cause, with owner and next action for each;
- checkpoint location, elapsed time and AI/Firecrawl/new-source consumption, which must be zero under this prompt;
- final live course_link count after one refresh.

State reconciled, admitted/applied, left pending and newly raised separately. If zero decisions were submitted, say so and identify the exact blocker for each reviewed candidate. Do not claim that opening a page, collecting snapshots or recommending a choice cleared Layer 4.
```
