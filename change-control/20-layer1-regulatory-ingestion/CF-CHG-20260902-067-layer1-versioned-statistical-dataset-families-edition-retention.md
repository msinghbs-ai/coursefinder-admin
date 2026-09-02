# CF-CHG-20260902-067 — Layer 1 Versioned Statistical Dataset Families & Edition Retention

**Status:** IMPLEMENTED / TARGETED PASS  
**Initiated:** 2 September 2026, 15:35 AEST  
**Origin:** User requirement to retain prior statistical years/periods for ongoing comparison  
**Owner:** CourseFinder programme  
**Primary category:** 20-layer1-regulatory-ingestion  
**Related categories:** 30-admin-pim-ux, 40-layer2-enrichment  
**UI version:** v2.15.33

## Problem

CF-066 made the existing QILT and PRISMS statistical sources runnable from Layer 1, but the operational cards were still edition-specific (for example QILT GOS 2025 or PRISMS 2025-12).

That model does not scale safely over time. A statistical dataset needs a stable family identity with:
- one current operational edition;
- retained historical editions;
- explicit year/period keys;
- comparison-safe historical observations and Evidence;
- controlled rollover when a newer accepted edition arrives.

## Design decision

Layer 1 Statistics now separates:

**Dataset family → Edition → Source/Evidence/Observations**

Examples:
- QILT Graduate Outcomes Survey → 2025 → current source/evidence;
- QILT Student Experience Survey → 2024 → current source/evidence;
- PRISMS International Student Flow → 2025-12 → current source/evidence.

When a future edition is accepted:
1. it is registered under the same dataset family;
2. if it is newer than the family Current edition, it becomes Current;
3. the previous Current edition becomes Retained;
4. prior Evidence and observations remain untouched and available for comparison;
5. Layer 1 operations move to the newer source;
6. the prior schedule is transferred to the new Current source and disabled on the retained source.

This prevents year-specific operational cards from multiplying indefinitely while still preserving historical data.

## New governed structures

Migration:
- `20260902003700_cf_067_layer1_statistical_dataset_families_editions.sql`
- `20260902004500_cf_067_statistical_edition_rollover_schedule_transfer.sql`

Tables:
- `pipeline.layer1_dataset_families`
- `pipeline.layer1_dataset_editions`

Initial AU families:
- `au_qilt_gos` — QILT Graduate Outcomes Survey — annual;
- `au_qilt_ses` — QILT Student Experience Survey — annual;
- `au_qilt_gosl` — QILT Graduate Outcomes Survey – Longitudinal — annual;
- `au_qilt_ess` — QILT Employer Satisfaction Survey — annual;
- `au_prisms_student_flow` — PRISMS International Student Flow — periodic.

All statistical families preserve `identity_authority=false`.

## Current baseline

Current editions at implementation:
- QILT GOS — 2025 — 593 observations;
- QILT SES — 2024 — 977 observations;
- QILT GOS-L — 2025 — 235 observations;
- QILT ESS — 2025 — 228 observations;
- PRISMS — 2025-12 — 2,270 observations.

Each currently has one retained edition because only one accepted edition has been loaded into Pilot to date. The model supports additional annual/periodic editions without schema change.

## Runtime rollover

`pipeline.sync_layer1_statistical_edition(source_id)`:
- registers/refreshes the edition;
- compares edition period/year with the current edition;
- marks newer editions Current;
- marks the prior Current edition Retained;
- keeps all source/Evidence/observation rows;
- copies the governed Layer 1 operations profile to the newer source when required;
- transfers the active Layer 1 refresh policy to the new Current source.

The existing ETLs now call this sync after successful APPLY:
- `qilt-au-etl` source v0.2.6 / Edge v9;
- `prisms-au-etl` source v0.1.2 / Edge v3.

The QILT parser remains survey/year configuration-aware rather than blindly accepting an unknown publisher workbook layout. New annual publisher editions still require the relevant parser/source configuration to be qualified before APPLY. Once accepted, edition rollover/retention is automatic.

## Layer 1 UX

Operations now presents **dataset families**, not an endless list of year-specific cards.

For a versioned statistical family the card shows:
- dataset family name;
- Statistics badge;
- Current edition badge;
- retained-edition count where greater than one;
- current observation count;
- health / Evidence / last run / next run;
- Run now against Current only.

Details adds **Edition history & comparison retention**:
- edition key/year/period;
- current vs retained status;
- observation count;
- last verification;
- source label/period context;
- explicit notice that older editions are retained rather than overwritten.

Historical editions are not shown as separate operational cards and are not accidentally runnable as Current.

Administration → Layer 1 sources likewise configures Current editions only; historical editions remain retained audit/comparison inputs.

## Comparison boundary

This change provides the retained edition substrate for year/period comparison. It does not manufacture a comparison metric or coerce mismatched QILT/PRISMS grains.

Comparison consumers must continue to:
- align by dataset family;
- compare like-for-like metric/cohort/grain;
- require explicit or latest-common edition/period selection;
- preserve suppression and source-specific semantics.

## UAT

Permanent Layer 1 deployed UAT is updated to verify:
- five AU statistical dataset-family cards rather than five edition-specific titles;
- Current edition badges;
- Edition history & comparison retention disclosure;
- real QILT and PRISMS validation remains intact;
- CRICOS/NZQA and anonymous boundaries remain intact.

Final implementation UI is **v2.15.34**.

Final targeted candidate:
- `msinghbs-ai/Coursefinder-Pilot@e7f5a1c8eec7301c5e3c9266e7a225a0a81f2e9c`;
- frontend build `33596621514`: **PASS**;
- deployed targeted UAT `33596621522`: **PASS**;
- permanent Layer 1 suite: **6/6 PASS** on Chromium desktop;
- AU Statistics dataset-family/edition-history test: PASS, including live QILT GOS and PRISMS validation;
- real CRICOS and NZQA authority validation: PASS;
- Platform Admin source-configuration role boundary: PASS;
- anonymous browser boundary: PASS.

Corrective validation history is retained:
1. the first CF-067 deployed run exposed that replacing `security.admin_layer1_operations_read` had dropped the required authenticated EXECUTE grant used by the role-gated public admin reader; migration `20260902005100_cf_067_restore_authenticated_layer1_read_acl.sql` restored authenticated execution while keeping anon/public revoked;
2. subsequent failures were test-selector integration only (ambiguous family name and Administration heading), corrected without weakening access or data semantics.

CF-067 is therefore **IMPLEMENTED / TARGETED PASS**.

## Rollback

Revert CF-067 UI/runtime/migrations. If rollback is required, retain all pre-existing QILT/PRISMS sources, Evidence and observations. Do not delete historical statistical data.

## Production boundary

Pilot only. This does not enable Production, broaden Search/Publication authority, or change Provider/Course identity semantics.
