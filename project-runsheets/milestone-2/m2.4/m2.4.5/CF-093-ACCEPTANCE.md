# CF-093 Acceptance Plan

**Status:** PHASE A PASS / PHASE B TARGET BUILDER ACTIVE  
**Updated:** 11 Sep 2026

## Accepted Phase A — Scheduled Tasks operator catalogue

Accepted Pilot main is `643eef810ab10ab9679ab6687ee549b0664c5691` after functional PR #67 and release-currentness PR #68.

- Visible Admin release: **v2.15.77**.
- PR #67 functional merge: `912572203e4f53ac081617b0ea567c9298cab84d`.
- PR #67 post-merge Release History `34550482710` — PASS.
- PR #67 post-merge Pilot Frontend Build `34550482729` — PASS.
- PR #67 post-merge Deployed UAT `34550482733` — PASS.
- PR #68 release-currentness merge: `643eef810ab10ab9679ab6687ee549b0664c5691`.
- PR #68 post-merge Release History `34553234972` — PASS.
- PR #68 post-merge Pilot Frontend Build `34553235073` — PASS.
- PR #68 post-merge Deployed UAT `34553235214` — PASS; desktop targeted governed validation PASS, mobile intentionally skipped by validation-tier routing.
- Production unchanged; no Production Supabase project exists.

Security Advisor after the Phase B runtime slice remains at the existing **191 INFO / 0 WARN / 0 ERROR** `rls_enabled_no_policy` baseline; no new warning/error was introduced.

## Phase B — target builder/orchestration

Pilot branch: `m245/cf093-target-builder-20260911`  
Pilot PR: **#69**  
Base: accepted v2.15.77 main `643eef810ab10ab9679ab6687ee549b0664c5691`.

### Runtime contract inventory

The current generic `refresh_policy_upsert_v2` is not sufficient as a universal target builder because it verifies only that a source/profile/entity identifier is present; it does not prove target qualification or that downstream workers enforce the requested country/state/entity scope. Therefore CF-093 must not expose it as a universal scheduler constructor.

The existing Layer 2 Course Facts control plane already provides server-enforced scope selection and execution:

- `layer2_scope_countries_service`;
- `layer2_scope_options_page_service`;
- `layer2_operator_scope_service` with `preview` and `start`;
- `layer2_scope_courses`.

The current Layer 2 scheduler dispatch is profile-wide. This means a country/state recurring schedule cannot be safely represented as one generic refresh policy without a separate scoped scheduler contract. University/provider scheduling may become eligible only when a selected Provider resolves to one verified qualified profile.

### First executable slice

Pilot runtime migration **`20260911021144 cf_093_scheduler_workflow_builder_slice`** is APPLIED and represented by the same repository migration identity.

It adds authenticated SECURITY INVOKER browser wrappers backed by independently rank-gated private bridges for:

1. server-authorised scope options;
2. consequential-run preview;
3. immediate governed dispatch.

The accepted implementation boundary for this slice is deliberately narrow:

- workflow: **AU Course Facts enrichment**;
- scopes: Country / State-Territory / University-Provider, using server-authorised catalogue/profile services;
- only executable processing mode: **Acquisition + deterministic Layer 2**;
- automatic generic L2 -> L3 -> L4 is disabled;
- governed Evidence reprocess is disabled and remains in Layer 3;
- recurring schedule construction remains disabled in this slice;
- Search/Publication are not triggered as an implicit ingestion consequence;
- every consequential run requires an operator governance reason and records a governed Jobs dispatch record.

## Phase B acceptance sequence

1. Exact runtime migration identity represented in repository history.
2. Security Advisor remains at no-new-WARN/ERROR baseline.
3. Source/contract tests prove rank boundary, preview-before-dispatch, unsupported mode denial, no generic policy-upsert shortcut and Jobs/Evidence follow-through.
4. Pilot Frontend Build and local browser smoke PASS.
5. Release History Contract remains PASS while accepted visible release stays v2.15.77 during candidate work.
6. Codex review of exact implementation head; actionable findings corrected with smallest-safe forward changes.
7. Preview/browser UAT proves Country, State and University selection and the disabled unsupported modes.
8. Runtime negative acceptance proves unauthenticated/low-rank denial and unsupported workflow/mode rejection.
9. Nominated run proves preview -> AU Layer 2 dispatch -> Job/Evidence follow-through without manufacturing Layer 3 or Publication work.
10. Only after functional acceptance: publish the next visible release, merge, run deployed UAT/security/currentness, then reconcile governance.

## Current gate

PR #69 head started at `216c2854f2e9d53df723e5c038aa0a064999cfc4`; Codex review has been requested. Release History Contract `34553879983` is PASS; Pilot Frontend Build `34553880058` was still running at the last recorded check.

Do not merge or bump the visible release until exact-head CI/Codex and targeted acceptance are green.
