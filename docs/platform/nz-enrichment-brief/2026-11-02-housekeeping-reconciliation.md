# Catalogue and pipeline housekeeping reconciliation (2 Nov 2026)

- **Authority:** Platform Admin direction of 2 Nov 2026 07:21 AEDT, §5 (mandatory housekeeping) and §6 (evidence audit and reporting): `2026-11-02-e16-final-disposition-decision.md`.
- **Operating model:** Decision 260 housekeeping standard (`docs/platform/DATA-PIPELINE-OPERATING-MODEL.md` §6): `pipeline.component_register`, the weekly `hygiene-check` job, `hygiene.retire_after_days` (live value 14), and drop by paste file only. No new clean-up subsystem is proposed.
- **Scope:** read-only SQL on `fxcwkweaxjtknorudmwp`. No writes, deletes, AI or Firecrawl calls, page fetches or commits. **Records changed: 0. Records deleted: 0.**
- **Source snapshot:** database clock 2 Nov 2026 **07:24–07:42 AEDT**. Migration head `20261102010000_cf247_e13_entry_completeness_gate`. This is newer than the Gate B head (`20261101120000`).
- **Control totals at 07:40 AEDT:**
  - active fees 91,901, and active provider fees 11,537. Both are unchanged since Gate B and the E1 record;
  - Layer 4 pending 663;
  - open SS-007 holds 177;
  - manual locks 7,561;
  - search documents 34,042;
  - open search refresh requests 0.
- **E16 cohort:** E16 is referenced here, not redone. The source is `ui-audit/e16-sibling-variant-cohort-2026-11-02.csv`. It was re-measured on the live data only to show its current state.

## 0. Production load disclosure (validation load policy)

- `PRODUCTION-VALIDATION-LOAD-POLICY.md`, from the Platform Admin's 07:41 direction, reached this stream at about 07:42. By then every query in this report had already run.
- Several of those queries scanned whole sets (Storage anti-joins, link and fee cohorts). Two hit the 2-minute statement time-out and were cancelled. Both were read-only.
- **Admission jobs during the window (07:24–07:42):**
  - 0 failures;
  - `adapter-overwrite` at 07:23 took 40.9 s;
  - `coverage-admit-intakes` at 07:28 took 43.1 s;
  - `coverage-admit` at 07:30 took 65.9 s.
- These durations are inside the heavy-run range in the Gate C window (maxima 54.7 s, 95.8 s and 87.9 s), but above the median. This stream's load may have contributed, and that cannot be ruled out.
- The 07:00 and 07:03 time-outs came before this stream's first query (07:24:15).
- **No production query was run after 07:42.** Any re-measurement should be prepared as bounded, keyed queries and run by the integrator (policy rule 4).

## Summary of classifications

| Classification | Findings | IDs |
|---|---:|---|
| Correct automatically under an existing authorisation | 1 | H11 |
| Quarantine and route to Layer 4 | 7 | H02, H05, H12, H13, H19, H20, H23 |
| Retain for audit/history | 7 | H06, H16, H17, H18, H22, H25, H26 |
| Retire under approved housekeeping | 2 | H10, H27 |
| Require a specific Platform Admin decision | 11 | H01, H03, H04, H07, H08, H09, H14, H15, H21, H24, H28 |
| **Total** | **28** | |

**Consumer-visible values that may be wrong (before containment):**
- **E16:** 67 confirmed wrong-programme links are shown, and 31 fees read from sibling pages are active (29 of those amounts are shown). Containment has not yet been applied: 0 of the 77 are held.
- **H13 and H20:** 193 links outside E16 point to a handbook or programme page of 2024 or earlier, and 38 fees were read from those pages. These are candidates. Year is judged from the URL, and no page was read.

**Checked and valid, so not classified:**
- 0 orphaned foreign-key evidence references.
- The search projection matches the catalogue exactly for membership, links and fees.
- SS-007 held-course fees are all explicitly admitted.
- 3,436 course-link locks are fully consistent.

Owners used below:
- **PA:** Platform Admin.
- **INT:** the integrator, who controls production writes.
- **L4:** Layer 4 reviewers.
- **ENG:** engineering stream (binding prevention, E16-1).

---

## A1. Duplicate active official links

**Query:** active `official_course` links grouped by course, having more than 1. Sources come from `pipeline.sources.source_type`. The URL is normalised with scheme, `www`, query string and trailing slash removed.

**Result:** 239 courses and 491 links. This matches Gate B (05:50).

| ID | Cohort | Courses (links) | In E16 | Consumer impact | Classification | Smallest next action (owner) |
|---|---|---:|---:|---|---|---|
| H01 | A reviewer link (`layer4_human_review`) and the old sweep link are both active, and neither is primary | 165 (331) | 0 | **None today.** The website and Zoho show the reviewer link on 164; the other course has no search document. The result depends only on `last_verified_at` ordering. course_url equals the reviewer link on 79. 0 locks. Sorted-id md5 `42a24a57dbb0c5e496102e67a67a23ea` | Require PA decision | Approve E16-3 (generalised E15 Part 1): set the reviewer link primary and the old link inactive, using a count-guarded paste with rollback. This does not change consumer values (PA approves, INT runs) |
| H02 | Different pages, no primary, no reviewer link | 33 (67) | **33** | A sibling or older-year page is shown (E16) | Quarantine and route to Layer 4 | Covered by E16 containment (07:21 §2) (INT) |
| H03 | One primary plus other active links | 23 (57) | 5 | The primary link is shown on 23 of 23. On the 18 courses outside E16, the extra links are inactive-in-effect but still `active` | Require PA decision | Include in the H01 tranche (PA, INT) |
| H04 | The same page spelled differently | 18 (36) | 0 | None | Require PA decision | Include in the H01 tranche (PA, INT) |

## A2. Missing or conflicting primary links

**Valid, not a finding:**
- 21,509 courses have one active link and no primary.
- The projection's link was recomputed for all 34,042 documents (gated source, then `is_primary desc, last_verified_at desc nulls last, updated_at desc, id`). **0 mismatches.**
- 0 shown URLs are not an active link.
- The consumer API functions do not read `catalogue.courses.course_url`. A `course_url` gap is therefore internal only.

| ID | Finding | Count | Consumer impact | Classification | Smallest next action (owner) |
|---|---|---:|---|---|---|
| H05 | One active link, but course_url names a different page | 56 courses, 32 with a provider fee shown. Sorted-id md5 `d8d45e9b2d7c267346007ec5ff187a72`. 0 in E16 | The link is shown. The cohort is mixed: Adelaide University generic-degree pages against major pages (for example, 115678J Bachelor of Aviation shows `…aviation-pilot` while course_url is `…aviation-management`); Whitireia path moves; NMIT `-2` pages; ANU 2017 against 2022 | Quarantine and route to Layer 4 | Route as `official_course_url` items through the existing route. Hold a link only where a person confirms a wrong programme. Pending items for these 56 were not checked before this report, so check them first (INT, L4) |
| H06 | course_url set, but no link row for it and no active official link | 21 | None: the API returns null, which means "not held" | Retain for audit/history | None (keep as the record of the old address) |
| H07 | Link shown, but course_url null | 1,345 | None (internal field) | Require PA decision | Decide whether course_url should follow the projected link. If yes, add it to the H01 tranche (PA) |
| H08 | Active Federation University links from source `31c982b0…` ("Federation University Australia official course pages"), which has **no enrichment source gate row** | 10 | Not shown (URL null). The gate works as designed | Require PA decision | Approve or refuse the `official_course_url` source gate for this source (PA) |

## A3. Superseded pages still active

| ID | Finding | Count | Consumer impact | Classification | Smallest next action (owner) |
|---|---|---:|---|---|---|
| H09 | An older-year handbook link is active beside a newer-year link for the same course | 114 courses (114 links); md5 `ee6b9c7143c22eb483ac1a5dff035ab3`. 107 are in H01, and 7 are in the E16 different-pages group | The older-year link is shown on 6 (1 in H01, 5 in E16) | Require PA decision | Resolved by the H01 tranche and by E16 containment. No separate action (PA) |
| H10 | Components marked `retiring` whose `retire_after` date has passed but which are still present: `search.refresh_course_documents_v2(boolean)`, `public.layer2_provider_asset_fetch_routes()` and `public.zoho_v2_export(text)` (functions); `cron-history-trim` and `cron-history-retention` (paused jobs) | 3 functions, 2 jobs | None expected. `zoho_v2_export(text)` is not on the G3 frozen list, but it is Zoho-facing. Confirm that no edge function or caller uses it before the drop | Retire under approved housekeeping | Prepare the Decision 260 §6.2 rule 4 drop paste file once the hygiene check confirms no use for 14 days (INT prepares, PA runs) |
| H11 | Register drift: (a) `layer2_provider_asset_promotion_context(uuid)` and `layer2_hotcourses_directory_apply` are already absent but are still `retiring` and listed in `ready_to_drop`; (b) `security.semester_intake_apply_v1` and `calendar_default_intakes_apply_v1` are `retiring` with no `retire_after` date | 4 rows | None | Correct automatically under an existing authorisation (Decision 260 §6.1–6.2 register upkeep, `component_register_sync_v1`) | Set (a) to `retired`, and give (b) dates in the next housekeeping migration (INT) |

**Context:** the last `hygiene-check` run (2 Nov 03:23 AEDT, report id 4) found:
- 7 ready to drop;
- 79 unused tables;
- 284 unused indexes;
- 54 tables without row-level security;
- 51 edge functions not called;
- 368 tables without a purpose.

Those are the weekly check's own outputs and are not re-classified here. The register holds 1,153 rows. Retired tables past `retire_after` (15) are already absent.

## A4. Wrong-year or wrong-programme bindings

| ID | Finding | Count | Consumer impact | Classification | Smallest next action (owner) |
|---|---|---:|---|---|---|
| H12 | **E16 cohort (reference):** 77 courses (md5 `1374432181…`, rebuilt exactly). 67 confirmed (md5 `e30cf5d9…`), 9 unclear (md5 `c88d5936…`), 1 false positive (Lennox, `e35721bb…`) | 67 confirmed: link shown 67, held 0, provider fee shown 47. 9 unclear: link shown 9 | **Wrong-programme links are exposed (67).** 0 pending `official_course_url` items exist on the 77, so no item would duplicate (only 6 `course_entry_first_read` items are pending) | Quarantine and route to Layer 4 | E16 containment through the SS-007 hold route, plus new `official_course_url` items for unresolved cases (INT, under 07:21 §2) |
| H13 | **Wrong-year candidates outside E16:** the shown URL carries a handbook or programme year of 2024 or earlier, on automated (sweep) links. MQ 50 (2014–2019), ANU 38, UniMelb 29, La Trobe 22, SCU 14, Sydney 19, UQ 10, CQU 6 and others. Includes 6 non-handbook pages (news posts and PDFs: UOW College 3, ANC 3) | 193 (187 handbook-style, 6 other). 39 show a provider fee. The 217 non-E16 courses including H14 have md5 `944908a930b927c94a5cd83bd1c14d9f` | Students are sent to an archived year's page. Pending link item on 1 (UniMelb) | Quarantine and route to Layer 4 | **The E16 authority names the 77-course cohort only.** Either the PA extends §2 to this cohort, or E16-1's "handbook year or source validity" rule re-evaluates it under §4. Add the year rule to the E16-1 regression fixtures (ENG; PA for authority) |
| H14 | Monash handbook links from 2020–2024 that were **hand-entered and locked** (`manual_entry`, `course_url` value lock) | 24 courses; md5 `676753801b6588d8333914e617493030`. 0 provider fees | Older-year page shown | Require PA decision | PA decides whether these hand-set values stay. Automated rules must not override them |
| H15 | Shown URL carries the year 2025 | 92 shown, 17 with a provider fee | Possibly last year's handbook. Not sampled | Require PA decision | Decide whether the prior-year handbook is acceptable when the current year is not published. This sets the E16-1 year rule (PA) |

**Method:** H13 to H15 are judged from the URL path only, using the regex `/(20[12]\d)(/|$|\?)`. No page was read. These are candidate assessments, not proof.

## A5. Orphaned evidence references

**Valid, not a finding:** every evidence reference is enforced by a foreign key. Checked:
- `catalogue.course_fees` (182,000 refs);
- `course_links` (23,534);
- `layer4_review_items` (24,692);
- `coverage_course_pages` (33,578);
- `evidence_entity_links` to courses (179,892) and to providers (4,787);
- `layer4_review_items` to courses (24,605).

All have **0 orphans**. The 3,027 active links without evidence are hand-entered (`manual_entry`).

| ID | Finding | Count | Consumer impact | Classification | Smallest next action (owner) |
|---|---|---:|---|---|---|
| H16 | Evidence rows whose `storage_path` has no object in the `evidence` bucket: 2 `inline://ranking/qs_wur/…` (2024 and 2025) and 2 `management-plane/CA/ON/…` regulatory snapshots from 14 Aug | 4 | None: 0 active fees or links use them | Retain for audit/history | None |
| H17 | Pending Layer 4 provider items with no evidence id: `no_page_first_run` 55 and `conjoint_rule_first_run` 5, all from 30 Oct | 60 | None | Retain for audit/history | None. These are rule items by design |

## A6. Old source copies without lineage

| ID | Finding | Count | Consumer impact | Classification | Smallest next action (owner) |
|---|---|---:|---|---|---|
| H18 | Objects in the `evidence` bucket with no `evidence_artifacts` row: 18,031 objects, **699 MB** (2.4% of Storage), from 11 Aug to 1 Nov. By prefix: `layer2/*/firecrawl` json 6,166 (2.9 MB), `coverage` html 4,559 (239 MB), `adapters` html 3,955 (283 MB), `scholarships` 2,119 (82 MB), `companion` 611 (16 MB), plus smaller groups | 18,031 | None | Retain for audit/history | **Sampled:** of 300 layer2 objects, the scholarship (34) and companion (11) copies are referenced by their own tables. The firecrawl, coverage and adapter copies had no reference found. The existing `evidence_unreferenced` estimate (stricter rule, 1 Nov 06:56) gives 412 files and 20.8 MB. No deletion. Decide within H28 (PA) |

**Note:** 730 objects named as `deleted` in `evidence_storage_dedupe_log` are present again. They were re-written after deletion with the same content path (content-addressed). This is not a defect.

## A7. Incorrect fees dependent on invalid bindings

| ID | Finding | Count | Consumer impact | Classification | Smallest next action (owner) |
|---|---|---:|---|---|---|
| H19 | **E16 sibling-page fees (reference):** fee ids md5 `fa15331cda52edbb2d4ea0cff1cd6c26`, rebuilt from the CSV | 31 active. 29 amounts are shown as the website tuition; 30 of the evidence URLs equal the shown URL | **Unsupported fees exposed** | Quarantine and route to Layer 4 | E16-5 / §2.4 reversible suppression (E1 pattern, count-guarded, with rollback) (INT) |
| H20 | Provider fees whose evidence `source_url` is a shown wrong-year page (H13): ANU 30, CQU 5, ANC 3. All are recorded as `fee_year` 2026 by the adapter. Amounts range from AUD 9,000 to 50,760 | 38 fees on 38 courses | Possibly an archived year's fee shown as current. Not verified (no page read) | Quarantine and route to Layer 4 | Route to `provider_current_tuition_validation`. Suppress only under an authority covering this cohort (PA for authority; L4) |
| H21 | Active provider fees from sources without an approved gate. They are hidden from `tuition` but appear in `website_v2_course.tuition_history` (Gate B, P2) | 29 | Shown in history only | Require PA decision | Any fix touches the G3 frozen consumer API, so it needs a G3 approval or a recorded acceptance (PA) |

**Valid, not a finding:**
- There are 68 active provider fees read from SS-007 held URLs (65 shown).
- **Every one** sits on a hold whose `admitted_attributes` include `provider_tuition`. That admission was made by Platform Admin decision pack D1 (31 Oct 13:30).
- 0 unsupported.

## A8. Superseded review items

| ID | Finding | Count | Consumer impact | Classification | Smallest next action (owner) |
|---|---|---:|---|---|---|
| H22 | Superseded Layer 4 items 21,891: course_intake 10,931; course_english 6,047; fee validation 4,769; provider_current_tuition 95; entry_matrix_first_run 40; scope 6; course link 3. Returned items 308 (Layer 2 202, Layer 3 106). 285 have a later item for the same field; the other 23 have none and are all on published courses. 40 superseded `entry_matrix_first_run` items have no `decided_at` | 22,199 | None | Retain for audit/history | None. Policy `layer4_decisions` is immutable with no purge (CF-CHG-20260901-051) |

## A9. Stale or duplicate Layer 4 exceptions

**Checks on the pending items:**
- **Pending:** 663. Of these, 499 `course_entry_first_read`, 55 `no_page_first_run`, 40 `entry_matrix_first_run`, 33 `official_course_url`, 29 `provider_current_tuition_validation`, 5 `conjoint_rule_first_run`, 1 `provider_current_tuition` and 1 `course_english`.
- **Duplicates:** 0 pending items repeat the same entity, field and proposed value. Two providers hold 24 `entry_matrix_first_run` items with 24 distinct values, one per entry page. That is by design.
- **Stale:** none on these tests:
  - 0 pending items are on an inactive or unpublished course;
  - 0 `official_course_url` items propose a link that is already active, and 0 have a before-link that is no longer active;
  - 0 fee validation items have their proposed amount already active.
- **Held course:** 1 `provider_current_tuition` item is on an SS-007 held course whose admitted fee differs. It stays pending.
- **Oldest pending:** 25 Oct (7.5 days). None is older than 14 days.

| ID | Finding | Count | Consumer impact | Classification | Smallest next action (owner) |
|---|---|---:|---|---|---|
| H23 | Fee validation items older than 7 days ("Fee reader: course match not sure enough", from 25 Oct). They reach the T5 14-day limit on 8 Nov | 27 | None (held) | Quarantine and route to Layer 4 (already routed; reuse) | Settle them in the next Layer 4 session before 8 Nov (L4) |

## A10. Failed or retried work no longer actionable

| ID | Finding | Count | Consumer impact | Classification | Smallest next action (owner) |
|---|---|---:|---|---|---|
| H24 | `pipeline.layer2_run_batches` `dc4fabeb-532a-4536-9cbd-50d042e09f8c` has been `running` since 29 Sep 15:02 AEDT. Its last heartbeat was 12 Oct 08:55 AEDT, `processed_count` = `target_count` = 61,211, and all 61,211 items are `layer3_required`. A further 34 batches have been `partial` since 26 Aug–28 Sep with processed = target. The table is `active` in the register | 1 + 34 | None | Require PA decision | Approve a governed status close (Gate D/E G5), plus a stale-heartbeat health rule that reads `health.stuck_hours` (live value 4) (PA approves, INT runs) |
| H25 | Coverage course pages exhausted (3 or more attempts) and no longer claimed: fetch_failed 855, blocked 342, robots_disallowed 149, no status 163. 1,374 are published; 20 of their URLs are shown as the official link | 1,509 | 20 shown links to pages the reader could not fetch | Retain for audit/history | None. Re-entry follows the Decision 261 flag unit |

**Context, not housekeeping:**
- `coverage-admit` (07:00) and `adapter-overwrite` (07:03) hit statement time-outs today. Under the load policy they are recorded as "suspected validation-induced interference, pending root-cause verification". They belong to Gate C.
- Enrichment flags:
  - 18,219 hard `raised`, of which 17,278 have no next check (hard reasons are held at once by design, §3.0);
  - 52,299 soft `counting`.

## A11. Manual locks and protected values

| ID | Finding | Count | Consumer impact | Classification | Smallest next action (owner) |
|---|---|---:|---|---|---|
| H26 | 7,561 locks in all. For each lock group, what was checked and what it found: <ul><li>**`course_url` value, 3,016:** course_url equals an active link on 3,016 of 3,016; 0 have more than one active link; 2,773 are shown, and on all 2,773 the shown link equals course_url.</li><li>**`course_url` removed, 420:** 420 of 420 have course_url null and no active link; 0 are shown.</li><li>**`official_url` (value 3,016, removed 420):** these pair with the `course_url` locks.</li><li>**Provider website, 361:** not checked.</li><li>**`lifecycle_status`, 160:** all on inactive courses.</li><li>**Campus city, 65:** not checked.</li><li>**Provider course_finder, 53:** not checked.</li><li>**Provider names, 32:** not checked.</li><li>**English, 14:** not checked.</li><li>**Tuition, 1:** course 082629F, an active hand-entered provider fee of 56,800 with no evidence id.</li><li>**Other provider and scholarship fields, 3:** not checked.</li></ul>213 value locks and 42 removed locks sit on courses that are now inactive. **0 locks on the E16 cohort**; 24 on H14 | 7,561 | Consistent | Retain for audit/history | None. Protected values are preserved, and H14 goes to the PA |

## A12. Search projection discrepancies (catalogue against `search.course_documents`)

**Valid, not a finding:**
- **Membership:** 34,042 documents. That equals the active courses at published, active providers. 0 documents exist for inactive, suspended or unknown courses, or for unpublished providers.
- **Links:** 0 differences from the recomputed projection rule. `has_link` agrees with the URL on all documents.
- **Fees:** 10,501 documents show provider tuition. Of these:
  - 0 have no active fee;
  - 0 show an amount that is not an active fee;
  - 0 gated fees are left unshown.
- **Refresh:** 0 open refresh requests. The last document update was at 07:30 AEDT.

The only differences are the designed gate exclusions H08 (10 links) and H21 (29 fees). There are no new findings.

## A13. Evidence retention and storage lifecycle

**Storage (`storage.objects`, all buckets):** 196,840 objects, **28.66 GB (26.7 GiB)**.

| Bucket | Objects | Size |
|---|---:|---:|
| evidence | 190,145 | 20.77 GB |
| adapter-captures | 4,553 | 7.66 GB |
| provider-assets | 2,023 | 0.11 GB |
| archive | 119 | 0.11 GB |

**Retention rules in force:**
- `pipeline.retention_class_policies` (CF-CHG-20260901-051): `regulatory_evidence` is immutable, with no purge and no default period. Layer 4, publication and material audit records are immutable.
- Evidence row classes:
  - 148,084 have no class;
  - 33,579 are `standard_365`. `retain_until` is set on 14,999 of them, from 24 Aug to 28 Sep 2027;
  - 399 are `legacy`;
  - 45 have other classes;
  - 0 are expired.
- **Capacity policy** (CF-CHG-20260825-036): planning envelope 60 GiB; warn at 60%, high at 75%, critical at 90%. **Use now: 44.5%.**
- **Growth, estimate:** about 0.6–1.0 GB a week of evidence over the last 3 weeks, plus 0.2–0.35 GB a week of captures. At that rate the 60% warning level is reached in roughly 10 weeks (mid-January 2027).
- **Removal of duplicates and replaced copies:** `evidence-storage-dedupe-daily` runs with `batch.evidence_dedupe` = 100 files a day. `evidence-purge-prepare` is catalogued, but its function is absent and it has no `cron.job` row.
- **Backup:** Storage is not in database backups (Gate D/E, G8).

| ID | Finding | Count | Consumer impact | Classification | Smallest next action (owner) |
|---|---|---:|---|---|---|
| H27 | Adapter screenshots older than the `retention.screenshot_keep_days` setting (7 days). The existing retention run (`svc_retention_files_next`, category `adapter_screenshots`) has **never been started**, because `retention_runs` holds no such category. 0 evidence rows point to `adapter-captures` | 4,367 screenshots (7.46 GB) older than 7 days. The estimate (1 Nov 06:42, excluding open builds) is 3,124 files, 5.46 GB | None | Retire under approved housekeeping (live setting plus the existing Storage & retention run) | The PA starts the run from Settings › Storage & retention, after the dry-run estimate. Screenshots are not evidence (PA) |
| H28 | **There is no lifecycle rule for page copies.** Evidence is "immutable, no automated purge"; 148,084 rows have no class; replaced snapshots have no rule (the 18 Oct estimate, now stale, gave 20,704 rows and 6.74 GB purgeable); H18 holds 0.7 GB without lineage; Storage has no backup | — | None today. Capacity and recovery risk | Require PA decision | Decide: (a) keep all page copies, or keep only those cited by an active value plus the last N replaced versions; (b) a class for the 148,084 unclassified rows; (c) the Storage backup position (G8). Implement it only through `retention_class_policies` and the existing retention worker (PA) |

---

## §6 reporting metrics for this assessment

| Metric | Value |
|---|---|
| Records assessed | Official links: 25,045 active, on 24,793 courses. Search documents: 34,042. Active fees: 91,901. Layer 4 items: 24,891. Evidence rows: 182,107. Storage objects: 196,840. Locks: 7,561. SS-007 holds: 177 open. Snapshot 07:24–07:42 AEDT |
| Wrong or unsupported published values (before containment) | E16: 67 links and 31 fees (29 amounts shown). Candidates: 193 links (H13) and 38 fees (H20) |
| Contained records | 0 (this stream is read-only) |
| Routed to Layer 4 | 0 by this stream. Recommended: H05 56 and H13 193 (`official_course_url`); H20 38 (`provider_current_tuition_validation`) |
| Existing pending items reused | H23 27; E16 0; H13 1 (UniMelb) |
| New items created | 0. Proof that new items would not duplicate: 0 pending link or fee items exist on the 77 E16 courses |
| Automatically resolved | 0 |
| Needing new evidence | H13, H15 and H20 rest on the URL year only. Stored copies would be read under the existing E16-1 §4 re-evaluation; no paid reads are proposed |
| Manual locks preserved | 7,561 (3,436 course-link locks verified as consistent) |
| Consumer-visible incorrect values remaining | E16 as above (uncontained). Others are candidates only |
| Records deleted | **0** |
| Regression tests | None run (read-only SQL stream). The H13 and H15 year rule should be added to the E16-1 fixtures |

## Query evidence (all read-only, 07:24–07:42 AEDT)

- **A1 and A3:** `catalogue.course_links` (`link_type='official_course'`, `status='active'`) grouped by course and joined to `pipeline.sources`, with the normalised-URL count. The year is taken with `regexp_match(url,'/(20[12][0-9])(/|$)')`, comparing max against min year within each course.
- **A2:** `search.course_documents` joined to `catalogue.courses` and the active links. The projection was recomputed with `distinct on (course_id)` over links joined to `search.enrichment_source_gates` (`domain_code='official_course_url'`, `approved`), ordered as in `search.refresh_course_enrichment_core_v1`. The ungated sources come from the anti-join against `enrichment_source_gates`.
- **A4:** E16 ids taken from the CSV as a `VALUES` list; md5 of the sorted ids per class; search documents and open `course_remediation_holds`. The year regex was applied to `official_course_url`, with the E16 flag, `manual_entry` source and `manual_locks` added.
- **A5:** left joins from each referencing table to `pipeline.evidence_artifacts`. The foreign-key list comes from `pg_constraint` (`confrelid = evidence_artifacts`). `evidence_artifacts.storage_path` was anti-joined to `storage.objects` (bucket `evidence`).
- **A6:** `storage.objects` (`evidence`) anti-joined to `evidence_artifacts.storage_path`, grouped by prefix. A 300-object sample (`order by md5(name)`) was checked against `course_companion_pages`, `field_enrich_items` and `scholarship_page_candidates`. `evidence_storage_dedupe_log` was joined to `storage.objects`.
- **A7:** `course_fees` (`provider_current_tuition`, active) joined to `evidence_artifacts.source_url`, compared with the shown URL. The E16 fee ids come from the CSV column `fee_ids_from_shown_page`. SS-007 `admitted_attributes` include `provider_tuition`.
- **A8 and A9:** `layer4_review_items` by status and field. Duplicates were found by entity, field and md5 of the proposed value. Staleness tests: course lifecycle, publication, hold, link and fee state.
- **A10:** `layer2_run_batches` and `layer2_run_items` for `dc4fabeb…`; `coverage_course_pages` with `read_attempts>=3` by status; `enrichment_flags` by kind and state; failures in `cron.job_run_details` over 6 hours.
- **A11:** `manual_locks` by entity, field and mode, joined to courses, links and documents.
- **A13:** `storage.objects` by bucket and week; `retention_class_policies`, `retention_runs`, `retention_estimates`, `retention_file_queue` and `evidence_capacity_policy`; the definition of `svc_retention_files_next`; the `retention.*`, `hygiene.*` and `batch.evidence_*` settings in `platform_toolset_settings`; `component_register` (retiring and retired) and the latest `hygiene_reports`.
