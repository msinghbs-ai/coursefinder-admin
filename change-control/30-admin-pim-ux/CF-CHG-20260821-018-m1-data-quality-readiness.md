# CF-CHG-20260821-018 — M1 Data Quality Readiness operational gate

**Status:** **BLOCKED — TECHNICAL IMPLEMENTATION PASS; DEPLOYED AUTHENTICATED BROWSER EVIDENCE UNAVAILABLE**  
**Category:** `30-admin-pim-ux`  
**Initiated:** 21 August 2026 14:47 AEST (UTC+10)  
**Last updated:** 21 August 2026 15:32 AEST  
**Origin chat/workstream:** `M1-DATA-QUALITY-READINESS — Completeness, Freshness, Exceptions & Decision-Queue Gate`  
**Owner:** CourseFinder Admin/PIM governance  
**Change class:** Admin operational UX / governed read contract / data-quality semantics / performance / UAT

## Trigger

Completeness has become an operational product feature rather than a passive field-presence display. The existing Completeness workspace used the legacy six-signal Course percentage and separate page reads, while current governance explicitly states that completeness is a coverage signal rather than truth, approval, Search admission or publication authority.

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

Every domain contract preserves the state vocabulary `present / source_null / not_applicable / zero / suppressed / not_yet_enriched / stale / ambiguous / rejected`, including zero-count states. Operators can drill from aggregate domain metrics to affected records and onward to canonical entity, Source/Evidence and Review context where the underlying data supplies those relationships.

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
- `40-layer2-enrichment` read-only enrichment coverage visibility.

Related accepted controls retained, not reopened:

- `CF-CHG-20260820-012` — lifecycle / publication / readiness / Search separation;
- `CF-CHG-20260820-014` — Completeness Profiles are policy context, not truth;
- `CF-CHG-20260820-015` — PIM operational browser/performance baseline;
- `CF-CHG-20260821-016` — Pipeline Operations read boundary;
- `CF-CHG-20260821-017` — Evidence workspace/private-boundary baseline.

## Semantic impact

No canonical Provider, Course, Campus or Scholarship identity change is authorised or performed.

No source authority, ingestion precedence, canonical factual value, Search admission decision or publication decision is changed by this workstream.

Accepted operational readiness semantics are:

1. do not expose a single equal-weight cross-domain percentage as the authoritative Data Quality product view;
2. retain the old six-signal score only where required for backward-compatible catalogue display/history, explicitly as a legacy/admin-presence signal;
3. define readiness by domain with separate denominators and exception-state counts;
4. treat `zero` as a present numeric value rather than missing;
5. treat `not_applicable` as excluded from the applicable denominator rather than a completeness failure;
6. expose `source_null`, `suppressed`, `not_yet_enriched`, `stale`, `ambiguous` and `rejected` only when governed source/evidence/observation state supports the classification;
7. keep canonical publication, Search projection/admission and downstream channel publication independent.

The durable semantic contract is recorded in `docs/coursefinder-data-quality-readiness-contract-v1.0.md`.

## Before

- Completeness page was a Course-only catalogue mode.
- It called `courses_page` more than once to build a percentage summary.
- It used the display-only six-signal score: registration, structure, any fee, intake, English and description.
- Fee presence did not distinguish regulatory registered fee from Provider-current fee.
- An absent Provider-current fee / URL / Intake / English fact was visually similar to generic incompleteness even where Layer 2 enrichment had not yet been attempted.
- Aggregate drill-down was not domain-specific across Provider, Course, Campus and Scholarship.

## After

Implemented contract:

- one bounded overview RPC for all readiness-domain aggregates;
- one bounded/paged exceptions RPC for a selected domain/state/entity scope;
- no page-level N+1 entity/detail RPC pattern;
- explicit state counts for all nine governed readiness states;
- domain-level readiness rate rather than one fabricated cross-domain percentage;
- direct entity and Evidence/Review navigation from exception results where supported;
- AU+NZ full-scale query benchmark and ACL regression;
- dedicated Data Quality v1.0 runtime workspace routed from the accepted `Completeness` navigation item.

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
- latest deployed migration at initial reconciliation: `20260821025059 — m1_pipeline_ops_safe_source_projection_v1`.

Initial live inventory:

- all canonical: 3,085 Providers / 43,461 Courses / 3,922 Campuses / 4 Scholarships;
- AU+NZ: 1,955 Providers / 33,105 Courses / 3,922 Campuses / 4 Scholarships;
- Search Course documents: 33,105;
- Course links: 10;
- Course intakes: 18;
- Course English requirement rows: 32;
- AU+NZ Provider-current fee rows: 10;
- `workflow.review_queue`: 0 rows at initiation.

Accepted CRICOS residual evidence is reused rather than reclassified:

- 34 AU Course→Campus gaps are authoritative source absences;
- 191 AU Tuition and Non-Tuition gaps are authoritative source absences;
- no synthetic Campus or fee is created.

## Implementation references

### Supabase migrations

- `20260821050044 — m1_data_quality_readiness_v1`;
- `20260821050313 — m1_data_quality_readiness_course_base_fast_v1`;
- `20260821050457 — m1_data_quality_readiness_overview_fast_v2`;
- `20260821050825 — m1_data_quality_readiness_exceptions_fast_v2`;
- `20260821050846 — m1_data_quality_readiness_runtime_memory_v1`.

The live Supabase migration ledger is the current authoritative migration record. The Pilot repository also does not mirror several immediately preceding accepted PIM/Evidence/Pipeline live migrations, so this control does not introduce a one-off migration-storage convention solely for Data Quality.

### RPC / API

- `public.admin_read(text,jsonb)` — existing browser boundary, extended with `data_quality_overview` and `data_quality_exceptions`;
- `security.admin_data_quality_read(text,jsonb)` — role-checked Data Quality dispatcher;
- private `security.data_quality_*` base/implementation helpers.

### Pilot frontend

- feature branch: `m1-data-quality-readiness-20260821`;
- `src/data-quality-entry.jsx`;
- `src/data-quality.css`;
- `index.html` Data Quality runtime root/marker;
- PR: `msinghbs-ai/Coursefinder-Pilot#18`;
- production build run: `32450608567` / run #103 — PASS;
- promoted Pilot `main`: `d2e59771e52b6664c1da7427e4d8125d54963e0b`.

Visible candidate marker:

`PIM Admin v2.12 · Pipeline Ops v1.0 · Evidence v1.0 · Data Quality v1.0 · governed`

## UAT

Detailed evidence: `docs/uat/coursefinder-m1-data-quality-readiness-technical-acceptance-2026-08-21.md`.

### Semantic UAT

PASS:

- identity and regulatory authority remain country/source specific;
- all nine states exposed;
- numeric zero treated as ready;
- `not_applicable` excluded from denominator;
- AU CRICOS source gaps remain `source_null` only where previously proven;
- NZ CRICOS-specific tuition is `not_applicable`;
- Provider-current fee / URL / Intake / English absence remains `not_yet_enriched` before accepted enrichment;
- Search admission does not imply publication.

Representative live AU+NZ Course states:

- geography: 26,614 present / 34 AU source-null / 6,457 NZ not-yet-enriched;
- regulatory tuition: 26,326 present / 131 zero / 191 AU source-null / 6,457 NZ not-applicable;
- Provider-current fee: 10 present / 33,095 not-yet-enriched;
- Course URL: 10 present / 33,095 not-yet-enriched;
- Intake: 10 Courses present / 33,095 not-yet-enriched;
- English: 10 Courses present / 33,095 not-yet-enriched;
- Scholarship applicability: 500 present / 32,605 not-yet-enriched;
- Search admission: 33,105 / 33,105 present.

### ACL UAT

PASS:

- `public.admin_read`: authenticated yes / anon no;
- `security.admin_data_quality_read`: authenticated yes / anon no;
- private Data Quality base/implementation helpers: authenticated no / anon no;
- authenticated Platform Admin read returned governed overview successfully.

### Dispatcher regression

PASS for sampled existing routes:

- Dashboard;
- AU Courses page (26,648);
- Evidence page;
- Pipeline overview;
- Publication overview.

### Performance

Initial ~9 s/spilling aggregate was rejected during implementation.

Final observed samples:

- full AU+NZ overview warm: ~836.6 ms, zero temp spill;
- AU regulatory-fee source-null exception page, 50 rows: ~155.8 ms, zero temp spill;
- earlier final cold overview after spill removal: ~4.0 s.

No page-level N+1 detail pattern is used.

### Frontend / build

PASS:

- legacy Completeness navigation is intercepted before old duplicate Course reads execute;
- Data Quality overview uses one aggregate RPC;
- exception drill-down uses one paged RPC;
- Evidence route defect found during UAT was corrected from `?id=` to `?evidence_id=` before promotion;
- Node 22 / dependency install / Vite production build passed in GitHub Actions run 32450608567;
- PR #18 merged to the actual Worker source repository.

### Advisor regression

PASS for change-specific findings. Security/performance advisors show existing programme-wide observations only; no Data Quality table/index finding was introduced.

### Deployed authenticated browser

**BLOCKED.**

Correct runtime from accepted prior recovery UAT:

`coursefinder-pilot.techm.workers.dev`

The current execution environment has no Cloudflare control-plane connector, no usable Wrangler network/authentication path and no authenticated Pilot browser session. GitHub exposes no Cloudflare deployment status on the merged commit through the available status API. Public-web tooling cannot directly open this unindexed Worker URL from connector-only context.

CourseFinder governance therefore does not treat merged Pilot source as deployed-browser proof.

Remaining browser evidence:

1. Data Quality v1.0 marker/current bundle served after hard refresh;
2. authenticated Completeness navigation opens domain readiness;
3. AU+NZ overview loads;
4. AU regulatory-tuition source-null drill-down exposes 191 records with paging;
5. canonical Course and Evidence navigation work;
6. browser telemetry uses `public.admin_read` and no private helper;
7. Dashboard/Catalogue/Evidence/Pipeline remain functional.

## Rollback / reversion

The change is additive/read-only.

Rollback path:

1. revert Pilot merge `d2e59771e52b6664c1da7427e4d8125d54963e0b` or remove the Data Quality runtime root/entry/style changes;
2. remove `data_quality_overview` / `data_quality_exceptions` branches from `public.admin_read` if database rollback is required;
3. retire the new private Data Quality helpers.

Do not delete or rewrite canonical, Evidence, Search, publishing or Review data to revert this workspace.

## Documentation impact

- Data Quality semantic contract: `docs/coursefinder-data-quality-readiness-contract-v1.0.md` — added;
- UAT: `docs/uat/coursefinder-m1-data-quality-readiness-technical-acceptance-2026-08-21.md` — added;
- Change Control Register — updated with blocked gate/promotion state;
- PIM Admin Guide / architecture / running build / master plan — no accepted-baseline bump until the deployed authenticated browser gate is closed;
- Zoho contract — unchanged.

## Decision / status history

| Timestamp | Status | Decision / event | Reference |
|---|---|---|---|
| 21 Aug 2026 14:47 AEST | PROPOSED / IMPLEMENTING | New governed Data Quality Readiness gate initiated after repository, Pilot head and live Supabase reconciliation. Composite percentage identified as semantically misleading for the requested cross-domain product view. | `M1-DATA-QUALITY-READINESS` |
| 21 Aug 2026 15:00–15:18 AEST | IMPLEMENTING / UAT | Live read contract applied and iteratively optimised; initial spilling ~9 s aggregate rejected. Final contract preserves the nine-state semantics and existing `admin_read` boundary. | Supabase migrations `20260821050044`–`20260821050846` |
| 21 Aug 2026 15:23 AEST | TECHNICAL PASS | Authenticated role/ACL regression, existing dispatcher regression and final performance samples passed. | Technical UAT |
| 21 Aug 2026 15:27 AEST | BUILD PASS | Pilot PR #18 production build run 32450608567 completed successfully. | `Coursefinder-Pilot#18` |
| 21 Aug 2026 15:29 AEST | SOURCE PROMOTED | PR #18 merged into the actual `coursefinder-pilot` Worker source repository at `d2e59771e52b6664c1da7427e4d8125d54963e0b`. | Pilot `main` |
| 21 Aug 2026 15:32 AEST | BLOCKED | Deployed authenticated browser/Cloudflare runtime proof cannot be produced from the available execution environment; source promotion is not treated as deployment proof. | Technical UAT §12 |

## Closure

**Final status:** **BLOCKED — TECHNICAL IMPLEMENTATION PASS / PILOT SOURCE PROMOTED / DEPLOYED AUTHENTICATED BROWSER UNPROVEN**  
**Closed at:** N/A  
**Outcome:** All Data Quality semantic, DB/RPC, ACL, performance, build and source-promotion gates pass. The only remaining blocker is fresh deployed authenticated browser evidence against `coursefinder-pilot.techm.workers.dev`.
