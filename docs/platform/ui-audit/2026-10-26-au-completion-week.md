# AU completion week (expedited)

Date: 26 Oct 2026 (AEDT), opened 17:0x
Mandate: Platform Admin, 26 Oct 2026 17:01, "AU completion wave, EXPEDITED". This is the week's primary track.
Change control: CF-CHG-20260915-247
Standing rules: rule 9 (merge own PRs when the suite is green), rule 10 (lodge before replying), G2 (settings-keyed), G3 (consumer API frozen), G4 (tests governed). Destructive and consumer-API changes go to the Platform Admin as paste files and are never auto-merged.

## 1 Baseline (26 Oct workbooks, `docs/platform/reports/2026-10-26/`)

| Measure | 26 Oct |
|---|---|
| AU active courses | 26,103 |
| All 11 core fields complete | 5,435 (20.8%) |
| In automatic work (finish held by intakes, est. 3 Jan 2028) | 324 |
| Blocked: provider unpublished | 10,706 |
| Blocked: value not on the course page (fee schedules, English policies, calendars) | 9,335 |
| Blocked: Layer 4 review | 290 |
| Blocked: website unknown | 11 |
| Blocked: register has no value | 2 |
| No reader yet | description, academic entry requirements, application deadline |

Field rates: English 64.8% (est. 2 Nov), international tuition 31.6% (30 Dec), official page 71.3% (24 Apr 2027), intakes 36.0% (3 Jan 2028; no measurable progress in the last 7 days). Duration, study level, field of study and open-to-international are complete; campus 99.9%; registered tuition 99.3%.

## 2 Week outcome targets (re-run Thursday, report all three)

| Outcome | Baseline | Target |
|---|---|---|
| All 11 fields complete | 5,435 | 7,500–9,000 |
| In automatic work | 324 | 8,000+ (the real deliverable) |
| Can't date | 20,344 | under 10,000, every remaining row with a named cause and owner |

The completed count lags as lanes fill. Pace is reported as measured; no date is promised that the arithmetic does not support.

## 3 Step status

| Step | What | Status | Detail |
|---|---|---|---|
| 1 | Register-sync fix: CRICOS end dates recorded | in progress | section 4 |
| 2 | Eligibility re-run, then ONE count-guarded publish paste | waiting for step 1 | no paste exists before the post-fix verification passes |
| 3 | Fee reader AU scope + AU fee-schedule discovery overnight | pending | budget numbers before any overrun |
| 4 | MARK-FILE: AU English-policy and calendar approvals | pending | |
| 5 | Description reader: build started | pending | lands Wednesday with the Wollongong acceptance test |
| 6 | Entry-matrix reader: AU top 20 switch staged, off | pending | on at the Platform Admin's confirmation Tuesday |
| — | Workbook generator as a catalogued weekly job (Fridays) | pending | |

## 4 Step 1: register-sync fix (decisions before code)

### What the live data shows (checked 26 Oct 17:2x)

- The CRICOS register is current. The source check at 25 Oct 23:41 UTC found the publisher's file unchanged since the 30 Sep edition (hash `5eaf3ef2…`, 25,540 active courses, 431 expired). Next monthly ingestion is 18 Nov.
- The 30 Sep run found **563 courses no longer on the register** and stopped at its safety limit (511). Its retirement has been **held for a Platform Admin approval since 30 Sep** (run `b8a541af…`, Layer 1 operations). Those 563 courses are still active in the catalogue.
- Nothing records an end date. All 1,556 CRICOS provider registrations read `active` with no `valid_to`. That is why "deregistered" could not be separated from "current" on 25 Oct.
- What the 30 Sep edition says about the AU catalogue (active providers, active courses):

| Group | Providers | Active courses | Not on the register any more |
|---|---|---|---|
| Published, every course on the register | 201 | 12,266 | 0 |
| Published, some courses gone | 22 | 2,662 | 172 |
| Published, no course on the register | 1 | 2 | 2 |
| Unpublished, every course on the register | 1,068 | 7,067 | 0 |
| Unpublished, some courses gone | 249 | 4,078 | 361 |
| Unpublished, no course on the register | 5 | 28 | 28 |

### Decision: what "ended" means and where it is recorded

- **A CRICOS course registration has ended** when its course code is not in the latest accepted register edition. Its `valid_to` is the last date a register edition listed it. CRICOS publishes no end date of its own, so this is the closest true date; it is stated as "last listed" wherever it shows.
- **A CRICOS provider registration has ended** when none of its courses is in the latest edition. Status `ended`, `valid_to` = the last date any of its courses was listed. A provider that comes back (a course listed again) is restored: status `active`, `valid_to` cleared. Nothing is deleted.
- Recorded in `catalogue.provider_registrations` and `catalogue.course_registrations` (`valid_to`, provider `status`). The existing mirror trigger copies the provider dates to `catalogue.provider_identifiers`.
- **Consumer API:** no shape changes. Zoho reads the CRICOS code from `provider_registrations` and orders by status only among `inactive / cancelled / archived`. `ended` is outside that list, so Zoho's output does not change. The website does not read registration dates.
- **Course retirement stays where it is.** The 563 held courses are not retired by this change. Retiring them is the existing Platform Admin approval; it is offered as an optional part of the publish paste (step 2).
- **Safety guard:** nothing is ended when the latest edition lists less than `layer1.register_end_dates_min_share` (0.9) of the tracked course codes, so a truncated file cannot end hundreds of registrations.
- **Ongoing:** job `layer1-register-end-dates` (daily, catalogued) re-applies the rule after each edition; every run is recorded in `pipeline.register_end_date_runs`.
- Scope: CRICOS (AU) tonight. NZQA departures use the seen-tracking path and are not changed.

### Decision: eligibility for the publish paste (step 2)

An unpublished, active AU provider is **eligible to publish** when all hold:

1. its CRICOS registration is current (not ended) and at least `publish.eligible_min_current_courses` (1) of its courses is on the latest edition;
2. its site answers: provider discovery `mapped`, with at least `publish.eligible_min_site_pages` (1) course page kept.

Every other unpublished AU provider gets a named cause and owner: registration ended (owner: register; nothing to publish), no website on record (owner: website check), site gave no course pages (owner: discovery review), site not checked yet (owner: discovery). The check is a read-only function, `security.au_publish_eligibility_v1()`.
