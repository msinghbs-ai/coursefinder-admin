# DOT drop-off capability (s1351): proof of concept

**Direction:** Platform Admin PC-20261128-DOT-DROPBOX-POC (28 Nov 2026): one temporary high-entropy HTTPS upload capability URL on the existing endpoint, one genuine READY institutional package, expiry, revocation, bounded size; no connector, account, public bucket, queue or cron.
**Pilot change:** migration `20261201090000_cf247_s1351_dot_dropbox_capability.sql`; `dot-intake` v0.4.0 (`verify_jwt` off: the function signs callers in itself, a Supabase user or a capability); spec `tests/uat/cf-247-s1351-dot-dropbox-capability-contract.spec.mjs`. Supersedes s1350 (not shipped).
The real URL is never written here, in GitHub or in logs kept by S1-Build; it is handed over privately.

## What the capability is

| Part | Behaviour |
|---|---|
| Token | `dic_` + 256 random bits; only its SHA-256 is stored (`pipeline.data_intake_capabilities`) |
| Scope | One package: country, provider and package name fixed at issue; the caller's own country, provider or package are ignored |
| Limits | Expires (at most `data_intake.capability_max_hours`, 48); file ceiling `data_intake.capability_max_bytes` (25 MiB, never above `data_intake.max_bytes`); the package becomes immutable once finalised |
| Powers | Upload originals and finalise the READY manifest of that package, and read that package's status. No list, no read of files, no overwrite, no delete, nothing else |
| Issue and revoke | `public.admin_data_intake_capability_issue_v1` and `..._revoke_v1` (Platform Admin or service role), each logged in `pipeline.admin_control_events` |
| Everything else | Unchanged: the switch `data_intake.on`, prechecks before storage, the private `data-intake` bucket, derived paths, READY manifest last, the existing structured intake writer and admission rules |

## How DOT uses it

The URL is `https://fxcwkweaxjtknorudmwp.supabase.co/functions/v1/dot-intake?cap=<token>` (or the same address with header `x-intake-capability: <token>`, which keeps the token out of request logs). Raw bodies work, so plain HTTP is enough:

```bash
CAP_URL='<the capability URL>'
# 1. each original (repeat per file); type from the Content-Type header
curl -sS -X POST "$CAP_URL&action=upload&ext=pdf&sha256=$(sha256sum a.pdf | cut -d' ' -f1)&source_url=<https address>" -H 'Content-Type: application/pdf' --data-binary @a.pdf
# 2. the READY manifest, last: {"files":[{"sha256":"…"}],"items":[structured intake candidates]}
curl -sS -X POST "$CAP_URL&action=finalise&sha256=$(sha256sum manifest.json | cut -d' ' -f1)" -H 'Content-Type: application/json' --data-binary @manifest.json
# 3. status and receipt
curl -sS -X POST "$CAP_URL&action=status"
```

Multipart forms (fields `action`, `sha256`, `ext`, `source_url`, `file`) also work.

## Rehearsal (rolled back, 28 Nov 2026 13:38 AEDT)

| Check | Result |
|---|---|
| Issue | 68-character token; the raw token is not stored, its hash is |
| Gate | ok, scope AU / TIWA / the named package, 26,214,400 bytes |
| Another country, provider or package stated by the caller | ignored: the capability's scope is used |
| Upload and finalise | recorded (by the system actor); finalise received with candidate counts |
| Revoked; expired | `HELD:CAPABILITY_INVALID` |
| A capability for a finalised package; 500 hours | refused |
| A signed-in rank-0 user issuing one | refused (platform admin required) |
| Audit rows | 3 (issue, revoke, issue) |

## Not yet proven

Evidence registration of the uploaded originals: the drop-off records them (`pipeline.data_intake_files`, hash, size, MIME, source address) and proof runs on the platform's own stored copies of the cited pages; registering the originals themselves in the evidence catalogue is the next increment and is reported as an exact gap, not claimed.
