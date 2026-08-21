# CF-CHG-20260821-018 — M1 Data Quality Readiness operational gate

**Status:** PROPOSED / IMPLEMENTING  
**Category:** `30-admin-pim-ux`  
**Initiated:** 21 August 2026 14:47 AEST (UTC+10)  
**Origin chat/workstream:** `M1-DATA-QUALITY-READINESS — Completeness, Freshness, Exceptions & Decision-Queue Gate`  
**Owner:** CourseFinder Admin/PIM governance  
**Change class:** Admin operational UX / governed read contract / data-quality semantics / performance / UAT

## Trigger

Completeness has become an operational product feature rather than a passive field-presence display. The existing Completeness workspace still uses the legacy six-signal Course percentage and separate page reads, while current governance explicitly states that completeness is a coverage signal rather than truth, approval, Search admission or publication authority.

## Problem / requested outcome

Implement a governed Data Quality / Readiness workspace spanning Provider, Course, Campus, Scholarship and enrichment domains. It must expose domain readiness and exceptions without manufacturing values or pretending all absent facts have equal importance.

Required readiness domains:

- identity completeness;
- regulatory completeness;
- geography / delivery;
- taxonomy;
- regulatory fee;
- current Provider fee;
- Course URL;
- Intake;
- English requirement;
- Scholarship;
- evidence;
- verification / freshness;
- Search admission;
- publication readiness.

Every domain contract must preserve the state vocabulary `present / source_null / not_applicable / zero / suppressed / not_yet_enriched / stale / ambiguous / rejected`, including zero-count states. Operators must be able to drill from aggregate domain metrics to the affected records and onward to canonical entity, Source/Evidence and Review context where the underlying data supplies those relationships.

## Affected surfaces / related workstreams

Primary surface:

- Admin/PIM Data Quality → Completeness / readiness workspace.

Secondary surfaces:

- `public.admin_read(text,jsonb)` browser dispatcher;
- private `security.*` data-quality read helpers;
- Provider / Course / Campus / Scholarship canonical read models;
- Layer 1 regulatory observations and fees;
- Layer 2 Course Facts enrichment presence;
- Evidence lineage and workflow Review Queue;
- Search admission / projection state;
- publishing channel state;
- `80-uat-release-operations` performance, ACL and browser acceptance;
- `50-search-api-consumers` read-only Search admission visibility;
- `40-layer2-enrichment` read-only enrichment coverage visibility;
- `10-architecture-data-model` browser read-contract documentation only if the accepted dispatcher contract changes materially.

Related accepted controls retained, not reopened:

- `CF-CHG-20260820-012` — lifecycle / publication / readiness / Search separation;
- `CF-CHG-20260820-014` — Completeness Profiles are policy context, not truth;
- `CF-CHG-20260820-015` — PIM operational browser/performance baseline;
- `CF-CHG-20260821-016` — Pipeline Operations read boundary;
- `CF-CHG-20260821-017` — Evidence workspace/private-boundary baseline.

## Semantic impact

No canonical Provider, Course, Campus or Scholarship identity change is authorised.

No source authority, ingestion precedence, canonical factual value, Search admission decision or publication decision is changed by this workstream.

The operational readiness semantic changes are:

1. retire the single equal-weight Course percentage as the primary Data Quality product view;
2. retain the old six-signal score only where required for backward-compatible catalogue display/history, explicitly labelled as a legacy/admin-presence signal;
3. define readiness by domain with separate denominators and exception-state counts;
4. treat `zero` as a present numeric value rather than missing;
5. treat `not_applicable` as excluded from the applicable denominator rather than a completeness failure;
6. expose `source_null`, `suppressed`, `not_yet_enriched`, `stale`, `ambiguous` and `rejected` only when the governed source/evidence/observation state supports that classification; do not infer those states from a plain null where semantics are unknown;
7. keep canonical publication, Search projection/admission and downstream channel publication independent.

## Before

- Completeness page is a Course-only catalogue mode.
- It calls `courses_page` more than once to build a percentage summary.
- It uses the display-only six-signal score: registration, structure, any fee, intake, English and description.
- Fee presence does not distinguish regulatory registered fee from Provider-current fee.
- An absent Provider-current fee / URL / Intake / English fact is visually similar to generic incompleteness even where Layer 2 enrichment has not yet been attempted.
- Aggregate drill-down is not domain-specific across Provider, Course, Campus and Scholarship.

## After

Target contract:

- one bounded overview RPC for all readiness-domain aggregates;
- one bounded/paged exceptions RPC for a selected domain/state/entity scope;
- no page-level N+1 entity/detail RPC pattern;
- explicit state counts for the nine governed readiness states;
- domain-level readiness rate rather than one fabricated cross-domain percentage;
- direct entity and Evidence/Review navigation from exception results where supported;
- AU+NZ full-scale query benchmark and ACL regression before acceptance.

## Source authority / evidence

Governance authority:

- `PROJECT_INSTRUCTIONS.md`;
- `change-control/README.md` and `REGISTER.md`;
- Master Project Plan v1.58;
- Running Build v2.61;
- Database Architecture v2.10.38;
- Admin/PIM Design Decisions v1.11;
- PIM Admin Guide v1.12;
- accepted controls 012, 014, 015, 016 and 017.

Implementation authority at initiation:

- `msinghbs-ai/Coursefinder-Pilot@fda4270f3c440b8253b87da1a8c35a4b2769413e`;
- live `coursefinder_Pilot` Supabase project `fxcwkweaxjtknorudmwp`;
- latest deployed migration at reconciliation: `20260821025059 — m1_pipeline_ops_safe_source_projection_v1`.

Initial live inventory at reconciliation:

- all canonical: 3,085 Providers / 43,461 Courses / 3,922 Campuses / 4 Scholarships;
- AU+NZ: 1,955 Providers / 33,105 Courses / 3,922 Campuses / 4 Scholarships;
- Search Course documents: 33,105;
- Course links: 10;
- Course intakes: 18;
- Course English requirement rows: 32;
- AU+NZ Provider-current fee rows: 10;
- `workflow.review_queue`: 0 rows at initiation.

These counts are evidence that an equal-weight composite can conflate regulatory completeness, enrichment coverage and publication/Search state.

## Implementation references

- Supabase migration(s): pending
- Git repository/commit(s): pending
- Issue/PR: pending
- RPC/API objects: planned `security.admin_data_quality_read(...)` behind existing `public.admin_read(text,jsonb)`
- UI version: planned PIM Admin v2.13 / Data Quality v1.0, subject to UAT

## UAT

Required before closure:

- full AU+NZ aggregate benchmark;
- bounded domain/state exception-page benchmark;
- identity/regulatory/geography/taxonomy/fee/enrichment/evidence/freshness/Search/publication semantic spot checks;
- explicit proof that numeric zero is not counted as missing;
- explicit proof that unenriched domains remain `not_yet_enriched` rather than fabricated `source_null`;
- role-rank / `anon` / direct internal-schema ACL regression;
- `public.admin_read` dispatcher regression for existing Catalogue, Evidence and Pipeline routes;
- frontend production build;
- deployed authenticated browser acceptance if promoted to the Pilot runtime.

## Rollback / reversion

The work must remain additive/read-only. Rollback is to remove the new Data Quality dispatcher routes/helpers and revert the Data Quality frontend component/marker. Do not delete or rewrite canonical, Evidence, Search or publishing data merely to revert this workspace.

## Documentation impact

- PIM Admin Guide: required if accepted;
- Architecture: update only for an accepted material read-contract change; no canonical architecture bump for presentation alone;
- Running build: update only after gate result/promotion;
- Master plan: update only after gate result/promotion;
- UAT/design docs: required;
- Zoho contract: no semantic payload change planned.

## Decision / status history

| Timestamp | Status | Decision / event | Reference |
|---|---|---|---|
| 21 Aug 2026 14:47 AEST | PROPOSED / IMPLEMENTING | New governed Data Quality Readiness gate initiated after repository, Pilot head and live Supabase reconciliation. Composite percentage identified as semantically misleading for the requested cross-domain product view. | `M1-DATA-QUALITY-READINESS` |

## Closure

**Final status:** OPEN — IMPLEMENTATION / UAT IN PROGRESS  
**Closed at:** N/A  
**Outcome:** Pending autonomous implementation and technical acceptance gate.
