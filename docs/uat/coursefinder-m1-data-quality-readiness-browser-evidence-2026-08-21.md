# CourseFinder M1-DATA-QUALITY-READINESS — Deployed Browser Evidence

**Date:** 21 August 2026  
**Change Control:** `CF-CHG-20260821-018`  
**Runtime:** `coursefinder-pilot.techm.workers.dev`  
**Evidence windows:** approximately 21:55 AEST and 22:08 AEST  
**Evidence source:** authenticated operator screenshots supplied in the originating `M1-DATA-QUALITY-READINESS` chat plus correlated Supabase API/Postgres telemetry  
**Browser evidence result:** **PARTIAL PASS — deployment, Catalogue regression, legacy-label correction and Data Quality overview PASS; exception-page/Course/Evidence drill-down remains pending**

## 1. Deployed runtime and authentication

Authenticated mobile-browser screenshots prove the actual Worker is serving the Data Quality v1.0 runtime.

Observed marker:

`PIM Admin v2.12 · Pipeline Ops v1.0 · Evidence v1.0 · Data Quality v1.0 · governed`

The visible mature Admin session is `Platform Admin`.

**Result: PASS.**

## 2. Catalogue regression and legacy-label correction

### Australia scope

Browser evidence shows:

- page: Courses;
- Country filter: Australia;
- matching Courses: **26,648**;
- CRICOS tuition values render, including a legitimate `AUD 0` value;
- verified dates render;
- Data Quality v1.0 governed marker is present.

The count matches the accepted AU canonical Course baseline.

### All-country scope

Earlier deployed-browser evidence shows:

- Country filter: All;
- matching Courses: **43,461**;
- no visible permission/RPC failure.

The count matches the canonical all-country Course inventory recorded at CF-CHG-018 initiation.

### Legacy six-signal score labelling

The initial browser pass exposed the historical six-signal Course percentage under the generic labels `Readiness` and `Min readiness`. That was classified as a semantic-labelling defect because the historical percentage is not the governed cross-domain readiness model.

Pilot PR #19 changed presentation only:

- `Readiness` → `Legacy presence`;
- `Min readiness` → `Min legacy presence`.

The 22:08 AEST screenshot proves both corrected labels are now deployed. The underlying historical calculation/filter contract was not changed.

**Catalogue regression: PASS.**  
**Legacy-score semantic labelling: PASS.**

## 3. Data Quality workspace deployed-browser evidence

The 22:08 AEST screenshot directly proves navigation to the deployed Data Quality workspace.

Visible page:

`Data Quality & Readiness`

Visible policy:

`No composite completeness score`

The page explicitly states that completeness is shown by governed domain rather than as one equal-weight product score.

Scope shown: **AU + NZ**.

All nine governed metric-state labels are visibly rendered:

- Present;
- Source-null;
- Not applicable;
- Zero;
- Suppressed;
- Not yet enriched;
- Stale;
- Ambiguous;
- Rejected.

**Result: PASS.**

## 4. Domain metric spot-checks from deployed browser

The displayed AU+NZ values match the live governed backend contract.

### Identity completeness

| Entity | Scope / applicable | Readiness | Present |
|---|---:|---:|---:|
| Campus | 3,922 / 3,922 | 100% | 3,922 |
| Course | 33,105 / 33,105 | 100% | 33,105 |
| Provider | 1,955 / 1,955 | 100% | 1,955 |
| Scholarship | 4 / 4 | 100% | 4 |

### Regulatory completeness

- Course: 33,105 present / 100%;
- Provider: 1,955 present / 100%.

### Geography / delivery

- Campus: 3,922 present / 100%;
- Provider: 1,955 present / 100%;
- Course: **26,614 present / 34 source-null / 6,457 not-yet-enriched / 80.39%**.

This preserves the accepted distinction between 34 AU CRICOS source-absent Course Location relationships and NZ geography not yet enriched.

### Taxonomy

Course: **26,648 present / 6,457 not-yet-enriched / 80.50%**.

### Regulatory fee

Course scope: **33,105**; applicable: **26,648**; readiness: **99.28%**.

Visible state counts:

- Present: **26,326**;
- Source-null: **191**;
- Not applicable: **6,457**;
- Zero: **131**.

This is the required aggregate semantic result. The 131 numeric zero values are visibly separated from missing data and NZ CRICOS-specific tuition is excluded as not applicable.

**Aggregate/domain metric browser UAT: PASS.**

## 5. Browser-time governed RPC telemetry

The 22:07–22:08 AEST browser interaction correlates with **11 successful** API calls to:

`POST /rest/v1/rpc/admin_read` → HTTP 200

Observed current-window groups:

- 22:07:34 AEST — five HTTP 200 calls;
- 22:07:53 AEST — two HTTP 200 calls;
- 22:08:17 AEST — four HTTP 200 calls.

No new HTTP 500 appears in this fresh interaction window. Postgres telemetry shows no new statement-timeout error aligned with the 22:07–22:08 AEST interaction.

The stale legacy `ui_context` / `ui_dashboard` requests previously observed around 21:53 AEST do not recur in the fresh current-window sequence.

The API service log does not expose the `p_operation` argument, so individual calls are not falsely attributed to a specific operation. The screenshot timing and route render prove that the current Data Quality browser interaction is occurring while the governed `admin_read` boundary is completing successfully.

**Governed browser RPC / no-repeat-timeout check: PASS for the current interaction window.**

## 6. Remaining deployed-browser acceptance

The aggregate `Source-null = 191` count is now visually proven. What remains is the operational drill-down itself:

1. select **Regulatory fee → Course → Source-null** and prove the Exceptions view reports total **191**;
2. prove paging/next-page behaviour on that exception population;
3. open a canonical Course from an exception row and prove the intended Course detail route loads;
4. where an `evidence_id` is supplied, open linked Evidence and prove the Evidence detail route loads.

A Review navigation check is not required merely to manufacture evidence: `workflow.review_queue` had zero rows at implementation and no synthetic Review item is authorised. Review linkage remains conditional on a real governed review row being present.

## 7. Verdict

| Browser gate | Result |
|---|---|
| Correct Worker/current Data Quality bundle served | **PASS** |
| Data Quality v1.0 marker visible | **PASS** |
| Authenticated Platform Admin session | **PASS** |
| AU Course Catalogue regression — 26,648 | **PASS** |
| All-country Course Catalogue regression — 43,461 | **PASS** |
| Legacy score labelled `Legacy presence` / `Min legacy presence` | **PASS** |
| Data Quality workspace navigation/render | **PASS** |
| AU+NZ overview/domain cards | **PASS** |
| All nine governed state labels | **PASS** |
| Regulatory-fee aggregate source-null = 191 | **PASS** |
| Numeric zero = 131 kept distinct from missing | **PASS** |
| NZ regulatory tuition not-applicable = 6,457 | **PASS** |
| Fresh browser-time `admin_read` HTTP 200 / no repeat timeout | **PASS** |
| Regulatory-fee exception page total = 191 | **PENDING** |
| Exception paging | **PENDING** |
| Course detail navigation from exception row | **PENDING** |
| Evidence navigation from exception row | **PENDING** |

### Current CF-CHG-018 browser state

**PARTIAL PASS — OVERVIEW GATE COMPLETE.** The deployment, Catalogue regression, semantic relabel, Data Quality overview/state model and fresh governed RPC telemetry are accepted. The overall control remains open only for the exception-page and Course/Evidence drill-down browser path required by the aggregate → exception → provenance operating model.
