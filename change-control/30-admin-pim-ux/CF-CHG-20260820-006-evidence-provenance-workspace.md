# CF-CHG-20260820-006 — Evidence provenance workspace completeness and semantics

**Status:** OPEN / AUDITED — IMPLEMENTATION IN PROGRESS  
**Category:** 30-admin-pim-ux  
**Initiated:** 20 August 2026 11:28 AEST (UTC+10)  
**Origin chat/workstream:** `M1-PIM-GOV — Field Semantics, Change Control & Admin Guide`  
**Owner:** CourseFinder Admin/PIM governance  
**Change class:** Admin UX / evidence provenance / history visibility / completeness of Admin read presentation

## Trigger

The semantic audit found that the current Evidence screen uses the generic `SimpleList` workspace with `limit=1000` and chooses the first nine JSON keys dynamically.

Live Pilot contains **1,567 evidence artifacts** across **43 sources** and **8 evidence types**. Therefore the current screen can omit 567 current evidence artifacts and can omit high-value semantic fields such as `source_label` and `evidence_type` depending on object key order.

This conflicts with the PIM Admin Guide requirement that an Evidence view answer which source supplied a fact, which snapshot/page/file was used, when it was captured, what hash identifies it, validity/freshness context and supersession/history where available.

## Accepted correction

Create an explicit Evidence provenance workspace rather than using generic arbitrary-key rendering.

Required presentation:

- load all current evidence within the existing governed Admin cap;
- explicit Source, Evidence Type, Source Type, Captured At, Validity, MIME and Content Hash columns;
- searchable/filterable Source and Evidence Type;
- source URL and storage path visible in detail;
- full content hash visible in detail;
- metadata visible as evidence/source context, not silently dropped;
- `supersedes_evidence_id` and reverse supersession relationships shown where present;
- persistent resizable columns and Reset columns using the common v2.4 primitive;
- condensed right-side detail preserving list/filter state;
- visible UI version increment.

## Security / backend decision

No new direct evidence RPC is required. `public.admin_read('evidence',...)` already enforces Curator-or-higher role and returns the required row fields. This change should remain frontend/governance-only unless fresh inspection proves a missing read contract.

## Source baseline

Fresh live counts at initiation:

- evidence artifacts: 1,567
- distinct sources: 43
- evidence types: 8

No evidence data rewrite is authorised.

## UAT

1. Evidence workspace loads 1,567 current rows, not a 1,000-row truncation.
2. Source label and evidence type are explicit columns.
3. Search/filter operates on visible semantic fields.
4. Source URL, storage path, hash, validity and captured time are reachable.
5. Metadata is inspectable.
6. Supersession context is visible when present.
7. column width persistence/reset works through the common primitive.
8. Curator role boundary remains unchanged.
9. no evidence artifact or source record is modified.
10. deployed browser UAT after GitHub-triggered release.

## Rollback

Revert the Evidence frontend workspace to the preceding source version. Do not delete or rewrite evidence artifacts to roll back an Admin presentation change.

## Decision / status history

| Timestamp | Status | Decision / event | Reference |
|---|---|---|---|
| 20 Aug 2026 11:28 AEST | AUDITED / OPEN | Generic Evidence screen proven truncated and semantically arbitrary | `M1-PIM-GOV` / live Pilot audit |

## Closure

**Final status:** OPEN / IMPLEMENTATION IN PROGRESS  
**Closed at:** N/A  
**Outcome:** Pending explicit Evidence provenance workspace and UAT.
