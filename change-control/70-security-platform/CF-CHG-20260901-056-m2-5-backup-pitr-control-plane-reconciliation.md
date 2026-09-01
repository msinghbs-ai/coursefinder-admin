# CF-CHG-20260901-056 — M2.5 Backup / PITR Control-Plane Reconciliation

**Status:** RECONCILED / PLATFORM PROOF PARTIAL — RESTORE GATE OPEN  
**Category:** 70-security-platform  
**Initiated:** 1 September 2026, Australia/Melbourne  
**Owner:** M2.5 platform maturity  
**Parent readiness gate:** `CF-CHG-20260901-049`  
**Related follow-up:** `M25-FU-005`  
**M2.4 baseline:** remains CLOSED/PASS; this change does not reopen it.

## Purpose

Replace the ambiguous DB-only `platform_api_required` recovery note with an explicit distinction between:
1. product/plan recovery capability;
2. project control-plane configuration evidence;
3. executed restore evidence.

No billable resource, PITR add-on, clone project or restore is created by this gate.

## Live Pilot identity

Supabase management-plane project lookup:
- project: `coursefinder_Pilot`;
- ref: `fxcwkweaxjtknorudmwp`;
- organisation: `rszbvkqopqfvjldvfnbh`;
- region: `ap-south-1`;
- status: `ACTIVE_HEALTHY`;
- PostgreSQL: `17.6.1.155` / engine 17 / GA;
- created: 10 August 2026.

The current Supabase project tool surface exposes project identity/health but does **not** expose the Database > Backups inventory, last backup timestamp, PITR enabled state, or recovery window. These cannot be truthfully inferred from SQL.

## Current Supabase platform baseline checked 1 September 2026

Current official Supabase documentation states:
- Pro, Team and Enterprise projects are backed up daily;
- Pro daily-backup retention is seven days;
- current Postgres versions use physical backups by default;
- database backup/restore does not restore deleted Storage API objects because database backups contain Storage metadata rather than the object bodies;
- PITR is an optional paid add-on for paid plans and replaces daily backups while active;
- PITR requires at least the Small compute add-on;
- PITR pricing/retention is separately billable;
- paid-plan projects with physical backups can use Restore to a New Project.

These statements describe product capability/entitlement, not proof of the current Pilot project's Dashboard configuration.

## CourseFinder disposition

### Pilot

Recovery status is:
- plan capability: **daily-backup capability expected under the current paid-plan governance baseline**;
- actual backup inventory / most recent backup time: **CONTROL-PLANE UNVERIFIED**;
- PITR: **CONTROL-PLANE UNVERIFIED / NOT AUTHORISED OR ENABLED BY COURSEFINDER IN THIS GATE**;
- executed restore: **NOT RUN**;
- restore-to-new-project rehearsal: **NOT RUN**;
- RPO/RTO: **NOT YET ACCEPTED**.

Do not mark Pilot DR PASS from product documentation alone.

### Production

No Production Supabase project exists. Therefore:
- no Production backup schedule can be verified;
- no Production PITR decision can be applied;
- no Production restore can be executed;
- P6 Backup/Restore/DR remains OPEN.

The clean Production gate must still record:
1. actual configured backup mode and retention;
2. PITR enabled/disabled decision and retention if selected;
3. accepted RPO/RTO;
4. isolated restore target;
5. executed restore evidence;
6. migration/schema parity;
7. Auth/RLS/RPC/Storage-policy parity;
8. secrets re-bound after restore;
9. post-restore functional/security acceptance.

## Storage-specific DR warning

Supabase database backups do not contain the actual objects stored through the Storage API.

CourseFinder Evidence Storage is therefore a separate recovery concern. Database restore alone cannot be treated as full CourseFinder recovery. Production DR design must explicitly cover the private `evidence` object bodies and their DB lineage/metadata together.

This reinforces CF-055: Evidence retention/lineage is material recovery state and cannot be casually deleted.

## Cost boundary

PITR is a separately billed add-on. CF-056 does not enable it.

Any future PITR enablement or paid restore/clone resource must follow explicit cost/approval controls. No pricing value is used as approval.

## Acceptance

- Pilot identity/health is reconciled from the Supabase management plane.
- No Dashboard-only backup/PITR state is fabricated.
- Product capability is kept separate from actual project configuration.
- Production P6 restore remains OPEN.
- Storage-object recovery is explicitly separate from database restore.
- No billable action is performed.

## Status decision

**RECONCILED / PLATFORM PROOF PARTIAL — RESTORE GATE OPEN.**

This completes the non-billable metadata reconciliation possible from the current tool surface. Final backup/DR PASS remains a later Production control-plane + executed-restore gate.
