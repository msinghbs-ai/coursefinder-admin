# CF-CHG-20260823-028 — M1 Final Acceptance & Baseline Freeze

**Status:** CLOSED / PASS  
**Category:** 80-uat-release-operations  
**Initiated:** 23 August 2026 20:12 AEST  
**Origin chat/workstream:** 13. M1-ACCEPTANCE — final chat  
**Owner:** M1-ACCEPTANCE  
**Change class:** governance / release / operations / documentation

## Trigger

Final Milestone 1 acceptance gate authorised as the only workstream permitted to call CourseFinder Milestone 1 complete.

## Problem / requested outcome

Independently reconcile current governance, Change Controls, Admin documentation, Pilot implementation and deployed Mumbai Supabase state; run final count/integrity/security/performance/search smoke UAT; and freeze the M1 architecture/release baseline only if every declared M1 gate is PASS, deliberately deferred outside M1, rejected/not admitted, or covered by an explicitly accepted residual risk.

## Affected surfaces / related workstreams

- AU/NZ canonical Layer 1 and CRICOS facts;
- QILT, PRISMS, Scholarships and first-party Course Facts;
- Pipeline Layer 1–4 operations;
- PIM/Admin, Evidence and Data Quality;
- Search/FTS/vector and publication;
- Website/Zoho consumer contracts;
- security/ACL/RBAC/RLS/Storage/Edge Functions;
- performance/responsiveness and automated UAT;
- User Guide, PIM Admin Guide and Operations Runbook;
- programme master plan, running build and frozen M1 architecture baseline.

## Semantic impact

No canonical semantic change. This record accepts and freezes the already governed M1 Pilot baseline. It does not change canonical identity, field meaning, source authority, grain/cardinality, Search admission, publication semantics or Zoho meaning.

## Before

All precursor M1 gates were individually governed, but the authoritative master plan/running-build had not yet recorded the final Performance and Security closure as a single Milestone 1 acceptance decision. No dedicated M1 frozen architecture baseline existed.

## After

Milestone 1 is **COMPLETE / ACCEPTED for the Pilot baseline**. The baseline is frozen by `docs/coursefinder-m1-frozen-architecture-baseline-v1.0.md`, Master Project Plan v1.65 and Running Build v2.67. Production remains separately gated and broad publication remains unauthorised.

## Source authority / evidence

Authoritative governance source: `msinghbs-ai/coursefinder-admin`.

Implementation authority:

- Pilot main: `msinghbs-ai/Coursefinder-Pilot@133b81734e435f9dea5ffb3ddd943e71d2930696`;
- deployed browser performance acceptance remains bound to `1bcb96d26f7c701ec6cf91d771016cb6405f51b2`, with subsequent security-only commits layered on top;
- live Supabase: `coursefinder_Pilot` / `fxcwkweaxjtknorudmwp`, Mumbai (`ap-south-1`).

Final live acceptance checks on 23 August 2026 AEST proved:

- 3,085 Providers / 43,461 Courses total;
- AU 1,546 Providers / 26,648 Courses;
- NZ 409 Providers / 6,457 Courses;
- 33,105 `course-v3` Search documents;
- projection generation 22 and accepted combined hash `b4660ebc15851620bd111c82a74a19899c43a4560e5d2eb571b40e3c64bf77ee`;
- Search refresh dry-run 0 new / 0 changed / 0 removed / 33,105 unchanged and enrichment 0 changed / 33,105 unchanged;
- 0 published Search documents and 0 `publishing.entity_states` rows;
- 0 embeddings, 0 embedding jobs and 0 query embedding cache rows;
- 0 Provider/Course/Search orphan or duplicate-stable-key integrity findings in the bounded checks;
- 1,567 Evidence artifacts and a private 50 MiB MIME-restricted `evidence` Storage bucket;
- exactly one browser-executable authenticated `public` application RPC: `public.admin_read(text,jsonb)`, SECURITY INVOKER; anon denied;
- Supabase Security Advisor: no Critical/Error findings; INFO-only intentional RLS/no-policy findings plus the governed leaked-password WARN;
- Performance Advisor: INFO-only unindexed-FK/unused-index observations; no final performance gate blocker;
- 2,033 provider outcome rows, 2,270 student-flow observations, 4 scholarships, 14 first-party Course-Fact source records, 79,572 fee rows, 18 intake rows, 32 English-requirement rows and 10 governed course links.

## Implementation references

- Supabase migration(s): none introduced by final acceptance; accepted live security migrations include `20260823062726_m1_security_release_remove_legacy_provider_rpc` and `20260823095439_m1_security_release_edge_allowlist_cleanup`.
- Git repository/commit(s): Admin baseline before acceptance `79a9d01946551e9b4bce6667b5d02225117203fe`; Pilot main `133b81734e435f9dea5ffb3ddd943e71d2930696`.
- Issue/PR: precursor evidence includes Pilot PRs #27–#30 and accepted automated UAT run `32622164346`.
- RPC/API objects: `public.admin_read(text,jsonb)`, `search.refresh_course_documents_v3(boolean)` and governed Website/Zoho consumer contracts.
- UI version: PIM Admin v2.12 + Pipeline Ops v1.0 + Evidence v1.0 + Data Quality v1.0 + Access Admin v1.0 + Publication Governance v1.0.

## UAT

Final acceptance UAT is recorded in `docs/uat/coursefinder-m1-final-acceptance-technical-acceptance-2026-08-23.md`.

Result: **PASS**.

The final acceptance reran live counts, referential/duplicate integrity checks, Search deterministic dry-run, publication/vector closed-state checks, public RPC ACL enumeration, Storage configuration check and Supabase security/performance advisers, and reconciled the current Admin/Pilot main SHAs with the precursor acceptance records.

## Rollback / reversion

This change introduces governance/documentation only. Revert the acceptance documentation commit(s) if evidence is later shown to be invalid. Do not roll back deployed Pilot data or security changes merely to revert acceptance wording. Any post-freeze technical change must open a new Change Control and explicitly state whether it invalidates the M1 frozen baseline.

## Documentation impact

- PIM Admin Guide: retained v1.15; no semantic change.
- Architecture: new frozen M1 baseline v1.0 references Database Architecture v2.10.40.
- Running build: v2.67.
- Master plan: v1.65.
- UAT/design docs: new final acceptance technical acceptance record.
- Zoho contract: retained; no new DTO/semantic change.

## Explicitly outside M1 / carried forward by decision

The following are not silently open M1 work:

1. Supabase leaked-password protection — deferred for Pilot under `CF-CHG-20260823-022`; mandatory Production go-live gate.
2. M1-SEARCH-VECTOR — rejected/not admitted; any vector/hybrid production attempt requires a new M2 or later gate.
3. QUT first-party Course Facts acquisition — explicitly deferred under `CF-CHG-20260820-003`; future enrichment work only.
4. Broad catalogue publication — not authorised by M1; current Pilot is fully unpublished. Production/broader release requires a separately governed cutover/publication decision.
5. Physical deletion of retired diagnostic/UAT Edge slugs — cleanup only; current JWT-protected HTTP 410 tombstones are accepted Pilot residue.
6. Production identity model for retained custom-auth ingestion workers — must be reassessed for Production; Pilot exception remains time-bounded and service-control-plane scoped.
7. Further country expansion and wider enrichment coverage beyond the accepted AU/NZ M1 baseline — post-M1 programme work, not an M1 completion blocker.
8. INFO-only performance-advisor cleanup — future optimisation only unless measured workloads show regression.

## Decision / status history

| Timestamp | Status | Decision / event | Reference |
|---|---|---|---|
| 23 Aug 2026 20:12 AEST | PROPOSED | Final acceptance gate initiated | 13. M1-ACCEPTANCE — final chat |
| 23 Aug 2026 20:xx AEST | UAT PASS | Governance, live Supabase, Search/integrity/security/performance smoke and repository authority reconciled | Final acceptance technical UAT |
| 23 Aug 2026 20:xx AEST | CLOSED / PASS | M1 Pilot baseline accepted and frozen; post-M1 items explicitly enumerated | This record |

## Closure

**Final status:** CLOSED / PASS  
**Closed at:** 23 August 2026 AEST  
**Outcome:** CourseFinder Milestone 1 is accepted complete for the governed Pilot baseline. Production readiness remains subject to explicitly separate gates, most notably leaked-password protection and future publication/cutover approval.