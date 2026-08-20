# CourseFinder M1-PIM-GOV Evidence Provenance UAT — PIM Admin v2.5.0

**Date:** 20 August 2026  
**Change Control:** `CF-CHG-20260820-006`  
**Workstream:** `M1-PIM-GOV — Field Semantics, Change Control & Admin Guide`  
**Status:** **DB/SECURITY + FRONTEND SOURCE UAT PASS — DEPLOYED BROWSER UAT PENDING**

## Purpose

Replace the generic, truncated Evidence list with an explicit provenance workspace that exposes the evidence semantics already retained by CourseFinder, without rewriting any evidence or source record.

## Fresh live baseline

At initiation the Pilot contained:

- evidence artifacts: **1,567**;
- distinct sources: **43**;
- evidence types: **8**.

The prior frontend called `admin_read('evidence', {limit:1000})`, so 567 live artifacts were not reachable from the Evidence screen.

## Governed read UAT

Executed under the existing assigned `platform_admin` identity with `role=authenticated`.

`admin_read('evidence', {limit:2000})` returned:

- rows: **1,567**;
- rows containing `source_label`: **1,567**;
- rows containing `evidence_type`: **1,567**;
- rows containing `metadata`: **1,567**;
- rows containing populated `supersedes_evidence_id`: **0**.

The current corpus therefore has no populated evidence supersession links. The frontend must show an explicit no-predecessor/no-successor state rather than imply a history chain that does not exist.

**Verdict:** PASS.

## Security audit and correction

Fresh inspection found:

- `public.ui_evidence_governance_list(integer)` is `SECURITY DEFINER`;
- direct `authenticated EXECUTE` was **true**.

Pilot migration applied:

`m1_pim_gov_evidence_acl_v1`

Repository mirror:

`supabase/production-migrations/059_m1_pim_gov_evidence_acl.sql`

After migration:

- direct authenticated execute on `ui_evidence_governance_list(integer)`: **false**;
- authenticated execute on governed `public.admin_read(text,jsonb)`: **true**;
- assigned Platform Admin still retrieves all **1,567** artifacts through `admin_read`.

No evidence artifact, source record or evidence relationship was modified.

**Security verdict:** PASS.

## Frontend source implementation — PIM Admin v2.5.0

The Evidence navigation now uses a dedicated `EvidenceWorkspace` instead of generic `SimpleList`.

Implemented source semantics:

- requests `limit=2000`, covering the current full corpus;
- explicit decision-grid columns:
  - Source;
  - Evidence type;
  - Source type;
  - Captured at;
  - Validity;
  - MIME;
  - Content hash;
- searchable text across source label/type, URL, storage path, content hash and metadata;
- typeable Source and Evidence Type filters;
- reusable persistent resizable columns and Reset columns;
- selected evidence opens the common condensed right-side detail drawer;
- detail exposes:
  - Evidence ID;
  - Evidence type;
  - Source label/type;
  - Captured at;
  - validity window;
  - Source URL;
  - Storage path;
  - MIME type;
  - full content hash;
  - Entity ID;
  - superseded evidence ID;
  - metadata;
  - predecessor/successor context where relationships exist;
- detail explicitly states that capture/verification timestamps do not mean human approval;
- visible UI version is `PIM Admin v2.5.0`;
- package version is `2.5.0`.

No Evidence backend query semantics needed redesign; the existing governed row contract already carries the required provenance.

## Regression controls

The v2.5.0 source retains:

- v2.4.0 QILT/PRISMS Insights workspaces and governed `admin_read` routing;
- persistent common decision-grid resizing;
- right-side detail contract;
- v2.3.0 CRICOS/Provider-current fee presentation semantics.

No canonical Provider/Course identity, Layer 1/Layer 2 source adapter, Search projection, Zoho contract or consumer publication state is modified.

## Deployed browser UAT required

When the GitHub-triggered Cloudflare runtime can be observed:

1. login/navigation shows **PIM Admin v2.5.0**;
2. Evidence shows **1,567** records before filtering;
3. explicit Source and Evidence Type columns are present;
4. Source and Evidence Type filters operate on their displayed meanings;
5. search finds a known source URL/hash/metadata value;
6. selected row opens the right-side Evidence detail without losing list/filter state;
7. source URL, storage path, full hash, validity and metadata are reachable;
8. current records show explicit no-supersession state where applicable;
9. resize a column, refresh, confirm persistence;
10. Reset columns restores governed defaults;
11. direct browser calls to the underlying Evidence definer RPC remain unavailable;
12. QILT/PRISMS and exact `121174E` fee semantics remain intact.

## Verdict

**Evidence corpus completeness through governed read:** PASS  
**Provenance fields:** PASS  
**Security ACL:** PASS  
**Frontend source semantics:** PASS  
**Canonical/source data unchanged:** PASS  
**Cloudflare deployed/authenticated browser UAT:** PENDING

`CF-CHG-20260820-006` remains OPEN until deployed browser verification passes.
