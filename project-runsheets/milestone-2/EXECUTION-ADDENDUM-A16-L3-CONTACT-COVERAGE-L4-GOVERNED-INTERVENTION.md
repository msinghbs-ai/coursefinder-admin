# Execution Addendum A16 — Layer 3 International Contact Coverage & Layer 4 Governed Human Intervention

**Status:** ACTIVE — M2.4.4 ADDENDUM  
**Effective:** 30 August 2026  
**Change Control:** `CF-CHG-20260830-048`

## Purpose

Extend M2.4.4 with two related governance requirements:

1. complete explicit international-student/admissions contact-channel coverage from governed first-party university Evidence; and
2. define Layer 4 as a cross-platform governed human intervention capability that can override the effective value/state of an editable field without destroying source truth, Evidence or audit history.

This addendum does not weaken the accepted Layer 1 → Layer 2 → Layer 3 → Layer 4 authority model.

## A16.1 — International contact coverage

The A15 frozen cohort proved acquisition across 52 AU + 8 NZ Provider profiles, but accepted contact observations exist for only 11 Providers. A successful discovery run must not be interpreted as a successful email/contact result.

### Layer responsibilities

- **Layer 1:** retains canonical Provider identity and governed Provider website authority.
- **Layer 2:** acquires first-party university pages and preserves URL, content/Evidence, acquisition route, observed/verified time and A14 provider telemetry.
- **Layer 3:** interprets governed Layer 2 Evidence to classify and extract international-student/admissions contact channels. It may identify:
  - international students/admissions page URL;
  - international contact/team page URL;
  - general international admissions/recruitment email;
  - named international recruitment/regional manager where publicly published;
  - job title;
  - territory/market assignment;
  - institutional email;
  - public work phone;
  - explicit `not publicly published` / `not found in qualified Evidence` disposition.
- **Layer 4:** resolves ambiguous, conflicting, stale or incomplete contact interpretations and may apply governed human overrides under A16.2.

### Coverage target

For every governed AU/NZ Provider in the A15 cohort, retain an explicit disposition rather than treating absence as success:

- official international-student/admissions URL;
- official international contact/team URL where published;
- institutional admissions/recruitment email where published;
- named/territory contact where published;
- source URL + Evidence + last verified;
- explicit unavailable/not-published/not-found state where appropriate.

The initial target remains 60/60 Provider profiles. Contact existence is not manufactured.

### Quality boundary

First-party university Evidence remains preferred. Layer 3 output is interpretation, not source authority. Generic switchboards, unrelated domestic admissions contacts, personal/private details and unsupported territory mappings must not be promoted merely to improve coverage metrics.

## A16.2 — Layer 4 governed human intervention

Layer 4 is available as a human decision capability across the platform and may operate after any Layer 1/2/3 result where the field is designated editable.

### Core rule: overlay, do not destructively rewrite source truth

A Layer 4 edit creates a governed override/decision record and changes the **effective platform value** seen by authorised Admin/consumer projections. It must not erase or mutate immutable source Evidence, raw acquisition content, historical Layer 1 observations, Layer 2 Evidence or Layer 3 interpretation history.

Every overridden field must visibly indicate that its effective value is **L4 edited/overridden**.

### Minimum audit contract

Each Layer 4 edit must retain:

- entity type and stable entity ID;
- field/path being changed;
- underlying value immediately before override;
- new effective value;
- originating layer/source context;
- authenticated user ID;
- authenticated user display/email identity where permitted by internal audit policy;
- edited timestamp;
- reason code;
- optional operator comment/decision note;
- linked Evidence/review item where applicable;
- previous override/version reference;
- change status: active / superseded / reverted;
- publication impact/decision when relevant.

Audit history is append-only. Reverting an edit creates a new event; it does not delete the prior decision.

### Publishability

Publication is a consequential state and must not be conflated with ordinary field editing.

Layer 4 may make an entity/field publishable only through an explicit, role-gated publication decision that records who, when, why and which validation/readiness checks were overridden or satisfied.

A field value override and a publication override are separate auditable decisions even when performed in one operator workflow.

No Layer 4 action automatically authorises Production, Website or Zoho cutover.

### Editable vs protected fields

The platform should classify fields into at least:

1. **editable by Layer 4** — normal governed correction;
2. **editable with elevated approval** — identity, regulatory-sensitive, publication-critical or security-sensitive fields;
3. **immutable source/history** — raw Evidence, source payloads, audit records, historical versions, provider/model telemetry and other provenance.

Layer 4 must never directly edit the immutable class.

### UI behaviour

On Provider/Course/Campus/Scholarship/contact and other governed blades:

- editable fields expose an Edit/Resolve action according to role;
- a Layer 4 badge/marker appears on overridden effective values;
- operator can inspect source value vs effective value;
- audit drawer shows actor, timestamp, reason/comment and previous versions;
- operator can revert to the current governed underlying value by creating a new audited decision;
- conflicting/new upstream data must not silently erase an active Layer 4 override; it should raise revalidation/review.

### Security

- authenticated user identity is mandatory;
- RBAC/rank enforcement is server-side;
- sensitive/elevated fields require stronger role or approval;
- browser clients never receive service-role privileges;
- audit records are not client-writable except through governed mutation functions;
- all mutation RPC/Edge paths require negative/anonymous/insufficient-rank UAT.

## A16.3 — Acceptance requirements

A16 is not complete until:

1. the 60-Provider contact coverage/disposition contract is implemented and measurable;
2. Layer 3 extraction is Evidence-bound and does not manufacture contacts;
3. Layer 4 override persistence and effective-value projection are defined and implemented;
4. field-level L4 marker and audit history are visible in Admin UI;
5. reason/comment capture and revert/supersede semantics are proven;
6. publication override is separately role-gated and auditable;
7. protected/immutable fields cannot be edited through Layer 4;
8. security/RBAC/anonymous negative paths pass;
9. targeted validation → bounded integration → final desktop/mobile acceptance passes.

Any M2.4.4 acceptance run nominated before this addendum remains immutable evidence but cannot alone close the expanded M2.4.4 scope.
