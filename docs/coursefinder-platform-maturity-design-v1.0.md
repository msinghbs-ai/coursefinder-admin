# CourseFinder Platform Maturity Design v1.0

**Status:** CURRENT DESIGN BASELINE — POST-M2.4 / M2.5+  
**Issued:** 1 September 2026  
**Change Control:** `CF-CHG-20260901-050`  
**Implementation authority:** DESIGN ONLY — individual implementation items require their owning milestone/change control.

## 1. Purpose

This document converts post-M2.4 platform-maturity questions into durable architecture/design decisions and separates:
- capability already implemented and accepted;
- capability designed but not yet exposed operationally;
- genuine implementation gaps;
- UAT/performance principles that must remain standing.

M2.4 remains CLOSED/PASS. Nothing in this document reopens M2.4.4.

## 2. Platform maturity model

The mature CourseFinder control plane remains:

`Layer 1 authoritative/regulatory → Layer 2 deterministic acquisition/extraction → Layer 3 governed AI interpretation → Layer 4 governed human intervention → governed Search/Website/Zoho consumers`.

Production maturity adds:
- environment isolation;
- source onboarding/versioning;
- operational health/capacity;
- manual intervention controls;
- retention/housekeeping;
- consumer caching/version invalidation;
- repeatable UAT;
- security/performance budgets.

---

# 3. Scholarships — acquisition and Course relationships

## Current mechanism

Scholarship acquisition is already a first-class domain, not a free-text Course field.

The accepted schema model contains:
- `scholarship.scholarships` — canonical Scholarship entity;
- award tiers/windows/criteria;
- `scholarship.scopes` — typed include/exclude scope;
- `scholarship.course_links` — explicit Course↔Scholarship relationship;
- `scholarship.coverage` — verified available / verified-none / unknown / needs-review coverage;
- source/Evidence/confidence/validity on relationships.

Supported typed scope design includes:
- provider;
- course;
- course collection;
- category;
- study level;
- country;
- campus;
- all courses.

M2.4.4 added scheduled Scholarship ETL/maintenance. Deterministic relationships are created only when explicit Provider/Course include scope supports them. Evidence/source history is retained.

## Relationship resolution principle

A Scholarship must not be attached to every Course merely because it is published on the same website.

Relationship confidence hierarchy:
1. explicit Course ID/code/name with deterministic identity match;
2. explicit Provider-wide/all-courses scope;
3. explicit study-level/category/course-collection scope resolved through governed taxonomy;
4. explicit campus/country/student-audience scope;
5. ambiguous narrative eligibility → candidate only, Layer 3/4 review;
6. no defensible relationship → no Course link.

`course_links.eligibility_status` must distinguish:
- explicitly eligible;
- structurally in-scope;
- excluded;
- unknown;
- needs review.

The platform must never convert “structurally in scope” into student eligibility. Student-specific eligibility belongs to a later decision/application context.

## Course units / subjects

Current canonical CourseFinder architecture does **not** have a mature unit/subject-level entity that can safely serve as a Scholarship FK.

Therefore:
- Course-level and Course-collection relationships are supported now;
- unit/subject-level Scholarship eligibility must remain source text/criteria until a governed `course_unit`/subject model exists;
- do not create pseudo-unit records from scraped headings simply to attach Scholarships.

Future unit-level support requires a separate academic-structure design covering:
- unit identity/code;
- owning Provider/Course;
- temporal catalogue year;
- elective/core relationship;
- source authority;
- deduplication.

## Required maturity improvements

- Scholarship relationship panel in Scholarship and Course blades;
- show relationship reason, scope type, source, Evidence, confidence, validity;
- filter by Provider, Course, Study Level, Scholarship type, international-only, window status;
- coverage reporting: linked / verified-none / unresolved;
- scheduled relationship revalidation;
- consumer API exposes relationship reason, not inferred eligibility.

---

# 4. Provider groups / collections — G8 and equivalents

## Existing design

The physical architecture already contains:
- `ref.institution_collections`;
- `catalogue.provider_collection_memberships`.

This is the correct model for Group of Eight (G8/Go8) and other groupings. Do **not** add a hard-coded boolean `is_g8` to Provider.

A collection has:
- stable code/name;
- collection type;
- country/region scope;
- official URL;
- lifecycle/status.

Membership has:
- Provider FK;
- membership type;
- status;
- valid-from/to;
- source/Evidence;
- verified timestamp.

## Implementation improvement

Seed governed collections such as:
- AU Group of Eight;
- Australian Technology Network;
- Innovative Research Universities;
- Regional Universities Network;
- Universities Australia where membership semantics are useful;
- country-specific equivalents only where a defensible official source exists.

Admin:
- Provider detail shows active memberships;
- Provider list/filter supports one-or-many collection filters;
- Evidence/source link available;
- historic memberships do not appear as current without validity.

Website/Zoho:
- collection can be exposed as a filter facet only after accepted source/membership UAT;
- consumer display should use collection name, not internal codes.

---

# 5. Layer 1 country onboarding and Production separation

## Current accepted foundation

Country/Provider/Course onboarding framework and authoritative-source matrix already exist.

Current mature rule:
- country catalogue can exist before ingestion is enabled;
- Layer 1 authority/profile is country-specific;
- Layer 2 qualification is separate from Layer 1 catalogue visibility;
- AU/NZ accepted Layer 1 operations are not proof that another country is Production-ready.

Current catalogue has already shown AU, NZ and CA records in Pilot, but country presence alone is not Production acceptance.

## Required onboarding state machine

Each country should move through explicit states:

`seed_only → source_identified → source_qualified → pilot_ingestion → pilot_uat_pass → production_approved → production_enabled → monitored`

Separate status should exist for:
- Provider ingestion;
- Course ingestion;
- Scholarship ingestion;
- Layer 2 Provider-site enrichment;
- consumer/search publication.

## Admin menu

Administration → Country & Source Onboarding should show:
- country;
- authoritative Provider source;
- authoritative Course source;
- licensing/access constraints;
- adapter/profile;
- source health;
- last qualification;
- Pilot status;
- Production status;
- enabled layers;
- last full-run count;
- expected count/range;
- current variance;
- UAT evidence;
- next review.

Layer 1 operational page should run only sources already approved for that environment.

## Environment separation

Pilot and Production source registrations must be independently enabled.

Production validation must never be inferred from Pilot:
- same source/profile version may be deployed;
- Production gets its own run IDs, secrets, source-health evidence and acceptance;
- experimental/new-country sources default disabled in Production;
- Production source enablement requires explicit country/profile approval.

New-country UAT minimum:
1. source reachable and licensed/allowed;
2. schema/format qualification;
3. identity uniqueness;
4. duplicate/idempotency;
5. expected-count/variance;
6. malformed/null handling;
7. source change detection;
8. retry/recovery;
9. Evidence lineage;
10. security/role boundary;
11. Pilot full-run;
12. Production bounded canary;
13. Production count reconciliation;
14. rollback/disable.

---

# 6. UAT catalogue — what is already tested

The accepted deployed UAT matrix currently covers permanent suites for:

- Layer 1 operations;
- Data Quality/readiness;
- performance and payload budgets;
- Layer 2 operational maturity;
- Layer 2 platform/profile configuration;
- Layer 2 Provider flows;
- Administration navigation;
- Course detail UX;
- screen-state persistence;
- Layer 3/4 intelligence operations;
- Layer 3 provider credentials;
- Layer 3 operations maturity;
- cross-layer operations;
- A16 Layer 3 contact / Layer 4 intervention boundary;
- permanent Layer navigation;
- responsive Provider/Course blades;
- quota-aware/background Firecrawl;
- unified Layer headers;
- Evidence type-aware previews and screenshot integrity;
- Layer status summaries;
- A26/A28 parent-run/operator UX;
- Scholarship decision support;
- release notes;
- paged filters;
- contextual QILT/PRISMS/Scholarship insights;
- filter/demo trace;
- Provider international contact intelligence.

Final M2.4.4 acceptance passed desktop and mobile against this governed acceptance tier.

## UAT gaps to add for platform maturity

- Provider collection/G8 membership;
- manual Provider/Course creation;
- field-edit conflict/reconciliation;
- block/unblock Provider/Course;
- storage/capacity alerts;
- retention/purge policy;
- new-country Production canary;
- scraper plug-in onboarding;
- AI model/provider onboarding;
- consumer cache-version invalidation;
- bulk-action permissions/rollback;
- Production restore/DR.

---

# 7. Performance specification and principles

## Existing hard budgets

Standing accepted browser/backend gates:
- normal RPC/detail interaction: **≤ 3,000 ms**;
- management/page payload: **≤ 250 KB**;
- filter/options payload: **≤ 60 KB**.

These are hard acceptance budgets and must not be relaxed merely to obtain PASS.

## Design principles

1. **Page first, enrich after**  
   Page the canonical entity set first, then calculate expensive detail/aggregates for returned rows.

2. **Bound management projections**  
   Do not serialize entire source/profile registries into routine page payloads.

3. **No N+1 consumer fetching**  
   Website/Zoho should use bounded APIs and cache reference data.

4. **Separate ingestion from serving**  
   Bulk scraping/AI execution is background work with quotas/concurrency; consumer reads must not synchronously trigger acquisition.

5. **Consumer caching**  
   Website/Zoho should cache:
   - reference/filter bundle;
   - Provider options;
   - country/subdivision collections;
   - stable Course detail where appropriate;
   - QILT/PRISMS/statistical context with long TTL.

6. **Version invalidation**  
   Add compact version keys such as:
   - `dataset_version`;
   - `provider_version`;
   - `filter_version`;
   - `scholarship_version`;
   - `search_version`.
   Consumers refresh only when relevant version changes.

7. **Heavy-run isolation**  
   Scheduler/concurrency policy must keep ingestion within compute budgets and preserve API/UI SLO.

8. **Scale compute for ingestion, not idle reads**  
   Normal read-heavy Production should be benchmarked independently from bulk ingestion.

---

# 8. Layer 2 working mechanism

Layer 2 is deterministic acquisition/extraction.

Normal chain:

`L1 entity/scope → source/profile qualification → acquisition route → native Evidence → deterministic extraction/normalisation → identity/field validation → accepted L2 fact OR L3/L4 fall-out`.

Core controls:
- Firecrawl-first where profile/policy selects it;
- provider route explicitly selected;
- quota/reserve/rate/concurrency;
- parent run / wave / batch / job lineage;
- retry/resume/stale recovery;
- Evidence retained;
- no automatic L1 identity overwrite;
- no Search/Publication mutation unless separately governed.

Layer 2 should be used for facts that can be obtained deterministically from known source structures/rules.

---

# 9. Layer 3 working mechanism and future AI hookup

Layer 3 consumes governed Evidence and produces interpretations/candidates, not canonical truth.

Current mechanism requires:
- model/provider profile;
- secret reference;
- task/purpose;
- prompt/schema version;
- benchmark;
- enabled/unpaused state;
- token/call/latency/cost telemetry;
- confidence;
- exact Evidence references;
- retries/fallback;
- Layer 4 fall-out.

## To add a future AI provider/model

Required onboarding:
1. create provider/router definition;
2. store credential server-side/Vault only;
3. create model profile for one explicit task class;
4. define input Evidence types and exclusions;
5. define output JSON/schema;
6. define validation and confidence thresholds;
7. define cost/token/call limits;
8. define retry/fallback;
9. create benchmark cases + negative controls;
10. pass benchmark before enabling;
11. enable only for bounded Pilot scope;
12. collect telemetry;
13. Production-enable separately.

No “general AI” credential should implicitly be allowed to perform every Layer 3 task.

---

# 10. Layer 4 mechanism and future scraper controls

## Layer 4

Layer 4 is governed human intervention.

Accepted design:
- append-only override/decision history;
- field-level intervention;
- actor/time;
- original/source value retained;
- optional comment/decision note;
- publication remains a separate decision;
- no destructive overwrite of Evidence.

Maturity improvements:
- unified intervention drawer from Provider/Course/Scholarship/Evidence;
- clear “source value / current canonical / proposed override”;
- expiry/review date for temporary overrides;
- revert-to-source action;
- conflict indicator when fresh L1/L2 data differs from L4;
- bulk actions only with explicit role and preview;
- block/unblock controls;
- audit export.

## Adding/testing a new scraper

A scraper is a provider/adapter, not a hard-coded Layer 2 shortcut.

New scraper onboarding requires:
- adapter/provider definition;
- capabilities;
- secret reference;
- cost/quota model;
- health check;
- rate/concurrency limits;
- evidence types/MIME;
- screenshot/native-content behaviour;
- timeout/retry policy;
- sample URLs;
- deterministic identity tests;
- fallback order;
- quota-exhaustion behaviour;
- telemetry;
- negative/security tests.

Pilot qualification precedes Production enablement.

---

# 11. Manual Provider/Course create and edit

## Existing position

Field-level Layer 4 edits exist conceptually/runtime for governed interventions.

Governed **manual creation of a new Provider or Course is not yet a mature accepted routine workflow**.

## Target design

Manual create should create a provisional entity, never fabricate authoritative status.

Required fields:
- entity type;
- display/canonical name;
- country;
- Provider relationship for Course;
- entered identifiers;
- source/reference URL where known;
- reason;
- actor;
- ticket/change reference;
- created timestamp.

Lifecycle:
`manual_draft → pending_authority_reconciliation → verified OR rejected/merged`.

Rules:
- manually entered regulatory identifier remains unverified until L1 reconciliation;
- manual title/name cannot become identity by itself;
- duplicate candidates must be shown before create;
- Search/Publication defaults off;
- later authoritative match merges/reconciles rather than creating duplicate canonical rows.

Editing existing fields:
- use L4 intervention ledger;
- source values remain visible;
- field marked human-overridden;
- comment optional/required by field risk;
- revert/review supported.

---

# 12. Manual Provider/Course blocking

Blocking must be explicit and separate from deletion.

Required states:
- operational block — stop refresh/jobs;
- publication block — exclude from consumer channels;
- search block — exclude from Search projection;
- data-quality quarantine — retain but require review.

For a Provider block, operator must choose whether it cascades to:
- all Courses;
- new scheduled Layer 2 work;
- Publication/Search;
- existing evidence only remains readable.

Every block requires:
- reason code;
- comment;
- actor/time;
- optional expiry/review date;
- audit;
- unblock action.

Hard delete is not the normal block mechanism.

---

# 13. Storage assessment, reporting and notifications

Storage must be measured in separate categories:
- PostgreSQL database/disk;
- Evidence object storage;
- temporary DB spill;
- backups/PITR;
- CI/UAT artifacts;
- logs.

Admin Platform/Storage dashboard should show:
- current provisioned DB disk;
- logical DB size;
- WAL/system where available;
- Evidence object count/bytes;
- daily/weekly/monthly growth;
- largest Evidence types/sources/providers;
- backup/PITR status;
- temp-file activity;
- capacity forecast;
- last housekeeping;
- failed upload/orphan count.

Alert thresholds should be configurable, e.g.:
- 70% warning;
- 80% high;
- 90% critical;
- abnormal growth-rate alert;
- Evidence storage growth beyond daily budget;
- temp spill/deadlock anomaly;
- backup/restore failure.

Notifications should route to Admin dashboard first and later email/Slack/operations integration where configured.

---

# 14. Purging and maintenance

Do not use blanket deletion.

Classify records:

## Immutable/governed history — normally retain
- regulatory Evidence;
- accepted source versions;
- Layer 4 decisions;
- publication decisions;
- material audit events;
- accepted run lineage needed for audit.

## Retain with lifecycle/compaction
- superseded Evidence;
- historical provider attempts;
- AI interpretations;
- old source/profile versions;
- logs/telemetry.

## Safe transient cleanup
- expired terminal queue rows;
- ephemeral locks/reservations;
- stale caches;
- expired signed-access metadata;
- temporary staging after accepted reconciliation;
- CI artifacts according to retention policy;
- cron execution logs after operational retention period.

Maintenance design requires:
- retention policy by record/artifact class;
- dry-run report;
- estimated reclaim;
- immutable exclusion list;
- legal/audit hold;
- bounded batch deletion;
- post-delete integrity check;
- metric of records/bytes reclaimed.

---

# 15. Proposed implementation allocation

## M2.5 — Production/platform controls
Appropriate:
- Pilot/Production source separation;
- storage/capacity monitoring;
- maintenance/retention policy;
- Production country/source enablement gates;
- Production performance/load baseline;
- manual block/unblock security controls where required for safe operations;
- Production AI/scraper secret/onboarding framework deployment.

Not required to finish M2.5:
- broad provider-group enrichment;
- broad manual catalogue authoring UX;
- unit-level academic model.

## M3 — consumer/API maturity
- provider collection/G8 filter exposure;
- versioned cache invalidation;
- compact reference/bootstrap bundles;
- Scholarship relationship consumer contract;
- Website/Zoho cache semantics.

## M4 — publication/operational handover
- final block/publication policy;
- operations/storage reporting;
- retention jobs;
- audit exports;
- handover UAT.

## Future platform maturity
- governed manual Provider/Course creation;
- bulk-edit workflow;
- course-unit/subject model;
- richer AI provider marketplace/routing;
- additional country-specific institution collections.

---

# 16. Design decisions

1. Provider groupings are relational collections, not booleans.
2. Scholarship relationships are typed/evidence-backed; student eligibility is never inferred from structural scope.
3. New-country Production enablement is an explicit environment-specific gate.
4. Pilot UAT does not automatically equal Production UAT.
5. Manual creation produces provisional entities pending authority reconciliation.
6. Human edits use Layer 4 audit/override, not source overwrite.
7. Blocking is reversible lifecycle/governance state, not deletion.
8. Scrapers and AI providers use governed plug-in/profile onboarding.
9. Storage/capacity is an operational control surface with thresholds and notifications.
10. Purging is class-based, dry-run, audit-safe and excludes governed Evidence/history by default.
11. Consumer caching/version invalidation is part of performance architecture.
12. Existing hard performance budgets remain standing.
