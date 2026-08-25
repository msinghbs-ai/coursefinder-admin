# CourseFinder M2→Production Delivery Plan & Technical Scope of Work v1.0

**Status:** AUTHORITATIVE DELIVERY / HOURS / MILESTONE-MEETING BASELINE  
**Date:** 25 August 2026  
**Change Control:** `CF-CHG-20260825-031`  
**Predecessor:** `docs/coursefinder-master-project-plan-v1.66.md`  
**Governance standard:** `docs/coursefinder-milestone-governance-standard-v1.0.md`

## Purpose

This plan converts the consolidated post-M1 programme into a practical delivery and billing baseline. It includes the complete clean Production stack, security-first acceptance, automated UAT, Layer 2 scale-out, Layer 3 operationalisation, consumer integration, Search/publication and final Production handover.

It also establishes the hours baseline used at milestone meetings. Hours are engineering/architecture/project engagement allocations, not elapsed chat/session time. Actual invoicing remains subject to confirmed engagement time.

## Delivery rules

- Active delivery weeks should remain within approximately **8–12 hours**.
- 16–30 September 2026 is a hard **NO PROJECT DELIVERY / 0 HOURS** period.
- Automated database/API/security/storage/browser UAT is part of the engineering scope, not a separate client UAT burden.
- Security is the primary acceptance gate.
- No broad Search/publication authority is implied by Layer 2 or Layer 3 completion.
- Production is a separate trust boundary and must not be a renamed/copied Pilot environment.
- Supabase/vendor/Cloudflare subscription charges are project expenses and are not engineering hours.

## Consolidated programme and hour envelope

| Milestone | Delivery window | Status | Planned hours | Principal outcome |
|---|---|---|---:|---|
| **M2.0 — Programme Consolidation & Auto-UAT** | 22–24 Aug | COMPLETE / RECORDED | **8** | Consolidate former M2/M3/M4 scope into one governed M2 programme; milestone governance; automated UAT baseline |
| **M2.1 — Layer 2 Platform** | 24–25 Aug | CLOSED / PASS | **3** | Deterministic L2 platform, provider/evidence model, completeness, Scholarship path, deployed UAT |
| **M2.2 — Security & Production Foundation** | 26 Aug–4 Sep | NEXT | **10** | Production trust boundary, Auth/RBAC/RPC/Storage/CI-CD/backup foundation |
| **M2.3 — L2 Scale Enrichment & L1/L2 UX Maturity** | 5–11 Sep | PLANNED | **12** | AU/NZ L2 scale-out, evidence economics, mature operational Layer 1/2 Admin |
| **M2.4 — L3 AI Operations & Pre-Blackout Gate** | 12–15 Sep | PLANNED | **7** | Governed L3 exception processing, validation, Layer 4 fall-out, checkpoint |
| **BLACKOUT** | **16–30 Sep** | NO DELIVERY | **0** | No planned project delivery |
| **M2.5 — Full Production Stack Deployment & Acceptance** | 1–7 Oct | PLANNED | **12** | Clean Production environment deployed, seeded, monitored, restored and security/UAT accepted |
| **M3 — Consumer API / Zoho Integration** | 8–14 Oct | PLANNED | **10** | Browser-safe consumer contract and Zoho integration acceptance |
| **M4 — Search / Publication / Production Handover** | 15–21 Oct | PLANNED | **8** | Search/publication gate, full regression, release/handover and operating acceptance |
| **TOTAL POST-M1** | 22 Aug–21 Oct |  | **70 h** | Complete governed path from M1 Pilot baseline to Production-ready platform |

### Recorded-to-date position

- M1: 28 h — invoiced / closed.
- M2.0: 8 h — recorded.
- M2.1: 3 h — recorded.
- Post-M1 recorded to 25 Aug: **11 h**.
- Remaining planned engineering envelope from 26 Aug onward: **59 h**.

## Weekly hour distribution

| Active week / period | Milestone allocation | Hours | Weekly control |
|---|---|---:|---|
| 22–28 Aug | M2.0 8 + M2.1 3 + M2.2 1 | **12** | maximum normal active-week envelope |
| 29 Aug–4 Sep | M2.2 | **9** | normal active week |
| 5–11 Sep | M2.3 | **12** | heavy scale/UAT week |
| 12–15 Sep | M2.4 | **7** | shortened four-day gate |
| 16–30 Sep | Blackout | **0** | no delivery |
| 1–7 Oct | M2.5 | **12** | Production deployment/acceptance week |
| 8–14 Oct | M3 | **10** | consumer integration week |
| 15–21 Oct | M4 | **8** | final release/handover week |

# Technical Scope of Work

## M2.0 — Programme Consolidation & Automated UAT — 8 h — COMPLETE

| Task ID | Actionable task | Hours | Deliverable / acceptance |
|---|---|---:|---|
| M2.0-01 | Review M1 closure and reconcile remaining roadmap, dependencies and technical debt | 2.0 | consolidated post-M1 programme baseline |
| M2.0-02 | Consolidate former M2/M3/M4 workstreams into a single Milestone 2 programme with sub-gates | 2.0 | coherent M2.1–M2.5 roadmap |
| M2.0-03 | Establish automated database/API/security/browser UAT framework, SHA-bound evidence and regression expectations | 3.0 | Auto-UAT as default release gate |
| M2.0-04 | Establish milestone meeting governance, hour/timekeeping and evidence record structure | 1.0 | repeatable meeting/time baseline |
|  | **M2.0 total** | **8.0** | |

## M2.1 — Layer 2 Platform — 3 h — CLOSED / PASS

| Task ID | Actionable task | Hours | Deliverable / acceptance |
|---|---|---:|---|
| M2.1-01 | Reconcile and accept L2 source-profile, provider-routing, deterministic extraction and Evidence platform | 1.0 | accepted Layer 2 platform contract |
| M2.1-02 | Execute/reconcile deployed desktop/mobile automated UAT and close M2.1 Change Controls | 1.0 | final deployed UAT PASS |
| M2.1-03 | Consolidate evidence sizing, scraper subscription path and Production-transition requirements | 1.0 | operational/capacity/production handoff |
|  | **M2.1 total** | **3.0** | |

**Expense:** Supabase Pro upgrade from 25 Aug 2026 — record at actual supplier invoice/receipt amount; separate from engineering hours.

## M2.2 — Security & Production Foundation — 10 h

| Task ID | Workstream | Actionable task | Hours | Acceptance / evidence |
|---|---|---|---:|---|
| M2.2-01 | Architecture | Define clean Production trust boundaries, environment inventory, region, environment naming and separation from Pilot | 1.0 | approved Production architecture baseline |
| M2.2-02 | Supabase/Auth | Upgrade/validate paid-plan capabilities; enable leaked-password protection; define privileged MFA/session policy | 1.0 | Auth hardening UAT |
| M2.2-03 | Security | Inventory every browser-executable RPC, `SECURITY DEFINER`, grant, exposed schema, view and RLS boundary | 2.0 | zero unexplained critical/high; WARN disposition |
| M2.2-04 | Secrets/CI-CD | Separate Pilot/Production credentials; define GitHub protected environment, scoped secrets and deployment evidence | 1.0 | environment isolation + secret-negative tests |
| M2.2-05 | Backup/DR | Define RPO/RTO, daily backup/PITR decision and restore-test procedure | 1.0 | documented recovery acceptance criteria |
| M2.2-06 | Cloudflare | Define Production Cloudflare deployment/origin/auth/WAF/rate-control boundary | 1.0 | Production frontend security design |
| M2.2-07 | UAT/Security | Automate negative RBAC, Storage, Edge/server auth, RPC abuse and restore readiness checks | 2.0 | security/UAT suite PASS or evidence-backed blocker |
| M2.2-08 | Docs/Governance | Update Production guide, Change Control and milestone acceptance evidence | 1.0 | M2.2 meeting/closure record |
|  |  | **M2.2 total** | **10.0** | |

## M2.3 — Layer 2 Scale Enrichment & L1/L2 UX Maturity — 12 h

| Task ID | Workstream | Actionable task | Hours | Acceptance / evidence |
|---|---|---|---:|---|
| M2.3-01 | Vendor | Configure paid Firecrawl route and controlled provider-budget/concurrency policy | 1.0 | provider readiness + cost limits |
| M2.3-02 | Pipeline | Implement/validate production-shaped L2 scheduling, batches, retry/resume, provider fallback and rate controls | 2.0 | repeatable scale execution |
| M2.3-03 | Evidence | Implement hash dedupe, retention classes, evidence-growth metrics and 60/75/90% storage thresholds | 1.0 | evidence lifecycle controls |
| M2.3-04 | Data | Execute representative/broad AU/NZ Course and Scholarship enrichment batches with identity/fee guards | 3.0 | completeness uplift + factual resolution measurements |
| M2.3-05 | Admin UX | Mature Layer 1 Regulatory and Layer 2 Enrichment scorecards, queues, entity drill-down and Evidence links | 2.0 | desktop/mobile operational UX |
| M2.3-06 | Economics/Quality | Measure pages/entities, vendor units, cost/entity, cost/resolved entity, retry/fallback and storage/entity | 1.0 | scale/economics KPI baseline |
| M2.3-07 | UAT | Run database/API/security/storage/browser/performance/replay regression suites | 2.0 | M2.3 automated UAT PASS |
|  |  | **M2.3 total** | **12.0** | |

## M2.4 — Layer 3 AI Operations & Pre-Blackout Gate — 7 h

| Task ID | Workstream | Actionable task | Hours | Acceptance / evidence |
|---|---|---|---:|---|
| M2.4-01 | AI Governance | Define model/profile/prompt versions, permitted evidence classes, budgets and security/data-boundary rules | 1.0 | governed L3 contract |
| M2.4-02 | Data/Workflow | Establish L3 unresolved-evidence queue, structured suggestion schema, confidence and version lineage | 1.0 | deterministic L2→L3 handoff |
| M2.4-03 | AI/Validation | Implement bounded interpretation for accepted exception classes with deterministic pre/post validation | 2.0 | measurable accepted/rejected/retry outcomes |
| M2.4-04 | Admin UX | Mature Layer 3 AI Interpretation workspace and safe Layer 4 escalation context | 1.0 | operator-visible L3 state |
| M2.4-05 | UAT/Security | Automated prompt/output validation, negative-authorisation, malformed-output, retry and Layer 4 fall-out tests | 1.0 | safe-failure UAT |
| M2.4-06 | Governance | Pre-blackout checkpoint: freeze refs, blockers, restart instructions and next gate | 1.0 | durable 1 Oct restart baseline |
|  |  | **M2.4 total** | **7.0** | |

## 16–30 September 2026 — Blackout

**No planned implementation, deployment, UAT, meeting preparation or billable project delivery. Planned hours: 0.**

Emergency/incident work, if explicitly requested, is outside this baseline and must be separately authorised and recorded.

## M2.5 — Full Production Stack Deployment & Acceptance — 12 h

| Task ID | Workstream | Actionable task | Hours | Acceptance / evidence |
|---|---|---|---:|---|
| M2.5-01 | Supabase | Create/configure clean Production Supabase project in accepted region and apply governed migration baseline | 1.0 | healthy isolated Production project |
| M2.5-02 | Data | Re-run/seed accepted reference and Layer 1 authoritative data; reconcile identity/count/hash invariants | 2.0 | Production data integrity baseline |
| M2.5-03 | Auth/Security | Configure Production Auth, leaked-password protection, privileged MFA/session/RBAC and access expiry | 1.0 | Auth/RBAC negative/positive PASS |
| M2.5-04 | Storage/Secrets | Configure private Evidence Storage, Vault/server secrets, Production scraper keys and access controls | 1.0 | no client secret exposure; Storage PASS |
| M2.5-05 | Cloudflare | Deploy Production Admin/app environment, custom domain/origin isolation, WAF/rate controls as applicable | 1.5 | authenticated Production frontend reachable/isolated |
| M2.5-06 | GitHub CI/CD | Configure protected Production deployment environment, release gates, SHA/migration evidence and rollback | 1.0 | reproducible governed deployment |
| M2.5-07 | L2/L3 Smoke | Execute bounded Production L2/L3 acquisitions/interpretation without implicit publication | 1.0 | retained Evidence + safe canonical behaviour |
| M2.5-08 | Monitoring/Ops | Configure production health, job/source/vendor/storage/security monitoring and management reporting | 1.0 | daily/weekly/monthly operational baseline |
| M2.5-09 | DR | Execute backup/restore/recovery exercise into safe non-Production target | 1.0 | restore/RPO/RTO evidence |
| M2.5-10 | Final UAT | Run Production database/API/security/storage/desktop/mobile/performance/regression acceptance | 1.5 | Production foundation CLOSED/PASS or blocker evidence |
|  |  | **M2.5 total** | **12.0** | |

## M3 — Consumer API / Zoho Integration — 10 h

| Task ID | Workstream | Actionable task | Hours | Acceptance / evidence |
|---|---|---|---:|---|
| M3-01 | API | Freeze/version browser-safe consumer read contract and permitted fields | 2.0 | stable consumer API/RPC contract |
| M3-02 | Security | Implement/verify RLS/grants/auth and negative-access tests; no raw canonical CRUD | 2.0 | browser security gate PASS |
| M3-03 | API | Pagination, filtering, exact-ID lookup and response/error semantics | 1.0 | deterministic consumer behaviour |
| M3-04 | Zoho | Integrate/smoke Zoho widget/client against the governed Production consumer surface | 2.0 | end-to-end consumer path |
| M3-05 | Performance | Representative catalogue API latency/concurrency validation | 1.0 | performance threshold evidence |
| M3-06 | UAT | Automated positive/negative browser/API integration UAT | 1.0 | M3 gate PASS |
| M3-07 | Docs | Developer contract/runbook/handover updates | 1.0 | maintained integration guidance |
|  |  | **M3 total** | **10.0** | |

## M4 — Search / Publication / Production Handover — 8 h

| Task ID | Workstream | Actionable task | Hours | Acceptance / evidence |
|---|---|---|---:|---|
| M4-01 | Search | Reconcile accepted enrichment into Search projection; relevance/performance/idempotency validation | 2.0 | deterministic Search gate |
| M4-02 | Publication/Security | Validate explicit publication eligibility/channel controls, negative access and rollback | 1.5 | no implicit/broad unauthorised publication |
| M4-03 | Regression | Full Production regression: Layer 1–4, Evidence, Admin, Search, API, publication, roles, mobile/desktop | 2.0 | final automated release suite PASS |
| M4-04 | Operations | Finalise monitoring, incident, backup/restore, troubleshooting, bug reporting and management reporting | 1.0 | operations handover accepted |
| M4-05 | Release | Production release/handover, final milestone evidence, residual-risk register and baseline freeze | 1.5 | final Production release decision |
|  |  | **M4 total** | **8.0** | |

# Production stack included in scope

The Production deployment baseline includes:

- separate paid-plan Supabase Production project;
- PostgreSQL schema/migrations and authoritative data seed/re-ingestion;
- Supabase Auth security controls and RBAC;
- RLS/grants/RPC/function security boundary;
- private Supabase Evidence Storage;
- Vault/server-side vendor credentials;
- Layer 1 regulatory ingestion;
- Layer 2 deterministic enrichment and paid-provider routing;
- Layer 3 governed AI interpretation;
- Layer 4 terminal human review;
- Admin/PIM Layer 1–4 operational UX;
- GitHub protected Production CI/CD and SHA-bound automated UAT;
- Cloudflare Production deployment/origin/auth/WAF boundary;
- monitoring, alerts, logs and management reporting;
- backup/restore/DR testing;
- consumer API / Zoho integration;
- Search projection and explicit publication governance;
- documentation, runbooks, troubleshooting and handover.

## Excluded / separately governed

- new country expansion beyond accepted programme scope unless added through Change Control;
- vector/hybrid Search unless a later explicit admission gate approves it;
- broad publication before M4 approval;
- third-party subscription/usage charges (Supabase, Firecrawl, other scraper/AI/vendor usage) — expenses at actual cost;
- emergency work during the 16–30 September blackout unless separately authorised;
- feature additions not required for the accepted milestone use cases.

# Milestone meeting record

At every milestone meeting update the following table in the current milestone record.

| Field | Meeting record |
|---|---|
| Milestone / target window | |
| Planned engineering hours | |
| Hours confirmed/recorded to date | |
| Hours remaining in milestone envelope | |
| Capability outcome | |
| Accepted end-to-end use cases | |
| Architecture/data-authority change | |
| Security/trust-boundary change | |
| Deployment SHA / migrations | |
| Automated UAT run/artifacts | |
| Scale / cost / storage KPI | |
| Admin UX/version | |
| Monitoring / restore / rollback | |
| Failed/rejected approaches | |
| Residual risks / blockers | |
| Expenses incurred | |
| Closure decision | PASS / BLOCKED / DEFERRED / ACTIVE |
| Next exact gate | |

## Billing control

The milestone-hour values are **maximum planned engineering envelopes**, not automatic invoices. Interaction/session timestamps may be retained separately. Only engagement time explicitly confirmed for billing is charged.

At the current AUD 125/hour reference rate previously used for M1, the full 70-hour post-M1 engineering envelope would equate to AUD 8,750 before expenses, of which 11 hours have currently been recorded. This rate reference is for planning only and does not override the actual approved billing arrangement.
