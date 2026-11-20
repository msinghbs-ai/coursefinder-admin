# Layer 4 Review: the 19-queue card contract and audit matrix (s872 to s874)

**Trigger:** Platform Admin 20 Nov 2026 17:13 AEDT, universal minimum-effort Layer 4 overhaul.
**Release:** PIM Admin **v2.16.71** (package 0.1.493).
**Migration:** `20261120174700_cf247_s872_l4_system_queues_apart.sql` (s872).
**CI contract:** `tests/uat/cf-247-s872-s874-l4-universal-card-contract.spec.mjs` covers all 19 queues.
**Status (20 Nov 2026 18:05 AEDT): recorded before merge.** The rolled-back live dry run passed (md5 `c701feda`).

## 1. The contract every card now follows

| Part | Rule | Where |
|---|---|---|
| Rail | **Human Action Required** holds groups a person decides (layer4-groups C and D). **System Queues (Auto-Recovering)** holds groups an existing rule settles or the platform is recovering (A and B). Human groups come first in "All in this queue". | `security.layer4_rule_groups_v1` (`sys~` and `aerb:` keys), `src/Layer4Focus.jsx` |
| Main hold reason | The amber banner gives the reason in plain English. Machine-rule prefixes, version tags and codes are removed from the headline (for example `D-R3`, `gate_incomplete` becomes "gate incomplete"). The full machine text stays under **Technical detail**. | `plainHold`, `CardHold`, `HoldBanner` |
| Action bar | One row. The admitting decision comes first. Decisions where the person enters a value come next; their confirm button is **Save Edit & Admit**. Re-categorise decisions follow. Set-aside decisions (reject, refuse, archive, dismiss, no page) sit on the right. | `orderChoices` / `choiceRole`, `Item` in `src/Layer4Inbox.jsx` |
| Recovery | An AER course read with a stored copy offers **Re-read from stored copy ($0)**. With no stored page, it offers **Queue stored-page fetch** (s870). | `AerRecoveryAction` |
| Batch | Every rule group has **Preview & Settle Batch**: the exact records, read in one keyed call. Banned-word descriptions: admit with the words removed (s837). Recovery groups: re-read or fetch (s870). Other queues: settle with one decision, one reason and a typed `SETTLE n`. Each record is decided on its own, at its own rank. | `BatchPreview` |

## 2. The 19 queues

Live counts were read on 20 Nov 2026 17:20 AEDT, after s871. "Human" is layer4-groups C and D; "System" is A and B.

| # | Queue (kind) | Decisions (bar order) | Human | System | Batch settle | $0 stored-copy re-read |
|---|---|---|---|---|---|---|
| 1 | course_link | keep, use · enter (Save Edit & Admit) · refuse | 419 | 24 | yes | no (no deterministic reader for course links) |
| 2 | held_scholarship | publish · duplicate (edit) · not_international, not_scholarship (re-categorise) | 73 | 0 | yes | no |
| 3 | website_needed | website (edit) · cricos_only (re-categorise) · archive | 40 | 0 | yes | no |
| 4 | pages_not_found | pages · website (edit) · cricos_only · release | 54 | 0 | yes | no |
| 5 | too_few_pages | pages · cricos_only | 129 | 0 | yes | no |
| 6 | nothing_ready | adapter, rebuild · cricos_only | 0 | 317 | yes | no |
| 7 | central_to_approve | open | 4 | 0 | yes | no |
| 8 | onboarding_failed | retry, builder | 0 | 1 | yes | no |
| 9 | site_down | wait · website (edit) · archive | 0 | 149 | yes | no |
| 10 | not_offered | keep · archive_course | 0 | 0 | yes | no |
| 11 | fee_check | course, keep | 10 | 0 | yes | no |
| 12 | counsellor_report | report_fixed, course · report_not_changed | 0 | 0 | yes | no |
| 13 | not_on_site | keep, course · archive_course | 0 | 0 | yes | no |
| 14 | provider_departure | reviewed · merged (edit) · closed | 2 | 0 | **no** (Platform Admin, one at a time) | no |
| 15 | no_page_first_run | approve · has_page (edit) · reject | 55 | 0 | yes (approve and reject) | no |
| 16 | conjoint_first_run | approve · parent (edit) · reject | 5 | 0 | yes (approve and reject) | no |
| 17 | aer_review | approve · approve_except (edit) · reject; recovery: Re-read ($0) / Queue fetch | about 520 (audit sample 464) | about 270 | **no** (A3; only re-read or fetch) | **yes** (aer-det-v1.3) |
| 18 | provider_description | Remove "word" & Admit (banned words), Save Edit & Admit, Approve As-Is · Reject | 207 | 0 | banned-word groups only | no (Re-read uses the AI reader) |
| 19 | course_page_needed | search_again · add_page (edit) · no_page | 1,527 | 0 | yes (search again) | no |

## 3. What this does not do (recorded as gaps)

- **No $0 re-read outside entry requirements.** Only AER has a deterministic reader (aer-det-v1.3). The re-reads of the other queues use the AI reader, which is not $0. They keep their own Re-read decisions.
- **"Re-categorisation" uses each queue's existing decisions** (for example not_international, cricos_only). No new category is invented.
- **Registered kinds are outside the 19.** Interventions, campus localities, Boost study loads and scholarship course links keep their own cards. They are never batch-settled.
