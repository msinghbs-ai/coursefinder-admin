# CourseFinder Master Project Plan v1.55

**Status:** **AUTHORITATIVE PROGRAMME GOVERNANCE — M1-PIPELINE-OPS GOVERNANCE BASELINE RESOLVED**  
**Supersedes:** `docs/coursefinder-master-project-plan-v1.54.md`  
**Last consolidated:** 21 August 2026 09:04 AEST  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.38.md`  
**Running build:** `docs/coursefinder-running-build-v2.58.md`  
**Pipeline Ops baseline:** `docs/coursefinder-m1-pipeline-ops-governance-baseline-v1.0.md`

## Current programme position

M1-PIM-FINALISATION remains **CLOSED / PASS**. PIM Admin v2.11 is the accepted deployed Admin baseline and its semantic/security boundaries are not reopened by this handoff.

The next Pipeline Operations workstream had been blocked by contradictory predecessor governance status. That blocker is now resolved and transferred to a dedicated Change Control.

## Exact current governance baseline

M1-PIPELINE-OPS must use:

1. `PROJECT_INSTRUCTIONS.md`;
2. `change-control/README.md`;
3. `change-control/REGISTER.md`;
4. this Master Project Plan v1.55;
5. `docs/coursefinder-running-build-v2.58.md`;
6. `docs/coursefinder-database-architecture-v2.10.38.md`;
7. `docs/coursefinder-admin-pim-design-decisions-v1.10.md`;
8. `docs/coursefinder-pim-admin-guide-v1.9.md`;
9. `docs/uat/coursefinder-pim-admin-v2.11-final-browser-acceptance-2026-08-20.md`;
10. `CF-CHG-20260821-016`.

## Governance ambiguity resolved

The following conflict was confirmed:

- `change-control/REGISTER.md`, Master Plan v1.54, Running Build v2.58 and `CF-CHG-20260820-015` closed the shared PIM browser gate;
- the detailed `CF-CHG-20260820-013` still contained earlier `OPEN — deployed role-browser UAT pending` language;
- PIM Admin Guide v1.8 still contained the pre-v2.11 browser blocker;
- the M1-PIM finalisation UAT was a valid point-in-time technical record but predated final browser acceptance.

Resolution:

- `CF-CHG-20260820-013` is CLOSED / PASS for its original PIM role-boundary/safe-Sources scope;
- residual Pipeline-specific rank-4 browser/action acceptance is transferred to `CF-CHG-20260821-016`;
- PIM Admin Guide v1.9 supersedes v1.8 as the current operating-guide entry point;
- final v2.11 browser UAT remains the current deployed acceptance authority;
- historical UAT/status records remain preserved as evidence for the state they recorded.

## Overlapping Change Controls

| Change | State | Pipeline Ops relationship |
|---|---|---|
| `CF-CHG-20260820-006` | CLOSED / PASS | preserve Evidence provenance/private boundary for Source/Job/Evidence links |
| `CF-CHG-20260820-013` | CLOSED / PASS | inherit Pipeline Operator rank 4, safe Sources projection and `admin_read` boundary |
| `CF-CHG-20260820-015` | CLOSED / PASS | inherit accepted v2.11 deployed browser/security/runtime baseline |
| `CF-CHG-20260821-016` | PROPOSED — baseline resolved | owns M1-PIPELINE-OPS changes and acceptance |

## Accepted Pipeline starting contract

- Pipeline Control / Jobs / Sources require Pipeline Operator+ rank 4;
- browser reads use `public.admin_read(text,jsonb)`;
- internal schemas are not browser CRUD surfaces;
- rank-4 Sources payloads must not expose credentials/hidden implementation configuration;
- operational grids remain bounded/server-paged;
- failed jobs do not permit direct canonical Provider/Course edits from the browser;
- shared dispatcher changes must preserve independently accepted Evidence and other routed operations;
- no broad authenticated legacy `ui_*` SECURITY DEFINER compatibility path may be restored.

## Implementation authority at handoff

Accepted deployed Pilot source/head at this handoff:

`msinghbs-ai/Coursefinder-Pilot@b3867cc89bbfd3f76def01993a70868318016ef0`

Accepted visible marker:

`PIM Admin v2.11 · governed`

The Pipeline Ops workstream must recheck the Pilot repository, governance repository and live Supabase state immediately before implementation so newer parallel work is not overwritten.

## M1-PIPELINE-OPS current gate

**Governance baseline:** PASS / RESOLVED.  
**Implementation:** NOT STARTED under `CF-CHG-20260821-016`.  
**Next required gate:** current-state technical reconciliation of live Pipeline schemas/functions/grants, deployed UI contracts and Source → Job → Evidence relationships.

No production Pipeline, ACL, source configuration or canonical-data change was made by this governance reconciliation.
