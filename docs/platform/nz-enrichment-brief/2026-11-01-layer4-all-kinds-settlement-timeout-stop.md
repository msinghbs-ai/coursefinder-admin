# Layer 4 all-kinds settlement — database timeout safety stop
1 November 2026 (AEDT), UI v2.15.388. Batch L4B-20261101-1051.

## Mandate and actual outcome
User: “go through all pills and i need settlement”.
Re-read current controller and v5 action playbook; searched the admin repo for ANU rank/score settlement remediation. Search found the earlier checkpoint, not a remediation record. This is not proof no remediation exists; no compatibility clearance was established.

Authenticated Platform Admin, refreshed live queue, selected By kind and Central pages to approve (3), then oldest item Niagara College Canada (23 Oct). Opened its destination Adapter builder, step 1.3. No settlement decision was submitted; no value admitted, no item reconciled, no downstream job initiated. All-kinds pass remains incomplete.

## Reproducible blocker
- Niagara central-page destination's Waiting for approval region failed: “The database took too long to answer and stopped the request. Try again in a moment; if it keeps happening, tell the Platform Admin.”
- English policies showed zero pending for Niagara despite central work item. Switched the existing document-type view to Academic calendars; one waiting calendar appeared with raw captured value “Fall 2026 semester: September”. Attached calendar source shown: https://www.niagaracollege.ca/dualcredit/dates. Scope must be verified before provider-wide approval.
- Used Evidence's existing source-URL search to locate its stored copy. Search timed out, ref VK2DWH.
- Dismissed the error and used Refresh for the one permitted retry after intervening observation. Same source lookup timed out again, ref ZKEMAX.
- Old unfiltered evidence rows remained on screen after failures. These are not evidence-search results for Niagara and were not treated as such.
- No repeated write, no pending decision form, no uncertain submission. No external source visit, paid read, AI re-check, SQL or engineering change.

## Required stop
Canonical controller docs/platform/skills/cf-layer4-kbe/SKILL.md, Stop conditions:
“repeated uncertain writes or statement timeouts”.
Repeated database timeouts prevent inspection of the authoritative stored evidence and approval data. Review writes stopped under this rule, not for unrelated concurrent engineering. Did not force approval from the raw calendar value or URL slug.

Owner: Claude/platform engineering for the central-approval and Evidence lookup timeout; Platform Admin for compatibility clearance where needed.
Next action: reproduce the authenticated UI lookup for Niagara source above, inspect timeout causes and restore reliable results; verify central approval data loads and newest stored evidence can be inspected. Then resume the existing mandate without another general GO. The previous ANU rank/qualification-score interpretation issue also remains unverified; do not approve affected reads from existing misleading proposals.

## Final refreshed counts
Successfully returned to Layer 4 and refreshed. Platform Admin, v2.15.388; 1,870 pending, 662 universities, 367 older than seven days.

| Kind | Pending |
|---|---:|
| Course link | 118 |
| Held scholarship | 137 |
| Website needed | 42 |
| Course pages not found | 54 |
| Too few course pages | 131 |
| Adapter has nothing ready | 315 |
| Central pages to approve | 3 |
| Adapter proposal failed | 1 |
| Provider left the register | 16 |
| No page published: first run | 55 |
| Conjoint or double degrees: first run | 5 |
| Entry requirements (AER) | 993 |
| Fee fails the check | 0 |
| Course not offered | 0 |
| Course not on site | 0 |
| Website not answering | 0 |
| Counsellor report | 0 |
| Total | 1,870 |

Five zero kinds were absent from the pills; displayed twelve sum exactly to live total.
This attempt: one central item investigated, zero saved decisions/admissions/reconciliations/deferred decisions/downstream actions. Remaining pills not traversed after mandatory reliability stop. Previous successful batch remains four decisions, 22 destination rows verified Active plus 13 approved rows awaiting destination verification; no double counting or resubmission.

Related records:
- 2026-11-01-chatgpt-work-layer4-settlement-L4B-1020.md
- 2026-11-01-course-link-118-review-register.md

Settlement has not been completed. Navigation, lookup retries and queue census are not settled items.
