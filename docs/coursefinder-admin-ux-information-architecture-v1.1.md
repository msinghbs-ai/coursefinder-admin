# CourseFinder Admin UX & Information Architecture v1.1

**Status:** APPROVED UX IA ADDENDUM / CURRENT ADMIN INTERACTION CONTRACT  
**Supersedes for UX decisions:** `docs/coursefinder-admin-ux-information-architecture-v1.0.md`  
**Date:** 18 August 2026  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.26.md`  
**Detailed design decisions:** `docs/coursefinder-admin-pim-design-decisions-v1.0.md`

This v1.1 addendum retains all navigation, country-context, catalogue, Provider/Course workspace, completeness, source-mapping, Pipeline, Jobs, Evidence, Outcomes, Administration and phased-delivery principles from v1.0. The following refinements are now binding for new Admin/PIM implementation.

## 1. Admin interaction model

Admin is a decision-by-exception workspace. High-volume catalogue pages must optimise for rapid scanning, comparison and governed action rather than large-card browsing or navigation-heavy record pages.

Standard pattern:
- server-side pagination;
- dense table/list rows;
- sortable headers;
- fast filters compatible with sorting/pagination;
- search;
- selected-row persistence;
- compact right-side detail panel;
- detail close/collapse without losing page/filter/sort state;
- evidence/freshness/lifecycle/publication/Search signals visible in the list where useful.

## 2. Provider list minimum UX

Provider list should expose, where canonically available:
- Provider name;
- Country flag + ISO code;
- State/Province/Region;
- City;
- stable/regulatory key;
- direct Provider website action;
- Courses/Campuses counts as appropriate;
- Last Verified;
- Evidence status/count;
- Lifecycle;
- Publication;
- Search projection/sync;
- recency/change state.

Country and State/Region filters must use authoritative canonical/reference data. Missing geography is a data-quality gap and must not be guessed merely for display convenience.

## 3. Country/currency visual contract

Country displays use flag + ISO alpha-2 code, with full country name available where useful.

Monetary values use ISO 4217 code as the authoritative currency label. Currency symbol may supplement the code. Flags are contextual only and cannot replace the currency code.

## 4. Direct links

When an accepted canonical Provider website exists, Admin must provide a direct external-link action without requiring a separate navigation page.

Evidence/source links remain semantically separate from the canonical Provider website.

## 5. Change intelligence

Admin must progressively support explicit change states and filters for:
- Added;
- Modified;
- Amended/materially changed;
- Last Verified;
- Source Changed;
- Evidence Updated;
- Stale;
- Needs Review;
- Publication Changed;
- Search Out of Sync.

Recommended quick views include `New`, `Recently modified`, `Stale`, `Source changed`, `Needs review`, and `Search out of sync`.

## 6. AI / automation operating principle

Every new Admin feature must assess whether deterministic automation or a bounded evidence-backed agent can remove repetitive human work.

Preferred operating model:

`Acquire -> validate -> compare -> classify -> propose -> auto-resolve safe cases -> queue exceptions -> human decision -> apply -> verify -> evidence/audit`

Humans should focus on ambiguous identity, low-confidence mapping, material semantic interpretation and governance approvals. AI must not invent identity or source facts.

## 7. Review Queue direction

Review items should state *why* attention is required and expose the evidence/difference needed for a decision.

Future prioritisation should combine:
- risk;
- impact;
- confidence;
- freshness/staleness;
- publication/search consequence.

Agent-generated evidence-difference summaries are encouraged when grounded in stored source/evidence versions.

## 8. Consistency rule

Providers, Courses, Scholarships and future catalogue entities should share the same interaction primitives unless their domain semantics genuinely require an exception.

Country/source-specific work may alter fields and mappings but should not invent a separate Admin navigation/decision pattern.

## 9. Governance

The durable details are maintained in `docs/coursefinder-admin-pim-design-decisions-v1.0.md`. Future CourseFinder chats implementing Admin/PIM functionality must consult that document together with the current architecture, master plan and running build, and must document superseding UX decisions rather than silently regressing accepted features.
