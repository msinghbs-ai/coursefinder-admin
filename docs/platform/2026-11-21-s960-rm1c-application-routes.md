# s960: Australian application routes (RM1C) into a draft edition

**Lane:** 2 (`S2-Data-Destination-Continuous`) · **Asked:** Platform Admin, 21 Nov 2026 21:16 AEDT (first item chosen 21:19: AU rule drafts) · **Pilot:** #1466 · **Migration:** `20261122040000_cf247_s960_rm1c_au_application_routes.sql` · **Spec:** s960

## Business objective

A student looking at an Australian course should see how international students apply: directly to the provider, through an education agent, or through the state's admissions centre. Each route must come from an official page, word for word, and apply only where it is true. For example, the UAC route applies to New South Wales and the ACT, not to the whole country.

## What was captured

| Rule (application route, international students) | Official page | Applies to |
|---|---|---|
| Apply directly to the education provider | Study Australia, How to apply to study | Australia |
| Apply through an education agent | Study Australia, How to apply to study | Australia |
| Undergraduate through UAC (Australian Year 12, IB Diploma or NCEA Level 3); all others apply directly | UAC, Steps to uni for international Year 12 students | NSW, ACT |
| Undergraduate through VTAC (international Australian Year 12 students); others apply directly | VTAC, Quick start guide for international students | VIC |
| Undergraduate through SATAC (listed Australian Year 12 or IB Diploma); others apply directly | SATAC, International applicants | SA, NT |

Each pattern was run through the loader's own text and match code against the page's static HTML on 21 Nov 2026 (21:40 to 22:10 AEDT); all five were found with verbatim quotes.

**Not captured (no guess):**
- QTAC (QLD): its statement for international applicants is not in the page's static HTML.
- TISC (WA): no official TISC page for international applicants was found.
- Tasmania has no admissions centre; the national "apply directly" rule covers it.

## Design

| Part | What it does |
|---|---|
| `destination.page_facts.state_codes` | New nullable column: the states (`ref.subdivisions` codes) a fact's rule applies to. Null means the whole country, as before. |
| Layer 1 Register › Australia | Study Australia, UAC, VTAC and SATAC are registered as destination page-facts sources. They are checked monthly and not auto-ingested. |
| Edition | Draft study-rules edition "Australian application routes (Study Australia and admissions centres)", with terms **pending**. |
| Facts | Five text facts in category `application_route`, scope "international student", all read directly (static, no Firecrawl). |
| Loader function | `security.destination_page_facts_load_v1` (md5-guarded, `a81d0f62` → `c34e7946`). A rule from a fact that names states gets one proven `state` applicability per state instead of the country one; a single state is kept in `study_rules.state_code`; a copied rule keeps its state. |
| Loader edge function | `layer1-destination-geo-loader` v1.6.0 adds scope `static`: only pages read directly; every rendered (Firecrawl) page and the workbook are skipped, so it costs $0. |
| Live on deploy | Workflow "Destination page facts (static read)" runs the static read once after deploy and reads the drafts back. The monthly job (3rd of the month, currently paused) reads every fact as before. |
| Consumer API | Unchanged. Once the edition is published, `destination_read_v1` already returns each rule's applicability list, state entries included. |

## Platform Admin actions

1. Set the edition's reuse terms (Destination data › Study rules). Study Australia is an Australian Government site; UAC, VTAC and SATAC are copyright, quoted as short factual rules.
2. Approve the five draft rules and publish the edition.

## Guardrails

- G3: 75 functions / 48 tables, no drift.
- Manual locks: 7,585.
- Jobs: 135 active, none added.
- Spend: $0 AI, $0 Firecrawl.
- Nothing dropped, deleted or published.

## Evidence

The rolled-back dry run used a synthetic load and gave:
- 5 facts found and 5 rules written, all draft.
- Applicability: country AU ×2; AU-NSW and AU-ACT; AU-VIC (with `state_code` AU-VIC); AU-SA and AU-NT.
