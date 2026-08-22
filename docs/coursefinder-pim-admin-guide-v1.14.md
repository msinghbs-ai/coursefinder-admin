# CourseFinder PIM Admin Guide v1.14

**UI:** PIM Admin v2.12 + Pipeline Ops v1.0 + Evidence v1.0 + Data Quality v1.0 + Access Admin v1.0  
**Effective:** 23 August 2026  
**Status:** **CURRENT ADMIN OPERATING GUIDE**  
**Supersedes:** `docs/coursefinder-pim-admin-guide-v1.13.md`

All accepted v1.13 PIM, Pipeline, Evidence and Data Quality semantics remain in force. This revision adds Access Admin operation, Data Quality snapshot freshness and automated release-UAT guidance.

## 1. Operational authority model

The operational journey remains:

`Layer 1 Regulatory → Layer 2 Deterministic/Structured Enrichment → Layer 3 AI Suggestions → Layer 4 Human Resolution → Search Admission → Publication`

Do not collapse these authorities. Search admission is not publication and no missing value may be manufactured merely to improve readiness.

## 2. Browser and role boundary

| Area | Minimum role |
|---|---|
| Overview / Catalogue / Data Quality | assigned CourseFinder role |
| Review Queue / Evidence | Curator, rank 3 |
| Pipeline Control / Jobs / Sources | Pipeline Operator, rank 4 |
| PIM Configuration | PIM Admin, rank 5 |
| Users & Roles / identity administration | Platform Admin, rank 6 |

Normal reads use:

`Supabase Auth → public.admin_read(text,jsonb) → server rank check → governed internal read`.

Privileged Access Admin mutations use the JWT-protected `admin-user-management` server boundary; the service-role key is never exposed to the browser.

## 3. Users & Roles — Access Admin v1.0

Workspace:

`Platform Administration → Users & Roles`

Platform Admin can:

- list/search current Auth users and governed role assignments;
- create a confirmed controlled UAT/test account where appropriate;
- use invite-first provisioning for normal staff;
- assign/replace one or more governed CourseFinder roles;
- set/remove a common expiry for non-Platform-Admin roles;
- disable/re-enable a controlled account;
- review recent access-management audit events.

Six governed roles remain:

1. Viewer;
2. Counsellor;
3. Curator;
4. Pipeline Operator;
5. PIM Admin;
6. Platform Admin.

Effective access is the highest active, unexpired role.

### Safety rules

The server rejects:

- Platform Admin self-disable;
- self-removal of `platform_admin`;
- removing/disabling the last active Platform Admin;
- an empty/unknown governed role assignment;
- expiry on `platform_admin` in v1.

Do not attempt destructive self-lockout merely for UAT. Server negative tests are the accepted evidence for these invariants.

### Audit/privacy

Access events include create/invite, role replacement and disable/enable. Passwords, tokens and sessions are excluded from access-audit payloads and governance records.

## 4. Data Quality freshness model

Data Quality v1.0 semantics remain unchanged:

`present / source_null / not_applicable / zero / suppressed / not_yet_enriched / stale / ambiguous / rejected`.

The aggregate overview is now a **timestamped operational snapshot**, refreshed every 15 minutes. The UI explicitly shows the snapshot computation/freshness information.

Exception drill-down remains **live** and server-paged.

Operationally:

`Snapshot domain aggregate → live exception state → canonical entity → Evidence / Review when real`.

Do not interpret the overview timestamp as a canonical verification timestamp for an individual entity.

## 5. Data Quality examples retained

- AU Course with accepted CRICOS Course-Location source absence can be `source_null`; no synthetic Campus is created.
- AU registered Tuition Fee may legitimately be zero and is `zero`, not missing.
- NZ regulatory tuition is `not_applicable` under the accepted Layer 1 authority contract.
- absent Provider-current fee / Course URL / Intake / English before successful later enrichment is `not_yet_enriched`.
- Search projection presence proves Search admission only, not publication.

## 6. Mobile operation

Data Quality is accepted on desktop and Pixel-7/mobile browser profiles. The mobile workspace has its own bounded vertical scroll container so operators can reach lower readiness domains and state controls.

Any future responsive regression that prevents a normal operator from reaching an actionable control is a product/UAT defect, not an automation inconvenience.

## 7. Automated deployed acceptance

Every Pilot `main` promotion can automatically execute the governed deployed UAT critical path on:

- Chromium desktop;
- Chromium mobile / Pixel 7 emulation.

Current critical path proves:

1. authenticated login;
2. Data Quality snapshot policy/state counts;
3. regulatory-fee Source-null = 191 and pages 1–4;
4. canonical Course detail / Fee semantics;
5. private CRICOS Regulatory Snapshot Evidence detail.

Unexpected HTTP 5xx fails the deployed test. Runtime evidence also captures 4xx, browser console errors and page errors.

Do not update governed expected counts merely to make a failed test pass. Investigate the source/change first.

## 8. Current accepted release

Pilot:

`msinghbs-ai/Coursefinder-Pilot@e877e3e28cd281ff3751a70bc500eeb0d8f31963`

Visible runtime marker:

`PIM Admin v2.12 · Pipeline Ops v1.0 · Evidence v1.0 · Data Quality v1.0 · Access Admin v1.0 · governed`

PIM Admin itself remains v2.12; Access Admin is an independently versioned v1.0 capability.

Final deployed automated acceptance:

- workflow run `32600027592`;
- desktop 3/3 PASS;
- mobile 3/3 PASS;
- zero recorded HTTP 4xx/5xx or console/page errors in final runtime artefacts.

## 9. Governing references

- `CF-CHG-20260821-018` — Data Quality v1.0 — CLOSED / PASS;
- `CF-CHG-20260822-019` — UAT Harness v1.0 — CLOSED / PASS;
- `CF-CHG-20260822-020` — Access Admin v1.0 — CLOSED / PASS;
- `CF-CHG-20260823-021` — Data Quality snapshot/concurrent hardening — CLOSED / PASS;
- Database Architecture v2.10.39;
- Admin/PIM Design Decisions v1.13;
- Running Build v2.63.

The pre-existing Supabase leaked-password-protection warning remains a separate security backlog item and was not introduced by these controls.
