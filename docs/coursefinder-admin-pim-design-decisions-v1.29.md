# CourseFinder Admin/PIM Design Decisions v1.29

**Status:** CURRENT M2 DESIGN DECISIONS  
**Date:** 2 September 2026  
**Supersedes:** v1.28  
**Change Controls:** CF-CHG-20260902-063, CF-CHG-20260902-064, CF-CHG-20260902-080, CF-CHG-20260902-081

## Decisions 38–61
Decisions 38–61 from v1.28 remain authoritative and unchanged.

## Decision 62 — Provider logos are governed assets
Provider logos are Layer 2 Provider assets linked to canonical Provider identity. The UI displays an approved primary asset; discovered candidates remain reviewable with Evidence.

## Decision 63 — Logo is presentation, not identity
A visual/logo match cannot create, merge or rename a Provider. Provider resolution occurs first.

## Decision 64 — Scholarship discovery is multi-view
Scholarships should support Scholarship, Provider/university and Course views. Provider cards can show logo, current Scholarship count, award summary and applicable study levels; Course views show only resolved applicable Scholarships.

## Decision 65 — Shared acquisition is visible operationally
Layer 2 operations distinguish new vendor acquisition from reused Evidence/fan-out. Operators should be able to see provider route, content change, shared-fetch reuse and cost/vendor units.

## Decision 66 — Parse.bot remains disabled until qualification
A configuration slot may exist without endpoint/credential. UI must not imply it is usable until connection, security, cost and extraction UAT pass.

## Decision 67 — Refresh follows volatility
Routine full refreshes are not daily by default. Course facts are monthly, Scholarships weekly, Provider logos quarterly, with lighter checks and source-specific acceleration around consequential dates/changes.

## Decision 68 — Commercial aggregators are reconciliation by default
Hotcourses, IDP and similar platforms may inform completeness/UX comparison. Their data is not automatically imported as canonical CourseFinder Scholarship truth without explicit source/reuse approval.
