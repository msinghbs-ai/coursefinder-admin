# Milestone 2 Execution Addenda A1–A6

**Status:** AUTHORITATIVE EXECUTION ADDENDA  
**Effective:** 26 August 2026  
**Applies to:** M2.4 and every later M2.x / M2.x.y workstream unless a newer accepted governance decision explicitly supersedes a clause.  
**Origin:** M2.4 Go 7 integration/UAT disruption review.

These addenda extend, and do not replace, `PROJECT_INSTRUCTIONS.md` and `project-runsheets/milestone-2/STANDING-INSTRUCTIONS.md`.

## A1 — Automated UAT & Change Integration Discipline

Automated UAT remains mandatory, but execution must be proportional to the change and must not repeatedly run the entire permanent acceptance matrix during active development.

Every material implementation progresses through three stages:

1. **Targeted development validation** — run only tests directly affected by the change. Navigation changes test navigation and affected workspaces; DB/RPC changes test affected contracts; Layer-specific changes test that Layer and immediate authority/security boundary.
2. **Integration regression** — run a bounded suite covering the changed component plus immediate upstream/downstream dependencies. This must prove the accepted primary user journey before full acceptance starts.
3. **Full acceptance** — run the complete deployed desktop/mobile permanent matrix once against a nominated acceptance SHA. Full acceptance is a checkpoint/milestone gate, not the normal development feedback loop.

A later source change invalidates the nominated acceptance SHA and requires a new Targeted → Integration → Full Acceptance sequence.

Missing deterministic DOM/navigation elements should fail fast. Long timeouts are reserved for genuinely asynchronous ingestion, deployment, provider or backend operations.

Retries may diagnose transient infrastructure behaviour but must not hide deterministic application, selector, authorization or navigation failures. Never weaken tests, role boundaries, security or data-authority invariants merely to obtain PASS.

## A2 — Primary Navigation Contract / No Floating Operational Architecture

All production-shaped Admin capabilities must be reachable through the accepted primary information architecture.

Floating buttons, experimental launchers, DOM-injected controls and hidden Settings routes must not become permanent operational entry points.

A temporary launcher may exist only as short-lived development scaffolding and must:

- be explicitly temporary;
- not be the sole access path for an accepted feature;
- not be referenced by permanent UAT;
- be removed before acceptance.

Permanent UAT must traverse accepted user-facing navigation. For the current M2.4 model:

- `Data Operations → Layer 1 / Layer 2 / Layer 3 / Layer 4 / Evidence / Jobs / Onboarding`;
- provider/configuration authority belongs under `Governance & Platform`;
- operator documentation belongs under `Help & Guides`.

Experimental, qualification, destructive and diagnostic controls remain separated from routine operator workflows and stay role/rank protected.

## A3 — Shared Navigation/Test Adapter Contract

Permanent tests must not independently hard-code menu labels, floating launchers or workspace-opening sequences across many suites.

Maintain shared navigation adapters such as:

- `openLayer1()`;
- `openLayer2()`;
- `openLayer2Advanced()`;
- `openLayer3()`;
- `openLayer4()`;
- `openEvidence()`;
- `openOnboarding()`;
- `openGuides()`;
- `openGovernanceProvider()`.

Workspace-specific tests should test workspace behaviour, not obsolete launch mechanics. When information architecture changes, update the shared adapter once, run targeted navigation integration, then verify affected functional suites.

## A4 — CI Run Control

Intermediate development commits must not unnecessarily launch overlapping full deployed desktop/mobile matrices.

CI should evolve toward distinct tiers:

`targeted → integration → acceptance`

Only a nominated acceptance candidate should trigger the complete deployed matrix. If a newer candidate supersedes an active acceptance run, cancel the superseded run where practical.

Batch logically related implementation/test-alignment changes before launching full acceptance. Do not use a sequence of minor commits as a sequence of 20–30 minute permanent matrices.

## A5 — Operational UX / Performance Evidence

Maintain a dedicated lightweight audit suite separate from permanent functional acceptance for:

- menu/navigation inventory;
- page/workspace screenshot;
- page purpose and visible content;
- role visibility;
- relevance/duplication/obsolete content;
- UX recommendations;
- page/RPC timing and payload size;
- browser/server errors;
- responsive/mobile observation.

Store retained evidence under the applicable milestone evidence folder. The audit must not require the entire functional matrix to be rerun merely to refresh screenshots or page-content observations.

## A6 — Milestone / Addendum / Go Naming

Use the following hierarchy consistently:

- `M2.4`, `M2.4.1`, etc. = governed milestone/sub-milestone;
- `A1`, `A2`, etc. = permanent execution instruction addendum;
- `Go 7`, `Go 8`, etc. = execution batch/checkpoint only;
- `Go 7-R1`, etc. = repair/recovery within an execution batch;
- `CF-CHG-*` = formal Change Control.

Do not encode permanent governance rules only inside a Go prompt. Go records explain what happened; A-level addenda govern all later execution.

## Go 7 lesson retained

Go 7 changed the accepted primary navigation while older permanent suites still referenced `Layer 2 Operations` and the floating `M2.3 Intelligence` launcher. Missing deterministic selectors waited approximately 45–50 seconds and retried across many tests, creating long matrices and lost momentum. This is the canonical example for why A1–A4 are mandatory.
