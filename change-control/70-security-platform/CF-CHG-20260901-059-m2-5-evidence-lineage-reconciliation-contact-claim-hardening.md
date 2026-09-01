# CF-CHG-20260901-059 — M2.5 Evidence Lineage Reconciliation & Provider-Contact Claim Hardening

**Status:** IMPLEMENTED / RUNTIME PASS — TARGETED CI PENDING  
**Category:** 70-security-platform  
**Initiated:** 1 September 2026, Australia/Melbourne  
**Owner:** M2.5 platform maturity / Evidence integrity  
**Parent readiness gate:** `CF-CHG-20260901-049`  
**Related follow-up:** `M25-FU-009`  
**Depends on:** `CF-CHG-20260901-055`  
**M2.4 baseline:** remains CLOSED/PASS.

## Trigger

CF-055 reduced a raw Evidence-lineage warning to seven unresolved historical cases:
- five Storage objects not referenced by `pipeline.evidence_artifacts.storage_path`;
- two legacy Canadian Evidence rows whose `storage_path` is absent from the current Evidence bucket.

CF-059 performs provenance reconciliation without deleting or rewriting any historical object/Evidence row, and hardens the Provider-contact scheduler root cause found in four of the five Storage cases.

## Deterministic provenance findings

### 1. RMIT Layer 2 discovery object

Unlinked object:
`layer2/v2/discovery/726918ee-10e9-41e3-9a2a-5dace20af754/e7b0e849-d07e-4ea4-a1ec-62dad6ce55e3/09431698-3cfd-4c2b-8669-e924bc65c329/extraction-input.json`

Context:
- Course: RMIT Bachelor of Engineering (Honours), CRICOS stable key `course:cricos:00122a:0100714`;
- Job `e7b0e849-d07e-4ea4-a1ec-62dad6ce55e3` = `layer2_discovery`;
- job terminal state = failed/recovered;
- result explicitly records `recovered=true`, `selected_before_timeout=10`, `evaluated_before_timeout=16`;
- error = `outer dispatch timeout recovered; resume remaining scope under v1.2.5`;
- the same Job/Course registered its `source.html` Evidence immediately before interruption;
- later v1.2.5 and v1.3.0 retries registered valid `layer2_extraction_input` Evidence for the same Course and source lineage.

Classification:
**historical_orphan_explained / recovered_dispatch_timeout_upload_before_registration**.

No object deletion is authorised.

### 2. Four Provider-contact objects

Providers:
- Australian National University;
- Australian University College of Divinity;
- Avondale University;
- Bond University Limited.

The unresolved objects were created between 23:56:57Z and 23:58:40Z on 28 August 2026.

Historical worker source at commit `4f2b36ba2b3c26549f519322513ca7d37348723b` identifies:
`provider-contact-discover-scheduled-v1.1.2`.

Its sequence was:
1. fetch page;
2. upload HTML object;
3. call `layer2_evidence_capture`;
4. parse/upsert contacts.

At that version:
- no duplicate/orphan cleanup surrounded Evidence registration;
- `provider_contact_profiles_service` selected enabled profiles ordered by `last_run_at`;
- it had no claim token, lease, `FOR UPDATE SKIP LOCKED`, or in-progress exclusion.

Nonce history proves overlapping executions:
- several one-time nonces were consumed concurrently around 23:56–23:57;
- multiple runs overlapped the exact Storage-object creation window.

Each unresolved object is within milliseconds of other successfully registered Provider-contact Evidence for the same Provider, but its SHA-256 filename prefix has no Evidence-row hash match.

Classification:
**historical_orphan_explained / concurrent_scheduler_upload_before_registration**.

This is not an Evidence dedupe duplicate; it is an unregistered uploaded object from the historical unleased/concurrent execution window.

No object deletion is authorised.

### 3. Two Canadian management-plane references

Legacy Evidence:
- `97370ab7-d949-4e54-8785-9ee176703fb3` — Collège Boréal;
- `de6710b1-de72-43e6-a96b-4f9ecac07d51` — Sault College.

Both:
- are `regulatory_snapshot` rows;
- have `metadata.management_plane=true`;
- use the legacy path form `management-plane/CA/ON/.../2026-08-14.html`;
- predate the Storage-backed worker convention;
- have later Storage-backed Evidence from the same source lineage.

Later lineage examples:
- Boréal Evidence `502c4148-4143-4235-9528-c4fcbba6c8d0` → `regulatory/CA/ON/boreal/2026-08-14T02-36-39-254Z.html`;
- Sault Evidence `e0fb2acd-209d-413a-badb-08057de37a65` → `regulatory/CA/ON/sault/2026-08-14T02-43-32-758Z.json`.

Their hashes differ, so CF-059 does not claim byte-equivalent replacement.

Classification:
**legacy_virtual_reference / legacy_management_plane_reference**.

The original Evidence rows remain unchanged.

## Corrective implementation

### A. Private append-only reconciliation ledger

Create `pipeline.evidence_lineage_reconciliations` with:
- target kind: `storage_object` or `evidence_artifact`;
- exact target key/path or Evidence ID;
- reconciliation class and reason code;
- source/job/provider/course references when known;
- supporting evidence JSON;
- change-control reference;
- created timestamp.

The table is private:
- no anon/authenticated grants;
- no browser CRUD;
- seeded only with deterministically proven CF-059 cases.

No update/delete path is introduced.

### B. Capacity/integrity telemetry

Preserve raw visibility:
- raw unlinked Storage objects remains 205;
- raw missing non-URI Evidence paths remains 2;
- generic duplicate count remains 200;
- direct URI virtual references remain 16.

Add:
- reconciled historical orphan count;
- reconciled legacy-reference count;
- raw missing-Storage count.

Compatibility operational fields become unresolved-only:
- `orphan_object_count` excludes generic duplicates and ledger-reconciled historical orphans;
- `failed_upload_count` / `missing_storage_object_count` exclude ledger-reconciled legacy virtual references.

Expected current unresolved integrity input after CF-059: **0**.

Raw/reconciled counts remain visible so reconciliation does not erase history.

### C. Provider-contact claim/lease hardening

Add bounded claim state to `pipeline.provider_contact_profiles`:
- claim token;
- claimed-at;
- claim expiry.

Add service-only atomic claim RPC using:
- `FOR UPDATE SKIP LOCKED`;
- configurable bounded lease (default 15 minutes);
- only enabled/non-paused profiles whose prior claim is expired/absent.

The current scheduled Edge worker must:
- use the claim RPC instead of the unleased selector;
- pass the claim token to a claim-aware finish RPC;
- clear the claim on succeeded/failed completion;
- reject stale finish tokens;
- allow abandoned claims to expire for bounded recovery.

No contact canonical/Search/Publication authority changes.

## Security

- reconciliation ledger is private;
- no direct `storage.objects` mutation;
- no historical Evidence-row update;
- service-only claim/finish RPCs;
- claim token is operational concurrency state, not exposed to browser clients;
- block/Layer authority boundaries are unchanged.

## UAT

1. exactly five Storage-object reconciliations and two Evidence-artifact reconciliations are present;
2. no historical object/Evidence row is deleted or rewritten;
3. raw counts remain visible;
4. reconciled counts are separately visible;
5. unresolved orphan count = 0;
6. unresolved missing Storage count = 0;
7. integrity severity no longer reflects explained historical lineage;
8. two overlapping claim attempts cannot obtain the same Provider-contact profile;
9. stale/wrong finish token is rejected;
10. correct finish token clears claim;
11. abandoned lease is reclaimable after expiry;
12. Provider-contact Edge source uses claim-aware RPCs;
13. Security and Performance Advisors remain 0 WARN / 0 ERROR.

## Explicit non-goals

- no historical object deletion;
- no Evidence-row path rewrite;
- no bulk Storage cleanup;
- no Production action;
- no M2.4 reopening.

## Rollback

Restore prior capacity snapshot function and Provider-contact selector/worker source. Reconciliation ledger rows remain historical governance evidence unless a later explicit change supersedes them.


## Implementation & Pilot runtime proof — 1 September 2026

### Migration and reconciliation ledger

Pilot migration:
\`supabase/migrations/20260901224000_m2_5_evidence_lineage_reconciliation_contact_claim.sql\`

Pilot source commit:
\`b98776b45ff21520933674fb448aa3eba2fa5fa4\`.

The complete migration was first executed inside a rollback transaction. The dry-run compiled the ledger, claim services and telemetry together and returned the expected reconciled capacity snapshot before rollback.

It was then applied successfully as:
\`m2_5_evidence_lineage_reconciliation_contact_claim\`.

Live ledger:
- total reconciliation rows: **7**;
- Storage-object reconciliations: **5**;
- legacy Evidence-reference reconciliations: **2**.

The ledger is private and append-only for this gate. No historical Storage object or Evidence artifact row was deleted or rewritten.

### Provider-contact worker hardening

Current worker:
- source version \`provider-contact-discover-scheduled-v1.3.4\`;
- source commit \`abf67de65f0f7648ca880350199799934341c85e\`;
- deployed Supabase Edge version **19**;
- \`verify_jwt=false\` retained for the existing nonce-governed scheduled boundary.

The worker now:
- acquires Provider-contact profiles through the atomic claim service;
- uses a 1,800-second bounded lease;
- passes the claim token to claim-aware finish;
- clears the claim on success/failure;
- removes only the just-uploaded object when Evidence registration fails;
- retains CF-055 duplicate-object cleanup after successful dedupe;
- never removes the retained Evidence object's path.

### Rollback-only claim UAT

Proven without leaving claim state:
- first claim returned exactly one profile and a claim token;
- overlapping second claim for the same Provider returned zero profiles;
- wrong finish token was rejected with \`stale or invalid Provider-contact claim token\`;
- forced expired lease reclaimed the same profile with a different token;
- correct finish succeeded;
- separate post-finish read proved \`claim_token\`, \`claimed_at\` and \`claim_until\` all cleared;
- live active Provider-contact claims after UAT: **0**.

No real contact acquisition run was launched for CF-059.

### Corrected live integrity snapshot

Latest post-CF-059 snapshot:
- severity: **OK**;
- database: **627,092,627 bytes**;
- Evidence objects: **10,868**;
- Evidence bytes: **5,326,216,492**;
- Evidence artifacts: **10,713**;
- governed Evidence planning utilisation: **8.27%**;
- raw unlinked Storage objects: **205**;
- proven fingerprint duplicates: **200**;
- reconciled historical orphans: **5**;
- unresolved orphan objects: **0**;
- direct virtual/external Evidence references: **16**;
- reconciled legacy references: **2**;
- total virtual/external references: **18**;
- raw missing bucket objects: **2**;
- unresolved missing bucket objects: **0**;
- \`failed_upload_count=0\`;
- integrity count used for severity: **0**.

Raw historical counts remain visible. The OK state means there is no *unexplained* integrity fault in this known population; it does not erase the historical reconciliation evidence.

### Platform Admin and release

Platform Administration now displays raw, duplicate, reconciled and unresolved Evidence-lineage counts separately.

Repository source/release version is **PIM Admin v2.15.19**.

Release title:
**Evidence lineage reconciliation and contact claim hardening**.

### Advisors

After the migration and Edge deployment:
- Security: **147 INFO / 0 WARN / 0 ERROR**;
- Performance: **175 INFO / 0 WARN / 0 ERROR**.

### Permanent UAT

Added:
\`tests/uat/m2-5-evidence-lineage-reconciliation-contract.spec.mjs\`
(commit \`d6320ca9ac090f20ed51db936fa2d9686bc868eb\`).

Workflow routing/integration/acceptance:
\`7f10e29bac5351b173b5de2df4b61d28d51eed07\`.

The permanent contract checks reconciliation seeds, unresolved-only telemetry, atomic claim semantics, failed-registration cleanup, Platform UI lineage labels, release/version consistency and a full \`npm run build\`.

## Current decision

**IMPLEMENTED / RUNTIME PASS — TARGETED CI PENDING.**

FU-009 has no unexplained known lineage fault remaining. Final CF-059 targeted source/build validation is the remaining gate before marking the follow-up complete.
