# Coursefinder — Running Build v1.0

**Status:** Active running build record  
**Environment:** `coursefinder_Pilot`  
**Supabase project ref:** `fxcwkweaxjtknorudmwp`  
**Region:** Mumbai (`ap-south-1`)  
**Purpose:** Record the exact current build state, deployment assumptions, validation checkpoints, known issues and next actions. Update this document whenever the environment materially changes.

---

## 1. Environment State

- Authoritative Pilot/UAT database: `coursefinder_Pilot`.
- Supabase organisation: `techM`.
- Plan: Free.
- Region: Mumbai (`ap-south-1`).
- Earlier Australia Southeast `Coursefinder_Prod` project is paused/superseded for this Pilot.
- Historical `coursefinder-demo` remains source/validation only and must not be treated as the target schema.
- New clean GitHub Pilot repo and Cloudflare Worker are pending creation by the project owner.

---

## 2. Applied Database Build

Production migrations applied in Mumbai through `023`:

1. `001_schemas_extensions`
2. `002_reference_core`
3. `003_security_rbac`
4. `004_pim_core`
5. `005_catalogue_core`
6. `006_academic_options_provider_associations`
7. `007_scholarships`
8. `008_integrations_pipeline_evidence`
9. `009_layer4_workflow`
10. `010_publishing`
11. `011_search_projection`
12. `012_pgvector_embeddings_cache`
13. `013_api_contracts`
14. `014_import_export`
15. `015_migration_utilities`
16. `016_baseline_seed`
17. `017_ui_seed_slice`
18. `018_search_projection_rebuild`
19. `019_fk_index_hardening`
20. `020_private_evidence_storage`
21. `021_ui_api_bridge`
22. `022_ui_compatibility_views`
23. `023_ui_bridge_security_hardening`

All new DB changes must continue as numbered Git-tracked migrations.

---

## 3. Current Schema Map

### `ref`
Global controlled/reference data: countries, regions, subdivisions, currencies, languages, study levels, fields of study, provider types, English tests, institution collections and ranking sources.

### `catalogue`
Providers, identifiers, aliases, registrations, campuses, provider group membership/rankings, Course Collections, Courses, Collection memberships, course registrations/campuses/fees/intakes/English requirements, Course Academic Options and Provider Associations.

### `pim`
Attribute Families, Attribute Groups, Family/Group mappings, Attribute Definitions, Family Attributes, Options, Categories, Entity Registry, Attribute Values, Entity Categories and Completeness Profiles/Requirements.

### `scholarship`
Scholarships, award tiers, scopes, criteria and coverage.

### `integration` / `pipeline`
Integration systems, extraction/model profiles, sources, acquisition policies, jobs, evidence and claims.

### `workflow`
Review Queue/Actions, suggestions, import/export jobs, migration runs/entity maps, reconciliation and handover events.

### `search`
Search Profiles, intent aliases, Search Projection, projection state, course embeddings, embedding cache and embedding jobs.

### `publishing`
Channels and entity publication state.

### `security`
Roles, user-role assignments and service permissions.

### `public`
Curated API/RPC and transitional compatibility surface only. Canonical relational tables are intentionally not modelled in `public`.

---

## 4. Supabase Studio Visual Expectations

### Expected visual behaviour

Supabase Studio may initially appear empty or nearly empty when the **schema selector is set to `public`**. This is expected and does not mean the Pilot database is empty.

To inspect the relational model:

- select `catalogue` for Providers/Courses/Collections;
- select `pim` for PIM tables;
- select `search` for Search Projection/vector support;
- select `workflow` for review/import/migration state;
- select `scholarship`, `pipeline`, `ref`, etc. as required.

The Schema Visualizer may need to be scoped per schema. The multi-schema separation is intentional and is part of the production architecture.

### Current row verification

Direct DB verification on 11 Aug 2026 shows:

| Table | Rows |
|---|---:|
| `catalogue.providers` | 7 |
| `catalogue.courses` | 35 |
| `pim.entity_registry` | 42 |
| `search.course_documents` | 35 |
| `search.intent_aliases` | 22 |
| `workflow.migration_entity_map` | 42 |
| `search.projection_state` | 1 |
| `workflow.migration_runs` | 1 |

So an empty-looking Studio view should first be treated as a **schema-selection/UI issue**, not a data-loss assumption.

---

## 5. Pilot Seed / Search State

- UI seed: 7 Australian providers.
- UI seed: 35 technology/data/AI/cyber courses.
- Search Projection: 35 course documents.
- Projection generation: 2.
- pgvector/HNSW structure exists.
- Course embeddings in the Mumbai Pilot are intentionally not copied from the demo and remain to be regenerated from canonical Mumbai data.
- Query embedding cache exists but should not be seeded from historical/demo cache rows.

---

## 6. Current Security State

### Completed hardening

- `service_role` remains server-side only.
- Private evidence bucket exists with no anonymous object access.
- UI bridge requires authenticated Supabase sessions.
- Security Definer View errors introduced by the temporary compatibility layer were remediated by migration `023` using hardened/security-invoker compatibility views.
- Foreign-key covering indexes were added after Performance Advisor review.
- No historical anonymous demo write policies were copied intentionally.

### OPEN — Mandatory RLS hardening

Supabase DB inspection currently flags **61 internal tables with RLS disabled** across `ref`, `catalogue`, `scholarship`, `integration`, `pipeline`, `workflow`, `publishing` and `search`.

**Status:** BLOCKING before formal UI/UAT security sign-off.

Planned remediation:

1. Enable RLS on the affected internal tables via a numbered migration.
2. Review direct schema/table grants to `anon` and `authenticated`.
3. Avoid broad client policies.
4. Keep browser consumption through curated API/RPC contracts.
5. Add minimum authenticated policies only where explicitly required.
6. Re-test the authenticated UI/API bridge after hardening.
7. Re-run Security Advisor.
8. Record all accepted INFO/WARN findings and resolve Critical/Error findings.

Do not perform the RLS change as an undocumented dashboard change.

---

## 7. Current API / UI Boundary

- Curated authenticated UI RPC bridge is deployed.
- Transitional compatibility views exist only to allow UI migration from the historical admin shape.
- New UI work should use explicit v2.9.1 RPC/API contracts rather than making the compatibility layer permanent.
- Browser must use the Supabase publishable key only.
- No direct browser access to canonical private schemas should be introduced.

Current Pilot endpoint base:

`https://fxcwkweaxjtknorudmwp.supabase.co`

The publishable key is configuration/secrets material and must not be embedded in documentation beyond environment-variable usage.

---

## 8. Performance State

Validated historical pilot baselines retained for comparison:

- canonical representative search: ~24 ms;
- Search Projection FTS: ~1.25 ms;
- representative FTS improvement: ~19x;
- 1,000 canonical serial searches: ~23.99 s;
- 1,000 projected serial searches: ~1.71 s;
- serial projected-search improvement: ~14x;
- HNSW vector top-20 warm: ~10.8 ms;
- hybrid FTS + vector + fusion warm: ~36.9 ms.

These are pilot micro-benchmarks, not production SLAs. Re-baseline after full catalogue migration and representative embeddings/traffic.

Performance Advisor FK-index gaps were remediated. Unused-index INFO findings on a new low-traffic Pilot are expected and are not grounds for premature index removal.

---

## 9. Known Open Work

### Immediate

1. Create clean Pilot GitHub repo.
2. Create/configure new Cloudflare Worker/application.
3. Carry approved migrations/docs into the clean repo.
4. Apply RLS/privilege hardening migration.
5. Re-run Security Advisor and browser-contract tests.
6. Create Mumbai Auth UAT user(s) and role assignments.
7. Begin PIM-style UI build.

### Pilot delivery

- wider canonical data migration;
- Layer 1–4 worker/pipeline promotion;
- Layer 2 evidence/enrichment;
- scholarship normalisation/matching;
- full Search Projection and embedding generation;
- Website API;
- Zoho API integration;
- Website/Zoho UAT;
- performance/load/resilience UAT;
- production readiness and cutover.

---

## 10. Running Build Update Rule

Update this file whenever any of the following changes:

- project/region/environment;
- applied migration number;
- schemas/tables/API contracts;
- security or advisor state;
- UAT data counts;
- Search Projection generation;
- embedding coverage;
- Worker/UI deployment state;
- known blockers;
- production-readiness status.

For material architecture/schema changes, create a new versioned architecture/database document as well. For optimisation ideas, update the Improvements & Performance Roadmap rather than silently changing production design.

---

## 11. Revision Log

### v1.0

- Created as the first dedicated running-build record.
- Captures Mumbai migration state through 023.
- Records expected Supabase Studio multi-schema visual behaviour.
- Records verified table/row baseline.
- Adds the 61-table RLS hardening issue as an explicit blocking security task.
