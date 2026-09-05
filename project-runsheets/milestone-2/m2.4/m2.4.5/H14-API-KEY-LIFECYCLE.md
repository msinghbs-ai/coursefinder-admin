# M2.4.5 H14 — Consumer API Key Lifecycle & Integration Handover

**Status:** OPEN / ACTIVE BACKLOG  
**Added:** 5 September 2026 15:48 AEST  
**Change Control:** `CF-CHG-20260905-207`  
**Primary owner:** Security / Platform with Admin/PIM UX and Search/API consumer dependencies

## Outcome

Provide one governed Admin workspace for lifecycle management of CourseFinder-issued external-consumer API credentials and maintain complete versioned developer handovers for those consumers.

This workstream is separate from Layer 2 Scraper Config. Scraper/vendor credentials remain server/Vault-side and are not managed as distributable consumer API keys.

## Admin navigation

Add:

`Administration -> API Keys`

Default access boundary: Platform Admin / rank 6.

No API-key secret is exposed through normal browser list/detail reads.

## Required lifecycle fields

- consumer / integration
- environment
- credential identity
- API purpose / contract version
- enabled/revoked state
- lifecycle status
- created_at
- rotated_at
- expires_at
- days remaining
- last_used_at / last successful authentication where telemetry exists
- owner / notes
- creator / rotator audit identity

## Required actions

- create
- rotate
- set/change expiry
- enable/disable
- revoke
- copy new key once
- prepare/send secure handover for new key
- copy endpoint/credential identity
- inspect lifecycle/audit history

## Secret handling

The persistent database stores a one-way hash and lifecycle metadata only. The raw generated key may be returned exactly once by a privileged create/rotate action and held in transient UI state.

After the user closes/reloads the result, the key cannot be revealed again. Lost keys are rotated.

`Copy` and `Send` are therefore creation/rotation-result actions, not normal credential-list actions.

## Secure send

Do not implement ordinary plaintext-email delivery of raw secrets.

Preferred order:

1. approved secure secret-delivery connector/workflow;
2. secure handover package with recipient/channel audit metadata;
3. manual copy to an organisation-approved secure channel.

The audit record must never include the raw secret.

## Expiry and rotation

- expiry optional but recommended for all external integrations;
- warning states at 30/14/7 days by default;
- expired credentials authenticate as invalid;
- revoked credentials fail immediately;
- rotation normally revokes/replaces the previous credential;
- any temporary overlap must be explicit, bounded and audited;
- Pilot and Production use separate credentials.

## First consumers

- Wix / Website Pilot
- Zoho Pilot
- future external consumer integrations admitted through governed API contracts

Do not include scraper providers, Supabase service-role, database passwords or internal platform secrets.

## Wix handover delivery

Current complete handover:

`docs/integrations/coursefinder-wix-api-handover-v1.1.md`

Current router/version policy:

`docs/integrations/README.md`

Every successor Wix handover must be a complete standalone document with a change summary at the top.

## Runtime implementation tasks

1. Define private credential metadata + audit model without raw-secret persistence.
2. Implement privileged create/rotate/expiry/enable/disable/revoke operations.
3. Apply expiry/revocation checks to website/Wix authentication and later migrate Zoho to the shared lifecycle pattern where accepted.
4. Add governed Admin read projection returning masked metadata only.
5. Add Administration -> API Keys responsive workspace.
6. Add one-time new-secret result card with Copy and Secure Handover actions.
7. Add expiry warnings/status filters.
8. Add audit-history drawer.
9. Add environment/Production-migration inventory handling.
10. Run targeted security, browser and API authentication UAT.

## Acceptance

H14 is not complete until all are proven:

- rank boundary enforced;
- no existing raw secret can be read from browser/API/DB projection;
- create and rotate return new raw secret once only;
- only hash + metadata persist;
- expiry enforced by authentication path;
- disable/revoke enforced;
- copy/send actions never persist/log the secret;
- audit events are complete and secret-free;
- Wix credential remains dedicated and server-side in Wix;
- Production credential process creates a new key rather than cloning Pilot secret material;
- build + targeted deployed browser/API UAT pass;
- CF-207 updated with actual migration, Edge, UI version and deployment evidence.

## Sequencing

H14 is part of M2.4.5 pre-production hardening. It may proceed in parallel with remaining H3-H13 work, but must be complete before external-consumer Production credential handover is considered production-ready.
