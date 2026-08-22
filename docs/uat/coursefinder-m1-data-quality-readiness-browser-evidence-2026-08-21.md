# CourseFinder M1-DATA-QUALITY-READINESS — Deployed Browser Evidence

**Evidence dates:** 21–22 August 2026  
**Change Control:** `CF-CHG-20260821-018`  
**Runtime:** `coursefinder-pilot.techm.workers.dev`  
**Evidence source:** authenticated operator screenshots plus correlated Supabase API/Postgres telemetry  
**Browser evidence result:** **PASS — COMPLETE DEPLOYED OPERATIONAL CHAIN PROVEN**

## 1. Runtime/authentication — PASS

Authenticated screenshots prove the actual Worker serves:

`PIM Admin v2.12 · Pipeline Ops v1.0 · Evidence v1.0 · Data Quality v1.0 · governed`

The session is an authorised Platform Admin browser session.

## 2. Catalogue regression and semantic relabel — PASS

Browser evidence proves:

- AU Course Catalogue: **26,648**;
- all-country Course Catalogue: **43,461**;
- CRICOS tuition renders, including legitimate `AUD 0`;
- historical six-signal Course percentage is labelled **Legacy presence**;
- historical filter is labelled **Min legacy presence**.

The legacy score remains backward-compatible presentation/history context and is not represented as governed domain readiness.

## 3. Data Quality overview — PASS

The deployed `Data Quality & Readiness` workspace renders under AU+NZ scope and visibly states `No composite completeness score`.

All governed states are present:

`Present / Source-null / Not applicable / Zero / Suppressed / Not yet enriched / Stale / Ambiguous / Rejected`.

Representative deployed values match the live governed contract:

- Identity: Course 33,105; Provider 1,955; Campus 3,922; Scholarship 4 — 100%;
- Course geography: **26,614 present / 34 source-null / 6,457 not-yet-enriched / 80.39%**;
- Course taxonomy: **26,648 present / 6,457 not-yet-enriched / 80.50%**;
- Course regulatory fee: **26,326 present / 191 source-null / 6,457 not-applicable / 131 zero / 99.28%**.

This visibly preserves legitimate zero values and NZ non-applicability rather than treating either as missing.

## 4. Exceptions/paging — PASS

The deployed `Exceptions & decision context` page proves:

- context: Regulatory fee · Course · Source-null;
- scope: AU+NZ;
- total: **191 records**;
- source: `CRICOS Providers, Courses and Locations`;
- real Evidence links are displayed where the read contract supplies an evidence ID.

All bounded pages were independently captured:

- **1–50 of 191**;
- **51–100 of 191**;
- **101–150 of 191**;
- **151–191 of 191**.

Paging therefore operates against the real 191-record exception population rather than a local fixture.

## 5. Canonical Course drill-down — PASS

A canonical Course opened from the exception workflow. The detail retained:

- canonical identity and Provider context;
- Field/Study Level;
- lifecycle/publication state;
- CRICOS registered fee versus Provider-current fee semantics;
- Search/publication state;
- Intake/English;
- taxonomy lineage;
- Campus;
- Evidence and Regulatory Facts.

The exception → canonical Course link therefore preserves governed provenance context.

## 6. Evidence detail navigation — PASS

On 22 August 2026 at approximately 13:30 AEST, a real Evidence link from the accepted workflow opened the deployed Evidence detail workspace.

The screenshot visibly proves:

- page: **Evidence Artifact**;
- artifact type: **Regulatory Snapshot**;
- source: **CRICOS Providers, Courses and Locations**;
- **PRIVATE EVIDENCE BOUNDARY**;
- acquisition job: `regulatory_sync`;
- extracted observations/claims: **103,315**;
- affected/linked canonical entities: **25,500**;
- reviews: **0**;
- Source authority/acquisition, storage/content hash, acquisition job, extracted observations and affected canonical entity sections all render.

This directly proves the corrected `evidence_id` route and closes:

`Data Quality aggregate → Exception → canonical Course → Evidence artifact`.

No synthetic Review item was introduced merely to satisfy UAT.

## 7. Browser-time telemetry

Earlier accepted windows on 21 August correlated with successful `POST /rest/v1/rpc/admin_read` HTTP 200 traffic for overview, Exceptions and Course navigation.

The final Evidence interaction on 22 August around 13:29–13:30 AEST also correlates with repeated successful `admin_read` HTTP 200 requests, including four successful requests around 13:30:08 AEST.

Two statement timeouts occurred earlier in the broader 22 August session, around 13:24 and 13:26 AEST. API logs do not expose `p_operation`, so these are not attributed to a specific Data Quality/Evidence operation without evidence. The required Evidence navigation subsequently completed successfully.

This limitation is explicitly carried into `M1-UAT-HARNESS`: future automated deployed-browser runs must retain network/console evidence and fail on unexpected 5xx responses instead of relying on retrospective manual log correlation.

## 8. Verdict

| Browser gate | Result |
|---|---|
| Correct Worker/current Data Quality bundle served | **PASS** |
| Authenticated Platform Admin session | **PASS** |
| AU Course Catalogue — 26,648 | **PASS** |
| All-country Course Catalogue — 43,461 | **PASS** |
| `Legacy presence` semantic relabel | **PASS** |
| Data Quality workspace / no composite score | **PASS** |
| Nine-state vocabulary | **PASS** |
| Regulatory fee 26,326 / 191 / 6,457 / 131 | **PASS** |
| Exception total = 191 | **PASS** |
| All four exception pages | **PASS** |
| Canonical Course navigation | **PASS** |
| Evidence linkage retained | **PASS** |
| Real Evidence detail route | **PASS** |
| Private Evidence boundary visible | **PASS** |

### Final CF-CHG-018 browser state

**PASS — DEPLOYED END-TO-END OPERATIONAL UAT COMPLETE.**

The browser evidence is sufficient to close `CF-CHG-20260821-018`. Future routine browser regression should move to the governed automated UAT harness rather than requiring operator screenshot sequences.