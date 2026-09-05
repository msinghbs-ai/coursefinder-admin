# CF-CHG-20260905-206 — Layer 4 Reusable Scholarship Scope Rules

**Status:** IMPLEMENTED / RUNTIME PASS / UI RELEASED v2.15.66 / CI PENDING  
**Milestone:** M2.4.5  
**Type:** FEATURE / OPERATIONS / ADMIN-PIM UX  
**Initiated:** 5 September 2026 13:26 AEST  
**Originating workstream:** CF M2.4.5 — Scholarships Acquisition & PIM Completion  
**Primary owner:** 30-admin-pim-ux  
**Related:** CF-205 Layer 4 mass operations

## Problem

CF-205 reduced 2,199 Scholarship Course-scope rows to 10 governed cohorts, but a future catalogue/detail refresh could recreate the same reviewed cohort. Operators should not repeatedly make the same decision when the Scholarship rule and retained first-party Evidence are unchanged.

## Decision

A reusable Layer 4 scope rule is conservative and Evidence-bound. It is keyed by:

- exact canonical Scholarship;
- exact candidate reason/rule wording;
- exact first-party Evidence ID;
- exact Provider;
- accept or reject decision.

A new Evidence ID deliberately does **not** inherit the old rule. The candidate returns to Layer 4 review so a changed Scholarship source cannot silently inherit yesterday's decision.

## Runtime

Private registry:

- `pipeline.layer4_scope_rules`

Guarded operations:

- `public.layer4_scope_rules_read(integer)`
- `public.layer4_scope_rule_save(uuid,text,text,text,text)`
- `public.layer4_scope_rule_apply(uuid,integer)`
- `public.layer4_scope_rule_set_state(uuid,boolean,text)`

Private trigger path:

- `security.layer4_scope_rule_apply_one_impl(uuid)`
- `security.layer4_scope_rule_candidate_trigger()`
- `trg_layer4_scope_rule_candidate`

When a new `needs_review` Course-scope candidate has the same Scholarship, candidate reason, Provider and Evidence ID as an enabled rule, it is automatically accepted/rejected according to that retained rule. Accepted candidates create a governed `scholarship.course_mappings` row with `mapping_basis=layer4_reusable_rule:<rule_id>` and the original Evidence. Rule use count and last-applied time are retained.

## Operator workflow

Layer 4 now contains **Reusable Scholarship scope rules** below the CF-205 cohort workspace.

1. Cross-check the first-party Scholarship rule and cohort sample.
2. Choose reusable Accept or Reject.
3. Record the audited source/rule reason.
4. Type exact live confirmation `SAVE RULE N`.
5. Optionally apply the saved rule to the current cohort.
6. Future exact-Evidence matches are resolved automatically.
7. Disable the rule with a reason if its operational use should stop.

No Course-by-Course rule authoring is introduced.

## Safety

- Pipeline Operator rank or higher is required to create/apply/enable/disable rules.
- Missing Evidence blocks rule creation.
- Provider mismatch blocks rule creation and application.
- Multiple Evidence versions in one cohort block rule creation.
- Changed Evidence never matches an old rule.
- Publication and Search admission remain separate.
- Underlying Evidence and candidate history are retained.
- CF-102 Provider Logo display, private signed access and cache behaviour are unchanged.

## Runtime baseline at implementation

- Current Scholarship Course-scope rows awaiting review: 2,199.
- Current cohorts: 10.
- Each current major cohort has one Evidence version and zero Provider mismatch.
- No reusable eligibility rule was automatically created during implementation; source semantics still require an operator decision.

## Source / replay

Pilot migrations:

- `supabase/migrations/20260905032600_cf_206_layer4_reusable_scope_rules.sql`
- `supabase/migrations/20260905033100_cf_206_layer4_scope_rule_state_control.sql`

UI:

- `src/layer4-scope-rules-entry.jsx`
- visible release `v2.15.66`

Contract:

- `tests/uat/cf-206-layer4-reusable-scope-rules-contract.spec.mjs`

## Implementation refs

- `6b75e37ed9cff77c3c8b580deea799c505f157db` — replay migration
- `e6b37201b11e3a2b7a3c13196ca135c01c455843` — rule state control
- `fcda4edf7e90e18009289fd59aaaa58428df4295` — reusable-rule UI
- `78e5f9d0bc9555bbfef54fe5692e2a0463c66195` — load UI / v2.15.66 title
- `a2e221f058ce2cff98b40bf99a7bdf7fca15e5ce` — v2.15.66 release currentness
- `67fb98dcad0cc435c20d093335913a0431b4ed4e` — source contract

## Rollback

The UI entry can be removed without deleting retained rule history. Rules can be disabled individually. Do not destructively delete a rule that has been applied; retain it for audit. Any incorrect accepted Course mappings require governed corrective Layer 4 action rather than deletion of audit history.

## Gate

Runtime schema/RPC/trigger deployment is PASS. No eligibility rule was created or applied to live cohorts during implementation. Final browser/build CI must pass before this record is marked CLOSED/PASS.
