# M2.5 FOLLOW-UPS

| ID | Item | Impact | Next action | Status |
|---|---|---|---|---|
| M25-FU-001 | Production Supabase project does not exist | M2.5 deployment cannot begin | Confirm organisation, region and supplier cost; create separate Production project | BLOCKED / USER CONFIRMATION |
| M25-FU-002 | Production leaked-password protection not yet provable | Mandatory Production security gate | After project creation enable and UAT under CF-CHG-20260823-022 | OPEN |
| M25-FU-003 | Production GitHub protected environment not yet reconciled | Deployment trust boundary unproven | Inspect/create protected Production environment and SHA-bound workflow after project identity exists | OPEN |
| M25-FU-004 | Production Cloudflare origin/WAF not yet reconciled | Public runtime boundary unproven | Establish Production origin/environment/WAF only after Production app/API identity exists | OPEN |
| M25-FU-005 | Backup/restore/DR not yet proven | CF-056 reconciles Pilot project identity and paid-plan recovery capability, but current Dashboard backup/PITR state is not exposed by the tool surface and no restore has executed | Keep Production P6 open; after clean Production exists verify actual backup mode/PITR, accept RPO/RTO and run isolated restore + security/lineage checks | RECONCILED / RESTORE GATE OPEN |
| M25-FU-006 | Historical 42-Course scheduled remainder | Closure-time snapshot has progressed | VIC request is terminal: 42 completed / 219 retained acceptance-isolation/reschedule markers / 0 operational acquisition failures; 6,562 Course URLs require discovery | RECONCILED / CF-053 |
| M25-FU-007 | Zoho Pilot CF-CHG-045 remains ACTIVE/PARTIAL | Parallel integration must not be mistaken for Production cutover | Keep M3 Zoho Pilot separate; no Production Zoho secrets/cutover in M2.5 | OPEN / PARALLEL |
| M25-FU-008 | Platform maturity implementation | Pilot foundation implemented under CF-CHG-20260901-051 | Continue only authorised owning-gate work; do not reopen M2.4 | ACTIVE |
| M25-FU-009 | Evidence Storage lineage mismatch | CF-059 reconciles all remaining known 5+2 cases in a private ledger: 5 historical upload-before-registration orphans + 2 legacy management-plane references. Raw 205/2 counts remain visible; unresolved orphan/missing counts are now 0 and integrity severity is OK | Check CF-059 targeted source/build contract. No historical Storage/Evidence deletion or rewrite is authorised/required | RECONCILED / RUNTIME PASS / TARGETED CI PENDING |
| M25-FU-010 | Capacity notification target unset | Thresholds and observations exist without external escalation | Select notification channel and severity routing | OPEN |
| M25-FU-011 | Platform maturity Admin UI | CF-058 server/read surface is live; source v2.15.19 retains the CF-058 full build/source contract PASS in workflow `33507629698` / job `99855436515` | Deployed browser acceptance remains blocked by FU-015 until Cloudflare serves current main | IMPLEMENTED / SOURCE+BUILD TARGETED PASS / DEPLOYED UI BLOCKED |
| M25-FU-012 | Block enforcement not wired to all owners | CF-057 server-side enforcement + rollback UAT + targeted Chromium contract are PASS | Keep canonical block-management UI under FU-011; do not reopen CF-057 unless an owning path materially changes | COMPLETE / TARGETED PASS |
| M25-FU-013 | M2.5 targeted CI final status | Source-contract suite validated | Run 33476711758 / job 99757413769 PASS on dac23d68; retain as CF-051 targeted evidence | COMPLETE / TARGETED PASS |
| M25-FU-014 | Layer 2 run observability defect | Operator history hid terminal Jobs and lacked timestamps | CF-052 migration/UI correction deployed; run 33477539721 / job 99760830965 PASS; retain 219 VIC failures as separate Pilot ops review | COMPLETE / TARGETED PASS |

| M25-FU-015 | Pilot Cloudflare external Git deployment drift | CF-061 deployed browser run `33515683960` explicitly observed release pill **v2.15.21**, superseding the earlier v2.15.14/v2.15.19 drift evidence | Currentness is recovered; rerun any still-deferred CF-053/054/058 browser gates unchanged when their owning workstream resumes | RECOVERED / v2.15.21 CURRENTNESS PROVEN |
| M25-FU-016 | Layer 3 source-pattern operator execution | CF-054 backend/Edge/manual queue implemented; rollback/source contract `33492875364` PASS | Worker deployment has recovered to v2.15.19; rerun deployed UI acceptance only after CF-060 v2.15.20 currentness is confirmed. No real model canary without separate authorisation | IMPLEMENTED / SOURCE+ROLLBACK TARGETED PASS / DEPLOYED UI RECHECK PENDING |
| M25-FU-017 | Jobs workspace returns 0 records despite active pipeline Jobs | CF-060 found obsolete route suppression in `adminRead` after the Pipeline Ops overlay was removed; live DB had 3,964 Jobs | Check source/build runs `33511601936` and `33511602057`; after PASS trigger deployed Jobs UAT and confirm non-zero server total | IMPLEMENTED / SOURCE CI PENDING / DEPLOYED UAT PENDING |


## A17 Career Skills / Labour-Market follow-ups — 1 September 2026

| ID | Item | Impact | Next action | Status |
|---|---|---|---|---|
| M25-FU-018 | A17 reference schema | No canonical occupation/skill relationship model yet | Implement occupations, versioned codes/concordances, skills and relationship tables with RLS/grants | OPEN |
| M25-FU-019 | AU OSCA reference ingestion | AU occupation identity/versioning not yet loaded | Qualify ABS OSCA + correspondence downloads and OSCA 2027 change path | OPEN |
| M25-FU-020 | AU JSA market adapter | Market context not yet available | Qualify JSA profiles + monthly IVI; retain native ANZSCO period/geography while transition continues | OPEN |
| M25-FU-021 | NZ NOL/Tahatū adapter | NZ occupation/pathway context not yet available | Qualify Stats NZ NOL + Tahatū API/source terms and bounded Pilot adapter | OPEN |
| M25-FU-022 | Course learning-outcome Evidence | Course-acquired skills cannot be proven without first-party evidence | Extend L2 Course enrichment for learning outcomes, graduate attributes, career statements and accreditation | OPEN |
| M25-FU-023 | Layer 3 skill/occupation mapping | No governed candidate-generation task yet | Build benchmarked normalisation/mapping with negative controls against manufactured skills/jobs | OPEN |
| M25-FU-024 | Layer 4 mapping review | Consequential mappings need human resolution | Add accept/reject/adjust/note/review-date workflow with immutable source lineage | OPEN |
| M25-FU-025 | Career & Skills UX | Course blade/compare do not expose new model yet | Implement responsive Course blade + compare group with provenance/freshness/unavailable states | OPEN |
| M25-FU-026 | Registration/migration overlays | Policy/licensing can be confused with job outcomes | Implement separate time-scoped overlays, disclaimers and stale-state handling | OPEN |
| M25-FU-027 | A17 acceptance/publication gate | Consumer publication is not authorised | Run bounded AU+NZ schema/source/AI/browser/security/performance UAT and separately approve publication | OPEN |
| M25-FU-028 | QILT/PRISMS comparison deployed acceptance | CF-061 runtime/source/build/deployed comparison is PASS on Worker v2.15.21, including 900px tablet and 390px mobile viewport checks | Retain workflow `33515936377` / job `99882833322` as targeted evidence; broader M2.5 regression remains milestone-owned | COMPLETE / TARGETED PASS |


## A29 QS / THE Ranking follow-ups — 2 September 2026

| ID | Item | Impact | Next action | Status |
|---|---|---|---|---|
| M25-FU-029 | QS/THE ranking schema migration | Private ranking domain and secured read projections are now live in Pilot | Retain applied migrations as baseline; only extend through additive governed migrations | COMPLETE / TARGETED DB PASS |
| M25-FU-030 | QS 2026/2027 source qualification | Current QS editions not yet ingested | Qualify official current/year pages and authorised Excel artifact path; record terms/access and fingerprints | OPEN |
| M25-FU-031 | THE 2026 source qualification | Current THE edition not yet ingested | Qualify official 2026 table and methodology; record terms/access and source fingerprint | OPEN |
| M25-FU-032 | Ranking historical backfill | No longitudinal Provider ranking series yet | Backfill 2025/2024 first, then extend towards 5–10 years where official publisher sources remain accessible/authorised | OPEN |
| M25-FU-033 | Ranking Provider crosswalk | Publisher institution names/IDs are not yet mapped to canonical Providers | Build deterministic mapping + unresolved Layer 4 queue; do not create Providers from ranking rows | OPEN |
| M25-FU-034 | Ranking Admin/Compare UX | Provider blades/Compare do not yet show QS/THE | Add latest cards, edition selector, 5-year trend and explicit Provider-context labelling | OPEN |
| M25-FU-035 | Ranking consumer admission | Website/Zoho/Search exposure is not authorised | After Pilot acceptance, separately decide fields, filters/sort and cache/version contract; no hidden relevance boost | OPEN |


## Statistics / Compare / Manual Import follow-ups — 2 September 2026

| ID | Item | Impact | Next action | Status |
|---|---|---|---|---|
| M25-FU-036 | Statistics & Rankings workspace | QILT/PRISMS/rankings are fragmented | Implement unified coverage/year/observation/source workspace and dataset drill-downs | ACTIVE / CF-064 |
| M25-FU-037 | Compare dataset/year controls | Existing Compare assumes QILT/PRISMS and hides route | Promote Compare to primary navigation; add dataset toggles and aligned period/edition selection | ACTIVE / CF-064 |
| M25-FU-038 | Manual ranking publisher file upload | Historical paywall/access can block automation | Upload/register + private Evidence + duplicate hashing are implemented; add parser preview/reconcile/apply workflow | PARTIAL / UPLOAD REGISTRATION IMPLEMENTED |
| M25-FU-039 | Provider/Course statistics deep-links | Blades can become overloaded without hierarchy | Add concise summaries plus View Statistics / Add to Compare | OPEN |
| M25-FU-040 | Navigation/Admin reorganisation | Current menu separates QILT/PRISMS and hides Compare | IA v1.5 implemented in Pilot v2.15.23; retain targeted deployed/browser acceptance evidence | IMPLEMENTED / TARGETED UAT ACTIVE |

| M25-FU-041 | Supabase RLS advisory reconciliation | Current Supabase tool advisory reports RLS disabled on 24 tables including private pipeline control/state tables; enabling RLS blindly could break governed RPCs | Reconcile Data API exposed schemas/grants and each affected table's intended access; apply explicit RLS/policies only under security Change Control after negative-path UAT | OPEN / SECURITY REVIEW REQUIRED |
