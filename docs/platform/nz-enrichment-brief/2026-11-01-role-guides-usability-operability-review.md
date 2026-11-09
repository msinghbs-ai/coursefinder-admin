# StudySearch — Role guides, usability and operational maintenance review
**Date:** 1 November 2026 (AEDT)  
**Status:** Assessment complete; recommendations proposed, not implemented.  
**Mandate:** Assess the guides for each role against UI, features and scripts needed to operate and maintain the platform; record expansion and retirement recommendations in the admin repository.  
**Reviewer:** ChatGPT, independent review of connected Platform Admin session and repository sources.

## 1. Verdict
**The platform has substantial operational capability, but its guides and some completion paths do not yet form a dependable, consistent operating contract.** Keep the existing platform architecture and its consolidated screens. Correct the contradictions and incomplete journeys before expanding the toolset.

The strongest existing capabilities are role-based navigation, generated SOPs, source/evidence provenance, settings controls, job monitoring, an operational scorecard, scoped settings/publishing recovery, deployment helpers and governed retirement. The weakest points are:
1. guidance which says it was reviewed for the current release but describes old or contradictory behaviour;
2. Layer 4 work which cannot be completed entirely from the consolidated review surface;
3. release/recovery and retirement controls whose presentation or script checks are weaker than the documented promise;
4. role-specific tasks not verified end to end at the role that must perform them.

**No blanket operational-readiness or RBAC certification is given.** Only a Platform Admin session was available. Viewer, Counsellor, Curator, Pipeline Operator and PIM Admin permissions were reviewed from source and guides, not exercised using their accounts. This was a usability and operability assessment, not a penetration test, full code audit, restore drill or new settlement batch.

## 2. Baseline and evidence method
- Live UI observed: **v2.15.389**, authenticated Platform Admin.
- Source search results resolved Pilot main to **ef64ad47a7f84a2e216facdbd8b42902b0601c5d**; release manifest reads v2.15.389 / package 0.1.316, state candidate.
- Admin search references resolved to **a6b9cc9efe53a9205edb92e6eaf5b9b2c062b1a5**. Files fetched from main can move during concurrent engineering; file blob SHAs are listed in §10 where retained.
- Read the canonical operating model, current INDEX and Pilot CLAUDE.md. Inspected guide sources, both SOP mirrors, navigation, representative application components, selected CI helpers/workflows, test guards and the published test register.
- Live read-only walkthrough: Guides / Platform guide; Scheduled jobs / Automations; Platform health / Health checks, Alerts, scorecard and Screen use; Settings section headings; Backup & restore (expanded its collapsed card and inspected the backup list and presence of diff/restore controls). Layer 4 queue and source were assessed with the 118-card review already recorded in this same chat.
- Did not change roles, keys, budgets, schedules, publication, catalogue values, holds or jobs. Did not execute deployment, restore, re-read, AI, paid processing or database commands. Navigation and expansion of a card are not functional-write tests.
- The Platform Admin reports prior blockers have been worked out. Earlier timeout and ANU findings are **historical regression cases**, not asserted as still-live defects without a new reproduction. This assessment does not certify their remediation or reopen them merely from old evidence.

### Evidence labels
**Observed** = visible in the current authenticated UI. **Source-confirmed** = directly supported by inspected code/documents. **Needs verification** = insufficient evidence for a runtime conclusion. A passing contract or a version stamp is not proof that a person can finish the workflow.

## 3. Role-by-role fitness

| Role | Operational requirement | Existing support / positive evidence | Gap and assessment | Required acceptance walkthrough |
|---|---|---|---|---|
| Viewer, rank 1 | Find a course/provider, understand provenance, distinguish published and waiting data, inspect an answer without editing | Platform guide, Catalogue and four AER workspace tabs described; nav and guide tests include rank-1 paths; AER guide §2 explains quotes/history and the rank-3 Evidence boundary | **Partially demonstrated.** Guide contains coverage advice; no live Viewer account tested. Stored-copy access intentionally needs a higher role: explain this at the link rather than an unexplained redirect | Find by code; inspect quote and publication state; inspect resolution for two countries; confirm no edit/write controls and clear explanation for restricted Evidence |
| Counsellor, rank 2 | Search, compare, shortlist, use contacts, communicate source limitations and report errors | Role summary names shortlists/notes; AER integration guide prohibits eligibility conclusions; SOP describes counsellor-report outcome in Zoho | **Partially documented.** The in-app guide gives only a short daily list. End-to-end shortlist/report/Zoho outcome was not exercised | Find a course, shortlist, read scholarship estimate and no-scale requirement, report a wrong value; see received/fixed/not-changed outcome without admin access |
| Curator, rank 3 | Correct sourced facts, preserve manual provenance, settle eligible review kinds, escalate AER and policy conflicts correctly | Operator SOP, AER edit/add/quarantine/restore guidance, Layer 4 choices and reasons; navigation separates privileged tabs | **Needs improvement.** Generic “Layer 4 decisions” role wording must explicitly except AER approval; review cards often omit necessary evidence/destination links. AER guide explains the boundary better than the general guide | Correct one fixture-backed active row; stale-edit refusal; settle one non-AER fixture; AER decision disabled with next owner; validate saved correction and consumer follow-through |
| Pipeline Operator, rank 4 | Diagnose queues and worker errors, start permitted work, escalate controls requiring rank 5/6 | Jobs/Task manager, role-labelled SOP tasks, live jobs and error visibility | **Contradictory instructions.** SOP tells rank 4 to pause jobs and lower per-run size; inspected automation control requires at least rank 5, then per-job control rank. Do not widen access to make the prose true | Read failure; acknowledge permitted error; start a permitted task; receive clear handoff for pacing/pause; no forbidden action succeeds |
| PIM Admin, rank 5 | Pace/pause supported automations, create catalogue records, test adapters, hand off admission | Role summary and builder nav min 5; source/registered tests distinguish testing from admission | **Partially demonstrated.** Stale “priority queue” ownership, legacy tab names and broad guide links complicate tasks. Server permissions were not replayed live | Pause/resume a disposable test task, adjust an allowed setting with reason, test adapter without admitting, hand off field approval |
| Platform Admin, rank 6 | Approve admissions, control service budgets/models, manage users, recover errors and release safely | Live health/alerts; settings headings cover operational controls; 11 daily backups visible; source shows scoped restore, reason and before-restore backup; canonical governance and CI | **Strong breadth, incomplete consistency.** Alert/admission guide contradictions, mirror drift, retirement presentation, recovery baseline and helper checks need correction | Approve a fixture-backed item, verify exact destination and audit; inspect current limits; confirm alert receipt; compare scoped backup; rehearse release recovery in isolated environment |

Integration owner and incident responder are **operational responsibilities**, not additional RBAC ranks. Keep the AER role guide’s integration and incident sections, but expose their applicable task links from Guides. Do not create parallel permission systems.

## 4. Findings and proposed changes
IDs below identify this review only; they do not create a competing SS execution register. Attach accepted work to existing SS tasks where it belongs, or allocate new SS IDs through the canonical register.

### UR-01 — Current version stamp does not mean current operational guidance
**Priority P1 · Source-confirmed and observed · Improve.**  
Sources: Pilot `src/guide/platformGuide.js`, `src/guide/sops.js`; live Guides.
- Guide says Mailgun email is planned and alerts are on screen only.
- Live Health shows external delivery on, by the alert scheduled task, and three delivered test/recovery alerts.
- Admin `OPERATIONAL-LIMITS.md` v1.3 documents D12 push/e-mail delivery and its expected delay, cooldown and reminder rules.
- Guide’s alert table describes first detection/daily behaviour rather than the implemented 15-minute confirmation, cooldown, reminder and recovery model.

**Action:** replace the obsolete Mailgun/on-screen-only narrative with current D12 ownership, destination mechanism, expected latency, failure/retry and receipt-verification instructions. A “Delivered” state is not proof the recipient read/received a notification. Preserve the pending receipt check in SS-014. Retire the obsolete delivery proposal text, not the working alert task.

**Accept:** guide and health screen agree on delivery mode, timing, acknowledgement and recovery; a safe test case explains raised, collected/delivered and receipt-confirmed separately.

### UR-02 — Operator task instructions exceed the documented control role
**P1 · Source-confirmed; live lower-role check required · Correct documentation before considering policy change.**  
Sources: Operator SOP interventions and start-of-day steps; Platform guide SIGNALS/ROLES; migration `20261013012900_cf247_all_controls_in_settings.sql`.
The SOP says Pipeline Operator can pause after repeated failures and recommends lowering batch size. The inspected control function begins with an authenticated rank-5 floor and then checks the job’s control rank. The general role summary itself assigns pause/pace to PIM Admin. Later function edits and the live definition must be checked before definitive RBAC sign-off.

**Action:** write “Operator diagnoses/records/escalates; PIM Admin or permitted higher role changes pace/pause; Platform Admin for rank-6 controls”. Show the minimum effective action role beside the control. Do not grant broader rights merely to match an outdated SOP.

**Accept:** rank-4, rank-5 and rank-6 walkthroughs match the action-specific server boundary; denial names the next owner.

### UR-03 — Admin-repo SOP copies are stale
**P1 · Source-confirmed · Expand existing synchronisation.**  
Admin `docs/sops/admin-sop.md` v1.56 and operator v1.53 say reviewed for **v2.15.373**; Pilot generated copies and source say **v2.15.389** with the same SOP versions.
`scripts/export-sops.mjs` writes only the Pilot copies; copying to admin is a separate instructed step. S22 checks Pilot export equality, not the admin mirror.

**Action:** add a controlled publish/compare stage to the existing export/release process. Record source commit, reviewed release and content digest in the mirror. Avoid a new document generator or permanent poller. Separate “content version” from “reviewed release”; a no-step-change release may keep the content version but must synchronise review metadata.

**Accept:** a deliberately stale mirror is detected; both copies regenerate identically from the same source; cross-repo write conflicts fail clearly rather than overwriting concurrent work.

### UR-04 — By-kind review cannot traverse more than the first 200 items
**P1 · Source-confirmed · Expand existing Layer 4 list.**  
`src/Layer4Inbox.jsx` requests `items` with limit 200 in both item modes. When total exceeds returned rows it renders “Showing … of …”; only the university list has Previous/Next controls. There is no corresponding item-list pagination in this component.
This matters for kinds such as AER and Adapter has nothing ready whose observed counts exceed 200.

**Action:** add server-supported stable cursor/pagination to the existing item list with an explicit oldest-first order and unique tie-breaker. Restore current kind/provider/filter/position after destination navigation and a saved decision. This requires confirming/extending the backend read contract; do not simply raise the cap or bulk-settle.

**Accept:** >200 mixed pending fixture items are all reachable exactly once during a pass; concurrent decisions/new arrivals do not cause hidden starvation or duplicate writes.

### UR-05 — Reviewer evidence and correction destinations are incomplete
**P1 · Observed earlier in this session, source-confirmed · Expand current cards.**  
118 Course link cards were consolidated and recorded in `2026-11-01-course-link-118-review-register.md`. Eighty had no clickable source/evidence links, although three had policy addresses as plain text; 38 displayed URL pairs without stored-copy quotes. This is not proof evidence is absent elsewhere.
The component renders source/copy/rows for AER, but course-link cards depend on before/proposed URL values; fee cases have only a generic hint. Cards expose a kind attribute, not an item-ref attribute.

**Action:** give each relevant card a stable review reference, source/capture date, newest-copy indicator, evidence link, manual-lock/ownership indicator, exact current/proposed values and an “Open record” correction route. Fee and English conflicts need amount/year/basis or score/test/scope, not just generic link choices. Reuse the existing course evidence overlay; do not add another review console.

**Accept:** a reviewer can prove a decision from held evidence and finish linked corrections without external page acquisition or searching the whole evidence store. Treat earlier timeout cases as regression fixtures, not an assumed current outage.

### UR-06 — “Done” must expose the actual settlement result
**P1 · Source-confirmed; previous successful UI decisions observed · Expand existing response/status.**  
Layer 4’s completion handler shows generic `returns`, reloads summary/items and removes the card. This verifies closure but does not itself show destination values or AER admitted/excluded/superseded/retained counts.

**Action:** expose existing decision/audit identifiers and actual affected counts in the completion result, with a link to the destination and evidence. Distinguish admitted, reconciled without admission, deferred and queued downstream work. Do not infer admission from navigation, read-again requests or a disappearing card alone.

**Accept:** all existing choice routes have a verifiable outcome; uncertain responses can be reconciled by reference before retry. Extend existing audit/decision contracts; do not duplicate the event store.

### UR-07 — Retired jobs still present ordinary Resume and schedule controls
**P1 · Observed · Improve retirement presentation and verify server protection.**  
Scheduled jobs shows “Review rule: sources disagree” marked RETIRED/paused with Resume and frequency controls. A retired onboarding snapshot also appears with Resume.
Rule 4’s recorded logical retirement and revoked execution are positive safeguards; this review did not attempt to bypass or re-enable them.

**Action:** show Retiring/Retired as distinct from “Paused by a person” and “Paused while idle”. Hide or disable operational controls for retired components; explain replacement, history and removal date. Ensure area-resume cannot resurrect retired components. Retain historical run/evidence access.

**Accept:** retired jobs cannot be resumed through single-job or area controls; legitimately paused active jobs remain recoverable. No destructive deletion in this review.

### UR-08 — Automation ownership descriptions disagree
**P1 · Observed and source-confirmed · Update existing guides/catalogue text.**  
SOP automation stage 4 says central-page proposals write nothing before a person decides; live Automations includes a running “Approve checked AI readings of central pages” job for focus providers. Onboarding catalogue text says it stops at Ready to admit for a person while the SOP describes admission while an automatic-admit switch is enabled.

**Action:** describe each conditional path accurately: read/propose, qualify, automatic approval/admission under an already-authorised switch and scope, and explicit human decision. Link the controlling setting and approval record. Do not change the switches during documentation repair.

**Accept:** an operator can identify why a particular provider auto-admitted or is waiting, using the same labels in the guide, job catalogue and UI.

### UR-09 — Legacy names and click destinations impose avoidable recovery work
**P2 · Source-confirmed and observed · Consolidate.**  
General guide prose still names Layer 2 Adapters/Onboarding, Scholarships Extraction and retired priority ownership. Navigation already has aliases for these. SOP Open buttons check `canOpen(page,rank)`, not the requested tab; a user may be allowed the parent page but not the named tab, which the router substitutes.

**Action:** retire legacy names from current instructions; retain redirect aliases for saved links. Validate page+tab+filter+minimum role, not page existence alone. Critical task links should open the exact working section and provider/kind. Mark a cross-role handoff rather than silently falling back.

**Accept:** current task links land at their stated destination at each applicable rank; old external bookmarks still resolve safely.

### UR-10 — Budget guidance confuses observation and enforcement
**P2 · Source-confirmed · Improve.**  
One signal says OpenRouter work stops at the floor; the duties/SOP describe Observe mode where guards only notify. AER also has specific programme/spend gates. Static “100 now”, daily-credit and timing figures in instructions drift from configurable settings.

**Action:** explain effective mode and lane-specific gates, including provider/API refusal versus platform guard. Link to live values rather than repeating operational constants in prose. Use one task table for who can view, propose and change each class of control.

**Accept:** for a sample refusal the operator can identify which actual gate stopped work and who may change it; no instruction implies a stopped lane when it is observation only.

### UR-11 — Operational snapshots need consistent freshness and completeness labels
**P2 · Observed and source-confirmed · Expand existing metrics.**  
Health displayed current checks alongside older coverage diagnostics. The scorecard appropriately says T5 is measured at report time and shows its capture time; its 1,175 backlog is not the live Layer 4 count observed at 1,869. The canonical execution register’s current Layer 4 line also carries older figures; INDEX current-state header remains 31 Oct/v2.15.382 despite live v2.15.389.

**Action:** keep current versus snapshot counts clearly separate, show capture time per metric, and mark incomplete/stale data. Reconcile the execution register/INDEX from authoritative checkpoints. Change “rising queue means reviewers are behind” to include new arrivals, inaccessible evidence, repeated defects and downstream dependencies. “AER has no reader yet” should name the affected coverage measure/country/lane and observation time, not imply there is no AER implementation.

**Accept:** two different capture windows are never presented as the same baseline; absent evidence is not counted as healthy or complete. Avoid creating another progress dashboard.

### UR-12 — Low screen use alone is not a retirement criterion
**P2 · Observed · Retain existing screen-use telemetry with stronger decision criteria.**  
Health’s 14-day screen-use view labels unopened screens candidates to retire; Course sources had no opens and SOPs/Work queues had few. Maintenance and incident features are deliberately infrequent; counts can also reflect discoverability.

**Action:** require purpose, unique operational coverage, dependency/replacement, actual consumers and an isolated walk-through before retiring. Add context to the existing component register; do not retire recovery, audit or role controls just because usage is low.

**Accept:** every retirement has a named replacement or an explicit approved removal of the responsibility, plus safe redirects/history.

### UR-13 — Already-applied migrations skip checksum verification
**P1 · Source-confirmed · Harden existing helper.**  
`scripts/ci/apply-migration.sh` checks whether the version exists and immediately exits “already applied; skipped”. The md5 comparison occurs only after a newly applied migration. This is narrower than the documented expectation of history/file equality.

**Action:** compare the existing history statement checksum with the repository file **before** skipping; refuse a mismatch and leave the database unchanged. Preserve a legitimate idempotent replay when identical. Retain the transactional history write and fail-fast behaviour. Do not modify applied migrations to resolve a mismatch.

**Accept:** absent version applies once; identical version safely skips after comparison; changed same-version file fails before any execution; history lookup/error/normalisation cases produce an actionable report. Extend existing CI/script guards rather than create another migration runner.

### UR-14 — Recovery authority is far behind the candidate release
**P1 · Source-confirmed; recovery fitness not tested · Review, do not silently promote.**  
`src/release-manifest.js` marks v2.15.389 candidate, while `RECOVERY_RELEASE` points to accepted v2.15.79 (14 Sep). Release verification checks the manifest relationships, not whether that old UI/function set is compatible with today’s additive schema and operational state.

**Action:** Platform Admin/release owner must establish a usable recovery plan with commit/artifact references, database compatibility, forward-fix steps, affected consumers and a tested boundary. If a recent release becomes accepted, record that decision explicitly; do not mark every latest build accepted automatically. Extend the existing runbook/manifest, not a second recovery mechanism.

**Accept:** isolated recovery rehearsal and documented verification prove the chosen path; old-schema assumptions are identified before an incident.

### UR-15 — Backup feature is useful but its scope is narrower than platform disaster recovery
**P2 · Observed and source-confirmed · Retain and clarify.**  
After expanding the collapsed Backup & restore card, daily backup 11 (1 Nov 06:50) was present, with 2,825 published providers, 277 unpublished and 501 settings; Compare/Restore, Download SQL and the reason-gated restore section exist. Source takes a before-restore backup and supports chosen rows/providers/settings.
This feature covers publishing/settings, not proof of database, Evidence objects, service credentials or whole-platform restoration.

**Action:** make “Expand to compare the latest backup” obvious or default the active recovery card open. Link scope, latest successful backup and last isolated restore proof to the existing production runbook. Clearly label SQL export as a controlled break-glass artifact, not a routine operator step. Reuse current recovery/restore controls.

**Accept:** a user can distinguish backup existence from restore proof, undo a fixture-level restore in isolation and name what is outside this feature’s scope. No live restore was attempted here.

### UR-16 — Test generation and semantics need tightening
**P2 · Source-confirmed · Expand existing guards, not the test count for its own sake.**  
S22 checks release stamp, named page/tab existence and generated Pilot-doc equality; the Platform guide guard checks screen coverage and absence of money literals. These are useful but did not catch stale delivery prose, role contradiction or cross-repo drift.
The published test register’s category summary says 89 deployed tests while its narrative says 92; this is a reporting inconsistency, not evidence tests failed.

**Action:** extend S22/platform-guide tests for capability-aware task destinations and canonical operational facts. Have the generator derive all counts from one collected result set and assert totals agree. Preserve G4, safe/live-acting separation and the weekly workflow; do not add per-finding duplicate guards where a central guard owns the rule.

**Accept:** a stale alert mode/retired task target/incorrect effective role fails a focused contract; summary and narrative counts are generated from one source. Production writes remain out of the safe weekly track.

### UR-17 — Specialist guide discovery and incident handoffs are incomplete
**P2 · Source-confirmed · Extend existing Guides, not more SOP silos.**  
AER-ROLE-GUIDES has valuable Viewer, Curator, Platform Admin, reviewer, integration-owner and incident workflows, but in-app Guides presents only Platform guide and two SOP tabs. General Curator wording must explicitly state AER decisions are Platform Admin-only. Admin SOP includes historic “More evidence” wording absent from the current AER decision choices.

**Action:** add context/task links inside existing Guides to the relevant specialist sections and existing production runbook. Include the exact minimum role, source requirement, saved evidence and escalation owner. Remove unsupported choice names from active prose while retaining history. Give Counsellors clear estimate/no-scale/contact-provider wording and a traceable correction-report route.

**Accept:** each role can find its own top tasks without reading an administrator’s full runbook; AER review instructions match the current choice contract and D4 exclusions.

## 5. Feature and script disposition

| Component / script | Disposition | Why / required expansion | What to retire or avoid |
|---|---|---|---|
| Existing Guides + `src/guide/platformGuide.js`, `src/guide/sops.js`, `src/Sops.jsx` | Retain, improve | Shared source, role-linked tasks and downloads are sound; repair semantics and tab-level gating | Old navigation prose, obsolete alert plan and unsupported choice labels; no extra competing SOP application |
| `scripts/export-sops.mjs` | Retain, expand | Generate canonical Pilot docs and verify/publish admin mirrors with conflict handling | Manual copy as the only consistency control; no second generator |
| `scripts/verify-release-contract.mjs` | Retain, expand | Current manifest, legacy patch exclusion and guide coverage guards are valuable; add narrowly owned semantic/recovery-reference checks | Duplicated current-version literals and revival of retired patch scripts |
| S22 + platform-guide contract specs | Retain, expand | Capability-aware destination, specialist-task and operational-truth checks | Cosmetic stamp-only sign-off; redundant new tests for centrally owned rules |
| `scripts/test-register.mjs` | Retain, correct | Uses actual Playwright collection; reconcile category/narrative totals | Hand-maintained counts |
| `scripts/ci/apply-migration.sh` | Retain, harden | Existing version checksum before skip; transaction/history guards remain | Parallel ad hoc migration runners; editing an applied file |
| `scripts/ci/deploy-function.sh` and deploy-on-merge workflow | Retain | Explicit function allow-list, target and verify_jwt handling; controlled deployment path | One-off manual deployments as the routine path; helper was inspected, not executed |
| Weekly deployed workflow + `scripts/deployed-weekly-summary.mjs` orchestration | Retain | Desktop/phone reporting and live-acting off by default; inspect the summary helper before any implementation change (its invocation, not full body, was assessed here) | Treating held live-acting tests as executed acceptance |
| Existing `Layer4Inbox.jsx` and destination record/evidence screens | Retain, expand | Complete cursor, evidence, stable refs and saved-outcome visibility in the current UI | New separate settlement console, mass approval, unsafe higher caps |
| `SettingsBackup.jsx` | Retain | Scoped diff/restore with reason and before-restore backup | Describing settings snapshots as complete DR |
| Existing health/alerts/scorecard and component-register workflow / hygiene-check | Retain, improve | Freshness, owner/action and retired/paused semantics | Retiring safeguards solely from low opens |
| Logically retired Rule 4 and old onboarding-pilot snapshot | Complete governed retirement when eligible | Preserve records; confirm dependencies/usage and approved replacement; hide unsafe-looking controls now | Routine Resume on retired items; destructive auto-drop |
| Legacy URL aliases | Retain compatibility layer | Saved links should continue to resolve to the correct current route | Legacy names in current task instructions; removing aliases without consumer/dependency check |

There is no evidence-based case here for adding a new paid toolset, new autonomous agent, new database or new permanent probe function. All proposed work fits existing screens, generators, guards, catalogue and release workflow.

## 6. Operating task coverage and missing proof

| Journey | Current evidence | Completion proof still required |
|---|---|---|
| Find, inspect and correct a fact | Catalogue/AER guide + source contracts | Lower-role real-session task completion, saved provenance and consumer visibility |
| Review and settle | Existing Layer 4 route + earlier four saved decisions | Complete item traversal, source-first evidence, each action route, exact destination/outcome counts |
| Diagnose a failed lane | Jobs/health visible, reasons and live checks | Role-correct response, recorded owner, successful subsequent run and reduced backlog |
| Change a limit | Broad Settings section coverage visible | Effective mode, server role denial/allow, reason/audit and subsequent behaviour |
| Monitor alerting | Live delivered tests and operational-limits D12 contract | Recipient receipt and actual on-call responsibility; latency fits intended response |
| Recover publication/settings | Daily backups and scoped controls visible | Isolated restore/undo proof; DR scope handled by production runbook |
| Release/recover code | Manifest and CI helpers present | Valid recovery baseline and compatibility rehearsal; existing-version checksum failure test |
| Maintain toolsets | Limits, settings and component register established | Owner/purpose/dependency and governed retirement evidence; no usage-only removals |

## 7. Implementation order, owners and gates

| Tranche | Scope | Owner | Exit condition |
|---|---|---|---|
| A — correct operational truth | UR-01/02/03/08/09/10/17; reconcile INDEX and old snapshot wording under UR-11 | Platform documentation owner + integrator | Current guide, SOP mirrors, role action matrix and actual destinations agree; no permission expansion |
| B — finish review journeys | UR-04/05/06; isolate prior ANU issue and timeout regressions under their existing work | Layer 4/UI + data contract owners | >200-item pass and each supported route completed with evidence and destination/audit verification |
| C — maintenance/recovery safety | UR-07/13/14/15 | Platform engineer + Platform Admin | Retired controls protected; checksum skip guard; approved recovery plan and isolated drill |
| D — durable assurance | UR-11/12/16 and all six role walkthroughs | QA/operations owner | Freshness/count consistency; central guards extended; role scenarios pass; retirement decisions recorded |

Use the **single STUDYSEARCH-EXECUTION-REGISTER**. Map accepted items to SS-004/SS-007/SS-014/SS-015 where appropriate rather than claiming existing work unfinished from this review alone. Existing completion claims remain governed by their own evidence. Do not reserve new SS IDs in a parallel backlog.

User authorised this review and its repo record. No production implementation is claimed. UI/backend implementation follows existing change-control, full-suite and release rules. Consumer/API changes require the existing explicit approval and developer handover; destructive retirement stays a reviewed paste path. No consumer API alteration is required merely to correct guide prose.

## 8. Verification and limits
- Verified live pages and source evidence listed above; no test suite run was necessary for a documentation-only assessment.
- Inspected S22, platform-guide guard, register generator, release verifier and two CI helper bodies; read relevant workflow orchestration. Published test result “1333 passed” is a repo record, **not a test run performed by this reviewer**.
- No write-path UAT, role impersonation, live restore, alert send, paid read, user-management change or deployment was performed.
- No exhaustive inventory of every script, stored function or Edge function is claimed. This is a guide-driven operational assessment of representative critical workflows, with named follow-up coverage. Uninspected scripts are not candidates for deletion.
- Current live database function bodies and grants were not introspected; migration/source evidence cannot certify that deployed RBAC matches. No DB objects were invented; references use inspected code or PIPELINE-LINEAGE sections 5–6.
- Existing lineage documentation itself contains historical test counts/legacy-failure language in §6 and queued/absent claims that require reconciliation with current source before reuse. Do not copy those old figures into a new readiness claim.

## 9. Required review acceptance
This assessment is accepted as delivered when the repo record is available. **Platform usability acceptance remains open** until:
1. six real or isolated role-session workflows pass, including forbidden-action cases;
2. each top daily task has an accurate current route, role and completion condition;
3. Layer 4 can traverse a full large kind and verify its saved outcomes;
4. operational summaries disclose freshness, source and incomplete windows;
5. alert delivery/receipt and scoped recovery are proven with appropriate safe evidence;
6. release/recovery and retirement controls agree with the runbook and scripts;
7. changes reuse existing ownership/guards and clearly state Replaces/Retires.

Do not use percentage “usability complete” from this static review; task execution evidence is required.

## 10. Source index
Repository paths are the evidence authority; links refer to main unless pinned in an implementation PR. The assessment above identifies the relevant symbols/sections.

### Pilot
- [Guide source](https://github.com/msinghbs-ai/Coursefinder-Pilot/blob/main/src/guide/platformGuide.js): ROLES, DAILY_ROUTINE, SIGNALS, ADMIN_DUTIES, ALERTS.
- [SOP source](https://github.com/msinghbs-ai/Coursefinder-Pilot/blob/main/src/guide/sops.js): AUTOMATION, admin/operator schedules and interventions.
- [SOP renderer](https://github.com/msinghbs-ai/Coursefinder-Pilot/blob/main/src/Sops.jsx): Open capability check and Markdown download.
- [Navigation](https://github.com/msinghbs-ai/Coursefinder-Pilot/blob/main/src/nav-map.js): PAGES, LEGACY, canOpen, effectiveTab, resolveTarget.
- [Layer 4 Inbox](https://github.com/msinghbs-ai/Coursefinder-Pilot/blob/main/src/Layer4Inbox.jsx): loadItems, Item, decided, evidence rendering.
- [Settings backup](https://github.com/msinghbs-ai/Coursefinder-Pilot/blob/main/src/SettingsBackup.jsx): scoped recovery, confirmation/reason and before-restore result.
- [S22](https://github.com/msinghbs-ai/Coursefinder-Pilot/blob/main/tests/uat/cf-247-s22-sops-contract.spec.mjs), [Platform guide guard](https://github.com/msinghbs-ai/Coursefinder-Pilot/blob/main/tests/uat/cf-247-platform-guide-contract.spec.mjs).
- [SOP exporter](https://github.com/msinghbs-ai/Coursefinder-Pilot/blob/main/scripts/export-sops.mjs), [Release verifier](https://github.com/msinghbs-ai/Coursefinder-Pilot/blob/main/scripts/verify-release-contract.mjs), [Test register generator](https://github.com/msinghbs-ai/Coursefinder-Pilot/blob/main/scripts/test-register.mjs).
- [Migration helper](https://github.com/msinghbs-ai/Coursefinder-Pilot/blob/main/scripts/ci/apply-migration.sh), [Function deploy helper](https://github.com/msinghbs-ai/Coursefinder-Pilot/blob/main/scripts/ci/deploy-function.sh), [Deployment workflow](https://github.com/msinghbs-ai/Coursefinder-Pilot/blob/main/.github/workflows/deploy-on-merge.yml), [Weekly deployed workflow](https://github.com/msinghbs-ai/Coursefinder-Pilot/blob/main/.github/workflows/deployed-weekly.yml).
- [Release manifest](https://github.com/msinghbs-ai/Coursefinder-Pilot/blob/main/src/release-manifest.js), [working rules](https://github.com/msinghbs-ai/Coursefinder-Pilot/blob/main/CLAUDE.md).
- [Automation control source](https://github.com/msinghbs-ai/Coursefinder-Pilot/blob/main/supabase/migrations/20261013012900_cf247_all_controls_in_settings.sql): rank floor and per-job gate; later changes/live body require final reconciliation.

### Admin
- [Operating model](../AGENT-OPERATING-MODEL.md), [INDEX](INDEX.md), [execution register](../STUDYSEARCH-EXECUTION-REGISTER.md).
- [AER role guides](../AER-ROLE-GUIDES.md) §§1–7; [Operational limits](../OPERATIONAL-LIMITS.md) monitoring/alerts, D12 and scorecard; [lineage](../PIPELINE-LINEAGE.md) §§5–7; [test register](../TEST-REGISTER.md).
- [Admin SOP mirror](../../sops/admin-sop.md), [Operator SOP mirror](../../sops/operator-sop.md).
- [Earlier Course link census](2026-11-01-course-link-118-review-register.md), [earlier timeout checkpoint](2026-11-01-layer4-all-kinds-settlement-timeout-stop.md): historical session evidence, not current regression claims.
- Existing production runbook discovered at `docs/coursefinder-production-environment-runbook-v1.0.md`; latest approved successor and restore evidence must be resolved before updating recovery instructions. Its complete contents were not assessed here.

### Retained blob identities for key inspected files
- Pilot release manifest: `0adce91dc56ed28cf3980c7923282fec1e4d863b`.
- Pilot SOP renderer: `c5062e77830e6ac9db6bccd5158261630c668e96`.
- Pilot package.json: `41d1548aae6913de61dde0d6674d9e9bf66fcadd`.
- Pilot generated admin SOP: `2f4b781e760eb295e3108f5bd5103d349c56cba0`.
- Pilot generated operator SOP: `9ff9a6f9d336747ff56da671433e45cb36d8c31a`.

## 11. Replaces / Retires for this deliverable
**Replaces:** nothing; this is an independent assessment linked to existing canonical operating documents.  
**Retires:** nothing in production; proposed removals and expansions are explicit in §§4–5.  
**Operational state changed:** none.  
**Next owner:** Platform Admin and integrator to disposition UR-01–UR-17 in the single execution register, then implement and verify by tranche.
