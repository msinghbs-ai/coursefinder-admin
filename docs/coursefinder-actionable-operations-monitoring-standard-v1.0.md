# CourseFinder Actionable Operations & Monitoring Standard v1.0

**Status:** ACTIVE DELIVERY STANDARD  
**Effective:** 15 September 2026  
**Change Control:** `CF-CHG-20260915-247`  
**Applies to:** Admin/PIM operational screens, Layer 1–4 workflows, Jobs, Evidence, Scholarships, Rankings, Statistics, Search/API and country onboarding.

## Purpose

Operational UI and reporting must help an operator decide what to do next. Stale totals, decorative cards and duplicated diagnostic data must not dominate routine screens.

Every operational surface must answer, in as little space as practical:

1. What is running now?
2. What changed since the last hour/day?
3. What is blocked, why, and who/what can act?
4. What useful data was admitted to canonical/Search/API consumers?
5. What resource/quota headroom remains?
6. At the current rate, when will the current scope finish and what resource/cost pressure is forecast?
7. What is the next safe action?

## UI rule — actionable first

Each screen is to be refactored around the job of the role using it. Remove or progressively disclose information that does not support an operator decision.

Default operational panels should contain only current/actionable information. Historical detail, raw IDs, long diagnostics, internal schema and forensic telemetry belong behind drill-down.

Metrics must be cross-linked. A count is not useful if the operator cannot click through to the records/runs/evidence that make up that count.

Examples:

- `Layer 3 waiting: 2402` → click opens the filtered Layer 3 queue;
- `Blocked: 17` → click opens the exact blocked run items grouped by stop reason;
- `Evidence created: 198` → click opens Evidence filtered to that run/time window;
- `Admitted: +22` → click opens canonical admission decisions and affected Search/API records;
- `429: 6` → click opens provider attempts causing rate pressure;
- `Layer 4 required: 3` → click opens the exact human decisions.

## Live run card

Any active job/wave must show a compact live card with:

- data family / source / country / scope;
- run ID only as secondary detail;
- started time and elapsed time;
- target / processed / remaining / progress %;
- L2 deterministic resolved;
- L3 queued / active / completed / rejected;
- L4 required;
- admitted / unchanged / blocked / failed;
- Evidence created / reused;
- current provider/model route;
- retries / 429 / 5xx;
- vendor units and cost;
- AI calls/tokens/cost where applicable;
- p50/p95 latency where sample size is meaningful;
- throughput per minute/hour;
- estimated completion time based on measured recent throughput;
- quota/rate/resource headroom;
- next scheduled/automatic action;
- one-click Jobs, Evidence, L3/L4 and affected consumer-data drill-downs.

During active work, the card must update automatically by Realtime subscription where practical or bounded polling around every 5–10 seconds. Operators must not need to press Refresh to see active progress.

## Cadence metrics

### Live / active run

Show only execution state needed to operate the run: progress, queues, failures, resource pressure, throughput and ETA.

### Hourly

Retain/report:

- jobs started/completed/failed;
- items processed;
- L2 resolved;
- L3 queued/completed/rejected;
- L4 exceptions;
- canonical admissions;
- Search/API projection changes;
- consumer coverage deltas;
- Evidence created/reused and storage growth;
- provider units/cost, AI calls/tokens/cost;
- p50/p95 latency;
- retries, 429, 5xx and other failures;
- backlog by stage;
- quota/resource headroom;
- forecast based on recent throughput;
- exact blocker or next action.

### Daily

Aggregate the same measures by country, provider/source, data family and execution route. Include:

- admission yield per 100 processed items;
- L3 fall-out rate;
- Layer 4 exception rate;
- unchanged/replay efficiency;
- cost/unit and Evidence growth;
- backlog burn-down/burn-up;
- stale source/profile count;
- forecast days/hours to complete active qualified scope at observed throughput;
- capacity/quota risk for the next 24–72 hours.

Daily reporting should identify trends requiring action; it must not simply repeat cumulative totals.

## Resource planning metrics

Operational telemetry must support resource forecasting for:

- scraper/vendor quota and monthly units;
- model requests/minute and requests/day;
- AI input/output tokens and cost ceilings;
- database statement/runtime latency;
- Edge execution duration/failure rate;
- Evidence object count/bytes/storage growth;
- scheduler queue depth and oldest age;
- concurrent workers and saturation;
- API response latency/rate pressure;
- estimated time/cost to clear current qualified backlog.

Forecasts must label assumptions and use recent measured throughput rather than invented constants.

## Role-specific views

### Platform Admin

Show system health, security/identity boundaries, scheduler/worker status, provider/model quotas, database/Edge health, storage growth, consumer API health and alerts. Configuration and raw diagnostics remain available but are not the default dashboard.

### PIM / Data Admin

Show source freshness, qualified scope coverage, running ingestion/enrichment, field coverage gaps, admission yield, blocked/parked work, Evidence links and next runnable scopes.

### Reviewer

Show only Layer 4/quality exceptions requiring human decision, Evidence, conflicts, impact and decision history. Do not make reviewers inspect normal successful ingestion telemetry.

### Counsellor / business user

Show curated Provider/Course/Scholarship/Ranking/Statistics data and freshness/quality indicators relevant to use. Do not expose pipeline internals unless the role also has an operational role.

### Integration / operations support

Show Search/Wix/Zoho API health, projection freshness, payload/version, failed requests, rate limits, affected records and direct links to source/admission lineage where authorised.

## Screen refactoring rule

For every Admin screen, document:

- primary user/role;
- primary decision/action;
- five to eight default metrics/controls maximum where practical;
- which existing elements are removed, merged or moved to progressive disclosure;
- direct cross-links to Jobs/Evidence/related records;
- live/stale-state behaviour;
- empty/error/blocker states;
- role/rank visibility.

No new metric card should be added without identifying the operator action it supports.

## Monitoring and autonomous delivery contract

CF-247 delivery is monitored hourly. Each hourly cycle must:

1. reconcile current Admin/Pilot/runtime/CI truth;
2. capture the actionable metrics above where available;
3. continue the next safe implementation or data-admission step without waiting for a user `proceed` message;
4. update the governed hourly monitoring record and continuity documents when state changes;
5. report the outcome achieved in that hour and the exact next action;
6. stop only for a hard external API/quota/tool/auth/approval/safety limit or a genuine authority/security blocker.

If execution is blocked by an external limit, the hourly entry must name the provider/tool, exact limit/error, affected work and earliest/required recovery action. `Waiting for user command` is not a valid operational state for routine safe work.

## Tool/context budget rule

Work must be split into bounded executable increments sized to available tool/context limits. Before a long tool session approaches exhaustion:

- persist implementation/runtime evidence;
- update `CURRENT-STATE`, `FOLLOW-UPS` and `NEXT-CHAT`;
- record pending CI/run IDs and exact decision rule;
- avoid launching duplicate work merely because a chat/tool session ended.

Hourly monitoring continues from repository/runtime truth, not from the prior chat transcript.

## Acceptance

The standard passes only when:

- active runs visibly update without manual refresh;
- every headline metric drills to the records producing it;
- stage metrics reconcile end-to-end from L1/L2/L3/L4 to admission/Search;
- historical/stale information is visually separated from live state;
- role-specific screens are demonstrably less cluttered and more actionable;
- hourly and daily reports can be generated from retained telemetry;
- resource/quota forecasts are based on measured data;
- automated monitoring records progress even when the user is not interacting with the chat.
