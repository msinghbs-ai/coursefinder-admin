# CF-CHG-20260822-019 — M1 UAT Harness automated operational acceptance

**Status:** **IMPLEMENTING / UAT**  
**Category:** `80-uat-release-operations`  
**Initiated:** 22 August 2026 13:39 AEST (UTC+10)  
**Origin chat/workstream:** `M1-UAT-HARNESS — Automated Operational Acceptance`  
**Owner:** CourseFinder release/UAT governance  
**Change class:** CI/CD / browser acceptance / test evidence / release operations

## 1. Trigger

CF-CHG-018 required a long operator-driven sequence of screenshots plus manual Supabase log correlation to prove deployed Data Quality behaviour. The final session also contained earlier unattributed statement timeouts that were only visible after retrospective log review.

Routine regression should therefore become repeatable, evidence-producing and mostly autonomous. Human acceptance remains required for semantic wording, information hierarchy and genuinely visual judgement, but should not be the mechanism for proving deterministic navigation, counts, paging, role boundaries or server failures.

## 2. Objective

Introduce CourseFinder UAT Harness v1.0 using Playwright with two release stages:

1. **PR/build gate** — production build plus deterministic unauthenticated/local smoke where feasible;
2. **deployed acceptance gate** — authenticated Playwright against `coursefinder-pilot.techm.workers.dev` using a dedicated UAT account supplied only through GitHub Actions secrets.

The harness must produce machine-readable and human-reviewable evidence: HTML report, JSON/JUnit result, screenshots, traces and captured browser/network failures.

## 3. Security constraints

- no authentication bypass;
- no service-role key in browser tests;
- no committed passwords/tokens/session files;
- UAT credentials supplied through repository Actions secrets only;
- test identities use normal Supabase Auth and normal CourseFinder role/rank enforcement;
- Evidence continues to require Curator+ rank 3;
- future role-matrix expansion should use separate test identities rather than role spoofing;
- uploaded artefacts must not include secret values.

Planned secret names:

- `COURSEFINDER_UAT_EMAIL`;
- `COURSEFINDER_UAT_PASSWORD`.

No claim is made that these secrets already exist.

## 4. v1 automated acceptance scope

Initial deployed suite will cover the accepted Data Quality critical path because it is deterministic and already manually proven:

`Login → Data Quality → Regulatory fee/Course/Source-null → assert 191 → paging → canonical Course → Evidence → assert Regulatory Snapshot`.

Governed expected values include:

- AU Course Catalogue = 26,648;
- all-country Course Catalogue = 43,461;
- AU+NZ Course scope = 33,105;
- regulatory-fee present = 26,326;
- regulatory-fee source-null = 191;
- regulatory-fee not-applicable = 6,457;
- regulatory-fee zero = 131;
- regulatory-fee readiness = 99.28%.

Expected values are release fixtures, not silently updated snapshots. A changed governed count requires investigation/change-control context rather than automatic baseline acceptance.

## 5. Evidence contract

A deployed run should retain, at minimum:

- Playwright HTML report;
- machine-readable result JSON/JUnit;
- screenshots/traces on failure and explicit milestone screenshots on the critical path;
- console errors;
- unexpected 4xx/5xx network responses, with 5xx release-failing;
- commit SHA, base URL and run identifier in the run environment/attachments.

Typical artefact tree:

`playwright-report/`, `test-results/`, `uat-artifacts/`.

## 6. CI contract

Existing `Pilot Frontend Build` remains the build authority and must continue to run Node 22 + production Vite build.

A separate `Deployed UAT` workflow will be manually dispatchable initially. It must preflight required secrets, install a Chromium browser through Playwright, run the deployed suite, and upload evidence even on failure.

The deployed job is intentionally not represented as PASS until a real Actions run completes against the Worker with a real governed UAT identity.

## 7. No data/architecture change

This control changes test/release automation only. It does not alter:

- canonical identity;
- source authority;
- Evidence grain/private Storage boundary;
- Search admission;
- publication semantics;
- Supabase database schema or browser read contract.

Database Architecture v2.10.38 therefore remains current.

## 8. Acceptance gate

PASS requires:

1. Playwright/test source and workflow committed in Pilot;
2. existing Vite production build still PASS;
3. PR smoke/static UAT stage PASS where implemented;
4. no secrets committed;
5. deployed workflow has explicit secret preflight and evidence upload;
6. at least one real authenticated deployed UAT run PASS, or the workstream is handed over as **BLOCKED — harness implemented/build-tested; UAT secrets/first deployed run pending**;
7. governance/UAT docs record actual run evidence rather than inferred success.

## 9. Relationship to CF-CHG-018

`CF-CHG-20260821-018` is **CLOSED / PASS** and is not reopened by this work. Its accepted semantics/counts become the first governed fixture for the automated suite.

The two earlier unattributed statement timeouts observed during final manual Data Quality UAT are retained as motivation for automatic 5xx/trace capture, not as a reason to redefine the accepted Data Quality model.

## 10. Current implementation baseline

- Admin baseline: `msinghbs-ai/coursefinder-admin@cbb36d0147c7aaef64b041163a30a1f1ed35d6b5`;
- Pilot baseline: `msinghbs-ai/Coursefinder-Pilot@72721c57d2a11a5fb79288c9eadf4e14602a2e14`;
- Master Project Plan v1.59;
- Running Build v2.62;
- Admin/PIM Design Decisions v1.12;
- PIM Admin Guide v1.13;
- Database Architecture v2.10.38.

## 11. Closure

**Final status:** IMPLEMENTING / UAT  
**Closed at:** N/A  
**Outcome:** pending implementation and first real automated deployed run.