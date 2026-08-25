# CourseFinder Production Environment Build & Operations Guide v1.1

**Issued:** 25 August 2026  
**Supersedes:** v1.0  
**Status:** CURRENT DESIGN / Production establishment not yet executed

This version carries forward v1.0 and records the M2.2 changes introduced by CF-CHG-20260825-032/-034.

## Production establishment rules

- Production is a clean separate Supabase project; Pilot is never renamed into Production authority.
- Preferred Production database region remains Sydney `ap-southeast-2` unless explicitly changed.
- Production receives separate Auth authority, Storage, Vault/secrets, API keys, Cloudflare configuration and CI/CD environment.
- Pilot data is promoted only through governed migration/bootstrap/reconciliation processes; Pilot credentials do not become Production credentials.
- broad Publication remains off until its own release gate.

## Supabase plan

Organisation plan is now verified **Pro**. The previous Free-plan constraint is retired. Pro entitlement must still be distinguished from feature configuration.

Current Pilot evidence:

- leaked-password protection remains disabled and must be enabled/verified before M2.2 security PASS;
- daily backup/PITR capabilities are to be verified/configured for the clean Production project;
- Production restore evidence cannot be claimed until an isolated restore has actually executed.

## Production Auth baseline

Before go-live verify:

- leaked-password protection enabled;
- current password-strength policy;
- privileged MFA/session policy and reauthentication rules;
- Access Admin role/rank enforcement;
- invalid/expired session paths;
- no Pilot-only Auth workaround retained.

## Database/API security baseline

Before Production release:

- current browser-executable RPC inventory reconciled;
- all privileged mutations server-enforced or explicitly justified;
- no raw private-schema browser CRUD;
- anon/authenticated grants validated from effective privileges;
- Search gate-table RLS policy disposition completed before any Search schema exposure change;
- Search/read consumer API uses allowlisted DTO only;
- no Evidence/Vault/review/private operational fields in consumer responses.

## CI/CD

Required Production release chain:

`approved source SHA → build/tests → migration preflight → protected GitHub Production environment → scoped Production secrets → deploy → database/API/security UAT → deployed browser/API UAT → release evidence`.

Production secrets must not be stored in source or reused from Pilot. Rollback must identify the previous known-good SHA and migration/data rollback/replay approach.

## Backup / recovery

Production acceptance evidence must include:

- actual configured backup schedule/retention;
- PITR enabled/disabled decision and retention where used;
- documented RPO/RTO;
- isolated restore target;
- executed restore;
- canonical counts/invariants/hash reconciliation;
- Storage/Evidence recovery procedure;
- secret re-binding after restore;
- redeployment/rollback validation.

Until that restore executes, DR status is **DEFERRED**, not PASS.

## Search consumer boundary

M2.2 exact/FTS preview is server-side showcase scope only. The final Production API transport, public authentication/rate limits, Publication gating and website release remain later consumer/release gates.
