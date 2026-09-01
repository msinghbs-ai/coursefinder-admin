# CourseFinder Course Skills, Career Pathways & Labour-Market Intelligence Design v0.1

**Status:** M2.5 DESIGN BASELINE — IMPLEMENTATION PENDING  
**Date:** 1 September 2026  
**Change Control:** `CF-CHG-20260901-062`  
**Execution Addendum:** A17

## 1. Goal

Provide international students with explainable, current and evidence-backed information about:
- skills a Course develops;
- occupations related to the Course;
- labour-market context for those occupations;
- professional registration/licensing;
- migration-policy signals where relevant.

The model must never imply guaranteed employment, salary, registration or visa eligibility.

## 2. Source register

### Australia

| Dataset/source | Authority | Use | Refresh/design notes |
|---|---|---|---|
| OSCA 2024 | ABS | canonical AU occupation taxonomy, hierarchy, titles, main tasks, skill level | versioned reference; prepare for OSCA 2027 |
| OSCA correspondence downloads | ABS | ANZSCO↔OSCA and NOL concordance | preserve one-to-many/many-to-one relationships |
| Occupation & Industry Profiles | Jobs and Skills Australia | employment/profile context | JSA transition to OSCA must be tracked |
| Internet Vacancy Index | Jobs and Skills Australia | monthly vacancy-demand proxy by occupation/geography | currently ANZSCO-coded; retain native code + period |
| National Skills Taxonomy | Jobs and Skills Australia | strategic canonical AU skills framework as it matures | adapter must be version-aware |
| Training Occupation Pathways | Jobs and Skills Australia | qualification→occupation pathways, especially VET | do not over-extend to university courses without evidence |
| Provider Course pages/handbooks | provider first party | learning outcomes, graduate attributes, career statements | Layer 2 Evidence source |
| Accreditation/registration bodies | official body | accredited-program and registration requirements | separate from occupation mapping |

Important links:
- https://www.abs.gov.au/statistics/classifications/osca-occupation-standard-classification-australia/latest-release
- https://www.abs.gov.au/about/key-priorities/about-osca/osca-2027
- https://www.jobsandskills.gov.au/data/occupation-and-industry-profiles
- https://www.jobsandskills.gov.au/data/internet-vacancy-index
- https://www.jobsandskills.gov.au/data/internet-vacancy-index/methodology
- https://www.jobsandskills.gov.au/data/national-skills-taxonomy
- https://www.jobsandskills.gov.au/data/training-occupation-pathways

### New Zealand

| Dataset/source | Authority | Use | Refresh/design notes |
|---|---|---|---|
| National Occupation List (NOL) | Stats NZ | canonical NZ occupation identity | versioned taxonomy |
| Tahatū occupation data/API | Tertiary Education Commission | job descriptions, tasks, pay/training/work context and pathway support | API/source contract and terms must be qualified before Production |
| Provider Course pages/handbooks | provider first party | learning outcomes, graduate attributes, career statements | Layer 2 Evidence |
| Green List / occupation rules | Immigration NZ | migration-policy overlay | time-scoped; never a Course promise |
| Registration authorities | official body | occupational registration/licensing | separate relationship |

Important links:
- https://tahatu.govt.nz/our-data
- https://tahatu.govt.nz/our-data/tahatu-occupations-api
- https://www.stats.govt.nz/methods/about-the-national-occupation-list/
- https://www.immigration.govt.nz/work/requirements-for-work-visas/green-list-occupations-qualifications-and-skills/

## 3. Canonical model

### ref.occupations
Suggested fields:
- id UUID
- country_code
- canonical_title
- description
- skill_level
- lifecycle_status
- valid_from / valid_to
- source_version_id

### ref.occupation_codes
One occupation may carry multiple code systems.
- occupation_id
- classification_system: OSCA | NOL | ANZSCO | ISCO | other
- classification_version
- code
- principal_title
- valid_from / valid_to
- source_id / evidence_id
- is_primary_for_country

Unique constraint should include classification system + version + code, not code alone.

### ref.occupation_code_correspondence
Required because mappings may not be 1:1.
- from_code_id
- to_code_id
- correspondence_type
- correspondence_weight/qualifier when officially supplied
- source/evidence/version

### ref.skills
- id
- country/global scope
- taxonomy/system
- taxonomy_version
- skill_code
- title
- description
- skill_type
- lifecycle

### ref.occupation_skills
Occupation-required/used skills only.
- occupation_id
- skill_id
- relationship_type
- importance/proficiency where officially supplied
- source/evidence
- valid_from/to

### career.course_skills
Course-developed skills.
- course_id
- skill_id
- relationship_type: stated_learning_outcome | graduate_attribute | subject_derived | accreditation_required | normalised_from_evidence | human_verified
- source_text
- source_id / evidence_id
- confidence_score
- review_status
- publishable
- valid_from/to
- verified_at

### career.course_occupations
- course_id
- occupation_id
- relationship_type: provider_stated | accreditation | government_pathway | curriculum_inferred | ai_suggested | human_verified
- relevance_score
- confidence_score
- source/evidence
- review_status
- publishable
- valid_from/to

### career.occupation_market_metrics
Time series, never overwritten in-place.
- occupation_id
- source_classification_code_id
- metric_type
- value_numeric / value_text
- unit
- geography_type / geography_code
- reference_period
- released_at
- seasonal_adjustment
- source/evidence
- observed_at

Examples: vacancy count/index, employment count, median/typical earnings where official, projection/growth category.

### career.occupation_registration
- occupation_id
- jurisdiction
- registration_required
- authority
- requirement_summary
- source/evidence
- valid_from/to

### career.occupation_migration_signals
- occupation_id/code basis
- jurisdiction
- programme/list
- tier/category
- requirement_summary
- effective_from/to
- source/evidence
- last_verified_at

This is policy data, not an eligibility result.

## 4. Evidence and provenance

Every published Course skill must trace to first-party Course/curriculum/accreditation Evidence or an accepted government pathway. Occupation-required skills cannot be copied into Course-acquired skills merely because an occupation is linked.

Every market observation must preserve:
- native source classification;
- source release/version;
- reference period;
- release date;
- geography;
- seasonally adjusted/raw state;
- metric definition/methodology link.

## 5. Acquisition mechanism

### AU
1. Layer 1 scheduled reference adapter loads OSCA version + code hierarchy.
2. Layer 1 concordance adapter loads official OSCA↔ANZSCO/NOL correspondence.
3. Layer 2 JSA adapter ingests profiles and IVI releases as time-series observations.
4. Layer 2 provider adapter captures learning outcomes/career statements/accreditation.
5. Layer 3 normalises provider evidence to canonical skills and proposes occupations.
6. Layer 4 reviews consequential or low-confidence mappings.

### NZ
1. Layer 1 adapter loads NOL/version/concordance.
2. Layer 2 Tahatū adapter ingests permitted occupation/pathway context.
3. Layer 2 provider adapter captures Course learning outcomes/career statements.
4. Layer 2 policy adapter versions Green List/registration requirements.
5. Layer 3/4 use the same candidate→review boundary as AU.

## 6. Confidence/relevance

Do not create one opaque “job match score”. Store component evidence:
- provider-stated career outcome;
- accreditation/pathway support;
- learning-outcome/skill overlap;
- curriculum evidence coverage;
- government pathway;
- reviewer acceptance.

UI may translate this to labels such as Strong / Related / Exploratory only after thresholds are governed and explainable.

## 7. Course blade UX

**Career & Skills**
1. Skills you'll develop — top six badges + View all.
2. Evidence drawer per skill — exact learning outcome/source.
3. Potential career pathways — occupation, relationship basis, relevance label.
4. Market snapshot — official metric, geography, period, freshness.
5. Registration — requirement/authority.
6. Migration — separate policy card with effective date and disclaimer.
7. Last verified/source links.

Unavailable states must distinguish:
- not mapped yet;
- no first-party skill evidence found;
- occupation mapped but market data unavailable;
- not applicable;
- source stale;
- awaiting review.

## 8. Comparison UX

For up to the governed comparison limit:
- common skills;
- differentiating skills;
- strong/related occupations;
- market metrics for the same geography and period where possible;
- QILT graduate outcomes in a separate row/group;
- registration/migration indicators with effective dates.

Do not compare incomparable periods or geographies without warning.

## 9. API/read contract

Course detail projection should return bounded summaries plus paged drill-down:
- career_summary
- skills_summary[]
- occupation_summary[]
- market_snapshot[]
- registration_summary[]
- migration_signal_summary[]

Evidence bodies remain private; consumer API may expose public source links and provenance labels only.

## 10. Scheduling/freshness

Recommended design classes:
- occupation taxonomy: on official release/change notice;
- JSA IVI: monthly;
- occupation profiles: source-defined release cadence;
- provider Course learning outcomes: existing L2 refresh/profile cadence;
- migration lists: scheduled recheck + change detection, more frequent than static taxonomy;
- registration: periodic + source change detection.

Do not hard-code the cadence if source metadata can provide it.

## 11. Security

- public/Website/Zoho cannot query raw/private Evidence tables;
- Layer 3 secrets remain server-side;
- L4 accept/reject requires governed rank;
- migration/registration edits are audited;
- consumer projection excludes unreviewed low-confidence candidates;
- no third-party job/person data acquisition is required for the core model.

## 12. Implementation phases

**A17-P1 Reference:** schema + OSCA/NOL/concordance adapters.  
**A17-P2 Market:** JSA/Tahatū market/pathway adapters and time-series storage.  
**A17-P3 Course evidence:** learning outcomes/career/accreditation extraction.  
**A17-P4 Intelligence:** skills normalisation and occupation candidate generation.  
**A17-P5 Review/UI:** Layer 4 review, Course blade, compare.  
**A17-P6 Consumer:** governed API/Search/Website/Zoho projection after acceptance.

## 13. Initial bounded demo

Use one AU and one NZ Course with accessible first-party learning outcomes. Demo:
1. source Course outcome;
2. Evidence record;
3. normalised skill;
4. proposed/accepted occupation;
5. official current market metric;
6. classification/version;
7. separate migration/registration card;
8. compare two AU Courses if equivalent metric periods exist.

## 14. Non-goals

- predicting individual salary;
- promising employment;
- personalised visa assessment;
- scraping commercial job boards as canonical labour-market truth;
- inferring Course skills solely from occupation skill requirements;
- exposing AI-only mappings as established facts.
