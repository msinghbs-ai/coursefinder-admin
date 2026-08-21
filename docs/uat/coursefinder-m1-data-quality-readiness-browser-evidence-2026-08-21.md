# CourseFinder M1-DATA-QUALITY-READINESS — Deployed Browser Evidence

**Date:** 21 August 2026  
**Change Control:** `CF-CHG-20260821-018`  
**Runtime:** `coursefinder-pilot.techm.workers.dev`  
**Evidence windows:** approximately 21:55, 22:08 and 22:23–22:26 AEST  
**Evidence source:** authenticated operator screenshots supplied in the originating `M1-DATA-QUALITY-READINESS` chat plus correlated Supabase API/Postgres telemetry  
**Browser evidence result:** **PARTIAL PASS — deployment, Catalogue regression, legacy-label correction, Data Quality overview, 191-record Exceptions paging and canonical Course drill-down PASS; linked Evidence detail navigation remains pending**

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

The 22:08 AEST screenshot proves both corrected labels are deployed. The underlying historical calculation/filter contract was not changed.

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

## 5. Exceptions and decision context — deployed browser PASS

The 22:23–22:24 AEST screenshots directly prove the operational drill-down from the governed aggregate into the deployed Exceptions workspace.

Visible context:

- workspace: `Exceptions & decision context`;
- scope: `AU + NZ`;
- domain: `Regulatory fee`;
- entity: `Course`;
- state: `Source-null`;
- total: **191 records**.

Every visible row retains the state `Source-null` and the Source/Evidence column identifies the governed source as `CRICOS Providers, Courses and Locations`, with Evidence links displayed where the backend supplies an evidence ID.

### Paging proof

The supplied screenshots cover the complete 191-record population in four bounded pages:

- **1–50 of 191**;
- **51–100 of 191**;
- **101–150 of 191**;
- **151–191 of 191**.

`Previous` / `Next` controls and page state are visibly functional. The final page contains the expected residual 41 rows rather than a fabricated full page.

**Exception total = 191: PASS.**  
**Server-paged browser navigation: PASS.**  
**Source/Evidence linkage presentation: PASS.**

## 6. Canonical Course drill-down — deployed browser PASS

The 22:26 AEST screenshot proves that a canonical Course can be opened from the exception workflow.

The loaded Course detail visibly contains governed canonical and enrichment sections including:

- stable identity / Course code / Provider context;
- Field and Study Level;
- lifecycle and publication state;
- `Fee semantics`, keeping CRICOS registered total-course fee separate from Provider-current fee;
- Publication & Search state;
- Intakes & English;
- Taxonomy lineage;
- Fees;
- Campuses;
- Evidence;
- Regulatory Facts.

The Course detail also displays real Evidence artifacts/IDs and Evidence links, proving that the exception → canonical Course flow retains provenance context rather than dropping it.

**Canonical Course navigation from exception row: PASS.**  
**Evidence link availability on the resulting Course: PASS.**

This screenshot does **not** prove that an Evidence detail route was opened. That distinction is retained intentionally because the Data Quality frontend previously required a specific `evidence_id` route correction and the final route should be browser-proven rather than inferred.

## 7. Browser-time governed RPC telemetry

### 22:07–22:08 overview window

The overview interaction correlated with **11 successful** requests to:

`POST /rest/v1/rpc/admin_read` → HTTP 200

No new HTTP 500 or Postgres statement timeout was aligned with that interaction.

### 22:21–22:26 exception/Course window

Fresh API telemetry aligned with the latest screenshots shows repeated successful:

`POST /rest/v1/rpc/admin_read` → HTTP 200

including activity at approximately:

- 22:21:34 and 22:21:53 AEST;
- 22:22:39, 22:22:42 and 22:22:51 AEST;
- 22:23:40 AEST;
- 22:24:01, 22:24:22 and 22:24:59 AEST;
- 22:25:24, 22:25:33 and 22:25:42 AEST.

There is no new API HTTP 500 in this fresh interaction window. Postgres telemetry contains no new statement-timeout or permission error aligned with the 22:21–22:26 browser activity; the most recent statement-timeout remains the earlier 21:53 event already recorded.

The API service log does not expose `p_operation`, so individual 200 responses are not falsely attributed to specific operations. The screenshots provide the route-level browser proof; telemetry independently confirms the governed browser read boundary is completing successfully during the same window.

**Governed browser RPC / no-repeat-timeout check: PASS for the exception/Course interaction window.**

## 8. Remaining deployed-browser acceptance

Only one direct browser check remains:

1. use a real displayed **Evidence** link from the exception/Course flow and prove the deployed **Evidence detail** workspace loads for that `evidence_id`.

No Review navigation check is required merely to manufacture evidence. `workflow.review_queue` had zero rows at implementation and no synthetic Review item is authorised; Review linkage remains conditional on a real governed Review row being present.

## 9. Verdict

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
| Regulatory-fee exception page total = 191 | **PASS** |
| Exception paging — all four pages through 151–191 | **PASS** |
| Source/Evidence linkage visible in exception rows | **PASS** |
| Course detail navigation from exception row | **PASS** |
| Evidence links visible on canonical Course | **PASS** |
| Fresh browser-time `admin_read` HTTP 200 / no repeat timeout | **PASS** |
| Evidence detail navigation using a real `evidence_id` | **PENDING** |

### Current CF-CHG-018 browser state

**PARTIAL PASS — ONLY EVIDENCE DETAIL ROUTE REMAINS.** The deployment, Catalogue regression, semantic relabel, Data Quality overview/state model, 191-record exception population, full paging, canonical Course drill-down, provenance-link presentation and current governed RPC telemetry are accepted. The overall control remains open only for direct browser proof that a real Evidence link from this flow opens the deployed Evidence detail workspace.