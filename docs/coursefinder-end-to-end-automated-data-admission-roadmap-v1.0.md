# CourseFinder End-to-End Automated Data Admission Roadmap v1.0

**Status:** ACTIVE PROGRAMME DELIVERY ROADMAP  
**Effective:** 15 September 2026  
**Change Control:** `CF-CHG-20260915-247`  
**Scope:** Layer 1–4 automation, country adapters, Course facts, Scholarships, Rankings, Statistics, Evidence, Search/API consumers and Admin operations.

## Outcome

CourseFinder is feature-complete for a data family only when a governed source can run one time and repeatedly through this lifecycle without routine engineering intervention:

`Source → Layer 1 identity/authority → Layer 2 acquisition + Evidence + deterministic extraction → Layer 3 evidence-bound interpretation when needed → policy admission or Layer 4 exception → canonical data → Search/publication projection → Wix/Website + Zoho/API → live Admin operations/telemetry`.

A parser, successful scrape, Evidence row, Layer 2 batch, `layer3_required` state or AI candidate is not by itself a completed feature.

## Programme decision

The programme will no longer optimise milestone completion around isolated parsers, one-off provider workers or manual Layer 3 runs. Existing accepted components are retained, but all new work is judged against the end-to-end lifecycle above.

M2.4.7–M2.4.9 remain useful governance/checkpoint labels, but they are not separate architecture redesign phases. The primary delivery track is now this roadmap. Bugs/security/tooling continue in parallel and block only when they directly affect authority, data correctness, recoverability or safe consumer exposure.

## Layer responsibilities

### Layer 1 — authoritative substrate

Layer 1 owns stable Provider/Course identity and national/regulatory/statistical source authority. It must:

- acquire authoritative registries/datasets;
- preserve source identifiers, editions/versions and Evidence;
- reconcile lifecycle state without name-derived identity shortcuts;
- expose stable entities/scopes to downstream layers;
- never depend on Layer 2/3 AI to redefine authoritative identity.

### Layer 2 — deterministic acquisition and extraction

Layer 2 owns repeatable first-party/provider acquisition and deterministic extraction. It must:

- resolve a qualified source/profile for each target scope;
- select URLs/endpoints/files using reusable adapter contracts;
- acquire by governed Direct HTTP → approved scraper/provider → fallback routing;
- retain native Evidence and normalized Evidence;
- run deterministic parsers/structured extraction;
- validate identity/scope against Layer 1;
- admit exact, policy-approved deterministic facts through the admission service;
- enqueue unresolved fields to Layer 3 with Evidence, entity, task class, field policy and reason;
- schedule rechecks with hash/change detection and bounded retries;
- expose live run/wave/item telemetry.

**Layer 2 is not complete when it only sets `layer3_required`. It is complete when every item is either deterministically admitted, queued to Layer 3, explicitly blocked/parked, or unchanged.**

### Layer 3 — automated evidence interpretation

Layer 3 owns evidence-bound interpretation for fields that deterministic extraction cannot safely resolve. It must:

- continuously drain eligible Layer 2 handoffs without an operator pressing Run;
- select only enabled, unpaused, benchmark-passed model profiles for the task class;
- retain exact model, prompt/profile, calls, tokens, latency, cost, validator and Evidence telemetry;
- apply deterministic validators after model output;
- never invent values or redefine Layer 1 identity;
- route validated results through a separate field-admission policy service;
- auto-admit only field classes explicitly authorised for validated Layer 3 admission;
- route ambiguous, conflicting, identity-sensitive or consequential results to Layer 4;
- use zero-call paths for unchanged/already-resolved Evidence.

The AI endpoint never obtains unrestricted canonical-write authority. Admission remains a deterministic server-side policy decision.

### Layer 4 — exception resolution

Layer 4 is the exception queue, not the normal data pipeline. It handles:

- identity ambiguity;
- conflicting qualified sources;
- low-confidence/validator-failed interpretation;
- consequential publication decisions;
- protected/manual override fields.

The target operating posture is that the majority of routine source refreshes never require Layer 4.

## Universal execution architecture

### 1. Source/adapter contract

Every source adapter implements the same logical contract:

- `discover(scope)` → governed target records/URLs/files;
- `acquire(target)` → immutable Evidence;
- `normalize(evidence)` → normalized Evidence;
- `extract(normalized_evidence, schema)` → deterministic field candidates + unresolved tasks;
- `identity_check(entity, source_identity)` → pass/fail/ambiguous;
- `freshness/hash` → changed/unchanged;
- `telemetry` → route, retries, latency, units/cost.

Provider/country-specific code should be restricted to source-specific discovery/parsing where unavoidable. Scheduling, retries, Evidence, handoff, admission, telemetry and projection must remain shared infrastructure.

### 2. Field policy registry

Each consumer-relevant field declares:

- entity type and grain;
- Layer 1/2/3 source authority;
- deterministic parser/validator;
- Layer 3 task class when allowed;
- minimum benchmark/validator/confidence requirements;
- automatic admission permitted: yes/no;
- Layer 4 trigger conditions;
- freshness cadence;
- Search/Wix/Zoho exposure policy.

This removes task-specific admission logic from ad-hoc parsers.

### 3. Automatic Layer 2 → Layer 3 queue

Introduce one durable queue/state contract for unresolved Evidence work:

`pending → reserved → interpreting → validated | no_candidate | rejected → admission_pending | layer4_required → admitted | resolved_layer4`.

Requirements:

- idempotency by Evidence hash + entity + task class + profile/policy version;
- bounded concurrency and provider/day/minute budgets;
- retry ceiling and parked state;
- automatic dispatcher/scheduler;
- per-item trace to originating Layer 2 run/wave;
- stale recovery;
- operator pause/resume/cancel without deleting Evidence.

### 4. Deterministic admission service

One admission surface accepts Layer 2 deterministic candidates and authorised Layer 3 validated candidates. It performs:

- Layer 1 identity check;
- source qualification/admitted-domain check;
- field grain/cardinality validation;
- source/evidence/version/freshness validation;
- field-specific semantic validation;
- conflict/precedence decision;
- append-only decision/provenance record;
- canonical mutation only when authorised;
- Search/publication invalidation signal after a real accepted change.

### 5. Projection and consumer boundary

After accepted canonical changes:

- refresh governed Search projection incrementally;
- Wix/Website and Zoho APIs read curated contracts only;
- null/zero/suppressed/not-applicable/not-yet-enriched semantics remain explicit;
- Evidence/private operational schemas are never directly exposed;
- consumer freshness/coverage metadata is returned where useful.

## Data-family implementation

### Course facts

Target fields include official Course URL, intake availability, English requirements, provider-current international tuition, delivery mode, duration and other approved enrichment fields.

Use Layer 2 deterministic extraction first. Layer 3 handles evidence-supported semantic interpretation only. Identity-sensitive mapping remains Layer 1/Layer 4 governed.

### Scholarships

Use the same orchestration contract:

first-party catalogue/detail discovery → Evidence → deterministic classification/extraction → Layer 3 only for approved semantic classification/detail extraction → admission → explicit Provider/Course scopes → Search/API.

Existing Scholarship-specific functions become adapters/workers behind the shared orchestration contract rather than a separate operational universe.

### Rankings

Publisher editions/files/pages remain source-authoritative. Ranking ingestion uses Layer 1/statistical dataset identity, Evidence and edition/versioning, deterministic mapping to Provider identity, exception routing for ambiguous Provider mapping, then curated consumer projection. AI is not required for numeric rank ingestion when deterministic publisher identity is available.

### Statistics / QILT / PRISMS / country equivalents

Retain observation grain: source, measure, cohort/dimension, geography/entity, period/edition and suppression semantics. ETL is deterministic; AI is not used to manufacture statistical observations. Consumer correlation occurs through governed relational mapping/projection.

### Provider contacts/assets and later enrichment families

Use the same source/adapter/queue/admission model, with field-specific privacy/publication rules. A successful acquisition is not automatic public admission.

## Country model

Country onboarding changes source authority/adapters, not the pipeline architecture.

Current governed order remains:

1. AU — accepted substrate and active enrichment;
2. NZ — Layer 1 accepted; Layer 2 Course source/profile qualification must be independently completed;
3. CA — next active authoritative-source expansion;
4. GB;
5. US;
6. IE;
7. DE after its identity/source-authority blocker is resolved.

For GB/US/IE/DE, the shared pipeline is tested with contract fixtures and qualified pilot sources before full live admission. A country is not declared supported merely because the generic engine can parse a fixture.

## Delivery roadmap

### Track A — close the automation gap first

1. Implement durable Layer 3 work queue sourced automatically from Layer 2 fall-out.
2. Implement server-owned Layer 3 dispatcher with concurrency/rate/day/cost controls.
3. Extend the Layer 3 task registry/model benchmarks to the actual Course-fact task classes being produced by Layer 2.
4. Implement the deterministic post-L3 admission policy service.
5. Wire accepted admission to incremental Search/API projection.
6. Add live Admin run view with Layer 2 → Layer 3 → Layer 4 → admitted counters and 5–10 second refresh/realtime events.

This is the highest priority because current runtime proves Layer 2 can generate Evidence and Layer 3 fall-out, but Layer 3 is not automatically draining that work.

### Track B — consolidate execution without big-bang refactor

1. Keep working accepted Edge functions.
2. Put them behind shared orchestration/state/admission contracts.
3. Migrate duplicated provider-specific scheduling/retry/admission logic only when touched or when it blocks scale.
4. Retire one-off/recovery/probe functions after replacement path is proven.
5. Do not rewrite stable parsers merely for architectural cleanliness.

### Track C — AU full useful-data fill

Run controlled AU Provider waves through the completed automatic lifecycle and measure:

- target/processed;
- deterministic L2 resolution;
- Layer 3 queued/validated/no-candidate/rejected;
- Layer 4 exceptions;
- admitted field changes;
- Search/API delta;
- vendor/model units, cost and latency;
- Evidence completeness.

Expand source qualification/provider coverage only after the shared loop proves end-to-end admission.

### Track D — NZ and CA

NZ: qualify first-party Course enrichment sources independently, then run the exact same lifecycle.

CA: retain national/provincial authoritative identity work, then plug first-party/provider Course enrichment into the shared adapter contract. Do not reproduce the AU implementation as country-specific orchestration.

### Track E — GB / US / IE / DE portability gate

Before broad country ingestion, run a portability suite against representative qualified source forms:

- structured API/JSON;
- HTML catalogue/detail;
- sitemap/index discovery;
- CSV/XLSX authoritative dataset;
- PDF/static publication where applicable;
- pagination and multi-campus/multi-intake examples;
- changed/unchanged replay;
- source deletion/retirement;
- identity ambiguity/fail-closed case.

Only the source adapter changes. Queueing, Evidence, Layer 3, admission, telemetry and consumer projection must pass unchanged.

### Track F — Scholarships / Rankings / Statistics convergence

Prove that each existing data family is operable through the common job/telemetry/control-plane model even where its extraction/admission rules differ. The objective is one Admin operations experience, not one universal parser.

### Track G — consumer and operator completion

Admin Cloudflare UI must provide:

- live active run/wave card;
- Layer 1/2/3/4 counts in one trace;
- processed/remaining/progress %;
- Evidence created/reused;
- admitted/unchanged/rejected/blocked;
- exact stop reason;
- provider/model/units/tokens/cost/latency;
- pause/resume/cancel/retry where safe;
- next scheduled run;
- coverage/freshness deltas;
- direct Jobs/Evidence/Layer 4 links.

Wix/Website and Zoho receive versioned, curated, authenticated/rate-limited consumer APIs with no direct canonical-write authority.

## Acceptance matrix

The roadmap does not PASS on one AU university.

### Functional matrix

For each applicable source/data family:

- initial full load;
- incremental changed record;
- unchanged replay / zero-change path;
- failed acquisition and bounded retry;
- duplicate dispatch/idempotency;
- stale runner recovery;
- Evidence retention/replay;
- deterministic L2 success;
- L2 → automatic L3 handoff;
- valid L3 interpretation;
- model/validator rejection;
- Layer 4 routing;
- deterministic admission;
- no-op admission;
- Search/API delta only after accepted change;
- scheduled recheck.

### Portability matrix

Run shared contract tests across:

- AU live accepted profiles;
- NZ qualified pilot profile before enabling broad Course enrichment;
- CA qualified pilot profile;
- GB/US/IE/DE representative adapter fixtures and then one qualified live pilot when source authority is accepted.

### Data-family matrix

- Course facts;
- Scholarships;
- Rankings;
- Statistics/outcomes;
- Provider contacts/assets where consumer admission is authorised.

### Security matrix

- anonymous/insufficient-rank denial;
- browser cannot execute service-only workers/admission helpers;
- SECURITY DEFINER/search_path/grant audit;
- private Evidence access controls;
- Vault/secret non-exposure;
- Edge auth/automation-key controls;
- API auth/rate limits;
- Layer 1 identity cannot be mutated by Layer 2/3;
- Layer 3 model cannot bypass admission policy;
- Layer 4 consequential actions remain role-gated/audited.

### Performance/reliability matrix

- representative 1 / 10 / 100 / 500 item waves where source/provider limits permit;
- queue fairness;
- concurrency ceiling;
- provider/model rate and daily ceilings;
- recovery after timeout/provider 429/5xx;
- bounded storage/Evidence growth;
- API/Search response budgets;
- no statement-timeout regressions on operator dashboards.

## Definition of Done

The programme may move on from the automation foundation only when:

1. a qualified source can be started from Admin or schedule;
2. Layer 2 produces/reuses Evidence and deterministic results;
3. unresolved eligible items automatically execute Layer 3 without chat/operator intervention;
4. validated authorised fields automatically pass the deterministic admission service;
5. exceptions alone reach Layer 4;
6. accepted changes automatically reach Search/consumer projections;
7. Admin shows live end-to-end progress;
8. the same shared orchestration passes AU plus NZ/CA pilots and portability tests for GB/US/IE/DE adapter forms;
9. Scholarships, Rankings and Statistics use the same operational control-plane conventions;
10. Wix/Website and Zoho consume safe curated APIs;
11. replay/idempotency/recovery/security/telemetry tests pass.

## Explicit non-goals

- No big-bang rewrite of every existing Edge Function.
- No generic AI parser replacing deterministic authoritative ingestion.
- No automatic Layer 3 admission for identity/regulatory/high-consequence fields without explicit policy.
- No broad country admission before source authority/identity qualification.
- No milestone/document perfection as a prerequisite for useful admitted data.

## Immediate execution order

1. Build automatic Layer 3 queue + dispatcher from existing Layer 2 `layer3_required` outcomes.
2. Add task-specific benchmarked model routes for the Course fields currently falling out of RMIT/UQ waves; use free routes where they meet quality, not merely because they are free.
3. Add deterministic Layer 3 admission policy and Search projection trigger.
4. Add live end-to-end UI progress.
5. Re-run AU controlled waves and prove admitted data increases without manual chat intervention.
6. Apply the same pipeline to NZ qualified pilot and CA qualified pilot.
7. Run portability fixtures for GB/US/IE/DE.
8. Converge Scholarship/Ranking/Statistics operations into the same job/telemetry/control-plane conventions.
