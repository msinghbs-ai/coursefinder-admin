# Coursefinder Architecture v2.8.1 — Baseline Index

**Status:** Authoritative architecture document set for the next physical-schema stage.

**Target project:** `Coursefinder_Prod`

**Baseline version:** v2.8.1

---

## 1. Purpose

This index defines which documents together form the complete Coursefinder v2.8.1 production architecture baseline.

Each document is intentionally **standalone within its own scope**. A reader should not need to read v2.6, v2.7 or v2.8 first to understand a v2.8.1 document.

Earlier versions remain in the repository as historical design artefacts only.

---

## 2. Authoritative v2.8.1 document set

### A. Database Architecture

`docs/coursefinder-database-architecture-v2.8.1.md`

Scope:

- high-level DB principles;
- target Supabase/Postgres schema boundaries;
- Provider/Campus/Course Collection/Course relationships;
- PIM metadata;
- scholarships;
- integration/pipeline/workflow structures;
- import/export architecture;
- search/pgvector architecture;
- publishing/API/RBAC;
- data-flow scenarios;
- production migration principles.

### B. Menu, Integration & Information Model

`docs/coursefinder-architecture-v2.8.1-menu-integration-model.md`

Scope:

- `platform_admin` super-menu;
- role-driven menu reduction;
- Course Family vs Course Collection vs Category vs Association;
- catalogue/PIM operating model;
- Layer 1–4 purpose;
- multi-scraper Layer 2 design;
- multi-LLM/aggregator Layer 3 design;
- Zoho commercial-boundary model;
- menu ownership and operational responsibilities.

### C. Global Reference, Seed Data & Search Foundation

`docs/coursefinder-architecture-v2.8.1-global-reference-seed-search.md`

Scope:

- geography/reference model;
- seed strategy;
- provider identity/external identifiers;
- Institution Collections;
- rankings;
- Field of Study taxonomy;
- staged Oceania/Americas/Europe rollout;
- Search Projection;
- hybrid search/pgvector principles;
- website/search API behaviour;
- scholarship/search interaction.

### D. Current Database Assessment

`docs/coursefinder-current-db-assessment-v2.8.1.md`

Scope:

- live `coursefinder-demo` estate assessment;
- reusable concepts/data;
- design limitations;
- security/RLS issues;
- current pgvector limitations;
- migration classification;
- current-to-target risks;
- rationale for a clean `Coursefinder_Prod` build.

### E. Review Checklist

`docs/coursefinder-database-architecture-v2.8.1-review-checklist.md`

Scope:

- architecture sign-off checklist across catalogue, PIM, reference, search, scholarships, integrations, Zoho, import/export, menu/RBAC and production-project approach.

---

## 3. Cross-document terminology

The following terms have the same meaning throughout all v2.8.1 documents.

| Term | v2.8.1 meaning |
|---|---|
| Provider | Canonical education institution/provider |
| Campus | Provider location/delivery site |
| Course | Atomic canonical searchable academic offering |
| Course Family | Structural/schema type of Course |
| Course Collection | Provider-defined programme grouping/vertical |
| Category / Field of Study | Coursefinder-controlled global classification |
| Institution Collection | Group/membership of Providers such as Go8 |
| Ranking | Time-series provider measurement from a ranking source |
| Attribute | Governed reusable PIM data definition |
| Completeness Profile | Rules defining sufficient data for Family/Country/Channel |
| Integration | External capability/provider definition |
| Pipeline Policy | Rules for how integration capability is used |
| Evidence | Captured source artefact/provenance |
| Search Projection | Denormalised derived read model for fast search |
| Search Profile | Versioned rules defining searchable/vector content |
| Commercial Preference | Customer-specific preference/commission/agreement data owned by Zoho |

---

## 4. Versioning rule going forward

For each architecture baseline:

1. every document starts as a complete document for its stated scope;
2. do not begin with a delta/revision narrative;
3. companion references should point to the **same baseline version** wherever those documents form one architecture set;
4. historical context, superseded decisions and iteration notes belong in an appendix/end section;
5. older files are never overwritten merely to hide history;
6. physical schema versions may advance separately when they represent a new implementation stage.

Example:

```text
Architecture baseline v2.8.1
  Database Architecture v2.8.1
  Menu / Integration / Model v2.8.1
  Global Reference / Seed / Search v2.8.1
  Current DB Assessment v2.8.1
  Review Checklist v2.8.1

After approval:
  Physical Database Schema v2.9
```

---

## 5. Next stage

Once the v2.8.1 set is approved, the next document should be a complete **Physical Database Schema v2.9**, defining:

- every schema/table;
- every column/type/default/nullability;
- PK/FK/unique/check constraints;
- indexes;
- RLS/grants;
- seed-data manifest;
- import/export template definitions;
- API contracts;
- current-to-target mapping;
- migration order;
- performance/search verification plan.

`Coursefinder_Prod` should be created only after v2.9 is approved.
