# CourseFinder Running Build v2.47

**Status:** CURRENT GOVERNED SOURCE BUILD — CLOUDFLARE RUNTIME OBSERVATION PENDING  
**Date:** 20 August 2026  
**Supersedes:** `docs/coursefinder-running-build-v2.46.md`  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.37.md`  
**Master plan:** `docs/coursefinder-master-project-plan-v1.43.md`  
**Evidence UAT:** `docs/uat/coursefinder-m1-pim-gov-evidence-v2.5.0-uat-2026-08-20.md`

## Build delta

v2.47 preserves the accepted Layer 1, Layer 2, Search, fee-semantic and Insights state and advances the Evidence governance workspace.

### PIM Admin v2.5.0

The generic 1,000-row Evidence list is replaced by an explicit provenance workspace.

Current live evidence baseline:

- evidence artifacts: **1,567**;
- distinct sources: **43**;
- evidence types: **8**.

The governed `admin_read('evidence',{limit:2000})` returns all 1,567 current artifacts and every returned row includes Source label, Evidence type and metadata.

Evidence presentation now includes explicit Source, Evidence Type, Source Type, Captured At, Validity, MIME and Content Hash columns plus searchable/filterable provenance and right-side detail for URL, storage path, full hash, metadata and supersession context.

Current corpus has zero populated `supersedes_evidence_id` links; Admin therefore shows explicit no-supersession state rather than implying history.

### Evidence security boundary

Pilot migration:

`m1_pim_gov_evidence_acl_v1`

Repository mirror:

`supabase/production-migrations/059_m1_pim_gov_evidence_acl.sql`

Direct `authenticated` EXECUTE on `public.ui_evidence_governance_list(integer)` is now false. Browser access remains through Curator-or-higher `public.admin_read`.

Assigned Platform Admin role-context UAT still returns all 1,567 artifacts.

No evidence/source rows were modified.

## Preserved PIM governance state

### `CF-CHG-20260820-001`

CRICOS `121174E` fee semantics remain accepted and retained through v2.5.0:

- Tuition Fee AUD 132,900;
- Non-Tuition Fee AUD 0;
- Estimated Total Course Cost AUD 132,900;
- registered total-course basis;
- source-not-supplied year;
- separate Provider-current fee section.

### `CF-CHG-20260820-005`

QILT/PRISMS Insights remain retained through v2.5.0:

- QILT outcomes: 2,033;
- PRISMS raw observations: 2,270;
- PRISMS paired source rows: 1,135;
- AU-VIC + higher_education pairs: 112;
- no manufactured PRISMS Provider/Course identity;
- direct authenticated execute removed from the four public QILT/PRISMS definer projections.

## Preserved AU Layer 1 / Course Facts / Search

- Providers: 1,546
- active CRICOS Courses: 26,648
- Layer 1 adapter: `layer1-au-depth-v1.6.0`
- qualified AU Provider-current sources: RMIT + UQ
- bounded Provider-current Courses: 10
- Search Course Documents: 33,105
- fee/intake/English Search enrichment admitted: 0

No Admin governance change grants Search/Website/Zoho publication.

## Change Control

- `CF-CHG-20260820-001` — technical + frontend source PASS / deployed browser pending
- `CF-CHG-20260820-002` — CLOSED / PASS
- `CF-CHG-20260820-003` — DEFERRED
- `CF-CHG-20260820-004` — CLOSED / PASS
- `CF-CHG-20260820-005` — technical + frontend source PASS / deployed browser pending
- `CF-CHG-20260820-006` — Evidence DB/security + frontend source PASS / deployed browser pending

## Documentation decision

Updated:

- Running Build → v2.47
- Master Plan → v1.43
- Evidence UAT
- Change Control record/register

Unchanged because canonical semantics did not change:

- Database Architecture remains v2.10.37
- PIM Admin Guide v1.0 remains semantically correct
- Zoho consumer contract unchanged
- Search contract unchanged

## Remaining runtime gate

The current tool environment cannot independently observe the unindexed Cloudflare Worker runtime. Deployed authenticated browser UAT remains required for open PIM governance changes before closure.
