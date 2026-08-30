# CourseFinder Layer 4 Governed Intervention Design v0.1

**Status:** WORKING DESIGN — M2.4.4 / A16  
**Date:** 30 August 2026  
**Change Control:** `CF-CHG-20260830-048`

## Recommended model

Use an append-only **Layer 4 override ledger** plus an effective-value projection, rather than allowing administrators to overwrite Layer 1/2/3 source rows directly.

Conceptually:

`source/history value → optional active L4 override → effective value → readiness/publication gate → downstream consumer`

This preserves both operator flexibility and evidence-grade traceability.

## Suggested persistence

A generic governed structure should support:

### l4_override_decisions

- `override_id`
- `entity_type`
- `entity_id`
- `field_path`
- `underlying_value_json`
- `override_value_json`
- `underlying_layer`
- `underlying_source_ref`
- `reason_code`
- `comment`
- `evidence_refs`
- `created_by_user_id`
- `created_at`
- `supersedes_override_id`
- `status` = active/superseded/reverted
- `decision_type` = field_override/publication_override/review_resolution
- `approval_context` where elevated approval is required

The exact schema may use typed per-domain tables where a generic JSON field would weaken validation. Field registry metadata should determine data type, permitted values, editability class and required role.

## Effective-value resolution

For each governed field:

1. resolve current underlying Layer 1/2/3 value according to existing authority;
2. find the latest valid active Layer 4 override for that entity+field;
3. if present, expose the L4 value as effective;
4. retain both underlying and override values in Admin read contracts;
5. mark `effective_source='L4'` / equivalent metadata;
6. on new upstream change, retain the override and create a revalidation signal rather than silently removing it.

## Publication

Publication should use an explicit decision record rather than a simple editable boolean.

A publication decision should capture:
- entity;
- target consumer/scope;
- readiness state at decision time;
- exceptions/overridden checks;
- actor;
- timestamp;
- reason/comment;
- expiry/review date where appropriate.

This prevents a normal data correction from accidentally becoming a release decision.

## Why this is preferable to direct edits

- preserves regulatory/source truth;
- supports forensic audit and rollback;
- makes human intervention visible rather than hidden;
- permits upstream refreshes without losing the human decision;
- supports field-level provenance in APIs/UI;
- gives Publication a separate control plane;
- allows stronger approval for high-risk fields.

## Implementation caution

Do not implement one unrestricted generic RPC that accepts arbitrary table/column/value input. Mutations must resolve through a governed field registry or typed mutation functions so the server controls which entities/fields are editable, validates values and enforces required role/approval.
