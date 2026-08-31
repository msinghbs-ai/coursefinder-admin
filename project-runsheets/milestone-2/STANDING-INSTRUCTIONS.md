# Milestone 2 Standing Instructions — M2.2 onward

**Status:** AUTHORITATIVE MILESTONE-2 CONTINUATION CONTRACT  
**Effective:** 26 August 2026  
**Applies to:** M2.2 and every later M2.x / M2.x.y workstream unless a newer accepted governance document explicitly supersedes a clause.

## Why this file exists

CourseFinder M2 work is split across short chats and sub-milestones. The detailed task prompt may change, but the operating rules must not disappear when a new chat starts or one issue consumes the context window.

Every M2 continuation prompt and runsheet must explicitly inherit this file in addition to `PROJECT_INSTRUCTIONS.md`, `project-runsheets/milestone-2/EXECUTION-ADDENDA-A1-A6.md` and `project-runsheets/milestone-2/EXECUTION-ADDENDUM-A7-UAT-EFFICIENCY-REVIEW.md`, `project-runsheets/milestone-2/EXECUTION-ADDENDUM-A8-RELEASE-NOTES-SINGLE-SURFACE.md`, `project-runsheets/milestone-2/EXECUTION-ADDENDUM-A10-PAGED-FILTERS-TABLET-FOCUS.md` and `project-runsheets/milestone-2/EXECUTION-ADDENDUM-A12-CONTEXTUAL-INSIGHTS.md` and `project-runsheets/milestone-2/EXECUTION-ADDENDUM-A13-FILTER-STABILITY-L2-DEMO-TRACE.md`, `project-runsheets/milestone-2/EXECUTION-ADDENDUM-A14-L2-L3-TELEMETRY.md` and `project-runsheets/milestone-2/EXECUTION-ADDENDUM-A15-INSTITUTE-CONTACT-INTELLIGENCE.md`.

## Mandatory start-of-chat reconciliation

Before material work:

1. read `PROJECT_INSTRUCTIONS.md`;
2. read this `project-runsheets/milestone-2/STANDING-INSTRUCTIONS.md`;
3. read `project-runsheets/milestone-2/EXECUTION-ADDENDA-A1-A6.md`;
4. read `project-runsheets/milestone-2/EXECUTION-ADDENDUM-A7-UAT-EFFICIENCY-REVIEW.md`;
5. read `project-runsheets/milestone-2/EXECUTION-ADDENDUM-A8-RELEASE-NOTES-SINGLE-SURFACE.md`;
6. read `project-runsheets/milestone-2/EXECUTION-ADDENDUM-A10-PAGED-FILTERS-TABLET-FOCUS.md`;
7. read `project-runsheets/milestone-2/EXECUTION-ADDENDUM-A12-CONTEXTUAL-INSIGHTS.md`;
8. read `project-runsheets/milestone-2/EXECUTION-ADDENDUM-A13-FILTER-STABILITY-L2-DEMO-TRACE.md`;
9. read `project-runsheets/milestone-2/EXECUTION-ADDENDUM-A14-L2-L3-TELEMETRY.md`;
10. read `project-runsheets/milestone-2/EXECUTION-ADDENDUM-A15-INSTITUTE-CONTACT-INTELLIGENCE.md`;
11. read `change-control/README.md` and `change-control/REGISTER.md`;
12. read the latest Master Project Plan and Running Build;
13. read the latest accepted database architecture and Admin/PIM design decisions relevant to the task;
14. read the current milestone/sub-milestone `RUNSHEET.md`, `CURRENT-STATE.md`, `FOLLOW-UPS.md` and `NEXT-CHAT.md` where present;
15. read overlapping open/recent Change Controls;
16. reconcile current Pilot/Production implementation repository heads, deployed Supabase state and applicable CI/UAT before changing shared foundations.

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
- Follow A12 for contextual insight integration: QILT/PRISMS/country-equivalent statistics and Scholarships must be relationally surfaced on Provider/Course decision blades at their true source granularity, with provenance and explicit unavailable/not-mapped states.
- Follow A13 for stable Course/tablet filters and Layer 2 demo traceability: filter menus remain anchored to their trigger and the routine Layer 2 screen must expose automatic Direct HTTP → Firecrawl → fallback routing plus linked captured Evidence without fabricating screenshots.
- Follow A14 for standing Layer 2 / Layer 3 telemetry: scraper/provider route, retry, latency, vendor units/cost/Evidence/fall-out and model/profile/calls/tokens/latency/cost/validator metrics must be retained where supplied; unavailable usage is explicit and never manufactured.
- Follow A15 for accepted institute contact intelligence boundaries: first-party source authority, privacy, evidence/quality reconciliation and no automatic Search/Zoho admission remain protected.

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


## Long-running automation handoff rule

When a CI/UAT/deployment automation is expected to take more than about five minutes, or is still running after the substantive implementation and pre-gates are complete:

- do not hold the chat open merely waiting for automation;
- record the exact repository head, workflow/run IDs, current status and next decision rule in `CURRENT-STATE.md` and `NEXT-CHAT.md`;
- leave running workflows untouched unless they are superseded or clearly defective;
- end the chat with the exact pickup point;
- the next chat must check those run IDs first before creating another candidate or rerun.

This does not permit skipping a required gate. It only changes how long-running automation is handed across chats.

## A16 — Layer 3 contact coverage and Layer 4 governed intervention

M2 work after 30 August 2026 must also read and preserve `project-runsheets/milestone-2/EXECUTION-ADDENDUM-A16-L3-CONTACT-COVERAGE-L4-GOVERNED-INTERVENTION.md`.

A16 requires:
- explicit international-student/admissions contact-channel disposition for each governed Provider rather than treating a successful discovery run as a successful contact result;
- Layer 2 first-party acquisition/Evidence followed by Layer 3 Evidence-bound contact classification/extraction;
- Layer 4 human intervention through governed, auditable overrides rather than destructive rewriting of source/Evidence/history;
- field-level L4 marking, actor/time/reason/comment history and reversible/superseding decisions;
- publication overrides as separately role-gated consequential decisions;
- immutable/protected field classes and server-side editability enforcement.


## A17–A19 — Operations UX, Scholarship coverage and Scholarship scheduled ETL

M2 work after 31 August 2026 must also read and preserve:
- `EXECUTION-ADDENDUM-A17-OPERATIONS-UX-L2-WAVES-PRIMARY-NAV.md`;
- `EXECUTION-ADDENDUM-A18-COURSE-SCHOLARSHIP-COVERAGE.md`;
- `EXECUTION-ADDENDUM-A19-SCHOLARSHIP-SCHEDULED-ETL-MAINTENANCE.md`.

Standing requirements added by these addenda include bounded Layer 2 execution waves, parent-navigation operational registries, deterministic Course–Scholarship mapping only from explicit governed scopes, and scheduled Scholarship ETL/maintenance with Evidence/history retention.


## A20 — UniPIM-style information architecture and central Administration

M2 work after 31 August 2026 must also read and preserve `project-runsheets/milestone-2/EXECUTION-ADDENDUM-A20-UNOPIM-STYLE-UI-IA-CENTRAL-ADMIN.md`.

A20 requires task-first primary navigation, catalogue/data-quality/operator workspaces outside settings, one central Administration entry for configuration, grouped record cards, progressive disclosure for advanced/raw configuration, and backwards-compatible deep links where feasible.


## Canonical Admin navigation standard

The **current navigation registry implemented in the Pilot repository is the UI navigation source of truth**.

Authoritative implementation:
- `msinghbs-ai/Coursefinder-Pilot/src/mature-main.jsx`
- primary navigation: `NAV`
- backwards-compatible non-primary routes: `HIDDEN_ROUTES`
- page metadata / labels: `PAGE_META`
- route resolver: `routeFromHash()`

Standing rule for all future Admin/PIM UI work:

1. Extend or modify the canonical navigation registry first; do not create a parallel menu model in a feature component.
2. Routine user journeys must be reachable from the canonical primary navigation.
3. Configuration/settings must enter through the single `Administration` workspace unless a later governed design decision explicitly supersedes A20.
4. Feature-specific launchers/overlays may exist only as secondary affordances; permanent UAT must not require them.
5. `HIDDEN_ROUTES` are compatibility routes, not primary-navigation authority.
6. Any navigation change must update:
   - `NAV` / `HIDDEN_ROUTES` / `PAGE_META` as applicable;
   - A20 or its governed successor;
   - Admin/PIM design decisions;
   - desktop/tablet navigation UAT;
   - release notes where user-visible.
7. New menu items must be placed by user task/domain, not by implementation layer or developer convenience.
8. Do not reintroduce duplicate Settings/Sources/Attributes/Scheduling/Onboarding entries beside routine Catalogue/Operations work.
9. Repo/runtime truth overrides stale screenshots, chat assumptions or older menu documentation.


## A21 — Permanent Layer navigation and final Pilot placement

M2 work after 31 August 2026 must also read and preserve `project-runsheets/milestone-2/EXECUTION-ADDENDUM-A21-PERMANENT-LAYER-NAV-NON-FLOATING-FINAL-PILOT-UI.md`.

A21 makes the following a standing UI rule:
- Layer 1, Layer 2, Layer 3 and Layer 4 are permanent sibling routes under canonical Operations navigation;
- Layer 3 and Layer 4 are separate workspaces;
- floating launchers/dialog-only primary journeys are prohibited;
- the Pilot must present intended final placement rather than trial navigation experiments;
- normal workspaces must lead with concise status, meaningful KPIs, blockers and actionable controls;
- advanced configuration belongs under Administration/progressive disclosure;
- no new feature may add an independent visible root/menu model outside `src/mature-main.jsx::NAV` without a governed superseding design decision.


### Canonical navigation implementation guard

Post-render menu mutation is prohibited. Browser scripts, MutationObservers and feature entrypoints must not rename, hide or replace `src/mature-main.jsx::NAV` items after React renders them. Legacy navigation adapters may remain only as unloaded historical source until removed. Permanent deployed UAT must detect injected/legacy navigation markers.


### Catalogue filter stability guard

Filter restoration must not simulate user clicks. Saved catalogue filter/search/sort state must be restored directly in canonical component state. No popover may auto-open during restore/loading, and async option loading must stay anchored to the operator-selected filter. Legacy DOM-click screen-state restoration is prohibited.


## A22–A23 — Responsive detail blades and quota-aware Layer 2 background execution

M2 work after 31 August 2026 must also read and preserve:
- `project-runsheets/milestone-2/EXECUTION-ADDENDUM-A22-RESPONSIVE-DETAIL-BLADES-UI-ACCEPTANCE.md`;
- `project-runsheets/milestone-2/EXECUTION-ADDENDUM-A23-L2-QUOTA-AWARE-BACKGROUND-FIRECRAWL.md`.

Standing requirements:
- Provider/Course detail blades are responsive final workspaces with one reliable vertical scroll owner; desktop/tablet/mobile acceptance is mandatory.
- Layer 2 qualification sampling is a background source-quality/identity gate, never the production Course batch size.
- Layer 2 operator UI must not expose hard-coded qualification sample/wave/provider-routing knobs as the primary workflow.
- Layer 2 production execution is background/scheduled and quota-aware; current effective Firecrawl entitlement/reserve/rate/concurrency is read from runtime provider configuration.
- Firecrawl direct/scraper-first is the default effective production route under A23; no silent paid fallback.
- Qualification/production policy is edited centrally under Administration and shown read-only/effective in Layer 2 operations.
