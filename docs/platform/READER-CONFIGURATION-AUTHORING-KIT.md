# Reader configuration authoring kit (s1310, deployed contract)

S1-Build, 27 Nov 2026, prepared under the delivery freeze (SS-Programme-Control 14:36 AEDT; coursefinder-admin PR 1293, comment 7209093818).

This kit covers only what is deployed (Pilot #1729 and #1730, migration `20261130171000`). Anything not listed here is refused by the writer with `INVALID_INPUT`: no selectors, scripts, prompts, SQL or field mappings.

## 1. Where a configuration is created

| Route | Who | How |
|---|---|---|
| Screen | PIM Admin (draft, qualify, requalify); Platform Admin (also activate, pause, resume, roll back) | Layer 2/3 Build & enrich › Adapter builder › pick the university › **5 Reader configurations** |
| Operations workflow | A session, with no person at the screen | GitHub Actions › **Reader configuration operations** (`reader-config-ops.yml`), `workflow_dispatch` with `ops` (a JSON list of up to 20 operations) and `by` (who is acting). Each operation is one call of `public.svc_reader_configs_v1`. |

Both routes use the same writer, `security.reader_config_op_v1`, with the same checks and the same log (`pipeline.admin_control_events`, area `reader_lifecycle`). Every change needs `args.reason`. A configuration is never created through CI.

## 2. The operations

| `action` | `args` | Effect |
|---|---|---|
| `list` | `provider_id` | Configurations, versions, samples, results, sources, listing pages, entry rows, the settings dictionary, authority and history. Writes nothing. |
| `save_draft` | `provider_id`, `domain`, `configuration`, `samples`, `source_note`, `reason` | Creates the configuration, or a new draft version. If a draft already exists, it is updated in place. |
| `discard_draft` | `version_id`, `reason` | The draft becomes invalid and is kept in history. |
| `qualify` | `version_id`, `reason` | Takes a fresh snapshot of the samples' stored copies and queues them for the existing worker lease. Stored copies only, deterministic readers, no fetch, no model, $0. |
| `requalify` | `version_id`, `reason` | A successor version on the current stored copies. |
| `activate` | `version_id`, `reason` | The existing step and authority. Academic entry follows its knowledge pattern; scholarships stay `HELD:ACTIVATION_AUTHORITY`. |
| `pause`, `resume` | `version_id`, `reason` | Platform Admin. |
| `rollback` | `version_id` (an earlier version that was active), `reason` | Platform Admin. That version becomes current again and its pages are read again. |

## 3. The configuration contract

### Academic entry (`domain: "academic_entry"`)

| Key | Values | Rule |
|---|---|---|
| `template` | `provider_settings` · `country_page_generic_heading` | Required |
| `url_like` | An SQL `like` pattern on the provider's own site (`%` matches any text), up to 300 characters | Must match at least one of the provider's entry-matrix sources |
| `country_from` | `url_slug` or empty | Required for `country_page_generic_heading` (the country is the last part of the address, from `ref.countries`) |
| `settings` | `{ "<key>": value }` for the keys below | Each key must be a registered `reading.entry_*` setting, and each value must be within its range. `provider_settings` needs at least one key. |

Registered settings, read live on 27 Nov 2026. The screen always lists them from `pipeline.platform_toolset_settings`.

| Key | Platform value | Range |
|---|---|---|
| `reading.entry_quote_window_chars` | 600 | 100 to 3000 |
| `reading.entry_html_table_min_rows` | 5 | 2 to 200 |
| `reading.entry_ruled_grid_min_rows` | 5 | 2 to 200 |
| `reading.entry_ruled_grid_min_columns` | 3 | 2 to 50 |
| `reading.entry_cell_min_levels` | 4 | 2 to 20 |
| `reading.entry_cell_min_lines` | 20 | 5 to 5000 |
| `reading.entry_pdf_per_call` | 1 | 1 to 10 |
| `reading.entry_global_pages_on`, `…_cell_reader_on`, `…_grid_reader_on`, `…_ruled_grid_reader_on`, `…_html_table_reader_on`, `…_quote_parts_on`, `…_value_null_on`, `…_range_lower_bound_on`, `…_subject_rows_on`, `…_qualification_first_on`, `…_country_aliases_on`, `…_pdf_firecrawl_on`, `…_det_only_lease_on` | 0 or 1 (switches) | 0 to 1 |
| `reading.entry_band_label_words`, `…_country_aliases`, `…_global_phrases`, `…_global_qualifications`, `…_global_scope_tokens`, `…_grid_headings`, `…_qualification_countries` | lists | up to 200 texts of up to 200 characters |

### Scholarships (`domain: "scholarship"`)

| Key | Values | Rule |
|---|---|---|
| `template` | `link_hosts` | The only template |
| `hosts_add` | Host names | Up to 10. Each must be the provider's own site host (`pipeline.scholarship_discovery_providers`) or one of its subdomains. It may be empty: qualification finds the hosts on the stored copies. |

### Samples

`samples` is a list of `{ "id": "<entry-matrix source id or listing page id>", "role": "positive" | "negative" }`.

- There can be at most `reader.qualify_samples_max` samples (8), and at least one must be positive.
- Every sample must be the provider's own stored page. For academic entry, a positive sample must also fall within `url_like`.
- **Passing.** Academic entry needs at least `reader.qualify_min_positive` (2) positives read by a proven reader, or passing the guard while the routed model is available. Scholarships pass when every positive gains awards.
- **Negatives.** A `provider_settings` negative must not be read into rows. A `country_page_generic_heading` negative must stay held. A scholarship negative listing must gain nothing.

## 4. Example: the operations workflow `ops` input

```json
[{"action":"save_draft","args":{"provider_id":"2c4f515c-c146-4e90-ba8a-294130aa1f40","domain":"academic_entry",
  "configuration":{"template":"provider_settings","url_like":"https://www.qut.edu.au/__data/assets/pdf_file/%International-entry-requirements%","settings":{"reading.entry_quote_window_chars":3000}},
  "samples":[{"id":"649d017d-a168-4bc5-a656-e176c499d150","role":"positive"},{"id":"fd198a4d-ac37-4910-8e4e-62be983653a0","role":"positive"}],
  "source_note":"QUT by-country PDFs (foundation, diploma)","reason":"why this configuration"}},
 {"action":"qualify","args":{"version_id":"<version_id from save_draft>","reason":"qualify on stored copies"}}]
```

A scholarship draft uses `"domain":"scholarship","configuration":{"template":"link_hosts","hosts_add":[]}` with listing page ids as samples.

## 5. Not in this release

The following are not launch blockers:

- direct JSON file upload and export on the screen (the workflow above takes the same JSON);
- field mappings, selectors and new templates;
- scholarship activation authority (held for the Platform Admin).
