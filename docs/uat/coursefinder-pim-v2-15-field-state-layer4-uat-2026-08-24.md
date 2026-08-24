# CourseFinder PIM v2.15 Field-State & Layer 4 UAT — 24 August 2026

**Status:** BACKEND PASS / V2.15.1 DEPLOYED BROWSER RECOVERY PENDING  
**Change Control:** `CF-CHG-20260824-032`

## Purpose

Prove that Course Detail exposes the governed Course attribute set even when values are empty, layer progress is field-specific, Layer 4 cannot bypass unresolved L2/L3 work, and the drawer remains render-safe for all governed backend payload shapes.

## Reference Courses

### Federation University Australia — Bachelor of Arts

Positive populated path:

- first-party Course URL present;
- English requirement present (`IELTS Academic`, overall 6);
- registered CRICOS fee semantics remain separate from Provider-current tuition;
- Evidence drill-down available.

### Federation University Australia — Bachelor of Science (Honours), CRICOS 088661B

Unresolved-state reference. Layer 2 history proves:

- official Course URL resolved;
- description resolved;
- March/July intakes resolved;
- English attempted but unresolved;
- international tuition attempted but unsafe CSP/Band candidates rejected;
- delivery mode and Academic Options not attempted by the current extractor.

## Backend field-state UAT — PASS

| Attribute | Expected state |
|---|---|
| Provider | Resolved L1 |
| CRICOS / Course code | Resolved L1 |
| Study level | Resolved L1 |
| Field of study | Resolved L1 |
| Duration | Resolved L1 |
| Delivery mode | Awaiting L2 |
| Official Course URL | Resolved L2 |
| Course description | Resolved L2 |
| Current Provider tuition | L2 struck → Awaiting L3 |
| Intakes | Resolved L2 |
| English requirement | L2 struck → Awaiting L3 |
| Campuses | Resolved L1 |
| Academic options | Awaiting L2 |
| Categories | Direct L4 input |
| Collections | Direct L4 input |
| Regulatory facts | Resolved L1 |

Direct SQL validation returned exactly two `awaiting_l2`, two `awaiting_l3`, and two direct `l4_input` values for the unresolved subset.

No accepted Layer 3 persistence/execution table exists yet, so no enrichment field may display a struck L3 / terminal awaiting-L4 state.

## Layer 4 authority UAT — PASS for scalar contract

The governed scalar resolution contract:

- requires Curator rank 3+ at the control plane;
- supports Course description, official Course URL, delivery mode and duration only;
- requires a human reason;
- records prior/new value and actor;
- preserves `resolved_layer=4`;
- does not mutate Search or Publication;
- does not flatten compound tuition/intake/English semantics into free text.

A transactionally rolled-back delivery-mode test on Science (Honours) returned `layer=4`, `search_changed=false`, `publication_changed=false`, showed the test value inside the transaction, and restored the original NULL value after rollback.

Browser writes are now routed through JWT-protected Edge function `layer4-course-resolve`; the database mutation function is service-role-only.

## v2.15.0 deployed manual UAT — FAIL

Manual clicking of a Course produced a blank Course Detail page.

Root cause was isolated to the presentation layer: `state_summary` values may be JSON objects, while v2.15.0 rendered `search`, `canonical` and `admin_readiness` values directly as React children. React rejects an object child and the drawer subtree failed to render.

The Course-detail backend read and canonical data remained valid. This was not a Layer 2 ingestion failure.

## v2.15.1 recovery — APPLIED / BROWSER PENDING

Recovery implementation:

- object-safe display conversion for all operational summary values;
- JSON objects are converted to bounded scalar summaries rather than rendered directly;
- all 16 governed Course attributes remain visible;
- the field-state matrix remains field-specific;
- fee/English/Evidence semantics remain intact;
- no polling or MutationObserver recovery logic added.

Implementation refs:

- `f9c7f79cf950d47f36a4a9ac72b63c710ed6e987` — safe Course renderer;
- `e85258a44afd09fa1bcf92b024c5bca1c67a01c7` — visible v2.15.1 version;
- `1a92714a36ab0531a86ec1e1a88078d633d7fff9` — runtime title/marker;
- `4faf4fbdc7b8e6e114944774d4fed306285601bd` — SHA-bound recovery UAT expectations.

## Deployed automated browser acceptance — PENDING

Desktop and mobile Chromium must prove:

### Bachelor of Arts

- exact `PIM Admin v2.15.1` marker;
- Course drawer visible and title rendered;
- `Operational state` visible without React object-child failure;
- all 16 governed attribute labels visible;
- first-party Course URL correct;
- English explicitly labelled/populated;
- Evidence drill-down responsive.

### Science (Honours)

- all 16 governed attribute labels visible;
- exactly two `Awaiting L3` trails;
- exactly two `Awaiting L2` trails;
- exactly two direct `L4 input` trails;
- blank values displayed as `—`;
- zero scalar `L4 edit` controls while fields are not terminal;
- exactly two `L4 review` actions for direct PIM/L4 fields.

The run must report no browser/server runtime errors.

## Acceptance rule

Do not close `CF-CHG-20260824-032` or the parent M2.1 gate until the deployed SHA-bound desktop/mobile result is PASS. Any further blank-page, lock-up or timeout regression keeps the gate BLOCKED and triggers rollback to the last responsive Course drawer presentation.