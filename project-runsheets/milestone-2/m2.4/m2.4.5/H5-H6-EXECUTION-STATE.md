# M2.4.5 — H5/H6 Execution State

**Updated:** 5 September 2026 17:40 AEST  
**Change Control:** CF-CHG-20260905-211  
**Status:** H5 FUNCTIONALLY ACCEPTED ON CANONICAL DETAIL SURFACE / RELEASE PACKAGING OPEN — H6 ACCEPTED

## H5 — Manual PIM source-backed candidates

Implemented and accepted in Pilot runtime/source:

- private candidate store `pipeline.pim_source_candidates`;
- rank-5 source-backed candidate register/read/decision contract;
- Provider/Course/Campus/Scholarship candidate types;
- source authority / first-party distinction;
- stable source identifier, official URL or Evidence, operator reason and actor/time lineage;
- duplicate active candidate prevention;
- Course/Campus/Provider-owned Scholarship candidate requires canonical Provider;
- explicit states `submitted → validated / needs_review → ready_for_acquisition`, plus rejected/cancelled;
- no direct canonical catalogue writer;
- no direct Search/publication consequence;
- `ManualPimCandidateWorkspace.jsx` operator registration and queue component;
- operator rank resolved from governed Admin context when not explicitly supplied;
- canonical Provider/entity context can be inherited from an existing detail record;
- existing `Layer4Intervention` detail surface now exposes **Source-backed PIM candidate workflow** for Provider/Course/Campus/Scholarship without a floating launcher or second control plane.

H5 functional acceptance head:

- `d7556a8a0aea078b19aacaa1051ddd98ebdcbf84`.

Acceptance results:

- Pilot Frontend Build run `33953096725` — SUCCESS;
- CourseFinder Deployed UAT run `33953096702` — SUCCESS.

The remaining H5 item is release packaging/IA only: decide whether to expose a dedicated primary navigation entry. If required, it must be added through the existing canonical navigation registry and accompanied by the visible Admin version/release-note bump. This is not required for the governed detail-surface workflow to operate.

## H6 — Publication controls

Accepted:

- existing Layer 4 publication decision remains authoritative;
- non-mutating `publication_control_preview`;
- exact preview confirmation token required by `publication_control_execute`;
- bounded cohort size 1–100;
- target scopes `governed_publication`, `search_api`, `website`, `zoho`;
- actions publish / unpublish / rollback;
- exact cohort token and size retained in approval context;
- single-record detail UI uses Preview → Confirm → Execute;
- target-specific publication state can be inspected from entity detail;
- automatic publication remains FALSE;
- consumer cutover remains unauthorised.

The hardened H6 baseline at `4eb5e158f33ad871d9dee7abd3fffd9d6f548ee4` passed both Frontend Build and Deployed UAT. H6 is technically accepted. Website, Zoho, Search/API or Production cutover remains a separate future release decision.

Mass execution is supported server-side but no broad mass-publish UI is enabled. Any future mass UI must use the same exact preview token and bounded cohort.

## Security disposition

Security Advisor surfaced the first public privileged implementation as signed-in callable SECURITY DEFINER WARN. Corrected immediately:

- private H5 implementation → `pim_api`;
- private H6 implementation → `l4_api`;
- browser-facing `public.*` functions → SECURITY INVOKER wrappers;
- PUBLIC/anon EXECUTE revoked;
- server-side auth/rank enforcement retained in private implementation;
- candidate/settings tables remain private with RLS and no direct browser table access.

Final Security Advisor re-check on 5 September 2026 confirms the CF-211 functions remain absent from exposed `SECURITY DEFINER` WARN findings. Existing unrelated Layer 4/statistics function warnings and scholarship mutable-search-path warnings remain platform backlog items.

`pipeline.pim_source_candidates` is reported as INFO `RLS enabled, no policy`; this is intentional for the private table because browser table access is revoked and governed operations occur only through the authenticated wrapper/private implementation boundary.

## Performance disposition

The original CF-211 Evidence-FK finding is resolved by `pim_source_candidates_evidence_idx`.

Final Performance Advisor re-check no longer reports the H5 Evidence foreign key as unindexed. The new H5 indexes currently appear as unused INFO because the candidate workflow is newly introduced and has not accumulated production-like query history. Other performance observations are pre-existing platform INFO items.

## Source lineage

Pilot commits in this execution line include:

- `49ef8cbabe96b0a133212fc94e36d05c18e6c1a5` — candidate/publication migration;
- `8ec83e34f87e5f15cd1dfa038220c7770e4ee81b` — previewed target-scoped detail publication UI;
- `b6aebd5d0dd6577db6c227e4585cc1672b11e3a4` — H5 candidate workspace;
- `9d1705498bf04763ec384698deac926b198cb281` — private implementation wrappers;
- `f31ffbdf148aa760a9f2896dfc12fa996afe95a2` — Evidence FK index;
- `4eb5e158f33ad871d9dee7abd3fffd9d6f548ee4` — hardened CF-211 source contract tests;
- `66bcb62aea372ae4a5a0ed586a310ce8486cf7d1` — context-aware H5 workspace;
- `7f771ce6c49579f1b503e0fe799f5a2656a7d316` — canonical detail-surface placement;
- `d7556a8a0aea078b19aacaa1051ddd98ebdcbf84` — final H5 placement contract tests and accepted Pilot head.

Admin governance:

- CF-CHG-20260905-211 current;
- execution state reconciled to successful final build/UAT and final advisor review.

## Current gate

### H6

**ACCEPTED.** No remaining H6 implementation blocker. Automatic publication remains disabled and consumer cutover remains separately governed.

### H5

**FUNCTIONALLY ACCEPTED.** The governed source-backed candidate workflow is available from the canonical entity-detail/Layer 4 surface and has passed build/deployed UAT.

**Release packaging remains open:** primary-nav exposure and visible Admin version/release-note bump should be completed together only if the project elects to expose H5 as a standalone workspace in the main IA.

Do not treat that packaging item as permission to weaken the H5 candidate boundary or introduce a second launcher/control plane.
