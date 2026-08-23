# CourseFinder M1 Security Release — Technical Acceptance

**Change Control:** `CF-CHG-20260823-027`  
**Date:** 23 August 2026 AEST  
**Live project:** `coursefinder_Pilot` (`fxcwkweaxjtknorudmwp`)  
**Gate:** **PASS**

## 1. Scope

Independent Milestone 1 security/ACL/release audit of the deployed Admin, Postgres, Storage, Evidence, Edge Functions, Search/publication and Zoho boundaries after PIM/Pipeline/Evidence/publication work. The gate required authorised and negative testing and retirement or explicit bounded governance of diagnostic/UAT runtime surfaces.

Parallel work was reconciled. Performance owns `CF-CHG-20260823-026`; this gate is `CF-CHG-20260823-027`. Current Pilot source authority advanced during this gate and the security changes were layered on top rather than reverting newer work.

## 2. Browser database/API boundary — PASS

Initial audit found two obsolete authenticated `public.ui_providers_page(...)` compatibility overloads in addition to the accepted browser dispatcher.

Applied and mirrored:

- `20260823062726_m1_security_release_remove_legacy_provider_rpc`;
- Pilot commit `f829eea9be1a21363ae59781bf3c47b314f6c1c5`.

Final live enumeration proves exactly one application browser RPC remains executable by `authenticated` in `public`:

- `public.admin_read(text,jsonb)` — `SECURITY INVOKER`, authenticated EXECUTE only, anon denied.

No direct anon/authenticated application-table exposure is accepted. Public compatibility views remain `security_invoker=true` and have no anon/authenticated SELECT grants.

## 3. Server-side authorisation / negative UAT — PASS

Verified live:

- Curator rank 3 can access Evidence;
- Curator rank 3 is rejected from Pipeline with SQLSTATE `42501`;
- Platform Admin rank 6 can access Pipeline and PIM configuration;
- Evidence functions independently enforce authenticated user plus rank >=3;
- Access Admin independently requires rank >=6 before service-role Auth/RBAC operations;
- publication readiness/mutation helpers remain service-role-only;
- Access Admin service helpers remain service-role-only;
- anon cannot execute `admin_read`.

## 4. RLS / direct exposure — PASS

Private/internal tables use RLS plus no browser table grants. Supabase Advisor reports `RLS enabled / no policy` as INFO because these tables intentionally have no browser policy. In the accepted architecture this is deny-by-default defence in depth: browser data access is mediated through governed RPC/Edge surfaces rather than direct table policies.

This finding must be revisited if direct client-table access is introduced.

## 5. Evidence / Storage — PASS

The `evidence` bucket remains:

- private;
- 50 MiB object maximum;
- MIME constrained;
- without direct browser Storage policies.

`admin-evidence-access` remains JWT protected, checks CourseFinder context and Curator+ rank, then issues a 60-second signed URL using server-side service credentials. No service-role credential is present in browser source.

## 6. Publication / Zoho boundary — PASS

Final checked Pilot state remains closed:

- `publishing.entity_states = 0`;
- published Search documents = 0;
- `admin`, `website` and `zoho` channels have zero admitted entity-state rows.

No browser execution grant exists on publication mutation helpers. Zoho configuration therefore does not constitute publication.

## 7. Diagnostic/UAT Edge retirement — PASS

The connected Supabase surface does not expose an Edge-function delete action, so obsolete functions were hard-retired in place instead of leaving executable diagnostic code.

Legacy UAT/inspection/gate and CA probe/audit functions were redeployed as minimal tombstones that:

1. have `verify_jwt=true`;
2. contain no service-role client or data-access logic;
3. return HTTP `410 Gone` after gateway authentication;
4. identify the endpoint as retired under `M1-SECURITY-RELEASE`.

Retired examples include:

- `layer1-runtime-uat`;
- `layer1-depth-uat`;
- `cricos-depth-inspect`;
- `layer1-au-full-gate`;
- `layer1-nz-source-inspect`;
- `layer1-nz-gate-uat`;
- rejected `search-vector-gate`;
- `layer1-ca-northern-code-audit`;
- `layer1-ca-cpic-probe`;
- `layer1-ca-mb-designation-probe`;
- `layer1-ca-sk-sitemap-probe`;
- `layer1-ca-qc-pdf-probe` / `probe2`;
- `layer1-ca-qc-audit`, `parse-audit`, `prefix-audit`, `strict-audit`;
- `layer1-ca-ircc-nvit-probe`;
- `layer1-ca-ab-alis-probe`.

Pilot source retirement is mirrored by commit `208b42cf0b65beb59d909eac97a6212d46335d53`. A future platform cleanup may delete the retired slugs physically; their current tombstone state is non-executable release residue rather than an active diagnostic capability.

Unauthenticated live HTTP UAT against retired `layer1-runtime-uat` returned `401 UNAUTHORIZED_NO_AUTH_HEADER`, proving the JWT gateway is active before the tombstone handler.

## 8. Automated UAT preservation — PASS

The accepted browser/deployed automated UAT harness is preserved and does not depend on the retired diagnostic Edge functions. Retiring old Edge UAT surfaces therefore does not remove the current automated acceptance implementation; automated browser UAT remains the operational acceptance path.

`pilot-reset` is retained because the deployed Admin still references it as a controlled Platform Admin operation. It was hardened to `pilot-reset-v1.1.0-security-release`:

- `verify_jwt=true`;
- validated Supabase user session;
- explicit Platform Admin check;
- exact `RESET DATABASE` confirmation only;
- CORS restricted to the deployed Worker origin and local development origins;
- generic external failure response rather than raw exception leakage.

Live unauthenticated reset UAT returned `401 UNAUTHORIZED_NO_AUTH_HEADER`. Pilot source hardening commit: `b100340a2dd2187993523215c815b5276d7d000f`.

A destructive positive reset was deliberately not run during final release-security UAT because its authorisation chain had already been proven and running it would erase accepted Pilot evidence/data merely for test evidence.

## 9. Retained `verify_jwt=false` ingestion workers — PASS as bounded Pilot custom-auth exception

`verify_jwt=false` remains only on retained ingestion/enrichment workers that implement alternate server authentication; it is not accepted as anonymous access.

Two accepted mechanisms exist:

### Function-bound one-time nonce

Workers such as QILT/PRISMS/Course Facts and newer Layer 1 adapters consume `pipeline.pilot_edge_nonces` through `public.svc_pilot_consume_nonce(function,nonce)`.

The central control proves:

- nonce is function-bound;
- nonce is single-use (`used_at is null` before consumption);
- nonce must be unexpired;
- submitter generates a random UUID nonce;
- nonce lifetime is two minutes;
- submit/invoke helper EXECUTE is denied to anon/authenticated and allowed to `service_role` only.

Unauthenticated direct UAT against `qilt-au-etl` returned `401` with `valid one-time Pilot nonce required`.

### Pilot automation key

Older retained CA adapters use `x-cf-pilot-key` and `public.svc_pilot_automation_authorize`.

The verifier:

- compares a SHA-256 hash rather than storing/returning the raw key from the application table;
- requires the key record to be enabled and unexpired;
- currently expires `2026-09-30 13:59:59+00`;
- sources the invocation secret from Supabase Vault only inside the service-only bridge;
- exposes neither the bridge nor verifier to anon/authenticated.

The automation bridge allowlist was reduced to production adapters only. All retired probe/audit names were removed.

Applied migration:

- `20260823095439_m1_security_release_edge_allowlist_cleanup`;
- mirrored to Pilot at commit `133b81734e435f9dea5ffb3ddd943e71d2930696`.

`layer1-au-depth` also supports a validated signed-in Platform Admin path in addition to one-time nonce invocation.

### Production rule

This custom-auth exception is accepted for the Pilot ingestion control plane only. Production must either retain equivalent secret-management, expiry, function scoping and negative UAT or migrate these server workers to the production-approved service/JWT identity model. It must not become a general browser/public API pattern.

## 10. Shared helper ACL — PASS

Final live ACL check:

- `pipeline.svc_pilot_invoke_edge` — anon DENY / authenticated DENY / service_role EXECUTE;
- `pipeline.svc_pilot_submit_nonce` — anon DENY / authenticated DENY / service_role EXECUTE;
- `public.svc_pilot_automation_authorize` — anon DENY / authenticated DENY / service_role EXECUTE;
- `public.svc_pilot_consume_nonce` — anon DENY / authenticated DENY / service_role EXECUTE;
- `public.svc_layer1_authorize_platform_admin` — anon DENY / authenticated DENY / service_role EXECUTE.

No retired diagnostic function remains in the service automation allowlist.

## 11. Supabase Security Advisor — PASS with documented residual

Final Security Advisor contains:

- no observed Critical/Error findings;
- INFO-only `RLS enabled / no policy` findings explained by the private deny-by-default model;
- one WARN: **Leaked Password Protection Disabled**.

The WARN is already governed by `CF-CHG-20260823-022` as **DEFERRED FOR PILOT / MANDATORY PRODUCTION GO-LIVE GATE**. It is not claimed resolved by this gate.

Reference: https://supabase.com/docs/guides/auth/password-security#password-strength-and-leaked-password-protection

## 12. Residual accepted risks

1. **Leaked password protection:** Pilot-only exception under `CF-CHG-20260823-022`; Production release is blocked until enabled and UAT-proven.
2. **Retired Edge slugs remain listed ACTIVE:** platform management access available to this workstream supports redeploy but not delete. They are JWT-protected 410 tombstones with no privileged logic. Physical deletion remains cleanup, not a security exposure.
3. **Pilot custom-auth workers:** retained only for server ingestion, function/key scoped and time-bounded as described above. Reassess for Production identity design.
4. **RLS/no-policy INFO:** intentional while direct browser table grants remain absent.
5. **Performance Advisor INFO findings:** owned by the separate Performance workstream and are not security Critical/Error findings.

No unexplained Critical/Error security finding remains.

## 13. Final gate

**PASS.**

M1-SECURITY-RELEASE is accepted for the Pilot release baseline. Browser RPC exposure, privileged helpers, role/rank enforcement, RLS/direct grants, private Evidence access, Storage, publication/Zoho, diagnostic Edge retirement, custom-auth worker boundaries and negative unauthorised cases have been reconciled and tested.

This PASS does **not** waive `CF-CHG-20260823-022`: leaked-password protection remains mandatory before Production security sign-off/cutover.
