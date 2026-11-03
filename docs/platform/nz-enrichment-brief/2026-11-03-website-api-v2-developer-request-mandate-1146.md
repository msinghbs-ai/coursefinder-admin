# StudySearch — Website API v2 Developer Request, 2 November 2026

**Mandate:** Assess and prepare the API changes requested by the Wix developer, preserve API v2 compatibility, and prepare the next formal developer handover.

Read the canonical operating model, current developer requirements register, latest Website API v2 guide, consumer API contract and current live definitions before implementation.

## 1. Scope and change classification

The developer requests:

1. Campus names and course counts.
2. Scholarship nationality eligibility.
3. Ranking history.
4. Academic entry requirements.
5. University-level costs.

Classify each as:
- Missing API functionality.
- Existing API functionality requiring documentation.
- Missing or incomplete underlying data.
- Platform enrichment requirement.
- Not supported because a reliable data basis is unavailable.

Do not build API fields merely to compensate for data-coverage gaps.

## 2. Campus names and course counts — proposed additive API change

Existing objects include:
- `catalogue.campuses`
- `catalogue.course_campuses`
- `api.website_v2_provider_campuses`

The current provider-campus API omits stored campus names.

Prepare an additive extension returning:

- `campus_id` — stable public identifier.
- `campus_name` — verified stored campus name.
- `course_count` — distinct published courses assigned to this campus.

Preserve all existing campus properties.

Requirements:

- Do not collapse multiple campuses in the same city/postcode into one campus.
- Deduplicate by stable campus identity.
- Count only relevant published, visible courses.
- Exclude withdrawn or invalid associations.
- Use the existing approved publication and identity rules.
- Do not count a provider's entire catalogue at each campus.
- Avoid a per-campus database query pattern that increases API latency.
- Validate against the existing Admin campus/course view for representative AU/NZ/CA providers.

Assess whether the `campuses[]` payload returned by the course search and detail APIs should also receive the new identifiers and names, keeping backwards compatibility.

Prepare exact before-and-after JSON examples.

## 3. Nationality — eligibility semantics

Existing scholarship data includes nationality readings and criteria.

The API already returns:
- `citizenship_eligibility[]`
- `eligible_countries_list[]`

Preserve these.

Propose an additive `nationality_eligibility_status` field:

- `restricted`
- `unrestricted`
- `unknown`
- `under_review`

Define each status using explicit source evidence and actual Layer 4 review state.

Do not treat an empty list as unrestricted.

Explicitly handle:
- Country-specific eligibility.
- Geographic region eligibility.
- International-student eligibility without specified nationality.
- Domestic-only awards.
- Confirmed unrestricted nationality.
- Unknown or incomplete extraction.

Where regional restrictions exist, preserve their original meaning instead of incorrectly inferring individual eligible countries.

Use StudySearch's own scholarship enrichment, extraction and Layer 4 pipeline to improve nationality evidence continuously.

Claude must not manually enrich scholarship records as the normal operating mechanism.

Verify that the existing nationality filter cannot produce false-positive matches or false exclusions.

## 4. Ranking history

Verify existing:
- `rankings` action.
- Provider detail ranking history.
- `public.website_v2_provider_rankings`.
- Accepted QS and THE editions.

The developer reports QS history from 2021 and THE from 2016, subject to individual institutions' available history.

Reconcile the actual live data and document which years are available.

Do not invent missing historical editions, rankings or institution identities.

Verify Adelaide University's actual edition history without assuming it existed under that identity in earlier years.

If the existing API satisfies the requirement, make no API change.

Provide a concise Wix example explaining how to sort ranking editions chronologically and display missing years.

Preserve rankings attribution and approved usage terms.

## 5. Academic entry requirements

Keep the existing API contract:
- `entry`
- `entry_matrix[]`
- `edu_country`
- Existing qualification and score metadata.

Do not create a parallel academic-entry API.

Continue the platform-owned AER automation programme:

- Provider and qualification source discovery.
- Country/global qualification reconciliation.
- Reader completeness.
- D-R2/D-R3 safeguards.
- Governed Layer 4 admission.
- Consumer publication and validation.

Report provider/course coverage separately from the API release.

Do not promise that all requirements will be populated by the API deployment.

For Wix, document how to hide unavailable entry data and display only approved, applicable requirements.

## 6. University-level costs

Do not introduce an average university tuition amount without an approved methodology.

Continue returning existing course-level tuition, including currency, basis and year.

Assess whether institution-published official cost-of-living or compulsory non-tuition cost information exists as separately evidenced platform data.

If not held reliably, report `not available`; do not add synthetic values.

Any future cost feature requires a separate approved definition of cost category, applicable audience, location, currency, effective year, source and basis.

## 7. Governance and release approval

Consumer API G3 remains in force.

Prepare the exact additive change proposal, affected functions, impact analysis and Platform Admin approval record.

Do not merge, deploy or rebaseline consumer API changes until the required explicit approval is recorded.

Once approved:

1. Record decision and field contracts in Admin.
2. Create guarded additive migrations in Pilot.
3. Run existing consumer-contract and full test suites.
4. Verify current live function checksums.
5. Validate searches, provider detail, scholarships, rankings and sync.
6. Confirm existing fields remain byte/semantically compatible where required.
7. Check API performance, pagination, visibility restrictions and cache behaviour.
8. Deploy through the authorised release process.
9. Verify representative live payloads and Wix read-back.
10. Record release version, rollback/forward recovery and results.

## 8. Formal Wix API handover

Follow the previous Developer Guide Issue 7 process.

Prepare the next sequential developer guide issue (Issue 8 if still current), but verify the latest issue before numbering.

Update only the developer-facing material under:

`docs/integrations/developer-pack/`

Required handover package:
- Updated Website API v2 developer guide.
- Updated OpenAPI 3.1 specification.
- Updated Postman collection.
- Before-and-after API request/response examples.
- Campus and nationality field definitions.
- Ranking history usage example.
- Entry and cost availability guidance.
- Dated developer handover note.
- Section 13 change log showing only actual consumer API changes.
- Explicit release/version line.
- Applicable Wix CMS mapping and sync guidance.

Update `docs/integrations/WEBSITE-DEVELOPER-REQUIREMENTS.md` and the canonical platform decision register.

Do not include internal engineering defects or unrelated release activity in the developer pack.

No secrets, API keys or internal database functions should appear in developer-facing documents.

Do not hand over proposed fields as though they are live.

## 9. Completion report

Return a concise summary containing:

1. API fields actually added.
2. Requests satisfied by the existing API.
3. Data-coverage work still underway.
4. Exact approved/deployed release version.
5. Verified live examples.
6. Updated handover document locations.
7. Any remaining Platform Admin decisions.
8. Any Wix-side mapping changes required.

**The objective is to deliver accurate, additive Website API changes while StudySearch itself continues autonomous data enrichment.**