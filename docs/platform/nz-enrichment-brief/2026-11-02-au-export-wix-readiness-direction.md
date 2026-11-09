<!-- Recorded verbatim: Platform Admin, received 2 Nov 2026 11:18 AEDT (chat). -->

StudySearch — Complete AU Export and Wix Data Readiness

Continue the existing approved workstreams. Do not restart completed investigations or request another general GO.

Priority 1 — Deliver the complete export

Finish the one-off GitHub Actions export workflow using the existing authorised read-only database credentials.

Requirements:

- Export every Australian course held in the catalogue, not only courses visible in Website API v2.
- Include all related fees, campuses, links, intakes, English requirements, academic entry requirements, scholarships, scholarship-course associations, provider rankings, entry matrices and evidence/publication states.
- Preserve stable IDs and one-to-many relationships.
- Include the exact fields currently served to Wix.
- Distinguish source-held values, admitted values, held/rejected values and consumer-visible values.
- Produce all 13 datasets, an Excel index, data dictionary and manifest.
- Validate row counts, distinct IDs, referential integrity and reconciliation against the Website API's Australian population.
- Record exact snapshot time, source commit, queries used and dataset limitations.
- Keep database credentials and exported data out of Git commits and workflow logs.
- Use the private workflow artifact with the agreed 14-day retention.

Do not leave a long-running transaction idle across admission scheduling windows. Validate the snapshot method and production impact before execution.

Completion means the files exist, all expected datasets reconcile, and the artifact can be downloaded.

Priority 2 — Correct Wix enrichment gaps

Complete the intake-date persistence fix and demonstrate actual dates flowing from stored evidence through catalogue, search projection and consumer API.

Continue fixture testing for course descriptions using verified stored pages.

Prepare the university-description acquisition pilot with an exact cost ceiling, but do not incur unapproved paid acquisition.

Keep unrelated discovery jobs paused.

Priority 3 — Field availability states

Prepare the Wix metadata contract for:

- Available
- Not provided by source
- Processing
- Awaiting Layer 4
- Held for quality verification
- Not applicable
- Confirmed unavailable

Do not replace numeric, date, array or URL values with text.

Maintain API v2 compatibility and the existing G3 approval boundary.

Priority 4 — Existing operational work

Complete v2.15.403 deployment verification, the approved E16 containment, housekeeping and budget-control work independently.

Do not make the full database export wait for unrelated releases once its own checks pass.

Progress reporting

At every substantial checkpoint show:

- Export: datasets completed/13, row counts, reconciled counts, artifact status.
- Wix enrichment: intake, course descriptions, university descriptions.
- Platform releases and live verification.
- E16 and housekeeping status.
- Exact remaining blockers and decisions.

Do not report the export as complete merely because its workflow is built.

Immediate goal: deliver the complete, downloadable Australian course-data export before expanding the Wix enrichment scope.
