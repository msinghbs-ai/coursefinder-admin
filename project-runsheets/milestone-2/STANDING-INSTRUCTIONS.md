# Milestone 2 Standing Instructions — M2.2 onward

**Status:** AUTHORITATIVE MILESTONE-2 CONTINUATION CONTRACT  
**Effective:** 26 August 2026  
**Applies to:** M2.2 and every later M2.x / M2.x.y workstream unless a newer accepted governance document explicitly supersedes a clause.

## Why this file exists

CourseFinder M2 work is split across short chats and sub-milestones. The detailed task prompt may change, but the operating rules must not disappear when a new chat starts or one issue consumes the context window.

Every M2 continuation prompt and runsheet must explicitly inherit this file in addition to `PROJECT_INSTRUCTIONS.md`, `project-runsheets/milestone-2/EXECUTION-ADDENDA-A1-A6.md` and `project-runsheets/milestone-2/EXECUTION-ADDENDUM-A7-UAT-EFFICIENCY-REVIEW.md`, `project-runsheets/milestone-2/EXECUTION-ADDENDUM-A8-RELEASE-NOTES-SINGLE-SURFACE.md` and `project-runsheets/milestone-2/EXECUTION-ADDENDUM-A10-PAGED-FILTERS-TABLET-FOCUS.md`.

## Mandatory start-of-chat reconciliation

Before material work:

1. read `PROJECT_INSTRUCTIONS.md`;
2. read this `project-runsheets/milestone-2/STANDING-INSTRUCTIONS.md`;
3. read `project-runsheets/milestone-2/EXECUTION-ADDENDA-A1-A6.md`;
4. read `project-runsheets/milestone-2/EXECUTION-ADDENDUM-A7-UAT-EFFICIENCY-REVIEW.md`;
5. read `project-runsheets/milestone-2/EXECUTION-ADDENDUM-A8-RELEASE-NOTES-SINGLE-SURFACE.md`;
6. read `project-runsheets/milestone-2/EXECUTION-ADDENDUM-A10-PAGED-FILTERS-TABLET-FOCUS.md`;
7. read `change-control/README.md` and `change-control/REGISTER.md`;
8. read the latest Master Project Plan and Running Build;
9. read the latest accepted database architecture and Admin/PIM design decisions relevant to the task;
10. read the current milestone/sub-milestone `RUNSHEET.md`, `CURRENT-STATE.md`, `FOLLOW-UPS.md` and `NEXT-CHAT.md` where present;
11. read overlapping open/recent Change Controls;
12. reconcile current Pilot///Production implementation repository heads, deployed Supabase state and applicable CI/UAT before changing shared foundations.

Repository/runtime truth takes precedence over stale chat text. Do not overwrite newer parallel work.

## Delivery behaviour

- Work autonomously. Do not ask the user to perform routine technical UAT that can be automated.
- Implement/deploy where authorised, run bounded database/API/security/storage/Edge/browser UAT, retain evidence, and hand over only as PASS, BLOCKED with exact evidence, or explicitly DEFERRED.
- Do not stop the whole workstream because one issue is blocked. Record the blocker in the milestone `FOLLOW-UPS.md`, preserve evidence/next action/owner, and continue independent safe tasks.
- Before context becomes large, update the runsheet/current state/follow-ups and prepare the next continuation prompt from repo truth rather than chat memory.
- Every material observable change requires Change Control and exact implementation/UAT/rollback references.
- Maintain visible release notes/version when browser-facing behaviour changes.
- Keep Admin/PIM guides, Operations Runbooks and milestone records current as part of the gate, not as optional cleanup.
- Follow A1–A6 for test staging, primary navigation, shared test adapters, CI run control, UX/performance evidence and naming.
- Follow A7 for UAT harness efficiency. Review and tune test setup/coverage/runtime between every major milestone, and before substantial M2.4.1 feature work continues.
- Follow A8 for release/version presentation: the top-right version Release Notes overlay is the single operator-facing release surface; persistent footer/runtime feature markers are prohibited.
- Follow A10 for platform-wide filter performance and tablet behaviour: large option sets are server-paged/searchable at 10 items per page, dependent filters remain scoped, and touch/tablet dropdowns must not auto-focus search inputs.

## Authority model that must not regress

`Layer 1 Regulatory / Authoritative → Layer 2 Deterministic Enrichment → Layer 3 AI-assisted Evidence Interpretation → Layer 4 Human Resolution → governed Search/Publication consumer boundary`

- Layer 1 source identity/authority cannot be redefined by Layer 2/3/4 shortcuts.
- Layer 2 is deterministic acquisition/extraction and preserves native Evidence/version/provenance.
- Layer 3 consumes governed Evidence; model/profile/prompt changes require governed revalidation/benchmark; AI does not directly redefine Layer 1 identity or obtain uncontrolled canonical-write authority.
- Layer 4 is terminal human resolution under the accepted bounded mutation contract.
- Search, Publication, website and Zoho are derived consumers, not identity authorities.
- Broad Publication and Production cutover require their own accepted gates.
- Do not manufacture missing values or collapse source-null/zero/suppressed/not-applicable/not-yet-enriched states.

## Security-first acceptance

Security is the primary gate for every M2 sub-milestone.

At minimum reconcile:

- browser-executable RPC/API routes;
- `SECURITY DEFINER` functions;
- grants, RLS, views and exposed schemas;
- role/rank enforcement including negative/anonymous tests;
- private helper/table access;
- Edge/server auth;
- Storage/Evidence access;
- secrets/Vault/provider credentials and log leakage;
- third-party data exposure;
- rollback/restore impact.

No PASS with unexplained Critical/High findings. New WARN findings require explicit disposition. Never expose service-role keys, database credentials, provider secrets or private Evidence to browser/client code.

## Automated UAT standing matrix

The following checks remain mandatory where applicable, but execution order is governed by A1: **targeted validation → bounded integration → one nominated full acceptance matrix**.

Use applicable automated checks for:

- database integrity and frozen invariants;
- API/RPC contracts;
- RBAC/ACL negative paths;
- anonymous/insufficient-rank paths;
- Storage/private Evidence;
- Edge/server authentication;
- desktop browser;
- mobile browser;
- zero-call / no-op paths where required;
- replay/idempotency;
- retry/resume/revalidation;
- performance at representative scale;
- rollback-only consequential-action tests;
- restore/recovery where platform state changes;
- Search signal only after an accepted canonical change;
- regression against accepted prior milestone state.

Do not repeatedly use the complete permanent desktop/mobile matrix as the active-development feedback loop. Do not weaken tests or role boundaries merely to obtain a PASS.

## Data operations / UI principles carried forward from M2.2+

The Admin is an operational control plane, not a collection of experimental/raw-table tools.

Normal operator journeys should favour:

- simple Layer 1 / Layer 2 / Layer 3 / Layer 4 workspaces;
- management scorecards and clear health;
- queue and job state;
- progress bars and processed/accepted/rejected/unchanged/failed counts;
- next scheduled/allowed action;
- evidence/provenance one or two clicks away;
- retry/resume and blocker visibility;
- source freshness and verification;
- cost/credits/latency/storage where relevant;
- progressive disclosure for diagnostics.

Experimental/probe/reset/qualification controls must not dominate normal operations. Retain advanced controls only where governed and safely role-gated. Accepted operational features must use the primary navigation contract; permanent UAT must not depend on floating launchers or hidden Settings routes.

## Operational maturity standing requirements

Where applicable every ingestion/enrichment job must evolve toward:

- source/profile validation before execution;
- measurable record/page selection where source permits;
- governed queueing;
- duplicate/concurrent-run protection;
- heartbeat/stuck-job detection;
- progress and resumability;
- evidence/log lineage;
- reconciliation of creates/updates/unchanged/conflicts/rejections;
- scheduled rechecks based on source/profile cadence;
- hash/change detection to avoid unnecessary work;
- bounded retries/provider fallback;
- cleanup of transient jobs/nonces/temp state without deleting governed Evidence;
- retention/housekeeping policy;
- alerts for stale sources, failed runs, provider budgets and storage growth;
- cost/performance/throughput telemetry;
- current guides/runbooks/troubleshooting and bug-reporting workflow.

## Follow-up continuity rule

Each milestone/sub-milestone must maintain a durable `FOLLOW-UPS.md` or equivalent register. A discovered issue cannot disappear merely because it is outside the current fix.

Record at minimum:

- source sub-milestone;
- problem/decision;
- impact and security/data/operational risk;
- evidence/commit/run IDs;
- workaround if any;
- owner;
- exact next action;
- target sub-milestone;
- status.

Review open follow-ups at the start and end of every sub-milestone.

## Production boundary carried forward

Production is a separate clean trust boundary from Pilot. Production work includes separate Supabase project/credentials/Auth/Storage/vendor secrets, protected GitHub environment/CI-CD, Cloudflare Production deployment, monitoring, backup/restore/DR and final automated acceptance. Do not convert Pilot state into Production truth or bypass CI/CD/secrets controls for convenience.

## Programme/timekeeping constraints

- The engineering plan targets roughly 8–12 engagement hours per active week, but billable time is user-confirmed rather than inferred from chat duration.
- 16–30 September 2026 inclusive is a no-planned-delivery blackout unless separately authorised.
- Keep interaction/time logging separate from technical gate status.

## Handover rule

Before ending a substantial chat, update repo state so the next chat can continue without rereading the previous conversation. At minimum reconcile:

- RUNSHEET;
- CURRENT-STATE;
- FOLLOW-UPS;
- NEXT-CHAT;
- Change Control;
- Running Build/Master Plan only where programme state actually changed;
- UAT/run evidence;
- guides/release notes where affected.
