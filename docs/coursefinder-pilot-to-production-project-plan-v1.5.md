# Coursefinder — Pilot to Production Project Plan v1.5

**Status:** Living delivery plan  
**Authoritative runtime:** `coursefinder_Pilot` — Mumbai (`ap-south-1`)  
**Pilot code repository:** `msinghbs-ai/Coursefinder-Pilot`  
**Architecture/design/planning repository:** `msinghbs-ai/coursefinder-admin`

> `Coursefinder-Pilot` remains code/runtime only. All design, database, planning, UAT, guide and roadmap records remain in `coursefinder-admin`.

---

## 1. Current Position

The project is currently in **Phase 1 — PIM/Admin UI**, with **Phase 1A — Super Admin Regulatory Settings completed at database/code level**. The next major functional build is the **Layer 1 Regulatory Worker**, but formal UAT remains gated by Phase 0A security hardening.

### Achieved foundation

- Mumbai production-model Supabase Pilot.
- Database migrations through **027**.
- Authenticated Pilot UI and catalogue workspaces.
- Course detail workspace.
- Search Projection baseline.
- Role model and Platform Admin assignment.
- Super Admin Regulatory Sources Settings.
- Seven Pilot countries configured with nine authoritative source records.
- Service-role-only country source resolver for Layer 1.
- GitHub → Cloudflare deployment configuration committed.
- Role-based User/Admin Guides underway and versioned.

---

## 2. Phase Status

| Phase | Scope | Status | Remaining estimate |
|---|---|---|---:|
| Phase 0 | Pilot runtime/bootstrap | Complete; latest merge deployment to verify | 0–2 hrs |
| Phase 0A | RLS / privilege hardening | **Next mandatory gate** | 4–6 hrs |
| Phase 1 | PIM/Admin UI | In progress | 14–20 hrs |
| Phase 1A | Regulatory Settings | **Implemented** | 1–2 hrs runtime/UAT verification |
| Phase 2 | Canonical data migration | Not started beyond UI seed | 14–20 hrs |
| Phase 3 | Layer 1 regulatory pipeline | **Next major build** | 14–20 hrs |
| Phase 4 | Layer 2 acquisition/evidence | Planned | 24–32 hrs |
| Phase 5 | Layer 3 AI extraction | Planned | 20–28 hrs |
| Phase 6 | Layer 4 governance | Planned | 18–24 hrs |
| Phase 7 | Search / Website / Zoho APIs | Planned | 20–28 hrs |
| Phase 8 | Zoho Creator integration/UAT | Planned | 20–28 hrs |
| Phase 9 | Website integration/UAT | Planned | 18–24 hrs |
| Production readiness | Security, performance, cutover, hypercare | Planned | 20–28 hrs |

**Planning-equivalent remaining envelope:** approximately **186–254 hrs**. This is a delivery estimate, not a timesheet claim, and will be refined from actual Pilot velocity.

---

## 3. Phase 0A — Mandatory Security Gate

**Priority:** Immediate  
**Exit gate:** no unresolved Critical/Error security findings relevant to the Pilot application boundary.

Scope:

- enable/harden RLS across internal domain tables;
- validate schema usage/table grants;
- preserve service-role and controlled backend operations;
- ensure anonymous users have no direct internal-table access;
- ensure authenticated browser users consume curated RPC/API contracts;
- validate Platform Admin Regulatory Settings after hardening;
- validate all current UI read RPCs;
- run Supabase Security Advisor;
- document accepted informational findings rather than adding permissive policies.

---

## 4. Phase 1 — PIM/Admin UI

### Completed UI baseline

- Dashboard
- Providers
- Campuses
- Course Collections
- Courses
- Course detail
- Scholarships
- Categories
- Attributes
- Completeness
- Review Queue
- Pipeline
- Jobs
- Settings → Regulatory Sources

### Remaining Phase 1 UI

- Provider detail workspace;
- PIM Families;
- Attribute Groups;
- Attribute Options;
- Completeness Profiles;
- Evidence Viewer;
- richer role-aware navigation/actions;
- pagination;
- filters and sort;
- saved table/filter state;
- controlled write workflow framework after security gate.

**Exit gate:** authorised admin roles can navigate and govern the core PIM/catalogue model through curated contracts without direct internal-schema browser access.

---

## 5. Phase 1A — Super Admin Regulatory Settings

**Status:** Implemented.

### Delivered

- Platform Admin-only Settings menu visibility.
- Server-side Platform Admin check.
- Country Regulatory Sources registry.
- Acquisition method.
- Coverage metadata.
- Authentication requirement.
- Trust priority.
- Source/system status.
- Health telemetry columns.
- Source links.
- Multi-source country support.
- Service-role-only Worker source resolver.

### Runtime/UAT verification

After Cloudflare deploy, confirm:

1. Platform Admin can see Settings.
2. Lower roles cannot see/use Regulatory Settings.
3. Seven Pilot countries appear.
4. Nine configured sources appear.
5. Source URLs, methods, coverage and trust order render correctly.
6. Health fields show `Not checked yet` until Layer 1 starts.

---

## 6. Phase 3 — Layer 1 Regulatory Pipeline

This is the **next major functional milestone**.

### Runtime flow

`Enabled Country → Source Resolver → Country Adapter → Fetch → Evidence → Reconciliation → Canonical Catalogue → Review if required`

### Worker requirements

- read enabled countries;
- call the service-only source resolver;
- support multiple ordered sources per country;
- use runtime secrets where a source requires authentication;
- no hard-coded regulator URLs in frontend code;
- adapter-specific acquisition logic;
- content hash/evidence capture;
- source health telemetry;
- pipeline job creation/status;
- retries/backoff;
- idempotent reruns;
- stable provider/course reconciliation;
- explicit change/conflict outcomes;
- Layer 4 routing for ambiguous changes.

### Country adapter order

| Country | Adapter focus |
|---|---|
| AU | CRICOS dataset discovery/download and provider/course/location parsing |
| CA | IRCC DLI provider/campus identity; course detail remains later-source work |
| DE | HRK Hochschulkompass provider/course discovery |
| GB | OfS provider status + Discover Uni course data |
| IE | QQI qualification/programme/provider registry |
| NZ | NZQA primary + Education Counts identity reconciliation |
| US | College Scorecard API provider/institution/field data |

### Phase 3 exit gate

For each Pilot country:

- configured source resolves successfully;
- source health is recorded;
- evidence is retained;
- identity reconciliation is repeatable;
- rerun is idempotent;
- changes are traceable;
- failures are visible in Jobs;
- ambiguous identity/data changes can enter Layer 4.

---

## 7. Phase 2 — Canonical Data Expansion

Once the Layer 1 identity path is proven:

- migrate/reconcile the wider validated catalogue;
- retain stable provider/course IDs;
- migrate only trusted facts/provenance;
- avoid migrating demo security/config debt;
- do not migrate old embeddings/cache;
- rebuild Search Projection;
- regenerate embeddings under the active Search Profile/model.

Phase 2 and Phase 3 can overlap carefully: identity should be established by Layer 1 before bulk enrichment facts are treated as canonical.

---

## 8. Phase 4–6 — Enrichment and Governance

### Phase 4 — Layer 2

Acquire provider-origin information and evidence:

- descriptions;
- URLs;
- campuses;
- Course Collections;
- fees;
- intakes;
- English requirements;
- Academic Options;
- scholarships;
- source snapshots and hashes.

### Phase 5 — Layer 3

- deterministic extraction first;
- LLM extraction where valuable;
- versioned model/extraction profiles;
- confidence;
- structured scholarship criteria;
- evidence-backed candidate values.

### Phase 6 — Layer 4

- approve/correct/reject;
- durable review actions;
- reviewer identity/role;
- before/after values;
- evidence lineage;
- reopen when evidence changes;
- publication governance.

---

## 9. Phase 7–9 — API / Zoho / Website

### API UAT before consumers

Stabilise and version API contracts for:

- course search/detail;
- providers;
- related courses;
- comparison;
- scholarships;
- recommendations;
- batch endpoints for Zoho.

### Zoho Creator UAT

Validate:

- stable IDs;
- filtered search;
- semantic intent;
- course/scholarship recommendations;
- batch lookups;
- retries/idempotency;
- academic relevance before external commercial reranking.

### Website UAT

Validate:

- public search/filtering;
- detail pages;
- related courses;
- scholarships;
- caching/rate limits;
- publication state;
- public-field boundary.

---

## 10. Progressive UAT Model

Do not wait for the entire platform to be complete.

`Admin UI UAT → Layer 1 UAT → Layer 2/3 Data Quality UAT → Layer 4 Governance UAT → API UAT → Zoho UAT → Website UAT → Production Readiness`

Each stage creates evidence and fixes before the next dependency is introduced.

---

## 11. Production Readiness Gates

Before production promotion:

- security hardening completed;
- role matrix validated;
- evidence retention/private storage validated;
- Layer 1–4 retry/idempotency tested;
- Search Projection rebuild tested;
- embedding regeneration tested;
- API versioning/failure behaviour tested;
- Zoho and Website consumers signed off;
- monitoring/alerts configured;
- performance/load targets satisfied;
- backup/restore and migration reproduction validated;
- User/Admin Guides updated;
- cutover and rollback runbook approved.

---

## 12. Immediate Next Steps

1. Verify Cloudflare deploy of Phase 1A merge.
2. Complete Phase 0A RLS/privilege hardening.
3. Build Layer 1 Worker source resolver + health-check framework.
4. Implement AU CRICOS adapter first as the reference adapter.
5. Validate evidence, job telemetry and idempotent rerun.
6. Add remaining country adapters.
7. Complete remaining Phase 1 UI in parallel.
8. Expand canonical Pilot dataset after the identity flow is proven.

---

## Revision History

### v1.5

- Phase 1A marked implemented.
- Regulatory Settings and source registry included.
- Layer 1 Worker promoted to next major build.
- Phase 0A security gate retained ahead of formal UAT.
- Estimates revised after current UI/Settings delivery.
