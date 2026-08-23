# CourseFinder Pilot to Production Project Plan v1.10

**Status:** **ACTIVE PRODUCTION-TRANSITION GOVERNANCE**  
**Supersedes:** `docs/coursefinder-pilot-to-production-project-plan-v1.9.md`  
**Updated:** 23 August 2026 11:40 AEST  
**Master Plan:** `docs/coursefinder-master-project-plan-v1.61.md`  
**Running Build:** `docs/coursefinder-running-build-v2.63.md`  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.39.md`  
**Current accepted runtime:** CourseFinder Pilot

## 1. Current position

The Pilot is an accepted non-production operational validation environment. It is not itself the Production security baseline.

Accepted Pilot authority remains:

`msinghbs-ai/Coursefinder-Pilot@e877e3e28cd281ff3751a70bc500eeb0d8f31963`

Runtime marker:

`PIM Admin v2.12 · Pipeline Ops v1.0 · Evidence v1.0 · Data Quality v1.0 · Access Admin v1.0 · governed`

Current accepted operational controls include automated authenticated desktop/mobile UAT, governed Access Admin, private Evidence, Layer-aware Pipeline Operations and Data Quality readiness.

Production readiness/cutover remains a separate future gate. No Production Supabase project identity or Production deployment is asserted by this document until one is explicitly provisioned and governed.

## 2. Pilot exception policy

A security or platform control may be deferred in Pilot only when all are true:

- the exception is explicitly documented in Change Control;
- Pilot remains non-production;
- the exception does not invalidate the purpose of the Pilot/UAT being performed;
- the exception is not presented as resolved;
- the exception has a named Production closure gate where Production requires the control.

Pilot exceptions do not automatically transfer to Production.

## 3. CF-CHG-20260823-022 — leaked-password protection

### Pilot disposition

**DEFERRED / DOCUMENTED TEMPORARY EXCEPTION.**

The current Pilot Supabase organisation is on Free. Supabase currently makes leaked-password protection available on Pro Plan and above. The live Pilot security advisor therefore continues to report:

`auth_leaked_password_protection — Leaked Password Protection Disabled`

No Pilot subscription upgrade is required solely to remove this warning. No fake database substitute is permitted.

### Production disposition

**MANDATORY GO-LIVE SECURITY GATE.**

Production may not receive final CourseFinder security sign-off/cutover approval until:

1. the Production Supabase environment is identified and recorded;
2. its plan/entitlement supports managed leaked-password protection;
3. **Prevent use of leaked passwords** is enabled in Supabase Auth;
4. the Production Supabase security advisor no longer reports `auth_leaked_password_protection`;
5. a controlled leaked-password attempt is rejected without password material being stored in evidence;
6. a compliant governed UAT account still authenticates successfully;
7. Access Admin/RBAC regression passes;
8. the Production evidence is attached to `CF-CHG-20260823-022`.

Pilot deferral is explicitly **not** a waiver of these Production requirements.

## 4. Production security readiness gate

At minimum, Production security acceptance must reconcile the following before go-live:

| Control | Production treatment |
|---|---|
| Leaked-password protection | **Mandatory PASS — CF-CHG-022** |
| Auth/RBAC / Access Admin | Re-run against Production identities and server boundary |
| Service-role exposure | Must remain server-side only |
| Browser read boundary | Revalidate approved governed read contracts |
| Evidence Storage | Private boundary must remain enforced |
| Security advisors | Review all WARN/ERROR findings; document intentional INFO findings |
| RLS/privilege posture | Reconcile Production grants/policies against accepted architecture |
| UAT automation | Run against deployed Production candidate before cutover |
| Secrets | Production-only secrets; no Pilot/UAT credential reuse unless explicitly approved |
| Rollback | Production cutover/reversion path documented and tested where applicable |

The existence of an accepted Pilot UAT result does not replace Production-environment security validation.

## 5. Production cutover gate

Production cutover is allowed only after the applicable Production Change Controls and UAT records are PASS.

For `CF-CHG-022`, the gate is binary:

- **PASS:** eligible plan + setting enabled + advisor clean for this finding + Auth/RBAC UAT PASS;
- **NOT READY:** any of the above is absent or unproven.

If the Production subscription does not expose leaked-password protection, Production security sign-off remains blocked until the entitlement is corrected or an explicit new security-risk decision is approved.

## 6. Preserved application/data semantics

This production-security decision does not change:

- canonical Provider/Course/Campus/Scholarship identity;
- Layer 1–4 authority semantics;
- Search admission versus publication;
- Data Quality state semantics;
- Access Admin role hierarchy;
- current Pilot runtime version;
- current canonical/search counts.

No Running Build, Database Architecture, Admin/PIM Decisions, PIM Admin Guide or visible UI version bump is required for the Pilot deferral itself.

## 7. Current accepted baseline

- Master Project Plan: v1.61;
- Running Build: v2.63;
- Database Architecture: v2.10.39;
- Admin/PIM Decisions: v1.13;
- PIM Admin Guide: v1.14;
- Pilot runtime: `e877e3e28cd281ff3751a70bc500eeb0d8f31963`;
- final accepted Pilot automated deployed UAT: run `32600027592`, desktop/mobile PASS.

## 8. Current decision

**Pilot:** continue with the leaked-password warning documented as a bounded non-production exception.

**Production:** leaked-password protection is mandatory and must be enabled/UAT-proven before final security sign-off or cutover.

Governing Change Control: `CF-CHG-20260823-022`.