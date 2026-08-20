# CourseFinder PIM Admin Guide v1.8

**UI:** PIM Admin v2.10.0 candidate  
**Effective:** 20 August 2026  
**Status:** **TECHNICAL/PRODUCTION BUILD PASS — DEPLOYED AUTHENTICATED BROWSER ACCEPTANCE BLOCKED / NOT YET PROVEN**

## 1. Purpose

PIM Admin is an operational decision tool over governed CourseFinder data. It is not a generic database browser and must not encourage staff to treat raw row presence as source truth, Search admission or publication approval.

The browser reads through `public.admin_read`. Internal schemas remain backend/governance surfaces rather than direct browser CRUD contracts.

## 2. Navigation and role visibility

| Area | Minimum role | Purpose |
|---|---|---|
| Overview | assigned CourseFinder role | operational counts and boundary context |
| Catalogue / Providers | assigned role | canonical Provider discovery and detail |
| Catalogue / Courses | assigned role | canonical Course discovery, readiness and Search state |
| Catalogue / Campuses | assigned role | canonical Campus discovery and geography |
| PIM Configuration / Attributes | PIM Admin, rank 5 | governed Families, Groups, Attributes, Options and Completeness configuration |
| Enrichment & Insights / QILT | assigned role | Provider outcomes enrichment |
| Enrichment & Insights / PRISMS | assigned role | student-flow enrichment |
| Data Quality / Completeness | assigned role | six-signal Admin presence/readiness view |
| Data Quality / Review Queue | Curator, rank 3 | governed review workload |
| Evidence | Curator, rank 3 | provenance, extraction/freshness and source evidence |
| Pipelines & Jobs | Pipeline Operator, rank 4 | ingestion/job/source operational visibility |
| Scholarships | assigned role | relational Scholarship workspace |
| Search & Publication | assigned role | derived Search projection and publishing channel state |

A hidden menu item is a convenience, not a security boundary. The server read must independently enforce the same or stricter role requirement.

No empty Integrations or Platform Settings sections are shown merely to satisfy a taxonomy. Add them only when a governed operational workspace exists.

## 3. List behaviour

Operational lists are server-paged. Normal catalogue and operational pages request 50 rows at a time.

The current broader Pilot contains 35,487 active Courses / 43,461 total Course rows; operator behaviour must therefore remain practical above the older 26,648-Course AU-only baseline.

### Search

Search terms are sent to the server after a short debounce. Exact stable identifiers are supported where the domain supplies them, including CRICOS Course code, Provider CRICOS/stable identity, Evidence UUID and Pipeline Job UUID.

Do not implement a browser workaround that downloads thousands of rows and filters them locally.

### Filters, sort and paging

List state is stored in the URL. Moving into a detail view and using browser Back should restore the originating list query, filters, sort and page. Scroll restoration is also retained where the browser supports the stored history state.

Normal derived Course filters — Fee, Intake, English, Scholarship, State/Region, Link presence and minimum Admin readiness — are evaluated server-side before bounded page enrichment. Migration 075 changed the execution plan only; it did not change the meaning of any signal.

The normal Course grid deliberately does **not** expose catalogue-wide fee/readiness ordering while those derived sort paths still use the more expensive accepted implementation. This is a performance safeguard, not a semantic change.

### Refresh and stale requests

Each governed read uses a cancellable request. A superseded search/filter/navigation request should be aborted so an older response cannot overwrite newer state.

Loading must show skeleton/progress feedback. Errors must show a retry action. Empty data must show a governed empty state rather than a blank screen.

## 4. Catalogue semantics

### Provider

Provider detail is structured into:

- identity and lifecycle;
- regulatory identity/registrations;
- geography and Campuses;
- related Courses;
- Evidence/source history;
- record timestamps.

Related lists are bounded in the detail payload. A count may exceed the number of preview rows shown.

### Course

Course detail retains the accepted semantic panels for:

- canonical identity and lifecycle;
- CRICOS/regulatory facts;
- fees;
- intakes;
- English entry requirements;
- geography/delivery;
- taxonomy;
- Scholarships;
- Admin readiness;
- Search projection/publication state;
- evidence/state context.

#### Fee rule

Never collapse these into one generic tuition amount:

- **CRICOS registered total-course tuition** — regulatory registration fact with its own basis/year/source;
- **Provider-current fee** — current Provider-published fee schedule/observation with its own year/basis/campus/intake/source.

UI labels must preserve the basis. A Provider-current annual fee is not a replacement for a CRICOS registered total-course value, and vice versa.

Reference `121174E` remains a required browser regression: its CRICOS registered section contains three rows including Non-Tuition Fee AUD 0, while Provider-current remains empty unless a separately accepted Provider observation exists.

### Campus

Campus detail is organised around identity, Provider relationship, geography/delivery, related Courses, source/evidence and record history. It must not manufacture a Campus merely to fill a relationship gap.

## 5. Readiness, Search and publication

These states are independent:

1. **Canonical lifecycle/publication fields** — state on the canonical entity.
2. **Admin readiness/completeness** — current presence/readiness diagnostic.
3. **Search projection** — whether a derived Search document exists and its projection status/version.
4. **Publishing channel state** — channel-specific publication state.

The current Course Admin readiness is a six-signal display rule:

- registration;
- structure;
- fee;
- intake;
- English;
- description.

It is not source-truth confidence, approval, Search admission or consumer publication. PIM Completeness Profiles remain a separate governed configuration mechanism.

## 6. PIM Configuration

PIM Admin v2.10 explicitly presents:

- Attribute Families;
- Attribute Groups;
- Attribute Definitions;
- Attribute Options;
- Completeness Profiles;
- Completeness Requirements;
- Family/Attribute relationships where returned by the governed contract.

An empty Options/Profile/Requirements section means no governed rows are loaded. The UI must not invent vocabulary or scoring policy.

Attribute code/value identity remains distinct from display labels and display order.

## 7. Evidence

Evidence is provenance, not a generic document list. The operational grid can show:

- layer;
- evidence type;
- source and country;
- operational status;
- freshness state;
- extraction state;
- linked observation count;
- content hash;
- captured timestamp;
- authority URL.

Evidence filtering is bounded/server-side. Do not restore the old pattern of loading a four-digit Evidence set merely to filter it in React.

Freshness labels must be evidence-policy driven. `no_policy` is a valid state and must not be rewritten as stale.

Source-null or missing-extraction conditions are diagnostics; they do not authorise synthetic values.

## 8. Pipelines and Jobs

Pipeline workspaces are Pipeline Operator+.

Pipeline Control summarises layer journey and observed volumes. Jobs and Sources are server-paged operational views. Do not expose hidden source adapter/system configuration to rank-4 users.

A failed job is not permission to modify canonical entities from the browser. Any future retry/replay action requires an explicit governed server action, role check, idempotency contract and visible disabled/busy state.

## 9. Dates, currency and country labels

The Admin displays dates/times using Australian English formatting in the `Australia/Sydney` timezone for operator consistency.

Currency uses the row/source currency code and Australian number formatting. Do not silently assume AUD for non-Australian records when a currency is available.

Country is shown using governed ISO code/name context where available.

## 10. Browser acceptance checklist

Before closing the v2.10 finalisation gate, test the deployed authenticated app on normal desktop and laptop widths:

- browser network reads use `public.admin_read`, not direct legacy `ui_*` browser RPCs;
- visible UI version/navigation matches the intended deployed release;
- every visible menu item loads useful real data or an explicit empty state;
- no unexplained blank page;
- initial Course page is practical at current 35k+ active / 43k+ total scale;
- search/filter/page changes show progress without stale-response overwrite;
- exact Course/Provider identifiers resolve;
- detail navigation and browser Back/Forward preserve list context;
- resizable columns and sticky context remain usable;
- Provider/Course/Campus details are structured and decision-useful;
- fee labels retain CRICOS vs Provider-current distinction;
- lower-ranked roles do not see privileged menu items;
- direct privileged URLs/RPC calls fail gracefully and server-side;
- Evidence, Pipeline and PIM Configuration behave correctly for their target roles.

Record any deployed defect against `CF-CHG-20260820-015` and keep the applicable predecessor Change Control open until retest passes.

## 11. Current deployed-runtime blocker

Immediately before the governed recovery trigger, real Chrome API telemetry still showed direct legacy `ui_*` browser calls. The newest available such request was `ui_context` at 20 August 2026 07:00:57 UTC, HTTP 403.

A no-content `coursefinder-admin/main` commit at 07:04:28 UTC (`494a6ddcc18671abd492370410a94212c9c21deb`) was issued solely to trigger the established external Cloudflare Git rebuild of the unchanged accepted v2.9 tree.

No post-trigger browser telemetry is currently available. Do not treat that absence as failure or acceptance. The browser gate remains open until the deployed bundle can be observed.

## 12. Known separate item

Supabase Auth leaked-password protection is still reported as a project-level advisor warning. It was not changed or claimed as resolved by PIM finalisation.
