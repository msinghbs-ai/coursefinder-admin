# CourseFinder Layer 1 Canada — Ontario Public College Parser UAT v1.0

**Date:** 13 August 2026  
**Scope:** CA Gate B — Ontario public-college live acquisition/parser  
**Worker:** `layer1-ca-on-college-programs-v0.1.0`

## Result

**LIVE ACQUISITION / PARSER DRY-RUN: PASS**  
**CANONICAL COURSE APPLY: BLOCKED BY IDENTITY CONTRACT**

## Runtime evidence

Authoritative source: Ontario Data Catalogue — Ontario public college programs: postsecondary field of study table.

Latest discovered resource during UAT:
`ontario_public_college_programs_postsecondary_field_of_study_table_august_07_2026.xlsx`

Accepted bounded/full-sheet parser run:
- HTTP/runtime: PASS;
- workbook bytes: 374,429;
- private evidence captured: PASS;
- evidence SHA-256: `13754b3cfbf0ff6300855d9b0dcae2d1910063278db359297345009b0e95d295`;
- workbook sheet: `Table`;
- data rows: 4,522;
- Ontario college source codes: 24;
- rows with APS Code: 4,522 / 4,522;
- rows with stable institutional/local programme code: **0 / 4,522**.

Workbook columns observed:
- College;
- MTCU Code;
- MTCU Title English;
- APS Code;
- APS Title;
- Credential Type English;
- CIP Code;
- CIP Title English;
- STEM/BHASE;
- French equivalents.

The 24 source college codes are:
`ALGO, BORE, CAMB, CANA, CENT, CONF, CONS, DURH, FANS, GEOR, GRBR, HUMB, LACI, LAMB, LOYT, MOHA, NIAG, NORT, SAUL, SENE, SHER, SLAW, SSFL, STCL`.

## Identity decision

Accepted Canada Course identity remains:
`UUIDv5(verified IRCC DLI + namespaced stable institutional/source-local programme key)`.

The Ontario ministry workbook does not expose that institutional/local programme key.

Therefore:
- APS is retained as Ontario regional registration/validation metadata;
- MTCU is classification/funding metadata;
- CIP is field-of-study classification metadata;
- APS Title / MTCU Title are mutable metadata;
- none of APS, MTCU, CIP or title may be promoted to base Course identity under the current architecture.

The Ontario workbook is therefore a **validation/classification authority**, not by itself a sufficient base Course identity authority.

## Provider mapping

The workbook identifies colleges by 24 short source codes rather than DLI numbers. Canonical IRCC DLI Providers now exist for the corresponding Ontario public colleges, but source-code-to-DLI mappings must be verified before Course reconciliation.

No Provider identity may be created or merged from the Ontario source.

## Pilot automation UAT

To remove browser-JWT handoffs during Pilot UAT, this worker supports two authentication modes:
1. normal signed-in Platform Admin session; or
2. temporary Pilot server automation secret.

The Edge platform `verify_jwt` check is disabled only for this worker; the request is still rejected unless the in-function Platform Admin or Pilot-secret authorisation passes.

The Pilot secret is stored in Supabase Vault; only its SHA-256 is stored in the validator table. The temporary key expires on 30 September 2026 and must be disabled/removed before production hardening.

Automated invocation through `pg_net` successfully reached the worker without a browser JWT.

Initial run exposed missing XLSX MIME support in the private evidence bucket; the bucket was corrected and subsequent parser runs passed.

## Next gate

1. Verify the 24 Ontario source-college codes to existing IRCC DLI Providers.
2. Select first-party institutional catalogue sources exposing stable programme codes/keys.
3. Join first-party programme keys to Ontario APS/MTCU/CIP validation metadata where possible.
4. Run bounded Course dry-run.
5. Only then enable an approved Course APPLY slice and same-slice idempotency UAT.

## Gate state

- Ontario live acquisition: PASS.
- Ontario XLSX parser: PASS.
- Evidence: PASS.
- Provider source-code mapping: PENDING VERIFICATION.
- Stable base Course key from Ontario workbook: NOT AVAILABLE.
- Canonical Course APPLY: LOCKED.
- Overall CA Gate B: BLOCKED on federated first-party Course identity coverage.
