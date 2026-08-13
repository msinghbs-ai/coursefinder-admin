# CourseFinder Layer 1 Canada — Ontario First-Party Course Identity UAT v1.2

**Date:** 14 August 2026  
**Scope:** CA Gate B — Ontario first-party Course identity expansion  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.10.md`

## Result

- Ontario Provider mapping: **PASS 24/24**.
- Algonquin full-source: **PASS — 88**.
- Conestoga full-source: **PASS — 315**.
- Fanshawe partial PGWP source: **PASS — 80**.
- Mohawk current-open source: **PASS — 108**.
- Durham full-current API: **PASS — 150**.
- Niagara lifecycle-aware source: **PASS — 135**.
- Overall CA Gate B: **ACTIVE/BLOCKED — country Course-source coverage incomplete**.

## Niagara identity finding

Niagara's official availability source exposes 135 programme rows. The displayed programme code is not unique enough for base identity: code `0122` is reused across three distinct Broadcasting streams.

The rejected `niagara_program_code` UAT write was isolated, unpublished and removed before gate promotion. No search documents, campuses, intakes or scholarship references existed for those temporary rows.

Each Niagara programme row also exposes a first-party programme page ID in the official programme URL. Validation showed:
- rows: 135;
- page IDs present: 135/135;
- distinct page IDs: 135;
- duplicate page IDs: 0;
- distinct published programme codes: 133.

Accepted identity scheme:
`UUIDv5(IRCC DLI O19396019469 + niagara_program_page_id)`.

Published Niagara programme code is retained only as non-identifying registration metadata using `niagara_published_program_code`.

## Lifecycle-aware reconciliation

`svc_layer1_apply_scoped_course_records(...)` now accepts source-normalised Course lifecycle:
- `active`;
- `suspended`;
- `inactive`;
- `unknown`.

Sources omitting lifecycle remain backward-compatible and default to `active`.

Niagara lifecycle is derived from all published intake states per programme:
- any Open or Waitlisted intake -> `active`;
- otherwise Suspended -> `suspended`;
- otherwise Closed -> `inactive`;
- unresolved -> `unknown`.

Accepted Niagara lifecycle counts:
- active: **114**;
- suspended: **16**;
- inactive: **5**;
- unknown: **0**.

## Niagara APPLY / idempotency / integrity

Corrected first APPLY:
- records: 135;
- created: 135;
- conflicts: 0.

Full-source repeat:
- created: 0;
- existing: 135;
- conflicts: 0.

Integrity:
- UUIDv5 mismatch: 0;
- duplicate page IDs: 0;
- wrong Provider links: 0;
- title-derived stable keys: 0;
- rejected `niagara_program_code` identities remaining: 0;
- secondary registrations: 135 across 133 published codes.

## Autonomous runtime PASS

Worker: `layer1-ca-niagara-catalogue-v0.2.1`.

The official source moved to the current admissions availability route during UAT; the registered source was corrected and refreshed before runtime acceptance.

Autonomous Edge replay:
- HTTP 200;
- parsed: 135;
- 0 created / 135 existing;
- lifecycle: 114 active / 16 suspended / 5 inactive / 0 unknown;
- parser conflicts: 0;
- private HTML evidence captured with SHA-256 and Storage path.

## Pilot execution control

Niagara uses a short-lived one-time nonce rather than a browser JWT or reusable outbound Pilot key. The nonce is generated server-side, expires after two minutes and is consumed once. Browser roles cannot execute the nonce-consume RPC.

ACL validation:
- Course APPLY RPC: anon=false, authenticated=false, service_role=true;
- nonce consume RPC: anon=false, authenticated=false, service_role=true.

The Pilot-only execution mechanism remains temporary and must be removed during production hardening.

## Current CA Course state

Canonical CA Courses: **876**.

Composition:
- Algonquin 88;
- Conestoga 315;
- Fanshawe 80 partial;
- Mohawk 108;
- Durham 150;
- Niagara 135.

Full/current accepted source Courses: **796**.  
Partial-source Courses: **80**.

## Security status

No new CA identity-write exposure was introduced. The new nonce table is deny-by-default with RLS and no browser policy. Existing project-level authenticated UI SECURITY DEFINER warnings and leaked-password protection remain Phase 7 items.

## Gate state

**Six Ontario institutional Course source patterns now PASS, but `CA_FEDERATED_COURSE_SOURCE_COVERAGE_BLOCKER` remains active. Continue institutional coverage; do not promote Canada yet.**
