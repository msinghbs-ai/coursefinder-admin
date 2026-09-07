# CF-CHG-20260907-242 — M2.4.5 UI Improvements & v2.15.73 Release Currentness

**Status:** CLOSED / PASS  
**Date:** 7 September 2026  
**Milestone:** M2.4.5  
**Environment:** Pilot / UAT only  
**Production:** UNCHANGED / NOT AUTHORISED  
**Predecessor baseline:** v2.15.71 / `c9dbbfb0f1bdbe63c28d68a27077357797b2ae84`  
**Accepted functional head:** `39dbf633d236c812cd5134ff263b993f6ac3e851`  
**Accepted release/currentness head:** `82e1f13cd37508bec314bfbf882ecdcb4a89183c`  
**Accepted visible release:** v2.15.73

## Purpose

Close the bounded M2.4.5 UI improvement package requested after recovery of v2.15.71, while preserving governed data, security, Evidence, publication and Provider-equivalence semantics.

This record is separate from CF-241. CF-241 remains reserved for forward reconciliation of the superseded CF-239 runtime-performance changes. The superseded v2.15.72 recovery line remains forensic history and is not reused as a release identifier.

## Accepted scope

### Scholarship Catalogue

- Provider added as a standard bounded, searchable relational filter.
- Provider filtering is authoritative at the governed server read boundary through `provider_id`; no current-page client filtering is used.
- Country changes clear stale Provider selection.
- Fluid/responsive catalogue columns are used.
- Meaningful Scholarship columns use governed server-backed ordering; Evidence identifier ordering is not manufactured.
- Existing Scholarship lifecycle, publication, workflow, source and mapping semantics remain unchanged.

### Statistics & Rankings

- QILT and PRISMS dataset tables use fluid columns and governed server-side sorting for applicable fields.
- QS and THE expose Open Dataset and Compare using their own ranking datasets and retained edition/year semantics.
- Ranking dataset ordering is global/server-backed rather than page-local.
- Publisher institution identity, canonical Provider mapping/equivalence and Evidence attribution remain distinct.
- Ranking observations are not conflated with QILT/PRISMS outcomes.

### Provider Compare

- QS and THE are enabled by default when accepted data exists.
- Each system defaults to its latest retained accepted edition.
- Historical editions display independently beneath the selected/current edition.
- Missing accepted observations remain explicit; no ranking is manufactured.
- Provider logo/name identity remains visible while wide QILT/PRISMS/ranking data scrolls.
- Responsive behaviour is retained for multiple Provider comparisons.

## Governed read-contract reconciliation

Pilot migration:

`20260907064251_m245_ui_read_contract_reconciliation`

The migration:

- adds an internal Scholarship page helper that honours `provider_id` while retaining authentication and role/rank checks;
- revokes the helper from `PUBLIC`;
- preserves the legacy public Scholarship function signature;
- adds validated `sort` / `direction` handling to ranking observation reads with deterministic ordering;
- preserves Provider equivalence and Evidence fields;
- introduces no canonical write, publication or Search admission path.

Post-change Security Advisor review introduced no new warning attributable to this reconciliation; existing informational RLS inventory remained unchanged.

## Acceptance evidence

### Source / functional candidate

- Targeted reconciled source contract: run `34092573017` — PASS.
- Frontend build + Chromium smoke: run `34092486868` — PASS.
- Bounded viewport gate: run `34093001623` — PASS at:
  - desktop 1600×900;
  - laptop 1366×768;
  - tablet 900×820;
  - mobile 390×844.
- Functional PR #32 merged to Pilot `main` as `39dbf633d236c812cd5134ff263b993f6ac3e851`.
- Deployed targeted UAT: run `34093156194` — PASS.

### Release/currentness synchronization

The accepted functional package was promoted to **v2.15.73** because v2.15.72 is superseded forensic history under CF-240.

Release synchronization aligns:

- mature Admin `UI_VERSION`;
- browser/document title;
- release-currentness overlay authority;
- legacy release-list authority;
- dedicated deployed-currentness test.

Evidence:

- release-sync PR #33 source build + browser smoke: run `34093619913` — PASS;
- release-sync merged to Pilot `main` as `82e1f13cd37508bec314bfbf882ecdcb4a89183c`;
- merged-head frontend build + browser smoke: run `34093765392` — PASS;
- final deployed targeted UAT/currentness: run `34093765349` — PASS, including authenticated desktop validation, evidence upload and commit-status publication.

The deployed currentness gate verifies one synchronized v2.15.73 release across the release pill, browser title, release-currentness data attribute and release-note entry.

## Boundary / non-effects

- Production was not changed, provisioned or deployed.
- M2.5 was not reopened.
- CF-239 superseded runtime behaviour was not reintroduced.
- CF-241 remains a separate forward runtime reconciliation item.
- Search, Website/Wix, Zoho and publication admission were not broadened.
- No data-grain, Evidence, rank/role, RLS, Provider-equivalence or source-authority rule was weakened to obtain PASS.

## Rollback / recovery

- Functional source predecessor: v2.15.71 baseline `c9dbbfb0f1bdbe63c28d68a27077357797b2ae84`.
- Functional accepted head before release-only synchronization: `39dbf633d236c812cd5134ff263b993f6ac3e851`.
- Release/currentness accepted head: `82e1f13cd37508bec314bfbf882ecdcb4a89183c`.
- DB reconciliation is additive and should be reversed only through an explicit governed forward migration; do not restore superseded CF-239 runtime helpers as a rollback shortcut.

## Closure

**CLOSED / PASS.** The requested Scholarship, Statistics & Rankings and Provider Compare UI improvements are accepted in Pilot/UAT and the browser-visible/currentness authorities are synchronized to **v2.15.73**. Remaining M2.4.5 or pre-production work is governed separately.