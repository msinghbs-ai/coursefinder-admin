# CF-CHG-20260824-031 — Course Detail Operator Polish

**Status:** BLOCKED — v2.14.x DEPLOYED RECOVERY/UAT IN PROGRESS  
**Category:** 30-admin-pim-ux  
**Initiated:** 24 August 2026 14:00 AEST (+10:00)  
**Updated:** 24 August 2026 16:02 AEST (+10:00)  
**Origin chat/workstream:** M2.1 — Layer 2 Platform / Admin cross-check  
**Owner:** M2.1 Layer 2 Platform + Admin/PIM UX workstreams

## Trigger

Manual Admin cross-check of Federation University Australia `Bachelor of Arts` (`085611C`) identified Course Detail presentation defects. The v2.14 increment corrected URL, fee presentation, empty sections, Evidence navigation, regulatory wording and layer badges. Live UAT then exposed critical browser responsiveness regressions.

## Incident timeline

- **v2.14:** clicking Course Evidence caused Chrome `Page Unresponsive`.
- Root cause: `src/evidence-return-entry.js` used a page-wide `MutationObserver` whose callback removed/recreated the same button, recursively retriggering itself.
- **v2.14.1:** replaced that observer with bounded retries, but subsequent live UAT reported the application itself loading slowly/timing out.
- **v2.14.2 recovery:** removed the Evidence-return helper from application bootstrap entirely, deleted the helper source, and replaced the global version synchroniser MutationObserver with a bounded 20-attempt updater. Recovery takes priority over Back-to-Course convenience.

No canonical Course, Evidence, Search or publication data was corrupted by this browser/runtime defect.

## Semantic impact

No canonical semantics change.

- CRICOS registered tuition/non-tuition/estimated-total-course-cost remain Layer 1 facts.
- Provider-current tuition remains separate Layer 2/current Provider fact.
- Course URL may resolve from active governed `official_course` link when the legacy scalar is empty.
- layer badges are display/provenance hints only.
- completeness/readiness is not publication approval.
- Search/publication authority is unchanged.

## Live read contract

Migration `m2_1_admin_course_detail_enrichment_presentation_contract` remains active.

Federation Bachelor of Arts validation remains:

- official Course URL: `https://www.federation.edu.au/courses/dhm5-bachelor-of-arts/`;
- registered CRICOS fee rows: `3`;
- Provider-current fee rows: `0`;
- distinct supporting Evidence rows in Course Detail union: `3`.

## PIM Admin v2.14.2 recovery

Retained UI improvements:

- figure-first fee values;
- explicit L1/L2 provenance badges;
- one fee section only;
- hidden empty optional sections;
- concise Regulatory Facts;
- clickable Evidence navigation;
- official first-party Course URL.

Temporarily removed from runtime:

- `Back to Course` DOM helper.

The Evidence URL may still carry `return_course_id`, but the application no longer injects a return control outside the React workspace. A native React return action may be reintroduced only after recovery UAT passes.

## Publication guidance

PIM Admin Guide v1.18 remains current. 100% completeness must not auto-publish. Recommended operation remains:

`Completeness/readiness → Publication eligibility → bounded operator selection → preview → explicit Publish/Internal action → audit event → Search refresh → consumer visibility verification`.

Broad Pilot publication remains unauthorised.

## Implementation references

### v2.14 / v2.14.1 rejected runtime helpers

- `src/evidence-return-entry.js` — rejected helper; deleted in recovery commit `d89921cd392076c47704a7e26ae5e71a3049f738`.

### v2.14.2 recovery

- `index.html` — removes Evidence helper bootstrap and marks v2.14.2; commit `39630115b05112e8684bd7ccb817340a6c8094ae`;
- `src/pim-version-entry.js` — removes global MutationObserver and uses bounded synchronisation; commit `90bbd64f0661719d521c6f80fc8f616d2e8fc5a5`;
- `tests/uat/course-detail-polish-deployed.spec.mjs` — recovery acceptance checks Course and Evidence remain responsive without requiring Back to Course; commit `3eaf9131b9a5ba319415a53222788d711952a2f9`.

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

24 August 2026 approximately 15:59 AEST: user reported the application itself was not loading and timing out. v2.14.1 therefore cannot be accepted.

### Automated deployed browser v2.14.2 — PENDING

Recovery UAT must prove on desktop and mobile:

- application/login shell loads responsively;
- Federation Bachelor of Arts Course drawer opens;
- figure-first fee and layer badges render;
- Evidence navigation opens the Evidence workspace/drawer without locking the page;
- no browser/server runtime errors.

Back-to-Course is explicitly deferred from this recovery gate.

## Rollback

If v2.14.2 still fails deployed loading, rollback UI presentation to the last responsive v2.13 shell while retaining the safe Supabase read contract and canonical Layer 2 data.

## Current gate

**BLOCKED — DEPLOYED v2.14.2 RECOVERY UAT REQUIRED.**

`CF-CHG-20260823-029` remains blocked until the Admin runtime is responsive and final deployed acceptance passes.
