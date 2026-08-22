# CourseFinder M1-UAT-HARNESS — Technical Acceptance

**Evidence window:** 22–23 August 2026  
**Change Control:** `CF-CHG-20260822-019`  
**Result:** **PASS — IMPLEMENTATION + AUTHENTICATED DEPLOYED DESKTOP/MOBILE GATE ACCEPTED**

## 1. Scope

This acceptance validates UAT Harness v1.0 as a repeatable release-control mechanism. It validates the existing CF-CHG-018 Data Quality fixture; it does not redefine Data Quality semantics.

Accepted operating model:

`PR production build + local browser smoke → promotion → authenticated desktop/mobile browser acceptance → retained evidence → commit status`.

## 2. Security — PASS

- no auth bypass;
- no browser service-role credential;
- no test-only production route;
- no committed password/token/session state;
- deployed credentials sourced from GitHub Actions secrets;
- deployed URL required to use HTTPS;
- Evidence path exercised with a normally authorised Curator+ identity;
- normal CourseFinder RBAC remained authoritative throughout.

## 3. PR/build gate — PASS

Initial implementation PR #20 / workflow run #109 (`32550196119`) proved:

- Node 22 production build;
- 8 Playwright tests discoverable across desktop/mobile projects;
- Chromium installation;
- local login-shell browser smoke;
- evidence artefact upload.

Later remediation PRs retained the same gate. Final PR #24 also passed production build, suite discovery, Chromium installation, local browser smoke and evidence upload before promotion.

## 4. Harness failure detection — PASS

The first real authenticated concurrent desktop/mobile run successfully logged in and exposed `admin_read` HTTP 500s caused by PostgreSQL statement timeouts. The harness failed those tests even where the UI could otherwise recover.

The timeout was remediated under `CF-CHG-20260823-021`; the authenticated browser timeout was not increased and 5xx detection was not weakened.

A later deployed run exposed:

- a case-sensitive Evidence locator defect in the harness while the actual Evidence drawer was correctly rendered;
- a real mobile Data Quality scroll-container defect.

Both were repaired and re-tested. No failing acceptance condition was waived.

## 5. Final deployed release — PASS

Accepted Pilot SHA:

`e877e3e28cd281ff3751a70bc500eeb0d8f31963`

Workflow run:

`32600027592`

Target:

`https://coursefinder-pilot.techm.workers.dev`

Commit statuses:

- `coursefinder/deployed-uat/chromium-desktop` — **success**;
- `coursefinder/deployed-uat/chromium-mobile` — **success**.

### Desktop result

3/3 deployed tests PASS in 25.5 seconds:

1. governed regulatory-fee states and all 191 Source-null exceptions page correctly;
2. exception opens canonical Course detail / Fee semantics;
3. exception opens real private CRICOS Regulatory Snapshot Evidence detail.

Artefact ID `9482641524`, digest `sha256:8dddfadd2c970037030f2ecf6efb4f25d73c6c8dc2a2c134e68c63c78e666666`.

### Mobile result

3/3 deployed tests PASS in 23.3 seconds under Pixel 7 emulation, including the previously blocked mobile scroll path.

Artefact ID `9482641597`, digest `sha256:e601d52976be082e7db17c878fee5b207c0d9a80e16574eb2f4fe21d01fef2de`.

Both artefacts retain reports/test results/runtime evidence for 30 days.

## 6. Final runtime evidence — PASS

All six per-test runtime JSON files were independently inspected after upload.

Desktop and mobile combined:

- unexpected HTTP 5xx: **0**;
- HTTP 4xx diagnostics: **0**;
- browser `console.error` / uncaught page errors: **0**;
- all status-at-capture values: `passed`;
- all expected statuses: `passed`.

The Evidence test proves the real private Evidence workspace rather than a synthetic fixture: `Regulatory Snapshot`, source `CRICOS Providers, Courses and Locations`, and the private Evidence boundary are all required assertions.

## 7. Governed fixture retained

- AU Courses 26,648;
- AU+NZ Courses 33,105;
- all-country Courses 43,461;
- regulatory fee present 26,326;
- source-null 191;
- not-applicable 6,457;
- zero 131;
- readiness 99.28%.

Fixture values remain explicit and cannot silently update themselves after a failure.

## 8. Final verdict

| Gate | Result |
|---|---|
| Playwright source / security contract | **PASS** |
| Production build / suite discovery | **PASS** |
| Local Chromium smoke | **PASS** |
| Authenticated deployed desktop | **PASS — 3/3** |
| Authenticated deployed mobile | **PASS — 3/3** |
| Unexpected 5xx / 4xx / console errors | **PASS — 0** |
| Evidence artefacts retained | **PASS** |
| SHA-bound desktop/mobile commit statuses | **PASS** |

**Overall: CLOSED / PASS.**
