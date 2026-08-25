# CourseFinder Milestone Governance Standard v1.0

**Status:** CURRENT  
**Date:** 25 August 2026  
**Change Control:** `CF-CHG-20260825-031`

## Purpose

Every CourseFinder milestone must be reviewable from a single durable record without depending on chat memory. A milestone is complete only when outcome, security, data authority, implementation, UAT, evidence, operations and residual risk are reconciled.

## Required milestone structure

### 1. Milestone identity

- milestone ID and title;
- business/platform objective;
- start date and target completion window;
- owning workstream;
- related Change Controls;
- dependencies and predecessor gates.

### 2. Intended use cases

State concrete operator/user use cases before implementation. Each use case must identify:

- actor/role;
- starting state;
- action;
- expected system decision;
- evidence/traceability required;
- failure/escalation behaviour;
- downstream consequence.

### 3. Architecture and authority

Document:

- authority layer and source precedence;
- identity key/grain;
- schema/RPC/API/storage impact;
- evidence/versioning rules;
- Search/publication consequence;
- what the milestone is explicitly forbidden to redefine.

### 4. Security gate — primary

Every milestone must answer:

- what new trust boundary or privileged action exists?;
- what roles can read/run/change it?;
- what credentials/secrets exist and where are they stored?;
- what browser-executable RPC/API routes changed?;
- what RLS/grants/views/functions/storage policies changed?;
- what abuse cases were tested?;
- what new third-party/vendor data leaves CourseFinder?;
- what security findings remain and who accepted them?;
- what rollback contains the security impact?

No milestone may be called PASS with an unexplained Critical/High security finding.

### 5. Implementation task table

Every task row must contain:

| Field | Meaning |
|---|---|
| Task ID | stable milestone-local identifier |
| Workstream | schema/backend/UI/security/ops/data/UAT/docs |
| Task | precise deliverable |
| Dependency | predecessor or required state |
| Owner | accountable role/workstream |
| Target | date/window |
| Status | not started / active / blocked / pass / deferred |
| Implementation ref | migration/commit/PR/function/page |
| UAT ref | automated test/run/artifact |
| Risk | security/data/operational risk |

### 6. Automated UAT matrix

Minimum applicable suites:

- database integrity;
- API/RPC contract;
- ACL/RBAC/negative authorisation;
- storage access;
- Edge/server function auth;
- desktop browser;
- mobile browser;
- performance at representative scale;
- replay/idempotency;
- rollback/restore;
- regression against frozen invariants.

Human-only UAT is reserved for judgment that cannot reasonably be automated.

### 7. Measured scale and economics

Where applicable record:

- records/entities/pages processed;
- latency/duration;
- success and factual-resolution rate;
- retry/fallback rate;
- storage growth;
- vendor/API units;
- cost per processed entity;
- cost per successfully resolved entity;
- queue fall-out to the next authority layer.

### 8. Operations and supportability

Before closure define:

- daily/weekly/monthly checks;
- alerts/thresholds;
- retry/resume behaviour;
- runbook/troubleshooting path;
- backup/restore impact;
- bug-report fields;
- break-glass process where applicable.

### 9. UX acceptance

For an Admin capability verify:

- role-appropriate menu placement;
- status/next action is obvious without schema knowledge;
- tables are filterable/sortable/paged where appropriate;
- evidence/source context is one or two clicks away;
- destructive/consequential actions show impact;
- desktop/mobile acceptance;
- advanced diagnostics use progressive disclosure.

### 10. Closure decision

Allowed final gate states:

- **CLOSED / PASS** — all mandatory criteria met;
- **BLOCKED** — unmet mandatory criterion with evidence;
- **DEFERRED** — explicitly outside milestone with owner/next gate;
- **REJECTED** — approach not accepted;
- **SUPERSEDED** — replaced by named later decision.

Closure must include:

- final deployment SHA/migration state;
- final UAT run IDs/artifact digests;
- final counts/scale/cost where applicable;
- residual risks;
- rollback;
- next milestone/gate.

## Standing milestone meeting agenda

Use this table as the recurring programme review:

| # | Question | Required output |
|---:|---|---|
| 1 | What capability was the milestone meant to establish? | one-sentence objective |
| 2 | What use cases now work end-to-end? | accepted use-case list |
| 3 | What changed in architecture/data authority? | before/after |
| 4 | What changed in security/trust boundaries? | threat/control summary |
| 5 | What code/schema/runtime was deployed? | exact refs |
| 6 | What UAT passed? | automated matrix + run refs |
| 7 | What scale/cost/storage was measured? | KPI table |
| 8 | What does the operator see in Admin? | menu/workspace/version |
| 9 | How is it monitored and restored? | runbook/alerts/rollback |
| 10 | What failed or was deliberately rejected? | lessons/negative evidence |
| 11 | What risks remain? | residual-risk register |
| 12 | Can this milestone close? | PASS/BLOCKED/DEFERRED |
| 13 | What exact gate comes next? | next milestone + entry criteria |

## Naming convention going forward

Use milestone IDs that communicate capability rather than implementation sequence alone. Recommended pattern:

`M2.2 — SECURITY-PROD-FOUNDATION`  
`M2.3 — L2-SCALE-ENRICHMENT`  
`M2.4 — L3-AI-OPERATIONS`  
`M2.5 — PROD-READINESS-CUTOVER`

Future major milestones should continue the same pattern, with each workstream prompt referencing `PROJECT_INSTRUCTIONS.md`, the current milestone record and this standard.
