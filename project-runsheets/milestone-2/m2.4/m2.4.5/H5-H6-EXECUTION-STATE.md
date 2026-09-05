# M2.4.5 — H5/H6 Execution State

**Updated:** 5 September 2026  
**Change Control:** CF-CHG-20260905-211  
**Status:** H5 CLOSED / ACCEPTED — H6 CLOSED / ACCEPTED  
**Accepted visible Admin release:** **v2.15.66**

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
- existing `Layer4Intervention` detail surface exposes **Source-backed PIM candidate workflow** for Provider/Course/Campus/Scholarship without a floating launcher or second control plane.

H5 accepted Pilot head:

- `d7556a8a0aea078b19aacaa1051ddd98ebdcbf84`.

Acceptance results:

- Pilot Frontend Build run `33953096725` — SUCCESS;
- CourseFinder Deployed UAT run `33953096702` — SUCCESS.

### Navigation decision

A dedicated primary-navigation entry is **not required** for H5 closure. The workflow is intentionally exposed from the existing canonical entity-detail/Layer 4 surface where the operator already has the entity and Provider context needed for a source-backed candidate decision. Adding a second primary workspace would duplicate the control plane and increase the risk of identity/context drift.

Future IA refinement may add a consolidated candidate queue only if it reuses the same H5 RPC/state model and does not create a parallel canonical writer or publication path.

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

The hardened H6 baseline at `4eb5e158f33ad871d9dee7abd3fffd9d6f548ee4` passed both Frontend Build and Deployed UAT. Website, Zoho, Search/API or Production cutover remains a separate future release decision.

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

## Release reconciliation

The live UI is confirmed at **v2.15.66**. Earlier H5/H6 notes referring to v2.15.57 as the current visible release were stale documentation, not a requirement to roll the application version backwards or create another artificial bump.

H5/H6 are accepted as part of the current v2.15.66 Admin baseline.

## Final gate

### H5

**CLOSED / ACCEPTED.** Source-backed candidate registration is governed, rank-gated, Evidence/source-backed and separate from canonical Apply and publication.

### H6

**CLOSED / ACCEPTED.** Previewed manual publication decisions and rollback are available; automatic publication remains disabled and consumer cutover remains independently governed.
