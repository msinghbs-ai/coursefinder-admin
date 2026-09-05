# M2.4.5 — H5/H6 Execution State

**Updated:** 5 September 2026 17:25 AEST  
**Change Control:** CF-CHG-20260905-211  
**Status:** H5 RUNTIME IMPLEMENTED / CANONICAL UI PLACEMENT OPEN — H6 RUNTIME + DETAIL UI IMPLEMENTED / TARGETED CI ACTIVE

## H5 — Manual PIM source-backed candidates

Implemented in Pilot runtime and source:

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
- `ManualPimCandidateWorkspace.jsx` operator registration and queue component.

Open H5 closure item:

- place `ManualPimCandidateWorkspace` inside the canonical Admin navigation model. Do not introduce a floating launcher or second menu model. Existing canonical navigation currently exposes Quality & Review → Review Queue and Data Operations → Layer 4 — Human Resolution; final placement must preserve that IA and rank boundary.

## H6 — Publication controls

Implemented:

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

Mass execution is supported server-side but no broad mass-publish UI is enabled at this checkpoint. A mass UI must use the same exact preview token and bounded cohort and should not be enabled merely to close H6.

## Security correction

Security Advisor surfaced the first public privileged implementation as signed-in callable SECURITY DEFINER WARN. Corrected immediately:

- private H5 implementation → `pim_api`;
- private H6 implementation → `l4_api`;
- browser-facing `public.*` functions → SECURITY INVOKER wrappers;
- PUBLIC/anon EXECUTE revoked;
- server-side auth/rank enforcement retained in private implementation;
- candidate/settings tables remain private with RLS and no direct browser table access.

Direct runtime inspection confirms public CF-211 wrappers are not SECURITY DEFINER.

## Performance

The only new CF-211-specific Performance Advisor observation was the Evidence foreign key without a covering index. `pim_source_candidates_evidence_idx` is now applied. Remaining advisor observations are pre-existing platform INFO items.

## Source lineage

Pilot commits in this execution line include:

- `49ef8cbabe96b0a133212fc94e36d05c18e6c1a5` — candidate/publication migration;
- `8ec83e34f87e5f15cd1dfa038220c7770e4ee81b` — previewed target-scoped detail publication UI;
- `b6aebd5d0dd6577db6c227e4585cc1672b11e3a4` — H5 candidate workspace;
- `e3cf28fdde9a01bcc266a2a51726da6ca0bed4a0` — source contract UAT;
- `9d1705498bf04763ec384698deac926b198cb281` — private implementation wrappers;
- `f31ffbdf148aa760a9f2896dfc12fa996afe95a2` — Evidence FK index;
- `4eb5e158f33ad871d9dee7abd3fffd9d6f548ee4` — hardened CF-211 source contract tests.

Admin governance:

- `cd28918e4dd15d83ad210e6be3e3590888e20adb` — H5/H6 execution design;
- CF-211 Change Control current.

## Active automation

Pilot push for `4eb5e158f33ad871d9dee7abd3fffd9d6f548ee4` automatically started:

- CourseFinder Deployed UAT run `33952468057` — in progress at state capture;
- Pilot Frontend Build run `33952467996` — started for the same head.

Do not create duplicate full-suite runs while these are active. Check their conclusions first.

## Closure rule

Do not mark H5/H6 CLOSED until:

1. current CI concludes successfully for the source/runtime contract;
2. canonical H5 UI placement is committed with visible release/version update;
3. targeted deployed browser acceptance covers rank gate, candidate registration/duplicate rejection and H6 preview/token/rollback paths;
4. final Security Advisor confirms no new unexplained CF-211 WARN/ERROR;
5. M2.4.5 FOLLOW-UPS/CURRENT-STATE are reconciled.
