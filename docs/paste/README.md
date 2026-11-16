# Paste files (canonical folder)

**Rule (Platform Admin, 16 Nov 2026 09:20):** manual SQL paste files for the Platform Admin live here, in `coursefinder-admin`, not in the Pilot code repository. A migration drops and deletes nothing; a paste file is how a drop, delete or `cron.unschedule` is run by a person, on project `fxcwkweaxjtknorudmwp` only.

Each paste file is added in the same release cycle as the change that prepares it, and is listed under "Pending paste files" in `docs/CURRENT-STATE.md` until it has been run.

## Pending (not yet run)

| File | Run on or after | Prepared by | md5 |
|---|---|---|---|
| `PASTE-20261115-cron-legacy-jobs-drop.sql` | Part A any time; Part B from 29 Nov 2026 | Pilot migration `20261115200500_cf247_cron_quick_wins` | `b15d3ad9bcde75ea86b18e3f24fca4d0` |
| `PASTE-20261116-retired-settings-drop.sql` | 29 Nov 2026 | Pilot migration `20261116010000_cf247_settings_tidy_phase1` | `fdb433eae91edcd5fe4cceb5084e2fea` |
| `PASTE-20261116-api-field-dictionary-number-arrays.sql` | Any time after Pilot migration `20261116110000` is live; a follow-up migration then loads the 2 held fields | Pilot #1162, migration `20261116110000_cf247_api_field_dictionary_sync` (REQ-76) | `29cf5f3ad8fff63d68bd58bbc2143ff9` |
| `PASTE-20261116-l4-lift-false-link-refusals.sql` | Any time | S2-CF, Layer 4 official URL resolution (Platform Admin 16 Nov 2026 18:44; report `docs/platform/layer4-clearance-and-model-benchmark-2026-11-16.md` §7.3); after Pilot migration `20261116143000` | `1ac93dd83ccb7f872bc947f4fa19aec1` |
| `PASTE-20261116-staging-boost-bucket.sql` | Any time (step 2 of the Boost setup); idempotent | CF-247 Boost, Platform Admin 16 Nov 2026 21:09 (`docs/platform/CF-WORKER-BOOST-AND-PROD-LAUNCH.md` §8, §11): the private `staging-boost` Storage bucket, service role only | `c70477e52486fcdfa47e6491647fbedc` |

## In transition

- These two files are byte-for-byte copies of the Pilot files of the same name (`docs/paste/`). The Pilot copies stay until their guards move: specs `s546` and `s549` read them there. Until then a change to either file is made in both places and the md5 above is updated.
- Pilot `docs/paste/` holds 41 files in all (most already run). 18 specs, 7 database fixture folders, one workflow trigger and the evidence classifier read them, so they move in a separate Pilot PR with their guards; nothing is moved by dropping a guard.
- Paste files from before 4 Nov 2026 are in `docs/platform/pastes/` (history; not moved).
