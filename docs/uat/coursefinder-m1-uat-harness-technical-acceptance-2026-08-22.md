# CourseFinder M1-UAT-HARNESS — Technical Acceptance

**Date:** 22 August 2026  
**Change Control:** `CF-CHG-20260822-019`  
**Result:** **PARTIAL PASS — IMPLEMENTATION/PR GATE PASS; AUTHENTICATED DEPLOYED RUN PENDING**

## 1. Scope

This UAT validates the implementation of CourseFinder UAT Harness v1.0. It does not re-test or redefine the already accepted CF-CHG-018 Data Quality semantics.

The target operating model is:

`PR production build + local browser smoke → deployment → authenticated desktop/mobile browser acceptance → evidence artefact → human semantic/visual review only where required`.

## 2. Source review

Pilot PR #20 adds Playwright without changing the application’s authentication, role model, Supabase schema, `public.admin_read` contract or Evidence private boundary.

Security review result:

- no service-role browser credential;
- no auth bypass;
- no test-only production route;
- no committed user/password/token/session state;
- Playwright artefact/output directories ignored by git;
- deployed credentials referenced only through Actions secrets;
- deployed URL required to be HTTPS;
- Evidence critical path still requires a normally authorised rank-3+ identity.

**Result: PASS.**

## 3. Test-source discovery

GitHub Actions run #109 / ID `32550196119` executed:

`npx playwright test --list`

and discovered **8 tests across 2 files**:

### Chromium desktop

1. Data Quality regulatory-fee states + 191 exception rows/paging;
2. exception → canonical Course detail;
3. exception → private Evidence Regulatory Snapshot;
4. unauthenticated local login-shell smoke.

### Chromium mobile

The same four configured test definitions are discoverable under the Pixel 7 project.

This confirms the deployed test source parses and is visible to the runner without requiring UAT credentials at PR time.

**Result: PASS.**

## 4. Production build regression

Final PR gate run:

- workflow: `Pilot Frontend Build`;
- run: **#109**;
- ID: `32550196119`;
- feature SHA: `a2cada41aaeaeaadf292e94db684b80b3f6c1c12`;
- Node: **22.23.2**;
- dependency installation: **PASS**;
- npm audit result: **0 vulnerabilities**;
- Vite production build: **PASS**.

**Result: PASS.**

## 5. Local browser smoke

The final browser-smoke job installed Playwright Chromium and executed:

`npm run test:uat:smoke`

Result:

- 1 Chromium desktop smoke test;
- login email/password/sign-in controls rendered;
- no server-side HTTP 5xx response was observed by the test;
- test runtime approximately 1.2 seconds;
- suite runtime approximately 3.1 seconds.

This smoke intentionally uses placeholder public Supabase configuration and performs no authentication. It proves browser/runtime integrity only; it is not a substitute for deployed acceptance.

**Result: PASS.**

## 6. Evidence artefact pipeline

The final PR run uploaded:

- name: `pilot-browser-smoke-32550196119-1`;
- artifact ID: `9469812028`;
- size: 214,738 bytes;
- digest: `sha256:3552483b89bcabe79333988d82007d4b60e13b8db94ff4565ccf58f7b8d2a65a`;
- retention: 14 days.

The workflow uploads `playwright-report/`, `test-results/` and `uat-artifacts/` even after a test failure.

**Result: PASS.**

## 7. Runtime failure capture

The deployed harness registers browser listeners for:

- HTTP 5xx;
- HTTP 4xx diagnostics;
- `console.error`;
- uncaught page errors.

Per-test runtime JSON is attached before the final 5xx assertion, so evidence is not lost when the test fails. Unexpected HTTP 5xx therefore becomes a deterministic UAT failure even where the application later recovers.

This directly addresses the manual CF-CHG-018 limitation where transient statement timeouts required retrospective log correlation.

**Design/code review: PASS.**  
**Real deployed failure-path execution: not yet exercised.**

## 8. Governed fixture review

The initial fixture exactly reflects the already accepted CF-CHG-018 values:

- AU Courses 26,648;
- AU+NZ Courses 33,105;
- all-country Courses 43,461;
- regulatory fee present 26,326;
- source-null 191;
- not-applicable 6,457;
- zero 131;
- readiness 99.28%;
- expected Evidence source `CRICOS Providers, Courses and Locations`.

The fixture is intentionally explicit and is not automatically rewritten after failures.

**Result: PASS.**

## 9. Source promotion

Pilot PR #20 was merged after the implementation gate passed.

Current Pilot `main`:

`80c293ff3d757a14cdb4495508684df1e6036e64`

**Result: PASS.**

## 10. Remaining deployed acceptance

The following has **not** yet been proven by the automated harness:

- real login with the dedicated governed UAT identity;
- Data Quality critical path on desktop Chromium against the Worker;
- the same critical path using mobile emulation;
- automated Evidence detail assertion against the deployed Worker;
- real automatic failure on an unexpected Worker/Supabase 5xx;
- 30-day deployed UAT evidence artefact creation.

Required Actions secrets:

- `COURSEFINDER_UAT_EMAIL`;
- `COURSEFINDER_UAT_PASSWORD`.

The secrets are deliberately not present in repository source, and their configuration cannot be verified through the current connected GitHub toolset.

## 11. Final verdict

| Gate | Result |
|---|---|
| Playwright source implemented | **PASS** |
| No auth bypass/service-role browser credential | **PASS** |
| Governed fixture committed | **PASS** |
| Production Vite build | **PASS** |
| Full suite discovery | **PASS — 8 tests** |
| Local Chromium smoke | **PASS** |
| PR evidence upload | **PASS** |
| Pilot source promotion | **PASS** |
| Authenticated deployed desktop run | **PENDING** |
| Authenticated deployed mobile run | **PENDING** |
| Deployed UAT evidence artefact | **PENDING** |

**Overall:** **BLOCKED — HARNESS IMPLEMENTED / BUILD + LOCAL BROWSER SMOKE PASS; FIRST AUTHENTICATED DEPLOYED RUN PENDING.**

No product baseline or CF-CHG-018 semantic status is rolled back by this release-process blocker.