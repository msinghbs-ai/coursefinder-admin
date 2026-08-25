# CourseFinder M2.2 Automated UAT — Security / Search / Showcase

**Run date:** 25 August 2026  
**Status:** IN PROGRESS / PARTIAL PASS / MATERIAL BLOCKERS RETAINED  
**Change Controls:** CF-CHG-20260825-032, -033, -034, -035

## Evidence baseline

- Admin governance baseline before M2.2: `34dd22215bb937c8f0ef131c36a6011893ade714`.
- Accepted M2.1 Pilot baseline: `cba0e9ecd2f4878bfd51ad5278e60046b1fae581`.
- Current M2.2 Pilot source at this evidence point: `045d5960ab1932eaa86ad459041ab3d5cd0659d9`.
- Supabase Pilot: `fxcwkweaxjtknorudmwp`, Mumbai `ap-south-1`, PostgreSQL 17.6.1.
- Supabase organisation plan: `pro`.

## Security UAT

| Test | Evidence | Result |
|---|---|---|
| Pro entitlement | live organisation plan = `pro` | PASS |
| Leaked-password protection | Security Advisor still reports disabled | BLOCKED |
| Direct Layer 2 privileged RPC | authenticated/anon EXECUTE = false; service_role = true | PASS |
| Hardened Layer 2 mutation boundary | `layer2-config-control` v3, `verify_jwt=true`, rank validation, policy allowlist | PASS (DB/Edge boundary) |
| Security Advisor regression | former Layer 2 SECURITY DEFINER warning absent; leaked-password WARN remains | PASS for RPC fix / BLOCKED overall Auth hardening |
| Search preview RPC exposure | anon/authenticated EXECUTE false; service_role true for lookup/search preview | PASS |
| Search raw schema browser access | anon/authenticated `search` schema USAGE false; no direct table grants found | PASS |
| Vault browser access | anon/authenticated Vault schema USAGE false | PASS |
| Evidence bucket | private bucket, 50 MiB limit, explicit MIME allowlist | PASS configuration / deeper signed-object negative tests pending final suite |
| Search gate-table RLS | three gate tables have RLS disabled; normal browser roles lack schema/table access | WARN / explicit Production disposition required |

## Data/regression invariants

- catalogue Courses: 43,461;
- Providers: 3,085;
- Search documents: 33,105;
- AU Search documents: 26,648;
- NZ Search documents: 6,457;
- published entities: 0;
- Search Projection generation: 22;
- Search Projection hash: `b4660ebc15851620bd111c82a74a19899c43a4560e5d2eb571b40e3c64bf77ee`.

No broad publication was enabled during M2.2 implementation.

## Search UAT

### Real representative cohort

Validated current Search rows include:

- UQ `102784C` — Bachelor of Computer Science (Honours);
- UQ `092454G` — Master of Data Science;
- UQ `082960F` — Bachelor of Nursing (Honours);
- RMIT `111279A` — Associate Degree in Business.

The UQ Nursing example demonstrates regulatory tuition distinct from Provider-current annual tuition, official Course URL, Intake and English requirements while remaining unpublished.

### Filter correctness

Query `nursing` with:

- country AU;
- subdivision AU-QLD;
- Provider-current annual tuition <= 50,000;
- Intake required;
- English required;

returned the expected UQ Bachelor of Nursing (Honours), preserving hard-filter semantics and separate fee meanings.

### Query-plan evidence

- initial combined exact-code/FTS preview produced a sequential plan at ~506 ms and was rejected;
- new exact lookup indexes changed the underlying exact predicate to BitmapOr/index scans at ~31 ms measured cold execution;
- direct AU FTS query `data science` used `course_documents_tsv_idx` GIN and executed at ~18 ms;
- the current rich JSON preview wrapper remains ~0.38–0.44 s in measured calls and therefore is **not yet a Production performance PASS**.

This result is deliberately retained rather than hidden by UI loading state.

## pgvector benchmark decision

- extension: pgvector 0.8.2 installed;
- embeddings: 0;
- embedding jobs: 0;
- query cache: 0;
- governed `integration.model_profiles`: 0;
- repository references to an approved embedding API key/profile: none found;
- prior `search-vector-gate` remains retired.

**Decision:** vector/hybrid relevance comparison is **DEFERRED / NOT ACCEPTED** in M2.2 because there is no governed reproducible embedding model/profile/corpus. Synthetic or fabricated embeddings are prohibited. FTS/exact/filter remains the stable Friday contract.

## Deployed browser UAT

The Pilot workflow is configured for SHA-bound desktop and mobile Chromium testing against the deployed Cloudflare Worker. At this evidence point, the current SHA workflow run is still pending and is therefore not counted as PASS. Final M2.2 handover must reconcile the completed run/artifacts to the final deployed source SHA.

## Recovery UAT

Production is intentionally a clean later environment. M2.2 defines the Pro backup/PITR/restore acceptance requirements but does not claim Production DR PASS before that Production project exists and an isolated restore is executed. Restore proof is deferred to the accepted Production establishment gate.

## Overall current verdict

**M2.2 is not yet PASS.**

Material remaining items:

1. leaked-password protection remains disabled despite Pro entitlement;
2. final deployed desktop/mobile UAT must complete on final source SHA;
3. rich Search preview latency requires optimisation or explicit non-acceptance for Production;
4. Production Search gate-table RLS policy disposition and Production release/recovery implementation remain governed future actions;
5. vector/hybrid remains a candidate, not accepted Search.
