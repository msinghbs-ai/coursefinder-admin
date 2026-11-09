# StudySearch — SS-020 Follow-up and Autonomous Recovery Coordination

Platform Admin decision: **APPROVE the SS-020 follow-up, beginning with Layer 4 Inbox performance remediation.**

Continue the ongoing development and integration programme.

Read:

- `docs/platform/ui-audit/2026-11-04-ss020-follow-up-prompt.md`
- `docs/platform/ui-audit/2026-11-04-ss020-implementation-review.md`
- Decision 269 and its amendments.
- The existing 06:30 human-assisted recovery decision.
- The current execution register and integration queue.

## 1. Fix Layer 4 Inbox first

The Inbox currently suffers from a database time-out and excessive page length.

Investigate the query plan, server-side pagination, filtering, university grouping, evidence loading and database time-outs.

Implement:

- Server-side paging per university and review kind.
- Bounded initial queries.
- Lazy loading of expensive evidence and detail.
- Stable item identity and review state across pages.
- Preservation of existing reviewer permissions and decisions.
- Phone-width compatibility.
- Performance checks using representative production-scale data.

Do not merely increase SQL time-outs or load the same dataset in smaller client-side components.

The new human-assisted interventions must use this improved Inbox rather than introducing a separate screen or another heavy query.

## 2. Finish the remaining SS-020 amendments

Complete the approved Refresh schedules rewire before retiring the old controls.

Keep Link refresh on Coverage › Courses.

Correct obsolete Layer 2/3 wording.

Preserve the approved 47-tab, 20-page design, redirects, roles and operational functionality.

## 3. Coordinate the four-stage recovery build

Continue the shared intervention record, AER recovery, scholarship recovery and stronger-AI fallback.

The Inbox optimisation and recovery development may proceed concurrently on isolated branches, but share one integration contract.

Avoid overlapping changes to the same component.

The Integration Controller owns releases and compatibility verification.

Do not interrupt normal Layer 4 reviews except for the affected deployment compatibility window.

## 4. Firecrawl and AI cost protection

Current reported Firecrawl balance: 2,099 credits.

Do not increase vendor spending limits.

Prioritise stored evidence, existing official sources, free discovery and deduplicated reads.

Complete the outstanding Macquarie reads through the already approved normal reader.

Report cost per successful source recovery, valid extraction, admission and published record.

Distinguish legitimate budget pauses from technical failures. Park only affected paid operations while independent work continues.

## 5. Decision pack reconciliation

Locate the current authoritative 24-item decision pack.

Do not request approvals already recorded.

Separate:

- Previously approved actions ready for execution.
- Actions approved conditionally.
- Actions awaiting an actual Platform Admin decision.
- Development-only switches that must remain disabled.
- Actions already implemented and verified.

For scholarship switches 19–22, preserve current disabled states unless the individual decision and activation gates explicitly authorise the change.

Return only genuinely unresolved decisions in one consolidated table with evidence, cost, risk and recommendation.

## 6. Production acceptance

Prove that:

- Layer 4 Inbox loads without database time-outs.
- Pagination works for large university groups.
- Existing decisions and permissions remain intact.
- Human-assisted intervention records are displayed correctly.
- Supplying missing evidence resumes eligible work automatically.
- AER and scholarship queues progress independently of unresolved individual cases.
- Website and Zoho continue reporting consistent published values.
- Firecrawl/AI use remains within current limits.

Record the affected issues, commits, releases and production verification in the existing execution register.

Do not declare SS-020 or the new intervention capability complete until deployed behaviour is verified.

**Continue all unrelated approved development and autonomous enrichment. The Layer 4 Inbox problem must not stop the platform's other workstreams.**