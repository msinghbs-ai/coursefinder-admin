<!-- Recorded verbatim by the Integration Controller. Received 5 Nov 2026 22:52 (Australia/Melbourne). -->

Platform Admin — PR #887 release authorisation

Approve the controlled merge and production deployment of PR #887, Course Catalogue customisable columns, at reviewed commit "e07a4122", subject to the final production-function hash checks and normal release gates.

Assign the next available release number.

After deployment, validate the actual Admin Course Catalogue:

1. Show/hide, reorder and resize columns.
2. Confirm saved layouts persist after refresh, sign-out/sign-in and across authenticated sessions.
3. Confirm Reset to default restores the original view.
4. Verify per-user isolation and unauthenticated access refusal.
5. Verify Adapter status, City, Intake month/year, commencement date, deadline, Last data admitted and Last published against real records.
6. Sort by Last data admitted and verify newest admitted records appear first across the entire filtered dataset.
7. Confirm search, filters, paging and course-row navigation remain unchanged.
8. Confirm desktop and mobile usability.
9. Verify consumer API compatibility and Course Catalogue performance.
10. Test both layout recovery switches without losing saved preferences.

Record PASS, FAIL or BLOCKED, the release version, production evidence and any outstanding defects in the existing Admin execution register.

If a gate fails, stop further discretionary releases and preserve or restore the known-good configuration using the governed recovery process.

Do not merge #877 or #889 under this authorisation.
