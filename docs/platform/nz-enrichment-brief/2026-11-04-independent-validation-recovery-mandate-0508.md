StudySearch — P0/P1 Independent Validation and Autonomous Recovery

Checkpoint: 4 November 2026, 04:53 AEDT

Continue as the active StudySearch Integration Controller under the canonical operating model.

This is a continuation of SS-018, SS-019, SS-021 and the existing scholarship coverage programme. Do not create another controller, execution register or duplicate integration issues.

1. Reconcile current production before acting

Read the latest Admin execution register, integration issue queue, Pilot release history, scholarship coverage design and existing autonomous recovery mechanisms.

The independent validation identified IQ-00215, IQ-00216, IQ-00219, IQ-00111 and IQ-00116.

All five IDs already exist in production.

Reconcile their current status, fingerprints, dependencies and latest evidence. Reopen or update existing issues only when justified by new evidence.

Use current production data, not the 04:53 figures as an assumed current baseline.

2. IQ-00215 — Torrens University scholarship coverage (P1)

The validation observed:

- 14 registered scholarships.
- Zero admitted or published.
- 13 discovery candidates, including 12 rejected.
- Eight scholarship listing items.
- One listing page read, with traversal incomplete.
- Missing or unproven international, undergraduate and postgraduate coverage.
- Admission eligibility reported false.

Investigate the complete existing data path:

Registered source → provider identity → source association → listing traversal → discovery classification → candidate matching → stored evidence → AI reading → eligibility validation → Layer 4 → admission → consumer publication.

Determine specifically:

1. Why admission eligibility is false.
2. Whether registered scholarships are current, eligible and applicable to international students.
3. Why the 12 candidates were rejected.
4. Whether provider aliases, sub-brands or institutional ownership are incorrectly matched.
5. Why listing traversal stopped.
6. Whether current undergraduate, postgraduate and research scholarships have been omitted.
7. Whether a shared platform defect affects other providers.

Do not assume all 14 registered records qualify for publication.

Correct reusable discovery, association, traversal, classification or reader defects centrally.

Allow the platform's normal scheduled processing to recover eligible work and present genuinely unresolved decisions to Layer 4 with complete evidence.

Record excluded scholarships with their verified reason and current source evidence.

3. IQ-00216 — TAFE South Australia (P1)

Investigate the single unmatched registered scholarship and eight rejected candidates.

Determine whether the records are:

- Current and internationally eligible.
- Domestic-only or otherwise out of scope.
- Incorrectly associated with the provider.
- Duplicates or expired awards.
- Failed discovery or extraction results.
- Eligible records being incorrectly refused by shared validation rules.

Reuse the Torrens diagnosis where the root cause is shared.

Do not create a provider-specific adapter or exception if the shared pipeline can be corrected.

Recover eligible work autonomously through existing governed routes.

4. IQ-00219 — Box Hill Institute (classification review)

Zero registered scholarships and zero discovered candidates do not independently prove a publication defect.

Establish:

- Whether an authoritative scholarship source exists.
- Whether current scholarships applicable to international students are published.
- Whether discovery coverage was complete.
- Whether the provider is legitimately classified as having no eligible scholarship.
- Whether source acquisition or traversal failed.

If coverage is genuinely absent, classify the provider as an evidence-backed coverage gap.

If an authoritative complete check establishes that no eligible scholarships are published, record that outcome without fabricating an admission or keeping a permanent P1 defect.

Retain P1 only if a material, reproducible coverage failure is demonstrated. Otherwise adjust severity through the existing integration issue governance.

5. Systemic scholarship coverage assurance

Do not stop after investigating Torrens, TAFE SA and Box Hill.

Use these cases to validate the existing scholarship coverage mechanism across the full eligible provider catalogue.

Ensure the platform can distinguish:

- Source not discovered.
- Source found but unread.
- Listing traversal incomplete.
- Candidate rejected correctly.
- Candidate rejected incorrectly.
- International eligibility unresolved.
- Domestic-only scholarship.
- Expired scholarship.
- Provider ownership conflict.
- Awaiting Layer 4.
- Admitted but not published.
- Published and consumer-verified.
- Evidence-backed no eligible scholarships.

Use existing statuses and objects where possible.

Every unresolved case must have an owner, evidence, next eligible recovery time and escalation condition.

Apply bounded automatic recovery and avoid repetitive discovery, paid reads or duplicate review items.

A failed provider must not prevent unrelated providers from progressing.

6. IQ-00111 — Fee integrity (P0)

Reconcile the released v2.15.442 fee correction and subsequent remediation against current production evidence.

Verify:

- Murdoch 096011C remains correct.
- AI fee-reader unit and credit-point handling.
- Fee holds and manual locks.
- UNSW short-course exclusions.
- VIT annual-versus-whole-course fee correction.
- Previously admitted incorrect AI fee rows.
- Scholarship savings derived from corrected tuition.
- Actual new fee reads processed under the corrected reader.

Compare catalogue values against Website API v2 and Zoho, including fee year, currency, amount and applicable audience.

Do not close IQ-00111 based only on tests, deployment or the original read-only replay.

Closure requires actual post-fix production reads and consumer-integrity evidence, with residual exceptions individually classified.

7. IQ-00116 — Tuition publication consistency (P1)

Investigate cases where a governed tuition decision is admitted in the catalogue but missing from the Website projection.

Trace the complete publication path:

Layer 4 decision → catalogue fee → projection → cache/refresh → Website API v2 → Zoho.

Determine whether the failure is caused by projection eligibility, fee-year selection, audience, holds, stale caching or another verified rule.

Correct the shared problem, not individual course values.

Preserve approval authority and do not modify consumer API contracts without the required separate decision and handover.

8. Live release verification — v2.15.457

Verify the actual production Cloudflare Worker release, version string and deployment evidence.

Reconcile:

- Pilot main commit and release.
- Applied migrations.
- Worker deployment and checksum evidence.
- Relevant function definitions.
- Current Admin UI version.
- SS-020 UI compatibility.
- Layer 4 review ownership and pauses.

If v2.15.457 has not reached production, classify it as pending verification rather than deployed.

Continue the remaining approved SS-020 work through the existing release controller.

9. SS-021 — Autonomous continuity is mandatory

The platform must diagnose and recover eligible items without routine manual assistance from Claude or ChatGPT.

For each recoverable failure:

1. Detect and classify.
2. Reuse existing issue fingerprints.
3. Select an approved remedy.
4. Retry within configured limits.
5. Park unresolved work with evidence and a recheck time.
6. Continue independent queues.
7. Verify recovered data.
8. Reopen the issue if the remedy fails.
9. Escalate only genuine human-authority, budget, destructive or policy decisions.

Do not manually enqueue individual enrichment items as a substitute for fixing the scheduler.

Do not change spending limits, bypass Layer 4, override manual bindings or create unjustified admissions.

AI diagnosis may recommend a remedy but must not grant its own admission authority.

10. Complete the independent validation gaps

Use bounded, read-only validation to establish the following:

- AER: source, extraction, proposed, admitted and consumer-published changes.
- Scholarships: registered, eligible, rejected, held, admitted and published changes.
- Rankings and course links: actual production publication changes.
- Website API v2, Wix and Zoho consistency.
- Firecrawl/OpenRouter usage and remaining budget.
- Database utilisation and scheduled-job failures.
- Job disable/restore history.
- Worker and migration consistency.
- Layer 4 backlog, admission throughput and technical blockers.
- Progress towards 24-hour unattended acceptance.

Keep unverified claims explicitly labelled. Do not turn a missing measurement into a new defect without supporting evidence.

11. Reporting and closure

Update the existing Admin execution register and linked issue records.

For each existing IQ, report:

Issue| Verified root cause| Recovery implemented| Production result| Consumer verified| Remaining blocker

Separately report changes in:

- Eligible records.
- Correctly excluded records.
- Automatically recovered records.
- Layer 4 decisions.
- Actual admissions.
- Consumer publication.
- Unresolved technical work.
- Cost and useful yield.

Keep the existing seven parallel engineering workstreams and SS-020 development progressing where independent.

Do not declare self-sustainability accepted until the platform completes its required unattended production observation with verified processing, recovery and publication outcomes.

Execution authority

Proceed autonomously with already approved, reversible engineering and operational remedies.

Do not request repeated permission for work already covered by existing mandates.

Escalate only genuinely new authority requirements in one consolidated decision pack.

Primary outcome: Fix reusable platform defects, restore eligible scholarship coverage, verify financial integrity and prove that StudySearch continues processing independently despite individual source, provider or review failures.