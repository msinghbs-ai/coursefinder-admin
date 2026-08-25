# CourseFinder Milestone 2 Consolidated Review v1.0

**Status:** CURRENT PROGRAMME REVIEW BASELINE  
**Date:** 25 August 2026  
**Change Control:** `CF-CHG-20260825-031`

## Executive position

M2.1 — Layer 2 Platform is **CLOSED / PASS** after final SHA-bound deployed desktop/mobile UAT. The programme has moved beyond Layer 2 experimentation: deterministic Layer 2 acquisition/extraction, retained Evidence, safe candidate application, provider routing, completeness measurement and Layer 3 fall-out are accepted platform capabilities.

The next phase is not another proof-of-concept. It is controlled scale-out and Production establishment with security as the primary acceptance criterion.

## What M2.1 achieved

| Capability | Result | Acceptance evidence / outcome |
|---|---|---|
| Layer contract | PASS | L1 authoritative/regulatory → L2 deterministic → L3 AI-assisted → L4 human resolution; L4 terminal |
| Source Profiles | PASS | versioned source/discovery/parser/Evidence profiles; Course Facts and Scholarships only for paid L2 acquisition |
| Provider abstraction | PASS | Direct HTTP, Scrape.do, Firecrawl and ZenRows integrated behind governed provider routes |
| Secret handling | PASS | vendor credentials Vault-only/write-only; no browser secret exposure |
| Provider attempts | PASS | actual route/provider, response, runtime and Evidence lineage recorded |
| Native + normalised Evidence | PASS | versioned private Evidence with hashes and runtime metadata |
| Deterministic Course extraction | PASS | identity/fee/description safety guards; no silent identity redefinition |
| Candidate apply | PASS | supported L2 facts can be applied without changing Search/publication |
| Completeness model | PASS | factual completeness measured; `not_yet_enriched` retained for unresolved facts |
| Federation live cohort | PASS | average completeness 37.5% → 92.5%; five of ten Courses reached 100% |
| Scholarship path | PASS | listing → detail discovery → retained Evidence → deterministic detail candidate |
| L3 fall-out measurement | PASS | unresolved domains measured rather than hidden; current Federation fall-out primarily tuition |
| M1 regression | PASS | 33,105 Search docs retained; zero publication side-effect |
| Admin Layer 2 Operations | PASS | management-oriented Layer 2 workspace with progressive drill-down |
| Desktop/mobile deployed UAT | PASS | run `32795496640` against Pilot SHA `cba0e9e…` |

## Consolidated Milestone 2 roadmap

Dates are programme target windows and may move only through Change Control if a gate requires rework.

| Milestone | Target window | Objective | Principal tasks | Exit gate |
|---|---|---|---|---|
| **M2.1 L2 Platform** | 23–25 Aug 2026 | Establish deterministic L2 platform and operating model | provider abstraction, source profiles, evidence, extraction, apply, completeness, Scholarship path, UI/UAT | **CLOSED / PASS** |
| **M2.2 Security & Production Foundation** | 25 Aug–4 Sep 2026 | Establish production-grade security, isolation and deployment baseline | Prod architecture, Supabase Pro/region, Auth hardening, RPC/ACL review, secret model, backups/PITR decision, CI/CD environments, Cloudflare separation, restore test, security UAT | zero unexplained Critical/High; explicit disposition of all WARN; restore + RBAC + deployment PASS |
| **M2.3 L2 Scale-Out & Evidence Economics** | 1–18 Sep 2026 | Fill AU/NZ L2 enrichment at controlled cost and evidence growth | Firecrawl subscription, provider routing thresholds, country/provider batches, scholarships, dedupe, retention, evidence storage monitoring, quality sampling, source health | target coverage/completeness achieved; cost/entity and GB/entity known; no identity/fee safety regression |
| **M2.4 Layer 3 Operationalisation** | 7–25 Sep 2026 | Mature AI interpretation as a governed exception processor | model profiles, prompt/version control, confidence/evidence contract, cost budgets, retries, deterministic pre/post validation, escalation to L4, L3 menu/workspace, red-team UAT | bounded L3 resolves accepted exception classes with measurable precision and safe L4 fallback |
| **M2.5 Production Readiness & Cutover** | 21 Sep–2 Oct 2026 | Build and accept Production environment without broad publication assumption | clean Prod project, controlled data seed, environment-specific secrets, monitoring, on-call/runbook, bug workflow, DR exercise, performance, final security/release gate | Production acceptance PASS; broad publication remains separate explicit gate |

## Required mature Admin IA

The Admin must now present the operating model as real platform capabilities rather than a Pilot collection of utilities.

### Primary operational workspaces

1. **Layer 1 — Regulatory**
   - country/source status;
   - last successful authoritative ingestion;
   - source version/hash;
   - records discovered/accepted/rejected;
   - freshness/SLA;
   - Evidence;
   - change impact;
   - downstream canonical impact.

2. **Layer 2 — Enrichment**
   - country/provider/source-profile status;
   - schedule/batch/routing policy;
   - direct vs paid provider use;
   - resolution/completeness uplift;
   - vendor units/cost;
   - Evidence growth;
   - unresolved domains routed to L3;
   - provider/source health.

3. **Layer 3 — AI Interpretation**
   - queue by unresolved domain;
   - model/profile/prompt version;
   - input Evidence lineage;
   - confidence and validation result;
   - accepted/rejected/retry/escalated counts;
   - token/cost/latency budget;
   - deterministic post-validation;
   - fall-out to Layer 4.

4. **Layer 4 — Human Review** remains terminal and exception-focused.

### UI maturity rules

- primary navigation must use business/operational concepts, not table names;
- each Layer workspace gets a scorecard + filterable work queue + entity drill-down + Evidence cross-link;
- status must distinguish `healthy`, `stale`, `blocked`, `degraded`, `not configured`, `not yet run`;
- no layer can report success purely from HTTP/API success; accepted factual outcome is required;
- every mutation/action displays authority, role and consequence;
- cost and Evidence growth are first-class L2/L3 operational metrics;
- mobile remains usable for status/review, while advanced configuration may be desktop-first;
- Search/Publication remain downstream product states and are never called Layer 5.

## Layer 2 acquisition subscription decision

### Recommended initial paid subscription: Firecrawl Standard

Reasoning:

- M2.1 already proved Firecrawl 10/10 on the RMIT/UQ benchmark;
- its richer HTML/Markdown Evidence resolved an ambiguous UQ fee case that other providers did not;
- current Standard allowance is 100,000 pages/month, sufficient for an initial one-pass AU+NZ or broader 43,461-Course campaign with headroom when Direct HTTP remains first route;
- the platform returns useful normalised content for deterministic extraction, reducing avoidable L3 calls.

Operational policy remains:

`Direct HTTP → Firecrawl when richer/rendered Evidence is required → Scrape.do / ZenRows fallback where domain behaviour requires it`.

Do not subscribe to multiple large paid tiers before measuring actual per-domain paid-route usage. Keep Scrape.do on Free initially; upgrade it to Hobby/Pro only when logs show a material class of domains that Firecrawl/Direct do not serve reliably or economically.

## Evidence storage sizing

Measured 25 Aug Pilot state:

- 1,583 Evidence objects;
- 1,793,315,334 bytes (~1.67 GiB);
- L2 v2 Native + Normalised sample: roughly 0.8 MiB per successful Course-page acquisition pair.

### Planning model

| Scenario | Approximate Evidence requirement |
|---|---:|
| Current Pilot | 1.67 GiB |
| One pass across AU+NZ 33,105 Courses | ~26–35 GiB L2 Course-page Evidence |
| One pass across 43,461 Courses | ~35 GiB base; plan 45–60 GiB incl. discovery/retries/Scholarships/headroom |
| 12 full monthly retained passes with no dedupe/lifecycle | >400 GiB/year likely |

Supabase Pro includes 100 GB file storage, so the first broad enrichment pass fits comfortably if evidence is managed. The risk is **retention multiplication**, not the first crawl.

Required controls before continuous scale:

- content-hash dedupe;
- do not persist duplicate normalised forms when source/hash is unchanged unless required by audit semantics;
- source-specific recrawl cadence rather than blanket monthly full refresh;
- legal/operational retention class per Evidence type;
- referenced/held Evidence cannot be deleted by a simple age rule;
- monthly storage forecast and alert thresholds at 60%, 75%, 90%;
- evaluate cold tier/off-platform archive only after the first measured production month.

## Standing milestone meeting table

Every milestone meeting must review the following, even where the answer is `none`:

| Review dimension | Required question |
|---|---|
| Outcome | What user/platform capability is now materially possible? |
| Security | What trust boundary changed? What was independently tested? |
| Data authority | Which source/layer is authoritative and what cannot it override? |
| Implementation | What code/schema/runtime actually changed? |
| UAT | Which automated database/API/security/browser tests passed? |
| Evidence | What artifacts/hashes/runs prove the result? |
| Scale | What volume, latency, cost and storage were measured? |
| Operations | How is it monitored, retried, restored and supported? |
| UX | Can the intended role understand status/action/consequence without backend knowledge? |
| Regression | What previously accepted invariant was re-tested? |
| Residual risk | What remains open, deferred or accepted? |
| Next gate | What exact PASS criteria unlock the next milestone? |

## Immediate next work

M2.2 is the next authoritative milestone. No Production cutover, broad publication or L3 autonomous write authority is implied by M2.1 closure.
