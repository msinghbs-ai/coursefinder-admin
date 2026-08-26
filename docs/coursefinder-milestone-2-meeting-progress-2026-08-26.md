# CourseFinder Milestone 2 — Meeting Progress Record

**Prepared:** 26 August 2026  
**Purpose:** meeting-ready record of Milestone 2 accomplishments completed to date and the current M2.4 execution position.  
**Authority:** Master Project Plan v1.73, closed M2.1–M2.3 Change Controls, M2.4 run sheet and deployed UAT evidence.

## 1. Executive progress

Milestone 2 has progressed from Layer 2 platform foundation through Search/security acceleration to a complete governed Layers 1–4 Pilot operating model. M2.1, M2.2 and M2.3 are closed/pass for their accepted scopes. M2.4 is active and is now focused on operational UX consolidation, performance/data-quality optimisation, model/provider monitoring and durable pre-Production regression rather than first-time feature launch.

The platform now has a coherent authority chain:

`Layer 1 Authoritative / Regulatory → Layer 2 Deterministic Acquisition & Extraction → Layer 3 AI-assisted Evidence Interpretation → Layer 4 Human Resolution`

Search and Publication remain downstream product states; they are not approval authorities.

## 2. M2.0 — programme consolidation and automated UAT

Accomplished:

- consolidated the former Milestone 2/3/4 delivery concepts into a governed Milestone 2 progression;
- established Change Control as the durable implementation trace;
- established repository run sheets to remove dependence on long chat history;
- made automated database/API/security/deployed-browser UAT the default acceptance method;
- established desktop/mobile deployed acceptance with retained runtime evidence/screenshots/artifacts;
- aligned milestone planning, technical scope and hour governance without inferring unapproved billable time.

## 3. M2.1 — Layer 2 platform foundation — CLOSED / PASS

Accomplished:

- built the governed Layer 2 source/profile/provider platform;
- separated source profiles, acquisition providers, provider attempts and deterministic extraction from canonical identity;
- retained native/versioned Evidence and provider-attempt lineage;
- implemented governed source/provider configuration, completeness trial and operational management surfaces;
- enforced write-only credential/security boundaries and role-aware mutation paths;
- established factual versus contextual completeness semantics;
- completed deployed desktop/mobile acceptance on the accepted M2.1 runtime.

## 4. M2.2 — Security / Production foundation / Search showcase — CLOSED / PASS

Accomplished:

- verified Supabase Pro and closed the material leaked-password protection finding;
- hardened privileged Layer 2 mutation behind JWT-enforced server/Edge boundaries;
- preserved direct authenticated RPC revocation for privileged mutation;
- implemented deterministic exact/FTS/filter website Search/read contract without broad Publication;
- hardened exact Course lookup and Search query plans;
- installed pgvector but deliberately deferred vector/hybrid relevance because no governed embedding model/profile/corpus existed;
- retained zero broad Publication and separated Pilot showcase readiness from Production cutover authority;
- completed consolidated desktop/mobile UAT and maintained the M2.2 meeting/showcase record.

Representative accepted M2.2 runtime evidence included Providers ~1.24 s, Courses ~1.84 s, Evidence ~0.79 s, Data Quality ~0.39 s and exact website lookup ~17 ms in the measured database path.

## 5. M2.3 — production-grade Layers 1–4 and decision operations — CLOSED / PASS

Accomplished:

### Layer 1

- hardened production-style bounded regulatory ingestion/retry/resume;
- verified AU CRICOS and NZ authoritative Layer 1 operational recovery paths;
- retained deterministic offsets, source identity, Evidence and reconciliation;
- preserved Layer 1 as the canonical authority boundary.

### Layer 2

- exercised representative AU scale enrichment and provider routing;
- implemented Firecrawl commercial entitlement governance at 5,000 pages/month with a 250-page safety reserve and no silent paid fallback;
- added atomic monthly provider budget checks before provider attempts;
- retained provider/Evidence lineage and rollback-only UAT for budget threshold enforcement;
- explicitly deferred dedicated NZ first-party Layer 2 Course enrichment to later NZ source qualification/onboarding rather than representing it as complete.

### Layer 3

- implemented governed Evidence interpretation with JWT-protected Edge execution and Vault/server-only provider credentials;
- rejected the nondeterministic `openrouter/free` router configuration after it failed a governed real-provider semantic benchmark;
- pinned the accepted profile to `nvidia/nemotron-3-nano-omni-30b-a3b-reasoning:free`;
- passed the governed benchmark: 5/5 provider semantic cases and 13/13 controls, USD 0 observed cost, 2.811 s maximum benchmark provider latency, 315 input / 462 output tokens;
- verified unchanged-Evidence zero-call, changed/expired/revalidation eligibility, validation rejection and no silent fallback;
- resumed Layer 3 only after benchmark PASS;
- retired the temporary one-time benchmark trigger after evidence was retained.

### Layer 4

- implemented/accepted all six terminal actions: Approve, Edit & Approve, Reject, Request More Evidence, Return Layer 2, Return Layer 3;
- proved Search refresh signalling occurs only after an accepted canonical change;
- retained reason, Evidence, Layer 2/3 lineage and decision history;
- completed rollback-only acceptance without leaving synthetic canonical changes.

### Reusable operations and decision context

- implemented nine-stage Country/Provider/Course onboarding with immutable audit lineage, rank checks and `canonical_fork=false` validation;
- implemented Important Links and source-precision-aware Important Dates without manufacturing exact dates/times from vague sources;
- retained QILT and PRISMS at their correct contextual grains rather than converting them into Course facts;
- added Scholarship Selection with explicit **SOURCE FACT / DERIVED SCORE / MISSING-UNRESOLVED** presentation and `eligibility_inference_permitted=false`;
- hardened Data Quality summary refresh contention by moving the full snapshot refresh to off-peak daily plus explicit post-ingestion refresh, while retaining live drilldown;
- restored deployed browser-bridge migration source parity and closed new SECURITY DEFINER advisor warnings;
- completed final Go 5 build/browser/deployed UAT including mobile 29/29 PASS on accepted M2.3 SHA `260ed6a0d19b80ad666d74b90aa13e735e802a6a`.

## 6. M2.4 — active optimisation / Go 7 Admin IA

Accomplished so far:

- redesigned the Admin primary information architecture around the operator workflow rather than historic feature implementation;
- published PIM Admin `v2.15.6` with maintained release notes;
- streamlined menu order to Overview → Catalogue → Data Operations → Insights → Quality & Review → Decision Tools → Governance & Platform → Help & Guides;
- moved Layer 1 out of Settings/experimental presentation and exposed it as **Layer 1 — Regulatory**;
- consolidated Layer 2/3/4, Evidence, Jobs and Onboarding under **Data Operations**;
- moved Scholarship Selection to **Decision Tools**;
- moved Layer 3 provider credential control into **Governance & Platform** for Platform Admin rather than a floating canvas button;
- retained Users & Roles under Governance and removed duplicate/obsolete floating navigation launchers;
- made **Guides & Runbooks** visible from the main menu with role-oriented guidance and direct workflow entry points;
- removed Statistics Canada parser qualification and Pilot database reset from the normal Layer 1 operator journey without deleting their governed technical contracts;
- published Admin Navigation & Information Architecture v1.4, Data Operations Admin Guide v1.1 and Master Project Plan v1.73;
- established CF-CHG-20260826-040 and M2.4 repository run sheets;
- added a permanent navigation/content audit to capture every visible primary page/workspace, heading/content sample, navigation elapsed time and screenshot;
- aligned inherited UAT selectors to the new primary IA rather than restoring obsolete labels or weakening tests.

## 7. Current performance picture

Representative deployed Go 7 measurements:

| Area | Desktop | Mobile | Observation |
|---|---:|---:|---|
| Providers | 1.47 s | 1.27 s | healthy |
| Courses initial core read | 2.02 s | 2.16 s | largest core latency; still below 3 s budget |
| Campuses | 0.45 s | 0.40 s | healthy |
| Scholarships | 0.34 s | 0.28 s | healthy |
| Evidence | 0.46 s | 0.45 s | healthy |
| Data Quality overview | 0.39 s | 0.29 s | healthy |
| Exact CRICOS lookup | 0.65 s | 0.62 s | healthy |
| Course detail | 0.76 s | 0.72 s | healthy |
| Course filter payload | 257.7 KB | 257.7 KB | largest payload; optimisation target |

No accepted 3-second threshold has been relaxed.

## 8. Current risks / optimisation opportunities

- `courses_page` has the least latency headroom among core reads and should be profiled before catalogue scale increases further.
- `course_filters` at ~258 KB should be split/lazy-loaded/cached without removing accepted filter functionality.
- the Go 7 visible IA is coherent, but some workspaces still use hidden launcher-backed overlay components internally; M2.4 should migrate them progressively to first-class routes/components for cleaner deep links, history, performance measurement and UAT.
- Layer 3 model/provider availability is operational configuration, not architecture; future provider/model changes require governed revalidation/benchmark.
- NZ dedicated first-party Layer 2 Course enrichment remains explicitly deferred.
- Production establishment, broad Publication and Zoho cutover remain later governed gates.

## 9. Meeting demonstration sequence suggested

1. Dashboard / current programme health.
2. New PIM Admin v2.15.6 menu and Guides.
3. Layer 1 authoritative regulatory operation and source health.
4. Layer 2 enrichment plan/provider/Evidence and Firecrawl budget guard.
5. Layer 3 benchmark-passed model profile and unchanged-Evidence zero-call principle.
6. Layer 4 terminal review / six actions / Search-signal boundary.
7. Course detail with sourced current facts and explicit unresolved states.
8. Evidence / provenance drill-through.
9. Data Quality exception workflow.
10. QILT / PRISMS contextual intelligence and Scholarship Selection no-eligibility-inference boundary.
11. Automated UAT, performance metrics and desktop/mobile screenshots.
12. Remaining M2.4 optimisation items and later Production gate.

## 10. Current gate

M2.1, M2.2 and M2.3 are **CLOSED / PASS** for their accepted scope. M2.4 is **ACTIVE**.

Go 7 implementation has build and local browser-smoke PASS. The initial full deployed Go 7 run correctly exposed stale inherited UAT navigation selectors after the menu was intentionally renamed/restructured. The selectors have been updated to traverse the new primary menu while retaining underlying functional/security assertions, and the final selector-aligned deployed desktop/mobile acceptance is the immediate closure gate.

This record should be updated with that final run ID/SHA and audit evidence before the Milestone 2 meeting pack is treated as frozen.
