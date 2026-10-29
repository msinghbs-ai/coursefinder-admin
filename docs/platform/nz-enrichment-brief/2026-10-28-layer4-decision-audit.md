# Layer 4 Review and KBE skill — decision and outcome audit

Date: 28 October 2026; corrected 30 October 2026 after live fee-check verification  
Scope: read-only audit guidance. No queue, catalogue or schema writes.

## Why Evidence has no Layer 4 filter

**Operations → Evidence** audits saved source pages and files. It does not audit Layer 4 decisions. A routed Layer 4 review decision can reference an artifact through `pipeline.layer4_decisions.evidence_id`; an inbox decision does not necessarily create a new “Layer 4” evidence artifact or carry an evidence id in its control-event detail. Filtering Evidence by source or layer therefore cannot reliably show what Layer 4 cleared.

The decision-first path is:

1. `pipeline.admin_control_events` with `area = 'layer4'` and `action = 'inbox_decide'` — the existing Inbox decision history used by `public.admin_layer4_inbox('decided')`: when, actor, kind, stable UI ref, choice, reason and result.
2. `pipeline.layer4_decisions` plus `pipeline.layer4_review_items` — additional routed-decision detail for applicable review items, including final value, evidence id and current review state. Not every Inbox kind uses these tables.
3. The relevant canonical/source table — proof of what actually happened afterwards, such as a released fee flag or retained registered fee.
4. `pipeline.evidence_artifacts` / the Evidence screen — the supporting source, opened by evidence id where one actually exists.

Some routed actions produce both an Inbox control event and a `layer4_decisions` row. These are two records of one submission, not two decisions. Other actions, including the verified `fee_check` keep/release path, produce an Inbox control event without a `layer4_decisions` row.

While the existing **Layer 4 → Decided** view is failing, there is no complete UI-only audit path. Do not substitute the failing view or global pending-count deltas. A count can move because another item was raised, superseded or changed by background work.

## Routed review-ledger example

The live routed ledger contains five decisions from the earlier batches:

| Batch | Provider | Decisions | Recorded actions |
|---|---|---:|---|
| `L4B-20261028-1752` | Federation University Australia | 3 | 3 × approve official course URL |
| `L4B-20261028-1441` | The University of Sydney | 2 | 1 × edit-and-approve conjoint rule; 1 × reject fee-course validation |

These are **routed decision counts**, not a claim that five values were admitted or that every Inbox action appears in this ledger. The three Federation canonical course URLs were separately verified as bound and readable. The rejected Sydney fee proposal admits no fee by design. The Sydney conjoint decision requires its own outcome check before being reported as applied.

## Reusable Inbox audit query

Run in the Supabase SQL editor. Use `%L4B-%` for skill-tagged batches, or replace it with one full batch such as `%L4B-20261030-0938%`. The substring handles reasons with or without a leading bracket.

```sql
select
  substring(e.detail->>'reason' from 'L4B-\d{8}-\d{4}') as batch_id,
  e.created_at as decided_at,
  e.id as inbox_event_id,
  e.target,
  e.actor,
  coalesce(p.display_name, p.canonical_name) as provider,
  e.detail->>'kind' as category,
  e.detail->>'ref' as stable_ui_ref,
  e.detail->>'choice' as choice,
  e.detail->>'value' as value,
  e.detail->'result' as result,
  e.detail->>'reason' as reason
from pipeline.admin_control_events e
left join catalogue.providers p
  on p.id::text = e.detail->>'provider_id'
where e.area = 'layer4'
  and e.action = 'inbox_decide'
  and e.detail->>'reason' ilike '%L4B-%'
order by e.created_at desc;
```

For all Inbox activity—including non-skill manual decisions—remove the batch predicate and use date, actor, provider or category predicates instead. The batch marker isolates skill-run decisions; it is not a universal Layer 4 marker.

## Additional routed-decision query

Use this to enrich applicable Inbox events with review-item state, final values and evidence ids. Do not interpret an empty result as proof that no Inbox decision occurred.

```sql
select
  substring(d.reason from 'L4B-\d{8}-\d{4}') as batch_id,
  d.created_at as decided_at,
  d.id as routed_decision_id,
  d.review_item_id,
  d.actor_id,
  coalesce(p.display_name, p.canonical_name) as provider,
  r.field_code as category,
  c.course_code,
  coalesce(c.canonical_title, s.name, r.entity_type) as subject,
  d.action,
  r.status as current_review_status,
  d.final_value,
  d.evidence_id,
  d.reason
from pipeline.layer4_decisions d
join pipeline.layer4_review_items r
  on r.id = d.review_item_id
left join catalogue.courses c
  on r.entity_type = 'course' and c.id = r.entity_id
left join scholarship.scholarships s
  on r.entity_type = 'scholarship' and s.id = r.entity_id
left join catalogue.providers p
  on p.id = coalesce(
    c.provider_id,
    s.provider_id,
    case when r.entity_type = 'provider' then r.entity_id end
  )
where d.reason ilike '%L4B-%'
order by d.created_at desc;
```

Match routed detail to the Inbox event by batch, stable review-item ref, actor and timestamp/action context. Do not add the two row counts together.

## Open the supporting Evidence

Where a routed decision supplies `evidence_id`, paste it into the **Evidence** search box. This opens the original saved source and its canonical-use information. A null or absent evidence id means there is no artifact to open through this route; use the Inbox reason/result, source-specific evidence, final value and batch checkpoint instead.

## Reconcile four different outcomes

Report these separately:

| Measure | What proves it |
|---|---|
| **Decided** | An `inbox_decide` row in `pipeline.admin_control_events`; applicable routed items can also have a `layer4_decisions` row. |
| **Cleared from waiting** | The source-specific item is no longer pending: for example the review item is decided or the fee flag is released. This alone does not prove admission. |
| **Actually admitted/applied** | The current canonical row matches the decision's intended outcome. A keep/reject decision often intentionally admits nothing. |
| **Re-raised** | A newer pending item exists for the same source entity and field after the decision. Treat it as new work or a defect, not as proof the original decision never happened. |

Canonical outcome checks by category:

- **Fee check/keep:** `pipeline.enrichment_flags` shows the source flag released, and current `catalogue.course_fees` retains the registered values without admitting the proposed page fee. The release result can say the next Enrich fields task includes the course, so a later re-raise remains possible.
- **Course link:** `catalogue.courses.course_url`, the reviewer row in `catalogue.course_links`, and `pipeline.coverage_course_pages` binding/read state. Note the separately recorded Federation apply-path issue: replaced links may remain active and a fresh read may not have been requested.
- **Other fee decision:** current `catalogue.course_fees`; a rejected proposal is a completed decision with no admission.
- **Scholarship:** current `scholarship.scholarships` publication/lifecycle state and audience/value fields; verify duplicates separately.
- **Archive:** current `catalogue.courses.lifecycle_status`; never infer an archive merely from queue removal.
- **Conjoint/no-page rule:** the rule/no-page outcome and any newer pending item; the decision's `parent_url` alone is not proof of application.
- **Adapter rebuild:** queued and completed are different outcomes; use the existing task/build state and do not count a queued rebuild as admitted enrichment.

## Batch reporting rule

For each batch, reconcile the checkpoint to Inbox event ids, applicable routed decision ids and current source/canonical outcomes:

`baseline pending = decisions + still pending + superseded/otherwise resolved + newly raised adjustments`

Do not force this equation to hide exceptions or attribute unrelated category movement to the batch. Record the stable UI item/ref id—UUID or kind-specific numeric ref—plus Inbox event id, routed decision id and evidence id where available. Qualification of one kind's write path does not prove every Layer 4 action route.

## UI improvement path

Repair the existing **Layer 4 → Decided** view rather than adding a Layer 4 filter to Evidence or creating another panel. Its current source is `pipeline.admin_control_events`; enhancement should retain that Inbox history and join applicable routed/canonical detail rather than assuming every decision lives in `layer4_decisions`. The existing view is the correct place for batch/date/provider/category filters and links to current outcomes and Evidence. Any Pilot change requires a decision record first; none is made by this audit.
