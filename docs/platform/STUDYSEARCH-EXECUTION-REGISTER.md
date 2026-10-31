# StudySearch execution register

**Canonical, single list of StudySearch transformation work** (Platform Admin, 31 Oct 2026 11:32: "one permanent StudySearch task ID for every work item and one consolidated execution register").
- Evidence and detail: `nz-enrichment-brief/2026-10-31-studysearch-transformation.md` (the record), cited by section.
- Original F/TD identifiers are kept as references only.
- Operating model: `AGENT-OPERATING-MODEL.md`.

**Statuses:** Not started · Investigating · Awaiting decision · Approved · Implementing · Verifying · Completed · Blocked. A task is Completed only after production verification, never on a merge or a test claim alone.

**Last reconciled:** 31 Oct 2026 11:32 AEDT. Sources:
- GitHub: Pilot `main` `5dc76dcc`, no open PRs;
- live `fxcwkweaxjtknorudmwp`: migration head `20261031010000`;
- Admin `500250fb`.

## Register

| Order | Task | Ref | Phase | Task and expected outcome | Priority · depends on | Status | Approval | Admin record | Pilot PR · release | Production verification | Next action · owner |
|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | **SS-001** | Phase 0 | 0 | Production baseline: verified state of releases, jobs, APIs, queues, cost, security, branding | P0 · — | Completed | Mandate 31 Oct 10:23 | Record §2 (`4276a3de`) | — | Live reads 10:24–10:28 | — |
| 2 | **SS-002** | Decisions | 0 | Governance and approval record: decisions and the consumer API handover/version rule recorded verbatim | P0 · — | Completed | — | Record §10, §10.2 (`500250fb`) | — | n/a (documentation) | Keep current · Claude |
| 3 | **SS-003** | Admin INDEX | 0 | INDEX reconciled to the current state, mandates, release and decisions | P0 · SS-001 | Completed | — | INDEX (`ae06a6f3`, `beb9f961`) | — | n/a (documentation) | Update at each release · Claude |
| 4 | **SS-004** | F1 | 1 | Scheduled job time-outs: `waste-guard` and `coverage-ai-match-prepare` within limits, same rows written | P1 · SS-001 | **Verifying** | Standing authority (rule 9) | Record §7, §8.2, §8.8 | #767 · v2.15.377 (`5dc76dcc`) | Since deploy (11:03): `waste-guard` 1/1 ok (25.8 s); `coverage-ai-match-prepare` 15/15 ok (max 37.3 s); was 14 of 24 failing. **Acceptance:** 0 time-outs in 24 h and 7 d | Re-check at 24 h (1 Nov 11:03) and 7 d (7 Nov) · Claude |
| 5 | **SS-005** | F1c | 1 | Pause Rule 4 job `l4-rule-low-agreement` on purpose; correct its catalogue description (it admits, it does not "send to review") | P1 · — | **Approved → Implementing** | Platform Admin 31 Oct 11:32 (this register's instruction §6) | Record §8.9, §10.2 | v2.15.378 (built, held at `e8b15d19`, not pushed) | Live 11:32: job still active; to verify inactive after deploy | Ship and verify · Claude |
| 6 | **SS-006** | F6 | 1 | Error reporter: remove the anonymous EXECUTE grant (already refused inside); search-path lints accepted with reason | P2 · SS-005 (same release) | **Approved** | As SS-005 | Record §8.5, §8.10 | v2.15.378 | Live 11:32: anon grant present; to verify removed | Close with SS-005 evidence · Claude |
| 7 | **SS-007** | TD1 | 2 | Binding identity audit: evidence-based dry-run list of the 1,564 unproven bindings and the shared-URL group, with classification, proposed action (release / verify / re-role), risk, and impact on coverage and admitted values | P1 · — | **Investigating** | Decision 31 Oct 11:28: dry-run list, then decide; no corrections | Record §8.11, §10.1 | — | Counts verified 11:23 (1,564; 983 AU shared); first classification of 30 URLs | Produce the full list · Claude, then **Awaiting decision** |
| 8 | **SS-008** | F1c | 2 | Rule 4 quality and batching: dry-run over 1,185 adapters, which outputs are safe for automatic admission; batching, checkpoint and recovery design with admission disabled | P2 · SS-005 | Not started | Decision 31 Oct 11:28: review first; no restart | Record §8.9, §10.2 | — | — | After SS-007 · Claude |
| 9 | **SS-009** | F5 | 2 | Multiple entry scores: review the 24 courses and their evidence; propose an additive `min_scores[]` that preserves `min_score`, with examples, a sample response and consumer impact | P2 · — | Not started | Decision 31 Oct 11:28: review before approving; no field yet | Record §2.8, §10.2 | — | — | After SS-008 · Claude |
| 10 | **SS-010** | TD2/TD3 | 2 | Controlled enrichment recovery: stop futile re-queues on mismatch or no-copy pages; bounded, count-guarded recovery of withdrawn values | P2 · SS-007 | Not started | Needs design and approval; ingestion holds apply | 30 Oct diagnostic TD2/TD3 | — | — | After SS-009 · Claude |
| 11 | **SS-011** | F2 | 3 | Website search latency investigation: per-step timing (auth, rate, action, log, network), query optimisation, regional and sequential-call options with estimates. **Read only; no regional probe** | P2 · — | **Investigating** | Decision 31 Oct 11:28: measure more first | Record §8.6, §8.7 | — | Verified: DB in `ap-south-1`, edge `us-east-1`, 4–5 sequential calls per request, search p95 13.5 s | Measure per step · Claude, then **Awaiting decision** |
| 12 | **SS-012** | F2 | 3 | Approved performance remediation (consumer change with guide issue, version line, compatibility assessment and handover note) | P2 · SS-011 | Not started (awaits SS-011 decision) | Not yet requested | — | — | — | Decision after SS-011 · Platform Admin |
| 13 | **SS-013** | Rebranding | 4 | StudySearch presentation and active documentation; technical and historical names kept | P3 · — | Investigating | Phase 3 plan only | Record §9 | — | Classification verified by repository grep | Active-docs pass after SS-011 · Claude |
| 14 | **SS-014** | Operations | 4 | Self-sustaining operations and recovery: service targets from the baselines, runbooks (owner, health signal, stop condition, recovery), weekly report, spend forecast | P3 · SS-004 | Not started | — | Record §4 | — | — | — |
| 15 | **SS-015** | Acceptance | 4 | Production acceptance and handover against agreed thresholds | P3 · all | Not started | — | — | — | — | — |

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
