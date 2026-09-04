# CF-CHG-20260904-145 — Second International Scholarship Wave Canonical Reconciliation

**Status:** IMPLEMENTED / TARGETED PASS  
**Milestone:** M2.4.5

## Change

Reconciled the three CF-144 first-party detail captures into Evidence-backed canonical **unpublished** Scholarship roots.

## Identity correction

ECU's detail extractor returned the generic page heading `Scholarships`. This was not accepted as canonical identity. The already-retained first-party candidate identity `2027 ASEAN International Scholarship` was used because the candidate URL/detail Evidence pair was exact and Provider-scoped.

Monash returned clean detail-page names and those were retained:

- Vice-Chancellor International School Leaver Award;
- Vice Chancellor's ASEAN Award.

## Structured award semantics

- ECU 2027 ASEAN International Scholarship — `20% tuition` → percentage `20`, fee basis `tuition_fee`;
- Monash Vice Chancellor's ASEAN Award — `20% tuition` → percentage `20`, fee basis `tuition_fee`;
- Monash Vice-Chancellor International School Leaver Award — `$15,000` → fixed amount `AUD 15,000`.

These values are available to the governed Course-side Scholarship calculation model. Percentage savings remain fail-closed until Course fee basis/year and Scholarship duration/scope align.

## Result

Canonical Scholarship inventory reached **210**, all currently unpublished in this controlled fill. Each new row is linked to:

`first-party detail URL → Evidence → source record → acquisition trace → canonical unpublished Scholarship`.

No broad Publication, Search, Website or Zoho admission occurred.

## Source reconciliation

Pilot source migration:

- `supabase/migrations/20260904063500_cf_144_145_second_international_scholarship_wave.sql`
