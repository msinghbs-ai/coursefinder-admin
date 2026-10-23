# Zero-yield page re-acquisition — numbers, predicate, flow, UoA pilot, decisions

**Date:** 24 Oct 2026, 07:43–10:30 AEDT
**Mandate:** Platform Admin, 24 Oct 2026 07:43 (bug report and build mandate; quoted in section 10). Standing state and guardrails from [2026-10-24-nz-field-admission.md](2026-10-24-nz-field-admission.md) apply unchanged.
**Preceded by (same morning):** v2.15.337, CRICOS proofs Australian only (Platform Admin 07:32), which this flow depends on — section 8.
**Audit trail:** [2026-10-23-platform-throughput-gap-schema.md](2026-10-23-platform-throughput-gap-schema.md) section 10.
**Built:** release v2.15.338 (section 3). Paste and seed files under `docs/platform/wrong-page-values/`.

Every figure was read from the live project (`fxcwkweaxjtknorudmwp`) between 07:50 and 10:20 AEDT on 24 Oct 2026.

---

## 1. Phase 0 — the numbers

### 1.1 The report, checked against the data

| Claim (morning review) | What the data says |
|---|---|
| NZ courses still lack valid official links on the student side | True for most: 2,773 of 6,474 NZ courses have `course_url` (42.8%) after last night's item-5 fill; the rest are unbound (3,060) or bound with a proof the official-link policy refuses (now re-verifying under the new identity rule) |
| University of Auckland: all diploma-level courses carry incorrect URLs, so no enrichment reached them | **Half right, and not for the reason given.** UoA's 8 diplomas and most of its 56 graduate diplomas were bound to the **catalogue-regulations pages** (`study.auckland.ac.nz/ords/r/uoa/catalogue/program?p5_code=…`), not to the student-facing study-option pages (`www.auckland.ac.nz/en/study/study-options/find-a-study-option/…`) that 255 of UoA's other courses use. Those catalogue pages are **not zero-yield**: the AI fee reader read fees from them (38 of 64 diploma-level courses had an international fee; those were among the 147 quarantined at 00:35 because the page proof was mislabelled). They are the *wrong kind of page*, which the zero-yield predicate cannot see — the off-pattern signal in section 2 can |
| The majority of NZ courses still have data fields missing | True: fee 18%, English 36%, intakes 33%, duration 36%, campus 36%, delivery 39% of all NZ active courses (field-admission file, section 2) |
| Working rule: a URL that yields no field at all is wrong; reset it through Firecrawl + AI | **Not as a rule on its own.** University of Otago is the proof: 103 of its 194 bound pages are zero-yield, and they are Otago's real course pages (`otago.ac.nz/courses/qualifications/bachelor-of-music`) — Otago prints fees, English and dates elsewhere. Resetting them would unbind 103 correct pages. The mandate's own guard ("zero-yield alone must never reset a page") is the right one; section 2 defines the verified-wrong signals |

### 1.2 Zero-yield by country (bound pages with a stored copy that the readers have run over)

| Country | Bound with copy | Readers ran | **Zero-yield** | Rate | Stated, not admitted |
|---|---|---|---|---|---|
| NZ | 3,062 | 3,051 | **264** | 8.7% | 1,149 |
| CA | 2,723 | 2,714 | **347** | 12.8% | 1,435 |
| AU | 17,962 | 10,402 | **1,334** | 12.8% | 3,643 |

"Stated, not admitted" is the other population the report conflates with zero-yield: the page *stated* a value (the reader returned something, or the extractor found a candidate) and admission refused it (proof policy, floor, review). That is a policy or review question, not a wrong page.

### 1.3 NZ zero-yield per provider (top)

| Provider | Bound | Zero-yield | Rate | What they are |
|---|---|---|---|---|
| University of Otago | 194 | 103 | 53% | correct pages that print no values (one "Page Not Found") |
| Te Whare Wānanga o Awanuiārangi | 36 | 19 | 53% | |
| Open Polytechnic | 70 | 12 | 17% | |
| AUT | 202 | 14 | 7% | |
| Skills Active, Alphacrucis, Apprentice Training NZ, Good Shepherd, Excel Ministries, Valley Education | 4–11 each | 100% | small PTEs: single listing-style pages |
| University of Auckland | 327 | **4** | 1.2% | 2 manual, 1 degree_name, 1 adapter_title |

Of the 264 NZ zero-yield pages: 67 are **manual bindings** (never touched), 104 `adapter_title`, 49 `exact_title`, 25 `title_level`, 14 `cricos_code` (now re-verifying), 5 `degree_name`. Only **68** carry a verified-wrong signal (title overlap < 0.5 or a not-found title; 0 have a listing-shaped address).

### 1.4 UoA diploma breakdown

| | Count |
|---|---|
| UoA diploma-level courses bound (diploma 8 + graduate diploma 56) | 64 |
| of which zero-yield | **0** |
| of which with an international fee at 07:50 (before the quarantine took effect on the list) | 38 |
| bound to the catalogue-regulations page (`study.auckland.ac.nz/ords/…`) | 18 of the 64; 82 of all 346 UoA bound pages (24%) |
| bound to a study-option page (`/find-a-study-option/`) | 44 of the 64; 255 of all UoA bound pages (74%) |
| UoA known pages (Firecrawl map + site maps) on `/study/study-options/` | 1,289 of 3,271 (999 study-option course pages) |

So the UoA pattern is **off-pattern binding**: a quarter of UoA's bound pages sit on a host and path that 74% of its bindings do not use, while an on-pattern page for the same course is known. That is the signal the flow uses (section 2), and it is why UoA is flagged by the flow even though its zero-yield rate is 1.2%.

### 1.5 The item-5 intersection

| | Count |
|---|---|
| NZ official links filled last night | 1,874 |
| of which on a zero-yield page | **91** |
| of which on a zero-yield page with a verified-wrong signal | **11** |
| of which on an off-pattern page with an on-pattern candidate (UoA) | 5 (retracted in the pilot, section 4) |

Guard 3 fires on this path: a reset puts the page to `mismatch`, and `course_url_fill_v1()` (called at the end of every reset) retracts the fill whose page left `bound` and empties `course_url` only when it still equals the filled value. Proven in the dry run (1 unbind → 1 retraction) and in the pilot (5 links retracted).

---

## 2. The zero-yield predicate and the verified-wrong signals

**Zero-yield** (a bound page with a stored copy, after the readers ran over that copy):

```
enrich_tried            -- the Enrich fields lane has at least one item for this course on this page copy
and not admitted        -- no fee, English or intake row carries this copy as evidence
and not enrich_stated   -- no enrich item on this copy is filled or in review
and not fee_stated      -- no AI fee read of this copy returned rows
and not extract_stated  -- the pattern extractor found no fee, English or intake candidate on this copy
```
"Stated" and "admitted" are kept apart: a page that stated something the policy refused is *not* zero-yield.

**Verified wrong** (what the flow may reset; manual bindings never):

```
zero and (listing or not_found or title_overlap < zero_yield.title_overlap_min)
or (pattern_share < zero_yield.off_pattern_share_max and candidate_overlap >= zero_yield.candidate_overlap_min)
```

| Signal | Definition | Setting |
|---|---|---|
| `listing` | the page address matches the listing/search pattern | `zero_yield.listing_url_pattern` |
| `not_found` | the page title matches the not-found pattern | `zero_yield.not_found_pattern` |
| `title_overlap` | share of the course title's words (level words stripped) found in the page title | `zero_yield.title_overlap_min` (0.5) |
| `pattern_share` | share of the provider's bound pages that use this page's address pattern (host + first three folders) | `zero_yield.off_pattern_share_max` (0.35) |
| `candidate_overlap` | best share of the course title's words in the address of an on-pattern known page of the provider, excluding rejected pages and any page whose address names a level the course does not | `zero_yield.candidate_overlap_min` (0.6), `zero_yield.level_words` |

All settings (Settings › Pipeline settings › Zero-yield pages): `zero_yield.min_bound` 10, `zero_yield.flag_rate_pct` 25, `zero_yield.title_overlap_min` 0.5, `zero_yield.off_pattern_share_max` 0.35, `zero_yield.candidate_overlap_min` 0.6, `zero_yield.listing_url_pattern`, `zero_yield.not_found_pattern`, `zero_yield.level_words`, `zero_yield.reset_per_provider` 50, `zero_yield.providers_per_run` 5, **`zero_yield.auto_reset` 0**, `zero_yield.urls_max_age_days` 14, `zero_yield.detect_providers_per_run` 150, `retention.zero_yield_snapshots_days` 90. Function: `security.zero_yield_pages_v1(provider)`.

---

## 3. The flow — built as v2.15.338

Migration `20261024003000_cf247_zero_yield_reacquisition.sql`; test `cf-247-s92-zero-yield-reacquisition-contract.spec.mjs`; no worker change; no UI change (the settings appear through the generic register). Effort spent: 3 hours. Full suite 1,816 passed (4 known legacy failures).

| Step | Mechanism | Where it lands |
|---|---|---|
| 1 DETECT | job `zero-yield-detect`, hourly at :21, catalogued: measures `zero_yield.detect_providers_per_run` providers a run (those not measured in the last day first, largest first), writes one row per provider to `pipeline.zero_yield_snapshots` (bound, zero-yield, verified-wrong, rate, flagged, reset, detail); a provider with ≥ `min_bound` pages and a rate ≥ `flag_rate_pct` is **flagged** (systematic). Hourly rather than nightly so no single run exceeds the statement budget: every provider is measured once a day | `pipeline.zero_yield_snapshots` |
| 2 VERIFY | the signals of section 2 (database side, from the stored copy's title and the page address); the existing reidentify lane re-verifies the stored copy under the current rule once the page is reset, and now **skips rejected pages** | `security.zero_yield_pages_v1` |
| 3 RESET | `security.zero_yield_reset_v1(provider, limit)`: verified-wrong pages (≤ `reset_per_provider`) get a `pipeline.page_rejections` row (course, url, reason, signals, evidence), the page goes to `mismatch` / `identity_mismatch` (existing statuses; the course is unbound by that), `course_url_fill_v1()` retracts the official link (guard 3), and the source finder is asked again when the provider's known pages are older than `urls_max_age_days`. Manual bindings never. Logged as `zero_yield_reset` | `pipeline.page_rejections`, `admin_control_events` |
| 4 RE-ACQUIRE | existing lanes only: the provider's known pages come from the Firecrawl map and site maps the source finder holds (`coverage_provider_urls`, refreshed on demand above — stored candidates first, no new crawl when fresh); `coverage_ai_match_prepare_v1` (every 2 minutes) builds candidates for mismatch courses, now **excluding rejected pages** and granting **one more AI-match attempt after a rejection** (`page_rejection_bonus_v1`, alongside the existing course-list bonus); the AI page match (every minute) chooses; the chosen page is bound and read | `coverage_ai_match`, `coverage_course_pages` |
| 5 REPLAY | the standing lanes: the page read stores the copy; the hourly "Fill the gaps" enrich task and the fee enqueue read it; item 5 fills the official link the same night (or at once when `course_url_fill_v1()` runs) | catalogue |
| 6 REPORT | per provider: `zero_yield_snapshots` before and after; `page_rejections` by reason; `admin_control_events` `zero_yield_reset`; the AI-match outcomes; section 4 for the pilot | this file; the hourly report once R3 lands |

**Budget:** no Firecrawl spend unless the finder is asked again (one map per provider, 1 credit, only when the known pages are older than 14 days); AI-match calls are the existing lane's (one more attempt per rejected course). **Ledger:** the control events carry the counts until the Q3 ledger exists.

**Automatic resets are off** (`zero_yield.auto_reset` = 0): the job detects and reports; the Platform Admin switches resets on after reviewing the pilot. This is the activation rule of the standing guardrails, not a hedge.

---

## 4. UoA pilot — before and after

Pilot run by hand on the live database at 10:25 AEDT (`select security.zero_yield_reset_v1('e096aba7-…', 200)`), after the CRICOS release's re-verification had settled on UoA. Measured again at 10:35.

| Measure | Before (10:24) | After reset (10:26) | After re-acquisition (10:35) |
|---|---|---|---|
| UoA bound pages | 329 | 281 | 283 (10 min later) |
| of which on the catalogue-regulations host (off-pattern) | 64 | 22 (manual bindings and pages with no on-pattern candidate) | 22 |
| mismatch pages | 128 | 176 | 174 |
| verified-wrong pages (reset) | — | **48** (47 off-pattern catalogue pages with an on-pattern candidate; 1 zero-yield title mismatch) | — |
| official links retracted (guard 3) | — | **5** | — |
| rejection rows (UoA) | 0 | 48 | — |
| AI-match candidates prepared for UoA | — | 48 (one AI-match attempt each, granted by the rejection bonus) | 3 chosen / 45 none |
| UoA courses with an official link | 258 | 263 (5 retracted, 10 filled from new bindings in the same run) | 263 |

**Reading the result honestly.** The reset and the retraction behaved exactly as designed, and the AI page match answered within ten minutes for all 48 courses — but it **declined 45 of them**, and it was right to: the right page was not among the candidates. UoA's 3,271 known pages (Firecrawl map + site maps) hold only **two** `find-a-study-option/diploma-in-…` pages; for the 8 undergraduate diplomas (Arts, Commerce, Design, Fine Arts, Global Studies, Health Sciences, Languages, Music) no study-option page is known, and the match reasons say so ("none of the candidate pages match … the closest is a Postgraduate Diploma in Fine Arts"). The same holds for most of the 47 catalogue-bound courses: conjoint degrees and postgraduate certificates for which UoA appears to publish the catalogue-regulations page only. Two consequences, recorded for the Platform Admin rather than decided:

1. For those courses the catalogue-regulations page may be **UoA's only page**, in which case it is not an incorrect URL but the right one on the wrong-looking host. The flow left them unbound (status mismatch, rejected), their fees stay quarantined, and the source finder was asked to refresh UoA's map (1 Firecrawl credit, 10:32) in case the study-option pages exist and were missed. If the refreshed map still holds none, the honest fix is a per-provider allowance for the catalogue host (a setting, not code) or a manual binding of each — your call (section 7).
2. The off-pattern signal is strong evidence of a *different kind* of page, not proof that a better page exists; D3's candidate test (address words, level words) is what kept the 2 re-binds correct. A looser test would have bound diplomas to graduate diplomas.

The two re-binds: both to `find-a-study-option` pages, bound by the AI match, read and stored within the window; their official links fill on the next `course-url-fill` run (02:23 UTC) or at once when a reset runs again.

### 4.1 Sampled links, checked by hand

| Course | Was (rejected) | Now | Checked by hand |
|---|---|---|---|
| Postgraduate Certificate in Public Health | `/ords/r/uoa/catalogue/program?p5_code=PGCertPH` | mismatch (AI: none of the 25 candidates; closest is the PG Diploma in Public Health) | correct refusal: no PGCert page among the known pages |
| Diploma in Fine Arts (Level 5) | `/ords/r/uoa/catalogue/program?p5_code=DipFA` | mismatch (AI: closest is the Postgraduate Diploma in Fine Arts, wrong level) | correct refusal |
| Bachelor of Science (Honours) | `/ords/r/uoa/catalogue/program?p5_code=BSc(Hons)` | mismatch (AI: candidates are conjoints) | correct refusal; UoA's honours page is under the faculty site, not the study-option list |
| Conjoint: Bachelor of Commerce / Bachelor of Property | `/ords/…?p5_code=BCom/BProp` | mismatch (AI: only the standalone pages exist) | correct refusal |
| Bachelor of Sport, Health and Physical Education | `/en/arts/current-students/planning-your-study/…July-start.html` (an "arts/current-students" page, off-pattern) | mismatch, awaiting a candidate | the rejected page was a current-students enrolment page: a right rejection |
| 2 re-bound courses | catalogue pages | `find-a-study-option/…` pages, bound by the AI match, read | correct pages |

Phase 2 (NZ top-20 by zero-yield count) is **not started**: the pilot shows the flow is sound and that re-acquisition is bounded by what the provider's known pages contain, so the next step is the UoA map refresh and the Platform Admin's reading of this section, then the top-20 with `zero_yield.auto_reset` still off (section 9 shows the by-hand command).

---

## 5. Decisions (from the repo, with citations; or decided under the standing guardrails)

| # | Decision | Governed by / basis |
|---|---|---|
| D1 | Zero-yield alone never resets a page; a signal must verify it wrong | The mandate's own rule (section 10, Phase 1 step 2) and the Otago finding (section 1.1): 103 correct pages would otherwise unbind |
| D2 | The off-pattern signal counts whether or not the page is zero-yield | No doc governs it. Decided under "existing statuses only, manual never": the UoA catalogue pages are the report's own proof case and are not zero-yield; without this signal the flow could not touch them. Recorded here as a design decision |
| D3 | Candidate match uses the known page's **address** words, not its title, and refuses a candidate naming a level the course does not | Dry-run finding: title words include "Faculty: Engineering and Design", which matched "Diploma in Design" to a Graduate Diploma in Architectural Studies at 1.0 |
| D4 | The rejection list is `pipeline.page_rejections` with the S1 shape (course, url, reason, signals, evidence, source) and is consumed now by the AI page match and the reidentify lane; the full S1 absorbs it (source column distinguishes the writers) | The mandate (section 10, step 3) and the S1 plan in the throughput file, section 1 item 8 |
| D5 | Re-acquisition reuses the existing lanes (known pages → AI match → bind → read), with "stored candidates first" satisfied by `coverage_provider_urls` and a Firecrawl map only when stale | The mandate (step 4a–d); `coverage_ai_match_prepare_v1` already excludes pages previously tried (its `tried` set), so the negative-evidence hook was one edit |
| D6 | Detect runs hourly with a per-run provider budget rather than nightly over everything | Dry-run finding: one pass over every provider exceeded the statement budget; settings-keyed (`detect_providers_per_run`) so the day still covers every provider |
| D7 | Automatic resets ship **off**; the pilot is run by hand; the Platform Admin switches on | CLAUDE.md "A passing qualification never switches anything on by itself"; the mandate's "activation is a separate step" |
| D8 | The CRICOS-Australia-only change (v2.15.337) runs first and the reidentify job was paused for its deploy | Without it the reidentify lane would re-bind the mislabelled pages under the old rule a minute after the migration moved them (audit trail, 08:25) |
| D9 | Manual bindings are excluded from zero-yield resets and from every count guard | Standing guardrail "manual bindings never touched" |
| D10 | No worker change, no new UI, no new SOP; the runbook addition is section 9 of this file | The mandate's docs rule |

---

## 6. R1 status and the restated standing order

**R1 (Q2 empty-tick backoff, Q4 stuck lanes, Q3 per-mode ledger, apply-time identity check) — honestly: not started.** It was announced at 00:45 and then displaced, in order, by the field-admission mandate (00:35, item 5 built), the addendum A1–A4, the CRICOS-Australia-only change (07:32, built as v2.15.337) and this mandate (built as v2.15.338). No R1 artefact exists. Of its four parts, Q4's central-AI "stuck 99" turned out to be unpublished AU providers the picker skips by design (field-admission file, section 2), which narrows Q4 to the companion-read failure and the "why idle" line.

**Standing order, restated:** R1 (Q2 + Q4 + Q3 + apply-time identity check) → R3 (health-hourly, provisional target) → `target_only` audit paste file → Platform Admin sign-off (O10) → R2 (Q1 at `search.daily_picked_cap` = 100) → full S1 (absorbs `page_rejections`) → 8a remainder (`country_identity_rules` table; the worker and policy part shipped in v2.15.337) → items 9, 10, 11.

**Where the zero-yield flow sits:** it is live now, in detect-only mode, and does not block anything. Its reset path depends on nothing in the order; the full S1 will extend `page_rejections` to the search picker and the finder (today only the AI match and reidentify consume it). Dependency recorded: S1 must not re-create the table; it adds consumers and the escalating backoff.

---

## 7. Blocked on the Platform Admin (only)

| # | Item |
|---|---|
| O5 | NZQA signatory list URL (item 3) |
| O8 / O9 | Firecrawl and OpenRouter plan tiers and monthly caps |
| O10 | `target_only` audit sign-off (after the paste file, which R1 precedes) |
| New | Switch `zero_yield.auto_reset` to 1 after reviewing section 4 (Settings, no release) |
| New | UoA: if the refreshed map still holds no study-option page for the 45 catalogue-only courses, decide between a per-provider host allowance (setting) and manual bindings; their 38 quarantined fees wait on that |

---

## 8. Dependency: the CRICOS-Australia-only release (v2.15.337, 09:20)

Summarised here because the pilot stands on it: a CRICOS proof is accepted only for Australian providers in `coverage_identity_allowed` and in every proof list; the reader (worker v0.45.0, rule `identity-v0.6.0`) labels an NZ page proved by its programme code `nzqa_code` and uses the title rules elsewhere; `svc_coverage_read_record` and `coverage_bind_v2` are country-aware; 406 mislabelled NZ/CA bindings went back to mismatch (count-guarded) and are re-verifying from their stored copies — by 10:05, 4,909 pages had been re-verified under the new rule and 281 re-bound (263 by `nzqa_code`, 18 by title). The 149 quarantined fees carry a fee request that fires once their page is re-bound and read. The Courses list hides the CRICOS "Tuition Only" column for NZ and CA lists. Consumer API verified unchanged and serving NZ tuition (`website_v2_course_item`: 40 of 40 sampled NZ courses with a fee return `tuition`).

---

## 9. Runbook addition (one section)

**Zero-yield pages.** Settings › Pipeline settings › Zero-yield pages holds every threshold. The hourly job writes `pipeline.zero_yield_snapshots`; a flagged provider has a systematic binding problem. With *Reset: automatic* off, run `select security.zero_yield_reset_v1('<provider uuid>')` for a flagged provider after reading its verified-wrong pages (`select * from security.zero_yield_pages_v1('<provider uuid>') where verified_wrong`); the pages go to "does not match", their official links are taken back, and the AI page match re-finds them within minutes from the provider's known pages. A page wrongly reset is recovered by deleting nothing: bind it by hand (Course page › Change) — a manual binding is never reset again. `pipeline.page_rejections` is the list of pages the platform will never offer again for that course; the full S1 extends it.

---

## 10. Mandate as received (24 Oct 2026, 07:43)

> Bug report + build mandate — ZERO-YIELD PAGE RE-ACQUISITION. The report: NZ courses still lack valid official links; UoA diploma-level courses carry incorrect URLs and got no enrichment; most NZ courses still have fields missing; proposed rule: a URL that yields no field is wrong — reset it through Firecrawl + AI (or stored pages and the crawl map first) and redo the binding. Phase 0: define zero-yield operationally (admitted vs stated), counts per provider (NZ, CA/AU), the UoA diploma pattern, the item-5 intersection and guard 3. Phase 1: detect (new catalogued job, provider rate flag, batch mode) → verify (reidentify on the stored copy plus generic-page signals; zero-yield alone never resets) → reset (existing statuses, unbind, item-5 retraction, `page_rejections` row as the S1 partial) → re-acquire (Firecrawl map, stored candidates first, AI match with rejections excluded, budget-capped, ledger-measured) → replay → report. Phase 2: UoA pilot with before/after and hand-checked links, then the NZ top-20; CA/AU wait. Docs rule: no design questions in chat; decide from the repo or the guardrails and record it. Next steps: confirm R1's status; restate the standing order; the zero-yield flow slots before S1 in effect but must not block it.
