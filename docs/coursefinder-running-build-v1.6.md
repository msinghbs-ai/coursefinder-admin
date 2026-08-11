# Coursefinder — Running Build v1.6

**Status:** Active Pilot build record  
**Environment:** `coursefinder_Pilot` — Mumbai (`ap-south-1`)  
**Supabase project ref:** `fxcwkweaxjtknorudmwp`  
**Pilot code:** `msinghbs-ai/Coursefinder-Pilot`  
**Architecture / planning / UAT records:** `msinghbs-ai/coursefinder-admin`

---

## 1. Current Position

Coursefinder is now in **Phase 3 — Layer 1 Regulatory Worker**, with the AU/CRICOS reference adapter implemented in code and database service contracts deployed.

### Completed foundation

- Phase 0 runtime/bootstrap complete.
- Phase 0A RLS/privilege hardening complete.
- Phase 1A Regulatory Settings implemented.
- 76/76 internal domain tables RLS enabled.
- 0 direct internal-table access for `anon` or `authenticated`.
- Browser remains on curated authenticated RPC boundary.
- Seven Pilot countries / nine regulatory source records configured.
- Layer 1 service-only source resolver deployed.
- Layer 1 Worker baseline merged into Pilot main.

---

## 2. Database Migration Position

Production-model migrations are applied through **031**.

### 029 — Layer 1 Worker Service Contract

Introduces service-role-only RPCs for:

- country source resolution;
- regulatory job start/finish;
- source health telemetry;
- evidence registration;
- AU CRICOS provider/course reconciliation.

CRICOS reconciliation is conservative:

1. use existing CRICOS registration where present;
2. otherwise exact-normalised AU provider/course match;
3. attach registration only when the match is unique;
4. otherwise create a new regulator-keyed entity when there is no match;
5. ambiguous matches are counted as conflicts and are not auto-merged.

### 030–031 — AU CRICOS Acquisition Configuration

AU source metadata now contains:

- CKAN discovery endpoint;
- dataset slug;
- preferred resource format;
- required direct CSV resources:
  - `CRICOS Institutions.csv`
  - `CRICOS Courses.csv`.

The Worker therefore resolves acquisition endpoints from Settings/configuration rather than hard-coding regulator URLs into the frontend.

---

## 3. Pilot Worker Build

Pilot PR #4 merged to `main`:

`3ab609cf5bc86e87b6d24357050c4989461666f2`

### Worker runtime

`worker/index.js`

Routes:

- `GET /api/layer1/health`
- `POST /api/layer1/run`

`/api/*` runs Worker-first while all normal routes continue to serve the Vite SPA through the Cloudflare Assets binding.

### AU CRICOS adapter

Implemented capabilities:

- resolve AU source from Supabase Settings;
- discover current CRICOS resources through data.gov.au CKAN metadata;
- fetch Institutions and Courses CSVs;
- SHA-256 content hashing;
- upload regulatory evidence into private `evidence` bucket;
- create evidence metadata records;
- create/update pipeline job state;
- update source health state;
- parse provider/course identities;
- support dry-run and apply modes;
- optional record cap for Pilot/UAT;
- batch reconciliation at 250 records per RPC;
- idempotent registration-based reruns.

---

## 4. Runtime Secrets / Deployment Dependency

The Worker deliberately contains no service-role secret in GitHub.

Cloudflare Worker must have these secrets before Layer 1 execution:

- `SUPABASE_SERVICE_ROLE_KEY`
- `LAYER1_RUN_KEY`

Non-secret `SUPABASE_URL` is committed in Wrangler configuration for the Mumbai Pilot project.

Until both secrets are configured:

- the SPA can still deploy and operate;
- `/api/layer1/health` reports runtime configuration state;
- `/api/layer1/run` cannot perform a regulatory sync.

---

## 5. AU Reference Adapter UAT Sequence

### UAT-A — Worker deployment

Validate:

- Cloudflare build succeeds;
- existing SPA/login remains available;
- `/api/layer1/health` returns Worker version;
- API route does not fall through to SPA.

### UAT-B — Secret configuration

Add Worker secrets in Cloudflare and confirm health reports configured.

### UAT-C — CRICOS dry-run

Run AU with:

- `apply=false`;
- `maxRecords=100` initially.

Validate:

- source resolution;
- current CRICOS CSV discovery;
- private evidence objects;
- SHA-256 hashes;
- job completion;
- source last-check/last-success;
- parser record count;
- no catalogue mutations.

### UAT-D — Limited apply

Run:

- `apply=true`;
- `maxRecords=100`.

Validate:

- provider/course registrations;
- exact-match linkage;
- new regulator-keyed entities only where required;
- conflict count;
- no duplicate CRICOS registration identity;
- search projection remains intentionally separate until reconciliation review.

### UAT-E — Idempotency

Repeat the same 100-record apply and confirm no duplicate providers/courses/registrations are created.

### UAT-F — Full AU apply

After reconciliation review, remove the record cap and process the full current CRICOS Courses dataset.

---

## 6. Remaining Phase 3 Work

### AU adapter completion

- CRICOS Locations CSV;
- CRICOS Course Locations CSV;
- campus/location reconciliation;
- provider-registration evidence split where useful;
- explicit conflict queue routing to Layer 4;
- deleted/expired registration handling between snapshots;
- incremental/change comparison using content hashes;
- Search Projection rebuild after approved canonical changes.

### Other country adapters

After AU reference UAT:

1. Canada — IRCC DLI;
2. Germany — HRK Hochschulkompass;
3. United Kingdom — OfS + Discover Uni;
4. Ireland — QQI;
5. New Zealand — NZQA + Education Counts;
6. United States — College Scorecard.

---

## 7. Current Risks / Improvements

- Cloudflare control-plane is not connected to this ChatGPT session; runtime secrets and deployment logs require user-side confirmation.
- CRICOS source is a snapshot export; the CRICOS live register remains the freshest point lookup source.
- Exact-name matching is intentionally conservative; fuzzy matching should be review-assisted rather than silently merging identities.
- Full AU processing should be preceded by 100-record UAT and idempotency testing.
- Worker observability and retry/backoff should be expanded after the first successful AU run.

---

## 8. Immediate Next Actions

1. Verify Cloudflare build for Pilot commit `3ab609cf...`.
2. Configure `SUPABASE_SERVICE_ROLE_KEY` and `LAYER1_RUN_KEY` as Worker secrets.
3. Call `/api/layer1/health`.
4. Run AU dry-run with 100 records.
5. Review Jobs, source health and evidence.
6. Run AU apply with 100 records.
7. Repeat the same apply to prove idempotency.
8. Add location/campus ingestion.
9. Full AU reconciliation.
10. Begin Canada adapter.

---

## Revision History

### v1.6

- Phase 3 started.
- Records migrations 029–031.
- Records Pilot Worker PR #4 and AU CRICOS adapter.
- Defines runtime-secret dependency and AU progressive UAT sequence.
