<!-- Recorded verbatim: Platform Admin, received 2 Nov 2026 10:56 AEDT (chat). Decision 3 (restore, US$3) is worded "PROPOSED APPROVAL" and E-3 requires explicit recording; treated as pending explicit confirmation. -->

# StudySearch — Consolidated Platform Admin Decision Pack
**2 November 2026 | E16, SS-015, Recovery, Capacity, Housekeeping and Wix Enrichment**

## Executive direction

Reconcile the live state before execution. Apply only decisions expressly authorised below or already authorised in the canonical Admin repository.

Do not reopen completed remediation, create a new programme or delay production acceptance because information is missing from individual courses.

**Priority: correct the mechanisms, safely contain unsupported values, route unresolved data through Layer 4 and complete operational handover.**

Maintain parallel-agent delivery with one production release controller.

## Decision 1 — E16 group (a): 12 course links

**APPROVED APPROACH: Option 2 — targeted link containment.**

Use the same reversible method previously applied to E16 Part B:

- Set confirmed unsupported links to `unverified`.
- Remove primary selection where applicable.
- Record the page rejection and evidence.
- Rebuild the affected search projection.
- Route unresolved course links through the existing Layer 4 review mechanism.
- Preserve before-state, audit trail and reversal path.

Do not use the SS-007 hold where doing so unnecessarily pauses `course-url-fill` platform-wide.

Verify the exact 12-record cohort against current production before applying any approved change.

F1's two associated fees must be independently checked and withdrawn only when their source is confirmed invalid, under the applicable authorisation.

The project must not wait for all 12 replacement URLs to be found.

## Decision 2 — E16 C1: 14 nested-award links

**APPROVED POLICY: Retain the existing evidence rule.**

Do not override the v2.15.402 award-link acceptance rule based solely on similarity of titles or URL paths.

Where programme-specific recorded evidence validates the nested award link, retain it.

Where independent evidence establishes a wrong programme, qualification level or year, quarantine that specific link and route it to Layer 4.

F3's 14 associated fees must follow their own provenance and applicability assessment. Do not automatically withdraw all 14 merely because their link is in C1.

The nine inconclusive courses remain under governed review.

Close the historical 67-record finding through verified containment and prevention, not through manual replacement of every URL.

## Decision 3 — Restore rehearsal

**PROPOSED APPROVAL: US$3 maximum for one isolated temporary Supabase test project.**

Execution conditions:

- Use the approved backup and documented restore process.
- No production writes or configuration changes.
- Disable jobs, outgoing network calls and integration paths on the restored copy before testing.
- Prevent restored functions or credentials from accessing production.
- Verify schema, catalogue counts, migration state and selected records.
- Record restore duration, failures, limitations and measured recovery objectives.
- Delete the temporary project after evidence capture, following authorised cost and deletion controls.

Do not claim a successful full-platform restore if Storage, secrets, authentication settings or edge services remain untested.

## Decision 4 — Scheduler capacity

**APPROVED APPROACH: Stagger the three 10-minute admission jobs, subject to current-load reconciliation.**

Use the existing D8 P1 proposal as the starting point:

| Job | Proposed minute pattern |
|---|---|
| coverage-admit | `3-59/10 * * * *` |
| coverage-admit-intakes | `5-59/10 * * * *` |
| adapter-overwrite | `9-59/10 * * * *` |

Before changing schedules, confirm their current schedules, the latest job results, the relevant dependencies and whether later releases have already addressed the collision.

Use one governed, reversible schedule change. No batch-size or worker-capacity increases.

Test for schedule overlap, actual completion times, queue movement and consumer freshness.

Record the two 07:00/07:03 timeouts accurately. Do not misreport them as zero failures.

Do not delay the deployed desktop/phone UAT while waiting for scheduled weekly execution; dispatch an equivalent authorised read-only run.

## Decision 5 — Recovery Runbook Appendix E

Use the following proposed dispositions. Record them individually, with no assumption that a proposal constitutes permission for new expenditure or destructive action.

### E-1: Recovery objectives

Adopt as initial operational targets:

- Database RPO: 24 hours.
- Full database recovery RTO: one working day, target eight hours.
- Recovery of an isolated bad data change: four hours.
- Other service targets as documented in the runbook, subject to rehearsed evidence.

These are targets, not proven capabilities. Report any objective the rehearsal cannot demonstrate.

### E-2: PITR

Verify whether PITR is currently enabled.

Do not purchase or activate the approximately US$100/month PITR option under this decision pack.

Record its additional benefit, cost and remaining Storage limitations for a separate capacity/availability decision.

### E-3: Restore rehearsal

Proceed only once the US$3 isolated-project approval is explicitly recorded.

### E-4: Storage backup

**Preferred direction: Option S — independent Storage protection.**

Prepare the smallest incremental backup to an external S3-compatible destination, including evidence, adapter captures, provider assets and archive as appropriate to retention policy.

The documented estimate is approximately US$0.45/month for stored capacity; revalidate actual storage, request and transfer charges.

Do not activate paid storage or transfer production credentials without the specific spending and security approval.

The alternative is explicit acceptance of the current approximately 29 GB unprotected Storage risk. Do not silently treat that risk as resolved.

### E-5: UR-14 recovery release

- Accept the documentation reconciliation identifying v2.15.79 as the historical accepted recovery release.
- Prefer R-a: promote the latest release that actually passes SS-015 acceptance.
- Do not promote a release before acceptance.
- Do not roll back forward-only database migrations.

Test the chosen recovery application against the isolated restored database.

### E-6: UR-15 backup scope

- U1: Approve accurate UI labelling of the existing settings-only backup.
- U2: Recommend external weekly copies of settings backups using existing CI mechanisms, subject to access and retention checks.
- U3: Prepare a monthly logical catalogue backup proposal, but do not enable a heavy production scan without load, retention and cost approval.

### E-7: AI budget enforcement

**Preferred direction: enforce the existing US$14/day ceiling.**

Prepare B1/B2 with verification, but do not simply switch `openrouter` from `observe` to `stop` and claim compliance.

The current lane guards total more than US$14/day, and two AI lanes are not guarded.

Implement the smallest complete budget enforcement design covering:
- Every paid AI lane.
- Aggregate daily ceiling.
- Credit floor of US$10.
- In-flight work.
- Retry and restart safety.
- Accurate spend accounting.

Use current settings and enforcement mechanisms.

Perform refusal tests before enabling production enforcement.

Any changed limits require the applicable Platform Admin approval.

### E-8: Firecrawl budgets

Use the documented F1/F2 proposals, but first reconcile their current values against the actual vendor billing period.

Recommend a single hard monthly ceiling across all acquisition paths, including on-demand requests.

Do not reduce daily allowance to 14,000 solely to obtain a passing dashboard if that would unnecessarily starve authorised workloads.

Build F2 to close the missing monthly enforcement paths and deploy only with verified limits, tests and rollback.

### E-9: Alerts

Recommend W1: an external hourly GitHub Actions watchdog using existing CI credentials and read-only checks.

Keep the existing push/e-mail alert route operational.

Do not create or invent a deputy recipient.

For the immediate pilot, use documented one-person coverage with explicit acknowledgement and response limitations, pending designation of a deputy.

Do not activate a Teams or Slack webhook without an approved destination.

## Decision 6 — Housekeeping disposition

Use the 28 findings in `2026-11-02-housekeeping-reconciliation.md`. Preserve each H identifier.

### Approve bounded, non-destructive work

- H01/H03/H04/H09: Prepare one count-guarded duplicate-link consolidation tranche with before/after read-back, keeping the validated link and existing history. Do not execute consumer-visible changes without their required approval.
- H11: Correct component-register drift under the existing housekeeping authority.
- H24: Prepare guarded closure of genuinely completed background batches and an existing-health-check extension for stale heartbeats.
- H05/H13/H20: Route uncertain values into existing Layer 4 review without duplicating items or automatically withdrawing unproved values.
- H23: Reuse existing pending review items.

### Retain without correction

- H06: historical course URLs.
- H16–H18: evidence/history pending retention decisions.
- H22: immutable Layer 4 history.
- H25: exhausted page-read history.
- H26: manual locks and protected values.

### Require separate evidence before changing

- H07: do not copy a projected URL to `course_url` merely to populate an empty field.
- H08: keep Federation source gating unchanged until source approval is evidenced.
- H14: preserve all hand-entered, locked Monash links.
- H15: previous-year handbook URLs are review candidates, not automatically incorrect.
- H21: the 29 ungated fees appearing in tuition history require G3 assessment before a consumer-facing correction.
- H28: no new evidence purge or retention policy until recoverability and legal retention are established.

### Retirement

For H10 and H27, prepare the authorised retirement/retention evidence, including callers, recovery dependencies, protected evidence, scope and counts.

No destructive drop or Storage deletion without a separate explicit approval and count-guarded paste file.

Produce the mandatory housekeeping reconciliation:
- records examined;
- corrected, retained, held and retired;
- Layer 4 items reused/created;
- evidence identifiers;
- consumer changes;
- manual locks preserved;
- records physically deleted;
- remaining risks.

## Decision 7 — Wix missing-field enrichment

Continue the two existing workstreams independently:

1. Live Australia field-coverage reconciliation.
2. University description reader, fixture build only.

Complete `2026-11-02-missing-field-coverage-reconciliation.md` first.

Reconcile:
- 23,732 Australian course-search records in the handoff;
- 11,744 university-course records;
- all reported missing-field counts;
- search-versus-detail availability;
- live source population;
- Layer 4 waiting versus genuinely unavailable;
- existing stored evidence and processing jobs.

Do not treat a missing search-summary field as proof that the database lacks the information.

### University descriptions

- Reuse official stored About/Overview pages.
- Extract only evidence-supported statements.
- Preserve page quotes, provenance and verification dates.
- Route proposals to Layer 4.
- Keep automatic publication and scheduled acquisition disabled.
- No paid AI or Firecrawl reads without the proposed pilot's cost approval.
- No Website API v2 shape change without G3 approval.

### Wix field-state policy

Preserve native field values and types.

Distinguish:
- available;
- not provided;
- processing;
- under Layer 4 review;
- held for quality;
- not applicable;
- confirmed negative.

Do not return a text placeholder in a numeric tuition field or a URL field.

Design the state representation against the frozen consumer contract and obtain G3 approval before modifying the response.

## Decision 8 — Final production closure

Do not let the entire platform wait for:

- 12 missing course URLs;
- 14 evidence-accepted nested-award links;
- nine unresolved handbook matches;
- 45 university descriptions;
- incomplete scholarship coverage;
- a non-zero Layer 4 queue;
- P2 housekeeping work.

Proceed through SS-015 Gates A–E.

Correctness and safe publication remain mandatory; completeness is continuous operational work.

Use up to six independent agents as supported, with a single integrator controlling production work.

Report only genuine production blockers and the exact evidence required to close them.

## Required completion report

Update the existing execution register and return:

1. Decision executed, pending or requiring separate authority.
2. E16 remaining incorrect published values and Layer 4 disposition.
3. Scheduler reliability after staggering.
4. Recovery rehearsal evidence and runbook readiness.
5. Housekeeping H01–H28 disposition with exact counts.
6. Wix missing-field coverage and description-reader build progress.
7. SS-015 Gates A–E.
8. Next production GO/NO-GO recommendation.

Do not treat any unapproved spending, destructive action or consumer-contract change as authorised merely because it is discussed in this prompt.

**Outcome required: a safely published, operationally recoverable StudySearch platform with continuing governed enrichment and no recurring manual-validation programme.**