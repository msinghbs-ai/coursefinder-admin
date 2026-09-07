# CF-CHG-20260907-235 — Layer 4 Public RPC Security-Boundary Hardening

**Status:** ACTIVE / TARGETED SECURITY RECOVERY  
**Milestone:** M2.4.5  
**Type:** SECURITY / RECOVERY / PRE-PRODUCTION HARDENING  
**Initiated:** 7 September 2026  
**Primary owner:** 70-security-platform  
**Related:** CF-205 Layer 4 Mass Operations, CF-206 reusable Scholarship scope rules, CF-234 recovery protocol

## Trigger

During M2.4.5 recovery reconciliation at Pilot head `8bc6960d05e5521ff6ae44ad0ee49e7c07ef80ff`, the live Supabase Security Advisor reported authenticated-callable `SECURITY DEFINER` WARN findings for the CF-205/206 Layer 4 mass, quality, review and Scholarship scope-rule RPCs in the exposed `public` schema.

The functions contain explicit authenticated-role/rank guards and fixed search paths, so this is not evidence that Layer 4 semantic checks failed. It is nevertheless a pre-production exposure-boundary warning and must be corrected rather than waived silently.

## Governed correction

Preserve all accepted CF-205/206 behaviour and move the privileged implementations into the non-exposed `l4_api` schema. Recreate the same public signatures as `SECURITY INVOKER` wrappers that call the private implementations.

Invariants retained:

- Curator/Pipeline Operator rank checks remain inside the privileged implementation.
- Exact live-count confirmation remains required for mass mutation.
- Scholarship bulk accept continues to fail closed on missing Evidence or Provider mismatch.
- Scope rules remain exact Provider + Evidence + candidate-reason cohorts.
- Generic scalar mass approval remains unsupported.
- Publication/Search/Website/Zoho state remains unchanged.
- No canonical Provider/Course identity writer is added.

## Source implementation

Pilot replay migration:

`supabase/migrations/20260907003500_cf_235_layer4_public_wrapper_security_hardening.sql`

Initial source commit: `96abe8264d2c9cb70c2b05792d4317e382d3d4c0`.

## Required acceptance

1. Apply the migration to Pilot runtime.
2. Verify the public Layer 4 functions are `SECURITY INVOKER` and the `l4_api` implementations remain `SECURITY DEFINER`.
3. Re-run Security Advisor and confirm the CF-205/206 exposed-function WARN findings are gone.
4. Run the exact CF-205/206 source/targeted contract and deployed Layer 4 mass/scope browser acceptance before closing.
5. Do not promote a visible release solely for this boundary-only correction unless browser-visible behaviour changes.

## Rollback / recovery

If the wrappers fail, restore the prior public function definitions from the CF-205/206 replay migrations and remove the newly moved `l4_api` overloads only after confirming no dependent runtime call remains. Do not alter or delete `pipeline.layer4_mass_operations`, `pipeline.layer4_scope_rules`, quality findings, Scholarship mappings or audit history as part of rollback.
