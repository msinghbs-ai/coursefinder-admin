# Scholarship throughput reconciliation — 4 November 2026

Mandate: Platform Admin 08:16 (`2026-11-04-p0-autonomous-operations-acceptance-mandate-0816.md`) §1, §7 and §9, under the Integration Controller's
direction of 08:31. Production project `fxcwkweaxjtknorudmwp`, read only. Every query time is given in Sydney time. No switch was changed, nothing
was enqueued, and no issue was transitioned: the Integration Controller makes the transitions.

## 1. Classifier verification (§1: IQ-00241, IQ-00239)

### Scheduled runs

| Run | Start | Result | Duration | Providers | Cases |
|---|---|---|---|---|---|
| 1208143 | 06:29 | failed (ON CONFLICT, v2.15.460) | 33 s | 0 | 0 |
| 1209768 | 07:29 | failed (same; v2.15.461 not yet live) | 24 s | 0 | 0 |
| 1211430 | 08:29 | succeeded (v2.15.461, classify md5 c072494c…) | 32 s | 40 | 4,577 |
| | 1213115 | 09:29 | succeeded | 7 s | 40 (80 in all) | 5,080 in all |

Job command: `select security.scholarship_coverage_classify_v1()` (unchanged).

### How long one full catalogue cycle takes

- 2,560 providers are in scope (scholarship coverage ledger, excluding not applicable and out of scope); `batch.sch_coverage_classify` is 40.
- One full cycle is therefore **64 hourly runs (about 2 days 16 hours)**: the first pass ends about **7 Nov 2026 00:29**.
- 2,407 of the 2,560 are `no_evidence` providers (nothing listed, nothing held). They take 60 of the 64 runs.
- Providers never classified are always picked before any re-pass, so **no provider is classified a second time by the scheduler until the first pass is complete**. Providers with a coverage issue go first.

### Repeated-address listings (the v2.15.460 fault)

The 08:29 run classified both Victoria University records (listings 4 and 45), SAE (listing 5) and Otago (listing 43). All of these list some address more than once, and the run succeeded:

- Each of the 7 repeated addresses that is not already a candidate has exactly **one** case, for example SAE's apply page, listed 4 times. The cases are `traversal_incomplete`, reason "listing read before fan-out".
- The other 7 repeated addresses are already candidate pages, so they correctly have no listing case.

Lincoln (listing 10) and the two RMIT records (13, 33) are later in the pick order:

| Provider | Position | Expected run |
|---|---|---|
| Lincoln | 353 | about 17:29 today |
| RMIT UP | 490 | about 21:29 today |
| RMIT | 1,410 | about 5 Nov 19:29 |

### Idempotent and deterministic

The fixture shows this (58/58, including two passes with an unchanged winner). The production proof needs a scheduled re-pass of an unchanged provider, which comes only after the first pass ends (about 7 Nov 00:29; `sch_cov.reclassify_hours` 6 applies after that).

The 09:29 run left the 40 providers of 08:29 untouched (their `classified_at` is unchanged), as the pick order intends, so their cases stand as written at 08:29.

### No false eligibility or admission

At 08:43:

- All 389 `published_verified` cases are published, active scholarships. No admission state is attached to anything but a scholarship row.
- No candidate was admitted and no admission-log row was written after 08:29. 1,151 scholarships are published.
- `pipeline.scholarship_coverage_recoveries` is empty, and every `sch_cov.recover_*` switch is 0.

The classifier writes only its own tables and work items.

Re-checked at 09:43, after the 09:29 run: 0 admissions since 08:29, 0 admission-log rows, 1,151 published (unchanged), 0 recoveries.

### Finding: the folded-duplicate count is not durable

The run's answer (`duplicate_cases`, `report_errors`, `report_error_last`) is discarded by pg_cron: `cron.job_run_details` keeps "1 row". Nothing else keeps it. A repeat or a report failure is therefore invisible after the run.

Options for the Integration Controller (the job command is not changed here):

- record the answer through `security.job_outcome_set_v1`; or
- add a run ledger row from inside the function; or
- have the job command store the result.

### Closure conditions

| Issue | Met | Not yet met |
|---|---|---|
| IQ-00241 | Fix released (v2.15.461) and live (md5 c072494c…); scheduled runs succeed; repeated-address listings (VU, SAE, Otago) produce one case per address; no false eligibility or admission | Lincoln and RMIT runs (17:29 and 21:29 today; 5 Nov 19:29); an unchanged re-pass (after about 7 Nov 00:29) |
| IQ-00239 (`job_failed:`) | The job's last runs succeed | The issue's own condition has not cleared yet (its condition cleared at 08:51 AEDT and its ops state is now superseded) |

My recommendation: close IQ-00239 once its detector clears it after a clean hour; that is independent of IQ-00241. Close IQ-00241 after the Lincoln run (about 17:29), or else hold it in production verification until the re-pass. That is the Integration Controller's call.

## 2. Thirteen states and provider coverage (§7)

**Cases by state at 09:43 (80 providers):**

| State | Cases |
|---|---|
| rejected_correctly | 1,808 |
| domestic_only | 1,310 |
| international_unresolved | 860 |
| published_verified | 429 |
| traversal_incomplete | 195 |
| expired | 151 |
| admitted_not_published | 138 |
| source_found_unread | 99 |
| awaiting_layer4 | 33 |
| source_not_discovered | 28 |
| ownership_conflict | 18 |
| rejected_incorrectly | 11 |
| evidence_backed_none | 0 |

`evidence_backed_none` is a **provider-level** state only. A provider earns it with a complete listing read, every case resolved and none published, so no case ever carries it. None of the 80 providers classified so far meets it.

**Provider states:**

| Provider state | Providers |
|---|---|
| source_not_discovered | 37 |
| traversal_incomplete | 17 |
| source_found_unread | 15 |
| international_unresolved | 8 |
| ownership_conflict | 1 |
| rejected_incorrectly | 1 |
| published_verified | 1 |

Reconciliation against the coverage ledger:

- 80 of 2,560 providers are classified. The rest follow over the cycle.
- The 26 providers with an open coverage issue are classified first.

### Torrens, TAFE SA and Box Hill

**Torrens (IQ-00215; 09:29 run).** Unresolved 15:

- **7 rejected incorrectly:**
  - Motivational Scholarship, refused by the name rule. Recovery `reread_stored`.
  - 6 register pages never read (Alumni, Career Enhancement, PEPEA, Ironwood Pathway, Kings College Malaysia, Pearl Pathway). Recovery `reopen_read`.
- **6 ownership conflicts:** BMIHMS awards on bluemountains.edu.au.
- **2 traversal incomplete:** Family Scholarship and Three Pillars, from the listing read before fan-out. Recovery `refresh_listing`.

Recovery through the shared pipeline is ready but cannot move:

- Admission eligibility is false until `sch_cov.legal_name_identity_on` is decided, and all three recovery families need their spend switch.
- For the same reason, the intervention generator raises nothing for Torrens.
- The 6 ownership conflicts are the Platform Admin's identity decision (whether bluemountains.edu.au belongs to Torrens).
- Not every Torrens case qualifies: Career Enhancement lists nationality "Australia" on the register, so it may be domestic only once read.

**TAFE SA (IQ-00216; 09:29 run).** Unresolved 3:

- 2 traversal incomplete: 8435, "2026 TAFE SA International Scholarship Programs" ($2,000, international, the register's only entry), and 8440.
- 1 awaiting Layer 4: 8438, a 2023 news page. It is past-year-only, so it is expired in substance; a reviewer should refuse it.
- Resolved: 2 domestic only, 3 rejected correctly.

The provider is refused by the admission policy (TAFE, not a pilot member), so no recovery or intervention runs. The only eligible-looking scholarship (8435) is reachable only if TAFE SA joins the pilot.

**Box Hill (IQ-00219; 08:29 run).** One case, `source_not_discovered`: discovery `map_search(42)` kept 0 pages.

- **Source eligibility evidence:** the provider's own site lists a Pathway to Victoria Scholarship under international-students (boxhill.edu.au/international-students/pathway-to-victoria-scholarship/, plus /study-with-us/scholarships). Found by web search, not read by the platform.
- So "no eligible scholarships" is **not** established. This is a discovery gap.
- Box Hill is refused by the admission policy, so it cannot be admitted or published while it is outside the pilot.

**Recommendation:** P2, gap recorded (discovery missed the source; the binding constraint is policy). Re-raise to P1 if Box Hill joins the pilot.

### Human-assisted interventions

Job `layer4-interventions` (v2.15.463) raised 36 `sch_international_unresolved` interventions for 19 providers at 08:44 from the classified cases, through `security.har_sch_generate_v1` (md5 983b3939…). By design it raises interventions only for **admission-eligible** providers (`scholarship_admission_provider_ok_v1`).

So **Torrens, TAFE SA, Box Hill, AFTRS, MIT/Unitec and TAFE Queensland will never get an intervention while the admission rule refuses them.**

- **Torrens:** the refusal is the name-rule defect (D1), not policy. Its intervention and its recovery both wait for the Platform Admin's decision on `sch_cov.legal_name_identity_on`.
- **The other five:** the refusal is policy (non-university providers outside the pilot, `scholarship.pilot_only`). Asking a reviewer about them would be asking about providers that cannot be admitted.

No parallel path was built.

### Recovery switches (all 0, unchanged)

| Switch | Effect | Activation condition | Authorised? |
|---|---|---|---|
| `sch_cov.recover_register_pages_on` | one Firecrawl and AI read of a never-read register page on the provider's own site | Platform Admin approval of the spend; acts only for admission-eligible providers (7 today; 13 with D1) | No: spends Firecrawl and AI |
| `sch_cov.recover_stored_reads_on` | one AI read from the stored copy of a page refused by the name rule | D1 on first (otherwise no eligible case); Platform Admin approval of AI spend | No |
| `sch_cov.recover_listings_on` | promote AI international listings to listing sources; re-read listings read before fan-out (one Firecrawl read each) | Platform Admin approval of the spend | No |
| `sch_cov.legal_name_identity_on` | Torrens becomes admission-eligible | Platform Admin decision on admission scope | No |
| `sch_cov.policy_disposition_on` | policy-refused TAFE, university college and wānanga are reported as blocked by policy instead of zero | Platform Admin decision; changes what coverage-reconcile reports for 45 providers | No |

None of these is covered by an existing authorisation: the 05:08 mandate authorises reversible engineering, not new spend or admission scope.

## 3. IQ-00242, IQ-00243, IQ-00244 (§9)

Common facts:

- All three providers are **refused by the admission policy**: they are non-university types outside the pilot. `scholarship.non_university_admission` is 1, but `scholarship.pilot_only` is 1 and none is a pilot member.
- Nothing they hold could be admitted or published today, whatever discovery finds.
- Their coverage disposition is `zero` (P1) only because of the reporting rule in D5 (`sch_policy_reported_as_zero`).
- "Authoritative source" below comes from the providers' own public pages, found by web search (not read through the platform; marked unverified).

### IQ-00242: Australian Film Television and Radio School

| | |
|---|---|
| Provider | University college; 2 active courses |
| Discovery | Settled `not_eligible` under the 30-course minimum (`sitemap(24)` kept 15 pages, 22 Oct) |
| Authoritative source | aftrs.edu.au/students/future-students/scholarships-and-financial-support/ (candidate 22071, read 22 Oct) |
| Current offerings | The AI classified it as a listing ("Equity Scholarships"). Public guidelines for 2027 are First Nations scholarships (domestic by definition). |
| Rejection reasons | 13 not a scholarship (course pages and historical milestones); 1 international not stated (an "Inaugural Alumni & Industry Scholarship" milestone page: expired in substance); 1 listing (the source above) |
| International eligibility | Not demonstrated. AFTRS has an international-students page (unverified whether any scholarship is open to international students). |
| Missing eligible scholarship | None demonstrated |
| Recommended severity | **P2**. Policy (non-university, not a pilot member, under the course minimum); no evidence of a missing internationally eligible scholarship. |

### IQ-00243: Manukau Institute of Technology and Unitec

| | |
|---|---|
| Provider | NZ ITP; one record for two institutions; website manukau.ac.nz; 144 courses |
| Discovery | `map_search(1072)` kept 10 pages, all on manukau.ac.nz |
| Rejection reasons | 7 not a scholarship (transcripts, paper awards, news); 2 domestic only (Bed Bath & Beyond award; English for migrants and refugees); 1 international unresolved (MPTT, Māori and Pasifika Trades Training: domestic by programme design) |
| Authoritative source | **Unitec's own international scholarships page** (unitec.ac.nz/international/study-with-us/international-scholarships/, with International Academic Excellence Scholarship regulations), found by web search and not read. It is on a host the record does not own, so discovery never looked. |
| Missing eligible scholarship | Likely (Unitec), but not proven by a platform read |
| Root cause | **Provider identity** (two institutions in one record), the same family as D1 and D6. A Platform Admin identity decision (split the record, or add unitec.ac.nz as an owned host). |
| Recommended severity | **P2** while policy refuses NZ ITPs. P1 if the pilot takes them, with the identity decision first. The generator will not raise an intervention while the provider is not admission-eligible, so the identity decision goes to the Platform Admin through the decision pack. |

### IQ-00244: TAFE Queensland

| | |
|---|---|
| Provider | TAFE; 96 courses |
| Discovery | `map_search(2920)` kept 31 pages, 30 of them on scholarships.tafeqld.edu.au (the TAFE Queensland Scholarship Foundation's FAQ and status pages) |
| Rejection reasons | 30 not a scholarship (FAQ and status pages: correctly rejected); 1 listing "what types of scholarship are available" (AI: merit scholarships, audience both; traversal incomplete) |
| Authoritative source | The Foundation's program is domestic (its application form was read as domestic). TAFE Queensland International publishes a **Destination Australia** scholarship page (tafeqld.edu.au/international/life-in-australia/destination-australia-scholarship, a Commonwealth-funded regional study scholarship open to international students). Found by web search, not read; its currency (2024) is unverified. Discovery did not find it. |
| Missing eligible scholarship | Possible (Destination Australia), not proven |
| Recommended severity | **P2**. Policy refuses TAFE outside the pilot. A discovery gap on the international site is recorded. |

### Recommendation

Lower IQ-00242, IQ-00243 and IQ-00244 to P2 through the governed process, keeping their history. None demonstrates a missing internationally eligible scholarship that the platform could admit today. The P1 came from the `zero` disposition (root cause `sch_policy_reported_as_zero`).

The three underlying gaps are recorded for the decision pack:

- MIT and Unitec identity;
- TAFE Queensland's international source;
- AFTRS below the course minimum.

## 4. Query log (Sydney time, all read only)

| Time | What |
|---|---|
| 08:36 | Mandate read; no query in 08:35–08:42 |
| 08:43:11 | Classify runs, function md5, scope, states, settings |
| 08:43:24 | Pick-order positions of repeated-address listing providers (listing pages only) |
| 08:43:37 | Cases for the repeated addresses of listings 4, 5, 43, 45 |
| 08:43:48 | Published-verified integrity, admissions since 08:29, switches, work items |
| 08:43:56 | IQ-00215/216/219/239/241/242/243/244 |
| 08:44:08 | Six providers: type, admission, discovery, candidates, register, listings |
| 08:44:19 | AFTRS, MIT/Unitec, TAFE Queensland candidates with AI verdicts |
| 08:44:4x | `layer4_interventions` shape (first attempt failed on a column name), intervention functions and har settings |
| 08:44:56 | Interventions by lane and class |
| 08:45:02 | `har_sch_generate_v1` definition |
| 08:45:12 | Pick-order positions of the six providers |
| 08:49:0x | Remedy runs and issue events (first attempt failed on a column name) |
| 08:49:16 | Remedy runs, IQ-00239/241 events, work_blocked issues |
| 09:43:12 | 09:29 run, states, admissions, publications, IQ-00239, interventions |
| 09:43:24 | Provider states; Torrens, TAFE SA and TAFE Queensland cases |

No query ran in 08:35–08:42 or 08:47–08:48. All were light (single providers or small tables), except the two pick-order queries, which scan the 2,560-row coverage ledger.
