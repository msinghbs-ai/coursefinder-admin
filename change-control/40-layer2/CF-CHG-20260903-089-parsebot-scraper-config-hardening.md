# CF-CHG-20260903-089 — Parse.bot qualification and Scraper Config UX/performance hardening

**Status:** IMPLEMENTED / TARGETED VERIFICATION ACTIVE  
**Initiated:** 2026-09-03 11:36 AEST  
**Owner:** Layer 2 / Admin-PIM UX  
**Parent:** CF-CHG-20260903-087 / M2.4.5 H2  
**Related:** CF-085, CF-084, CF-088  
**Pilot release:** v2.15.46

## Trigger

User enabled Parse.bot and requested a runtime recheck against the official Parse API quickstart, plus review of:
- the non-standard dark Scraper Config header and icon-only Refresh control;
- inherited bold typography across provider cards;
- slow Scraper Config load;
- unclear Layer 2 execution-policy purpose/input layout;
- unclear purpose of Layer 2 sources.

## Parse.bot finding

Official Parse API documentation confirms:
- API base: `https://api.parse.bot`;
- REST auth: `X-API-Key`;
- API creation: `POST /dispatch`;
- build/task polling: `GET /dispatch/tasks/{task_id}`;
- generated execution: `POST /scraper/{scraper_id}/{endpoint_name}`.

CourseFinder runtime before CF-089 treated every non-direct acquisition provider as a generic URL proxy. The Parse.bot registry entry had `configuration_required=true`, but no generated `scraper_id` / `endpoint_name`. Therefore enabling Parse.bot did **not** make it execution-ready.

Existing cost governance happened to skip Parse.bot while cost remained unknown, but that was not a sufficient adapter contract.

## Decision

1. Keep the user-enabled registry state visible.
2. Align Parse.bot provider metadata with the official API contract.
3. Add a server-side connection probe that validates the configured Vault credential against `GET /dispatch/tasks` without exposing the key.
4. Explicitly block Parse.bot from generic URL-proxy acquisition and scheduled discovery until a generated Parse API route is qualified for a specific extraction profile.
5. Do not manufacture a generic Parse.bot execution route.
6. Record connection state separately from execution qualification.

## Scraper Config performance

Before:
- opening Scraper Config called `adminRead('layer2_acquisition_providers')` and `adminRead('layer2_profiles')` in parallel;
- `layer2_profiles` builds the complete Course/Scholarship profile inventory, including job/evidence/version counts;
- current profile-route population is in the thousands;
- then a third read loaded routes for the selected profile.

After:
- initial load calls only the small acquisition-provider registry;
- profile routing is progressive disclosure;
- opening Profile routing invokes a bounded server-side profile-options service;
- search returns at most 10 matching profiles;
- route rows load only after a profile is selected.

## UI standardisation

- embedded Scraper Config no longer uses its full-screen dark sub-application header;
- canonical Administration header/card styling and labelled Refresh action are used;
- inherited `font-weight:700` from provider-card buttons is neutralised; only headings/important labels remain bold;
- `Run bounded acquisition` is relabelled `Test selected route` inside advanced Profile routing;
- Layer 2 Sources is relabelled **Extraction Profiles** without changing its section key/deep link;
- purpose: versioned non-secret source-specific extraction rules and qualification state, not vendor credential/routing control;
- Layer 2 execution policy is renamed **Layer 2 workload defaults**, moved behind progressive disclosure and limited to scheduler batches, qualification cadence, wave size and continuation;
- the legacy global route mode is read-only in this workspace; routing is not written from a second control plane.

## Runtime / migration

Pilot migrations:
- `20260903005500_cf_089_scraper_config_profile_options.sql`;
- `20260903005800_cf_089_parsebot_provider_contract.sql`.

Edge/runtime:
- `layer2-provider-control` v2 — bounded profile options + Parse.bot connection probe;
- `layer2-acquire-v2` v11 — explicit Parse.bot generated-route qualification guard;
- `layer2-scope-discover-scheduled` v21 — same scheduled guard.

No Production resource was created.

## Implementation commits

- `154863879e8a816248235ba58a136083c3956c00` — bounded profile option migration;
- `960820b5f1764aa109f7cfc3d3933b28753ac510` — provider-control probe/options;
- `243c8a9cbc460feede499e2622ee57b49f44c3b5` — progressive Scraper Config + Parse.bot UX;
- `52c4ddb6659e2f69a7410549be25ea55b929245f` — canonical typography/layout;
- `3c04330dc1e224db74c7d42b304ee751bdb5b30f` — generic acquisition guard;
- `534b27b3a9d0de77b67650a967efe1589e009712` — scheduled acquisition guard;
- `6dd61f0b813ef1bdd4ed15348ca8d371f6763c90` — Parse.bot official provider contract;
- `e6008a13cd15e00580a538b26d7d8f3e822191c7` — workload-default/routing-writer simplification;
- `aba61e1efa71e038cb02a945181a1ef63c765aa7` — Admin progressive-disclosure theme;
- `1c38b4298c7812eaa0dfcb353b9e5e479bedc7dc`, `3b542b4445a76fa68d350717b2b7f530764fa79e` — v2.15.46;
- `b2b9570b5c9784072344eb5006a4e645e9e8c761` — targeted UAT;
- `c6f3dd45b7668887978c75e0ac4a2467f91c15d9` — targeted workflow routing.

## Validation

Targeted source/build/browser UAT is active on Pilot head `c6f3dd45b7668887978c75e0ac4a2467f91c15d9`.

The deployed test performs a real Parse.bot connection probe using the stored Vault credential but does not create a generated Parse API or spend a profile execution route. A successful connection is necessary but not sufficient for execution qualification.

Do not claim Parse.bot execution-ready until a bounded generated-API qualification proves scraper creation/selection, task completion, endpoint execution, Evidence capture and cost/credit telemetry.

## Targeted UAT correction — 2026-09-03 11:39 AEST

Initial deployed run `33704442944` failed before exercising the CF-089 Parse.bot browser contract because the workflow selected the earlier CF-088 Administration regression. That frozen regression still pinned release v2.15.45 while the deployed Worker was correctly v2.15.46.

This was a test-maintenance failure, not an application rollback or Parse.bot failure.

Corrections:
- `304597a70b6d6c43a327cb4168fc362aa097d21b` makes CF-088 release assertions durable across later compatible releases;
- `726b3f962eda9aa03380a7f9a7e76dbed39a6fe7` ensures CF-089 workflow edits route to the CF-089 targeted suite;
- `80b9548eb23edefcdbbd9cc8fa943f42c73d1165` additionally standardises workload-default form controls after the screenshot exposed browser-default label/input rendering.

Final targeted build `33704684206` is PASS. Final deployed CF-089 UAT `33704684224` remains the acceptance result to record.

## Parse.bot live credential result — 2026-09-03 11:48 AEST

The corrected diagnostic probe reached the official Parse API endpoint using the Vault-stored credential and received **HTTP 401 / authentication_failed**.

Therefore:
- DNS/network/base URL connectivity is proven;
- the configured `X-API-Key` value is not currently accepted by Parse.bot;
- Parse.bot must remain **not execution-qualified** despite the registry Enabled flag;
- no generated API dispatch or endpoint execution is authorised until the Platform Admin rotates/re-enters a valid Parse API key and the connection probe passes.

The secret value was not exposed or logged.
