# CourseFinder Running Build v2.74

**Status:** M1 FROZEN / M2.1 CLOSED-PASS / M2.2 CLOSED-PASS / M2.3 CLOSED-PASS / **M2.4.0 CLOSED-PASS**  
**Date:** 26 August 2026  
**Supersedes:** `docs/coursefinder-running-build-v2.73.md`  
**Master Project Plan:** `docs/coursefinder-master-project-plan-v1.74.md`  
**Change Controls:** `CF-CHG-20260826-040`, `CF-CHG-20260826-042`

## Accepted Pilot runtime

**Final M2.4.0 source / acceptance SHA:**

`msinghbs-ai/Coursefinder-Pilot@ba846abb8f55c0c28d65de9e676bd29ed09a3ab4`

Visible browser release:

- PIM Admin `v2.15.6`;
- M2.3 Intelligence remains the accepted underlying Layer 3/4 capability set.

Acceptance evidence:

- Frontend Build `32958795576` — PASS;
- deployed UAT `32958795547` — PASS;
- desktop job `98146317262` — PASS;
- mobile job `98146317373` — PASS.

## M2.4.0 accepted changes

### Primary Admin information architecture

Accepted operating order:

`Overview → Catalogue → Data Operations → Insights → Quality & Review → Decision Tools → Governance & Platform → Help & Guides`.

`Data Operations` provides the normal Layer 1–4 operating model plus Evidence, Jobs/Runs and Onboarding according to existing role/rank boundaries. Scholarship Selection remains a Decision Tool. Guides & Runbooks are visible in-product.

Layer 1 normal operator entry is `Data Operations → Layer 1 — Regulatory`; generic Settings is not the routine operator journey. Platform Settings, qualification and destructive controls remain separately privileged.

### Permanent UAT / CI architecture

- shared primary-navigation adapters replace distributed obsolete launcher logic;
- permanent UAT no longer depends on `Layer 2 Operations`, `.m23-launcher`, `.l3cred-launcher` or equivalent floating operational launchers;
- deterministic navigation waits are bounded/fail-fast;
- deployed UAT uses targeted → bounded integration → one nominated acceptance matrix;
- the page-content/UX audit is separate from permanent functional acceptance.

### Course first-render performance

The bounded integration stage exposed a real desktop first-load Course-page performance miss against the unchanged 3,000 ms RPC budget. The mature shell now prioritises the Course page response and loads Course filter metadata immediately afterwards, preserving the same governed payloads and security/data semantics.

Retained integration evidence on `70244120258cf47d25575bc8af4dbb71fee0daf3` / run `32958008107`:

- first desktop `courses_page`: **1,985 ms**;
- `courses_page` payload: **80,557 bytes**;
- `course_filters`: HTTP 200 / **257,659 bytes**;
- RPC budget remains **3,000 ms**;
- Course-filter payload budget remains **350,000 bytes**.

No test threshold was widened to obtain PASS.

## Staged validation evidence

### Targeted

Working SHA `ecc81dfbf5e6e985eb84b4974c50b0657aac10a0`, run `32954022764`:

- desktop `98131600073` — PASS;
- mobile `98131600295` — PASS.

### Bounded integration

Marker SHA `70244120258cf47d25575bc8af4dbb71fee0daf3`, run `32958008107`:

- desktop `98143894774` — PASS;
- mobile `98143894861` — PASS.

### Full acceptance

Nominated acceptance SHA `ba846abb8f55c0c28d65de9e676bd29ed09a3ab4`, run `32958795547`:

- desktop `98146317262` — PASS;
- mobile `98146317373` — PASS.

## Authority/security state

M2.4.0 is a browser/navigation/test-architecture and request-order optimisation gate. It introduced no database DDL and no canonical/source semantic change.

Accepted boundaries remain:

- Layer 1 Regulatory/Authoritative → Layer 2 Deterministic Enrichment → Layer 3 AI-assisted Evidence Interpretation → Layer 4 Human Resolution;
- Search/Publication remain downstream derived consumers;
- no role/rank, RLS, grant, Edge auth, Vault/provider-secret or private Evidence boundary was weakened;
- destructive/Platform Settings authority remains separately privileged;
- NZ first-party Layer 2 Course enrichment remains deferred.

## Gate state

- M1 — CLOSED / PASS / FROZEN;
- M2.1 — CLOSED / PASS;
- M2.2 — CLOSED / PASS;
- M2.3 — CLOSED / PASS — NZ L2 EXPANSION DEFERRED;
- M2.4.0 — **CLOSED / PASS**;
- M2.4.1 — **NEXT / READY**;
- M2.4.2–M2.4.4 — PLANNED;
- broad Publication — NOT AUTHORISED;
- Production cutover — NOT AUTHORISED.

## Next programme gate

Proceed to M2.4.1 Layer 1 Regulatory Operations Maturity & Automation for at least AU and NZ, inheriting the accepted primary navigation, security boundaries, durable follow-up register and staged UAT discipline. M2.4.1 should mature source validation, record-count guardrails, queue/progress/Evidence operations, automation/rechecks, retry/resume and safe housekeeping without reopening M2.4.0 navigation architecture.

## Commercial/time boundary

Technical execution does not create billable-time entries. The maintained engagement-time record remains authoritative.
