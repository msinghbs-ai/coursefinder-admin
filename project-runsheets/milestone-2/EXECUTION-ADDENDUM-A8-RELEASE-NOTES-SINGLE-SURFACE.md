# Milestone 2 Execution Addendum A8 — Single Release-Notes Surface & Footer Cleanup

**Status:** AUTHORITATIVE EXECUTION ADDENDUM  
**Effective:** 27 August 2026  
**Applies to:** M2.4.2 and later M2.x / M2.x.y browser work unless explicitly superseded.

This addendum extends `PROJECT_INSTRUCTIONS.md`, `STANDING-INSTRUCTIONS.md`, A1–A6 and A7.

## Purpose

The Admin previously exposed a persistent footer/runtime marker listing the current PIM Admin version and multiple feature/component versions. This was useful during early Pilot validation but is now redundant because governed release history is available from the interactive top-right Admin version control.

The operator-facing product must have one release/version surface rather than duplicating version/change information in a persistent footer.

## Authoritative release surface

The **top-right PIM Admin version control** is the single operator-facing release surface.

It must:
- remain visible in the normal Admin shell;
- show the current PIM Admin version;
- open the governed Release Notes overlay;
- show version/date/title and operator-facing changes;
- remain keyboard accessible;
- support close button, backdrop and Escape;
- remain covered by permanent deployed browser UAT.

## Footer/runtime feature marker

The persistent footer/runtime marker that lists:
- PIM Admin version;
- Pipeline Ops version;
- Evidence version;
- Data Quality version;
- Access Admin version;
- Layer 1/Layer 2/M2.3 feature versions;
- or equivalent implementation/runtime feature labels

must be removed from the normal operator UI.

Do not replace it with another footer, floating chip, badge, toast or persistent debug marker.

Implementation/component versions may still exist in:
- source code;
- deployment metadata;
- CI/UAT evidence;
- Running Build;
- release notes;
- Change Control;
- diagnostic/logging evidence.

They must not compete with the governed version overlay in the routine Admin interface.

## Browser/UAT contract

Permanent UAT must no longer depend on the removed footer marker to prove deployment readiness or version.

Instead:
1. deployment readiness should use the existing deterministic application/runtime readiness checks;
2. current browser version should be read from the normal Admin version control;
3. release-note coverage must open the version overlay and verify the current release entry;
4. targeted/integration/acceptance tests must assert the obsolete footer/runtime marker is absent.

Do not reintroduce hidden or force-clicked runtime markers merely to satisfy old tests.

## Release discipline

Browser-facing feature changes still require visible release notes/version maintenance under Standing Instructions.

Version bumps should occur when the release slice is frozen enough to describe accurately. Do not publish a release-note entry for behaviour that is still under active full-run acceptance.

## Rollback

If removing the footer exposes a genuine deployment-readiness gap in UAT, fix the readiness helper to use deterministic application state. Do not restore the footer as a test hook unless a new accepted Change Control explicitly reverses this addendum.
