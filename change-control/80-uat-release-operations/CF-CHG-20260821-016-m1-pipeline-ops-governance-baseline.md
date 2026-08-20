# CF-CHG-20260821-016 — M1 Pipeline Operations governance baseline and operational acceptance

**Status:** **PROPOSED — GOVERNANCE BASELINE RESOLVED / IMPLEMENTATION NOT STARTED**  
**Category:** `80-uat-release-operations`  
**Initiated:** 21 August 2026 09:04 AEST  
**Origin:** `M1-PIPELINE-OPS`  
**Owner:** CourseFinder Pipeline Operations  
**Affected surfaces:** `30-admin-pim-ux`, `70-security-platform`, Evidence provenance, Pipeline runtime/API contracts

## Trigger

`M1-PIPELINE-OPS` was blocked because the exact current governance-document baseline and overlapping Change Control state were not conclusively resolved.

The ambiguity was real:

- the authoritative register, Master Project Plan v1.54, Running Build v2.58 and `CF-CHG-20260820-015` classify the shared PIM browser gate as CLOSED / PASS;
- the detailed `CF-CHG-20260820-013` record still contained earlier `OPEN — deployed role-browser UAT pending` language;
- PIM Admin Guide v1.8 still described the pre-v2.11 deployed-browser blocker;
- the historical M1-PIM finalisation UAT is a valid point-in-time technical record but predates final deployed v2.11 acceptance.

This Change Control establishes the exact baseline for Pipeline Operations and prevents those historical status statements being treated as current programme state.

## Exact governance baseline

M1-PIPELINE-OPS must start from the following current governance set:

1. `PROJECT_INSTRUCTIONS.md` — authoritative cross-chat operating entry point;
2. `change-control/README.md` — Change Control routing/lifecycle rules;
3. `change-control/REGISTER.md` — current index;
4. `docs/coursefinder-master-project-plan-v1.55.md` — current programme handoff for Pipeline Ops;
5. `docs/coursefinder-running-build-v2.58.md` — accepted deployed build/runtime baseline;
6. `docs/coursefinder-database-architecture-v2.10.38.md` — current accepted Admin-read/role/dispatcher architecture;
7. `docs/coursefinder-admin-pim-design-decisions-v1.10.md` — current cross-chat Admin/PIM operating contract;
8. `docs/coursefinder-pim-admin-guide-v1.9.md` — current Admin operating guide entry point;
9. `docs/uat/coursefinder-pim-admin-v2.11-final-browser-acceptance-2026-08-20.md` — final deployed browser acceptance;
10. this Change Control.

Historical documents remain valid evidence for the state they recorded but do not override a later explicit supersession/closure record.

## Overlapping Change Controls

### CF-CHG-20260820-013 — operations role boundary

**State:** CLOSED / PASS for its original PIM scope.

Accepted contract inherited by Pipeline Ops:

- Pipeline Control / Jobs / Sources require Pipeline Operator+ (rank 4);
- browser reads enter through `public.admin_read`;
- safe Sources payloads must not expose source implementation configuration or credentials;
- no legacy authenticated `SECURITY DEFINER` browser compatibility surface is to be reopened.

Residual Pipeline-specific browser/action acceptance has been explicitly transferred to this record rather than left ambiguously inside the closed PIM gate.

### CF-CHG-20260820-015 — PIM operational UI/browser finalisation

**State:** CLOSED / PASS.

Pipeline Ops inherits the accepted v2.11 deployed browser/read/security baseline. It must not reopen the deployment-source incident or legacy RPC compatibility path unless a new regression is proven.

### CF-CHG-20260820-006 — Evidence provenance workspace

**State:** CLOSED / PASS.

If Pipeline Ops adds Source → Job → Evidence navigation or actions, Evidence provenance/security semantics remain authoritative. Evidence is not a generic public file list and private evidence boundaries must be preserved.

## Accepted implementation/runtime baseline

- deployed Pilot UI source: `msinghbs-ai/Coursefinder-Pilot`;
- accepted deployed head at handoff: `b3867cc89bbfd3f76def01993a70868318016ef0`;
- visible accepted release marker: `PIM Admin v2.11 · governed`;
- browser read boundary: `public.admin_read(text,jsonb)` SECURITY INVOKER;
- authenticated execute on `admin_read`: allowed;
- anon execute on `admin_read`: denied;
- public SECURITY DEFINER executable by authenticated/anon: 0 at accepted baseline;
- Pipeline read minimum role: Pipeline Operator rank 4;
- normal operational lists are server-paged/bounded rather than four-digit local-filter downloads.

These values must be rechecked against live state immediately before any mutation; this record does not freeze implementation state indefinitely.

## Scope constraints for M1-PIPELINE-OPS

Pipeline Operations may improve operational visibility and governed actions, but must preserve these boundaries:

- Provider/Course identity is not owned by the Pipeline workspace;
- failed/replayed jobs do not authorise direct browser mutation of canonical entities;
- source authority/evidence/versioning must be retained;
- hidden credentials, scraper tokens, adapter secrets and private source configuration must not be returned to normal rank-4 browser payloads;
- future retry/replay/cancel/schedule/enable-disable actions require explicit server actions and role checks;
- operational writes require idempotency/replay semantics, audit/change history, double-click protection and visible busy/error states;
- dispatcher changes must preserve Evidence and all other accepted `admin_read` routes rather than replacing unrelated branches;
- no broad authenticated execution of legacy `ui_*` SECURITY DEFINER functions is permitted as a compatibility shortcut.

## Required first implementation gate

Before applying a Pipeline Ops schema/RPC/UI/runtime change, the workstream must:

1. re-read the exact baseline above from current `main`;
2. inspect live Supabase Pipeline tables/functions/grants and current deployed Pilot code;
3. inventory current Source, Job, run-state, evidence-link and operational-action contracts;
4. classify proposed changes as read-only UI, operational server action, schema/API change or security change;
5. define bounded dry-run/UAT and rollback/reversion paths;
6. preserve overlapping Evidence/Admin contracts.

## Current decision

**The governance-document blocker is resolved.**

M1-PIPELINE-OPS is no longer blocked by baseline ambiguity. It is **READY FOR CURRENT-STATE TECHNICAL RECONCILIATION**, but no production Pipeline operation or permission change is authorised merely by this documentation repair.
