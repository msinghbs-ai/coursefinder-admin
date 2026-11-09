# Layer 4 batch `L4B-20261030-0938` — independent live verification

Date: 30 October 2026  
Scope: checkpoint review and read-only live audit. No queue, decision, catalogue or schema writes performed by this audit.

## Conclusion

The reported qualification **succeeded for the `fee_check` / flag-release write path**. Five real Inbox decisions are recorded, all five source flags are released, the fee-check queue remains at zero, and all five courses retain their registered tuition totals. No proposed page fee was admitted.

This is not evidence that every Layer 4 action route has been qualified. Course-link, scholarship, AER, archive and other routes still require their own first-decision verification when used.

## Live decision evidence

The decisions are in `pipeline.admin_control_events` with `area = 'layer4'` and `action = 'inbox_decide'`, which is the existing Inbox history source. They do not have corresponding `pipeline.layer4_decisions` rows; that is expected for this action route and is not a missing-audit failure.

| Stable UI ref (fee flag) | Inbox event id | Provider | CRICOS | Choice/result | Current canonical outcome |
|---:|---:|---|---|---|---|
| 1924240 | 25591 | Massey College | 116090G | `keep`; flag released | Registered tuition **AUD 28,500** retained; no page fee admitted |
| 3636190 | 25592 | UNSW Sydney | 084279G | `keep`; flag released | Registered tuition **AUD 61,000** retained; no page fee admitted |
| 4177321 | 25593 | Apex Australia Vocational Education | 118715G | `keep`; flag released | Registered tuition **AUD 32,000** retained; no page fee admitted |
| 5039017 | 25594 | Apex Australia Vocational Education | 113737H | `keep`; flag released | Registered tuition **AUD 34,000** retained; no page fee admitted |
| 5039018 | 25595 | Apex Australia Vocational Education | 113738G | `keep`; flag released | Registered tuition **AUD 34,000** retained; no page fee admitted |

Each event has the expected batch id and variance evidence in its reason. The matching `pipeline.enrichment_flags` rows are `state = 'released'` with `release_kind = 'person'`; their release timestamps match the Inbox events.

Current active fee rows retain `basis = 'registered_total_course'`. Their September update timestamps predate this batch, independently supporting that the decisions released the holds rather than writing new page fees.

## Queue reconciliation

- Checkpoint preflight: **2,746** total pending; **5** `fee_check`.
- Checkpoint completion: **0** `fee_check`; reported total **2,740**.
- Independent current `security.layer4_inbox_items_v1()` check: **0** `fee_check`.
- No fee-check item had re-raised at the time of audit.
- Live total reads moved between **2,740 and 2,741** during the audit. Category comparison also showed `website_needed` moving from 41 to 40, which is unrelated to this fee batch. Do not attribute the entire global count delta to these five decisions or use the moving total as the sole audit measure.

The release results state that the next Enrich fields task includes the courses. Release is therefore not a promise that fee issues can never re-raise; any later item must be treated as new work and reconciled separately.

## Checkpoint corrections for future runs

The checkpoint's five outcomes are substantiated. Two labels should be interpreted more precisely:

1. `stable_review_item_id` values are numeric **fee-flag/UI refs**, not `pipeline.layer4_review_items` UUIDs. Future checkpoints should call these `stable_ui_ref` and record the Inbox event id where available.
2. `write_path_qualification = passed` applies to the fee-check flag-release route, not every Layer 4 action route.

The canonical Skill, audit guide and portable package have been corrected for these distinctions. The audit guide now treats `pipeline.admin_control_events` as the Inbox submission history and `pipeline.layer4_decisions` as supplemental routed detail, without double-counting actions that appear in both.

## Next step

A fresh bounded single-provider batch is reasonable. It must continue to submit and verify decisions item by item. When it encounters a different kind/action route, verify the first decision for that route before continuing; do not infer success from this fee-check qualification alone.
