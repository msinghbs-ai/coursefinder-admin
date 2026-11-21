# s935 — API usage for every version and key; one key per consumer and version

**Lane:** S1-RM-Design · **Asked:** Platform Admin, 21 Nov 2026 13:11 AEDT · **Release:** v2.16.76 / 0.1.498 · **Pilot:** #1458 · **Migration:** `20261121200000_cf247_s935_api_usage_versions_and_keys.sql`
**Standing rule:** Self-Sustaining API & Key Governance (Pilot and admin `CLAUDE.md` and `AGENTS.md`).

## Business objective

Settings › API usage must show every consumer API version (Website and Zoho, v1, v2, v3 and any later one) and every key, with live usage, without a screen change each time a version or key is added. Each consumer gets its own key for each version, so a key can be rotated or switched off for one version without touching another.

## What was wrong

- The screen held a list of two platforms written into the code (Website v2, Zoho v2). Website API v3 and Zoho API v3 were not shown.
- v3 signed in with the v2 functions, so v2 and v3 shared one key, and v3 calls were logged under the v2 version (only an action prefix `v3:` told them apart).

## Design

| Part | What it does |
|---|---|
| `pipeline.api_versions` | One row per (platform, version, endpoint): label, key store, status, frozen. Seeded with Website v1 (`website-course-api`, `wix-course-api`), Zoho v1 (`zoho-course-api`), Website and Zoho v2 (frozen), Website and Zoho v3. |
| v3 keys | `website_developer_v3`, `zoho_creator_v3`, `zoho_crm_sync_v3` in `private.api_keys`, each with a random hash and marked Not issued. Rows only; the table's shape is unchanged. |
| Bridge | The website already calls v3 with its v2 key. That key is `website_developer_v3`'s previous key for `api.new_key_bridge_days` (14, Settings › Search and API). It ends at the first rotation's overlap, or after 14 days. Zoho does not call v3 yet, so its v3 keys have no bridge. |
| `pipeline.api_key_auth_v1(platform, version, hash)` | Service role only. Matches the current key of that platform and version, then the previous key within its overlap. Returns key name, whether the previous key was used, rate limit and page settings. |
| `pipeline.api_request_log_v1(…)` | Logs a call under its own version and key: action, status, time, items, bytes, error code, request id. |
| `security.api_usage_versions_v1()` | Every registered version, plus any version seen in a key or in 30 days of the log that the register lacks (marked not registered). Every key store (`private.api_keys`, the two v1 credential tables), and an earlier version's key used on a version. Per key: status (Active, Rotating / Grace, Not issued, Revoked), masked prefix, created, rotated, last used, and 24 h / 7 d / 30 d calls, 2xx, 4xx, 5xx, error rate and p95. |
| `security.api_usage_coverage_v1()` | Lists any active registered version or key the read path misses. The migration fails if it is not empty. |
| `public.admin_api_usage` | Gains `versions` (md5-guarded edit). |
| `public.admin_api_key_rotate` | The new key's prefix names the version (`cfw3_`, `cfz3_`); the first issue of a Not issued key keeps the bridge (md5-guarded edit). |
| `website-api-v3`, `zoho-api-v3` | Sign in with `api_key_auth_v1(…, 'v3', …)` and log with `api_request_log_v1`. The rate limit is the existing per-key counter. |
| Settings › API usage | One card per version from the read; key table with status, usage and Issue key / Rotate. No version, key or count written into the screen. |

## Guardrails

- G3: v1 and v2 sign-in, functions, tables and edge functions are unchanged; 75 functions / 48 tables, no drift (checked before and after in the migration).
- Manual locks 7,585 (checked before and after). No new job; active jobs ≤ 140. Nothing dropped or deleted. $0 AI and $0 Firecrawl.
- Keys are never stored or shown except once, on issue, to the Platform Admin.

## Platform Admin actions after deploy

1. Settings › API usage › Website API v3 › `website_developer_v3` › **Issue key**, and send it to the website developer securely, before the bridge ends (14 days from deploy).
2. Zoho API v3 › `zoho_creator_v3` and `zoho_crm_sync_v3` › **Issue key**, and send them to Divya when Zoho moves to v3.

## Known limits

- v1 has no per-call log (its edge functions are frozen), so its cards show Not logged; key status comes from the credential tables.
- v3 calls before this release are in the log under v2 with the `v3:` action prefix; they are shown on the v3 card as the v2 key used on v3.

## Tests

- New: `tests/uat/cf-247-s935-api-usage-versions-keys-contract.spec.mjs` (migration, edge functions, screen; mocked screen with v1, v2, v3 and an unregistered v4 in every key status, Issue key).
- Updated: `cf-247-s50-api-console` (error rate on the version card), `cf-247-s538-website-api-v3-r28-contract`, `cf-247-zoho-api-v3-contract` (v3 signs in with its own key).
