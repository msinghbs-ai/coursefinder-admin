# CourseFinder M2.1 — Country Course Completeness & Provider Trial Baseline

**Date:** 23 August 2026  
**Change Control:** `CF-CHG-20260823-029`  
**Status:** RUNNING / PARTIAL PASS — baseline and contracts proven; provider execution pending credentials/browser runtime

## Purpose

Prove Layer 2 against the actual CourseFinder use case: improve evidence-backed international-student Course completeness by country while measuring which acquisition provider is most accurate, reliable and economical.

This is not an admissions workflow. The trial stops at governed Course/related-data enrichment and downstream CourseFinder readiness/search/publication states.

## Trial contract implemented

Live objects:

- `pipeline.layer2_country_completeness_profiles`;
- `pipeline.layer2_completeness_trials`;
- `pipeline.layer2_completeness_trial_courses`;
- `pipeline.layer2_provider_trial_results`;
- `pipeline.layer2_course_factual_snapshot(uuid)`;
- `pipeline.layer2_course_decision_context_snapshot(uuid)`;
- `public.layer2_completeness_trial_create(text,uuid,integer)` — service-role only;
- `public.layer2_provider_trial_record(...)` — service-role only;
- `pipeline.layer2_provider_trial_summary(uuid)` — service-role only;
- `public.layer2_completeness_trial_finalize(uuid)` — service-role only;
- Edge `layer2-trial-control` v1 — JWT protected, rank >=4;
- Edge `layer2-scholarship-extract` v1 — JWT protected, rank >=4 and consumes only `layer2_extraction_input` Evidence.

New trial tables are RLS-enabled. `anon` and `authenticated` have no direct table SELECT. `service_role` has explicit trusted CRUD access. Browser execution cannot call the trial mutation RPCs directly.

## Country profiles

### AU international Course profile

Factual domains currently measured:

- identity;
- regulatory;
- official Course URL;
- Provider-current international tuition;
- intakes;
- English requirements;
- Campus/delivery;
- description;
- verification/freshness.

Decision-context domains:

- Scholarships;
- QILT Provider context;
- QILT study-area context;
- PRISMS Provider context where source grain supports it;
- PRISMS state/subdivision context.

### NZ international Course profile

A separate NZ profile exists and explicitly prohibits treating NZ regulatory semantics as CRICOS semantics.

## Sampling model

A default 10-Course learning batch is not a permanent limit.

For batches of 10 the current sampler selects:

- 2 known-coverage controls to prove that the worker does not regress already-enriched facts; and
- 8 gap-learning Courses to exercise missing domains.

This replaced an initial gap-only sampler. The two initial gap-only trial rows were retained for audit but marked `cancelled / superseded_by_control_plus_gap_sampling` rather than deleted.

## Active AU cohorts

### RMIT University

Trial: `26086e95-a387-44a7-9a50-d566e29076bb`

- 10 Courses;
- 2 control-known-coverage;
- 8 gap-learning Courses.

Control example:

- Advanced Diploma of Electronics and Communications Engineering — CRICOS `103390B`.

Gap examples include:

- Bachelor of Arts (Fine Art) (Honours) — `006591A`;
- Bachelor of Arts (Photography) — `006593K`;
- Bachelor of Fashion (Design) (Honours) — `0100706`;
- Bachelor of Textiles (Design) — `0100707`.

The controls currently have evidence-backed Course URL, Provider-current tuition, intakes and English requirements. The gap cohort currently lacks those domains plus description while retaining identity, Campus/delivery and verification.

### The University of Queensland

Trial: `3148ca84-f4f9-440f-9bb3-af2e54d383fa`

- 10 Courses;
- 2 control-known-coverage;
- 8 gap-learning Courses.

Control example:

- Bachelor of Arts — CRICOS `001942A`.

Gap examples include:

- Bachelor of Commerce — `001944K`;
- Bachelor of Economics — `001948F`;
- Bachelor of Information Technology — `001952K`;
- Bachelor of Urban Planning — `001960K`.

The same gap pattern is present: identity/Campus/verification exist; current Provider tuition, official URL, intake, English and description require Layer 2 enrichment.

## Context projection proof

`public.course_decision_context(course_id)` now returns decision context separately from direct Course facts.

For a representative active AU trial Course:

- QILT context returned 30 current Provider/provider-study-area observations;
- exact PRISMS Provider-linked context returned 0 rows in the present source mapping;
- PRISMS state/subdivision context was available and is bounded to the latest 30 rows in the projection.

This is the intended behaviour. CourseFinder does **not** manufacture Provider-linked PRISMS rows when the current source grain does not support that association.

Every projected QILT/PRISMS row carries explicit `grain` and `course_grain=false` semantics.

## Provider comparison metrics

The trial result contract records:

- acquisition success;
- gatekeeping bypass;
- JavaScript rendering;
- Evidence quality score;
- deterministic extraction success;
- verified correctness status;
- latency;
- request count;
- vendor cost;
- targeted/resolved fields;
- Layer 3 escalation;
- Layer 4 escalation;
- blocker/extra metrics.

Aggregate recommendation metrics include acquisition success rate, deterministic success rate, correctness rate, resolution rate, total vendor cost, cost per resolved field, latency, Evidence quality and Layer 3/4 escalation rates.

A provider is not accepted merely because it returns HTTP 200 or has the cheapest request price.

## Scholarship extraction

`layer2-scholarship-extract` v1 consumes only a previously normalised `layer2_extraction_input` Evidence artifact.

It deterministically attempts Scholarship title, award amount/percentage, closing-date text, study-level text and eligibility narrative. It writes a `pipeline.scholarship_source_records` candidate through the existing governed service contract and **does not apply canonical Scholarship mutation**.

Sparse Evidence returns/records `layer3_required=true`. It does not jump directly to Layer 4.

Layer 4 remains terminal and should receive only genuinely unresolved/conflicting cases after Layer 3 has consumed the available Layer 2 Evidence or requested better Layer 2 Evidence.

## Current blockers

1. Scrape.do, ScraperAPI, Firecrawl and ZenRows credentials remain intentionally unconfigured in Vault, so no real vendor success/cost claim is made.
2. No `layer2_extraction_input` Evidence exists yet in the live database; the next runtime step must perform bounded acquisition then invoke `layer2-extract` before Scholarship/domain extraction UAT.
3. The eight gap Courses per Provider require first-party Course URL discovery before Course-detail provider comparison can run. Known control Courses already have official Course links and can be used to validate transport/extraction paths first.
4. Deployed desktop/mobile SHA-bound UAT evidence remains outstanding.

## M1 regression

Post-migration live counts remain:

- Search documents: **33,105**;
- Search published: **0**;
- canonical Courses: **43,461**;
- canonical Courses unpublished: **43,461**.

No trial/context/Scholarship-extractor object authorises canonical or Search writes.

## Gate

**PARTIAL PASS / M2.1 remains BLOCKED.**

PASS so far: country profile/sampling model, first AU cohorts, RLS/ACL boundaries, provider-comparison metric contract, QILT contextual projection semantics, Scholarship Evidence-driven extraction worker contract, M1 regression.

Outstanding: Course URL discovery for gap cohorts, real provider/Evidence/extraction execution, vendor cost/result comparison, Scholarship bounded runtime Evidence, deployed browser UAT and final M2.1 acceptance.