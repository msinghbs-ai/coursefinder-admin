# CF-CHG-20260902-073 — Administration Acquisition route render-crash correction

**Status:** IMPLEMENTED / TARGETED PASS  
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

Permanent test:
- `tests/uat/cf-073-administration-acquisition-route-deployed.spec.mjs`;
- direct visit to `/#administration?section=layer2-providers`;
- assert the canonical Admin shell and Acquisition provider workspace render;
- assert Worker release **v2.15.31** and no workspace-boundary error;
- navigate to Administration overview, use browser Back and prove the Acquisition route renders again without a blank root or browser page error.

The first deployed run `33590425757` failed only because the test also required the rank-5+ **Layer 2 execution policy** heading while the governed UAT account is a lower-rank operator. The Acquisition page itself rendered in that run. The assertion was corrected without widening role permissions.

Targeted deployed proof:
- Pilot source/test head: `c546c2c3bf87e41154a2c5f5d7b6d554026deba4`;
- deployed UAT run `33590571041`, job `100123554544`: **PASS**;
- Chromium desktop: **1 passed (4.6s)**;
- exact route + browser Back recovery: **PASS**;
- Worker visible release: **v2.15.31**;
- no `.m-workspace-error` and no browser `pageerror` observed.

Frontend proof:
- build run `33590571059`: **PASS**;
- build job `100123554410`: **PASS**;
- browser-smoke job `100123640329`: **PASS**.

## Rollback

Revert the CF-073 Pilot source commit(s), visible version bump and UAT wiring. No data rollback is required.

## Implementation refs

- Root-cause/fix commit: `Coursefinder-Pilot@9373966e1a0dcb00ae177fa6376a5ab5942dae44`.
- Role-boundary UAT correction / accepted head: `Coursefinder-Pilot@c546c2c3bf87e41154a2c5f5d7b6d554026deba4`.
- UI/release: **v2.15.31**.
- Deployed UAT: `33590571041` / `100123554544` PASS.
- Frontend build: `33590571059` / `100123554410` PASS.
- Browser smoke: `100123640329` PASS.

## Closure

**Closed targeted corrective gate:** 2 September 2026, 14:24 AEST.

The reported white-page failure is corrected on current Pilot main and verified on the deployed Worker. Browser history itself remains hash-based by design; the route-level error boundary now prevents a future workspace renderer exception from leaving Back/Forward on a permanently blank React root.
