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

## M2.4.5 H2 reconciliation — 2026-09-03 10:43 AEST

Source/runtime inventory confirms Scraper Config is the current provider-control surface:
- reader paths: `layer2_acquisition_providers`, `layer2_profiles`, `layer2_provider_routes`;
- writer: `layer2-provider-control`;
- bounded acquisition runtime: `layer2-acquire`;
- global wave policy: `layer2-sync-control` → `layer2_execution_policy_service` / `layer2_wave_scope_service`;
- separate per-profile execution policy still exists through `layer2_ops_policy_update` and requires H2 reconciliation before any semantic consolidation.

Live provider state was read only. Parse.bot remains disabled. Firecrawl is enabled with recorded monthly entitlement 5,000 and reserve 250, rate 30/min, concurrency 5 and timeout 90 seconds.

Pilot commit `a033d3ef941eadb7fd992da15eb82c77956f9bec` clarifies the embedded surface as **Administration · Scraper Config** and its single provider-control-plane ownership. No route, database or provider state was mutated by this H2 step.

H2 remains ACTIVE because effective global `route_mode` vs per-profile routing semantics still require bounded reconciliation.
