# Coursefinder User Guide v1.2

## What Coursefinder Does
Coursefinder maintains a governed catalogue of education Providers, Courses, Campuses, Course Collections, Categories, Scholarships and supporting evidence.

The platform separates authoritative regulatory truth from later enrichment:

**Layer 1 — Regulatory**  
Government/regulator identity and registration data.

**Layer 2 — Evidence Acquisition**  
Provider websites, fees, intakes, admissions and other deterministic evidence.

**Layer 3 — AI Enrichment**  
Structured extraction, normalisation and assisted matching.

**Layer 4 — Human Governance**  
Review, correction, approval and audit.

## Roles

### Counsellor
Uses published/searchable catalogue data to find and compare study options.

### Curator
Reviews data quality and resolves catalogue issues routed for human review.

### Pipeline Operator
Monitors ingestion and enrichment Jobs, evidence and source health.

### PIM Admin
Maintains Attribute Families, Groups, Attributes, Options, Categories and completeness rules.

### Platform Admin
Controls platform-level settings such as regulatory sources, integrations and controlled Layer 1 ingestion.

## Regulatory Sources
Platform Admin opens **Settings → Regulatory Sources** to see the authoritative source configured for each Pilot country.

The screen shows source, acquisition method, coverage, authentication requirement, trust rank, status and latest successful check.

For Australia, CRICOS is the authoritative Layer 1 source currently under UAT.

## Australia Layer 1 UAT Controls

### Run dry-run (100)
Downloads the current CRICOS source, stores evidence, hashes the source, parses the register and selects the first 100 deterministic records. It does **not** modify the catalogue.

### Apply first 100
Requires explicit confirmation. The run may create or link Providers, Courses and CRICOS registrations. After the write, Coursefinder rebuilds Search Projection and retains the updated catalogue statistics.

### Re-run same 100
Used to prove idempotency. The same regulatory identities should be resolved without duplicate entity creation.

### Reset AU UAT
Requires explicit confirmation. It removes only AU CRICOS UAT additions/registrations and returns the catalogue to the seeded Pilot boundary. User accounts, PIM configuration, source settings, job history and evidence remain intact.

## Statistics After Apply
After a successful Apply, the result panel retains:
- Provider count
- Course count
- CRICOS registration count
- Search document count
- Search generation

The same canonical data is then visible throughout Dashboard, Providers, Courses and Search-related screens.

## Catalogue Concepts

**Course Family** — structural schema/type that controls applicable attributes.  
**Course Collection** — provider-defined grouping such as a faculty/study vertical.  
**Category** — Coursefinder global cross-provider taxonomy.  
**Academic Option** — Major, Minor, Specialisation, Stream, Concentration or similar option inside a Course.

## Evidence and Audit
Regulatory evidence is stored privately. Pipeline Jobs and evidence records provide the operational history for each ingestion run. Resetting UAT catalogue records does not remove that audit history.
