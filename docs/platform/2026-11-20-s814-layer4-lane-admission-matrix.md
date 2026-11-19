# Layer 4 lane admission matrix (CF-247 s814)

**Date:** 20 Nov 2026 · **Chat:** S1-Build · **Directive:** Platform Admin 20 Nov 2026 09:55 AEDT (s813–s819) · **Change:** Pilot #1410 (`20261120110000`)

## How this was measured

- Every Layer 4 kind with waiting items was read live on 20 Nov 2026 between 10:05 and 10:25 AEDT. The measurements ran as the Platform Admin, inside rolled-back runs of the `db-migration-dry-run` workflow, so nothing was kept.
- For each kind, the oldest waiting item was decided with every choice the Inbox offers. Each decision was rolled back on its own.
- Two things were recorded for each choice:
  - the time the decision took;
  - which catalogue, scholarship and search tables it wrote. These are the per-transaction table counters, which record writes even when the decision is rolled back.
- **"Writes the catalogue"** means the decision itself changed a `catalogue.*` or `scholarship.*` table.
- **"Reaches search"** means it also changed `search.course_documents` or queued `search.refresh_requests` in the same decision.
- **"Downstream"** means the decision is kept in `pipeline.*` and a scheduled step writes the catalogue later.
- Counts are the waiting items at 10:05 AEDT. Kinds with no waiting items (Scholarship course links, Counsellor report, Course not offered, Course not on the site) are left out.

## Matrix

| # | Kind | Waiting | Admit (or main action): what it writes | Reject / other actions | Works end to end? | Blocker found | Bulk or rule-based drain |
|---|---|---|---|---|---|---|---|
| 1 | Entry requirements (AER) | 2,562 | Approve → `catalogue.provider_entry_matrix` | Reject, Re-read stored page → the same table; Request evidence, AI analyse, Open intervention → pipeline only | Writes the catalogue; course search documents are refreshed by the scheduled entry-matrix steps (downstream) | None in the decision. Approve except needs the rows ticked. | One item at a time by rule (AER v1 is frozen). Batch approval of verified, page-quoted rows is s816–s817. |
| 2 | Course page needed | 1,689 | Add page → `catalogue.course_links`, `catalogue.courses`, `search.course_documents` | Search again, No page → pipeline only | Yes | None | Search again can be run on a whole university; no bulk Add page (each needs its own address) |
| 3 | Human input needed (interventions) | 487 | Provide URL, Attach document, Select source → pipeline only (the owning lane reads them) | Return to technical, Reject evidence → pipeline | Downstream | Actions not offered for an item's type are refused by design | None; each needs its own input |
| 4 | Course link | 422 | Use (fee check) → `catalogue.course_fees`, `search.course_documents` | Keep → pipeline; Enter and Refuse are refused on fee items by design | Yes | None (Use 0.8 s, fixed by s814) | None; each fee is checked by a person |
| 5 | Adapter has nothing ready | 318 | Rebuild → adapter build queued (pipeline) | CRICOS data only → adapter wave (pipeline) | Downstream | Rebuild took 2.5 s (decision guard scan; fixed by s814) | CRICOS data only could be applied to a ticked set (not built) |
| 6 | University and Course description | 213 | Approve → `catalogue.courses` or `catalogue.providers`, `search.refresh_requests` | Reject, Re-read → pipeline; Edit & Approve (s802) → the catalogue, human input, locked | Yes | Approve took 0.6 s (held promotion scan; fixed by s814) | Approve all verified for a provider (exists, course descriptions; the reviewer types the count) |
| 7 | Website not answering | 149 | Website → `catalogue.providers` | Archive → `catalogue.providers`, `catalogue.course_entry_requirements`, `search.refresh_requests`; Wait → pipeline | Yes | None | None |
| 8 | Too few course pages | 129 | CRICOS data only → pipeline | Pages → opens the builder | Downstream | None | As row 5 |
| 9 | Held scholarship | 82 | Publish → the review is admitted and the scholarship is queued for the hourly publish checks (pipeline) | Not for international students, Not a scholarship → refused (pipeline); Duplicate → closed against a named published scholarship | Downstream (published by `scholarship-auto-publish`) | **Every decision took 1.8–5.8 s and timed out for people (UTS Jumbunna).** The Inbox rebuilt the AI screen after each decision. Fixed by s813 (about 0.2–0.6 s). | Domestic-only and Indigenous-only pages refused by rule before AI (s815) |
| 10 | Campus locality | 69 | Accept largest, Choose locality, No locality → pipeline only | — | Downstream (the campus locality step writes the catalogue) | None in the decision | Primary-campus preview and apply (s812, S1-RM-Design) |
| 11 | No page published: first run | 55 | Approve, Reject → pipeline (the no-page rule for the university) | Has page needs the sample courses ticked | Downstream | None | None |
| 12 | Course pages not found | 54 | Website → `catalogue.providers` | Release → pipeline (took 0.7 s; fixed by s814); CRICOS data only → pipeline | Yes for Website; downstream otherwise | None | None |
| 13 | Website needed | 40 | Website → `catalogue.providers` (needs a full https address) | CRICOS data only → pipeline; Archive → `catalogue.providers`, `search.refresh_requests` | Yes | None | None |
| 14 | Fee fails the check | 10 | Keep → pipeline | Course → opens the course | Downstream | None | None |
| 15 | Boost study load | 7 | Accept full time / part time / both → `catalogue.courses` | Not stated, Dismiss → pipeline | Writes the catalogue; the search document follows at the next course refresh | None | None needed (7) |
| 16 | Conjoint or double degrees: first run | 5 | Approve, Parent, Reject → pipeline | — | Downstream | None | None needed (5) |
| 17 | Central pages to approve | 4 | Opens the builder | — | Not decided in the Inbox | None | None |
| 18 | Provider left the register | 2 | Closed, Reviewed → pipeline; Merged needs the successor named | — | Downstream | None | None needed (2) |
| 19 | Adapter proposal failed | 1 | Retry → onboarding queued (pipeline) | Builder → opens the builder | Downstream | Retry took 0.7 s (onboarding screen rebuild) | None needed (1) |

## Decision times

These were measured live in rolled-back runs, the second call of each pair, so the time is warm.

| Decision | Before s813/s814 | After (dry run, busy database) |
|---|---|---|
| Held scholarship › Not for international students | 2,275–4,505 ms | 154–423 ms |
| Held scholarship › Publish | 1,787–5,769 ms | 262–675 ms |
| Adapter has nothing ready › Rebuild | 2,489–3,642 ms | 692–1,063 ms (the onboarding screen it returns still takes about 0.5 s) |
| Course pages not found › Release | 677–2,603 ms | 173–603 ms |
| Course link › Use (fee check) | 782–1,025 ms | 333–464 ms |
| University or Course description › Approve | 566–1,910 ms | 314–371 ms |
| Entry requirements › Approve | 474–867 ms | 364–522 ms (`aer_review_read_v1` about 150 ms) |
| Every decision: reading its item twice | about 110 ms | about 4 times faster (1,382 → 552 ms for two reads in the same busy run) |

The database was busier during the after-runs, around the hourly scholarship classifier. A quiet morning run measured 154–262 ms for every Held scholarship choice. Live times are measured again after the merge (s819).

## Still above 300 ms, and why

- **Rebuild and Retry.** Both still return the adapter or onboarding screen, about 0.5 s. They are rare and are not timing out.
- **Entry requirements › Approve.** The entry-matrix read takes about 150 ms. This is AER v1 code, which is frozen; it is handled with the AER work (s816–s817).
- **Load.** A run that coincides with the hourly scholarship classifier (:29) is 2 to 4 times slower. The classifier is rewritten in s815.
