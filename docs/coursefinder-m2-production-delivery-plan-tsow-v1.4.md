# CourseFinder M2 → Production Delivery Plan / TSOW v1.4

**Issued:** 25 August 2026  
**Status:** CURRENT  
**Supersedes:** v1.3  
**Programme baseline:** Master Project Plan v1.71  
**Change Controls:** CF-CHG-20260825-036, CF-CHG-20260825-037, CF-CHG-20260825-038

## 1. M2.3 status

M2.3 is ACTIVE / EXPANDED into the full production-grade Data Operations gate for Layers 1–4, onboarding, refresh intelligence, unified navigation, Scholarship decision support, Course contextual intelligence, Important Links/Dates and role guidance.

The existing 12-hour M2.3 allocation remains the planning baseline only. This revision does not infer additional billable engagement time.

## 2. M2.3 technical scope

| Task ID | Workstream | Actionable task | Planning allocation | Acceptance |
|---|---|---|---:|---|
| M2.3-01 | Layer 1 | Production-grade source certification; source-specific batch/rate/retry/resume/freshness policies | 1.0 | READY/CONDITIONAL/BLOCKED matrix |
| M2.3-02 | Layer 2 scale | AU/NZ deterministic batches, paid-provider budget controls, retry/resume, Evidence/economics | 1.5 | representative/broad scale evidence |
| M2.3-03 | Refresh scheduler | Build source/entity freshness classes, change-triggered L2, unresolved/change-triggered L3 and important-date refresh triggers | 1.0 | no indiscriminate LLM/re-ingestion; deterministic scheduling UAT |
| M2.3-04 | Layer 3 AI | Operationalise aggregator/provider profiles, free-model preference, server-side secrets, rate/token/retry budgets, structured-output validation and candidate lineage | 1.5 | bounded AI interpretation PASS |
| M2.3-05 | Layer 4 | Operational terminal human review queue with approve/edit/reject/return-for-evidence and audit lineage | 1.0 | role/security/audit UAT |
| M2.3-06 | Onboarding | Country/Provider/Course onboarding lifecycle, adapter assessment, shared canonical-model assessment and UAT/promotion readiness | 1.0 | reusable onboarding workflow |
| M2.3-07 | Unified UX | Data Operations parent menu for L1–L4, Evidence, Jobs; remove redundant overhead; role-aware navigation | 1.0 | desktop/mobile navigation PASS |
| M2.3-08 | Course/Scholarship intelligence | Course QILT/PRISMS/Scholarship context + transparent Scholarship Selection mini-app | 1.5 | semantic/scoring/coverage UAT |
| M2.3-09 | Links & dates | Governed Important Links directory + sourced Important Dates registry/ticker + targeted refresh integration | 0.75 | freshness/source/date UAT |
| M2.3-10 | Guides | Role quick tours with deployed screenshots/mock-ups, semantic traps and operating instructions | 0.5 | guides match deployed UI |
| M2.3-11 | Consolidated Auto-UAT | DB/API/security/storage/AI/replay/performance/desktop/mobile regression | 1.25 | M2.3 PASS/BLOCKED evidence |
|  |  | **M2.3 total** | **12.0** | |

## 3. Layer 3 efficiency rule

Do not send the full catalogue to an LLM on a frequent calendar schedule. Layer 3 executes only when deterministic Layer 2 cannot safely resolve a required fact, new/changed Evidence arrives, a prior interpretation expires, or a governed revalidation event requires it.

Free/zero-cost models are preferred where they pass task validation. Model availability is dynamic; use an OpenAI-compatible provider abstraction and versioned model profiles. API keys remain server/Vault only.

## 4. Refresh-cycle defaults

These are policy starting points, not universal hard-coded schedules:

- regulatory authorities: according to published/source-observed update cadence, otherwise daily/weekly health checks with hash/delta-driven ingestion;
- Provider/Course first-party facts: monthly/term-cycle by default, accelerated around known intake/fee/application changes and when upstream hashes change;
- Scholarships: more frequent near application/open/close windows; otherwise event/monthly cadence;
- QILT/PRISMS/national outcomes: source release cadence rather than daily polling;
- Layer 3: event-driven only on unresolved/changed/expired interpretation;
- Layer 4: event-driven queue;
- Important Links verification: periodic health check plus source-failure trigger;
- Important Dates: warning windows and targeted refresh around sourced deadlines.

Actual cadence must be source-certified and configurable.

## 5. Firecrawl

User-confirmed paid entitlement is 5,000 pages/month. Track monthly used/remaining pages, batch estimate, warning/stop threshold, pages/entity and pages/resolved entity. Never silently exceed the governed monthly budget. Prefer Direct HTTP when sufficient.

## 6. M2.4

M2.4 is repurposed from initial Layer 3 implementation to AI/Data Quality optimisation, cost/quality benchmarking, queue/freshness tuning, residual-risk closure, full-stack regression and pre-blackout freeze/restart instructions.

## 7. Boundaries

M2.3 does not create the separate Production environment, grant broad Publication, perform Zoho cutover or final Production handover. Layer 4 remains terminal; Search/Publication remain downstream states.
