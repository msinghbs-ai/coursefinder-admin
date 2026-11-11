# Provider descriptions — runbook

**Version:** 1.0 (11 Nov 2026) · **Change control:** CF-247 F-PDESC · **Rules:** `DATA-PIPELINE-OPERATING-MODEL.md` §3.3.1 · **In the app:** Guides › Platform Admin SOP and Operator SOP; Help › Platform guide › Specialist tasks

How the platform writes each provider's description, when it runs, who does what, and how to speed it up, slow it down or stop it. Settings are named as they appear on screen; the key is in brackets. Values change on screen with a reason, so this runbook gives the controls, not today's numbers (the screens show those).

## 1. What it does

For every live provider (active and published) with no description, or only the short profile built from a register, the platform reads the provider's own About page and has a pinned AI model write a short, neutral description with the prompt the Platform Admin keeps on screen. Every sentence must be backed by a passage on that page. A description that passes is admitted automatically or waits for a person in Layer 4. A description typed by hand is never replaced.

## 2. How it works

| Step | What happens | Where it shows |
|---|---|---|
| 1. Queue | Live providers with no description (or only the register profile) are queued. Providers asked for with **Fill description** go first. | Coverage; Provider description prompt card (queued, on demand waiting) |
| 2. Find the page | The worker takes the stored copy of the provider's own About page, or finds the About link on its home page. Wrong host, another provider's site or a page that is not About or Overview stops here, before any AI call. | Held with its reason |
| 3. Read | Directly first, with robots.txt respected. Through Firecrawl only when the site refuses, within the Firecrawl reads ceiling and daily share. The page is kept as evidence. | Firecrawl use on the card |
| 4. Identity | The page must prove the provider's current name before any AI call. | Held: name not proved, name conflict |
| 5. Write | The pinned model writes two to five sentences with the active prompt (Models & services › AI & OpenRouter › Provider description prompt). Each sentence lists the passages it rests on. | AI spend on the card |
| 6. Check | Each passage must be on the page (compared in one form that ignores spacing around tags and quote or dash shapes; words and numbers exact). Every number must be in its passage. The first sentence names the provider (any of its name forms: without "Pty Ltd" or "Limited", each comma-listed trading name, "&" as "and"). No refused topic (rankings, awards, outcomes, promotion, fees, visas). Length and duplicates are checked. | Held with the rule that failed |
| 7. Admit | Passed descriptions are admitted automatically when they carry no refused topic, marketing wording or word kept for a person ("accredited"). Figures pass because step 6 proved them. Otherwise the description waits in **Layer 4 › Inbox**. Waiting items are checked again hourly, a few each run. | Admitted in 24 hours; Layer 4 |
| 8. Recover | Self-heal reads again, once, the answers held under an older prompt version when a new one is saved. It puts back reads stopped only by the Firecrawl allowance once it renews. It re-records answers held only because the model said the page does not describe the institution. | Self-heal last run on the card |

**Fill description (on demand).** A Curator or above opens a provider (or ticks several in the Providers list, up to the providers in one Fill click limit), presses **Extract / refresh description now**, then **Fill description**. No reason is needed. The read starts at once and goes ahead of the regular queue for the on-demand priority window. It is **not** held by the task's own AI spend ceiling, OpenRouter daily guard or Firecrawl daily share. It **is** held by a description typed by hand, an identity that cannot be proved, the platform-wide AI rule (credit floor, platform ceiling) and the Firecrawl monthly limit. Fill says why when it cannot start: written by hand, already described, not active and published, identity not proved, already being read.

## 3. Schedule

| Job (Scheduled jobs › Automations) | When | What one run does | Control on Automations |
|---|---|---|---|
| Provider descriptions: find, read and propose (`provider-description-read`) | Every 5 minutes, at :01, :06 … :56, and at most once every **Provider descriptions: run every** (`pdesc.every_minutes`) | Settles waiting items for automatic admission (**waiting items settled a run**, `pdesc.machine_settle_per_run`), then sends the coverage-sweep worker up to **providers a run** (`batch.provider_description`) | Platform Admin |
| Provider descriptions: recover held answers, Firecrawl-stopped reads and reads for a new prompt (`provider-description-self-heal`) | Every 10 minutes, at :03, :13 … :53 | The three recoveries of step 8, each capped by its setting | PIM Admin |
| Fill description | When a Curator or above presses it | Queues the chosen providers and starts the worker at once | — |

Both jobs do nothing while **Provider descriptions: reader on** (`pdesc.enabled`) is 0.

## 4. Controlling throughput

All on **Settings › Pipeline settings › Provider descriptions** unless named. Each change needs a reason and is reversible on the same screen.

| To | Change | Effect |
|---|---|---|
| Write more per run | **Providers a run** (`batch.provider_description`, up to 10) | More providers each 5-minute run (more AI and Firecrawl use per hour) |
| Run less often | **Run every** (`pdesc.every_minutes`, 5 or more minutes) | The 5-minute job skips runs until the interval has passed |
| Allow more AI spend overall | **AI spend ceiling (all reads)** (`pdesc.ai_usd_max`) | The regular reader stops at this total; Fill does not |
| Allow more AI spend a day | Models & services › AI & OpenRouter: **Daily guard: provider descriptions with AI** (`guard_provider_description`) | The regular reader stops for the day at this amount |
| Allow more Firecrawl | **Firecrawl reads ceiling (all reads)** (`pdesc.firecrawl_reads_max`) within its **allowance window**; Models & services › Services & limits: **Daily share: provider descriptions** (`daily_share_pdesc`); **Firecrawl reads one worker call may start** (`pdesc.firecrawl_per_call`) | More sites that refuse direct reads can be read |
| Clear the automatic-admission queue faster | **Waiting items settled a run** (`pdesc.machine_settle_per_run`) | More waiting descriptions checked again each run |
| Recover faster after a prompt change | **Held answers re-checked a run** (`pdesc.self_heal_per_run`) and **Firecrawl-stopped reads put back a run** (`pdesc.self_heal_requeue_per_run`) | More held reads go back each 10 minutes |
| Retry harder | **Tries a read** (`pdesc.tries`) | Failed reads are tried more times before they are listed as dead letters |
| Bigger Fill batches | **Providers in one Fill click** (`pdesc.fill_max_per_click`); **On-demand priority** (`pdesc.on_demand_minutes`) | More providers per click; how long a Fill stays ahead of the queue |
| Change the wording | Models & services › AI & OpenRouter › **Provider description prompt** (Platform Admin): edit, Save with a reason | A new version at once; held answers are read again once with it |

The platform-wide limits still apply on top: the OpenRouter credit floor and platform ceiling, and the Firecrawl monthly plan.

## 5. Stopping

| To stop | Do | Who | What happens |
|---|---|---|---|
| Everything (reader, self-heal, Fill) | **Reader on** (`pdesc.enabled`) to 0 | Platform Admin | Runs return at once; queued reads stay queued; nothing is lost. Back to 1 to resume |
| The regular reader only | Pause **Provider descriptions: find, read and propose** on Scheduled jobs › Automations, with a reason | Platform Admin | No new regular reads or automatic settling; Fill still starts the worker |
| The self-heal only | Pause **Provider descriptions: recover held answers …** on Scheduled jobs › Automations, with a reason | PIM Admin | No re-records or put-backs |
| Automatic admission | **Automatic admission (source-verified)** (`pdesc.machine_admit_on`) to 0 | Platform Admin | Every passed description waits for a person in Layer 4 |
| Figures in automatic descriptions | **Figures allowed in an automatic description** (`pdesc.machine_numbers_allowed`) to 0 | Platform Admin | Descriptions with a figure other than a founding year wait for a person |
| Firecrawl | **Firecrawl when a site refuses** (`pdesc.acquire_firecrawl`) to 0 | Platform Admin | Sites that refuse direct reads are held, not read |
| The prompt | **Use the prompt from Settings** (`pdesc.prompt_on`) to 0 | Platform Admin | Back to the built-in prompt and its word rules (and the earlier automatic-admission word lists) |
| One provider | Type its description by hand on the provider record | Curator and above | Kept as written by hand; Fill, the reader and the AI never replace it |

A Pipeline Operator does not pace or pause these jobs: note the job, the error and when, and raise it with the PIM Admin (self-heal) or Platform Admin (reader).

## 6. Who does what

| Role | Does |
|---|---|
| Curator (rank 3) | Fill description; corrects a provider's description on the record (kept as written by hand); reads Layer 4 provider description items |
| Pipeline Operator (rank 4) | Decides Layer 4 provider description items (Approve or Reject with a reason, against the stored About page); reports a failing job |
| PIM Admin (rank 5) | Pauses or resumes the self-heal job |
| Platform Admin (rank 6) | Maintains the prompt; every setting in §4 and §5; pauses or resumes the reader |

## 7. What to watch

On the **Provider description prompt** card (Models & services › AI & OpenRouter):

- AI spend against the ceiling and the daily guard;
- Firecrawl use against its allowance and daily share;
- admitted in 24 hours, described, queued, on demand waiting, held, written by hand;
- the reader's and the self-heal's last runs.

Signals:

- **Admitted in 24 hours flat while the queue is not empty.** Check the reader's last run, then the limits.
- **Many held with the same rule.** Read three of them against their pages. A prompt or check issue goes to the Platform Admin.
- **Layer 4 provider description items rising.** These are marketing wording, a refused topic or "accredited". A person decides them.

## 8. History

| Version | Date | Change |
|---|---|---|
| 1.0 | 11 Nov 2026 | First issue (Platform Admin 11 Nov 2026 21:04), after the prompt-based design (Pilot #1024 to #1031). |
