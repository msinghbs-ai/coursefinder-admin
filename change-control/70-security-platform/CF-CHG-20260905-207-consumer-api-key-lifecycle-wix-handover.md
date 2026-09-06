# CF-CHG-20260905-207 — Consumer API Key Lifecycle & Wix Integration Handover

**Status:** OPEN / M2.4.5 H14 — WIX AUTH HOTFIX APPLIED 2026-09-06  
**Initiated:** 2026-09-05 15:48 AEST  
**Origin:** CourseFinder Wix developer API/handover workstream  
**Primary category:** 70-security-platform  
**Affected surfaces:** 30-admin-pim-ux, 50-search-api-consumers, 80-uat-release-operations  
**Milestone:** M2.4.5

## Requested outcome

1. Maintain a versioned, complete Wix developer handover containing API reference, testing, cache-first architecture and Production-cutover guidance.
2. Future Wix handover revisions must be independent full documents with a change summary at the top, not patch-only addenda.
3. Add an Admin feature for external-consumer API key lifecycle management, including expiry, rotation/revocation, copy and secure-send workflow.

## Governance decision

External-consumer integration credentials are a separate control plane from scraper/vendor credentials.

- Wix/Website, Zoho and future external consumers receive dedicated environment-specific credentials.
- Supabase `service_role`, Vault secrets and scraper/vendor credentials must never be exposed through this workspace.
- The persistent store retains only a one-way credential hash plus lifecycle metadata.
- The raw secret is available only transiently at creation/rotation time.
- If the raw secret is lost, rotate it; do not add a reveal-existing-secret capability.
- Pilot and Production credentials are always distinct.

## Admin workspace requirement — H14

Add **Administration → API Keys** (Platform Admin/rank-6 boundary unless the accepted role model explicitly delegates a narrower operator role).

### List/grid fields

- Integration / consumer name
- Environment
- Credential identity
- Purpose/API contract
- Status: Active / Expiring / Expired / Revoked / Disabled
- Created at
- Rotated at
- Expires at
- Days remaining
- Last used / last success where telemetry exists
- Created/rotated by
- Notes / owner

### Actions

- Create credential
- Rotate credential
- Set/change expiry date
- Disable / enable
- Revoke
- Copy newly generated key
- Secure-send newly generated key
- Copy credential identity / endpoint
- View lifecycle/audit history

### Secret-display rule

The raw secret may be shown once immediately after successful creation or rotation and held only in transient browser state. Closing/reloading the result must make it unavailable. Normal list/detail reads return masked metadata only.

### Copy action

Copy is enabled only while the transient newly generated secret is available. Copying an existing stored credential is not possible because the raw secret is not stored.

### Send action

`Send` means hand off the transient newly generated secret through an approved secure delivery adapter/workflow. It must not silently email a raw secret in ordinary plaintext email. The audit log records recipient/channel metadata but never the raw secret.

Until an approved secure-send connector is implemented, the UI may provide **Prepare secure handover** / **Copy secure handover package** rather than unsafe email transmission.

### Expiry behaviour

- Expiry is optional but should be strongly recommended for external integrations.
- UI warnings at configurable windows, default 30/14/7 days.
- Expired credentials fail authentication.
- Rotation may permit a bounded overlap window only when explicitly selected and audited.
- Revocation is immediate.

### Audit events

At minimum:

- credential_created
- credential_rotated
- expiry_changed
- credential_disabled
- credential_enabled
- credential_revoked
- secret_copied
- secure_handover_prepared/sent

Never log the raw secret, bearer header or full credential hash.

## Wix handover versioning rule

Current router: `docs/integrations/README.md`.

Current full Wix handover: `docs/integrations/coursefinder-wix-api-handover-v1.1.md`.

Each successor must:

1. have a new immutable filename/version;
2. place a concise `Changes since previous version` section at the top;
3. repeat the complete developer handover;
4. avoid requiring developers to reconcile multiple documents;
5. use minor versions for additive/non-breaking changes and major versions for breaking contract/architecture changes.

## API/cache architecture retained

Wix remains cache-first:

`CourseFinder canonical projection -> Wix sync API -> scheduled Wix backend job -> Wix CMS cache -> visitor search/filter/detail`

Normal visitor queries should not generate CourseFinder API calls. Course deltas use stable IDs and `changed_since`; failed refreshes retain last-known-good cache and do not advance the cursor.

## 2026-09-06 Wix authentication incident and hotfix

Developer testing reported `401 AUTHENTICATION_REQUIRED` using both `Authorization: Bearer` and `x-cf-token`, while an invalid action reportedly returned `INVALID_ACTION`.

Investigation established:

- the registered Wix Pilot credential is enabled and the current key hash is accepted by `website_edge_auth_v1`;
- `wix-course-api` v1 used a hard-coded token hash, which was incompatible with the intended Admin-managed credential lifecycle;
- v1 token extraction prioritised JSON-body `integration_token` over both supported headers, so any stale body value could override a valid `Authorization` or `x-cf-token` header;
- in v1 and v2, `INVALID_ACTION` is evaluated only after successful authentication, therefore any request receiving `INVALID_ACTION` has already passed authentication for that request shape.

Hotfix applied to Supabase Pilot Edge Function `wix-course-api` version 2 on 6 September 2026:

1. authentication now validates the presented key through `website_edge_auth_v1` / the credential registry rather than a hard-coded hash;
2. header precedence is now `Authorization: Bearer` first, then `x-cf-token`, with JSON-body `integration_token` retained only as a compatibility fallback;
3. supported actions and external request contract remain unchanged;
4. `verify_jwt=false` remains intentional because the function performs dedicated server-side integration-token authentication.

Post-deploy verification:

- Edge Function status: ACTIVE, version 2;
- current Wix Pilot credential: enabled;
- current Wix Pilot credential hash: accepted by `website_edge_auth_v1`;
- full external HTTP smoke test still requires a caller capable of making the POST request from outside the current execution environment.

Developer retest should use one authentication method only and omit `integration_token` from the JSON body:

- preferred: `Authorization: Bearer <key>`;
- alternative: `x-cf-token: <key>`.

## Security acceptance

Before closure prove:

1. API key workspace is rank-gated and browser reads never receive existing raw secrets.
2. Create returns a new raw key once only.
3. Stored credential is hash-only plus metadata.
4. Copy works only during the transient creation/rotation result.
5. Refresh/reopen cannot reveal a raw key.
6. Expired, revoked and disabled credentials fail authentication.
7. Rotation works with no unintended long-lived overlap.
8. Audit history contains lifecycle actions without secret material.
9. Wix key remains distinct from Zoho, scraper/vendor and Supabase privileged credentials.
10. Production migration inventory includes credential metadata/functions/Edge bindings but not reusable Pilot raw secrets.
11. Wix Edge authentication reads the managed credential registry and requires no Edge redeploy for routine key rotation.

## Documentation evidence

- `docs/integrations/coursefinder-wix-api-handover-v1.0.md` — historical baseline.
- `docs/integrations/coursefinder-wix-api-handover-v1.1.md` — current complete handover.
- `docs/integrations/README.md` — current-version router and versioning rule.

## Implementation state

Governance and handover documentation are applied. Wix authentication hotfix v2 is applied to Pilot and now uses the managed credential registry. The broader Admin/API-key lifecycle runtime implementation remains an M2.4.5 H14 delivery item and must receive migration/Edge/UI/build/deployed-UAT evidence before this record can close.

## Rollback

Documentation can be superseded by a later complete handover version. Runtime implementation must support disabling the API Key workspace/Edge writer while leaving existing consumer authentication credentials unchanged. Never roll back by exposing raw stored secrets.
