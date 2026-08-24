# CourseFinder PIM v2.15 Field-State & Layer 4 UAT — 24 August 2026

**Status:** BACKEND PASS / DEPLOYED BROWSER PENDING  
**Change Control:** `CF-CHG-20260824-032`  
**Pilot head:** `effa55f60974e27ad3f27fcd74543f2785fb91ce`

## Purpose

Prove that Course Detail exposes the governed Course attribute set even when values are empty, that layer progress is field-specific, and that Layer 4 cannot bypass an unresolved Layer 2/3 workflow.

## Reference Courses

### Federation University Australia — Bachelor of Arts

Used as the populated positive path. Existing expectations include:

- first-party Course URL present;
- English requirement present (`IELTS Academic`, overall 6);
- registered CRICOS fee semantics remain separate from Provider-current tuition;
- Evidence drill-down remains responsive.

### Federation University Australia — Bachelor of Science (Honours), CRICOS 088661B

Used as the unresolved-state reference.

Layer 2 retained Evidence/extraction history proves:

- official Course URL resolved;
- Course description resolved;
- March/July intakes resolved;
- English extraction attempted but returned no requirement;
- international tuition extraction attempted but available CSP/Band candidates were rejected as unsafe/low-confidence;
- delivery mode and Academic Options were not attempted by the current Course-facts extractor.

## Backend field-state UAT — PASS

Expected/observed reference states for Science (Honours):

| Attribute | Expected state | Reason |
|---|---|---|
| Provider | Resolved L1 | authoritative Provider identity |
| CRICOS / Course code | Resolved L1 | authoritative regulatory identity |
| Study level | Resolved L1 | canonical Layer 1 fact |
| Field of study | Resolved L1 | canonical Layer 1 fact |
| Duration | Resolved L1 | canonical value present |
| Delivery mode | Awaiting L2 | no field-specific Layer 2 attempt evidence |
| Official Course URL | Resolved L2 | first-party URL acquired/applied |
| Course description | Resolved L2 | first-party meta-description applied |
| Current Provider tuition | L2 struck → Awaiting L3 | Layer 2 attempted; unsafe domestic/CSP-style candidates rejected |
| Intakes | Resolved L2 | March/July present |
| English requirement | L2 struck → Awaiting L3 | Layer 2 attempted; no safe requirement extracted |
| Campuses | Resolved L1 | Layer 1 campus relationships present |
| Academic options | Awaiting L2 | not attempted by current extractor |
| Categories | Direct L4 input | PIM/human-managed field |
| Collections | Direct L4 input | PIM/human-managed field |
| Regulatory facts | Resolved L1 | current regulatory observation present |

Direct SQL validation returned exactly:

- 2 `awaiting_l2` among the reference unresolved subset: Delivery mode, Academic Options;
- 2 `awaiting_l3`: Provider-current tuition, English requirement;
- 2 `l4_input`: Categories, Collections.

No Layer 3 persistence/execution table currently exists, so no enrichment field is allowed to display a struck L3 / terminal awaiting-L4 state yet.

## Layer 4 authority UAT — design/security PASS, mutation browser UAT pending

Created a governed scalar resolution contract that:

- requires authenticated Curator rank 3+;
- supports only Course description, official Course URL, delivery mode and duration;
- requires a human resolution reason;
- records prior/new value and actor in `pipeline.layer4_course_field_resolutions`;
- preserves `resolved_layer=4` after application;
- does not change Search or Publication;
- cannot mutate compound tuition/intake/English facts through generic free text.

UI actions are terminal-state gated. For Science (Honours), no scalar `L4 edit` control should appear because its scalar gaps are still Awaiting L2. Only Categories/Collections should expose `L4 review` as direct PIM/L4 fields.

## Deployed automated browser acceptance — PENDING

`tests/uat/course-detail-polish-deployed.spec.mjs` requires desktop/mobile Chromium to prove:

### Populated Course

- application loads and Course drawer remains responsive;
- exact `PIM Admin v2.15.0` marker;
- all 16 governed attribute labels visible;
- first-party Course URL works;
- English is explicitly labelled and populated;
- Evidence navigation remains responsive.

### Unresolved Course

Science (Honours) must display in the **Course attributes** matrix:

- all 16 governed attribute labels even when empty;
- exactly 2 `Awaiting L3` trails;
- exactly 2 `Awaiting L2` trails;
- exactly 2 direct `L4 input` trails;
- blank values as `—`;
- zero `L4 edit` buttons;
- exactly 2 `L4 review` buttons.

The browser run must also report no server/browser runtime errors.

## Acceptance rule

Do not close `CF-CHG-20260824-032` or the parent M2.1 gate until the deployed SHA-bound desktop/mobile result is PASS. Any responsiveness regression reopens the recovery gate immediately.