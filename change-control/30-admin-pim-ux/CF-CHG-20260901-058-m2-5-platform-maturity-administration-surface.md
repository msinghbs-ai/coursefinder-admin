# CF-CHG-20260901-058 — M2.5 Platform Maturity Administration Surface

**Status:** ACTIVE / SOURCE+SERVER IMPLEMENTATION  
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
