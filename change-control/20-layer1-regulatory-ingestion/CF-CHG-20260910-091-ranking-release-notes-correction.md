# CF-CHG-20260910-091 — Ranking release-notes currentness correction

## Status
Accepted corrective follow-up pending Pilot merge.

## Context
The QS ranking corrective recovery was merged without publishing the corresponding operator-facing release note in the Administration version pill. This violated the established release-currentness/UI design principle that visible bug fixes are recorded under the release-notes **Bug / UI fixes** section.

## Corrective action
- Publish PIM Admin v2.15.75 release-currentness metadata.
- Record the QS duplicate-edition cleanup and 2026/2027 acquisition-contract correction under **Bug / UI fixes**.
- Preserve lifecycle/audit Evidence semantics; no destructive history purge is introduced by the UI correction.
- Keep RLS remediation deferred to Pilot security task #60.
- Add a source contract preventing this release-note omission from recurring for this correction.

## Acceptance
The top-right release pill must display v2.15.75 and the opened release-notes dialog must expose the ranking correction under **Bug / UI fixes**.
