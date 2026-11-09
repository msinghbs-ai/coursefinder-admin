# StudySearch — P0 Work Continuity and Autonomous Recovery

Continue the existing development session as Integration Controller.

**Platform Admin decision:** No individual provider, course, source, reader failure or Layer 4 backlog should unnecessarily prevent unrelated eligible work from progressing.

This is a permanent, cross-layer operating requirement, not another one-off remediation.

Read the canonical operating model, existing operations controller, scheduling controls, Layer 4 throughput design, admission rules and execution register.

## 1. Identify the blocking points

Audit all existing scheduled jobs and queues across:

- Provider discovery, identity and lifecycle.
- Course links and page acquisition.
- AER and qualification matrices.
- Fees and fee validation.
- Intakes and application deadlines.
- Scholarships and rankings.
- Layer 2/3 enrichment and Layer 4 admission.
- Consumer publication and cache refresh.

Identify where one blocked entity, exhausted retry, full review queue, stale lease, failed batch or provider-specific condition prevents unrelated work.

Record each finding under existing issue IDs.

## 2. Build one shared Work Continuity capability

Extend the existing operations controller and job scheduler rather than creating another independent controller.

Every work item must have:

- Stable entity and work identity.
- Owner and current stage.
- Attempt count, failure classification and diagnostic evidence.
- First-blocked and last-attempt timestamps.
- Next eligible retry time.
- Recovery deadline and escalation condition.
- Dependency and manual-lock references.
- Evidence or source version used.
- Final verified outcome or explicit unresolved blocker.

Use existing states and contracts where possible. Add new persisted objects only where the existing model cannot meet these requirements.

## 3. Time-bound automatic recovery

Implement configurable recovery policies by error class.

Suggested initial policy:

| Failure | Automatic action |
|---|---|
| Transient network or worker error | Retry with bounded exponential backoff |
| Missing course page | Use verified alternative discovery routes; then park |
| Source or qualification ambiguity | Park with evidence and propose Layer 4 review |
| AI extraction incomplete | Retry through the approved reader strategy |
| Duplicate/identity conflict | Quarantine affected item, retain existing accepted data |
| Provider website unavailable | Defer with scheduled identity and availability re-check |
| Human review required | Place in the appropriate Layer 4 category and continue other work |
| Budget exhausted | Pause only the affected paid lane; continue free and stored-evidence work |

Make thresholds settings-governed and evidence-based. Do not create infinite retries.

A parked item must not consume active worker capacity, retain an expired lease or repeatedly generate identical review items.

## 4. Guarantee forward progress

Introduce fair queue selection across independent providers, fields and workstreams.

When an item is blocked:

1. Record its state and evidence.
2. Release its claim safely when appropriate.
3. Schedule the next permitted recovery attempt.
4. Select the next eligible independent item.
5. Continue until the applicable worker capacity or budget is exhausted.

Preserve transaction integrity and existing admission constraints.

A failed item must not cause an otherwise valid batch to be discarded.

Use safe per-item isolation where supported rather than abandoning the entire batch.

## 5. Prevent Layer 4 from becoming the global bottleneck

Review the current AER 600-item waiting limit and other admission back-pressure controls.

**Do not raise or bypass the limits simply to improve throughput.**

Introduce admission-aware scheduling:

- Separate genuine human decisions from technically incomplete reads.
- Route incomplete evidence back to bounded technical recovery.
- Park unresolved cases without repeatedly generating review items.
- Prioritise work that can produce a complete, review-ready result.
- Preserve capacity for newly discovered eligible providers.
- Continue independent enrichment fields while one review category is full.
- Automatically resume paused acquisition when genuine capacity becomes available.

Only remove an item from a review queue through an authorised, audited state transition. Parking must not conceal a pending human decision or count as admission.

## 6. Evidence-backed Layer 4 categories

Use existing Layer 4 kinds wherever they fit; extend only for genuinely missing outcomes.

Each review item must present:

- Provider and exact course/source identity.
- Problem summary and root cause.
- Original value and proposed value.
- Current authoritative evidence and stored copy.
- Previous attempts and failures.
- Automated recovery already attempted.
- Available actions permitted for the reviewer.
- Consequence of each action.
- Recommended resolution with confidence and supporting evidence.

Where a technical issue cannot be resolved, create one deduplicated actionable review case, not repeated low-information alerts.

Preserve existing human approval authority, manual locks and immutable decision history.

## 7. Autonomous diagnosis and correction

The platform must be the primary operator.

Claude and ChatGPT are responsible for architecture, development, governance and independent validation—not routine individual-course or provider recovery.

The platform should automatically:

- Detect operational failures.
- Classify root causes.
- Select approved recovery strategies.
- Execute permitted corrections.
- Validate outcomes.
- Reopen failures when a remedy does not work.
- Escalate only genuine authority, budget, identity or policy blockers.

Never allow AI diagnosis to authorise its own academic admission, destructive lifecycle action, budget increase or consumer API change.

## 8. Continuous validation

Add V1–V4 tests demonstrating:

1. One failed course does not stop other courses.
2. One unavailable provider does not stop other providers.
3. An AER queue at its limit does not stop fees, intakes or other independent work.
4. Failed AI extraction is safely parked and recoverable.
5. An expired lease does not permanently starve a queue.
6. Duplicate errors produce one actionable case.
7. Successful recovery automatically returns an item to the correct eligible stage.
8. Every admission still passes Layer 4 and existing validation gates.
9. Manual bindings, fee holds, previous decisions and consumer data remain protected.
10. The scheduler continues making measurable progress through an unattended 24-hour window.

Measure both worker success and actual newly admitted/published data.

## 9. Permanent operating metrics

Maintain in the existing Admin execution register and operations reporting:

- Eligible work and completed work by lane.
- Active, blocked, parked and retry-due counts.
- Oldest blocked items and time to recovery.
- Queue starvation and admission throughput.
- Recovery success percentage.
- Root causes with repeated failures.
- New records admitted and published.
- Items awaiting Platform Admin authority.
- Firecrawl/AI spending and useful yield.
- Provider and field coverage trends.

Every issue must have a deadline for its next automatic action or a recorded blocker requiring authority.

Do not repeatedly notify the Platform Admin about an unchanged blocker.

## 10. Execution mandate

Use maximum safe parallel development without violating ownership or integration rules.

Record this decision in the Admin repository before code. Reuse existing workstreams, controller, issue queue and reporting.

Implement centrally, deploy incrementally through the Integration Controller and prove each improvement in production.

Continue unrelated work while remediation proceeds.

**Acceptance condition:** The system must keep performing eligible work, isolate and recover blocked items, and escalate genuine decisions with adequate evidence—without requiring Claude or ChatGPT to manually restart normal operations.

Do not mark this mandate complete until a continuous unattended production run proves work progresses despite deliberately introduced recoverable failures.