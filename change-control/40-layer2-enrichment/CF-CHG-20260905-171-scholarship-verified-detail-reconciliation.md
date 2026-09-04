# CF-CHG-20260905-171 — Scholarship Verified Detail Reconciliation

**Milestone:** M2.4.5  
**Status:** IMPLEMENTED / RUNTIME PASS  
**Date:** 5 September 2026

## Purpose

Close the gap between first-party Scholarship detail acquisition and the canonical unpublished Scholarship catalogue without allowing catalogue pages, navigation fragments, duplicate URLs or low-confidence extraction noise to become canonical records.

## Accepted pipeline

`first-party catalogue → detail candidate → Evidence → normalised extraction → source record → reconciliation gate → existing canonical link OR new unpublished canonical root → Layer 4 / publication decision`

Acquisition itself remains non-canonical and publication-blocked. Canonical mutation occurs only at the explicit reconciliation step.

## Reconciliation gate

A source record is eligible only when all of the following are true:

- provider identity is resolved to a canonical Provider;
- Evidence is present;
- identifier scheme is `first_party_detail_url`;
- audience is explicitly international;
- confidence is at least 0.8;
- the URL is a normal HTTP(S) detail URL rather than a search/filter URL;
- the title is not catalogue/navigation language such as Eligibility, FAQ, Guidelines, Find a Scholarship, Skip to main content, general international Scholarship catalogues or blocked-page messages;
- duplicate source rows are reduced to the latest observation for a Provider + normalised detail URL.

Eligible rows are matched first by Provider + normalised first-party detail URL and then, only when unique, by exact normalised title. New roots use deterministic identity and are always created `unpublished`.

## Runtime implementation

Pilot migrations:

- `20260905000100_cf_171_verified_scholarship_detail_reconciliation.sql`
- `20260905000200_cf_172_fix_verified_scholarship_uuid_match.sql`
- `20260905000300_cf_173_scholarship_reconciliation_runtime_stats_uat.sql`
- `20260905000400_cf_174_reconciliation_browser_contract_marker.sql`
- `20260905000500_cf_175_scholarship_reconciliation_stats_view_marker.sql`

Runtime objects:

- `pipeline.scholarship_verified_detail_reconciliation_candidates`
- `scholarship.normalise_first_party_url(text)`
- `scholarship.normalise_title(text)`
- `scholarship.reconcile_verified_detail_records(uuid,text,text,uuid,integer)`
- enhanced `security.admin_scholarship_runtime_read(jsonb)`
- enhanced `security.admin_scholarship_runtime_uat(text)`
- `scholarship-runtime-control` Edge Function v2.

Direct browser execution of reconciliation is denied. Pipeline Operators can preview through the authenticated Edge Function; canonical reconciliation requires PIM Admin rank or above.

## First controlled AU reconciliation

The initial controlled AU reconciliation produced:

- 8 verified individual first-party details accepted;
- 8 new canonical roots created;
- 0 records published;
- 63 matching detail candidates downgraded to `needs_review` because their extracted source represented catalogue/filter/navigation material;
- 0 generic/navigation source records applied;
- 8 reconciliation traces retain both source-record and verification-Evidence links.

Canonical Scholarship count increased from 213 to 221. Publication remains 0.

## UI / operator workflow

Scholarship Operations now exposes:

- Country or University acquisition;
- Preview and Start governed fill;
- Preview verified details;
- PIM-Admin-only **Reconcile unpublished**;
- reconciliation-ready and reconciled-unpublished statistics;
- live UAT checks covering Evidence, browser denial, generic-fragment exclusion and unpublished-only canonical creation.

## Safety and efficiency

- No re-fetch is required for already captured Evidence.
- Duplicate first-party detail URLs reuse the latest captured source record.
- Generic catalogue/navigation pages are converted to review rather than repeatedly re-fired as details.
- Existing canonical records are linked, not blindly overwritten.
- Scholarship publication remains a separate human-governed decision.
- Percentage award text may be structurally parsed, but fee type/basis is not inferred; Course financial calculations remain fail-closed until a semantically compatible fee row exists.

## Acceptance

Runtime checks after the first AU application confirm:

- reconciliation service present;
- authenticated browser role cannot execute it directly;
- reconciled records remain unpublished;
- generic/navigation records have not been applied;
- reconciliation trace retains Evidence and source-record linkage;
- Scholarship acquisition jobs retain no publication authorisation;
- financial calculations remain fail-closed.

This change does not authorise mass publication or Search/Website/Zoho admission.