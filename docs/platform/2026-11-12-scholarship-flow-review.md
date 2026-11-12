# Scholarship admission flow: review and engineering gaps (12 November 2026)

Change control: CF-CHG-20260915-247, item F-SCH.01 (Pilot #1051, worker coverage-sweep v0.75.0, migration `20261113030000`). All figures are live readings from Supabase project `fxcwkweaxjtknorudmwp`, taken 12 Nov 2026 between 09:30 and 10:40 AEDT, read only.

**Status (12 Nov 2026 12:45 AEDT):** Pilot #1051 (reader and flow guard), #1056 (decisions 2–5 activated) and #1057 (stricter proof after the first shadow review) are merged and deployed, all verified against live. The reader is in shadow, and live processing waits on a passing validation.

## Summary

Scholarships are admitted slowly, and some providers and scholarships are missing. The cause is not a broken job. It is four gaps in the design:

1. **Recovery was built and then left switched off.** Every scholarship job reports success each run, but most of the recovery work has no switch turned on, so the jobs often have nothing to do. Admission comes in bursts: some days nothing is found or admitted at all.
2. **There's no reader for the most common reason for refusal.** 2,226 scholarships are refused only because the first read found no sentence saying international students may apply. For 1,870 of them, no eligibility text was captured at all. The platform sends these to a person instead of reading them again.
3. **The Layer 4 lane is a fixed-size waiting room.** The people lane for scholarship coverage is capped at 150 open items, and it's full. Everything beyond the cap waits with no owner and no reader.
4. **Scope rules contradict coverage reporting.** 180 providers are reported as "unresolved, source not discovered", yet discovery permanently refuses them under the 30-course minimum. No job can ever move them.

F-SCH.01 adds the missing reader, routes cases to people only after that reader has come back silent, corrects a false stop in the pilot report, and adds an hourly flow guard. The guard raises one issue per cause, so a stall is visible on the admin UI the same day.

## What was measured

| Measure | Value |
|---|---|
| Scholarships published (active) | 1,200 across 65 providers |
| Scholarships active but unpublished | 397 across 67 providers |
| Coverage cases, unresolved | 3,523 (international eligibility 2,226; listing traversal 472; admitted not published 342; found but unread 286; awaiting Layer 4 122; source not discovered 31; ownership 22; rejected incorrectly 22) |
| Providers fully resolved with published scholarships | 1 of 2,561 classified |
| Layer 4 scholarship coverage lane | 150 open of a 150 cap (144 eligibility, 6 ownership) |
| Layer 4 scholarship value lane | 150 open of a 150 cap |
| AI reviews pending | 197 (106 are "the page could not be read") |
| Days with no scholarship found or admitted (last 14) | 5 (31 Oct, 1 Nov, 4–6 Nov) |
| Scholarship AI spend | under US$1 a day |
| Scholarship Firecrawl | peak 1,146 credits a day; monthly cap 60,000; no lane hold |

## Why admission is slow

The scholarship jobs run on schedule and succeed. But the recovery work that would feed them was built (v2.15.460, "bounded recovery built, switched off") and never switched on:

| Switch | Work waiting |
|---|---|
| `sch_cov.recover_listings_on` | 144 listing pages found and never read; 472 listing cases not traversed |
| `sch_cov.recover_register_pages_on` | 19 register pages never read |
| `sch_cov.recover_stored_reads_on` | refused pages that could be re-read from their stored copy |
| `retry.scholarship_transient_recover_on` | 68 Layer 4 items that are only a failed page read |
| `har.ai_escalate_on` (and no escalation model set) | the stronger-model attempt before a person |

These are the same switches the 4 November throughput reconciliation (`docs/platform/2026-11-04-scholarship-throughput-reconciliation.md`, §2) listed as waiting on a Platform Admin decision. Eight days later they're unchanged, because nothing on the platform raised the waiting decision again. The flow guard now does.

Discovery itself is mostly idle. 1,293 providers are settled as "not eligible", and the remaining mapped or empty providers aren't due again for up to 30 days. So when there's no recovery work either, nothing happens.

## Why providers are missing

- **The 30-course minimum.** Discovery refuses an Australian provider with fewer than 30 active courses (`scholarship_min_courses`). 1,293 providers are refused this way. An evidence-based legitimacy check exists to replace the minimum and is switched on, but it only applies to the 8 pilot providers, because `scholarship.pilot_only` is still on.
- **Pilot-only admission for non-universities.** 276 New Zealand and 30 Canadian non-university providers are in discovery, but their scholarships are refused under the pilot-only rule. 630 eligibility cases belong to these providers.
- **A dead-end state.** 180 of the course-minimum providers are reported as "source not discovered" (unresolved), and 170 of them already have scholarship pages found. No job acts on that state for a provider discovery refuses. Including other scope refusals, the guard counts more such providers. The coverage switch that would report them as blocked by policy (`sch_cov.policy_disposition_on`) is off.
- **Canada is an upstream gap, not a scholarship gap.** Only 52 of 1,130 active Canadian providers have any active course, and all 52 are already in scholarship discovery.

The pilot's two stop flags were measurement errors, not admission errors. Seven Engineering Institute of Technology records were admitted on 2 Nov from a good page snapshot. A later re-read replaced their page facts, and the publication review withdrew them. Two International College of Management scholarships are open to international *and* domestic students, which the report counted as unsupported. With the corrected measure, no pilot provider stops.

## Why items park in Layer 4

The coverage classifier marks a scholarship "international eligibility unresolved" when the AI called the page a scholarship but no sentence proved international students may apply. Human-assisted recovery (`har_sch_generate_v1`) then raises it for a person, treating the first AI read as the only automated attempt.

There was no second, narrower read for these cases. The existing re-check reader (worker mode `scholarship_recheck`) only reads items already in the human review queue. Once the lane reached its cap of 150, the remaining ~2,080 cases had neither a person nor a reader. Most of them need a reader, not a person: in 1,870 cases the first read captured no eligibility text at all.

The same pattern holds for the value lane: 261 admitted scholarships wait unpublished for "no stated award value", and that lane is also full at 150.

## Other gaps found

- 22,133 AI queue rows are marked failed as "directory site", about 10 for each of 2,326 candidates, between 13 Oct and 2 Nov. The gate now stops these, but the rows remain. This is a housekeeping item.
- A re-read of an admitted scholarship page replaces its page facts. If eligibility was proven elsewhere (for example on a linked terms page), a later re-read can drop that proof and lead to withdrawal. This is a known limitation of F-SCH.01; it is not fixed here.
- The OpenRouter ceiling is in observe mode, so it refuses nothing today. If it is switched to stop, field enrichment alone (US$16 today against a US$14 ceiling) would block scholarship reading for the rest of the day. The scholarship lane needs a reserved share before that switch is made.
- The platform raises dozens of per-provider "zero scholarships" issues. They describe symptoms and don't name a cause, so they don't lead to action. The flow guard raises cause-level issues instead.

## What F-SCH.01 builds

1. **Eligibility reader** (worker v0.75.0, mode `scholarship_eligibility`; job `scholarship-eligibility`, every 10 minutes). For each case refused only because international eligibility isn't stated:
   - It reads the stored page again with the narrow question "who may apply?", using the pinned first model (about US$0.0003 a page).
   - If the page is silent, it reads one page the scholarship links to for its eligibility or conditions on the same site (one Firecrawl credit through the scholarship share).
   - A sentence counts only if it appears on the page it was read from and names international or domestic students in words.
2. **A rule for the reader's answers**, shadow first. While shadowing, it only records what it would do. Once switched to live:
   - "Domestic only" proven: the case is resolved as domestic only.
   - International (or both) proven on the provider's own site, where that was the only refusal: the page goes back through the existing admission rule, which checks every other rule again.
   - Still silent: the case may go to a person.
3. **Layer 4 routing.** While the reader is on, an eligibility case goes to a person only after the reader has read it and found nothing.
4. **Pilot report.** "International and domestic" counts as open to international students. A record withdrawn by a later check isn't counted as an unsupported admission.
5. **Flow guard** (job `scholarship-flow-guard`, hourly; on). It raises one integration issue per cause, each with its numbers and the setting or owner that clears it, and clears the issue when the cause is gone. The causes:
   - a Layer 4 lane is full while cases wait
   - a built recovery is switched off while work waits
   - a coverage state is one no job can move
   - nothing has been found or admitted for 24 hours
   - cases have been unresolved for more than 7 days

Spend controls are unchanged. Reader cost goes to the AI spend ledger (lane `scholarship_ai`) and is stopped by the existing credit floor, daily ceiling and lane guard. Firecrawl goes through the scholarship share. The consumer API is untouched. Nothing is dropped.

## Findings after activation

- **Shadow review (first 200 reads):** 194 pages were silent. The model read "both" from enrolment conditions on 150 pages, and the proof correctly refused these. Of 5 international proofs, 2 were course names ("Master of International Business"), so the proof was tightened in worker v0.76.0 before anything was acted on.
- **Firecrawl share:** scholarships get 800 Firecrawl credits per Sydney day, out of a 4,000 platform total. The share was used up by 12:30, after which every scholarship read waits until midnight. This is a main cause of the bursty admission pattern, and it now caps the widened scope.

## Decisions for the Platform Admin

| # | Decision | Effect | Cost |
|---|---|---|---|
| 1 | Turn on the eligibility reader in shadow (`sch_elig.on` = 1) | 1,604 cases at 66 admission-eligible providers are read; results recorded, nothing changes | about US$0.50 AI; up to about 1,600 Firecrawl credits for linked pages, spread over days |
| 2 | After reviewing the shadow results, act on proven sentences (`sch_elig.apply_on` = 1) | proven cases admitted through the existing rule, or resolved as domestic only | none extra |
| 3 | Policy for scholarships still silent after the reader (`sch_elig.silent_resolves`) | resolved as "not proven for international students", or kept for a person | none |
| 4 | Switch on the built recoveries (listings, register pages, stored re-reads, transient retries) | the 144 listings, 19 register pages and 68 failed reads move without a person | small Firecrawl and AI spend within existing caps |
| 5 | Scholarship scope: end pilot-only for non-universities, and replace the 30-course minimum with the legitimacy check | up to about 1,500 more providers searched; 630 eligibility cases become admissible | larger; staged widening recommended |
| 6 | Torrens name rule (`sch_cov.legal_name_identity_on`) | Torrens University becomes admission-eligible (14 scholarships listed, none held) | none |
| 7 | Value lane: how to treat scholarships with no stated value | 261 admitted scholarships waiting to publish | none |

## What is not claimed

- No gain in admissions or publications is claimed until shadow results have been reviewed and the action is switched on.
- The linked-page reader's accuracy is not yet measured; that's what shadow is for.
- The flow guard reports causes. It doesn't switch anything on itself, in line with "a passing qualification never switches anything on by itself".
