# CF-CHG-20260825-036 — M2.3 Production-Grade Data Operations, Scale Enrichment & Decision UX

**Status:** APPROVED / IN PROGRESS — EXPANDED SCOPE  
**Category:** 00-governance-programme  
**Initiated:** 25 August 2026 21:26 AEST (+10:00)  
**Scope expanded:** 25 August 2026 22:05 AEST (+10:00)  
**Origin:** M2.2 → M2.3 sequential progression  
**Owner:** CourseFinder programme / Data Operations

## Trigger

M2.2 is CLOSED / PASS. The user explicitly authorised immediate progression to M2.3 and has now expanded M2.3 to make Layer 1 a production-grade operational capability, mature batch governance across regulatory and enrichment sources, redesign the Data Operations navigation/journey, add a governed Scholarship Selection mini-app, enrich Course detail with QILT/PRISMS context where applicable, and complete role-based Admin/User guidance with screen mock-ups and quick tours.

The planned-hours baseline remains the existing 12-hour M2.3 planning allocation until engagement time is explicitly reconciled. Technical execution does not create billable-time entries.

## Core milestone outcome

M2.3 is no longer only a Layer 2 scale-out milestone. It is the **production-grade Data Operations maturity gate** for Layer 1 and Layer 2, plus the first governed decision-support experience built on Scholarship/Course/Provider facts.

Layer 1 is to be treated as **production-grade and operationally accepted**, not experimental. This does not create the separate Production environment or spend M2.5 Production deployment authority. Pilot remains the current deployed validation environment; Layer 1 semantics and operating controls must nevertheless meet Production-quality standards.

## Required operational journey

The Admin IA must present one coherent parent journey rather than scattered ingestion pages:

**Data Operations**

1. **Overview** — end-to-end Layer 1 → Layer 4 state, current jobs, freshness, blockers and next actions.
2. **Layer 1 — Regulatory** — production-grade authoritative ingestion, source health, schedules, batches, counts, freshness, validation and replay.
3. **Layer 2 — Enrichment** — deterministic/structured enrichment, provider routing, evidence, batches, retry/resume, economics and unresolved fall-out.
4. **Layer 3 — AI Interpretation** — visible handoff/readiness state only until M2.4 grants operational AI authority.
5. **Layer 4 — Human Resolution** — terminal review/escalation context; do not invent a Layer 5.
6. **Evidence & Provenance** — shared evidence browser and entity/source lineage.
7. **Jobs / Runs** — cross-layer execution history, retry/resume, outcomes and diagnostics.

Remove or merge redundant/duplicated menu entries and low-value technical pages that fragment this journey. Preserve role/permission boundaries and deep links.

## Scope

### 1. Layer 1 — production-grade regulatory operations

- Remove experimental/trial framing for accepted Layer 1 country/source pipelines.
- Reconcile every currently accepted regulatory Provider/Course source and adapter.
- Define, sort and vet per-source batch processing limits, concurrency, rate limits, pagination/page-size, retry policy, resume cursor, timeout and maximum safe execution window.
- Distinguish source-native limits from CourseFinder safety limits.
- Validate repeatability, idempotency, freshness, identity invariants, source-null semantics, replay and failure recovery.
- Expose source health, last success, record counts, deltas, current run, freshness SLA, blocker and next action.
- No regulatory source is called production-grade until its actual source-specific limits and safe operating policy are evidenced.

### 2. Layer 2 — production-shaped scale and economics

- Controlled provider budgets/concurrency and no surprise paid fallback.
- Production-shaped batch scheduling, retry/resume and rate controls.
- Evidence dedupe, retention, storage thresholds and growth economics.
- Representative and broad AU/NZ Course/Scholarship enrichment with identity and fee guards.
- NZ first-party Layer 2 qualification/profile work where current profile coverage is absent.
- Measure vendor units, cost/entity, cost/resolved entity, retry/fallback, Evidence/entity and resolution quality.

### 3. Unified Data Operations UX

For Layers 1–4 expose consistent operational concepts where applicable:

- source/configuration;
- authority class;
- last successful run;
- current job/run;
- records discovered/selected/processed/accepted/rejected;
- creates/updates/unchanged/conflicts;
- Evidence count;
- duration;
- batch size/limit/concurrency;
- retry/resume cursor;
- next scheduled/allowed action;
- health/freshness;
- blocker;
- affected entities;
- Change Control/UAT reference.

Use drill-down rather than duplicate pages. Optimize for an operator understanding the full ingestion/enrichment journey quickly.

### 4. Scholarship Selection mini-app

Create a governed decision-support mini-app that helps identify suitable University/Course options based on Scholarship availability and explicit user-selected criteria.

It must:

- assimilate only governed Course, Provider, Scholarship and accepted contextual facts;
- allow filtering/ranking by criteria such as country, Provider, Course/field, study level, tuition, Scholarship value/type, eligibility, audience/nationality constraints where source-supported, intake/cycle, closing date and available contextual quality signals;
- explain why each option ranks/matches;
- distinguish source fact, derived score and missing/unresolved data;
- never manufacture eligibility or Scholarship values;
- avoid opaque claims of a universally “best” University/Course;
- use explicit, inspectable weighting/ranking criteria;
- link recommendations back to Course, Provider, Scholarship and Evidence detail;
- remain decision support, not an admissions/application/offer/visa workflow.

Where Scholarship coverage is insufficient, the app must surface coverage limitations rather than return fabricated rankings.

### 5. Course detail blade — contextual intelligence

The Course detail blade must include, where applicable and available:

- existing canonical/regulatory Course facts;
- Provider-current Layer 2 facts;
- CRICOS fee semantics kept separate from Provider-current tuition;
- QILT Provider/course-relevant contextual outcomes with reporting period/source grain clearly labelled;
- PRISMS contextual student-flow/provider/course signals where the accepted mapping genuinely applies;
- Scholarship links/counts relevant to the Course/Provider;
- Evidence/provenance and freshness;
- completeness/readiness and unresolved facts;
- Search/publication state without implying publication authority.

QILT/PRISMS must remain contextual analytical signals. Do not flatten provider-level or reporting-period data into unsupported Course facts.

### 6. Menu simplification

Audit the full Admin navigation and remove unnecessary overhead. Prefer a small number of clear parent workspaces:

- Dashboard
- Catalogue / PIM
- Data Operations
- Data Quality
- Scholarship Selection
- Search / Publication (only where currently authorised)
- Administration / Settings
- Help / Guides

Exact labels may be refined through the accepted navigation design, but duplicated ingestion/pipeline/source/evidence/job pages must be consolidated under Data Operations where practical.

### 7. Admin/User Guide + role quick tours

Update the maintained Admin and User Guides to match the deployed UI, including role-specific use paths for:

- Platform Admin;
- PIM/Data Administrator;
- Reviewer;
- Counsellor / decision-support user;
- Integration/operations support.

Documentation must include:

- screen mock-ups or current representative screenshots where appropriate;
- a short role-based quick tour;
- what each page is for;
- recommended operational sequence;
- common mistakes/semantic traps;
- links between Layer 1–4, Evidence, Course details and Scholarship Selection;
- batch/retry/resume operating guidance;
- field/source/authority explanations where ambiguity is likely.

### 8. Automated UAT

Automated UAT remains the default. M2.3 requires database/API/security/storage/deployed-browser/performance/replay evidence, including:

- Layer 1 source-specific batch-limit and replay tests;
- Layer 2 batch/retry/resume/provider-budget tests;
- no surprise paid-provider fallback;
- Evidence dedupe/retention/storage tests;
- Course detail QILT/PRISMS semantic tests;
- Scholarship Selection deterministic scoring/explanation/coverage tests;
- role/navigation/negative-authorisation tests;
- desktop/mobile tests for the redesigned Data Operations journey;
- regression of M1/M2.1/M2.2 identity, fee, Auth, Search and Publication invariants.

## Additional design improvements incorporated

1. **Source certification matrix:** each Layer 1/2 source gets an operational classification such as READY / CONDITIONAL / BLOCKED with evidenced limits, freshness and recovery behaviour.
2. **Batch policy registry:** centralise source/provider batch limits and budgets instead of scattering constants through workers.
3. **Dry-run / impact preview:** where feasible, show selected entities, expected source/provider, limit/budget and canonical-mutation consequences before a broad batch starts.
4. **Cross-layer entity timeline:** on Provider/Course detail, show significant Layer 1 → Layer 2 → Layer 3 → Layer 4 events and Evidence lineage without making the UI a raw log viewer.
5. **Coverage-aware Scholarship scoring:** ranking confidence should fall when relevant Scholarship or Course facts are unresolved; missing data is not treated as zero.
6. **Operational dashboard KPIs:** freshness, failed sources, active batches, retry backlog, Evidence growth, paid-vendor consumption and L3/L4 fall-out should be visible without opening individual jobs.
7. **No dead-end navigation:** every blocker/exception should deep-link to the source, entity, Evidence or corrective action where permissions allow.

## Authority boundaries

M2.3 does not authorise:

- the separate Production environment/cutover owned by M2.5;
- Layer 3 AI execution beyond accepted handoff/readiness visibility;
- broad Publication;
- Production consumer traffic;
- Zoho cutover;
- final Production handover;
- fabricated Course/Provider/Scholarship/QILT/PRISMS facts.

Layer 4 remains terminal. Search Projection, Search Visibility and Publication remain downstream product states.

## Current evidence inherited

- M2.2 CLOSED / PASS on Pilot SHA `38ad08bb75ee7cf26a0a701a3ae008d1563b915b`.
- First real M2.3 UQ batch completed 3/3 resolved at Layer 2 after one bounded retry, 3 vendor units, USD 0 vendor cost.
- Modern Evidence idempotent replay/dedupe controls are implemented; current Evidence capacity remains within the accepted planning envelope.
- Firecrawl credential is operational historically but paid entitlement/cost authority is not proven; paid Firecrawl scale remains blocked from implicit use.
- Current NZ Layer 2 Course-detail first-party profile coverage remains a gap to qualify/implement.

## Acceptance

M2.3 closes only when:

- accepted Layer 1 sources are production-grade and source-specific batch policies are vetted;
- Layer 2 representative/broad batching, retries, economics and Evidence controls are proven;
- the unified Data Operations IA is deployed and role-safe;
- Course detail contextual QILT/PRISMS presentation passes semantic UAT;
- Scholarship Selection is deployed with transparent criteria and coverage-aware behaviour;
- Admin/User Guides and role quick tours match the deployed UI;
- implemented scope passes automated database/API/security/storage/browser/performance/replay UAT;
- M1/M2.1/M2.2 invariants remain safe;
- paid-provider blockers are resolved or explicitly isolated without hidden spend.

## Rollback

Any batch or UX change that threatens canonical identity, source authority, fee semantics, Evidence integrity, security, storage capacity, provider budget or publication boundaries is stopped/reverted and retained as blocker evidence. Publication remains unaffected unless a later authorised gate changes it.

## Documentation

Maintain Master Project Plan/TSOW, Running Build, Change Control Register, navigation/IA decisions, Operations Runbook, Data Flow & Feature Atlas, Admin/PIM Guide, User Guide, role quick-tour material, milestone meeting record and M2.3 UAT evidence throughout execution.
