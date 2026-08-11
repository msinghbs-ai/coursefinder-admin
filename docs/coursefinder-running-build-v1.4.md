# Coursefinder — Running Build v1.4

**Status:** Active Pilot build record  
**Environment:** `coursefinder_Pilot` — Mumbai (`ap-south-1`)  
**Supabase project ref:** `fxcwkweaxjtknorudmwp`  
**Pilot code:** `msinghbs-ai/Coursefinder-Pilot`  
**Architecture / planning / UAT records:** `msinghbs-ai/coursefinder-admin`

---

## 1. Current Build Position

Coursefinder has moved beyond database/UI foundation into an operational Pilot control-plane stage.

### Completed

- Clean Mumbai Supabase Pilot deployed.
- Production-model multi-schema database built through migration **027**.
- 7-provider / 35-course UI seed available.
- Search Projection available for the Pilot seed.
- Supabase Auth login validated.
- Vite/React Pilot deployed through GitHub → Cloudflare Worker workflow.
- Catalogue UI available for Providers, Campuses, Course Collections, Courses, Course Detail, Scholarships and Categories.
- PIM/quality/operations views available for Attributes, Completeness, Review Queue, Pipeline and Jobs.
- **Phase 1A — Super Admin Regulatory Settings implemented.**
- Current Pilot user assigned `platform_admin` rank 6.
- User Guide and Admin Guide are maintained in the Admin repository.

---

## 2. Phase 1A — Regulatory Settings

**Status: IMPLEMENTED — deployment/runtime visual verification pending after latest merge.**

### Database

Migration **026 — Regulatory Settings Final**:

- adds source health fields to `pipeline.sources`:
  - `last_checked_at`
  - `last_success_at`
  - `last_failure_at`
  - `last_error`
  - `metadata`
- replaces the initial Regulatory Settings RPC so Pilot-status countries are included;
- restricts the UI source registry to Platform Admin;
- creates service-role-only `pipeline.resolve_regulatory_sources(country)` for Layer 1 Worker source resolution.

Migration **027 — Regulatory Source Seed**:

- seeds authoritative systems/source configuration for all seven active Pilot countries;
- supports multiple sources per country where coverage differs;
- records acquisition method, coverage, auth requirement and trust order as configuration.

### Seeded source model

| Country | Source configuration | Trust |
|---|---|---:|
| Australia | CRICOS | 10 |
| Canada | IRCC Designated Learning Institutions | 10 |
| Germany | HRK Hochschulkompass | 10 |
| United Kingdom | Office for Students Register | 10 |
| United Kingdom | Discover Uni | 20 |
| Ireland | Irish Register of Qualifications | 10 |
| New Zealand | NZQA Education Organisations | 10 |
| New Zealand | Education Counts tertiary directory | 20 |
| United States | Department of Education College Scorecard | 10 |

### UI

Pilot PR #3 merged to `main`:

`c5807bd6de10b65a77d9836ea97e5efdb92b39f6`

Settings now provides:

- Platform Admin role gating;
- Pilot country count;
- configured-country count;
- authoritative-source count;
- source method;
- coverage;
- auth requirement;
- trust priority;
- status;
- health/last-success field;
- direct authoritative-source link;
- Worker resolution explanation.

Backend validation returned **7 configured Pilot countries / 9 source records**.

---

## 3. Layer 1 Runtime Contract

Layer 1 Workers must not contain scattered country URLs.

Runtime resolution pattern:

`Country → pipeline.resolve_regulatory_sources() → ordered active source(s) → system config → runtime secret → adapter`

The Worker will write operational health back to `pipeline.sources` and processing status to pipeline job/evidence structures.

Expected telemetry:

- last checked;
- last success;
- last failure;
- latest error;
- evidence/content hash;
- job status and duration.

---

## 4. Current Security State

### Completed controls

- browser uses curated RPC/API boundary;
- Platform Admin Settings RPC checks role rank server-side;
- Worker source resolver is service-role only;
- service-role credential is not used by the browser;
- regulator/source URLs are stored as controlled configuration rather than frontend constants.

### Blocking security gate

**Phase 0A — RLS / privilege hardening remains mandatory before formal UAT sign-off.**

The previously identified internal-table RLS/privilege gap must be closed and Supabase Security Advisor rerun. No broad browser policies should be added merely to remove informational findings.

---

## 5. Supabase Studio Visual Expectations

The domain model is distributed across schemas such as:

`catalogue`, `pim`, `pipeline`, `integration`, `search`, `workflow`, `scholarship`, `security`, `publishing`, `ref` and `api`.

If Studio is left on `public`, the table editor/schema visualiser can appear almost empty. This is expected. `public` is primarily the curated browser/RPC boundary rather than the canonical domain schema.

---

## 6. Current Pilot Data Limitations

The current UI seed is intentionally small. Layer 2 enrichment has not yet populated all course detail sections, therefore fees, intakes, English requirements, Course Collections, Academic Options or evidence may be empty for some seeded records.

Do not interpret an empty UI section as an absent database capability.

---

## 7. Immediate Next Build Sequence

### Gate A — Verify latest Cloudflare deployment

Confirm the build after Pilot commit `c5807bd6de10b65a77d9836ea97e5efdb92b39f6` and validate:

- login;
- Platform Admin role display;
- Settings visibility;
- Regulatory Sources table;
- all seven countries and nine source rows;
- source links and coverage display.

### Gate B — Phase 0A security hardening

- enable/harden RLS and privileges on internal domain tables;
- validate every browser RPC after hardening;
- rerun Security Advisor;
- close Critical/Error findings.

### Build C — Phase 3 Layer 1 Worker

- resolve configured source(s) by country;
- implement source adapters;
- health-check sources;
- collect evidence/content hashes;
- create job telemetry;
- reconcile stable provider/course identities;
- send ambiguous changes to Layer 4.

### Build D — Remaining Phase 1 UI in parallel

- Provider Detail;
- PIM Families;
- Attribute Groups;
- Attribute Options;
- Completeness Profiles;
- Evidence Viewer;
- role-aware action framework;
- pagination/filter/sort/saved table state.

---

## 8. Deployment Notes

Cloudflare control-plane access is not directly connected to the current ChatGPT session. Deployment is managed through committed GitHub configuration and validated through Cloudflare logs / the deployed Worker URL.

`wrangler.jsonc` is committed in the Pilot repository to define the `dist` static asset deployment and SPA fallback.

---

## 9. Repository Boundary

### `Coursefinder-Pilot`

Code/runtime only:

- React/UI;
- API clients;
- Worker/runtime code;
- tests;
- build/deployment config.

### `coursefinder-admin`

All governance artefacts:

- architecture;
- database design;
- migrations and deployment record;
- project plan;
- running build;
- UAT evidence;
- User Guide;
- Admin Guide;
- roadmap;
- decisions and handover.

---

## Revision History

### v1.4

- Marks Phase 1A Regulatory Settings implemented.
- Records migrations 026–027.
- Records seven-country / nine-source Layer 1 registry.
- Records Platform Admin role gating and Layer 1 service resolver.
- Defines immediate security and Layer 1 Worker next steps.
