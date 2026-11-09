# Platform Admin direction — Intake Recovery: UNSW Blockage and Cross-University Fairness (5 Nov 2026, 15:50 AEDT)

Recorded verbatim as received (attachment in the Integration Controller session). Status: in progress — see processes/intake-dates.md §9.

```text

StudySearch — Intake Recovery: UNSW Blockage and Cross-University Fairness

Platform Admin direction — 5 November 2026

The platform has demonstrated unattended intake processing, but it is not yet producing balanced or consistently trustworthy results.

Implement a bounded correction using existing architecture. No broad refactoring, new scheduler, new AI controller or additional dashboard.

1. Immediate data-quality investigation

Investigate the five newly published UNSW intake values, particularly:

- Master of Industrial Research: intake evidence appears to originate from a student testimonial describing February 2023.
- Diploma in Computer Science: potential UNSW College pathway identity and questionable August 2028 mapping.

Verify each against official course-specific offering evidence, provider identity and calendar applicability.

A valid general university calendar alone is insufficient proof that a particular course offers that intake.

If a published value lacks the required evidence, use the existing governed correction, withdrawal or hold mechanism. Preserve historical records and audit trails.

Do not automatically discard other correctly supported values.

Treat unsupported consumer-visible dates as a data-integrity issue and follow existing P0 governance where applicable.

2. Repair UNSW calendar precedence

The currently approved 2023 key-dates reading must not prevent matching an applicable current 2027 calendar.

Implement a deterministic, evidence-backed selection rule that:

1. Prioritises the correct current/future academic year.
2. Excludes obsolete editions from supplying future commencement dates.
3. Normalises equivalent official period labels such as "Term 1" and "Teaching period T1".
4. Requires the same provider, course applicability and academic calendar type.
5. Rejects ambiguous or contradictory period mappings.
6. Preserves manual locks and current admission policy.
7. Reconsiders affected held items only when their relevant inputs change.

Do not globally replace source precedence or create a new calendar interpretation engine.

Test UNSW 2023 versus 2027 explicitly.

3. Fix provider starvation

The live "security.intake_dates_plan_v3" orders candidates by focus-provider rank and course ID before applying the batch limit.

This causes UNSW to consume the available hourly work ahead of the other universities.

Correct selection using an existing governed fairness mechanism or a minimal provider-fair extension.

Requirements:

- Retain approved focus priority.
- Allocate a bounded opportunity across eligible providers.
- Preserve per-course eligibility, holds and fingerprints.
- Avoid repeated unchanged failures.
- Persist progress across runs.
- Support a provider with zero eligible work without blocking others.
- Keep batch size and fairness settings configurable under G2.
- Remain within existing database execution time-outs.

Do not simply increase the global batch size.

Do not bypass the existing scheduled job.

4. Test multiple universities immediately

After the pre-production tests pass and the controlled release is authorised, use the existing Admin Intake Run & Validate functionality.

Evaluate UNSW, Melbourne, Sydney and Newcastle in the same bounded validation exercise.

At minimum, show for each:

- Active intake rows.
- Current official calendar availability.
- Actual eligible rows.
- Rows selected.
- Rows processed.
- Newly extracted dates.
- Validated matches.
- Newly admitted values.
- Website API v2 publication.
- Skipped rows with exact reasons.

At least three universities must receive a genuine processing opportunity.

A university may legitimately produce zero new dates, but the report must distinguish:

Not evaluated / Evaluated but no eligible evidence / Evaluated but validation held / Successfully admitted.

Do not report a university as having no eligible data if the selection never reached it.

5. Maintain self-sustaining operation

The existing platform scheduler must continue:

- Selecting eligible work fairly.
- Reading current stored evidence.
- Applying approved AI interpretations.
- Enforcing source and course identity.
- Validating calendar applicability.
- Admitting only authorised values.
- Verifying Website API publication.
- Recording every skipped or failed item.
- Scheduling the next eligible revisit.

Claude may develop, deploy and independently verify the correction, but must not manually dispatch individual courses as a substitute for the scheduled pipeline.

6. Pre-production gate

Use the production-equivalent database and existing integration fixtures.

Include regressions for:

- Obsolete 2023 calendar losing to current 2027 evidence.
- Term 1 / T1 canonical matching.
- Different institution or pathway college.
- Testimonial falsely presented as intake evidence.
- Course-specific exceptions.
- Provider starvation under heavily skewed course counts.
- Zero-eligible university.
- Duplicate or unchanged work suppression.
- Manual locks.
- Real admission and consumer publication.

Demonstrate the corrected selector across ten representative universities in isolated testing.

Do not merge merely because unit tests pass.

7. Release and acceptance

Prepare one bounded PR and complete the normal release gates.

The engineering hold remains in place for unrelated discretionary work.

After approved deployment, run the governed 5–10-minute validation.

Acceptance requires:

1. The five earlier UNSW values have documented evidence verdicts and any necessary corrections.
2. Obsolete calendars cannot block current applicable periods.
3. At least three universities are independently evaluated.
4. No provider monopolises the bounded workload while other eligible providers wait.
5. New admissions, if eligible, have correct source evidence.
6. Website publication is independently verified.
7. The next normal scheduled cycle follows the same fair selection rules without manual dispatch.
8. Every zero-yield provider has a durable reason and next action.

A test that processes three universities but produces zero valid dates is not proof of enrichment success. Report its exact data-yield verdict separately from the fairness verdict.

8. Durable reporting

Update the existing Admin process record:

"docs/platform/processes/intake-dates.md"

Include the selector root cause, affected functions, source precedence correction, course identity audit, university-level throughput and publication evidence.

Keep historical measurements, PR/release references, failures and subsequent scheduled results.

No new reporting framework or parallel execution register.

Final objective: StudySearch must independently process eligible intake dates across multiple universities, correctly reject unsupported dates and prevent a single high-priority provider or obsolete calendar from blocking the rest of the catalogue.
```
