# CourseFinder M1-DATA-QUALITY-READINESS — Deployed Browser Evidence

**Date:** 21 August 2026  
**Change Control:** `CF-CHG-20260821-018`  
**Runtime:** `coursefinder-pilot.techm.workers.dev`  
**Evidence time:** approximately 21:55 AEST  
**Evidence source:** authenticated operator screenshots supplied in the originating `M1-DATA-QUALITY-READINESS` chat  
**Browser evidence result:** **PARTIAL PASS — deployment/current bundle and Catalogue regression proven; Data Quality workspace/drill-down still requires direct browser proof**

## 1. Evidence received

Two authenticated mobile-browser screenshots were supplied after Pilot source promotion.

Observed deployed marker:

`PIM Admin v2.12 · Pipeline Ops v1.0 · Evidence v1.0 · Data Quality v1.0 · governed`

The visible role badge is `Platform Admin`.

This is sufficient to prove that the deployed Worker is serving the Data Quality v1.0 candidate bundle rather than the previously accepted pre-Data-Quality marker.

## 2. Catalogue regression evidence

### Australia scope

The first screenshot shows:

- page: Courses;
- Country filter: Australia;
- matching Courses: **26,648**;
- CRICOS tuition values visible, including a legitimate `AUD 0` row;
- verified dates populated;
- Data Quality v1.0 governed marker visible.

The 26,648 count matches the accepted AU Course baseline and prior authenticated dispatcher regression.

**Result: PASS.**

### All-country scope

The second screenshot shows:

- page: Courses;
- Country filter: All;
- matching Courses: **43,461**;
- mixed populated/unpopulated enrichment rows;
- no visible permission/RPC failure state.

The 43,461 count matches the canonical all-country Course inventory recorded at CF-CHG-018 initiation.

**Result: PASS.**

## 3. Deployment-source blocker reclassification

Before this evidence, CourseFinder governance could prove only:

- source promotion to `Coursefinder-Pilot/main`;
- production build PASS;
- live Supabase read-contract PASS.

The screenshots now prove that the actual deployed Worker has advanced to a bundle carrying the Data Quality v1.0 governed marker.

Therefore the previous blocker **“deployment/current bundle unproven” is cleared**.

## 4. Browser-UAT defect discovered

The screenshots also show the historical six-signal Course percentage under the column heading:

`Readiness`

and the advanced filter label:

`Min readiness`.

Under CF-CHG-018, this historical percentage may remain for backwards-compatible Catalogue presentation, but it must not be confused with the new governed domain-readiness model. The accepted semantic contract requires it to be explicitly identified as a legacy/admin-presence signal.

This is therefore a browser-UAT semantic-labelling defect, not a calculation defect.

Remediation opened in `msinghbs-ai/Coursefinder-Pilot#19`:

- `Readiness` → `Legacy presence`;
- `Min readiness` → `Min legacy presence`;
- underlying value/filter/RPC semantics unchanged.

## 5. Remaining browser acceptance

The following still require direct deployed browser evidence before CF-CHG-018 can close:

1. open **Data Quality → Completeness** and prove it routes to the Data Quality v1.0 domain-readiness workspace;
2. prove the AU+NZ overview renders domain cards and all nine governed state labels;
3. open Course → Regulatory fee → `source_null` and prove the exception total is **191**;
4. prove paging works on that exception population;
5. open a canonical Course from an exception row;
6. open linked Evidence using `evidence_id` under Platform Admin/Curator+ access;
7. after PR #19 is deployed, confirm the mature Course grid/filter show `Legacy presence` / `Min legacy presence` rather than generic `Readiness` wording.

Browser-network telemetry for `public.admin_read` remains desirable evidence, but the live DB/ACL contract is already independently proven and no direct private Data Quality helper is browser-executable.

## 6. Verdict

| Browser gate | Result |
|---|---|
| Correct Worker/current candidate bundle served | **PASS** |
| Data Quality v1.0 marker visible | **PASS** |
| Authenticated Platform Admin session | **PASS** |
| AU Course Catalogue regression — 26,648 | **PASS** |
| All-country Course Catalogue regression — 43,461 | **PASS** |
| No visible Catalogue permission failure | **PASS** |
| Legacy score semantic labelling | **FAIL — remediation PR #19** |
| Data Quality workspace navigation/render | **PENDING** |
| 191 regulatory-fee exception browser drill-down | **PENDING** |
| Course/Evidence browser drill-down | **PENDING** |

### Current CF-CHG-018 browser state

**PARTIAL PASS.** Deployment is now proven and Catalogue regression is healthy. The overall gate remains open for the actual Data Quality workspace/drill-down browser checks and the legacy-score labelling correction discovered by this evidence.
