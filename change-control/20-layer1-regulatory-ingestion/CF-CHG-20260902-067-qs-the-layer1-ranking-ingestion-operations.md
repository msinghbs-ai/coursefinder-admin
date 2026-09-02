# CF-CHG-20260902-067 — QS / THE Layer 1 Ranking Ingestion Operations

**Status:** IMPLEMENTED / TARGETED UAT ACTIVE  
**Initiated:** 2 September 2026 Australia/Melbourne  
**Primary category:** 20 — Layer 1 Regulatory / Authoritative Ingestion  
**Related:** CF-063, CF-064, CF-065, A29

## Request

Make QS World University Rankings 2026/2027 and Times Higher Education World University Rankings 2026 operationally available from Layer 1, while retaining manual authorised-file fallback when publisher pages/downloads require registration, login or paid access.

## Decision

QS/THE remain **Layer 1 publisher-authoritative institutional context**. They are not Provider regulatory identity authority and they do not become Course-level rankings.

The Layer 1 operating model is:

`Global ranking source → validate publisher artifact → dry-run parser → governed queue → ranking apply → Provider mapping/reconciliation → Evidence-backed observations`.

## Sources

Registered Layer 1 Global sources:

- QS World University Rankings 2026 — `https://www.topuniversities.com/world-university-rankings/2026`
- QS World University Rankings 2027 — `https://www.topuniversities.com/world-university-rankings/2027`
- Times Higher Education World University Rankings 2026 — `https://www.timeshighereducation.com/world-university-rankings/latest/world-ranking`

## Acquisition rule

For each edition:
1. Layer 1 source metadata identifies ranking system + edition.
2. If an authorised publisher CSV/XLSX artifact is already registered, the Layer 1 parser uses that immutable Evidence artifact.
3. If no usable publisher artifact exists, validation returns an explicit **publisher file required** condition.
4. Operator can use Layer 1 → ranking card → **Upload publisher file**.
5. Administration → Sources & Imports opens pre-filled for system + edition.
6. Revalidate and run from Layer 1.

No paywall, registration gate or bot control is bypassed.

## Parser semantics

`ranking-layer1-etl` v1 accepts governed CSV/XLSX publisher artifacts and preserves:
- exact ranks;
- ties;
- rank bands;
- open-ended bands;
- reporter/unranked/unknown states;
- overall score where published;
- source row payload and ordinal.

PDF/ZIP/JSON can remain Evidence but require a dedicated parser adapter before apply.

## Mapping

Deterministic accepted auto-mapping is limited to exact canonical/display Provider name + country match.

Unresolved institutions are retained as publisher institutions and observations with no Provider mapping. They are reported as mapping conflicts/review work; no CourseFinder Provider is manufactured.

## Runtime implementation

Pilot migrations:
- `20260902004533_cf_067_ranking_layer1_ingest_service_contract.sql`
- `20260902004608_cf_067_register_qs_the_layer1_sources.sql`
- `20260902004626_cf_067_layer1_global_source_projection.sql`
- `20260902004804_cf_067_layer1_ranking_source_metadata_projection.sql`

Edge:
- `ranking-layer1-etl` v1
- `layer1-operations-control` v4 / control version 1.2.0

UI:
- Layer 1 exposes Global ranking source cards.
- Ranking cards expose publisher/edition metadata.
- Ranking cards provide **Upload publisher file** shortcut.
- Admin import form accepts Layer 1 system/year prefill.
- Admin release advanced to v2.15.26.

## Security

- ranking tables remain private;
- RLS remains enabled;
- browser has no direct table grants;
- apply/latest-import service RPCs require service role/postgres;
- Layer 1 run permissions retain existing operator/platform-admin boundaries;
- ranking worker accepts only the Layer 1 service credential;
- manual file upload remains private Evidence.

## Acceptance

Required:
- Layer 1 read returns GLOBAL QS 2026, QS 2027 and THE 2026 cards;
- source system/edition metadata visible;
- build PASS;
- deployed browser UAT PASS;
- no direct browser ranking-table access;
- security advisor 0 WARN / 0 ERROR;
- performance advisor reviewed;
- first real publisher artifact dry-run proven before actual observation APPLY.

## Current boundary

The ingestion **mechanism** is live. No QS/THE ranking observation is claimed accepted until an authorised publisher CSV/XLSX artifact is uploaded and the edition passes dry-run/apply reconciliation.
