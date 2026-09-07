# CF-CHG-20260907-235 — Layer 4 Public RPC Security-Boundary Hardening

**Status:** CLOSED / TARGETED SECURITY PASS  
**Milestone:** M2.4.5  
**Type:** SECURITY / RECOVERY / PRE-PRODUCTION HARDENING  
**Initiated:** 7 September 2026  
**Closed:** 7 September 2026  
**Primary owner:** 70-security-platform  
**Related:** CF-205 Layer 4 Mass Operations, CF-206 reusable Scholarship scope rules, CF-234 recovery protocol

## Trigger

During M2.4.5 recovery reconciliation at Pilot head `8bc6960d05e5521ff6ae44ad0ee49e7c07ef80ff`, the live Supabase Security Advisor reported authenticated-callable `SECURITY DEFINER` WARN findings for the CF-205/206 Layer 4 mass, quality, review and Scholarship scope-rule RPCs in the exposed `public` schema.

The functions already contained explicit authenticated-role/rank guards and fixed search paths, so the warning was not evidence that Layer 4 semantic checks failed. It was nevertheless a pre-production exposure-boundary defect and was corrected rather than waived.

## Governed correction

The accepted CF-205/206 behaviour was preserved while privileged implementations were moved into the non-exposed `l4_api` schema. The same public signatures now exist as `SECURITY INVOKER` wrappers.

Invariants retained:

- Curator/Pipeline Operator rank checks remain inside the privileged implementation.
- Exact live-count confirmation remains required for mass mutation.
- Scholarship bulk accept continues to fail closed on missing Evidence or Provider mismatch.
- Scope rules remain exact Provider + Evidence + candidate-reason cohorts.
- Generic scalar mass approval remains unsupported.
- Publication/Search/Website/Zoho state remains unchanged.
- No canonical Provider/Course identity writer was added.

## Source implementation

Pilot replay migration:

`supabase/migrations/20260907003500_cf_235_layer4_public_wrapper_security_hardening.sql`

Source/runtime head: `96abe8264d2c9cb70c2b05792d4317e382d3d4c0`.

## Acceptance evidence

- Pilot migration `cf_235_layer4_public_wrapper_security_hardening`: applied successfully.
- Runtime introspection confirmed exposed Layer 4 public functions are `SECURITY INVOKER` and matching `l4_api` implementations remain privileged with no anon execute grant.
- Supabase Security Advisor after CF-235: all CF-205/206 exposed Layer 4 `SECURITY DEFINER` WARN findings removed.
- CourseFinder Deployed UAT on the CF-235 head: run `34069963783` — **PASS**, targeted desktop tier.
- Public RPC names/signatures and browser code were unchanged.
- The existing CF-205 source contract is intentionally release-pinned to its accepted v2.15.65 release and therefore was not rewritten or weakened merely to make a later boundary-only recovery commit pass.
- Subsequent CF-236 hardening reached a Security Advisor state with **0 WARN findings**, providing an additional bounded confirmation that the CF-235 Layer 4 warnings did not recur.
- No visible release promotion was made because CF-235 changed only the security boundary, not browser-visible behaviour.

## Closure decision

CF-235 is **CLOSED / TARGETED SECURITY PASS**. CF-205/206 functional semantics remain accepted; the later boundary correction is proven by runtime introspection, Advisor removal and deployed targeted smoke without changing the older release-pinned acceptance contract.

## Rollback / recovery

If later regression evidence identifies an issue, restore the prior public function definitions from the CF-205/206 replay migrations and remove the moved `l4_api` overloads only after confirming no dependent runtime call remains. Do not alter or delete `pipeline.layer4_mass_operations`, `pipeline.layer4_scope_rules`, quality findings, Scholarship mappings or audit history as part of rollback.
