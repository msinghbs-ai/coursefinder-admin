# CF-CHG-20260820-006 — Evidence provenance workspace completeness and semantics

**Status:** APPLIED / DB-SECURITY PASS + FRONTEND SOURCE PASS — DEPLOYED BROWSER UAT PENDING  
**Category:** 30-admin-pim-ux  
**Initiated:** 20 August 2026 11:28 AEST (UTC+10)  
**Origin chat/workstream:** `M1-PIM-GOV — Field Semantics, Change Control & Admin Guide`  
**Owner:** CourseFinder Admin/PIM governance  
**Change class:** Admin UX / evidence provenance / history visibility / security ACL

## Trigger

The prior Evidence screen used generic `SimpleList` with `limit=1000` and arbitrary first-key columns. Live Pilot contains **1,567 evidence artifacts** across **43 sources** and **8 evidence types**, so 567 current artifacts were not reachable and important semantic fields such as Source and Evidence Type were not guaranteed visible.

The audit also found `public.ui_evidence_governance_list(integer)` is `SECURITY DEFINER` and was directly executable by `authenticated`.

## Accepted correction

Evidence is now treated as an explicit provenance workspace, not a generic JSON list.

PIM Admin v2.5.0 source:

- requests all current evidence through `admin_read('evidence',{limit:2000})`;
- explicit Source, Evidence Type, Source Type, Captured At, Validity, MIME and Content Hash columns;
- search across source, URL, storage path, hash and metadata;
- typeable Source and Evidence Type filters;
- persistent resizable columns and Reset columns;
- condensed right-side detail preserving list/filter state;
- detail exposes Evidence ID/type, source label/type, captured time, validity, source URL, storage path, MIME, full hash, entity ID, metadata and supersession context;
- capture/verification timestamps are explicitly not presented as human approval;
- visible/package version is `2.5.0`.

No evidence artifact/source record is rewritten.

## Live governed read UAT

Executed under assigned `platform_admin` with `role=authenticated`.

`admin_read('evidence',{limit:2000})` returned:

- total rows: **1,567**;
- rows with `source_label`: **1,567**;
- rows with `evidence_type`: **1,567**;
- rows with `metadata`: **1,567**;
- rows with populated `supersedes_evidence_id`: **0**.

The current corpus has no populated supersession links. Admin therefore shows explicit no-predecessor/no-successor state rather than inventing history.

## Security correction

Pilot migration:

`m1_pim_gov_evidence_acl_v1`

Repository mirror:

`supabase/production-migrations/059_m1_pim_gov_evidence_acl.sql`

After migration:

- direct authenticated EXECUTE on `ui_evidence_governance_list(integer)`: **false**;
- authenticated EXECUTE on governed `public.admin_read(text,jsonb)`: **true**;
- assigned Platform Admin still retrieves all **1,567** evidence artifacts through the governed Curator+ path.

## Semantic authority

The PIM Admin Guide Evidence section already defines the correct provenance semantics and remains authoritative. No canonical architecture change is required.

Evidence remains evidence/provenance; it does not become canonical truth merely because it was captured, hashed or verified.

## UAT evidence

`docs/uat/coursefinder-m1-pim-gov-evidence-v2.5.0-uat-2026-08-20.md`

Passed:

1. full current evidence corpus reachable through governed read;
2. source/evidence-type/provenance fields preserved;
3. explicit Evidence workspace implemented in source;
4. source/hash/metadata/detail context reachable by design;
5. no fabricated supersession history;
6. direct browser access to underlying SECURITY DEFINER projection removed;
7. v2.3 fee and v2.4 Insights semantics retained in source;
8. no canonical/source data mutation.

## Deployed browser UAT required for closure

1. visible `PIM Admin v2.5.0`;
2. Evidence displays 1,567 records before filtering;
3. explicit Source and Evidence Type columns;
4. search/filter semantic behaviour;
5. right-side Evidence detail preserves grid/filter state;
6. source URL/storage/full hash/validity/metadata reachable;
7. explicit no-supersession state on current corpus;
8. persistent resize and Reset columns;
9. underlying Evidence definer RPC is not directly browser callable;
10. retained QILT/PRISMS and `121174E` fee behaviour.

## Rollback

Frontend can revert to the preceding source independently. Reopening direct authenticated EXECUTE on the Evidence SECURITY DEFINER projection requires explicit security-governance approval. Never delete or rewrite evidence artifacts to roll back Admin presentation.

## Decision / status history

| Timestamp | Status | Decision / event | Reference |
|---|---|---|---|
| 20 Aug 2026 11:28 AEST | AUDITED / OPEN | Generic Evidence screen proven truncated and semantically arbitrary | `M1-PIM-GOV` / live Pilot audit |
| 20 Aug 2026 | SECURITY REVIEW | Underlying Evidence projection confirmed SECURITY DEFINER + direct authenticated EXECUTE | live Pilot privilege audit |
| 20 Aug 2026 | APPLIED | Evidence ACL hardened; frontend v2.5.0 provenance workspace staged | `m1_pim_gov_evidence_acl_v1` / feature branch |
| 20 Aug 2026 | TECHNICAL UAT PASS | 1,567-row governed read and provenance fields validated; no evidence rows changed | Evidence v2.5.0 UAT |

## Closure

**Final status:** OPEN — DB/SECURITY PASS + FRONTEND SOURCE PASS / DEPLOYED BROWSER UAT PENDING  
**Closed at:** N/A  
**Outcome:** Full current Evidence corpus and provenance semantics restored to governed Admin source; runtime/browser verification remains pending.
