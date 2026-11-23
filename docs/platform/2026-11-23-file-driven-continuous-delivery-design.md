# File-Driven Continuous Delivery and Multi-Lane Consolidation Design

**Version:** 1.0
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
| 3. EXECUTE | Work offline against stored artifacts (`storage_artifact_path`). `$0` Firecrawl, `$0` unapproved AI, no new live fetch where a stored artifact exists |
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
| `HELD:NO_SOURCE` | No usable official source or stored artifact | S2-CF finds one |
| `HELD:SITE_BLOCKED` | Site refuses reads (robots, 403 or 429) | Platform Admin decision |
| `HELD:BUDGET_GATE` | Needs paid fetch or AI spend that is not approved | Platform Admin approval |
| `HELD:G3_FREEZE` | Would change a frozen consumer API (G3, 75 functions and 48 relations) | Platform Admin approval |
| `HELD:IDENTITY_UNRESOLVED` | The course identity cannot be matched with confidence | S2-CF |
| `HELD:NON_ACADEMIC_ONLY` | Provider offers only non-academic or non-award courses | Closed unless scope changes |

Only `HELD:BUDGET_GATE` and `HELD:G3_FREEZE` appear in the digest's approval list. The others are worked by lanes.

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
