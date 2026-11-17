# Layer 1 AI induction mapper — request and response contract

**Version:** 1.0, 17 Nov 2026 19:00 AEDT
**For:** S2-Build (owner of the edge function `layer1-ai-induction-mapper` and of the Layer 1 readers).
**From:** S1-RM-Design (owner of the Admin wizard, Pilot release v2.16.24, migration `20261117193000`).
**Decision:** Platform Admin, 17 Nov 2026 18:10: the wizard ships with mapping by hand; AI Auto-Map switches on by itself once the mapper is deployed.
**Status:** the mapper is not deployed. The wizard is live and calls nothing until `status` answers.

## How the wizard uses the mapper

Layer 1 › Sources › + Add source › step 3 (Field mapping) calls the edge function from the signed-in browser with `supabase.functions.invoke('layer1-ai-induction-mapper', { body })`. The function receives the user's JWT; it must check the caller is Pipeline Operator (rank 4) or above.

1. When the wizard opens it sends `status`. If the answer is not `{ "ok": true }` (including 404 while the function does not exist), the AI Auto-Map button stays disabled and says the mapper is not deployed.
2. When the person presses AI Auto-Map it saves the draft, then sends `map`. Suggestions fill only the rows the person has not mapped yet, marked "AI" with the confidence. Nothing is saved until the person presses Save & continue; an edited suggestion is stored as `ai_adjusted`.

The mapper suggests; a person decides. It writes nothing to the database.

## Action `status`

Request:

```json
{ "action": "status" }
```

Response (200):

```json
{ "ok": true, "version": "1.0.0", "model": "<the pinned model id>" }
```

## Action `map`

Request:

```json
{
  "action": "map",
  "induction_id": "<uuid of pipeline.layer1_source_inductions>",
  "country_code": "IE",
  "connector_type": "csv_file",
  "source_url": "https://…",
  "sample": { "columns": ["Title", "NFQ Level", "Provider"], "rows": [["Course 1", "8", "Provider"]] },
  "target_fields": [ { "field": "level", "label": "Level", "category_key": "course_basics" } ],
  "categories": [ { "key": "course_basics", "label": "Course basics", "description": "…" } ]
}
```

- `sample.rows` holds at most 20 rows, each an array in column order. Values are text.
- `target_fields` is the full list from `ref.enrichment_category_fields` (32 fields today); `categories` is `ref.enrichment_categories` (8 today). Suggest only values from these lists.
- `connector_type` is one of `csv_file`, `xlsx_file`, `json_api`, `html_pages`, `pdf_document`, `manual_upload`.

Response (200):

```json
{
  "ok": true,
  "model": "<the pinned model id>",
  "suggestions": [
    { "source_field": "NFQ Level", "target_field": "level", "category_key": "course_basics", "confidence": 0.86, "reason": "Values are qualification levels 6 to 10." },
    { "source_field": "Provider", "target_field": null, "category_key": "provider_profile", "confidence": 0.4, "reason": "Provider name; no platform field in the list." }
  ]
}
```

- One suggestion per source field at most. `target_field` and `category_key` may each be `null`.
- `confidence` is 0 to 1. `reason` is one short sentence a person can check against the sample.
- On failure answer `{ "ok": false, "error": "<plain words>" }`; the wizard shows the text.

## What the database accepts (so suggestions save cleanly)

`public.admin_layer1_induction_save` refuses a mapping whose `category_key` is not in `ref.enrichment_categories`, whose `target_field` is not a field name (`^[a-z0-9_.]{2,80}$`), or whose `source_field` is empty.

## Reading an induction and recording a dry run (service role)

| Function | Use |
|---|---|
| `public.svc_layer1_induction_read(p_id uuid, p_source_id uuid)` | The draft or activated induction: country, scheme, connector, licence and terms, mappings, cadence, per-source retention, dry-run result. Pass the id, or the source id after activation. |
| `public.svc_layer1_induction_dry_run_record(p_id uuid, p_result jsonb)` | Records step 5. `p_result`: `status` (`passed` or `failed`), and the counts `rows_read`, `inserts`, `updates`, `departures`, `postcode_escalations` (all required, whole numbers); optional `reader` and `message`. |

- Dry-run size: setting `layer1.induction_dry_run_rows` (100). Postcode escalation: a campus postcode below `destination.postcode_primary_min_share` (0.9), as `security.destination_postcode_flags_v1` decides.
- A recorded dry run switches nothing on. Activation is the Platform Admin's step and saves the source paused; a failed dry run blocks activation until a later one passes.
- Two category lists exist and are tied field by field. The wizard and the completeness report use the eight categories in `ref.enrichment_categories` (Platform Admin 17 Nov 18:10). The Boost matrix (`country_category_boost`, Pilot migration `20261117183000`, Platform Admin 18:02) uses eight other keys. `ref.enrichment_category_fields.boost_category` gives the Boost category of each coverage field, so a mapping to a field resolves to both.
- Category routing: `ref.enrichment_categories` and `ref.enrichment_category_fields` are readable by the service role. The Platform Admin can move a field between categories, so read them rather than copying them into code.

## Model routing

The mapper is AI work whose output a person confirms. Pin it to one named, qualified model and return that id in `model`; do not route under an "auto" model. Its limits (calls, cost) are settings, not values in code (G2).

## Not in this contract

- Building a reader for a new source, and the dry run itself (S2-Build).
- Enforcing per-source retention. The values are recorded on the induction; platform policy and prune jobs are unchanged (Platform Admin decision 17 Nov 2026 18:10).
