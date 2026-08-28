# M2.4.2 — Layer 2 Full Enrichment, Operations Maturity & Performance

**Status:** CLOSED / PASS
**Parent:** M2.4

## Objective

Turn Layer 2 into a mature, simplified, production-shaped enrichment operation and execute broad enrichment across the accepted scope while measuring performance, cost, completeness, storage and fall-out.

## Scope

### Operational simplification
- one Layer 2 Enrichment workspace for routine operations;
- suppress experimental/trial/probe controls from the normal path;
- retain advanced source/provider qualification behind privileged diagnostics;
- show source/profile, route policy, schedule, batch size, provider health, spend, Evidence growth and unresolved domains.

### Full enrichment execution
- enumerate eligible Courses/Scholarships by country/provider/source profile;
- automatic batch/queue generation;
- Direct HTTP first where sufficient;
- governed Firecrawl/other fallback only when required;
- enforce per-provider/per-entity budgets, concurrency and reserve limits;
- execute broad AU enrichment across approved source profiles;
- preserve explicit NZ first-party L2 deferral until source qualification is accepted rather than fabricating coverage;
- capture unresolved domains for Layer 3 rather than hiding gaps.

### Progress, jobs and evidence
- progress bar for batch and individual jobs;
- processed/resolved/unchanged/failed/L3-required counts;
- current provider/attempt, latency, retry state and estimated remaining workload where measurable;
- direct drill-through to Native/Normalised Evidence, candidate and canonical consequence;
- job summary and downloadable/reportable run evidence without secret exposure.

### Performance and economics
- throughput/pages per minute/hour;
- provider success and factual-resolution rates;
- deterministic extraction success by domain;
- paid fallback rate;
- provider units/cost per processed and resolved entity;
- Evidence bytes/entity and storage growth;
- DB/API/Edge/browser latency and slow paths;
- retry/throttle/error patterns;
- Layer 2→Layer 3 fall-out rate.

### Scheduling, rechecks and housekeeping
- source/profile-specific refresh cadence;
- stale data detection and targeted recheck rather than blanket recrawl;
- hash-based unchanged detection/dedup where valid;
- resume failed batches safely;
- clean transient queue/probe/nonce/temp state after terminal jobs;
- archive/prune operational logs according to policy while retaining governed Evidence;
- stuck-job detection and recovery;
- provider credit/quota threshold alerts;
- daily/weekly operational health summary.

### UI/UX evolution
- refine UX using actual full-run performance and failure evidence;
- management summary → queue → entity/job detail → diagnostics;
- progress, ETA only where defensible, last heartbeat and next action;
- clear distinction between resolved, unchanged, missing, failed, L3-required and blocked;
- simplify scheduling/recheck controls;
- mobile-friendly monitoring/review; advanced config may remain desktop-first;
- maintain release notes, Admin Guide and Operations Runbook with every accepted behaviour change.

## Addendum A8 — Operator-first Layer 2 Sync (27 August 2026)

This addendum is part of the active M2.4.2 gate and is subordinate to the standing A1–A7 governance/UAT contract.

### Operator intent
Routine enrichment must not require an operator to understand profile IDs, acquisition routes, bounded trials, provider credentials or internal batch primitives.

The normal Layer 2 journey becomes:

`Country → University / catalogue provider → Scope preview → Sync / Recheck → Progress → Results / fall-out`

### Required routine controls
- Country selector contains only countries with authorised Layer 2 profiles; deferred countries remain visible as deferred where useful but cannot be silently enabled.
- University / catalogue-provider selector is filtered by selected country and represents the governed canonical provider/source-profile scope, not the acquisition vendor.
- Scope preview shows total catalogue records, deterministically queueable records, source-limited records, current profile/version, last success, schedule and active-run state before execution.
- Primary action is one management-friendly `Sync now` / `Discover & sync` control. If governed URLs are missing, the UI must state that discovery is required and use the accepted deterministic discovery substrate rather than infer canonical URLs.
- Existing active/concurrent-run protection remains authoritative; the UI must not create duplicate runs.
- Acquisition vendor selection is automatic under the accepted route policy by default. Manual vendor selection belongs under Advanced controls and must not be required for normal sync.
- Progress/result state must remain visible after launch and link to Jobs/Runs, Evidence and Data Quality.

### Acquisition-provider configuration correction
- Fix provider editing so concurrency/rate/timeout changes are persisted, re-read from the server and visibly confirmed after save.
- Do not claim a provider setting saved merely because the request returned without an exception.
- Provider editor must validate allowed concurrency/rate/timeout bounds client-side and server-side.
- Firecrawl is the representative persistence UAT case because its current stored concurrency remained `2` after the reported edit attempt.
- Routine profile concurrency and acquisition-provider concurrency are separate controls and must be labelled as such.

### Progressive disclosure
Normal operator surface:
- country;
- university/catalogue provider;
- eligible/blocked counts;
- last/next run;
- sync/recheck action;
- progress and result summary.

Advanced surface only:
- profile JSON/versioning;
- acquisition vendor credentials;
- route priority/fallback;
- acquisition-provider concurrency/rate/timeout;
- provider qualification/probes/trials;
- destructive or diagnostic recovery controls.

### UAT extension
Stage A for this slice must prove:
- selector filtering and scope preview;
- deferred NZ cannot be launched as Course enrichment;
- primary sync action is disabled/redirected to discovery when no governed URLs are queueable;
- duplicate active run protection remains visible/enforced;
- Firecrawl concurrency edit persists after close/reopen/server re-read;
- invalid provider concurrency is rejected rather than silently coerced;
- no acquisition credential/secret is exposed;
- no Layer 1 identity mutation occurs.

Stage B must add desktop/mobile coverage for the simplified selector/sync journey, Jobs/Evidence/Data Quality regression and immediate Layer 3 fall-out contracts.


## Addendum A9 — Scope-first Sync, Ordered Acquisition Routing & Layer 2 Screen Cleanup (27 August 2026)

This addendum supersedes the A8 routine selector model where it conflicts, while preserving A8 security, persistence, Evidence and authority controls.

### Operating principle
The operator chooses **what catalogue scope to sync**. The platform chooses **how to acquire it**.

Routine workflow:

`Country → Fetch scope → Scope value → Preview → Sync / Recheck → Progress → Results`

Fetch scope is exactly one of:
- **Country** — every authorised university/provider and every eligible Course in the selected country;
- **State / subdivision** — every authorised university/provider and every eligible Course whose governed campus/provider scope belongs to the selected state/subdivision;
- **University** — every eligible Course for the selected governed university/provider.

A scope selection expands server-side into the matching authorised Layer 2 source profiles, universities/providers and Courses. The operator must not select individual acquisition vendors, profile IDs, route IDs or batches in the routine path.

### Ordered acquisition routing
Every source profile retains one ordered, governed provider chain. Routine execution always uses the first eligible provider and falls through only on configured fallback outcomes, budget/quota rules or capability mismatch.

Default Course acquisition order for the simplified model:
1. `direct-http`;
2. `firecrawl`;
3. remaining enabled providers in explicitly stored route priority order.

Examples of remaining providers include Scrape.do, ScraperAPI and ZenRows. Their exact order remains configurable per source profile under Advanced configuration. The operator never chooses the provider during a normal sync.

Routing requirements:
- discovery and acquisition must use the same ordered-route resolver rather than hard-coding `direct-http`;
- successful Direct HTTP must stop fallback;
- Firecrawl is the first paid/managed fallback unless an accepted source-profile exception explicitly says otherwise;
- later providers are attempted only for configured fallback conditions;
- provider concurrency, rate, timeout, spend/quota and availability gates are enforced before an attempt;
- every attempt records provider, priority, reason for fallback, response/outcome, Evidence and cost/unit telemetry where available;
- route-order edits are Platform Admin / Advanced only and must persist with server re-read verification;
- no fallback may weaken identity, Evidence, Layer 1 authority or canonical-mutation rules.

### Scope resolution rules
Country, state and university scopes are catalogue selectors, not scraping shortcuts.

Before launch the server must calculate and return:
- universities/providers included;
- total Courses in catalogue scope;
- Courses with governed current URLs;
- Courses needing deterministic discovery;
- blocked/deferred Courses;
- active-run conflicts;
- estimated batches from the stored execution policy.

Country/state runs fan out into governed per-profile/per-university batches so source-specific route, concurrency, schedule and Evidence policy remain authoritative. One oversized undifferentiated country job is not permitted.

### Routine Layer 2 screen cleanup
The routine Layer 2 screen should contain only:
- Country;
- Fetch scope: Country / State / University;
- State or University selector only when required;
- scope preview counts and included university count;
- one `Sync now` / `Discover & sync` / `Recheck` primary action;
- current run progress and simple result counts;
- last run / next scheduled run;
- concise blocked/deferred reason with links to Jobs, Evidence or Data Quality when action is required.

Remove from the routine screen, or move behind a single **Advanced configuration** entry:
- source-profile cards/list as a primary launcher;
- profile/version IDs and raw JSON;
- acquisition-provider picker;
- route-priority editor;
- provider credentials and qualification/probe/trial controls;
- separate vendor concurrency/rate/timeout controls;
- bounded-trial buttons;
- internal queue/batch primitive controls;
- duplicate health/telemetry panels already available in Jobs/Providers/Evidence;
- destructive recovery/cleanup actions;
- low-level provider-attempt diagnostics.

Advanced configuration may retain source profiles, ordered routes, provider limits/credentials, schedules and diagnostics, but must not be required for routine operation.

### Latest-run finding incorporated by A9
The Federation discovery run started at 27 August 2026 07:07 AEST (`c7dd414e-487a-4861-a9f3-defbfd9458f2`) processed 5 Courses and failed 5/5 with `layer2_provider_attempt_finish: invalid attempt status`. All five attempts used `direct-http`; fallback routing was never exercised. A9 therefore requires discovery to use the common ordered-route resolver and requires the provider-attempt terminal-status contract to be reconciled before broader scope runs.

### A9 UAT
Targeted validation must prove:
- Country scope expands to all authorised universities and eligible Courses in that country;
- State scope expands only to universities/Courses in the selected governed subdivision;
- University scope expands to all eligible Courses for that university;
- the preview and generated batches reconcile exactly to catalogue counts;
- Direct HTTP success stops the chain;
- a controlled Direct HTTP fallback condition advances to Firecrawl;
- Firecrawl fallback can advance to the next configured provider where policy permits;
- route order is honoured exactly and is not user-selectable in routine UI;
- paid-provider budget/concurrency/rate gates still apply;
- provider-attempt terminal states are valid and persisted;
- no duplicate active runs, no Layer 1 identity mutation and no secret exposure;
- routine UI contains no removed experimental/internal controls on desktop or mobile.

## Automated UAT

- route selection/fallback/budget guards;
- successful and failed batches;
- rate-limit/retry handling;
- identity mismatch zero-uplift;
- safe candidate apply;
- no Search/Publication side effect unless separately authorised;
- Evidence lineage and private access;
- replay/idempotency and unchanged-hash path;
- queue resume and cleanup;
- schedule/recheck;
- performance thresholds at representative scale;
- role/rank/anon/secret negative tests;
- desktop/mobile deployed UAT;
- regression of M1/M2.1/M2.3/M2.4.1 invariants.

## Exit gate

M2.4.2 closes only when Layer 2 can be run and monitored as a routine enrichment service, broad accepted enrichment has been executed/measured, performance/cost/storage are known, unresolved domains are cleanly handed to Layer 3, and the UI/operations documentation reflects actual operating evidence.

## A8 — single release-notes surface / footer cleanup

M2.4.2 inherits `project-runsheets/milestone-2/EXECUTION-ADDENDUM-A8-RELEASE-NOTES-SINGLE-SURFACE.md`.

For this workstream:
- the persistent footer/runtime feature marker is obsolete and must remain removed;
- the top-right PIM Admin version control + Release Notes overlay is the single operator-facing release/version surface;
- deployment readiness/UAT must not use the removed footer as a test hook;
- permanent browser UAT must assert the footer marker is absent and the version overlay remains accessible;
- the M2.4.2 version bump/release entry occurs only when the release slice is frozen after the remaining full-run gates.


## A10 — paged filters, tablet focus and dependent State scope

M2.4.2 inherits `project-runsheets/milestone-2/EXECUTION-ADDENDUM-A10-PAGED-FILTERS-TABLET-FOCUS.md`.

For this workstream:
- Layer 2 State scope must visibly list every included governed university/profile;
- State-scope university display is paged 10 at a time;
- large University/Provider/reference option lists must not be eagerly backloaded;
- Course catalogue filters are the priority server-paged implementation;
- shared filter/dropdown rendering is capped at 10 options per page;
- tablet/touch/coarse-pointer filter opening must not auto-focus the search input or summon the keyboard;
- parent-scope changes must clear invalid dependent State/Provider selections;
- Stage B must include tablet/touch coverage for the paged filter interaction.


## Addendum A11 — Evidence-Driven AU/NZ Scale-Out Strategy (27 August 2026)

### Decision

M2.4.2 will **not** require university-by-university bespoke engineering or completion of every AU/NZ university before acceptance. UQ, RMIT and Federation are the qualification/evidence cohort used to prove the Layer 2 operating model. Their evidence is sufficient to define the scalable onboarding contract for the remaining catalogue.

M2.4.2 closes when the platform proves that Layer 2 can safely onboard, qualify, run, observe and hand off universities at scale. National catalogue completion becomes an operational rollout, not a prerequisite for this submilestone.

### Standard onboarding path

Remaining universities should normally follow:

`Sample → qualify source/profile → automated full discovery → automated managed enrichment → canonical promotion of safe L2 results → governed L3/L4 exception stream`

A university returns to engineering only when the generic governed path cannot safely qualify the source or satisfy identity/Evidence requirements.

### Australia rollout

Australian providers are processed in waves rather than serial bespoke projects:

- **Tier 1 — large/high-volume universities:** bounded representative sample, then automatic full discovery/enrichment when safety gates pass.
- **Tier 2 — medium universities:** sample approximately 10–20 representative Courses; auto-promote to full-run when profile/source-pattern thresholds pass.
- **Tier 3 — small/specialist providers:** bounded qualification; unresolved records remain source-limited/L3/L4 rather than driving bespoke engineering by default.
- **Exception providers:** provider-specific source qualification is permitted only where the generic Direct HTTP → Firecrawl → remaining governed fallback path cannot safely resolve identity/source structure.

Rollout waves should normally contain multiple universities (target 5–10 where workload/rate limits permit), retain per-profile execution policy, and report provider-level acceptance/fall-out separately.

### Safety and acceptance thresholds

- Anything automatically selected or canonically promoted must retain **100% identity safety** under the accepted Layer 1 identity contract.
- Discovery/enrichment coverage is not required to be 100%.
- Missing, ambiguous, identity-mismatch and source-limited outcomes are valid governed terminal outcomes.
- Coverage shortfall must not cause identity thresholds to be weakened.
- One difficult university must not block national progression where its safe outcomes and exception population are explicitly recorded.
- Search and Publication remain unauthorised by Layer 2 unless separately approved.

### New Zealand rollout

NZ first-party Course enrichment remains deferred until an NZ source-pattern qualification cohort is completed. The intended rollout is:

`NZQA canonical catalogue → qualify 2–3 representative first-party source patterns → generic NZ profile families → bounded sample → automated wave rollout`

NZ should expand by **reusable source pattern**, not by bespoke university implementation. NZQA remains Layer 1 authority; first-party Layer 2 evidence may enrich but never redefine identity.

### Cross-layer evidence handoff

Layer 2 must deliberately produce a structured exception stream that downstream layers can consume:
- deterministic L2-resolved candidates;
- L3-required interpretation cases;
- L4 human-resolution cases;
- ambiguous/identity-mismatch/source-limited outcomes;
- Evidence IDs, source/profile/version, acquisition route and reason codes.

Once the qualification evidence exists, Layer 3 and Layer 4 workstreams may operate on these governed exceptions in parallel without waiting for complete national Layer 2 coverage.

### Exit-gate interpretation

For M2.4.2, “broad accepted enrichment” means representative full-run evidence plus a production-shaped scalable rollout mechanism and governed cross-layer fall-out. It does **not** mean every Australian and New Zealand university has already been individually enriched.


## A12 contextual insight integration

M2.4.2 now inherits A12. QILT/PRISMS/country-equivalent statistics and Scholarships are not operator-complete as isolated admin workspaces. Relevant governed data must be surfaced in Provider/Course detail blades at its true granularity, with provenance/freshness and explicit not-available/not-mapped/suppressed states. Standalone insight pages remain for bulk QA/operations. Targeted API/browser/security UAT is required before Stage B nomination.


## A14 Layer 2 / Layer 3 telemetry retention — 29 August 2026

A14 is now a standing M2 rule. Layer 2 must retain scraper/provider attempts, route/fallback outcome, latency, retries, vendor units/credits where measurable, estimated/measured cost, Evidence count/bytes, fields resolved and L3 fall-out. Layer 3 must retain exact model/profile, external calls, prompt/input tokens, completion/output tokens, latency, validator outcome and estimated/measured cost when the provider/runtime supplies them. Missing usage metadata remains explicit unavailable and is never manufactured.

Runtime checkpoint at adoption:
- 3,065 retained Layer 2 provider attempts; all have a metrics object and 3,012 already retain attempt latency;
- historical attempt-level vendor-unit/cost fields were not consistently populated, although managed-run/item metrics retained vendor usage/cost;
- `layer2-acquire-v2.9` now retains per-attempt provider key, request-unit usage basis, vendor units, latency and estimated request cost when available;
- Layer 3 accepted production interpretations remain 0, so production token totals are correctly 0;
- retained Layer 3 benchmark runs already record external-call count, input/output tokens, configured/returned model, cost and maximum latency;
- Security Advisor remains 131 INFO / 0 WARN / 0 ERROR and Performance Advisor 167 INFO / 0 WARN / 0 ERROR after the Edge update.

A new scraper/model execution path is not acceptable if it silently bypasses this telemetry contract.


## Corrective Stage C PASS / M2.4.2 CLOSED — 29 August 2026

The explicitly authorised corrective Stage C is PASS.

- corrected UAT source: `60e9e25a86a48522dbae7a29d6c2955c9d295761`;
- corrective Stage C candidate / accepted Pilot: `093010fada8391c93626b59e59c678064f4961c3`;
- deployed acceptance run: `33219089690`;
- chromium-desktop: **45/45 PASS**;
- chromium-mobile: **45/45 PASS**.

Historical Stage C failure `33215640328` remains retained as immutable evidence. It was not rewritten or removed; the explicit governance reopening authorised exactly one corrective run after the stale pre-A12 reorder assertion was corrected.

Final post-acceptance runtime:
- Security Advisor: 131 INFO / 0 WARN / 0 ERROR;
- Performance Advisor: 167 INFO / 0 WARN / 0 ERROR;
- UQ weekly Course refresh ENABLED;
- RMIT weekly Course refresh DISABLED;
- Federation weekly Course refresh DISABLED; source profile PAUSED/source-limited;
- RMIT frozen cohort remains 212/212 identity matched, 0 unsafe, 0 applied, fingerprint `627bb7daa62fe3bbfc3047ce2b57a88e`;
- RMIT canonical promotion remains separately BLOCKED pending an already-authorised exact frozen-set executor;
- Layer 3 source-pattern benchmark remains separately BLOCKED under its unchanged quality threshold;
- A14 telemetry remains standing and carries into M2.4.3.

M2.4.2 is **CLOSED / PASS** for its accepted Pilot scope.

Accepted programme documents:
- Running Build: `docs/coursefinder-running-build-v2.76.md`;
- Master Project Plan: `docs/coursefinder-master-project-plan-v1.76.md`.

Next gate: **M2.4.3 — Layer 3 AI Operations Maturity**.
