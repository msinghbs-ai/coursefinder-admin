# File-Driven Continuous Delivery and Multi-Lane Consolidation Design

**Version:** 1.1 (section 10 added 23 Nov 2026 18:52 AEDT: Standing Authority Charter)
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
- **A stale claim is released by the integration owner.** A `CLAIMED` row with no PR activity for 24 hours is reset to `PENDING` by `S2-Build` and noted in the digest.
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
3. Guardrails: G3 75 and 48, manual locks 7,585, active cron jobs at or under 140, `$0` Firecrawl spend.
4. Approvals needed: the `HELD:BUDGET_GATE` and `HELD:G3_FREEZE` rows only.

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
