# CF-CHG-20260823-027 — M1 Security, ACL & Release Readiness Gate

**Status:** **CLOSED / PASS**  
**Category:** `70-security-platform`  
**Initiated:** 23 August 2026 16:24 AEST (UTC+10)  
**Closed:** 23 August 2026 19:58 AEST (UTC+10)  
**Origin:** CourseFinder chat — `12. M1-SECURITY-RELEASE`  
**Owner:** CourseFinder security/platform governance  
**Affected surfaces:** `80-uat-release-operations`, Admin/PIM, Pipeline, Evidence, Search/publication, Supabase Auth/RBAC/RLS/Storage/Edge Functions, Zoho boundaries  
**Change class:** final security/ACL/release closure audit

## 1. Requested outcome

Perform the independent Milestone 1 security closure against the actual deployed Pilot after PIM, Pipeline, Evidence, Search/publication and documentation work. Audit browser RPCs, SECURITY DEFINER functions, grants, rank enforcement, RLS, Storage/Evidence, Edge Functions, secrets, compatibility surfaces, publication/Zoho and Supabase advisors. Negative cases were mandatory. Diagnostic/UAT surfaces had to be removed or rendered non-executable before PASS.

## 2. Reconciled baseline / parallel-work protection

Parallel M1 Performance work already owns `CF-CHG-20260823-026` and closed PASS against Pilot `1bcb96d26f7c701ec6cf91d771016cb6405f51b2`. This security work was correctly re-keyed to `CF-CHG-20260823-027` and layered over the newer source rather than overwriting it.

Known overlapping residual:

- `CF-CHG-20260823-022` — Supabase leaked-password protection — **DEFERRED FOR PILOT / MANDATORY PRODUCTION GO-LIVE GATE**.

## 3. Browser/API compatibility cleanup — PASS

Initial audit found two obsolete authenticated `public.ui_providers_page(...)` compatibility overloads in addition to the accepted browser dispatcher.

Applied live and mirrored:

- migration `20260823062726_m1_security_release_remove_legacy_provider_rpc`;
- Pilot commit `f829eea9be1a21363ae59781bf3c47b314f6c1c5`.

Final live enumeration proves the only application RPC in `public` executable by `authenticated` is:

- `public.admin_read(text,jsonb)` — SECURITY INVOKER; anon denied.

No direct browser application-table access is accepted. Remaining compatibility views are `security_invoker=true` with no anon/authenticated SELECT grants.

## 4. Role/rank and privileged-helper UAT — PASS

Verified live:

- Curator rank 3 Evidence access succeeds;
- Curator rank 3 Pipeline access is rejected with SQLSTATE `42501`;
- Platform Admin rank 6 Pipeline/PIM access succeeds;
- Evidence functions independently require authenticated user + rank >=3;
- Access Admin independently requires rank >=6 before service-role Auth/RBAC operations;
- Access Admin service helpers are service-role-only;
- publication readiness/mutation helpers are service-role-only;
- anon cannot execute the governed Admin browser dispatcher.

## 5. Evidence / Storage / secrets — PASS

The `evidence` bucket remains private, MIME constrained, 50 MiB maximum, and without direct browser Storage policies.

`admin-evidence-access` remains JWT protected, resolves CourseFinder context, requires Curator+, and only then uses service credentials to create a 60-second signed URL. Service-role credentials remain server-side.

## 6. Publication / Zoho boundary — PASS

Final checked Pilot state remains closed:

- zero `publishing.entity_states` rows;
- zero published Search documents;
- `admin`, `website` and `zoho` channels each have zero admitted entity-state rows.

No browser publication mutation grant exists. Zoho configuration alone does not constitute publication.

## 7. Diagnostic/UAT Edge cleanup — PASS

Automated browser/deployed UAT remains the accepted operational acceptance implementation. It does not depend on the old diagnostic Edge UAT helpers.

The connected Supabase management interface supports redeploy but not physical Edge deletion. Obsolete diagnostic/UAT/probe/rejected-gate functions were therefore hard-retired in place as minimal JWT-protected HTTP 410 tombstones with no service-role/data-access logic.

Retired classes include:

- `layer1-runtime-uat`, `layer1-depth-uat`;
- `cricos-depth-inspect`, `layer1-au-full-gate`;
- `layer1-nz-source-inspect`, `layer1-nz-gate-uat`;
- rejected `search-vector-gate`;
- obsolete CA `*-probe` / `*-audit` diagnostic surfaces.

Source retirement is mirrored in Pilot commit:

- `208b42cf0b65beb59d909eac97a6212d46335d53`.

Unauthenticated live HTTP UAT against retired `layer1-runtime-uat` returned HTTP 401 at the JWT gateway. The retained slugs therefore no longer provide diagnostic execution capability. Physical deletion is future housekeeping, not an active exposure.

## 8. `pilot-reset` — retained and hardened

`pilot-reset` remains operational because the deployed Admin still references it for controlled Platform Admin reset operations. It was hardened to `pilot-reset-v1.1.0-security-release`:

- `verify_jwt=true`;
- validated Supabase user session;
- explicit Platform Admin authorisation;
- exact `RESET DATABASE` confirmation only;
- CORS restricted to the deployed Worker and local development origins;
- generic external failure response rather than raw exception leakage.

Pilot source commit:

- `b100340a2dd2187993523215c815b5276d7d000f`.

Unauthenticated live reset UAT returned HTTP 401. A destructive positive reset was intentionally not executed merely for evidence because it would remove accepted Pilot data/evidence; its authentication/role chain has already been proven.

## 9. Retained custom-auth ingestion workers — PASS as bounded Pilot control

Some retained ingestion/enrichment Edge workers deliberately use `verify_jwt=false`, but they are not anonymous application APIs. They require one of the accepted server control-plane mechanisms:

### Function-bound one-time nonce

The nonce path is:

- generated server-side as random UUID;
- bound to an exact function;
- expires after two minutes;
- consumable once only;
- submit/consume helpers are service-role-only.

Direct unauthenticated UAT against `qilt-au-etl` returned HTTP 401 `valid one-time Pilot nonce required`.

### Pilot automation key

Older retained CA adapters require `x-cf-pilot-key` and server-side verification against a SHA-256 hash. The invocation secret is retrieved from Supabase Vault only inside the service-only bridge.

The live key is enabled but explicitly expires **30 September 2026**. This is a bounded Pilot control, not a general browser/public authentication pattern.

The shared automation allowlist was reduced to production adapters only; all retired probe/audit names were removed.

Applied live and mirrored:

- migration `20260823095439_m1_security_release_edge_allowlist_cleanup`;
- Pilot commit `133b81734e435f9dea5ffb3ddd943e71d2930696`.

Final shared-helper ACL verification shows anon/authenticated denied and `service_role` EXECUTE only for the nonce, automation, Platform-Admin-authorisation and service invocation helpers.

## 10. Supabase Advisor — PASS with explicit residual

Final Security Advisor contains:

- no observed Critical/Error findings;
- INFO-only `RLS enabled / no policy` findings, explained by the private deny-by-default architecture and absence of direct browser table grants;
- one WARN: **Leaked Password Protection Disabled**.

The WARN is already governed by `CF-CHG-20260823-022`. It is accepted only for the Pilot and remains mandatory before Production security sign-off/cutover.

Performance Advisor INFO findings remain owned by `CF-CHG-20260823-026` and are not security Critical/Error findings.

## 11. Accepted residual risks

1. **Leaked-password protection:** Pilot-only exception under `CF-CHG-20260823-022`; Production remains blocked until enabled and UAT-proven.
2. **Retired Edge slugs still show ACTIVE:** they are JWT-protected 410 tombstones with no privileged execution logic because physical delete is unavailable through the connected management surface.
3. **Pilot custom-auth ingestion workers:** service control-plane only, function/key scoped and time-bounded; reassess/migrate to the final Production identity model before production cutover where required.
4. **RLS/no-policy INFO:** intentional while direct browser table access remains absent.
5. **Performance INFO:** delegated to the independent Performance gate.

No unexplained Critical/Error security finding remains.

## 12. Technical acceptance / source evidence

Detailed technical acceptance:

- `docs/uat/coursefinder-m1-security-release-technical-acceptance-2026-08-23.md` — PASS;
- technical acceptance update commit `6370c90ea15696ea9f619e53d97ebb12157ed179`.

Pilot security source chain:

- `f829eea9be1a21363ae59781bf3c47b314f6c1c5` — legacy browser RPC retirement mirror;
- `208b42cf0b65beb59d909eac97a6212d46335d53` — diagnostic Edge tombstones;
- `b100340a2dd2187993523215c815b5276d7d000f` — reset hardening;
- `133b81734e435f9dea5ffb3ddd943e71d2930696` — production-only automation bridge allowlist.

## 13. Rollback

- legacy Provider wrappers should not be restored without a governed consumer;
- retired diagnostic functions may only be re-enabled under a new Change Control with explicit authentication and UAT purpose;
- `pilot-reset` may be removed when the Admin reset workflow is retired, but must not be replaced by a weaker browser/service credential path;
- custom-auth ingestion controls must not be relaxed to restore a failed worker.

## 14. Closure

**Final status: CLOSED / PASS.**

M1-SECURITY-RELEASE is accepted for the Pilot release baseline. Browser RPC exposure, role/rank enforcement, privileged functions, direct grants/RLS, private Evidence access, Storage, publication/Zoho, diagnostic Edge retirement, retained automated UAT and custom-auth ingestion boundaries have been reconciled and technically tested.

This PASS does **not** waive `CF-CHG-20260823-022`: leaked-password protection remains a mandatory Production go-live control.
