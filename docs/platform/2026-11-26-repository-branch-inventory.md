# Repository branch inventory (26 Nov 2026)

**Prepared:** S1-Build, 26 Nov 2026 11:10 AEDT, for SS-Programme-Control.
**Status:** inventory only. No branch has been deleted and no setting changed. Deleting branches and changing repository settings need the Platform Admin's approval.
**Data:** every branch with its class is listed in `2026-11-26-repository-branch-inventory.tsv`, read through the GitHub REST API at 10:55 AEDT.

## How each branch was classed

- **Open PR:** the branch heads an open pull request.
- **Merged, safe:** the branch's last merged PR has the same head as the branch, so nothing was added after the squash merge.
- **Commits after merge:** the branch moved on after its PR merged. Compare it with `main` before removing it.
- **Closed unmerged:** every PR from the branch was closed without merging.
- **No PR, contained in main:** no PR, and `compare main...branch` shows nothing ahead of `main`.
- **No PR, unmerged commits:** no PR, with commits that `main` does not have.
- **Backups and snapshots:** the branch name marks a backup, snapshot, archive or restore point.

## Counts

| Class | Pilot | Admin | What to do |
|---|---|---|---|
| `main` | 1 | 1 | Retain |
| Open PR | 4 | 1 | Retain |
| Protected draft (Pilot #1502) | 1 | 0 | Retain |
| Backups and snapshots | 173 | 1 | Retain (see note 1) |
| Merged, safe to remove | 1,372 | 687 | Remove on approval |
| No PR, contained in `main`, safe to remove | 18 | 30 | Remove on approval |
| Probe left behind | 0 | 1 (`s1-dynlookups-permcheck-probe`) | Remove on approval |
| Commits after merge | 1 (`cf247-validation-parity`, #888) | 2 (`cf247-e78` #277, `s1-build-s1154-window1` #1094) | Reconcile, then remove |
| Closed unmerged (abandoned or superseded) | 48 | 16 | Owner check, then remove |
| No PR, unmerged commits | 102 | 33 | Owner check (see note 2) |
| **Total** | **1,720** | **772** | |

1. **Snapshot branches.** Pilot keeps 137 `db-function-snapshot-*` and 25 `edge-live-snapshot-*` branches, which workflows write. They need a retention rule (for example the last 14 days, like `hygiene.retire_after_days`) rather than one-off removal.
2. **Unmerged work with no PR.**
   - Pilot: 60 `cf247-*` and 21 `s*` working branches, plus 12 `db-schema-dump`, `db-baseline-rebuild` and `db-history-sync` branches.
   - Admin: 20 `boost-test` and `boost-experiment` branches written by workflows, plus 13 working branches.
   - Each needs its owner, or a check that the work went in by another route.

## Stale reservations (Master Plan reservation table)

- **Shipped but still marked in release:** 35 rows still say "(this change)" or "in release". 32 of them have their spec on Pilot `main`, so they shipped and only the wording is stale.
- **Reserved but not shipped:** `s1042`, `s1049` and `s1106` have no spec on `main`. Their owners, S1-AER-Claude (`s1042`, `s1049`, `s1106`), confirm whether to release or retire them.

## Automatic branch deletion

- Both repositories have `delete_branch_on_merge` off.
- The `automerge` label path already deletes the branch it merges (`scripts/ci/auto-merge.sh`, since 20 Nov 2026). Most of the 2,059 merged branches predate it.
- **Assessment:** turning the setting on is low risk.
  - It deletes only a merged PR's head branch.
  - No workflow reads a PR branch after its merge: Deploy on merge uses the commits before and after the merge on `main`.
  - Snapshot and backup branches never merge, so it does not touch them.
  - It also covers merges made by hand in the GitHub interface.
- **Decision for the Platform Admin:**
  1. Turn on `delete_branch_on_merge` in both repositories.
  2. Approve removing the merged-safe and contained-in-`main` branches (2,107 in all).
  3. Set a retention rule for the snapshot branches.

  The other classes stay until their owners answer.
