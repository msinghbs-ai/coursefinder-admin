# StudySearch execution register

**Canonical, single list of StudySearch transformation work** (Platform Admin, 31 Oct 2026 11:32: "one permanent StudySearch task ID for every work item and one consolidated execution register").
- Evidence and detail: `nz-enrichment-brief/2026-10-31-studysearch-transformation.md` (the record), cited by section.
- Original F/TD identifiers are kept as references only.
- Operating model: `AGENT-OPERATING-MODEL.md`.

**Statuses:** Not started · Investigating · Awaiting decision · Approved · Implementing · Verifying · Completed · Blocked. A task is Completed only after production verification, never on a merge or a test claim alone.

**Last reconciled:** 1 Nov 2026 12:35 AEDT (Layer 4 recovery v2.15.390, §35; usability remediation SS-016 with UR-04 to UR-06 in v2.15.391 and v2.15.392, §36). Earlier: 1 Nov 2026 11:15 AEDT (24-hour checks; SS-007 integrity repair v2.15.389; SS-015 T1–T8 evidence; record §34). Earlier: 1 Nov 2026 10:15 AEDT (Reliability Closure mandate 08:57; v2.15.387 and v2.15.388: SS-004 remediation, record §33). Earlier: 31 Oct 2026 21:05 AEDT (SS-014 mandate 19:22; v2.15.384). Earlier: 31 Oct 2026 13:20 AEDT (Executive Execution Mandate 12:38: SS-007 hold built in v2.15.379; SS-011 completed; one consolidated decision pack `nz-enrichment-brief/2026-10-31-studysearch-decision-pack.md` covers SS-007, SS-008, SS-009, SS-010 and SS-012). Sources:
- GitHub: Pilot `main` `5dc76dcc`, no open PRs;
- live `fxcwkweaxjtknorudmwp`: migration head `20261031010000`;
- Admin `500250fb`.

## Progress dashboard

Kept per the Platform Admin's instruction of 1 Nov 2026 10:23 (`nz-enrichment-brief/2026-11-01-studysearch-progress-dashboard-mandate.md`). Counted from the register below: each SS task once; "Verifying" after deployment counts as deployed, awaiting verification; SS-015 (assessment) as in progress. Layer 4 settlement is kept separate. Definitions: reviewed by a person = approved, edited, rejected or returned since the baseline; reconciled = superseded by the system; deferred = returned to Layer 2 or 3; exceptions = pending past the 14-day target.

**StudySearch Overnight Progress — 2 Nov 2026 02:00 AEDT**

**Engineering:** 11/15 completed and verified; 3 verifying (SS-004, SS-007, SS-014); 1 in progress (SS-015). The observation windows are still running.

**SS-016:** **2/17 accepted** (UR-06, UR-13). 13 implemented and awaiting acceptance:
- UR-01, UR-02, UR-03, UR-04, UR-05, UR-07, UR-08, UR-09, UR-10, UR-11, UR-12, UR-16, UR-17;
- the UR-03 guard is now live and proven by a real Admin sync;
- P1 (Curator) and P2 (Counsellor) guide text now follows the server.

2 not implemented: UR-14 and UR-15 (investigation only; no rollback baseline promoted).

**Role simulation:** 6/6 role journeys pass as **fixtures**. **Live: 1/6** (Platform Admin). Lower-role sessions are needed for the other five; none were fabricated.

**UR-18:** design done (§10 admission contract). Not built. D-B1 to D-B3 not ratified; D-B4 separate.

**Layer 4:**
- live pending 1,352;
- 521 verified decisions overnight: #28585 SITI fee, plus #28588, which live-verified the E15 fix (Otago, Bachelor of Applied Management);
- holds kept on RMIT, QUT and ANU;
- exceptions E1–E15: E1, E14 and E15 repair packs await approval; E11–E13 ceilings await approval.

**Releases overnight:** v2.15.395, 396, 397, 398, 399 and 400, all live and verified. Current: **v2.15.400**.

| Release | Pilot | Content |
|---|---|---|
| v2.15.397 | `30b249dc` (#789) | Refusals and links name the role; six role fixtures |
| v2.15.398 | `8f15da35` (#790) | E15: the approved course page replaces the old one (migration `20261101120000`, md5 `214aae7e`) |
| v2.15.399 | `64d98034` (#791) | Layer 4 Inbox decisions named as the Pipeline Operator's (P1); Counsellor text (P2); SOP mirror guard |
| v2.15.400 | `1f7d41aa` (#792) | Mirror guard works with squash merges (defect found in the v2.15.399 sync) |

Each release: full suite with 0 failed and 0 skipped (v2.15.400: 1,406 passed); all post-merge workflows succeeded; live version checked; SOP mirrors and TEST-REGISTER synced. Migration head `20261101120000`.

**Next:**
- **Platform Admin:** decide the consolidated approval pack: E1, E14, E15 (Part 2 option A/B), E11–E13 and D-B1 to D-B3.
- **Platform Admin:** lower-role sessions for live acceptance.
- **Claude:** 2 Nov 07:30 SS-014 checks; the morning report.

| Outstanding | Next action | Human approval |
|---|---|---|
| SS-004 | Clean 24 h to 2 Nov 09:25; 7 days to 7 Nov | No |
| SS-007 | Daily re-check | Yes, for further corrections |
| SS-014 | 2 Nov 07:30 checks; alert receipt | Confirm the [TEST] alerts arrived |
| SS-015 | Two complete weeks (2–15 Nov); assess 16 Nov | Acceptance |
| SS-016 | Live acceptance of 13 implemented items | Lower-role sessions; recovery baseline (UR-14) |
| Layer 4 | `2026-11-01-consolidated-approval-pack.md` | Yes |

## Register

| Order | Task | Ref | Phase | Task and expected outcome | Priority · depends on | Status | Approval | Admin record | Pilot PR · release | Production verification | Next action · owner |
|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | **SS-001** | Phase 0 | 0 | Production baseline: verified state of releases, jobs, APIs, queues, cost, security, branding | P0 · — | Completed | Mandate 31 Oct 10:23 | Record §2 (`4276a3de`) | — | Live reads 10:24–10:28 | — |
| 2 | **SS-002** | Decisions | 0 | Governance and approval record: decisions and the consumer API handover/version rule recorded verbatim | P0 · — | Completed | — | Record §10, §10.2 (`500250fb`) | — | n/a (documentation) | Keep current · Claude |
| 3 | **SS-003** | Admin INDEX | 0 | INDEX reconciled to the current state, mandates, release and decisions | P0 · SS-001 | Completed | — | INDEX (`ae06a6f3`, `beb9f961`) | — | n/a (documentation) | Update at each release · Claude |
| 4 | **SS-004** | F1 | 1 | Scheduled job time-outs: `waste-guard` and `coverage-ai-match-prepare` within limits, same rows written | P1 · SS-001 | **Verifying** | Standing authority (rule 9); mandate 1 Nov 08:57 | Record §7, §8.2, §8.8, §33 | #767 · v2.15.377 (`5dc76dcc`) · #779 v2.15.387 (`0089e2fe`) · #780 v2.15.388 (`9396b085`) | Since deploy (11:03) to 12:55: `waste-guard` 2/2 ok (25.8 s, 25.1 s); `coverage-ai-match-prepare` 57/57 ok (median 26.0 s, max 73.4 s); was 12 of 24 and 10 of 720 failing in the 24 h before (record §19). 1 Nov: cancellations were idle pauses (now classified paused); 17:10 time-outs were row-lock contention between admission jobs started together (now staggered :00/:03/:08). **Acceptance:** 0 time-outs in 24 h and 7 d **24 h (to 1 Nov 11:03): not met**: 2 time-outs at 31 Oct 17:10 (before the stagger); 3 idle-pause cancellations now classified paused; 0 failures in 2,840 runs after the 09:25 fix (§34.2). | Clean 24 h from 1 Nov 09:25 (2 Nov); 7 d (7 Nov) · Claude |
| 5 | **SS-005** | F1c | 1 | Pause Rule 4 job `l4-rule-low-agreement` on purpose; correct its catalogue description (it admits, it does not "send to review") | P1 · — | **Completed** | Platform Admin 31 Oct 11:32 | Record §8.9, §10.2, §15; change control `ab26d82e` | #768 · v2.15.378 (`96daf97a`) | Live 11:46: job inactive; catalogue "PAUSED (Platform Admin 31 Oct 2026…"; migration head `20261031020000`; post-merge workflows all success (Deploy `41151938573`, Release Currentness `41151938691`, Deployed UAT `41151939131`) | — |
| 6 | **SS-006** | F6 | 1 | Error reporter: remove the anonymous EXECUTE grant (already refused inside); search-path lints accepted with reason | P2 · SS-005 (same release) | **Completed** | As SS-005 | Record §8.5, §8.10, §15 | #768 · v2.15.378 | Live 11:46: anon EXECUTE false; authenticated true | — |
| 7 | **SS-007** | TD1 | 2 | Binding identity audit and controlled remediation: release 154 generic/wrong automatic bindings and re-role 302 shared fee/enrolment/application pages, provider by provider, verified per binding against source evidence, reversible, count-guarded | P1 · — | **Verifying** (batch A done and consumer-verified; batch B retained; 154 releases and 1,012 verification reads still held) | Platform Admin 31 Oct 13:30: D1 approved, D2 retain | Record §18, §22–§24; handover note executed; batch B list | #769 · v2.15.379 (`a8319590`); batch A executed by function, 13:31–13:36 | Live 13:39: 177 re-roled at 25 providers, 167 links unverified, 0 manual touched; published wrong links 167 → 0; other item content unchanged (md5 `900cd49d`); Zoho null; no drift; no paid processing on held courses **1 Nov: regression found and repaired** (v2.15.389, #781 `ef64ad47`): coverage-admit had re-activated the 167 links on 31 Oct 14:30; admission now skips held courses; website official_url 167 → 0 again, other content md5 unchanged, no drift (§34.1). | Independent re-verification (1 Nov); the 154 releases and 1,012 verification reads stay held (D11, 31 Oct 19:22: no further corrections, paid reads or ingestion-hold changes) · Claude, Platform Admin
| 8 | **SS-008** | F1c | 2 | Rule 4 quality and batching: dry-run over 1,185 adapters, which outputs are safe for automatic admission; batching, checkpoint and recovery design with admission disabled | P2 · SS-005 | **Completed** (logical retirement) | Platform Admin 31 Oct 13:30, D3 | Record §14, §27 | #772 · v2.15.382 (`115e40b3`) | Live 14:24: job inactive; job and function `retiring` (retire after 14 Nov); EXECUTE revoked; history kept | Drop by paste after 14 Nov · Platform Admin
| 9 | **SS-009** | F5 | 2 | Multiple entry scores: review the 24 courses and their evidence; propose an additive `min_scores[]` that preserves `min_score`, with examples, a sample response and consumer impact | P2 · — | **Completed** | Platform Admin 31 Oct 13:30, D4 (G3) | Record §16, §16.1, §28; guide issue 7; handover | #772 · v2.15.382 (`115e40b3`) | Live 14:24: 41 courses, 116 items (24 with more than one); 0101331 6 items; min_score unchanged; Zoho carries it; no drift | Website rendering (developer) · website team
| 10 | **SS-010** | TD2/TD3 | 2 | Controlled enrichment recovery: stop futile re-queues on mismatch or no-copy pages; bounded, count-guarded recovery of withdrawn values | P2 · SS-007 | **Completed** (24 h closed 1 Nov 13:55: 464 items created, 0 futile, 0 on mismatch-page courses, 178 filled, US$0.36; was 1,600–2,200 futile a day) | Platform Admin 31 Oct 13:30, D5 | Record §20, §25 | #770 · v2.15.380 (`699ba5ad`) | D5a live (md5 `688da7ae`): 0 new Enrich items on mismatch-page courses since deploy; daily futile-item count to be measured over 24 h. D5b: of 65, 50 recovered, 14 verified no value, 1 waiting; US$0 spent 24 h since D5a (to 1 Nov 11:00): 0 futile items, 0 Enrich items on mismatch-page courses of 457 created; window closes 13:55 (§34.2). | Close at 13:55 (1 Nov) · Claude
| 11 | **SS-011** | F2 | 3 | Website search latency investigation: per-step timing (auth, rate, action, log, network), query optimisation, regional and sequential-call options with estimates. **Read only; no regional probe** | P2 · — | **Completed** (investigation) | Decision 31 Oct 11:28: measure more first | Record §8.6, §8.7, §13, §21 | — | Root cause measured 12:55–13:00: 50-item pages (p50 3.1 s vs 0.8 s for 1–20 items), per-item building (display code 3×, published check per item), full sort and count; network secondary | → SS-012
| 12 | **SS-012** | F2 | 3 | Approved performance remediation (consumer change with guide issue, version line, compatibility assessment and handover note) | P2 · SS-011 | **Completed** | Platform Admin 31 Oct 13:30, D6 (G3) | Record §26 | #771 · v2.15.381 (`d9c06e1c`) | Live: output byte-identical (fingerprint `0a1fd5be` before and after); items 50: 536 → 280 ms; search DB time median about 840 → 552 ms; edge p50/p95 await website traffic 1 Nov: no website search traffic since the deploy (insufficient data); Zoho 6 searches p50 611 ms, p95 1,293 ms; 0 server errors. | Report edge p50/p95 when traffic returns · Claude
| 13 | **SS-013** | Rebranding | 4 | StudySearch presentation and active documentation; technical and historical names kept | P3 · — | **Completed** (presentation and active documentation); identifier renames need separate decisions | Platform Admin 31 Oct 10:23 and 14:27 | `STUDYSEARCH-IDENTITY-INVENTORY.md`; record §9; router, README and operating-model headings | #773 · v2.15.383 (`9952dd7f`) | Live 14:48: no screen, title, report, job label, setting, test name or workflow name uses the former name (guard s6 over all `src/`); retained identifiers listed with reasons | D8, D9, D10 decided 31 Oct 19:22 (names, error text and crawler identity kept); crawler proposal in inventory §5, not deployed · —
| 14 | **SS-014** | Operations | 4 | Self-sustaining operations and recovery: service targets from the baselines, runbooks (owner, health signal, stop condition, recovery), weekly report, spend forecast | P3 · SS-004 | **Verifying** (A–E and D12–D16 live; D13 pilot waits for eligible pages; D15 under observation) | Platform Admin 31 Oct 14:27, 19:22 (D7), 21:54 (D12–D16) | Record §30–§32; `OPERATIONAL-LIMITS.md` 1.3; inventory §5 | #773; #774/#775/#776 v2.15.384; #777 v2.15.385 (`dd320cc6`); #778 v2.15.386 (`62ce39a3`) | Live 1 Nov 00:10: platform alerts delivered by push and e-mail (test, deduplicated critical, recovery; failure visibility dry run); stale `coverage-ai-match` flag released (D14); gap 25 min (D15); scholarship check 1.4–2.1 s cold (was 7.0–8.5 after v2.15.384, 11.9 before), whole run 15.7–16.8 s (was about 22 s); pilot live, 0 eligible until about 2 Nov; drift none 1 Nov: health p50 16.3 s after D16 (21.3 before); v2.15.387 runtime regression fixed by v2.15.388; 10 false stall criticals before the stall-age fix, 0 since 09:25; coverage-queue section rise under observation; alerts: 0 raised since the test, receipt unconfirmed (§34.2). | 2 Nov 07:30: D13 first pilot results, D15 wait figures, D14 guard re-arming, D16 24 h · Claude. Platform Admin: confirm the [TEST] alerts arrived
| 15 | **SS-015** | Acceptance | 4 | Production acceptance and handover against agreed thresholds | P3 · all | **Verifying** (assessment opened; not accepted) | Platform Admin 31 Oct 19:22 | Record §31.6 | — | Windows open: 24 h (1 Nov), 7 days (7 Nov), two complete weeks for the gate. T1 so far: 5 failures in 21,052 runs since 11:03 (4 incidents), so not met 1 Nov: T1–T8 table in §34.3: Pass T2, T3, T5, T8; Fail T1 (24 h), T4 (week), T6 (p95, week), T7 (week); post-fix windows insufficient. Gate assessable 16 Nov. **Not accepted.** | Assess the gate on 16 Nov (weeks 2–8 and 9–15 Nov) · Claude; acceptance · Platform Admin
| 16 | **SS-016** | UR-01–UR-17 | 5 | Usability, role guides and operational excellence (review `2026-11-01-role-guides-usability-operability-review.md`): role-correct guides and SOP mirrors (A), Layer 4 review traversal, evidence and verified outcomes (B), retirement, migration and recovery safety (C), freshness, guards and six role walkthroughs (D) | P1 · SS-014, SS-015 | **Implementing** (B: UR-04, UR-05, UR-06 live, awaiting authenticated-UI acceptance; A, C, D open) | Platform Admin 1 Nov 2026 11:48 | Record §36 | #783 v2.15.391 (`51fddef9`) · #784 v2.15.392 (`2900d17e`) | UR-04: AER 993/993 reached in 5 pages; UR-05: 119/119 course-link cards with stored copy; UR-06: outcomes verified on each route; found 2 unapplied course-link decisions | UI acceptance of B with the Platform Admin signed in; then UR-13, UR-07, Tranche A · Claude |

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
| 1 Nov 2026 00:15 | D12 alerts live (push and e-mail via the existing task); D14 (v2.15.385); D15 gap 25 min; D16 and D13 (v2.15.386); record §32 |
| 1 Nov 2026 10:15 | SS-004 remediation live: pause-cancelled runs classified paused, admission jobs staggered, stall age from due time (v2.15.387); health-check run time regression found in verification and fixed (v2.15.388). Record §33 |
| 1 Nov 2026 11:15 | 24-hour checks recorded (§34.2); SS-007 integrity regression repaired (v2.15.389, §34.1); SS-015 T1–T8 evidence (§34.3, not accepted); progress dashboard added (instruction 10:23) |
| 1 Nov 2026 12:35 | Layer 4 timeout stop cleared at the database (v2.15.390, §35); ANU rank/score scope 22 pending reads; SS-016 created for UR-01 to UR-17 (§36); UR-04/05/06 live (v2.15.391, v2.15.392) |
