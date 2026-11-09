<!-- Recorded verbatim: Platform Admin, received 2 Nov 2026 11:10 AEDT (chat). -->

StudySearch — Complete AU Database Export and Wix Enrichment Closure

Continue existing approved engineering and remediation workstreams. Do not pause them for this reporting task.

1. Complete the outstanding Australian course export

Produce a complete, read-only export from the current database, not a sample or aggregate coverage summary.

Include every Australian course held in the catalogue, with publication and lifecycle status retained, and identify the subset exposed by Website API v2.

Create an Excel workbook with separate worksheets for:

1. Courses — all core fields and values.
2. Course fees — all fee types, basis, amount, currency, audience, year, status and evidence.
3. Course intakes — months, years, exact dates, deadlines, campuses and source status.
4. Course entry requirements — academic, country, qualification, audience, grades, conditions, status and evidence.
5. English requirements — tests, overall scores, component scores, applicability and source.
6. Course scholarships — linked awards, eligibility evidence, relationship status and truncation.
7. Scholarship master — all stored scholarship attributes.
8. Provider rankings — QS, THE and other supported rankings, edition and source.
9. Provider entry matrices — qualifications, countries, benchmark bands and applicable study levels.
10. Course links and campuses — source identities, primary links, held records and delivery locations.
11. Website API v2 field reconciliation — database value, projection value and consumer field.
12. Field-state reconciliation — available, missing, processing, Layer 4 pending, quality-held, rejected and not applicable.
13. Data dictionary and coverage statistics.

Use stable IDs and preserve one-to-many relationships in separate sheets. Do not flatten away multiple entry requirements, fees, scholarship links or ranking editions.

Do not fabricate values or treat null as a negative conclusion.

Export in bounded, paginated batches using a safe snapshot strategy. Avoid heavy scans during admission job windows. For large results, produce multiple CSV files with an Excel index if required.

Reconcile row counts, distinct IDs and source snapshots. Report omitted or inaccessible datasets explicitly.

2. Fix the identified Wix enrichment gaps

Prioritise persistence of intake year, actual start date and application deadline where the existing calendar reader already extracts those values.

Use the approximately 16,650 verified stored Australian course pages for description extraction before authorising new source reads.

Conduct a small, cost-capped pilot for university About pages and present the actual cost ceiling for approval before paid acquisition.

Do not introduce a new Layer 4 review type if an existing kind safely supports the same evidence and decision rules.

Do not restart all four paused discovery jobs without a measured need and existing approval.

3. Preserve the Website API v2 contract

Document the current value, source field and null semantics for each consumer field.

Prepare a proposal for separate field-state metadata rather than putting text placeholders into numeric, date, boolean, array or URL fields.

Distinguish:

- Not provided by institution.
- Being processed.
- Awaiting Layer 4 review.
- Withheld for evidence or identity concerns.
- Confirmed not applicable.
- Verified value available.

Any consumer API shape change requires the existing G3 approval and Wix handover process.

4. Delivery requirements

Store the export manifest, field mapping, reconciliation and evidence report in the Admin repository.

Provide the generated files or their actual accessible locations, row counts, snapshot time, unresolved limitations and data-quality exceptions.

Do not report the export as complete until all Australian courses and the related child datasets have been reconciled.

Continue the approved scheduler stagger, E16 containment, deployed UAT and recovery work independently.

Primary deliverable: the complete Australian database-held course-fields export, including scholarships, rankings and entry requirements, with an exact Wix API comparison.