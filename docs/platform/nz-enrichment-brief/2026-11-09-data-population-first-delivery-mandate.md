# StudySearch — Data Population First: Provider Descriptions and Valid Intake Dates

> **Update 9 Nov 2026 (Platform Admin sole-controller decision):** any wording below that makes the controller lease, adoption, ownership or fencing a precondition for merge or release is retired. Claude is the sole accountable engineering controller and releases through the standard reviewed route (one release at a time, exact-head CI, checksums, G1-G4, protected approvals). Wording kept for the record. See [decision](2026-11-09-claude-sole-engineering-controller-decision.md).

**Platform Admin mandate, 9 November 2026.** **Mode 1 Active Remediation.** This is a PRIORITY OVERRIDE within the existing [F-PDESC](../STUDYSEARCH-FEATURE-ACCEPTANCE.md), [F-INT](../STUDYSEARCH-FEATURE-ACCEPTANCE.md), [cross-domain delivery mandate](2026-11-08-cross-domain-autonomous-delivery-closure.md) and [sole execution register](../STUDYSEARCH-EXECUTION-REGISTER.md). It does not create a new tracker, new approval rule or new controller.

## 0. Outcome demanded and non-acceptance of scaffold-only work
The Platform Admin wants **actual provider descriptions populated and valid course intake dates populated autonomously in canonical data and (where published/eligible) consumer output**. PRs, plans, dashboards, counts of created Layer 4 items, successful cron ticks and drafts are **work products, not the requested result**. Claude must not call a domain feature complete without verified source→evidence→governed decision→canonical admission→Website/Zoho publication and unattended recurrence. One bounded Newcastle intake milestone from earlier history does not establish whole-platform autonomous coverage.

**Override the next work:** provider-description population F-PDESC and course-intake F-INT are the primary two end-to-end delivery lanes. P0 unsafe data remain a safety gate, not a pretext for endlessly diverting unrelated autonomous fields into engineering PRs. Existing held reviews are consolidated as the exact required human action while all technically eligible other providers/courses progress.

## 1. Fresh live starting baseline (read-only Supabase, 9 Nov; not necessarily atomic)
| Measurement | Observed value | Meaning |
|---|---:|---|
| Provider records | 3,103 | All countries, all lifecycle/publication states |
| Provider description filled | **0** | Actual `catalogue.providers.description` nonempty |
| Provider description source reads | **5** | `pipeline.provider_description_reads`: 4 `proposed`, 1 `held` |
| Pending provider description reviews | **4** | `pipeline.layer4_review_items` field_code `provider_description` |
| Scheduled pdesc job | Active | `provider-description-read` cron `6,16,26,56 * * * *` |
| Pdesc scope | 5 keys; AU universities only | `pdesc.provider_keys` has exactly 5 keys, `pdesc.countries=['AU']`, `pdesc.provider_types=['university']`, `pdesc.pending_max=10`; **configuration, not underlying absence of a reader, is the immediate breadth bottleneck** |
| Pdesc held | 1 | ACU `https://www.acu.edu.au/about-acu`: an AI sentence not adequately quoted on official source; NEVER waive evidence gate |
| Pdesc proposed | 4 | CDU, Monash, UOW and UQ; actual review-item IDs in `provider_description_reads`. Proposed does **not** mean admitted. |
| Active intake rows with exact date | **1,534** | `catalogue.course_intakes` status active, start_date not null |
| Active intake rows without exact date | **30,302** | Not all are eligible for a precise date. Some are legitimately month-only/unproven. Do not fabricate to drive coverage. |
| Recent fill events | **151** in the last 24 hours | 151 distinct intakes had null→non-null start date in events; only **142** of their intake IDs currently join to an active intake with non-null start_date. This does **not** certify course-level eligibility or consumer publication. |
| Intake jobs | Both active | `intake-dates-apply` :26 hourly; `coverage-admit-intakes` every 10 min starting :05 |
| Intake horizon | 18 months | G2 `intake_dates.max_months_ahead`; keep all course-specific/campus/year guards and rejected-date memory |
| Pending course descriptions | 1,322 | Separate F-CDESC lane, not a reason to block F-PDESC/F-INT |

**Other existing risk:** La Cité 65 annual fees resembling years (64 equal fee_year) remain a P0 integrity item requiring the already prepared guarded paste with explicit Platform Admin authority. Deakin 2027 academic-calendar inference without course-specific evidence and UQ 092452K lifecycle require proof; never bulk-admit speculative dates.

## 2. Delivery tranche A — provider descriptions (F-PDESC), not another prototype
**Immediate producer→consumer sequence:**
1. Reconcile and expose exact evidence-backed CDU, Monash, UOW and UQ proposed items in **existing Layer 4 Inbox**; person must review each actual candidate and source. Prepare one four-item review batch with reference, claim/quote and disposition, no unauthorised auto-decision. After permitted human decisions, **immediately verify each accepted row** in `catalogue.providers.description`, the consumer source and authenticated Website/Zoho as available; if an approved row fails to publish, pursue the admission/consumer defect now rather than writing another planning report.
2. For ACU held sentence, use free/stored official About text to generate a **source-backed factual description without unsupported faculty claims** or correctly mark the hold for human evidence; no inventing, prompt injection or lenient evidence gate.
3. **Expand scope beyond the five hardcoded-in-settings provider keys** through the authorised existing Admin UI / settings change with a recorded reason, bounded by country/provider type, site/source eligibility, `pdesc.pending_max`, budget, queue control and fair provider selection. No direct SQL bypass. Do not treat the five-provider pilot as a permanent coverage strategy.
4. First bounded generalisation wave: **next 20 eligible Australian university providers not already covered**, selected deterministically by source readiness and coverage/fairness. This is a *work-scope target*, not permission to fabricate twenty descriptions or spend without budget. Record source found→read→quote supported→technically ready→human review/approved-auto-policy→canonical→published for every selected provider.
5. The initial first-description human-approval policy remains binding. **If it is the structural reason no provider can ever self-populate**, prepare ONE explicit Platform Admin policy decision to authorise **constrained auto-admission of entirely factual, source-quoted, identity-confirmed, non-promotional, unchanged-source descriptions** with auditable eligibility and spot-check/rollback; conflicts, promotional/ranking claims, unsupported text, manual locks, first-time unapproved rule classes and all exceptions stay in Layer 4. DO NOT silently enable this policy. While approval is pending, continue source acquisition and review-ready production.
6. Prove a **real nonzero provider-description canonical gain** from the existing four reviews after valid decisions; then make the next authorised scheduled batch produce ongoing progress. Human-approved work must publish without a Claude manual command after every item.

**Pdesc acceptance:** first official source→review→canonical→Website/Zoho trace (provider ID, read, review decision, before/after, sync/HTTP), net provider descriptions **greater than 0**, then sustainable unattended source coverage for next 20; any person-held subset is item-level and shown in UI. If no decisions yet, report `0 admitted; 4 human review held`, do not mark feature accepted.

## 3. Delivery tranche B — valid intake dates (F-INT), no unsupported mass fill
1. Reconcile current 1,534 active dated vs 30,302 undated rows by provider into precise statuses: (a) official course-specific future start date evidenced; (b) official course period plus institution calendar with course-year/campus/audience offering proof; (c) month-only legitimate (no exact date provided); (d) no source/read pending; (e) identity/availability/lifecycle conflict; (f) human review; (g) genuinely technical failure.
2. Use existing bound course pages, stored latest course calendars, approved source editions and free readers before paid Firecrawl or AI. Follow course applicability and exact academic year, campus and audience; a university-wide semester calendar alone is not sufficient. Do not reintroduce the withdrawn Deakin 2028 values or assume all 2027 Trimester 3 starts apply across every course.
3. Work a **bounded multi-university intake cohort** using the existing `intake-dates-apply` and `coverage-admit-intakes` chain, with fair provider rotation. For each chosen eligible course publish evidence quote, candidate, validation/hold, admitted event, canonical new date, Website/Zoho stored projection, and HTTP check when accessible.
4. If no eligible dates at one university, classify it as proof-limited/month-only and progress to another automatically. Do not endlessly retry the same intake/date/policy nor re-crawl identity-refused pages without new inputs. Preserve source and budget controls.
5. The existing Intake Run & Validate UI must support one course and a selected university with a persisted run ID, but **UI cosmetics are not the primary outcome**. Do not write additional intake-only presentation PRs until the current #922–#928 draft integration has a coherent tested release candidate and data producer improvements are being addressed.
6. Validate net new **correct, course-eligible dates that remain active across two unattended cycles** and cross-consumer parity. Count **gross filled**, **withdrawn/corrected**, **net dated gain** and **canonical published eligible** separately. If no eligible true dates exist in the tested cohort, prove why and select the next source/provider; a truthful month-only field is better than a made-up exact date.

**Intake acceptance:** positive, source-verified, retained net gain on one or more eligible previously undated courses, with consumer parity when parent publication permits, plus coverage/holds for a provider cohort and repeatable unattended advancement. Counts of 151 fill events are NOT proof that 151 verified exact dates were published.

## 4. Required controller execution order and permission discipline
- **Run A and B in parallel** with distinct ownership. Controller alone sequentially integrates any qualified release; agents must not share table/functions or write production. Follow the current atomic controller lease/adoption policy; developer sessions may create Pilot draft PRs and CI but MUST NOT merge/deploy/run production mutations until an actual authorised release route exists.
- Where the needed catalogue record admission requires a human reviewer or controlled configuration, raise **ONE consolidated specific action**, naming exact IDs/settings, reason, pre/post checks, impact and existing UI location; do NOT announce the entire domain blocked while other source/technical work is possible.
- Treat #922–#928 as existing drafted UI changes; reuse/integrate without another seven intake-only PRs. Source evidence and backend end-to-end delivery take priority over polish.
- Maintain separate active P0 risk response. Do not use P0 La Cité as a reason to avoid pdesc/intake source acquisition or honest read-only verification.
- Existing cost controls stay; no broad Firecrawl plan purchase or high-volume re-crawl unless independently needed and authorised. No manual data fabrication, review bypass or G3 shape change.
- At each scheduled run choose the next unblocked step in **both lanes**; the end-of-session handover is only a checkpoint, not a result. Production scheduled workers remain autonomous independent of Claude execution.

## 5. Operator-readable outcome scorecard (existing Admin UI and register, not a new dashboard)
Every checkpoint must show exact UTC/AEDT observation timestamp and before→after:
| Metric | Pdesc | Intake |
|---|---|---|
| Eligible source coverage | provider official About pages found/proved | official course/calendar/year identity proved |
| Validated proposals | number + provider IDs | exact date candidates + intake IDs |
| Reviews genuinely pending | count + Layer4 item IDs/decision | count + course applicability/lock |
| Newly admitted | source-and-rule valid `providers.description` | source-and-rule valid `course_intakes.start_date` |
| Withdrawn/invalid | unsupported description corrections | invalid/withdrawn calendar dates |
| Net canonical gain | descriptions now populated – baseline 0 | active verified dates now – baseline with withdrawals |
| Consumer integrity | Website/Zoho stored and authenticated HTTP as possible | Website/Zoho stored and authenticated HTTP as possible |
| Automation | active job, actual run/result, next due | both scheduled jobs, stage timings/retry and next due |
| Human blocker | exact review IDs + needed policy decision | exact item/course-specific proof or human decision |
| Next independent action | next eligible provider batch | next eligible university/course batch |

The required **minimum durable result from this mandate** is a production-evidenced positive description gain after valid approvals, and real verified intake gains without unsupported dates. If no approvals can be obtained, the Controller must supply exact four-item review packet and a ready policy request, while progressing technical source acquisition and eligible intake cohorts. Never claim data filling when only code is developed.

## 6. Engineering/quality/records
Every new source/reader change must cite this mandate and existing F-PDESC/F-INT + IQ/SS issue. Full governed testing, no red/skipped, exact-head CI, release permission and first-run live admission/consumer checks required. All progress goes into `STUDYSEARCH-EXECUTION-REGISTER.md` and derived `STUDYSEARCH-PROGRAMME-STATUS.md`; update `STUDYSEARCH-FEATURE-ACCEPTANCE.md` only when genuine acceptance contract changes. Independent validation must distinguish **actual admitted values** from plans/read attempts/review queues. No duplicate trackers/menus.
