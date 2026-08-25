# CourseFinder Production Environment Build & Operations Guide v1.0

**Status:** PRE-PRODUCTION BASELINE  
**Date:** 25 August 2026  
**Change Control:** `CF-CHG-20260825-031`

## Purpose

This guide defines how to establish, secure, operate, monitor and troubleshoot a clean CourseFinder Production environment without copying Pilot weaknesses or weakening governance. Production is a separate trust boundary, not a renamed Pilot project.

## Production target architecture

Recommended initial Production stack:

- Supabase Production project on a paid plan, preferably Sydney (`ap-southeast-2`) unless a documented data-residency/latency decision selects another region;
- Cloudflare-hosted Admin/application deployment isolated from Pilot;
- GitHub protected Production environment and protected deployment branch/tag workflow;
- vendor acquisition credentials separate from Pilot and stored only in server-side secret stores/Vault;
- private Evidence Storage;
- automated database/API/security/browser UAT required before every Production promotion;
- broad Search/publication remains separately governed.

Do not copy secrets, service-role keys or browser credentials between environments.

## Step-by-step establishment

### Phase 1 — Production governance

1. Open a Production Change Control under `70-security-platform` or `80-uat-release-operations` depending on primary impact.
2. Freeze the accepted Pilot migration/runtime SHA used as the source baseline.
3. Produce an environment inventory: Supabase, Cloudflare, GitHub, scraper providers, mail/identity integrations, storage, monitoring and DNS.
4. Define Production owners and emergency access owners.
5. Define RTO/RPO targets and backup/restore acceptance criteria before creating data.
6. Define allowed Production data sources and explicitly exclude Pilot/UAT credentials and synthetic test accounts unless approved.

### Phase 2 — Supabase Production project

1. Create a new Supabase project in the chosen Production region; do not convert the Pilot project in place.
2. Use an environment-specific project name and project reference.
3. Apply schema through the governed migration history only.
4. Compare migration list and schema hashes between source and Production.
5. Create environment-specific Auth configuration, redirect URLs and SMTP.
6. Enable leaked-password protection before creating ordinary Production users.
7. Require MFA for privileged Admin roles where supported by the application contract.
8. Disable anonymous sign-in unless explicitly required by a separately accepted public product path.
9. Review JWT/session expiry and privileged-session requirements.
10. Verify all exposed schemas, grants, RLS, views and RPCs.
11. Audit every `SECURITY DEFINER` function; no unexplained browser-executable privileged function may remain.
12. Keep service-role/secret keys out of frontend bundles and `NEXT_PUBLIC_*`/browser configuration.
13. Create the private Evidence bucket with MIME, size and access restrictions.
14. Configure backup policy; for Production, decide whether daily backups are sufficient or PITR is required.
15. Run Supabase Security and Performance Advisors and record every WARN/ERROR disposition.
16. Execute a restore test into a non-Production target before declaring backup readiness.

### Phase 3 — GitHub and CI/CD

1. Use a protected Production environment in GitHub.
2. Require successful automated UAT before Production deployment.
3. Require review/approval for changes that alter schema, Auth, RLS, privileged RPCs, secrets, publication or source authority.
4. Use environment-scoped secrets; Production credentials must not be available to Pilot workflows.
5. Pin dependencies and retain lockfiles.
6. Generate deployment evidence containing commit SHA, migration state, workflow run ID, test result and rollback target.
7. Do not permit a manual local workstation deployment that bypasses the accepted release workflow except under documented break-glass procedure.

### Phase 4 — Cloudflare Production application

1. Create a Production deployment/environment distinct from Pilot.
2. Use Production-only environment variables and Supabase public/publishable key.
3. Configure custom domain/DNS only after authenticated Production UAT passes.
4. Apply least-privilege Cloudflare API tokens for deployment automation.
5. Review WAF/rate-limit/bot controls for Admin and public endpoints separately.
6. Ensure Admin authentication cannot be bypassed by a direct origin URL.
7. Record Worker/Pages deployment ID and source SHA in release evidence.

### Phase 5 — acquisition vendors

1. Create Production API keys separate from Pilot keys.
2. Store vendor secrets in Supabase Vault/server secret storage only.
3. Configure per-provider monthly and per-entity budget limits.
4. Preserve Direct HTTP as the first route where sufficient.
5. Configure Firecrawl as the initial paid richer-Evidence route.
6. Retain Scrape.do/ZenRows as controlled fallback until measured use justifies a paid tier.
7. Rate-limit concurrency below vendor maximum until provider/domain-specific behaviour is measured.
8. Record vendor request units/cost and provider attempt for every paid acquisition.

### Phase 6 — Production seed and validation

1. Seed reference/configuration data from an accepted export/migration path.
2. Re-run Layer 1 authoritative ingestion rather than assuming copied Pilot data is authoritative.
3. Reconcile Provider/Course stable identities and counts.
4. Run a bounded L2 cohort before broad enrichment.
5. Verify Evidence paths, hashes and private access.
6. Verify no Search/publication side-effect from L2/L3 operations.
7. Execute automated database/API/security/browser acceptance on desktop/mobile.
8. Run restore/rollback drill.
9. Sign Production gate only when security, integrity, performance, observability and operations criteria pass.

## Production security checklist

Mandatory before go-live:

- leaked-password protection enabled;
- privileged MFA policy accepted and tested;
- no shared human admin accounts;
- least-privilege roles and expiry for elevated temporary access;
- no browser access to service-role or vendor secrets;
- no unexpected `PUBLIC`/`anon`/`authenticated` execution on privileged functions;
- all exposed tables protected by explicit access controls;
- views use safe invoker/access semantics;
- private Evidence cannot be listed/read without authorised path;
- signed Evidence links use short TTL;
- audit events retained for access and consequential mutations;
- dependency lockfiles and automated vulnerability review enabled;
- CI/CD secrets environment-scoped;
- Production and Pilot credentials independent;
- backup restore tested;
- incident rollback documented;
- all Supabase Security Advisor WARN/ERROR items explicitly accepted, remediated or blocked.

## Current Production hardening items inherited from Pilot

1. Enable leaked-password protection (`CF-CHG-20260823-022`).
2. Independently review `public.layer2_ops_policy_update(...)`: it is currently `SECURITY DEFINER`, callable by `authenticated`, validates `auth.uid()` and requires rank >= 5. Production must either retain it with explicit threat-model/UAT evidence or replace it with a narrower mutation boundary.
3. Confirm non-public schemas remain inaccessible through the Data API.
4. Re-run the complete browser-executable RPC inventory after every migration.
5. Re-test Evidence Storage access and signed URL behaviour.

## Platform limitations and operational implications

### Supabase Pro

Current plan characteristics relevant to CourseFinder include:

- 100 GB file storage included, then per-GB overage;
- 8 GB database disk included per project, then overage;
- 250 GB egress included, then overage;
- daily backups retained for 7 days;
- 7-day log retention;
- no Production SLA equivalent to Enterprise support commitments;
- development branches do not contain Production data by default;
- Edge Function egress is not a static IP guarantee.

Implications:

- evidence lifecycle must be monitored before it becomes a storage-cost problem;
- external sources requiring static-IP allowlisting may need another acquisition path;
- incident investigation requiring >7 days of platform logs needs an external log strategy/log drain or retained application audit records;
- backups are not a substitute for tested restore/RPO/RTO.

### scraper providers

- credit cost varies by rendering/proxy mode;
- rate/concurrency limits differ by plan;
- successful transport does not prove correct content;
- provider output format can change;
- vendor outage/failure must not corrupt canonical identity;
- any vendor-generated/normalised Evidence remains subordinate to first-party source authority.

### Cloudflare

- plan-specific Worker/Pages limits must be tracked;
- runtime/platform logs are not the canonical business audit record;
- deployment success does not replace authenticated application UAT.

## Daily operations

Daily automated/operational review should cover:

- Supabase project health;
- Auth failures/anomalies;
- Security Advisor changes after schema releases;
- failed Edge Functions and error rate;
- Layer 1 source freshness;
- Layer 2 failed/degraded provider routes;
- paid acquisition spend/credits;
- L3 queue growth and retry rate;
- L4 review backlog age;
- Evidence Storage utilisation and daily growth;
- database size/connections/slow queries;
- failed scheduled jobs;
- Search/publication state drift;
- latest Production deployment/UAT status.

## Weekly management activities

- review storage/cost forecast;
- review provider success, factual resolution and cost per resolved entity;
- review stale sources;
- review L3 accuracy/escalation and token cost;
- review privileged-role membership/expiry;
- review unresolved Security Advisor items;
- sample Evidence-to-canonical lineage;
- verify backups exist;
- review open bugs by severity and regression risk.

## Monthly management activities

- restore test or scheduled recovery exercise according to accepted cadence;
- review and rotate vendor/API credentials according to policy;
- review inactive users and privileged roles;
- review source and provider contracts/quotas;
- validate evidence retention/tiering;
- run performance benchmark against representative catalogue scale;
- review monthly Supabase/vendor/Cloudflare costs against budget;
- review Change Controls and close/supersede stale records.

## Monitoring thresholds

Initial operational thresholds:

- Evidence storage: warning 60%, action 75%, critical planning 90% of quota;
- failed scheduled job: alert on first failed critical Layer 1 run; alert after two consecutive L2/L3 failures;
- privileged login anomaly: immediate review;
- Security Advisor new WARN/ERROR: review within one working day; Critical/High blocks promotion;
- provider spend: warn at 60% and 80% monthly allowance;
- L3 queue age: warn when oldest unresolved item breaches domain SLA;
- Layer 1 stale source: blocks downstream freshness claims.

## Troubleshooting sequence

1. Identify affected environment and deployment SHA.
2. Determine whether failure is browser, API, database, Edge Function, source acquisition, vendor, storage or Auth.
3. Check latest successful run and first failing run.
4. Inspect correlated job/provider-attempt/Evidence IDs.
5. Confirm source/profile/version and provider route actually used.
6. Check Supabase service logs and application audit records.
7. Validate Auth/RBAC independently before assuming UI defect.
8. Reproduce in a bounded non-Production path where possible.
9. Do not mutate canonical rows manually to hide ingestion/extraction defects.
10. Open/update Change Control if the fix changes observable behaviour, data semantics, security or operations.
11. Add an automated regression test before closure.
12. Record rollback and final evidence.

## Bug reporting standard

Every bug should contain:

- environment;
- timestamp/timezone;
- user role (never credentials);
- entity/source/job/Evidence IDs where relevant;
- expected result;
- actual result;
- exact reproduction path;
- deployment SHA/UI version;
- browser/device if relevant;
- screenshots/log reference with secrets removed;
- severity and data/security impact;
- whether Search/publication/canonical data changed;
- related Change Control;
- automated regression test added/updated;
- fix SHA and UAT run.

Severity model:

- **SEV1:** confirmed security compromise, data corruption, unauthorised publication or complete Production outage;
- **SEV2:** major workflow unavailable, privileged access defect, repeated incorrect canonical application;
- **SEV3:** bounded functional defect with workaround and no material security/data corruption;
- **SEV4:** cosmetic/documentation/minor usability issue.

## Separate clean ChatGPT Production project

Create a separate ChatGPT project for Production operations and releases, but keep durable authority in GitHub/Supabase rather than in chat memory.

Recommended project instruction:

> CourseFinder Production is a security-first controlled environment. Before any material work, read `PROJECT_INSTRUCTIONS.md` in `msinghbs-ai/coursefinder-admin`, then the Change Control register, latest master plan/running build, Production Build & Operations Guide, current architecture and relevant open security/release records. Reconcile GitHub source, deployed Production Supabase and release evidence before changing anything. Production secrets must never be pasted into chat or committed. Use the Supabase/GitHub/Cloudflare connected tools where available. Every material change must be traceable to Change Control, implementation SHA/migration, automated database/API/security/browser UAT, rollback and final gate status. Security is the primary acceptance gate. Do not infer publication authority from data availability. Do not use Pilot state as Production truth. Do not bypass CI/CD or privileged access controls for convenience.

Recommended naming: **CourseFinder — Production Control Room**.
