# CourseFinder Operations Runbook v1.0

**Effective:** 23 August 2026  
**Status:** CURRENT — M1 OPERATIONS HANDOVER  
**Audience:** Integration/Operations Support, Pipeline Operator, PIM Admin, Platform Admin

## 1. Operating principles

1. Read `PROJECT_INSTRUCTIONS.md` and `change-control/REGISTER.md` before material action.
2. Preserve authority boundaries: Layer 1 → Layer 2 → Layer 3 → Layer 4 → Search Admission → Publication.
3. Never repair a failed pipeline by inventing canonical values or manually editing downstream derived rows.
4. Prefer bounded dry-run, APPLY, immediate replay and idempotency evidence.
5. Evidence is part of the operation, not optional logging.
6. Search admission and publication are separate controls.
7. Production security gates are stricter than Pilot exceptions.

## 2. Pre-flight checklist

Before a material run:

- identify the owning Change Control and overlapping open controls;
- verify source/configuration and source authority;
- verify environment/project before executing any write;
- identify expected entity scope and stable identity keys;
- confirm evidence storage path/private boundary;
- record current row counts/hash/projection state where relevant;
- determine rollback/reversion path;
- use a bounded sample before broad APPLY when source/mapping behaviour changed.

## 3. Source refresh

### Normal refresh

1. Open **Sources** and verify source status/configuration.
2. Confirm acquisition method and expected authority/grain.
3. Start/observe the governed job using the accepted adapter/configuration.
4. Verify acquisition completed and Evidence artifact/snapshot exists.
5. Compare discovered/selected/processed/accepted/rejected and create/update/unchanged/conflict counts.
6. Inspect source-null/zero/not-applicable behaviour for regulated fields.
7. If canonical writes are authorised, APPLY only the accepted scope.
8. Replay the same scope immediately; expected stable inputs should produce no duplicate identity and no unexplained derived churn.
9. Update Change Control/UAT evidence.

### Source-health warning

A stale/failed health signal is not permission to switch to an arbitrary alternative source. Qualify source authority first. If source semantics or structure changed, follow Section 7.

## 4. Failed jobs

1. Locate the job in **Jobs** and record job ID, layer, source, start/end time, last successful run, cursor and failure text.
2. Determine whether failure is acquisition, authentication/403, parse/structure, identity resolution, mapping, storage/evidence, canonical write, Search refresh or publication.
3. Inspect associated Evidence and source snapshot before retrying.
4. Fix the cause at the owning layer; do not patch a downstream table to bypass failure.
5. Resume from the governed cursor only when the operation supports safe resume.
6. Otherwise rerun the bounded deterministic scope.
7. Confirm no duplicate Provider/Course/Campus/Scholarship identities and no unintended updates.
8. Record final result in the Change Control.

Escalate as **BLOCKED** when the authoritative source is unavailable or materially ambiguous and no governed deterministic path exists.

## 5. Replay and idempotency

For ingestion/enrichment/Search refresh changes:

- perform dry-run first where supported;
- record input/source hash and intended scope;
- APPLY once;
- run immediate replay with identical input;
- verify creates=0 and updates/changes=0 unless a documented time-dependent field legitimately changes;
- verify unchanged count matches the accepted scope;
- verify stable canonical IDs;
- verify Evidence is not duplicated incorrectly;
- verify Search semantic hash does not churn due only to projection-version/runtime metadata.

For Search, accepted full refresh is `search.refresh_course_documents_v3(p_apply)`. Canonical facts must not be mutated by Search refresh.

## 6. Evidence inspection

Use Evidence to trace:

`Source → Job → Artifact/Snapshot → Observation/Claim → Canonical Entity/Field → Review/Decision → Search/Publication consequence`.

Validate:

- source URL/authority;
- acquisition timestamp;
- content hash/snapshot/version;
- storage metadata and privacy;
- job association;
- entity/fact association;
- current versus superseded observation;
- verification/freshness context.

If the evidence cannot support the proposed value at the same grain/scope, reject or route to review rather than promote it.

## 7. Source changes

Trigger this procedure when URL, schema, labels, pagination, authentication, anti-bot behaviour, file format, field meaning or source coverage changes.

1. Open/update Change Control in the category owning the semantic impact.
2. Capture old/new source evidence and exact structural/semantic difference.
3. Determine whether identity, source authority, precedence, grain or field meaning changed.
4. Do not silently modify mappings where semantics changed.
5. Run bounded parser/acquisition UAT.
6. Run bounded dry-run/APPLY/replay if canonical writes are affected.
7. Verify data-quality states rather than converting new nulls into defaults.
8. Re-run security/ACL checks if new storage/RPC/runtime surfaces are introduced.
9. Update PIM Admin Guide if an administrator could misinterpret the changed field/workflow.

Persistent 403/anti-bot behaviour should be handled by the governed acquisition design (for example approved proxy/scraper configuration), not by weakening evidence requirements.

## 8. Rollback / reversion

### Data/schema/runtime change

Use the rollback defined in the owning Change Control/migration. Verify forward and rollback identity counts and dependent projections.

### Ingestion/enrichment

Prefer deterministic reversion using accepted source/version and scoped identifiers. Do not delete shared canonical identities solely because one enrichment observation is rejected.

### Search

Restore the prior accepted projection/function/version only through governed migration/change control. After rollback, verify row count, hashes and publication state.

### Documentation-only

Revert the documentation commit; no database rollback is required.

## 9. Security incident escalation

Examples: suspected service-role exposure, unauthorised Admin access, Evidence leakage, role escalation, unexpected public RPC/table/storage access or suspicious Auth activity.

1. Stop the affected privileged operation.
2. Preserve logs/evidence; do not delete audit trail.
3. Identify exposed credential/session/surface and affected environment.
4. Revoke/rotate credentials or disable affected account through governed controls where required.
5. Validate RLS/ACL/RPC/storage permissions and server-side rank checks.
6. Open/update a `70-security-platform` Change Control or incident record.
7. Re-run security UAT before restoring privileged workflow.
8. Do not treat the Pilot leaked-password exception as transferable to Production.

Production go-live requires leaked-password protection to be enabled and UAT-proven under `CF-CHG-20260823-022`.

## 10. Search admission operations

Before admitting enrichment:

- confirm domain gate and source-specific gate are explicitly approved;
- confirm source UAT passed;
- confirm grain matches Course Search semantics;
- keep CRICOS registered tuition separate from Provider-current tuition;
- do not admit QILT/PRISMS at Course grain where mapping would be invented;
- dry-run refresh and compare semantic/content hashes;
- APPLY and replay;
- verify expected changed/unchanged scope.

Current accepted Search projection is `course-v3` with 33,105 AU+NZ Course documents.

## 11. Publication rollback

Broad catalogue publication is not authorised by current Pilot acceptance.

For any bounded publication action:

1. capture canonical publication state, Search publication state and channel-state rows before change;
2. verify explicit allowlist/scope and authorised publication profile;
3. execute positive path;
4. verify only intended Website/Zoho consumer scope became visible;
5. to rollback, restore canonical Course to unpublished and run the governed Search/publication refresh/reconciliation;
6. remove/restore affected channel-state rows according to the publication contract;
7. prove no unintended published Search documents remain;
8. record exact before/after/rollback evidence.

Current handover baseline: 33,105 Search documents, 0 published, 33,105 unpublished.

## 12. Access and role troubleshooting

- Evidence / Review Queue requires rank 3.
- Jobs / Sources / pipeline control requires rank 4.
- Attributes/PIM Configuration requires rank 5.
- Settings and Users & Roles require Platform Admin rank 6.
- Effective access is the highest active unexpired governed role.
- Do not test self-lockout by removing the last Platform Admin; use accepted negative-test evidence.

## 13. Routine handover evidence

For each operational incident/change, capture:

- Change ID;
- environment;
- source/job IDs;
- stable entity identifiers;
- input/source hash where available;
- dry-run result;
- APPLY result;
- replay/idempotency result;
- Evidence artifact reference;
- Search projection/hash impact;
- publication/channel impact;
- ACL/security result where relevant;
- rollback result;
- final PASS/BLOCKED/DEFERRED status.

## 14. Governing references

- `PROJECT_INSTRUCTIONS.md`
- `change-control/REGISTER.md`
- `docs/coursefinder-user-guide-v2.0.md`
- `docs/coursefinder-pim-admin-guide-v1.15.md`
- `docs/coursefinder-database-architecture-v2.10.40.md`
- `docs/coursefinder-data-quality-readiness-contract-v1.0.md`
- `docs/coursefinder-publication-governance-contract-v1.0.md`
- relevant `docs/uat/` technical acceptance records.