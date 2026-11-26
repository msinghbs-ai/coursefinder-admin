# DR-19: record processing journey, diagnosis and human-assisted resolution (design adjustments)

**Owner:** S2-Build (UI and the read contract's first version), with S2-RM-Design (shared diagnostic and recovery contract). S1-Build stays integration and release owner.
**Mandate:** SS-Programme-Control, 26 Nov 2026 19:19 AEDT, "DR-19: intelligent monitoring and human-assisted resolution" (Platform Admin execution mandate).
**Status:** design recorded 26 Nov 2026 19:25 AEDT. Increment 1 (`s1272`) built, rehearsed and recorded before merge at 19:40.

## 1. What changes, and what does not

- **No new dashboard, page, tab or navigation level.** The journey and the diagnosis are one more fold, **Processing journey and diagnosis**, on the existing Layer 4 card. That card is the same component in the focused view (Waiting, grouped by rule) and in the list views, so both get it with one change.
- **Data Delivery** keeps its stream view. A record-level drill from a stream's holds into the same fold is increment 2 (section 7). It needs a per-record list from the shared contract first.
- **No cosmetic redesign.** The fold reuses the card's existing styles (`l4z-fold`, `l4lc-*`) and the PIM `StatusChip` tones. The only new style is the eight-stage strip, which wraps on a phone.
- **No backend logic in the frontend.** The fold renders what `public.admin_record_journey_v1` returns; every stage state and reason is decided on the server.
- **Actions are unchanged.** The fold names the card's existing decision buttons (the same choices, roles and admission paths) as the authorised next action. It adds no new action, permission or admission path.
- **No spend.** The read runs no model. An AI diagnosis is shown when the platform has already made one (Layer 4 interventions: the stronger model analyses a failure once). Otherwise the fold says none has been run.
- **G3 untouched.** The read only reads the consumer API's tables, and never through or into its shape.

## 2. The eight stages

| Stage | Read from |
|---|---|
| Discovery | the stored evidence's source page; else the course's active official page (`catalogue.course_links`) |
| Acquisition | the stored copy (`pipeline.evidence_artifacts`: stored path or content hash, time, type) |
| Extraction | the value the reader proposed (`layer4_review_items.proposed_value`); the reader run and its model (`pipeline.field_enrich_items`) |
| Normalisation and mapping | the AI interpretation when there is one (`pipeline.layer3_interpretations`: status, validator result, model, prompt version, confidence, cost); otherwise "deterministic reader, no AI interpretation" |
| Validation | the item's decision state and the gate that holds it (the course entry completeness gate for entry reads; the item's hold reason otherwise) |
| Canonical admission | the Layer 4 lifecycle's admission check (`security.layer4_item_lifecycle_v1` › `steps.admitted`) |
| Publication | the lifecycle's publication check (`steps.published`) |
| Website and Zoho verification | none is recorded per record yet, so the stage reads **Not verified** (increment 2, shared contract) |

**Each stage has one state:**
- `done`;
- `failed`;
- `held` (waiting for a person or a gate);
- `not_started`;
- `skipped` (not used for this kind of record, or replaced by a newer read);
- `waiting` (not reached: an earlier stage stopped it; the reason names that stage);
- `not_verified`;
- `unavailable` (the platform keeps no per-stage record for this kind of item; the reason says so).

The first stage that is not `done` is the **stopping stage**. Every later stage that is not done reads `waiting`, with "Not reached: waits for <stage>".

**Unavailable, not verified and zero are never merged.**
- A missing value is `null` with a reason, shown as "Not available".
- An unchecked value is `not_verified`, shown as "Not verified".
- A measured zero is `0`, shown as 0 (for example US$0.00 for a stored-copy re-read).

## 3. The diagnosis (same read)

| Field | Source in increment 1 | When there is none |
|---|---|---|
| Exact failure reason | the stopping stage's reason | n/a |
| Stored source evidence | evidence id, page, captured time, type, hash prefix, whether a stored copy exists | "No stored copy is linked" |
| Previous attempts | the lifecycle's events (reviewer and automatic), corrected reads, the technical work item's attempts and failure class | 0 attempts (a measured zero) |
| Reader and AI model | the reader run's source and model; the interpretation's model, prompt version and confidence | "Deterministic reader: no model" when the reader is deterministic; "Not recorded" otherwise |
| Failed validation or admission gate | the gate's missing parts, or the item's hold reason | n/a |
| AI-assisted root cause diagnosis | the intervention's AI analysis, recommendation and required input | "Not run: the platform runs one only when automatic recovery fails, so nothing was spent" |
| Similar resolved cases | items of the same field and hold reason decided in the last `layer4.journey_similar_days` days (G2, 90): outcome counts and the latest `layer4.journey_similar_max` (G2, 5), each with its reference | 0 similar cases |
| PR and resolution references | the item's and the similar items' change-control references; the intervention's integration issue | "None recorded" |
| Recommended recovery | the intervention's recommendation; else the lifecycle's repeat-guard alternative; else its next step | n/a |
| Estimated recovery cost | a stored-copy re-read by the deterministic reader (entry reads) is US$0.00; an AI re-interpretation is the average cost of this task's last interpretations, with the count | "Not available" |
| Potential data population gain | what admission would fill: the field, the course or provider, and the row count where the value has rows | n/a |
| Authorised next action | the card's own decision buttons, with the role each needs (the existing Layer 4 rules) | n/a |
| Actual outcome | decision state and time, admission and publication from the lifecycle | "Not decided yet" |

## 4. Read contract (increment 1): `public.admin_record_journey_v1(p_args jsonb)`

**Input:** `{kind, ref}`, the Layer 4 item. Signed-in Curator and above (rank 3), the same as the lifecycle read.

**Output:**
```
{kind, ref, found, family, subject, stopped_at, stopped_label, stopped_state, stopped_reason,
 stages: [{key, label, state, reason, at, detail}],
 diagnosis: {failure_reason, evidence, attempts, reader, gate, ai_diagnosis, similar, references, recommendation, cost, gain, outcome},
 lifecycle_stage, generated_at}
```

**Families:**
- `review_item`: course link, entry, matrix, description, no page and conjoint items; the full journey.
- `intervention`: validation, admission and publication from the intervention; earlier stages `unavailable`.
- `lifecycle_only`: every other kind, mapped from the lifecycle's steps; stages it does not track are `unavailable`.

The functions inside are `security.record_journey_v1(kind, ref)` and the two settings. There is no table, job, cron or spend.

## 5. For S2-RM-Design: the shared diagnostic and recovery contract

This read is the first version of the shared contract. S2-RM-Design owns what it does not yet hold:
1. **Website and Zoho verification per record:** a recorded check that a published record is returned by the website read (v2 and v3) and by Zoho, with its time. Until then the stage reads Not verified.
2. **A per-record list behind Data Delivery's holds and recoveries** (stream, stage, provider), so Data Delivery can open the same fold for a record (increment 2).
3. **Resolution references:** PR numbers and change-control items linked to the records they fixed, beyond `change_control_ref`, so similar cases can name the PR that settled them.
4. **Recovery outcome measurement:** for an automatic recovery, the fields it filled when it ran (realised gain), so the diagnosis can show measured gain beside potential gain.

The keys above stay stable. New fields are added beside them.

## 6. Guardrails

- PIM visual design kept, desktop and 412 px phone width, no sideways scroll.
- S1-API-Frontend-Delivery's page search (s1270) is not touched.
- Permissions, G3, manual locks, cron ceiling and spend controls are unchanged.
- Admin pull request first, then Pilot; live-dry-run rehearsal; production UAT on the signed-in browser.

## 7. Increments

1. **s1272, Layer 4 card:** the read contract, the fold on every Layer 4 card, and the guide text.
2. **Data Delivery drill:** a record list for a stream's holds and recoveries, opening the same fold. Needs contract item 2.
3. **Course record drawer:** the journey per field on the Course catalogue blade.
4. **Verification and realised gain:** after contract items 1 and 4.
