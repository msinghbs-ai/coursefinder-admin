<!-- Recorded verbatim by the Integration Controller. Received 6 Nov 2026 07:00 (Australia/Melbourne). -->

Platform Admin — Authorise PR #891 (v2.15.487)

Approve the controlled release of PR #891 to correct the Course Catalogue Columns panel.

Proceed once the final full suite, generated test register and required CI checks pass.

Deploy during the existing safe release window.

Production acceptance:

1. Confirm all 40 column checkboxes can be operated on desktop and phone.
2. Test show/hide, reorder and resize.
3. Confirm the Saved acknowledgement appears inside the panel on mobile.
4. Refresh and verify the layout persists.
5. Reset to default and confirm the original layout is restored.
6. Verify the fix does not interfere with existing data-quality styles, search, filters, sorting or paging.
7. Confirm the new CSS collision guard works in CI.

Record production PASS/FAIL/BLOCKED and the release evidence in the Admin execution register.

Do not repeat unrelated acceptance tests already verified under v2.15.486 unless the changed code affects them.

The Platform Admin sign-out/sign-in test remains pending until completed.

Keep #877, #889 and #890 outside this release. Do not resume unrelated discretionary deployments.
