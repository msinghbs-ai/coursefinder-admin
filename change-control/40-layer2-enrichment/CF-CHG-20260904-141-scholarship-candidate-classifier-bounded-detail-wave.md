# CF-CHG-20260904-141 — Scholarship Candidate Classifier & Bounded Detail Wave

**Status:** IMPLEMENTED / RUNTIME PASS  
**Milestone:** M2.4.5

## Objective

Continue AU Scholarship data fill without wasting acquisition capacity on catalogue navigation, filter URLs, support pages, non-AU Providers or ambiguous links.

## Changes

### RMIT / Federation reconciliation
Existing first-party Evidence captured under shared Provider/Course acquisition sources was preserved rather than rewritten. Federation Merit, Federation Global Merit, RMIT Academic Merit South East Asia and RMIT Future Leaders are now linked to canonical **unpublished** Scholarship identities through the end-to-end trace.

### Candidate pre-acquisition classifier
`pipeline.layer2_scholarship_discovery_candidates` now retains:

- `classification`;
- `classification_reason`;
- `classified_at`;
- `detail_target_url`.

Supported classifications are:

- `detail_ready`;
- `detail_redirect`;
- `catalogue_or_filter`;
- `support_or_navigation`;
- `external_or_out_of_scope`;
- `needs_review`.

Only deterministic noise/current-scope exclusions are auto-rejected. Ambiguous rows remain `needs_review`.

### Precision correction
The initial classifier pass was intentionally tested before broad firing and exposed two defects:

1. Monash Funnelback discovery links encode the first-party target as `&amp;url=` rather than ordinary `&url=`;
2. a generic title regex could incorrectly classify valid Scholarship names ending in “Scholarship”.

Both were corrected before bulk execution. Monash redirect candidates now resolve to first-party `monash.edu` Scholarship detail URLs before acquisition.

### AU-only gate
Current M2.4.5 fill excludes non-AU Providers from automatic Scholarship detail acquisition. Other countries remain a later explicit qualification/onboarding exercise.

### Bounded international detail wave
A controlled 12-record international-first wave was run against qualified Monash detail targets. All **12/12** completed at Layer 2 with first-party Evidence and source records.

Recovered examples include:

- Engineering International High Achievers Scholarship;
- Faculty of IT International Merit Scholarship;
- Monash International Tuition Scholarship (MITS);
- K.C. Kuok Scholarship;
- Monash Mauritius Award;
- Monash Philippines Award;
- Monash Thailand Award;
- Nicholas Auden International Study Scholarship;
- Pharmacy and Pharmaceutical Science International Merit Scholarship;
- Sir John Monash Scholarships for Excellence;
- Vice-Chancellor ASEAN Award for Onshore School Leavers;
- Vice-Chancellor ASEAN Pathway Award.

Representative structured values include 20% and 40% tuition awards and fixed values of AUD 10,000, AUD 40,000, AUD 100,000 and AUD 360,000. Award semantics remain source-driven; no percentage is applied to a Course fee until fee basis/year alignment passes the existing calculation guard.

## Provider statistics
The existing `pipeline.scholarship_provider_stats` summary now also tracks:

- candidate total;
- detail-ready total;
- candidate needs-review total;
- candidate rejected total;
- candidate acquired total;
- last candidate-classification timestamp.

The guarded `scholarship_operations_read()` response now includes these aggregate progress fields for Admin/PIM use. Raw pipeline tables remain unavailable to browser roles.

## Publication boundary

- new/reconciled Scholarship roots remain `unpublished`;
- no Search, Website or Zoho admission occurs;
- no Course eligibility is inferred from Provider ownership alone;
- Layer 4 remains the required path for ambiguous Course/scope interpretation;
- the Scholarship financial calculation remains fail-closed where fee basis/year is unresolved.

## Source/runtime reconciliation

Pilot source migrations:

- `20260904054500_cf_132_134_rmit_federation_trace_reconciliation.sql`;
- `20260904054600_cf_133_137_scholarship_candidate_classifier.sql`;
- `20260904055000_cf_138_140_bounded_international_wave_and_stats.sql`.

This work remains within active M2.4.5. M2.5 and Production remain paused/not provisioned respectively.
