# UnoPim lessons-learned: what is built, what is not (s806)

**Date:** 20 Nov 2026 (AEDT) · **Chat:** S1-RM-Design · **Source of the lessons:** `docs/platform/ui-audit/ui-ux-settings-audit-2026-11-15.md` §7 (locked 16 Nov 2026), `docs/coursefinder-pim-admin-guide-v1.0.md` (UnoPIM attribute, group and family organisation; a dashboard that surfaces what needs attention) and `docs/coursefinder-pilot-to-production-project-plan-v1.0.md` (UnoPIM-style UX principles).
**How this was checked:** each row below was matched against the code on Pilot `main` (migrations, `src/`) and the audit's own progress log (its §8). Where something is "not built" it was searched for by name and by purpose and not found.

## Summary

| # | Lesson | Status | Evidence |
|---|---|---|---|
| 7.1 | Decoupled AI platform and prompt registry | **Partly built** | The AI platform is decoupled (`pipeline.ai_model_catalogue`, `ai_service_routes`, `ai_route_qualifications`). `pipeline.prompt_templates` holds three prompts verbatim, **in shadow only**: no worker reads from it (audit §8, Wave C, v2.16.9). Other worker-code prompts (the audit counts 11 services in worker code) are not yet in it. |
| 7.2 | Preview-before-write inline Enrich (extracted value, verbatim quote, confidence; Accept, Regenerate, Discard) | **Not built** | No Enrich popover. Existing on-demand reads write through their own admission path. Layer 4 is the only place a person decides a value with its quote beside it. |
| 7.3 | Field-level history drawer with one-click Restore | **Not built** | No field history table. Locks and Layer 4 decisions are recorded, but there is no per-field `old → new` view and no Restore. |
| 7.4 | Channel-scoped completeness (Website vs Zoho readiness from the consumer contracts) | **Not built** | No `pipeline.channel_contract_fields`. Release 2.16.61 adds a completeness bar for each record (below), but it is not channel-scoped. |
| 7.5 | Migration and UI parity for settings and prompts | **Built for settings; open for prompts** | Settings Hub (v2.16.8, migration `20261116040000`): five groups, search, change log reusing `pipeline.admin_control_events` (a migration logs as `action = 'migration'`), Consumer APIs read-only without an unlock. Prompts: no Hub pane until a reader uses the registry. |
| Dashboard "needs attention" | Surface what needs a person, not a hunt through the catalogue | **Built** | Dashboard › Waiting for you and Layer 4 Review › Inbox. |
| Completeness per record | A share-complete bar on every row | **Built in 2.16.61 (s807)** | Courses: the existing six-signal score drawn as a bar. Providers: the share of nine tracked fields held. |
| Missing-field filter | Narrow a grid to records lacking fields | **Built in 2.16.61 (s807)** | Courses use the filters the list already had (no database change). Providers use a new `missing` argument (migration `20261120090000`, one in-place, md5-guarded edit of `security.admin_providers_page_v3`). |
| Bulk action bar | Act on many ticked rows | **Partly built** | Providers: Fill fields (description only), Export selected as CSV, Clear. Courses: the existing tick-box bar for descriptions. **Not built:** bulk-queue to Intake Run & Validate and bulk-flag primary campus (each needs a new write path; held for approval). |
| Provenance on a record | Where each value came from, and whether it is locked | **Partly built** | Provider drawer panel shows Held or Missing for nine fields and a source pill for the description (Register, AI verified, Human input · Locked). Other fields do not record their source per field, so the panel says so. Course locks are shown by the existing lock notes. |

## What the lessons taught us, and the decision each one needs

| Lesson | Gap | Proposed next step | Decision needed |
|---|---|---|---|
| Prompts in one place | Eight prompts still live in worker code; `prompt_source` drifts | Move them into `pipeline.prompt_templates` in shadow, run the parity report, then switch a reader on as its own approved step | None to continue in shadow |
| Never write silently | Admins have no preview step on AI reads | Build 7.2 only after 7.3, so Accept & Admit can be undone | Platform Admin: order of 7.2 and 7.3 |
| Undo | No per-field history | New history table written by the admission path (G3: beside the catalogue, never in its shape) | Approve a new table |
| Channel readiness | Website and Zoho completeness cannot be told apart | `pipeline.channel_contract_fields` built from the v2 and Zoho contract specs, with a spec keeping it in step | Approve a new table |
| Per-field provenance | Only the description records its source | Record source on the admission path for the fields that matter to the website first | Approve scope |

## Proposed, not shipped
The Layer 4 inline "Edit & Approve" textarea and the six-month "Human Edits & Periodic Audit" bulk re-review bar are **not in the source**. They appear in the s806–s810 mockup labelled proposed. Layer 4 today decides an item with Approve (including Approve except), Reject or Hold, each with a reason; a person corrects a value through the record editor, which writes a manual lock.

## Reading this document
"Built" means present on Pilot `main` and covered by a test. "Partly built" names what is missing. Nothing here switches anything on; a passing qualification still never activates anything by itself.
