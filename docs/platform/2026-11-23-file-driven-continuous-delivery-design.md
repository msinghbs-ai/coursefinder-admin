# File-Driven Continuous Delivery and Multi-Lane Consolidation Design

**Version:** 1.1 (section 10 added 23 Nov 2026 18:52 AEDT: Standing Authority Charter) **1.2** (23 Nov 2026 19:40 AEDT, S1-Build): section 11 added (asset acquisition, lane ownership, related jobs and toolset matrix, mirrored from the Drive design section 6 with every lane mapped to its S1 owner); stale-claim release and the blocker queue made part of the 08:00 AEDT run (sections 3 and 7).
**Date:** 23 Nov 2026 (AEDT)
**Owner:** `S1-CD-Orchestrator` (governance only). **Register owner after merge:** `S1-Build`.
**Linked from:** `docs/platform/CONTINUOUS-DELIVERY-MASTER-PLAN.md`, section 3a.
**Scope:** governance markdown, CSV queue and monitoring registers, and CI or document checks in `coursefinder-admin`. No Pilot runtime code, no SQL migrations, no change to any lane's owned files.

## 1. Purpose

The Platform Admin should not have to hand batches to each S2 lane one by one. This design gives every lane one shared work queue, one way to claim work, one way to report it, and one daily digest. Each lane pulls its own next batch from `docs/monitoring/PROVIDER-ENRICHMENT-QUEUE.csv`, delivers it, marks it, and pulls again.

It does not change who owns what. Section 3a of the master plan still decides the single writer per domain, and `S2-Build` stays the integration owner for shared items.

## 2. Batch consolidation sizing

Batches are grouped by identical `source_type` so one reader pattern serves the whole batch. Sizes are a target, not a quota: a lane may shrink a batch to stay inside its context or its guardrails.

| Lane | Domain | Batch size | Approx. courses | Grouping and notes |
|---|---|---|---|---|
| `S2-RM-Design` | Academic entry requirements (AER) | 3 to 5 universities | 300 to 600 active | Same `source_type` |
| `S2-ELR` (or `S1-ELR`) | English requirements | 3 to 5 universities | 300 to 600 active | Parked until an ELR chat is opened (`elr_status = PARKED`) |
| `S2-CF` | Official URLs and descriptions | 3 to 5 large universities (more than 150 missing URLs), or 8 to 12 colleges or providers sharing a CMS or domain pattern | 500 to 800 | Large and small providers are never mixed in one batch |
| `S2-INT` | Exact intakes and deadlines | 5 to 8 universities | Not capped | Grouped by academic calendar structure |
| `S2-Build` | Scholarships | 3 to 5 universities | Not capped | Multi-award listing pages are read in two parts (existing s985 rule) |
| `S2-GEO` | Campus locality and city statistics | 10 to 20 providers | Not capped | Stops at the 90% primary-locality threshold. Read-only until the Platform Admin unlocks writes (section 3a) |

## 3. The six-step loop

`PULL -> CLAIM -> EXECUTE -> SHIP -> ADVANCE -> LOOP`

| Step | What the lane does |
|---|---|
| 1. PULL | Read the queue. Take the next `N` rows in `queue_rank` order where `<lane>_status == PENDING` and `source_type` matches (N from section 2). A row with `active_claim_lane` already set is skipped |
| 2. CLAIM | Open a lightweight Admin PR that changes only the chosen rows: `<lane>_status = CLAIMED:<lane>`, `active_claim_lane = <lane>`, `active_spec_id = <central spec_id>`. The spec number is claimed in the section 3a register first. Merge it on green CI before any work starts, so two lanes cannot take the same row |
| 3. EXECUTE | Stored artifact first (`storage_artifact_path`), then a $0 plain-HTTP direct read where there is no stored copy; paid Firecrawl or pinned AI only within the US$5.00 a day micro-budget for Tier 1 universities and linked courses (section 10.2) |
| 4. SHIP | Merge Admin first, then Pilot, on green CI and a passing live dry run. This is the existing release order and the section 3a release report (five points) still applies |
| 5. ADVANCE | Set each row to `DONE`, or to `HELD:<reason_code>` (section 6). Clear `active_claim_lane` and `active_spec_id`. Update `last_updated_aedt` |
| 6. LOOP | Go straight back to PULL. Stop only when no `PENDING` row remains for the lane, or the lane reaches about 75% of its context capacity, and then park with a one-line session entry |

**Rules that keep the loop safe**

- **One writer per column.** A lane edits only its own status column and the claim fields on its own rows. Columns: `url_desc_status` (S2-CF), `aer_status` (S2-RM-Design), `elr_status` (ELR owner), `intake_status` (S2-INT), `scholarship_status` (S2-Build), `geo_status` (S2-GEO). `aer_source_url`, `storage_artifact_path` and `source_type` are written by S2-CF (section 4), apart from the first seeding.
- **Claims are PRs, not edits to main.** Rebase onto the latest `origin/main` before merge. If a row changed under you, take the other lane's row as it is and pick the next one.
- **A stale claim is released at 08:00 AEDT.** A `CLAIMED` cell whose row has not been updated for 24 hours is reset to `PENDING` by `S1-Build`'s daily run (`docs/monitoring/aer-reader-status-refresh/daily_digest.py`), with a dated note on the row and a line in the digest. From 23 Nov 2026 the S2 lanes are consolidated under S1 (section 11).
- **Section 3a still wins.** The queue never lets a lane touch another lane's tables, functions or jobs.

## 4. Cross-lane artifact reuse

`S2-CF` is the lane that verifies where each provider's pages live. When it confirms a source it writes two values into the queue:

- `aer_source_url`: the verified source URL.
- `storage_artifact_path`: the Supabase Storage path of the captured artifact.

`S2-RM-Design`, `S1-ELR`, `S2-INT` and `S2-Build` read those two values and reuse the captured artifact. No lane fetches the same page a second time. If a lane finds the stored artifact is wrong or stale, it sets its own row to `HELD:NO_SOURCE` and raises it with `S2-CF`. It does not overwrite the path.

## 5. Queue file

`docs/monitoring/PROVIDER-ENRICHMENT-QUEUE.csv` is generated from `docs/monitoring/AER_University_Reader_Status.csv` (snapshot 23 Nov 2026 16:49 AEDT): 1,886 providers, 36,046 active courses.

**Ordering**

| Tier | Providers | Rule |
|---|---|---|
| 1 | 64 (AU 53, NZ 11) | `provider_type` university, university college or wānanga. Ordered by `active_courses` DESC |
| 2 | 50 | Other providers with `active_courses` of 50 or more. Ordered by `active_courses` DESC |
| 3 | 1,772 | Remaining providers (fewer than 50 active courses). Ordered by `active_courses` DESC |

Ties are broken by provider name, then provider ID, so the file is reproducible.

**Columns:** `queue_rank, tier, provider_id, provider_name, country_code, provider_type, active_courses, source_type, aer_source_url, storage_artifact_path, url_desc_status, aer_status, elr_status, intake_status, scholarship_status, geo_status, active_claim_lane, active_spec_id, last_updated_aedt, notes`.

**Initial seeding**

- `aer_status = DONE` where the register already shows `Fully Working` (a read source, at least 80% admitted, no pending Layer 4 item). That is 10 providers, one of them a university (Notre Dame Australia). Everything else is `PENDING` (1,876 rows, 63 of them universities).
- `url_desc_status`, `intake_status`, `scholarship_status`, `geo_status`: `PENDING` for every row.
- `elr_status`: `PARKED` for every row until an ELR chat is opened.
- `source_type`, `aer_source_url` and `storage_artifact_path` are copied as they stand in the register. `source_type` is `Unknown` for most providers today, so S2-CF's first job is to improve it.

**Status values:** `PENDING`, `CLAIMED:<lane>`, `DONE`, `HELD:<reason_code>`, `PARKED`.

**Refresh:** the status columns are owned by the lanes. The reader-status columns of the AER register stay in `AER_University_Reader_Status.csv` and are not copied again.

## 6. Reason codes for `HELD`

| Code | Meaning | Who clears it |
|---|---|---|
| `HELD:NO_SOURCE` | No usable official source or stored artifact | `S1-Build` (S2-CF finds one) |
| `HELD:SITE_BLOCKED` | Site refuses reads (robots, 403 or 429) | Platform Admin decision |
| `HELD:BUDGET_GATE` | Would take platform spend above US$5.00 a day, or needs paid crawling of a Tier 2 or Tier 3 provider (section 10.2) | Platform Admin approval |
| `HELD:G3_FREEZE` | Would change a frozen consumer API (G3, 75 functions and 48 relations) | Platform Admin approval |
| `HELD:IDENTITY_UNRESOLVED` | The course identity cannot be matched with confidence | `S1-Build` (S2-CF for duplicate catalogue courses) |
| `HELD:NON_ACADEMIC_ONLY` | Provider offers only non-academic or non-award courses | Closed unless scope changes |
| `HELD:PARSER_EDGE_CASE` | The source is stored and readable, but the AER v2 proven-structure reader fails closed on a layout it does not yet handle | `S1-RM-Design` (Opus escalation): fix the reader; the blocker entry carries the snippet, the file and function, and the error |
| `HELD:WAF_OR_JS_BLOCK` | The platform's $0 plain-HTTP read is refused (WAF, 403) or the page needs JavaScript; paid Firecrawl is not available (`firecrawl.daily_budget_total` is 0) or would exceed US$5.00 a day | `S1-Build`: Settings budget unlock or another route; the blocker entry carries the URL, the HTTP status and headers, and a credit estimate |

Only `HELD:BUDGET_GATE` and `HELD:G3_FREEZE` appear in the digest's approval list. Every other `HELD` row gets a structured entry in the digest's *Technical Blockers & Ready-to-Solve S1 Queue* (provider, spec, code, solver lane, source URL or storage path, exact error, proposed fix), and is worked by the solver lane named above (Platform Admin, 23 Nov 2026 19:13).

## 7. Daily Executive Status Digest

`docs/monitoring/DAILY-EXECUTIVE-STATUS.md` is the only daily report the Platform Admin needs to read. `S1-Build` updates it at 08:00 AEDT each day. It shows:

1. Per-lane queue burndown: `DONE`, `CLAIMED`, `PENDING` and `HELD` counts, with 24-hour velocity.
2. Live coverage: AER, ELR, URLs, descriptions, exact intakes, scholarships and geo, as courses and percentage points.
3. Guardrails: G3 75 and 48, manual locks 7,585, active cron jobs at or under 140, and paid spend against the US$5.00 a day cap (section 10.2), with the lanes' spend log.
4. Approvals needed: the `HELD:BUDGET_GATE` and `HELD:G3_FREEZE` rows only.
4a. Technical Blockers & Ready-to-Solve S1 Queue: every `HELD:*` cell, written in full to `docs/monitoring/S1-BLOCKER-QUEUE.csv` (`provider_id`, `aer_source_url`, `storage_artifact_path`, the exact reason and the target solver from section 6), counted by solver and code in the digest, with the Tier 1 and Tier 2 lines listed. Solver entries a lane writes (spec, exact error, proposed fix) are kept as written while the provider is still held.
5. Notes: stale claims released, entries dropped, and any guardrail not met.

The digest is regenerated by `docs/monitoring/aer-reader-status-refresh/daily_digest.py` in the same 08:00 AEDT run and pull request as the AER register. It reads the queue, the register and a rolled-back live read of coverage and guardrails (`sliceC.sql.tmpl`), and keeps every spend-log line the lanes write.

## 8. Checks (CI and document)

To be added with the queue, in the existing admin doc checks:

- Header matches the 20 columns above, in order.
- Row count equals the distinct `provider_id` count; no duplicates.
- Status values come from the allowed list; `HELD` codes come from section 6.
- A row with `CLAIMED:<lane>` has `active_claim_lane` and `active_spec_id` set and matching, and the spec exists in the section 3a register.
- `elr_status` stays `PARKED` until the ELR owner is named in section 3a.

## 9. Decisions and open points for the Platform Admin

| Item | Position taken here | Why it matters |
|---|---|---|
| Shared CSV against single-writer rule | One writer per column, claims by PR | Keeps section 3a intact while lanes share one file |
| Fully Working seeding | Uses the register's `reader_status`, not the percentage alone | 141 providers are at 80% or more, but only 10 also have a read source and no open Layer 4 item |
| ELR owner name | Section 3a says S1-ELR or a future S2-ELR | Row stays `PARKED` until named |
| `source_type` mostly `Unknown` (1,713 of 1,886) | S2-CF improves it as it verifies sources | Batches grouped by `source_type` will be weak until then |

## 10. Standing Authority Charter: gate upgrades (Platform Admin, 23 Nov 2026 18:52 AEDT)

These rules are permanent. They are also in both repositories' `CLAUDE.md`, and they mean a lane runs its loop end to end without per-batch or micro-spend sign-off.

### 10.1 AER v2 readers are pre-authorised

AER v1 stays frozen (Decision 276). Two things are permanently pre-authorised:

- AER v2 proven-structure sources: `PDF_TABLE` cell-grid matchers, `HTML_TABLE` and `HTML_ACCORDION`.
- Deterministic degree-abbreviation expansions: `B` → Bachelor, `M` → Master, `Hons` → Honours, `GradDip` → Graduate Diploma.

A course matched through an expanded title goes to Layer 4 for a person and is never admitted by the machine. The existing v2 safeguards still apply (design §9.4: one catalogue course per course minimum, the printed course in the row identity, fail closed).

### 10.2 Two-tier fetch and the US$5.00 a day micro-budget

| Tier | What | Authority |
|---|---|---|
| Fetch tier 1 | Stored artifact first, then a $0 plain-HTTP direct read of a page with no stored copy. This retires the 3 Nov 2026 stored-first block for $0 HTTP reads. robots.txt and site policies apply; a challenge page is never bypassed | Always authorised |
| Fetch tier 2 | Paid Firecrawl fetches or pinned AI description cascades for Tier 1 universities and courses already linked to an official page | Authorised up to US$5.00 a day across the whole platform, logged in the digest |
| Above the cap, or paid crawling of Tier 2 or Tier 3 providers | | `HELD:BUDGET_GATE` |

The cap is a G2 setting, changed on Settings with a reason. Until the platform enforces it, a lane reads the day's logged spend before each paid call.

### 10.3 Downstream work is enqueued automatically

When `S2-CF` admits an official course URL or saves a snapshot to `aer-artifacts/<provider>/`, the Descriptions, AER, Intakes and Scholarships items for that course are enqueued in the same change, so no course sits unqueued.

### 10.4 Intake Rule B is global, with international calendar inheritance

- Rule B (the stated month equals the calendar start month) is permanent for every provider. A day is never inferred from a month.
- A university's official International Academic Calendar dates apply to its international courses, even when a course page does not say "international".

### 10.5 Escalation is by exception only

A lane never pauses mid-loop for a batch approval. It halts and records `HELD:<reason>` in the 08:00 digest only when a change would:

- (a) touch the frozen G3 v2 surface (75 / 48);
- (b) touch the 7,585 manual locks;
- (c) take active cron jobs above 140;
- (d) take spend above US$5.00 a day;
- (e) delete or withdraw live admitted records in bulk without replacements.

Every other rule still applies: single-writer domains, Layer 4 human decisions, no drop or delete by an applied migration, and live dry runs.

### 10.6 What this charter changes in the live system (follow-up, by the owning lane)

The charter is the authority; each lane applies its own part in its next change.

| Item | Live today (read 23 Nov 2026 18:55 AEDT) | Owner |
|---|---|---|
| US$5.00 a day cap as a setting | Firecrawl `daily_budget_total` is 0 with `daily_budget_on` true (S3 containment), so paid Firecrawl stays off until the setting is changed with a reason | Platform Admin or S3 (setting change), then the platform enforces it |
| $0 direct read of copy-less pages | Scholarship and AER lanes run stored-first and skip copy-less pages | Each lane in its next change |
| Auto-enqueue on URL or snapshot | Not built | S2-CF, with S2-Build as integration owner |
| Rule B for every provider | Listed per provider in `intake_dates.nearest_start_providers` (s988) | S2-INT |
| International calendar inheritance | Not built | S2-INT |

## 11. Asset acquisition, lane ownership, related jobs and toolset matrix (Drive design section 6; S1 consolidation)

Mirrored from section 6 of the Google Drive design (`File-Driven Continuous Delivery & Multi-Lane Consolidation Design (S1)`, read 23 Nov 2026 19:20 AEDT). From the Platform Admin's message of 23 Nov 2026 18:55, all execution is consolidated under S1 agents (`S1-RM-Design`, `S1-Build`, `S1-API-Frontend-Delivery`, `S1-CD-Orchestrator`, `S1-ELR`). Each S2 lane named in the Drive text is mapped to its S1 owner below; section 6 routes each `HELD` code to its solver.

**Lane mapping**

| S2 lane in the Drive text | S1 owner from 23 Nov 2026 | Why |
|---|---|---|
| `S2-CF` (official URLs, descriptions, upstream AER capture) | `S1-Build` | Missing URLs, identity, blocked sites and upstream snapshots |
| `S2-RM-Design` (AER v2 readers, Layer 4 routing) | `S1-RM-Design` | Reader, parser and table work |
| `S2-INT` (exact intakes and deadlines) | `S1-RM-Design` | Calendar and intake readers (Rule B) are reader work |
| `S2-Build` (scholarships, partner contacts, saved courses, shared schema) | `S1-Build` | Shared backend and integration owner |
| `S2-GEO` (campus locality, destination city statistics) | `S1-Build` | Read-only until the Platform Admin unlocks writes (unchanged) |
| `S2-ELR` / `S1-ELR` (English requirements) | `S1-ELR` | `PARKED` until the lane opens (unchanged) |

### 11.1 Asset and link acquisition (who gets what, and where it lives)

| Asset or source | Discovery owner | Capture and storage | Queue or registry target | Downstream consumers |
|---|---|---|---|---|
| Individual official course pages | `S1-Build` (`url_desc_status`) | $0 plain-HTTP direct read, then Supabase Storage `aer-artifacts/<provider>/` | `catalogue.courses`; queue `storage_artifact_path`, `url_desc_status` | `S1-RM-Design` (AER, intakes), `S1-ELR`, `S1-Build` (scholarships) |
| University-wide international entry matrix pages and PDFs on the provider's domain | `S1-Build` (upstream domain pass) and `S1-RM-Design` | $0 plain-HTTP download to `aer-artifacts/<provider>/entry-matrix.<ext>` | Queue `aer_source_url`, `source_type`, `storage_artifact_path`; `pipeline.entry_matrix_sources` | `S1-RM-Design` (AER v2 readers) |
| Provider academic calendars and intake schedules | `S1-RM-Design` (`intake_status`) | Stored snapshots first, then a $0 plain-HTTP read (section 10.2) | `catalogue.course_intakes`; queue `intake_status` | Website v3, Zoho v3, Counsellor UI |
| Provider scholarship listing and multi-award pages | `S1-Build` (`scholarship_status`) | Stored snapshots or a $0 direct read; paid reads only within section 10.2 | `scholarship.scholarships`; queue `scholarship_status` | `public.counsellor_scholarships_list`, Website v3, Zoho v3 |
| Campus postcodes, localities and city profiles | `S1-Build` (`geo_status`) | Read-only discovery against the CRICOS and NZQA registers and stored evidence (writes locked until the Platform Admin unlocks them) | `catalogue.campuses`, `destination.city_profiles`; queue `geo_status` | Website v3, Zoho v3, Counsellor UI (REQ-117) |
| Study Square partner contacts; each user's saved courses | `S1-Build` | Admin entry or the Zoho CRM partner export handed over by a person, never scraped; saved courses are each user's own | `pipeline.partner_contacts`, `pipeline.saved_courses` (s997) | Counsellor UI (`S1-API-Frontend-Delivery`) |

### 11.2 Lane, job and toolset matrix

| Owner | Queue column or scope | Related jobs, specs and functions | Approved toolset | Cost and governance |
|---|---|---|---|---|
| `S1-Build` (URLs and descriptions) | `url_desc_status` | Identity matcher, soft-404 guard, s662 and s664 description readers (s670 untouched), s991 wrong-URL quarantine | Plain HTTP, Supabase Storage `aer-artifacts/`, the pinned description cascade, rolled-back dry runs | $0 plain HTTP always; paid reads within US$5.00 a day (section 10.2); 3,436 URL locks untouched |
| `S1-RM-Design` (AER) | `aer_status` | AER v2 readers (s1000, s1009 v1.4, s993, s996), `pipeline.entry_matrix_sources`, Layer 4 inbox | Deterministic v2 readers (`PDF_TABLE` cell grid, `HTML_TABLE`, `HTML_ACCORDION`), strict-proof validator, abbreviation expansions routed to Layer 4 (section 10.1) | AER v1 frozen (Decision 276); 7,585 manual locks untouched |
| `S1-RM-Design` (intakes) | `intake_status` | Calendar and intake readers (s986 to s988, s994, s995), Rule B same-month validator | Calendar readers on stored snapshots, $0 plain HTTP, rolled-back dry runs | No day inferred from a month; unstated audience held |
| `S1-ELR` | `elr_status` | Central English rules and provider English readers | Deterministic English reader on stored artifacts | `PARKED` on all rows until the lane opens |
| `S1-Build` (scholarships and shared backend) | `scholarship_status`, shared schema | Scholarship fire job and picker (s989), two-part listing reader and direct reads (s992), s997 (budget cap on the Boost read, saved courses, partner contacts), `TEST-REGISTER.md` generator | Stored-first and $0 direct reads, two-part reader; paid reads within section 10.2 | Migrations follow the s980 pre-flight and live dry run |
| `S1-Build` (geo) | `geo_status` | Campus locality and NZ and CA link evidence audit, `destination.city_profiles` discovery | Read-only SQL and rolled-back yield models, 90% primary-locality threshold | Read-only until the Platform Admin unlocks writes |
| `S1-API-Frontend-Delivery` | Pilot UI and additive v3 reads | s990 (Pilot #1498), `public.counsellor_scholarships_list`, `public.admin_integrations_status`, the v1.1 Counsellor shell | React and Vite, `tokens.css`, `ui-kit.css`, Playwright at 1440 x 900 and 375 x 812, stylesheet lint | G3 v2 (75 / 48) frozen (`s57`); Counsellor navigation locked to 4 items (IR-021) |
| `S1-Build` (register and digest) | Daily digest and register sync | 08:00 AEDT scheduled refresh: `AER_University_Reader_Status.csv`, the Google Sheet mirror, `DAILY-EXECUTIVE-STATUS.md`, `S1-BLOCKER-QUEUE.csv`, stale-claim release | Rolled-back live reads through the shared dry-run workflow (only when its queue is clear), Google Sheets and Drive | Read-only on the database; escalates `HELD:BUDGET_GATE` and `HELD:G3_FREEZE` only |

### 11.3 Cross-lane handoff for AER links and PDFs

1. **Upstream capture by `S1-Build`.** On every `url_desc_status` domain pass, `S1-Build` captures any official provider-wide international academic entry page or PDF it finds on the provider's domain ($0 plain HTTP), saves it to `aer-artifacts/<provider>/entry-matrix.<ext>`, and fills `aer_source_url`, `source_type` and `storage_artifact_path` in the queue without changing `aer_status`. The downstream items are enqueued in the same change (section 10.3).
2. **Downstream use by `S1-RM-Design`.** `S1-RM-Design` takes `PENDING` Tier 1 universities whose `aer_source_url` and `storage_artifact_path` are already filled first. It runs the AER v2 readers on the stored copy at $0 and routes ambiguous rows to Layer 4 for a person, never to machine admission.

## 10. Asset acquisition, lane ownership, related jobs and toolset matrix (mirror of Drive blueprint Section 6)

Mirrored from the Drive document "File-Driven Continuous Delivery & Multi-Lane Consolidation Design (S1)", Section 6, on 23 Nov 2026 (Platform Admin 18:48). It is numbered 10 here so the references to sections 6 to 9 of this file stay valid. Where the two differ, this repository is the source of truth (Platform Admin, 16 Nov 2026).

### 10.1 Asset and link acquisition ownership (who gets what and where it lives)

| Asset / source type | Responsible discovery lane | Capture and storage path | Queue / registry target | Downstream consumer lanes |
|---|---|---|---|---|
| Individual official course pages | S2-CF (`url_desc_status`) | Plain HTTP direct fetch ($0) to Supabase Storage (`aer-artifacts/<provider>/`) | `catalogue.courses` + `PROVIDER-ENRICHMENT-QUEUE.csv` (`storage_artifact_path`, `url_desc_status`) | S2-RM-Design, S2-ELR, S2-INT, S2-Build |
| University-wide international entry matrix pages and PDFs (discovered on provider domains) | S2-CF (upstream domain pass) and S2-RM-Design | Plain HTTP direct download ($0) to Supabase Storage (`aer-artifacts/<provider>/entry-matrix.<ext>`) | `PROVIDER-ENRICHMENT-QUEUE.csv` (`aer_source_url`, `source_type`, `storage_artifact_path`) + `pipeline.entry_matrix_sources` | S2-RM-Design (AER v2 readers) |
| Provider academic calendars and intake schedules | S2-INT (`intake_status`) | Reuses stored snapshots in `aer-artifacts/<provider>/` ($0; stale unstored 2026 calendars held as `HELD:BUDGET_GATE`) | `catalogue.intakes` + `PROVIDER-ENRICHMENT-QUEUE.csv` (`intake_status`) | Website v3, Zoho v3, Counsellor UI |
| Provider scholarship listing pages and multi-award pages | S2-Build (`scholarship_status`) | Stored snapshots or plain HTTP direct read ($0; scoped Firecrawl window only when explicitly approved by the Platform Admin) | `catalogue.scholarships` + `PROVIDER-ENRICHMENT-QUEUE.csv` (`scholarship_status`) | `public.counsellor_scholarships_list`, Website v3, Zoho v3 |
| Campus postcodes, localities and city profiles | S2-GEO (`geo_status`) | Read-only discovery against L1 CRICOS/NZQA + stored evidence (writes locked until Platform Admin unlock) | `catalogue.campuses` and `destination.city_profiles` + `PROVIDER-ENRICHMENT-QUEUE.csv` (`geo_status`) | Website v3, Zoho v3, Counsellor UI (REQ-117) |

### 10.2 End-to-end lane, job and toolset architecture matrix

| Lane / owner | Queue column / scope | Related jobs, specs and edge functions | Approved toolset and parsers | Cost and governance guardrails |
|---|---|---|---|---|
| S2-CF | `url_desc_status` | Identity matcher, soft-404 guard, s662/s664 description readers (do not touch s670), s991 wrong-URL quarantine | Plain HTTP fetch, Supabase Storage (`aer-artifacts/`), Qwen3/pinned description cascade, Postgres rolled-back dry-run | $0 Firecrawl; US$0.50 hard cap approved for 659 unqueued description reads; 3,436 URL manual locks immutable |
| S2-RM-Design | `aer_status` | AER v2 readers (s1000, s1009 v1.4, s993), `pipeline.entry_matrix_sources`, Layer 4 resolver and `admin_layer4_inbox` | AER v2 deterministic parsers (PDF_TABLE cell-grid matcher, HTML_TABLE, HTML_ACCORDION), strict-proof validator, 0.8 confidence + 5% audit sample | AER v1 frozen (Decision 276); $0 external spend; single-subject marks and "up to" misreads blocked; 7,585 manual locks immutable |
| S1-ELR / S2-ELR | `elr_status` | Central English rules and provider English readers (currently PARKED until the lane opens) | Deterministic ELR parser + stored artifacts in `aer-artifacts/` | `elr_status = PARKED` across all 1,886 rows until the Platform Admin names the owner; $0 spend |
| S2-INT | `intake_status` | Calendar and intake readers (s986 to s988), Rule B same-month validator | Offline calendar parser on stored snapshots, Postgres rolled-back dry-run | Strict same-month rule (no month-to-day invention); unstated audience held; $0 spend |
| S2-Build | `scholarship_status` + shared ops | Scholarship fire job and queue picker (s989), two-part multi-award listing reader, TEST-REGISTER.md generator | Stored-first and plain HTTP direct reader, two-part split reader, Firecrawl (only under explicit Platform Admin approval) | $0 scheduled Firecrawl; scoped one-off Firecrawl window only for Charles Darwin and Lincoln after a credit quote |
| S2-GEO | `geo_status` | Campus locality and NZ/CA link evidence audit, `destination.city_profiles` discovery | Read-only SQL and rolled-back dry-run yield model, 90% primary-locality threshold rule | Strictly read-only until the Platform Admin unlocks writes; never infer links from single-campus providers |
| S1-API-Frontend-Delivery | Pilot UI and additive v3 RPCs | Pilot #1498 (s990), `public.counsellor_scholarships_list`, `public.admin_integrations_status`, ui-v1 Counsellor shell | React/Vite, `tokens.css`, `ui-kit.css`, Playwright CI (1440x900 and 375x812), stylesheet lint CI | G3 v2 (75/48) strictly frozen (s57); 4-item Counsellor nav lock (IR-021); legacy CSS deletion staged in a separate PR |
| S1-Build | Daily digest and register sync | Daily 08:00 AEDT cron sync, `AER_University_Reader_Status.csv` and Google Sheet mirror, `DAILY-EXECUTIVE-STATUS.md` | Scheduled GitHub/Supabase sync job, Google Sheets API | Read/sync reconciliation only; escalates `HELD:BUDGET_GATE` and `HELD:G3_FREEZE` exceptions to the Platform Admin |

### 10.3 Cross-lane artifact handoff rules (AER links and PDFs)

1. **Upstream capture by S2-CF:** during every `url_desc_status` domain pass, S2-CF captures any official provider-wide International Academic Entry Requirements page or PDF found on the provider's domain ($0 plain HTTP), saves it to Supabase Storage (`aer-artifacts/<provider>/entry-matrix.<ext>`), and populates `aer_source_url`, `source_type` and `storage_artifact_path` in `PROVIDER-ENRICHMENT-QUEUE.csv` without modifying `aer_status`.
2. **Downstream consumption by S2-RM-Design:** S2-RM-Design prioritises PENDING Tier 1 universities where `aer_source_url` and `storage_artifact_path` are already populated, running AER v2 PDF_TABLE or HTML_TABLE parsers offline at $0 spend and routing ambiguous rows to Layer 4 human review rather than machine auto-admission.
