# Coursefinder — Admin Guide v1.1

**Pilot environment:** Mumbai (`ap-south-1`)  
**Audience:** Curator, Pipeline Operator, PIM Admin and Platform Admin  
**Purpose:** Explain administration, data governance, Layer 1–4 operations, role boundaries and the current Pilot control plane.

---

# 1. Administration Model

Coursefinder separates responsibilities rather than providing unrestricted database access to every administrator.

| Role | Rank | Primary responsibility |
|---|---:|---|
| **Viewer** | 1 | Read catalogue information. |
| **Counsellor** | 2 | Consume catalogue/search/recommendations. |
| **Curator** | 3 | Catalogue quality and human review. |
| **Pipeline Operator** | 4 | Layer 1–3 jobs, acquisition and failure handling. |
| **PIM Admin** | 5 | Families, groups, attributes, options, categories and completeness. |
| **Platform Admin** | 6 | Security, roles, integrations, regulatory sources and global Settings. |

> **Browser security principle:** internal schemas are not the browser data-access surface. UI users consume curated RPC/API contracts.

---

# 2. Platform Architecture

`Authoritative Sources → Pipeline → Canonical Catalogue/PIM → Publishing/Search → API → Website/Zoho`

Key schema responsibilities:

| Schema | Responsibility |
|---|---|
| `ref` | Countries, study levels, fields, provider types and other controlled reference data. |
| `catalogue` | Providers, campuses, courses, collections, academic options and structured course facts. |
| `pim` | Families, groups, attributes, options, values, categories and completeness. |
| `scholarship` | Scholarship definitions, scope and criteria. |
| `integration` | External systems, model profiles and extraction configuration. |
| `pipeline` | Sources, policies, jobs, evidence and claims. |
| `workflow` | Review and audit workflows. |
| `search` | Search Projection, profiles, embeddings and caches. |
| `publishing` | Publication/projection control. |
| `security` | Roles, assignments and service permissions. |
| `api` / curated public RPCs | Application-facing contract boundary. |

---

# 3. Super Admin → Settings → Regulatory Sources

Phase 1A introduces the country regulatory source control plane.

The Settings page is visible only to **Platform Admin** and the backend independently verifies the role.

### What the screen shows

- Pilot country;
- configured source;
- acquisition method;
- source coverage;
- authentication requirement;
- trust priority;
- source status;
- last successful health check;
- authoritative source link.

### Current Pilot model

Seven Pilot countries are configured using nine source records because the UK and New Zealand use multiple sources for different coverage responsibilities.

### Why configuration is centralised

Regulator URLs must not be scattered through frontend/Worker code. Layer 1 uses a service-side resolver to obtain the active source configuration for a country.

Runtime rule:

`Country → active source(s) ordered by trust → integration configuration → runtime secret → country adapter`

---

# 4. Regulatory Source Configuration Concepts

## System

`integration.systems` represents the external regulatory/dataset system and stores platform-level configuration such as:

- system code/name;
- system type;
- base URL;
- acquisition method;
- auth model;
- coverage metadata;
- runtime secret name where applicable.

## Source

`pipeline.sources` maps a source to a country/provider and contains:

- source URL/label/type;
- trust rank;
- status;
- operational metadata;
- health telemetry.

## Trust Rank

Lower numbers are preferred. A country may have more than one source because one registry may cover provider identity while another covers course data.

## Health Telemetry

The source table supports:

- `last_checked_at`;
- `last_success_at`;
- `last_failure_at`;
- `last_error`.

These remain empty until the Layer 1 Worker starts source checks.

---

# 5. Layer 1 — Regulatory Ingestion

Layer 1 establishes authoritative identity and regulatory facts wherever supported.

### Worker process

1. Read the enabled country.
2. Resolve configured regulatory source(s) using the service-only resolver.
3. Load required runtime secret without exposing it to the browser.
4. Run the source-specific adapter.
5. Record source health.
6. Capture evidence/content hash.
7. Create/update pipeline job status.
8. Reconcile provider/course identity using stable IDs and authoritative identifiers.
9. Apply safe canonical changes through controlled backend operations.
10. Route ambiguity/conflict to Layer 4.

### Required operational behaviour

- idempotent reruns;
- retries/backoff;
- clear failed-job state;
- source freshness visibility;
- no silent source switching;
- evidence for material changes;
- deterministic identity reconciliation where possible.

---

# 6. Pilot Regulatory Source Coverage

| Country | Primary role |
|---|---|
| Australia | CRICOS provider/course/location regulatory source. |
| Canada | DLI/provider and international-study eligibility identity source. |
| Germany | Recognised higher-education provider/course discovery. |
| United Kingdom | Provider regulatory status plus separate course dataset. |
| Ireland | Qualification/programme/provider registry. |
| New Zealand | Provider/qualification source plus secondary identity directory. |
| United States | Institution/field/cost/outcome API source. |

Different countries expose different levels of regulatory detail. Layer 1 therefore establishes the strongest authoritative baseline available; Layer 2 fills provider-origin detail later.

---

# 7. Layer 2 — Evidence Acquisition

Layer 2 acquires details that regulatory sources usually do not provide completely:

- descriptions;
- provider/course URLs;
- campuses;
- provider Course Collections;
- fees;
- intake labels and dates;
- English requirements;
- Academic Options;
- scholarships;
- source evidence.

Acquisition policy can vary by global default, country, provider and exception.

---

# 8. Layer 3 — Structured Enrichment

Layer 3 converts evidence into candidate structured values.

Recommended processing order:

`Deterministic extraction → existing mappings → approved model extraction → confidence/routing → Layer 4 if required`

Admin controls eventually include:

- model profile;
- extraction profile;
- routing profile;
- confidence thresholds;
- structured criteria;
- cost/quality controls.

An AI result is a candidate value, not automatically authoritative truth.

---

# 9. Layer 4 — Human Governance

Layer 4 is the durable review/audit layer for ambiguous changes.

A decision should preserve:

- reviewer identity and role;
- action;
- previous value;
- approved/corrected value;
- supporting evidence;
- reason/notes;
- timestamp;
- lineage;
- reopening reason if evidence later changes.

Potential actions include approve, correct, reject, map attribute, create attribute, merge/split/link, change scope, verified-none, expire, needs-research, suggest and comment.

---

# 10. PIM Administration

Coursefinder uses:

`Attribute Family → Attribute Group → Attribute Definition → Attribute Option/Value`

## Families

Determine which groups/attributes apply to an entity or course type.

## Groups

Drive logical admin UI sections such as General, Academic, Fees, Admissions, English, Campuses, Scholarships, SEO/Content and Evidence.

## Attributes

Can define:

- data type;
- validation;
- options;
- required state;
- filterability;
- searchability;
- vector inclusion/weight;
- display order;
- status.

## Categories

Global Coursefinder taxonomy. Categories remain separate from provider-specific Course Collections.

## Completeness Profiles

Define required information by family/country/channel and how completeness is scored.

---

# 11. Provider and Course Identity

Never merge identities only because names appear similar.

Provider identity can include:

- stable key;
- aliases;
- registrations;
- authoritative identifiers;
- predecessor/successor/merger associations;
- temporal validity.

Course display names can change without changing the Coursefinder identity.

---

# 12. Security Administration

Before formal UAT sign-off, Phase 0A must complete:

- RLS/privilege hardening across internal schemas;
- no broad anonymous table access;
- authenticated browser access only through curated contracts;
- service-role credentials server-side only;
- role assignments reviewed;
- Regulatory Settings verified with Platform Admin and lower-role tests;
- Supabase Security Advisor rerun;
- no unresolved Critical/Error findings relevant to the application boundary.

Do not create permissive policies merely to eliminate informational advisor messages.

---

# 13. Search Administration

Canonical catalogue data is independent from a specific embedding model.

Preferred search sequence:

`Structured filters → taxonomy/grouping → FTS → optional vector → fusion/boost → scholarship logic → optional external commercial rerank`

Search Projection, embeddings and caches are derived/rebuildable artefacts.

---

# 14. API / Zoho / Website Boundary

Coursefinder owns canonical academic/catalogue truth.

Zoho may consume stable IDs, academic relevance and recommendation reasons, then apply business/commercial preference externally.

Raw commission/agreement values must not be embedded into semantic search content.

Website and Zoho contracts should be versioned and independently UAT-tested.

---

# 15. Supabase Studio Expectations

The Pilot uses multiple schemas. If Studio is left on `public`, the table editor/schema visualiser can appear empty.

Select schemas such as:

`catalogue`, `pim`, `pipeline`, `integration`, `search`, `workflow`, `scholarship`, `security`, `publishing` or `ref`.

The `public` schema primarily contains the curated UI/RPC boundary.

---

# 16. Operational Monitoring

Platform/Pipeline administrators should monitor:

- source freshness;
- source last check/success/failure;
- job success/failure/retries;
- queue depth/age;
- evidence changes;
- Search Projection generation;
- embedding coverage;
- API latency/error rate;
- cache hit rate;
- Layer 4 acceptance/rejection/reopen rates;
- Worker failures.

Performance improvements should be measured and recorded in the Coursefinder roadmap.

---

# 17. Change Management

For each platform/database change:

1. architecture/decision belongs in `coursefinder-admin`;
2. DDL is applied through Supabase migration tooling;
3. exact migration SQL is recorded in `coursefinder-admin`;
4. runtime/UI/Worker code goes to `Coursefinder-Pilot` only;
5. GitHub/Cloudflare build is tested;
6. running-build record is updated;
7. User/Admin Guides are versioned where behaviour changes;
8. roadmap is updated for new optimisation opportunities.

---

# 18. Next Admin Milestone

The next major operational milestone is:

> Platform Admin can see a country's configured regulatory source, Layer 1 resolves it automatically, the Worker performs a health/fetch cycle, evidence and job telemetry are recorded, and the resulting provider/course identity change is visible and auditable.

---

# Revision History

### v1.1

- Phase 1A Regulatory Settings documented as implemented.
- Added source/system/trust/health concepts.
- Added service-side Layer 1 resolution process.
- Added seven-country coverage model.
- Strengthened role/security and next operational milestone guidance.

### v1.0

- Initial Coursefinder Admin Guide.
