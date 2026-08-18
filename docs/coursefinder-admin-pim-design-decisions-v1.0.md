# CourseFinder Admin / PIM Design Decisions v1.0

**Status:** AUTHORITATIVE CROSS-CHAT UX / OPERATING CONTRACT  
**Date:** 18 August 2026  
**Architecture baseline:** `docs/coursefinder-database-architecture-v2.10.26.md`  
**Programme baseline:** `docs/coursefinder-master-project-plan-v1.26.md`  
**Related UX baseline:** `docs/coursefinder-admin-ux-information-architecture-v1.0.md`

## 1. Purpose

This document records durable Admin/PIM product decisions so work performed from separate CourseFinder chats, countries, enrichment streams and implementation sessions converges on one interaction model.

Later chat callouts may extend this contract, but should not silently remove accepted features or replace them with a less efficient interaction unless a new documented design decision explicitly supersedes the relevant rule.

The canonical backend model remains authoritative. UI convenience must not weaken identity, evidence, lifecycle, publication or Search boundaries.

## 2. Primary operating objective

CourseFinder Admin is a **decision and exception-management workspace**, not a passive database viewer.

Design for:
- minimum routine human effort;
- maximum deterministic automation;
- AI/agent assistance where it reduces repetitive review without inventing facts;
- rapid cross-checking of canonical record, source, evidence, freshness and publication state;
- few-click approve/reject/review workflows;
- dense information presentation with drill-in detail rather than navigation-heavy pages;
- safe bulk operations where the underlying decision is deterministic and auditable.

Human operators should primarily handle exceptions, ambiguous mappings, low-confidence structure and governance approvals that cannot be resolved safely by deterministic rules or bounded agents.

## 3. Catalogue decision-grid pattern

Providers, Courses, Scholarships and similar high-volume entities should converge on the same list interaction pattern:

1. server-side pagination;
2. dense scan-friendly rows;
3. sortable column headers;
4. column/global filters that work with sorting and pagination;
5. persistent selected row state;
6. compact right-side detail/verification panel;
7. close/collapse detail without navigating away or losing list/filter/page state;
8. evidence/source/lifecycle/publication/Search signals visible before deep drill-in;
9. bulk action capability only where governance permits;
10. saved views as a later productivity layer.

A list-to-full-page navigation should not be required for ordinary verification.

## 4. Mandatory Provider decision-grid fields

Provider rows should prioritise:
- Provider name;
- Country flag + ISO country code;
- State / Province / Region where canonically available;
- City;
- stable key / regulatory identifier as appropriate;
- Course count;
- Campus count where useful;
- Last Verified;
- Evidence count / evidence state;
- Lifecycle;
- Publication;
- Search projection/sync status;
- change/freshness status.

### Provider website

A direct Provider website action is mandatory when an accepted website URL exists.

Rules:
- show a clear external-link affordance from the row and/or condensed detail header;
- open the authoritative Provider website in a new browser tab;
- never fabricate a URL;
- distinguish canonical Provider website from evidence/source URLs where both exist.

## 5. Country and currency presentation

Where country or currency is relevant to the entity or value:

### Country
Display:
- country flag;
- ISO alpha-2 country code;
- country name on hover/detail where space is constrained.

### Currency
Display:
- ISO 4217 currency code;
- amount/value;
- currency symbol where unambiguous and useful;
- associated country flag only as contextual decoration where appropriate, never as a substitute for the currency code because currencies can span multiple countries.

The currency code is authoritative in the UI; a flag alone is never sufficient.

## 6. Change intelligence and recency

Admin users must be able to identify what changed without manually comparing records.

Standard change signals should include, where the backend supports them:
- **Added** — canonical entity first created;
- **Modified** — canonical row last changed;
- **Source Changed** — new source-record/evidence content hash or source observation changed;
- **Amended** — governed material change to structured facts/relationships after initial canonical creation;
- **Verified** — last authoritative verification/check timestamp;
- **Evidence Updated** — latest evidence capture/version changed;
- **Publication Changed** — publication state changed;
- **Search Changed / Out of Sync** — Search projection differs from current publishable canonical state;
- **Stale** — verification/evidence age exceeds the relevant source/freshness policy;
- **Needs Review** — unresolved deterministic/AI confidence or governance issue.

Required filters/sorts should evolve toward:
- Added today / 7 days / 30 days;
- Modified today / 7 days / 30 days;
- recently verified;
- stale verification;
- source/evidence changed since last verification;
- newly unpublished/published;
- Search out of sync;
- Needs Review;
- AI-suggested changes awaiting approval.

A future `Since my last visit`/saved checkpoint view is recommended once per-user state is available.

## 7. AI / agent-first operating model

Every new Admin feature should explicitly ask:

**Can this step be deterministic or safely agent-assisted so a human only handles exceptions?**

Preferred sequence:

`Acquire -> validate -> compare -> classify -> propose -> auto-resolve safe cases -> queue exceptions -> human approve/reject -> apply -> verify -> evidence/audit`

### Suitable automation/agent responsibilities
- source freshness checks;
- change detection by content hash/version;
- deterministic exact identifier matching;
- completeness scoring;
- stale-data detection;
- duplicate candidate detection;
- evidence presence/lineage validation;
- Search projection drift detection;
- source schema drift detection;
- proposed taxonomy/category mapping;
- proposed structured extraction from unstructured evidence;
- clustering similar review exceptions;
- summarising evidence differences for reviewer attention;
- prioritising Review Queue by risk/impact/confidence/freshness;
- generating bounded re-validation/re-acquisition jobs.

### Human-only or approval-gated decisions
- ambiguous canonical identity resolution;
- low-confidence source mappings;
- material semantic interpretation not proven by the source;
- publication approval where policy requires human governance;
- acceptance of AI-derived structure when confidence/evidence policy does not permit auto-apply.

AI must not invent Provider/Course/Scholarship identity, eligibility, award or regulatory facts.

## 8. Review-by-exception UX

Admin pages should surface the reason a record needs attention, not merely mark it `Needs Review`.

Recommended decision chips/signals:
- Missing identifier;
- Missing authoritative evidence;
- Source changed;
- Evidence stale;
- Canonical/source conflict;
- Ambiguous mapping;
- Search out of sync;
- Completeness below threshold;
- New record;
- Material amendment;
- AI suggestion;
- Publication pending.

The right-side detail panel should put the decision-critical differences first and allow deeper evidence sections to remain collapsed until needed.

## 9. Few-click decision standard

For common review tasks, target:

`filter/sort -> select record -> inspect condensed evidence/difference -> approve/reject/queue`

Normal verification should not require repeated back navigation, reopening filters or losing pagination state.

Where one-click/bulk approval is permitted, the UI must still preserve actor, timestamp, evidence and the decision basis.

## 10. Common feature consistency

New country, source, Layer 2/3, Scholarship, Search or data-quality chats must reuse this design language unless a documented exception exists.

Common primitives should include:
- country flag/code;
- currency code/value;
- sortable/filterable tables;
- pagination;
- compact collapsible detail panels;
- direct canonical website/source links;
- status pills;
- recency/change chips;
- evidence counts/freshness;
- completeness indicators;
- Review Queue actions;
- AI/automation recommendation/exception indicators.

Do not create a different interaction model for each country merely because the source shape differs.

## 11. Proposed near-term improvements

Priority additions to the current Pilot Admin:

1. Provider direct website link in row/detail header.
2. Country flag + ISO code rendering.
3. Last Verified and Modified columns.
4. Added/Modified/Verified recency chips.
5. Evidence count/freshness and source-change indicator.
6. Quick views: `New`, `Recently modified`, `Stale`, `Needs review`, `Source changed`, `Search out of sync`.
7. Course decision grid brought to the same server-side pagination/filter/sort standard as Providers.
8. Scholarship decision grid aligned to the same pattern, with Current Cycle / Open Window / Award / Eligibility / Evidence freshness signals.
9. Review Queue priority scoring from risk + impact + confidence + freshness.
10. Agent-produced `What changed?` summary in the detail panel backed by stored source/evidence differences.
11. Automated re-verification jobs for stale/source-changed records, with humans notified only for exceptions.
12. Saved views/checkpoints for repeat Admin workflows.

## 12. Non-negotiable backend boundary

These UX decisions do not alter accepted canonical design:
- stable source identifiers remain identity authority;
- names/titles do not become identity;
- Layer 2/3 cannot redefine Layer 1 Provider/Course identity;
- evidence remains separate from canonical facts;
- lifecycle remains separate from publication;
- publication remains separate from Search projection;
- private evidence does not become public because the Admin UI links to authorised metadata/actions;
- AI suggestions remain evidence-backed proposals until policy permits deterministic/approved application.

## 13. Governance rule for future chats

At the start of any CourseFinder Admin/PIM feature work, use this document together with the current architecture/master-plan/running-build documents as the default UX operating contract.

When a new chat introduces a useful UI/UX decision:
1. implement and UAT it where in scope;
2. record the durable decision here or in a superseding version;
3. preserve feature compatibility across Providers, Courses, Scholarships and future entities where applicable;
4. explicitly assess agent/automation opportunities and human-effort reduction;
5. avoid silent regression of previously accepted interaction features.

**Decision:** ACCEPTED as the cross-chat Admin/PIM UX and automation baseline.