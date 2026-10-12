# StudySearch – How scholarships work

**Version:** 2.4 (12 Oct 2026, platform release v2.15.256)
**Owner:** Platform Admin
**Change control:** CF-247
**Rule:** this document is updated with every change to how scholarships are found, read, linked, published or controlled. The change-control entry for that change says which version of this document it produced.

---

## 1. In one paragraph

StudySearch takes scholarships only from each university's own website, in every country. A scraper (Firecrawl) reads each page as a person would see it, and the page is saved as evidence. A pinned AI model then reads the saved page and answers with the facts: whether it is one scholarship, its name, who it's for, whether it is offered, the value, study levels, courses and dates. Each fact must come with an exact quote from the page, and the quote is checked against the page; a fact that is not proven counts as not stated. (Until AI admission is switched on, the fixed rules used before v2.15.249 still decide, and the AI answers are recorded alongside.) Courses are linked only where the page supports it. Scholarships that pass every publishing check are published automatically each hour and appear on the website and in Zoho. Pages are read again regularly, so changes on the university's site flow through. Anyone with the right role can also run any of this on demand, and every piece of background work shows in Task manager.

## 2. Principles

| Principle | What it means in practice |
|---|---|
| Provider pages only | Scholarships come from universities' own sites. No national register or third-party directory is used (Study Australia, Australia Awards and Manaaki were retired on 11 Oct 2026). |
| Scraper only | Every scholarship page, listing page, candidate page and site map is read through the scraper (rendered page). There is no direct read and no fallback. robots.txt is not consulted for scholarship pages (Platform Admin decision, 11 Oct 2026). |
| Evidence first | Every page read is saved (compressed copy, fingerprint, version). Every fact and every course link points back to it. |
| Proven facts, no guessing | The AI may only state what the page says, with a quote. Code checks every quote against the saved page, and the quote for who it is for must itself name international (or domestic) students, or name another country or region ("students from Papua New Guinea"); the university's own country, and Australia and New Zealand for each other, do not count (v2.15.256). A fact without a proven quote counts as not stated. Anything unclear (for example, two different values) is left for a person. |
| Pinned, qualified models in order | Qwen3 30B reads first, GPT-4.1 mini reads again when the first reply fails, a stated fact is not proven, or the first model would admit (a second model confirms each admission); a value one model proved stands when a later model's value is not proven (v2.15.256); a page no model settles goes to Layer 4 › AI could not decide, where a person's decision is kept for that page copy. GPT-4.1 is qualified as a possible third reader; a Platform Admin adds it to the order. Each model is a named version (no automatic routing between models). A model is qualified on a sample of pages with known answers before it is used. Qualifying never switches anything on: making a model active and switching AI admission on are separate steps, each with a reason. |
| People win | A value entered by hand is never changed by automation until a person hands it back. |
| Country-neutral | Amounts stay in the provider's own currency. Numeric dates are read in that country's day/month order. |
| Everything visible and controllable | Every job and on-demand task appears in Task manager with its controls. |

## 3. The journey of a scholarship

| Step | What happens | Where you see it |
|---|---|---|
| 1. Universities queued | Universities in countries switched on for scholarships wait their turn for discovery. | Layer 1 › Scholarships (countries); Layer 2 › Scholarships |
| 2. Site mapped | The scraper maps the university's site, including its site maps, and keeps addresses that look like scholarship pages (candidates). | Layer 2 › Scholarships (discovery by country) |
| 3. Candidates screened | Each candidate is read through the scraper and saved. Addresses matching a skip rule (course pages, news and similar) are skipped. With AI admission on, the AI answer decides: it is admitted only if it is one named scholarship, open to international students and not ended. The reasons for refusing a page are recorded. | Layer 2 › Scholarships; Scholarships › Extraction (recent answers); the task's journey |
| 4. Page read and saved | The scholarship's own page is read through the scraper and saved as evidence (a new version only when the page changed). | Scholarship record › Evidence & extraction, steps 1 to 3 |
| 5. Name check | The page must name the scholarship before anything is taken from it. | Evidence & extraction, step 4 |
| 6. Facts read | AI (when on): name, who it's for, offered, value (percentage, amount, tiers, full tuition), study levels, courses named and dates, each with its quote. Fixed rules still read nationalities, who qualifies and how long. Each fact keeps the page's words. | Scholarship record rows; Evidence & extraction, step 5; Scholarships › Extraction |
| 7. Facts applied | New values update the record unless a person has locked them. Every change is logged with its evidence. | Evidence & extraction, step 6; record History |
| 8. Courses linked | See section 4. | Courses it applies to › Show the courses and why each is linked |
| 9. Publishing checks | See section 5. Passing scholarships are published hourly as a batch named auto-publish. | Scholarships › Coverage (review) |
| 10. Delivered | Published scholarships go to the website, Wix and Zoho, through the course API and the scholarship APIs. | Scholarships list (published only) |
| 11. Kept current | Published and ready pages are read again at least every 30 days (a setting). A change on the page flows through. A scholarship that stops passing a check is withdrawn at the daily review. | Jobs; Scholarships › Coverage |

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
| Who it is for | Hourly | Reads the audience from the wording (fixed rules); skips scholarships read by AI |
| Read scholarship pages with AI | Every minute | Sends queued pages to the active model (and the qualification sample to a model being qualified); checks every quote |
| AI re-check of refused pages | Nightly | While AI admission is on, queues the next universities (25 a night) whose refused pages have not been read with the active model and instructions |
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
| Scholarships › Extraction | Qualify | Reads the qualification sample with one model and scores it |
| Scholarships › Extraction | Re-check the watch list with AI | Reads every refused and known page of the watch-list universities with the active model |
| Scholarships › Extraction | Try a page | Reads one address with a model and shows the answer; changes nothing |
| Layer 4 › AI could not decide | Read the waiting pages again (Platform Admin, with a reason) | Reads every waiting page again from the first model in the order, on its stored copy (no scraper credit); a page stays only if no model settles it (v2.15.256) |

**Automatically, for a university being onboarded (v2.15.253).** Every university without an admitting adapter, and every new university, is onboarded a step at a time by the scheduled job provider-onboarding (Providers › Onboarding). Once its adapter is built and qualified and its central pages are attached, onboarding runs the same Find scholarships now task for that university; the scholarships found then follow the journey above (AI reading, publishing checks, hourly publish). Onboarding stops at Ready to admit (or Needs a person) for the adapter; scholarships are not held back by that step. The search runs once per onboarding, so a retry does not search again. Each row counts its scholarships live: found since onboarding started, published, and pages still waiting for the AI. Its Journey lists every scholarship found with its state (v2.15.255). A slim banner on every page (Curator and above) warns when Firecrawl credits, the OpenRouter credit, the adapter AI allowance or the scholarship scraper cap run low.

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
| AI admission (Scholarships › Extraction) | On since 11 Oct 2026, 11:45 pm (switched on and off by a person, with a reason) |
| AI models in use | Qwen3 30B first, GPT-4.1 mini second (both qualified on instructions v2) |
| AI instructions | Version 2; a new version switches AI admission off until the models are qualified again |
| Universities re-checked with AI each night | 25 |
| Model order | Qwen3 30B, then GPT-4.1 mini, then Layer 4 |
| Second model confirms admissions | On |
| AI calls at once | 5 |

## 10. Costs

- About one scraper credit per page read (scholarship page, listing page or candidate) and one per site map.
- When the scholarship credit cap is reached, pages wait. There is no direct read. Raise the cap in Settings.
- Credits used show on Layer 2 › Scholarships, on each scholarship record (Evidence & extraction) and in Task manager.
- AI reading of a stored page uses no scraper credit. Measured on the 41-page sample: Qwen3 30B about US$0.0003 a page; GPT-4.1 mini about US$0.0014 a page (instructions v2). Cost today shows on Scholarships › Extraction.
- AI calls are paid from the OpenRouter key kept by layer3-provider-control (Layer 3 itself was retired on 12 Oct 2026) and shared with the adapter builder; when the key's credit limit is reached every AI call fails until it is raised.

## 11. Where to look

| Question | Screen |
|---|---|
| What is published? | Scholarships |
| Why isn't this scholarship published, and where did each value come from? | Scholarship record (rows, Evidence & extraction) |
| Does our list match the university's own listing page? | Scholarships › Coverage |
| What is discovery finding and refusing? | Layer 2 › Scholarships |
| What was published or withdrawn, and when? | Scholarships › Coverage (Layer 4 › Scholarship publishing was retired on 12 Oct 2026, v2.15.253; its old address opens Coverage) |
| What is running right now? | Scheduled jobs › Task manager |
| What did the AI read on a page, and was each fact proven? | Scholarships › Extraction (recent answers, with the stored copy) |
| Which AI model is used, and how well did it qualify? | Scholarships › Extraction |
| Which pages could no model settle? | Layer 4 › AI could not decide |

## 12. Version history

| Version | Date | Change |
|---|---|---|
| 1.0 | 11 Oct 2026 | First issue: scraper-only reading, evidence journey, dates, evidence-based course links, Study Australia retired (v2.15.243); on-demand tasks and Task manager running now (v2.15.244). |
| 2.0 | 11 Oct 2026 | v2.15.248: every page a task reads is recorded and shown as a journey; a copy of every page is kept; skip rules; listing page suggestions; an automatically published scholarship that fails a check is held. v2.15.249: a pinned, qualified AI model reads every scholarship page with quotes checked against the page (Scholarships › Extraction); AI admission, model activation and instructions are separate, reasoned steps. |
| 2.1 | 12 Oct 2026 | v2.15.250: models read in order (Qwen3 30B, then GPT-4.1 mini, then Layer 4 › AI could not decide); parked Layer 4 course items rerouted to university adapters and parked scholarships to the AI. v2.15.251: the audience quote must name international or domestic students; a second model confirms each admission. |
| 2.2 | 12 Oct 2026 | v2.15.253: onboarding runs a scholarship search for each university it onboards; credit and limit banner; Layer 4 › Scholarship publishing retired (Scholarships › Coverage). |
| 2.3 | 12 Oct 2026 | v2.15.255: the onboarding scholarship search runs once per onboarding; scholarships counted live on each row (found, published, pages with the AI) and listed in its Journey. |
| 2.4 | 12 Oct 2026 | v2.15.256: a value one model proved stands when a later model's is not proven; a quote naming another country or region proves international; GPT-4.1 qualified as a possible third reader; Read the waiting pages again. |
