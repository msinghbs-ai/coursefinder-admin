# StudySearch — Feature Completion and Autonomous Operation Acceptance Contract

**Implementation and live metadata reference:** [Capability and Data-Population Inventory](inventory/STUDYSEARCH-CAPABILITY-AND-DATA-POPULATION-INVENTORY.md); linked source snapshots of all function signatures, automation catalogue, G2 settings and recorded plans. Validate against current production before marking F-substeps done.


**Mandate:** Platform Admin, 8 November 2026. **Status:** Governance specification recorded; delivery acceptance **NOT** established.
**Authority:** `docs/platform/AGENT-OPERATING-MODEL.md`, Pilot `CLAUDE.md`, cross-domain mandate `docs/platform/nz-enrichment-brief/2026-11-08-cross-domain-autonomous-delivery-closure.md`.
**Source of truth for operational issues/status:** `docs/platform/STUDYSEARCH-EXECUTION-REGISTER.md` and `pipeline.integration_issues`. This file defines WHAT MUST WORK and HOW TO PROVE IT; it is **not another task queue**. The linked `STUDYSEARCH-PROGRAMME-STATUS.md` is a dated, derived one-page summary, never the authority for an issue's live state.

## 1. Definition of complete and non-negotiable design rules
Every feature below has a durable ID (F-INT, F-FEE, etc.), numbered substeps, real code/DB object/issue evidence, role-appropriate visible Admin UI, live settings, first successful unattended run, automatic recovery proof, valid data admitted/published when authorised, and a cross-consumer check. The feature is incomplete if it only has schema/scaffolding, an agent report, a PR, passing CI, a queued item, a green job, or a simulated run.
The canonical lifecycle is **Discover → Identity/evidence → Extract → Validate → Governed review → Admit → Publish → Verify consumers → Monitor/recover**. At each transition record eligible, attempted, successful, legitimately refused, held (reason), next revisit, actual newly admitted/published net gain, input/output IDs, cost and elapsed time. Expose UNKNOWN distinctly from ZERO.

**G1–G4:** existing registered jobs only, all variable limits/switches in `pipeline.platform_toolset_settings` or existing toolset settings (label, range, unit, used_by, audit reason, role), frozen Website/Zoho consumer contracts except explicit G3 approval, no anonymous/duplicated tests; no destructive/consumer change without existing approvals; no AI approval of human Layer 4 decisions; preserve manual locks/source lineage. Existing GitHub→Cloudflare deployment pipeline stays. One Integration Controller merges/releases, agents work on non-overlapping areas. Real progress is production evidence, not a headline or a forecast.

## 2. Feature and subtask acceptance checklist

### F-INT — Intake dates, deadlines and provider/course-specific verification (P0 IQ-00313; related IQ-00111)
**Already exists:** Pilot `src/IntakeRunValidate.jsx` (scope, bounded cohort, preview, fix cohort, audited Run Now, verify), `src/AutomationProgress.jsx` (status, stages, universities, history, failures, controls), `docs/intake-run-validate.md` and `docs/intake-automation-progress.md`; Admin `docs/platform/processes/intake-dates.md`. **Do not create a duplicate screen, scheduler or second progress mechanism.** Current scope appears cohort/top-university based; the individual-course and full selected-university journeys require proof or extension.

- [ ] **F-INT.01 Source and lifecycle truth:** verify provider/course ID, CRICOS, campus, domestic vs international audience, live/retired status, official course page and eligible 2026/2027/2028 calendar year. Correct the Deakin year/end-date defect without assuming every Deakin 2027 period is offered by every course; verify UQ 092452K independently of 098328K with official evidence.
- [ ] **F-INT.02 Scope controls:** within existing Intake Run & Validate, offer verifiable **one course** (exact ID/CRICOS) and **one selected university** (all eligible courses subject to bounded pagination/batches), alongside existing approved cohort scope. Explicit preview-only vs governed Run Now vs verification-only; show estimated count, caps, cost, reason, affected records, source, current version and role. No hidden unbounded “whole university” query. Reuse existing server endpoints where possible; extend only as permitted.
- [ ] **F-INT.03 End-to-end execution:** one immutable run/job/cohort ID, fixed evidence snapshot, dedupe, retry and cancellation rules, stage-by-stage timestamps/last error; queued → selected → evidence → validated/refused → admitted/withdrawn → Website+Zoho source → HTTP verification. Must restore after reload/session end and prevent duplicate writes.
- [ ] **F-INT.04 University and course drill-down:** display exact eligible/held/missing evidence, source quote/year, reason, actor/decision/lock, net new admitted, canonical vs Website vs Zoho and next scheduled attempt. Existing Process results/Automation progress must show per-run progress and historical results.
- [ ] **F-INT.05 Safety/acceptance:** regression for 2027/2028 cross-year, discontinued course, identity/campus/audience, calendar ambiguity, duplicate run, permission denial, 0 eligible, slow timeout, producer success without admission and consumer parity. At least two unattended real production cycles; no unsupported date reintroduced. Test on desktop/phone with approved operator roles.
- [ ] **F-INT.06 First-run and scheduled controls:** existing `intake-dates-apply`, `coverage-admit-intakes`, first-run monitor, job catalogue and settings observed from UI; verify no “green cron / failed work” false positives.

### F-FEE — Evidence-backed tuition, fee plausibility and publication (IQ-00111 family)
- [ ] **F-FEE.01 Contain invalid provider fees:** existing La Cité 65-row guarded paste, original exact hash/audit/manual-lock policy; require explicit Platform Admin authorisation, lawful execution, adapter re-admission prevention and rollback; never run merely to mark an issue complete.
- [ ] **F-FEE.02 Repair reader and source:** currency, annual vs total basis, course/CRICOS, international audience, year and source quote; no calendar year interpreted as CAD price. Preserve manual fee precedence and recalculation of scholarship savings.
- [ ] **F-FEE.03 Autonomous path:** source → read → plausibility → review/approval where required → canonical → Website/Zoho, with no repeat of refused unchanged evidence. Show net gains, removals, held reasons and fees by provider/year.
- [ ] **F-FEE.04 Operator UI:** existing fee/Operations/settings path shows active jobs, guard counts, source review, per-provider/run drill-down, approved Run Now/Verify and outcomes; existing first-run `fee-plausibility-guard` actual output checked.
- [ ] **F-FEE.05 Acceptance:** legitimate tuition gains or honest source holds, consumer parity, zero false-active-year amounts, actual 2+ unattended runs with measured outputs.

### F-ENG — English requirements (IQ-00030 / IQ-00072 and actual English issue)
- [ ] **F-ENG.01 Ground 14,940 reported missing courses in current three-layer gap funnel; classify source missing, policy/group, page reading, unmapped course and manual/held.**
- [ ] **F-ENG.02 Recover legitimate stored sources before paid reads, preserve faculty/level, country/audience/qualification rules, conflicting score and manual locks.**
- [ ] **F-ENG.03 Automated source→extract→policy→Layer 4/authorised decision→active English→Website/Zoho, with no fabricated scores.**
- [ ] **F-ENG.04 UI controls:** existing English policies and Layer 2/3 Operations show scope, scheduler, requeue, why held, batch/output, reviewer packet and net published gains. A disabled automatic setting is not “delivered”.
- [ ] **F-ENG.05 First-run and consumer parity acceptance on real eligible courses**, not only an added function or report.

### F-CDESC — Course descriptions (existing #894/#900, Layer 4 issue family)
- [ ] **F-CDESC.01 Distinguish unread/never queued, no source, invalid evidence, re-ask held, technically recoverable, ready for review, admitted, consumer-visible.**
- [ ] **F-CDESC.02 Reuse stored evidence; bounded review-first scheduling; no unsupported sentences/claims; never auto-admit where reviewer is required.**
- [ ] **F-CDESC.03 Layer 4 university/provider review packets and controlled per-item decision with audit, immediate admission/publication verification.**
- [ ] **F-CDESC.04 UI capacity, 24h throughput, ageing, settings, zero-yield/blocked reasons, processed vs net published; mobile acceptance.**
- [ ] **F-CDESC.05 Acceptance:** measured net gain beyond prior 163 active, or true reviewer/evidence hold with actionable next step.

### F-PDESC — Provider descriptions (existing #877/#912 and IQ-00022)
- [ ] **F-PDESC.01 Correct official provider identity/site/description source, manual locks and re-read validity.**
- [ ] **F-PDESC.02 Autonomous bounded provider reader with independent first-run output, retries/hold; no repeated failed no-work calls.**
- [ ] **F-PDESC.03 Reviewer-owned decisions then canonical and Website/Zoho publication; investigate persistent 0 published / earlier 4 awaiting human decision.**
- [ ] **F-PDESC.04 UI: Run & Validate, provider-specific pipeline status and actual net published output.**
- [ ] **F-PDESC.05 QA: reliable isolated acceptance including #916/#920 fixture failure case and live result.**

### F-AER — Academic entry requirements (IQ-00060 / IQ-00293 / current AER families)
- [ ] **F-AER.01 Recover source coverage and provider identity; use stored/free links before budgeted Firecrawl.**
- [ ] **F-AER.02 Keep fair scheduler and provider-specific row limits as audited settings; accurately distinguish technical holds from review-ready and never let held duplicates exhaust capacity.**
- [ ] **F-AER.03 Evidence completeness E13/D-R2/D-R3, country/qualification variants, replay supersessions and actual readiness.**
- [ ] **F-AER.04 Layer 4 user decisions on complete packets, item-level audit, no blanket approvals, then active rows and Website/Zoho publication.**
- [ ] **F-AER.05 UI university drill-down, pending/readiness/reviewer capacity/next action and links to source, reviews and releases.**
- [ ] **F-AER.06 Acceptance:** new source coverage, human-decided and published valid entries beyond 1,304 prior active rows; no re-admission of rejected evidence.

### F-SCH — Scholarship coverage and eligibility (IQ-00082 / IQ-00241 and coverage family)
- [ ] **F-SCH.01 Source/listing discovery, currency and country/residency, international vs domestic, award type, research vs coursework, eligibility proof.**
- [ ] **F-SCH.02 Classifier→read→review→admit→publish with reliable scheduled work, no duplicate scholarship or zero-yield plans.**
- [ ] **F-SCH.03 Existing Admin Coverage/Scholarships/Layer 4 shows provider-level completeness, pending decisions, active switches, spend and reasons; allowed operators can inspect and resume.**
- [ ] **F-SCH.04 Verified Website/Zoho publication increase beyond 1,144 baseline or durable honest no-source state per provider.**

### F-DISC — Provider/course lifecycle and source integrity (IQ-00046/47/56 etc.)
- [ ] **F-DISC.01 Classify source-gone vs temporary timeout vs HTTP 200 empty page vs identity refusal; do not exhaust/retry permanently dead URLs.**
- [ ] **F-DISC.02 Provider/country/course archive cascades only under approved housekeeping/locks, preserve evidence and scheduled-job consistency.**
- [ ] **F-DISC.03 Controlled 115 no-response and 3 companion-page recoveries after worker stability; 1409 dead and 194 source-gone require evidence/authority to retire, not an endless retry.**
- [ ] **F-DISC.04 Existing Admin UI reports per-source reason, attempt time, next retry and acquired useful values.**

### F-OPS — Autonomy, first-run, control plane and UI (IQ-00053 / IQ-00072 / SS-014 / SS-016 / SS-020)
- [ ] **F-OPS.01 Worker reliability:** verify #921 modes `enrich_ai` and `read`; concurrency setting, expired leases and 2+ unattended runs, actual successful field outputs and correct failure classification. Do not confuse old issue headline with current rate.
- [ ] **F-OPS.02 Every changed job is registered in existing first-run verifier / job-output contracts; validate expected vs actual and downstream stage movement.**
- [ ] **F-OPS.03 Existing Process results/Layer 2/3 Operations/Queues & yield/Settings/Platform health shows per-feature run, control, settings, stage funnel, net gains, reasons, deadlines and active issues. NO duplicate screen.**
- [ ] **F-OPS.04 Admin feature drill-down on desktop and phone; valid role permissions; reproducible authorised manual Run Now and Verify actions; preview must be read-only and bounded.**
- [ ] **F-OPS.05 Zero-yield detector distinguishes evidence-backed abstention vs failed valid work, and routes only genuine issues to existing fingerprint; no pointless new plan loop.**
- [ ] **F-OPS.06 Schedules and continuity:** platform jobs independent of Claude; check first-run and drift periodically; one scheduled **read-only requirements/implementation audit** plus, if Claude supports it, a separate **single mutating-controller resumption** requiring fresh owner/lease and release gates. Do not create competing write agents or claim scheduled execution succeeded before it runs.
- [ ] **F-OPS.07 Release/QA:** full zero-red suite, real PostgreSQL, exact main commit, live function checksums, Cloudflare Git-connected pipeline, real consumer verification, no unapproved API shape changes.
- [ ] **F-OPS.08 Financial autonomy:** configured 100k Firecrawl allowance, verified live balance, floor/day shares, spend and actual useful output per credit, no uncontrolled vendor purchase.
- [ ] **F-OPS.09 Alert reliability:** generated vs delivered vs recipient-acknowledged, no false “sent”; watchdog and real delivery validation separate.

## 3. Design and code-to-subtask traceability
Each feature/substep above must resolve to **existing IQ/SS issue → applicable design/decision → current code function + UI component → PR/commit/migration → tests → installed setting/job → first unattended run and expected/actual outputs → producer/consumer result → independent validation record**.
When code is missing, create a small owned subtask in the **existing execution register**. When an issue is already known, update its substep rather than open a duplicate. A substep is completed only with live proof. Operator UI control must be present and functioning, not just described in a document. Technical safety holds remain visible with exact authority and next step.

**Independent validation ingestion:** Each supplied report has an observed-through time, comparison window, source, evidence and issue fingerprint; reconcile it against later releases/production readbacks. Append it under the existing IQ/SS substep. Update this acceptance contract ONLY when feature requirements, dependencies or tests change, not for every metric change. Update the derived programme status whenever the verified issue status materially changes. Mark unverified mismatches pending, not as new faults, until independently confirmed.

## 4. Recurring acceptance audit and non-stalling work
Read-only hourly independent validation already exists outside Claude; reuse it instead of duplicating. The active controller should install/configure only a supported Claude execution schedule if the provider can actually run Claude Code with repo access. First prove ONE triggered run (identity, capacity, read/write permissions, clean handover); then enable recurring **bounded** development cycles, each beginning from current GitHub/DB and picking the highest-priority unblocked substep. One owner of production release; independent agents own distinct branches/functions. Never promise persistent execution when it is not actually configured. A stopped/expired/session-limited agent leaves durable next actions and a verified checkpoint.
Every scheduled **design audit** compares this file, UI catalogue, process records and actual installed code/ops; creates or updates an issue-linked substep with evidence; independently proceeds with next authorised issue rather than stopping on a report or a blocked review. Every significant release updates the register and derived status.

## 5. Closeout and audit definition
A feature is eligible for *Production verified* only if:
1. Requirements and role-visible UI controls demonstrated and documented.
2. Existing production job/setting and Run Now / Verify behaviour accepted (where applicable).
3. Full regression plus true production-shaped SQL and phone tests pass.
4. Two or more real unattended cycles produce expected stage movement, or show justified no-work without false errors.
5. Canonical admitted and published net gain measured with event IDs and Website/Zoho parity, or legitimate source/reviewer hold recorded.
6. Monitoring proves stale/failed producer-to-consumer transitions route to an existing IQ issue without requiring Claude to notice and intervene.
7. No unresolved source-integrity regression, extra spend or human-authority bypass.

**Priority order:** P0 consumer integrity/fee false data → current P1 worker/reliability and critical pipeline starvation → unblock human review packets and AER → all domain autonomy and UI → validation/monitoring and throughput optimisation. Holds for people/spending do not stop unrelated lanes.


## 6. Overnight autonomous execution and scheduled requirements audit
**Current state at specification creation (8 Nov 2026):** the EXISTING ChatGPT task `StudySearch Independent Validation` is hourly and has been updated to include feature/substep checks. Its update is verified through the task-management response. It performs **independent read-only inspection**, NOT Claude Code development. No new Claude overnight coding schedule has been created or verified by this specification. Older Codex weekend/Monday tasks are disabled and MUST remain disabled.

**Claude controller schedule activation (only if Claude account supports a task that actually launches Claude Code with GitHub and the correct repo/environment):**
1. Inspect Claude's actual scheduler features and Code Remote access, task ownership, model/effort, GitHub repo and Supabase authorization. Do not assume a generic Claude scheduled message can run code.
2. Configure **one** recurring controller-resumption task (suggest hourly while the mandate is open; precise time controlled by account owner, stagger from production heavy-read windows). Separate spawned agents inside that run own non-overlapping code/functions. Never schedule multiple independent prod release controllers.
3. In the first triggered run, do not mutate immediately: verify main SHA, execution-register handover, active controller/inflight GitHub workflows, CLI permissions, monthly spend allowance and production load windows. Prove which tools were actually invoked, whether a branch can be edited, whether a PR can be created and whether required CI runs. Record a real run ID, start/end UTC and outcome. If this first run cannot execute a bounded engineering cycle, disable the coding task and state that overnight autonomous development is unavailable through that tool.
4. Every successful subsequent run: read canonical model, this spec, executive status and register; independently verify latest production/PRs and incoming independent validation; claim one highest-priority unblocked **existing IQ/SS + F-substep**; implement one bounded end-to-end slice, test, create/update its owned PR, and integrate **sequentially** only under the active controller's current authority. Always use existing GitHub→Cloudflare integration and full canonical gates. If it hits a genuine approval blocker, park that issue and continue safe other work within the same run. No duplicate fixes of already merged PRs.
5. At end of run, append actual evidence to the existing execution register; regenerate derived Programme Status with a timestamp and source links; publish a validated handover / next executable substep. No false heartbeat, no claim of all-night work if runs have not executed. Continuous platform scheduled jobs are distinct from the AI coding schedule.
6. Explicit stop condition: account owner disables schedule or the programme reaches acceptance; never silently re-enable stopped Codex schedules. At budget exhaustion, pause only additional AI agent spend and continue deterministic/read-only/CI work as permissions permit.

**Independent requirements audit (already hourly, read-only):** compare `STUDYSEARCH-FEATURE-ACCEPTANCE.md` to code, UI catalogue, intakes process, live pipeline counts, last actual scheduled run and `STUDYSEARCH-PROGRAMME-STATUS.md`; create a concise evidence-backed discrepancy `F-substep + IQ/SS + current proof + missing acceptance + next action`. Results are delivered to the Controller through the existing Admin repo/issue workflow when authorised; a chat-only report does not imply the Controller has ingested it. Do not duplicate the existing automation.

**Instruction priority:** production P0 integrity → P1 worker/resource failures → source/read reliability → missing UI/first-run handoffs → review-ready packs and approved decisions → admissions/publication → monitoring closure. The controller does not wait for all agents to report before integrating an already qualified independent branch. P0 may pause mutating releases when safety requires, but independent test/read-only work continues.


## 7. Platform Admin 9 November: all-provider description automation and policy
**New source of authority:** [All-provider autonomy decision](nz-enrichment-brief/2026-11-09-all-providers-autonomous-description-delivery-decision.md). The Platform Admin no longer accepts individual approval of every low-risk provider description. **Develop and release a new approved factual-auto-admit rule with strict evidence provenance**, while preserving the live manual-review gate until that rule is legitimately deployed. Do not represent the current v2.15.494 provider-description code as already having this feature. F-PDESC.03's text about "reviewer-owned decisions" continues to apply to exceptions, unsupported claims, conflicts and all cases not meeting the new auto-rule. The safe class is subject to official source or authoritative register identity, exact factual support, non-promotional wording, no manual lock or prior rejection, auditable machine actor, and Website/Zoho consumer parity. Machine admission is NOT "approve every Layer4 row".
**Breadth target:** all 3,103 providers (AU 1,556, NZ 417, CA 1,130) evaluated and every eligible description written by end of 9 Nov Melbourne, with honest provider-specific exceptions; not an artificial 20-university cap. Stored sources first, free direct sources second, paid Firecrawl fallback third, authoritative registered facts where trustworthy fourth. 0 current descriptions and 2,323 websites are the first snapshot. Pending old reviews must be reconciled with new rule after release, not machine-impersonated as previous human actions.
**Acceptance for F-PDESC.01-.05:** all-country provider census; source/evidence tiers and decisions; first nonzero canonical + eligible published description; dynamically fair bounded throughput without expensive redundant recrawls; durable holds/revisits and G2 settings; repeated unattended provider batches after Claude leaves; exact source/consumer validation and no unapproved budget expansion. Any exact-code action requiring the release controller must still pass the existing controller-fencing and G1–G4 gates.
