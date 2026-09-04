# CF-CHG-20260904-142 — Evidence Acquisition Provenance

**Status:** IMPLEMENTED / TARGETED PASS  
**Milestone:** M2.4.5

## Change
Evidence detail now distinguishes whether an artifact originated from a live acquisition provider or was derived from Evidence already retained in private Storage.

The governed Evidence detail contract exposes:
- acquisition mode;
- acquisition provider key/name and adapter type;
- original/source Evidence ID;
- original private Storage path;
- shared-fetch ID where applicable;
- reuse count and last reuse timestamp;
- acquisition runtime/adapter version where recorded.

## Semantics
- `live_acquisition` means the original Evidence was acquired from the source through Direct HTTP or the named scraper/provider.
- `stored_evidence_derived` means the displayed artifact was produced from an already retained Evidence artifact rather than another source fetch.
- shared Evidence reuse remains visible without rewriting the original capture timestamp or source lineage.
- derived/extracted artifacts retain their `source_evidence_id`; the original acquisition provider remains discoverable from that Evidence.

## Security
No raw `pipeline.evidence_artifacts`, `pipeline.layer2_shared_fetches` or acquisition-provider grants are added to browser roles. The browser continues through the existing role-checked Evidence detail read contract. The helper is not executable by `anon` or `authenticated` directly.

## UI
The Evidence drawer receives an **Acquisition provenance** card showing:
- Live acquisition vs Derived from stored Evidence;
- Direct/Firecrawl/other acquisition provider;
- Evidence origin ID;
- Storage reuse count;
- runtime/Storage lineage.

This is provenance information only and does not change canonical facts, publication or Search admission.
