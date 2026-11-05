<!-- Recorded verbatim by the Integration Controller. Received 5 Nov 2026 22:46 (Australia/Melbourne). -->

StudySearch — PR #889 false-positive correction

Choose Option 2, with one adjustment: incorporate the correction into the existing PR #889 before release. Do not create another PR.

The 167 UNSW rows were legitimately reconsidered after the 15:56 governed change to "intake_dates.month_unique_match".

The monitoring logic must not classify such reconsideration as an ineffective repeated attempt.

Required:

1. Reuse existing intake event history, reader versions, settings-change audit records and available source fingerprints.
2. Detect repeat failures only when the relevant evidence, reader and settings are demonstrably unchanged.
3. Exclude legitimate rechecks following an applicable governed setting change, reader revision or source update.
4. Where the historical input state cannot be established, report "unverified_repeat" or equivalent diagnostic status rather than raising a confirmed repeated-failure issue.
5. Ensure stable issue fingerprints and deduplication.
6. Preserve the existing scholarship and AER observer results byte-for-byte where applicable.
7. Add a regression test reproducing the 167 legitimate UNSW rechecks.
8. Keep the current five-second lock timeout and intake-only monitoring switch.
9. Re-run focused tests, the full required suite and CI.

Do not add new intake-processing mechanisms, duplicate observers or additional per-row tracking solely for this correction.

After validation, provide the final #889 release-readiness verdict for Platform Admin approval.

Keep #877 ready and continue #887's independent test gate without blocking their development.
