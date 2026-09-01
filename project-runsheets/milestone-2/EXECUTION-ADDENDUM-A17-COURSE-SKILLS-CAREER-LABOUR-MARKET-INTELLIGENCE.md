# Execution Addendum A17 — Course Skills, Career Pathways & Labour-Market Intelligence

**Status:** ACCEPTED DESIGN / M2.5 IMPLEMENTATION BACKLOG  
**Issued:** 1 September 2026  
**Primary Change Control:** `CF-CHG-20260901-062`  
**Applies to:** M2.5 and later Course/Provider/Search/Website/Zoho work that exposes skills, occupations, labour-market or migration/registration signals.

## Purpose

Introduce a governed Course → skills → occupations → labour-market intelligence model for international-student decision support without manufacturing employment, registration or migration outcomes.

## Standing authority boundary

The platform must keep separate:
1. **skills evidenced as developed by a Course**;
2. **skills/tasks associated with an occupation**;
3. **Course-to-occupation career-pathway relationships**;
4. **current labour-market observations**;
5. **professional registration/licensing requirements**;
6. **migration-policy signals**.

No one of these may be treated as proof of another.

## AU source baseline

Primary authoritative sources:
- ABS OSCA 2024 current occupation classification: https://www.abs.gov.au/statistics/classifications/osca-occupation-standard-classification-australia/latest-release
- ABS OSCA 2027 forward-change notice: https://www.abs.gov.au/about/key-priorities/about-osca/osca-2027
- Jobs and Skills Australia occupation/industry profiles: https://www.jobsandskills.gov.au/data/occupation-and-industry-profiles
- JSA Internet Vacancy Index: https://www.jobsandskills.gov.au/data/internet-vacancy-index
- JSA IVI methodology: https://www.jobsandskills.gov.au/data/internet-vacancy-index/methodology
- JSA National Skills Taxonomy: https://www.jobsandskills.gov.au/data/national-skills-taxonomy
- JSA Training Occupation Pathways: https://www.jobsandskills.gov.au/data/training-occupation-pathways

OSCA is canonical for new AU occupation identity. Where a current JSA dataset is still ANZSCO-coded, retain the native ANZSCO code and reporting period and resolve through a versioned concordance. Never silently relabel ANZSCO observations as OSCA observations.

## NZ source baseline

Primary authoritative sources:
- Tahatū Career Navigator data hub: https://tahatu.govt.nz/our-data
- Tahatū occupations API: https://tahatu.govt.nz/our-data/tahatu-occupations-api
- Stats NZ National Occupation List information: https://www.stats.govt.nz/methods/about-the-national-occupation-list/
- Immigration NZ Green List / occupation requirements: https://www.immigration.govt.nz/work/requirements-for-work-visas/green-list-occupations-qualifications-and-skills/

NOL is the canonical NZ occupation classification for new NZ occupation identity where available. Migration signals remain a separate time-scoped policy overlay.

## Data model

Do not add repeated `job1/job2/skills` scalar columns to `catalogue.courses`.

Target logical entities:
- `ref.occupations`
- `ref.occupation_codes`
- `ref.skills`
- `ref.occupation_skills`
- `career.course_skills`
- `career.course_occupations`
- `career.occupation_market_metrics`
- `career.occupation_pathways`
- `career.occupation_registration`
- `career.occupation_migration_signals`
- `career.mapping_evidence`

Course-skill relationships must include relationship type, source/evidence, confidence, validity and review/publication state. Course-occupation relationships must distinguish provider-stated, accreditation-supported, government-pathway, curriculum-inferred, AI-suggested and human-verified mappings.

## Layer mechanism

### Layer 1
Acquire/version occupation taxonomies and official concordances only. Layer 1 does not infer that a Course leads to an occupation.

### Layer 2
Acquire deterministic first-party Course learning outcomes, graduate attributes, unit/subject text where governed, accreditation, provider-stated career outcomes, and official labour-market datasets/APIs. Preserve source grain, period, geography and Evidence.

### Layer 3
Normalise evidence-backed Course outcomes to canonical skills and propose Course↔occupation mappings. Output candidates with Evidence, model/profile/schema version and confidence. Layer 3 cannot publish a career claim directly.

### Layer 4
Human reviewer may accept/reject/adjust a mapping, relevance/confidence, publication state, note and review date. Source text and prior decisions remain immutable/auditable.

### Consumers
Search/Website/Zoho receive only governed published projections. Skills, jobs, market demand, migration and registration must remain separately labelled.

## UI contract — Course blade

Add **Career & Skills** after core Course facts and contextual QILT/PRISMS/Scholarship material:
- Skills you'll develop — evidence-backed badges, expandable with provenance;
- Potential career pathways — occupation, match/relevance, source basis;
- Current market — employment/vacancy/pay/projection observations with geography and reporting period;
- Registration/licensing — when applicable;
- Migration information — separate policy signal with effective date and disclaimer.

Never display a labour-market metric without source and reporting period. Never label a vacancy count as guaranteed job availability.

## Comparison contract

Course comparison may include:
- number/type of evidence-backed skills;
- common/differentiating skills;
- strong/related occupation mappings;
- current labour-market observations by relevant geography;
- QILT graduate outcomes alongside, but not merged mathematically with, labour-demand signals.

## Acceptance/UAT minimum

1. OSCA/NOL identities and code-version uniqueness.
2. ANZSCO↔OSCA/NOL concordance is explicit and non-lossy where source mapping is one-to-many.
3. no fabricated Course skill/occupation mappings.
4. exact Evidence provenance for course-acquired skills.
5. labour metrics retain source period/geography/native classification.
6. Layer 3 candidate cannot bypass Layer 4/governed publication threshold.
7. negative test: occupation-required skill does not automatically become Course-acquired skill.
8. negative test: Green List/migration signal does not imply visa eligibility.
9. stale policy/market observations show freshness state.
10. Course blade and comparison work on desktop/mobile.
11. API payloads remain bounded/paged.
12. role/RLS/private Evidence and anonymous negative paths pass.

## Demo rule

Use a bounded AU and NZ Course where first-party learning outcomes exist. Demonstrate the lineage:
Course → source learning outcome → canonical skill → proposed/accepted occupation → current official market observation.
Then deliberately show the distinction between market demand and migration/registration policy.

## Production gate

This addendum is design/implementation authority only. It does not authorise broad consumer publication until source adapters, mappings, UAT and publication policy are accepted under an implementation Change Control.
