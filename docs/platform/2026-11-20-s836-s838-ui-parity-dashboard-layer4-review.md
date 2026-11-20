# S1-UI-Parity s836 to s838: Dashboard, Layer 4 Review by rule, card polish and Platform Health rates

**Chat:** S1-RM-Design · **Trigger:** Platform Admin 20 Nov 2026 14:40 and 14:41 AEDT (parity with the approved s820–s827 mockup); lane roster 15:25 (specs s836–s839, migrations ≤ `20261120145500`)
**Release:** PIM Admin **v2.16.68** (package 0.1.490) · **Pilot PR:** #1424 (`cf247-s836-s838-ui-parity`) · **Migration:** `20261120145000_cf247_s836_s838_rule_groups_pulse_rates.sql`
**Status (20 Nov 2026 16:20 AEDT): live.** Admin #694 (`fd310dcb`), Pilot #1424 (`13256fba`, v2.16.68); migration applied by Deploy on merge, history md5 `8f00baa9` = file; read back and checked signed in (runsheet entry of 16:20). Follow-up **s839** live 16:35 AEDT (admin #699, Pilot #1429 `4a0695c8`, v2.16.69): plain hold reason on course description cards in every view, and Preview the batch read ahead so it opens in under 300 ms.

## 1. Pre-flight (read only)

| Check | Result |
|---|---|
| Live `schema_migrations` (rolled-back probe, 15:40) | 2,219 rows, head `20261120143000` (s833) |
| Pilot `origin/main` | `98656714f` (#1422 s833, #1421 s832) |
| Open PRs | Pilot #1423 (S1-AER s834/s835, migration `20261120163000`); admin: none |
| Live `md5(pg_get_functiondef)` | `public.admin_layer4_inbox` `f458ded2…`; `security.ops_pulse_refresh_v1` `8aa5a729…` |
| G3 | 75 functions, 48 relations, no drift · manual locks 7,585 |

## 2. What each item does

| Id | Change | Where |
|---|---|---|
| s836 | **Dashboard.** Order: role line, five cards, Active failures (operators and above), Continue where you left off (3 most recent). Removed: Waiting for your approval, Waiting for you, Also, the four summary cards and the Layer 2/3 › Operations link. Spend card shows "of the US$14.00 daily cap" and its bar. **Cause:** the pulse read `openrouter_daily_ceiling_usd`, but the budgets check writes `ai_daily_ceiling_usd`. **Fix:** a pulse fragment, plus a client fallback to the budgets check. Active failures lists genuine failures and warnings only (`dashboardFailures`). | `src/Dashboard.jsx`, `src/health-exec.js`, `src/lib/ops-pulse.js`; migration fragment |
| s837 | **Layer 4 Review opens on Review by rule.** The left rail groups every waiting item of the chosen queue by its rule, across the whole queue (`rule_groups`). The right shows one focused card, read by key (`rule_group_items`). Preview the batch lists the exact records. Only the banned-word description group can be admitted as a batch: after a confirmation, one `decide` `edit_approve` per record with its reason. AER is never batch-approved. The older views are under Other views. | `src/Layer4Focus.jsx`, `src/lib/l4-rules.js`, `src/Layer4Inbox.jsx`; `security.layer4_rule_groups_v1` |
| s838 | **Cards:** the amber Main hold reason banner on every held card (`CardHold`); banned words marked inline (`markBanned`); the cleaned text directly above Remove "word" & Admit; a three-button bar in one row. **Platform Health:** stage 2 shows the capture rate against normal and stage 3 the auto-clean pass rate against normal, from the stored pulse (`security.ops_pulse_rates_v1`). | `src/DescriptionEditAdmit.jsx`, `src/OpsPulse.jsx`, `src/layer4-inbox.css`, `src/ops-pulse.css` |

## 3. Rule groups (live, rolled-back dry run)

| Queue | Groups (largest first) | Time |
|---|---|---|
| Course and university descriptions (207) | Page match not clear enough 71 · More than one page could be this course 64 · Waiting for the machine check 48 · The page changed after it was read 15 · **Contains a banned word 8** · Not a course overview page 1 | 250 ms |
| Entry requirements (2,562 at 14:42) | Completeness gate 1,891 · Audit sample 492 · All rows held 111 · No stored page bound 40 · Page identity 16 · plus five small matrix groups | under 2 s |
| Course links (422) | First sentence of the reason (for example "Fee reader: outside the usual range or an old fee year" 73) | under 1 s |

A keyed read of 50 cards (the batch limit) took about 200 ms.

## 4. Guardrails

- **G3:** no new public function, table or view; checked before and after inside the migration.
- **G2:** four settings: `layer4.rule_group_refs_max` 500, `layer4.rule_batch_max` 50, `pulse.rate_window_hours` 24, `pulse.baseline_days` 7.
- **G1:** no new job; the rates ride `ops-pulse-refresh`.
- **Fail-closed edits:** both are md5-guarded.
- **Data:** manual locks untouched; no catalogue write by the migration.
- **Spend:** none.

## 5. Tests (G4)

- **New:**
  - `cf-247-s836-dashboard-parity-contract`
  - `cf-247-s837-layer4-rule-rail-focus-contract`
  - `cf-247-s838-card-polish-rates-help-contract`
- **Retired:** seven Dashboard tests whose sections were removed; see the retirement log.
- **Updated:**
  - Layer 4 browser tests now open `?view=university`.
  - The S1-UX Dashboard test now expects genuine failures only.
