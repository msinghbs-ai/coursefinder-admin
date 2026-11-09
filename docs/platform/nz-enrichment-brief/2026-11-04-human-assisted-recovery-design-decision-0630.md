# StudySearch — Mandatory Human-Assisted Recovery Across All Admission Layers

**Platform Admin design decision — immediate amendment to SS-018, SS-019 and SS-021**

The platform must never indefinitely block eligible work because it cannot discover a source, interpret a document, identify a course or complete a field extraction.

This requirement applies to all data admission processes: providers, courses, AER, scholarships, fees, intakes, rankings, course links and enrichment fields.

## 1. AI-first recovery, followed by actionable Layer 4 intervention

Introduce or extend a common recovery sequence:

1. Detect the missing information or failed process.
2. Examine stored evidence, existing records, prior decisions and source history.
3. Attempt approved autonomous recovery.
4. Escalate to a stronger AI reasoning model when the failure is genuinely interpretative and within existing cost authority.
5. Validate its proposed resolution against official evidence.
6. If still unresolved, identify exactly what human input is required.
7. Create one deduplicated, actionable Layer 4 intervention.
8. Park only the affected work, release worker capacity and continue other eligible records.
9. Automatically resume processing when the intervention is completed.
10. Verify admission, publication and consumer results where applicable.

Use the existing AI provider/model routing and budget controls. Higher reasoning capability is a targeted fallback, not permission for unrestricted AI calls.

AI must not invent source URLs, scores, eligibility, fees or admission decisions.

## 2. Expand Layer 4 beyond approve/reject

Reuse existing Layer 4 categories where supported. Add new governed intervention types only where no suitable action exists.

Support the following operator actions through existing or extended UI controls:

- Provide or correct an official source URL.
- Attach or reference an authoritative document.
- Enter missing structured information.
- Confirm provider/course/scholarship identity.
- Select an authoritative source.
- Confirm applicable country, qualification, campus or audience.
- Correct an AI-extracted value against quoted evidence.
- Request a fresh source search.
- Confirm that an eligible source is not published.
- Return the item to the appropriate technical recovery stage.
- Reject unsupported evidence.

Manual entry must follow the same identity, provenance, field validation, ownership and admission rules as automatically extracted data.

Providing a URL or document is **not itself approval to publish**.

## 3. Layer 4 must explain the required decision

Each intervention must display:

**Issue summary**
- Exact provider, course, scholarship or field.
- What the platform attempted.
- Why it could not finish.
- Impact on admission or publication.

**Evidence**
- Official source links.
- Available stored copies.
- Relevant quotations.
- Previous extraction attempts.
- Conflicting values or missing information.
- AI-generated analysis, confidence and uncertainty.

**Recommended intervention**
- The next best action.
- Specific missing information.
- Suggested answer or source where supported.
- Explanation of how the response will unblock processing.

**Resolution**
- Role-authorised action controls.
- Supporting document or manual-entry fields.
- Audit trail and reviewer identity.
- Downstream processing to be resumed.
- Verification and final admission/publication status.

The reviewer should be able to resolve ordinary source and data gaps without opening SQL, running scripts or asking Claude to repair individual records.

## 4. Apply immediately to the missing AER universities

For ACU, CQU and Deakin:

- Review the stored-source inventory and previous discovery failures.
- Use existing authorised discovery and reader routes first.
- Apply higher-reasoning analysis where source structure or identity requires it.
- For unresolved sources, create actionable Layer 4 interventions requesting the specific official URL, document or course mapping.
- Prepopulate each intervention with evidence already held by the platform.
- Allow a reviewer to supply the missing source or structured information.
- Automatically validate and restart the appropriate reader after the intervention is saved.
- Continue all other universities and courses during this process.

Extend the same process to CDU, UniSQ, UNE, Torrens, JCU, RMIT, UWA and every other eligible provider with unresolved requirements.

Do not repeatedly create new review items for an unchanged failure.

## 5. Apply across all other data admissions

Use the same intervention and automatic-resumption contract for:

- Scholarship discovery, eligibility, ownership and publication.
- Fee evidence, audience, academic year and calculation problems.
- Intake commencement and application deadline extraction.
- Missing or incorrect course pages.
- Provider websites, identity and lifecycle.
- Ranking source and entity matching.
- Course descriptions and other supported enrichment fields.

Avoid independent, incompatible human-review mechanisms for each workstream.

Reuse the current Layer 4 architecture, evidence model, admission guards and audit infrastructure.

## 6. Time-bound resolution and queue continuity

Every unresolved item must have a configured:

- Maximum automated attempts.
- Escalation trigger.
- Next automatic action time.
- Human-intervention status.
- Assigned responsibility.
- Recheck condition.
- Recovery deadline.
- Verified final outcome.

Use appropriate configurable thresholds by failure class.

An intervention awaiting a human response must not:

- Repeatedly spend credits on unchanged evidence.
- Hold an active worker lease.
- Block another provider or course.
- Prevent unrelated fields being enriched.
- Produce repeated identical Layer 4 items.
- Be counted as an admitted value.

Layer 4 queue capacity must be managed by readiness and genuine decision requirements, without increasing or bypassing existing safety limits.

## 7. Automatic resumption is mandatory

When the reviewer provides a URL, document, corrected value or identity resolution:

1. Save the decision and evidence with an audit record.
2. Validate the supplied information.
3. Mark the affected dependency as resolved only when validation passes.
4. Automatically schedule the next eligible pipeline operation.
5. Reuse stored evidence rather than purchasing another read unnecessarily.
6. Apply all existing Layer 3 and Layer 4 admission checks.
7. Verify catalogue and consumer publication.
8. Close or reopen the existing integration issue based on the actual result.

If the supplied information remains insufficient, return a specific, updated request to the existing review item rather than starting an unrelated investigation.

## 8. Test the full recovery lifecycle

Demonstrate end-to-end examples for:

- Missing AER source URL.
- Rendered or inaccessible requirement document.
- Ambiguous course identity.
- Missing scholarship eligibility.
- Conflicting tuition evidence.
- Incomplete intake information.

Tests must prove that:

- The platform identifies the missing fact.
- AI attempts an authorised resolution.
- Layer 4 requests meaningful human assistance only when needed.
- The reviewer can provide the information.
- The platform resumes automatically.
- Valid data progresses to admission and publication.
- Other work continues throughout.

Retain all existing approval, manual-lock, destructive-action, security and consumer API restrictions.

## 9. Operational reporting

Add the following metrics to the existing Admin reporting rather than creating another dashboard:

| Workstream | Automatically resolved | Human input needed | Human resolved | Resumed | Admitted | Published | Still blocked |
|---|---:|---:|---:|---:|---:|---:|---:|

Report average time from intervention creation to automatic resumption, unresolved intervention age and recovery success rates.

Record every change in the canonical execution register and existing integration queue.

## Acceptance

This design is complete only when a normal operator can resolve a missing source or evidence gap through Layer 4, and the platform independently resumes the original work.

**Claude and ChatGPT must not remain routine intermediaries for individual data problems. They develop, govern and independently validate the system; the platform performs normal recovery.**

Implement this centrally as a permanent StudySearch capability, prioritising missing AER sources and scholarship coverage, while preserving uninterrupted processing of other eligible work.