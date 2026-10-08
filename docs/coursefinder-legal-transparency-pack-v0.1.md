# CourseFinder — Legal and Transparency Pack

**Version:** 0.1 · **Status:** DRAFT FOR REVIEW · **Date:** 8 October 2026
**Classification:** Internal working draft. Not reviewed by legal counsel. Not a legal opinion.
**Change control:** proposed new item (next free ID is `CF-CHG-20261008-248`); recorded under `CF-CHG-20260915-247` until the Platform Admin assigns one.
**Evidence base:** Pilot `main` at `af302735` (UI v2.15.221 candidate, package 0.1.148, 8 Oct 2026); admin `main` at `1b52964c`; live Supabase project `fxcwkweaxjtknorudmwp` read on 8 Oct 2026 at about 15:40 AEDT.
**Reference model:** DegreeAtlas "Legal and policies" set (degreeatlas.org/legal), reviewed in full on 8 Oct 2026, with every linked policy and methodology page.

> **How to use this pack.** Each policy section has three parts:
> 1. **Draft public statement**: wording the website could publish once the gaps are closed. It holds no repository names, links or commit references, so it can be lifted as it stands.
> 2. **Where we stand**: what the code, design and live database actually do today, with references.
> 3. **Gaps and decisions**: what must change, or be decided, before the statement is true.
>
> Status markers: [[IN PLACE]] true today · [[PARTIAL]] partly true · [[GAP]] not true today · [[DECISION]] needs an owner decision · [[N/A]] does not apply today.
>
> Repository paths, commit hashes and repo URLs in this pack are for internal use only. Remove them from anything customer-facing.

---

## 1. Summary

CourseFinder is an international-student course discovery and comparison platform. It collects, checks and holds course facts (official page, intakes, English requirements, fees, duration, campus, delivery) for providers in Australia, New Zealand and Canada, and serves them to a website (Wix), Zoho (used by counsellors) and other consumers through governed, token-protected APIs. It does **not** process applications, admissions decisions, offers or visas (Design Reference §1, Decision 1).

**What is published today (live, 8 Oct 2026)**

| Measure | Value |
|---|---:|
| Active courses held | 34,959 (AU, NZ, CA) |
| Courses marked published | **0**, but the course APIs do not yet enforce published-only, so token-holding consumers (website, Zoho) can receive unpublished course data |
| Scholarships published (website and Zoho) | 360 |
| Providers with active courses | 1,867 |
| Staff sign-in accounts | 8 |
| Student or public user accounts | **0** (none exist in the design) |
| Rankings shown to any consumer | **None** (staff screens only) |

**Where the legal set stands overall**

| Policy | DegreeAtlas has | CourseFinder today | Readiness |
|---|---|---|---|
| Legal hub / status of documentation | Yes | Nothing published | [[GAP]] |
| Privacy policy | Yes, very detailed | None. Personal data is held (staff, provider contacts) | [[GAP]] |
| Terms of use | Yes | None for the website; no API terms for integrators | [[GAP]] |
| Cookie statement | Yes ("no cookies") | Admin app sets no cookies; website (Wix) not assessed | [[PARTIAL]] |
| Accessibility statement | Yes (WCAG 2.2 AA, automated gates) | No target, no automated checks | [[GAP]] |
| Commercial disclosure | Yes | Nothing to disclose today; Zoho-side re-ranking undisclosed | [[PARTIAL]] |
| AI and model use | Yes | Strong governance in design and code; nothing published | [[PARTIAL]] |
| Data and source methodology | Yes | Design is mature; nothing published | [[PARTIAL]] |
| Evidence, freshness and attribution register | Yes, per dataset licence | Evidence model strong; licence and attribution register missing | [[GAP]] |
| Corrections and feedback | Yes (public form) | Counsellor report path only; no public route | [[PARTIAL]] |
| Contact / operator imprint | Yes (entity named) | Operator not named anywhere | [[DECISION]] |
| Refund policy | Yes (paid API) | No paid product | [[N/A]] |
| Data breach response | Not published | No procedure exists | [[GAP]] |
| Security posture statement | Not published | Strong controls, several open findings | [[PARTIAL]] |

**Five blockers before any course is published to students**
1. Name the operator (legal entity, ABN, contact address) and decide whether it is an APP entity under the Privacy Act 1988. [[DECISION]]
2. Publish a privacy policy that covers staff data, provider-contact data, counsellor reports and the website's own data. [[GAP]]
3. Publish terms of use with the "not admissions advice, check with the institution" boundary, plus API terms for integrators. [[GAP]]
4. Record the licence and attribution for every source shown to consumers (CRICOS first). [[GAP]]
5. Write a data breach response procedure (Notifiable Data Breaches scheme). [[GAP]]

---

## 2. Legal hub and status of documentation

### Draft public statement

> **Legal and policies**
>
> Privacy, terms of use, cookies, accessibility, commercial disclosure, AI use and data sources for CourseFinder.
>
> **What CourseFinder publishes.** CourseFinder holds facts about courses for international students in Australia, New Zealand and Canada: the official course page, start months, English requirements, international tuition fees, duration, campus and how the course is delivered. Each fact is taken from the provider's own pages or an official government register, checked, and kept with the page it came from. A fact that has not been checked is shown as unknown rather than estimated. CourseFinder does not process applications, make admissions decisions, issue offers or advise on visas. Always confirm details with the provider before you apply.
>
> Policies: Privacy · Terms of use · Cookies · Accessibility · Commercial disclosure · AI and model use · Data sources and methodology · Corrections · Contact
>
> **Status of these pages.** These pages describe CourseFinder as it is built at release [release]. They are written by [Operator legal name] and [have / have not] been reviewed by external legal counsel. They are not a warranty or legal advice.

### Where we stand
- No legal, privacy, terms, cookie, accessibility or disclaimer text exists in either repository (Pilot `src/`, `public/`, `index.html`; admin `docs/`). [[GAP]]
- The only browser-facing site is the staff-only PIM Admin at `coursefinder-pilot.techm.workers.dev`. Its sign-in screen says "Authorised staff access only" (`src/mature-main.jsx:205`). [[IN PLACE]]
- The student-facing website is built in Wix, outside these repositories. It reads CourseFinder through `website-course-api` / `wix-course-api` with a token kept in Wix Secrets Manager (`docs/integrations/coursefinder-wix-api-handover-v1.1.md`). The legal hub belongs on that website. [[DECISION]]
- A release identifier exists and could be cited, as DegreeAtlas does: `src/release-manifest.js` (UI `2.15.221`, state `candidate`). [[IN PLACE]]

### Gaps and decisions
- Decide where the legal hub lives (Wix website, a CourseFinder-hosted page, or both) and who owns the wording. [[DECISION]]
- Adopt DegreeAtlas's discipline: each statement is tied to a release and states plainly what is not done. [[DECISION]]

---

## 3. Privacy policy

### Draft public statement

> **Privacy policy**
>
> **The short version.** You can search and compare courses on CourseFinder without an account, and CourseFinder does not ask you for personal information to do so. CourseFinder holds a small amount of personal information about the people who run it, and the work contact details that universities and colleges publish for their own staff. This policy explains each kind, where it is kept, who can see it and how long it is kept.
>
> **1. Students and website visitors.** CourseFinder has no student accounts and keeps no record of what you search for. [The website at [domain] is run on Wix; Wix's own privacy notice applies to the website itself, including any forms and cookies it uses: see the cookie statement.] If you contact us, we use your message only to answer you.
>
> **2. Counsellors reporting a problem.** When a counsellor reports a wrong course fact from Zoho, CourseFinder receives the report with the counsellor's name and work email so that we can follow up. It is used only for that report.
>
> **3. University and college staff.** CourseFinder keeps the work contact details that a provider publishes for its international, admissions and partnership staff: name, job title, team, work email, work phone and the page it came from. Some job titles are confirmed through a licensed business-contact service. Personal email addresses (such as Gmail or Outlook) are refused. We use these details only to contact a provider about its own course information. If you are listed and want your details corrected or removed, write to [privacy contact].
>
> **4. CourseFinder staff.** Staff accounts hold an email address, a role and a sign-in history. Changes staff make are recorded with their account so that every change can be traced.
>
> **Where information is kept.** CourseFinder's database and file storage are hosted by Supabase in [region]. The admin website is served by Cloudflare. [Other service providers.] Some of these providers store or process information outside Australia; see "Overseas disclosure".
>
> **How long we keep it.** [Retention periods per category — to be decided.]
>
> **Your rights.** You can ask to see, correct or remove personal information we hold about you by writing to [privacy contact]. We answer within [30] days. If you are not satisfied, you can complain to the Office of the Australian Information Commissioner (oaic.gov.au) [or the New Zealand Privacy Commissioner, or the Office of the Privacy Commissioner of Canada].
>
> **What CourseFinder does not do.** No advertising or tracking scripts. No sale of personal information. No profiling of students. No automated decisions about individuals.

### Where we stand

**3.1 Personal data actually held (live counts, 8 Oct 2026)**

| Category | What is held | Where | Live count | Status |
|---|---|---|---:|---|
| Staff sign-in accounts | Email, password hash, role, ban state | `auth.users`, `security.user_roles` | 8 users | [[IN PLACE]] (must be disclosed) |
| Staff identity in audit trails | User ID on about 90 tables (`admin_control_events.actor`, `manual_edit_log.actor`, `firecrawl_runs.requested_by` and others) | `pipeline.*` | — | [[IN PLACE]] |
| Staff email copied into decision ledgers | `actor_email` | `pipeline.layer4_override_decisions`, `layer4_publication_decisions`, `layer4_block_decisions` | — | [[PARTIAL]] (copy outlives account; `layer4_block_decisions` has no RLS statement in git) |
| Staff access audit | Actor, target, before and after state | `security.user_access_events` (RLS on, service role only) | — | [[IN PLACE]] |
| Provider (university) staff contacts | Full name, job title, team, territory, work email, work phone, profile URL, source URL | `pipeline.provider_contacts`, `provider_contact_versions`, `provider_contact_observations`, import rows | 31 live (18 named staff), 76 observations | [[PARTIAL]] |
| Counsellor problem reports (Zoho `report` action) | Reporter name (120 chars), email (160), reference | `pipeline.data_flags.detail.reporter` | 0 so far | [[PARTIAL]] |
| Scraped pages and screenshots | Provider web pages (may incidentally name staff) | Private buckets `evidence` (131,295 records, 19.1 GB), `adapter-captures` | — | [[PARTIAL]] |
| Students, leads, enquiries, applications | Nothing | — | 0 | [[IN PLACE]] |

Provider contacts design: `docs/coursefinder-provider-contact-database-management-design-v1.0.md` (§3, §8, §14 Security, §15 "privacy policy require[s] a separate consumer-admission Change Control"). Sources: university contact pages (`provider-contact-discover-scheduled`), CSV import, and licensed Apollo enrichment that does not request personal email or phone (`provider-contact-enrich-apollo`, `src/pim-version-entry.js:56`). Free-mail domains are rejected at import (`20260902114100`, `20260902114200`). Exports are audited (`provider_contact_export_audit`).

**3.2 Who processes it (sub-processors)**

| Service | Role | Personal data involved | Status |
|---|---|---|---|
| Supabase (Pro, `ap-south-1` Mumbai) | Database, auth, storage, edge functions | All of the above | [[PARTIAL]] Overseas (India): APP 8 disclosure needed |
| Cloudflare Workers | Hosts the admin app | Request telemetry | [[IN PLACE]] |
| GitHub | Source code and governance docs | Staff names in commit history; docs name staff by role | [[PARTIAL]] Both repos are **public** (open issue) |
| OpenRouter, and the model providers behind it | AI checks of course facts | Course page text only; no personal data by design | [[PARTIAL]] Confirm prompts never carry contact data |
| Firecrawl, ZenRows | Page reading and search | Public provider pages | [[IN PLACE]] |
| Apollo (`api.apollo.io`) | Licensed title enrichment for provider contacts | Names, titles, employer | [[PARTIAL]] Licence terms not filed |
| Wix | Student website, holds API token | Website visitor data (outside these repos) | [[DECISION]] |
| Zoho Creator | Counsellor tool; sends reports | Counsellor name and email | [[DECISION]] |

**3.3 Retention**
- A retention policy table exists (`pipeline.retention_class_policies`, `20260901162500`): regulatory evidence, accepted source versions, Layer 4 decisions, publication decisions and material audit are never purged; terminal jobs 90 days, expired queue rows 30, stale locks 7, cache 30, staging 14, bounded logs 90. [[IN PLACE]]
- The Storage & retention screen (8 Oct, v2.15.219–221) purges adapter screenshots and job logs after 7 days and unreferenced evidence after 7 days, with typed confirmation and a run log (`20261008000500`–`20261008001300`). [[IN PLACE]]
- **No retention rule covers personal data**: provider contacts are soft-deleted only (`deleted_at`), `actor_email` copies are kept for good, Zoho reporter details have no disposal. [[GAP]]
- No self-service or documented route to see, correct or remove personal data. [[GAP]]

**3.4 Laws that may apply (to confirm with counsel)**

| Law | Why it may apply | Status |
|---|---|---|
| Privacy Act 1988 (Cth), 13 Australian Privacy Principles | Applies if the operator is an APP entity (annual turnover over A$3 million, or another trigger). Even if exempt, following the APPs is the market expectation | [[DECISION]] |
| APP 1 (open and transparent management) | Requires a clearly expressed, up-to-date privacy policy | [[GAP]] |
| APP 5 (notification of collection) | Provider staff collected from websites and Apollo should be told, at or soon after collection, or the policy must be readily available | [[GAP]] |
| APP 8 (cross-border disclosure) | Database in Mumbai; OpenRouter and model providers overseas | [[GAP]] |
| APP 11 (security, destruction when no longer needed) | No personal-data retention rule | [[GAP]] |
| Notifiable Data Breaches scheme (Privacy Act Part IIIC) | Requires assessment within 30 days and notice to the OAIC and individuals for eligible breaches | [[GAP]] No procedure |
| Privacy and Other Legislation Amendment Act 2024 | Statutory tort for serious invasions of privacy (in force since 10 June 2025); privacy-policy transparency for automated decisions that significantly affect individuals (from 10 December 2026) | [[DECISION]] CourseFinder makes no decisions about individuals today; confirm and say so |
| Spam Act 2003 (Cth) | Any commercial email to provider staff needs consent (inferred consent from conspicuous publication is narrow) and an unsubscribe | [[DECISION]] |
| Privacy Act 2020 (NZ), and Unsolicited Electronic Messages Act 2007 | NZ provider staff contacts | [[DECISION]] |
| PIPEDA and CASL (Canada) | Canadian provider staff contacts (CA work is paused) | [[DECISION]] |

### Gaps and decisions
1. Operator identity and APP-entity status. [[DECISION]]
2. Retention periods for provider contacts (for example 24 months after last confirmed), staff email copies (redact on account deletion, as DegreeAtlas does after 90 days) and counsellor reports (for example 180 days after closure). [[DECISION]]
3. A written process for access, correction and removal requests, and a privacy contact address. [[GAP]]
4. A collection notice for provider staff (APP 5), and a lawful basis for any outreach email (Spam Act). [[GAP]]
5. Overseas disclosure statement naming India (Supabase) and the AI and scraping providers. [[GAP]]
6. Make both repositories private, or remove staff personal details from them. They have been public for nine days (daily update 8 Oct). [[GAP]]

---

## 4. Terms of use

### Draft public statement

> **Terms of use**
>
> **What CourseFinder is.** CourseFinder helps international students find and compare courses. The information comes from providers' own websites and official government registers.
>
> **What you may rely on, and what you may not.**
> - Each course fact shows where it came from. Use it as a starting point.
> - CourseFinder is not an education agent, a provider, or an immigration adviser. It does not decide whether you are eligible, whether a course is open to you, or whether you will get a visa.
> - Fees, start dates and English requirements change. Always confirm them on the provider's official page before you apply or pay.
> - A provider being listed is not an endorsement, a ranking or a sign that it is admitting students. Registration information comes from the government register named on each record (for example CRICOS).
> - Where a fact is unknown, CourseFinder shows it as unknown. An empty field is never an estimate of zero.
>
> **Rankings and statistics.** [If and when shown:] Rankings are those of the named publisher, for the institution as a whole, not for a course.
>
> **Acceptable use.** Do not scrape CourseFinder in bulk, misrepresent a provider, or present CourseFinder information as an offer or as official advice.
>
> **API access (for partners).** Access to CourseFinder data through its APIs needs an issued token and a written agreement. Tokens are rate-limited and can be revoked. [Licence, attribution and service-level terms.]
>
> **No warranty.** CourseFinder is provided as is. Nothing in it is legal, financial, migration or admissions advice. Rights you have under the Australian Consumer Law are not excluded.
>
> **Governing law.** [State or territory], Australia.

### Where we stand
- The non-admissions boundary is a core design rule (Design Reference §1, Decision 1). [[IN PLACE]] in design, [[GAP]] in published text.
- "Unknown stays unknown": a field with no checked value stays empty and shows as missing in coverage (University Adapters design §12.2; "Nothing" is the third precedence step). [[IN PLACE]]
- Labour-market and migration content: never implies guaranteed employment, and migration is "never Course promises" (`project-runsheets/milestone-2/STANDING-INSTRUCTIONS.md`, A17; M25-FU-026 disclaimers OPEN; M25-FU-027 not authorised for consumers). [[PARTIAL]]
- Regional category from Home Affairs LIN 19/217: "Academic entry is not held and is never implied" (Decision 165). [[IN PLACE]]
- Consumer API controls: hashed tokens (`private.*_integration_credentials.token_sha256`), per-integration rate windows, token rotation in the admin (`src/EnvironmentMigrationWorkspace.jsx:118-122`). [[IN PLACE]]
- No written API terms, licence or attribution requirement for Wix, Zoho or future integrators. [[GAP]]
- Australian Consumer Law s18 (misleading or deceptive conduct) is the main exposure for a consumer-facing comparison site. The "confirm with the provider" wording and per-fact sources are the controls. [[PARTIAL]]
- ESOS Act 2000 and the National Code 2018 regulate registered providers and their education agents. CourseFinder is neither, but if counsellors using Zoho recruit students for providers, they carry education-agent obligations. Say clearly what CourseFinder is not. [[DECISION]]

### Gaps and decisions
- Write website terms and API terms; decide governing law and the customer entity that offers them. [[GAP]]
- Decide whether published courses must carry their CRICOS code and provider name on every view (good practice; it also anchors identity). [[DECISION]]

---

## 5. Cookie and browser storage statement

### Draft public statement

> **Cookies**
>
> [The CourseFinder data service sets no cookies. The website at [domain] is built on Wix, which sets its own cookies: [list from a scan of the live site, with purpose and consent].]
>
> **Staff admin site.** The CourseFinder admin site sets no cookies. It keeps the signed-in session and a few screen preferences in the browser's local storage, on the staff member's own device.

### Where we stand
- The admin app writes **no cookies** and uses no IndexedDB (no `document.cookie` anywhere in `src/`). [[IN PLACE]]
- No third-party scripts, fonts, analytics or trackers in the admin app (`index.html`, `src/`); fonts fall back to system fonts. Cloudflare could add a beacon outside the code; check the Cloudflare dashboard. [[PARTIAL]]
- Browser storage keys written by the admin app:

| Key | Storage | Holds | Personal? |
|---|---|---|---|
| `sb-fxcwkweaxjtknorudmwp-auth-token` (supabase-js default) | localStorage | Signed-in session | Yes (staff) |
| `coursefinder:pim:screen-state:v1:<userId>:<screen>` | localStorage | Filters and view state | User ID in key |
| `coursefinder:pim:course-detail:section-order:<userId>` | localStorage | Section order | User ID in key |
| `coursefinder:provider-contacts:columns:v1` | localStorage | Column choice | No |
| `coursefinder:compare-selection:v1` | localStorage | Compare tray | No |
| `cf:scheduler:view:v1:<actorKey>` | localStorage | Scheduler view | Actor key |
| `cf.card.<id>`, `cf.adapters.filters` | sessionStorage | Card and filter state | No |
| `coursefinder:provider-list-logo-cache:v2` | sessionStorage | Short-lived signed logo links | No |
| `coursefinder-layer1-country-result-v2`, `coursefinder-layer2a-statcan-ca-result-v1` | sessionStorage | Last run result | No |
| `cf-chunk-reload` | sessionStorage | Reload guard | No |

- The Wix website's cookies and consent banner have not been assessed. [[GAP]]

### Gaps and decisions
- Scan the live Wix site and list its cookies. If any are non-essential (analytics, marketing), decide on consent. [[GAP]]
- The admin session sits in localStorage, so a cross-site scripting flaw could read it. Security headers (section 12) reduce that risk. [[PARTIAL]]

---

## 6. Accessibility statement

### Draft public statement

> **Accessibility**
>
> CourseFinder aims to meet the Web Content Accessibility Guidelines (WCAG) 2.2 Level AA. [How it is checked.] [Known limitations.] Report a barrier to [contact], marked "accessibility", with the page, browser and any assistive technology you use.

### Where we stand
- No WCAG target is stated in code or design. [[GAP]]
- No automated accessibility testing (no axe, no contrast check). The only related test checks a release-notes dialog closes accessibly (`tests/uat/release-notes-deployed.spec.mjs:7`). [[GAP]]
- Some good practice is in place in the admin app: `lang="en-AU"`, 289 `aria-label`, 92 `role=` attributes, `role="switch"` with `aria-checked`, visible focus styles in 10 places, one reduced-motion rule. Colours come from a single tokens file (`scripts/verify-ui-tokens.mjs`) but contrast is not verified. [[PARTIAL]]
- Design rules: labels unique for assistive technology (Design Reference §7 rule 4); "accessibility and readable contrast are part of acceptance" (`docs/01-governance/coursefinder-pim-operating-principles-v1.0.md`). [[PARTIAL]]
- The student website is built in Wix; its accessibility is outside these repositories. The Disability Discrimination Act 1992 applies to it. [[DECISION]]

### Gaps and decisions
- Adopt WCAG 2.2 AA as the target for any consumer surface; add an automated contrast and axe check to the release gate. [[DECISION]]

---

## 7. Commercial disclosure

### Draft public statement

> **Commercial disclosure**
>
> CourseFinder shows no advertising, no sponsored listings and no paid placement. No provider pays to appear or to be ranked higher. Course order reflects your search, not payment. A provider correcting its own information is never charged.
>
> [If commercial arrangements are introduced, they will be labelled, kept separate from factual results, and described on this page before they go live.]

### Where we stand
- No payments, pricing, sponsored, featured, partner, commission, affiliate or referral features in code or design (no Stripe or Paddle). [[IN PLACE]]
- The consumer API documentation says "Commercial/CRM re-ranking remains a Zoho-side concern" (`docs/m1-search-governed-projection-uat-2026-08-19.md:75`). If Zoho or the website re-orders results for commercial reasons (for example partner providers), the disclosure must say so. [[DECISION]]
- Rankings: QS and THE are provider context, not course quality (Decision 44); not exposed to consumers (M25-FU-035; CF-247 notes QS out of scope because of commercial licensing). [[IN PLACE]]

### Gaps and decisions
- Confirm whether the customer's business earns commission from providers (education agency model). If so, ACL and agent-transparency expectations call for a clear disclosure. [[DECISION]]

---

## 8. AI and model use

### Draft public statement

> **AI and model use**
>
> **Nothing a student types is sent to an AI model.** Search on CourseFinder does not use a language model.
>
> **Where models are used.** Models are used only behind the scenes, to help check course facts read from providers' official pages: start months, English requirements and tuition fees, and to suggest which page belongs to which course.
>
> **What models are never allowed to do.**
> - Change a value a person has entered or locked.
> - Replace a value that is already held. A model's answer can only fill an empty field, and only for a model that has passed its qualification test.
> - Decide anything about a student.
> - Act on instructions found in a web page. Page text is treated as data.
> - Switch itself on. A model that passes its test stays off until a person switches it on.
>
> **How models are chosen.** Each task uses specific, named models, each tested on a fixed set of known answers. A model must get at least 80% right with no wrong value accepted. Every result records which model gave it and what it cost. Answers a model is unsure of go to a person.

### Where we stand

**8.1 Models in use (live, 8 Oct 2026)**

| Task | Tier 1 | Tier 2 | Tier 3 | Via |
|---|---|---|---|---|
| English requirement check | `qwen/qwen3-30b-a3b-instruct-2507` | `mistralai/mistral-small-3.2-24b-instruct` | `xiaomi/mimo-v2.6-pro` (final) | OpenRouter |
| Intake (start month) check | `qwen/qwen3-30b-a3b-instruct-2507` | `xiaomi/mimo-v2.6-pro` | `moonshotai/kimi-k2-0905` (final) | OpenRouter |
| Tuition check | `qwen/qwen3-235b-a22b-2507` (hand-off paused on purpose) | — | — | OpenRouter |
| Course page matching | `qwen/qwen3-30b-a3b-instruct-2507` (chooses a page, never admits a value) | — | — | OpenRouter |
| Adapter builder proposals | `qwen/qwen3-30b-a3b-instruct-2507` (proposes only) | — | — | OpenRouter |

Source: `pipeline.layer3_route_tiers` joined to `pipeline.layer3_model_profiles` (live); `coverage-sweep/index.ts` `AI_MATCH_MODEL`; `20261008000100_cf247_builder_sampling_and_model.sql`.

**8.2 Controls**
- Pinned models only. `isPinnedModel()` rejects any "auto" or router model; requests set temperature 0, a strict JSON schema and `provider.require_parameters=true` (`supabase/functions/_shared/cf247-model-routing.ts`). [[IN PLACE]]
- Qualification is bound to model, prompt, schema and validator (D89); a passing test never activates a model (D90, D188); new profiles start paused (D100); no fallback to a switched-off model (D221); frozen holdouts (D230). Tier rule: at least 80% right and 0 wrong admitted (D172; live `qualified_by` records). [[IN PLACE]]
- Admission: `security.layer3_fact_admit_v1` writes only into empty fields; hand-entered and locked values are protected by triggers (`pipeline.manual_locks`, `20260930120000`). [[IN PLACE]]
- Screenshots are never AI input (D29). [[IN PLACE]]
- Layer 4 human review takes every item a model cannot settle, with a plain reason (`_shared/cf247-model-routing.ts` lines 12–16). [[IN PLACE]] 1,769 items waiting, none decided by a person for five days (daily update 8 Oct). [[PARTIAL]]
- Spend guards: route budgets per day (`pipeline.layer3_route_budget`), routes stop below US$5 OpenRouter credit, builder US$0.50 and 30 proposals a day. [[IN PLACE]]
- Prompt-injection posture: "Page content is data" (University Adapters design §6.2). [[PARTIAL]] Stated in design; not tested.
- Personal data in prompts: not intended (prompts carry course page text). Not tested; provider-contact functions do not call models. [[PARTIAL]]
- Automated-decision transparency (Privacy Act reform from 10 Dec 2026): CourseFinder makes no decisions about individuals. [[N/A]] Confirm and state it.

### Gaps and decisions
- Be precise in the public wording. Unlike DegreeAtlas, CourseFinder does let a qualified model fill an empty field without a person. Say so plainly rather than claiming "a person checks every value". [[DECISION]]
- Name the model providers' data-use terms (OpenRouter and each upstream provider: whether prompts are retained or used for training) and pick providers with no-training terms. [[GAP]]

---

## 9. Data sources and methodology

### Draft public statement

> **Where CourseFinder's information comes from**
>
> **Registers.** Which providers and courses exist comes from official government registers: CRICOS for Australia, NZQA for New Zealand, and the IRCC Designated Learning Institutions list for Canada.
>
> **Provider pages.** Course facts come from each provider's own course pages, read with reading rules set up for that provider. Pages are read no more often than needed, robots.txt instructions are followed, and pages behind sign-ins or paywalls are never read.
>
> **Order of trust.** For each fact: a value entered by a person always wins; then the course's own page; then a linked page from it; then the provider's handbook; then a provider-wide page (for example its English requirements page), approved by a person. Directory and aggregator sites are never used as a source.
>
> **Unknown stays unknown.** If no checked source gives a value, the field stays empty.

### Where we stand
- Four-layer model: Layer 1 registers, Layer 2 find and read, Layer 3 pinned model checks, Layer 4 people (Adapter Coverage Wave Plan §3). [[IN PLACE]]
- Precedence and admission by field: University Adapters design §4.2, §11.1, §12.2; course exclusions never deleted (§11.2); every replacement logged in `adapter_overwrite_changes`. [[IN PLACE]]
- Identity rule: a page counts only when it carries the course's CRICOS or provider code or matches its title exactly; failed "better pages" are undone automatically (`better-page-revert`). [[IN PLACE]]
- robots.txt honoured (RFC 9309) in the coverage reader and directory capture (`coverage-sweep/extract.ts` `robotsAllows()`); VTAC not crawled because it disallows all. [[PARTIAL]] Not checked in the Layer 1 per-college scrapers or Layer 2 functions.
- Never circumvent logins, paywalls or bot controls (ranking design "Manual publisher artifact fallback"; QS "Cloudflare-challenged … no bypass attempted"). [[PARTIAL]] Firecrawl's `stealth` / `enhanced` proxy settings and ZenRows "anti_bot" are available in settings; confirm they are not used against sites that refuse readers.
- User agents: most readers identify as CourseFinder with a contact URL. Three functions (`ranking-layer1-etl`, `ranking-qs-source-recovery`, `coursefacts-au-qut`) send a plain browser user agent. [[PARTIAL]]
- Refused hosts (archive, staging, test) and aggregator exclusion (`pipeline.important_links.uses`; Adapter Lessons §1). [[IN PLACE]]
- Course descriptions are the provider's own text, 200–1,000 characters, no AI rewriting, shown with attribution and a link (Decision 140). [[IN PLACE]] in design.
- Site terms that forbid automated access are followed (Decisions 167, 232, 233). Hotcourses needs legal review before wider use; XuanXiao is reference only. [[IN PLACE]]

---

## 10. Source licence and attribution register

DegreeAtlas publishes a register listing every dataset with publisher, licence, vintage and retrieval date, plus the attribution wording each licence requires. CourseFinder has no such register. This is the draft.

| Source | Publisher | Used for | Licence (as published by the source; confirm) | Recorded in CourseFinder? | Shown to consumers? |
|---|---|---|---|---|---|
| CRICOS (data.gov.au) | Australian Government Department of Education | AU providers, courses, codes, register fees | CC BY 2.5 AU, attribution required | [[GAP]] No licence or attribution recorded | Yes, when courses publish |
| NZQA provider and qualification pages | New Zealand Qualifications Authority | NZ providers and qualifications | To confirm (NZ Government copyright terms) | [[GAP]] | Yes |
| NZQA Rule 18 English table | NZQA | NZ English requirements | To confirm | [[GAP]] | Yes |
| IRCC Designated Learning Institutions list | Immigration, Refugees and Citizenship Canada | CA providers (CA Layer 1 paused) | To confirm (canada.ca terms) | [[GAP]] | Not yet |
| Statistics Canada PSIS | Statistics Canada | Statistics (staff only) | Statistics Canada Open Licence | [[GAP]] | No |
| Ontario open data | Government of Ontario | CA reference | Open Government Licence – Ontario | [[GAP]] | No |
| QILT survey reports | Social Research Centre for the Department of Education | Statistics (staff only; not admitted) | To confirm | [[GAP]] | No |
| PRISMS enrolment data | Department of Education | Statistics (staff only) | To confirm | [[GAP]] | No |
| Australia Awards, Study Australia, NZ Scholarships, EduCanada | DFAT, Austrade, MFAT, Global Affairs Canada | Scholarships (360 published) | To confirm per site | [[GAP]] | **Yes, today** |
| Home Affairs LIN 19/217 regional postcodes | Department of Home Affairs (Federal Register of Legislation) | Regional category | To confirm | [[GAP]] | Yes |
| DAAD international programmes | DAAD | Germany (paused) | To confirm | [[GAP]] | No |
| QS World University Rankings | QS Quacquarelli Symonds | Provider context (staff only) | Commercial; "licensed upload" | [[PARTIAL]] `access_status='licensed_upload'`; licence terms not filed | No (M25-FU-035) |
| Times Higher Education rankings | THE | Provider context (staff only) | Commercial | [[PARTIAL]] | No |
| ARWU | ShanghaiRanking Consultancy | Planned | Commercial | [[PARTIAL]] | No |
| Hipo university-domains-list | Hipo (GitHub) | Provider domain hints | MIT | [[IN PLACE]] (`20261002185500`) | No |
| Provider course pages | Each provider | Course facts and short descriptions | Provider copyright; facts extracted, descriptions quoted with attribution | [[PARTIAL]] Evidence kept per page | Yes |
| Provider logos | Each provider | Logos | Redistribution rights not confirmed; initials shown instead (CF-247) | [[IN PLACE]] (held back) | No |
| Apollo | Apollo.io | Contact title enrichment | Commercial subscription | [[PARTIAL]] "Licensed" label only | No |

Country source matrix gate 8 ("licensing, redistribution and product-use terms are acceptable") is asserted as passed for Australia but not evidenced (`docs/coursefinder-country-authoritative-source-matrix-v1.0.md`). [[GAP]]

### Gaps and decisions
- Add `licence`, `licence_url`, `attribution_text` and `retrieved_at` to the source registry (`pipeline.sources`) and show attribution beside published values, as DegreeAtlas does. [[GAP]]
- Draft CRICOS attribution: "Contains CRICOS register data © Commonwealth of Australia (Department of Education), licensed under CC BY 2.5 AU. Modified: fields selected and restructured by CourseFinder." [[DECISION]]
- Confirm terms for the four scholarship sources before more scholarships publish. [[GAP]]

---

## 11. Corrections and feedback

### Draft public statement

> **Report a problem**
>
> If a course fact is wrong, tell us: the course, what is wrong, and a link to the provider page showing the right value. A correction never changes CourseFinder because it was requested; it is checked against the provider's own page first. Providers correcting their own information are never charged. [Form or email.]

### Where we stand
- Counsellors can report a wrong fact from Zoho (`zoho-course-api` `report` action → `public.zoho_edge_report_v1` → `pipeline.data_flags`; D238a). 0 reports stored so far. [[PARTIAL]]
- All corrections go through Layer 4 with a reason and are reversible (P4). Hand-entered values then win over automated readers (`pipeline.manual_locks`). [[IN PLACE]]
- No public correction route for students or providers. [[GAP]]

### Gaps and decisions
- Decide the public route (website form into the same `data_flags` queue, or a monitored mailbox), its retention and its reply commitment. [[DECISION]]

---

## 12. Security posture (internal; summary may be published)

| Control | State | Reference | Status |
|---|---|---|---|
| Row-level security | On for most tables; access only through role-checked functions. 39 tables have RLS off; none is granted to the public (`anon`); one (`ref.nationality_terms`) is readable by signed-in users | Live check 8 Oct; M25-FU-041 | [[PARTIAL]] |
| Public (`anon`) access | No table grants to `anon`; anon execute removed from definer functions | Live check; `20260926070000` | [[IN PLACE]] |
| Storage buckets | All three private (`evidence`, `adapter-captures`, `provider-assets`); access by 60-second signed links | Live check | [[IN PLACE]] |
| Secrets | Supabase Vault, write-only; consumer tokens stored as SHA-256 hashes | D77, D99, CF-207 | [[IN PLACE]] |
| Multi-factor sign-in | 0 MFA factors enrolled for 8 staff accounts | Live check; runbook §6.5 plans MFA | [[GAP]] |
| Leaked-password protection | Pilot PASS (CF-022); production repeat open (M25-FU-002) | CF-049 | [[PARTIAL]] |
| Security headers on the admin site | No CSP, HSTS, X-Frame-Options or Permissions-Policy | `wrangler.jsonc`; no `_headers` | [[GAP]] |
| Repository visibility | Both repositories public for nine days | Daily update 8 Oct | [[GAP]] |
| Dangerous helper | `security.zz_probe_v1()` (can delete every row of a course-source table; owner only). Platform Admin chose to leave it for now | Daily update 8 Oct | [[DECISION]] |
| Backups and restore | Daily, 7-day retention; restore not proven | CF-056, M25-FU-005 | [[PARTIAL]] |
| Audit trail | Settings, admissions, overrides and purges logged with actor and reason | D184, D238, `admin_control_events` | [[IN PLACE]] |
| Breach response | No procedure; no alerting by email | — | [[GAP]] |

---

## 13. Contact and operator imprint

### Draft public statement

> CourseFinder is operated by **[Operator legal name]**, ABN [ABN], [registered address].
> - General: [email]
> - Privacy requests: [email], marked "privacy"
> - Corrections: [form or email]
> - Accessibility: [email], marked "accessibility"
> - Source rights and takedown: [email], marked "rights"

### Where we stand
- The operator is not named anywhere in either repository. The design says the customer owns every account and is never named (Decision 164; production runbook §1–§4). Customer accounts are eight days overdue (daily update 8 Oct). [[DECISION]]
- Current infrastructure sits with the MSP (Supabase org `techM`, GitHub account `msinghbs-ai`). The privacy policy must name whoever is the data controller at go-live. [[DECISION]]

---

## 14. Not applicable today

| DegreeAtlas page | Why not applicable | Revisit when |
|---|---|---|
| Refund policy (paid API) | No paid product | A paid API or subscription is introduced |
| Institution claim / partnership intake forms | No provider self-service | Providers can edit their own records |
| Eligibility engine statement | CourseFinder does not compute eligibility | Eligibility features are proposed |

---

## 15. Gap register and recommended order

| # | Item | Owner | Priority | Before |
|---|---|---|---|---|
| G1 | Name the operator; decide APP-entity status | Customer | Critical | Any publication |
| G2 | Make repositories private or scrub personal details | Platform Admin | Critical | Now |
| G3 | Enrol MFA for all staff accounts | Platform Admin | Critical | Now |
| G4 | Breach response procedure (NDB scheme, NZ and Canada equivalents) | Customer and MSP | Critical | Any publication |
| G5 | Privacy policy (sections 3.1–3.4) and collection notice for provider staff | Customer, counsel | High | Course publication |
| G6 | Personal-data retention rules (contacts, `actor_email`, reports) and a removal process | Platform Admin | High | Course publication |
| G7 | Website terms and API terms | Customer, counsel | High | Course publication |
| G8 | Source licence and attribution register; CRICOS attribution on published courses | Platform Admin | High | Course publication |
| G9 | Confirm scholarship source terms (360 already published) | Platform Admin | High | Now |
| G10 | Security headers on admin site; drop `security.zz_probe_v1()`; RLS review of 39 tables | MSP | High | M2.4.9 |
| G11 | Cookie scan of the Wix website | Customer | Medium | Course publication |
| G12 | WCAG 2.2 AA target and automated checks | MSP | Medium | Course publication |
| G13 | AI providers' data-use terms; confirm no personal data in prompts | Platform Admin | Medium | M2.4.9 |
| G14 | Public corrections route | Customer | Medium | Course publication |
| G15 | Commercial disclosure decision (Zoho re-ranking, any commission) | Customer | Medium | Course publication |
| G16 | robots.txt in Layer 1 per-college and Layer 2 readers; CourseFinder user agent everywhere; no stealth proxy against refusing sites | MSP | Medium | M2.4.9 |
| G17 | External legal review of this pack | Customer | High | Publishing any of it |

Recommendation: add G1–G10 to the CF-049 production readiness gate, which today lists security items only and no privacy or legal items, and treat G17 as a GO/NO-GO condition at M2.4.9.

---

## 16. Assumptions

- The student website is the Wix site that calls `website-course-api` / `wix-course-api`; it is outside these repositories and was not inspected.
- "Published" means `publication_status='published'` in the search projection and scholarships tables. The course APIs do not yet enforce published-only and currently return unpublished courses (daily update 8 Oct, risk 7). Until the planned single step (first publish plus filter switch) is done, any statement that "nothing is published" is only true of the public website, not of the APIs. [[GAP]]
- Laws listed are for discussion with counsel. This pack does not decide whether any law applies.
- Live counts are as read on 8 Oct 2026 and will change.

## Appendix A — DegreeAtlas pages reviewed (8 Oct 2026)

| Page | What it covers | Used here for |
|---|---|---|
| degreeatlas.org/legal | Hub, "what we publish" box, status of documentation | §2 structure |
| /legal/privacy | Per-key browser storage, what reaches the host, forms, every table with columns and retention, disposition job, who can read submissions | §3 depth and table-by-table honesty |
| /legal/terms | Preproduction status, what you may and may not rely on, API subscriptions, attribution, no warranty | §4 |
| /legal/refunds | Paid API refund rules | §14 (N/A) |
| /legal/cookies | "No cookies", localStorage keys listed | §5 |
| /legal/accessibility | WCAG 2.2 AA, automated contrast and colour-blindness checks | §6 |
| /legal/disclosure | No ads, rule for any future commercial units | §7 |
| /legal/ai-use | No model in browser, models only in pipeline, never write canonical data | §8 |
| /methodology, /methodology/authority, /methodology/evidence | Source, evidence model, five-part evidence standard, open-data attribution register | §9, §10 |
| /corrections | Public correction form, storage and retention | §11 |
| /contact, /about | Operator, imprint not yet supplied | §13 |
