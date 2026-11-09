## 6. SS-020 — Admin Menu Consolidation (Decision 269)

**Status: APPROVED — Execute in parallel with overnight development.**

Implement the approved StudySearch Admin menu consolidation in the prescribed order, without interrupting production enrichment, Layer 4 admission or the work-continuity programme.

### Authoritative references — read before development

In `msinghbs-ai/coursefinder-admin`:

1. `docs/coursefinder-design-reference-v1.4.md` — Decision 269.
2. `docs/platform/ui-audit/2026-11-03-admin-menu-build-prompt.md` — complete implementation instructions, release sequence and affected files.
3. `docs/platform/ui-audit/2026-11-03-admin-menu-keep-merge-retire-review.md` — C01–C53 tab decisions.
4. Design canvas: https://claude.ai/artifact/8hxx9qgcFkxNkXSsVJJyGw
5. `docs/platform/nz-enrichment-brief/2026-11-03-enrichment-controls-audit.md` — sections 3 and 6.

**Baseline:** v2.15.439 (`793f642`). This is a historical reference. Reconcile current Pilot main, live release, overlapping branches and active deployment ownership before editing.

### Implementation sequence

Deliver each step through a separate governed release with a version-pill entry.

| Step | Task | Required result |
|---|---|---|
| 1 | Retire dead sections | Remove approved obsolete UI sections and reconcile their dependencies |
| 2 | Paging and length corrections | Correct page-size, truncation and navigation problems |
| 3 | Add Queues & yield and Services & limits | Consolidated operational visibility without duplicate controls |
| 4 | Consolidate Layer 2/3 | Apply controls-audit items 4, 7, 8, 9 and 10 |
| 5 | Relocate QILT/PRISMS and Link refresh | QILT/PRISMS under Datasets; Link refresh under Settings |
| 6 | Align guides and operational references | Update SOPs, component register, UI catalogue and role guidance in the corresponding releases |

Step 6 is a documentation and registration requirement for every applicable release, not permission to postpone consistency updates until the end.

### Mandatory safeguards

- Preserve **LEGACY redirects** for every moved tab.
- Retire superseded scripts, jobs and tables through governed housekeeping in the same change, preserving required data for 14 days.
- Destructive drops or deletions require the existing Platform Admin paste-file approval path.
- No Website API v2 or Zoho consumer contract changes, in accordance with Decision 266.
- No change to role permissions, access boundaries or existing operational authority.
- Preserve supported phone-width behaviour for Courses, the course detail blade and Layer 4 Inbox.
- Preserve existing URLs, navigation outcomes, state, filters and deep links where the design requires compatibility.
- Maintain existing V1–V4 release, migration, function-hash, regression and production-verification gates.
- Do not duplicate controls or leave obsolete UI entry points active without an approved compatibility reason.

### Parallel development coordination

SS-020 may be developed in parallel on an isolated workstream.

The Integration Controller retains exclusive responsibility for merging and deploying releases.

Before each release, reconcile current main and verify that the affected components have not changed in another workstream.

In particular, coordinate with the active Layer 4 engineering and ChatGPT browser-review sessions.

If an SS-020 release changes the Layer 4 interface, admission controls or review navigation, establish a bounded compatibility pause for affected reviewer actions. Resume immediately after verification.

Do not pause unrelated ingestion, source recovery, AER reading, fee processing, intakes or scheduled enrichment.

### Conflict handling

If current code or production behaviour contradicts Decision 269 or the approved Final board:

1. Record the precise discrepancy and affected component.
2. Identify the approved design and actual production behaviour.
3. Recommend the minimum safe resolution.
4. Record **DECISION REQUIRED — SS-020** in the existing execution register.
5. Park only the affected UI change; continue all independent approved steps.

Do not silently reinterpret or override the design.

### Completion requirements

The completed interface must have **47 tabs across 22 pages**, matching the approved Final board.

Verify:

- Every C01–C53 decision is implemented or retains a documented approved exception.
- LEGACY redirects operate correctly.
- Navigation and page data remain functional.
- Role restrictions remain unchanged.
- Phone viewport regression checks pass.
- Operational controls and diagnostics remain accessible.
- Corresponding scripts, jobs, tables, guides and SOPs are reconciled.
- All released changes have passed production verification.

### Reporting

Update SS-020 in the existing StudySearch execution register after every release.

Report using:

| Task | Status | Result |
|---|---|---|
| Step 1 — Dead sections | Pending / Testing / Deployed / Verified | Release, changes and verification |
| Step 2 — Paging and length | Pending / Testing / Deployed / Verified | Release, changes and verification |
| Step 3 — Operational tabs | Pending / Testing / Deployed / Verified | Release, changes and verification |
| Step 4 — Layer 2/3 | Pending / Testing / Deployed / Verified | Release, changes and verification |
| Step 5 — Dataset and Settings moves | Pending / Testing / Deployed / Verified | Release, changes and verification |
| Step 6 — Guides and registration | Pending / Testing / Deployed / Verified | Evidence of reconciliation across releases |

**Final instruction:** Execute SS-020 in the approved order, in parallel with SS-019 and SS-021. Preserve production continuity and the existing release ownership model. Do not declare SS-020 complete until all 47 tabs, 22 pages, redirects, permissions, responsive behaviour and operational dependencies are verified in production.