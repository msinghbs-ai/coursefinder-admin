# CF-CHG-20260902-073 — Administration Acquisition route render-crash correction

**Status:** APPLIED / TARGETED UAT PENDING  
**Initiated:** 2 September 2026, 14:16 AEST  
**Origin:** CourseFinder user-reported Pilot browser defect — `/#administration?section=layer2-providers` blanks the application and browser Back changes hashes without restoring rendered pages.  
**Owner / category:** Admin/PIM UX / `30-admin-pim-ux`  
**Change class:** Corrective UI/runtime resilience defect  
**Milestone:** M2.5 — Production Readiness & Platform Maturity

## Problem

On current Pilot source v2.15.30, opening Administration → Acquisition as an administrator renders `Layer2ExecutionPolicySettings`. That renderer references the Lucide component `ShieldCheck`, but `mature-main.jsx` does not import `ShieldCheck`.

For rank 5/6 users this creates a synchronous render-time `ReferenceError`. Because the canonical React application has no workspace-level error boundary around the routed page, the uncaught render failure unmounts the application root. Browser Back/Forward can continue changing the hash/URL while the app remains blank until a full reload remounts React.

## Requested outcome

- Restore Administration → Acquisition without weakening Layer 2 authority, policy, credential or execution controls.
- Preserve normal hash-history navigation and make Back/Forward recoverable.
- Prevent a future route-local render exception from unmounting the complete Admin shell.
- Add a permanent deployed-browser regression covering the exact reported route and Back navigation.

## Affected surfaces

- `src/mature-main.jsx`
- Admin visible UI/release version
- `src/pim-version-entry.js`
- `index.html`
- deployed UAT routing and a dedicated CF-073 browser regression
- M2.5 governance records

No database, Supabase RPC, Edge Function, Evidence, Search, Publication, Zoho, Layer 1 identity or Layer 2 acquisition semantics change.

## Before

- `/#administration?section=layer2-providers` can throw `ReferenceError: ShieldCheck is not defined` for privileged users.
- The uncaught route render error can unmount the entire React root.
- Back/Forward then changes hashes without restoring the UI until refresh.

## After

- Import `ShieldCheck` explicitly.
- Wrap the routed workspace in a route-keyed React error boundary so a route-local render failure keeps the shell mounted and automatically clears when navigation changes.
- Direct Acquisition route and browser Back recovery are covered by permanent deployed UAT.
- Visible UI version advances from v2.15.30 to v2.15.31.

## Security / authority

This is a browser-render and resilience correction only. Existing rank checks, write-only credentials, Vault storage, Layer 2 execution policy, Firecrawl controls, Evidence requirements and downstream publication/search boundaries remain unchanged.

## UAT

Planned permanent test:
- `tests/uat/cf-073-administration-acquisition-route-deployed.spec.mjs`
- direct visit to `/#administration?section=layer2-providers`
- assert Admin shell, Acquisition provider workspace and Layer 2 execution policy render
- navigate to Administration overview and use browser Back
- assert the Acquisition route renders again without page error / blank root

## Rollback

Revert the CF-073 Pilot source commit(s), visible version bump and UAT wiring. No data rollback is required.

## Implementation refs

Pending source commit and deployed targeted UAT evidence.

## Closure

Pending targeted source/build/deployed browser proof.
