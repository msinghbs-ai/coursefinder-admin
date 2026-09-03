# M2.4.5 CURRENT STATE

**Status:** ACTIVE / H1 TARGETED PASS — H2 UI TARGETED PASS / PARSE.BOT AUTH BLOCKED  
**Updated:** 2026-09-03 12:47 AEST  
**Change Control:** CF-CHG-20260903-087

## Entry baseline

- M2.4.4 remains CLOSED / PASS / FROZEN.
- M2.5 Production readiness was reconciled at 2026-09-03 10:13 AEST and remains blocked at P0 because no Production Supabase project exists and Production organisation/region/name/cost are unconfirmed.
- M2.4.5 is inserted to complete Pilot/Admin/PIM hardening before P0 resumes.
- Pilot repo head at intake: `ce8ab734a1d4bb4743b09b09f3ae45a47bb9d7dc`.
- Admin repo pre-M2.4.5 head: `3dec3218abceca6ec7139c6fa931d931fd9be805`.
- targeted deployed UAT on Pilot head: SUCCESS, run `33696909480`.

## Initial priorities

P1. Admin IA/UI simplification and duplicate-setting audit.  
P2. Scraper Config enable/disable + effective routing consolidation.  
P3. Scholarship PIM grid/filter/order maturity.  
P4. Scheduler/Jobs operational review.  
P5. Manual PIM record pattern.  
P6. Publication automation control plane, disabled by default.  
P7. Production migration inventory/telemetry update after each material change.  
P8. Faster targeted UAT.  
P9. Milestone meeting evidence/time-interaction ledger.


## H1/H2 execution state — 2026-09-03 10:45 AEST

- Pilot source advanced to H1/H2 lineage ending `87eba42de1e03c9761b927f2cb59a793cd10215f` before final workflow routing.
- Visible Admin release: **v2.15.45**.
- H1 implemented under CF-088. Administration labels/ranks/breadcrumbs/cards share one metadata model. Users & Roles is embedded in Administration; legacy `#users-roles`, `#attributes` and `#settings` resolve to canonical sections.
- Historic rank-3 Scheduling/Onboarding hidden routes remain because central Administration is rank 4; redirecting them would alter permissions.
- H2 runtime inventory: Direct HTTP, Scrape.do, ScraperAPI, Firecrawl and ZenRows enabled; Parse.bot and Custom gateway disabled. Firecrawl records 5,000 monthly units / 250 reserve / 30 requests-min / concurrency 5 / 90s timeout.
- Production migration manifest: all tracked components source-ready; all target states pending. No Production project exists.
- Pilot roles remain viewer 1, counsellor 2, curator 3, pipeline_operator 4, PIM Operator 5, Platform Admin 6.
- H1 targeted validation PASS: Frontend Build `33700864619`; Deployed UAT `33700864824`. No full acceptance run requested.

## H2 corrective implementation — 2026-09-03 11:39 AEST

- User-enabled Parse.bot is now confirmed in runtime: enabled, Vault credential configured, base `https://api.parse.bot`, `X-API-Key`, priority 25, rate 30/min, concurrency 10, timeout 90s.
- Official Parse API contract requires dispatch/build then generated scraper endpoint execution; the prior generic-proxy assumption was invalid.
- CF-089 prevents Parse.bot from being called as a generic URL proxy until a generated API route is qualified.
- A live server-side Parse.bot connection probe was added and targeted deployed UAT is executing it.
- Scraper Config no longer eagerly reads the complete Layer 2 source-profile inventory. Profile routing is lazy and bounded to 10 searched matches.
- Scraper Config embedded header/Refresh/typography aligned to canonical Administration.
- `Layer 2 sources` relabelled **Extraction Profiles**; it remains the advanced source-specific extraction-rule/version/qualification workspace.
- Layer 2 policy is reduced to **workload defaults** behind progressive disclosure; its legacy route mode is read-only in Admin so it no longer acts as a parallel routing writer.
- Pilot runtime migrations CF-089 applied; Edge versions: provider-control v2, acquire-v2 v11, scope-discover-scheduled v21.
- No Production project/resource created; Production migration target states remain pending.

## CF-089 targeted closure — 2026-09-03 11:50 AEST

- Accepted Pilot head: `b6f75ffccf93981522a5c077100deeac87f7022a`.
- Deployed targeted UAT `33705175873`: PASS.
- Frontend build job in `33705175916`: PASS.
- Parse.bot real authenticated diagnostic: HTTP 401 / `authentication_failed`.
- Interpretation: CourseFinder can reach the official Parse API, but the currently stored Vault key is not accepted. Parse.bot stays enabled as configured by the user but is explicitly **not execution-qualified** and is excluded from generic proxy execution.
- Scraper Config performance issue is corrected: 7-provider registry loads first; 1,883 extraction profiles / 12,207 route mappings are no longer eagerly loaded. Profile routing is opened on demand and search is capped at 10 results.
- Scraper Config header/Refresh/typography and workload input layout now use canonical Administration patterns.
- Layer 2 Sources is now presented as **Extraction Profiles** to describe its actual purpose: versioned non-secret source-specific extraction rules and qualification state.
- Layer 2 workload defaults remain advanced scheduler/batch/wave controls, not scraper routing; the legacy route mode is read-only there.
- Production remains unprovisioned; CF-089 portability delta is recorded in CF-084.


### CF-090 ranking import recovery

User upload `THE_year2026.txt` is confirmed present as private ranking Evidence (3,966,028 bytes; SHA-256 `00fdcfa0a2d5067982c9b7631e5baa7dc64e683c0c0280a1a02730edb45112fa`). Registration succeeded; the subsequent Parse & validate control failed because `ranking-publisher-control` attempted PostgREST access to the intentionally unexposed private `ranking` schema. The control now uses service-only RPCs instead. QS/THE Statistics cards are no longer grey merely because accepted_editions=0; they remain actionable with Manage imports while Compare remains gated on accepted observations. Admin release **v2.15.47**. Targeted recovery UAT is active and will reuse the existing THE 2026 Evidence.

## CF-091 addenda — 2026-09-03 12:47 AEST

- H11-H13 added to M2.4.5 for Provider logo completeness/source discovery, ARWU + University Diversity statistics, and ranking parser/API/Parse.bot acquisition.
- Hotcourses rankings hub currently exposes THE, QS, ARWU and Hotcourses Diversity Index; Hotcourses HDI presents diversity rank, represented nationalities, international-student counts and source attribution.
- Existing A31/A32 source-authority rule remains: Hotcourses/commercial aggregators are reconciliation/discovery by default unless explicit reuse authority is approved.
- Initial ARWU target is 2025 with multi-year edition retention.
- Diversity Index is to remain a separate contextual dataset rather than being flattened into QS/THE/ARWU ranking semantics.
- API/Parse.bot ranking fetch must converge with uploaded-file parsing into the same staging/validate/apply gate; credentials remain Vault-only.
- CF-083/A32 repository cross-reference reconciliation is already complete. Current docs are v2.10.50 / v1.31, not v2.10.49 / v1.30.
- No runtime/schema/Production change made by CF-091.


## Execution priority — 2026-09-03 12:59 AEST

Immediate workstream order is now **H11 → H12 → H13**.

Parked without closure:
- H2 residual Parse.bot authentication/qualification blocker;
- H3 Scholarship PIM maturity;
- H4 Scheduler/Jobs;
- H5-H10 remaining/continuous hardening.

Important dependency rule: the current Parse.bot HTTP 401 does **not** block H11, H12 or H13 uploaded-file/parser implementation. It blocks only live Parse.bot-generated API qualification/execution until the credential is corrected.


## CF-092 Parse.bot ranking API decision — 2026-09-03 12:59 AEST

H13 live Parse.bot design is now dataset-specific rather than generated/generic:
- QS established `get_world_rankings` API;
- ARWU established `get_arwu_rankings?year={YEAR}` API with `API-Snapshot-Version: 10`;
- controlled target years 2015–2026.

Current stored Parse.bot credential 401 remains the only live-call blocker. No replacement scraper is required or authorised.


## H11 Provider Assets implementation — 2026-09-03 13:39 AEST

- H11 governed Provider logo coverage/read contract is deployed to Pilot runtime and committed as migration `20260903213000_cf_091_h11_provider_asset_coverage.sql`.
- Administration v2.15.48 adds **Provider Assets** with expected/discovered/acquired/approved/blocked/missing coverage, country/state filters and Provider/Evidence drill-through.
- Provider detail now receives `provider_asset_context` from the governed `admin_read` boundary.
- AU broad active-Provider baseline: 1,546 expected / 7 discovered / 7 acquired / 2 approved / 1 blocked / 1,539 missing / 4 needs review.
- This is intentionally **not** described as university-only coverage because Provider Type is unpopulated across the current catalogue; final H11 university denominator needs an explicit governed scope/type crosswalk.
- Source commits: `53ea54af4fcbc941248fe506bd4360f07ce9f3f4`, `11405c9d27fb61b74aca3857a71f6fb8cf45e5fb`, `bfadc963b49b59e255c270c7ed8126b4bf040275`, `f81a6af5072f67d2f1feb71df58e50f6b6c3fd36`.
- Frontend Build run `33712087980` and Deployed UAT run `33712087970` started for head `f81a6af5072f67d2f1feb71df58e50f6b6c3fd36`; final conclusions pending at this timestamp.
- Security Advisor: existing INFO-only posture; no new WARN/ERROR identified from H11 read surface.


## Parse.bot credential revalidation — 2026-09-03 13:48 AEST

Fresh direct validation against both established CF-092 ranking APIs returned HTTP 401 `Invalid API key`:
- QS `get_world_rankings`;
- ARWU `get_arwu_rankings?year=2024` with snapshot v10.

Endpoint reachability is proven. Current Vault credential validity remains the only live H13 Parse.bot blocker.


## H13 live qualification PASS — 2026-09-03 14:29 AEST

Parse.bot credential has been corrected and the established ranking adapters now return HTTP 200.

- QS 2026: `edition_year=2026`, total 1,504, pagination contract confirmed.
- ARWU 2026: `year=2026`, total 892, snapshot v10 accepted.

H13 is no longer authentication-blocked. Next action is controlled 2015–2026 Evidence/staging/backfill implementation, with manual Apply preserved.


## CF-093 ranking publisher URL/file import — 2026-09-03 14:42 AEST

Implemented and deployed:
- ARWU first-class ranking system;
- Admin ranking import method selector: Parse.bot URL or file upload;
- QS/ARWU approved Parse.bot scraper reference fields with edition year;
- governed URL importer retains complete API response as private Evidence;
- parser v1.5.0 supports Parse.bot QS/ARWU JSON plus existing THE/file formats;
- exact import-id parsing avoids QS direct-source override;
- v2.15.49 UI;
- targeted deployed UAT run `33715985168` PASS.

QS 2026 and ARWU 2026 live APIs are qualified (HTTP 200). The remaining creation of registered 2026 imports must run under an authenticated CourseFinder Admin session; management tooling does not bypass that operator JWT boundary.


## CF-094 ranking import UX correction — 2026-09-03 14:55 AEST

- Recent imports now order by latest parse/apply activity, not original upload time.
- Successful parse disables the same system/year action until system/year changes.
- Prior success message clears on system/year change.
- Existing same-system/year registration now requires an inline **Continue with new revision** confirmation.
- No popup operational workflow introduced.
- Pilot v2.15.50; targeted deployed UAT run `33716795837` active.


## CF-095 release-currentness correction — 2026-09-03 15:57 AEST

User screenshot exposed release/version drift and unreadable QS Parse.bot failure.

Corrected:
- Admin/release/document title synchronised to v2.15.51;
- QS Parse.bot defaults to 2026;
- QS 2027 URL mode is explicitly warned/disabled because the current Parse.bot extraction returns `extraction_failed`;
- nested Parse.bot error messages no longer render as `[object Object]`;
- dedicated deployed release-currentness UAT added.

Final Pilot head `791573c4a26903ab3ed5cffe7ce8711af63efba8`.
Deployed targeted UAT `33721019815`: PASS.


## CF-096 QS 2026 Parse.bot recovery — 2026-09-03 16:13 AEST

Root cause fixed: exact-import service context omitted private `storage_path`, so the parser could not download already-registered Evidence.

QS 2026 import `05716189-91c6-4bd1-a99a-c82104e1f409` is now **validated** from retained Parse.bot Evidence:
- 1,503 candidate observations;
- 15,030 indicator cells;
- 0 unknown rank semantics;
- AU rows 36;
- mapped unique AU Providers 35 / 36 = 97.22%;
- unmatched: The University of Technology Sydney (UTS);
- Victoria University retained as equivalent-name fan-out review work.

Apply/publication remains manual. Release v2.15.52 records the correction.
