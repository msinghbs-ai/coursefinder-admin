# StudySearch — audit Layer 4 review and fill upstream decision-evidence gaps

Act as the current Integration Controller. Audit ChatGPT’s work, challenge its conclusions and complete authorised remediation that makes Layer 4 decisions evidence-ready.

Read the current operating model first:
https://raw.githubusercontent.com/msinghbs-ai/coursefinder-admin/main/docs/platform/AGENT-OPERATING-MODEL.md
Then follow INDEX and only the relevant canonical records. Australian English.

## 1. Audit the work actually performed

In msinghbs-ai/coursefinder-admin read:
- docs/platform/nz-enrichment-brief/2026-11-03-university-review-csv-mandate.md
- docs/platform/nz-enrichment-brief/2026-11-03-layer4-university-review.csv
- docs/platform/nz-enrichment-brief/2026-11-03-layer4-university-review-checkpoint.md
- docs/platform/STUDYSEARCH-EXECUTION-REGISTER.md
- docs/platform/skills/cf-layer4-triage/SKILL.md and references/action-playbook.md
- the current AER admission, evidence, lifecycle and continuous-validation rules.

Checkpoint claims: 24 candidates across 9 provider records; zero submitted decisions, zero admissions. Queue 5,024 → 5,025, attributed to one unrelated AER arrival. These are historical observations, not a current baseline.

Verify counts, stable refs, CSV accuracy and evidence, including whether candidates were merely inspected or fully validated. Correct unsupported claims in the durable record with traceability. Check whether the stop for the undocumented University description kind was justified, and whether it should block unrelated qualified kinds. Do not weaken evidence or approval gates to improve throughput.

## 2. Determine exactly what each decision is missing

Reconcile the live queue by university and kind. Start with all 24 CSV refs, skipping already-decided refs after verifying their outcomes. For each pending item identify:

- Existing evidence and its source, capture time, newest run/copy and lineage.
- Exact missing fact preventing a specific existing UI decision.
- Whether the fact is absent upstream, stored but not linked, hidden by the UI, stale, conflicting or incorrectly interpreted.
- Responsible layer, existing job/function, owner, recovery action and verification condition.
- Whether existing stored evidence can resolve it without another fetch or AI call.

Use real objects verified against PIPELINE-LINEAGE and current code/schema. Do not invent table, job, issue or event IDs.

Classify information needs against the actual architecture:
- Layer 1: registered provider/course identity, CRICOS or NZ identifiers, registration/operating status, study level and registered fee facts.
- Layer 2: exact official page ownership and course identity; current source/copy, edition and audience; source discovery, links and page completeness.
- Layer 3: quote-backed extraction, numeric basis/scale, qualification/country mapping, proposed/excluded/dropped rows and justified uncertainty.
- Layer 4: evidence presentation, conflict resolution, authorised person decisions and saved-outcome verification.

Preserve these responsibilities where the implementation differs; explain the verified mapping.

## 3. Investigate the specific findings

- UNSW: ten sampled course-link refs have no linked stored copy. Determine whether copies exist elsewhere, why linking failed and whether current sources establish exact course/award/CRICOS identity. Keep award variants and historical handbook editions distinct. Review whether the UI safely expresses rejection of a bad proposal when no held page exists; do not fabricate a held-page justification.
- Fees: refs 6496144, 6526827, 6526834 and 6619496. Recover exact-course evidence, currency, annual versus total basis, duration and fee year. Determine whether the existing registered-total retention action is justified by available evidence under current rules. Missing page evidence is not automatically proof that the registered fee is current.
- Macquarie scholarship ref 1184: compare the held record with the published exact-title/provider equivalent, including canonical IDs, URLs, benefit, round and audience. Confirm or disprove duplication. Do not publish a second equivalent or classify it as ineligible merely to clear the queue.
- Prime Education refs 1176/1177: resolve the RMIT UP/Alphacrucis ownership mismatch from authoritative identity and source evidence. Route correction through governed housekeeping, without silently reassigning ownership.
- Bond ref 1230: distinguish general scholarship boilerplate from scholarship-specific eligibility and verify the January 2026-only round. Do not infer current availability.
- Unreadable scholarship candidates: distinguish source failure from no scholarship, ineligibility or no published value.
- University description: inspect current deployed controls and lineage, establish the authoritative decision rules, and align the existing playbook and role guide. Keep this separate from evidence remediation for other kinds.

## 4. Fix causes across providers

Group recurring gaps by root cause and reuse existing integration issue fingerprints. Repair common evidence/lineage/UI problems once; validate across affected universities and kinds. Do not create a second task register, dashboard or error queue.

Prefer existing evidence, free recovery routes and existing settings/jobs. Respect current ingestion holds, approved budgets and admission authority. No unapproved paid crawl, AI re-check, broad re-read, bulk approval, direct SQL admission, destructive housekeeping or consumer API change.

Continue independent authorised work while genuine external blockers are tracked. Upstream automated validation must not impersonate a human Layer 4 decision.

## 5. Make readiness and results reviewable

Update the existing CSV audit attachment with stable IDs, university/kind, missing facts, responsible layer, evidence references, recovery action, actual action taken, timestamp, submission flag, saved decision/event reference where available, verification, owner and next action. Separate review recommendations from saved decisions and recovered evidence from admitted data. Retain historical evidence and action history.

For each repaired route prove:
1. The upstream evidence is correct and current.
2. Layer 4 displays it against the right pending item.
3. The existing authorised UI action can use it.
4. Any decision actually submitted is persisted and its downstream outcome verified.

Coordinate with ChatGPT’s dedicated UI reviewer; do not decide concurrently on the same refs. If that reviewer retains settlement ownership, prepare evidence-backed recommendations and return a resumable provider-by-provider handover.

Use applicable V1–V4 checks and existing continuous validation. Detect evidence gaps incrementally, deduplicate unchanged failures, reopen regressions and report through existing operational channels. No new notification subscription is implied.

## Deliver and continue

Record the mandate before code and update the existing execution register and feedback queue. Provide:
- An audit verdict on ChatGPT’s work and any corrections.
- A concise missing-information matrix by kind and responsible layer.
- The 24-item reconciled CSV, with resolved versus unresolved evidence gaps.
- Common fixes, releases and verified production effects.
- Ready-for-review items and remaining blockers with owners.
- An exact resume point for university-by-university settlement.

Report inspected, evidence-ready, decisions submitted, saved/verified, admissions, exceptions and new arrivals separately. Do not declare the programme complete from a CSV, deployment or queue reduction. Commit the durable report before replying, then continue authorised remediation until acceptance is verified or only genuine external blockers remain.
