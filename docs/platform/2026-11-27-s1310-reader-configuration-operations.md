# Reader configuration operations (s1310)

S1-Build, 27 Nov 2026. Assignment: SS-Programme-Control 13:39 and 13:43 AEDT, "P0 — Australian University Reader Plugin Implementation". Direction: Platform Admin 27 Nov 2026, coursefinder-admin #1293 (reader configuration is data; shared engine code is governed; no per-institute CI).

## What exists already

- s1303 (academic entry) and s1304 (scholarships) hold reader configurations as Layer 2 source profiles and versions (`pipeline.layer2_source_profiles`, `pipeline.layer2_source_profile_versions`). They detect held pages, propose a configuration, qualify it on stored copies with the existing readers, and activate it as a separate step.
- There was no screen or writer for a person to create, change, qualify, activate or roll back a configuration.

## What s1310 adds

| Part | Detail |
|---|---|
| Screen | Layer 2/3 › Adapter builder › **5 Reader configurations** (collapsed). Shows the stored sources, each configuration's versions and what changed, its samples and results, the activation authority, what it read and admitted, and the next requalification. Actions: New configuration, Change as a new draft, Save draft, Qualify on stored copies, Discard draft, Requalify, Activate, Pause, Resume, Roll back. |
| Writer | `security.reader_config_op_v1` is the only writer. The screen reaches it through `public.admin_reader_configs_v1`: PIM Admin may draft and qualify; Platform Admin may also activate, pause, resume and roll back. The `reader-config-ops` workflow reaches it through `public.svc_reader_configs_v1` (service role). Every change needs a reason and writes an `admin_control_events` line. |
| Closed list | Academic entry: template (`country_page_generic_heading` or `provider_settings`), address pattern, country from the address, and registered `reading.entry_*` settings within their ranges. Scholarships: hosts of the provider's own site that the listing links its awards to. No code, SQL, selector or prompt. |
| Qualification | A draft is a pending version whose samples are in state `draft`, so they are never leased. Qualify queues them for the existing worker lease (stored copies, deterministic readers, no fetch, no model, $0). Negatives depend on the class: a `provider_settings` negative must not be read into rows, and a negative scholarship listing must not gain awards. A pass switches nothing on. |
| Activation | Uses the existing step and authority. Academic entry follows its knowledge pattern; `provider_settings` is on the same footing as the Standing Authority Charter item 1 readers. A pass that relied on the routed model is switched on only while that model is available. Scholarships stay `HELD:ACTIVATION_AUTHORITY` until the Platform Admin grants authority. When a `provider_settings` version is activated, its pages are read again once. |
| Requalification | `reader.requalify_days` (365). An active version is qualified again on the current copies after that many days, or sooner when a sample copy changes. A successor that passes replaces it through the existing activation step. A successor that fails pauses it for a person, and the outcome is recorded. |
| Governance | No job, queue or table is added. G2: one setting. G3: 75/48 checked. Locks and cron are unchanged. Nothing is dropped. Spec `cf-247-s1310-reader-config-operations-contract`. |

## No per-institute CI

A configuration for a new university is created through the screen or the operations workflow, never by a migration or pull request. CI runs only for changes to shared code, through the normal release controls.
