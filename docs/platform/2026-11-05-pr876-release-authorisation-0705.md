# PR #876 release authorisation (Platform Admin, 5 Nov 2026 07:05 AEDT)

**Instruction (verbatim):** "Review PR876 which provides the fix for pr872, if all test pass merge it and ill test it from ui."

## Scope

- Codex PR #876 (`codex/intake-preview-timeout`, e88cb25d): Preview statement timeout (SQLSTATE 57014) in Course Intake Run & Validate after v2.15.478.
- Authority: review, full release gate, merge and deploy of #876 only. The Platform Admin performs the UI acceptance (Preview, fix cohort, Run Now once); the Integration Controller verifies the data and gives the verdict.
- Unchanged: the engineering hold (21:59) for all other work; #875 stays held; no setting, cohort, spend or timeout change is made by the Integration Controller on its own.

## Integration Controller review notes

- Live guard hashes match the migration (course_title_key 6dbf3327, immutable; course_page_check_v1 c8bf35fe; intake_ui_selection_v1 629006a8).
- Index targets are small (catalogue.courses 44,391 rows / 56 MB; pipeline.coverage_course_pages 35,709 rows / 61 MB); the build-time write block is brief.
- Production read-only measurement 07:16 at the PR default (5 rows per university): 50 rows evaluated, 2 eligible courses / 5 values (UNSW only). Preview should complete, but on the default setting the cohort is expected to be about 2 courses, below the 10-value acceptance target (likely BLOCKED, not FAIL). Raising `run_now.preview_rows_per_university` is a Platform Admin setting change with a reason, after a measured latency check.
