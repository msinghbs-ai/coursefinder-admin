# Coursefinder Running Build v2.7

**Date:** 12 August 2026  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.4.md`  
**Master plan:** `docs/coursefinder-master-project-plan-v1.6.md`

## Current programme position

- Layer 1: AU PASS; NZ PASS; CA ACTIVE; GB/US/IE queued; DE deferred/blocked.
- CA identity architecture: PASS.
- CA Provider authority and Course authority are now independent gates.
- CA final production gate remains blocked on federated Course-source coverage and remaining production UAT.
- CA Layer 2A runs in parallel and cannot create canonical identity.

## CA Provider authority implementation

Worker:
- `layer1-ca-live-v1.1.0`
- Supabase function version `2`
- deployment SHA-256 `f8e818f16bd33c7a58e1b1c4a92c0a72e222d2e32946f27dbbcf3287519504b3`
- `verify_jwt=true`
- Platform Admin required.

New service RPC:
- `svc_layer1_apply_ca_ircc_providers(...)`

Behaviour:
- live IRCC acquisition;
- DLI-deduplicated Provider records;
- bounded offset/batch execution;
- private evidence + SHA-256;
- Provider-only APPLY using `ircc_dli` identity;
- zero Course writes;
- Course coverage blocker returned independently.

Reproducible migrations:
- Pilot `20260812133000_ca_ircc_provider_only_apply.sql`;
- Admin `051_ca_ircc_provider_only_apply.sql`.

Pilot worker commit:
- `29c91171eae906892d025fbeb88b0c0150ed78e4`.

## CA dual-authority identity

Provider:
`CA + ircc_dli + DLI_number`

Course:
`UUIDv5(verified DLI + namespaced stable local programme key)`

APS/MTCU/CIP:
validation/classification metadata only.

Titles:
mutable metadata; never identity.

Migration 050 enforces these rules in `svc_layer1_apply_scoped_course_records(...)`.

## StatsCan Layer 2A

First authenticated run reached the worker and job layer but v0.2.0 failed because `getCubeMetadata` was implemented as a PID-addressed GET.

Corrected worker:
- `statcan-ca-psis-etl-v0.2.1`;
- Supabase function version `3`;
- SHA-256 `3d069c7e3f3f87f8cafd54b8c5405d0a4c645f55711db2113e2f5152d0f51d5c`;
- uses POST `/getCubeMetadata` with productId body;
- full-table CSV GET unchanged;
- `apply=true` still blocked.

StatsCan corrective Pilot commit:
- `6bd544c931f29790a2f134a300d59c3ae59a6c36`.

Pilot Function HTTP error-body handling:
- `d58a1a0cbfe09e6776ef2d9e516b83a747e633e4`.

## Security/performance validation

Provider-only RPC privileges:
- anon execute: false;
- authenticated execute: false;
- service_role execute: true.

Post-DDL Supabase security advisor:
- no newly exposed CA write contract;
- INFO RLS-with-no-policy notices remain consistent with internal deny-by-default schemas;
- WARN notices for authenticated UI SECURITY DEFINER RPCs are existing broader Pilot hardening items;
- leaked-password protection warning remains an environment Auth hardening item.

Performance advisor:
- unused-index INFO notices only;
- no new CA missing-FK-index issue reported.

Current pre-Provider-APPLY state:
- CA Providers: 0;
- CA Courses: 0.

## Next execution

1. Canada Layer 1 `Validate batch` on v1.1.0.
2. `Apply CA batch` — now Provider-only.
3. Re-run same Provider batch for idempotency.
4. Continue bounded IRCC batches until full source reconciled.
5. Run StatsCan PSIS dry-run on v0.2.1 and inspect real CSV diagnostics.
6. Establish verified StatsCan/Ontario/BC source-to-DLI mappings.
7. Continue federated Course-source UAT separately.
