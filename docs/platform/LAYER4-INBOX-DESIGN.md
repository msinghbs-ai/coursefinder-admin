# Layer 4: one inbox for everything that needs a person

**Status:** BUILT (v2.15.298, 20 Oct 2026); decisions taken 07:40 · **Change control:** CF-CHG-20260915-247 · **As at:** 20 Oct 2026, 07:40 AEDT
**Asked by:** Platform Admin, 20 Oct 2026 07:02: "work out the logic and streamline the intended operation by layer 4, Flagged Unis should come here for unflag as well, rethink and make it fulfil its tasks, think around what we have got and anything that needs attention or intervention should come to Layer 4, define its return path etc."

## 1. The rule

Layer 4 is where the platform asks a person. Anything the platform cannot settle by itself, and will not retry by itself, comes to Layer 4 with:

1. **What it is** (a university, a course field, a scholarship, a page), in plain words.
2. **Why it is here**: one sentence a non-technical person understands.
3. **What the platform suggests**, when it has a view (keep, use the new value, refuse, release).
4. **The choices**, each named by what it does ("Keep the page we hold", not "Reject").
5. **Where it goes next** for each choice (the return path), shown on the item before the person decides.

Everything the platform handles by itself stays out of Layer 4: automatic holds that release themselves (a website that is down, a course page not changed since the last read, work outside the focus list), jobs that paused because they ran empty, and counts used to stop wasting credits. Those stay on Flags and Live activity, where they can be watched and overridden.

A held item that the platform will *not* retry by itself (a hard hold that only a person can lift) always appears in Layer 4.

## 2. What is waiting today (live, 20 Oct 2026 07:30)

| Source | Waiting | Oldest | Needs a person? | In Layer 4 today? |
|---|---:|---|---|---|
| Course links (page found differs from the page held) | 24 | 6 Oct | Yes | Yes (Review queue) |
| Held scholarship pages (AI could not decide), with the AI re-check | 857 | 12 Oct | Yes | Yes (separate tab) |
| Universities without a website | 107 stopped (41 not in the CRICOS-only group) | 12 Oct | Yes | Yes (separate tab) |
| Universities held: course pages not found | 54 | 19 Oct | Yes (fix site or pages, then release) | No (Flags) |
| Universities stopped: adapter built, nothing ready to admit | 305 | 12 Oct | Yes (review or rebuild the adapter) | No (Build adapter) |
| Universities stopped: central pages to approve | 3 | 12 Oct | Yes | No (Onboarding) |
| Universities stopped: adapter proposal or capture failed | 18 | 12 Oct | Yes (retry or build by hand) | No (Onboarding) |
| Universities stopped: too few course pages read (not held, not CRICOS-only) | ~120 | 12 Oct | Yes (add page addresses) | No (Onboarding) |
| Courses not offered (page says so) | 49 | 17 Oct | Yes (archive or keep) | No (Flags) |
| Courses not on the provider's site (CRICOS still lists them) | 221 | 17 Oct | Yes, low priority (check, archive later) | No (Flags) |
| Fees failing the cross-check | 3 courses, 3 adapters | 14–18 Oct | Yes | No (Flags) |
| Counsellor reports from Zoho | 0 | — | Yes | No (Coverage › Counsellor reports) |
| Website held: does not answer | 161 | 15 Oct | No: checked every 10 minutes, released when it answers. Comes to Layer 4 only after 30 days | No |
| Courses outside focus, page not found, Enrich gives no value | 18,646 | 14 Oct | No: automatic, release on change | No |
| Central pages not due, logo not found, idle jobs | 283 | 14–15 Oct | No (logo: optional upload task) | No |

Seven kinds of work that need a person are spread over five screens, and three of them (305 adapters with nothing ready, 54 held universities, 120 universities with too few pages) have no queue at all: they show only as a stopped stage.

## 3. Proposed Layer 4

**One inbox, grouped by university.** A person opens a university once and clears everything it needs (website, pages, adapter, held scholarships, course links, flags), instead of visiting five screens. Items without a university (jobs, platform notices) sit under "Platform".

**Tabs:** Inbox (all, grouped by university, largest first) · By kind (the same items, one kind at a time, for bulk work) · Decided (history, reversible) · Team and forecast (as now).

**Item kinds, choices and return paths:**

| Kind | Why it is here | Choices (button text) | Return path |
|---|---|---|---|
| Course link | The page that shows the CRICOS code differs from the page held | Keep the page we hold · Use the new page · Enter another address | Keep: closed, same pair not asked again. Use or enter: link written (manual, wins over automation), page read again, adapter applies on the next read |
| Website needed | No website could be confirmed | Enter the website · Not a real university (archive) · CRICOS data only | Website: onboarding restarts at the website step. Archive: archive workflow. CRICOS only: no adapter, no credits |
| Course pages not found (held) | Site mapped or searched, no usable course page | Change the website · Add page addresses · Release and try again · CRICOS data only | Change or add: flag released, onboarding restarts, site mapped again. Release: same, no change. CRICOS only: stays held, labelled |
| Too few pages read | Fewer than 3 course pages read | Add page addresses · CRICOS data only | Onboarding carries on as soon as 3 pages are read |
| Adapter with nothing ready | Adapter built but no field passes its check | Open the adapter (fix a pattern) · Rebuild the adapter · Admit what is ready anyway · CRICOS data only | Fix or rebuild: qualify again, then auto-admit what passes. Admit: enrichment, then scholarships |
| Central pages to approve | English policy, calendar or fee schedule read by the AI | Approve · Refuse | Approve: policy applied to its courses, onboarding carries on |
| Adapter proposal or capture failed | The AI proposal or page capture failed twice | Try again · Build by hand (Adapter builder) | Onboarding restarts at proposing |
| Held scholarship | No model could prove it is for international students | Publish (with the chosen answer) · Not for international students · Not a scholarship | Publish: hourly publish checks. Refuse: kept, same page copy never asked again |
| Course not offered | The course page says it is no longer offered | Archive the course · Keep it | Archive: unpublished, hidden from the consumer API, reviewable on Archived |
| Course not on the provider's site | CRICOS lists it, the site has no page | Archive · Keep (check again in 90 days) · Enter its page | Archive or keep; page: read and checked |
| Fee fails the cross-check | The page fee is far from the CRICOS total | Use the page fee · Keep the CRICOS total · Enter the fee | Written as a manual value or closed |
| Counsellor report | A counsellor in Zoho reported a value | Fixed (with the value) · Not changed (with a reason) | Zoho reads the outcome back |
| Website not answering (after 30 days) | The site has not answered for 30 days | Change the website · Archive · Keep waiting | Change: onboarding restarts. Archive: archive workflow |

**Rules for every item:** a reason is required only when a choice changes data or closes a hold (as now); a decision can be reversed from Decided; the same evidence is never asked about twice; the item names who decided and when; items older than the target (7 days) are highlighted; Pipeline Operator and above may decide university-level items (website, pages, flags), PIM Admin and above data values, Platform Admin admits adapters and archives (as set by the role settings).

**Fixes already made today (v2.15.297):** Approve was missing on course links; course links now say Keep the page we hold / Use the new page / Enter another address and show both addresses; Reset filters sits with the filter chips.

## 4. Build plan (after the decisions below)

| Step | What | Size |
|---|---|---|
| 1 | One database view of every person item (kind, university, reason, suggestion, choices, return path, age), built from the existing sources; no data moves | Migration |
| 2 | One decide function that routes each choice to the existing action (link apply, website set, flag release, onboarding retry, scholarship decide, archive, adapter admit) | Migration |
| 3 | Layer 4 Inbox (grouped by university) and By kind tabs; the current Review queue, AI could not decide and Websites to find become kinds inside it | UI release |
| 4 | Release the old separate tabs (kept 14 days, then retired by the housekeeping rule) | UI release |
| 5 | Daily running sheet lists Layer 4 items per university (already in the sheet) | Done |

## 5. Decisions for the Platform Admin

1. Grouping: by university (recommended) or by kind.
2. Scope: include the 305 adapters with nothing ready and the ~120 universities with too few pages (recommended), or keep those on Build adapter.
3. Low-priority items (221 courses not on the provider's site): in the inbox (recommended, at the bottom), or a monthly review list only.
4. Website not answering: into Layer 4 after 30 days held (recommended), or never (Flags only).

**Decided (Platform Admin, 20 Oct 2026 07:40):** 1 "By university (Recommended)"; 2 "Yes, all of them (Recommended)"; 3 "Inbox, at the bottom (Recommended)"; 4 "After 30 days held (Recommended)". Built in v2.15.298 (migration `20261020040000_cf247_layer4_inbox.sql`, Layer 4 › Inbox). The older tabs retire 14 days after the Inbox went live (3 Nov 2026) if unused.
