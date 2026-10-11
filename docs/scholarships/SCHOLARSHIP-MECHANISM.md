# StudySearch – How scholarships work

**Version:** 1.0 (11 Oct 2026, platform release v2.15.244)
**Owner:** Platform Admin
**Change control:** CF-247
**Rule:** this document is updated with every change to how scholarships are found, read, linked, published or controlled. The change-control entry for that change says which version of this document it produced.

---

## 1. In one paragraph

StudySearch takes scholarships only from each university's own website, in every country. A scraper (Firecrawl) reads each page as a person would see it, and the page is saved as evidence. Fixed rules then read the facts from the saved page: value, who it's for, nationalities, dates, study levels and courses. Each fact keeps the sentence it came from. Courses are linked only where the page supports it. Scholarships that pass every publishing check are published automatically each hour and appear on the website and in Zoho. Pages are read again regularly, so changes on the university's site flow through. Anyone with the right role can also run any of this on demand, and every piece of background work shows in Task manager.

## 2. Principles

| Principle | What it means in practice |
|---|---|
| Provider pages only | Scholarships come from universities' own sites. No national register or third-party directory is used (Study Australia, Australia Awards and Manaaki were retired on 11 Oct 2026). |
| Scraper only | Every scholarship page, listing page, candidate page and site map is read through the scraper (rendered page). There is no direct read and no fallback. robots.txt is not consulted for scholarship pages (Platform Admin decision, 11 Oct 2026). |
| Evidence first | Every page read is saved (compressed copy, fingerprint, version). Every fact and every course link points back to it. |
| Fixed rules, no guessing | Facts are read by deterministic rules. Anything unclear (for example, two different values) is left for a person, not guessed. |
| People win | A value entered by hand is never changed by automation until a person hands it back. |
| Country-neutral | Amounts stay in the provider's own currency. Numeric dates are read in that country's day/month order. |
| Everything visible and controllable | Every job and on-demand task appears in Task manager with its controls. |

## 3. The journey of a scholarship

| Step | What happens | Where you see it |
|---|---|---|
| 1. Universities queued | Universities in countries switched on for scholarships wait their turn for discovery. | Layer 1 › Scholarships (countries); Layer 2 › Scholarships |
| 2. Site mapped | The scraper maps the university's site, including its site maps, and keeps addresses that look like scholarship pages (candidates). | Layer 2 › Scholarships (discovery by country) |
| 3. Candidates screened | Each candidate is read through the scraper. It is admitted only if it is one named scholarship, open to international students and currently offered. The reasons for refusing a page are recorded. | Layer 2 › Scholarships (outcomes and reasons) |
| 4. Page read and saved | The scholarship's own page is read through the scraper and saved as evidence (a new version only when the page changed). | Scholarship record › Evidence & extraction, steps 1 to 3 |
| 5. Name check | The page must name the scholarship before anything is taken from it. | Evidence & extraction, step 4 |
| 6. Facts read | Value (percentage, amount, tiers, maximums), who it's for, nationalities, who qualifies, how long, applications open, applications close (with rounds), study start, study levels, fields, and courses named or excluded. Each fact keeps the page's words. | Scholarship record rows; Evidence & extraction, step 5 |
| 7. Facts applied | New values update the record unless a person has locked them. Every change is logged with its evidence. | Evidence & extraction, step 6; record History |
| 8. Courses linked | See section 4. | Courses it applies to › Show the courses and why each is linked |
| 9. Publishing checks | See section 5. Passing scholarships are published hourly as a batch named auto-publish. | Layer 4 › Scholarship publishing; Scholarships › Coverage (review) |
| 10. Delivered | Published scholarships go to the website, Wix and Zoho, through the course API and the scholarship APIs. | Scholarships list (published only) |
| 11. Kept current | Published and ready pages are read again at least every 30 days (a setting). A change on the page flows through. A scholarship that stops passing a check is withdrawn at the daily review. | Jobs; Layer 4 › Scholarship publishing |

## 4. How courses are linked

Links come only from the saved page, in this order. The first rule that applies decides.

| Order | Rule | Example | Proof kept on the link |
|---|---|---|---|
| 1 | Courses the page names: course codes (CRICOS form) or course titles that match the provider's own courses. Long titles also match when one contains the other. | "open to students in the Bachelor of Commerce or Bachelor of Laws" | The sentence, and the code or title it named |
| 2 | English language course scholarship: the provider's English language courses only | "Curtin English Scholarship" | Marked as an English course scholarship |
| 3 | Study levels and fields the page states | "all international postgraduate coursework students"; "Engineering Excellence Scholarship" | The sentence the level was read from, and the scholarship's name for the field |
| 4 | None of the above: no course links. The scholarship can still be published. | A general bursary that names no level or course | "The page names no course, level or field" |

Further rules:
- **Excluded courses** (after "excluding", "except", "other than", "not available for") are never linked under any rule. Example: "All undergraduate degrees, excluding the Bachelor of Science (Medical Radiation Science)".
- **Titles named but not found** among the provider's courses are listed on the record for a person to check. They are not guessed.
- **Links made or decided by a person** are never changed by automation.
- Links are rebuilt each time the page is read. Search, the website and Zoho are refreshed only when a link actually changes.

## 5. Publishing

A scholarship is published only when all of these hold:

| Check | Held reason shown when it fails |
|---|---|
| Active | not active |
| Has its provider page | no provider page |
| For international students (from the page's wording) | not for international students; provider page limits it to citizens and residents; provider page does not mention international students |
| Has a stated value (percentage, amount or tiers) | no stated award value |
| Not domestic only | eligibility lists domestic students only |
| Evidence saved | no evidence |
| Not held after a hand-check | held after hand-check |
| Currently offered | not currently offered (provider page) |
| English course scholarships not linked to other courses | English language course linked to other courses |
| Course link not broader than the scholarship | course link broader than the scholarship |
| One record per scholarship: the provider's own, evergreen, current edition | another edition of this scholarship is listed |
| Verified in the last 12 months | not verified in 12 months |

A scholarship with no linked course **can** be published (Platform Admin decision, 11 Oct 2026). Automatic publishing runs hourly and can be switched off. Every batch is listed for review, and any scholarship can be held or withdrawn with a reason.

## 6. Scheduled jobs

| Job | When | What it does |
|---|---|---|
| Find university scholarship pages | Every 10 minutes | Maps the next universities' sites through the scraper, then screens candidate pages and admits new scholarships |
| Keep the discovery queue filled | Hourly | Queues the next universities in countries switched on |
| Re-read scholarship pages | Every 5 minutes | Reads due scholarship pages through the scraper and applies what they state |
| Read listing pages | Every 15 minutes | Reads each provider's scholarship listing page for the coverage check |
| Re-read cadence | Daily | Brings forward the next read of published and ready scholarships |
| Who it is for | Hourly | Reads the audience from the wording (fixed rules) |
| Nationalities | Every 10 minutes | Reads the nationalities named (fixed rules) |
| Fee alignment | Hourly | Recalculates savings for courses whose fee changed |
| Publish automatically | Hourly | Publishes scholarships that pass every check, as one batch |
| Course scholarships refresh | Every 15 minutes, full each night | Refreshes the scholarships shown on each course (search, website, Zoho) |
| Daily publication review | Daily | Withdraws published scholarships that no longer pass a check |
| Savings | Daily | Works out the saving a year for each course and scholarship |

Retired on 11 Oct 2026: register feeds (ETL scheduler), weekly scope maintenance, AI-run scheduler, country watch and scope-apply.

## 7. On demand: run it now

| Where | Button | What it does |
|---|---|---|
| Provider record; Scholarships › Coverage (one provider, or tick up to 50) | Find scholarships now | Maps the university's site through the scraper, screens its candidate pages, admits new scholarships, reads every scholarship page and links courses from the evidence |
| Course record | Check scholarships for this course | Reads the provider's scholarship pages again and applies the link rules. The task lists the scholarships added to or removed from the course. |
| Scholarship record | Read again now | Reads that scholarship's page again now and applies what it states |

Each button starts a **task**. The task puts its pages first in the reader's queue, sends the scraper worker the next step each minute (map, screen, read), shows progress on the button and in Task manager, and finishes when nothing in scope is left. Courses are attached by the same evidence rules as scheduled reading. Cancel stops the task. Pages already read keep their results, and the rest go back to their normal turn. A task for the same target can't be started twice. Unpublished or archived providers can't be scanned until restored.

## 8. Task manager and controls

**Scheduled jobs › Task manager** shows everything using resources right now:

| What | Shown | Controls |
|---|---|---|
| Tasks (on-demand and admin tasks) | Title, state, progress, what it found, who started it | Cancel (all); Pause and resume where the task type supports it |
| Scheduled jobs running this moment | Job, area, how long it has run, schedule on or paused | Pause the schedule (the run in progress finishes), Resume, Run now |
| Worker calls on their way | Work type, number of calls, age of the oldest | Shown only; they finish on their own |
| Credits used in the last hour | By purpose | — |

Standing rule (Platform Admin, 11 Oct 2026): **every future feature that runs work in the background is registered as a task type (pipeline.admin_job_kinds) or a scheduled job, and appears in Task manager with its controls.**

## 9. Settings (Scholarships › Coverage › Settings and jobs)

| Setting | Current value |
|---|---|
| Universities searched per run | 6 |
| Candidate pages read per run | 30 |
| Universities kept waiting for discovery | 30 |
| Scholarship pages re-read per run | 40 |
| Listing pages read per run | 6 |
| Re-read published and ready pages at least every | 30 days |
| Scraper credits for scholarships (all time) | 60,000 |
| Publish scholarships that pass every check automatically | On |

## 10. Costs

- About one scraper credit per page read (scholarship page, listing page or candidate) and one per site map.
- When the scholarship credit cap is reached, pages wait. There is no direct read. Raise the cap in Settings.
- Credits used show on Layer 2 › Scholarships, on each scholarship record (Evidence & extraction) and in Task manager.

## 11. Where to look

| Question | Screen |
|---|---|
| What is published? | Scholarships |
| Why isn't this scholarship published, and where did each value come from? | Scholarship record (rows, Evidence & extraction) |
| Does our list match the university's own listing page? | Scholarships › Coverage |
| What is discovery finding and refusing? | Layer 2 › Scholarships |
| What was published or withdrawn, and when? | Layer 4 › Scholarship publishing |
| What is running right now? | Scheduled jobs › Task manager |

## 12. Version history

| Version | Date | Change |
|---|---|---|
| 1.0 | 11 Oct 2026 | First issue: scraper-only reading, evidence journey, dates, evidence-based course links, Study Australia retired (v2.15.243); on-demand tasks and Task manager running now (v2.15.244). |
