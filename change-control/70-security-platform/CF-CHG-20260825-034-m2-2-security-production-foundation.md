# CF-CHG-20260825-034 — M2.2 Security & Production Foundation

**Status:** **CLOSED / PASS — PILOT SECURITY FOUNDATION**  
**Category:** 70-security-platform  
**Initiated:** 25 August 2026 20:08 AEST (+10:00)  
**Closed:** 25 August 2026 21:26 AEST (+10:00)  
**Origin chat/workstream:** M2.2 — SECURITY-PRODUCTION-SEARCH-SHOWCASE  
**Owner:** CourseFinder security/platform workstream

## Final implemented security state

Supabase organisation `techM` (`rszbvkqopqfvjldvfnbh`) is verified on **Pro**. Pilot `fxcwkweaxjtknorudmwp` remains ACTIVE_HEALTHY in Mumbai `ap-south-1`.

Implemented and UAT-proven hardening:

- browser-direct authenticated execution of `public.layer2_ops_policy_update(uuid,uuid,jsonb)` revoked;
- policy mutation routed through JWT-enforced `layer2-config-control` v3 with current actor/rank validation and policy-field allowlist;
- the former Security Advisor warning for that authenticated SECURITY DEFINER surface is gone;
- browser roles are denied the M2.2 website Search preview RPCs;
- Search/Vault private boundaries remain non-browser CRUD surfaces;
- no service-role secret is added to browser code;
- Publication remains zero and cannot be escalated by the bounded Search preview;
- final deployed desktop/mobile UAT passes on Pilot SHA `38ad08bb75ee7cf26a0a701a3ae008d1563b915b`, run `32840377935`;
- Supabase leaked-password protection is now enabled under Pro and live Security Advisor no longer reports the leaked-password WARN.

## Final security regression — 25 August 2026 21:26 AEST

Effective execution checks after Auth enablement:

- `anon` → `layer2_ops_policy_update`: DENIED;
- `authenticated` → `layer2_ops_policy_update`: DENIED;
- `service_role` → `layer2_ops_policy_update`: ALLOWED;
- `anon` / `authenticated` → bounded website lookup/search preview RPCs: DENIED;
- `service_role` → bounded website lookup/search preview RPCs: ALLOWED.

Runtime invariants remain:

- Courses: 43,461;
- Providers: 3,085;
- Search documents: 33,105;
- AU: 26,648;
- NZ: 6,457;
- embeddings/jobs/query cache: 0 / 0 / 0;
- broad publication: 0;
- Search Projection generation: 22;
- Search Projection hash: `b4660ebc15851620bd111c82a74a19899c43a4560e5d2eb571b40e3c64bf77ee`.

## Advisor disposition

The previous material M2.2 WARNs are cleared. Current Security Advisor output contains INFO-level `rls_enabled_no_policy` notices across private/internal schemas. These do not establish browser exposure and are retained for Production defence-in-depth design rather than being treated as unexplained Critical/High findings.

Three Search gate tables previously noted with RLS disabled remain internal/private under the current effective grant boundary. Production must define accepted service/internal policies before changing those semantics.

Historical/ingestion Edge Functions with `verify_jwt=false` remain subject to Production relevance inventory and either custom-auth/server-only disposition or retirement before clean Production promotion.

## Production trust boundary

This PASS is for the M2.2 Pilot security/Production foundation, not Production cutover.

Production remains a new clean environment, not a renamed Pilot. Target region remains Sydney `ap-southeast-2` unless a later regional Change Control changes it. Production establishment/cutover must separately prove:

- environment/project identity and scoped secrets;
- protected deployment workflow;
- backup/PITR configuration;
- isolated restore execution and accepted RPO/RTO;
- Production logging/monitoring;
- Production Auth controls including leaked-password protection;
- final Production security advisor and browser/API regression.

## Evidence

- final Pilot source SHA: `38ad08bb75ee7cf26a0a701a3ae008d1563b915b`;
- build run: `32840377937` PASS;
- deployed UAT: `32840377935` desktop/mobile PASS;
- desktop artifact: `9560350909`;
- mobile artifact: `9560520848`;
- detailed evidence: `docs/uat/coursefinder-m2-2-security-search-showcase-2026-08-25.md`;
- leaked-password parent control: `CF-CHG-20260823-022` CLOSED/PASS.

## Closure

**Final status: CLOSED / PASS — PILOT SECURITY FOUNDATION.**

All implemented M2.2 security controls are UAT-proven for the Pilot. No broad Publication, Production website exposure, Zoho cutover or final Production handover authority is granted by this closure.