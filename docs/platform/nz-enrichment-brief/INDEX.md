# Platform data programme — INDEX and standing state

## Current controller checkpoint — 6 November 2026

This checkpoint supersedes the historical release, PR and ownership summaries below.
Start with [Controller handover](../STUDYSEARCH-EXECUTION-REGISTER.md#controller-handover)
and [validated machine state](../STUDYSEARCH-CONTROLLER-STATE.json), then independently
verify live state under [the operating model](../AGENT-OPERATING-MODEL.md#permanent-ai-controller-continuity-6-november-2026-admin-382).

- Claude explicitly released control in [Admin #382](https://github.com/msinghbs-ai/coursefinder-admin/issues/382#issuecomment-6686299314). Atomic ref `studysearch-controller` at `6d95b3e1` records published release to Codex; owner and lease remain null, fencing adoption pending. No active production authority or completed transfer is claimed.
- Pilot main remains `4ba94e3f`, UI v2.15.489/package 0.1.416 (HTTP/asset verified19:09UTC; fullmigrationledger/helper baseline19:12UTC), coverage Worker v0.59.8/edge 239, migration head `20261106400000` with 1,791 versions. Exact Cloudflare commit and authenticated UI remain unverified.
- Final takeover candidates #895 `bcceb856`, #896 `7984e7bd`, #894 `8bde11f8`, #893 `201b9126` pass all current source/metadata checks: respectively1,951/1,951/1,967/1,992tests, zero failures/skips/flakes. Bundles are verified; #892 is integrated. Source covers8write-capable/2throwaway-only/9reporting definitions with safe credential targets and dispatch inputs. Actualaccountfencing/activeownership remains blocked by demonstrated403 and unavailableCloudflare/directSQLcontrols.
- #877/#889/#891/#887 are merged; bounded operational and authenticated operator checks remain open. #890 G3 and #875 remain held. No production release, migration or data correction occurred in this execution.
- Deadline P0: historical97non-closing/14closing/41context-required classification retained. Ten additional cohort courses/twelveintake-datepairs verified through allthreeconsumerSQLfunctions; cumulative17courses/21pairs atdifferenttimes,48courses/HTTP/cacheunverified. Original three bad values remain active19:12UTC; no correction or wider authority. [Evidence](../validation/2026-11-06-deadline-semantic-p0.json).
- Original 63 alerts: 47 historical events, 16 active, zero exact duplicates. Latest19:12UTC backlog is78pending, allunattempted (62historical events,16active acrossfiveconditions;77overdue); classification did not deliver or acknowledge alerts.
- Job-count discrepancy resolved by indexed automatic flag history:128records/87transitions, all176states match the independent17:07snapshot (163active), historical13:46aggregate164 reproduced. Current18:06count is161active/176total; do not reactivate to restore a count. Original13:46individualstates remain inferred; no universal direct-write exclusion. Last12,000cronrows cover10:43–18:07/last2h with0failures. [Evidence](../validation/2026-11-06-controller-cutover-verification.json).
- Developer guide **Issue 7** is current; Issue 8 is draft. The Issue 6 currentness line below is historical and superseded.
- Configured weekend/Monday resumptions do not establish continuous execution. Checkpoints describe actual bounded work only; no unattended monitoring, heartbeat or successor acceptance is claimed.

Record: [weekend controller mandate and findings](2026-11-06-weekend-controller-continuity.md).
The existing execution register and live integration issue queue remain canonical.

## Historical index baseline

Last updated: 2026-10-31 13:25 AEDT by Claude (main integrator), under the StudySearch transformation mandate. The sections from "Standing order" down are kept as written on 26 Oct 2026 07:40 and are history; the "Current state" section below supersedes them where they differ.
Earlier stamp: 2026-10-26 07:40 AEDT by the data-engineering agent. Overnight 08:00 report: ../ui-audit/2026-10-25-overnight-outcomes.md ("08:00 report").

**Ledger maintenance:** [Claude AER and cross-workstream reporting instruction](2026-11-03-aer-cross-workstream-ledger-instruction.md) — maintain the existing execution register and feedback queue; no parallel ledger.

## Current state (31 Oct 2026)

**The platform is being renamed StudySearch** (formerly CourseFinder).
- Technical names stay: repositories, the Worker, database objects, APIs, keys and storage keys (transformation record §2.9).

**Active mandates:**

| Date | Mandate | Record |
|---|---|---|
| 2 Nov | CF-247 Layer 4 AER live queue assessment: 539 pending (499 course/40 provider), dropped-row risks, governed per-item admission/recovery playbook (**no decisions submitted**) | `2026-11-02-aer-layer4-admission-review-and-playbook.md` |
| 2 Nov | CF-247 AER catalogue-first coverage: 1,476 eligible AU/NZ providers, 34 source-linked; named university gaps and RMIT/UWA classification (**audit/mandate; no reads deployed**) | `2026-11-02-aer-catalogue-provider-coverage-reconciliation.md` |
| 2 Nov | CF-247 continuous AER assurance: automated provider/qualification/source gap reconciliation, Admin progress and existing email/push reporting (**design only; ingestion holds remain**) | `2026-11-02-aer-continuous-assurance-mandate.md` |
| 2 Nov | CF-247 AER design Draft 1.2: qualification-first, global IB/GAC/A Levels, missing UK and other country coverage, postgraduate admission, all eligible AU/NZ providers and provider source URLs (**design only; ingestion holds remain**) | `../ENTRY-REQUIREMENTS.md` §F; `2026-11-02-aer-qualification-coverage-gap-assessment.md` |
| 31 Oct 10:23 | StudySearch production stabilisation, operational autonomy and rebranding (**primary**) | `2026-10-31-studysearch-transformation-mandate.md`, record `2026-10-31-studysearch-transformation.md` |
| 30 Oct 22:30 | AER production closure: D5 release, human Layer 4 review support, outcome register; **ingestion held** (no QUT, B5 or recovery reads) | `2026-10-30-aer-production-closure-mandate.md`, response `2026-10-30-aer-production-closure-response.md` |

**Live release:**
- Pilot `main` `115e40b3` = v2.15.382; migration head `20261031070000` (verified 14:24).
- Today's releases: v2.15.379 (remediation hold), v2.15.380 (enrichment mismatch hold), v2.15.381 (course item speed-up), v2.15.382 (Rule 4 retired; `entry.min_scores[]`).

**Decisions:** D1–D6 approved 31 Oct 13:30 (`2026-10-31-studysearch-d1-d6-approval.md`) and executed (record §22 to §28). Developer guide issue 7 is current.

**Live health (31 Oct baseline; record §2):**
- Consumer API at its approved baseline, 0 server errors in 7 days.
- 3 scheduled jobs timing out since 29 Oct; root cause found (record §7).
- Website search p95 13.5 s.
- 1,141 Layer 4 items pending, 1,000 of them AER.

**Decisions awaiting the Platform Admin** (record §5):
- consumer API speed-up of search (G3);
- an additive field for all published entry scores (G3);
- anonymous access to `admin_ui_error_report`;
- lifting any ingestion hold;
- any Worker or repository rename.

**Consumer API rule (Platform Admin 31 Oct 2026 11:24):** every consumer API change, even one that changes no response field, ships with a developer guide issue with a version line, a dated handover note for the consumer's owner, the release version and change-control reference (record §10).

**Developer guide:** issue 6 (31 Oct, `scale_stated`) is current; issue 5 (29 Oct) is superseded.
New sessions (human or agent): read this file first. Full operating rules:
docs/platform/AGENT-OPERATING-MODEL.md (read once). This repo is the durable record;
chat history is transport only. Australian English throughout.

## Repos
- DECISIONS (this repo): msinghbs-ai/coursefinder-admin — WHAT and WHY. Nothing executes here.
- EXECUTION: msinghbs-ai/Coursefinder-Pilot — Cloudflare Worker + Supabase code.
  All deployments ship from Pilot; this repo's wrangler target is NOT the live Worker.
  Pilot working rules: its CLAUDE.md (CF-247). Every code change traces to a decision
  recorded here FIRST.

## Thread files (read only what a task touches)
Base: https://raw.githubusercontent.com/msinghbs-ai/coursefinder-admin/main/docs/platform/nz-enrichment-brief/

| File | Contents |
|---|---|
| 2026-10-23-nz-enrichment-brief-assessment.md | Day-one DB introspection, coverage matrix |
| 2026-10-23-nz-brief-verification-and-release-plan.md | Verification answers, Releases 1–3 |
| 2026-10-23-nz-brief-decisions.md | Decisions + thread (quarantine a07de41, 8a query, R1 extension, identity root cause) |
| 2026-10-23-platform-throughput-gap-schema.md | Plan + live build thread (diagnosis: upstream starvation, not budget) |
| 2026-10-24-nz-field-admission.md | NZ field push; item 5 shipped (1,874 links); entry-requirements spec section 5 |
| 2026-10-24-zero-yield-reacquisition.md | Zero-yield flow v2.15.338; UoA pilot; standing order section 6; detect-only |
| 2026-10-24-au-quick-wins-and-247-ingestion.md | AU triage vs developer gaps; links widened (16,889 AU + 1,863 CA); 24/7 audit; hourly report ≤8 min fresh |
| 2026-10-24-au-builds-and-enrichment-jobs.md | MANDATE RECORD (not a response): Phase 0 R1-first, B1–B6, E1–E6, Phase 3 gates, expected coverage; builds programme not completed |
| 2026-10-24-r1-release-plan-and-verification.md | R1 full plan, PR #681 / v2.15.339, independent tests and read-only live verification |
| 2026-10-30-field-report-throughput-diagnostic.md | Read-only diagnostic of the 30 Oct AU/NZ/CA field reports: metric definition, read-to-admission funnels, negative-delta reconciliation, decisions TD1–TD6 (binding without proof, gap-queue re-queue of wrong-page courses, unmet 23 Oct re-reads, report and label changes) |
| 2026-10-30-aer-production-closure-mandate.md / -response.md | AER closure mandate and Claude's response: D5 verified and released, decision C1 (course outcome register), Layer 4 position |
| 2026-10-30-layer4-*.md | Kimi Work Layer 4 batch verifications and Skill v4/v5 records (scholarships, course links) |
| 2026-10-31-independent-production-health-check.md | Independent read-only health check (31 Oct 10:10) |
| 2026-10-31-project-status-review.md | Project status review (31 Oct) |
| 2026-10-31-studysearch-transformation-mandate.md | **Current primary mandate** (verbatim) |
| 2026-10-31-studysearch-transformation.md | **Canonical programme record:** baseline, findings F1–F8, roadmap, approvals, progress |
| ../STUDYSEARCH-EXECUTION-REGISTER.md | **Single execution register** (SS-001 onwards): every StudySearch task, status, approval, PR, verification and next action |
| 2026-10-24-target-only-audit.md | target_only audit result (A 87 / B 455 providers), write-back paste, O10 decision |
| ../ui-audit/2026-10-24-layer4-parked-triage.md | MANDATE + Phase 0 census: 2,011 Layer 4 items, classification, Phase 1 designs and budget, Phase 2 learning loop |
| ../ui-audit/2026-10-25-speed-reconfiguration.md | **PRIMARY TRACK from 25 Oct 22:05:** speed programme (map-then-match binding, search quality, calibrated stops, Tranche 2, velocity + live visibility S5/S6) |
| ../ui-audit/2026-10-25-overnight-outcomes.md | Overnight outcomes mandate O1–O7, Track C, paused-lanes table |
| ../ui-audit/2026-10-24-title-and-international-intent-mandate.md | MANDATE (queued after audit → O10 → R2): NZ title verification, AU international-intent pages |

## Standing order
**25 Oct 22:05 / 22:27 (Platform Admin): the speed programme (`../ui-audit/2026-10-25-speed-reconfiguration.md`) is the primary track.** Merge queue: **#694 gate consolidation → SP-1 → #695**; Track B release 1 keeps its place (with S5/S6 inside, or split to 1.1 straight after if bundling adds more than a day). Naming: #694 is "gate consolidation", never "S1"; speed releases are SP-x only.

R1 (Q2 backoff, Q4 narrowed, Q3 ledger, apply-time identity check) — **LANDED** as one
release, v2.15.339 / PR #681. R3 (`health-hourly`) — **LANDED** as v2.15.340 / PR #682;
provisional headline target remains unset until its first full week of rows.
target_only audit — PRODUCED; O10 APPROVED; route staged (c)-then-(b) — **R2 LANDED v2.15.350 (PR #692) with tranche 1 applied** (`2026-10-24-target-only-audit.md` sections 3–5); (b) rule-settings proposal after ~2 weeks of the weekly line, starting from the 951-override finding. Then R2 (Q1 at
search.daily_picked_cap = 100; raise only on ledger evidence). Then stepped read-lane
test. Then S1 full (absorbs zero-yield table; contract test: search, AI match AND
finder all consume rejections). Then 8a remainder (country_identity_rules table).
Then items 9, 10, 11. B1 entry requirements remains first among the AU builds and does
not bypass O10/R2 or any approval gate.

## Decisions awaiting Platform Admin
(Pruned 25 Oct 2026 15:15 to the next human gates, per the Platform Admin's 14:50 decisions.)
1. **SIT 3954 extract**: shown in `docs/platform/ui-audit/2026-10-24-layer4-parked-triage.md` ("SIT 3954 stored register extract"). The register itself titles 3954 "--", which points to the one-row quarantine paste. Say the word and the file is written; also delete branch `cf247-sit3954-extract` (deletion refused from this session).
2. **Track B release 1 PR**: review before merge (Fields section, Pipeline strip on `pipeline.course_events`, Read-with-AI v2, calendar retirement tidy, lineage test).
3. **#694 gate consolidation merged and live 23:17** (rule 9: the agent merges its own PRs; review is retrospective). #695 Track C merged 26 Oct 07:36 (reader off).
4. **Speed programme**: decided 22:27 (SP-1 before #695; no-page gap cause and conjoint rule approved; S5/S6 inside Track B R1 with the one-day split rule; Tranche 2 Part A applied by the Platform Admin). **SP-1 #696 merged and live 23:21** (rule 9; switch `bind.no_page_on` when ready); Tranche 2 Part B after Monday's weekly line; O8/O9 plan tiers for S3.

Parked, not gates today: policy proposals paste (65 rows, mark when ready); zero_yield.auto_reset; UoA catalogue-host; O5 / O8 / O9; R3 headline target.
Closed 25 Oct: #693 accepted (live re-check is the verification); Track B release 1 approved as specified; 2.2–2.4 specs accepted (queued behind Track A); `reading.read_attempts_max` open row; real-tables rule (AGENT-OPERATING-MODEL rule 7); entry-requirements feed confirmed (additive in existing payloads); Sydney 2026 edition current plus a quarterly re-check; entry build plan approved; case-by-case rendering rule.

## Live platform state (key releases)
v2.15.334 Release 1 · v2.15.335 read-lane capability ·
v2.15.336 item 5 course_url fill · v2.15.337 identity CRICOS-AU-only ·
v2.15.338 zero-yield flow detect-only · v2.15.339 R1 backoff/ledger/why-idle/identity ·
v2.15.340 R3 health-hourly · v2.15.341 UI audit Phase 0 (plain errors, coverage-admit http fix; PR #683) ·
v2.15.342 HOTFIX manual task / stall visibility / Layer 4 held-fee address / target-only refused at start (PR #686) ·
v2.15.343 HOTFIX 2 person task passes the stop in the credit check; credits-refused status (PR #687) ·
v2.15.344 UI audit Phase 2 course list fee basis and sorts (PR #684) ·
v2.15.345 UI audit Phase 3 dedupe and data-quality leaks (PR #685) · v2.15.346 UI audit Phase 1 list internals stripped (PR #688) ·
v2.15.347 HOTFIX 3 Task manager read speed (PR #689) ·
v2.15.348 Campuses by CRICOS location name + Provider filter (PR #690) ·
v2.15.349 Firecrawl targets rule reports the failing condition (PR #691) ·
v2.15.350 R2: daily picked-courses cap 100 + per-course stop 6 (PR #692); tranche 1 (25 overrides) applied ·
v2.15.351 list columns on every sort (PR #693) · v2.15.352 gate consolidation (PR #694) · v2.15.353 SP-1 (PR #696, worker v0.47.0) · v2.15.354 SP-1.1 first-run pending cap (PR #697) · v2.15.355 Track C entry requirements step A, reader off (PR #695, worker v0.48.0).
No open PRs (24 Oct 23:40).
Hotfix record: docs/platform/ui-audit/2026-10-24-hotfix-manual-task-and-layer4-entry.md (re-open paste file with the Platform Admin).
Key metric: course-page binding % — every field's ceiling. Tracker definition (official link active, published providers), 25 Oct 22:20: NZ 47.0% · AU 75.1% · CA 69.8% (the earlier "NZ 53.5%" could not be reproduced from current tables; see the speed record).
R1 live evidence: worker v0.46.0 writes the per-mode ledger; 15-minute backoff cap;
90-day ledger retention; apply-time identity quarantine; Work queues why-idle line.
R3 target: 0 (not set) until a week of rows; then Platform Admin sets the provisional target.
Hourly report "StudySearch hourly stats" is the daily view.

## Guardrails (summary — full rules in AGENT-OPERATING-MODEL.md and Pilot CLAUDE.md)
Config over code; settings keys for every tunable; no new status values; quote-on-page
for AI admissions; manual bindings never touched; count guards on paste jobs; no new
panels/SOPs without retiring old; decisions precede code; nothing applied, merged,
deployed or activated without its approval gate.

