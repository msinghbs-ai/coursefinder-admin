# PR #879 (Codex): intake complete scan and one-action Run Now — closed without merge

- **PR:** msinghbs-ai/Coursefinder-Pilot #879, branch `codex/intake-complete-scan`, head `10a58e70a0a189bd9680e14f2fc25560030035f2` (4 Nov 2026), based on v2.15.479 (820ac18f).
- **Closed:** 5 Nov 2026, without merge. Platform Admin 20:03: "Assess #879 for closure without merge if superseded"; "Do not restart discretionary intake development".
- **Why closed:** independent validation (`validation/2026-11-05-pr879-intake-complete-scan-readiness.md`) found:
  - it pages and checks cohorts against `intake_dates_plan_v2`, which is retiring and has no callers; the live path is `intake_dates_plan_v3` (1d531a83, v2.15.485);
  - `intake_ui_selection_v1` and `run_now_cohort_create_v1` changed after its base;
  - it writes `run_now_cohorts` directly, not through the shared cohort creator;
  - its migration version `20261105020000` is already applied by `cf247_intake_calendar_v2`.

  The scheduler that #882–#885 rebuilt now reaches every pilot university fairly. The 19:26 run admitted and published 6 Newcastle values without the Preview. Intake development is closed except for P0.
- **The problem it addressed still exists:** the Admin Preview scans only `run_now.preview_rows_per_university` (5) rows per university, so a bounded validation from the Admin screen can miss eligible work (5 Nov 2026 19:06, Newcastle 0 of 5). If the Platform Admin reopens this, port the paging to plan v3 and the shared cohort creator, under a new setting, as a new PR.
- **Kept here:** the migration as written, the documentation change, the measured results and the query plans. The screenshots (`docs/ui-evidence/intake-complete-scan-desktop.png` and `-phone.png`) remain on the branch, which is not deleted.
