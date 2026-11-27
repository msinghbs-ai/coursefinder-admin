# Cloudflare reader preflight (s1320)

S1-Build, 27 Nov 2026. Assignment: SS-Programme-Control 27 Nov 2026 20:45 AEDT ("Cloudflare Containers deployment preflight"), working from the M3 runbook *Cloudflare Containers — Setup & Elastic Processing Runbook* v1.0.

**Status:** prepared, not deployed (`HELD:DEPLOYMENT_APPROVAL`). Nothing has been deployed, created or changed on the Cloudflare account, and nothing has been spent. The frontend Worker `coursefinder-pilot` and its `wrangler.jsonc` are unchanged.

## 1. What was found in the repositories

| Item | Finding |
|---|---|
| Frontend deployment | Cloudflare Workers Builds (Git integration) builds the root `wrangler.jsonc` (Worker `coursefinder-pilot`, assets only). No GitHub Actions workflow deploys to Cloudflare, and none used a Cloudflare secret before this change. `release-currentness-deployed.yml` only waits for the Cloudflare build. |
| Where the token is stored | No Pilot workflow uses a GitHub environment, so the repository convention is **repository secrets**. The session proxy blocks the GitHub secrets, variables and environments APIs (HTTP 403), so the token can only be checked from inside a workflow. If `CLOUDFLARE_READER_API_TOKEN` was saved as an environment secret, the preflight reports it as "not visible" and that environment's name is needed. |
| Wrangler support for the new scheduling policy | Checked in the published config schema. Wrangler 4.158.0 (5 Nov) to 4.168.0 (24 Nov) all accept `scheduling_policy: "durable_object"`, named `images` (with `dockerfile` and `build_context`) and `exports` with `storage: "sqlite"`. Pinned to **4.161.0** (12 Nov). |
| Toolchain | `wrangler deploy --dry-run` parses the configuration and bundles the Worker. It stops before the image only because this session has no Docker daemon. GitHub runners have Docker, so the image build runs there. |

## 2. What is prepared (Pilot)

| Path | Contents |
|---|---|
| `.github/workflows/cloudflare-reader-preflight.yml` | **Read-only, started by hand.** Job `preflight` sends GET requests only, with the token mapped into one step and never printed. It checks token verification (user and account), the accounts listing, the Worker scripts listing, Workers account settings, subscriptions (needs Billing Read) and the Containers applications inventory (needs Containers Read). Job `build-check` gets **no token**: it builds the reader image for linux/amd64, runs it with `--network none` to check `/health`, and runs `wrangler@4.161.0 deploy --dry-run`. |
| `cloudflare/reader-burst/wrangler.jsonc` | Isolated Worker `studysearch-reader-burst`. `workers_dev: false`, no routes, so it is not reachable until approval. `scheduling_policy: "durable_object"`, image `reader`, SQLite Durable Object `ReaderContainer`. Variables: `READER_SLOTS=reader-01`, `IDLE_MS=300000`, `MAX_BODY_BYTES` (40 MiB), `MAX_PAGES`, `SIG_SKEW_S`. These become G2 settings (toolset `cloudflare_reader`) at approval. |
| `cloudflare/reader-burst/src/index.ts` | Gateway. Every check runs before any container is reached: HMAC-SHA256 signature over method, path, request id, time, slot and body hash (`READER_BURST_SIGNING_KEY`, a Worker secret set at deployment); time skew; named slot only; body size and hash. Then `getByName(slot)`. The Durable Object refuses a reused request id (`REPLAYED`) and a second job on a busy slot (`SLOT_BUSY`). It starts `standard-3` with `enableInternet: false` and inactivity timeout `IDLE_MS`, shares one start promise, and polls `/health` until ready. It holds no Supabase credential, makes no outside fetch, and has no queue or scheduler. |
| `cloudflare/reader-burst/container/` | A `Dockerfile` (pinned `denoland/deno:debian-2.1.4`, linux/amd64, non-root, dependencies cached at build, run `--cached-only`) and `server.ts`. **The existing reader modules are copied byte for byte** from `supabase/functions/coverage-sweep` (`pdf.ts` ruled-cells-v1, `entry-pdf-scope.ts`). It uses the same `npm:unpdf@0.12.1` and the same stored-PDF sequence as `storedText` (gunzip, `pdfPages`, `pdfTables`, s1253 scope retry). It proves the source sha256 and refuses non-PDF or over-inflated input. It returns the proven tables and positioned pages for the existing readers, verifier and admission writer. It writes nothing. |
| `tests/uat/cf-247-s1320-cloudflare-reader-preflight-contract.spec.mjs` | Guard (5 tests): read-only workflow, dry run only, token never printed, frontend unchanged, gateway order (signature before `getByName`), offline container, module reuse, no lockfile. |

**Local proof in this session:**
- `deno check` passed.
- The server on a generated 60-page, 104 kB ruled PDF returned the existing reader's own verdict in 416 ms at 129 MB RSS.
- A hash mismatch was refused (`SOURCE_HASH_MISMATCH`), and so was a non-PDF (`NOT_PDF`).
- The Wrangler dry run parsed the configuration and bundled the Worker.

## 3. Newcastle benchmark (prepared)

| Item | Value |
|---|---|
| Entry-matrix source | `ff90a9ca-5e2f-4a1a-9b5f-b816852eed1c` (Newcastle `1822b40a…`) |
| Stored evidence | `751ba9e8-659f-493b-9a3e-456b9ae59b55`, `source_snapshot`, `application/pdf`, captured 24 Nov 2026 09:39 UTC |
| Source | `https://www.newcastle.edu.au/__data/assets/pdf_file/0020/1102565/2025-1079-International-Prospectus-2027-ROW_WEB-2.pdf` |
| Content hash (raw PDF) | `e208356a6936a0bc0b3f923191d21d092d97d7610f2fc921589365f1576da4ca` |
| Stored object | `evidence/layer2/AU/entry-matrix/1822b40a…/ff90a9ca…/e208356a….pdf.gz`, **13,792,426 bytes gzip** |
| Supabase baseline | The AER entry-inspect read failed with HTTP 546 (worker resource limit) on 3 of 3 attempts, read-only. No rows. |
| Benchmark run (after approval) | One signed request to `reader-01`. The trusted caller streams the stored object (no fetch from the university). Compare: cold start, wall time, RSS, pages read, `pdf.status` and tables. Then the existing verifier and admission outcome (rows admitted or held, with reasons). The slot must be at zero instances after the idle timeout. |

## 4. Cost estimate (USD; Cloudflare published rates, to be confirmed against the account)

The figures assume one `standard-3` instance (2 vCPU, 8 GiB, 16 GB disk) at full CPU, which is about **$0.220 an hour awake** (RAM $0.072, CPU $0.144, disk $0.004). Workers Paid includes 25 GiB-h of RAM, 375 vCPU-min and 200 GB-h of disk a month, which is about 3.1 hours of a `standard-3` at full CPU.

| Case | Awake time | Estimate |
|---|---|---|
| Newcastle benchmark (worst case: 5 min reading + 5 min idle) | 10 min | about $0.04 before allowance; **$0 within the included allowance** |
| Pilot month, one slot, about 2 heavy PDFs a day | about 10 h | about $1.50 over the allowance |
| Pilot month, two slots at the same use each | about 20 h | about $3.70 over the allowance |
| Theoretical maximum if a slot never stopped (two slots, 24 h) | 48 h a day | about $10.60 a day. Prevented by the idle timeout, one job per slot and the lease cap. This is why a daily ceiling and the kill switch are needed. |

Not included:
- Workers Paid base US$5/month, if the account is not already on it.
- Worker and Durable Object requests, which are negligible at this volume.
- Container logs, priced from 1 Dec 2026.
- Egress.

Model and Firecrawl spend are separate and unchanged.

## 5. Approval requested from the Platform Admin (runbook §11)

1. **Run the read-only preflight**: dispatch `Cloudflare reader preflight (read only)` once. It is $0. S1-Build reads back the account, Workers Paid, Containers and the token's scope.
2. **Deployment authority** for `studysearch-reader-burst` from Pilot CI, with a deploy step added in the governed release. The bootstrap token needs Workers Admin (one-time creation) and Containers Write. After creation, it is narrowed to the individual Worker and the bootstrap token is revoked (runbook §3.2).
3. **One `standard-3` slot (`reader-01`)**. A second slot (`reader-02`) only on a separate approval.
4. **Ceilings**: proposed **US$2.00 a day and US$20.00 a month** for container compute, recorded as G2 settings with the kill switch. Plus an account-level email alert, not a blocking spend limit.
5. **Data handling**: public, stored university evidence only. Durable Object placement is not guaranteed to be in Australia.

## 6. Points to decide

- **Lockfile.** The runbook asks for an npm lockfile in the Worker folder, but Pilot `CLAUDE.md` says never to create `package-lock.json`. The preparation pins exact versions instead (Wrangler 4.161.0, Deno 2.1.4, unpdf 0.12.1), so no lockfile is needed unless the Platform Admin decides otherwise.
- **Folder.** The folder is `cloudflare/reader-burst/`, not `workers/reader-burst/`, because Pilot spec `s587` guards that no `workers/` folder exists (no separate Boost worker).

## 7. Unchanged

- Supabase stays the default runtime and the queue, lease, evidence, qualification and admission authority.
- There is no new cron job, queue, admission engine or storage system.
- G3 is untouched, and no setting or spend changed.

## 8. Preflight result (run 45989015838, 27 Nov 2026 22:20 AEDT, read only, $0)

| Check | Result |
|---|---|
| Secret `CLOUDFLARE_READER_API_TOKEN` | Present as a **repository** secret and visible to Pilot workflows (value not shown) |
| Token | A **user-owned** token, active, expires 27 Dec 2026. The account-token verify endpoint answers 401, so it is not an account-owned token. |
| Accounts the token reaches | **Two**: "Techm" (`e792d0…`), which holds the Workers `coursefinder-pilot`, `coursefinder-admin`, `coursefinder-demo` and `studysearch-portal`, and a personal account (`f20962…`, free plan) |
| Techm subscriptions | `workers_paid` (Paid), `observability_paid`, `images_v2_stream_basic` |
| Containers on Techm | Applications listing HTTP 200: available, with **no existing application** (so there is no default-policy application to migrate) |
| Containers on the personal account | 401: "requires the Workers Paid plan" (not the StudySearch account) |
| Image build (runner, no token) | Built for linux/amd64 with Docker 29.4.2 |
| `wrangler@4.161.0 deploy --dry-run` | Passed. Worker 4.63 KiB (gzip 1.96 KiB) with Durable Object `ReaderContainer`, then "--dry-run: exiting now" |
| Offline health check | The check command was wrong (`deno eval` takes no `--allow-net`); fixed in Pilot s1320 follow-up |

**Points for the Platform Admin before deployment approval**
- The token reaches a second, personal account. The runbook (§3.1) asks for the StudySearch account only. Re-scope it to Techm, or replace it with an account-owned token.
- Write permissions (Workers Admin for the first creation, Containers Write) are not proven by a read-only run. They are proven only by the approved deploy step.
