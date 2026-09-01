# CourseFinder Running Build v2.81

**Status:** M1 FROZEN / M2.1–M2.4 CLOSED-PASS / M2.5 ACTIVE-READINESS  
**Date:** 1 September 2026  
**Supersedes:** `docs/coursefinder-running-build-v2.80.md`  
**Master Project Plan:** `docs/coursefinder-master-project-plan-v1.81.md`  
**Active Change Control:** `CF-CHG-20260901-049`

## Accepted Pilot source candidate

`msinghbs-ai/Coursefinder-Pilot@95f2991e97e76e644bd74f73512b8bf2725fd4b7`.

This is the accepted source/deployment candidate entering M2.5. It is **not** Production truth.

Final M2.4.4 evidence:
- build `33468512538` PASS;
- acceptance `33468512515` PASS;
- desktop 75 passed;
- mobile 76 passed;
- Security 146 INFO / 0 WARN / 0 ERROR;
- Performance 172 INFO / 0 WARN / 0 ERROR.

## Production readiness state

No CourseFinder Production Supabase project exists.

Visible projects:
- `coursefinder_Pilot` / ap-south-1;
- `coursefinder-demo` / ap-southeast-2;
- unrelated inactive `ARR`.

Visible organisation:
- `techM` / `rszbvkqopqfvjldvfnbh`.

Production project:
- project ref: NOT PROVISIONED;
- region: NOT APPROVED;
- supplier cost: NOT QUOTED/CONFIRMED;
- Auth: NOT ESTABLISHED;
- Storage: NOT ESTABLISHED;
- Vault/secrets: NOT ESTABLISHED;
- Production CI/CD: NOT ESTABLISHED;
- Cloudflare Production: NOT ESTABLISHED;
- restore/DR: NOT PROVEN;
- Production UAT: NOT RUN.

## M2.5 rule

Do not:
- rename or promote Pilot to Production;
- reuse Pilot secrets blindly;
- create billable Production resources without required confirmation;
- infer Production security from Pilot acceptance.

## Production mandatory security

`CF-CHG-20260823-022` leaked-password protection must PASS in Production.

Production also requires:
- Auth/RBAC/session regression;
- RLS/grants/views/RPC/SECURITY DEFINER audit;
- anon/negative tests;
- private Evidence;
- server-only secrets;
- Security Advisor disposition;
- restore/rollback proof;
- SHA-bound Production acceptance.

## Scheduling

16–30 September 2026 remains a no-planned-delivery blackout. M2.5 engineering baseline remains 12 planned hours.

## Parallel work

Zoho Creator Pilot `CF-CHG-20260827-045` remains ACTIVE/PARTIAL and separate. No Zoho Production cutover is authorised by M2.5 readiness.

## Platform maturity design baseline

No runtime change is asserted by CF-CHG-20260901-050.

Future controlled backlog:
- PM-A1 Country & Source Onboarding Maturity;
- PM-A2 Provider Collections / G8;
- PM-A3 Scholarship Relationship Operations;
- PM-A4 Manual Intervention & Blocking;
- PM-A5 Manual Entity Creation;
- PM-A6 Scraper Onboarding Framework;
- PM-A7 AI Onboarding Framework;
- PM-A8 Storage, Capacity & Notification;
- PM-A9 Retention, Purge & Housekeeping;
- PM-A10 Consumer Cache & Dataset Versioning;
- PM-A11 Platform UAT Catalogue;
- PM-A12 Performance & Workload Isolation.

See `docs/coursefinder-platform-maturity-design-v1.0.md`.

## M2.5 Pilot corrective state

Layer 2 run observability is corrected under `CF-CHG-20260901-052` without reopening M2.4.

Current Pilot source head at this checkpoint:
`9fa8f590c8370bf600f1495794f9205fabbdf8a7`.

Admin UI version:
**v2.15.15**.

Deployed correction:
- `20260901062200 m2_5_layer2_run_observability_correction`;
- terminal production parents retain child Jobs/Evidence after wave items become completed/failed;
- acquisition attempts and managed runs display timestamps;
- active work is separated from latest terminal production history;
- qualification retry-window no-op checks return `qualification_waiting`;
- post-action operator refresh errors are visible.

VIC proof:
- historical request `1bb1504d-7bad-42d9-b059-4adeaf9118c7`: 261 total / 42 completed / 219 failed;
- retained lineage: 261 Jobs / 783 Evidence artifacts;
- bounded check `c876a8fb-5f03-4433-85ab-5af7e96cee63`: zero eligible Providers, zero new production wave requests, zero new Course Jobs.

CF-052 targeted deployed UAT:
- run `33477539721`;
- job `99760830965`;
- Chromium desktop: **2 passed / 0 failed**.

Post-change advisors remain:
- Security 146 INFO / 0 WARN / 0 ERROR;
- Performance 174 INFO / 0 WARN / 0 ERROR.

## Next

Obtain explicit organisation + Production region confirmation, then obtain and confirm Supabase project cost before provisioning the Production project.


### M2.5 CF-057 — universal Layer 4 block enforcement

CF-057 deploys server-side enforcement for the reversible Layer 4 block ledger without deleting source/canonical data.

Pilot migration:
`20260901211500_m2_5_universal_layer4_block_enforcement.sql`
(commit `f97c1aa2040890e9a49c1ddf38a9755700b0fee3`).

Implemented owners:
- Layer 2 Course Fact apply operational block;
- Layer 3 interpretation/source-pattern operational block before model call;
- publication readiness and publishable decision;
- 20 Website/Zoho/legacy Search/read contracts;
- secured Data Quality quarantine read.

Provider-level Search/quarantine blocks inherit to child entities. Layer 1 regulatory source recording remains unaffected. Rollback-only live UAT left zero retained block decisions. Security remains 146 INFO / 0 WARN / 0 ERROR and Performance 171 INFO / 0 WARN / 0 ERROR.

Permanent targeted contract:
`tests/uat/m2-5-layer4-block-enforcement-contract.spec.mjs`.


### M2.5 CF-058 — Platform maturity Administration surface

CF-058 replaces the canonical Administration → Platform legacy surface in repository source with a responsive M2.5 Platform workspace.

Pilot server migration:
\`20260901220500_m2_5_platform_maturity_admin_read_surface.sql\`
(commit \`ded6ff03156126aa66e5d1ca2914e2e62e337a77\`).

Source version has advanced to **PIM Admin v2.15.20**. The workspace exposes governed readiness, capacity/integrity, environment gates, UAT catalogue, performance/workload profiles, retention dry-run/classes and CF-057 block controls. It does not expose Production enablement, PITR purchase, destructive purge or consumer cutover.

Latest sampled Pilot telemetry:
- DB 632,933,523 bytes;
- Evidence 10,546 objects / 5,224,808,213 bytes;
- 8.11% of governed 60 GiB Evidence planning envelope;
- CF-059 now preserves that raw history but reconciles the 5 historical orphan objects and 2 legacy missing-path references; current unresolved integrity is 0 / severity OK.

Post-DDL advisors remain Security 146 INFO / 0 WARN / 0 ERROR and Performance 171 INFO / 0 WARN / 0 ERROR.

Permanent source/build contract:
\`tests/uat/m2-5-platform-maturity-admin-contract.spec.mjs\`.

Deployed UI acceptance is not claimed because FU-015 still proves Cloudflare Worker deployment drift.


### M2.5 CF-059 — Evidence lineage reconciliation & Provider-contact claim hardening

CF-059 closes the known FU-009 provenance population without deleting or rewriting historical Storage/Evidence.

Pilot migration:
\`20260901224000_m2_5_evidence_lineage_reconciliation_contact_claim.sql\`
(commit \`b98776b45ff21520933674fb448aa3eba2fa5fa4\`).

A private reconciliation ledger records:
- five explained historical Storage orphans;
- two legacy Canadian management-plane Evidence references.

Latest Pilot integrity:
- raw unlinked Storage objects 205;
- fingerprint duplicates 200;
- reconciled historical orphans 5;
- unresolved orphans 0;
- raw missing bucket refs 2;
- reconciled legacy refs 2;
- unresolved missing bucket refs 0;
- integrity severity **OK**.

Provider-contact scheduled discovery is now source v1.3.4 / Edge v19 and uses atomic leased claims so overlapping scheduled invocations cannot select the same profile. Failed Evidence registration cleans only the just-uploaded object via the Storage API.

Rollback-only UAT proved overlapping claim exclusion, wrong-token rejection, lease expiry/reclaim and correct claim clearing. Live active claims are 0.

Post-change advisors:
- Security 147 INFO / 0 WARN / 0 ERROR;
- Performance 175 INFO / 0 WARN / 0 ERROR.

Admin/release source version has advanced to **v2.15.20** and the Platform capacity view displays raw, reconciled and unresolved lineage separately.

Permanent contract:
\`tests/uat/m2-5-evidence-lineage-reconciliation-contract.spec.mjs\`.

Deployed browser acceptance remains separately blocked by FU-015.


### M2.5 CF-060 — Jobs workspace read-path restoration

Deployed user UAT on v2.15.19 exposed a canonical Jobs regression: the page displayed 0 rows even though the live pipeline held 3,964 Jobs.

Root cause was browser-side only. The governed read helper still suppressed `jobs` and `sources` reads when the current hash matched those routes, a compatibility rule from a Pipeline Ops overlay that is no longer mounted.

Repository source v2.15.20 now:
- mounts the existing server-paged governed Pipeline Jobs workspace directly from canonical navigation;
- uses `pipeline_jobs_page`, `pipeline_filters` and `pipeline_job_detail`;
- displays current/history Layer, mode, status, source/provider, counts, Evidence, duration/cursor and timestamps;
- removes the obsolete route-based empty-result suppression;
- mounts the governed Sources workspace directly as well.

No DB migration or new mutation authority is required.

Permanent contracts:
- `tests/uat/m2-5-jobs-workspace-read-path-contract.spec.mjs`;
- `tests/uat/m2-5-jobs-workspace-deployed.spec.mjs`.

Source trigger `97c3679d8304c36e10ae6e5b74d6cc99a2834152` launched workflow `33511601936` and frontend build `33511602057`; both were still pending/queued at handover.
