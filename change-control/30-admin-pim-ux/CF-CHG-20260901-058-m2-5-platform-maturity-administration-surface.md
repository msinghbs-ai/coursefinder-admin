# CF-CHG-20260901-058 — M2.5 Platform Maturity Administration Surface

**Status:** IMPLEMENTED / SOURCE+BUILD TARGETED PASS — DEPLOYED UI BLOCKED BY FU-015  
**Category:** 30-admin-pim-ux  
**Initiated:** 1 September 2026, Australia/Melbourne  
**Owner:** M2.5 platform maturity / Admin UX  
**Parent readiness gate:** `CF-CHG-20260901-049`  
**Related follow-up:** `M25-FU-011`  
**Depends on:** `CF-CHG-20260901-051`, `CF-CHG-20260901-055`, `CF-CHG-20260901-056`, `CF-CHG-20260901-057`  
**M2.4 baseline:** remains CLOSED/PASS.

## Trigger

The canonical Administration shell already exposes a privileged `Platform` tab, but that tab still mounts the legacy `RegulatorySettings` component. M2.5 introduced accepted backend state for:
- environment-specific source/scraper/AI gates;
- capacity/integrity observations;
- retention dry-run policy;
- platform UAT catalogue;
- workload profiles;
- reversible Layer 4 block decisions.

Those controls are not yet consolidated in canonical Administration.

## Objective

Replace the legacy Platform tab with one responsive, operator-grade Platform Maturity workspace that makes current readiness visible without inventing Production state or weakening server-side governance.

## UX contract

### Overview
Show:
- Pilot/Production boundary;
- Production source/scraper/AI enabled counts;
- open Production hard-gate UAT count;
- latest Layer 2 wave state;
- retention-class/workload-profile counts;
- explicit Production-not-provisioned banner.

### Capacity & integrity
Show:
- DB logical size;
- Evidence object bytes/count;
- Evidence planning utilisation;
- integrity severity;
- raw unlinked objects;
- proven duplicate objects;
- unresolved orphan objects;
- missing Storage objects;
- virtual/external Evidence references;
- temp bytes since prior observation;
- backup/PITR status with CF-056 wording;
- notification target state.

No capacity figure may be presented as a Supabase vendor hard quota when it is only the governed planning envelope.

### Environment gates
Read-only operator table for:
- Layer 1 source/capability gates;
- Layer 2 acquisition-provider gates;
- Layer 3 model-profile gates;
- Pilot vs Production;
- state, enabled, UAT/evidence, reason and updated time.

No Production enable button is introduced by CF-058.

### UAT catalogue
Display accepted Pilot permanent domains separately from designed/not-run M2.5/Production gates.

### Performance & retention
Display workload profiles and dry-run retention classes with immutable/purge/dry-run safeguards.

No destructive purge action is introduced.

### Layer 4 block controls
Expose the already-authorised server-side CF-057 block ledger:
- select Provider/Course/Campus/Scholarship target through governed catalogue reads;
- inspect current block state;
- block/unblock one independent scope at a time;
- reason required;
- optional comment, review/expiry date;
- clear warning that blocking is reversible state and never deletion;
- show active blocks with direct entity label and scope.

Mutation remains server-side `public.layer4_block_decide`, rank-5 enforced.

### Responsive design
Desktop/tablet/mobile source must:
- avoid fixed-width page content;
- stack metric cards and forms cleanly;
- preserve horizontal overflow only for bounded tables;
- use full-width controls at tablet/mobile breakpoints;
- retain canonical Administration navigation rather than introducing a second settings shell.

## Server/read boundary

Browser reads remain through `public.admin_read`.

Add a private secured dispatcher:
`security.admin_platform_maturity_read(p_operation,p_args)`.

Supported operations:
- `platform_readiness`;
- `platform_capacity`;
- `platform_environment_gates`;
- `platform_uat_catalogue`;
- `platform_workloads`;
- `platform_retention`;
- `platform_active_blocks`.

No raw private table CRUD is exposed.

## Security

- anonymous access denied through existing `admin_read` auth/role boundary;
- environment/platform reads require at least pipeline-operator rank consistent with existing M2.5 reads;
- active block ledger list requires Curator/PIM-governance role as appropriate;
- block mutation remains rank-5;
- no secrets, Vault IDs, credentials, prompt bodies or raw approval JSON are returned;
- no Production mutation path is introduced.

## Deployment/currentness boundary

FU-015 remains a known external Cloudflare Git deployment blocker:
- deployed Worker v2.15.14;
- repository source v2.15.17 before CF-058.

CF-058 may reach source/server targeted PASS while deployed browser acceptance remains BLOCKED by FU-015. Do not weaken browser tests or claim deployed UI acceptance until Worker currentness is repaired.

## UAT

Permanent source/server contract must verify:
1. Administration Platform mounts the new component, not legacy `RegulatorySettings`;
2. all reads use `admin_read`;
3. no Production enable/mutation action exists;
4. capacity labels distinguish planning envelope from vendor quota;
5. block mutation uses `layer4_block_decide`;
6. destructive purge is absent;
7. responsive CSS contract exists;
8. server operations are rank-gated and sanitised;
9. Security/Performance Advisors remain 0 WARN / 0 ERROR.

Deployed browser UAT is a separate gate after FU-015.

## Explicit non-authorisations

CF-058 does not authorise:
- Production project creation;
- Production source/scraper/AI enablement;
- broad Publication;
- Website/Zoho Production cutover;
- destructive purge;
- PITR purchase/enablement;
- autonomous block/unblock;
- M2.4 reopening.


## Implementation evidence — 1 September 2026

### Server/read surface

Pilot migration:
\`supabase/migrations/20260901220500_m2_5_platform_maturity_admin_read_surface.sql\`

Pilot commit:
\`ded6ff03156126aa66e5d1ca2914e2e62e337a77\`.

Applied successfully as:
\`m2_5_platform_maturity_admin_read_surface\`.

Added \`security.admin_platform_maturity_read(...)\` behind \`public.admin_read\` for:
- readiness;
- capacity/integrity;
- environment gates;
- UAT catalogue;
- workload profiles;
- retention dry-run/classes;
- active Layer 4 blocks.

The migration also routes the existing CF-057 \`data_quality_quarantine\` secured read through \`public.admin_read\`; this corrects the browser dispatcher without reopening or weakening CF-057 enforcement.

Post-deploy boundary proof:
- anonymous \`public.admin_read\` execute = false;
- authenticated \`public.admin_read\` execute = true;
- anonymous private Platform dispatcher execute = false;
- authenticated dispatcher route exists but server function enforces rank >= 4;
- no Vault IDs, secret environment keys or raw approval evidence are returned;
- no Production enable/update path is added.

### Canonical Administration source

New source:
- \`src/platform-maturity-entry.jsx\` — commit \`ccd673bd4936849a5da471212cafe1b0081d2439\`;
- \`src/platform-maturity.css\` — commit \`d01052664abb52d20632bad342e0a72fabcba139\`;
- canonical Administration mount + existing PIM-link correction — \`defa70bbe87c7d9a6f56b244d1b8b3ae38b837f3\`;
- Admin title version — \`3a03063e594cc735337938ee75d59419bd59973a\`;
- v2.15.18 release note — \`9ef46df36698efc06d47ad5dee87737b78756761\`;
- release-note permanent contract aligned — \`f00f9fb4c3acaab27119e0f94f8e0067a680f38d\`.

Repository source is now **PIM Admin v2.15.18**.

The Platform workspace provides:
- readiness/Production-boundary overview;
- current capacity and Evidence lineage classification;
- Pilot/Production source, scraper and AI gate tables;
- UAT catalogue;
- workload and retention policy views;
- governed rank-5 Layer 4 block/unblock controls using the existing CF-057 mutation contract.

It deliberately provides **no**:
- Production enable action;
- PITR purchase/enable action;
- destructive purge;
- broad Publication or consumer cutover.

Responsive CSS includes bounded table overflow and mobile/tablet stacking for metrics, forms and block controls.

### Current runtime capacity shown by the contract

Latest sampled Pilot snapshot:
- logical DB: **632,933,523 bytes**;
- Evidence: **10,546 objects / 5,224,808,213 bytes**;
- governed Evidence planning utilisation: **8.11%**;
- integrity severity: **WARNING**;
- raw unlinked objects: **205**;
- proven duplicates: **200**;
- unresolved orphan objects: **5**;
- missing Storage objects: **2**;
- virtual/external Evidence references: **16**.

The UI labels the 60 GiB Evidence value as a governed planning envelope, not a Supabase vendor hard quota.

### Advisors after CF-058 server migration

- Security: **146 INFO / 0 WARN / 0 ERROR**;
- Performance: **171 INFO / 0 WARN / 0 ERROR**.

### Permanent source/build UAT

Added:
\`tests/uat/m2-5-platform-maturity-admin-contract.spec.mjs\`
(commit \`34603320e6c4d094041c0b6cd4ccc5a2c3e21f3c\`).

Workflow routing commit:
\`45dcf406090be5bedc8838b965495b71aee7cee0\`.

The contract checks the server/read boundary, v2.15.18/release history, canonical Administration mount, responsive CSS, no Production/purge mutation and performs \`npm run build\`.

Targeted source/build validation trigger: `bd267ab46216529e21f94a4448394365b12a2cae`. Result is intentionally not polled in-chat; check this exact commit first on the next Proceed.

## Current decision

**IMPLEMENTED / SOURCE+BUILD TARGETED PASS — DEPLOYED UI BLOCKED BY FU-015.**

Even after source/build targeted PASS, deployed browser acceptance must remain BLOCKED until the external Cloudflare Worker is reconciled from v2.15.14 to current repository source.


## CF-058 targeted build correction

Initial trigger \`bd267ab46216529e21f94a4448394365b12a2cae\` ran in workflow \`33506554067\` / job \`99851861314\` and failed inside the unchanged \`npm run build\` assertion.

The failure was not a CF-058 Platform component syntax error. It exposed an older malformed \`src/layer2-operations-entry.jsx\` tail originating from the prior managed-run currency edit:
- managed-run cost JSX was truncated;
- ~20 KB of duplicate tail content existed after the first legitimate root render.

Corrective source commit:
\`a4cde432dcf8798ad1e61b986db3052ddeb64b74\`.

The repair:
- restores the managed-run cost cell as a syntax-safe \`$<amount>\` display;
- removes the accidental duplicate tail after the canonical root render;
- retains CF-052 terminal-run classification and observability semantics;
- does not alter Layer 2 authority, quota, retry, Search or Publication behaviour.

Fresh unchanged CF-058 source/build trigger:
\`97dc4085e4c00208864529bca21eb743ac46c05d\`.

Do not claim targeted PASS until that exact trigger completes successfully.


### Second CF-058 build correction

Fresh trigger \`97dc4085e4c00208864529bca21eb743ac46c05d\` ran in workflow \`33507331297\` / job \`99854598112\` and again failed the unchanged \`npm run build\` assertion.

The first repair correctly removed the accidental duplicate tail, but the managed-run line itself remained malformed. A subsequent direct replacement initially encountered JavaScript replacement-string \`$'\` expansion and was immediately superseded.

Final syntax-safe restoration:
\`27abb0f3c64a508227e2a442fdf5d4c78ca0f051\`.

That commit restores the entire Recent managed runs JSX line from the last known-good baseline and applies the currency prefix using a literal-safe function replacement:
\`('$'+Number(r.vendor_cost_usd).toFixed(2))\`.

Fresh unchanged CF-058 source/build trigger:
\`7f7f6a920fd303578cad7430401f4dce522c6e0c\`.

Final unchanged source/build trigger `7f7f6a920fd303578cad7430401f4dce522c6e0c` passed targeted Chromium desktop in workflow `33507629698` / job `99855436515`. The contract includes `npm run build`; source/build acceptance is therefore PASS. Deployed-browser acceptance remains separately blocked by FU-015.
