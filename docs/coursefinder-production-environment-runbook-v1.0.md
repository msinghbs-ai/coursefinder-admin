# CourseFinder — Production Environment Runbook (customer-owned accounts)

**Version:** 1.0 · **Date:** 29 September 2026 · **Status:** ACTIVE: go-live target **Friday 3 October 2026**
**Change control:** CF-CHG-20260915-247 (M2.4.8 / M2.4.9 / M2.5) · **Decisions:** Design Reference Decision 163, Decision 164
**Plan:** `docs/coursefinder-complete-coverage-delivery-plan-v1.1.md`

---

## 1. Executive summary

The platform moves from the pilot accounts to accounts owned by the customer and paid with the customer's credit card. Every service is included: Supabase, Cloudflare, GitHub, OpenRouter, Firecrawl, the other Layer 2 providers, and the consumer API. The MSP keeps administrator access to deliver and support the platform.

**Recommended approach: transfer the existing Supabase project** to the customer's Supabase organisation. A transfer moves the whole project as it stands: database, 11 GB of evidence files, 139 edge functions, secrets, 46 schedules, users and API address. Nothing is copied or rebuilt, so the website developer's API address does not change. This is the lowest-risk way to meet 3 October.

**Fallback approach: a new project with a full migration.** Use it only if a region change is required (for example Mumbai to Sydney) or the transfer is refused. Section 7 gives the steps and effort. It needs a 3–4 hour change window and a new API address for the website developer.

## 2. Business objectives

| Objective | Measure |
|---|---|
| Customer owns every account and pays every bill | Each service in §4 is in the customer's name, on the customer's card, with the customer as owner |
| No loss of data or evidence | Table row counts, storage object counts and sizes, and function list identical before and after (§8) |
| Website keeps working | Consumer API snapshots identical before and after cutover; developer tests pass |
| MSP can support it | MSP accounts are members with administrator rights, never owners of billing |
| Pilot credentials retired | Every pilot-era key rotated or revoked (§6.4) |

## 3. Scope

### In scope
- Customer accounts: Supabase, Cloudflare, GitHub, OpenRouter, Firecrawl, other Layer 2 providers in use, email sending (SMTP), and domain/DNS.
- Moving the Supabase project (database, storage buckets, edge functions, schedules, secrets).
- Moving the two GitHub repositories and their deployment workflows.
- Moving front-end hosting (Cloudflare Workers) and the custom domain.
- Production consumer API tokens for the website (Wix), website API and Zoho. An API address on the customer's domain.
- Rotating every credential used during the pilot.
- Verification, rollback and a post-go-live check.

### Out of scope
- New features. Work in progress continues under the delivery plan after go-live.
- Moving the unrelated `coursefinder-demo` project (it stays in the pilot organisation).

## 4. Accounts the customer creates (customer name, customer credit card)

| # | Service | Plan to choose | Approx. cost (USD) | Customer does | Then gives the MSP |
|---|---|---|---|---|---|
| 1 | **Supabase** | Organisation on **Pro**, spend cap **on** | $25/month + compute (Medium about $60/month during the load window, then Small about $15/month); the first $10 of compute is covered | Create organisation "<Customer> CourseFinder"; add card; add billing email | Invite the MSP's Supabase login as **Owner** (needed for the transfer; can drop to Administrator afterwards) |
| 2 | **GitHub** | Organisation (Free is enough; Team $4/user/month if branch protection with required reviews is wanted) | $0–4/user/month | Create organisation; add card only if on Team | Invite the MSP's GitHub account as **Owner** |
| 3 | **Cloudflare** | Account; **Workers Paid** recommended | $5/month | Create account; add card; add the customer domain (change the domain's name servers to Cloudflare, or add a CNAME if DNS stays elsewhere) | Invite the MSP as **Administrator** |
| 4 | **OpenRouter** | Pay as you go with prepaid credits | Start with $50 credit; about $0.0008 per Layer 3 item | Create account; buy credits; turn on auto top-up at $10 if wanted | Create an API key named "CourseFinder production" with a **credit limit** (e.g. $30/month) and send it by a secure channel (not email) |
| 5 | **Firecrawl** | **Standard** (100,000 credits/month) | About $99/month (monthly) or $83/month (annual) | Create account; subscribe | Create an API key; send securely |
| 6 | Other Layer 2 fetchers (ScraperAPI, Scrape.do, ZenRows, Parsebot) | Only if kept | Varies | Decide keep or drop (recommendation: **drop for go-live**; Firecrawl plus direct reads cover the sweep) | Keys only for the ones kept |
| 7 | Apollo (provider contact enrichment) | Only if kept | Varies | Decide keep or drop (recommendation: drop for go-live) | Key only if kept |
| 8 | **Email sending** for admin sign-in emails (SMTP) | Existing M365 / Google Workspace mailbox, or a sending service | Existing | Provide an SMTP account (e.g. `noreply@<customer domain>`) | SMTP host, port, user, password |
| 9 | **Domain** | Existing customer domain | Existing | Decide two host names: admin console (e.g. `admin.<domain>`) and API (e.g. `api.<domain>`) | Confirmation of the names |

**Secure hand-over of keys:** use a password manager share (1Password/Bitwarden), or have the customer type keys straight into the admin console (Administration → Layer 2 providers / Layer 3 AI profiles). Never send them by email or chat.

## 5. Timeline to go-live

| When (IST) | Who | Step |
|---|---|---|
| Mon 29 Sep | MSP | Runbook and plan issued. Compute raised to Medium. Admission running |
| Tue 30 Sep | Customer | Create accounts 1–5, 8, 9; send invitations and keys (§4) |
| Tue 30 Sep | MSP | Pre-transfer readiness (§6.1): the 27 live functions missing from GitHub brought into the repository; inventory baseline taken |
| Wed 1 Oct | MSP | GitHub organisation transfer (§6.2); Cloudflare project rebuilt in the customer account on a temporary address (§6.3) |
| Wed 1 Oct | MSP | **Supabase project transfer** (§6.4), outside website peak hours; verification (§8) |
| Thu 2 Oct | MSP | Credential rotation (§6.5); vendor keys switched to customer accounts; production API tokens issued; developer tests against the new API address |
| Thu 2 Oct | Platform Admin | Dress rehearsal and GO/NO-GO (M2.4.9) |
| Fri 3 Oct | MSP | Custom domains live; pilot tokens revoked; go-live check (§9); developer notified |
| After 3 Oct | MSP | Compute back to Small once the admission backlog clears; daily updates continue |

## 6. Recommended path — project transfer

### 6.1 Pre-transfer readiness (MSP)
1. **Functions missing from GitHub.** 27 of the 139 live edge functions have no source in the repository, including `layer4-course-resolve`, which the Layer 4 screens use. Download each one's live source into `supabase/functions/` and commit it, so the repository can rebuild production. (The transfer doesn't need this, but a rebuild or rollback would.)
2. **Inventory baseline.** Record:
   - row counts for every table;
   - storage object counts and bytes per bucket;
   - the list of live functions with their versions;
   - the list of schedules;
   - Vault secret names;
   - a consumer API snapshot.
3. **Transfer prerequisites:**
   - disconnect any Supabase GitHub integration on the project (Project Settings → Integrations);
   - confirm no log drains;
   - the MSP login must be Owner of the pilot organisation and a member of the customer organisation.
4. **Customer organisation ready:** on Pro, card valid, spend cap on.

### 6.2 GitHub (repositories)
1. In each repository (`Coursefinder-Pilot`, `coursefinder-admin`): Settings → General → Danger zone → **Transfer**, to the customer organisation.
   - History, issues, pull requests, Actions workflows and branch settings move with the repository.
   - GitHub redirects the old addresses.
2. Re-enter the Actions secret `SUPABASE_ACCESS_TOKEN` and the variable `SUPABASE_PROJECT_REF`. Don't rely on secrets surviving the transfer. The token must come from the customer's Supabase account (the MSP's personal token is retired at §6.5).
3. Optionally rename `Coursefinder-Pilot` to `coursefinder-platform`. Update the project instructions and `docs/README.md`.
4. Branch protection on `main`: pull request required; status check `build-and-smoke` required.

### 6.3 Cloudflare (admin console hosting)
1. In the customer Cloudflare account: Workers & Pages → Create → Import a repository → the customer GitHub organisation's platform repository (Workers Builds).
2. Set the same build command and environment variables as the pilot Worker. Copy them from the pilot Cloudflare project settings; they hold the Supabase URL and publishable key.
3. Deploy to the temporary `*.workers.dev` address, check sign-in and the main screens, then add the custom domain `admin.<domain>`.
4. **API address on the customer domain (recommended).** Add a small Worker route, `api.<domain>/*`, that forwards to the Supabase functions address for `wix-course-api`, `website-course-api` and `zoho-course-api`.
   - The website developer then uses `https://api.<domain>/...`.
   - Any future Supabase move or region change is invisible to the website.
5. Remove the pilot Cloudflare project after go-live plus 7 days.

### 6.4 Supabase project transfer
1. Pilot organisation → project `coursefinder_Pilot` → Project Settings → General → **Transfer project** → choose the customer organisation.
   - Billing moves to the customer from the moment of transfer.
   - The project ref (`fxcwkweaxjtknorudmwp`), URL, keys, data, storage, functions, schedules and secrets are unchanged.
2. Rename the project to "CourseFinder Production" (name only).
3. **Region stays ap-south-1 (Mumbai).** A transfer can't change region. If Sydney is required, use §7 instead.
4. Check straight away (§8): same row counts, storage bytes, function list and schedules; consumer snapshot identical.

### 6.5 Credential rotation (everything the pilot saw)

| Credential | Where it lives | Action |
|---|---|---|
| Supabase API keys (publishable/secret, or anon/service_role) | Supabase; Cloudflare environment variables; edge functions (automatic) | Create new API keys, update Cloudflare, then revoke the old ones (see the note after this table) |
| Supabase personal access token (deploy workflow) | GitHub Actions secret | Replace with a token from the customer's Supabase account |
| Automation key | Vault `coursefinder_pilot_automation_key` | Rotate through the admin console |
| Firecrawl | Vault (Layer 2 provider credential) | Replace with the customer key; set the monthly limit in the budget guard to the customer plan |
| Other Layer 2 providers | Vault | Replace with customer keys, or disable the provider |
| OpenRouter | Vault (one key for all Layer 3 profiles) | Replace with the customer key |
| Apollo | Edge function secret `APOLLO_API_KEY` | Replace, or remove and disable the function |
| Consumer API tokens (Wix, website, Zoho) | Stored as hashes in the database | Issue production tokens; give them to the developer securely; revoke pilot tokens on go-live day |
| Admin console users | Supabase Auth (5 users) | Remove pilot-only users; add customer administrators; set up multi-factor sign-in |
| SMTP | Supabase Auth settings | Customer SMTP details |

**Note on API key rotation:**
- Anything reading `SUPABASE_URL` or `SUPABASE_SERVICE_ROLE_KEY` keeps working, because Supabase supplies those automatically.
- The schedules call functions through `public.coursefinder_runtime_edge_base_url()` and a one-time nonce, so they carry no key that needs rotating.

## 7. Fallback path — new project and full migration (only if a region change is needed)

**Effort:** about 1.5–2 days of MSP work plus a 3–4 hour change window. **Effect:** a new project ref and URL. The website must use the `api.<domain>` address from §6.3 step 4.

| Step | What | How | Check |
|---|---|---|---|
| 1 | Create project | Customer organisation, chosen region, Pro, compute Medium | Project healthy |
| 2 | Extensions | Enable `vector`, `pg_net`, `pg_cron`, `pgcrypto`, `uuid-ossp`, `supabase_vault`, `pg_stat_statements` | List matches source |
| 3 | Freeze source | Pause all 46 schedules; put the admin console in read-only (maintenance banner) | No cron runs |
| 4 | Roles and schema | `supabase db dump --db-url <source> --role-only` and `--schema` for all custom schemas (`api, ref, catalogue, pim, scholarship, integration, pipeline, search, publishing, workflow, security, private, ranking, pim_api, l4_api, admin_api, public`), restore with `psql` | Object counts match |
| 5 | Data | `supabase db dump --data-only` (includes the `auth` schema, so the 5 users and hashed passwords come across), restore with `psql`. Don't restore `cron.job` until step 10 | Row counts match for every table |
| 6 | Storage (11 GB, 31,417 files, buckets `evidence` and `provider-assets`) | Create the buckets with the same settings (private; allowed types including `application/gzip`). Copy with `rclone sync` between the two projects' S3-compatible storage endpoints (Project Settings → Storage → S3 access keys) | Object counts and total bytes match per bucket; a sample of SHA-256 checks against `pipeline.evidence_artifacts.content_hash` |
| 7 | Edge functions (139) | Point the GitHub variable `SUPABASE_PROJECT_REF` at the new ref; deploy every function from the repository (§6.1 step 1 must be done first); `verify_jwt` settings as the deploy workflow allow-list | Function list and versions match |
| 8 | Secrets | `supabase secrets set` for function secrets; **re-enter every Vault secret** through the admin console (the new project has a different Vault key, so copied secrets can't be decrypted) | Each provider "Test connection" passes |
| 9 | Runtime settings | Update `public.coursefinder_runtime_edge_base_url()` and `public.platform_environment_read_service` (both hold the project address) | A nonce call succeeds |
| 10 | Schedules | Recreate the 46 cron jobs from the source list; switch them on in groups (admission and sweep last) | `cron.job_run_details` shows successes |
| 11 | Front end and API | Update the Cloudflare environment variables to the new URL and keys; switch `api.<domain>` to the new functions address | Consumer snapshot identical to source |
| 12 | Cutover | Unfreeze on the new project; source stays paused for 7 days as rollback, then is deleted | §8 all green |

## 8. Verification (either path)

Each item below is compared before and after:

- Row count for every table in the custom schemas and `auth.users`.
- Storage: object count and total bytes per bucket, plus a 100-file sample hash check.
- Edge functions: slug list and versions. `verify_jwt` matches the workflow allow-list.
- Schedules: name, schedule, active flag.
- Vault: secret names present; each provider's test connection passes.
- Consumer API: the Decision 136 snapshot (`security.consumer_api_snapshot_v1()`) is identical, and the website developer runs `search`, `lookup` and `scholarships` with the production token.
- Admin console: sign-in, Data Quality → Course coverage, Layer 4 queue, Platform resources.
- Daily update runs the next morning without errors.

## 9. Go-live check (3 October)

| Check | Pass condition |
|---|---|
| Ownership | Every §4 account shows the customer as owner and the customer card |
| Credentials | Every §6.5 row done; pilot tokens revoked |
| Data | §8 identical |
| Coverage | Admission running; the daily update shows the figures |
| Website | Developer confirms production token works on `api.<domain>` |
| Backups | Daily backups visible (Pro keeps 7 days). Point-in-time recovery is optional (from about $100/month; needs Small compute or above) |
| Spend | Spend cap on; OpenRouter key limit set; Firecrawl budget guard at the plan limit |

## 10. Rollback

- **Transfer path.** The project can be transferred back to the pilot organisation the same way. Credentials are rotated only after the GO decision, so rollback before GO needs no key changes.
- **Migration path.** The source project stays paused but intact for 7 days. To roll back, point Cloudflare and `api.<domain>` back to it and switch its schedules on.

## 11. Assumptions
- The customer can create the accounts and approve card payments by 30 September.
- The Mumbai region is acceptable for go-live. Latency to Australian users is higher than Sydney, but the website is expected to cache through `sync_courses`, which lessens the effect.
- The MSP keeps administrator access to every account for support.
- Pricing is as published by each vendor on 29 September 2026 and should be confirmed at sign-up.

## 12. Risks

| Risk | Effect | Mitigation |
|---|---|---|
| Accounts not ready by 30 Sep | Go-live slips | Accounts are the first step; the transfer itself takes minutes |
| 27 functions exist only live | A rebuild would miss them | Brought into GitHub on 30 Sep (§6.1) |
| Secrets not carried by the GitHub transfer | Deploy workflow fails | Re-entered as a set step (§6.2) |
| Region is Mumbai | Higher latency for Australian users | API on the customer domain; region change later by §7 without affecting the website |
| Pilot keys still valid after go-live | Unauthorised use | Rotation table §6.5 is a go-live gate |
| Vendor limits (Firecrawl, OpenRouter) on new accounts | Sweep or Layer 3 pauses | Budget guards reset to the customer plans; daily update shows remaining credit |
