# Layer 4 Review and KBE skill — decision and outcome audit

Date: 28 October 2026  
Scope: read-only audit guidance. No queue, catalogue or schema writes.

## Why Evidence has no Layer 4 filter

**Operations → Evidence** audits saved source pages and files. It does not audit Layer 4 decisions. A Layer 4 decision references the original supporting artifact through `pipeline.layer4_decisions.evidence_id`; it does not necessarily create a new “Layer 4” evidence artifact. Consequently, filtering Evidence by source or layer cannot reliably show what Layer 4 cleared.

The decision-first path is:

1. `pipeline.layer4_decisions` — who decided, when, action, reason, final value and evidence id.
2. `pipeline.layer4_review_items` — the original entity, field/category and current review state.
3. The relevant canonical table — proof of what actually happened afterwards.
4. `pipeline.evidence_artifacts` / the Evidence screen — the supporting source, opened by evidence id.

While the existing **Layer 4 → Decided** view is failing, there is no complete UI-only audit path. Do not substitute the failing view or global pending-count deltas. A count can move because another item was raised, superseded or changed by background work.

## Current skill-batch ledger check

The live database currently has five decisions whose reasons carry the skill's `L4B-YYYYMMDD-HHMM` prefix:

| Batch | Provider | Decisions | Recorded actions |
|---|---|---:|---|
| `L4B-20261028-1752` | Federation University Australia | 3 | 3 × approve official course URL |
| `L4B-20261028-1441` | The University of Sydney | 2 | 1 × edit-and-approve conjoint rule; 1 × reject fee-course validation |

These are **decision counts**, not a claim that five values were admitted. The three Federation canonical course URLs were separately verified as bound and readable. The rejected Sydney fee proposal admits no fee by design. The Sydney conjoint decision requires its own outcome check before being reported as applied.

## Reusable read-only audit query

Run in the Supabase SQL editor. Use `L4B-%` for all skill-tagged batches, or replace it with one full prefix such as `L4B-20261028-1752%`.

```sql
select
  left(d.reason, 17) as batch_id,
  d.created_at as decided_at,
  d.id as decision_id,
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
where d.reason ilike 'L4B-%'
order by d.created_at desc;
```

For all Layer 4 activity—including non-skill manual and automatic decisions—remove the `where` clause and use date, actor, provider or category predicates instead. The batch prefix isolates skill-run decisions; it is not a universal Layer 4 marker.

## Open the supporting Evidence

Copy `evidence_id` from the audit row and paste it into the **Evidence** search box, which supports evidence IDs. This opens the original saved source and its canonical-use information. A null evidence id, as on the current conjoint-rule decision, means there is no artifact to open through this route; use the decision record, final value and batch checkpoint.

## Reconcile four different outcomes

Report these separately:

| Measure | What proves it |
|---|---|
| **Decided** | A row in `pipeline.layer4_decisions`, with stable decision and review-item ids. |
| **Cleared from waiting** | The same review item is no longer pending. This alone does not prove admission; it may be rejected or superseded. |
| **Actually admitted/applied** | The current canonical row matches the decision's intended outcome. |
| **Re-raised** | A newer pending item exists for the same entity and field after the decision. Treat it as new work or a defect, not as proof the original decision never happened. |

Canonical outcome checks by category:

- **Course link:** `catalogue.courses.course_url`, the reviewer row in `catalogue.course_links`, and `pipeline.coverage_course_pages` binding/read state. Note the separately recorded Federation apply-path issue: replaced links may remain active and a fresh read may not have been requested.
- **Fee:** current `catalogue.course_fees`; a rejected proposal is a completed decision with no admission.
- **Scholarship:** current `scholarship.scholarships` publication/lifecycle state and audience/value fields; verify duplicates separately.
- **Archive:** current `catalogue.courses.lifecycle_status`; never infer an archive merely from queue removal.
- **Conjoint/no-page rule:** the rule/no-page outcome and any newer pending item; the decision's `parent_url` alone is not proof of application.
- **Adapter rebuild:** queued and completed are different outcomes; use the existing task/build state and do not count a queued rebuild as admitted enrichment.

## Batch reporting rule

For each batch, reconcile the checkpoint to decision ids and current outcomes:

`baseline pending = decisions + still pending + superseded/otherwise resolved + newly raised adjustments`

Do not force this equation to hide exceptions. Record decision id and evidence id in future checkpoints alongside the stable review-item id so the batch remains portable across workstations.

## UI improvement path

Repair the existing **Layer 4 → Decided** view rather than adding a Layer 4 filter to Evidence or creating another panel. The existing view is the correct place for batch/date/provider/category filters and links to current outcomes and Evidence. Any Pilot change requires a decision record first; none is made by this audit.
