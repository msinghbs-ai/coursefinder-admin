# CF-CHG-20260903-085 — Streamline Firecrawl quota into Scraper Config

**Status:** IMPLEMENTED / TARGETED VERIFICATION ACTIVE
**Date:** 3 September 2026
**Area:** Layer 2 acquisition administration

## Problem
Layer 2 execution policy displayed the effective Firecrawl monthly entitlement and reserve but did not allow editing. The only editable form introduced by CF-084 was separated under Environment & Migration, while the established acquisition-provider drawer still exposed Firecrawl billing as raw JSON.

## Decision
Administration → Acquisition is renamed **Scraper Config**.

Scraper Config becomes the single vendor-configuration authority for:
- provider endpoint;
- credential;
- vendor rate limit;
- vendor concurrency;
- timeout;
- Firecrawl monthly entitlement;
- Firecrawl safety reserve;
- advanced request/billing metadata.

Layer 2 execution policy remains an effective read-only budget/wave summary. It consumes Firecrawl provider configuration.

Environment & Migration no longer owns a duplicate Firecrawl quota editor.

## Firecrawl UX
When Firecrawl is selected, Platform Admin receives first-class fields:
- Monthly Firecrawl limit
- Safety reserve

The underlying canonical fields remain:
- `billing_config.monthly_vendor_units_limit`
- `billing_config.stop_at_vendor_units_remaining`

`safety_reserve_percent` is recalculated from those values.

Advanced billing JSON remains available behind progressive disclosure.

## Validation
Save performs server update followed by read-back verification of:
- concurrency;
- timeout;
- rate limit;
- monthly vendor-unit limit;
- safety reserve.

Invalid reserve >= monthly limit is rejected.

## Non-impact
No Layer 2 runtime route logic, Evidence lifecycle, Layer 1 authority, Layer 3, Search, Publication, Website or Zoho contract is changed.
