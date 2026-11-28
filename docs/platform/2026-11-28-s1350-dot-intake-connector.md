# DOT intake connector (s1350): design, one-time connection steps and verification

**WITHDRAWN 28 Nov 2026 13:40 AEDT: not shipped.** Platform Admin direction PC-20261128-DOT-DROPBOX-POC replaced the connector with a one-package drop-off capability on the existing `dot-intake` endpoint (s1351, `docs/platform/2026-11-28-s1351-dot-dropbox-capability.md`). Pilot #1757 is held unmerged with no labels; its paste file is withdrawn. The steps below are not to be followed.

**Approval:** Platform Admin 28 Nov 2026 13:05 AEDT: "implement a private StudySearch DOT Intake API connector using the existing deployed dot-intake Edge Function ... secure agent authentication, evidence upload, package finalisation and status retrieval ... credentials securely outside the agent conversation and public GitHub repositories ... restricted permissions, expiry, revocation and audit". Shapes it follows: SS-Programme-Control PC-20261128-DOT-AUTH-REVIEW (a private scoped tool with backend credential handling and short-lived authenticated access, reusing the existing endpoint and gate).
**Pilot change:** migration `20261201080000_cf247_s1350_dot_intake_connector.sql`, edge function `dot-intake-connector` (`verify_jwt` off: it signs callers in with its own key), spec `tests/uat/cf-247-s1350-dot-intake-connector-contract.spec.mjs`. **Paste file:** `docs/paste/PASTE-20261128-s1350-dot-connector-key.sql`.
Nothing about the drop-off, the `dot-intake` gate, structured intake or admission is redesigned.

No secret, password, token or key value appears in this document. The only credential is the connector key, shown once on Settings › API usage and kept only in DOT's connector settings.

## 1. How it works

```
DOT agent ──(connector key)──▶ dot-intake-connector ──(short-lived session for the DOT user)──▶ dot-intake ──▶ data-intake bucket + svc_data_intake_v1 ──▶ structured intake
```

| Step | What happens |
|---|---|
| 1. Sign in | DOT sends its connector key (`Authorization: Bearer <key>` or `x-api-key`). The connector hashes it and signs it in as API version **dot v1** (`pipeline.api_key_auth_v1`); a wrong or switched-off key gets 401. Every call, refused or not, is logged in `pipeline.api_requests` with platform dot, version v1 and the key's name (never the key). |
| 2. The DOT user | `public.svc_data_intake_identity_v1('dot')`: the one active `dot_submitter` whose expiry is set and within `data_intake.role_max_days` (14). None: `HELD:NO_DOT_IDENTITY`; more than one: `HELD:AMBIGUOUS_DOT_IDENTITY`; a disabled user: `HELD:DOT_IDENTITY_DISABLED`. |
| 3. A short-lived session | The connector makes a session for that user on the server (a one-time sign-in link it redeems itself; no email is sent, no password exists or is stored), uses it for this one call and signs it out. The session is never returned to DOT. |
| 4. The existing endpoint | The connector calls the deployed `dot-intake` exactly as a signed-in DOT would; `dot-intake` applies its own gate (switch, role with bounded expiry), checks hash, type and size, stores once without overwrite, and submits through the existing structured intake. Its answer is returned as is. |

### Tools (MCP: `initialize`, `tools/list`, `tools/call`, `ping`; also plain JSON `{"tool": "...", "arguments": {...}}`)

| Tool | Arguments | Result |
|---|---|---|
| `upload_original` | `country`, `provider_id`, `package`, `mime_type` (PDF, HTML, JSON, JSONL, text), `content_base64` (the exact bytes), `sha256`, optional `source_url` | Recorded (or `replay: true`); 422 on a hash mismatch; 409 once the package is finalised |
| `finalise_package` | `country`, `provider_id`, `package`, and `manifest` (object) or `manifest_json` (exact text, for a byte-for-byte replay) | The intake receipt with received, duplicate and refused counts; `HELD:MANIFEST_INCOMPLETE` (nothing stored) until every listed original is uploaded; the same manifest again returns the same receipt; a different manifest is refused |
| `package_status` | `country`, `provider_id`, `package` | none, uploading, received or refused; files, attempts and the receipt |

A receipt is not acceptance: proof on the platform's stored copies, the course binding, Layer 4 and the admission rules decide afterwards.

### Rehearsal (rolled back, 28 Nov 2026 13:15 AEDT)

| Check | Result |
|---|---|
| Migration and paste file together | key `dot_intake_connector_v1` (dot, v1, enabled, not issued); 1 dot version; API usage coverage: nothing missing; all 8 key rows still pass the widened check |
| Identity lookup | no assignment: `HELD:NO_DOT_IDENTITY`; no expiry: held; 10-day expiry: that user; a second user: `HELD:AMBIGUOUS_DOT_IDENTITY`; not executable by `authenticated` |
| A random key | does not sign in |
| Issuing the key as the Platform Admin (`admin_api_key_rotate`, overlap 0) | a 45-character key (prefix `cfw1_`), shown once; it signs in as `dot_intake_connector_v1` on dot v1 and is refused on website v3; Settings › API usage lists the dot version |

## 2. The one-time connection steps (Platform Admin)

Do these once, in order, after Pilot s1350 is live (the S1-Build M3 document records the merge).

1. **Paste file.** Supabase › SQL editor (project `fxcwkweaxjtknorudmwp`) › paste `docs/paste/PASTE-20261128-s1350-dot-connector-key.sql` (md5 `69aa6f1bf217b2ee6aec6f1fceecae66`) › Run. The last line shows one row: `dot_intake_connector_v1 | dot | v1 | true`.
2. **DOT user.** Administration › Users & roles › **Create user**: an email address the Platform Admin controls for DOT (it is only an identity; nobody needs to accept the invitation, because the connector never uses a password), name "DOT intake", mode **Invite**, role **DOT evidence submitter** only, **Role expiry** required, no more than **14 days** ahead. Create.
3. **Connector key.** Settings › **API usage** › row **DOT intake connector v1** › key `dot_intake_connector_v1` › **Rotate** › overlap **0** › Rotate key. Copy the key shown (once). Do not paste it into any chat, document or repository.
4. **DOT's connector.** In DOT's platform, add a private custom connector (MCP server):
   - URL: `https://fxcwkweaxjtknorudmwp.supabase.co/functions/v1/dot-intake-connector`
   - Authentication: API key in a request header: `Authorization: Bearer <the key>` (or header `x-api-key: <the key>`). Paste the key only into the connector's credential field.
   - Tools exposed: `upload_original`, `finalise_package`, `package_status`.
5. **Check.** Ask DOT to list the connector's tools and call `package_status` for any package name (for example `country` AU, its provider id, `package` `connection-check`): the answer is `status: none`. S1-Build then reads back the call in `pipeline.api_requests` (dot v1, key `dot_intake_connector_v1`).

If DOT's platform cannot send a header with an MCP connector, stop at step 4 and tell S1-Build which authentication methods it offers; nothing else needs changing.

## 3. Revoke, renew or roll back

| To | Do |
|---|---|
| Stop DOT at once | Settings › API usage › DOT intake connector v1 › **Switch off** (every call 401), or Settings › Services & limits › **Data intake drop-off: on** → 0 (every call `HELD:SWITCHED_OFF`) |
| Rotate the key | Settings › API usage › Rotate (with or without an overlap); update DOT's connector |
| Renew DOT's access | Users & roles › DOT's row › set a new expiry (at most 14 days) |
| End DOT's access | Users & roles › Disable the user, or remove the role, or let the expiry pass |
| Roll back | Switch the key off. Nothing to drop; stored files, rows and logs stay as the record |

## 4. Production verification still to do (S1-Build, after the steps)

1. DOT's `package_status` call logged (dot v1) and answered `none`.
2. DOT uploads the next eligible READY subset's originals (not B15) and finalises: package and file rows, stored objects under `dot/<country>/<provider>/<package>/`, the audit row and the receipt read back.
3. Negative checks through the connector: a wrong `sha256` (422, nothing stored), a manifest before its originals (held), an upload after finalise (409), the same finalise again (same receipt), a switched-off key (401).
4. Each candidate's outcome after the admission ticks; acceptance only on a genuinely eligible canonical admission holding through two unattended cycles with consumer read-back.

Open item: the per-key rate limit is not enforced for this key yet (volume is bounded by the package rules); recorded in the API security guide.
