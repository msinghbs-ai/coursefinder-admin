# CourseFinder AU CRICOS Layer 1 Adapter Consolidation UAT v1.1

**Status:** PASS / ACCEPTED  
**Date:** 19 August 2026  
**Supersedes:** `docs/coursefinder-au-cricos-layer1-adapter-consolidation-uat-v1.0.md`  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.33.md`  
**Completeness design:** `docs/coursefinder-au-layer1-regulatory-completeness-design-v1.0.md`

## 1. Purpose

Confirm that all accepted structured CRICOS Course facts refresh through the primary AU Layer 1 operational path and record the post-consolidation completeness interpretation.

The regulatory-facts implementation is an internal phase of Layer 1, not an independent operational layer and not Layer 2.

## 2. Accepted source

- Active AU Providers: 1,546
- Active AU Courses: 26,648
- CRICOS Courses snapshot: `2026-08-04T08:04:20.717556Z`
- SHA-256: `fc2f2ef81c0b3c63dd47e1b01c7e5cf22f708c892e70f71707dbb421baed6945`

## 3. Accepted adapter design

Primary operational entrypoint: `layer1-au-depth-v1.5.1`.

Runtime contract:
- maximum 500 active Courses per invocation;
- bounded streaming scanner replaces full materialisation of all ZIP CSV rows;
- parent worker owns Course/Provider core reconciliation and geography;
- `layer1-au-cricos-facts-v1.1.0` is invoked internally under service-role authority for accepted regulatory Course facts;
- parent and child preserve the same Course source/evidence/hash contract;
- no automatic Search rebuild per bounded Layer 1 batch.

## 4. Dry-run UAT

Parent job: `72c3d242-b68b-44b7-b0ac-453883710ab2`.

Offset 0 / batch 500:
- completed;
- 500 selected Courses;
- exact source hash matched;
- facts matched: 500;
- facts unchanged: 500;
- fee observations: 1,488;
- fees unchanged: 1,488;
- missing Courses: 0;
- invalid fee values: 0;
- conflicts: 0.

**Result: PASS.**

## 5. APPLY/replay UAT

Parent job: `f9618d43-f5f3-4a7f-8739-663276f0bc7e`.

Offset 0 / batch 500:
- existing Courses: 500;
- existing Providers: 500;
- Courses created: 0;
- Providers created: 0;
- existing Campuses: 11;
- existing Course-location links: 515;
- geography conflicts: 0;
- facts unchanged: 500;
- fee observations unchanged: 1,488;
- fact/fee creates or updates: 0;
- missing identities: 0.

**Result: PASS.**

This proves same-snapshot replay does not create duplicate canonical identities, geography, regulatory facts or fees through the corrected primary adapter.

## 6. End-of-source boundary UAT

Parent job: `c6b40f4d-47d8-4ca0-a010-9d778675dbc8`.

Offset 26,500 / requested batch 500:
- selected records: 148;
- `hasMore=false`;
- existing Courses/Providers: 148;
- existing Campuses: 54;
- existing Course-location links: 184;
- facts unchanged: 148;
- fee observations unchanged: 444;
- creates/updates/misses/conflicts: 0.

**Result: PASS.**

This proves final partial-batch handling at the 26,648-Course boundary.

## 7. Current full catalogue state

- AU Providers: 1,546;
- AU active Courses: 26,648;
- current CRICOS regulatory Course observations: 26,648;
- active CRICOS registered-total-course fee observations: 79,562;
- current/year-specific Provider fee rows: 0;
- Search Documents: 33,105;
- Search `has_fee=true`: 0;
- running AU Layer 1 jobs after UAT: 0.

## 8. Completeness impact

The accepted CRICOS facts materially improve regulatory attribute coverage.

Current 13-dimension diagnostic:
- average: **99.22%**;
- 24,239 Courses at 100%;
- 26,448 Courses >=90%;
- 200 Courses <90%;
- minimum: 76.92%;
- maximum: 100%.

For comparison, the same 13-dimension profile applied only to dimensions persisted before the CRICOS-facts implementation produces an estimated average of **45.49%**.

This is a coverage comparison, not a claim that the previous adapter lost 54% of source rows.

## 9. Completeness semantics

The UAT now distinguishes:

### Source representation completeness

Whether accepted populated source values are represented or explicitly classified.

A blank authority value is `source_absent`, not an adapter defect.

### Regulatory attribute coverage

Whether a desired regulatory dimension has a usable value. This is the 99.22% diagnostic.

### Publication/Search completeness

Consumer readiness/freshness under separate publication and Search rules. It remains unformalised/unpopulated for AU and is not recalculated by this UAT.

## 10. Residual Layer 1 gaps

Current gaps requiring further classification/remediation:
- Study Level mapped: 24,367 / 26,648 — **2,281 unmapped**;
- Campus relationship: 26,614 / 26,648 — **34 missing**;
- Tuition Fee: 26,457 / 26,648 — 191 source-missing values;
- Non Tuition Fee: 26,457 / 26,648 — 191 source-missing values.

The study-level gap is a Layer 1 canonical mapping issue until each populated CRICOS `Course Level` value is mapped or explicitly review-classified.

The 34 campus gaps must be reconciled against CRICOS Course Locations and classified as source absence, identity-resolution issue or adapter defect.

The 191 Tuition and 191 Non Tuition gaps are treated as source coverage gaps unless a fresh source audit proves parsing/mapping failure.

No data may be inferred or fabricated to raise completeness.

## 11. Search boundary

Search remains unchanged:
- Course Documents: 33,105;
- `has_fee=true`: 0;
- `search.enrichment_gates` `courses/course_fee`: `blocked`.

No CRICOS registered total-course fee is treated as a current annual/provider fee.

## 12. Security/operational checks

- stats compatibility RPC is executable only by `postgres` and `service_role`;
- stale failed UAT jobs were explicitly closed;
- running AU Layer 1 jobs after UAT: 0.

## 13. Decision

**AU Layer 1 adapter consolidation = PASS / ACCEPTED.**

The next serial gate is **`M1-L1-AU-CRICOS-COMPLETENESS`**, not Layer 2.

It must resolve/classify the 2,281 study-level gaps and 34 campus gaps, repeat full dry-run/APPLY/replay/idempotency UAT and recalculate regulatory completeness with source-gap versus adapter-defect attribution.

Only after that gate passes does the serial data lane proceed to `M1-L2-AU-COURSE-FACTS`.
