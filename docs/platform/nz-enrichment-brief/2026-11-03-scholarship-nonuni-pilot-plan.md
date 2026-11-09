# Scholarships beyond universities — pilot plan (D-M6, D-M7)

**Authority:** Platform Admin decision, 3 Nov 2026 08:44 AEDT, §4 (`2026-11-03-morning-decision-pack-0844.md`; register `2026-11-03-platform-admin-decisions-0844.md`, D-M6 and D-M7).
**Prepared by:** Workstream B (scholarship completeness and eligibility), 3 Nov 2026.
**Evidence:** read-only reads of production `fxcwkweaxjtknorudmwp`, 3 Nov 2026 08:47–09:27 AEDT. No production writes. No AI or Firecrawl calls.
**Build:** branch `cf247-scholarship-pilot` (off `main` v2.15.414). Commits `96f66128` and `4d73121c`, pushed. Not merged and not released. The release is the integrator's.

## 1. In short

- The two proposals shipped in v2.15.413 are **global switches**:
  - P1 is `scholarship.non_university_admission`.
  - P2 is `scholarship.legitimacy_checks_on`.
- Switching either one on today would change the rules for every provider at once. There was no way to try them on a few providers first.
- This change adds that way:
  - A **pilot list** of providers. While the list is empty, nobody is affected.
  - A **pilot only** switch, which is on by default.
  - A check that refuses **another body's award** found on a college's site.
  - Two **read-only stop reports**.
- With the release deployed, the integrator activates the pilot with three setting changes (§5).
- Nothing is switched on by the release itself.
- `worker-outcome-check` stays paused (D-M8).

## 2. What P1 and P2 would do if switched on for everyone today

Counts are of active providers. Read live on 3 Nov 2026 between 08:56 and 09:27 AEDT.

### 2.1 P1 on its own: non-university admission

**Who could have scholarships admitted:**

| Country | University college | HE institute | TAFE / polytechnic | Private VET | Wānanga | Total |
|---|---|---|---|---|---|---|
| Australia | 8 | 136 | 16 | 839 | – | **999** |
| New Zealand | – | – | 17 | 372 | 3 | **392** |

- Canada: none. Its 1,130 providers have no provider type recorded.

**Firecrawl:** no new spend. Almost every Australian and New Zealand provider already has a discovery row:
- Australian non-universities with 30 or more CRICOS courses are already searched today.
- New Zealand providers are already searched whatever their size.

Today their pages are read and then refused as "not a university". With P1 on, new reads could become records.

**Stored pages refused as "not a university":**
- Pages from these provider types refused for that reason: about 490.
- Many of those pages are **on directory sites**, not on the provider's own site. Examples: acir.com.au, studymelbourne, studyqueensland, oneuedu and topaustraliauniversities.
- They name other institutions' awards, so they are not the provider's own evidence.
- The admission rule "not on the provider site" would refuse them, but only after the provider rule.

### 2.2 P2 on its own: legitimacy checks instead of the 30-course minimum

**Gained.** These Australian providers would start being searched:

| Provider type | Providers |
|---|---|
| Private VET | 706 |
| HE institute | 125 |
| Type "other" | 80 |
| TAFE | 5 |
| University | 5 |
| University college | 4 |
| **Total** | **925** |

- The 80 "other" providers would be searched even though P1 can never admit them.

**Lost.** All **52 Canadian providers** searched today would stop being searched.
- The legitimacy check needs a provider type, and Canadian providers have none.

**No change:** New Zealand.

### 2.3 Expected load for the 925 newly searched providers

**Firecrawl:**
- Recent scholarship spend: 3,948 credits in 14 days (about 280 a day).
- A non-university provider has used between 2 and 112 credits over its lifetime (about 20 is typical).
- 925 providers at about 20 credits each comes to about 18,500 credits.
- The cap is 150 credits per provider, so the most it could reach is about 139,000.
- Spend is bounded by the daily scholarship share of 3,500 credits, which is shared with universities.
- That is at least five full days of the scholarship share.

**AI:**
- Scholarship AI has cost US$0.15 in 14 days.
- Per provider, lifetime AI cost is US$0.005 to US$0.06.
- 925 providers would cost about US$30 in total, spread over the run.
- The daily ceiling of US$20 (`guard_scholarship_ai`) holds.

**Conclusion:** neither proposal is safe to switch on for everyone yet. P2 for everyone would stop the Canadian search. Both would open admission and search to hundreds of providers before the evidence is checked.

## 3. What was built (branch `cf247-scholarship-pilot`)

| Part | What it does |
|---|---|
| `scholarship.pilot_provider_ids` (list, ships empty) | The pilot providers. Empty means nobody. |
| `scholarship.pilot_only` (on) | While on, P1 and P2 apply only to listed providers, and everyone else keeps today's rules. Off means wider activation (not part of this plan; see §7). |
| P1 and P2 scoped | `scholarship_admission_provider_ok_v1` and `fc_sch_eligible_v1` apply their new rule only in the pilot scope. |
| Pilot start | Runs inside the hourly job `scholarship-discover-refill` (:23), only while P1 or P2 is on and the list is not empty. A listed provider is put first in the discovery order and gets one fresh discovery after the list is saved. Its pages read in the last 90 days, and refused only because it was not a university, are admitted again from their stored facts (up to `batch.scholarship_pilot_readmit`, 50 an hour). There is no new read, no AI and no Firecrawl. |
| Award source check | A non-university page naming another body's award (`scholarship.external_award_patterns`, for example "Australia Awards", "Manaaki", "Destination Australia", "University of …") is refused as "award of another body". Universities are not affected. |
| Stop reports (read-only) | `select * from security.scholarship_pilot_report_v1()` gives one row per pilot provider. `select security.scholarship_pilot_stop_v1()` gives the total. Both count from the time the pilot list was last saved. |

**Unchanged:**
- New records start unpublished, as today.
- Layer 4 governance, duplicate and edition protection, closing-date rules and round states (closed rounds stay closed).
- Firecrawl and AI limits. No limit is raised.
- The consumer API.

**Migration:** `supabase/migrations/20261103090000_cf247_scholarship_nonuni_pilot.sql` (file md5 `2df231459d266b4ffc5376e9cfa33f30`). Five md5-guarded changes, using live definitions read at 08:47 AEDT:

| Function | Before (live) | After |
|---|---|---|
| `security.scholarship_admission_provider_ok_v1(uuid)` | `804be95b3e78fb9efe3ea0d967cbe666` | `269f74a985acbc37f1f3b8615efa6254` |
| `security.fc_sch_eligible_v1(uuid)` | `8064816107a9b44bb2aeccbfa4a2d867` | `2c44de24ea2d1bda123e1c8679591a9f` |
| `security.fc_provider_tier_v1(uuid)` | `3d0aa9dc690e23df4fd0c7248aaa7300` | `2d71dcbd8aab00516c8222f68b6cc51b` |
| `security.scholarship_discovery_refill_v1(integer)` | `46a66f131b574375db6e9edbc2ad3f36` | `5a72808f07e2f5219518ed3fc20fcdb7` |
| `security.scholarship_admit_from_provider_page_v1(bigint)` | `5b3557c1ea4488f3e9b751ad9e7371e9` | `0741db9c35ef91eba6caa55b04fde869` |

**Validation:**
- **Fixtures** (`tests/fixtures/scholarship-pilot/run.sh`):
  - The live definitions were rebuilt, and all 8 equal the live md5s.
  - The migration applies 5 changes, and a second run changes nothing.
  - 26 cases pass.
- **Specs** (31 tests in total):
  - `s231` (new) passes.
  - `s226`, `s32`, `s42`, `s57` and `s120` pass.
- **Not run:** the full suite. That is the integrator's CI gate.
- **Test register:** to be re-taken with the release, because `s231` is added.

## 4. Proposed pilot cohort (8 providers: 5 in Australia, 3 in New Zealand)

**How they were chosen:**
- Each provider already has stored pages **on its own website**, read in October 2026.
- On those pages, the AI read a single, named scholarship that is explicitly open to international students and currently offered.
- The pages were refused only because the provider is not a university.
- Each has a recorded provider-type basis (a TEQSA, CRICOS or NZQA register).
- All 8 pass the P2 legitimacy check today.

| # | Provider | Id | Type, country | Courses | Official scholarship evidence (own site) | Expected re-admits | P2 passes |
|---|---|---|---|---|---|---|---|
| 1 | Bendigo TAFE and Kangan Institute | `a1efd433-9dec-48d1-b477-21b6e522363a` | TAFE, AU | 19 | kangan.edu.au/international/…/scholarships1/ (Automotive Scholarship, Pathway to Victoria Scholarship, Access Scholarship) | 6 pages, of which 1 is "Australia Awards" and will be refused as another body's award | yes |
| 2 | Engineering Institute of Technology | `2b61a262-c219-4396-bdbf-e35aee47639d` | HE institute, AU | 14 | eit.edu.au/scholarships/… (Senior Year Merit, Doctorate Research, LATAM Future Engineers Bursary and 4 others) | 7 | yes |
| 3 | International College of Management, Sydney (ICMS) | `435ca964-67a5-483c-bc8f-9d5ab059c0c2` | HE institute, AU | 65 | icms.edu.au/future-students/scholarships/… (ICMS International Scholarship, Global Innovator and others) | 7 | yes |
| 4 | Curtin College | `0ba022f8-dd06-49f5-9c96-2e80a3d71e16` | HE institute (pathway college), AU | 8 | curtincollege.edu.au/how-apply/scholarships/… (High Achiever, Master Qualifying Program Bursary, Diploma Pathway Bursary) | 5 | yes |
| 5 | Perth College of Business and Technology | `e6f73072-cb37-4d2d-93ef-9ec855dd5397` | Private VET, AU | 17 | pcbt.wa.edu.au (Regional 5% Scholarship, PCBT $1,000 Scholarship, Diversity Scholarship) | 5 pages, of which 1 is "University of Adelaide …" and will be refused | yes |
| 6 | Ara Institute of Canterbury | `87576ec2-c4b0-4a00-ab94-64422c77d545` | Polytechnic, NZ | 178 | ara.ac.nz/student-services/…/scholarships/… (Ara International Student Academic Scholarship and 4 others) | 5 | yes |
| 7 | Otago Polytechnic | `cd27693c-6c80-42f4-8b76-1ed2d94e0b45` | Polytechnic, NZ | 182 | op.ac.nz/international/fees-and-scholarship/… (2026 International Scholarships, English Pathways Scholarship) | 4 | yes |
| 8 | Unitec (Manukau Institute of Technology and Unitec) | `66f6fcc9-15f8-46e6-b3b3-0576ab4bcce3` | Polytechnic, NZ | 80 | unitec.ac.nz/application-and-funding/scholarships-and-awards/… (International Pathways Award, Lance Laulala Memorial Scholarship) | 8 pages, of which 3 are "Manaaki" (a government programme) and will be refused | yes |

**Spend so far:** lifetime scholarship spend for the eight is 2–112 Firecrawl credits and under US$0.06 of AI each.

**Why this mix tests the decision:**
- Rows 1, 5 and 8 contain known **other-body awards**. They test the award-source check.
- Row 7's "scholarship" pages sit under the international fees section. They test eligibility evidence and Layer 4 review.
- Rows 2, 4 and 5 are small, with fewer than 30 CRICOS courses. They test P2.

**Not in the first pilot:**

| Group | Why |
|---|---|
| Wānanga (3) | No stored page on their own sites names a scholarship, so there is no verified evidence yet. They can be added once a fresh discovery finds an official page. |
| University colleges | SAE University College's stored own-site pages are news items or a "Destination Australia" page (a government award). Moore College's pages come from the retired register. Reserve: SAE `141c895b-9fd5-4c10-9427-bf457593de37`. |
| Le Cordon Bleu New Zealand | Its website is the global domain `cordonbleu.edu`, and its stored pages include the **Brisbane** scholarship. The rules cannot yet tell the country or campus apart, so the wrong-provider risk is high. |
| Small private VET colleges with many "refused" pages | Those pages are on directory sites, not their own. |
| Type "other" | Not an admissible type under P1. |

**Reserve:** MIT Melbourne `4e8fe8de-b6bc-47e8-bbb7-b4dcbf218d30` (HE institute, 3 own-site pages).

## 5. Activation steps (integrator, after the release that carries `20261103090000` is deployed and verified)

**Before you start:**

1. Confirm the five after-md5s above against the live definitions.
2. Confirm that `select security.scholarship_pilot_stop_v1()` answers `providers: 0`.
3. Confirm that `scholarship.pilot_only` is `true`.

**Then make three setting changes** on Settings › Pipeline settings › Scholarships, each with a reason that cites D-M6 or D-M7. Do them in this order:

1. **`scholarship.pilot_provider_ids`** = the eight ids in §4, in this form:
   `a1efd433-9dec-48d1-b477-21b6e522363a, 2b61a262-c219-4396-bdbf-e35aee47639d, 435ca964-67a5-483c-bc8f-9d5ab059c0c2, 0ba022f8-dd06-49f5-9c96-2e80a3d71e16, e6f73072-cb37-4d2d-93ef-9ec855dd5397, 87576ec2-c4b0-4a00-ab94-64422c77d545, cd27693c-6c80-42f4-8b76-1ed2d94e0b45, 66f6fcc9-15f8-46e6-b3b3-0576ab4bcce3`
   - Saving the list starts the pilot measurement.
2. **`scholarship.non_university_admission`**: `false` → `true` (P1, pilot scope only).
3. **`scholarship.legitimacy_checks_on`**: `false` → `true` (P2, pilot scope only).

**Do not change:**
- `scholarship.pilot_only` (stays `true`).
- Any Firecrawl or AI limit.
- `worker-outcome-check` (stays paused).

**After the next `scholarship-discover-refill` run (:23):**

1. The run's answer shows `pilot: {queued, due, readmitted, admitted}`. Expect `due` of up to 8, and up to about 47 pages re-admitted, fewer after duplicates and the award-source refusals.
2. `select * from security.scholarship_pilot_report_v1()` returns eight rows, with `in_scope`, `admission_ok`, `search_ok` and `legitimacy_ok` all true.
3. Any other provider is unchanged. For example, `security.scholarship_admission_provider_ok_v1` is false for an unlisted TAFE.
4. Every pilot record is unpublished and goes to **Layer 4 review before publication**.

**To roll back:** set the list to empty, or switch either proposal off. Records already admitted stay unpublished until Layer 4 decides. Nothing is withdrawn automatically.

## 6. Stop conditions and how each is measured

- **Where to look:**
  - `security.scholarship_pilot_stop_v1()` gives `stop`, `reasons`, and the per-day figures against their limits.
  - The per-provider detail is in `security.scholarship_pilot_report_v1()`.
- **When to check:** at least daily, and after every Layer 4 session.
- **What happens:** a `stop: true` result means pausing expansion. Clear the list or switch the proposal off, then report to the Platform Admin. Nothing switches itself off.

| Stop condition | Measured as | Threshold (setting) |
|---|---|---|
| Wrong-provider admission | A pilot record since the start that matches any of:<br>- its page is not on the provider's own sites<br>- its page is on a directory site<br>- the record's provider differs from the page's provider<br>- a Layer 4 block or publication decision names the provider | more than `scholarship.pilot_stop_wrong_provider_max` (0) |
| Unsupported eligibility | A pilot record whose page facts do not show all of: explicitly open to international students, currently offered, and a single scholarship page; or whose audience is not international; or which has a Layer 4 decision on eligibility, audience or nationality | more than `scholarship.pilot_stop_unsupported_max` (0) |
| Budget: Firecrawl | The pilot's scholarship credits since the start, per day | over `scholarship.pilot_stop_fc_share_pct` (20%) of `daily_share_scholarships` (3,500), that is 700 a day |
| Budget: AI | The pilot's scholarship AI cost since the start, per day | over `scholarship.pilot_stop_ai_share_pct` (20%) of `guard_scholarship_ai` (US$20), that is US$4 a day |
| Operational: reads | The share of a provider's page reads since the start that failed, were blocked or failed to scrape | over `scholarship.pilot_stop_failed_pct` (50%), once it has `scholarship.pilot_stop_min_reads` (10) reads |
| Operational: discovery | A provider's discovery row is `failed` or has used 3 attempts | any |

**Also check by hand, at each Layer 4 session:**
- Is the awarding body the provider itself? (The award-source patterns catch known programmes, not every case.)
- Is the country or campus right?
- Is the closing date right?
- Does a closed past round stay "closed"?

## 7. When to widen

**Phase 1** is the eight providers, for at least 7 days. Phase 1 is complete when all of these are true:
- each provider has had its fresh discovery and its pages have been read;
- `scholarship_pilot_stop_v1()` has stayed `stop: false` throughout;
- Layer 4 has reviewed every pilot record;
- no record was wrong-provider or lacked eligibility evidence;
- at least 80% of pilot records were accepted as they were;
- Firecrawl and AI use stayed under the pilot shares, and the university scholarship work did not slow. Check this with `security.job_outcomes_v1`: `scholarship_discover` stays succeeded or idle.

**Phase 2** widens to about 40 providers by **adding ids to the same list**, with `pilot_only` still on:
- every Australian TAFE (16) and New Zealand polytechnic (17);
- HE institutes with official pages on their own sites;
- wānanga once an official page is found.

The same exit criteria apply.

**Phase 3** is wider activation (`scholarship.pilot_only` off). It needs a separate Platform Admin decision and two fixes first:
- P2 must not stop the search for the 52 Canadian providers. Either give them provider types, or keep the course rule where a country has no types.
- Providers of type "other" must not be searched when they can never be admitted.

Until then, keep growing the list instead of turning `pilot_only` off.

## 8. Notes

- The stored refused pages of small private VET colleges are mostly on directory sites. They are not evidence of the provider's own scholarships, and this pilot does not use them.
- Historical closed scholarships are unchanged. Round states and the API's `current_status` still show a passed close date as closed, never open.
- Read windows:
  - The data reads (counts, cohort evidence) ran in the Sydney windows 08:56–08:58, 09:06–09:08, 09:16–09:17 and 09:26–09:27.
  - Light catalogue reads ran between those windows: function definitions and md5s, settings, columns and the cron list.
  - One of them, the function md5s at 08:47:40, fell inside the :47–:48 avoid window. It read only the function catalogue (`pg_proc`), not table data.
