# Platform Admin mandate — Customisable Course Catalogue Columns and Data Freshness (5 Nov 2026, 17:31 AEDT)

Recorded verbatim as received. Status: queued behind the intake operator-visibility follow-up (decision 16:36 §9); one bounded PR; release only on authorisation (engineering hold).

```text

StudySearch — Customisable Course Catalogue Columns and Data Freshness

Platform Admin mandate — 5 November 2026

Implement configurable, persistent columns within the existing StudySearch Admin Course Catalogue screen.

The objective is operational visibility: an operator must be able to examine different course fields, determine which data is populated or missing, and sort courses by recently admitted or modified information.

This is a bounded UI improvement, not a redesign of the Course Catalogue or enrichment pipeline.

1. Audit existing functionality first

Read the canonical operating model, current Pilot rules and existing Course Catalogue implementation.

Identify:

- Current table and column definitions.
- Existing search, filters, pagination and sorting.
- Existing saved user preferences.
- Current course-list API and database projection.
- Available field values and enrichment states.
- Existing adapter statuses.
- Field admission timestamps and audit records.
- Mobile layout and performance constraints.

Reuse or extend existing components and preference storage.

Do not build a competing course table or duplicate data endpoints.

2. Column selection

Add a Columns control above the Course Catalogue table.

The operator must be able to:

- Search the list of available columns.
- Tick columns to show.
- Untick columns to hide.
- Reorder columns.
- Resize column widths.
- Apply a selection immediately.
- Restore the default layout.

Keep course identity accessible, including the course title and appropriate course code.

Organise the column selector into useful groups:

Identity

- Course title.
- Course code / CRICOS code.
- Provider.
- Country.
- State.
- City.
- Campus.
- Study level.
- Study area.

Course information

- Duration.
- Delivery mode.
- Tuition.
- Fee year.
- Intake month.
- Intake year.
- Exact commencement date.
- Application deadline.
- English requirements.
- Academic entry requirements.
- Scholarships.
- Course description.
- Official course URL.

Pipeline and enrichment

- Adapter status.
- Adapter last read.
- Adapter result.
- Stored course page available.
- Source identity status.
- Evidence last verified.
- Layer 4 status.
- Enrichment status.
- Last successful field admission.

Lifecycle and timestamps

- Created date.
- Last modified.
- Last data admitted.
- Last source update.
- Last published.
- Lifecycle status.

Expose only fields supported by existing verified data contracts.

Do not invent values or calculate misleading timestamps.

3. Adapter and city columns

Add the specifically requested columns.

Adapter

Display a concise status such as:

- Ready.
- Processing.
- Completed.
- Held.
- Failed.
- Not configured.

Use the existing adapter lifecycle and results.

Allow the operator to open the relevant existing adapter or processing detail.

Do not infer adapter completion merely because an adapter exists.

City

Display the actual city or cities associated with the course's linked campuses.

For multiple campuses, provide a concise display with an expandable list.

Preserve country/state context where required to distinguish identically named cities.

Do not automatically copy the provider's headquarters city onto every course.

4. Last modified and last admitted

These are separate concepts.

Last modified

The timestamp of the latest actual persisted change to the relevant course record.

Last data admitted

The timestamp of the most recent successfully admitted course field or related authorised enrichment value.

Do not use a scheduled reader run, rejected proposal, unchanged update or catalogue refresh as a new admission.

Where possible, expose:

- Field changed.
- Previous value.
- New value.
- Admission timestamp.
- Admission source.
- Applicable Layer 4 or automated rule.
- Source evidence reference.

Allow sorting by both timestamps, newest or oldest first.

Use the platform's existing authoritative change/admission records; verify them against the schema before implementation.

If a trustworthy historical timestamp is unavailable, show Unknown rather than inventing one.

5. Per-user preferences

Persist the following by authenticated user:

- Visible columns.
- Column order.
- Preferred widths.
- Sorting field.
- Sorting direction.

Restore the user's last saved layout when opening Course Catalogue from another device or browser.

Use the existing per-user settings mechanism where suitable.

Preferences must not change another operator's layout.

Provide:

- Reset to default.
- Optional restore of the last saved view.
- Clear acknowledgement when the user's configuration is saved.

The default layout must remain usable for new users and accounts with no saved settings.

6. Fluid responsive layout

The table must support:

- Resizable columns.
- Minimum readable column widths.
- Horizontal scrolling when needed.
- Sticky headers.
- Stable table layout during paging.
- Readable long text.
- Desktop and mobile use.
- Existing course-row click behaviour.
- No unnecessary full-page refresh.

Do not force every selected column to fit into a phone-width viewport.

A wide, horizontally scrollable table is preferable to unreadably compressed data.

Retain appropriate accessibility and keyboard interaction.

7. Field completeness visibility

The operator should be able to distinguish:

- Populated.
- Missing.
- Pending extraction.
- Waiting for review.
- Held by validation.
- Not applicable.
- Failed.

Use existing field-state definitions.

Where an enrichment value is missing, provide the existing reason or a link to its operational detail if available.

Do not turn an empty field into a misleading zero or No value.

Provide a column selector count and a clear indication of the active sort.

8. Accurate server-side sorting

Sorting must operate on the entire filtered result set, not merely the currently loaded page.

Where supported, include server-side sorting for:

- Last modified.
- Last data admitted.
- Provider.
- City.
- Adapter state.
- Course title.

Retain existing filtering and pagination semantics.

Avoid per-course database calls or row-by-row enrichment lookups when displaying the table.

Benchmark performance using production-representative course volumes.

If an optional field is expensive to retrieve, use a bounded existing projection or aggregate rather than adding N+1 queries.

9. Automation compatibility gate

Before changing existing course-list functions, assess:

- Current provider/course lifecycle processing.
- Existing adapter and enrichment mechanisms.
- Search/index refresh behaviour.
- Manual locks and admission controls.
- Course filters and paging.
- Existing personal settings.
- Website and Zoho consumer contracts.

Record Reuses, Changes, Replaces, Retires, Conflicts and Protects.

Do not overwrite existing user preference data.

Do not alter background automation plans or admission authority.

Any obsolete table-view mechanism should be retired only under established governance.

10. Production-schema and UI tests

Apply the lessons from the previous intake releases.

Use production-representative database constraints, roles and function signatures.

Test:

1. Show and hide columns.
2. Persist preferences.
3. Restore saved preferences after sign-out and sign-in.
4. Reset to default.
5. Reorder and resize columns.
6. Server-side sorting across pages.
7. Multiple cities for one course.
8. Adapter status correctly populated.
9. Last modified versus last admitted distinction.
10. No fabricated timestamps.
11. Existing search, filters and pagination.
12. Read-only roles and permission boundaries.
13. Desktop and phone layouts.
14. Performance with many selected columns.
15. Backward compatibility with the existing Course Catalogue.

No synthetic-only acceptance.

11. Release and validation

Develop as one bounded PR.

Complete all normal test, production-schema parity, CI and release gates.

Do not automatically release while unrelated engineering work is under an active hold.

After authorised deployment, verify from the actual Admin UI:

- Column selection works.
- User preferences survive refresh and new sessions.
- Reset restores the default.
- Adapter and city fields reflect real catalogue data.
- Last admitted sorting correctly identifies recently admitted courses.
- Timestamps match authoritative source records.
- Wide tables remain usable on mobile.
- Existing search, filtering and paging are unaffected.

Record the PR, version, test results and operational acceptance in the existing Admin execution register.

Definition of done: Operators can customise the Course Catalogue table to inspect course data, adapter state and field freshness; their choices persist per user, and the table remains accurate and performant without changing the underlying enrichment automation.
```
