# AER and Scholarship Data Intake Engine: design v0.1

**Status:** PROPOSED. Nothing is built, switched on or changed by this document.
**Date:** 25 Nov 2026, 11:37 AEDT. **Requested by:** Platform Admin ("Why can't the platform engine go through and maintain the work queue itself? Self-sustaining, with AI comparing results and building readers. How do we build this process and engine inside the platform?").
**Prepared in:** chat "StudySearch requirements register" (Claude).
**Read from:** admin `main` `149f8263`. Inputs:
- `AER-DESIGN-V2-PROPOSAL.md` and its 12 Nov review;
- `AER-TECHNICAL-DESIGN.md`;
- `DATA-PIPELINE-OPERATING-MODEL.md`;
- `AGENT-OPERATING-MODEL.md` (24–25 Nov wave mandates; AI preprocessing mandate, 25 Nov 08:16);
- `CONTINUOUS-DELIVERY-MASTER-PLAN.md` (AER-FU and SCH-FU follow-ups);
- `OPS-QUEUE-LANE-CONTROL-AND-ON-DEMAND-RUNS-DESIGN.md` (s768);
- `adapters/ADAPTER-LESSONS.md` and the adapter pattern sheet;
- Drive M3: AER and Scholarship University Reader Status trackers, Gates & Limits register, Layer 4 human-review spec (21 Nov).

**Scope:** academic entry requirements (AER) and scholarships, for AU, NZ and CA providers with active courses. The same engine is meant to carry fees, intakes and English later, but they are out of scope here.

---

## 1. Executive summary

The platform already has most of the parts an intake engine needs:
- stored evidence with content hashes;
- deterministic readers;
- qualified AI routes;
- a strict verifier and machine admission;
- Layer 4;
- three dispatchers;
- on-demand requests;
- budgets.

What it does not have is a **single, platform-owned record of what should happen next for each provider and each data domain**. Today that knowledge lives in chats, wave mandates, Google Sheets, CSV registers and the master plan. So the work moves only when a chat picks a cohort, and it stalls when the chat stops.

This design adds an **Intake Engine** with four parts:

1. **Intake ledger.** One state record per provider and domain (AER, Scholarships), moving through the nine existing Steps, each with a next action, a due time, an owner type and a blocker code. Phase 0 derives it from existing records, so nothing is duplicated.
2. **Planner.** It runs as one more lane on the existing `coverage-lane-dispatch`. Every few minutes it picks the highest-value next actions it can afford and calls the existing workers. It escalates by a fixed ladder: deterministic → qualified lean model → Firecrawl or heavier model → ticket for an agent or person.
3. **Reader registry and builder.** Provider- or site-specific readers become versioned, data-only reader profiles rather than code. An AI "reader builder" drafts a profile from stored pages and labelled answers. The profile is tested offline on stored copies against the labelled set. Profiles of a proven-structure kind (`PDF_TABLE`, `HTML_TABLE`, `HTML_ACCORDION`) go live the moment the test passes, because the Standing Authority Charter pre-authorises them. Every other kind is activated by the Platform Admin.
4. **Compare-and-learn loop.** Sampled reads are run twice: deterministic and AI, or two models. The results are compared row by row against the stored page. Agreement raises confidence; disagreement goes to a judge step or Layer 4. Every decision feeds a labelled set. This builds the `aer-improve` loop proposed on 12 Nov, which was never built.

Chats and agents stay useful, but they become **workers on the same ledger**. They claim a ticket with a lease, do the part the engine can't (find an awkward source, fix a reader), and their output goes back through the same registry, tests and gates. Hand-picked waves are retired once the engine has run two unattended weeks without regressions.

---

## 2. Why the engine can't sustain itself today

| # | Gap | Evidence (25 Nov unless stated) | Effect |
|---|---|---|---|
| G-1 | **No platform-owned "next action" per provider and domain.** Progress is held in chat mandates, the master plan, reader-status CSVs and Sheets. | Wave mandates 24–25 Nov (`AGENT-OPERATING-MODEL.md`); 11 AER-FU and 9 SCH-FU follow-ups in the master plan; status trackers refreshed from CSV. | Work moves only when a chat runs. Overnight chat runs "failed to meet expectations" (25 Nov mandate). |
| G-2 | **Source discovery (Step 1) is not automated.** | AER: 231 of 1,886 providers have a registered source; 1,102 are "No Reader Yet". Scholarships: 1,736 of 1,886 are "No Reader Yet". | Most of the territory never enters the pipeline unless a chat finds the page. |
| G-3 | **Fragmented queues with no common priority.** | 17 queues in `pipeline.queue_watch`; 21 worker lanes in `field_execution_registry`; Layer 4 items, on-demand requests, `course_page_needed`, entry-matrix sources and scholarship candidates are all separate. The s768 operations control was designed but not built. | Nothing ranks "the next most valuable action" across stages. A stalled stage doesn't trigger the next remedy. |
| G-4 | **Stalls have no automatic way out.** Items park as `gate_incomplete`, `all_rows_held`, `no_bound_page`, `identity_not_admitted`, `LAYER4_OPEN` or `INTERNATIONAL_NOT_STATED`, with "next action" written as prose. | AER: Layer 4 held 561, pending 100. Scholarships: 81 providers Stuck in L4. **s871 (20 Nov)** superseded 1,818 AI reads for a free deterministic re-read that only knows academic test keys. 1,563 courses ended with no entry row and nothing waiting (live check, 25 Nov 08:56). | Recoveries are one-off migrations. Nothing checks that the recovery actually recovered. |
| G-5 | **Reader building is human or chat work, held as code.** | Per-provider adapters (`docs/adapters/configs/*.json`); multi-award heading splitter not built (Charles Darwin, Lincoln give 0 items); PDF and accordion layouts "need a rendered read or hand entry" (`ADAPTER-LESSONS.md`). | Each new layout waits for a chat and a PR. |
| G-6 | **No learning loop.** Layer 4 decisions aren't collected as labelled examples; there is no champion and challenger. | AER v2 §3.7 (self-improvement) and the `aer-improve` job (§3.10) proposed 12 Nov; neither appears in the current state. | The same failure classes come back. Each fix is manual. |
| G-7 | **Budgets are set per chat, not per expected yield.** | Firecrawl `firecrawl.daily_budget_total` = 5 credits a day; AI for entry requirements and matrices OFF unless authorised; US$5.00 a day platform cap (Gates register). `ai_route_v1('entry_matrices')` returned one model where three were qualified (AER-FU-11). | The engine can't escalate on its own, so chats ask for one-off spend. |
| G-8 | **Coverage is measured by status labels, not one definition.** | Sheets use Fully Working, Stuck in L4, Partial, No Reader and Site Blocked, worked out from CSVs. The 12 Nov review asked for coverage defined by the resolver (`entry_resolve`, `minimum_published`) for the top applicant countries. | Hard to tell real gain from movement; "proposed" gets counted as delivered. |

**In short:** the platform runs workers well, but it doesn't own the plan. The plan lives outside the database, so no scheduler can act on it.

---

## 3. Principles

1. **One record of intent.** Every provider and domain has exactly one current state and one next action, in the database, readable by people, chats and the planner.
2. **Reuse before build.** Existing workers, dispatchers, stored evidence, verifiers, Layer 4, on-demand requests and budgets do the work. The engine only decides *what next* and *with which tool*. No second reader, queue runner or scheduler (standing rule).
3. **Cheapest proof first.** The escalation ladder is Tier 1 stored evidence or direct HTTP, deterministic, $0; then Tier 2, a qualified lean model on preprocessed sections; then Tier 3, Firecrawl or heavier models within caps; then Tier 4, a ticket for an agent or person. This matches the 24 Nov tiers and the 25 Nov preprocessing mandate.
4. **Evidence is the ground truth, not an earlier answer.** Comparisons check every row against the stored page quote. An earlier AI answer is never ground truth (25 Nov mandate, rule 3).
5. **Live on deploy where already authorised; activation by the Platform Admin otherwise.** Under the standing mandate (21 Nov), verified fixes and verified deterministic admission rules go live in the same change, with no unrequested shadow soak or delayed cutover. Under the Standing Authority Charter (23 Nov), Tier 1 ($0) actions and AER v2 proven-structure readers are pre-authorised. New AI routes, prompts for model-assisted reads, spend above the US$5.00 a day micro-budget and non-structural reader profiles are activated by the Platform Admin (AI preprocessing mandate, 25 Nov, rule 4).
6. **Never lose a reading without a replacement.** A supersession needs a successor result or stays reversible, and is checked two cycles later (the s871 lesson).
7. **Controls unchanged.** G3 75/48, 7,585 manual locks, Layer 4 for genuine exceptions, the cron ceiling of 140, the US$5.00 daily cap, no bot-challenge bypass, and consumer communication controls.
8. **Escalate by exception only.** The engine never waits for a batch approval. It parks only the affected provider and action as `HELD:<reason>` in the 08:00 `docs/monitoring/DAILY-EXECUTIVE-STATUS.md`, and only for the Charter's five triggers: G3, manual locks, cron above 140, spend above US$5.00 a day, or a bulk withdrawal without replacements. Everything else carries on.

---

## 4. Target design

### 4.1 Intake ledger (Step state per provider and domain)

**One row per (provider, domain).** Domain is `aer_matrix`, `aer_course` or `scholarship`. Fields:

| Field | Meaning |
|---|---|
| `stage` | The furthest Step reached (1 Find source · 2 Acquire evidence · 3 Segment/convert · 4 Extract · 5 Map/normalise · 6 Verify/admit · 7 Publish · 8 Consumer read-back · 9 Monitor) |
| `state` | `ready`, `running`, `waiting_change`, `blocked`, `done_monitoring`, `no_data_proven` |
| `next_action` | A code from a fixed catalogue (§4.3), never prose |
| `due_at` | When the planner may next act |
| `owner_type` | `engine`, `agent`, `person` |
| `blocker_code` | The existing tokens: `gate_incomplete`, `all_rows_held`, `no_bound_page`, `identity_not_admitted`, `site_blocked`, `INTERNATIONAL_NOT_STATED`, `LAYER4_OPEN` … |
| `attempts_by_tier`, `last_outcome`, `cost_to_date` | Escalation memory and spend |
| `priority_score` | Active courses × applicant-country weight × gap size × freshness. Weights in Settings (G2) |
| `coverage` | Domain measure (AER: resolver `minimum_published` for the top applicant countries; Scholarships: linked active courses and published awards) |
| `claim_id`, `lease_until` | For agent or person tickets (one owner per provider and action, as today) |

**Phase 0 is a view, not a table.** `security.intake_ledger_v1` is computed from existing records:
- `entry_matrix_sources` and runs;
- `aer_det_*` pages;
- `course_entry_requirements`;
- `layer4_review_items`;
- `on_demand_requests`;
- scholarship sources, listings, candidates and awards;
- `queue_watch`.

The reader-status CSVs and Sheets are then generated from that view, replacing the hand-maintained status. A small table is added only when the planner needs to remember attempts and due times. That table becomes the single home for this state, and the CSV registers and wave lists are retired.

### 4.2 Planner (one lane on the existing dispatcher)

- **How it runs.** `intake-planner` is a `worker_lane` in `field_execution_registry`, run by `coverage-lane-dispatch` (no new cron). Every 5 minutes it:
  1. reads ledger rows where `state = ready` and `due_at <= now`, ordered by `priority_score`;
  2. looks up each row's `next_action` in the action catalogue to get the tool and tier;
  3. checks budgets (per-tier daily caps in Settings; Firecrawl credits; AI route caps; on-demand request scope);
  4. calls the existing worker or RPC with a bounded batch, never more than `intake.batch_max`;
  5. records the outcome, then sets the next `stage`, `next_action` and `due_at`, or escalates one tier.
- **Fairness.** It alternates countries and providers, as the s1054 scholarship picker already does, with a cap per provider per hour.
- **Change-driven upkeep.** Providers in `done_monitoring` are re-read only when a stored copy's content hash changes. Changes are detected by the Firecrawl monitor (150 credits a week) or a cheap direct HTTP check on a cadence by priority.
- **Downstream enqueue.** When a course's official URL or a provider snapshot is admitted, the planner sets that course's AER and Scholarship ledger rows to `ready` in the same change (Standing Authority Charter §3), so no course sits unqueued.
- **Two-cycle proof.** "Done" is set only after two unattended cycles show the same admitted coverage and consumer read-back (as the 24 Nov mandates require).

### 4.3 Action catalogue and escalation ladder

| Step | Tier 1 ($0) | Tier 2 (lean model, preprocessed) | Tier 3 (paid acquisition or heavy) | Tier 4 (ticket) |
|---|---|---|---|---|
| 1 Find source | Link crawl from stored course pages and the provider site map; known URL patterns per country pack; CRICOS or register links | AI page-type classifier on stored candidates (matrix, course page, scholarship hub, listing, award, other) | Bounded site search or Firecrawl map of the provider site | Agent finds the official source; person if access is blocked |
| 2 Acquire | Direct HTTP or PDF to stored evidence (hash, path) | — | Firecrawl rendered fetch (accordions, JS pages) | Upload by a person (provider PDF); site-blocked record |
| 3 Segment | `leanText` blocks and `selectSections` (existing); PDF table proof; multi-award heading splitter (to build) | — | — | Reader profile needed (§4.4) |
| 4 Extract | Deterministic readers: aer-det, struct-det, elr-det, fid-det, listing reader | Qualified model on selected sections (`courseEntryInput`, scholarship extraction) | Heavier qualified model on failure only | Agent drafts a reader profile |
| 5 Map/normalise | Country packs, qualification aliases, levels, GPA scales | Model suggests a mapping (never admits) | — | Person confirms new aliases or packs once |
| 6 Verify/admit | Strict verifier; machine admission rules | Judge model only for disagreements (§4.5) | — | Layer 4, genuine exceptions only |
| 7–8 Publish/read-back | Auto-publish rules; consumer read-back checks | — | — | Person for publication holds |
| 9 Monitor | Hash change check; due re-read | — | Firecrawl monitor | — |

The planner tries the cheapest tool that applies. After `intake.max_attempts_tier_n` failures with the same outcome, it moves up a tier. It never repeats an unchanged read with an unchanged tool, which is today's "no unchanged retries" rule, now enforced in code.

### 4.4 Reader registry and reader builder

- **Reader profiles are data.** A profile holds:
  - a site or layout signature (host, URL pattern, DOM or heading markers, PDF table fingerprint);
  - section rules (headings, accordion labels, table columns);
  - field mappings;
  - the country pack to use;
  - a version, status (`draft`, `tested`, `active`, `retired`) and its evidence.

  It extends the existing adapter pattern sheet and `docs/adapters/configs`, so they move into one table read by the existing readers. No per-provider code.
- **Reader builder (AI-assisted).** When a provider or layout keeps failing at Tier 1, the planner opens a `build_reader` action:
  1. It collects the stored pages, the failure outcomes and any labelled answers (Layer 4 decisions, rows a person accepted).
  2. A qualified model drafts a profile against a fixed schema; it never writes code.
  3. The draft is **tested offline** on the stored copies ($0, no live writes). Every extracted row must quote the page. This is a qualification test, not a shadow soak: when it passes, the profile goes live as described below.
  4. Results are compared with the labelled set and the current reader.
- **Activation gate:**
  - no new false admission on the labelled set;
  - recall at least the current reader's;
  - an audit error rate no higher than v1's (the 12 Nov review, amendment 3).

  - **Proven-structure kinds** (`PDF_TABLE` cell-grid, `HTML_TABLE`, `HTML_ACCORDION`) are pre-authorised (Standing Authority Charter §1). They go live in the same change once the test passes, with the audit sample and Layer 4 for genuine exceptions.
  - **Other kinds** (free-text sections, model-assisted profiles, new routes or caps) are activated by the Platform Admin, individually or under a standing policy he approves, with an audit trail.
- **Agents build profiles too.** A chat working a Tier 4 ticket submits a profile draft through the same schema and offline test, not a migration.

### 4.5 Compare-and-learn loop (self-improvement)

1. **Dual read on a sample.** For a configurable share of reads (for example 5%, plus every new profile or prompt version), the planner runs a second method: deterministic vs AI, or model A vs model B, on the same selected sections.
2. **Row comparison against evidence.** Rows are matched on scope (country, qualification, level, course; for scholarships award, value, currency, eligibility, course scope). Each value is checked against the quoted page text.
   - Agreement: confidence recorded, admitted through the normal rule.
   - One-sided or conflicting: a judge step (a third, qualified model sees both answers and the quotes, and must cite) proposes a winner. Admission stays with the verifier. Unresolved cases go to Layer 4 as one grouped card per provider.
3. **Labelled set.** Every Layer 4 decision (approve, edit, reject with reason), audit-sample outcome and resolved disagreement is stored with the stored copy, the reader or prompt version and both answers.
4. **Weekly improvement (`intake-improve`, one rollup target):**
   - clusters failures and edits by outcome code and field;
   - drafts a prompt change, a profile change or a new country-pack alias for the largest clusters;
   - runs the offline trial on stored copies and the labelled set;
   - posts the result for activation.

   This is AER v2 §3.7, extended to scholarships.
5. **Drift watch.** If a provider's admitted coverage drops, or a re-read disagrees with admitted rows beyond a threshold, the ledger row goes back to `ready`, with `next_action = reconcile`.

### 4.6 Domain specifics

**AER**
- **Two products.** The provider matrix (provider × applicant country × qualification × level) and course-level requirements. The resolver defines coverage: `minimum_published` for the top applicant countries (agreed in the 12 Nov review).
- **Non-academic entry kinds are first-class.** `prior_qualification`, `portfolio_interview`, `work_experience`, `subject_prerequisite` and `general_note` must have a Tier 1 or Tier 2 path. A deterministic re-read may not supersede an AI read whose kinds it can't produce (the s871 lesson: 1,563 courses). The course view shows these kinds.
- **Rendered fetch for collapsed sections.** Accordion and JS content triggers a Tier 3 rendered fetch only when the stored copy lacks the section (for example EQUALS 108164E).
- **Golden courses.** The s1022 golden-course validator becomes the regression set for AER reader and profile changes.

**Scholarships**
- **Chain.** Hub → listing → award page → eligibility (international stated), value and currency, GPA scale, course scope, round dates.
- **Reader profiles.** The multi-award heading splitter becomes a profile capability, not a code fork. Listing readers stay direct-first (s992).
- **Lifecycle on a cadence.** Open, closing, closed and withdrawn are re-checked by round dates and hash changes; withdrawn awards keep their evidence.
- **Layer 4 cards.** Grouped per provider (scope, GPA scale), with a bulk decision. Awards already parsed and waiting only on scope cards are the fastest gain (78 providers, S2-Build audit 24 Nov).

### 4.7 Where people and agents fit

| Role | Before | After |
|---|---|---|
| Platform Admin | Writes wave mandates; approves spend case by case | Sets priorities and budgets in Settings; activates profiles, prompts and routes; decides standing policies; works grouped Layer 4 cards |
| Chats and agents | Pick cohorts; run Steps 1–5 by hand; report in Admin docs | Claim Tier 4 tickets from the ledger (lease, one owner); find sources, draft reader profiles, fix blockers; output goes through registry, offline test and gates |
| S1-Build | Integration, registers, shared runner | Same, plus owner of the planner lane and ledger view |
| Sheets and registers | Hand-refreshed status | Generated from the ledger (read only) |

### 4.8 Measures (shown on Operations › Intake and in the Monday line)

| Measure | Today (25 Nov) | Target direction |
|---|---|---|
| AER: active courses with an admitted requirement | 10,847 of 36,052 (30.1%) | Rising weekly without chat runs |
| AER: providers with no registered source | 1,655 of 1,886 | Falling (Tier 1–2 discovery) |
| Scholarships: active courses linked | 15,052 (41.8%) | Rising |
| Scholarships: providers "No Reader Yet" | 1,736 | Falling |
| Ledger rows `ready` older than 24 h (stalls) | not measured | Near 0 |
| Supersessions without a successor result after 2 cycles | not measured (s871: 1,563 courses) | 0 |
| Precision on audit sample and labelled set | not reported per version | No new false admissions |
| Cost per admitted row, by tier | not reported | Reported; Tier 1 share rising |
| Chat-run share of admitted gain | most | Falling to exceptions only |

---

## 5. What existing components become

| Existing | Role in the engine |
|---|---|
| `coverage-lane-dispatch` and `field_execution_registry` | Runs `intake-planner` as one more lane |
| `rollup-scheduler` and `rollup_targets` | Runs `intake-improve` weekly and the ledger snapshot hourly |
| `pipeline.on_demand_requests` | The Tier 3 spend envelope and "Fill now" actions (s768 design) |
| `queue_watch`, `job_effective_state_v1` | Inputs to ledger state; health of each tool |
| Stored evidence (`evidence_artifacts`, hashes) | Basis for every comparison and every re-read decision |
| aer-det, struct-det, elr-det, fid-det, listing reader, lean selector | Tier 1 and Tier 2 tools |
| `ai_route_qualifications`, `lean_qualify`, `lean_sections_eval` | Qualification of models and reader profiles on preprocessed input |
| Layer 4 (grouped cards, s872) | Genuine exceptions only; every decision becomes a labelled example |
| Adapter pattern sheet and adapter configs | Seed for the reader registry |
| Golden-course validator (s1022) | Regression set |
| AER and Scholarship reader-status CSVs and Sheets | Generated from the ledger |
| Wave mandates and the master plan follow-up tables | Replaced by ledger tickets (kept as history) |

---

## 6. Rollout (each phase gated; a pass switches nothing on)

| Phase | What | Exit test | Spend |
|---|---|---|---|
| 0. Read model | `intake_ledger_v1` view over existing records; status trackers generated from it; stall and supersession measures. Live on deploy (read only) | Ledger totals equal the current trackers (1,886 providers; AER and scholarship status counts) | $0 |
| 1. Planner, Tier 1 | `intake-planner` lane live on deploy for Tier 1 actions only ($0, pre-authorised): stored-copy re-reads, direct HTTP fetches, deterministic readers, proven-structure profiles, downstream enqueue. Per-tool circuit breaker from day one | Two unattended cycles result-bearing; admitted coverage rises or holds; no supersession without a successor; cron ceiling unchanged | $0 |
| 2. Escalation | Tier 2 and Tier 3 actions inside the US$5.00 a day micro-budget (Charter §2) and the per-route AI caps; above that, `HELD:BUDGET_GATE` | Cost per admitted row reported; the cap is never exceeded | Within the US$5.00 a day cap |
| 3. Compare and learn | Dual-read sample, judge step, labelled set, weekly `intake-improve` drafting changes and trialling them offline | One improvement cycle with measured gain and no new false admissions; model-assisted changes activated by the Platform Admin | Within cap |
| 4. Reader registry and builder | Profiles as data; builder drafts and offline tests; proven-structure profiles live on pass, others on activation | ≥ 5 profiles live from builder drafts; Charles Darwin and Lincoln multi-award pages yield items | Within cap |
| 5. Agents as ledger workers | Chats claim Tier 4 tickets; wave mandates retired | Two weeks with no hand-picked waves and coverage still rising | As today |

Unless the Platform Admin asks for one, no phase includes a shadow soak or a delayed cutover. Each change ships live with its guard (standing mandate, 21 Nov).
---

## 7. Risks and guards

| Risk | Guard |
|---|---|
| The planner amplifies a bad reader | Offline test on stored copies before a profile goes live; per-tool circuit breaker on a rising Layer 4 or reject rate; the drift watch reverts the ledger state |
| Spend creeps | The US$5.00 a day micro-budget (Charter §2) and per-route AI caps; `HELD:BUDGET_GATE` above it; on-demand envelopes; cost per admitted row reported |
| A false admission at scale | Strict verifier unchanged; audit sample; only proven-structure profiles go live without the Platform Admin; manual locks respected |
| A second scheduler by stealth | The planner is one registered lane; no new cron (G1); actions call existing workers only |
| Supersession loses data (s871) | Principle 6: a supersession needs a successor result, is checked after 2 cycles, and is reversible |
| Agents and engine collide | One owner per provider and action via claim and lease on the ledger (today's rule, enforced in the database) |
| Site blocks | Recorded as `site_blocked`; no bypass; Tier 4 upload or another official source |

---

## 8. Decisions for the Platform Admin

1. **Direction.** Approve the Intake Engine as the target for AER and scholarships, with Phase 0 (read model) and Phase 1 (planner, Tier 1, live on deploy) to start.
2. **Single home for intake state.** After Phase 0, the ledger becomes the single home for provider and domain state, and CSV or Sheet trackers are generated from it (read only).
3. **Spend inside the micro-budget.** Confirm Phase 2 runs inside the existing US$5.00 a day cap (Charter §2) and the per-route AI caps. Say whether AER entry-requirement AI stays off unless authorised (Gates register), or gets a small standing share of that cap.
4. **Activation of non-structural profiles and prompts.** Choose a standing policy (for example providers under N active courses, with a clean audit sample) or individual activation. Proven-structure profiles are already pre-authorised.
5. **Non-academic AER kinds.** Confirm they are first-class in coverage and on the course view, and that a deterministic re-read may not supersede reads it can't reproduce (closes the s871 gap).
6. **Lane ownership.** Planner and ledger: S1-Build. Reader registry and builder: S1-RM-Design. Compare-and-learn: S2-AER for AER, F-SCH owners for scholarships.

---

## History

| Version | Date | Change |
|---|---|---|
| 0.1 | 25 Nov 2026 11:37 AEDT | First proposal (Platform Admin request; chat "StudySearch requirements register"), aligned with the standing mandates in `CLAUDE.md` (immediate live activation, Standing Authority Charter, master plan) |
