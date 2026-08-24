# CF-CHG-20260823-029 — M2.1 Layer 2 Enrichment Platform Foundation

**Status:** BLOCKED — ACQUIRE-V2 RETAINED-EVIDENCE / EXTRACTION + DEPLOYED BROWSER ACCEPTANCE OUTSTANDING  
**Category:** 40-layer2-enrichment  
**Initiated:** 23 August 2026 20:21 AEST (+10:00)  
**Updated:** 24 August 2026 10:38 AEST (+10:00)  
**Origin chat/workstream:** M2.1 — L2-PLATFORM  
**Owner:** M2.1 Layer 2 Platform workstream

## Product / authority boundary

CourseFinder is an international-student Course and related-data aggregation, discovery and comparison platform.

`Layer 1 Authoritative/Regulatory → Layer 2 Deterministic Acquisition & Extraction → Layer 3 AI-assisted Evidence Interpretation → Layer 4 Human Resolution`

Layer 4 is terminal. There is no Layer 5.

Layer 2 is limited to **Course enrichment** and **Scholarship enrichment**. QILT and PRISMS remain Layer 1 contextual datasets and must not be sent through paid Layer 2 acquisition providers.

## Layer 2 operational process

The governed operational process is now:

`Execution Policy → Run Batch → Run Item → Job → Provider Attempt → Native Evidence → Normalised Evidence → Deterministic extraction → L2 resolved OR L3 required`.

Layer 2 never sends directly to Layer 4. Only unresolved Layer 3 fall-out becomes Layer 4 Review.

### Execution policy

`pipeline.layer2_execution_policies` stores one management policy per Course/Scholarship enrichment source:

- Manual / Daily / Weekly / Disabled;
- batch size;
- cost-aware routing strategy;
- maximum paid attempts/item;
- optional vendor-unit/cost ceilings;
- automatic Layer 3 hand-off;
- identity-mismatch stop guard.

Initial safe default: **Manual / 10 items / Direct HTTP then best-value fallback / maximum 2 paid attempts**.

### Run tracking

- `pipeline.layer2_run_batches` — source-profile-version/policy snapshot + aggregate outcome/cost;
- `pipeline.layer2_run_items` — Course/Scholarship item + Job/provider/Evidence/resolution/fall-out.

These tables are RLS-enabled and service-only at table level.

## Acquisition Providers

Current tested methods:

| Provider | Credential | Current role |
|---|---|---|
| Direct HTTP | none | zero-external-fee first route where sufficient |
| Scrape.do | configured | rendered HTML fallback / benchmark |
| Firecrawl | configured | rich HTML/Markdown/screenshot escalation |
| ZenRows | configured | rendered/proxy fallback / benchmark |
| ScraperAPI | not configured | catalogue option only |
| Custom gateway | disabled | future governed adapter |

Provider credentials remain Vault-only/write-only. Browser surfaces show readiness, not secrets.

Provider choice is based on evidence-backed resolution/correctness/reliability/cost, not HTTP 200 or cheapest request.

## Provider benchmark evidence

Technical record: `docs/uat/coursefinder-m2-1-provider-benchmark-2026-08-24.md`.

First benchmark: five RMIT + five UQ current Course pages × Direct HTTP / Firecrawl / Scrape.do / ZenRows = **40 bounded attempts**.

| University | Direct HTTP | Firecrawl | Scrape.do | ZenRows |
|---|---:|---:|---:|---:|
| RMIT | 5/5 | 5/5 | 3/5 | 4/5 |
| UQ | 5/5 | 5/5 | 1/5 | 1/5 |

All successful responses contained the exact CRICOS identity plus fee, English and intake/start markers.

Scrape.do/ZenRows failures were predominantly 429s caused by the deliberately parallel diagnostic. Representative sequential retries returned 200, therefore accepted interpretation is **rate/concurrency orchestration issue**, not content failure.

Current provisional routing conclusion:

- Direct HTTP first for ordinary RMIT/UQ pages;
- Firecrawl is the strongest proved rich-Evidence escalation route;
- Scrape.do/ZenRows remain viable rate-aware fallbacks;
- no final paid-provider winner until deterministic extraction and actual account-plan economics are measured.

Scholarship acquisition against Study Australia returned usable content through all four methods. Retained-Evidence Scholarship extraction remains pending.

## Direct HTTP runtime / IP provenance

The CourseFinder Admin is served behind Cloudflare Worker `coursefinder-pilot.techm.workers.dev`, but the actual Direct HTTP source `fetch()` executes in the Supabase Edge Function runtime.

Therefore source websites see **Supabase Edge outbound egress**, not the Cloudflare Worker IP.

Supabase hosted Edge Functions do not provide a guaranteed static outbound IP. Historical pre-v2 attempts did not record the observed public egress IP, therefore CourseFinder cannot reconstruct the exact historical public egress address.

## Acquisition runtime v2

`layer2-acquire-v2` is deployed ACTIVE with `verify_jwt=true`; existing `layer2-acquire` remains rollback until v2 browser/live Evidence UAT passes.

v2 records on every Provider Attempt:

- `runtime_platform = supabase_edge`;
- `runtime_region = SB_REGION`;
- `runtime_execution_id = SB_EXECUTION_ID`;
- `runtime_deployment_id = DENO_DEPLOYMENT_ID`;
- `egress_identity = supabase_edge_dynamic_non_static`.

This provides auditable runtime provenance without falsely claiming a fixed outbound IP.

## Evidence per fetch / versioning

Every successful v2 fetch creates a new Evidence Artifact row even when bytes are unchanged. Verification time is evidence.

New fields:

- `evidence_group_key`;
- `capture_version` with unique group/version guard;
- `supersedes_evidence_id`;
- `valid_from` / previous `valid_to`;
- SHA-256 content hash;
- `content_changed` metadata;
- Source Profile Version;
- Provider Attempt / runtime version / deployment lineage;
- retention/review metadata.

A re-fetch of identical content therefore produces another capture version rather than erasing the observation event.

## Evidence Storage / retention

Evidence remains in the existing **private Supabase Storage bucket `evidence`**.

Acquisition-v2 storage hierarchy:

`layer2/v2/{country}/{domain}/{profile}/{YYYY}/{MM}/{DD}/{job}/{attempt}/v{capture_version}-{kind}.{ext}`

The physical hierarchy exists for operational lifecycle management. Admin review uses relational lineage rather than bucket browsing.

v2 assigns:

- `retention_class = standard_365`;
- `retain_until = captured_at + 365 days`;
- `review_state = unreviewed`.

365 days is a minimum retention horizon, **not an automatic destructive-delete date**. Evidence referenced by accepted observations/candidates, review or a hold must not be silently purged. A destructive retention sweeper is not authorised in M2.1 without a separate reference/hold security UAT gate.

Detailed contract: `docs/coursefinder-layer2-operations-evidence-lifecycle-v1.0.md`.

## Provider logging / telemetry

Provider Attempt telemetry is separate from source Evidence content.

It may store bounded non-secret information such as status, latency, bytes, MIME, trace/request ID, rate-limit headers, credit/request-cost headers, retries, fallback reason, vendor units/cost and produced Evidence IDs.

It must never store provider API keys, auth headers or browser-visible service-role credentials.

## Simplified Admin UX

Layer 2 Platform visible version is now **v1.4**.

Primary menu is intentionally reduced to:

`Data Enrichment → Layer 2 Operations / Evidence`.

Former Pipeline Control, Source Registry, Source Config, Acquisition Providers, Acquisition Trials and Jobs remain drill-down capabilities from Layer 2 Operations instead of six separate menu destinations.

Layer 2 Operations first screen contains only:

- enrichment sources + schedule/batch/routing;
- provider readiness;
- Evidence count/review count;
- recent run outcome + L3 fall-out + cost.

Advanced configuration and diagnostics use progressive drill-down.

QILT/PRISMS remain under Insights. Completeness and terminal Layer 4 Review remain under Quality & Review.

Navigation contract: `docs/coursefinder-admin-navigation-information-architecture-v1.3.md`.

## Security / ACL UAT

PASS for the new backend foundation:

- new policy/run tables use RLS;
- `anon` and `authenticated` direct SELECT is false;
- service role has trusted table access;
- Admin reads remain rank >=4;
- execution-policy mutation requires PIM Admin rank >=5;
- acquisition-v2 is JWT protected;
- source-bound URL/profile gates retained;
- non-Course/non-Scholarship profiles cannot execute through acquisition-v2;
- provider credentials remain Vault-only.

Supabase Advisor still reports the established `RLS enabled/no policy` informational pattern on private schemas. This is intentional where direct browser table access is revoked; existing M1 security architecture is not being weakened.

## Implementation references — 24 Aug operational lifecycle increment

Live:

- `m2_1_layer2_operations_evidence_lifecycle`;
- `m2_1_layer2_evidence_capture_version_guard`;
- Edge `layer2-acquire-v2` v1 ACTIVE.

Pilot:

- `supabase/migrations/20260824104000_m2_1_layer2_operations_evidence_lifecycle.sql`;
- `supabase/migrations/20260824104100_m2_1_layer2_evidence_capture_version_guard.sql`;
- `supabase/functions/layer2-acquire-v2/index.ts`;
- `src/layer2-operations-entry.jsx`;
- `src/layer2-operations.css`;
- `src/data-acquisition-nav-entry.js` v1.4;
- `index.html` Layer 2 Platform v1.4;
- `tests/uat/admin-navigation-deployed.spec.mjs` simplified-navigation acceptance.

Governance/UAT:

- `docs/coursefinder-layer2-operations-evidence-lifecycle-v1.0.md`;
- `docs/coursefinder-admin-navigation-information-architecture-v1.3.md`;
- `docs/uat/coursefinder-m2-1-layer2-operations-lifecycle-2026-08-24.md`.

## Current gate

M2.1 remains **BLOCKED**, not PASS.

Remaining acceptance evidence:

1. deployed desktop/mobile browser UAT for Layer 2 Platform v1.4;
2. authenticated live `layer2-acquire-v2` Direct HTTP run proving v2 private Evidence + runtime provenance;
3. one configured paid-provider v2 attempt proving retained provider-native Evidence/telemetry;
4. normalisation + deterministic Course extraction from v2 Evidence;
5. retained-Evidence Scholarship extraction;
6. measured L2 resolved vs L3-required fall-out;
7. activation of a production scheduler/runner only after batch-selection semantics are accepted. Execution schedule policies are now governed/stored, but automatic catalogue-wide processing is not yet authorised.

## Decision history

| Time | Decision |
|---|---|
| 23 Aug 20:21 | M2.1 initiated against frozen M1 baseline. |
| 23 Aug ~21:00 | Multi-provider/Vault/routing/Evidence made core. |
| 23 Aug ~22:15 | Country completeness, Scholarships, contextual QILT/PRISMS and terminal Layer 4 added. |
| 24 Aug ~10:10 | QILT/PRISMS removed from Layer 2 acquisition; Course/Scholarship only. |
| 24 Aug ~10:18–10:25 | First 40-attempt Course + Scholarship provider benchmark completed. |
| 24 Aug ~10:38 | Layer 2 execution policy/run lifecycle, Evidence retention/versioning, acquisition-v2 provenance and simplified management UI implemented. |

## Closure

**Final status:** BLOCKED — ACQUIRE-V2 retained-Evidence/extraction and deployed browser acceptance outstanding.  
**Closed at:** N/A
