# Paste files (canonical folder)

**Rule (Platform Admin, 16 Nov 2026 09:20):** manual SQL paste files for the Platform Admin live here, in `coursefinder-admin`, not in the Pilot code repository. A migration drops and deletes nothing; a paste file is how a drop, delete or `cron.unschedule` is run by a person, on project `fxcwkweaxjtknorudmwp` only.

Each paste file is added in the same release cycle as the change that prepares it, and is listed under "Pending paste files" in `docs/CURRENT-STATE.md` until it has been run.

## Pending (not yet run)

| File | Run on or after | Prepared by | md5 |
|---|---|---|---|
| `PASTE-20261115-cron-legacy-jobs-drop.sql` | Part A any time; Part B from 29 Nov 2026 | Pilot migration `20261115200500_cf247_cron_quick_wins` | `b15d3ad9bcde75ea86b18e3f24fca4d0` |
| `PASTE-20261116-retired-settings-drop.sql` | 29 Nov 2026 | Pilot migration `20261116010000_cf247_settings_tidy_phase1` | `fdb433eae91edcd5fe4cceb5084e2fea` |
| `PASTE-20261116-admission-rule-legacy-unschedule.sql` | 1 Dec 2026 (retire_after 30 Nov and 14 idle days); refuses unless all 20 rules are live and all 20 jobs are off, retiring, past retire_after and idle | Pilot #1185, migration `20261116190000_cf247_admission_rule_runner_cutover` (PR 2 cutover, live 16 Nov 2026 23:31 AEDT) | `84d275f83c23b080d2ac0d0c8f003f51` |
| `PASTE-20261118-rollup-legacy-unschedule.sql` | 2 Dec 2026 (retire_after 1 Dec and 14 idle days); guarded | Pilot migration `20261118010000_cf247_rollup_scheduler_cutover` (PR 1 cutover, Platform Admin 17 Nov 2026 23:07) | `6aa2922735e28f1f6fa3e08881061809` |
| `PASTE-20261118-coverage-lane-legacy-unschedule.sql` | 2 Dec 2026 (retire_after 1 Dec and 14 idle days); refuses until `security.flag_jobs_v1` reads the live lanes from the registry | Pilot #1229, migration `20261118012000_cf247_pr3_coverage_lane_dispatch_cutover` (PR 3 cutover, live 18 Nov 2026 00:21 AEDT) | `9f3907f811c8ad6263e39c59028cc410` |
| `PASTE-20261116-api-field-dictionary-number-arrays.sql` | Any time after Pilot migration `20261116110000` is live; a follow-up migration then loads the 2 held fields | Pilot #1162, migration `20261116110000_cf247_api_field_dictionary_sync` (REQ-76) | `29cf5f3ad8fff63d68bd58bbc2143ff9` |
| `PASTE-20261116-l4-lift-false-link-refusals.sql` | Any time; stops unless exactly 59 rows match | S2-CF, Layer 4 official URL resolution (Platform Admin 16 Nov 2026 18:44; report `docs/platform/layer4-clearance-and-model-benchmark-2026-11-16.md` §7.3); after Pilot migration `20261116143000` | `1ac93dd83ccb7f872bc947f4fa19aec1` |
| `PASTE-20261117-supabase-invite-email-template.md` | Step 4 only (a test invitation and reset to an address you control); steps 1 to 3 done 17 Nov 2026 14:33 AEDT by `supabase-auth-config.yml` | Pilot #1189, release v2.16.16 (no migration) | `f2512654fdef6ee5a8c62809c64928fd` |
| `PASTE-20261118-29-destination-check-constraints.sql` (version 2) | **Before Thu 19 Nov 2026 01:15 AEDT, after Pilot migration `20261118150000` is live** (the file stops otherwise). Guarded: replaces each CHECK only if its live definition is unchanged; the new ones accept everything the old ones did | S2-Build, 28-destination schema lock (Platform Admin 18 Nov 2026 11:28 and 12:21): occupation schemes (adds OSCA, NOL, ISCO, ESCO and national schemes), numeric state codes, study rule categories (adds health_insurance, language_requirement, admission_test, dependants, minimum_wage, offer_document), accreditation bodies (adds TEF, NZQA_EER, TRUSTED, KHDA, SETARA, IEQAS, FINEEC, ANVUR), ranking system `ft` (Consumer API change approved 12:21; no column change), occupation fields optional on industry rows | `22bc38a31482375b8da67e214fd73939` |
| `PASTE-20261202-cf245-enrichment-snapshots-drop.sql` | On or after 2 Dec 2026 (retire_after; after the rollup legacy unschedule). Guarded: both targets off and idle since 18 Nov, all five objects retiring, no other reader | Pilot migration `20261118151000` (Platform Admin 18 Nov 2026 12:19: retire non-actionable legacy telemetry): drops `pipeline.enrichment_coverage_snapshots`, `pipeline.layer2_enrichment_hourly_admin_cache_v1` and three functions | `a2675ef3ac7b4033be9fb72140c9655b` |
| `boost-test-reseed.sql` | After each rebuild of project `coursefinder-boost-test` (ucdaaqrpgcldnatavmib) only; never the Pilot | S2 - BOOST lane (Platform Admin 17 Nov 2026 18:02, 20:06, 21:18) | `90931cd10cbf851c3fefda2c4f850813` |

## Done (kept for the record)

| File | Outcome | md5 |
|---|---|---|
| `PASTE-20261116-staging-boost-bucket.sql` | Done 17 Nov 2026 14:37 AEDT by Pilot #1199 (migration `20261117152300`, same values and check); nothing to paste | `c70477e52486fcdfa47e6491647fbedc` |

## Reference (moved from Pilot on 18 Nov 2026; nothing to run)

These left the Pilot repository in the paste split (Pilot #1248, Platform Admin approval 16 Nov 2026 10:10). No spec, fixture or workflow reads them.

| File | What it is | md5 |
|---|---|---|
| `CDESC-20261108-decode-html-entities-in-live-descriptions.md` | Review pack (8 Nov 2026) | `edb4f4959446f0c8f8fec7f47a40a53e` |
| `ENG-20261108-english-policy-review-pack.md` | Review pack (8 Nov 2026) | `b5874c756c61fd124a47756283a63a10` |
| `PASTE-20261104-fee-units-holds-readback.sql` | Read-only read-back (4 Nov 2026) | `919a295db53e6704157f163cb15ab897` |
| `PASTE-20261104-newgen-03871f-b-website-correction-rollback.sql` | Rollback of a run correction (4 Nov 2026) | `3a31bcffd3c72404c4162dc630664b54` |
| `READONLY-20261106-p0-deadline-scope.sql` | Read-only scope query (6 Nov 2026) | `23a46463b5eeb7a7024c4de4c1141de4` |

## Copies kept as Pilot test fixtures

Pilot keeps byte-for-byte copies of the paste files its specs, database fixtures, workflow triggers or evidence classifier read in `tests/fixtures/paste/` (36 files, most already run; guarded by Pilot spec `s616`, which also fails on any Pilot `docs/paste/` folder). Two of them are pending here: `PASTE-20261115-cron-legacy-jobs-drop.sql` and `PASTE-20261116-retired-settings-drop.sql` (specs `s546` and `s549`); a change to either is made in both places, with the md5 above updated. Every other new paste file is written here only.

Paste files from before 4 Nov 2026 are in `docs/platform/pastes/` (history; not moved).
