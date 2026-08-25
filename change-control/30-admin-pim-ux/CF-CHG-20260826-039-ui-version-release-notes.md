# CF-CHG-20260826-039 — UI Version Release Notes

**Status:** APPLIED / UAT PENDING  
**Category:** 30-admin-pim-ux  
**Initiated:** 26 August 2026 08:55 AEST (+10:00)  
**Origin:** CourseFinder M2.3 continuation — user requested maintained release notes opened by clicking the top-right version number  
**Owner:** CourseFinder programme / Admin PIM UX

## Requested outcome

Make the visible top-right PIM Admin version number an interactive release-history entry point. Clicking the version must open a screen overlay containing multiple application versions and the operator-facing changes introduced in each version. The mechanism must be maintained for future visible UI releases.

## Affected surfaces / related workstreams

- `msinghbs-ai/Coursefinder-Pilot` browser UI;
- visible PIM Admin version governance;
- M2.3 Admin/PIM operational UX under `CF-CHG-20260825-036`;
- deployed browser UAT and release evidence;
- no database, RPC, Layer 1 identity, Layer 2/3/4 authority or Publication semantic change.

## Semantic impact

None to canonical data or source authority. This is an observable Admin/PIM release-governance UX change only.

## Before

- the top-right release pill displayed a version but was not interactive;
- operators had no in-product view of what changed between browser releases;
- release history was implicit in repository/governance history rather than directly available from the UI.

## After

- PIM Admin visible version advances to `v2.15.4`;
- the top-right version pill is keyboard- and pointer-interactive and declares `aria-haspopup="dialog"`;
- clicking/pressing Enter/Space opens a governed release-notes overlay;
- the overlay lists multiple versions, release dates, release titles and change bullets;
- it closes by close button, backdrop click or Escape and restores focus to the release pill;
- future visible PIM releases are maintained by adding the newest entry to the `RELEASES` array in `src/pim-version-entry.js`.

## Implementation refs

Pilot commits:

- `351bcff5a3f325548520638918d3a4ba22fc0ca0` — release-history data, interactive version pill and accessible overlay;
- `44e8cf85c914b79b9a1424b6faab877be5b215bc` — governed runtime/title version bump to PIM Admin v2.15.4;
- `b75ace4c59c9f80d00fc782ee229198b176f225e` — deployed Playwright release-notes acceptance.

Primary implementation file: `src/pim-version-entry.js`.

## UI version

`PIM Admin v2.15.4`.

## UAT

Automated deployed-browser acceptance requires:

1. authenticated Admin loads with governed runtime marker `PIM Admin v2.15.4`;
2. top-right `.m-release-pill` displays `v2.15.4`, has button semantics and advertises a dialog;
3. click opens the `Release notes` dialog;
4. current `v2.15.4` and prior `v2.15.3` entries are visible with their change descriptions;
5. Escape closes the overlay and returns focus to the version pill;
6. runtime evidence contains no server-side failures.

Test: `tests/uat/release-notes-deployed.spec.mjs`.

Current state: implementation committed; CI/deployed-runtime result pending at this record checkpoint.

## Security / ACL

No new data read/write path, RPC, API call, role escalation or anonymous surface is introduced. Release content is static browser metadata and is available only as part of the existing application shell.

## Rollback

Revert Pilot commits `b75ace4c59c9f80d00fc782ee229198b176f225e`, `44e8cf85c914b79b9a1424b6faab877be5b215bc` and `351bcff5a3f325548520638918d3a4ba22fc0ca0` in reverse order. This restores the prior non-interactive version presentation without touching database state.

## Maintenance rule

For every future browser-facing PIM Admin version bump:

- increment the visible PIM version consistently in the governed runtime surface;
- prepend one release object to `RELEASES` with version, absolute release date, concise title and operator-facing change bullets;
- keep prior release entries unless an explicit archive policy is introduced;
- update deployed UAT expectations when the current visible version changes;
- record the version and release-note evidence in the applicable Change Control.

## Closure

Remain **APPLIED / UAT PENDING** until build/deployment and the deployed release-notes browser contract pass. This change does not by itself close M2.3.
