# CF-CHG-20260901-055 — M2.5 Evidence Lineage Classification & Duplicate Upload Prevention

**Status:** IMPLEMENTED / RUNTIME PASS — TARGETED CI PENDING  
**Category:** 70-security-platform  
**Initiated:** 1 September 2026, Australia/Melbourne  
**Owner:** M2.5 platform maturity  
**Parent readiness gate:** `CF-CHG-20260901-049`  
**Related follow-up:** `M25-FU-009`  
**M2.4 baseline:** remains CLOSED/PASS; this change does not reopen it.

## Trigger

CF-051 platform capacity telemetry reported a HIGH Evidence-lineage state:
- 205 objects in private Storage bucket `evidence` with no exact `pipeline.evidence_artifacts.storage_path` match;
- 18 Evidence rows with a nonblank `storage_path` and no current Storage object.

No deletion was authorised. CF-055 classifies the population before any remediation and corrects the mechanisms that create false positives or redundant objects.

## Live Pilot classification

Pilot: `fxcwkweaxjtknorudmwp`.

Current inventory at investigation:
- Evidence Storage objects: **9,321**;
- Evidence rows with a nonblank path: **9,157**;
- raw unlinked Storage objects: **205**;
- raw Evidence rows whose path is absent from Storage: **18**.

### A. Storage-only objects

A generic Storage fingerprint comparison was used:
- unlinked object ETag + size;
- compared only against a Storage object that **is** referenced by an Evidence row;
- no object content, metadata or Evidence row was mutated.

Result:
- **200/205** unlinked objects have an identical ETag + size to an Evidence-linked object;
- **5/205** do not have a registered-object fingerprint match and remain unresolved.

The 205 population by functional family:
- 158 Layer 2 Course discovery objects;
- 25 Provider-contact objects;
- 17 Scholarship acquisition objects;
- 5 AU CRICOS regulatory objects.

Additional lineage proof:
- 158/158 discovery objects have registered Evidence for the same Job/Course;
- 157/158 have registered `layer2_extraction_input` Evidence for that Job/Course;
- 157 objects belong to 21 completed discovery Jobs; one belongs to a recovered failed/timeout Job;
- 21/25 Provider-contact object hashes already match Evidence;
- 17/17 Scholarship object hashes already match Evidence;
- all five unlinked AU CRICOS objects are byte-size + ETag identical to the accepted package registered 16 minutes later under Job `97a1ef94-b6cf-4eaf-9b53-52bd370d47da`.

Unresolved objects retained for further provenance:
- Australian National University Provider-contact capture;
- Australian University College of Divinity Provider-contact capture;
- Avondale University Provider-contact capture;
- Bond University Limited Provider-contact capture;
- one recovered Layer 2 discovery object.

No historical object is deleted under CF-055.

### B. Evidence rows reported as “missing Storage”

Of the 18:
- 8 are `db://...` virtual references;
- 6 are `database://...` virtual references;
- 2 are `management-plane://...` virtual references;
- only 2 are Storage-looking legacy `management-plane/CA/ON/...` paths.

Therefore **16/18 are not Supabase Storage keys** and must not be counted as failed Storage uploads.

The two legacy Storage-looking rows are:
- Collège Boréal `management-plane/CA/ON/boreal/2026-08-14.html`;
- Sault College `management-plane/CA/ON/sault/2026-08-14.html`.

Current workers now use proper Storage-backed paths:
- `regulatory/CA/ON/boreal/<timestamp>.html`;
- `regulatory/CA/ON/sault/<timestamp>.json`.

Later Storage-backed Evidence exists for both source lineages. Their historical hashes differ, so they are not described as byte-equivalent; they are retained legacy management-plane references.

## Root cause

### Layer 2 Evidence dedupe after upload

`public.layer2_evidence_capture(...)` intentionally deduplicates unchanged Evidence by `evidence_group_key + content_hash`.

When unchanged content is seen it returns:
- the retained Evidence ID and retained `storage_path`;
- `content_changed=false`;
- the newly supplied object path as `duplicate_upload_path`.

Several workers upload first, call this RPC second, and ignore `duplicate_upload_path`. The database correctly reuses the retained Evidence row but the new object remains in Storage.

`layer2-acquire-v2` already contains the correct pattern: if the returned retained path differs from the just-uploaded path, remove only the new duplicate object through the Storage API.

### Scholarship Evidence dedupe

`svc_scholarship_register_evidence` returns an existing Evidence ID for the same source + source URL + content hash. The worker currently uploads first and does not compare the returned Evidence row's retained path with the new path, allowing redundant objects.

### Platform telemetry

`security.platform_capacity_snapshot_internal()` currently:
- counts every unmatched Storage object as an orphan;
- counts every Evidence `storage_path` not present in Storage as a failed upload, including URI-style virtual references;
- uses the larger raw count for integrity severity.

This converted a predominantly classified duplicate/legacy population into a HIGH platform alert.

## Corrective implementation

### 1. Duplicate-upload prevention

For workers that use Evidence dedupe:
- retain the existing Evidence object path;
- when the registration result proves the newly uploaded path is a duplicate, remove **only** that just-uploaded path through the Supabase Storage API;
- duplicate cleanup is best-effort and must not fail the acquisition/interpretation outcome;
- never remove the retained Evidence object's path.

In scope:
- `layer2-scope-discover-scheduled`;
- `layer2-screenshot-backfill-scheduled`;
- `provider-contact-discover-scheduled`;
- `scholarships-au-etl`.

`layer2-acquire-v2` already implements the required safe duplicate-cleanup pattern and serves as the reference.

### 2. Integrity telemetry classification

Update `security.platform_capacity_snapshot_internal()` to distinguish:
- raw unlinked Storage objects;
- duplicate unlinked objects proven by identical ETag + size to an Evidence-linked Storage object;
- unresolved orphan objects = raw unlinked minus proven duplicates;
- virtual/external Evidence URI references;
- real missing Storage object references.

Compatibility fields:
- `orphan_object_count` becomes unresolved orphan count;
- `failed_upload_count` becomes real missing Storage reference count.

Additional snapshot fields preserve raw visibility:
- `unlinked_storage_object_count_raw`;
- `duplicate_unlinked_storage_object_count`;
- `virtual_evidence_reference_count`;
- `missing_storage_object_count`.

Integrity severity is based on unresolved orphan and real missing Storage counts, not classified duplicates/virtual URI references.

### 3. No historical cleanup in this gate

CF-055 does **not**:
- delete any of the current 205 objects;
- rewrite any of the current 18 Evidence rows;
- repair the four unclassified Provider-contact objects;
- rewrite Boreal/Sault legacy references;
- alter retained Evidence hashes or lineage;
- change Layer 1 canonical, Search or Publication data.

Historical cleanup/remediation requires a later explicitly reviewed action after provenance resolution.

## Acceptance

1. platform snapshot classifies the current Pilot population without data deletion;
2. raw counts remain visible;
3. 16 virtual URI references are excluded from missing-Storage severity;
4. generic ETag+size classifier identifies current duplicate unlinked objects;
5. corrected Pilot severity is no longer HIGH solely from classified duplicates/virtual references;
6. worker source contracts prove only a just-uploaded duplicate path may be removed;
7. retained Evidence storage paths are never removed;
8. duplicate cleanup failure is non-fatal;
9. current unresolved objects remain retained;
10. Security and Performance Advisors remain 0 WARN / 0 ERROR.

## Rollback

Restore prior snapshot function and worker source. No historical data rollback is required because CF-055 does not delete or rewrite existing Evidence/Storage lineage.


## Implementation & runtime proof — 1 September 2026

Pilot source trigger:
`msinghbs-ai/Coursefinder-Pilot@ca1e54f95f9a52b39c3c1b3bf9357d332d6f2389`.

### Telemetry migration

Deployed:
`supabase/migrations/20260901195000_m2_5_evidence_lineage_classification.sql`
(commit `0f483134de8e0b9cce9791e048e4dfc6e3ceb6ce`).

Corrected live Pilot snapshot after deployment:
- severity: **warning**;
- database: **617,819,283 bytes**;
- Evidence objects: **9,484** at the observation instant;
- Evidence bytes: **4,902,002,299**;
- Evidence planning utilisation: **7.61%**;
- raw unlinked Storage objects: **205**;
- proven duplicate unlinked objects: **200**;
- unresolved orphan objects: **5**;
- virtual/external Evidence references: **16**;
- missing bucket objects: **2**;
- integrity count used for severity: **5**.

Raw counts remain visible in the snapshot. Compatibility fields now represent unresolved integrity only:
- `orphan_object_count=5`;
- `failed_upload_count=2`.

No existing Storage object or Evidence row was changed.

### Forward duplicate prevention

Deployed Edge revisions:
- `layer2-scope-discover-scheduled` source v1.3.3 / Supabase Edge version **20** — commit `a12b4124b7ff3d96c7aae2456cf3124d17ef5151`;
- `layer2-screenshot-backfill-scheduled` source v1.0.1 / Edge version **2** — commit `3f1658ec6c28e03e0504f7bd0a01d47b347a73ae`;
- `provider-contact-discover-scheduled` source v1.3.3 / Edge version **18** — commit `649982a5981e9104776a427f17d3626f2c066e94`;
- `scholarships-au-etl` source v0.1.2 / Edge version **3** — commit `6aca195afbb1a0ecf6db73adbb3891d3662a8c9d`.

All preserve their existing scheduled one-time-nonce boundary and `verify_jwt=false` deployment setting.

The cleanup rule is deliberately narrow:
- registration must prove the just-uploaded path is not the retained Evidence path;
- only that just-uploaded duplicate object is removed;
- Storage API is used, never direct SQL mutation of `storage.objects`;
- cleanup failure logs a warning but does not fail the acquisition;
- retained Evidence paths are never removed.

No real acquisition run was started to prove CF-055.

### Remaining unresolved historical lineage

Retain without deletion:
- 4 Provider-contact Storage objects with no registered-object fingerprint match;
- 1 recovered Layer 2 discovery object with no registered-object fingerprint match;
- 2 legacy Canadian management-plane Evidence paths with no current bucket object.

The two Canadian rows have later Storage-backed Evidence from the same source lineage, but their hashes differ. They remain historical references, not byte-equivalent replacements.

### Advisors

After the telemetry migration and Edge deployments:
- Security: **146 INFO / 0 WARN / 0 ERROR**;
- Performance: **172 INFO / 0 WARN / 0 ERROR**.

### Permanent contract

Added:
`tests/uat/m2-5-evidence-lineage-contract.spec.mjs`.

Wired into targeted/integration/acceptance by:
`0a130874d715012def20eefc4105c1ac7c50f200`.

Final trigger:
`ca1e54f95f9a52b39c3c1b3bf9357d332d6f2389`.

At handback GitHub had not yet attached a workflow run/status. Per the user’s operating instruction, do not poll in-chat; check this exact commit first on the next `Proceed`.

## Current status decision

**IMPLEMENTED / RUNTIME PASS — TARGETED CI PENDING.**

M25-FU-009 is no longer an undifferentiated HIGH integrity finding. Historical unresolved lineage remains open, but classified duplicates/virtual references no longer drive HIGH severity.
