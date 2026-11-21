# API security and end-of-life guide

**Owner:** Platform Admin · **Issued:** 20 Nov 2026 (AEDT), s808 · **ISM controls addressed:** 1798 and 2053 (API authentication, authorisation and error handling), 1817 to 1911 (software and platform currency, supported versions), 1424 and 1717 (browser security headers). **Amended:** 21 Nov 2026, s935 (one key per consumer and version; version register).
**Status words:** *Met*, *Partly*, *Gap*. The consumer API is frozen (G3). Nothing in this guide changes its shape; the controls below are read-only checks or sit beside it.

## 1. The APIs

| API | Consumers | Edge function | Authentication | Status |
|---|---|---|---|---|
| Website API v2 | The website | `website-api-v2`, `website-course-api`, `wix-course-api` | Bearer key; frozen | Frozen by G3 |
| Zoho API v2 | Zoho | `zoho-api-v2`, `zoho-course-api` | Bearer key; frozen | Frozen by G3 |
| Website API v3 | The website, after go-live | `website-api-v3` | Its own key (`website_developer_v3`, s935), signed in with `pipeline.api_key_auth_v1('website', 'v3', hash)`; until it is issued the v2 key works on v3 as its previous key for `api.new_key_bridge_days` (14) | Beside v2; joins the frozen list at go-live (Decision 277) |
| Zoho API v3 | Zoho | `zoho-api-v3` | Its own keys (`zoho_creator_v3`, `zoho_crm_sync_v3`, s935), signed in with `pipeline.api_key_auth_v1('zoho', 'v3', hash)`; a v2 key is refused | Beside v2 |
| Admin reads and writes | The admin app | Database functions behind `admin_read` and governed writes | Supabase sign-in plus server-side role rank | Not public |

Every version is a row in `pipeline.api_versions` (platform, version, endpoint, key store, frozen). Settings › API usage reads that register and every key store, so a new version or key shows with no screen change (standing rule Self-Sustaining API & Key Governance, s935).

## 2. Authentication and authorisation (ISM-1798, ISM-2053)

| Control | How | Status |
|---|---|---|
| Key held only as a hash | The function hashes the presented bearer key (SHA-256) and looks the hash up; the key itself is not stored (`website_api_v2_auth`, and from v3 `pipeline.api_key_auth_v1`) | Met |
| One key per consumer and version (s935) | A key is scoped to one consumer and one version; `pipeline.api_key_auth_v1` matches only keys of the platform and version asked, so a v2 key is not a v3 key. The only exception is the time-limited bridge: an earlier version's key held as the new key's previous key until the new key is issued | Met |
| Why `verify_jwt` is off on consumer functions | They do their own key authentication; the setting is recorded per function in `.github/edge-functions.json`, and a live function that differs fails the daily drift check | Met |
| Per-key rate limit | `website_api_v2_rate`, `rate_per_minute` per key; over the limit returns `RATE_LIMITED` | Met |
| Every call logged | `website_api_v2_log` (v2) and `pipeline.api_request_log_v1` (v3 on): version, action, status, time, item count, bytes, error code, request id and the key's name (never the key). v1 (`website-course-api`, `wix-course-api`, `zoho-course-api`) has no per-call log; Settings › API usage shows it as Not logged | Partly (v1) |
| Least privilege | Each action maps to one fixed database function chosen in code; a caller cannot name a function | Met |
| Method and input checks | POST only; unknown action, malformed JSON and invalid input are rejected with a fixed code | Met |
| Key rotation and revocation | Keys rotate on Settings › API usage with a dual-key overlap (`api.key_rotate_overlap_hours`); the new key is shown once and only its hash is kept; a new version's key starts Not issued. A rotation schedule is **not** recorded here | Partly |

## 3. Error handling (ISM-1278)

A public error must not reveal SQL, table names, function names or stack traces.

| API | Behaviour | Status |
|---|---|---|
| Website v2, Zoho v2, Zoho course, Website course, Wix course | Fixed codes and messages (`INVALID_JSON`, `INVALID_ACTION`, `INVALID_INPUT`, `AUTHENTICATION_REQUIRED`, `RATE_LIMITED`, `NOT_FOUND`, `SERVICE_UNAVAILABLE`, `METHOD_NOT_ALLOWED`); unexpected database errors return `SERVICE_UNAVAILABLE` and log the error code only; every response has a request id | Met (frozen, unchanged) |
| Website v3 | As v2. Until 20 Nov 2026 an invalid-input detail could carry a database message that did not come from the platform's own validation. From s810 the detail is sent only when it starts with the platform's own `INVALID_INPUT:` text; any other database message is dropped | Met from s810 |
| Zoho v3 | As v2 until 20 Nov 2026. From s811 (Platform Admin, 20 Nov 2026 08:06) the same one-line rule as Website v3 applies: a detail is sent only when it starts with the platform's own `INVALID_INPUT:` text. The error envelope, codes, actions and signatures are unchanged. `zoho-api-v3` is not on the frozen G3 list (that names `zoho-api-v2` and `zoho-course-api`); v2 is untouched | Met from s811 |

The `INVALID_INPUT` detail on the frozen v2 and Zoho functions is the platform's own validation text raised by the platform's functions; it was left as it is.

## 4. Browser security headers (ISM-1424, ISM-1717)

Sent by the Cloudflare Worker that serves each app's files, from `public/_headers` (copied into the built folder):

| Header | Value | Purpose |
|---|---|---|
| `Content-Security-Policy` | Scripts only from the app itself; connections only to the app and its Supabase project; no plug-ins; `frame-ancestors 'none'`; `base-uri` and `form-action` limited to the app | Blocks injected scripts and framing |
| `Strict-Transport-Security` | `max-age=31536000; includeSubDomains` | HTTPS only |
| `X-Frame-Options` | `DENY` | Clickjacking (older browsers) |
| `X-Content-Type-Options` | `nosniff` | No type guessing |
| `Referrer-Policy` | `strict-origin-when-cross-origin` | Less leakage in links |
| `Permissions-Policy` | Camera, microphone, location, payment and USB off | Least privilege |

Known trade-offs: styles allow inline rules because the app sets style attributes; images allow any `https:` source for provider logos. The generated release notes page keeps its script in its own file (`release-history.js`), so no page needs the policy lifted (an inline script on it was blocked by the policy and fixed in Pilot #1405).

**Contact for security reports (`/.well-known/security.txt`).** Published in s811 in both apps (this repository's `public/.well-known/security.txt` and Pilot's): `Contact: mailto:security@studysquare.com` (named by the Platform Admin, 20 Nov 2026), `Preferred-Languages: en`, `Expires: 2027-11-19`. It is served as `text/plain; charset=utf-8` by a rule in `public/_headers`, so the single-page fallback never answers it. Renew `Expires` before it lapses (Pilot's spec `s811` fails 30 days before).

## 5. Currency and end of life (ISM-1817 to 1911)

Dates are as published by each vendor on the checking date; confirm against the vendor before relying on them.

| Component | Where | Version in use (20 Nov 2026) | Support position | Action |
|---|---|---|---|---|
| Node.js | CI, local builds | 22.x | Maintenance LTS; security fixes only; ends 30 Apr 2027 | Move CI and local builds to the next LTS before April 2027 (calendar item for Feb 2027) |
| Vite | Pilot | 6.4.6 | Second-to-last major: security patches only | Plan an upgrade to the current major; tracked as a risk |
| Vite | Admin repository | 8.3.8 (upgraded 20 Nov 2026 from 8.1.5, which had a high advisory) | Current major | None |
| React | Pilot / admin | 18.3.1 / 19.2.8 | Supported; Pilot is a major behind | Upgrade with the Vite plan |
| `@supabase/supabase-js` | Both | 2.x | Current major | Kept by the audit gate |
| Wrangler (Cloudflare) | Pilot tooling | 4.x | Current major | Kept by the audit gate |
| Supabase edge runtime | Edge functions | Managed by Supabase | Platform-managed | Watch Supabase announcements |
| Cloudflare Workers runtime | Admin app | Compatibility dates 2026-08 | Platform-managed | Review the dates at each major tooling upgrade |
| PostgreSQL | Supabase | Managed by Supabase | Platform-managed | Watch Supabase announcements |

The dependency audit (s809) fails a pull request on any high or critical advisory, so a vulnerable library cannot arrive unnoticed; the table above tracks the slower question of versions that are supported but ageing. Review the table every quarter with the docs budget.

## 6. The published `security.txt`
```
Contact: mailto:security@studysquare.com
Preferred-Languages: en
Expires: 2027-11-19T13:00:00.000Z
```
It is `public/.well-known/security.txt` in each app repository. A `Canonical` line is left out because each app is reached on more than one host. Renew `Expires` at each security review.
