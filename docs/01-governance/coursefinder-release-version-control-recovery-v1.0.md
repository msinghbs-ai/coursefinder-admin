# CourseFinder Release / Version Control & Recovery v1.0

**Status:** CURRENT GOVERNANCE  
**Effective:** 14 September 2026 AEST  
**Owner:** Release / UAT Operations  
**Applies to:** All browser-visible CourseFinder Pilot releases and future Production releases  
**Current governing work:** CF-CHG-20260910-093

## 1. Purpose

CourseFinder uses one governed release lifecycle. A browser-visible release must never depend on several independently maintained "current version" literals.

The Admin repository remains the governance authority. The Pilot repository is the implementation/runtime authority. Current release state must be reconciled from both before promotion or recovery.

## 2. Release states

Every visible release is in one of these states:

1. **Accepted release** — merged, deployed and accepted by the applicable deployed-currentness/UAT gate.
2. **Candidate release** — implementation exists on a branch/PR but has not yet completed accepted deployment/UAT.
3. **Recovery baseline** — the latest accepted release that can restore the browser application while preserving newer forward-only database/runtime state unless a separately governed runtime recovery is required.
4. **Historical release** — retained release-note/audit evidence; never selected as current merely from filename/version ordering.

A candidate must not be described as accepted merely because its source branch, Cloudflare preview or runtime backend exists.

## 3. Single implementation release authority

For browser-visible Pilot code, the only candidate-version authority is:

`Coursefinder-Pilot/src/release-manifest.js`

It contains:

- `UI_VERSION` — candidate browser release;
- `PACKAGE_VERSION` — candidate package release;
- `RELEASE` — candidate release-note content;
- `PREVIOUS_ACCEPTED_RELEASE` — exact accepted/recovery baseline immediately preceding the candidate.

Derived surfaces must not introduce another independent current-version literal.

### Derived surfaces

- `src/release-currentness-entry.js` imports the manifest and renders the candidate version/title/release note.
- `index.html` is version-neutral at bootstrap; runtime currentness sets the browser title from the manifest.
- `package.json` must equal `PACKAGE_VERSION`.
- `CHANGELOG.md` must contain the candidate package/version pair.
- `src/pim-version-entry.js` remains retained accepted release history until the candidate is accepted.
- the canonical shell's bootstrap version remains the previous accepted release while a candidate is unaccepted; the currentness overlay upgrades the rendered candidate. This creates a safe accepted fallback if the candidate overlay is absent.

No new component, test or workflow may create another candidate-version authority.

## 4. Mandatory automated gate

Pilot must provide and run:

`npm run release:verify`

The gate must run:

- before local `dev`;
- before `build`;
- in the Release History Contract CI workflow.

The verifier must fail when any of these disagree:

- manifest `UI_VERSION` and candidate changelog entry;
- manifest `PACKAGE_VERSION` and `package.json`;
- previous accepted version and retained release-history/bootstrap fallback;
- previous accepted release commit and governed recovery record;
- currentness overlay and manifest import contract;
- version-neutral bootstrap title contract.

A browser-visible PR may not merge with this gate red, cancelled or unrun.

## 5. v2.15.78 accepted recovery baseline

The exact recovery point preceding candidate v2.15.79 is:

| Item | Accepted recovery value |
|---|---|
| Visible release | **v2.15.78** |
| Package version | **0.1.5** |
| Pilot accepted main | **`7cf5cc72296ca82e6e026606a61f449ede4ead45`** |
| Release title | **Governed Scheduled Tasks target builder** |
| Release date | **11 September 2026** |
| Retained release history | `src/pim-version-entry.js` entry v2.15.78 |
| Changelog | `CHANGELOG.md` package 0.1.5 / visible v2.15.78 |

This baseline includes merged PR #84's Layer 2 transport-budget recovery. Database migrations/runtime changes applied after earlier releases remain governed independently and are **not** automatically rolled back by a browser release recovery.

## 6. Full v2.15.78 recovery procedure

Use this only after reconciling the troubleshooting/recovery protocol and confirming that browser/application release recovery is required.

### Gate R1 — classify and freeze promotion

1. Stop candidate release promotion.
2. Record exact current Pilot main, active PR head, Cloudflare deployment and visible browser version.
3. Confirm whether the defect is browser/currentness, implementation, database/runtime or mixed.
4. Do not rewrite applied Supabase migrations and do not delete Evidence/runtime history merely to restore the browser release.

### Gate R2 — verify recovery identity

Confirm all four recovery identifiers before rollback:

- Pilot commit `7cf5cc72296ca82e6e026606a61f449ede4ead45`;
- visible v2.15.78;
- package 0.1.5;
- release title `Governed Scheduled Tasks target builder`.

If any value disagrees, stop and reconcile repository/runtime truth rather than guessing another rollback commit.

### Gate R3 — restore application source/deployment

1. Restore/deploy the exact accepted application source from the v2.15.78 recovery commit or a governed recovery branch created directly from that commit.
2. Do **not** roll back Supabase migration history as part of this application recovery.
3. If newer database/runtime contracts are incompatible with v2.15.78, classify that separately and apply a governed forward-only compatibility/recovery change.
4. Never use migration-history repair, destructive Evidence deletion or secret substitution to make the old UI pass.

### Gate R4 — validate restored release

Run, at minimum:

1. `npm run release:verify` against the recovery source or equivalent historical contract validation;
2. frontend build;
3. release/currentness source contract;
4. Cloudflare deployment/currentness proof;
5. targeted browser smoke for login/navigation and the affected module;
6. applicable deployed UAT/security checks for the recovered surface.

Browser evidence must show:

- title/release pill = v2.15.78;
- v2.15.78 release note available;
- no candidate-only UI exposed;
- accepted authority/security boundaries still intact.

### Gate R5 — record recovery

Record in Change Control and continuity:

- incident/root cause;
- original failing candidate/head;
- recovery commit/deployment;
- CI/UAT run IDs;
- runtime/database state deliberately retained;
- exact next candidate gate.

Do not declare recovery complete until repository, deployment and browser evidence agree.

## 7. Normal next-release procedure

For every next browser release:

### Prepare

1. Reconcile accepted release from Admin governance + Pilot main + deployed browser.
2. Update `PREVIOUS_ACCEPTED_RELEASE` to that exact accepted release.
3. Change candidate `UI_VERSION` and `PACKAGE_VERSION` in `src/release-manifest.js`.
4. Update `package.json` and `CHANGELOG.md` in the same release PR.
5. Do not edit HTML, shell or currentness components with new independent version literals.

### Validate

6. `npm run release:verify` must pass locally/CI before build.
7. Run targeted functional/UAT contract for the feature.
8. Run frontend build and Cloudflare exact-head preview.
9. Obtain exact-head code review where required.
10. Run nominated browser/deployed-currentness acceptance.

### Promote

11. Merge only when the candidate's functional and release gates are green.
12. Verify main deployment and deployed UAT/currentness.
13. Only then mark the candidate as the accepted visible release in Admin governance.
14. Before creating the following candidate, promote the newly accepted release into retained `src/pim-version-entry.js` history and make it the manifest `PREVIOUS_ACCEPTED_RELEASE`.

This makes release promotion monotonic: accepted N → candidate N+1 → accepted N+1. No parallel "current" versions are maintained by hand.

## 8. Browser-visible change rule

A PR that changes browser-visible behaviour must do one of the following:

- advance the release manifest and package/changelog as part of a candidate release; or
- explicitly prove that it is not a release-promotion change and retain the current candidate/accepted version contract.

CI remains authoritative. A manual statement that versions are "already updated" never overrides a failing release contract.

## 9. Recovery versus database/runtime state

Visible-version recovery and database/runtime recovery are separate operations.

- Browser rollback may restore an earlier accepted application commit.
- Applied migrations remain immutable.
- Runtime/Edge compatibility must be reconciled independently.
- Any database correction is forward-only.
- Vault/provider secrets are never copied into source or release metadata.

## 10. Governance continuity

Every release transition must record:

- accepted release;
- candidate release;
- previous accepted/recovery commit;
- package version;
- implementation PR/head;
- build/CI result;
- Cloudflare/deployed currentness;
- applicable UAT result;
- next exact gate.

`docs/README.md` selects this document as the current Release / Version Control & Recovery authority. Chats must not infer current release governance from older release Change Controls or filename ordering.
