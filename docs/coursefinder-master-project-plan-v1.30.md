# CourseFinder Master Project Plan v1.30

**Status:** AUTHORITATIVE PROGRAMME GOVERNANCE DOCUMENT  
**Supersedes:** `docs/coursefinder-master-project-plan-v1.29.md`  
**Last consolidated:** 19 August 2026  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.30.md`  
**Running build:** `docs/coursefinder-running-build-v2.32.md`

## Current programme position

| Workstream | Status | Decision |
|---|---|---|
| AU Layer 1 CRICOS identity/geography/field | PASS / ACCEPTED | Preserve accepted substrate |
| NZ Layer 1 NZQA | PASS / ACCEPTED | Preserve accepted substrate |
| CA Layer 1 | PAUSED / SKIPPED FOR CURRENT M1 EXECUTION | Preserve history; no further fragmented ETL work |
| AU QILT Layer 2A | PASS / ACCEPTED | Maintain governed outcomes |
| AU PRISMS Layer 2A | PASS / ACCEPTED | Maintain time-scoped observations |
| AU Scholarships | PASS / FIRST-SOURCE ACCEPTED | Controlled expansion only |
| **AU CRICOS omitted Course facts** | **NEXT REGULATORY DATA GATE** | Inventory and persist useful accepted CRICOS fields, beginning with registered tuition/cost facts |
| AU first-party Course facts | NEXT AFTER CRICOS FACTS | Official Course links, current fee schedules, intakes, English requirements |
| Admin/PIM | IN PROGRESS / HARDENING REQUIRED | Finish role-aware UX plus SECURITY DEFINER/RPC/grant hardening |
| Search governed projection + FTS | PASS / ACCEPTED | 33,105 AU+NZ projection |
| Website/Zoho API contracts | PASS / CONTRACT ACCEPTED | Curated DTOs only |
| Vector/semantic Search | PENDING / PARALLEL GATE | May proceed independently with bounded relevance/latency UAT |
| Publication/release readiness | PENDING | No artificial publication solely for UAT |

## Programme correction — CRICOS Course facts

Live Mumbai verification shows:
- AU Courses: 26,648;
- `catalogue.course_fees`: 0 rows;
- AU Course Links: 0;
- AU Intakes: 0;
- AU English requirements: 0.

The current CRICOS Layer 1 adapter already parses the accepted Course export but persists only selected fields. CRICOS itself exposes registered tuition/cost and additional Course registration facts.

Therefore the programme must not begin first-party scraping for fees before closing the structured regulatory-source omission.

New sequence:
1. `M1-L1-AU-CRICOS-FACTS`;
2. `M1-L2-AU-COURSE-FACTS`;
3. fee/link/intake/English Search readiness gate;
4. publication/consumer rollout later.

## Remaining M1 work

### A. M1-L1-AU-CRICOS-FACTS — required

- inventory current CRICOS Course export fields;
- classify every useful field as canonical/relational/source-only/excluded;
- persist registered Tuition Fee, Non Tuition Fee and Estimated Total Course Cost with exact semantics;
- assess and persist useful structured attributes such as Dual Qualification, Foundation Studies, Work Component and Course Language where the canonical model warrants them;
- retain source/evidence/snapshot validity;
- full dry-run/APPLY/replay/idempotency UAT;
- no title matching or invented annual fee conversion.

### B. M1-L2-AU-COURSE-FACTS — required

After the CRICOS gap closes:
- qualify bounded first-party Provider sources;
- map by accepted CRICOS Course code/stable identity;
- official Course URL;
- current provider fee schedules with year/basis/campus/intake semantics;
- intakes;
- English entry requirements;
- evidence, validity and replay;
- ambiguity to review, never title fallback.

### C. M1-PIM-HARDENING — required

Finish Admin/PIM operational readiness:
- Provider/Course/Campus detail and provenance visibility;
- fact readiness distinguishing regulatory fee versus current provider fee;
- Evidence Viewer and source history;
- role-aware write controls;
- review browser-executable `SECURITY DEFINER` RPCs;
- explicit grants and server-side rank checks;
- remove/deprecate obsolete compatibility/browser surfaces;
- storage/RLS/security advisor UAT;
- resolve Supabase leaked-password-protection warning if available within project settings.

### D. M1-SEARCH-VECTOR — parallel, independent

- approve embedding model/profile/dimensions;
- generate bounded AU+NZ embeddings using semantic-content hash;
- vector-only and filtered latency benchmarks;
- curated relevance set comparing FTS/vector/hybrid;
- cache/replay/invalidation UAT;
- approve or reject semantic publication independently.

### E. Search enrichment readiness — after Course Facts

Fee, Link, Intake and English gates remain blocked until accepted facts exist and their consumer semantics are approved.

Do not equate a CRICOS registered total-course tuition amount with a current annual fee. Search/API DTOs may need separate regulatory/current fee readiness fields.

### F. Publication and consumer positive-path UAT — required before M1 close

Current 33,105 Search Documents remain unpublished by design.

After canonical/enrichment/hardening gates are accepted:
- define bounded publication policy;
- publish an accepted test/production slice through governed workflow;
- Website/Zoho positive-path API UAT;
- prove no internal/evidence/review fields leak;
- rollback/replay publication UAT.

### G. Final M1 production hardening — required

- security advisors / exposed RPC review;
- RLS/storage/auth checks;
- job/evidence retention and reset/rollback policy;
- search/performance regression;
- source refresh/replay runbook;
- monitoring/operational handover;
- final User/Admin Guide refresh;
- Milestone 1 acceptance record.

## Explicitly not required for current M1

- further Canada ETL generation;
- GB/US/IE/DE country implementation unless a future source-qualification gate separately approves them;
- Layer 3 AI as a prerequisite for accepted structured AU data;
- publication of vectors before semantic UAT;
- scraping a fee already available from CRICOS simply because it was missed in Layer 1.

## Recommended execution lanes

Primary serial data lane:
`M1-L1-AU-CRICOS-FACTS -> M1-L2-AU-COURSE-FACTS -> SEARCH-ENRICHMENT-READINESS -> PUBLICATION-UAT`

Parallel lane 1:
`M1-PIM-HARDENING`

Parallel lane 2:
`M1-SEARCH-VECTOR`

Close-out lane:
`M1-PRODUCTION-HARDENING -> M1-ACCEPTANCE`

## Programme next

**Immediate primary:** `M1-L1-AU-CRICOS-FACTS`.

**Then:** `M1-L2-AU-COURSE-FACTS`.

**Parallel:** `M1-PIM-HARDENING` and `M1-SEARCH-VECTOR`.
