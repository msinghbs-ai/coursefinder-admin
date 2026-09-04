# CF-CHG-20260904-150 — Provider Logo Hydration Performance Correction

**Status:** IMPLEMENTED / TARGETED UAT PENDING  
**Initiated:** 4 September 2026 18:35 AEST  
**Milestone:** M2.4.5 pre-production hardening  
**Primary category:** 30-admin-pim-ux  
**Related:** Provider Assets, CF-149 comparison meeting hardening

## Defect

Provider logos use the same governed managed Provider Asset source across Provider list, Provider detail and comparison surfaces, but the list historically applied logos in a post-render DOM decoration pass. The decorator observed the entire document subtree and reset a 90 ms timer on each mutation. React-heavy page updates could therefore repeatedly postpone logo hydration and add avoidable DOM scans.

The reusable `ProviderLogo` component also maintained a UUID cache separate from the Provider-list stable-key cache and did not de-duplicate concurrent requests for the same Provider ID.

## Correction

Pilot effective release **v2.15.60**:

- retains the existing bounded bulk `provider-asset-access` lookup for Provider-list rows;
- replaces the reset-on-every-mutation 90 ms timer with one animation-frame scheduler;
- narrows mutation reactions to relevant Provider table/drawer additions under the application root;
- scans only Provider first cells that have not already been decorated;
- changes list logo images to lazy loading, asynchronous decoding and low fetch priority;
- adds an in-flight Promise map so concurrent Provider detail/comparison logo requests for the same Provider ID share one lookup;
- retains the session list-logo cache;
- preserves Provider logo upload/import and refresh behaviour for authorised PIM/Admin operators.

## Architecture note

This is a bounded M2.4.5 performance correction. The Provider list still has a legacy DOM-decoration compatibility path because the generic catalogue `DataTable` does not yet render Provider-specific cells natively. A later structural cleanup may move Provider-logo rendering directly into the React row renderer and consolidate UUID/stable-key cache identity. That larger refactor is not required for this urgent hydration defect.

## Authority boundary

No Provider identity, Course identity, QILT, PRISMS, Scholarship, Search, Publication, Website, Zoho or Layer authority semantics change.

## Acceptance

Targeted proof must confirm:

1. no 90 ms Provider-logo hydration debounce remains;
2. no unconditional full-document MutationObserver drives Provider logo decoration;
3. concurrent same-Provider logo reads are de-duplicated;
4. Provider list continues to use one bulk stable-key lookup per visible miss batch;
5. list images are lazy/asynchronously decoded;
6. Provider-logo upload/import remains present for authorised administrators;
7. source/build succeeds and no deployed regression is introduced.

Permanent source contract: `tests/uat/cf-150-provider-logo-hydration-contract.spec.mjs`.

## Rollback

Frontend-only. Revert the CF-150 `ProviderLogo.jsx` scheduling/cache changes and v2.15.60 release metadata. No database rollback is required.
