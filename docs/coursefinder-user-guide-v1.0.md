# Coursefinder — User Guide v1.0

> **Pilot environment:** Mumbai (`ap-south-1`)  
> **Audience:** Viewer, Counsellor, Curator and business users  
> **Purpose:** Explain what Coursefinder is, how to navigate it, how catalogue data is created, and how each role should use the platform.

---

# 1. What Coursefinder Does

Coursefinder is a governed education catalogue and search platform. It brings together authoritative regulatory information, provider website data, structured enrichment and human review into a single catalogue that can be consumed by the admin portal, Website APIs and Zoho Creator.

The platform separates three important concepts:

| Concept | Meaning |
|---|---|
| **Provider truth** | The wording and structure used by the university/provider. |
| **Coursefinder structure** | Normalised fields, categories, attributes and search metadata used consistently across providers. |
| **Evidence** | The source material used to justify a value, change or recommendation. |

> **Principle:** Coursefinder standardises meaning without replacing the provider's original wording.

---

# 2. How Data Reaches the Catalogue

Coursefinder uses four controlled data layers.

### Layer 1 — Regulatory truth
Official regulator or government datasets establish provider/course identity and authoritative registrations where available.

### Layer 2 — Evidence acquisition
Provider websites and approved sources are fetched to obtain descriptions, fees, intakes, English requirements, campuses, study areas, scholarships and academic options.

### Layer 3 — Structured enrichment
Rules and AI models convert evidence into structured candidate values while preserving the original evidence.

### Layer 4 — Human governance
A reviewer resolves ambiguous, low-confidence or conflicting values before they become trusted catalogue data.

**Flow**

`Regulator → Provider Evidence → Structured Enrichment → Human Review → Canonical Catalogue → Search/API/Zoho`

---

# 3. Sign In

1. Open the Coursefinder Pilot URL.
2. Enter the email address and password issued for the Pilot Supabase Auth environment.
3. After sign-in, the menu and available actions depend on your assigned role.

The Pilot initially uses read-only catalogue workflows while role-controlled write operations are validated.

---

# 4. Main Navigation

## Dashboard
Provides an operating snapshot of the catalogue including providers, courses, Search Projection, attributes, scholarships, reviews, jobs and evidence.

## Providers
Browse canonical education providers. Each provider has a stable Coursefinder identifier so downstream systems do not depend on display names.

## Campuses
Shows physical or delivery locations associated with providers. Campus records can later be used by course intakes, recommendations and Website filters.

## Course Collections
Provider-defined study areas or verticals such as *Information Technology*, *Business* or *Health*. These preserve the provider's own grouping and are different from global Coursefinder Categories.

## Courses
The main catalogue workspace. Select a course to inspect its provider, study level, field, duration, delivery mode, collections, categories, academic options, fees, intakes and English requirements.

## Scholarships
Browse scholarship definitions and the scope to which they apply.

## Categories
Global Coursefinder taxonomy used consistently across providers for discovery, filtering and search.

## Attributes
Structured PIM fields used to extend entities without changing the core database schema for every new field.

## Completeness
Shows how much required catalogue information is present for each course and identifies records needing enrichment.

## Review Queue
Shows Layer 4 items requiring human attention. Decision actions will be enabled as role-based write workflows are promoted.

## Pipeline / Jobs
Shows Layer 1–4 processing activity and execution status.

---

# 5. Understanding Course Structure

A Course can have several related structures:

| Structure | Example | Purpose |
|---|---|---|
| **Course Family** | Masters coursework | Determines structural schema and PIM form behaviour. |
| **Course Collection** | Information Technology | Provider-defined study area or vertical. |
| **Global Category** | Computing & IT | Cross-provider Coursefinder taxonomy. |
| **Academic Option** | Machine Learning Specialisation | Major, Minor, Specialisation, Stream, Concentration or other option within a course. |

These should not be treated as interchangeable.

---

# 6. Search and Matching

Coursefinder uses structured filters and text search for normal browsing. Semantic/vector search is used where understanding user intent adds value, such as recommendations or related-course discovery.

The intended ranking order is:

`Hard eligibility/filter rules → academic relevance → semantic relevance → optional external commercial preference`

Commercial preference remains outside canonical academic truth.

---

# 7. Scholarship Matching

Scholarships are evaluated conservatively. If a required eligibility criterion is not available in machine-readable form, Coursefinder should return an **unknown/possible** result rather than assume eligibility.

Typical outcome states are:

- **Eligible** — known criteria are satisfied.
- **Ineligible** — a known exclusion or failed criterion exists.
- **Possible / Unknown** — the platform requires more information or human review.

---

# 8. Roles

| Role | Typical use |
|---|---|
| **Viewer** | Read catalogue and operational information. |
| **Counsellor** | Use catalogue/search/recommendation information while assisting students. |
| **Curator** | Review and improve catalogue content and data quality. |
| **Pipeline Operator** | Monitor Layer 1–3 jobs and operational ingestion. |
| **PIM Admin** | Manage structured catalogue configuration and controlled catalogue changes. |
| **Platform Admin** | Manage platform-wide configuration, security and integration settings. |

The interface will progressively hide or expose functions according to these roles.

---

# 9. Data Quality Expectations

When reviewing catalogue information:

- preserve provider wording where it is meaningful;
- do not convert a Specialisation into a Course Collection;
- do not create duplicate providers because a name changes;
- check source year/audience for fees;
- preserve named intake labels such as *Autumn*, *Semester 1* or *Spring*;
- use evidence before approving ambiguous values;
- never assume scholarship eligibility where criteria are incomplete.

---

# 10. Pilot Limitations

The current Pilot is intentionally staged. Some screens may show no data because Layer 2 enrichment has not populated that part of the catalogue yet. This does not mean the database feature is absent.

The Pilot will progressively add controlled editing, bulk operations, Layer 4 decisions, API integration, Zoho UAT and Website UAT.

---

# 11. Getting Help

When reporting an issue, include:

- screen name;
- provider/course name;
- action attempted;
- visible error message;
- expected result;
- screenshot where useful.

Do not include passwords, API keys or service-role credentials.

---

# Revision History

### v1.0
- First role-oriented Pilot User Guide.
- Covers platform concept, Layer 1–4 flow, catalogue structures, navigation, search and user roles.
