# UnoPim lessons-learned: what is built, what is not (s806, updated for s812)

**Date:** 20 Nov 2026 (AEDT; updated after s812, Pilot v2.16.64) · **Chat:** S1-RM-Design · **Source of the lessons:** `docs/platform/ui-audit/ui-ux-settings-audit-2026-11-15.md` §7 (locked 16 Nov 2026), `docs/coursefinder-pim-admin-guide-v1.0.md` (UnoPIM attribute, group and family organisation; a dashboard that surfaces what needs attention) and `docs/coursefinder-pilot-to-production-project-plan-v1.0.md` (UnoPIM-style UX principles).
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
| Missing-field filter | Narrow a grid to records lacking fields | **Built in 2.16.61 (s807)** | Courses use the filters the list already had (no database change). Providers use a new `missing` argument (migration `20261120100000`, one in-place, md5-guarded edit of `security.admin_providers_page_v3`). |
| Bulk action bar | Act on many ticked rows | **Built in 2.16.64 (s812) for Providers** | Providers: Fill fields (description only), **Queue to Intake Run & Validate** (a hand-off list on Layer 2/3 › Operations; each provider is chosen in turn for the existing preview, fix and run; the hand-off runs and spends nothing), **Flag primary campus** (Platform Admin; preview, then Apply with a reason; the B2 rule for the ticked providers only; skips providers that already have a primary campus, have it locked, tie or are outside AU, NZ and CA; one audit event; migration `20261120104000`, an action of the existing `admin_layer4_inbox`, no new public function; the size of one request is the setting `bulk.primary_campus_max`), Export selected as CSV, Clear. **Not built:** the Courses grid has no row selection, so it has no bulk bar beyond the existing tick-box description bar. Queueing is by provider, because the intake run takes one provider (page by page) or hand-picked courses. |
| Provenance on a record | Where each value came from, and whether it is locked | **Partly built (locks built in 2.16.64, s812)** | **Human Locked** pill beside every tracked field a person has locked: Provider drawer (nine tracked fields) and a Locks by hand panel in the Course drawer (description, duration, tuition, intakes, English, course page, official page, status), read from `pipeline.manual_locks`; locks on other fields (a name, the Course Finder switch) are listed in a line. **Register** and **AI verified** are shown for the description only, because it is the one field that records its source. For every other field the source is not recorded, and the screens say so rather than guess. |

## What the lessons taught us, and the decision each one needs

| Lesson | Gap | Proposed next step | Decision needed |
|---|---|---|---|
| Prompts in one place | Eight prompts still live in worker code; `prompt_source` drifts | Move them into `pipeline.prompt_templates` in shadow, run the parity report, then switch a reader on as its own approved step | None to continue in shadow |
| Never write silently | Admins have no preview step on AI reads | Build 7.2 only after 7.3, so Accept & Admit can be undone | Platform Admin: order of 7.2 and 7.3 |
| Undo | No per-field history | New history table written by the admission path (G3: beside the catalogue, never in its shape) | Approve a new table |
| Channel readiness | Website and Zoho completeness cannot be told apart | `pipeline.channel_contract_fields` built from the v2 and Zoho contract specs, with a spec keeping it in step | Approve a new table |
| Per-field provenance (Register, AI verified) | Only the description records its source; Human Locked is now shown for every tracked field | Record source on the admission path for the fields that matter to the website first, in a table beside the catalogue (G3) | Approve a new table (the History drawer in 7.3 can share it) |

## Earlier proposals now built
The Layer 4 inline Edit & Approve and the six-month Human Edits & Periodic Audit are **built** (S1-Build, s802 to s805, Pilot #1406, v2.16.62, migration `20261120101000`). An earlier version of this document listed them as proposed only; that is out of date.

## Reading this document
"Built" means present on Pilot `main` and covered by a test. "Partly built" names what is missing. Nothing here switches anything on; a passing qualification still never activates anything by itself.
