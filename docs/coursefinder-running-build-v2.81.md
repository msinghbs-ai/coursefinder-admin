# CourseFinder Running Build v2.81

**Status:** M1 FROZEN / M2.1–M2.4 CLOSED-PASS / M2.5 ACTIVE-READINESS  
**Date:** 1 September 2026  
**Supersedes:** `docs/coursefinder-running-build-v2.80.md`  
**Master Project Plan:** `docs/coursefinder-master-project-plan-v1.81.md`  
**Active Change Control:** `CF-CHG-20260901-049`

## Integration read back (S1-Build, 26 Nov 2026 12:35 AEDT)

- s1195 (#1652), #1577, #1589, #1597 and #1600 merged; the three S3-AER migrations applied live. Head `20261129080000`, G3 75/48, locks 7,585, cron 136.
- Adelaide: s1196 proposed (retired hosts kept out of relink and the site-map binder); the discontinued-course decision is the Platform Admin's.

## Converter fix and PR integration (S1-Build, 26 Nov 2026 11:15 AEDT)

- **s1195:** converter `lean-md-v3` takes out escaped tags (Holmesglen), worker v1.0.47, no migration; no page re-read for the new version.
- **S3-AER PRs #1577, #1589, #1597 and #1600:** rehearsed together, merging on green in version order; #1502 held.
- **Branch inventory:** 2,107 of 2,492 branches safe to remove; decision with the Platform Admin.

## Window 5 result (S1-Build, 26 Nov 2026 10:15 AEDT)

- **s1193 live (Pilot #1648):** Window 5 read 346 courses that pass the proven sibling page, by 10:07.
  - 57 filled: 113 active rows at 47 providers, all published.
  - 269 to Layer 4 (923 proposed rows); 20 held by the read gate or row rules; 0 failed.
  - US$0.79 on gpt-4.1-mini; Firecrawl $0.
- **Verified:** `website_v2_course('120328M')` returns its admitted requirements under `item.entry`. The AI gate and recorder accept the proven sibling page unattended.
- **s1194 live (Pilot #1650, 10:26):** Window 5 closed (route off, request closed); read back.

## Deterministic admission recovery, verified (S1-Build, 26 Nov 2026 08:55 AEDT)

- **s1192 live 08:39:** first canonical admission under the approved rule (082307B), consumer read-back verified.
- **Remaining deterministic blockers:**
  - 370 active rows already exist (no overwrite);
  - 422 rows at confidence 0.70 below the 0.80 machine threshold, so Layer 4 decides;
  - 6 gate incomplete (the reader dropped printed requirements).
- **s1193:** Window 5, 346 courses that pass the proven sibling page, in release.

## Deterministic admission recovery (S1-Build, 26 Nov 2026 08:40 AEDT)

- **s1192 (Pilot, migration `20261129010000`):** proven sibling page in `security.aer_machine_check_v1`, `security.enrich_fields_slice_v1` (entry only) and `security.enrich_entry_record_v1`; the 20 s1191 proposals checked through the existing machine admission.
- **Blockers of the 512 pending deterministic proposals:**
  - 370 active rows already exist (no overwrite, a person's decision);
  - 122 every row fails a row rule;
  - 20 identity, fixed by s1192.
- **Chat convention:** from 26 Nov 08:27, every response starts with Chat / Agent / Model / Reasoning effort / Assignment and ends with a HANDOVER block (Agent Operating Model).

## Development closure (S1-Build, 26 Nov 2026 07:55 AEDT)

- **Delivered functionality (course entry, S1-Build lane):**
  - gpt-4.1-mini qualified for course entry requirements on source-verified labels (whole page; s1151, s1154).
  - Bounded read windows on the existing route: US$0 daily cap, one scoped on-demand request each, route off after each window (s1154 to s1159, s1190).
  - $0 retirement of superseded corrections (s1157).
  - Window selection by the read gate's own identity and page checks (s1159).
  - Proven sibling-page identity for academic entry requirements in the deterministic proposer (s1191, Platform Admin decision 06:57).
  - Recall diagnostics for the selector (s1152).
  - Hourly delivery measure (Daily Executive Status).
- **Deployed PRs:**
  - Pilot: #1611, #1614, #1615, #1617, #1619, #1621, #1638, #1640, #1641, #1642, #1644.
  - Admin: #1081 to #1129.
- **Verified in production:**
  - Last 24 h at 07:29 AEDT: 212 courses newly populated, all published; 1,180 entry rows admitted; conversion 12.9%; US$0.012 entry AI per new course. AU backlog 14,138, clearance about 67 days at that rate (796 at 04:38).
  - s1191 live 07:40: 69 deterministic pages released. 40 courses proposed from their own stored readings (48 rows; no row copied from a sibling); 23 no row.
  - Route off and no session request open. G3 75/48, locks 7,585, cron 138. Platform AI today US$1.54 of US$5.00; Firecrawl 0 for every window.
- **Outstanding acceptance criteria (not complete):**
  1. s1191 canonical admission of the 40 proposals and consumer read-back (`website_v2_course`): **not verified.**
     - At 08:06 AEDT the 40 were still pending in Layer 4.
     - Deterministic (`aer_det`) proposals are not taken by the machine admission. Of all of them ever made, 12 were approved, all by a person; 512 are pending.
     - Dependency (protected, Platform Admin): Layer 4 decisions, or an approved machine-admission rule for deterministic entry proposals.
  2. The proven sibling-page rule in the AI read gate (`security.enrich_fields_slice_v1`) and AI recorder (`security.enrich_entry_record_v1`), for the 2,028 never-AI-read identity-held courses. Shared identity code; S2-AER to agree.
  3. Holmesglen escaped-markup converter fix (`lean-md-v3`), after a check that no lane reads pages again on the version change.
- **Operational backlog and owners:**
  - AU entry no page (5,432) and page bound not stored (1,503): S1-Build course pages; capped revisits are S1-RM-Design s1171.
  - Read with no admissible rows (7,056):
    - pages that state none (1,962): terminal;
    - superseded losses (1,425): the EQUALS decision, S1-RM-Design and Platform Admin;
    - identity-held: S1-Build and S2-AER under s1191.
  - Layer 4 (651 pending): Platform Admin, with the existing machine admission.
  - Further course entry windows run through the same bounded mechanism, inside the daily limit.
- **Known CI fault:** the Secret scan check-run can stay "in progress" after its workflow ends, blocking auto-merge (admin #1127, Pilot #1644). An empty commit restarts it.

## Chat handover (S1-Build, 26 Nov 2026 05:40 AEDT)

- **Windows:** Window 3 done (46 admitted, US$0.223). Window 4 (s1159) reads the 131 courses that pass the read gate's own checks. Always filter on `security.course_page_check_v1` and the entry identity rule, so no slot is spent on a page the gate refuses.
- **Blocking decision:** identity for pages shared by one programme's records (`p0-aer-activation/2026-11-26-entry-identity-shared-programme-pages-decision.md`). Option 2 releases 90 courses at $0.
- **Hourly measure:** the probe used each hour reads active `course_entry_requirements` rows by creation time, first active row per course and provider, and entry item outcomes, plus the AU lifecycle from `security.pim_lifecycle_v1`.

## Chat handover (S1-Build, 26 Nov 2026 04:45 AEDT)

- **Mandate:** Platform Admin 26 Nov 03:59 AEDT, accelerated production delivery. S1-Build prioritises extraction and admission bottlenecks alongside model qualification, and reports delivery hourly (Daily Executive Status).
- **Course entry route:** gpt-4.1-mini qualified (whole page, source-verified criteria, 25 Nov 18:26). It is opened only in bounded windows: a US$0 daily cap keeps the scheduled reader held, and one scoped on-demand request covers each window.
- **Windows so far:** Window 1 (172) done. Window 2 held for spend (s1156). Its remainder is s1157: 130 superseded corrections skipped, 7 read.
- **Next for S1-Build:** Window 3, the AU courses read with no admissible rows and never AI-read, shortest stored pages first under a stated spend bound. Then the `exact_title` identity evidence for the Platform Admin: 521 courses, 4,735 deterministic readings.
- **Not S1-Build:**
  - capped page revisits: S1-RM-Design s1171;
  - the 1,425 superseded losses: the EQUALS decision;
  - Layer 4 (571 pending): the Platform Admin.

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


### M2.5 CF-061 — QILT / PRISMS Provider & Course comparison experience

Pilot source has advanced to **v2.15.21** for a bounded contextual comparison experience modelled on the interaction pattern shown in the user-supplied ComparED references while retaining CourseFinder branding and authority rules.

Implemented:
- Provider and Course **Compare** workspace, maximum six selections;
- Catalogue and detail-blade Compare entry actions;
- like-for-like QILT alignment by survey + metric + study level + study area + collection period;
- QILT confidence interval, response count and national benchmark where stored;
- PRISMS contextual comparison retaining actual Provider/geography/study-area/cohort grain;
- responsive desktop/tablet/mobile layout;
- no Search, Publication or Zoho admission change.

Pilot migrations:
- `20260901133212_cf_061_contextual_compare_qilt_prisms.sql`;
- `20260901134059_cf_061_contextual_compare_provider_city_fix.sql`;
- `20260901134137_cf_061_contextual_insights_study_area_code_fix.sql`.

Live read validation:
- 3-Provider comparison PASS;
- 2-Course comparison PASS;
- Course QILT remains `provider_context`;
- 7-item request rejected by six-item boundary;
- unauthenticated read rejected;
- Security **147 INFO / 0 WARN / 0 ERROR**;
- Performance **175 INFO / 0 WARN / 0 ERROR**.

Permanent source/build contract:
`tests/uat/cf-061-qilt-prisms-comparison-contract.spec.mjs`.

Source/build trigger `b423af67af6917ae3407e3f5137dcd403d0da225` passed targeted Chromium desktop in workflow `33515174810` / job `99880438005`, including the full frontend build. Deployed comparison trigger `35fef88e07cff9e7d6e568d740c31722c3c3720e` passed workflow `33515683960` / job `99882055173` and proved Worker v2.15.21. Responsive recheck `90123d162103e707473ac8eb7a7a226cade51280` passed workflow `33515936377` / job `99882833322`, including explicit 900px tablet and 390px mobile viewport checks. CF-061 is IMPLEMENTED / TARGETED PASS.


### M2.5 CF-063 — QS / THE World University Rankings

Status: **DESIGN ACCEPTED / IMPLEMENTATION PENDING**.

Added governance/design for publisher-authoritative institutional ranking context:
- QS WUR 2026 and 2027 current targets;
- THE WUR 2026 current target;
- historical backfill target of 5–10 years where official publisher access/reuse permits;
- private editioned ranking domain rather than scalar Provider rank columns;
- exact/tied/banded/unranked semantics;
- methodology/source revision/Evidence retention;
- publisher-institution → canonical Provider crosswalk;
- Provider-level cards/history and Compare design;
- explicit separation from Course quality, regulatory identity and undisclosed Search relevance.

New design baselines:
- `docs/coursefinder-university-ranking-data-design-v1.0.md`;
- DB Architecture `v2.10.46`;
- Admin/PIM Decisions `v1.26`;
- A29;
- CF-CHG-20260902-063.

No ranking migration, source ingestion, Provider mapping, UI implementation or consumer admission has been performed yet. Follow-ups M25-FU-029 through M25-FU-035 own implementation.


### M2.5 CF-073 — Administration Acquisition route render-crash correction

A user-reported browser regression on `/#administration?section=layer2-providers` was corrected without reopening M2.4.

Root cause in v2.15.30: the rank-5+ `Layer2ExecutionPolicySettings` renderer referenced Lucide `ShieldCheck` without importing it. The synchronous render exception could unmount the React route tree, leaving browser Back/Forward to change hash URLs while the application stayed blank until reload.

Pilot **v2.15.31** now:
- imports `ShieldCheck` explicitly;
- retains all existing Layer 2 rank/credential/policy boundaries;
- adds a route-keyed workspace error boundary so future route-local render faults keep the Admin shell recoverable;
- permanently tests the reported Acquisition hash and browser Back recovery.

Accepted source: `Coursefinder-Pilot@c546c2c3bf87e41154a2c5f5d7b6d554026deba4`.
Frontend build `33590571059` PASS; build job `100123554410` PASS; browser-smoke job `100123640329` PASS.
Deployed targeted UAT `33590571041` / `100123554544` PASS, **1 passed (4.6s)** on Worker v2.15.31.


### M2.5 CF-081 — Consolidated Layer 2 acquisition, Scholarship seed & Provider assets

CF-081 is **APPLIED / TARGETED PASS — DATA POPULATION CONTINUES** in Pilot.

Pilot migration: `20260902132027 cf_081_layer2_consolidated_acquisition_scholarship_assets`.

Implemented:
- one source can support multiple versioned Layer 2 extraction profiles;
- shared same-URL Evidence cache + downstream fan-out queue;
- Provider asset/logo candidate + approved-asset domain;
- 933 AU/NZ Provider Scholarship profiles and 933 Provider-logo profiles seeded from first-party `web_catalogue` anchors;
- 7,464 acquisition routes across Direct HTTP / disabled Parse.bot / Firecrawl / ZenRows for those new profiles; 933 existing Course profiles sharing the same sources are now shared-fetch enabled;
- Parse.bot registered disabled with no fabricated endpoint or credential;
- `layer2-acquire-v2` upgraded to v10; successful acquisitions register shared Evidence and subsequent sibling requests can return at zero vendor cost inside TTL;
- Study Australia full refresh reduced from daily to weekly; DFAT to monthly; Scholarship maintenance to weekly;
- bounded Study Australia bootstrap pages 6–20 completed HTTP 200, raising canonical Scholarships 54→180 and source records 114→240.

Pilot source refs:
- worker change `e3d3109734306701fe6c63acbc2472e47dc06d95`;
- migration source `24ed81365d2ae2e7cb410b8c67b806a83adbb647`, FK-index hardening `93ea860691186c89ecc13eefd107289dac28a096`, shared-profile routing `c32c0d366eb7afa200b0ed64ce757a149afdf368`.

No Search/Website/Zoho Scholarship/logo admission is authorised by this change.


### M2.5 CF-083 — Scholarship catalogue→detail acquisition and Provider asset promotion

Status: **IMPLEMENTED / TARGETED PASS — CONTROLLED DATA POPULATION CONTINUES**.

Pilot source head after committed CF-083 migrations: `Coursefinder-Pilot@8fbcb36f76c52af7cd535adb910c7f2116378c66`.

Implemented:
- private `provider-assets` bucket and governed Provider asset promotion worker/RPCs;
- CQUniversity and Edith Cowan University promoted as approved primary Provider logos;
- Scholarship source grain split into `scholarship_catalogue` and `scholarship_detail`;
- catalogue pages are enumeration-only and are blocked from individual Scholarship extraction;
- `pipeline.scholarship_catalogue_runs` completeness ledger;
- dedicated catalogue enumerator;
- detail extractor hardened through v1.6 for stable first-party URL identity, award/date quality and scope-review flagging;
- Scholarship `scope_resolution` added to the existing Layer 4 field registry;
- six first-party detail records applied as canonical Provider-linked unpublished Scholarship roots;
- six pending Layer 4 scope reviews;
- no fabricated cycles/windows/scopes and no consumer publication.

Bounded UAT:
- 7/7 catalogue acquisitions HTTP 200: 3 Direct HTTP + 4 Firecrawl;
- catalogue enumeration: ACU 0 needs-review, ANU 0 needs-review, CDU 5, Charles Sturt 14, Curtin 14, Deakin 6, ECU 13;
- 52 catalogue links recorded;
- 6/6 selected individual detail acquisitions HTTP 200;
- extracted award examples: 25%, 30%, 15%, AUD 1,000 and 50%;
- canonical Scholarships increased from 180 to 186;
- 0 unmapped Providers in canonical dry-run/apply;
- all six new canonical records remain unpublished.

Post-change changed surface: Security/Performance **0 WARN / 0 ERROR**. Two new catalogue-run FK-index INFO findings were corrected.

Authority:
- CF-CHG-20260903-083;
- A32;
- DB Architecture v2.10.49;
- Admin/PIM Decisions v1.30.

No Search/Website/Wix/Zoho Scholarship or logo admission is authorised.


### M2.5 CF-084 — Environment, credentials & Production Supabase migration controls

Status: **IMPLEMENTED / TARGETED PASS**.

Pilot UI v2.15.43 adds `Administration → Environment & Migration`.

Implemented:
- Parse.bot endpoint/API-key provision using the existing write-only Layer 2 Vault credential path;
- Firecrawl quota/rate/reserve editable as governed provider configuration;
- Scrape.do, ScraperAPI and ZenRows central credential/settings access;
- OpenRouter credential access through the established Layer 3 provider-control path;
- Apollo moved to prefer an Admin-managed Vault credential, retaining legacy Edge env fallback during transition;
- Production target organisation/project ref/project URL/region/Admin origin/Website origin metadata;
- private environment/integration/migration registries;
- Production migration manifest covering Database/Auth, Vault, Storage, Functions, secrets, Auth/API keys, cron, extensions, origins, Evidence links and later consumer integrations;
- release notes advanced to v2.15.43.

Pilot portability telemetry:
17,400 Evidence rows / 17,626 Storage objects / 14 cron jobs / 7 Vault secrets / 0 absolute Evidence Storage paths / 0 Pilot Supabase URLs embedded in Evidence source/metadata.

The recorded Firecrawl monthly limit remains 5,000 until Platform Admin enters the user's newly increased vendor entitlement. CF-084 does not guess the new value.

Parse.bot remains disabled until trial endpoint/key and bounded adapter UAT are supplied.

No Production project is created and no consumer cutover is authorised by CF-084.


CF-084 follow-up hardening also removes hard-coded Pilot Supabase URLs from executable database→Edge dispatch helpers. Runtime Edge base URL and automation-credential selection are Admin-managed per environment.

Zoho and Website bearer tokens are now included in Environment & Migration as current-environment write-only rotation controls. Their private tables retain only SHA-256 hashes, so Production requires new token rotation rather than Pilot-token migration.


CF-084 acceptance evidence:
- accepted Pilot source `076a0e40047bfe7bbb146d868e44a569d6bb9c57`;
- frontend build `33695621150` PASS;
- deployed targeted UAT `33695621166` PASS;
- Security 174 INFO / 0 WARN / 0 ERROR;
- Performance 209 INFO / 0 WARN / 0 ERROR.

### CF-085 — Firecrawl quota streamlined into Scraper Config

Administration → Acquisition is renamed **Scraper Config**. Firecrawl monthly entitlement and safety reserve are now first-class editable fields in the Firecrawl provider drawer, with read-back verification. Layer 2 execution policy remains the effective readout for usage/wave clamping and no longer implies quota ownership. Environment & Migration no longer duplicates Firecrawl quota editing. UI version advances to v2.15.44.

## M2.4.5 CF-091 planned surfaces — 3 September 2026

Added to active pre-Production backlog:
- complete first-party Provider logo coverage with evidence/approval telemetry;
- Hotcourses sitemap/navigation review for discovery/reconciliation only;
- ARWU as a first-class multi-year institutional ranking, initial 2025 edition;
- University Diversity/HDI as a separate contextual university-statistics dataset;
- ranking acquisition by both uploaded parser and governed API/Parse.bot adapter using one validation/apply contract.

No CF-091 runtime/schema change is claimed by this Running Build entry. Current accepted DB Architecture remains v2.10.50 and Admin/PIM Decisions v1.31.
