# StudySearch — Cross-domain autonomous delivery and closure mandate

**Feature/subtask completion contract:** [Feature Acceptance](../STUDYSEARCH-FEATURE-ACCEPTANCE.md); **dated executive progress view:** [Programme Status](../STUDYSEARCH-PROGRAMME-STATUS.md). The canonical execution register continues to own all issue/PR/live production states; these linked files are design criteria and derived status only, not additional controllers or task queues.

**Platform Admin direction:** 8 November 2026. **Status:** Mandate and baseline recorded; operational acceptance NOT established. **Mode:** Active Remediation.
**Controller:** Current authorised Claude Integration Controller; parallel development agents only within non-overlapping ownership. **This is a scoped mandate, NOT a second issue queue or execution register.** Canonical status and history remain in `docs/platform/STUDYSEARCH-EXECUTION-REGISTER.md`; operational issues remain in `pipeline.integration_issues`; source/role/controls in the operating model, Pilot `CLAUDE.md`, UI catalogue and individual process records.

## 0. Decision and objective
The Platform Admin requires actual autonomous movement in **intakes/start dates/application deadlines, fees, English requirements, course descriptions, provider descriptions, AER, scholarships and provider/course discovery**, and **visible control and progress in the existing StudySearch Admin UI**. Releases, jobs, plans, pages fetched, pending Layer 4 records and green CI are NOT sufficient outcomes. Claude must not focus only on Firecrawl/AER while these domains show no measured admission/publication gains. Do not restart an already finished diagnosis; reconcile existing PRs, decisions and issue fingerprints, then deliver the next missing stage.

**Operating rule:** Investigate → Develop → Test → Integrate → Deploy → verify first scheduled run → verify downstream admission/publication → record outcome → take next issue. An agent finishing is not programme completion. Do not stop all lanes when one flag, reviewer, provider or vendor is held. Do not claim the AI session runs after its execution ends: platform jobs and scheduled validation must operate independently.

**Safety:** G1–G4, code/lineage verification, exact source and course identity, manual bindings and locks, E13/D-R2/D-R3, no AI approval of human Layer 4 work, no unapproved spending, no extra Firecrawl purchase, no API shape change without G3, no destructive write without paste-file authority, no test weakening. Single integrator merges sequentially after full green gates and live hashes. Do not introduce a parallel dashboard, new top-level menu, duplicate controller or second integration queue. Reuse existing Admin Operations/Process results, Queues & yield, Layer 2/3 Operations, Scheduled jobs, Pipeline settings, Platform health, Layer 4 Inbox, and relevant catalogue views per `UI-CATALOGUE.md`.

## 1. Time-qualified starting evidence — remeasure before action
Snapshot sources: Platform Admin's independent read-only report 8 Nov 2026 12:16 AEDT; subsequent Claude checkpoint/PR descriptions. These are different observation instants and must not be treated as one atomic snapshot.
- **P0 IQ-00313:** 10 unsupported Deakin 2028-11-01 commencement dates active, present in Website stored projections and Zoho stored projections; no correction in the supplied validation. CRICOS 0100305, 079321G and 095262C among newly synchronised. Course-specific eligibility unknown; authenticated consumer HTTP exposure not yet verified. A discontinued UQ course CRICOS 092452K also reportedly holds 2 active 2027 intakes. Keep separate P0 IQ-00111.
- **Catalogued outcomes:** exact active commencement dates 1,498; application deadlines 79; course descriptions 163; provider descriptions 0; active AER rows 1,304; published scholarships 1,144; scholarships coverage cases 20,506; rankings 0; course links 33,554; Layer 4 pending 4,108, approved 1,188. These are measurement baselines, not acceptance results.
- **AER:** 605 waiting reviews; after PR #909 Inbox readiness 245 ready (including 38 Approve except), 26 stale, 334 technical, no new human decisions or admissions. Fair mode and stored-source discovery previously remained OFF; confirm the current settings. PRs #906–#909 merged by 12:16 validation; latest verified Pilot main at mandate creation `5c9f46a152`. Revalidate newer releases.
- **English:** prior detailed assessment found 20,749 of 35,690 active courses holding English values (~14,941 without), but it predates this report; capture fresh current baseline and per-stage reasons.
- **Descriptions:** 1,190 course-description Layer 4 items reportedly waiting, 4 provider-description reviews pending, no decisions; independently verify old vs new proposals and publication.
- **Firecrawl:** Platform Admin billing page reportedly showed Standard, 100,000 monthly credits, US$99, 100,251 remaining for 8 Nov–8 Dec. Prior platform mirrors showed 8 → 962 → 956 under an older 5,000 plan view. **Billing page and platform mirror are not reconciled; verify actual vendor authority.** PR #910 (priority floor and 100k plan settings) was open at mandate creation, not a deployed gain. No purchase authorised by this mandate.
- **Autonomous orchestration:** plans are created but four completed plans in last window yielded zero measured fields, with 52 acquisition credits attributed; track IQ-00072 (zero-yield family). Layer 4 and admission bottlenecks are distinct from read acquisition.

## 2. Delivery lanes and task-level acceptance
Every lane has: current baseline; existing issue(s) and process record (verify real identifiers); accountable agent; exclusive function/migration ownership; exact next executable step; upstream/downstream dependency; UI control; 2+ unattended scheduled-run evidence where applicable; before/after metrics; producer-to-consumer integrity check; deployed acceptance. The Integration Controller assigns actual issue IDs and PR links in the existing execution register, not new invented permanent SS IDs.

### P0: intake and consumer integrity — immediate containment, not a separate endless investigation
- Reconcile all 10 Deakin records and UQ CRICOS 092452K against official year/calendar AND course-specific offering, audience and campus. Prevent further unsupported dates being admitted or republished using the existing governed hold; correct/withdraw only under precise authority, with immutable before-state and audit. Validate canonical, Website stored projection, Zoho stored projection, and authenticated API responses distinctly.
- Identify whether a year resolver, source page or publication predicate is shared and fix the cause, with 2027/2028 and discontinued-course regression tests. **Do not substitute the 2028 Deakin calendar date globally without course evidence.**
- Own IQ-00313 and retain IQ-00111. **Done:** zero affected active/projection records, recurrence guard pass, HTTP consumer parity, 2 scheduler cycles without reintroduction.

### Lane INT — intake dates, start years and application deadlines
- Reuse `docs/platform/processes/intake-dates.md`, existing intake jobs, Run & Validate and Process results. Reconcile course page period wording, first-party calendar year, course-specific offering and identity; automatic planner → candidate → evidence gate → existing governed admission → publication.
- Current action: verify autonomous per-stage counts, unknown-year/period, calendar conflict, not queued, held, rejected, admitted and Website/Zoho mismatches; correct missing handoffs, not by loosening provenance. Account for the UQ 098328K admission, distinct from discontinued 092452K.
- **Done:** at least two successful unattended cycles with eligible new intakes progressing to correctly evidenced canonical + consumer states, no unsupported date reintroduced; otherwise durable source-specific holds and zero false admissions.

### Lane FEE — tuition and other governed fees
- Take a fresh live baseline (not supplied by the 12:16 report): providers/courses with fee sources, queued, read, evidence backed, Layer 4 ready, human approved, admitted, published and consumer parity, including expiry/currency/year.
- Restore autonomous fee discovery/read/proposal and downstream handoffs using the existing jobs, cost caps, fee precedence and review policy. Do not auto-admit where human review required. Respect manual fee entries and the existing 18/19 tuition publication reconciliation / fee-integrity issue history, remeasure current.
- **Done:** measured net fee publication gains for eligible source-backed records, correct Website/Zoho values and audit; genuine absent evidence classified, no fabricated pricing.

### Lane ENG — English entry requirements
- Verify `#893` release and current rule/group pipeline, provider/faculty/course exceptions, stored page sufficiency, source identity, residency/audience, review and actual publication. Reconcile historically refused/credit-blocked pages without resetting permanent errors or repeating unchanged paid reads.
- **Done:** autonomous source → extraction → evidence → governed Layer 4 → admission → consumer visibility on eligible courses; measured coverage increase or honest bounded holds, plus cross-course/faculty exceptions passing actual SQL and UI checks.

### Lane C-DESC — course descriptions
- Start from ~163 active, ~1,190 pending Layer 4 and existing `#894/#900` capabilities; verify fresh. Distinguish 18k+ never-queued stored-page courses, held first admission, claim/length guards, source-unverified, human queue, approved and published.
- Restore jobs, proposal/readiness and review-first queue; avoid publishing claims unsupported by the page. Human Layer 4 approval remains mandatory. Design a review-capacity plan; do not create endless new proposals when no reviewer can decide.
- **Done:** throughput of source-backed proposals, actual authorised review decisions, admitted course descriptions and consumer-visible net gains measured and reconciled.

### Lane P-DESC — provider descriptions
- Verify existing `#877` provider-description reader and bounded Run now controls, previously 4 pending and zero published; check current state and activation requirements. Governed discovery → source verification → extraction → human review → admission → website/Zoho.
- **Done:** unattended eligible processing and net published, provider-bound descriptions with complete lineage; keep manual locks and safe first-party identities.

### Lane AER — entry requirements
- Reconcile `#902–#909` and recent replay/row-limit releases; measure **review-ready → human decision → admitted rows → published**, not count one-for-one replacements as gain. Resolve RMIT provider cap, fair scheduling and stored-source switches via authorised Admin control, preserve E13/D-R2/D-R3 and per-provider fairness.
- Add source attempts for providers using free stored links first; paid source discovery only within the verified Firecrawl budget. Park locked/shared-page and ambiguous identity cases by existing review policy. Surface reviewer-ready packets in university-grouped Layer 4 Inbox.
- **Done:** new correct AER admissions and verified consumer publication after authorised review, real provider coverage gains, back-pressure no longer incorrectly counts technical holds; zero blanket approvals.

### Lane SCH — scholarship coverage and publication
- Start from 1,144 published and 20,506 coverage cases as an older baseline; fresh per-provider stages: candidate found, source fetched, classified, eligible, human-review, admitted, published and audience/residency correctly applied.
- Recover existing stored listings/reads first; resume Firecrawl-dependent work only with verified balance and category priorities. Fix zero-yield plans and the classifier → Layer 4 → publication handoff without bypassing trust or evidence.
- **Done:** measurable new verified scholarships in existing consumers, correct source and residency filters; honest no-offering proof and no repeating fruitless paid pages.

### Lane DISC / REL — discovery, provider lifecycle, rankings and consumer reliability
- Verify provider identity, lifecycle cascade, registered-provider coverage, course URLs and linked fields; treat official course links and source verification separately. Measure ranking-source coverage and reason for zero published (do not fabricate ranks).
- Reconcile Website and Zoho individual schedules; no unapproved consumer API shape change. Fix orphan Layer 4 family IQ-00061 and observed zero-yield plans IQ-00072. Track real reader errors and source costs. Provide provenance and course/provider eligibility checks.

### Lane OPS / UI / QA — operator control and cross-domain operational verification
- Extend **existing** Process results and Layer 2/3 Operations, Queues & yield, Scheduled jobs, Pipeline settings and Platform health. If a real UI gap exists, update `UI-CATALOGUE.md` and role guides; no new top-level menu or duplicate dashboard.
- Every lane displays: pipeline name; on/off and scheduled next run; stage counts (eligible/queued/in-flight/blocked/review-ready/admitted/published); 24h gains and trend; oldest age; last actual attempt, first-run success and reason; held cause and next retry; budget credits; provider/region drill-down; event/issue/PR link; pause/resume/rerun only for permitted role, reason and audit.
- Settings, batch limits, reserve, priority, retries and switches MUST be **live labelled configurable settings** with G2 keys, bounds, units, `used_by`, reason, role and change events. NO hidden constants or values buried in migrations without a visible Admin control. Only narrowly justified documented technical safety constants may remain in code.
- UI must distinguish **green job** from **successful stage transfer** and **published data**, and clearly show data corrections/withdrawals as well as new gains.
- Real desktop and phone operation, platform role permissions, contract and genuine SQL fixtures are required. Agent-delivered UI is not complete until the configured control works in a logged-in, authorised session.

## 3. Firecrawl plan and budget acceptance
Vendor billing page: Standard 100,000 monthly credits / US$99 / period 8 Nov–8 Dec / 100,251 remaining was reported by the account owner; production mirror previously lagged and showed old limits. Reconcile actual provider data, mirror timestamp, credits used/purchased/top-ups and stored reserve BEFORE declaring a new cap active.
- Check #910 against G2. A guarded one-time settings seed may reflect the plan, but **runtime allocation must use the current vendor balance/plan and Admin-configurable settings**, not require a new hard-coded migration each plan cycle. Show allowance, live remaining, last sync, usage by lane, reserved floor and daily spend distribution in existing UI. Distinguish credits from money.
- Priority order: P0 containment independent of paid reads; AER official sources / English / scholarships / course discovery / other, adjusted for actual eligible high-yield evidence. Do not allow course-link search to consume the final usable credits ahead of AER; do not starve legitimate zero-cost source work.
- Use evidence-backed yield per credit: pages fetched, rows proposed, new review-ready, admitted/published. Prevent hidden repeated zero-yield crawls; automatically park under reserve, recover under verified replenishment without approval prompts.
- No additional purchase, unlimited AI, blanket requeue or reserve override authorised.

## 4. Parallel-agent ownership and integration sequencing
Use up to **eight bounded agents if supported** for: (A) P0 intake/date integrity, (B) fees, (C) English, (D) course descriptions, (E) provider descriptions, (F) AER, (G) scholarships/source acquisition, (H) UI/operations/QA; split ownership differently if actual function/migration overlap demands. Claude remains sole Integration Controller. A separate read-only independent validation feed supplies evidence but does not mutate production. Per-agent issue, one owned code area, branch, source identifiers, no overlapping migration/function editing, CI, production first-run proof, next action. Shared scheduler/platform settings belong to a designated integrator workstream, not several agents.
- Triage P0 Deakin first. Parallel read-only diagnosis, source acquisition within caps, tests and UI work may proceed. Integrate sequentially with no simultaneous release or production-write verification.
- Do not merge unverified green PRs just to clear branches. Test exact merged tree and 2+ real scheduled executions. No duplicate functionality, no invented SQL objects. Rate-limit live reads to permitted windows.

## 5. Canonical progress tracking (no second register)
The **single operational status** remains `docs/platform/STUDYSEARCH-EXECUTION-REGISTER.md` (SS/IQ identifiers). This file defines the target and acceptance; do not treat the static baseline as the live dashboard.
For every workstream use one existing issue/fingerprint or create a missing one after checking for duplicates. Maintain a row linked to this mandate with:
`Issue | Domain | Substep (source/reader/evidence/review/admit/publish/UI) | Owner | Dependency | State | Code/PR/migration | Test result | Deployed version | First scheduled run and expected/actual output | 24h gains | Last checked UTC | UI location/control | Human decision if truly needed | Next executable step | Evidence`.
Permitted states: not started, investigating, implementing, testing, deployed awaiting first run, verifying downstream, blocked with reason, production verified, closed. **Never call deployed = completed.**
At any new gap or regression, append a substep under the **same issue family** with root-cause evidence and accountable owner; do not reset progress to zero. Mark completed only with real production evidence and a linked UI acceptance result. Reconcile independent validation every run by event time, avoiding false deltas across different time windows.

Primary writer is the active Integration Controller, preventing concurrent conflicting edits. ChatGPT may provide independent verified review updates through GitHub when requested; the controller must reconcile them to the same register. Do not make the Platform Admin relay raw transcripts. Record a stable brief handover pointer here and in the canonical index. Do not promise unseen background execution.

## 6. Next action order and completion contract
1. **Contain Deakin/UQ unsupported intakes** and prevent further Website/Zoho propagation. Verify issue ownership, source/consumer parity and safe correction authority; no indiscriminate calendar substitution.
2. **Read exact PR #910 and current Firecrawl vendor reading**. Preserve new credits, configurable floor/daily shares and priority, do not assume old platform mirror is current; integrate only after guarded tests and operational proof.
3. **Publish a live per-domain first-run baseline** through existing Process results/UI. Demonstrate the real current job, switches, owner, stages, balances, last success, next action for INT/FEE/ENG/C-DESC/P-DESC/AER/SCH. Unknowns must read unknown, not 0.
4. **Assign agents immediately and run parallel non-overlapping delivery**, keeping P0 priority and admissions boundaries. Record each lane's first actual eligible→proposal/readiness→admission/publication progression, or a durable factual hold.
5. **Reconcile Layer 4 readiness and human capacity**. Queue complete review packets but do not auto-decide. Every approved item must actually reach canonical data and Website/Zoho; audit failures.
6. **Operator UI acceptance:** Settings visible and audited; Progress yields and blockers understandable by role; Run now / pause / resume behave correctly; desktop and phone.
7. **Exit Mode 1 only after all domain-level criteria pass** over a sustained observation period and no open P0, no unobserved first-run, verified high-priority monitoring and actual consumer parity. Any domain with zero gain must have a documented genuine lack of admissible source or specific remaining blocker, not just a successful job or plan.

**Required first report:** Matrix by domain with fresh baseline, owning agent and issue, actual enabled jobs/settings, blockers, next action, proposed release, UI control, estimated first-run observation, and evidence URI. Report to the Admin register, not only chat. Continue other executable work while one lane waits for a review or source.
