# Layer 4 Course link batch L4B-20261030-0816 — independent verification

Date: 30 October 2026
Status: writes verified; two narrative reconciliation corrections required

## Verdict

The batch made real, successful Course link decisions. The live Inbox ledger confirms **132 successful writes across 132 unique targets**, and none of those refs is currently waiting. The reported final UI count of 83 has since moved to **86 Course link items / 2,610 total**; the three additional Course link items are different refs, not failed or returning writes.

Two parts of the sidebar narrative need correction or additional refs:

1. `214 - 132 = 82`, not 83. A final count of 83 requires **one net additional Course link item** at the final refresh (`214 + 1 - 132 = 83`). Add that new-pending item to the reconciliation; it is not explained merely by saying that two items were re-raised and re-decided.
2. The reported two re-raises are not independently identifiable from the successful batch ledger: there are no repeated targets, no repeated non-null `course_id` in the 68 held-fee Enter results, and no repeated routed `entity_id` among the 64 review-item decisions. Preserve the claim only with the old/new refs or other UI checkpoint evidence.

## Method

Read-only reconciliation against live project `fxcwkweaxjtknorudmwp` using:

- `pipeline.admin_control_events` for submitted Inbox decisions and their returned outcomes;
- `pipeline.layer4_review_items` for routed entity identity;
- `security.layer4_inbox_items_v1()` for current waiting refs, reasons and counts.

No Platform Admin write, AI re-check, Firecrawl call or new source acquisition was performed for this audit. Source pages and quotation correctness were not re-read; this audit verifies writes, returned application outcomes, identities and queue state.

## Verified ledger totals

Batch writes ran from **08:20:44.722368 UTC to 08:59:23.959481 UTC**, within the reported 08:16–09:01 batch window. Event ids span 25621–25821 (not contiguous).

| Existing choice | Events | Unique targets | Returned outcome |
|---|---:|---:|---|
| Use the new page (`use`) | 17 | 17 | All `ok: true`, `action: approve`, `status: approved`; 17 distinct decision ids and review-item ids; every event has a final `course_url`; all 17 require search refresh. |
| Keep the page we hold (`keep`) | 1 | 1 | `ok: true`, `action: reject`, `status: rejected`; the mismatched proposed page was rejected, with no replacement value. |
| Enter another address (`enter`) | 114 | 114 | All `ok: true`; two distinct outcome routes below. |
| **Total** | **132** | **132** | No non-OK result and no repeated target. |

Only `inbox_decide` events carry this batch reason; there are 132 such events and no separate failure event under the same batch reason.

### Enter another address — actual outcome distinction

| Route | Events | Verified result |
|---|---:|---|
| Fee-reader routed review items | 46 | All returned `action: edit_and_approve`, `status: edited_approved`, a distinct decision id and a `final_value` page URL. All 46 require search refresh. The **page-address decision is applied/approved**; downstream search/fee work remains separate. |
| Held-fee read-again path | 68 | All returned `ok: true`, a course id, official URL and the existing read-again message. These have no routed decision id/final value in the returned result. The resulting fee read is downstream, not a fee admission. |

Therefore the report should not describe all 114 Enter outcomes simply as “not admitted results”. The accurate statement is: **46 page addresses were edited and approved with downstream refresh required; 68 entered the held-fee read-again path; no fee admission is inferred from either route.** The 17 Use decisions are a further set of approved page replacements.

Where returned, `publication_changed` was false for all 17 Use, 1 Keep and 46 routed Enter decisions. This does not replace the need to track the required search refreshes and fee reads.

## Queue verification

- None of the 132 successful batch targets currently appears in Course link waiting.
- Current live count: **86 Course link / 2,610 total**.
- The reported finish was **83 Course link / 2,606 total**.
- Net movement since that report: **+3 Course link / +4 total**, including one Website needed item.

The three additional current Course link refs are:

| Ref | Subject | Current reason | Created at (UTC) |
|---|---|---|---|
| `40a90cfd-059a-4653-a9b2-e25a70c2f012` | New Zealand Certificate in Coachbuilding (Level 4) | Official-page address pair needs a current-page decision | 09:00:00.457274 |
| `841f56b5-5278-4467-8539-50e6e4152a9e` | Certificate of Attainment in English Language (Level 3) | Official-page address pair needs a current-page decision | 09:00:00.457274 |
| `4c04cd80-e680-46d7-bcd7-f4cd4f9ad3f2` | Bachelor of Social Work (Honours) | Course page gives a different English score | 09:50:00.357248 |

Current Course link reasons reconcile exactly to the reported 83 plus these three:

- 38 course match not sure enough;
- 21 outside usual range/old fee year (the report's 6 without a stored official page + 15 rejected writes);
- 16 qualification/title differ;
- 6 official-page address pairs (the report's 4 + the two refs above);
- 3 PIA postgraduate English-policy conflicts;
- 1 USC stored-official-page defect;
- 1 new English-score difference (the third ref above).

A separate Website needed item was created at 11:06 UTC, accounting for the fourth net increase in the total queue.

## Rejected attempts and re-raises

The success ledger cannot independently prove the count of **16 rejected attempts**: rejected UI writes do not appear as successful `inbox_decide` events. It does confirm that no non-OK success result was recorded and no successful batch ref remains waiting. Keep the rejected-attempt count as a UI/checkpoint observation, with refs where available.

The two reported re-raises need old/new refs. Within the successful batch ledger:

- no target occurs more than once;
- no non-null `course_id` repeats among the 68 held-fee Enter results;
- no routed `entity_id` repeats among the 64 Use/Keep/routed-Enter decisions.

This does not prove the UI observation wrong; it means the current checkpoint does not supply enough identifiers to audit it.

## Required checkpoint amendment

Retain the 132 verified decisions and the exception owners, but amend the narrative to include:

1. the one net additional pending Course link item needed for `214 + 1 - 132 = 83`, with its ref;
2. old/new refs for the two claimed re-raises, or mark them unverified;
3. the 46/68 Enter outcome split above;
4. the subsequent current-state line: 86 Course link / 2,610 total at this audit, with the three additional Course link refs listed.

## Next action

Do **not** rerun a full Course link batch over the unchanged evidence/identity/policy exceptions merely to reduce the count. First reconcile the downstream search refreshes and fee reads separately, preserve the named human/pipeline owners, and review only newly raised or newly evidenced items. No fee or search admission should be claimed from the Enter decisions alone.
