# CF-CHG-20260903-094 — Ranking Import Recent Refresh & Duplicate-Year Guard

**Status:** IMPLEMENTED / TARGETED UAT ACTIVE  
**Initiated:** 2026-09-03 14:55 AEST  
**Category:** 20-layer1-regulatory-ingestion  
**Parent:** CF-093 / H12-H13  
**Trigger:** User screenshot from Administration → Sources & Imports.

## Issue

After a ranking parse:
- Recent ranking imports could appear stale because ordering used original `uploaded_at`, not latest parse/apply activity;
- successful Parse import remained enabled and success text remained until manually changed;
- same system/year could be registered again without an explicit operator warning.

## Fix

- `ranking_imports` read now returns `updated_at` and orders by latest activity (`updated_at DESC, uploaded_at DESC`);
- UI refreshes import history after registration and again after validation;
- after a successful parse, the main import button is disabled for the current system/year and reads **Parsed successfully — change year**;
- changing ranking system or edition year clears the prior success outcome and re-enables the import action;
- an existing same-system/year import triggers an inline warning before another revision can be registered;
- operator must explicitly choose **Continue with new revision** before retrying;
- warning states that a new Evidence revision is registered and later Apply may replace the accepted edition;
- Recent import timestamps show latest **Updated** activity rather than upload time only.

No popup-driven operational workflow was introduced.

## Pilot evidence

- UI commit: `b816a99f9f13dc5f01f8dca357ce6a47fc5230ca`;
- migration parity: `bf9dd9eb7ad1c9d72b676c24555e19a1296e3f7a`;
- Pilot DB migration `cf_094_ranking_recent_activity_order`: applied;
- Admin release: v2.15.50;
- Deployed UAT run `33716795837`: queued/active at record time.

## Rollback

Revert the two Pilot commits and restore `ranking_imports` dispatch to `security.admin_ranking_read` if targeted validation exposes regression.
