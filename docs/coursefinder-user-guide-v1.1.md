# Coursefinder — User Guide v1.1

**Pilot environment:** Mumbai (`ap-south-1`)  
**Audience:** Viewer, Counsellor, Curator and business users  
**Purpose:** Explain the Coursefinder concept, navigation, data lifecycle and role-based use of the platform.

---

# Welcome to Coursefinder

Coursefinder is a governed education catalogue, enrichment and search platform. It combines authoritative regulatory information, provider-origin content, structured enrichment and human governance into one catalogue that can support the admin portal, Website APIs and Zoho Creator.

> **Core principle:** standardise meaning without replacing the provider's original wording.

Three ideas are central:

| Concept | Meaning |
|---|---|
| **Provider truth** | The wording, course structure and facts published by the education provider. |
| **Coursefinder structure** | Consistent fields, categories, attributes and search metadata used across providers. |
| **Evidence** | The source material that supports a catalogue value or change. |

---

# 1. How Coursefinder Builds Trusted Data

Coursefinder uses four controlled layers.

### Layer 1 — Regulatory truth

Authoritative regulator/government sources establish provider/course identity and regulatory facts where available.

### Layer 2 — Evidence acquisition

Approved provider websites and external sources are fetched to collect details such as descriptions, fees, intakes, English requirements, campuses, Course Collections, scholarships and Academic Options.

### Layer 3 — Structured enrichment

Deterministic rules and approved AI models convert evidence into structured candidate values while retaining source evidence.

### Layer 4 — Human governance

A reviewer resolves ambiguous, low-confidence or conflicting information before it becomes trusted catalogue data.

### Data flow

`Regulator → Provider Evidence → Structured Enrichment → Human Review → Canonical Catalogue → Search/API/Zoho`

---

# 2. Signing In

1. Open the Coursefinder Pilot URL.
2. Enter the email address and password issued for the Pilot environment.
3. After sign-in, your role determines the menus and actions available to you.

The Pilot currently prioritises safe read workflows while controlled write operations are introduced progressively.

---

# 3. Main Navigation

## Dashboard

Shows the current operating snapshot, including Providers, Courses, Search Projection, Attributes, Scholarships, reviews, processing jobs and evidence counts.

## Providers

Browse canonical education providers. Stable Coursefinder identifiers allow downstream systems to reference a provider without depending on its current display name.

## Campuses

Browse provider locations and delivery footprints. Campus data can later support course intakes, filtering and recommendations.

## Course Collections

Provider-defined study groupings, such as *Information Technology*, *Business* or *Health*. Course Collections preserve provider structure and are separate from global Coursefinder Categories.

## Courses

The main catalogue workspace. Select **Open** to inspect the course without leaving the list.

The Course Detail panel can show:

- provider;
- stable key and course code;
- study level;
- field of study;
- duration;
- delivery mode;
- lifecycle/publication state;
- description;
- Course Collections;
- Global Categories;
- Academic Options;
- fees;
- intakes;
- English requirements.

Some sections may be empty during Pilot because Layer 2 enrichment has not populated them yet.

## Scholarships

Browse scholarship definitions and their provider/course/application scope.

## Categories

Global Coursefinder taxonomy used consistently across providers for search, filtering and matching.

## Attributes

Structured PIM fields that allow the catalogue to grow without adding a new database column for every provider-specific concept.

## Completeness

Shows whether required catalogue facts are present and helps identify records needing further enrichment.

## Review Queue

Displays Layer 4 items that require human review. Controlled decision actions will be enabled according to role and security gates.

## Pipeline / Jobs

Shows processing activity across the data lifecycle and operational execution history.

---

# 4. Understanding the Course Model

Coursefinder deliberately separates several concepts that may look similar.

| Structure | Example | Purpose |
|---|---|---|
| **Course Family** | Masters coursework | Determines the structural/PIM schema used by the course. |
| **Course Collection** | Information Technology | Provider-defined study grouping. |
| **Global Category** | Computing & IT | Cross-provider Coursefinder taxonomy. |
| **Academic Option** | Machine Learning Specialisation | Major, minor, specialisation, stream, concentration or other option inside a course. |

A provider's wording should be preserved even when Coursefinder maps it to a consistent global concept.

---

# 5. Search and Matching

Coursefinder is designed to use structured filters and text search for normal catalogue browsing. Semantic/vector search is applied where understanding user intent adds value, such as related courses and recommendations.

The intended decision order is:

`Hard eligibility/filter rules → Academic relevance → Semantic relevance → Optional external commercial preference`

Commercial preference is not part of canonical academic truth.

---

# 6. Scholarship Matching

Scholarship matching should be conservative. If Coursefinder does not have enough structured information to prove an eligibility condition, it should not assume the student is eligible.

Typical outcomes:

- **Eligible** — known required criteria are satisfied.
- **Ineligible** — a known exclusion or failed requirement exists.
- **Possible / Unknown** — more information or review is required.

---

# 7. Roles

| Role | Typical responsibility |
|---|---|
| **Viewer** | Read catalogue and operational information. |
| **Counsellor** | Search and use catalogue/recommendation information when assisting students. |
| **Curator** | Review and improve catalogue quality. |
| **Pipeline Operator** | Monitor Layer 1–3 processing and ingestion failures. |
| **PIM Admin** | Manage catalogue structure, attributes, categories and controlled configuration. |
| **Platform Admin** | Manage security, integrations and platform-wide Settings. |

Menus and actions will progressively become role-specific. For example, **Settings → Regulatory Sources** is a Platform Admin function and should not appear for lower roles.

---

# 8. Regulatory Sources — What Users Should Know

Coursefinder does not expect users to manually find regulator websites during normal work.

Each Pilot country has a controlled regulatory source configuration maintained by Platform Admin. Layer 1 uses that configuration to obtain authoritative information and records operational status/evidence.

For normal users, the important principle is:

> Regulatory facts come from governed source configuration rather than arbitrary internet search or manually entered URLs.

---

# 9. Data Quality Expectations

When reviewing catalogue information:

- preserve meaningful provider wording;
- do not turn an Academic Option into a Course Collection;
- do not create a duplicate provider because its display name changes;
- check fee year, audience and basis;
- preserve provider intake names such as *Semester 1*, *Autumn* or *Spring*;
- review source evidence before accepting ambiguous values;
- do not assume scholarship eligibility when criteria are incomplete.

---

# 10. Pilot Limitations

The Pilot is intentionally staged.

Current limitations can include:

- the catalogue seed is smaller than the eventual production dataset;
- Layer 2 detail may be missing for some courses;
- health timestamps for regulatory sources remain empty until the Layer 1 Worker performs checks;
- controlled editing/bulk actions are not yet generally enabled;
- Zoho and Website integrations are later UAT stages.

An empty data section does not necessarily mean the database capability is missing.

---

# 11. How to Report a UAT Issue

Include:

- screen name;
- provider/course name;
- action attempted;
- visible error message;
- expected result;
- screenshot where useful.

Never include passwords, API keys or service-role credentials in UAT notes.

---

# 12. UAT Journey

Coursefinder uses progressive UAT rather than waiting for the entire platform to be complete:

`Admin UI → Layer 1 → Layer 2/3 Data Quality → Layer 4 Governance → API → Zoho → Website → Production Readiness`

This makes each stage testable before downstream systems depend on it.

---

# Revision History

### v1.1

- Added Course Detail workspace guidance.
- Added role-aware Settings behaviour.
- Added Regulatory Sources user concept.
- Updated Pilot limitations and progressive UAT journey.

### v1.0

- Initial role-oriented Coursefinder User Guide.
