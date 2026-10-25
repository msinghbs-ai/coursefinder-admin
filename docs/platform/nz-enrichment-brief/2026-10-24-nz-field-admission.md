# NZ field admission — baseline, what was fired, item 5 build, entry-requirements proposal, gate map

**Date:** 24 Oct 2026, 00:35–01:40 AEDT
**Mandate:** Platform Admin, 24 Oct 2026 00:35 (consolidated NZ field admission; quoted in section 9).
**Audit trail:** [2026-10-23-platform-throughput-gap-schema.md](2026-10-23-platform-throughput-gap-schema.md) section 10 (append-only).
**Built in this mandate:** item 5 only (section 4). Everything else is read-only, fired through existing lanes, or plan-only.

Every figure was read from the live project (`fxcwkweaxjtknorudmwp`) between 00:35 and 01:30 AEDT on 24 Oct 2026. NZ = 6,474 active courses at 287 providers.

---

## 1. Pre-R1 verification (fee_ai identity-basis check)

Done at 00:45, recorded in the audit trail. **Not both paths enforce.** The policy (`security.coverage_identity_allowed(provider, basis, 'tuition')`, per-country lists in `coverage_admission_countries.identities`) is checked by the fee_ai path **at enqueue only** and by `coverage_apply_course_v1` **never** (it trusts its callers; four callers check, `svc_fee_ai_record` and `provider_credit_fee_apply_v1` do not). Live at 00:45: 0 fee-reader queue rows for the 149 quarantined courses, so nothing was in flight. **R1 is extended** with the check at the fee write inside `coverage_apply_course_v1` (a fee from a page whose label the country's tuition list does not allow is written `unverified` with a Layer 4 row, `source = identity_basis_reverify`; manual bindings and admin writes exempt). Open for the Platform Admin: the CA tuition list itself contains `cricos_code`.

---

## 2. Per-field NZ baseline (read-only)

| Field | Populated | % of 6,474 | Bound > 12 h and empty | Blocking lane (what actually holds the rest) |
|---|---|---|---|---|
| International fee | 1,149 | 17.7% | 2,234 | fee reader: 832 more requests fired tonight (section 3); the remainder are pages whose proof the tuition policy refuses (the 321 + the 285 cricos-labelled, gated on 8a) or pages with no fee printed (provider fee schedule, AI fee reader on `fee_schedule` sources: 13 NZ providers failed, 11 no values, 1 found) |
| English requirement | 2,345 | 36.2% | 1,423 | **the course page does not state it**: of 1,160 bound gaps, 1,108 are `page does not state it` after the AI reader tried the current copy; the lane is the central English-policy page (13 NZ providers approved, 4 proposed awaiting a person, 27 no values, 9 failed) and the provider English defaults job |
| Intakes | 2,117 | 32.7% | 1,255 | same: 787 of 945 bound gaps are page-silent, 19 refused for proof; the lane is the intake calendar (4 approved, 2 proposed, 13 no values) and the calendar-defaults job (`provider-calendar-intakes` is **switched off**) |
| Duration | 2,328 | 36.0% | 1,055 | page-silent: 721 of 747 bound gaps; no provider-level lane exists for duration |
| Campus | 2,315 | 35.8% | 1,295 | **164 in Layer 4 review** ("the campus named on the page is not in the admitted list") plus providers with no admitted campus list (`provider_fill`); 6 never tried |
| Delivery | 2,552 | 39.4% | 836 | page-silent: 425 of 534 bound gaps |
| course_url (official link) | 899 | 13.9% | 2,515 | **item 5** (section 4): 1,874 fill tonight; 285 wait for 8a (cricos-labelled NZ pages); the rest are unbound (R2) |
| Open to international | 1,551 (1,424 yes) | 24.0% | 1,869 | page-silent 401; the rest skipped for "only a site-wide line mentions international" (a rule the reader applies on purpose); the NZ Code of Practice signatory list (item 3, O5) is the provider-level source |

**Are the enrich/AI lanes consuming the sweep's pages? Yes, with numbers.** The standing task "Fill the gaps · all countries" ran at 23:23 AEDT (5,063 items, finished) on the pages the sweep re-read. NZ since the sweep (22:31): 2,746 enrich items created; filled: campus 67, delivery 82, duration 58, English 37, field of study 54, international 24, level 14, intakes 2; skipped: English 708, international 471, intakes 397, campus 333, duration 226, delivery 172. On the catalogue: NZ fees +52, English +46 verified, 154 durations set, 383 courses with intakes touched by a re-read. Every NZ bound page with a gap has been tried on its current copy (0–6 never tried per field), so **the lanes are not the constraint for these fields; the pages are**. Central AI: the 99 "stuck" queue rows are all AU providers that are unpublished, which the picker skips by design (Q4 will say so in its "why idle" line instead of showing a stuck count).

---

## 3. What was fired today (existing lanes only)

| Lane | What | Count | Record |
|---|---|---|---|
| Fee reader (`fee_course_requests` → `fee_course_pages_enqueue_v1`) | NZ bound pages with a tuition-allowed proof, a stored copy, no international fee, no request in 2 days, no pending Layer 4 fee item; requests dated just before the page read so they queue at once | **832 requests, 69 providers → 832 queued to the fee reader** at the next tick (queue 1,147 at 00:40) | `docs/platform/wrong-page-values/PASTE-20261024-nz-field-admission-fire.sql` |
| Central policy (`central_ai_enqueue_v1`) | every NZ provider with a read English-policy or calendar page and no open proposal | **10 enqueued** (1 English policy, 9 intake calendars) | same file |
| Page re-reads | nothing new: the 22:31 sweep already reset every NZ bound page with no fee and no English; NZ pages with a fee or English were re-read in October and their stored copies were tried | 0 | — |
| Enrich fields (AI) | nothing new: the standing hourly task already covers NZ "most missing first" and has tried every current copy; a targeted NZ task would re-ask silent pages at cost | 0 | — |
| Item 5 fill (new job, section 4) | first run after apply | **1,874 NZ courses get their official link** | migration + control event |

Order by well-covered providers: the fee requests cover 69 providers; the fee reader takes them by `course_priority`, and the 15 NZ providers with ≥ 80% of courses bound (1,029 courses) were already first in the sweep. There is no "42 well-covered" set in the data; the closest cuts are 15 providers at ≥ 80% bound and 58 at ≥ 50% (≥ 5 courses each).

**Expected admissions, NZ:**

| Field | Next 24 h | Next 7 days | Basis |
|---|---|---|---|
| International fee | 150–250 | 300–450 of the 832 (the sweep's 2,737 queued gave 52 NZ fees in 2 h with many pages carrying no amount) | fee reader rate and the sweep's yield |
| course_url | 1,874 tonight | +0–50 as bindings land (R2 adds more) | dry run |
| English | 20–40 | 60–120, plus whatever the 4 proposed policies add once a person approves them (each policy covers a provider's courses by level) | lane yield since the sweep |
| Intakes | 10–30 | 50–150 if the 9 calendars read come back with values and are approved | 2 filled + 9 calendars enqueued |
| Duration, delivery, campus | 20–60 each | 100–200 each, campus mostly from the 164 Layer 4 reviews | lane yield since the sweep |

---

## 4. Item 5 build (approved) — official link filled from the proven page

**Release v2.15.336 / 0.1.263, PR #678.** Migration `20261024001000_cf247_course_url_fill.sql` (spec: decisions file section 5), test `cf-247-s90-course-url-fill-contract.spec.mjs`, SOPs 1.77. No UI change: the four settings show on Settings › Pipeline settings (sections Official link and Job sizes) through the generic register.

| Object | What |
|---|---|
| `pipeline.course_url_fills` | one row per filled course: url, `evidence_id` (the proof), `identity_basis`, `filled_at`, `retracted_at`, `retract_reason`; commented, RLS on, never deleted |
| `security.course_url_fill_v1()` | the job; job `course-url-fill` daily 02:23 UTC, catalogued; callable by hand |
| `security.course_url_retraction_30d_v1()` | the guard-4 figure (filled, retracted, %, by reason, limit, enabled) for the hourly report |
| Settings | `course_url.fill_enabled` (0/1, 1), `course_url.max_retraction_pct` (1–20, 5), `batch.course_url_fill` (100–5,000, 2,000), `course_url.fill_countries` (list, **NZ**) |

| Guard | Enforced by |
|---|---|
| 1 Proven binding only | `status = 'bound'`, `identity_basis` present, `read_status = 'read'`, stored copy, the address is the page's final URL; **and** `coverage_identity_allowed(provider, basis, 'official_url')`, the country's own proof list, so an NZ page labelled `cricos_code` (285) waits for 8a |
| 2 Manual locks honoured | `pipeline.manual_locks` (course / course_url) excluded; only `course_url is null` is written; the `manual_lock_guard` trigger keeps a locked value anyway |
| 3 Re-fill on binding change | fills whose page left `bound` or changed copy are retracted (`page no longer bound` / `binding changed`), the link emptied only when it still equals the filled value, filled again from a qualifying binding (`on conflict` re-fill) |
| 4 30-day retraction monitoring | above `course_url.max_retraction_pct` (with ≥ 50 fills in the window) the job sets `course_url.fill_enabled` to 0 and logs `course_url_fill_paused`; the hourly report prints the figure |

**Dry run (live database, rolled back):** fill with every country allowed would be AU 16,887 / CA 1,836 / NZ 1,874; the real run (NZ list) filled 1,874 (basis: title_level 724, exact_title 602, degree_name 459, adapter_title 73, nzqa_code 16); one page un-bound and a second run → 1 retracted, 1 emptied, 0 re-filled; NZ courses with an official link after: 2,772 of 6,474 (42.8%). Ten sample rows were drawn (Massey Master of Supply Chain Management → massey.ac.nz/study/all-qualifications-and-degrees/…, SIT NZ Diploma in Hospitality Management → sit.ac.nz/programme/course/…, UCOL NZ Certificate in Arts and Design → ucol.ac.nz/programmes/creative/…, Auckland Master of Ecology → auckland.ac.nz/en/study/…).

**Developer note (section 13 of the next developer-pack issue, no API change):** "`course_url` is now populated for courses whose official page the platform has verified; its meaning and type are unchanged."

**Decision for the Platform Admin:** widen `course_url.fill_countries` to AU and CA (16,887 + 1,836 links) once the NZ run is reviewed — a Settings change, no release.

**Live (01:35 AEDT):** migration applied, history md5 `6df1196020bd2c6567f5ec9ccf5c972f` equals the file; job `course-url-fill` active; settings live. **First run by hand at 01:36: 1,874 NZ links filled, 0 retracted; NZ courses with an official link 899 → 2,773; search refresh requested.** PR #678 squash-merged (aa2468d9); workflow results recorded in the audit trail.

---

## 5. Entry requirements (academic) — build spec, proposal only (not built)

**Field:** `catalogue.course_entry_requirements` (new table beside the course, never a column on `courses`): `course_id`, `audience` (international / domestic / all), `kind` (prior_qualification, minimum_grade, subject_prerequisite, portfolio_interview, work_experience, other), `statement` (the admitted text, ≤ 500 chars), `level_code` (the NZQF / AQF level named, nullable), `quote` (verbatim from the page), `source_id`, `evidence_id`, `confidence`, `status` (the existing vocabulary: active, inactive, superseded, unverified), `as_at`, `last_verified_at`. Commented, RLS on. **Consumer API: additive only** — exposed later through a new website function, never by changing an existing one (Decision 266).

**Reader:** the existing Enrich fields AI lane gains a field `entry_requirements` (source rule per country in `pipeline.field_source_rules`, stored page only): the model returns up to 6 rows, each with a quote; the database admits a row only when the quote is on the page (the same check as English and intakes), the statement is ≤ 500 chars, and a `level_code` named is a real level for that country; otherwise the row is skipped with the reason. Rows for a page that names "see the programme regulations" or a PDF go to Layer 4 (`more_evidence`). Supersession: a new read for the same `course_id` + `audience` + `kind` marks the old row `superseded` with `as_at` from the page.

**Validation rules:** quote on page; no numeric score without a scale named (e.g. "GPA 5.0 on a 9 scale"); no row that only repeats the English requirement (already a field); international rows require a sentence naming international / overseas applicants.

**Settings:** `entry.max_rows_per_course` (1–10, 6), `entry.min_confidence` (0.5–1, 0.8), `entry.countries` (list).

**Estimate:** 2.5 days (table and admission function 1; reader prompt and item plumbing 1; contract test, source rules, SOP line 0.5).

**Merge note (25 Oct 2026):** this spec is EXTENDED, not replaced, by `docs/platform/ENTRY-REQUIREMENTS.md` (1.1) and `docs/platform/ENTRY-REQUIREMENTS-IMPLEMENTATION.md`. The table stays `catalogue.course_entry_requirements` with these columns and validation rules. It gains the kinds `override` / `general_note`, `min_entry_score`, `benchmark_band` and `provenance`. The provider-level country matrix (`catalogue.provider_entry_matrix`) is added beside it. Exposure: the Platform Admin's 25 Oct 14:36 mandate asks for additive fields on the existing course and provider payloads; this supersedes "a new website function" above, pending confirmation (decision 1 in the implementation file). Cost: one AI call per bound page, about US$0.004 a page at the current model, about NZ$15 for the NZ bound set. **Weekly matrix:** listed at 0% under "defined but never populated" until approved and built.

---

## 6. Gate map — NZ field → gate → expected coverage when it clears

Today: 3,414 of 6,474 NZ courses bound (52.7%). Coverage is "% of all active NZ courses".

| Field | Today | Gated on item 5 | Gated on 8a (285 cricos-labelled NZ pages re-verified; 147 quarantined fees re-admitted) | Gated on R2 (binding to 75% by 22 Nov) | Not a lane gate: page silent or provider source |
|---|---|---|---|---|---|
| course_url | 13.9% | **→ 42.8% tonight** | → 47% | → 68–72% | — |
| International fee | 17.7% | — | → 20–21% (147 back + part of the 285) | → 28–32% | fee schedules per provider for the page-silent rest |
| English | 36.2% | — | ≈ no change | → 45–50% | the central policy per provider is the real lever: 4 proposals awaiting approval now; 27 "no values" providers need a person to name the page |
| Intakes | 32.7% | — | ≈ no change | → 40–45% | calendars: 9 enqueued tonight, 2 proposed; `provider-calendar-intakes` job is off |
| Duration | 36.0% | — | — | → 45–50% | page silent; no provider lane |
| Campus | 35.8% | — | — | → 45–50% | 164 Layer 4 reviews and the admitted campus lists |
| Delivery | 39.4% | — | — | → 50% | page silent |
| Open to international | 24.0% | — | — | → 30% | item 3 (NZ Code signatory list, O5) is the provider-level answer |
| Entry requirements | 0% | — | — | — | section 5 proposal |

The honest reading: after item 5 the next NZ-wide lever is R2 (binding), then 8a; English and intakes move most through the provider-level pages, where the queue is people (6 proposals to approve, 27 providers with no policy page named), not machines.

---

## 7. Needed from the Platform Admin (other than O5, O8, O9)

| # | Item |
|---|---|
| 1 | Widen `course_url.fill_countries` to AU and CA after reviewing the NZ run (Settings, no release) |
| 2 | Approve or reject the 6 NZ central-policy proposals waiting (4 English, 2 calendar) on Layer 2 › Provider policies; each unlocks a provider's courses |
| 3 | Remove `cricos_code` from the CA tuition identity list (00:45 finding) |
| 4 | Entry requirements: approve the section 5 spec, or not |
| 5 | Whether `provider-calendar-intakes` (off) should run again for NZ once calendars are approved |
| 6 | CA: approve the 8 CA policy proposals waiting (6 English, 2 calendar); confirm CA fee requests stay unfired until 8a gives CA its DLI / program-code proofs (A1) |

---

## 8. Runbook addition (one section)

**Official link fill.** Settings › Pipeline settings › Official link: *fill from the proven page* (on/off), *most taken back* (%), *countries filled*; Job sizes › *links filled a run*. The nightly job runs at 02:23 UTC; the hourly report prints "course_url fills: n filled in 30 days, n taken back (x%)" from `security.course_url_retraction_30d_v1()`. If the job has paused itself, the setting shows 0 with the reason; tighten eligibility (for example exclude a proof label) before switching it back on. A link a person sets is never touched; lock it on the course to make that explicit.

---

## 10. Addendum A1–A4 (Platform Admin 00:46)

### A1. CA, reported separately

CA = 3,807 active courses, **3,080 bound (80.9%)**, 3,062 bound for more than 12 h. CA's binding is not the problem; its proofs and fee normalisation are.

| Field | Populated | % of 3,807 | Bound > 12 h and empty | Blocking lane / gate |
|---|---|---|---|---|
| International fee | 656 | 17.2% | 2,408 | **Gated on 8a**: 534 bound courses have a proof the CA tuition policy refuses; the other 1,892 pass the policy only because the CA list wrongly contains `cricos_code` (00:45 finding), so **no CA fee request was fired** — CA tuition stays blocked until CA has DLI / program-code proofs (8a). After 8a, per-term and per-credit normalisation (O2) gates the amounts: CA pages print per-term and per-credit fees that the floor and the yearly figure must understand |
| English requirement | 1,986 | 52.2% | 1,478 | page-silent 1,388 of 1,421 bound gaps; provider policies: 26 approved, 6 proposed (awaiting a person), 21 no values |
| Intakes | 1,595 | 41.9% | 1,473 | page-silent 713 of 1,123; calendars: 10 approved, 2 proposed, 18 no values |
| Duration | 1,313 | 34.5% | 1,753 | page-silent 1,314 of 1,415 |
| Campus | 2,036 | 53.5% | 1,069 | 54 in Layer 4 review; 28 never tried (the campus list needs ≥ 2 pages, `enrich.campus_min_pages`) |
| Delivery | 2,287 | 60.1% | 787 | page-silent 373 of 453 |
| course_url | 777 | 20.4% | 2,285 | item 5: **1,836 would fill** when `course_url.fill_countries` gains CA (decision, section 7) |
| Open to international | 3,806 | 100% | 1 | Layer 1 (DLI register) already answers it |

CA since the sweep: 28 fees, 2,140 enrich items (filled: campus 92, duration 46, delivery 32, field of study 20, intakes 19). Every CA bound gap has been tried on its current copy (never tried: 0–28 per field). **Fired for CA today:** 17 central-policy pages enqueued (existing function); nothing else is fireable without 8a.

### A2. Stored-page inventory (read-only)

`c` = bound pages with a stored copy; `c7` / `c30` = of those, read in the last 7 / 30 days; `m` = mismatch or ambiguous pages; `x` = bound pages whose proof label the country's official-link policy does not accept (NZ `cricos_code`, CA `cricos_code`/`nzqa_code`, or no label).

**NZ top 20 (by active courses)**

| Provider | Active | Bound | With copy | Copy ≤ 7 d | Copy ≤ 30 d | Copy % of active | m | x |
|---|---|---|---|---|---|---|---|---|
| University of Auckland | 458 | 346 | 334 | 95 | 334 | 72.9% | 111 | 91 |
| University of Canterbury | 280 | 224 | 224 | 96 | 224 | 80.0% | 56 | 7 |
| University of Waikato | 278 | 117 | 114 | 16 | 114 | 41.0% | 161 | 3 |
| Victoria University of Wellington | 273 | 165 | 152 | 5 | 152 | 55.7% | 104 | 13 |
| Massey University | 265 | 166 | 166 | 74 | 166 | 62.6% | 98 | 0 |
| Auckland University of Technology | 257 | 230 | 202 | 3 | 202 | 78.6% | 23 | **219** |
| University of Otago | 252 | 195 | 194 | 27 | 194 | 77.0% | 50 | 1 |
| NZIST Work-Based Learning | 231 | 0 | 0 | 0 | 0 | 0% | 21 | 0 |
| Southern Institute of Technology | 207 | 120 | 120 | 4 | 120 | 58.0% | 83 | 0 |
| Lincoln University | 199 | 104 | 93 | 1 | 93 | 46.7% | 90 | 11 |
| Eastern Institute of Technology | 184 | 101 | 98 | 8 | 98 | 53.3% | 81 | 3 |
| Otago Polytechnic | 182 | 118 | 92 | 1 | 92 | 50.5% | 55 | 26 |
| Ara Institute of Canterbury | 178 | 89 | 87 | 4 | 87 | 48.9% | 88 | 24 |
| Toi Ohomai | 156 | 93 | 93 | 23 | 93 | 59.6% | 63 | 0 |
| NMIT | 148 | 70 | 68 | 8 | 68 | 45.9% | 78 | 6 |
| Manukau Institute of Technology | 144 | 138 | 67 | 14 | 67 | 46.5% | 5 | 75 |
| Wintec | 144 | 77 | 76 | 4 | 76 | 52.8% | 67 | 1 |
| NorthTec | 122 | 95 | 44 | 7 | 44 | 36.1% | 27 | 54 |
| Whitireia and WelTec | 116 | 65 | 53 | 10 | 53 | 45.7% | 50 | 12 |
| UCOL | 115 | 93 | 41 | 3 | 41 | 35.7% | 22 | 52 |

**CA top 10**

| Provider | Active | Bound | With copy | Copy ≤ 7 d | Copy ≤ 30 d | Copy % of active | m | x |
|---|---|---|---|---|---|---|---|---|
| University of British Columbia | 575 | 400 | 342 | 21 | 342 | 59.5% | 175 | 58 |
| University of Alberta | 379 | 379 | 222 | 19 | 222 | 58.6% | 0 | 157 |
| Conestoga College | 270 | 270 | 264 | 255 | 264 | 97.8% | 0 | 6 |
| University of Victoria | 234 | 227 | 140 | 38 | 140 | 59.8% | 7 | 87 |
| Simon Fraser University | 208 | 157 | 153 | 92 | 153 | 73.6% | 51 | 4 |
| University of Lethbridge | 199 | 180 | 180 | 29 | 180 | 90.5% | 19 | 0 |
| University of Calgary | 179 | 34 | 34 | 22 | 34 | 19.0% | 145 | 1 |
| Durham College | 144 | 144 | 138 | 112 | 138 | 95.8% | 0 | 6 |
| Sheridan College | 105 | 78 | 77 | 75 | 77 | 73.3% | 27 | 1 |
| College of the North Atlantic | 105 | 105 | 105 | 76 | 105 | 100% | 0 | 54 |

Reading: every bound page in both lists has a copy read within 30 days (`c30 = c` everywhere), so stored-page replay has material at 36–80% of each NZ provider's courses and 19–100% of each CA provider's. The thin spots are binding, not copies: NZIST WBL (0 bound), Waikato (41%), Calgary (19%).

### A3. Stored-page replay — definition, and the finding that it already runs

**Definition.** For a bound page with a stored copy, every field reader runs against the copy, not a new fetch: no Firecrawl spend, no provider-server load, bounded only by lane throughput, admitted through the normal apply paths (floors, identity policy, provenance unchanged).

**The readers already accept stored-copy input — it is their default.** Read from the worker's own history and the live lanes: `enrich_ai` (English, intakes, duration, campus, delivery, international; v0.22.0) reads *stored pages*; `fee_ai` reads the course's stored page as text (v0.41.0); `reextract` re-runs the pattern extractor on *saved pages* (job `coverage-reextract`, every minute); `reidentify` checks the stored copy. A fresh fetch happens only in `read` (when `next_read_at` falls due) and nowhere in admission. So **the replay has already been run for both countries**: the standing hourly task "Fill the gaps · all countries (most missing first)" replayed the sweep's pages at 23:23 (5,063 items), and section 2 / A1 show that every NZ and CA bound gap has been tried on its current copy. No replay input path is needed and none is built.

**What a replay across the top-20 NZ and top-10 CA would admit from here.** The honest number is what the lane measured on the current copies: for pages already tried, re-asking yields nothing new (the skip reason is "the page does not state it" for 70–95% of gaps per field), so the per-provider replay expectation is **≈ 0 additional values per field** for pages tried since the sweep, and only the few never-tried items (NZ campus 6, CA campus 28, CA English 1, duration 1) plus the 164 + 54 campus rows in Layer 4 review. Replay becomes valuable again only when **new copies exist**: a newly bound page (R2), a re-verified page (8a), or a page re-read because the site changed (90-day cycle). That is why the handoff-on-bind (item 6) matters: it is the replay trigger for new copies. Expected admissions from replay alone: 24 h 0–20 values per field across the top-20 NZ; 7 d the same unless R2 lands bindings.

So A3's branch "copies are thin, run fetch-gated instead" does not apply either: copies are plentiful and already consumed. The constraint on these fields is the content of the course pages and the provider-level policy pages, where the queue is people (6 NZ and 8 CA proposals awaiting approval; 27 NZ and 21 CA providers with no policy page that gave values).

### A4. Wrong-page correction runbook — UoA first, then the NZ top-20

Steps 1 and 2 are done by the platform already; 3 is staged as a seed file; 4 and 5 are gated. Per provider, the pages concerned:

| Provider | Mismatch / ambiguous (step 1) | Verified against the stored copy under the current rule (step 2) | Bound with a disallowed label (8a set) |
|---|---|---|---|
| University of Auckland | 111 | 109 (the other 2 have no copy) | 72 `cricos_code` + 19 no label |
| Waikato | 161 | 157 | 3 |
| Victoria | 104 | 104 | 13 |
| Massey | 98 | 95 | 0 |
| Lincoln | 90 | 76 | 11 |
| Ara | 88 | 88 | 24 |
| SIT | 83 (9 manual) | 74 | 0 |
| EIT | 81 | 81 | 3 |
| NMIT | 78 | 78 | 6 |
| Wintec | 67 | 67 | 1 |
| Toi Ohomai | 63 | 62 | 0 |
| Canterbury | 56 | 55 | 7 |
| Otago Polytechnic | 55 | 55 | 26 |
| Otago | 50 | 41 | 1 |
| Whitireia and WelTec | 50 | 50 | 12 |
| NorthTec | 27 | 27 | 54 |
| AUT | 23 | 21 | 219 |
| UCOL | 22 | 22 | 52 |
| NZIST WBL | 21 | 21 | 0 |
| MIT | 5 | 5 | 75 |
| **Total** | **1,333** | **1,287** | **579** |

1. **LIST** — done above; per-page list at `docs/platform/wrong-page-values/SEED-20261024-page-rejections-nz-top20-wrong-pages.csv` (1,333 rows, same shape as the 1,870-row file: country, provider, course_id, status/read_status, attempts, http status, url).
2. **VERIFY** — done by the existing `coverage-reidentify` lane: 1,287 of the 1,333 (UoA 109 of 111) carry a `coverage_reidentify_done` row for the current rule (`identity-v0.5.12`) against their stored copy and are still mismatch, so they are confirmed wrong pages, not stale verdicts. No new fetch was made.
3. **WRONG** — they already carry `mismatch` / `identity_mismatch` and the course is already unbound by that status (a mismatch page never admits). The seed file above is their `page_rejections` population; it loads in S1's dry run with the 1,870-row file (3,203 rows, count-guarded). The 579 bound pages with a disallowed label are **not** moved tonight: under the current rule reidentify would relabel and re-bind them within a minute (section 10 of the audit trail, 00:30); they move by the 8a query once worker v0.45 is live.
4. **RE-FIND** — gated on S1: today's source finder (`source_find`, find-again) and the AI page match do not read a rejection list, so a scoped re-find would offer the same wrong pages again (Finding 2). UoA's finder has already run (348 of 458 bound); the course-page search for UoA's 111 mismatched courses sits behind the Q1 scheduler release (R2). Not fired.
5. **RE-BIND + REPLAY** — when R2 binds a new page, the standing enrich task and the fee enqueue replay it from its stored copy within the hour (A3), and item 5 fills its link the same night; item 6 (handoff on bind) makes that minutes.

Settings and ledger: the batch job for steps 3–5 is S1's (`pages.max_distinct_wrong`, `search.daily_picked_cap`, the ledger `landed` counts); nothing new is keyed tonight because nothing new runs.

**Per-provider report tonight (UoA):** listed 111 / verified 109 / rejected (already mismatch) 111 / re-found 0 (gated S1 + R2) / re-bound 0 / values admitted from the correction 0; fee requests fired for UoA's bound pages with an allowed proof: included in the 832 (section 3); UoA official links filled tonight by item 5: all bound UoA pages with an allowed proof (≈ 255 of 346; the 91 with a disallowed or missing label wait for 8a).

---

## 9. Mandate as received (24 Oct 2026, 00:35)

> Consolidated mandate — NZ field admission. Standing state acknowledged (diagnosis, quarantine a07de41, pending fee_ai verification, standing order R1 → R3 → audit → R2 → stepped test → S1 → 8a → items 5, 9, 10, 11; item 5 approved with four guards; guardrails unchanged; O5/O8/O9 awaiting). The mandate: (a) per-field NZ baseline with blocking lane, confirming whether the enrich/AI lanes consume the sweep's pages; (b) fire what is fireable today through existing lanes, well-covered providers first, with expected admissions for 24 h and 7 d; (c) build item 5 with its four guards; (d) entry requirements (academic) as a spec only, listed at 0% in the weekly matrix; (e) report the gates honestly (R2, 8a, item 5) with expected coverage per field. Output: this file and a chat summary.
