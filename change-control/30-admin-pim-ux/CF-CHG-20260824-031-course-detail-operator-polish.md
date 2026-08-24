# CF-CHG-20260824-031 — Course Detail Operator Polish

**Status:** BLOCKED — v2.14.x DEPLOYED RECOVERY/UAT IN PROGRESS  
**Category:** 30-admin-pim-ux  
**Initiated:** 24 August 2026 14:00 AEST (+10:00)  
**Updated:** 24 August 2026 16:12 AEST (+10:00)  
**Origin chat/workstream:** M2.1 — Layer 2 Platform / Admin cross-check  
**Owner:** M2.1 Layer 2 Platform + Admin/PIM UX workstreams

## Trigger

Manual Admin cross-check of Federation University Australia Course Detail identified presentation defects. The v2.14 increment corrected URL, fee presentation, empty sections, Evidence navigation, regulatory wording and layer badges. Live UAT then exposed browser responsiveness and version-display regressions.

## Incident timeline

- **v2.14:** clicking Course Evidence caused Chrome `Page Unresponsive`.
- Root cause: `src/evidence-return-entry.js` used a page-wide `MutationObserver` whose callback removed/recreated the same button, recursively retriggering itself.
- **v2.14.1:** replaced that observer with bounded retries, but subsequent live UAT reported the application itself loading slowly/timing out.
- **v2.14.2 recovery:** removed the Evidence-return helper from application bootstrap entirely, deleted the helper source, and replaced the global version synchroniser MutationObserver with bounded retries.
- **v2.14.2 visual UAT:** application became responsive again, but two additional defects were observed: Science (Honours) omitted an explicit English-requirement row when English was missing, and the visible PIM version repeatedly expanded to `v2.14.2.2.2...` because the bounded regex updater matched the `v2.14` prefix inside the already-correct `v2.14.2` value on every retry.
- **v2.14.3 recovery:** English requirement is now always explicit when the Intakes & English section is shown; missing English displays `Not yet captured`. Version synchronisation now assigns exact strings and never transforms a previous version string.

No canonical Course, Evidence, Search or publication data was corrupted by these browser/runtime defects.

## Semantic impact

No canonical semantics change.

- CRICOS registered tuition/non-tuition/estimated-total-course-cost remain Layer 1 facts.
- Provider-current tuition remains separate Layer 2/current Provider fact.
- Course URL may resolve from active governed `official_course` link when the legacy scalar is empty.
- Layer badges are display/provenance hints only.
- Missing English remains missing; the UI now makes that state visible instead of silently hiding the row.
- completeness/readiness is not publication approval.
- Search/publication authority is unchanged.

## Live read contract

Migration `m2_1_admin_course_detail_enrichment_presentation_contract` remains active.

Federation Bachelor of Arts validation remains:

- official Course URL: `https://www.federation.edu.au/courses/dhm5-bachelor-of-arts/`;
- registered CRICOS fee rows: `3`;
- Provider-current fee rows: `0`;
- distinct supporting Evidence rows in Course Detail union: `3`.

## PIM Admin v2.14.3 recovery

Retained UI improvements:

- figure-first fee values;
- explicit L1/L2 provenance badges;
- one fee section only;
- hidden empty optional sections;
- concise Regulatory Facts;
- clickable Evidence navigation;
- official first-party Course URL.

English presentation:

- `Intakes` is always a labelled value;
- `English requirement` is always explicitly labelled when the section is present;
- captured requirement example: `IELTS Academic · Overall score 6 · Confidence 1`;
- missing requirement displays `Not yet captured` and does not imply zero/not-applicable.

Version presentation:

- `src/pim-version-entry.js` uses exact idempotent assignment (`PIM Admin v2.14.3` / `v2.14.3`) rather than regex replacement;
- bounded retries remain only to wait for React shell mount;
- repeated `.2`/`.3` suffix accumulation is impossible under the new assignment logic.

Back-to-Course remains temporarily removed from runtime during recovery. A native React return action may be reintroduced only after recovery UAT passes.

## Publication guidance

PIM Admin Guide v1.18 remains current. 100% completeness must not auto-publish. Recommended operation remains:

`Completeness/readiness → Publication eligibility → bounded operator selection → preview → explicit Publish/Internal action → audit event → Search refresh → consumer visibility verification`.

Broad Pilot publication remains unauthorised.

## Implementation references

### Rejected runtime helper

- `src/evidence-return-entry.js` — rejected helper; deleted in recovery commit `d89921cd392076c47704a7e26ae5e71a3049f738`.

### v2.14.2 recovery

- `index.html` — removes Evidence helper bootstrap; commit `39630115b05112e8684bd7ccb817340a6c8094ae`;
- `src/pim-version-entry.js` — removes global MutationObserver; commit `90bbd64f0661719d521c6f80fc8f616d2e8fc5a5`;
- recovery UAT commit `3eaf9131b9a5ba319415a53222788d711952a2f9`.

### v2.14.3 recovery

- `src/CourseDetailPolish.jsx` — explicit English requirement/missing state; commit `4882711046b89ce6c716e7ab2021188ccb7c5036`;
- `src/pim-version-entry.js` — exact idempotent version assignment; commit `2ede9937135b9e7125f93c3111c9ada1169d47d6`;
- `index.html` — v2.14.3 release/runtime marker; commit `47a825a0f138f3f2616518112f9ff214518fbb62`;
- `tests/uat/course-detail-polish-deployed.spec.mjs` — v2.14.3 recovery acceptance; commit `22ab8276e37f2924a8cf9df9e3b1be7b5bdc6ad8`.

Governance:

- `docs/coursefinder-pim-admin-guide-v1.18.md` — operator/publication guidance.

## UAT

### Backend contract — PASS

- governed official Course URL resolves correctly;
- registered CRICOS fee count remains 3;
- no Provider-current fee is manufactured for Federation Bachelor of Arts;
- Course-link/description Evidence is included;
- no Search/publication mutation.

### Manual deployed browser v2.14 — FAIL

Chrome became unresponsive after Course → Evidence navigation.

### Manual deployed browser v2.14.1 — FAIL / RECOVERY TRIGGERED

Application itself was reported as not loading/timing out.

### Manual deployed browser v2.14.2 — PARTIAL PASS / DEFECTS FOUND

Application/Course drawer recovered responsiveness. Visual UAT then found:

- missing explicit English-requirement row for a Course with no captured English requirement;
- corrupted/repeated PIM version string in the sidebar.

### Automated deployed browser v2.14.3 — PENDING

Recovery UAT must prove on desktop and mobile:

- application/login shell loads responsively;
- exact PIM version string is `v2.14.3` with no suffix accumulation;
- Federation Bachelor of Arts Course drawer opens;
- figure-first fee and layer badges render;
- English requirement label/value renders explicitly;
- Evidence navigation opens the Evidence workspace/drawer without locking the page;
- no browser/server runtime errors.

Back-to-Course remains explicitly deferred from this recovery gate.

## Rollback

If v2.14.3 fails deployed loading, rollback UI presentation to the last responsive v2.13 shell while retaining the safe Supabase read contract and canonical Layer 2 data.

## Current gate

**BLOCKED — DEPLOYED v2.14.3 RECOVERY UAT REQUIRED.**

`CF-CHG-20260823-029` remains blocked until the Admin runtime is responsive and final deployed acceptance passes.
