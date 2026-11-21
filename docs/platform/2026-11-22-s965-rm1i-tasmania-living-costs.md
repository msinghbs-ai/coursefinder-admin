# s965: Tasmania-wide living costs (RM1I) as draft figures

**Lane:** 2 (`S2-Data-Destination-Continuous`) · **Asked:** Platform Admin, 22 Nov 2026 00:11 AEDT (IR-008 approved) · **Pilot:** #1472 (merged `34e31e05`, live 22 Nov 2026 01:40 AEDT) · **Migration:** `20261122100000_cf247_s965_rm1i_tasmania_living_costs.sql` · **Spec:** s965

## Business objective

A student looking at a Tasmanian course should see what it costs to live there each week, from an official source, attributed and clearly labelled as Tasmania-wide.

## Source

Migration Tasmania (Tasmanian Government), "Live in Tasmania", `migration.tas.gov.au/live_and_work/live_in_tasmania`, page last updated 28 July 2026. I read it as plain HTML on 22 Nov 2026 at 00:20 AEDT: $0, no Firecrawl, no AI. The page says the costs are approximate and in Australian dollars. Study Tasmania's living-expenses page no longer gives figures (IR-008).

| Weekly cost (AUD) | Low | High |
|---|---|---|
| Renting a whole house | around 550 | |
| Shared accommodation or a single room | 150 | 250 |
| Utility bills (water, electricity, gas) | 30 | 50 |
| Internet | 15 | 25 |
| Phone | 25 | 35 |
| Public transport | 20 | 45 |
| Grocery items | 70 | 150 |
| Food and entertainment | 50 | 150 |

## Design

| Part | What it does |
|---|---|
| Layer 1 Register › Australia | Migration Tasmania, checked monthly, not auto-ingested. |
| `destination.locality_metrics` | 75 draft `living_cost` figures: 15 for each Tasmanian locality held, found as ABS Significant Urban Areas with code `6…`, not by name. They are Hobart, Launceston, Devonport, Burnie–Somerset and Ulverstone. Each figure is stored in AUD per week. Each range is stored as a low and a high figure. |
| Attribution | "Living costs: Migration Tasmania, Live in Tasmania (migration.tas.gov.au), Tasmanian Government. Approximate weekly costs for Tasmania as a whole (Tasmania-wide), not specific to <locality>." Each row also keeps its verbatim line from the page. |
| Edition | `Migration Tasmania weekly living costs (Tasmania-wide), page of 28 Jul 2026` |

## Platform Admin action

Sign off the terms (Tasmanian Government copyright and disclaimer, tas.gov.au/stds/codi.htm). Then approve the edition in Destination data, which uses `admin_destination_figures_bulk_approve`. Nothing is approved by this change.

## Guardrails

- G3: 75 functions / 48 tables, no drift.
- Manual locks: 7,585.
- Jobs: 137 active, none added.
- Spend: $0 AI, $0 Firecrawl.
- Nothing dropped or deleted.
