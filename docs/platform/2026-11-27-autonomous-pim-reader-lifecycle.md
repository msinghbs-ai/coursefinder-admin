# Autonomous PIM: institute reader lifecycle (academic entry and scholarships)

**Implementation record | 27 November 2026 | v0.1 | S2-Build**
**Authority:** SS-Programme-Control, 27 Nov 2026 11:27 AEDT, "Complete Autonomous PIM — Institute Reader Creation, Qualification and Execution". This completes the existing PIM architecture: PIM acceptance gap Admin #1207 comment 7206040106, Master Plan §6.3 steps 4a, 4b and 6, §6.8, F-OPS.14, F-OPS.16 and F-OPS.19. It is not a new design phase.
**Integration and release owner:** S1-Build. **Coordinate with:** S2-AER (entry-matrix reading and admission), S1-Scholarship-Claude (scholarship processing), S2-RM-Design (DR-19), S1-Build (international source integrity, Admin #1271).

## 1. What existed, read live 27 Nov 2026 (rolled back, read only)

**Academic entry (entry matrices):**
- 452 sources at 259 providers. Of each source's latest read:
  - 313 done, 19 of them by a deterministic reader;
  - 36 failed for time or no reply;
  - 50 held_unparsed at 15 providers. That state is terminal: the page is never read again.
- The readers are generic, tried in order: aligned PDF grid, PDF columns, ruled grid, HTML table, then the routed model (`entry_matrices`: Mistral Small 3.2, not held).
- Matrix machine rule `aer-matrix-machine-v1` is at mode 2 (admit).
- Provider-specific configuration existed only as global settings. A held page stayed held: nothing detected a template change, proposed a configuration, qualified it or resumed processing.

**Held cases:**
- **RMIT, 36 HTML country pages** (`…/country-equivalency/<country>`). The site now prints the generic heading "Country or region equivalency" on every page. The completeness guard therefore holds each page as "not a country table" before any reader runs. In October the same pages named the country in their heading and 29 runs admitted rows.
- **14 PDFs at 14 providers** that no proven-structure reader proves.

**Scholarships:**
- 1,712 active listing pages at 265 providers: 1,520 read complete, 43 partial, 57 failed, 92 waiting.
- 347 listing pages read complete with **0 items**: the existing splitters found nothing on them.

**Other existing mechanisms:**
- Layer 2 source profiles: 2,996 profiles, with versioned configuration and validation status (4,809 valid versions).
- Recovery knowledge (s1292).
- `adapter_autobuilds`: 0 rows, course discovery only.

## 2. The lifecycle (s1303, academic entry; claimed as s1296)

| Step | Where |
|---|---|
| Detect a held template | `security.reader_lifecycle_tick_v1`, run from the existing entry-matrix read (`svc_reader_qualify_next`); classes `country_page_generic_heading`, `pdf_layout_unproven` |
| Reuse an existing reader | An active configuration covering the page goes out with every leased read (`svc_entry_matrix_next` → `security.reader_config_for_v1`). Held pages it covers are read again. A configuration qualified at another provider for the same class is copied into a new proposal. |
| Propose a reusable provider configuration | `security.reader_propose_v1`: a Layer 2 source profile (`reader:academic_entry:<provider>:<template>:<scope>`), created disabled and paused, with a version holding the configuration as data (address country; registered `reading.entry_*` overrides) and positive and negative samples |
| Qualify on stored evidence | The worker reads each sample's stored copy through the same entry-matrix code with deterministic readers only (no model, no fetch, $0); `svc_reader_qualify_record`; `security.reader_qualify_decide_v1` (valid or invalid; a pass switches nothing on) |
| Activate within authority | `security.reader_activate_v1`, a separate audited step. It runs only when the class's knowledge pattern records a standing automatic authority (Standing Authority Charter 23 Nov 2026 item 1, AER v2 proven-structure readers); otherwise `HELD:ACTIVATION_AUTHORITY`. A model-dependent pass also needs the route to still be usable (`HELD:ROUTE_UNAVAILABLE`). |
| Process | The held pages are read again through `admin_entry_matrix_reread` (history kept); then the existing route, completeness guard, matrix machine rule and Layer 4 decide |
| Admit, publish, consumer | Existing admission and publication; consumer read back through the existing DR-19 trace |
| Learn | Patterns `reader_config:aer_matrix:<class>` in `pipeline.ops_remedy_knowledge`. Every hold, qualification and post-activation read is an outcome. The same stored copies are never proposed again after a failure. A configuration whose reads yield nothing is paused and blocked. |
| Recur | The tick runs with every entry-matrix read: no new job, queue, scheduler or dashboard |

**Unsupported structures with no configuration in the existing readers' capability** (the 14 PDF layouts) are held with `HELD:READER_RELEASE_REQUIRED`. The hold is recorded once per stored-copy set, for an AER v2 reader release.

## 3. Scholarships (s1304, reserved; claimed as s1297)

Same lifecycle on the scholarship listing reader:
- **Detection:** listing pages read complete with 0 items, and failed or partial pages.
- **Configuration:** the existing splitters' registered settings (code split, heading split, label sections, tier blocks).
- **Qualification:** on stored listing copies.
- **Admission and publication:** the existing scholarship admission.

## 4. Status

| Item | State |
|---|---|
| s1303 academic entry lifecycle (migration `20261130143000`, worker v1.0.57) | Built; rehearsed again 27 Nov 2026 12:44 AEDT after the renumber (same result); first rehearsal (rolled back) 27 Nov 2026 12:03 AEDT. The RMIT proposal took 8 samples (6 positive, 2 negative); simulated reads gave a model-dependent pass; the activation step switched it on; 35 held pages were re-queued; the address country resolved to India. 13 PDF holds were classified, needing a reader release. Pilot PR pending. |
| s1303 release | Merged, Pilot #1724. Its step did not run until job 337 ran it (s1304 correction). |
| s1304 scholarships (migration `20261130150000`, worker v1.0.58) | Recorded before merge. 0-item listings classed: 196 not a listing, 151 at 83 providers proposed. Configuration = added link hosts. Activation held (`HELD:ACTIVATION_AUTHORITY`). Job 337 now runs the academic entry step. |
| Production, 27 Nov 2026 14:15 AEDT | **RMIT (academic entry):** proposed 13:49 and qualified 13:49 (6 of 6 positive guard passes, no deterministic proof, 2 negatives held); activated 13:54; 35 re-reads through the routed model are in progress (no rows yet: time budget, 1 incomplete). **PDFs:** 7 held for a reader release. **Scholarships:** 123 held as not a listing; 2 proposals failed qualification (no gain) and are held. |
| Acceptance (§8) | Not complete. **Met:** detection, proposal, evidence-backed qualification, activation under authority, explicit holds, and prevention (same copies not proposed again) for academic entry; detection, qualification and holds for scholarships. **Pending:** canonical admission, publication and consumer read-back for RMIT; a scholarship configuration that qualifies; two unattended result-bearing cycles per domain; a reuse case on new pages. |

## Version history

- v0.1, 27 Nov 2026: inventory and s1296 implementation record.
- v0.2, 27 Nov 2026 12:45: renumbered s1303 and s1304 (S2-AER merged s1296 first).
- v0.3, 27 Nov 2026 13:10: s1303 merged; the job-337 correction and s1304 scholarships recorded.
- v0.4, 27 Nov 2026 14:20: s1304 merged (migration 20261130160000, worker v1.0.59); first production results.
