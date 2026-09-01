# CourseFinder Career & Skills Implementation Guide v0.1

**Status:** M2.5 IMPLEMENTATION BLUEPRINT  
**Date:** 1 September 2026  
**Change Control:** `CF-CHG-20260901-062`  
**Execution Addendum:** A17

## 1. Implementation order

Do not begin with UI or AI. Build in this order:

1. reference schema;
2. source/version tables and Evidence linkage;
3. OSCA/NOL/concordance loaders;
4. labour-market/pathway adapters;
5. Course learning-outcome/career/accreditation extraction;
6. Layer 3 mapping;
7. Layer 4 review;
8. read projections/RPCs;
9. Course blade + comparison;
10. consumer publication after acceptance.

## 2. Recommended migration slices

### Migration A — reference identity

Create:
- `ref.occupations`
- `ref.occupation_codes`
- `ref.occupation_code_correspondence`
- `ref.skills`
- `ref.occupation_skills`

Mandatory constraints:
- classification system + version + code unique;
- country-primary occupation identity explicit;
- validity dates supported;
- source/evidence FK where available;
- no destructive overwrite of prior classification versions.

### Migration B — career relationships

Create:
- `career.course_skills`
- `career.course_occupations`
- `career.mapping_evidence`

Mandatory:
- many-to-many relationships;
- relationship_type enum/check;
- confidence/relevance nullable where not supplied;
- review status;
- publishable default false for inferred/AI candidates;
- valid_from/to;
- created/updated provenance;
- L4 decision linkage.

### Migration C — observations/policy

Create:
- `career.occupation_market_metrics`
- `career.occupation_registration`
- `career.occupation_migration_signals`

Market metrics are append-only/time-series observations. Do not update a July observation into August; insert a new observation.

## 3. Suggested source adapters

### ABS OSCA adapter

Responsibilities:
- fetch/download current release metadata;
- ingest hierarchy and occupation rows;
- retain release/version;
- ingest official correspondence files;
- compute idempotent hashes;
- report creates/updates/unchanged/conflicts;
- never delete a previous release merely because a later release appears.

Adapter profile suggestion:
`layer1-au-osca-reference-v0.1.0`

### JSA IVI adapter

Responsibilities:
- detect newly released month;
- store source workbook/report Evidence;
- ingest occupation/geography observations;
- preserve ANZSCO code/version as native source basis while applicable;
- resolve to canonical occupation through explicit correspondence;
- mark unresolved/ambiguous correspondences for review;
- retain seasonally-adjusted/raw semantics if supplied.

Profile:
`layer2-au-jsa-ivi-v0.1.0`

### JSA occupation profile adapter

Store occupation profile observations separately from IVI. Do not merge employment, earnings and vacancy metrics into one score.

### Stats NZ NOL adapter

Profile:
`layer1-nz-nol-reference-v0.1.0`

Same versioning/idempotency principles as OSCA.

### Tahatū adapter

Profile:
`layer2-nz-tahatu-careers-v0.1.0`

Before enabling:
- qualify API/source access terms;
- document authentication/rate limits;
- capture allowed fields;
- test occupation identity mapping;
- retain response/source Evidence consistent with terms.

### Provider Course evidence adapter

Extend existing L2 provider profiles to capture typed blocks:
- learning_outcome;
- graduate_attribute;
- career_outcome;
- accreditation;
- subject_or_unit_outcome where governed.

Do not flatten them into one generic text field.

## 4. Layer 3 task design

Suggested task:
`course_skills_occupation_mapping_v1`

Input:
- Course stable ID;
- current governed first-party Evidence only;
- canonical skills taxonomy slice;
- canonical occupation candidates narrowed by country/field where deterministic;
- accepted accreditation/pathway facts.

Output JSON should include:
- candidate skills[];
- candidate occupations[];
- exact evidence references;
- quoted-source offsets/identifiers where supported;
- relationship_type;
- confidence;
- reasons;
- abstain/insufficient-evidence state.

Negative rules:
- do not generate a skill only because the linked occupation requires it;
- do not map a Course to an occupation only from Course title similarity;
- do not infer migration eligibility;
- do not infer registration completion;
- abstain when Evidence is inadequate.

Benchmark set should contain:
- strong explicit provider career mapping;
- ambiguous broad degree;
- interdisciplinary Course;
- regulated profession;
- Course with no career statements;
- Course whose occupation skills exceed its stated curriculum.

## 5. Layer 4 review

Use the accepted L4 intervention/audit model rather than direct table edits.

Reviewer actions:
- accept skill;
- reject skill;
- accept occupation;
- reject occupation;
- change relevance label/score;
- add note;
- set review/expiry date;
- mark publishable/unpublishable;
- revert to source/algorithm state.

Show:
- underlying Evidence;
- current candidate;
- prior decision history;
- actor/time.

## 6. Read projections / RPCs

Prefer bounded secured projections such as:
- `course_career_summary(course_id)`
- `course_skills_page(course_id, limit, cursor)`
- `course_occupations_page(course_id, limit, cursor)`
- `occupation_market_snapshot(occupation_id, geography, as_of)`
- `course_career_compare(course_ids[], geography)`

Rules:
- browser functions expose summaries, not private Evidence bodies;
- enforce role/rank where review state is exposed;
- cap course_ids to the accepted comparison limit;
- return explicit unavailable/freshness states;
- include source period/classification metadata.

## 7. UI implementation

Course blade component groups:
- CareerSkillsSummary
- SkillEvidenceDrawer
- CareerPathways
- MarketSnapshot
- RegistrationCard
- MigrationPolicyCard

Comparison:
- SkillsComparison
- OccupationComparison
- LabourMarketComparison
- separate QILTOutcomeComparison

Do not mathematically blend QILT outcome percentages with vacancy indexes.

## 8. Feature/environment gates

Add capability gates:
- career_reference_ingestion
- career_market_enrichment
- career_ai_mapping
- career_review
- career_consumer_projection

Pilot and Production enablement remain separate. Production defaults disabled until source/adapters/UAT are accepted.

## 9. Telemetry

Capture:
- source release detected;
- rows parsed/accepted/rejected/unresolved;
- correspondence ambiguity count;
- Course Evidence coverage;
- Layer 3 calls/tokens/latency/cost;
- candidate skills/occupations;
- abstentions;
- L4 acceptance/rejection rates;
- stale market/policy observations;
- API latency/payload;
- consumer cache/version keys.

Suggested version keys:
- occupation_taxonomy_version;
- skills_taxonomy_version;
- labour_market_version;
- career_mapping_version;
- career_consumer_version.

## 10. UAT files to add

Suggested permanent suites:
- `tests/uat/m2-5-career-reference-contract.spec.mjs`
- `tests/uat/m2-5-career-market-contract.spec.mjs`
- `tests/uat/m2-5-career-mapping-contract.spec.mjs`
- `tests/uat/m2-5-career-layer4-review-contract.spec.mjs`
- `tests/uat/m2-5-career-course-blade-deployed.spec.mjs`
- `tests/uat/m2-5-career-comparison-deployed.spec.mjs`

Required negative assertions:
- anonymous/private Evidence access denied;
- AI candidate not automatically publishable;
- occupation skill does not create Course skill;
- stale migration signal does not show as current;
- market metric with unresolved code concordance is not silently attached;
- incompatible geography/period comparison is labelled or suppressed.

## 11. Pilot demo seed

Choose:
- one AU Course with explicit learning outcomes + at least one defensible career statement;
- one NZ Course with equivalent first-party evidence;
- optionally a second AU Course for comparison.

Do not hand-seed invented skills to make the demo look complete. If data is missing, demonstrate the explicit unavailable/not-mapped state.

## 12. Definition of done

Implementation is not complete until:
- migrations and adapters are committed/deployed;
- authoritative source versions recorded;
- bounded AU/NZ ingestion passes;
- mapping benchmark passes;
- L4 review passes;
- Course blade/compare pass desktop/mobile;
- security advisors and negative paths pass;
- performance/payload budgets pass;
- guide and release notes are updated;
- consumer publication is explicitly accepted or remains disabled.
