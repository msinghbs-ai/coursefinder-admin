# CF-CHG-20260905-202 — Qualified Institutional Sibling-Host Scholarship Gate

**Status:** IMPLEMENTED / RUNTIME PASS  
**Milestone:** M2.4.5  
**Layer:** Layer 2 — Scholarship source qualification

## Problem

UNSW's international Scholarship catalogue is hosted on `www.unsw.edu.au`, while individual Scholarship detail pages are hosted on the official sibling host `www.scholarships.unsw.edu.au`. The CF-186 host test accepted only equal/direct subdomain relationships, so legitimate institutional sibling hosts could be classified as external.

## Correction

Added an explicit source-level `first_party_hosts` allowlist. The Scholarship detail classifier now accepts:

- the catalogue host;
- its direct subdomain relationship; or
- an explicitly qualified host in the first-party source metadata.

No broad registrable-domain/eTLD matching was introduced. UNSW is explicitly qualified for `unsw.edu.au` and `scholarships.unsw.edu.au`.

## Runtime proof

A bounded UNSW International Student Award candidate passed preview as one `detail_ready` record. The detail acquisition subsequently succeeded through direct HTTP and produced first-party normalised Evidence `fb130186-fd3e-4d74-b15b-af25bf3e3c68`. Reconciliation created one new canonical unpublished root.

## Boundary

The allowlist is a first-party source qualification control, not a generic same-brand assumption. Semantic, international, navigation/filter and publication gates remain unchanged. Broad Publication remains prohibited.
