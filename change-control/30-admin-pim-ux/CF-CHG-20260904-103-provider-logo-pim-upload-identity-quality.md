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
- the same Provider-only editor accepts a public HTTPS image URL, downloads it server-side and stores the image in managed private Provider Assets rather than retaining an external hot-link;
- Provider list/logo display remains read-only;
- add repeatable quality checks for Provider identity/location field contamination.

## Governance correction

The initial technical implementation temporarily used CF-093 naming before repository reconciliation showed that CF-093 is already the ranking URL/file parser authority. That collision was corrected immediately. This change is governed only by **CF-CHG-20260904-103**; ranking CF-093 remains unchanged.

## Runtime implementation

Pilot changes:

- `provider-asset-access` v2 supports bounded batch signed access by Provider stable key for Provider catalogue rows while retaining existing Provider-ID access;
- `provider-asset-upload` v3 is JWT protected and requires role rank >=5 (`PIM Operator` / `Platform Admin`);
- accepted upload/import formats: SVG, PNG, JPEG, WebP; maximum 5 MB;
- Provider detail editor offers **Browse image** or **Image URL**;
- URL import accepts HTTPS only, rejects localhost/private-network target forms, validates every explicit redirect hop, rejects non-image MIME and retains a 5 MB bound;
- URL content is downloaded server-side, hashed with SHA-256 and copied into the private `provider-assets` bucket;
- original URL is retained as source provenance while managed Storage remains the display asset; no external hot-link becomes canonical state;
- uploaded/imported files are hashed with SHA-256 and stored under the private `provider-assets` bucket;
- the previous primary approved logo is superseded, not deleted;
- manual upload/import metadata retains actor, time, managed-storage state and CF-103 reference;
- failed database apply removes only the newly uploaded object;
- logo mutation is not exposed on Course, Compare, Provider list or other screens.

## Provider UI

`src/ProviderLogo.jsx` now:

- forces Provider brand/name text to CourseFinder light-theme `#0f172a` using `!important` and strong weight so dark-header inheritance cannot turn Provider names white;
- renders current approved managed logos in the Provider catalogue list using one bounded batch access request;
- uses initials fallback for Providers without an approved logo so every visible Provider row has a logo/fallback mark;
- makes the Provider-detail logo keyboard/click editable only for rank-5+ operators;
- opens a Provider-only editor with Browse image / Image URL options;
- presents a visible upload/import status message and refreshes cached/signed logo access after a successful replacement.

## Identity/location quality

`public.provider_identity_quality_summary()` now checks:

- missing canonical Provider name;
- missing display name;
- generic placeholder names such as `Location`, `Campus`, `City`, `State`, `Region` or `Country`;
- institution-like values incorrectly stored as `primary_city`;
- display/canonical Provider name matching `primary_city`;
- display/canonical Provider name matching governed state/region names;
- display/canonical Provider name matching country name/code;
- display-name divergence from canonical name.

A previously confirmed bad value remains corrected:

- `provider:cricos:00026a` — The University of Sydney: `primary_city` changed from `The University of Sydney` to `Sydney`.

Live post-correction quality check on 4 September 2026:

- Providers: 3,085;
- missing canonical name: 0;
- missing display name: 0;
- generic name placeholder: 0;
- institution-like city: 0;
- display matches city: 0;
- canonical matches city: 0;
- display matches subdivision: 0;
- display matches country: 0.

This means the currently stored canonical Provider data does not contain the reported generic `Location` placeholder. The permanent browser UAT therefore also checks rendered Provider rows so future UI field-mapping regressions are caught even when database values remain correct.

## UAT

Permanent targeted suite:

`tests/uat/cf-103-provider-logo-and-identity-quality-deployed.spec.mjs`

It verifies:

1. Provider-only logo replacement and rank-5 mutation gate;
2. Provider list rows show a managed logo or initials fallback;
3. Provider names render bold and theme-black (`rgb(15, 23, 42)`);
4. rendered Provider names are not generic location placeholders and do not equal the row City/State field;
5. Provider-detail editor exposes Browse image + Image URL only for PIM Operator / Platform Admin;
6. Course screen does not expose Provider logo mutation;
7. The University of Sydney renders Provider name correctly while City renders `Sydney`;
8. source retains the expanded identity/location quality-summary contract and URL-import safety contract.

## Security / consumer boundary

- Storage remains private;
- signed URLs remain short-lived;
- browser never receives service-role credentials;
- upload/import requires authenticated rank-5+ operator;
- remote imports reject non-HTTPS and obvious local/private-network URL targets and validate redirect hops;
- no Provider identity creation/merge is performed;
- no Search, Website, Zoho or publication authority is added;
- logo replacement does not alter canonical Provider name or regulatory identity.

## Source/runtime evidence

Existing baseline commits include:

- `4f65fcadcd02df4ddbea26be6c1b651144c3453e` — Provider asset batch access;
- `1c6a6fdbf5fcffea34369d813e1468b6ed5be2da` — manual Provider logo upload Edge source;
- `87d6cf9e54ca7f4011c356939fbb4a139e9a67b9` — Provider list/detail logo UX;
- `2b115ab3ba6e64d360cb294cb89d226d758a9eb2` — initial runtime migration source;
- `de32d86fdc4190596ea5075b2139ee32665fc69a` — CF-103 authority reconciliation migration;
- `2df5179434ebd89b8ab35ed6db07540716eaf0fb` — original permanent CF-103 targeted UAT.

4 September corrective commits:

- `c8677d2bc158075181ad127b3acb805857fc86f1` — stronger Provider name/list theme + Browse/URL editor;
- `824fb9ecdcf9490d0dd9df84c02c36e30de59792` / `1044d2bb42b2958341fd8285b8ac8a5ca9fb4b29` — Provider URL import worker and runtime-import alignment;
- `85fed55194d81cc7bd9ff177860b294556527838` — URL source provenance / managed-asset RPC migration;
- `aa67178c711190ae642a9baca180d5cfe99ebd4a` — expanded Provider identity/location quality gate;
- `b18349eec590e4099812dcce295fcac9a36c6ab5` — expanded permanent CF-103 browser/source UAT;
- `e8e07248750b3ce7e217b654d283493df4a1e83e` — duplicate temporary UAT removed.

Pilot runtime after deployment:

- `provider-asset-access` v2;
- `provider-asset-upload` v3;
- `cf_103_provider_logo_url_import` applied;
- `cf_103_provider_identity_location_quality_v2` applied.

## Next

After targeted UAT closes, return to the remaining M2.4.5 sequence rather than reopening H11 architecture:

1. verify the Provider-list logo/fallback and Provider-only Browse/URL replacement path visually in Pilot;
2. investigate any specific Provider still rendering a location-like label by captured Provider stable key/screenshot — the current database-wide quality gate is clean, so a recurrence would most likely be a UI/read projection regression;
3. continue H12 ARWU / Diversity statistics acceptance if still open;
4. close H13 ranking acquisition/file/API residuals and Parse.bot credential-dependent live qualification where required;
5. reconcile H3-H6 parked Admin/PIM hardening work;
6. prepare M2.4.5 closure and then resume M2.5 P0 Production readiness.
