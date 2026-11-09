# AU stalled fields: interpretation and recovery plan

Date: 27 October 2026, 05:24 AEDT.
Change control: CF-CHG-20260915-247.
Scope: interpretation of the Coverage & completeness screenshot and a recovery plan. No live data, setting or job was changed by this review.

## 1 Short answer

The screen is broadly correct about the size of the gaps, but **“top universities are missing all this info” is not the right interpretation**.

Each number is the count of active catalogue courses missing one admitted field. It is not the number of courses missing everything, and the same course can appear in several fields. “Pages read do not state it” also does not mean the university publishes the value nowhere: fees, intakes and English are often on provider-level schedules or policies rather than on every course page.

The large universities appear at the top partly because they have the most active register courses. The current lists show absolute missing-course counts, not each provider's missing rate or recoverable opportunity.

The right plan is therefore not “read more course pages”. It is:

1. verify the measurement and the intake regression;
2. complete the morning's governed unblocks;
3. recover each field from its correct source;
4. prioritise providers by recoverable courses and evidence, not prestige;
5. measure admitted values and accuracy, not reads.

## 2 What the screen gets right, and what needs qualification

The current coverage arithmetic agrees with the live daily snapshots: 26,103 active AU courses; 18,622 official pages (71.3%); 8,454 live international tuition values (32.4%); 9,391 intake values (36.0%); 16,917 English values (64.8%).

The “stalled” label follows the screen's broad rule: below target and moving by less than one point, falling, trailing another country, or having no reader. That makes it a useful attention list, but it mixes different operational states.

| Field | Seven-day evidence | Interpretation |
|---|---|---|
| Provider tuition | 8,244 → 8,454 admitted: **+210**, about +0.8 points | Improving, but below the screen's one-point movement threshold. The immediate fee queue is now drained, so further growth needs the named source/target-list actions. |
| English | 16,809 → 16,917: **+108**, about +0.4 points | Improving slowly. The next gains are mainly level-aware central policies and page/identity repair. |
| Official course page | 18,608 → 18,622: **+14** | Effectively flat. Binding remains the ceiling for every page-derived field. |
| Intakes | 9,987 → 9,391: **−596 admitted**, with the denominator unchanged at 26,103 | **A real coverage regression, not merely a stall or denominator effect.** Find which values were retired, superseded, reclassified or otherwise removed before simply acquiring more. |
| Delivery | The screen shows 72.6% → 63.5% (−9.1 points) | Verify the comparison lineage before acting on the decline. The 19 October `course_coverage_daily_by_country` rows do not contain `delivery`, while the 26 October rows do. This may be a history/attribute issue, not proof that 9.1 points of values were lost. |
| Academic entry | 0 admitted; reader in pilot | “No reader yet” is now misleading. A reader and strong completeness controls exist, but there are no active admissions and RMIT is paused for D1. Show “pilot / no admitted values”, not “nothing exists”. |
| Application deadline | 0; no reader | A genuine build gap. Do not substitute intake months for application deadlines. |
| Provider and course descriptions | 0% and 0.6% | Separate build gaps. The provider-description reader is in draft; a course-description reader is not the same thing. |

The no-reader rows also still show an 80% target even though the screen's own resolution text says to set the target to zero until a reader exists. Separate **not built**, **pilot**, **no admitted values** and **operationally stalled** rather than presenting them all as the same red condition.

## 3 First: measurement and regression checks

### Intake regression

Before the calendar push, reconcile the 596-course reduction between 19 and 26 October:

- which courses lost an admitted intake;
- whether they were retired, superseded, re-yeared, reclassified, had their identity basis changed, or were removed by a register or adapter path;
- whether the loss is legitimate or a write-path defect;
- the provider, writer and reason distribution.

Acceptance: every one of the 596 has a named explanation, any defective writer is stopped, and legitimate current values are restored through the normal admission path. Do not hide the decline by changing the denominator.

### Delivery comparison

Trace the screen's seven-day baseline to its real source. Confirm whether an attribute rename or missing historical snapshot causes the 72.6% comparison. Report numerator and denominator alongside the percentage.

### Provider lists

Add two interpretations to the existing workbook/reporting, not a new panel:

- missing count and missing rate per provider;
- recoverable count by cause and available source.

A university with 655 missing fees out of a large catalogue may be a better or worse opportunity than a smaller provider with 200 missing fees; absolute count alone cannot decide.

## 4 Immediate governed unblocks

1. Complete the 08:00 actions in their recorded order: **retirements → publish → fee re-apply**, with count verification after each. These remain separate Platform Admin actions.
2. Do not use **Release holds and fill** as a blanket first response. Use it only after the relevant central page, adapter rule or reader has changed; otherwise it spends on the same missing evidence.
3. For the 110 `target_list_refused` AU fee-schedule pages, prepare a provider-level, evidence-backed and count-guarded override proposal. Include rule-failure reasons, affected pages/courses and expected credit cost. Do not bulk-add them merely because they are the remaining fee source.
4. Triage the 68 older `found` fee-schedule rows and settle the one fee-reader item stuck at its attempt limit. These are small, named queue actions, not a new lane.

## 5 Field-by-field recovery plan

### A. Official course page — fix the ceiling first where a page exists

Latest causes include 1,368 with no search/AI match, 1,031 fetch failures, 298 needing render, 296 recorded as no page published, 257 blocked, 220 queued, 109 provider-site failures, 78 robots refusals, 31 stopped searches and 13 conjoint cases.

Plan:

- search/map/match only where provider evidence suggests a page exists;
- finish the redirect and near-twin Defect 1 work so wrong pages are rejected earlier;
- use the no-page and conjoint first runs to stop unbindable register entries consuming searches;
- repair fetch/render/site failures separately from genuine no-page cases;
- report both bound % and resolved % (bound plus verified no-page/conjoint outcomes), without deleting courses.

Acceptance: correct-page rate stays at or above the 60% gate, and movement comes from verified pages or honest gap classification, not relaxed identity.

### B. Provider tuition — provider schedules, then course-page residue

The current fee-schedule wave is drained: 284 found pages processed, 167 read and 117 failed; 110 failures are target-list refusals. This is not an active lane stall.

Plan:

1. apply and verify the fee re-apply paste;
2. decide the evidence-backed target-list proposal;
3. process the 68 older found rows and the stuck item;
4. for Sydney, Macquarie, UNSW and the other high-gap providers, inventory the current fee schedule and course-matching coverage before requesting more reads;
5. measure schedule rows matched to the right course, year and identity, not pages fetched.

Acceptance: new live fees pass the universal tuition identity gate; unmatched/ambiguous rows stay held; each provider reports found → read → matched → admitted → completed-course counts.

### C. Intakes — regression first, then level-aware calendars

Latest causes show that course pages alone cannot solve this: 1,961 courses have an approved university calendar that does not cover their level; 479 have a calendar giving no values; 312 have no calendar found; only nine are waiting on a calendar approval in this snapshot.

Plan:

1. reconcile the 596-value regression;
2. return the AU top-20 calendar MARK-FILE, approving only current, quoted and level-compatible rules;
3. for Sydney, ANU, Macquarie, Newcastle and Monash, check whether the right calendar exists and whether its study-level mapping is the actual blocker;
4. use course pages for course-specific dates, not a fabricated provider default;
5. leave stale calendars and incompatible rules rejected.

Acceptance: no unexplained intake regression; each approved rule names its source, year and covered levels; report courses filled by level, not calendar pages read.

### D. Delivery — fix binding and evidence, not a new reader

The existing classification of 3,390 eligible-provider `not_on_page` rows is:

- 2,305 (68%) need the right/allowed course page first;
- 752 (22%) are judged genuinely silent;
- 333 (10%) are recoverable quote/JSON failures.

Plan:

1. let the page/identity lanes address the 68% after publishing;
2. hand-check a 20-page sample of the supposed silent pages before declaring that source exhausted;
3. tune quote matching for the 10% where justified; the existing decision says this is below the 20% automatic re-run threshold, so do not rerun the whole cohort blindly;
4. do not infer “on campus” from CRICOS locations without a separate Platform Admin rule decision.

Acceptance: delivery gains carry quote-on-page evidence and the correct course identity. No new delivery reader is needed for the classified problem.

### E. English — central policy coverage by study level

The largest named gap is 1,140 courses where an approved university rule does not cover the course's level. A further 268 have no central rule found and 93 have a central rule giving no values.

Plan:

- inspect policy coverage by provider and study level before more course-page reads;
- attach the correct current English policy where missing;
- use the MARK-FILE for evidenced decisions, including rejection of rules contradicted by course pages;
- keep page/identity repair running for the 520 no-match and other page causes;
- prioritise UNSW, Melbourne, Flinders, Wollongong and Bond by recoverable courses after the source inventory.

Acceptance: each default is quoted, current and applicable to the course's level; disagreement checks remain enforced.

### F. Academic entry — finish the pilot before scaling

The reader exists but has zero active rows. UTS and WSU are enabled; RMIT is paused for D1; VU and Federation wait for PDF support.

Plan:

1. finish D1–D3 under their explicit approval and keep incomplete runs unapprovable;
2. reconcile every pilot page against its source table before admitting;
3. review the complete UTS/RMIT outputs and measure accuracy, not just extraction counts;
4. only then widen beyond the pilot;
5. treat the PDF reader as a separate authorised build for VU, Federation and WSU's linked table.

Acceptance: complete source-table parity, distinct row identity, quote-on-page and no silent omissions. Replace the UI's “No reader yet” wording with the real pilot state.

### G. Application deadline — source audit, then a separate reader

No reader exists. Audit how top providers publish application deadlines: course page, central dates page, intake-specific table or PDF. Specify the source and quote rules before code. Do not reuse intake start months as deadlines and do not let the entry-matrix reader silently admit deadlines under a different meaning.

### H. Descriptions — keep provider and course work separate

- Provider description: finish the existing draft, run the Wollongong no-superlatives/quote acceptance test and hand-verify five descriptions before activation.
- Course description: specify and build its own course-page reader with length, evidence and manual-lock rules. The existing 163 descriptions are not evidence of an operating reader.

Neither should block the fee, intake and binding recovery already available.

## 6 Provider order: source packs, not “top university means everything is absent”

Start with **Sydney, UNSW, Macquarie, ANU and Melbourne**, with Monash next, because they recur across the largest absolute gaps. For each provider, complete one existing-workbook source inventory:

| Source | Questions |
|---|---|
| Course inventory and official pages | Which register courses are currently advertised? Which are conjoint, discontinued or no-page? |
| Fee schedule | Current year? Course coverage? Matching keys? Target-list status? |
| Calendar | Current year? Study levels covered? Course-specific exceptions? |
| English policy | Current? Levels covered? Does it agree with course pages? |
| Entry requirements | HTML table or PDF? Country/qualification structure? Complete extraction possible? |
| Delivery evidence | On the correct course page, or genuinely silent? |
| About/course content | Suitable evidence for provider or course descriptions? |

Then execute the cheapest verified recovery first across all fields for that provider. This avoids five separate teams rereading the same university for five different fields.

## 7 Reporting and Thursday gates

Report per field and provider:

- admitted numerator and active-course denominator;
- seven-day numerator change, with regressions explained;
- recoverable courses by cause;
- source pages found/read, rows matched, values admitted and courses completed;
- review queue and oldest wait;
- correct-page/quote/identity failures;
- cost per admitted value.

Do not promise 80% across every field this week. Keep 80% as a longer-term coverage target where the source exists, use zero/not-built or pilot status where there is no operating reader, and judge Thursday by verified lane movement plus zero unexplained blocked rows.

## 8 Recommended sequence

1. Intake regression and delivery-baseline checks.
2. Retirements → publish → fee re-apply, with verification.
3. Top-five provider source inventories and calendar/policy marks.
4. Evidence-backed decision for the 110 target-list pages; clear the 68 old schedules and one stuck item.
5. Binding/identity recovery and level-aware calendar/English fills.
6. RMIT D1–D3 and entry pilot acceptance; no wider rollout before accuracy passes.
7. Delivery quote/sample work; then the separate deadline and description builds.
8. Thursday re-run using admitted values, named causes and accuracy, not read volume.
