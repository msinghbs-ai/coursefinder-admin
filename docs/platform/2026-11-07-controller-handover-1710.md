# StudySearch controller handover, 7 Nov 2026 17:10 Sydney

Controller: Claude (sole Integration Controller, reinstated 7 Nov). Supabase project fxcwkweaxjtknorudmwp ONLY. Single journal: STUDYSEARCH-EXECUTION-REGISTER.md. Evidence thread: Admin #382.

## State at handover (all verified against the live system in this session)
- Production releases on main: v2.15.491 (#896), .492 (#894), .493 (#893), #897 tests, and #899 alert delivery lifecycle (e015565d, migration 20261107030000). Deploy on merge, Release Currentness, Deployed UAT, frontend build all success. #898/#895/#892 closed; #890 and #875 HELD.
- Deployment: standard GitHub-connected Cloudflare path (main, npm run build, npx wrangler deploy). No wrapper. Do not reconfigure Cloudflare.
- Alerts (P1 OPEN): task trig_01Eo7QrJXR24e774gNzLUvTi ENABLED, schedule "59 * * * *", push+email on, prompt repointed to security.alert_delivery_take_v1 / alert_delivery_output_v1. First scheduled run verified (batch a65ec4d6, 5 alerts, generated, receipt unverified, no duplicates). The channel exposes no acknowledgement or receipt; nothing is ever described as delivered. The 84 platform and 42 work-queue alerts of 7 Nov 01:58Z stay as they are (legacy-unknown); never replay. Watchdog workflow platform-watchdog.yml is green and independent. Stop/recovery: set the task enabled=false (update_trigger), inspect pipeline.alert_delivery_batches/attempts and security.alert_delivery_status_v1(); a lease expires after 15 min and releases its attempts; retries back off and stop at alerts.max_attempts (5).
- P0 deadlines: five wrong application deadlines cleared in total (three on 6 Nov under #382 comment 6699003717, two on 7 Nov under comment 6702979821); guard course_deadline_in_quote_v1 md5 2357306ca969fb7b299021bac3b6f3fa. No further candidates known.

## Parked blockers (record once, do not retry without the stated change)
1. Verifiable notification transport: needs the Platform Admin to approve a provider that returns message ids and delivery status (no paid service, recipient change or duplicate platform started). Design sketch in the 16:05 register entry.
2. Firecrawl has reached its reserve until 1 Dec (critical issue budgets:firecrawl). Jobs coverage-discover, coverage-discover-2, coverage-read, coverage-read-2, coverage-find-site, coverage-reextract and coverage-reidentify are inactive; raising the reserve or reactivating paid reads is a budget decision. This also blocks the Canterbury and Massey English requirement page reads (central-find) and provider-description reads.
3. Authenticated Platform Admin session needed for: #877 provider-description workflow acceptance (provider-description-read in run_now.jobs), Admin UI authenticated checks, and the Layer 4 reviewer-usability walkthrough.
4. Course-description trust policy decision before any admission.

## Next executable actions (no approval needed), in order
1. Verify the hourly alert task at each :59 UTC run (batches must show one live attempt per alert, receipt unverified, no growth in retries_exhausted); register a line only on a change.
2. consumer-api-guard: confirm its next daily run is clean (last 2026-11-06 18:23Z).
3. Regenerate the Admin test register for spec s402 (node scripts/test-register.mjs in the Pilot repo, commit the generated TEST-REGISTER.md to Admin docs/platform).
4. Register records for #892-#894 and the 163 vs 164 versus now 160 active/16 inactive job reconciliation (G1: every job catalogued).
5. Course-description, English, AER and scholarship coverage work that does not need paid reads: use stored pages only (database-only), one sequential release per change, tests in genuine PostgreSQL.
6. The "975" label wording.

## Rules that still bind
G1 to G4 and housekeeping in Pilot CLAUDE.md; consumer API frozen; migrations are additive and never drop (drops go to the Platform Admin as paste files); every deploy is verified against the live system; one release controller, sequential releases.
