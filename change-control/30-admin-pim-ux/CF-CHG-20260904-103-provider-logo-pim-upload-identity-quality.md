# CF-CHG-20260904-103 — Provider Logo PIM Upload & Identity Quality

**Status:** IMPLEMENTED / TARGETED UAT ACTIVE  
**Date:** 4 September 2026 (Australia/Sydney)  
**Category:** 30-admin-pim-ux  
**Parent:** CF-091 / CF-101 / CF-102 / M2.4.5 H11  
**Pilot release baseline:** v2.15.57

## Objective

Close Provider-screen presentation and operator-maintenance gaps after H11 logo population:

- Provider/university name must render bold using the normal light-theme text colour rather than inheriting white/dark-header styling;
- Provider catalogue rows must display the current approved managed logo, with a compact initials fallback where no approved logo exists;
- clicking the logo in **Provider detail only** allows a PIM Operator or Platform Admin to browse for and upload/replace a managed primary logo;
- Provider list/logo display remains read-only;
- add repeatable quality checks for Provider identity/location field contamination.

## Governance correction

The initial technical implementation temporarily used CF-093 naming before repository reconciliation showed that CF-093 is already the ranking URL/file parser authority. That collision was corrected immediately. This change is governed only by **CF-CHG-20260904-103**; ranking CF-093 remains unchanged.

## Runtime implementation

Pilot changes:

- `provider-asset-access` v2 supports bounded batch signed access by Provider stable key for Provider catalogue rows while retaining existing Provider-ID access;
- new `provider-asset-upload` v1 is JWT protected and requires role rank >=5 (`PIM Operator` / `Platform Admin`);
- accepted upload formats: SVG, PNG, JPEG, WebP; maximum 5 MB;
- uploaded files are hashed with SHA-256 and stored under the private `provider-assets` bucket;
- the previous primary approved logo is superseded, not deleted;
- manual upload metadata retains actor, time, managed-storage state and CF-103 reference;
- failed database apply removes only the newly uploaded object;
- logo upload is not exposed on Course, Compare, Provider list or other screens.

## Provider UI

`src/ProviderLogo.jsx` now:

- forces Provider brand/name text to CourseFinder light-theme `#0f172a` and strong weight;
- renders current approved managed logos in the Provider catalogue list using one bounded batch access request;
- uses initials fallback for Providers without an approved logo;
- makes the Provider-detail logo keyboard/click editable only for rank-5+ operators;
- presents a visible upload status message and refreshes cached/signed logo access after a successful replacement.

## Identity/location quality

Added `public.provider_identity_quality_summary()` with aggregate checks for:

- missing canonical Provider name;
- missing display name;
- institution-like values incorrectly stored as `primary_city`;
- display/canonical names matching governed state/region names;
- display-name divergence from canonical name.

A confirmed bad value was corrected:

- `provider:cricos:00026a` — The University of Sydney: `primary_city` changed from `The University of Sydney` to `Sydney`.

Live post-correction summary:

- Providers: 3,085;
- missing canonical name: 0;
- missing display name: 0;
- institution-like city: 0;
- display matches subdivision: 0;
- canonical matches subdivision: 0;
- display differs from canonical: 0.

## UAT

Permanent targeted suite:

`tests/uat/cf-103-provider-logo-and-identity-quality-deployed.spec.mjs`

It verifies:

1. Provider-only logo replacement and rank-5 mutation gate;
2. Provider list logo rendering for a known approved-logo Provider;
3. Provider detail name is bold and theme-black;
4. upload affordance is present only for PIM Operator / Platform Admin;
5. The University of Sydney renders Provider name correctly while City renders `Sydney`;
6. source retains the identity-quality summary contract.

## Security / consumer boundary

- Storage remains private;
- signed URLs remain short-lived;
- browser never receives service-role credentials;
- upload requires authenticated rank-5+ operator;
- no Provider identity creation/merge is performed;
- no Search, Website, Zoho or publication authority is added;
- logo replacement does not alter canonical Provider name or regulatory identity.

## Source/runtime evidence

Key Pilot commits include:

- `4f65fcadcd02df4ddbea26be6c1b651144c3453e` — Provider asset batch access;
- `1c6a6fdbf5fcffea34369d813e1468b6ed5be2da` — manual Provider logo upload Edge source;
- `87d6cf9e54ca7f4011c356939fbb4a139e9a67b9` — Provider list/detail logo UX;
- `2b115ab3ba6e64d360cb294cb89d226d758a9eb2` — initial runtime migration source;
- `de32d86fdc4190596ea5075b2139ee32665fc69a` — CF-103 authority reconciliation migration;
- `2df5179434ebd89b8ab35ed6db07540716eaf0fb` — permanent CF-103 targeted UAT.

Pilot Edge versions after deployment:

- `provider-asset-access` v2;
- `provider-asset-upload` v1.

## Next

After targeted UAT closes, return to the remaining M2.4.5 sequence rather than reopening H11 architecture:

1. finish any remaining Provider data-quality exceptions found by the new quality gate;
2. continue H12 ARWU / Diversity statistics acceptance if still open;
3. close H13 ranking acquisition/file/API residuals and Parse.bot credential-dependent live qualification where required;
4. reconcile H3-H6 parked Admin/PIM hardening work;
5. prepare M2.4.5 closure and then resume M2.5 P0 Production readiness.
