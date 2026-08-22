# CF-CHG-20260822-019 — M1 UAT Harness automated operational acceptance

**Status:** **BLOCKED — HARNESS IMPLEMENTED / BUILD + LOCAL BROWSER SMOKE PASS; FIRST AUTHENTICATED DEPLOYED RUN PENDING**  
**Category:** `80-uat-release-operations`  
**Initiated:** 22 August 2026 13:39 AEST (UTC+10)  
**Last updated:** 22 August 2026 13:55 AEST  
**Origin chat/workstream:** `M1-UAT-HARNESS — Automated Operational Acceptance`  
**Owner:** CourseFinder release/UAT governance  
**Change class:** CI/CD / browser acceptance / test evidence / release operations

## 1. Trigger

CF-CHG-018 required a long operator-driven screenshot sequence plus manual Supabase log correlation. The final manual session also exposed transient statement timeouts only through retrospective log inspection. Deterministic browser acceptance therefore needs to become repeatable, evidence-producing and mostly autonomous.

Human acceptance remains appropriate for semantic wording, information hierarchy and genuinely visual judgement. It is no longer the intended mechanism for proving deterministic counts, paging, canonical navigation, Evidence navigation or unexpected server failures.

## 2. Objective

CourseFinder UAT Harness v1.0 uses Playwright in two stages:

1. **PR/build gate** — production Vite build, complete Playwright suite discovery and unauthenticated local Chromium smoke;
2. **deployed acceptance gate** — normal authenticated browser automation against `https://coursefinder-pilot.techm.workers.dev`, using GitHub Actions secrets and the real CourseFinder role boundary.

The harness creates HTML, JSON/JUnit, screenshot/trace/video and browser/network evidence rather than requiring screenshot collection through chat.

## 3. Security decisions

Accepted harness constraints:

- no authentication bypass;
- no service-role credential in browser tests;
- no committed password/token/session state;
- no test-only production endpoint;
- normal Supabase Auth only;
- normal CourseFinder role/rank enforcement only;
- Evidence remains Curator+ rank 3;
- future role-matrix UAT uses separate real test identities rather than role spoofing;
- Playwright output directories are gitignored;
- fixture failures do not auto-rewrite governed expected values.

Required repository Actions secrets for the first deployed run:

- `COURSEFINDER_UAT_EMAIL`;
- `COURSEFINDER_UAT_PASSWORD`.

The current tool connection cannot create or inspect repository Actions secrets, so their existence is not inferred.

## 4. Implemented Pilot source

Pilot PR **#20 — `M1-UAT-HARNESS: Playwright operational acceptance v1.0`** was merged after the PR gate passed.

Current Pilot `main`:

`80c293ff3d757a14cdb4495508684df1e6036e64`

Files added/changed:

- `package.json` — Playwright dependency and UAT commands;
- `playwright.config.mjs` — desktop/mobile projects, reports and evidence retention;
- `tests/uat/expectations.json` — governed CF-CHG-018 fixture;
- `tests/uat/support/runtime-evidence.mjs` — 4xx/5xx/console/page-error capture and milestone screenshots;
- `tests/uat/smoke.spec.mjs` — local login-shell smoke;
- `tests/uat/data-quality-deployed.spec.mjs` — authenticated critical path;
- `.github/workflows/pim-build.yml` — retained production build plus suite discovery + Chromium smoke;
- `.github/workflows/deployed-uat.yml` — manually dispatched deployed desktop/mobile acceptance;
- `.gitignore` — ignores Playwright/runtime artefacts and local secrets;
- `docs/uat-harness.md` — operating/security instructions.

No application runtime route, canonical data, Supabase schema or product ACL was changed.

## 5. Governed fixture

The first automated fixture intentionally codifies the already accepted CF-CHG-018 baseline rather than creating a new semantic baseline:

- AU Courses: 26,648;
- AU+NZ Courses: 33,105;
- all-country Courses: 43,461;
- regulatory fee present: 26,326;
- regulatory fee source-null: 191;
- regulatory fee not-applicable: 6,457;
- regulatory fee zero: 131;
- regulatory fee readiness: 99.28%;
- expected Evidence source: `CRICOS Providers, Courses and Locations`.

A legitimate count change requires investigation/governance before updating this file.

## 6. Automated critical path

The deployed suite contains three tests per browser project:

1. `Login → Data Quality → Regulatory fee states → Source-null 191 → pages 1–4`;
2. `Exception → canonical Course → Fee semantics`;
3. `Exception → Evidence → #evidence?evidence_id=... → Evidence Artifact → Regulatory Snapshot → PRIVATE EVIDENCE BOUNDARY`.

Projects:

- `chromium-desktop` — Desktop Chrome, 1440×1100;
- `chromium-mobile` — Pixel 7 emulation.

PR suite discovery proves all eight configured tests are parseable/discoverable: three deployed tests plus the local smoke in both projects.

## 7. Runtime evidence contract

For each deployed browser test the harness captures:

- unexpected HTTP 5xx responses;
- HTTP 4xx responses for diagnostic evidence;
- browser `console.error` messages;
- uncaught page errors;
- test/project/result metadata.

Unexpected HTTP 5xx responses **fail the deployed test even if the page later recovers**. Runtime evidence is attached before the 5xx assertion executes, preserving the failure evidence.

Playwright output includes:

- `playwright-report/`;
- `test-results/` with retained failure traces/videos/screenshots;
- `uat-artifacts/results.json`;
- `uat-artifacts/junit.xml`;
- `uat-artifacts/environment.json`;
- per-test runtime JSON;
- explicit milestone screenshots for the deployed critical path.

## 8. CI/UAT evidence — PR gate PASS

Final implementation run:

- workflow: `Pilot Frontend Build`;
- run number: **109**;
- run ID: **32550196119**;
- tested feature head: `a2cada41aaeaeaadf292e94db684b80b3f6c1c12`;
- Node: 22.23.2;
- dependency audit: 0 vulnerabilities;
- production Vite build: **PASS**;
- `npx playwright test --list`: **PASS**, 8 tests discovered in 2 files;
- Chromium installation: **PASS**;
- local browser smoke: **PASS**, 1 test passed in ~3.1 seconds;
- smoke evidence upload: **PASS**.

Latest PR-gate artefact:

- name: `pilot-browser-smoke-32550196119-1`;
- artefact ID: `9469812028`;
- size: 214,738 bytes;
- digest: `sha256:3552483b89bcabe79333988d82007d4b60e13b8db94ff4565ccf58f7b8d2a65a`;
- retention: 14 days.

This proves the harness source/build/smoke/evidence pipeline. It does not substitute for authenticated deployed UAT.

## 9. Deployed workflow contract

`.github/workflows/deployed-uat.yml` is a `workflow_dispatch` job with an HTTPS `base_url` input defaulting to the Pilot Worker.

Matrix:

- Chromium desktop;
- Chromium mobile.

The workflow:

1. checks out the tested commit;
2. uses Node 22;
3. installs dependencies;
4. fails clearly if UAT secrets are absent;
5. rejects a non-HTTPS deployed base URL;
6. installs Chromium;
7. runs the governed deployed suite;
8. uploads reports/traces/runtime evidence even on failure, retention 30 days.

## 10. Current blocker

No real authenticated `CourseFinder Deployed UAT` workflow run has yet been executed against the Worker after merging PR #20.

The current connected GitHub tooling can inspect/rerun workflow jobs but does not provide repository-secret creation or initial `workflow_dispatch` execution. Credentials must therefore be configured through GitHub Actions settings and the first workflow run triggered there.

This is an external acceptance prerequisite, not a reason to weaken authentication.

## 11. No data/architecture change

This control changes release automation only. It does not alter canonical identity, source authority, Evidence grain/private Storage, Search admission, publication semantics, Supabase schema or the `public.admin_read` browser boundary.

Database Architecture v2.10.38 remains current. Master Project Plan v1.59 / Running Build v2.62 remain the accepted product baseline until this release-process gate closes.

## 12. Relationship to CF-CHG-018

`CF-CHG-20260821-018` remains **CLOSED / PASS**. Its accepted semantics/counts are the first governed fixture for this test harness. The harness validates that baseline; it does not redefine it.

## 13. Acceptance status history

| Time | Status | Evidence |
|---|---|---|
| 22 Aug 2026 13:39 AEST | IMPLEMENTING | CF-CHG-019 opened; Pilot/Admin feature branches created. |
| 22 Aug 2026 13:51–13:54 AEST | PR UAT | Production build, Playwright suite discovery and local Chromium smoke executed in GitHub Actions. |
| 22 Aug 2026 13:54 AEST | IMPLEMENTATION GATE PASS | Run #109 / ID 32550196119 PASS; evidence artefact 9469812028 uploaded. |
| 22 Aug 2026 13:54 AEST | SOURCE PROMOTED | Pilot PR #20 merged to `main` at `80c293ff3d757a14cdb4495508684df1e6036e64`. |
| 22 Aug 2026 13:55 AEST | BLOCKED — DEPLOYED RUN PENDING | First authenticated desktop/mobile workflow-dispatch run not yet executed. |

## 14. Closure

**Final status:** **BLOCKED — HARNESS IMPLEMENTED / BUILD + LOCAL BROWSER SMOKE PASS; FIRST AUTHENTICATED DEPLOYED RUN PENDING**  
**Closed at:** N/A  
**Outcome:** Playwright UAT Harness v1.0 is implemented and source-promoted with a passing production build, full suite discovery, browser smoke and evidence-artifact pipeline. Closure is withheld only for a real authenticated deployed desktop/mobile run using normal Supabase Auth/CourseFinder RBAC.