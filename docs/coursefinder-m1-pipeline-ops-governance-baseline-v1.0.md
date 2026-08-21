# CourseFinder M1-PIPELINE-OPS Governance Baseline v1.0

**Status:** **HISTORICAL STARTING BASELINE — WORKSTREAM NOW CLOSED / PASS**  
**Date:** 21 August 2026  
**Change Control:** `CF-CHG-20260821-016`  
**Superseded for current status by:** `docs/coursefinder-master-project-plan-v1.56.md`, `docs/coursefinder-running-build-v2.59.md`, `docs/coursefinder-pim-admin-guide-v1.10.md` and `docs/uat/coursefinder-m1-pipeline-ops-technical-acceptance-2026-08-21.md`

## Purpose

This document records the exact starting baseline that resolved the governance ambiguity before `M1-PIPELINE-OPS` implementation. It remains historical evidence and must not be used as the current programme-state authority.

## Starting read order used by the workstream

Implementation began only after reconciling:

1. `PROJECT_INSTRUCTIONS.md`;
2. `change-control/README.md`;
3. `change-control/REGISTER.md`;
4. Master Project Plan v1.55;
5. Running Build v2.58;
6. Database Architecture v2.10.38;
7. Admin/PIM Design Decisions v1.10;
8. PIM Admin Guide v1.9;
9. final PIM Admin v2.11 browser acceptance;
10. `CF-CHG-20260821-016`.

The exact implementation and deployed Supabase state were then rechecked before mutation so newer parallel work was not overwritten.

## Starting implementation reference

The accepted Pilot head before Pipeline Ops implementation was:

`msinghbs-ai/Coursefinder-Pilot@b3867cc89bbfd3f76def01993a70868318016ef0`

Visible starting marker:

`PIM Admin v2.11 · governed`

## Inherited boundaries

The workstream inherited and preserved:

- Pipeline Operator rank 4 for Pipeline Control / Jobs / Sources;
- browser reads through `public.admin_read(text,jsonb)`;
- no normal browser CRUD against internal schemas;
- no browser exposure of hidden source credentials/adapter secrets;
- no restoration of broad authenticated legacy `public.ui_*` SECURITY DEFINER execution;
- private Evidence/provenance boundaries from `CF-CHG-20260820-006`;
- accepted PIM v2.11 browser/security baseline from `CF-CHG-20260820-015`;
- separately governed operational mutations rather than implicit retry/replay/reset permission.

## Final outcome

The workstream subsequently passed implementation and real-volume UAT.

Current accepted Pilot head:

`msinghbs-ai/Coursefinder-Pilot@848e302b19186cb0a751f74f23f06a244c5b0b2d`

Current visible marker:

`PIM Admin v2.11 · Pipeline Ops v1.0 · governed`

Authoritative current acceptance:

`docs/uat/coursefinder-m1-pipeline-ops-technical-acceptance-2026-08-21.md`

`CF-CHG-20260821-016` is **CLOSED / PASS**.
