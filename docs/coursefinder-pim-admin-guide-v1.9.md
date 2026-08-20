# CourseFinder PIM Admin Guide v1.9

**UI:** PIM Admin v2.11.0 accepted  
**Effective:** 21 August 2026  
**Status:** **DEPLOYED / BROWSER ACCEPTED — CURRENT ADMIN OPERATING GUIDE**  
**Supersedes:** `docs/coursefinder-pim-admin-guide-v1.8.md`

## 1. Purpose and supersession

This is the current Admin operating-guide entry point after PIM Admin v2.11 deployed-browser acceptance.

All accepted field/business semantics documented in v1.8 remain in force unless explicitly changed below. The v1.8 sections describing the pre-v2.11 Cloudflare/browser blocker are historical and must not be treated as current programme status.

Final deployed browser acceptance:

`docs/uat/coursefinder-pim-admin-v2.11-final-browser-acceptance-2026-08-20.md`

## 2. Current browser boundary

The supported browser read path remains:

`Supabase Auth → public.admin_read(text,jsonb) → server-side role/rank check → governed internal read`

Rules:

- `public.admin_read` is SECURITY INVOKER;
- authenticated browser execution is permitted; anon execution is denied;
- no normal browser CRUD against internal schemas;
- legacy `public.ui_*` SECURITY DEFINER compatibility helpers are not to be reopened to authenticated users;
- client-side menu visibility is not a security boundary.

## 3. Role-aware workspaces

| Area | Minimum role |
|---|---|
| Overview / Catalogue / Insights / Scholarships / Search & Publication | assigned CourseFinder role |
| Review Queue / Evidence | Curator, rank 3 |
| Pipeline Control / Jobs / Sources | Pipeline Operator, rank 4 |
| PIM Configuration | PIM Admin, rank 5 |
| privileged platform/runtime actions | explicit server contract; normally Platform Admin or a separately governed role/action |

## 4. Current deployed Admin release

Accepted deployed source:

`msinghbs-ai/Coursefinder-Pilot@b3867cc89bbfd3f76def01993a70868318016ef0`

Visible marker:

`PIM Admin v2.11 · governed`

Accepted v2.11 operational UX includes semantic Dashboard hierarchy, bounded real-data grids, governed Provider/Course filters, responsive/off-canvas navigation, independently scrollable navigation, sticky decision-grid context and improved detail interaction.

## 5. Core semantic rules retained from v1.8

### Provider/Course identity

Stable governed source identifiers remain authoritative. Title/name matching is not a canonical identity mechanism.

### Course fees

Never collapse CRICOS registered total-course costs and Provider-current fee observations into one generic amount.

- CRICOS registered values retain regulatory basis/source/year semantics.
- Provider-current observations retain published year/basis/campus/intake scope and evidence.
- zero is not missing.

Reference Course `121174E` remains a required regression example: its registered fee section contains three rows including Non-Tuition Fee AUD 0; Provider-current remains empty unless a separately accepted Provider observation exists.

### Completeness, Search and publication

Admin readiness/completeness, canonical lifecycle/publication state, Search projection and publishing-channel state remain separate concepts.

### Evidence

Evidence is provenance, not a public file list. Private evidence/storage boundaries remain in force. Source-null, extraction state and freshness are diagnostics, not permission to manufacture facts.

## 6. Pipeline Operations baseline

The accepted v2.11 Pipeline area is a governed operational workspace for Pipeline Control, Jobs and Sources at Pipeline Operator+.

Current inherited rules:

- operational lists are server-paged/bounded;
- exact Pipeline Job identity can be searched where supported;
- Sources payloads for rank-4 users must not expose hidden adapter/system configuration or credentials;
- a failed job does not authorise direct browser mutation of canonical Provider/Course entities;
- Source → Job → Evidence links must preserve Evidence provenance and private boundaries;
- changes to the shared `admin_read` dispatcher must preserve all accepted route branches.

Dedicated follow-on governance:

`CF-CHG-20260821-016 — M1 Pipeline Operations governance baseline and operational acceptance`

## 7. Pipeline operational-action rule

Retry, replay, cancel, schedule, enable/disable, source mutation or similar operational writes are **not** implicitly authorised by the existing read contract.

Before such an action is promoted it requires:

- explicit server-side action/API contract;
- appropriate role check;
- deterministic idempotency or explicit replay-safety design;
- audit/change-history evidence;
- disabled/busy/double-click protection;
- bounded error/retry handling;
- rollback/reversion behaviour;
- proof that the browser cannot bypass the governed server action with direct internal-schema writes.

## 8. Current M1-PIPELINE-OPS handoff

Exact baseline:

`docs/coursefinder-m1-pipeline-ops-governance-baseline-v1.0.md`

The governance ambiguity that previously blocked M1-PIPELINE-OPS is resolved. The workstream may proceed to current-state technical reconciliation under `CF-CHG-20260821-016` without reopening accepted PIM v2.11 semantics or security boundaries.
