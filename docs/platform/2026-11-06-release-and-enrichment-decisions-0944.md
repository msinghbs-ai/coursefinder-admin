# Platform Admin direction, 6 Nov 2026 (received 09:44 Melbourne), verbatim

StudySearch — 6 November Release and Enrichment Decisions

Platform Admin direction

Proceed with the following bounded decisions. Preserve the current engineering hold for unrelated changes.

1. Release sequence

PR #889 — Conditionally authorised

Complete rebase, CI, full tests, production-schema parity and the established release gates. If all pass, merge and deploy.

Verify in the actual Admin UI that intake selection, admission and publication progress are displayed using the existing generic observer.

Confirm provider-level history, failure reasons, next actions and published data changes agree with production records.

Do not introduce a duplicate monitoring system.

PR #877 — Conditionally authorised after #889

After #889 is operationally verified, reconcile and complete the same release gates for Provider Description enrichment.

Verify official-source identity, evidence-backed AI claims, manual locks, Layer 4 review and actual consumer publication.

Do not enable new automatic description admission authority.

Record the release outcomes in the existing Admin execution register.

Keep #890 and #875 held.

2. Course descriptions

Approve the bounded course-description implementation plan, with these decisions:

- D1: Retain existing human admission requirements. No provider-level automatic trust activation at this stage.
- D2: Create a separate course-description claim-word list, initially identical to the existing list. Evaluate "students" using production-matched positive and negative examples before removing it from any rule.
- D3: Retain the existing 700-character and four-sentence limits.
- D4: Authorise one AI re-ask for length or sentence-count violations, activated as a recorded setting change after the feature is verified and within existing spending limits.
- D5: Separate course-description marketing words from provider-description rules, without changing their effective policy at release.

For the trust-policy evaluation, use a stratified sample of 50 descriptions: 30 Australian, 15 New Zealand and 5 Canadian, subject to actual eligible availability.

Use that sample to measure factual accuracy, course identity, claim support and reviewer disagreement—not as authority to bypass Layer 4.

Reconcile the 857 pending description items and provide an efficient existing reviewer workflow.

Do not assume that removing one problematic claim word will make a reading admissible. Validate all remaining rules after every correction.

Develop the complete reader, relevant UI and governed admission path as one bounded PR after #877, respecting file ownership and dependencies.

3. English requirements

Approve the English implementation plan with these decisions:

- D1: Preserve today's provider scope, including universities and eligible non-university providers.
- D2: Every new faculty or course-group rule requires an authorised human approval and binding initially. Leave automatic group approval disabled.
- D3: Build the non-university search capability switched off. Do not activate the proposed 250–535-credit pilot without a separate spending decision and current credit reconciliation.
- D4: Use existing stored source evidence first for Canterbury and Massey. Investigate the current "central-find" job and restore it only within its previously approved operational authority and budget after validating why it was disabled. Do not broadly enable paid discovery.
- D5: Reuse the existing "policy-add-tests" job for compatible stored-page reparsing, rather than creating another scheduler.
- D6: Keep VET-level English requirements as a separate subsequent feature.

Authorise the necessary bounded, read-only "provider_facts_inspect" operation to obtain the six existing stored source-page examples for regression testing.

The inspection must not change production data, admit values, replace sources, alter settings or trigger paid reads.

Keep source extracts in the approved test evidence location, without exposing protected production data.

Prioritise UNSW faculty English requirements using the existing approved source and course identity controls.

Verify correct English test scores, levels, course-group applicability, catalogue admission and Website/Zoho publication.

Do not infer English requirements for an unrelated course or override an authoritative course-specific reading.

4. Permanent compatibility gate

Before changing any reader, AI rule or scheduler, identify:

- Existing working mechanisms.
- Previous readers and parser versions.
- Active jobs and schedules.
- Existing admission precedence.
- Manual locks and protected approvals.
- Overlapping processing or write paths.
- Functions or settings being superseded.
- Existing source and evidence freshness rules.
- Consumer API dependencies.

Every PR must document Reuses, Changes, Replaces, Retires, Conflicts and Protects.

A newer mechanism must not silently override a valid older automation, and obsolete mechanisms must not block newer authoritative evidence.

Use production-equivalent schema constraints, function signatures and realistic source fixtures.

5. Operator visibility and continuous accountability

Each new enrichment capability must operate through its existing Admin workspace.

The operator must be able to see:

- Eligible providers and courses.
- Evidence available.
- Jobs running and next scheduled execution.
- Values extracted, proposed, held, admitted and published.
- Failure classifications and exact reasons.
- Relevant human decisions.
- Cost and useful yield.
- Next revisit or source-change trigger.
- Historical outcomes.

Provide governed Preview, Run Now, Results, Verify and History where appropriate.

Persist detailed process results in the existing database records and maintain the corresponding operational design, material incidents and verified summaries in the Admin repository.

Do not create a separate monitoring system.

6. Production acceptance

For each feature:

1. Complete the full pre-production integration gate.
2. Deploy only the authorised PR.
3. Within the 5–10-minute post-deployment acceptance target, run a bounded verification.
4. Measure actual source-backed data progression.
5. Verify applicable authorised admissions.
6. Independently check consumer publication.
7. Confirm the next scheduled cycle proceeds without manual record dispatch.
8. Record PASS, FAIL or BLOCKED with actual evidence.

A correctly held item is not an admission failure, but neither is it a published data gain.

Do not start another corrective release automatically if operational validation fails.

7. Delivery priorities

Complete in order:

1. #889 Intake Automation Progress — release and validate.
2. #877 Provider Descriptions — release and validate.
3. Course Descriptions — one complete PR.
4. English Requirements — one complete PR.

Course descriptions and English requirements may be developed in parallel after #877 where file ownership allows. Claude remains the sole Integration Controller and releases them sequentially.

Final objective: Produce accurate, measurable enrichment gains while preserving existing automation, human admission authority and operational visibility.

Stop reporting release counts as progress. Report correctly admitted and consumer-published data instead.