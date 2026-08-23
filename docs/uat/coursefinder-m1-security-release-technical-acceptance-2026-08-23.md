# CourseFinder M1 Security Release — Technical Acceptance

**Change Control:** `CF-CHG-20260823-027`  
**Date:** 23 August 2026 AEST  
**Live project:** `coursefinder_Pilot` (`fxcwkweaxjtknorudmwp`)  
**Gate:** **BLOCKED**

## 1. Scope

Independent Milestone 1 security/ACL/release audit of the deployed Admin, database, Storage, Evidence, Edge Functions and publication boundaries. The gate required both authorised and negative tests and explicitly required diagnostic/UAT/temporary runtime surfaces to be removed before PASS.

Parallel work was reconciled before promotion. Pilot `main` had advanced to `1bcb96d26f7c701ec6cf91d771016cb6405f51b2` for M1 performance work, so this security work did not overwrite or roll back those changes. The legitimate Performance work already owned `CF-CHG-20260823-026`; this gate is `CF-CHG-20260823-027`.

## 2. Database/API boundary — PASS after cleanup

Before cleanup, live Postgres exposed three application RPCs directly to `authenticated` in `public`:

- `public.admin_read(text,jsonb)` — accepted governed browser boundary;
- two obsolete `public.ui_providers_page(...)` compatibility overloads.

Repository reconciliation found the current Admin browser uses `admin_read` and no live browser source depends on the two Provider wrappers.

Applied migration:

- live migration `20260823062726_m1_security_release_remove_legacy_provider_rpc`;
- mirrored to Pilot as `supabase/migrations/20260823062726_m1_security_release_remove_legacy_provider_rpc.sql`;
- Pilot source commit `f829eea9be1a21363ae59781bf3c47b314f6c1c5`.

Post-change enumeration proves exactly one browser-executable application RPC remains in `public`:

- `public.admin_read(text,jsonb)` — `authenticated=EXECUTE`, `anon=DENY`, `SECURITY INVOKER`.

No direct `anon` or `authenticated` table grants exist across the application schemas audited (`public`, `security`, `catalogue`, `pipeline`, `pim`, `workflow`, `scholarship`, `integration`, `search`, `publishing`, `ref`).

Public compatibility views still present are all `security_invoker=true` and have neither anon nor authenticated SELECT grants. They therefore do not form a browser data path.

## 3. Authorisation/rank UAT — PASS

Live effective test identities available during the audit were Curator rank 3 and Platform Admin rank 6.

Positive cases:

- rank 3 can call authenticated context and Evidence filter/read boundary;
- rank 6 can call context, Pipeline overview and PIM attribute/configuration reads;
- Evidence read functions independently enforce `auth.uid()` and rank >= 3;
- Access Admin Edge Function independently resolves current context through `admin_read` and requires role rank >= 6 before service-role operations;
- Evidence Access Edge Function independently resolves context through `admin_read` and requires rank >= 3 before issuing a 60-second signed URL.

Negative cases:

- anon invocation of `public.admin_read` is denied by EXECUTE ACL;
- rank 3 invocation of `pipeline_overview` fails with SQLSTATE `42501` / `pipeline_operator role required`;
- service-only Access Admin helper RPCs are denied to anon/authenticated and executable by `service_role` only;
- publication mutation/readiness RPCs in `publishing` are denied to anon/authenticated and service-only.

## 4. RLS and schema exposure — PASS with explained INFO findings

Application internal schemas are not granted USAGE to anon/authenticated, except `security` USAGE for authenticated where the governed security helper chain operates. Direct table grants to both browser roles are absent.

RLS remains enabled on private/internal application tables with no browser policies. Supabase Security Advisor reports these as INFO `rls_enabled_no_policy`. In this architecture the lack of policies is intentional deny-by-default defence in depth, not an unexplained release error: direct browser table grants are absent and browser reads are mediated through the governed RPC/Edge boundaries.

Remediation reference if this architecture changes: Supabase database linter `0008_rls_enabled_no_policy`.

## 5. Storage / Evidence — PASS

The only application evidence bucket is:

- bucket `evidence`;
- private (`public=false`);
- 50 MiB object size limit;
- constrained allowed MIME list;
- no browser Storage RLS policies.

The absence of Storage policies intentionally prevents direct browser object access. `admin-evidence-access` is JWT protected, requires Curator+ via the server-governed context, uses service credentials only after authorisation, and returns 60-second signed object URLs. Preview is constrained to accepted MIME types; download remains explicitly requested.

## 6. SECURITY DEFINER / privileged helper boundary — PASS for admitted application paths

Audited admitted browser/service paths use fixed `search_path` declarations and server-side role checks. The public browser dispatcher itself is not SECURITY DEFINER.

Privileged Access Admin service helpers are service-role-only. Publication functions are also service-role-only. No service-role key was found in the browser Supabase client path; privileged Edge Functions source service credentials from server-side environment variables.

## 7. Publication / Zoho boundary — PASS

Live publication state remains closed:

- `publishing.entity_states = 0`;
- Search documents with `publication_status='published' = 0`;
- configured channels `admin`, `website`, `zoho` each have zero entity-state rows.

No browser execution grant exists on publication mutation functions. The Zoho channel is configured but has no admitted/published state, preserving the Pilot no-publication boundary.

## 8. Edge Functions — BLOCKING FINDING

The live Edge inventory still contains numerous explicitly diagnostic, UAT, reset, probe or rejected-gate surfaces. Examples confirmed active include:

- `pilot-reset`;
- `layer1-runtime-uat`;
- `layer1-depth-uat`;
- `cricos-depth-inspect`;
- `layer1-au-full-gate`;
- `layer1-nz-source-inspect`;
- `layer1-nz-gate-uat`;
- `search-vector-gate` (the vector candidate is already rejected and this endpoint only returns HTTP 410);
- CA diagnostic/probe/audit endpoints such as `layer1-ca-northern-code-audit`, `layer1-ca-cpic-probe`, `layer1-ca-mb-designation-probe`, `layer1-ca-sk-sitemap-probe`, `layer1-ca-qc-*audit`, `layer1-ca-qc-*-probe`, `layer1-ca-ircc-nvit-probe`, `layer1-ca-ab-alis-probe` and related surfaces.

Some non-JWT production ingestion functions deliberately set `verify_jwt=false` but implement custom authorisation. For example live `layer1-au-depth` v1.6.0 requires either a consumed one-time Pilot nonce or a validated user JWT plus Platform Admin authorisation before invoking service-role operations. This design is materially different from a public unauthenticated function and is acceptable when the custom check is retained.

However, Supabase currently provides no safe decommission action through the connected management surface used for this audit, and these Edge functions overlap newer Layer 1/CA work. Overwriting them with tombstones or redeploying older code would violate the project rule not to clobber newer parallel work. Their active presence also directly violates this gate's explicit requirement to remove diagnostic/UAT/temporary functions before PASS.

Therefore the gate cannot be closed PASS in the current state.

## 9. Supabase advisors

Security Advisor after database cleanup:

- no Critical/Error findings observed;
- INFO `RLS enabled / no policy` findings — explained above as intentional private-schema deny-by-default architecture;
- WARN `Leaked Password Protection Disabled` — pre-existing `CF-CHG-20260823-022`, accepted only for Pilot and mandatory before Production go-live.

Performance Advisor was also rerun. It contains INFO-only unindexed-FK and unused-index observations; there are no security-release Critical/Error findings in that advisor. Performance disposition remains with the separate M1 Performance workstream rather than being silently changed here.

Leaked-password remediation: enable Supabase Auth leaked-password protection before Production release; see Supabase Auth password-security guidance.

## 10. Current Supabase runtime compatibility check

Current Supabase guidance confirms that `verify_jwt=true` performs the platform JWT check before the Edge handler, while `verify_jwt=false` requires the handler to provide an appropriate alternative authentication mechanism. Supabase's August 2026 changelog also records the completed Deno 2.1 Edge runtime rollout; no required rollback or security redesign was identified for the admitted Edge paths audited here.

## 11. Residual risks / blockers

### Blocking

1. Active diagnostic/UAT/probe/reset/rejected-gate Edge Functions remain deployed. They must be decommissioned or, where genuinely required operationally, explicitly reclassified/renamed/governed and independently re-audited.
2. The Edge inventory overlaps newer parallel Layer 1/CA work, so security cleanup must be reconciled with the owners/current source before destructive removal.

### Accepted Pilot-only residual

3. Supabase leaked-password protection remains disabled under `CF-CHG-20260823-022`. This is not accepted for Production.

### Non-blocking explained findings

4. Private/internal RLS tables with no policies are intentional deny-by-default and have no anon/authenticated direct table grants.
5. Performance advisor INFO findings are delegated to the active Performance gate.

## 12. Re-test required for PASS

Before `CF-CHG-20260823-027` can become PASS:

1. reconcile the final Edge-function allowlist with current Layer 1/2 owners and Pilot `main`;
2. undeploy diagnostic/UAT/probe/reset/rejected functions that are no longer required;
3. for every remaining `verify_jwt=false` function, prove its custom auth path and deny unauthorised invocation;
4. rerun the full Edge inventory and prove no temporary/diagnostic residue remains;
5. rerun Security Advisor and retain explanations for INFO findings;
6. rerun browser RPC, Storage, role-rank, publication and Zoho negative UAT to prove cleanup caused no regression;
7. enable leaked-password protection before any Production PASS.

## 13. Final gate

**BLOCKED.**

The database/browser/Storage/Evidence/publication ACL posture tested cleanly after removing obsolete Provider RPC compatibility exposure, but the explicit release requirement to remove diagnostic/UAT/temporary Edge Functions is not satisfied. A PASS would be inaccurate while those live surfaces remain.
