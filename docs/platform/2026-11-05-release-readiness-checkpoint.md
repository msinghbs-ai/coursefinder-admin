# Release-readiness checkpoint, 5 Nov 2026 (Platform Admin direction 21:00)

Each release is authorised separately. Nothing below has been merged or deployed.

| PR | Head | Independent review (agent E) | CI | Full local suite | Merge blockers |
|---|---|---|---|---|---|
| #887 Course Catalogue columns | e07a4122 | Ready with conditions; conditions met | Workers Builds, build-and-smoke, release-history-contract, course-columns-isolated-postgres green | 1,921 passed, 0 failed, 0 skipped | None |
| #889 Intake Automation Progress | 51ca8d1b | Ready with conditions; conditions met; Controller reviewed the later delta | Workers Builds, build-and-smoke, both isolated-postgres, integration workflows green | 1,916 passed, 0 failed, 0 skipped | None. Decide on the first-run false positive (accept with triage note) |
| #877 Provider descriptions | cf3f245b | Ready (re-validation after blocking fixes) | Workers Builds, build-and-smoke, provider-description, isolated-postgres green; release-history-contract runs at integration | 1,924 passed, 0 failed, 0 skipped | None |

Separate (not in this checkpoint):
- #890 R23/R24: awaiting G3 approval (`approvals/2026-11-06-g3-r23-r24-approval-package.md`).
- #875: held.
- #888: integrated, CI-only.
