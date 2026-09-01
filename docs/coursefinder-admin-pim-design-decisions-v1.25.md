# CourseFinder Admin/PIM Design Decisions v1.25

**Status:** CURRENT M2 DESIGN DECISIONS
**Date:** 1 September 2026
**Supersedes:** v1.24
**Change Control:** CF-CHG-20260901-051

## Decision 38 — Environment state is explicit
Pilot qualification and Production enablement are separate. Source capabilities, acquisition providers and AI profiles require environment-specific approval.

## Decision 39 — Capacity and integrity are distinct
Capacity reporting must separate DB size, Evidence storage utilisation and temp spill from orphan/missing Evidence lineage findings.

## Decision 40 — Retention is dry-run first
Regulatory Evidence, accepted source history, Layer 4 decisions, publication decisions and material audit remain excluded from routine purge. Future purge requires bounded deletion and post-delete integrity checks.

## Decision 41 — Blocking is reversible governance state
Operational, publication, Search and data-quality-quarantine blocks are independent append-only Layer 4 decisions. Each action retains actor, reason, time, optional review/expiry and supersession history. Blocking does not delete source data or rewrite canonical values.

## Decision 42 — Onboarding extends existing profiles
Scraper onboarding extends existing Layer 2 acquisition-provider configuration. AI onboarding extends existing Layer 3 model/task profiles. Environment enablement is additional to credentials, benchmark and quota configuration rather than a duplicate profile store.

## Decision 43 — UAT and workload profiles are first-class
Release governance must distinguish accepted Pilot domains from Production gates not yet run. Performance evidence must identify steady-state serving, scheduled refresh, bulk ingestion or representative concurrent workload while preserving the existing hard budgets.
