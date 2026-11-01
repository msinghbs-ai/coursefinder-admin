<!-- Recorded verbatim: Platform Admin, received 2 Nov 2026 10:28 AEDT (chat), with the Wix developer hand-off PDF (docs/integrations/wix/2026-11-02-AUSTRALIA_DATA_TEAM_HANDOFF.pdf; text extract alongside). -->

# StudySearch — Additional Mandate: Automated Missing-Field Enrichment and Scheduled Readers

**Platform Admin instruction — 2 November 2026**

Add this workstream to the current continuous-delivery programme.

## 1. Objective

Implement sustainable, scheduled enrichment for missing university and course information identified in the Wix developer's `AUSTRALIA_DATA_TEAM_HANDOFF.pdf`.

The platform must progressively fill supported missing values through existing ingestion, evidence, AI interpretation and Layer 4 workflows.

Do not require Claude or the Platform Admin to manually initiate enrichment for every university or course.

**Reuse the existing Layer 2 readers, Layer 3 AI enrichment, scheduling framework, evidence storage, field registry and Layer 4 admission mechanisms.**

Do not build a competing enrichment subsystem.

## 2. Priority 1 — University descriptions

The Wix report confirms:

- 45 Australian universities assessed.
- 0 descriptions populated.
- 45 descriptions missing.

Create or extend the university/provider description reader.

### Reader requirements

1. Identify the verified official university website.
2. Discover the relevant About, Overview or institutional profile page.
3. Reuse existing stored evidence before fetching a page.
4. Extract an accurate institutional description.
5. Use the existing AI enrichment mechanism to produce concise, factual, student-facing text where appropriate.
6. Verify that statements are supported by the official source.
7. Preserve the source URL, evidence ID, source timestamp, last verification date and AI extraction metadata.
8. Detect duplicate or outdated descriptions.
9. Submit proposed descriptions through the appropriate existing admission and review controls.
10. Publish only approved values.

Do not invent rankings, facilities, employment outcomes, accreditations or other claims merely to improve the description.

A missing description may remain unpublished while its source is unavailable or under review.

## 3. Priority 2 — Course descriptions

The Wix developer sampled 26 course-detail responses and found all 26 descriptions empty.

This is a sample finding, not proof that every course lacks a description.

First calculate actual database-wide and Website API v2 coverage by country, provider and course.

Create or extend the course description reader to:

1. Resolve the exact provider and course identity.
2. Verify course code, qualification level, programme variant and intended audience.
3. Select the correct official course page.
4. Reuse an existing verified page snapshot wherever possible.
5. Extract the course overview, curriculum summary or official programme description.
6. Generate concise, evidence-grounded text only when the source supports it.
7. Reject descriptions originating from sibling qualifications or unrelated programmes.
8. Respect manual edits and existing approved descriptions.
9. Retain full provenance and verification metadata.
10. Admit through the existing governed field workflow.

Course descriptions must not confuse Graduate Certificates, Graduate Diplomas, Master's degrees, nested awards or different programme years.

The new E16 binding safeguards must apply before extraction.

## 4. Priority 3 — Remaining missing fields identified by Wix

Use the PDF's course, university and scholarship coverage tables to build a field-level enrichment backlog.

Include:

| Field or group | Missing / unstated in report | Required action |
|---|---:|---|
| University description | 45/45 | Institutional description reader |
| Course description | 26/26 sampled | Full-population assessment, then course reader |
| Course official URL | 5,980/23,732 | Existing verified binding workflow |
| Intake month | 14,328/23,732 | Course-specific intake reader |
| Intake year | 23,732/23,732 | Year-aware intake extraction |
| Exact start date | 23,732/23,732 | Extract only officially stated dates |
| Application deadline | 23,732/23,732 | Deadline extraction with rolling-date semantics |
| Fee year | 15,338/23,732 | Existing fee provenance and year validation |
| English requirements | 7,688/23,732 | Existing English reader, with applicability scope |
| English minimum band score | 15,138/23,732 | Separate component-score validation |
| Academic entry summary in search | 23,732/23,732 | Verify detail availability and API projection contract |
| University academic entry matrix | 40/45 universities | Existing academic equivalence/entry workflow |
| Scholarship structured amount | 34/892 | Benefit classification validation |
| Scholarship nationality restrictions | 832/892 | Evidence-based eligibility extraction |
| Scholarship application details | Variable | Existing scholarship reader and eligibility workflow |

These are the PDF's reported counts, not guaranteed current live counts.

Reconcile live coverage before creating any jobs.

Do not interpret an empty field as proof that the university or course does not offer that feature.

## 5. Scheduler and reader design

For each missing field, first check whether an existing reader, scheduler or automation can be extended.

Use the existing automation catalogue and job infrastructure.

Create or extend scheduled jobs for:

**A. Provider Description Enrichment**
- Scope: missing, unverified or stale provider descriptions.
- Initial priority: the 45 Australian universities.
- Processing: reuse stored official About/Overview pages, then authorised acquisition.
- Output: evidence-backed description proposals.

**B. Course Description Enrichment**
- Scope: missing, unverified or stale course descriptions.
- Processing: provider-by-provider, bounded batches.
- Output: course-specific description proposals with exact binding proof.

**C. Missing-Field Enrichment Dispatcher**
- Scope: intake, English, fee-year and other fields where existing readers already support acquisition.
- Processing: eligible missing values selected using configurable priorities and source availability.
- Output: existing field-specific enrichment queues, not a new generic AI write path.

**D. Scheduled Coverage Reconciliation**
- Scope: compare actual source coverage, proposed values, approved values and Website API v2 projections.
- Output: dashboard metrics, exceptions and next eligible batches.

Use existing job names where equivalent capabilities already exist. Create a new job only when no suitable existing job can safely perform the function.

### Operational safeguards

- Configurable frequency and batch size.
- Per-country and per-provider scheduling.
- Bounded concurrency and retries.
- Existing AI and Firecrawl spending limits.
- Source snapshot reuse before paid acquisition.
- No heavy whole-catalogue scans during production admission windows.
- Idempotency and duplicate-job prevention.
- Dead-letter handling and recovery.
- Pause, resume and retry through existing authorised controls.
- No uncontrolled Layer 4 queue growth.

Initial runs should use isolated fixtures followed by a small supervised production pilot.

## 6. Missing-field status and Wix display

Introduce a consistent internal field-state interpretation using the existing status and evidence mechanisms.

Distinguish:

- `available`
- `not_provided`
- `processing`
- `under_review`
- `held_quality`
- `not_applicable`
- `confirmed_negative`

A field must be labelled `under_review` only when it has an actual pending Layer 4 review item.

Do not replace numeric, date, URL, boolean or array values with explanatory text.

Retain raw null semantics and prepare a field-state mapping for Wix presentation.

Any new Website API v2 metadata requires the existing G3 compatibility and consumer approval process.

Do not change Wix or Zoho API shapes during this workstream without authorisation.

## 7. Admission and quality control

Every reader must use the existing governed lifecycle:

Discover → Verify identity → Reuse/acquire source → Extract → Validate → Propose → Review/admit → Verify publication.

A description cannot be admitted merely because AI has generated fluent text.

Require:

- Official source relevance.
- Correct provider/course identity.
- Supported factual claims.
- Suitable language and length.
- No unsupported marketing claims.
- No sibling-programme contamination.
- Complete source/evidence linkage.
- Current field-specific admission authority.

Use Layer 4 for genuine review decisions, not for every ordinary missing value.

Retain unsupported values as missing or held rather than publishing guessed information.

## 8. Monitoring and completion metrics

Expose the following through the existing operational dashboard:

- Total eligible providers/courses.
- Description present, missing, proposed, held and admitted.
- Source pages already available.
- New pages acquired.
- AI reads performed.
- Successful verified admissions.
- Rejections and reasons.
- Layer 4 queue movement.
- Failed and retried jobs.
- Cost per verified description.
- Processing throughput.
- Last successful run.
- Remaining eligible backlog.

Provide field-level coverage by country and provider.

A scheduled reader is not complete merely because it runs successfully. It is complete when it demonstrably improves verified coverage without creating incorrect published values or uncontrolled review/cost growth.

## 9. Implementation and release sequence

1. Reconcile the latest Wix PDF against actual live database and API coverage.
2. Identify existing readers and jobs supporting each field.
3. Record required extensions and Replaces/Retires decisions in Admin.
4. Complete Provider Description enrichment first.
5. Complete Course Description enrichment next.
6. Integrate additional missing fields into existing specialist readers.
7. Implement configured scheduling, monitoring and recovery.
8. Run fixture testing.
9. Run a bounded pilot on representative universities and courses.
10. Verify actual values through Website API v2.
11. Enable governed ongoing scheduling under existing permissions.
12. Produce a before/after coverage and cost report.

Use parallel agents for reader development, evidence validation, scheduling, testing and Wix contract verification.

One integrator controls releases and production writes.

## 10. Project completion boundary

This workstream must not restart an indefinite enrichment project or postpone operational handover merely because some universities or courses do not provide a description.

The closure requirement is:

- Readers and scheduled workflows work reliably.
- New incorrect data is prevented.
- Existing missing values are progressively processed.
- Unsupported values remain safely withheld.
- Coverage and cost are measurable.
- Genuine review items enter Layer 4.
- The operating process no longer depends on manually prompting Claude.

Once these conditions are verified, remaining source-unavailable records become normal platform operations.

**Implement the smallest sustainable extension of the current architecture. Prioritise descriptions, reuse existing readers, enforce evidence-backed admission and demonstrate measurable coverage improvement through scheduled operation.**