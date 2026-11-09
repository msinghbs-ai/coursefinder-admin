# Layer 4 v5 qualification verification — L4B-20261030-1357

Date: 30 October 2026
Status: independently verified; continue the same kind with a bounded kind batch

## Decision

Run next:

```text
layer4-clear-kind held_scholarship
```

Do not run `layer4-clear-all` yet. Batch `L4B-20261030-1357` proves the existing held-scholarship **Not for international students** decision route only. It does not qualify scholarship publication, other Layer 4 kinds, AER, archives, linked corrections or adapter actions.

## Scope and method

Reviewed the supplied v5 checkpoint and reconciled it read-only against the live Supabase project `fxcwkweaxjtknorudmwp` using:

- `pipeline.admin_control_events` for actual Inbox submissions and stored application outcomes;
- `security.layer4_inbox_items_v1()` for current waiting refs and counts.

No AI re-check, Firecrawl call, new source acquisition, SQL write or consumer change was performed for this audit. The source quotations themselves were not re-read; this audit verifies the recorded decisions, their application outcomes and current queue state.

## Verified decisions

| Stable ref | Provider / subject | Existing UI choice | Ledger event | Stored application outcome | Current waiting state |
|---|---|---|---:|---|---|
| 1181 | Southern Cross University — Transition to Uni (TU) Pathway Scholarship | Not for international students | 25610 | `review: 1181`, `refused: true`, `decision: refuse` | Absent |
| 1185 | Southern Cross University — Business and Professional Women (BPW) Maude Spielvogel Scholarship | Not for international students | 25612 | `review: 1185`, `refused: true`, `decision: refuse` | Absent |
| 1186 | La Trobe University — New Colombo Plan (NCP) Scholarship | Not for international students | 25615 | `review: 1186`, `refused: true`, `decision: refuse` | Absent |

The event reasons carry batch id `L4B-20261030-1357` and the checkpoint's evidence bases. The stored `reviews_pending` values after the three events were 739, 738 and 737 respectively.

Therefore the checkpoint's central claim is correct: **three decisions were submitted, applied as refusals and verified out of waiting; zero scholarships were admitted by these decisions**.

## Verified exceptions

The following seven refs remain in the current held-scholarship waiting queue, exactly as the checkpoint reports:

| Refs | Exception | Required treatment |
|---|---|---|
| 1172, 1173, 1174, 1175 | Stored source unavailable/inadequate; no usable value or audience quote | Leave pending. Reassess only after a readable stored official copy is obtained through a separately authorised existing process. |
| 1176 | Provider identity and exact benefit unresolved | Leave pending for Platform Admin / provider ownership review. |
| 1177 | Provider identity conflict | Leave pending; do not publish under uncertain ownership. |
| 1184 | Possible publishable scholarship, but active-equivalent duplicate check incomplete | Complete the existing active-equivalent check. Publish only if there is no exact/near duplicate and every stored-evidence admission gate passes; otherwise leave pending for deduplication. |

These are legitimate exceptions, not failed writes. Do not force them to a refusal or publish decision merely to reduce the count.

## Queue reconciliation

- Checkpoint preflight: 2,741 total pending; 740 held scholarships.
- Checkpoint finish: 2,738 total pending; 737 held scholarships.
- Independent current read: **2,737 total pending; 737 held scholarships**.
- Current `website_needed` count is 40 rather than the checkpoint's 41. No later `layer4 / inbox_decide` event after event 25615 was found in the limited ledger check, so do not attribute that unrelated global movement to this qualification batch.
- Other current non-zero counts: AER 1,055; Course link 214; Course not on site 110; Adapter has nothing ready 312; Too few course pages 131; Course pages not found 54; No page first run 49; Conjoint first run 11; Provider departure 16; Onboarding failed 5; Central pages 3.

The held-scholarship movement reconciles exactly: 740 − 3 verified refusals = 737. There is no evidence in this audit of a re-raised decided ref.

## Next run contract

Start a new kind batch with `layer4-clear-kind held_scholarship`; the qualification run is complete, so this is not a resume of its ten-item scope.

The Kimi Work run must:

1. Use the connected authenticated Platform Admin browser on **Data pipeline → Layer 4 Review → By kind → Held scholarship**.
2. Record a new batch id, current counts and stable refs. Use stored evidence only; no AI re-check, Firecrawl or new source acquisition without separate explicit authorisation.
3. Process oldest first, one item at a time. Do not repeat refs 1181, 1185 or 1186; they are already decided and absent.
4. Submit only evidence-supported existing choices and verify each item leaves **Waiting for a person**. Navigation is not a decision.
5. Preserve the seven exception refs unless their named blocker is actually resolved. Do not loop over the four unreadable-source or two identity-conflict items without new evidence.
6. Treat this qualification as proving the refusal route only. For the first **Publish** decision, complete scholarship/value/international-eligibility/provider checks and the active-equivalent check, submit one publication, and verify both the admitted scholarship and Layer 4 closure before publishing another. Verify any other distinct action route conservatively before repeating it.
7. Checkpoint every 10 submitted decisions, every 20 reviews without a decision and before changing scope. Record ledger ids when available, actual admissions separately from refusals, and every unresolved owner/next action.
8. Stop on authentication loss, repeated uncertain writes, unreliable queue/evidence state, unexpected consumer-visible changes or a changed UI contract.

After this kind batch reaches exhaustion or a stop condition, choose one other exact kind and verify its first decision before continuing. Do not interpret this checkpoint as qualification for the full queue or for bulk AER work; AER remains Platform Admin-only and one item at a time.
