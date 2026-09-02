# CourseFinder Admin Navigation & Information Architecture v1.6

**Status:** CURRENT — M2.5 PROVIDER CONTACTS ADDENDUM  
**Date:** 2 September 2026  
**Supersedes:** v1.5  
**Related Change Controls:** `CF-CHG-20260826-040`, `CF-CHG-20260901-061`, `CF-CHG-20260902-063`, `CF-CHG-20260902-064`, `CF-CHG-20260902-076`

## Principle

The sidebar describes operator journeys, not source-table history.

Authority remains:

`Layer 1 Authoritative / Regulatory → Layer 2 Deterministic Acquisition & Extraction → Layer 3 AI-assisted Evidence Interpretation → Layer 4 Human Resolution`.

A15 contact acquisition remains Layer 2 Evidence-backed enrichment. A30 adds a managed Catalogue workspace without creating a new authority layer.

## Primary navigation order

| Order | Group | Menu item | Purpose |
|---:|---|---|---|
| 1 | Overview | Dashboard | cross-platform health, blockers, freshness and next actions |
| 2 | Catalogue | Providers | canonical Provider decision workspace |
| 2 | Catalogue | Courses | canonical Course decision workspace |
| 2 | Catalogue | Campuses | canonical Campus decision workspace |
| 2 | Catalogue | Scholarships | Scholarship decision workspace |
| 2 | Catalogue | **Provider Contacts** | manage multiple Provider-linked professional contacts, import/export, verification, delete/restore and history |
| 3 | Statistics & Insights | Statistics & Rankings | unified coverage, years, observations, mappings, Evidence and source verification for QILT/PRISMS/QS/THE |
| 3 | Statistics & Insights | Compare | select Providers/Courses, datasets and aligned year/period for comparison |
| 4 | Data Operations | Layer 1 — Operations | authoritative/regulatory and publisher-authoritative ingestion |
| 4 | Data Operations | Layer 2 — Enrichment | deterministic first-party acquisition/extraction |
| 4 | Data Operations | Layer 3 — AI Interpretation | governed Evidence interpretation |
| 4 | Data Operations | Layer 4 — Human Resolution | terminal human resolution |
| 4 | Data Operations | Evidence | cross-layer provenance |
| 4 | Data Operations | Jobs | run history and operational state |
| 5 | Quality & Review | Completeness / reconciliation | coverage/readiness and unresolved decision work |
| 6 | Administration | Administration | Sources & Imports, acquisition, scheduling, onboarding, PIM, users/roles, platform |
| 7 | Help | Guides & Runbooks | maintained operator guidance |

## Provider Contacts rule

Provider Contacts is a routine Catalogue workflow, not an Administration configuration page.

It owns:
- current managed contacts;
- Provider filtering and deep-links;
- column search/filter/sort/order;
- individual managed edits;
- verification/freshness;
- soft-delete/restore;
- import/export;
- version/audit history.

The Provider detail blade retains a concise International contacts summary and provides **View all Provider Contacts** deep-linking to this module with the Provider filter applied.

## Import rule

The module may present Import directly, but the backend must reuse governed private Evidence/file registration, hash/idempotency, Provider crosswalk and dry-run/APPLY controls.

A separate generic Sources & Imports page may still show import history/configuration; operators do not need to leave Provider Contacts for routine contact import.

## Responsive rule

Desktop may use a dense internally-scrollable grid. Tablet/mobile progressively reduce visible columns and keep one detail-drawer scroll owner. Document-level horizontal overflow is prohibited.

## Security / consumer boundary

Navigation does not change role ranks, source precedence or public consumer admission.

Import/export/create/edit/delete/restore are privilege-gated. Search/Website/Zoho contact exposure remains separately governed.

## UAT gate

Acceptance covers:
- canonical navigation placement;
- Provider deep-link in/out;
- desktop/tablet/mobile route and grid;
- role/negative paths;
- import/export access;
- deleted filter and restore;
- no duplicate legacy menu or hidden primary route.
