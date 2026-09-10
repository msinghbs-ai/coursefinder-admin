# CourseFinder Admin Navigation & Information Architecture v1.6

**Status:** CURRENT — M2.4.5 ADMIN IA HARDENING  
**Date:** 10 September 2026  
**Supersedes:** v1.5  
**Related Change Controls:** `CF-CHG-20260826-040`, `CF-CHG-20260901-061`, `CF-CHG-20260902-063`, `CF-CHG-20260902-064`, `CF-CHG-20260902-080`, `CF-CHG-20260903-088`, `CF-CHG-20260910-092`

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
| 4 | Data Operations | **Scheduled Tasks** | governed recurring schedules, bounded operator run requests, queues and run follow-through |
| 4 | Data Operations | Evidence | cross-layer provenance |
| 4 | Data Operations | Jobs | run history and operational state |
| 5 | Quality & Review | Completeness / reconciliation | coverage/readiness and unresolved decision work |
| 6 | Administration | Administration | Sources & Imports, acquisition, onboarding, PIM, users/roles and platform configuration |
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

## M2.4.5 Administration section model

Administration is one canonical workspace with metadata-driven section labels, rank visibility, breadcrumbs and compact overview cards.

Canonical sections:
- Overview — rank 4;
- Sources & Imports — rank 4;
- Layer 1 sources — rank 6;
- Extraction Profiles — rank 4;
- Scraper Config — rank 4 read surface with higher-rank server-authorised writes;
- Provider Assets — rank 4;
- Onboarding — rank 4 inside Administration;
- PIM configuration — rank 5;
- Users & Roles — rank 6;
- Environment & Migration — rank 6;
- Platform — rank 6.

Compatibility rules:
- `#users-roles`, `#attributes` and `#settings` remain valid deep links but resolve into canonical Administration sections;
- historic Onboarding compatibility remains only where its retained route does not alter permissions;
- the hidden Sources operational registry remains separate because it is not equivalent to one configuration section;
- Users & Roles no longer owns a separate full-screen Admin shell;
- **Scheduling is not an Administration section or hidden primary route.** `#scheduled-tasks` is the canonical scheduling route.

## Scheduled Tasks IA refinement — CF-092

Scheduled Tasks is a first-class **Data Operations** module immediately before Evidence. This placement reflects its operational role: operators configure recurring work, request eligible bounded work, and follow queue/Job/Evidence results in one place.

The former Administration → Scheduling tab/render branch and hidden `Refresh & Scheduling` route are removed. No duplicate settings surface is retained.

Authority rules:
- schedule configuration is visible through a paged governed read, not a browser table query;
- schedule edits require Pipeline Operator rank and use optimistic concurrency plus durable actor/reason/Change-Control audit;
- direct **Run on demand** is allowed only for exact bounded Layer 1–2 policies and does not alter the recurring cadence or next-run timestamp;
- Layer 3 direct generic run requests are not manufactured here because Layer 3 requires governed Evidence/profile/model context; operators use the native Layer 3 workspace for executable on-demand interpretation;
- Jobs remain read through the governed `public.admin_read` path;
- generic historical Job retry/replay/reset remains prohibited.

No primary Layer authority, Search/Publication authority or role rank changes under CF-092.

## M2.4.5 H2 terminology refinement — CF-089

Administration terminology distinguishes two Layer 2 configuration responsibilities:

- **Scraper Config** — vendor/provider control plane: enabled state, credential status, endpoint, rate, concurrency, timeout, quota and profile route membership.
- **Extraction Profiles** — advanced source-specific deterministic extraction configuration: what is acquired/extracted, source constraints, target entity, validation/qualification and version history.

Extraction Profiles is the relabelled presentation of the existing `layer2-sources` section. Its route key and backend contracts are unchanged.

Layer 2 workload defaults (scheduler batch size, qualification cadence and production wave size) remain necessary platform configuration but are placed behind progressive disclosure. They are not a second scraper-routing editor; the legacy global route mode is read-only there.
