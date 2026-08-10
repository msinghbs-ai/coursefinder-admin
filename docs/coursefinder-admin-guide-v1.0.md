# Coursefinder — Admin Guide v1.0

> **Pilot environment:** Mumbai (`ap-south-1`)  
> **Audience:** Curator, Pipeline Operator, PIM Admin and Platform Admin  
> **Purpose:** Explain administration, catalogue governance, Layer 1–4 operations, integrations and role boundaries.

---

# 1. Administration Model

Coursefinder separates operational responsibility instead of giving every administrator unrestricted database access.

| Role | Primary responsibility |
|---|---|
| **Curator** | Data quality, review and catalogue curation. |
| **Pipeline Operator** | Layer 1–3 jobs, source acquisition and failure handling. |
| **PIM Admin** | Attribute families, groups, options, categories, completeness and catalogue configuration. |
| **Platform Admin** | Security, users/roles, integrations, source systems and platform-wide settings. |

> **Security model:** browser users consume curated RPC/API contracts. Internal schemas are not intended to become the browser data-access surface.

---

# 2. Platform Architecture at a Glance

`Authoritative sources → Pipeline → Canonical Catalogue/PIM → Publishing/Search → Website/Zoho/API`

Core responsibilities are separated across schemas:

- `ref` — global controlled reference data;
- `catalogue` — providers, campuses, courses and academic structures;
- `pim` — extensible attributes, options, categories and completeness;
- `scholarship` — scholarships, scope and criteria;
- `integration` — external systems, model/extraction configuration;
- `pipeline` — jobs, sources, evidence and acquisition policy;
- `workflow` — review/audit/migration workflow;
- `search` — derived documents, embeddings, profiles and cache;
- `publishing` — publication state/projection control;
- `security` — roles, user assignments and permissions;
- `api/public RPC` — curated application boundary.

---

# 3. Super Admin → Settings

Settings is the control plane for global behaviour, not a general-purpose data editor.

Recommended Settings sections:

## Regulatory Sources
Country-by-country Layer 1 source configuration.

Each country should expose:

- country;
- authoritative regulator/source name;
- source type (`api`, `feed`, `download`, `web`, etc.);
- endpoint/base URL;
- provider/course ingestion enabled state;
- trust rank;
- source enabled/disabled state;
- authentication requirement;
- last check;
- last successful fetch;
- most recent failure;
- optional approved override.

The Pilot now exposes a read contract using existing `ref.countries`, `pipeline.sources` and `integration.systems`. Missing source configuration is intentionally visible instead of being hidden.

### Layer 1 rule

Layer 1 Workers should resolve the active source from configuration in this order:

`Country → authoritative source → acquisition policy → system configuration → runtime secret`

Regulator URLs must not be hard-coded into frontend code or scattered through Worker source.

## Integrations
External systems such as Website API consumers, Zoho Creator, scraper providers, LLM providers and future services.

## Search Profiles
Controls ranking/search behaviour by channel, locale and profile version.

## Security / Roles
User-role assignment and service permissions.

---

# 4. Layer 1 — Regulatory Ingestion

Layer 1 establishes authoritative identity and registration facts wherever a regulator/government source supports them.

## Expected process

1. Worker reads enabled countries.
2. Worker resolves the configured regulatory source.
3. Worker retrieves the source using the configured acquisition method.
4. Raw evidence is recorded.
5. Provider/course identity is reconciled against stable keys and authoritative identifiers.
6. Changes are written through controlled pipeline/catalogue operations.
7. Significant conflicts are sent to Layer 4.
8. Job and evidence status are retained for audit.

## Admin checks

Before enabling a country:

- regulator source configured;
- source verified as authoritative;
- endpoint tested;
- identifier mapping defined;
- acquisition schedule set;
- change handling understood;
- evidence retention working;
- rollback/re-run tested.

---

# 5. Layer 2 — Acquisition

Layer 2 discovers and retrieves provider-level detail not normally available from regulatory datasets.

Typical targets:

- provider/course URLs;
- descriptions;
- campuses;
- provider Course Collections;
- fees;
- intake labels/dates;
- English requirements;
- Academic Options;
- scholarships;
- supporting evidence.

Acquisition policy can vary by global default, country, provider and explicit exception.

---

# 6. Layer 3 — Enrichment

Layer 3 converts evidence into structured candidate values using deterministic rules and approved AI/model profiles.

Admin responsibilities include:

- extraction profile selection;
- model/profile version;
- confidence thresholds;
- routing rules;
- structured scholarship criteria;
- avoiding unnecessary model calls when deterministic extraction succeeds.

A model output is a candidate value, not automatically authoritative truth.

---

# 7. Layer 4 — Governance

Layer 4 is the durable review layer for ambiguous or conflicting catalogue changes.

A complete decision should preserve:

- reviewer identity;
- role;
- action;
- previous value;
- corrected/approved value;
- evidence;
- notes/reason;
- timestamp;
- review lineage;
- reopening reason where evidence changes later.

Typical actions include approve, correct, reject, map attribute, create attribute, merge, split, link, change scope, verified-none, expire, needs-research, suggest and comment.

---

# 8. PIM Administration

Coursefinder uses an extensible PIM model:

`Attribute Family → Attribute Group → Attribute Definition → Attribute Option/Value`

## Families
Determine which attributes and groups apply to an entity/type.

## Groups
Define logical UI sections such as General, Academic, Fees, Admissions, English, Campuses, Scholarships or SEO/Content.

## Attributes
Each definition can specify:

- data type;
- validation;
- options;
- filterability;
- searchability;
- vector inclusion;
- order;
- status.

## Categories
Global Coursefinder taxonomy. Categories are separate from provider Course Collections.

## Completeness Profiles
Define which fields are required for a specific family/country/channel and how completeness is scored.

---

# 9. Provider and Course Identity

Never merge identities solely because names look similar.

Provider identity can include aliases, registrations and temporal associations such as predecessor/successor/merger relationships.

Course identity should use stable keys and authoritative identifiers where available. Display titles and provider wording can change without changing the Coursefinder stable identity.

---

# 10. Search Administration

The normal search path should prioritise efficient structured and text search. Vector search is applied only when it improves semantic intent/recommendation quality.

Production sequence:

`Structured filters → taxonomy/grouping → FTS → optional vector → fusion/boost → scholarship logic → external commercial rerank`

Search artefacts are derived and rebuildable. Canonical catalogue data must not depend on a specific embedding model.

---

# 11. API / Zoho Boundary

Coursefinder owns canonical academic/catalogue truth.

Zoho can consume stable IDs, eligibility/relevance scores and recommendation reasons, then apply commercial/workflow preference externally.

Do not store raw commission/agreement values in semantic text or embeddings.

External API contracts should be versioned before production dependency grows.

---

# 12. Security Administration

Before formal UAT sign-off:

- RLS must be enabled/hardened across internal domain tables;
- anonymous direct-table access must remain closed;
- authenticated users should use curated RPC/API contracts;
- service-role credentials must remain server-side;
- role assignment must be reviewed;
- Supabase Security Advisor must have no unresolved Critical/Error findings;
- runtime secrets must not be committed to GitHub.

---

# 13. Operational Monitoring

Admins should monitor:

- job success/failure;
- queue depth and age;
- source freshness;
- evidence changes;
- Search Projection generation;
- embedding coverage;
- API P50/P95/P99;
- cache hit rate;
- Layer 4 acceptance/rejection;
- Worker errors and retries.

Performance improvements should be measurement-driven and recorded in the Coursefinder roadmap.

---

# 14. Supabase Studio Expectations

The Pilot uses multiple schemas. Supabase Studio can therefore appear empty if the visualiser/table view is left on `public`.

Select schemas such as:

`catalogue`, `pim`, `pipeline`, `integration`, `search`, `workflow`, `scholarship`, `security` or `ref`.

The `public` schema primarily contains the curated application/RPC boundary and is not intended to contain the full domain model.

---

# 15. Change Management

For every database/platform change:

1. design/decision recorded in `coursefinder-admin`;
2. migration applied through Supabase migration tooling;
3. migration SQL recorded in `coursefinder-admin`;
4. UI/runtime code committed only to `Coursefinder-Pilot`;
5. build/runtime tested;
6. running-build record updated;
7. roadmap updated when a new improvement opportunity is discovered.

---

# Revision History

### v1.0
- First Coursefinder Admin Guide.
- Defines role model, Settings/Regulatory Sources, Layer 1–4 operations, PIM, identity, search/API, security and operational process.
