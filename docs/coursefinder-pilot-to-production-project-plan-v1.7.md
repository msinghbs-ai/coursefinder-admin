# Coursefinder — Pilot to Production Project Plan v1.7

**Status:** Living delivery plan  
**Authoritative runtime:** `coursefinder_Pilot` — Mumbai (`ap-south-1`)  
**Pilot code repository:** `msinghbs-ai/Coursefinder-Pilot`  
**Architecture/design/planning repository:** `msinghbs-ai/coursefinder-admin`

> `Coursefinder-Pilot` remains code/runtime only. All design, database, planning, UAT, guide and roadmap records remain in `coursefinder-admin`.

---

## 1. Current Position

The project has now entered **Phase 3 — Layer 1 Regulatory Pipeline**.

Phase 0A security hardening is complete and Phase 1A Regulatory Settings is implemented. The AU/CRICOS Worker is the first country reference adapter and has been merged to Pilot `main`.

### Completed

- Phase 0 — runtime/bootstrap.
- Phase 0A — RLS and privilege hardening.
- Phase 1A — Super Admin Regulatory Settings.
- Seven-country / nine-source regulator registry.
- Layer 1 service-role source resolver.
- Layer 1 job/evidence/source-health service contract.
- AU CRICOS Institutions/Courses acquisition adapter.
- Private evidence storage path and hashing.
- Conservative CRICOS identity reconciliation.
- Combined Cloudflare SPA + Worker API routing.

---

## 2. Phase Status

| Phase | Scope | Status | Remaining estimate |
|---|---|---|---:|
| Phase 0 | Pilot runtime/bootstrap | ✅ Complete | 0 hrs |
| Phase 0A | RLS / privilege hardening | ✅ Complete | 0 hrs |
| Phase 1 | PIM/Admin UI | 🟢 In progress | 14–20 hrs |
| Phase 1A | Regulatory Settings | ✅ Implemented | 1–2 hrs visual/runtime UAT |
| Phase 2 | Canonical data migration | ⬜ Awaiting proven Layer 1 identity path | 14–20 hrs |
| **Phase 3** | **Layer 1 regulatory pipeline** | **🟢 In progress — AU reference adapter built** | **10–16 hrs AU + 8–12 hrs remaining countries baseline** |
| Phase 4 | Layer 2 acquisition/evidence | ⬜ Planned | 24–32 hrs |
| Phase 5 | Layer 3 AI extraction | ⬜ Planned | 20–28 hrs |
| Phase 6 | Layer 4 governance | ⬜ Planned | 18–24 hrs |
| Phase 7 | Search / Website / Zoho APIs | ⬜ Planned | 20–28 hrs |
| Phase 8 | Zoho Creator integration/UAT | ⬜ Planned | 20–28 hrs |
| Phase 9 | Website integration/UAT | ⬜ Planned | 18–24 hrs |
| Production readiness | Performance, cutover, hypercare | ⬜ Planned | 18–26 hrs |

**Planning-equivalent remaining envelope:** approximately **174–238 hrs**. This remains an engineering planning estimate rather than a timesheet claim.

---

## 3. Phase 3 — Layer 1 Regulatory Pipeline

### Reference runtime flow

`Country Settings → Source Resolver → Country Adapter → Fetch → Evidence/Hash → Reconciliation → Canonical Catalogue → Conflict Review → Source/Job Health`

### Delivered Worker controls

- service-role-only DB operations;
- Worker endpoint protection;
- dry-run by default unless `apply=true`;
- optional Pilot record cap;
- private evidence snapshots;
- content hashing;
- source-health timestamps/error state;
- pipeline Jobs visibility;
- conservative identity matching;
- batching and idempotent registration keys.

### Australia / CRICOS

Official dataset discovery uses data.gov.au configuration stored in Regulatory Settings. The reference adapter resolves and retrieves:

- CRICOS Institutions CSV;
- CRICOS Courses CSV.

The official CRICOS dataset is the bulk regulatory snapshot. Live CRICOS remains the latest point-look-up reference.

### AU exit gate

AU Layer 1 is complete when:

- Worker deploy is healthy;
- runtime secrets are configured;
- 100-record dry-run succeeds;
- evidence and hashes are retained;
- 100-record apply reconciles as expected;
- repeat apply creates no duplicate identities;
- locations/campuses are reconciled;
- full AU dataset applies successfully;
- conflicts route to Layer 4 rather than silent merge;
- Search Projection rebuild is tested after approved changes.

---

## 4. Immediate Phase 3 Execution Plan

### Step 3.1 — Runtime deployment UAT

- verify Cloudflare build after Pilot commit `3ab609cf5bc86e87b6d24357050c4989461666f2`;
- confirm SPA login still works;
- confirm `/api/layer1/health` reaches Worker code.

### Step 3.2 — Runtime secrets

Configure in Cloudflare Worker:

- `SUPABASE_SERVICE_ROLE_KEY`;
- `LAYER1_RUN_KEY`.

Do not commit either value to GitHub.

### Step 3.3 — AU dry-run

Run AU with:

- `apply=false`;
- `maxRecords=100`.

Validate source resolution, two CSV downloads, evidence, hashes, Jobs and source health without catalogue mutation.

### Step 3.4 — AU limited apply

Run:

- `apply=true`;
- `maxRecords=100`.

Review provider/course registrations and conflict counts.

### Step 3.5 — AU idempotency

Repeat exactly the same 100-record apply and confirm no duplicate provider/course identity creation.

### Step 3.6 — Locations/Campuses

Add:

- CRICOS Locations CSV;
- CRICOS Course Locations CSV;
- provider campus identity;
- course-campus relationships;
- location evidence.

### Step 3.7 — Full AU apply

Process the complete current CRICOS snapshot after reconciliation sign-off.

### Step 3.8 — Remaining countries

Use the proven adapter framework in this order:

1. Canada — IRCC DLI;
2. Germany — HRK Hochschulkompass;
3. United Kingdom — OfS + Discover Uni;
4. Ireland — QQI;
5. New Zealand — NZQA + Education Counts;
6. United States — College Scorecard.

---

## 5. Phase 1 UI Work in Parallel

The UI remains an active parallel stream:

- Provider detail workspace;
- PIM Families;
- Attribute Groups;
- Attribute Options;
- Completeness Profiles;
- Evidence Viewer;
- source/job detail drill-down;
- role-aware actions;
- paging/filter/sort/saved state;
- controlled write framework.

Priority should be given to **Evidence Viewer + Job/Source detail** because they directly support Layer 1 UAT.

---

## 6. Phase 2 Canonical Expansion

Do not bulk-migrate the demo catalogue until Layer 1 stable identity is proven.

After AU/initial country UAT:

- reconcile broader provider/course data against regulator identities;
- retain regulatory identifiers and evidence;
- migrate only trusted enrichment facts;
- exclude demo security/config debt;
- rebuild Search Projection;
- regenerate embeddings under active profiles.

---

## 7. Production Readiness Items Carried Forward

- enable leaked-password protection in Supabase Auth before production;
- evaluate replacing Pilot authenticated SECURITY DEFINER read RPCs with a dedicated API/Edge layer if zero-WARN security posture is required;
- configure Worker monitoring/alerting;
- retry/backoff and scheduled Layer 1 execution;
- source freshness SLA;
- API rate limiting;
- evidence retention policy verification;
- backup/restore and migration reproduction;
- User/Admin Guide updates after each UAT milestone.

---

## 8. Next Major Milestone

> **Australia Layer 1 UAT complete: CRICOS automatically resolves from Settings, fetches official source CSVs, stores evidence, reconciles provider/course identities, records job/source health and can be rerun idempotently.**

After this milestone, the adapter pattern can be replicated across the remaining Pilot countries and Phase 2 catalogue expansion can begin safely.

---

## Revision History

### v1.7

- Phase 0A marked complete.
- Phase 3 marked in progress.
- AU CRICOS reference Worker recorded.
- Adds runtime secret/deployment gates and progressive AU UAT sequence.
- Revises remaining delivery estimate.
