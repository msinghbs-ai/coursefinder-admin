# CF-CHG-20260902-068 — QS Direct XHR / JSON Layer 1 Acquisition Qualification

**Status:** IMPLEMENTED / TARGETED PASS  
**Initiated:** 2 September 2026 Australia/Melbourne  
**Category:** 20 — Layer 1 Regulatory / Authoritative Ingestion  
**Related:** CF-063, CF-064, CF-067, A29

## Purpose

Replace brittle rendered-HTML scraping for QS rankings with the publisher JSON/XHR data path where that path is directly available, while preserving manual authorised-file fallback and never bypassing anti-bot/access controls.

## Live qualification findings

### QS 2026

Edition NID: `4061771`.

Direct publisher static XHR asset:

`https://www.topuniversities.com/sites/default/files/qs-rankings-data/en/4061771_indicators.txt`

Pilot network probe:
- HTTP **200**;
- content type `text/plain` containing JSON;
- `data` array contains **1,501 rows**;
- publisher payload includes institution NID, region, country/location, city, rank display/rank, institution HTML/profile link and overall score;
- no browser DOM rendering is required.

### QS 2027

Edition NID: `4153156`.

Equivalent static asset:
- HTTP **404**.

Current publisher REST ranking endpoint:
`https://www.topuniversities.com/rankings/endpoint?nid=4153156&page=0&items_per_page=500&tab=indicators`

Pilot Supabase egress probe:
- HTTP **403**;
- Cloudflare managed challenge;
- no attempt is made to solve, bypass or automate the challenge.

Therefore 2027 remains a qualified source definition with manual authorised-file fallback until an approved direct publisher access route exists.

## Implementation

`ranking-layer1-etl` v1.1.0:
- primary QS 2026 acquisition from publisher static XHR JSON;
- QS 2027 attempts current REST only as a qualification probe;
- direct JSON snapshot SHA-256;
- raw JSON retained in private `evidence` Storage;
- Evidence registered as `ranking_publisher_json`;
- source lineage includes ranking system, edition, NID, endpoint kind, byte size, row count and worker version;
- parses institution NID/name/profile, country, region/city context, rank display, exact/tied/banded states, overall score and any `ind_*` numeric fields;
- manual CSV/XLSX publisher artifact remains fallback.

`layer1-operations-control` v1.2.1:
- passes Layer 1 source ID to the ranking ETL so publisher JSON Evidence is attached to the governed source.

Source metadata:
- QS 2026 acquisition mode: `publisher_static_xhr_json_with_manual_fallback`;
- QS 2027 acquisition mode: `publisher_rest_json_qualification_with_manual_fallback`;
- QS 2027 endpoint state: `cloudflare_challenge_from_pilot`.

Admin UI:
- ranking dataset class is normalised into the existing Layer 1 **Statistics** filter;
- release advanced to v2.15.27.

## Safety boundary

Direct QS JSON **APPLY is disabled** in v1.1.0. A direct source dry-run may retain Evidence and report candidate observations, but cannot write accepted ranking observations.

An APPLY attempt on the direct JSON route returns a governed rejection requiring dry-run/access acceptance first.

Manual authorised CSV/XLSX APPLY remains under the existing CF-067 path.

## Acceptance

Permanent deployed contract:
`tests/uat/cf-068-qs-xhr-layer1-deployed.spec.mjs`

Required:
- Global → Statistics displays QS 2026/2027;
- QS 2026 validation returns 1,501 candidate observations;
- 64-character source hash returned;
- Evidence artifact registered;
- Layer 1 card updates expected count to 1,501;
- QS 2027 challenge is surfaced explicitly;
- no ranking observation APPLY from direct JSON;
- no anti-bot bypass;
- Security advisor 0 WARN / 0 ERROR.

## Targeted proof

Deployed targeted gate `33579305870` / job `100090017855` — **PASS** on `Coursefinder-Pilot@df33b6f732e2c4a0ce185f1a4e9545582be07582`.

Runtime proof:
- QS 2026 Layer 1 validation PASS;
- expected observations **1,501**;
- source SHA-256 `7805ac74c54de80ef134abadf7e521de23fa6d64636c6676b0e29b89b3d2724c`;
- one retained `ranking_publisher_json` Evidence artifact;
- QS 2027 publisher challenge surfaced as governed HTTP 409 rather than server 500;
- direct ranking observation APPLY count remains **0**.

Security advisor after CF-068: **156 INFO / 0 WARN / 0 ERROR**. Performance advisor remains INFO-only.
