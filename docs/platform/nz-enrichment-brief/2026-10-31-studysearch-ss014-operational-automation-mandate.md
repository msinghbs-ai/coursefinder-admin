StudySearch — SS-014 Operational Automation and Production Acceptance

Executive direction

Continue from the verified v2.15.383 production state.

The objective is to establish a self-sustaining StudySearch platform with proactive monitoring, controlled automatic recovery, reliable data processing and minimal manual administration.

Do not restart completed investigations or repeatedly request routine approval.

Read the operating model and current Admin execution register before taking action.

1. Decisions on open items

D7 — Critical alerts

Approved to design and prepare configurable email and webhook alert integrations.

- Use existing operational settings and infrastructure where practical.
- Support severity, deduplication, acknowledgement, retry and recovery notifications.
- Avoid generating repeated alerts for the same incident.
- Do not enable external delivery until the destination and credentials are approved.
- Provide a recommendation for the simplest reliable alert channel.

D8 — Technical naming

Keep existing GitHub repository names, Cloudflare Worker identifiers, Supabase identifiers, domains and consumer API routes unchanged.

StudySearch remains the official product identity.

Document technical-name dependencies and revisit infrastructure renaming only when there is a demonstrable operational benefit.

D9 — Consumer error messages

Retain existing legacy error wording.

Any future consumer-visible message change must follow G3, including developer-guide issue, version line, compatibility assessment and handover.

D10 — Crawler user agent

Preserve the existing crawler identity and matching behaviour.

Prepare a backwards-compatible StudySearch user-agent proposal, including provider "robots.txt" compatibility and potential blocking risks.

Do not deploy the change under this mandate.

D11 — Remaining SS-007 bindings

Keep the 154 release candidates and 1,012 verification reads on hold.

No additional binding corrections, paid reads or ingestion-hold changes are authorised.

2. Execute SS-014 — Operational maturity

Deliver improvements in this order.

SS-014A — Health-check efficiency

Optimise the existing health-check implementation.

- Investigate the scholarship and queue checks taking approximately 11.5 seconds each.
- Reduce unnecessary scans and repeated calculations.
- Preserve existing health classifications and thresholds.
- Prove equivalent results before and after.
- Record execution time and resource improvements.

SS-014B — Stalled refresh detection

Implement monitoring for delayed or stalled search-projection refresh requests.

- Identify refresh requests exceeding configured thresholds.
- Distinguish a slow operation from a genuinely stalled operation.
- Preserve existing retry and recovery behaviour.
- Provide an actionable diagnostic, not simply another warning count.

SS-014C — Critical alert preparation

Build or configure the approved internal alerting framework.

- Configurable destination.
- Severity and escalation policy.
- Deduplication and cooldown.
- Retry and delivery-failure handling.
- Recovery notification.
- Test mode.

Keep external alert delivery disabled until a destination is approved.

SS-014D — Weekly operational scorecard

Build a weekly report against operational targets T1–T8 in "OPERATIONAL-LIMITS.md".

Include:

1. Scheduled job reliability.
2. Pipeline throughput and successful admissions.
3. Page identity and evidence quality.
4. Review backlog and ageing.
5. Website and Zoho API performance.
6. AI and Firecrawl consumption.
7. Search projection freshness.
8. Operational incidents, recovery and unresolved risks.

Distinguish observed measurements from incomplete monitoring windows.

Use existing measurements and reporting mechanisms. Avoid creating duplicate jobs or dashboards.

SS-014E — Recovery automation review

Assess existing automatic recovery and determine whether any approved internal improvements are justified.

Prioritise bounded retries, duplicate-work prevention, stale-job recovery, controlled backoff and prevention of repeated paid processing.

Do not introduce autonomous data admissions or weaken existing manual review rules.

3. Operational acceptance — SS-015

Prepare an operational acceptance assessment against the agreed T1–T8 targets.

Track:

- 24-hour and seven-day scheduled-job reliability.
- Consumer API response times.
- Data freshness.
- Enrichment yield.
- Cost ceilings.
- Monitoring coverage.
- Recovery effectiveness.
- Remaining human intervention requirements.

Do not claim acceptance before sufficient evidence is available.

Keep future observation windows open while progressing independent authorised work.

4. Execution authority

Complete authorised implementation, testing, release and production verification without stopping at every subtask.

Use existing governance, change control and release gates.

Escalate only when an action requires new authority, materially increases risk, affects a protected consumer contract, exceeds approved expenditure or requires destructive changes.

5. Session progress and documentation

Before material production changes, explain the action, expected benefit, risks and rollback.

Throughout the session, show:

- Current task ID.
- Completed work.
- Measured improvement.
- Current activity.
- Genuine blocker, if any.
- Immediate next action.
- Admin and Pilot references.

Keep the canonical StudySearch execution register and transformation record updated.

Do not create redundant documentation or duplicate operational mechanisms.

6. Definition of completion

SS-014 is complete when:

- Health checks are efficient and accurately classify failures.
- Stalled projection refreshes are detected.
- Critical alerting is configured and ready for destination activation.
- Weekly operational reporting works against T1–T8.
- Existing recovery controls have been assessed and improved where authorised.
- Tests and live verification support the results.
- Admin documentation accurately describes the operating model.

SS-015 can remain in verification until the required observation windows have completed.

Proceed with SS-014A through SS-014E as one substantial execution workstream. Do not stop after each subtask or ask for another general GO.

At completion, report quantified operational gains, remaining risks, exact release references and only the decisions that genuinely require Platform Admin input.