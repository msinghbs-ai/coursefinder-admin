# CF-CHG-20260904-146 — Release Currentness v2.15.58

**Status:** IMPLEMENTED / DEPLOYED UAT ACTIVE  
**Milestone:** M2.4.5

## Issue

Visible runtime changes introduced under CF-142–145 were already active while the Admin shell still reported v2.15.57. CourseFinder governance requires the visible release badge/title and release notes to reflect material operator-facing behaviour.

## Change

Publish **v2.15.58** as the current operator-visible release for:

- Evidence acquisition provenance: live acquisition versus artifacts derived from retained private Evidence;
- fixed Layer 1 → Layer 2 → Layer 3 → Layer 4 execution ordering in Data Operations and Administration;
- bounded first-party Scholarship detail acquisition and Evidence-backed canonical-unpublished reconciliation;
- second bounded international Scholarship wave including ECU/Monash structured award semantics.

The release-currentness entry is loaded after the established release-note module and reconciles the visible version pill, brand text, document title and current release-note entry without altering Layer authority or publication behaviour.

## Boundary

No canonical identity, Search, Website, Zoho or Production cutover authority is changed by this release-currentness patch.

## Source

- `src/release-currentness-entry.js`
- `index.html`

## Acceptance

Pilot Frontend Build and deployed browser UAT are required to close this change. The prior CF-142/143 source at `59fd6e5a0b4626abfc178e6b38832fd704ab4508` already passed both build and deployed UAT before this version-currentness correction.
