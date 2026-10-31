# StudySearch execution register

**Canonical, single list of StudySearch transformation work** (Platform Admin, 31 Oct 2026 11:32: "one permanent StudySearch task ID for every work item and one consolidated execution register").
- Evidence and detail: `nz-enrichment-brief/2026-10-31-studysearch-transformation.md` (the record), cited by section.
- Original F/TD identifiers are kept as references only.
- Operating model: `AGENT-OPERATING-MODEL.md`.

**Statuses:** Not started · Investigating · Awaiting decision · Approved · Implementing · Verifying · Completed · Blocked. A task is Completed only after production verification, never on a merge or a test claim alone.

**Last reconciled:** 31 Oct 2026 21:05 AEDT (SS-014 mandate 19:22; v2.15.384). Earlier: 31 Oct 2026 13:20 AEDT (Executive Execution Mandate 12:38: SS-007 hold built in v2.15.379; SS-011 completed; one consolidated decision pack `nz-enrichment-brief/2026-10-31-studysearch-decision-pack.md` covers SS-007, SS-008, SS-009, SS-010 and SS-012). Sources:
- GitHub: Pilot `main` `5dc76dcc`, no open PRs;
- live `fxcwkweaxjtknorudmwp`: migration head `20261031010000`;
- Admin `500250fb`.

## Register

| Order | Task | Ref | Phase | Task and expected outcome | Priority · depends on | Status | Approval | Admin record | Pilot PR · release | Production verification | Next action · owner |
|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | **SS-001** | Phase 0 | 0 | Production baseline: verified state of releases, jobs, APIs, queues, cost, security, branding | P0 · — | Completed | Mandate 31 Oct 10:23 | Record §2 (`4276a3de`) | — | Live reads 10:24–10:28 | — |
| 2 | **SS-002** | Decisions | 0 | Governance and approval record: decisions and the consumer API handover/version rule recorded verbatim | P0 · — | Completed | — | Record §10, §10.2 (`500250fb`) | — | n/a (documentation) | Keep current · Claude |
| 3 | **SS-003** | Admin INDEX | 0 | INDEX reconciled to the current state, mandates, release and decisions | P0 · SS-001 | Completed | — | INDEX (`ae06a6f3`, `beb9f961`) | — | n/a (documentation) | Update at each release · Claude |
| 4 | **SS-004** | F1 | 1 | Scheduled job time-outs: `waste-guard` and `coverage-ai-match-prepare` within limits, same rows written | P1 · SS-001 | **Verifying** | Standing authority (rule 9) | Record §7, §8.2, §8.8 | #767 · v2.15.377 (`5dc76dcc`) | Since deploy (11:03) to 12:55: `waste-guard` 2/2 ok (25.8 s, 25.1 s); `coverage-ai-match-prepare` 57/57 ok (median 26.0 s, max 73.4 s); was 12 of 24 and 10 of 720 failing in the 24 h before (record §19). **Acceptance:** 0 time-outs in 24 h and 7 d | Re-check at 24 h (1 Nov 11:03) and 7 d (7 Nov) · Claude |
| 5 | **SS-005** | F1c | 1 | Pause Rule 4 job `l4-rule-low-agreement` on purpose; correct its catalogue description (it admits, it does not "send to review") | P1 · — | **Completed** | Platform Admin 31 Oct 11:32 | Record §8.9, §10.2, §15; change control `ab26d82e` | #768 · v2.15.378 (`96daf97a`) | Live 11:46: job inactive; catalogue "PAUSED (Platform Admin 31 Oct 2026…"; migration head `20261031020000`; post-merge workflows all success (Deploy `41151938573`, Release Currentness `41151938691`, Deployed UAT `41151939131`) | — |
| 6 | **SS-006** | F6 | 1 | Error reporter: remove the anonymous EXECUTE grant (already refused inside); search-path lints accepted with reason | P2 · SS-005 (same release) | **Completed** | As SS-005 | Record §8.5, §8.10, §15 | #768 · v2.15.378 | Live 11:46: anon EXECUTE false; authenticated true | — |
| 7 | **SS-007** | TD1 | 2 | Binding identity audit and controlled remediation: release 154 generic/wrong automatic bindings and re-role 302 shared fee/enrolment/application pages, provider by provider, verified per binding against source evidence, reversible, count-guarded | P1 · — | **Verifying** (batch A done and consumer-verified; batch B retained; 154 releases and 1,012 verification reads still held) | Platform Admin 31 Oct 13:30: D1 approved, D2 retain | Record §18, §22–§24; handover note executed; batch B list | #769 · v2.15.379 (`a8319590`); batch A executed by function, 13:31–13:36 | Live 13:39: 177 re-roled at 25 providers, 167 links unverified, 0 manual touched; published wrong links 167 → 0; other item content unchanged (md5 `900cd49d`); Zoho null; no drift; no paid processing on held courses | Independent re-verification (1 Nov); the 154 releases and 1,012 verification reads stay held (D11, 31 Oct 19:22: no further corrections, paid reads or ingestion-hold changes) · Claude, Platform Admin
| 8 | **SS-008** | F1c | 2 | Rule 4 quality and batching: dry-run over 1,185 adapters, which outputs are safe for automatic admission; batching, checkpoint and recovery design with admission disabled | P2 · SS-005 | **Completed** (logical retirement) | Platform Admin 31 Oct 13:30, D3 | Record §14, §27 | #772 · v2.15.382 (`115e40b3`) | Live 14:24: job inactive; job and function `retiring` (retire after 14 Nov); EXECUTE revoked; history kept | Drop by paste after 14 Nov · Platform Admin
| 9 | **SS-009** | F5 | 2 | Multiple entry scores: review the 24 courses and their evidence; propose an additive `min_scores[]` that preserves `min_score`, with examples, a sample response and consumer impact | P2 · — | **Completed** | Platform Admin 31 Oct 13:30, D4 (G3) | Record §16, §16.1, §28; guide issue 7; handover | #772 · v2.15.382 (`115e40b3`) | Live 14:24: 41 courses, 116 items (24 with more than one); 0101331 6 items; min_score unchanged; Zoho carries it; no drift | Website rendering (developer) · website team
| 10 | **SS-010** | TD2/TD3 | 2 | Controlled enrichment recovery: stop futile re-queues on mismatch or no-copy pages; bounded, count-guarded recovery of withdrawn values | P2 · SS-007 | **Verifying** | Platform Admin 31 Oct 13:30, D5 | Record §20, §25 | #770 · v2.15.380 (`699ba5ad`) | D5a live (md5 `688da7ae`): 0 new Enrich items on mismatch-page courses since deploy; daily futile-item count to be measured over 24 h. D5b: of 65, 50 recovered, 14 verified no value, 1 waiting; US$0 spent | Measure futile items/day at 24 h (1 Nov) · Claude
| 11 | **SS-011** | F2 | 3 | Website search latency investigation: per-step timing (auth, rate, action, log, network), query optimisation, regional and sequential-call options with estimates. **Read only; no regional probe** | P2 · — | **Completed** (investigation) | Decision 31 Oct 11:28: measure more first | Record §8.6, §8.7, §13, §21 | — | Root cause measured 12:55–13:00: 50-item pages (p50 3.1 s vs 0.8 s for 1–20 items), per-item building (display code 3×, published check per item), full sort and count; network secondary | → SS-012
| 12 | **SS-012** | F2 | 3 | Approved performance remediation (consumer change with guide issue, version line, compatibility assessment and handover note) | P2 · SS-011 | **Completed** | Platform Admin 31 Oct 13:30, D6 (G3) | Record §26 | #771 · v2.15.381 (`d9c06e1c`) | Live: output byte-identical (fingerprint `0a1fd5be` before and after); items 50: 536 → 280 ms; search DB time median about 840 → 552 ms; edge p50/p95 await website traffic | Report edge p50/p95 when traffic returns · Claude
| 13 | **SS-013** | Rebranding | 4 | StudySearch presentation and active documentation; technical and historical names kept | P3 · — | **Completed** (presentation and active documentation); identifier renames need separate decisions | Platform Admin 31 Oct 10:23 and 14:27 | `STUDYSEARCH-IDENTITY-INVENTORY.md`; record §9; router, README and operating-model headings | #773 · v2.15.383 (`9952dd7f`) | Live 14:48: no screen, title, report, job label, setting, test name or workflow name uses the former name (guard s6 over all `src/`); retained identifiers listed with reasons | D8, D9, D10 decided 31 Oct 19:22 (names, error text and crawler identity kept); crawler proposal in inventory §5, not deployed · —
| 14 | **SS-014** | Operations | 4 | Self-sustaining operations and recovery: service targets from the baselines, runbooks (owner, health signal, stop condition, recovery), weekly report, spend forecast | P3 · SS-004 | **Verifying** (A to D live; E reviewed) | Platform Admin 31 Oct 14:27 and 19:22 (D7) | Record §30, §31; `OPERATIONAL-LIMITS.md` 1.2; inventory §5 | #773 v2.15.383; #774/#775 v2.15.384 (`8b468e31`, `60317717`) | Live 21:01: health md5 `b648e649`, stall `fe27fdb0`; scholarship check 7.0 to 8.5 s (was 11.6 to 13.7); whole run unchanged so far (about 22 s); search refresh and alert checks live; alerts recorded, delivery off; scorecards recorded (2 weeks); drift none | 1 Nov 11:20: 24-hour run time, false criticals, alerts, first daily scorecard · Claude. Decisions: alert destination (§31.7), recovery findings 1 to 3 (§31.5) · Platform Admin
| 15 | **SS-015** | Acceptance | 4 | Production acceptance and handover against agreed thresholds | P3 · all | **Verifying** (assessment opened; not accepted) | Platform Admin 31 Oct 19:22 | Record §31.6 | — | Windows open: 24 h (1 Nov), 7 days (7 Nov), two complete weeks for the acceptance gate | Weekly scorecard each Monday; acceptance only on the gate in §31.6 · Claude

## Related work completed in this session (outside SS numbering; for traceability)

| Item | Reference | Verified |
|---|---|---|
| AER course outcome register (closure decision C1) | v2.15.376, #766, `43f30791`; closure response §3.1 | Live 10:49: 31,875 courses; job active |
| Full deployed safe run on `6f006619` | `41144480924` | Desktop 80/80, phone 81/81, 0 skipped |
| Developer guide issue 6 (D5 `scale_stated`) | Admin `a79495a2` | Built, 16 pages; sent by the Platform Admin |

## Backlog (new findings; severity assessed; not in the execution order until placed by the Platform Admin)

| Finding | Severity | Note | Record |
|---|---|---|---|
| `SYSTEM-REFERENCE.md` §4b does not describe the entry fields | Low | Fold into SS-013 | §8.10 |
| About 20 edge functions were deployed by hand; parity rests on the drift check | Medium | Traceability; propose a CI redeploy | §2.1 |
| Role checks inside 169 signed-in-callable functions are unaudited | Medium | Sampled audit (D6 showed a check can silently not apply) | §2.7 |
| AER review queue: 1,000 items, about 11.8 h at the measured pace | Human work | Platform Admin review; supported by review pack 1 | Closure response §3.3 |

## Change log

| Date | Change |
|---|---|
| 31 Oct 2026 11:32 | Register created from the Platform Admin's baseline sequence and reconciled with GitHub and live |
| 31 Oct 2026 11:48 | SS-005 and SS-006 completed (v2.15.378 verified); SS-007 and SS-008 awaiting decision; SS-009 and SS-011 findings |
| 31 Oct 2026 13:20 | Executive Execution Mandate (12:38): SS-007 hold and governed correction built (v2.15.379), batch A prepared; SS-010 measured; SS-011 completed; decision pack D1–D6 |
| 31 Oct 2026 14:24 | D1–D6 executed: SS-007 batch A done (167 → 0), batch B retained; SS-010 D5a live, D5b settled; SS-012 live; SS-008 retired; SS-009 live with guide issue 7 |
| 31 Oct 2026 14:48 | SS-013 completed for presentation and docs (inventory); SS-014 first improvements live (v2.15.383), targets T1–T8; consumer handover pack index |
| 31 Oct 2026 21:05 | SS-014A to D live (v2.15.384, re-issued migration after its md5 guard refused the first); SS-014E reviewed; SS-015 opened; D7 to D11 recorded; alert destination recommendation |
