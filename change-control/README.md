# CourseFinder Change Control

**Status:** AUTHORITATIVE CHANGE-TRACEABILITY DIRECTORY  
**Effective:** 20 August 2026

This directory is intentionally separate from `docs/`. Core architecture, project plans, running-build, design specifications and UAT narratives remain under `docs/`; material implementation/semantic changes are traced here.

## Read order

Every CourseFinder workstream must first read:

1. `/PROJECT_INSTRUCTIONS.md`
2. `/change-control/README.md`
3. `/change-control/REGISTER.md`
4. the relevant category directory and overlapping open records
5. the latest applicable core governance documents under `/docs`

## Hierarchy

| Folder | Primary ownership |
|---|---|
| `00-governance-programme/` | programme governance, project operating rules, major cross-cutting decisions |
| `10-architecture-data-model/` | canonical schema, identity, relationship/grain, field semantics with architecture impact |
| `20-layer1-regulatory-ingestion/` | Layer 1 regulatory identity/source acquisition and canonical regulatory facts |
| `30-admin-pim-ux/` | Admin/PIM workflows, field presentation, decision grids, PIM Admin Guide |
| `40-layer2-enrichment/` | QILT, PRISMS and other enrichment acquisition/mapping/observation changes |
| `50-search-api-consumers/` | Search projection, API/website consumer contracts and publication behaviour |
| `60-zoho-integration/` | curated Zoho contract, mappings, payload behaviour and Zoho-specific integration |
| `70-security-platform/` | security, ACL/RBAC, platform/runtime/infrastructure controls |
| `80-uat-release-operations/` | release gates, operational/runbook changes, rollback and production/UAT process |

Choose one primary category. List all other affected categories/surfaces inside the record. Do not duplicate the same Change ID in multiple folders.

## Naming

Change records use:

`CF-CHG-YYYYMMDD-NNN-short-slug.md`

The Change ID never changes after creation, even if the record moves between PROPOSED, APPLIED, UAT PASS and CLOSED.

## Lifecycle

`PROPOSED → APPROVED (when needed) → APPLIED → UAT PASS → CLOSED`

Other valid states: `BLOCKED`, `REJECTED`, `SUPERSEDED`.

Not every change needs a separate approval step; autonomous implementation may move directly from PROPOSED to APPLIED when already authorised by the task and architecture. Semantic/identity/authority changes require explicit review before being treated as accepted.

## Mandatory record content

Use `templates/change-record-template.md`. Every material record must capture:

- Change ID and title;
- initiated timestamp with timezone;
- exact originating chat/workstream;
- owner/category/change class/trigger;
- problem/requested outcome;
- affected surfaces and related workstreams;
- semantic impact;
- before/after;
- source authority/evidence;
- implementation refs;
- UI version if applicable;
- UAT;
- rollback;
- status/closure timestamp;
- links to PIM Admin Guide/UAT/design docs when relevant.

## Cross-chat rule

A new or existing chat that touches a material platform surface must search `REGISTER.md` and the owning category before changing it. If an open record already covers the work, update that record rather than creating a competing change.

Conversation history is supporting context; the record is the durable cross-chat traceability mechanism.

## Register rule

`REGISTER.md` is an index, not the detailed source of truth. Keep it concise: Change ID, category, title, origin, initiated time, status, UI version and record path.

Detailed investigation and evidence belong in the individual record and linked documents.