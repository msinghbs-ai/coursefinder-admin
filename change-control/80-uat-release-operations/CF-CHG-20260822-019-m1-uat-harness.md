# CF-CHG-20260822-019 — M1 UAT Harness automated operational acceptance

**Status:** **CLOSED / PASS**  
**Category:** `80-uat-release-operations`  
**Initiated:** 22 August 2026 13:39 AEST (UTC+10)  
**Closed:** 23 August 2026 07:39 AEST (UTC+10)  
**Origin chat/workstream:** `M1-UAT-HARNESS — Automated Operational Acceptance`  
**Owner:** CourseFinder release/UAT governance  
**Change class:** CI/CD / browser acceptance / test evidence / release operations

## 1. Objective

CourseFinder UAT Harness v1.0 converts deterministic browser acceptance from a screenshot-heavy manual sequence into a governed repeatable gate:

`PR build + local smoke → promotion → deployed authenticated desktop/mobile acceptance → retained evidence → commit status`.

Human judgement remains appropriate for semantic wording and genuinely visual decisions. Authentication/RBAC is never bypassed.

## 2. Security contract — PASS

- normal Supabase Auth only;
- no browser service-role credential;
- no committed password/token/session state;
- no test-only production endpoint;
- deployed credentials supplied only through repository Actions secrets;
- Evidence still requires a normally authorised Curator+ identity;
- private Evidence/storage boundaries remain unchanged;
- fixture changes are governed rather than automatically rewritten after failure.

## 3. Implemented harness

The Pilot contains:

- Playwright desktop and Pixel-7/mobile projects;
- governed Data Quality fixture;
- local unauthenticated login-shell smoke;
- deployed authenticated Data Quality critical path;
- runtime collection for HTTP 4xx/5xx, `console.error` and page errors;
- milestone screenshots, JSON/JUnit, traces/videos and HTML report artefacts;
- automatic deployed execution on every `main` promotion;
- machine-readable commit contexts:
  - `coursefinder/deployed-uat/chromium-desktop`;
  - `coursefinder/deployed-uat/chromium-mobile`.

Runtime evidence records the `admin_read` operation name for failures without recording request arguments or credentials. Per-test status is explicitly labelled as capture-time state; Playwright/JUnit/GitHub remain the final-status authorities.

## 4. Governed fixture

The harness validates, but does not redefine, the accepted CF-CHG-018 baseline:

- AU Courses: 26,648;
- AU+NZ Courses: 33,105;
- all-country Courses: 43,461;
- regulatory fee present: 26,326;
- regulatory fee source-null: 191;
- regulatory fee not-applicable: 6,457;
- regulatory fee zero: 131;
- regulatory fee readiness: 99.28%;
- Evidence source: `CRICOS Providers, Courses and Locations`.

## 5. Initial implementation gate — PASS

Pilot PR #20 implemented UAT Harness v1.0.

PR gate run #109 / ID `32550196119`:

- production Vite build PASS;
- 8 Playwright tests discovered across desktop/mobile projects;
- Chromium installation PASS;
- local login-shell smoke PASS;
- evidence artefact `9469812028` uploaded.

The harness was promoted at `80c293ff3d757a14cdb4495508684df1e6036e64`.

## 6. First authenticated deployed run — useful FAIL

After the governed UAT credentials were configured, the automatic deployed harness successfully authenticated both desktop and mobile and exposed real `public.admin_read` HTTP 500s under concurrent load.

Supabase reconciliation proved PostgreSQL statement-timeout cancellations rather than authentication failure. The cold AU+NZ Data Quality overview recomputation exceeded the authenticated 8-second browser timeout.

This failure is accepted as evidence that the harness worked as designed. The 5xx condition was not ignored and the browser timeout was not increased to conceal it.

The remediation is governed by `CF-CHG-20260823-021`.

## 7. Post-remediation run and secondary findings

Pilot PR #23 promoted the Data Quality snapshot/read-path hardening at:

`6c8e8458033c8559013f3f79d47a46a1a9cd984a`.

Automatic deployed run **326000?** was preceded by run `32599359395`, which no longer reproduced the original Data Quality timeout but exposed two separate acceptance defects:

1. **desktop harness assertion defect** — the real Evidence drawer rendered successfully with zero HTTP/console errors, but the test expected case-sensitive DOM text different from the actual `Evidence artifact` / `Private evidence boundary` strings;
2. **real mobile responsive defect** — below 820px the fixed Data Quality shell changed to block layout without a bounded `.dq-main` scroll container, making lower domains unreachable by normal mobile viewport scrolling.

Both were corrected rather than waived:

- Evidence assertions now target the actual drawer semantics case-insensitively;
- mobile Data Quality `.dq-main` is explicitly height-bounded and vertically scrollable with momentum scrolling;
- runtime JSON now distinguishes capture-time status from final test result.

Pilot PR #24 passed production build, suite discovery, Chromium installation and local browser smoke before promotion.

## 8. Final deployed acceptance — PASS

Final accepted Pilot head:

`e877e3e28cd281ff3751a70bc500eeb0d8f31963`

Automatic deployed workflow:

- run ID: **32600027592**;
- target: `https://coursefinder-pilot.techm.workers.dev`;
- normal governed UAT identity via Actions secrets;
- desktop job: **SUCCESS**;
- mobile job: **SUCCESS**.

### Desktop

All three deployed tests passed:

1. regulatory-fee states + Source-null 191 + pages 1–4;
2. Exception → canonical Course → Fee semantics;
3. Exception → real private CRICOS Regulatory Snapshot Evidence artifact.

Runtime: **3 passed in 25.5s**.

Artefact:

- ID `9482641524`;
- digest `sha256:8dddfadd2c970037030f2ecf6efb4f25d73c6c8dc2a2c134e68c63c78e666666`;
- retention 30 days.

### Mobile

The same three deployed tests passed under Pixel 7 emulation, including scrolling to and activating the regulatory-fee Source-null state.

Runtime: **3 passed in 23.3s**.

Artefact:

- ID `9482641597`;
- digest `sha256:e601d52976be082e7db17c878fee5b207c0d9a80e16574eb2f4fe21d01fef2de`;
- retention 30 days.

Both final commit contexts are `success`.

## 9. Final artefact inspection — PASS

The six final per-test runtime JSON records were inspected after the workflow completed.

Across desktop and mobile:

- server errors: **0**;
- client HTTP errors: **0**;
- console/page errors: **0**;
- status-at-capture: `passed`;
- expected status: `passed`.

The retained evidence includes overview, page-1/page-4 exception, Course detail and Evidence Regulatory Snapshot screenshots for both projects.

## 10. Closure

**Final gate: CLOSED / PASS.**

UAT Harness v1.0 is now a working authenticated release gate, not only test source. Every Pilot `main` promotion can produce independently visible desktop/mobile status tied to the exact SHA and retained evidence. No authentication or CourseFinder role boundary was weakened to obtain this result.
