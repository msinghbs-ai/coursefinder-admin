# Platform data programme — INDEX and standing state

**ROADMAP HUMAN ENGAGEMENT — OPERATING MODEL v1.21 (13 NOV):** ChatGPT and Claude record a minimum of 15 minutes for each substantive human roadmap interaction, timestamped in Melbourne. Prompt requests are Planning. A separate human request directing implementation is Development. Use the registered RM item and verify the ledger write before replying. [Roadmap Engagement Register](../../Roadmap/2026-01/ROADMAP-ENGAGEMENT-REGISTER.md) · [Operating model](../AGENT-OPERATING-MODEL.md#roadmap-milestones-and-human-engagement-time)

**11 NOV COURSE-DESCRIPTION REPLACEMENT — P0 F-CDESC:** [Production controls/UI/prompt/operator guide](../COURSE-DESCRIPTION-PRODUCTION-DESIGN.md). [Decision and execution contract](2026-11-11-course-description-source-grounded-replacement-decision.md). Replace the existing generator's ineffective prompt/quality contract, repair the recording/settlement/replay and diagnose canonical vs API/UI snippet clipping, then retire only proven obsolete mechanisms. **No second reader, standalone 100-course pilot or dashboard;** source-shaped comparisons are release regression fixtures. No change to protected machine-admission, Layer 4, budgets or G3 without separate approval. Record actual accepted descriptions and consumer read-back in existing F-CDESC rows/Execution Register. Design approved; live replacement/retirement NOT verified.

**SHARED RUNNER CHANGE RULE — OPERATING MODEL v1.20 (13 NOV):** S2-CF evidence shows a cross-module `batch.admin_jobs` increase from 10 to 30 contributed to runner timeouts and ~2,800 stranded description reads; a smaller `batch.enrich_fields` mitigated the outage and Pilot #1106 improved admission throughput. [Operating Model v1.20](../AGENT-OPERATING-MODEL.md#shared-job-runner-and-capacity-changes-across-module-sessions-platform-admin-13-november-2026) assigns shared batch/concurrency/leases and release-version changes to the single integrator, requires cross-lane throughput/time-out/readmission checks, reversible incremental changes and regression proof, and prohibits module-specific agent changes that starve other lanes. S2-CF reported 3,247→3,601 canonical descriptions and deployed Zoho v3 (Pilot #1107), **but Zoho sync/export remain v2-shaped and no consumer has switched**. The developer register v2.23 already records this; do not create another tracker. Sentence-length-only source-backed recovery is a scoped engineering proposal subject to full unchanged claims/identity/copy/lock checks, **not** authority to waive safety or blindly cut to the first sentences. Validate two unattended cycles and document real canonical/API outcomes.

**S2-SCHOLARSHIP INDEPENDENT COVERAGE AUDIT — 13 NOV 2026:** Live read-only Supabase: **1,211 active published / 68 providers**, **1,670 active / 459 unpublished**, **761 providers with source candidates**. Platform `scholarship_university` classifies 143 universities: **AU 38/40, NZ 7/8, CA 11/95** with published scholarships (87 without; 73 Canadian universities have zero candidates). Missing AU/NZ examples: **CDU, Victoria University of Wellington, Notre Dame Australia** with source/held reasons. Evidence IDs/hash/capture date for all 1,211 published, but four no storage path and nine source-URL differences require proof audit. Scholarship review is **not cleared**: **150 sch_coverage + 150 sch_value awaiting input**, 198 AI reviews pending, 127 coverage cases `awaiting_layer4`. Last 24h 31 admitted events / 8 withdrawn, not automatically published; AI queue 7,971 queued / 22,335 failed. Nationality filters 155+1,050 fail to reconcile to older 1,202 denominator. [Developer register v2.26](../../integrations/WEBSITE-DEVELOPER-REQUIREMENTS.md#s2-scholarship-independent-live-audit--13-november-2026-provider-coverage-and-evidence) and [F-SCH.11–.13](../STUDYSEARCH-FEATURE-ACCEPTANCE.md#f-sch--scholarship-coverage-and-eligibility-iq-00082--iq-00241-and-coverage-family) require provider-by-provider evidence, actual Layer 4 closure, per-field proof, correct nationality facets and real published gain. S2-Scholarship owns remediation; no extra dashboard, blanket admission or new job triggered by this record.

**S2-SCHOLARSHIP P0 PUBLICATION/RECOVERY FOLLOW-UP — 13 NOV 2026:** Pilot #1108, #1109, #1113 and #1114 have merged; `sch_elig.readmit_on` is ON with guards, **0 restored**, and Sydney Bowel Cancer's 2019 round correctly remains held. The AI picker was stalled about 10 hours and restarted: reported 239 reads/227 OK/US$0.27, ~8,800 queued; 43 sectioned recoveries queued but **no measured field gain**. The existing Scholarships Admin catalogue/detail operational filters are live. **REQ-72 / F-SCH.08: 97 published scholarships have last known rounds older than a year**—verify official current/recurring terms and the existing publishing rule; do not blanket-withdraw or imply open status from old evidence. Counts 43+32+2+2 vs 77 and course-link categories 304+748+149 vs 1,202 need ID reconciliation. Zoho v3 is now deployed via S2-CF #1107, but Wix/Zoho consumer switching and scholarship list/detail/sync/filter/paging remain unverified; Zoho sync/export are v2-shaped. [Developer register v2.24](../../integrations/WEBSITE-DEVELOPER-REQUIREMENTS.md#s2-scholarship--scholarship-developer-fields-v3-and-admin-ui-delivery-13-november-2026), [F-SCH acceptance](../STUDYSEARCH-FEATURE-ACCEPTANCE.md#f-sch--scholarship-coverage-and-eligibility-iq-00082--iq-00241-and-coverage-family) and [API v3 definition](../../integrations/api-v3/API-V3-FIELD-DEFINITION.md#s2-scholarship--scholarship-fields-websitezoho-v3-and-admin-operator-coverage-13-november-2026) now carry the scoped next steps; no new dashboard, budget or execution request. Legacy mechanism narrative remains a dated snapshot. Owner S2-Scholarship with single API integrator.

**S2-SCHOLARSHIP MODULE — 13 NOV 2026 (Operating Model v1.19):** The independent Claude chat **S2-Scholarship** owns F-SCH, separate from S2-CF, S2-Intakes and AER. The [developer register v2.22](../../integrations/WEBSITE-DEVELOPER-REQUIREMENTS.md#s2-scholarship--scholarship-developer-fields-v3-and-admin-ui-delivery-13-november-2026), [API v3 fields](../../integrations/api-v3/API-V3-FIELD-DEFINITION.md#s2-scholarship--scholarship-fields-websitezoho-v3-and-admin-operator-coverage-13-november-2026), and [F-SCH.05–.07](../STUDYSEARCH-FEATURE-ACCEPTANCE.md#f-sch--scholarship-coverage-and-eligibility-iq-00082--iq-00241-and-coverage-family) specify developer field completeness, 77 long-page recoveries, controlled same-ID readmission and actual existing Admin UI filters. Dated S2-Scholarship report: 1,202 published; field population description 822, application method 878, award duration 418, country nationality 144, benefits 1,015. Reader first live cycle: **0 newly admitted**; no published gain from the readmission shadow. Pilot #1077 is closed; Website v3 scholarship additions live, **Zoho v3 unverified**. The historical 12 Nov 16:00 mechanism snapshot is not current execution state. Docs update does not toggle `sch_elig.readmit_on`, trigger background work or authorise a consumer cutover. Coordinate shared consumer code; no parallel PR conflicts.

**S2-INTAKES JULY NEXT-YEAR PERIOD DECISION — 13 NOV 2026:** Platform Admin **conditionally approved** an existing-planner fix for 110 Canterbury and 6 Massey **candidate** July intakes: match course-proven July/Semester Two offering to the future 2027 July start (Canterbury 19 Jul; Massey 12 Jul), despite an earlier February start. Never roll an explicit 2026-only offering forward, infer missing course applicability or promote the nine Massey + one Otago application-deadline-derived month errors. Preserve all G1–G4 and source guards; use exact-ID rolled-back tests, one qualified release, and net date/Website+Zoho parity read-back. [Decision/negative matrix](../processes/intake-dates.md#14-s2-intakes--next-year-named-july-intake-matching-decision-13-november-2026) · [F-INT acceptance](../STUDYSEARCH-FEATURE-ACCEPTANCE.md). The 116 are not promised admissions, and F-INT.07/.08 UI/v3 deadline fields remain outstanding. This docs decision is not a new background/on-demand request.

**S2-INTAKES MODULE — 13 NOV 2026 (Operating Model v1.18):** The parallel Claude chat **S2-Intakes** owns F-INT date/source/calendar/deadline recovery and Website/Zoho v3 date contracts, distinct from S2-CF (general course fields) and F-AER (academic entry). The central [developer register](../../integrations/WEBSITE-DEVELOPER-REQUIREMENTS.md#s2-intakes--course-intake-module-developer-requests-and-v3ui-acceptance-13-november-2026) now tracks REQ-25/-48/-51/-69 and R28; the [API v3 definition](../../integrations/api-v3/API-V3-FIELD-DEFINITION.md#s2-intakes--course-intakes-deadlines-and-date-evidence-13-november-2026) and [F-INT acceptance](../STUDYSEARCH-FEATURE-ACCEPTANCE.md) require field-level source, optional Admin columns/filters and independent Wix/Zoho proof. The last AER chat's 43 course/105 entry-row admissions, Adelaide approved-domain bug, 60 stranded search providers and on-demand request `f053937d` remain with F-AER; **do not miscount/assume ownership**. No background/on-demand work is authorised merely by this docs update; previous stopped chat stays stopped until explicitly resumed. Reuse existing Intake Run & Validate and Data Delivery instead of adding new screens.

**QUICK START — EXECUTION FIRST (13 NOV 2026; binding model v1.21):** This is the **small context pointer**, not a second status or task tracker. Weekly usage limits require selective reads and testing. Do not reread the full 500k-character [Execution Register](../STUDYSEARCH-EXECUTION-REGISTER.md), rescan Supabase or launch a broad/full test suite for orientation. Read the [Operating Model](../AGENT-OPERATING-MODEL.md) once, then only the specific [F-subtask](../STUDYSEARCH-FEATURE-ACCEPTANCE.md), most recent matching register entry, current PR and directly affected code. Reuse latest recorded evidence; fresh, narrowly scoped live queries only where material truth changed or a release gate requires it. Targeted tests in development; full governed CI at release. Resolve the next known blocker and verify output, rather than starting another discovery/pilot. Use one integration owner (Claude), and record only material changes and verified admissions.

**OPERATING MODEL v1.10 — BOUNDED WORKER WRITE PATHS (10 NOV, permanent):** a worker/API recording call and its triggers do constant-time work per item; admission, catalogue scans and consumer read-backs belong to the settling job; `exception when others` does not catch a statement time-out; a cap change is verified by measured throughput; no orphaned items after a job fails; paid answers are replayed before re-asking. See [the Operating Model section](../AGENT-OPERATING-MODEL.md#bounded-work-on-worker-write-paths-throughput-is-measured-not-assumed-platform-admin-10-november-2026-permanent-rule).

**OPERATING MODEL v1.8 — TEST-RUN EFFICIENCY (10 NOV):** one full governed run per final head; targeted tests plus central guards while developing; drafts until final; batch independent QA-passed releases through one full run; never push only to resolve a generated-file conflict; parallel shards and a CI-generated register are the engineering follow-ups. See [the Operating Model section](../AGENT-OPERATING-MODEL.md#test-run-efficiency-one-full-run-per-final-head-fast-by-design-platform-admin-10-november-2026-permanent-decision).

**P0 CROSS-DOMAIN UI AND FIELD CONSOLIDATION — PLAN FIRST (10 NOV 2026):** The Platform Admin has stopped repeated AER/Layer 4 and settings/nav spot fixes. Before any new discretionary UI/Layer 4 PR, Claude must review **every tracked course/provider field plus untracked scholarship/ranking/lifecycle domains**, the whole source→read→validate→admit→publish→consumer path, real UI labels, role/route links, and all Firecrawl/AI/field quota controls; deliver **one integrated grouped implementation plan in the existing [F-subtask acceptance contract](../STUDYSEARCH-FEATURE-ACCEPTANCE.md#p0-cross-domain-field-delivery-and-operator-ui--one-integrated-review-and-repair-plan)**. Existing `DataDelivery`, `LaneFunnels`, `SettingsRegister`, `PipelineSettings`, `Toolsets`, `nav-map` are reusable; no second dashboard, settings wall or parallel tracker. Genuine Layer 4 decisions stay human; technical/evidence errors use existing recovery, not human queue. Verify actual deployed UI; do not invent controls. Continue live platform automation and critical security fixes, but **plan and reconcile one coherent integration sequence before isolated code changes**. Accept only truthful production data and operator journey outcomes.

**MANDATORY ACTIONABLE APPROVALS — OPERATING MODEL v1.6:** Before asking the Platform Admin for a new approval, Claude must (1) check whether the exact action was already authorised; (2) prove that a currently deployed Admin UI control and authorised route actually exist, or explicitly say **“No Admin UI control exists”** and prepare the reviewed, authorised migration/workflow instead; (3) give precise scope, before/after, actual screen/navigation or release PR, role, audit reason, risks, reversal and verification. A service-only SQL function's approval row is not a human UI action or automatically a new policy decision. Never send the Platform Admin to a nonexistent UI component. [Permanent rule](../AGENT-OPERATING-MODEL.md#approval-requests-must-be-actionable-and-ui-verified-platform-admin-10-november-2026). For #984, the approved bounded 10-course verification must not be re-escalated as an undefined additional approval; any separate approval-policy constraint is to be explained with an exact actionable decision.

**P0 DELIVERY-FIRST RESTRICTION — EFFECTIVE 10 NOV:** [Operating Model v1.5](../AGENT-OPERATING-MODEL.md#immediate-data-delivery-priority-over-discretionary-prs-platform-admin-10-november-2026). Stop spawning/releasing optional F-OPS.04 phone-polish and other noncritical PRs (#971/#972/#979/#981 are parked), preserve their work, no wasted CI churn. Focus existing agents/release capacity on source-verified course AI admission above 163, one real Provider Fill Fields basic→enriched outcome, and proof on the existing Data Delivery UI. No new pilot, dashboard, task tracker or repeated discovery. Continue critical security/data-integrity fixes and mandatory release QA. Resume discretionary work only after measured production delivery and explicit priority review. **This overrides any older remaining-delivery ordering that sends agents to mobile UI improvements while data admissions remain stalled.**

**ROOT-CAUSE / PR CONTAINMENT — PERMANENT RULE (10 NOV 2026):** See [Operating Model v1.4](../AGENT-OPERATING-MODEL.md#root-cause-first-delivery-and-pr-containment-platform-admin-10-november-2026). Stop recurring patch/QA loops: resolve defects at their shared owning function/state contract, add targeted regressions, integrate genuine dependencies, retain one release controller, run full governed CI only on the final qualified head, and verify actual operator data admission/publication. Do not spawn another discovery/pilot/PR simply because a QA finding arrived. Changes to engineering practice live in the model; implementation and test fixes live in Pilot; completion evidence lives in the existing feature plan and register. Latest source/PR state overrides older static priority notes below.

**Quick Start amendment, 10 Nov 2026 (v1.3):** No Claude development schedules exist or may be created without Platform Admin approval (see the operating model v1.3 section). The only plan is the **Reconciled execution plan** table in [STUDYSEARCH-FEATURE-ACCEPTANCE.md](../STUDYSEARCH-FEATURE-ACCEPTANCE.md): resume at its first row with no genuine Dependency. Settings: minimum human controls ([audit §13](../SETTINGS-CONTROL-AUDIT.md)).

**Next executable priority pointers (Platform Admin order, 10 Nov; state lives in the plan table, not here):**

| # | Plan row | Immediate next action | Acceptance |
|---|---|---|---|
| 1 | **F-PDESC.04 / .01** Provider Fill fields + verified Run Now | Release identity fix (Agent E) and Provider Catalogue Fill fields/quality columns (Agent B), then re-run the Sydney cohort from Run & Validate and verify admission and Website/Zoho. Run Now is already active (10 Nov 05:16); do not re-activate. | An on-demand provider description admitted and consumer-verified |
| 2 | **F-PDESC.02** Upgrade basic profiles | Release Agent C's eligibility fix; basic registry profiles must not block About Us enrichment; the seven universities are examples, not a pilot | Basic → Enriched, published |
| 3 | **F-CDESC.02/.03/.05/.06** Course-description machine admission + Fill description | Live since 9 Nov. **10 Nov 23:55 throughput defect** ([register](../STUDYSEARCH-EXECUTION-REGISTER.md)): admission inside the AI worker's 8 s recording call lost whole batches (about 118 readings against a 2,000 cap). Fix released as Pilot #1001 on 11 Nov (live md5 verified); observe the next standing job, then release the 1,500 stranded items of job `bba24b11` and replay the 385 paid answers | Readings a day close to the cap for two unattended cycles; new descriptions with Website read-back |
| 4 | **F-INT.02/.03/.05** (IQ-00313) | Intake automation and D3 recovery: course/university scope and two unattended cycles | Retained exact dates with consumer parity |
| 5 | **F-OPS.03A / .05** | Add machine-admission and provider-quality stage counts to Data Delivery; release the control classification (Agent F) | Operator reads progress without asking Claude |
| 6 | Other F-workstreams | Per the plan table; Platform Admin gates listed there | — |

**Platform Admin gates open (do not work around):** disable the Claude development schedule (`trig_01Y4yZJc1dr8R2mDgpqwopwF`) in Scheduled tasks; G3 R23/R24 (#945) held for the Wix/Zoho emails and go-ahead; La Cité paste; machine word-list decision (UNSW/Flinders/Monash) and UQ text; any Firecrawl or AI ceiling increase (Firecrawl reads 20 used up; AI US$1 provider lane).

**Working rule:** If a priority has moved since this pointer was written, reconcile only its most recent GitHub/DB evidence and replace this small pointer when materially changed. Counts in historical entries are not current status. No new tracker, report suite or rediscovery programme.


**CURRENT COURSE DESCRIPTION AI DELIVERY — 10 NOV 2026:** [Platform Admin approved source-verified machine admission for course descriptions from existing stored course pages, no new pilot](2026-11-10-course-descriptions-autonomous-ai-admission-decision.md). 35,689 active courses / 163 described / 35,526 missing, 1,441 course description Layer 4 pending at baseline. Claude must implement a narrow audited source-proved machine-admission route rather than lowering `enrich.course_description_review_first=100000` as a shortcut; retain genuine manual/identity/evidence holds and G1–G4. No second reader or programme tracker. The earlier Run Now gap has been corrected: `run_now.jobs` included `provider-description-read` alongside intake at the 10 Nov 05:22 AEDT read-back; verify actual cohort execution and consumer outcome, rather than requesting repeated activation. Release, verified canonical/Website/Zoho gains and visible F-OPS.03A UI are the acceptance gates. Older D5 first-description human-only direction is superseded **only for the newly implemented safe class**.

**CURRENT ENGINEERING OWNERSHIP — PLATFORM ADMIN DECISION, 9 NOV 2026:** [Claude is sole responsible engineering controller; experimental atomic lease/adoption gate retired](2026-11-09-claude-sole-engineering-controller-decision.md). Claude owns code, integration, approved releases and remediation; delegates only implementation/independent QA. Historical 6 Nov cross-model handover and #385 adoption mandate no longer block routine development or otherwise approved releases. Real serial release execution, G1–G4, audited actions, protected approvals and validation remain. Earlier controller directions below are historical and do not override this decision.


**CURRENT INTAKE AUTONOMY EXECUTION PLAN — 9 NOV 2026:** [Exact 09:00–23:00 production cutover gates and F-INT execution tasks](2026-11-09-intake-autonomous-production-cutover-plan.md). Live: 1,534 active exact dates, 30,302 without exact date (many genuinely month-only), last filled 8 Nov 08:26 UTC; only 78 providers have approved calendars (67 proposals/51 pending), 8,793 no revisit, 2,413 page-exact-date candidates without an admit route; #931 draft adds no dates and spreads rechecks over 14 days. **P0 integration collision:** PR #930 and #931 both use migration numeric version 20261109020000. Full system autonomy and actual correct published net gain are today’s acceptance; 30,302 fictional exact dates today is not a permissible goal. Gate times are checkpoints, not delivery promises.


**OVERRIDING PROVIDER DESCRIPTION DECISION — 9 NOV 2026:** [All 3,103 AU/NZ/CA providers, source-backed autonomous descriptions and controlled machine admission](2026-11-09-all-providers-autonomous-description-delivery-decision.md). Platform Admin requests all providers attempted and every eligible description populated today, with no per-provider human approval. This is a policy **change to be implemented and legitimately released**, not authorisation for an existing service session to bypass Layer 4, budgets or consumer G3. Use stored/official/free sources, Firecrawl as a metered fallback, verified register facts if no About page; no invented generic claims. Current production has 0 descriptions, five-key AU-only reader and historic 4 human review holds. Prior “20 university wave” is superseded as the target, but remains a harmless diagnostic batch if used to validate first-run outputs.


**CURRENT TOP PRIORITY — 9 Nov 2026, DATA NOT SCAFFOLDING:** [Provider descriptions + intake dates autonomous data-delivery mandate](2026-11-09-data-population-first-delivery-mandate.md). Live baseline: providers.description 0/3103, pdesc scope five AU universities / four Layer4 proposed + one evidence-held; active exact dates 1534, undated month/date rows 30302; 151 filled intake events (142 currently retained active dated), not proof of consumer publication. Require first positive *correct* production data gain, then sustained provider/campus/source coverage. All previous draft/UI work remains secondary until integrated and data outcomes demonstrated.


**SUPERSEDED 9 Nov 2026 by the sole-controller decision above (historical record; its lease/adoption conditions no longer apply):** **Overnight controller ownership disposition (8 Nov 2026):** [Scheduled Claude controller lease decision](2026-11-08-scheduled-controller-lease-disposition.md): docs-only Admin scheduler proof verified; conditional designation for development, **no merge or production write while atomic lease and real adoption remain pending**. Preserve previous disabled Codex schedules and all existing approval gates.


**Live architecture and complete production inventories (8 Nov 2026):** [Capability and Data-Population Inventory](../inventory/STUDYSEARCH-CAPABILITY-AND-DATA-POPULATION-INVENTORY.md) and its linked CSVs: 2,317 SQL function signatures, 184 automation definitions, 1,236 setting definitions and 1,792 enrichment plan instances. Read-only snapshot, not live acceptance.


**Current feature design and completion audit (8 Nov 2026):** [Feature Acceptance Contract](../STUDYSEARCH-FEATURE-ACCEPTANCE.md) (F-INT through F-OPS substeps and UI acceptance), [Executive Delivery Status](../STUDYSEARCH-PROGRAMME-STATUS.md) (dated derived snapshot), and [canonical Execution Register](../STUDYSEARCH-EXECUTION-REGISTER.md) (authoritative issue/PR/production evidence). Earlier 6 Nov snapshots in this index are retained as history, NOT current production state.


**Current cross-domain delivery mandate (8 Nov 2026):** [Autonomous delivery and closure: intakes, fees, English, descriptions, AER, scholarships, UI and P0 integrity](2026-11-08-cross-domain-autonomous-delivery-closure.md). This is the target/acceptance contract; the sole live SS/IQ status remains in [the execution register](../STUDYSEARCH-EXECUTION-REGISTER.md). Current production state must be verified; older controller baseline below is historical.


**HISTORICAL (superseded 9 Nov 2026 by the sole-controller decision; retained as dated audit evidence, not a current hold):** **Controller directive — 2026-11-06T23:24:11Z: CODEX CONTROLLER RELEASED.** Codex appointment revoked; engineering stopped `2026-11-06T23:18:14Z`. Claude Sonnet5.5 (High reasoning effort) is the nominated successor, acceptance pending. Canonical checkpoint `CP-382-20261106T232411Z`; [final handover](2026-11-06-weekend-controller-continuity.md#codex-controller-released--final-handover-to-claude). Both Codex-owned future tasks are disabled: weekend `Automation_0a2ea05fa5e08191b96d4341b0c2cf90`, Monday `Automation_af49e809a9f081918404af049e370634`. Atomic6d95 remains generation0/no owner/no lease/adoption pending; Codex never acquired ownership. The old transfer target is stale; no Codex reacquisition/resumption is authorised. Claude must independently verify/accept authority and installed account fences. At23:20UTC83 pending/80 overdue, original3 incorrect deadlines active, latest watchdog42311080562failed. No Codex in-flight operation; direct Cloudflare account inventory unavailable. Existing PR892–897 and holds890/875 preserved.

## Current controller checkpoint — 6 November 2026

This 6 Nov checkpoint is itself historical (superseded 9 Nov 2026 by the sole-controller decision); its lease, adoption and fencing statements are not current holds.
Start with [Controller handover](../STUDYSEARCH-EXECUTION-REGISTER.md#controller-handover)
and [validated machine state](../STUDYSEARCH-CONTROLLER-STATE.json), then independently
verify live state under [the operating model](../AGENT-OPERATING-MODEL.md#permanent-ai-controller-continuity-6-november-2026-admin-382).

- Historical Claude release (superseded by the current Codex stop/Claude nomination): Claude explicitly released control in [Admin #382](https://github.com/msinghbs-ai/coursefinder-admin/issues/382#issuecomment-6686299314). Atomic ref `studysearch-controller` at `6d95b3e1` records published release to Codex; owner and lease remain null, fencing adoption pending. No active production authority or completed transfer is claimed.
- Pilot main remains `4ba94e3f`, UI v2.15.489/package 0.1.416 (lastHTTP/asset verified20:12UTC; fresh21:13GET403/error1010, independentwebunavailable; fullmigrationledger/helper baseline21:16UTC), coverage Worker v0.59.8/edge 239, migration head `20261106400000` with 1,791 versions. Exact Cloudflare commit and authenticated UI remain unverified.
- Final takeover candidates #895 `bcceb856`, #896 `7984e7bd`, #894 `8bde11f8`, #893 `201b9126` pass all current source/metadata checks: respectively1,951/1,951/1,967/1,992tests, zero failures/skips/flakes. Bundles are verified; #892 is integrated. Source covers8write-capable/2throwaway-only/9reporting definitions with safe credential targets and dispatch inputs. Actualaccountfencing/activeownership remains blocked by demonstrated403 and unavailableCloudflare/directSQLcontrols.
- #877/#889/#891/#887 are merged; bounded operational and authenticated operator checks remain open. #890 G3 and #875 remain held. No production release, migration or data correction occurred in this execution.
- Deadline P0: historical97non-closing/14closing/41context-required classification retained. Ten additional cohort courses/twelveintake-datepairs verified through allthreeconsumerSQLfunctions; cumulative17courses/21pairs atdifferenttimes,48courses/HTTP/cacheunverified. Original three bad values remain active22:57UTC; no correction or wider authority. [Evidence](../validation/2026-11-06-deadline-semantic-p0.json).
- **P1 alert collector recovery:** CP-382-20261106T225925Z; original Claude task `trig_01Eo7QrJXR24e774gNzLUvTi` / Platform Admin Claude account / :59UTC located. PR897 final33d7ef91 qualified (Node22 1992/0/0/0; genuinePG116/38; final checks/reuse verified). At22:57UTC83 pending/all unattempted/80 overdue, original79 IDs preserved; real delivery/backlog reduction/watchdog PASS unverified. Actual account fencing/atomic authority and Claude scheduler runtime access remain blocked. [Canonical handover](../STUDYSEARCH-EXECUTION-REGISTER.md#controller-handover) · [Single D382 owner action](2026-11-06-weekend-controller-continuity.md#consolidated-platform-admin-decision--ownership-cutover-and-exact-p0-correction).
- Job-count discrepancy resolved by indexed automatic flag history:128records/87transitions, all176states match the independent17:07snapshot (163active), historical13:46aggregate164 reproduced. Current21:16count is162active/176total; do not reactivate to restore a count. Original13:46individualstates remain inferred; no universal direct-write exclusion. Last12,000cronrows cover10:43–18:07/last2h with0failures. [Evidence](../validation/2026-11-06-controller-cutover-verification.json).
- Reader IQ-00046: counters reconciled; bounded cause diagnosis now exhausted inspected metadata. Three direct200/fetch_failed rows share one provider/URL; current adapter/codes do not establish empty-body versus caught-exception cause. Logs do not identify per-item failure. Watchcondition cleared20:21 but issue remains triaged and2091pages exhausted. No unchanged reprobe, patch or closure; seek new evidence or continue another safe lane. [Evidence](../validation/2026-11-06-controller-cutover-verification.json).
- Developer guide **Issue 7** is current; Issue 8 is draft. The Issue 6 currentness line below is historical and superseded.
- Configured weekend/Monday resumptions do not establish continuous execution. Checkpoints describe actual bounded work only; no unattended monitoring, heartbeat or successor acceptance is claimed.

Record: [weekend controller mandate and findings](2026-11-06-weekend-controller-continuity.md).
The existing execution register and live integration issue queue remain canonical.

## Historical index baseline

Last updated: 2026-10-31 13:25 AEDT by Claude (main integrator), under the StudySearch transformation mandate. The sections from "Standing order" down are kept as written on 26 Oct 2026 07:40 and are history; the "Current state" section below supersedes them where they differ.
Earlier stamp: 2026-10-26 07:40 AEDT by the data-engineering agent. Overnight 08:00 report: ../ui-audit/2026-10-25-overnight-outcomes.md ("08:00 report").

**Ledger maintenance:** [Claude AER and cross-workstream reporting instruction](2026-11-03-aer-cross-workstream-ledger-instruction.md) — maintain the existing execution register and feedback queue; no parallel ledger.

## Current state (31 Oct 2026)

**The platform is being renamed StudySearch** (formerly CourseFinder).
- Technical names stay: repositories, the Worker, database objects, APIs, keys and storage keys (transformation record §2.9).

**Active mandates:**

| Date | Mandate | Record |
|---|---|---|
| 2 Nov | CF-247 Layer 4 AER live queue assessment: 539 pending (499 course/40 provider), dropped-row risks, governed per-item admission/recovery playbook (**no decisions submitted**) | `2026-11-02-aer-layer4-admission-review-and-playbook.md` |
| 2 Nov | CF-247 AER catalogue-first coverage: 1,476 eligible AU/NZ providers, 34 source-linked; named university gaps and RMIT/UWA classification (**audit/mandate; no reads deployed**) | `2026-11-02-aer-catalogue-provider-coverage-reconciliation.md` |
| 2 Nov | CF-247 continuous AER assurance: automated provider/qualification/source gap reconciliation, Admin progress and existing email/push reporting (**design only; ingestion holds remain**) | `2026-11-02-aer-continuous-assurance-mandate.md` |
| 2 Nov | CF-247 AER design Draft 1.2: qualification-first, global IB/GAC/A Levels, missing UK and other country coverage, postgraduate admission, all eligible AU/NZ providers and provider source URLs (**design only; ingestion holds remain**) | `../ENTRY-REQUIREMENTS.md` §F; `2026-11-02-aer-qualification-coverage-gap-assessment.md` |
| 31 Oct 10:23 | StudySearch production stabilisation, operational autonomy and rebranding (**primary**) | `2026-10-31-studysearch-transformation-mandate.md`, record `2026-10-31-studysearch-transformation.md` |
| 30 Oct 22:30 | AER production closure: D5 release, human Layer 4 review support, outcome register; **ingestion held** (no QUT, B5 or recovery reads) | `2026-10-30-aer-production-closure-mandate.md`, response `2026-10-30-aer-production-closure-response.md` |

**Live release:**
- Pilot `main` `115e40b3` = v2.15.382; migration head `20261031070000` (verified 14:24).
- Today's releases: v2.15.379 (remediation hold), v2.15.380 (enrichment mismatch hold), v2.15.381 (course item speed-up), v2.15.382 (Rule 4 retired; `entry.min_scores[]`).

**Decisions:** D1–D6 approved 31 Oct 13:30 (`2026-10-31-studysearch-d1-d6-approval.md`) and executed (record §22 to §28). Developer guide issue 7 is current.

**Live health (31 Oct baseline; record §2):**
- Consumer API at its approved baseline, 0 server errors in 7 days.
- 3 scheduled jobs timing out since 29 Oct; root cause found (record §7).
- Website search p95 13.5 s.
- 1,141 Layer 4 items pending, 1,000 of them AER.

**Decisions awaiting the Platform Admin** (record §5):
- consumer API speed-up of search (G3);
- an additive field for all published entry scores (G3);
- anonymous access to `admin_ui_error_report`;
- lifting any ingestion hold;
- any Worker or repository rename.

**Consumer API rule (Platform Admin 31 Oct 2026 11:24):** every consumer API change, even one that changes no response field, ships with a developer guide issue with a version line, a dated handover note for the consumer's owner, the release version and change-control reference (record §10).

**Developer guide:** issue 6 (31 Oct, `scale_stated`) is current; issue 5 (29 Oct) is superseded.
New sessions (human or agent): read this file first. Full operating rules:
docs/platform/AGENT-OPERATING-MODEL.md (read once). This repo is the durable record;
chat history is transport only. Australian English throughout.

## Repos
- DECISIONS (this repo): msinghbs-ai/coursefinder-admin — WHAT and WHY. Nothing executes here.
- EXECUTION: msinghbs-ai/Coursefinder-Pilot — Cloudflare Worker + Supabase code.
  All deployments ship from Pilot; this repo's wrangler target is NOT the live Worker.
  Pilot working rules: its CLAUDE.md (CF-247). Every code change traces to a decision
  recorded here FIRST.

## AER consolidated design review — 2 November 2026

SS-017: [detailed assessment](2026-11-02-aer-qualification-coverage-design-review.md), aligned to the existing [AER-GAP-01–10 register](2026-11-02-aer-qualification-coverage-gap-assessment.md) and ENTRY-REQUIREMENTS.md Draft 1.2 §F; consolidated design `../AER-TECHNICAL-DESIGN.md` v1.1 §13. Documentation assessment delivered on 2 November. The same day the Platform Admin decided the scope (D-A1), the stored-copy reads (D-A3) and the additive tables (D-A5), and the implementation is tracked as SS-017 in the execution register; a G3 approval for any consumer change (D-A6) was last recorded as open on 3 November. This review did not itself lift any hold or authorise any deployment.

## Thread files (read only what a task touches)
Base: https://raw.githubusercontent.com/msinghbs-ai/coursefinder-admin/main/docs/platform/nz-enrichment-brief/

| File | Contents |
|---|---|
| 2026-10-23-nz-enrichment-brief-assessment.md | Day-one DB introspection, coverage matrix |
| 2026-10-23-nz-brief-verification-and-release-plan.md | Verification answers, Releases 1–3 |
| 2026-10-23-nz-brief-decisions.md | Decisions + thread (quarantine a07de41, 8a query, R1 extension, identity root cause) |
| 2026-10-23-platform-throughput-gap-schema.md | Plan + live build thread (diagnosis: upstream starvation, not budget) |
| 2026-10-24-nz-field-admission.md | NZ field push; item 5 shipped (1,874 links); entry-requirements spec section 5 |
| 2026-10-24-zero-yield-reacquisition.md | Zero-yield flow v2.15.338; UoA pilot; standing order section 6; detect-only |
| 2026-10-24-au-quick-wins-and-247-ingestion.md | AU triage vs developer gaps; links widened (16,889 AU + 1,863 CA); 24/7 audit; hourly report ≤8 min fresh |
| 2026-10-24-au-builds-and-enrichment-jobs.md | MANDATE RECORD (not a response): Phase 0 R1-first, B1–B6, E1–E6, Phase 3 gates, expected coverage; builds programme not completed |
| 2026-10-24-r1-release-plan-and-verification.md | R1 full plan, PR #681 / v2.15.339, independent tests and read-only live verification |
| 2026-10-30-field-report-throughput-diagnostic.md | Read-only diagnostic of the 30 Oct AU/NZ/CA field reports: metric definition, read-to-admission funnels, negative-delta reconciliation, decisions TD1–TD6 (binding without proof, gap-queue re-queue of wrong-page courses, unmet 23 Oct re-reads, report and label changes) |
| 2026-10-30-aer-production-closure-mandate.md / -response.md | AER closure mandate and Claude's response: D5 verified and released, decision C1 (course outcome register), Layer 4 position |
| 2026-10-30-layer4-*.md | Kimi Work Layer 4 batch verifications and Skill v4/v5 records (scholarships, course links) |
| 2026-10-31-independent-production-health-check.md | Independent read-only health check (31 Oct 10:10) |
| 2026-10-31-project-status-review.md | Project status review (31 Oct) |
| 2026-10-31-studysearch-transformation-mandate.md | **Current primary mandate** (verbatim) |
| 2026-10-31-studysearch-transformation.md | **Canonical programme record:** baseline, findings F1–F8, roadmap, approvals, progress |
| ../STUDYSEARCH-EXECUTION-REGISTER.md | **Single execution register** (SS-001 onwards): every StudySearch task, status, approval, PR, verification and next action |
| 2026-10-24-target-only-audit.md | target_only audit result (A 87 / B 455 providers), write-back paste, O10 decision |
| ../ui-audit/2026-10-24-layer4-parked-triage.md | MANDATE + Phase 0 census: 2,011 Layer 4 items, classification, Phase 1 designs and budget, Phase 2 learning loop |
| ../ui-audit/2026-10-25-speed-reconfiguration.md | **PRIMARY TRACK from 25 Oct 22:05:** speed programme (map-then-match binding, search quality, calibrated stops, Tranche 2, velocity + live visibility S5/S6) |
| ../ui-audit/2026-10-25-overnight-outcomes.md | Overnight outcomes mandate O1–O7, Track C, paused-lanes table |
| ../ui-audit/2026-10-24-title-and-international-intent-mandate.md | MANDATE (queued after audit → O10 → R2): NZ title verification, AU international-intent pages |

## Standing order
**25 Oct 22:05 / 22:27 (Platform Admin): the speed programme (`../ui-audit/2026-10-25-speed-reconfiguration.md`) is the primary track.** Merge queue: **#694 gate consolidation → SP-1 → #695**; Track B release 1 keeps its place (with S5/S6 inside, or split to 1.1 straight after if bundling adds more than a day). Naming: #694 is "gate consolidation", never "S1"; speed releases are SP-x only.

R1 (Q2 backoff, Q4 narrowed, Q3 ledger, apply-time identity check) — **LANDED** as one
release, v2.15.339 / PR #681. R3 (`health-hourly`) — **LANDED** as v2.15.340 / PR #682;
provisional headline target remains unset until its first full week of rows.
target_only audit — PRODUCED; O10 APPROVED; route staged (c)-then-(b) — **R2 LANDED v2.15.350 (PR #692) with tranche 1 applied** (`2026-10-24-target-only-audit.md` sections 3–5); (b) rule-settings proposal after ~2 weeks of the weekly line, starting from the 951-override finding. Then R2 (Q1 at
search.daily_picked_cap = 100; raise only on ledger evidence). Then stepped read-lane
test. Then S1 full (absorbs zero-yield table; contract test: search, AI match AND
finder all consume rejections). Then 8a remainder (country_identity_rules table).
Then items 9, 10, 11. B1 entry requirements remains first among the AU builds and does
not bypass O10/R2 or any approval gate.

## Decisions awaiting Platform Admin
(Pruned 25 Oct 2026 15:15 to the next human gates, per the Platform Admin's 14:50 decisions.)
1. **SIT 3954 extract**: shown in `docs/platform/ui-audit/2026-10-24-layer4-parked-triage.md` ("SIT 3954 stored register extract"). The register itself titles 3954 "--", which points to the one-row quarantine paste. Say the word and the file is written; also delete branch `cf247-sit3954-extract` (deletion refused from this session).
2. **Track B release 1 PR**: review before merge (Fields section, Pipeline strip on `pipeline.course_events`, Read-with-AI v2, calendar retirement tidy, lineage test).
3. **#694 gate consolidation merged and live 23:17** (rule 9: the agent merges its own PRs; review is retrospective). #695 Track C merged 26 Oct 07:36 (reader off).
4. **Speed programme**: decided 22:27 (SP-1 before #695; no-page gap cause and conjoint rule approved; S5/S6 inside Track B R1 with the one-day split rule; Tranche 2 Part A applied by the Platform Admin). **SP-1 #696 merged and live 23:21** (rule 9; switch `bind.no_page_on` when ready); Tranche 2 Part B after Monday's weekly line; O8/O9 plan tiers for S3.

Parked, not gates today: policy proposals paste (65 rows, mark when ready); zero_yield.auto_reset; UoA catalogue-host; O5 / O8 / O9; R3 headline target.
Closed 25 Oct: #693 accepted (live re-check is the verification); Track B release 1 approved as specified; 2.2–2.4 specs accepted (queued behind Track A); `reading.read_attempts_max` open row; real-tables rule (AGENT-OPERATING-MODEL rule 7); entry-requirements feed confirmed (additive in existing payloads); Sydney 2026 edition current plus a quarterly re-check; entry build plan approved; case-by-case rendering rule.

## Live platform state (key releases)
v2.15.334 Release 1 · v2.15.335 read-lane capability ·
v2.15.336 item 5 course_url fill · v2.15.337 identity CRICOS-AU-only ·
v2.15.338 zero-yield flow detect-only · v2.15.339 R1 backoff/ledger/why-idle/identity ·
v2.15.340 R3 health-hourly · v2.15.341 UI audit Phase 0 (plain errors, coverage-admit http fix; PR #683) ·
v2.15.342 HOTFIX manual task / stall visibility / Layer 4 held-fee address / target-only refused at start (PR #686) ·
v2.15.343 HOTFIX 2 person task passes the stop in the credit check; credits-refused status (PR #687) ·
v2.15.344 UI audit Phase 2 course list fee basis and sorts (PR #684) ·
v2.15.345 UI audit Phase 3 dedupe and data-quality leaks (PR #685) · v2.15.346 UI audit Phase 1 list internals stripped (PR #688) ·
v2.15.347 HOTFIX 3 Task manager read speed (PR #689) ·
v2.15.348 Campuses by CRICOS location name + Provider filter (PR #690) ·
v2.15.349 Firecrawl targets rule reports the failing condition (PR #691) ·
v2.15.350 R2: daily picked-courses cap 100 + per-course stop 6 (PR #692); tranche 1 (25 overrides) applied ·
v2.15.351 list columns on every sort (PR #693) · v2.15.352 gate consolidation (PR #694) · v2.15.353 SP-1 (PR #696, worker v0.47.0) · v2.15.354 SP-1.1 first-run pending cap (PR #697) · v2.15.355 Track C entry requirements step A, reader off (PR #695, worker v0.48.0).
No open PRs (24 Oct 23:40).
Hotfix record: docs/platform/ui-audit/2026-10-24-hotfix-manual-task-and-layer4-entry.md (re-open paste file with the Platform Admin).
Key metric: course-page binding % — every field's ceiling. Tracker definition (official link active, published providers), 25 Oct 22:20: NZ 47.0% · AU 75.1% · CA 69.8% (the earlier "NZ 53.5%" could not be reproduced from current tables; see the speed record).
R1 live evidence: worker v0.46.0 writes the per-mode ledger; 15-minute backoff cap;
90-day ledger retention; apply-time identity quarantine; Work queues why-idle line.
R3 target: 0 (not set) until a week of rows; then Platform Admin sets the provisional target.
Hourly report "StudySearch hourly stats" is the daily view.

## Guardrails (summary — full rules in AGENT-OPERATING-MODEL.md and Pilot CLAUDE.md)
Config over code; settings keys for every tunable; no new status values; quote-on-page
for AI admissions; manual bindings never touched; count guards on paste jobs; no new
panels/SOPs without retiring old; decisions precede code; nothing applied, merged,
deployed or activated without its approval gate.

