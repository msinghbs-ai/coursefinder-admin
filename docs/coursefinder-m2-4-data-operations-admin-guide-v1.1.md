# CourseFinder Data Operations Admin Guide v1.1

**Applies to:** Pilot/UAT PIM Admin v2.15.6 and later until superseded  
**Supersedes operational navigation guidance in:** `docs/coursefinder-m2-3-data-operations-admin-guide-v1.0.md`  
**Change Control:** CF-CHG-20260826-040  
**Authority chain:** Layer 1 authoritative/regulatory → Layer 2 deterministic acquisition/extraction → Layer 3 AI-assisted Evidence interpretation → Layer 4 terminal human resolution → downstream Search/Publication

## 1. Primary Admin navigation

The sidebar is organised around operator work rather than implementation history:

- **Overview** — Dashboard;
- **Catalogue** — Providers, Courses, Campuses, Scholarships;
- **Data Operations** — Layer 1 Regulatory, Layer 2 Enrichment, Layer 3 AI Interpretation, Layer 4 Human Resolution, Evidence & Provenance, Jobs & Runs, Onboarding;
- **Insights** — Outcomes (QILT), Student Flow (PRISMS);
- **Quality & Review** — Completeness;
- **Decision Tools** — Scholarship Selection;
- **Governance & Platform** — Sources, Attributes, Users & Roles where role permits;
- **Help & Guides** — Guides & Runbooks.

Items remain role-filtered. Not seeing a privileged menu item is expected when the signed-in role does not meet its existing minimum rank.

## 2. Layer 1 — Regulatory

Layer 1 is a first-class Data Operations capability. It is no longer presented as a generic Settings/experimental feature.

The routine Layer 1 journey is:

1. select the governed country/source;
2. inspect source health and latest successful run;
3. validate a bounded batch without catalogue writes;
4. apply an explicitly confirmed bounded batch where authorised;
5. continue from the exact returned offset;
6. verify reconciliation, Evidence and idempotency/replay behaviour.

Layer 1 owns authoritative/regulatory identity. Never use Layer 2, Layer 3 or an Admin convenience workflow to redefine Layer 1 identity.

Qualification/UAT utilities are not part of routine Layer 1 navigation. In particular, the Statistics Canada PSIS Layer 2A parser qualification and destructive Pilot database reset are intentionally excluded from the normal Layer 1 workspace. Their underlying technical controls are not converted into normal production operations by this UI change.

## 3. Layer 2 — Enrichment

Layer 2 is deterministic first-party Course/Scholarship acquisition and extraction. The primary **Layer 2 — Enrichment** entry opens the consolidated operations workspace; source profile/provider/trial detail remains progressive drill-down rather than separate top-level menus.

Preserve Evidence/version lineage, identity guards and provider economics. Direct HTTP remains preferred when it satisfies the Evidence contract. Firecrawl remains bounded to the confirmed 5,000-page monthly entitlement with a 250-page safety reserve and no silent paid fallback.

## 4. Layer 3 — AI Interpretation

Layer 3 interprets governed Evidence only. It cannot write canonical Course values directly.

The accepted profile `openrouter-free-router-v1` is benchmark-approved on `nvidia/nemotron-3-nano-omni-30b-a3b-reasoning:free`. Credentials remain server-side/Vault-backed. Any material provider/model/prompt/validator/trust change requires governed revalidation/benchmark before relying on the changed configuration.

Unchanged fresh Evidence must remain a zero-call path. Changed Evidence, expiry or explicit governed revalidation may establish eligibility subject to rate/day/token/retry/timeout/cost controls.

## 5. Layer 4 — Human Resolution

Layer 4 is the terminal human authority. The primary menu no longer presents a competing generic Review Queue entry.

Supported actions remain Approve, Edit and Approve, Reject, Request More Evidence, Return to Layer 2 and Return to Layer 3. All consequential actions require explicit reasons and retained lineage. Search refresh signals occur only after accepted canonical change.

## 6. Evidence & Provenance / Jobs & Runs

Evidence and Jobs are cross-layer operating surfaces and therefore sit with Layers 1–4 in Data Operations. Use Evidence to establish source/version/lineage before consequential decisions. Use Jobs & Runs to diagnose execution/recovery rather than treating HTTP success as factual success.

## 7. Onboarding

The shared lifecycle remains:

`Draft → Source Qualification → Adapter Assessment → Schema Assessment → L1 UAT → L2 UAT → L3 Ready → Operational Certification → Production Promotion Ready`.

Onboarding reuses the shared canonical Provider/Course/Campus/Scholarship architecture. Source differences belong in source-native staging, adapters/configuration or justified extension facts—not country-specific canonical forks.

## 8. Insights and Decision Tools

QILT and PRISMS remain **Insights** because they are contextual observations at their source grain, not Course-grain canonical facts.

Scholarship Selection sits under **Decision Tools**. It separates SOURCE FACT, DERIVED SCORE and MISSING / UNRESOLVED. Structural relevance never proves student eligibility.

## 9. Governance & Platform

Sources, Attributes and Users & Roles remain governance functions and retain existing rank boundaries. Generic Settings is not a supported primary operator destination after v2.15.6.

Platform Admin credential handling remains write-only from the browser where applicable. Secrets must never be echoed into the UI, logs, guides or Change Control.

## 10. Help & Guides

**Guides & Runbooks** is now visible inside the Admin. It provides workflow launch cards and role quick guides for Platform Admin, Pipeline Operator, Curator/Reviewer and read-only users.

The in-product guide is a quick operating aid. Repository governance remains authoritative for detailed Change Controls, architecture, UAT evidence and release state. Click the top-right PIM Admin version to view maintained browser release notes.

## 11. Security and semantic boundary

The v2.15.6 navigation change does not change:

- canonical identity or field meaning;
- source authority or precedence;
- role/rank thresholds;
- database/RPC/Edge grants;
- Evidence contracts;
- Layer authority;
- Search/Publication authority.

A menu move must never be interpreted as a privilege change.

## 12. Escalation

If an operator cannot find a privileged surface, verify the assigned CourseFinder role before treating the UI as defective. If a layer/provider/source contract changes materially, open or update Change Control and run the applicable automated acceptance rather than bypassing the governed workflow.