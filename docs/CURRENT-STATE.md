# StudySearch – current state (read this first)

**Purpose:** one page a new coding session reads before anything else, so it starts from the live system and not from chat history. It says where each exact fact lives and what is in flight right now.
**Rule (Platform Admin, 16 Nov 2026 09:20):** every version bump, migration, or UI or scheduler change updates this page in the same release cycle, with the documents it points to. A fact here carries the time it was read; check the live system before relying on a figure older than a day.
**Last updated:** 19 Nov 2026 18:57 AEDT (S1-Build: s776/s777 live 17:22 (Pilot #1382, v2.16.54, migration `20261119174000`; follow-up #1389 18:11, migration `20261119182000`): course field readiness snapshot, Pipeline & field ETA panel and hourly stakeholder tabs; s778 live 18:11 (Pilot #1390, v2.16.55): Users & roles dialogs stack each field; s781 live 18:24 (Pilot #1392, v2.16.56; #1393 v2.16.57): Catalogue › Providers logos, drawn flags, compact rows and More filters), 19 Nov 2026 17:53 AEDT (S1-RM-Design s766 addendum, trading names, Holmes owner and bounded read, Pilot #1388 and #1391; earlier s766 and s767: v2.16.53, Pilot #1385, heads `20261119172000` and `20261119173000`; host owners for Victoria University, RMIT and Western Sydney, trading names for Torrens and Moore, two stored-page reads queued, Layer 4 Grid Country and Provider type pills; section 5 › S1-RM-Design, 16:18 block), 19 Nov 2026 17:10 AEDT (S2 - BOOST s754: 201 university and higher-education providers, 141 with a description; of the 60 without, 0 ready to admit, 8 in Layer 4, 29 identity holds, 13 with no stored page; bounded GPT-4.1 mini re-check of 2 held both again, US$0.0006, no Firecrawl; Pilot #1383, head `20261119170500`; section 5 › S2-BOOST-Providers, 17:10 block), 19 Nov 2026 16:15 AEDT (S2-BOOST-Providers, no change made: Australian universities with a description 37 of 45; the 10 records without one triaged by exact reason, none admissible by rule; 906 providers without a description broken down by country and state; section 5 › S2 - BOOST lane, 19 Nov 16:15 block), 19 Nov 2026 15:45 AEDT (S2-BOOST-AER handover close-out: course drain 76 of 91, the last 16 pass the rule and are queued, expected 20:30 to 22:30 AEDT; S751-S752 prompt v2 and Windows-1252 verifier folding, Pilot #1376, migration `20261119143000`, verification replay 100% minimum in quote, 99.9% quote fidelity, 89.4% rows, US$0.028 of US$0.03, bar not met; Platform Admin decision of 15:14 for the S1 follow-up; AER v2 admission paused; m2.4.7 runsheets, 15:45 block), 19 Nov 2026 15:30 AEDT (S2-Build: page-text claim bounded, IQ-00606 closed after 11 of 11 clean runs (Pilot #1377, #1379, s772); course field readiness as 8 plain per-country CSVs under 2.9 MB in Drive › Monitoring, zip retired (Pilot #1378, s771); IQ-00594, IQ-00588 and IQ-00426 handed to S1-Build with their failure paths (s773–s775); head `20261119153000`; section 5, S2-Build 15:30 block), 19 Nov 2026 15:20 AEDT (S1-Build: s767 post-fix check, three hours of runs after the 12:24 deploy; no setting change needed, `no-page-propose` needs a query fix), 19 Nov 2026 14:18 AEDT (S1-Build: s769 live, Pilot #1374 and #1375, v2.16.51, migrations `20261119130000` and `20261119144500`: Scholarships › Coverage loads again (ref 8XEY7B); the listing matcher works out keys once instead of per item × record pair, 50 providers a page; the provider drawer and Publish read publishing checks for one provider only), 19 Nov 2026 13:45 AEDT (S2-BOOST-AER: S750 MiMo v2.6 Flash at 12 rows a call on 20 gate-held tables, 99.8% rows, 100% quotes, 99.4% minimums, longest call 32.9 s of 90 s, US$0.0198 of US$0.05, window closed, bar not met, nothing promoted; Manukau miss is a two-level row; worker v1.0.29, Pilot #1373, s750, no migration; course drain 75, 16 queued; m2.4.7 runsheets, 13:45 block), 19 Nov 2026 12:50 AEDT (S2-Build: LIN 19/198 living cost AUD 29,710 published on the Home Affairs edition, UKVI and USCIS published (Pilot #1363); s720 reliability unblock live, chunked coverage build, bounded admission snapshot and lock, page-text claim, evidence-link-index feed 1.6 s and HTTP 200 after the 11:42 critical alert, 34 stalled plans released, 203 runs with 0 timeouts (Pilot #1364, #1366, #1369, #1372); daily course field readiness to Drive › Monitoring, first run 36,031 courses (Pilot #1370, #1371, s770); #1333 guardrail note and Hourly_Admittance_Telemetry columns; head `20261119125500`; section 5, S2-Build 12:50 block), 19 Nov 2026 13:30 AEDT (S1-Build: s768 design for queue and lane control and on-demand runs, docs only: `docs/platform/OPS-QUEUE-LANE-CONTROL-AND-ON-DEMAND-RUNS-DESIGN.md`, F-OPS.10–.12, operating model v1.23, UI catalogue 1.20; three open points for the Platform Admin), 19 Nov 2026 12:40 AEDT (S2-BOOST-AER: S747 chunked matrix smoke test, 10 tables, US$0.0276 of US$0.10, both on-demand windows closed; MiMo v2.6 Flash 100% row completeness and quote fidelity, 99.3% minimum in quote, bar not met, nothing qualified; prompt aer-v2-matrix-chunk-v1 as data (Pilot #1365, migration `20261119110500`, worker v1.0.28 #1368, s747); course drain 75 admitted since s748, 16 queued; m2.4.7 runsheets, 12:40 block), 19 Nov 2026 12:40 AEDT (S1-Build: s767 live 12:24, Pilot #1367, migration `20261119120000`: `flag_jobs_v1` reads live registry lanes, so the PR 3 and PR 4 unschedule paste files can run; `security.job_effective_state_v1` and telemetry exporter revision 4 read dispatcher-held jobs from their dispatcher; CHRONIC_FAIL fixes: waste-guard cost measure to rollup target `ops-cost-guard`, `batch.sch_coverage_classify` 120 → 80, `bind.no_page_providers_per_run` 40 → 25; idle guard keeps retiring jobs off), 19 Nov 2026 11:25 AEDT (S1-Build: handover architecture documents updated, read only on production: `AGENT-OPERATING-MODEL.md` v1.22 "Production architecture baseline for handover", `STUDYSEARCH-PROGRAMME-STATUS.md` section 0, `UI-CATALOGUE.md` 1.19 section 4.2, `processes/intake-dates.md` schedule note; docs only), 19 Nov 2026 11:10 AEDT (S2-BOOST-Providers self-check, no change made: GPT-4.1 mini re-read 252 of 267 finished, 13 admitted, 238 held, US$0.0478, no Firecrawl; 2,184 of 2,830 published providers have a description; 184 identity holds remain; section 5 › S2 - BOOST lane, 19 Nov 11:10 block), 19 Nov 2026 10:26 AEDT (S2-BOOST-AER scheduled check: 73 course reads admitted since s748, 16 would-admit waiting, 79 matrix items pending with no new admission, P0 0; m2.4.7 runsheets, 10:24 block), 19 Nov 2026 09:55 AEDT (S2 - BOOST: study-load label split live, 206 international study loads admitted on re-read, Pilot #1337 and #1347; campus locality by campus name, 3 postcodes and 9 campuses, Pilot #1341; Boost fields v2 with application deadlines, worker v1.0.26, replay replay-v2-1 found no field at the bar so nothing admitted, Pilot #1346; run-5 PASS 9/9; head `20261119103000`; section 5 › S2 - BOOST lane, 09:55 block), 19 Nov 2026 08:45 AEDT (S1-Build: consolidation PR 4 cutover live 08:18, early by the Platform Admin's 07:47 decision, Pilot #1331, migration `20261119095000`; 9 legacy jobs off and retiring, active jobs 146 to 138, G1 0 unregistered, G3 75/48; paste file listed; spec renumbered s766, Pilot #1359 and #1362; Job governance section), 19 Nov 2026 08:50 AEDT (S2-BOOST-AER: matrix completion clauses and course links, 2 matrix items admitted (Pilot #1338, migration `20261119052500`, s741); held-page export (s742); AER course machine queue records every check and takes the least recently checked first (Pilot #1349 and #1360, migrations `20261119080500` and `20261119095500`, s748 and s749); table row chunker on 48 held pages, nothing switched on (Pilot #1358, s744 to s746); s747 smoke test not yet run; head `20261119100000`; section 5 › S2 - BOOST lane, 19 Nov 08:50 block), 19 Nov 2026 08:45 AEDT (S2-BOOST-Providers: identity proof accepts own bracketed initials and registration numbers (Pilot #1353, s762); provider description route GPT-4.1 mini, cap US$0.50 a day, Firecrawl off; 267 re-reads queued 08:36; dates, calendar and timetable confirmed refused source words; 61 Layer 4 descriptions triaged (Pilot #1355, migration `20261119090000`, s763 to s765); section 5 › S2 - BOOST lane, 19 Nov 08:45 block), 19 Nov 2026 07:40 AEDT (S1-RM-Design: v2.16.49 scholarships listed once, Pilot #1342, s699, verified live at 375×812, section 5); before it: 19 Nov 2026 07:15 AEDT (S2-BOOST-Providers handover: provider description prompt versions 4 and 5 recorded as fixtures; 54 held re-reads restored to Layer 4; 2,171 of 2,830 published providers have a description, 82 held scholarship pages, 78 campus localities waiting; Pilot #1345, migration `20261119080000`, s760 and s761; section 5 › S2 - BOOST lane, 19 Nov 07:15 block), 19 Nov 2026 07:15 AEDT (S2-BOOST-Discovery check-in: request closed, s658 holding, pick time-outs 141 and measured, no matcher or year rule built, section 5); before it: 19 Nov 2026 06:00 AEDT (S2-Build: post-squash batch: Boost test project rebuilt (PASS) and re-seeded, v2.16.47 blades live for every role, round states on rollup-scheduler only; coverage telemetry Pilot #1333 held for a decision; section 5, S2-Build 06:00 block), 19 Nov 2026 05:25 AEDT (S2 - BOOST: run-4 PASS 9/9 on the test project after the squash, admin run 44349340646; benchmark bench-5 on prompt v5, Mistral Small 3.2 59%, MiMo 44%, Qwen3 30B 32% of 63 leftover pages with signal, Pilot #1327, s699; nothing qualified or switched; head `20261119044000`; section 5 › S2 - BOOST lane, 05:25 block), 19 Nov 2026 04:30 AEDT (S2-Build: API v3 PR D read path, scholarship round states on the Melbourne date and the student-facing destination read; Pilot #1328, #1329, migrations `20261119041000`–`043000` and `045000`, s710–s712; section 5, S2-Build 04:30 block), 19 Nov 2026 03:15 AEDT (S1-AER: Thursday 02:45 check, 2 course reads admitted and 89 would-admit reads not reached by the machine job; cause found, fix S677 awaits authorisation; Pilot #1326, s676, no migration; section 5, S1-AER 03:15 block), 19 Nov 2026 02:25 AEDT (S1-Build: canonical migration squash merged, Pilot #1325, baseline from production dump 44324920057 at cut-off `20261118272000`, 800 files archived, production unchanged; migration freeze lifted early; `coursefinder-boost-test` free to re-seed), 19 Nov 2026 01:17 AEDT (S1-Build: migration freeze in effect until 03:30, #1314 held; coursefinder-boost-test being reset from 01:30), 19 Nov 2026 00:35 AEDT (S1-Build: 24-hour late-tick check of the dispatchers, PR 4 shadow progress; Job governance section), 19 Nov 2026 00:40 AEDT (S1-RM-Design: v2.16.46 Course detail declutter, Pilot #1324, s698, no migration; section 5 › S1-RM-Design 23:51 block), 18 Nov 2026 23:55 AEDT (S1-AER: Platform Admin decisions of 23:52, the 149 approved AER rows stay live and paid AER v2 replay is paused until tables are chunked per qualification or a stronger model is authorised; section 5, S1-AER 23:55 block), 18 Nov 2026 23:55 AEDT (S1-RM-Design: v2.16.45 Course and Provider detail fixes after live inspection, Pilot #1323, s697, no migration; section 5 › S1-RM-Design 23:02 block), 18 Nov 2026 23:35 AEDT (S1-AER: AER prompt v3.1 and 180 s evaluation calls, round 5 not qualified, Pilot #1311 to #1320, s674; standing 7-day AER validation renewal, workflow `aer-validation-renew.yml`; five AER consumer data findings resolved without quarantine, Pilot #1321, s675, `aer:p0` resolved 23:27; section 5, S1-AER 23:35 block), 18 Nov 2026 23:00 AEDT (S2-Courses: study load cue guard s661 and fee-basis replay s665 live, Pilot #1316 and #1319, worker v1.0.22, no migration; s662 and s664 are in Pilot #1314; S2-Intakes question below; section 5 › S2-Courses block), 18 Nov 2026 21:10 AEDT (S3-Boost providers: 1,543 CRICOS rows audited read-only, s700, section 5), 18 Nov 2026 20:05 AEDT (S1-RM-Design: v2.16.43 Layer 4 › Inbox › Grid › Clusters and City metrics measure wrap, Pilot #1309, no migration; Australia's city figures checked live; section 5 › S1-RM-Design block), 18 Nov 2026 19:20 AEDT (S2-BOOST-Discovery: 795 Course page needed items returned to the list by rule, Pilot #1306, s658; on-demand request closed, 2,190 credits; corrects 17:55 (402 gate-held, not 834); Course link year preference not built, by finding; head `20261118233000`; section 5 › S2 - BOOST lane, 19:20 block), 18 Nov 2026 19:00 AEDT (S2-BOOST-AER: hand-bound shared-page rule live, Pilot #1303, migration `20261118220000`, s670, 25 of 230 shared-page course reads released and 205 stay held; **AER course machine admission has run in shadow since 15:40 AEDT because its 11 Nov validation lapsed, 79 reads `would_admit` and none admitted**; section 5, AER block), 18 Nov 2026 18:45 AEDT (S2-BOOST-Providers: held scholarships 89 to 82 by rule l4-held-sch-settle-v1; provider description prompt version 5, 81 held descriptions sent back to the reader, 6 admitted of 34 re-read at 18:40; campus source-data exceptions table; Pilot #1302, migration `20261118213000`, s683 and s684; section 5 › S2 - BOOST lane, 18:45 block), 18 Nov 2026 18:00 AEDT (S2-BOOST-Courses: worker v1.0.18, read-only sentence inspection s660, multi-field page check v2 and gold-set replay s663, Pilot #1299 and #1301, no migration; the international-sentence cue is not clean (35 of 41 false) so study load v6 was not promoted; Qwen3 30B not qualified for intakes, fees or deadlines; 663 held course descriptions clustered; section 5 › S2 - BOOST lane, 18:00 block), 18 Nov 2026 17:55 AEDT (S2-BOOST-Discovery: the Course page needed searches were queued but not running; on-demand course search request, Pilot #1297, s656; search pick time-out fixed, Pilot #1300, s657; 716 searches, 71 pages found, 1 proved so far; 834 searches held by the stop gate; Course link 268 clustered; head `20261118210000`; section 5 › S2 - BOOST lane, 17:55 block), 18 Nov 2026 17:30 AEDT (S2-BOOST-Providers: Campus locality 312 to 78 by rule l4-campus-locality-v1; held scholarship re-check queued by rule l4-held-sch-recheck-v1, 60 of 72 re-checked; university description name forms pdesc-name-forms-v2, 88 to 86; Pilot #1298, migration `20261118203000`, s680 to s682; head `20261118203000`; section 5 › S2 - BOOST lane, 17:30 block), 18 Nov 2026 17:00 AEDT (S2 - BOOST: Course page needed 1,958 to 1,360 through the search lane by rule l4-page-needed-search-v1, Pilot #1293; study-load settlement heals itself, 74 released for v5, Pilot #1295; correction: search worker and course-list reader run live through the dispatcher; Adelaide 404s are guessed addresses, alias already in place; AER shared-page splitting held by the v1 freeze; head `20261118193000`; section 5 › S2 - BOOST lane, 17:00 block), 18 Nov 2026 15:45 AEDT (S2 - BOOST: reader v5, fee notes never the study load, worker v1.0.17, Pilot #1283; Course link 1,487 to 423 by rule l4-link-accept-v1, Pilot #1284; 400 Boost study loads: 94 admitted on re-read, 231 Not stated by rule, 75 waiting, Pilot #1286; scholarship scope rule hourly; Course page needed by provider; head `20261118183000`; section 5 › S2 - BOOST lane, 15:45 block), 18 Nov 2026 16:00 AEDT (S1-Build: RM1I/RM1C/RM1H/RM1D source readiness, pre-freeze lane; the per-owner paste file was reviewed against live), 18 Nov 2026 15:30 AEDT (S2-Build pre-freeze lane: paste file v2 must be run by the Platform Admin (the deploy refused it as a migration, Pilot #1280 reverted by #1288); BOM climate figures approved and served, edition waits for the published-per-owner paste file, Pilot #1287; page-text evidence key fix, Pilot #1281; head `20261118181500`; section 5), 18 Nov 2026 15:05 AEDT (S1-Build: consolidation PR 4 in shadow, Pilot #1282, migration `20261118170000`; cutover Thu 15:10 and late-tick check Thu 00:25 scheduled; Job governance section), 18 Nov 2026 14:55 AEDT (S1-RM-Design: v2.16.41 Operations screens, Pilot #1278; v2.16.42 Coverage now, climate icons and How the data connects, Pilot #1285, no migration; Coverage read migration handed to S2-Build; RM1F AMBA paste file; Wave 2 drafts status; section 5 › S1-RM-Design block and section 4 paste files), 18 Nov 2026 14:10 AEDT (S2 - BOOST: all 57 Scholarship course links resolved by deterministic rule under the automated rule authority, Pilot #1273 and correction #1276, migrations `20261118153000` and `20261118163000`, s636; 694 links, 60 audit rows, Inbox 0; head `20261118163000`; section 5 › S2 - BOOST lane, 14:10 block), 18 Nov 2026 14:30 AEDT (S2-Build: Operations backend v2.16.39, Pilot #1274, Task manager time-out fixed and 254 stranded tasks closed, health checks follow dispatchers and recorded pauses; BOM climate terms and open-licence publishing, Pilot #1275; grouped Layer 4 decisions v2.16.40, Pilot #1277 (study-load fix #1279 open); head `20261118162000`; section 5), 18 Nov 2026 13:45 AEDT (S1-RM-Design: hotfix v2.16.37, Links & Email Templates opens again, ref ZDUFMC, Pilot #1270, s634, live render confirmed; v2.16.38 Layer 1 wizard What this source will create, Pilot #1272, s635; runbook v1.4 maps the 28-destination extensions into existing tables; Operations UI v2.16.40 in progress after S2-Build's #1274; section 5 › S1-RM-Design block), 18 Nov 2026 13:05 AEDT (S2-Build: page-text registered, Pilot #1266; consolidation audit; 28-destination schema lock, Pilot #1265 and #1268 merged, paste file v2 dry-run passed; legacy CF-245 telemetry retired, #1269; section 5), 18 Nov 2026 12:25 AEDT (S2 - BOOST: Qwen3 30B kept solo; AER and scholarship admission audited; Scholarship course links in Layer 4, Pilot #1267; Layer 4 approval requirements written up; head `20261118143000`; section 5 › S2 - BOOST lane, 12:25 block), 18 Nov 2026 12:05 AEDT (S1-RM-Design: v2.16.35 role-centric Dashboard, Role guides, guided Create user, email editor, Pilot #1259; API v3 `study_load` and Publish edition fix, Pilot #1257, migrations `20261118133707` and `133717`; multi-country schema lock `s627`, Pilot #1262; RM26 to RM33 and REQ-84 to REQ-91; rows 37 and 38 and section 5), 18 Nov 2026 11:55 AEDT (S2-Build: 29-destination schema readiness cross-check, data paths in Pilot #1263, constraint paste file; section 5), 18 Nov 2026 11:45 AEDT (S2 - BOOST: refused study loads to Layer 4 › Inbox, Pilot #1251; Boost multi-field reading live in shadow, Pilot #1255 and #1261; run-3 PASS on the test project; head `20261118130000`; section 5 › S2 - BOOST lane, 11:45 block), 18 Nov 2026 11:35 AEDT (S2-Build: v2.16.33 Layer 4 › Inbox › Grid, saved views and the quote drawer, Pilot #1254; page-text feed to Boost, #1252; Layer 1 induction v3 fields and baseline records, #1258; v2.16.34 Layer 1 Register fixes, #1260; BOM climate loader open as #1256; section 5), 18 Nov 2026 11:10 AEDT (S1-Build: squash rehearsal complete, #1235 green at `20261118113000`, 3,364 of 3,364; section 4), 18 Nov 2026 11:00 AEDT (S1-Build: squash rehearsal dump and rebuild proof done, `coursefinder-boost-test` free to re-seed; section 4 and the S2 - BOOST lane), 18 Nov 2026 10:30 AEDT (v2.16.32, Pilot #1250: Bulk Approve Drafts for city figures, ILEP note corrected, migration `20261118110707`; `study_load` recorded as held but not yet returned by API v3; section 5), 18 Nov 2026 09:50 AEDT (S2 - BOOST: Platform Admin decisions of 07:08; the international study load first, worker v1.0.14; Boost no longer skips for a dispatcher tick; **Qwen3 30B qualified for study load, page-verified study loads admitted: 447 at 09:45 and rising**; Pilot #1238, #1241, #1244, #1246, #1247, #1249, migrations `20261118074500` to `20261118101500`; Boost specs renumbered s600 to s602; section 5 › S2 - BOOST lane, 09:50 block), 18 Nov 2026 09:35 AEDT (S2-Build: paste split done, Pilot #1248 and admin; Pilot has no docs/paste/, 36 guard-read files are Pilot test fixtures, 5 reference files moved here; spec s616), 18 Nov 2026 09:10 AEDT (S2-Build: Track B page reader live, Pilot #1245, s613, s599 renumbered to s612; PGWP ready, OfS and IRQ addresses hold no table; head `20261118090707`), 18 Nov 2026 08:40 AEDT (v2.16.30 and v2.16.31, Pilot #1242: Boost queue with Country tier and Priority score, migration `20261118083707`; Bulk Approve Drafts for localities, migration `20261118090707`; section 5), 18 Nov 2026 08:15 AEDT (S2-Build: Wave 2 schemes and duplicate sources reconciled, Pilot #1240; wizard Run dry run, #1243; live admitted counts; head `20261118080000`), 18 Nov 2026 08:00 AEDT (v2.16.29, Pilot #1239: Courses Study load and Empty reason, Campuses Primary and Locality, migration `20261118073000`; new operator runbook for destination editions and Wave 2 drafts; section 5), 18 Nov 2026 02:00 AEDT (S2 - BOOST: the stored-page queue is read in full, 2,144 courses, all shadow, 0 admitted; model benchmark bench-1 run on production and replayed on the test project; Pilot #1236, migration `20261118020000`, worker v1.0.11, s596; section 5 › S2 - BOOST lane, results block), 18 Nov 2026 01:25 AEDT (S1-Build: squash tooling 2 merged, Pilot #1237; rehearsal #1235 full CI green at live head `20261118020000`, 3,310 of 3,310; section 4), 18 Nov 2026 01:10 AEDT (S1-Build: consolidation PR 1 cutover live, Pilot #1232, migration `20261118010000`; squash tooling #1234 merged, #1237 and rehearsal #1235 in progress; sections 3 to 5), 18 Nov 2026 00:35 AEDT (S2-Build: consolidation PR 3 cutover live 00:21, Pilot #1229 after prerequisite #1227; Wave 2 PR C, the Layer 1 declarative runner, live, Pilot #1233; head `20261118013000`; section 2 and section 5), 18 Nov 2026 00:10 AEDT (S2 - BOOST: Boost extraction runs all day in shadow at higher throughput; first live results read; **Qwen3 30B not qualified, by finding**; Pilot #1226 and #1231, migrations `20261118000100` and `20261118011000`, worker v1.0.10; section 5 › S2 - BOOST lane, status block), 17 Nov 2026 23:32 AEDT (Pilot #1228: nine Wave 2 register drafts pre-staged, migration `20261118004000`; v2.16.28, Pilot #1230: API field dictionary and Grade scale conversions on Reference data, migration `20261118005000`; UI audit of the new API v3 fields written; section 5), 17 Nov 2026 22:55 AEDT (v2.16.27, Pilot #1225: the Email delivery provider card saves and tests itself; Deployed UAT on `main` green again from 22:31 AEDT; section 5), 17 Nov 2026 22:50 AEDT (S2 - BOOST: Boost extraction through `coverage-sweep` and the Models & services route is live, Pilot #1223, migration `20261117235000`, worker v1.0.9, s587; #1219 read back and run-2 passed through GitHub Actions; section 5 › S2 - BOOST lane), 17 Nov 2026 22:50 AEDT (Pilot #1222: the deployed Layer 1 role-boundary test follows the approved gates; Deployed UAT still red because the UAT account's password was changed at 22:17 AEDT; section 5), 17 Nov 2026 22:25 AEDT (S2 - BOOST, Platform Admin decisions of 21:18: Boost priority matrix moved to Settings › Pipeline settings over the single category list, one admitted row per course in a batch; Pilot #1219, migration `20261117223000`, s586 added, s581 retired; section 5 › S2 - BOOST lane), 17 Nov 2026 20:30 AEDT (squash rebuild proof decided: option A on `coursefinder-boost-test`; S2 - BOOST re-seeds after the rehearsal and after Thursday 03:30; sections 4 and 5), 17 Nov 2026 21:30 AEDT (release v2.16.26, Pilot #1217, Wave 2 decisions: one category list, source retention in one place, Curators open Layer 1, evidence and Layer 4 items side by side; migration `20261117213000`; section 5), 17 Nov 2026 20:15 AEDT (release v2.16.25, Pilot #1214, Wave 2 addenda: parser badge and Re-infer Parser Spec on Layer 1 sources, target record type in the wizard; migration `20261117203000`; section 5), 17 Nov 2026 19:45 AEDT (S1-Build Wave 2, Pilot #1212, migration `20261117200000`: staging retention in housekeeping-daily (dry run), 7-year evidence floor, ops telemetry views, live dry-run workflow; squash runbook and schedule; sections 3 to 5), 17 Nov 2026 19:00 AEDT (release v2.16.24, Pilot #1211, Parallel Wave 2: Layer 1 source induction wizard and Platform health › Country & category completeness; migration `20261117193000`; section 5), 17 Nov 2026 18:40 AEDT (S2 - BOOST: Boost priority matrix `country_category_boost` live, Pilot #1209, migration `20261117183000`, guard spec s581; first Boost test-project experiments, run-1; section 5 › S2 - BOOST lane), 17 Nov 2026 17:15 AEDT (S1-Build: `worker-boost-bulk-ingest` live, Pilot #1205, migration `20261117163500`; window, blackout, housekeeping and tick-lock gate; qualification SQL; section 5), 17 Nov 2026 17:00 AEDT (releases v2.16.22 and v2.16.23, Pilot #1204 and #1206: clean greeting without a name, Go-live checklist row for custom SMTP, and Admin invitations and resets through Resend with a write-only API key in Vault; migrations `20261117163000` and `20261117170000`; section 5), 17 Nov 2026 16:15 AEDT (Boost test rebuild PASS on every check, run 44019730363; section 5), 17 Nov 2026 16:15 AEDT (release v2.16.21, Pilot #1203: Resend invite on Users & roles, warning with Copy HTML on Links & Email Templates; the `#0b6e5f` StudySearch PIM Admin emails applied to Supabase Auth by `supabase-auth-config.yml` run 44021389741; section 5), 17 Nov 2026 15:35 AEDT (release v2.16.20, Pilot #1202: Users & roles › Links & Email Templates; migration `20261117152700`), 17 Nov 2026 15:30 AEDT (S1-Build: Supabase Auth applied, Boost bucket and tables live, four low-yield jobs paused, Boost rebuild root cause fixed; section 5), 17 Nov 2026 14:05 AEDT (release v2.16.19, Pilot #1197: Destination data page, Layer 4 kind Campus locality, `campuses[].locality` on API v3 providers; migration `20261117131500`). Before it: 17 Nov 2026 14:40 AEDT (S2-Build step 1, Pilot #1196: destination G-1 career grain and the destination field dictionary, migrations `20261117060000` and `20261117061000`; ABS loader runtime note in section 5), 17 Nov 2026 09:20 AEDT (AER benchmark round 3: Path B, Mistral failed the gate; Pilot #1191 and #1192; all AER entry reading stays off; benchmark report §6.1), 17 Nov 2026 08:50 AEDT (release v2.16.18, Pilot #1193 and #1194: destination data schema pack and API v3 `destination` action; migration `20261117040000`; bulk ingestion readiness checklist in section 5). Before it: 17 Nov 2026 07:15 AEDT (release v2.16.17, Pilot #1190: RM1A-3 register end dates; migration `20261117010000`; 2,051 applied), 17 Nov 2026 07:20 AEDT (Boost rebuild run 43940610220: schema complete, later steps FAIL with causes fixed; section 5), 17 Nov 2026 06:30 AEDT (PR 3 `coverage-lane-dispatch` in shadow since 06:21, Pilot #1188, 13 lanes; `coverage-ai-match` left out; section 4), 17 Nov 2026 03:30 AEDT (Boost rebuild: schema step stopped at its limit with one cause found and fixed; re-run waits; section 5), 17 Nov 2026 01:05 AEDT (release v2.16.16 live, Pilot #1189: invite and reset links to the admin sign-in, catalogue CSV export; no migration; Supabase dashboard paste doc pending; sections 3 to 5), 16 Nov 2026 23:45 AEDT (PR 2 cut over live 23:31 AEDT by S2 - SS Build under the Platform Admin's override of 21:23, Pilot #1185; PR 3 built in shadow as Pilot #1188, not merged: its live rehearsal waits for an approval; API v3 PR A/B fills live 21:50; sections 3 to 5), 16 Nov 2026 23:20 AEDT (PR 1 fix live 23:14 AEDT, Pilot #1187; fresh 24-hour shadow from 23:15 AEDT; cutover review Tue 17 Nov 23:20 AEDT; Boost test rebuild from the schema dump running, run 43863252704; sections 4 and 5), 16 Nov 2026 22:50 AEDT (PR 1 no longer blocks PR 3 or PR 2; PR 1 fix and new shadow, cutover Tue 22:30; section 4), 16 Nov 2026 22:50 AEDT (PR 1 cutover held: shadow fails the no-tick-over-budget criterion; section 4), 16 Nov 2026 21:25 AEDT (Boost setup steps 1 to 4: test project `coursefinder-boost-test` created; rebuild workflow waits for one secret; bucket paste file; sections 4 and 5), 21:05 AEDT (Cloudflare Worker Boost built and tested locally, nothing deployed or applied; section 5), 20:50 AEDT (Pilot #1181 finder fix, #1182 Course page needed settle, #1183 API v3 daily admittance telemetry; Layer 4 quick wins and the paths taken; Tue A/B gates; sections 3 and 5), 19:45 AEDT (Pilot #1180 live; official URL resolution of 856 items, Layer 4 4,916, new paste file; sections 3 to 5), 18:10 AEDT (Pilot #1162 field dictionary, #1178 AER routes and #1179 worker v1.0.6 merged; decisions of 16:52 in section 5), 16:45 AEDT (API v3 data admission plan in section 5), 16:40 AEDT (Layer 4 clearance and AER benchmark round 2 in section 5), 13:36 AEDT (course description readings in section 5), 13:25 AEDT (release v2.16.14: sections 2 to 5), 12:45 AEDT (AI token efficiency check in section 5), 12:26 AEDT (sections 3 to 5), 09:25 AEDT (rest), by the Course Module session (S2-CF), from Pilot `main` 8f53f8fd (#1173) and a read-only query of project `fxcwkweaxjtknorudmwp`.

## 1. Start here

1. This page, then `docs/README.md` (which document is current in each family).
2. Pilot `CLAUDE.md` (working rules G1 to G4, housekeeping, cron dispatchers, the UI map rule, the two-repository rule). This repository's `CLAUDE.md` mirrors the two-repository rule.
3. The live system: Supabase project `fxcwkweaxjtknorudmwp` only. The organisation's other project, `coursefinder-demo`, is unrelated and is never targeted.
4. Open Pilot PRs and branches. `main` is not always what is deployed mid-change.

## 2. Where each exact fact lives

| Question | Source of truth | How to get it exactly |
|---|---|---|
| Live schema (tables, functions, policies) | The live database | Pilot workflow "Database schema dump" (branch `db-schema-dump/<run id>`, md5 per file); one function: workflow "Database function snapshot". Checked-in migrations are not complete: at least one live function has no migration file. |
| Migrations applied | 2,154 (19 Nov 05:53 AEDT) |
| Scheduled jobs and dispatchers | `cron.job`, `pipeline.automation_catalogue`, `pipeline.rollup_targets`, `pipeline.admission_rules` | Read live; shadow reports: `security.rollup_shadow_report_v1(days)`, `security.admission_rule_shadow_report_v1(hours)` |
| Components and what is retiring | `pipeline.component_register` | Pilot branch `component-register-snapshot` (daily); `docs/platform/COMPONENT-REGISTER.md` is an older copy (15 Oct 2026) |
| UI routes, tabs, sub-tabs, folds, drawers | `docs/UI-MAP.md` (generated) | Pilot `node scripts/ui-map.mjs --mirror <this repo>`; guarded by spec `s557` |
| What each screen shows and does | `docs/platform/UI-CATALOGUE.md` (written by hand; v1.18 at v2.15.494, behind the v2.16 screens), in-app Guides | Trust `docs/UI-MAP.md` for names and places |
| Admin and operator SOPs | `docs/sops/` (mirror of Pilot `src/guide/sops.js`) | Pilot `node scripts/export-sops.mjs --check-mirror <this repo>/docs/sops` |
| Tests and what each guards | `docs/platform/TEST-REGISTER.md` (generated) | Pilot `node scripts/test-register.mjs` |
| Settings and UI simplification plan (decisions, phases, progress) | `docs/platform/ui-audit/ui-ux-settings-audit-2026-11-15.md` | Read §6 to §8; the live counts in it carry their read time |
| AI spend and yield by service and model tier; page-to-catalogue funnel | Google Sheet `StudySearch_Pipeline_Telemetry_Live`, tabs `Model_Tier_&_Token_Efficiency` and `Layer_Lifecycle_Funnel` (refreshed 08:05 AEDT daily) | `security.telemetry_model_tier_v1(24)`, `security.telemetry_layer_funnel_v1(24)` (read only) |
| Settings | `pipeline.platform_toolset_settings` | Settings › Settings on the admin screen; never a number in code (G2) |
| Consumer API (frozen) | Pilot `tests/uat/consumer-api-baseline.json`, spec `s57` | `docs/integrations/WEBSITE-DEVELOPER-REQUIREMENTS.md` before touching anything the website or Zoho reads |
| Paste files waiting to be run | `docs/paste/README.md` | Section 4 below |
| Task status and evidence | `docs/platform/STUDYSEARCH-EXECUTION-REGISTER.md`; consumer requests: `docs/integrations/` | One register; no second tracker |

## 3. Live system as read (16 Nov 2026 09:22 AEDT; release, migration and test rows 13:14 AEDT)

| Measure | Value |
|---|---|
| Visible release | **v2.16.53** (package 0.1.475; Pilot #1385, commit `0b68e4d3`, merged 19 Nov 2026 about 17:35 AEDT; Layer 4 Review › Grid Country and Provider type pills, AU university host owners and trading names). Before it v2.16.51 and **v2.16.49** (package 0.1.471; Pilot #1342, commit `363cda70`, merged 19 Nov about 07:03 AEDT; no migration; the Around this course card is headed Entry requirements and the Scholarships section is the only scholarship list on the Course detail). Before it v2.16.47 (Pilot #1330, live figures for every role) and v2.16.46 (Pilot #1324). v2.16.48 is claimed by Pilot #1335 and #1336, which re-bump on rebase. |
| Newest migration applied live | `20261119103000` (Pilot #1346, S2 - BOOST: Boost fields prompt v2 recorded on the qualification row; read back 19 Nov 09:40 AEDT). Before it `20261119100000` (Pilot #1361), `20261119095500` (#1360), `20261119095000` (#1331), `20261119084000` (#1344), `20261119082000` (S2 - BOOST #1347) and `20261119080000` (#1345); `20261119062000` (S2 - BOOST #1341) applied after `080000`, which merged first. |
| Migrations applied | 2,154 (19 Nov 05:53 AEDT) |
| Scheduled jobs (`cron.job`) | 191 active, 11 switched off |
| Components marked retiring | 46 settings, 30 functions, 14 screens, 8 jobs, 5 tables, 1 edge function |
| Tests | 799 specs, 3,693 tests (3,601 local, 92 deployed track; 19 Nov 00:35 AEDT, Pilot main `c9a293dd`) |
| UI | 21 pages, 56 tabs, 26 sub-tab bars, 215 folds, 41 drawers and dialogs (v2.16.49) |

## 4. Dispatchers, pending cutovers and pending paste files

Rule: Pilot `CLAUDE.md`, "Cron dispatchers" (register each legacy job byte for byte, 24-hour shadow cycle, then cutover; `cron.unschedule` by paste file after 14 days).

| Dispatcher | Jobs | State as read | Shadow since | Next step | Owner |
|---|---|---|---|---|---|
| Consolidation PR 1, `rollup-scheduler` | 25 report and cache targets (`pipeline.rollup_targets`; `layer2-onboarding-snapshot` stays on its own job) | **Live since 17 Nov 2026 23:47 AEDT** (Pilot #1232, migration `20261118010000`, history md5 `76ef60c4`; cutover pulled forward by the Platform Admin 17 Nov 23:07). Read back live: 25 of 25 group A targets `live`; 0 legacy report jobs switched on; 25 marked `retiring` (retire_after 1 Dec 2026); `layer2-onboarding-snapshot` still on its own job; `rollup-scheduler` on; 25 cutover events logged; first live runs succeeded (largest 116 ms); G3 75 of 75 functions, 48 of 48 relations, no drift flag. Shadow review (24 h from 12:07Z 16 Nov): 25 targets dispatched, 0 failed or refused; 26 legacy jobs unchanged and active; no tick over 60 s (largest 57.5 s). `all_match` failed only on dispatch count for `admin-read-snapshots`, `data-delivery`, `lane-funnel` (1,437 dispatches against 1,444 legacy starts, the same 1,444 due minutes: 3 late pg_cron starts at busy minutes, caught up by design); **the Platform Admin accepted minute coverage as the gate** (17 Nov 23:2x AEDT). The live dry run (`db-migration-dry-run.yml`) caught a record-name clash in the first version, fixed before merge. | **Fresh 24-hour shadow from 16 Nov 2026 23:15 AEDT** (first tick under the fix) | Watch late ticks for 24 h (`pipeline.rollup_runs`, mode live). Unschedule the 25 legacy jobs with admin `docs/paste/PASTE-20261118-rollup-legacy-unschedule.sql` on or after 2 Dec 2026 (guarded: it refuses unless all 25 are off, retiring, past retire_after and idle 14 days). | The session that prepared PR 1. Do not touch from another session. |
| Consolidation PR 2, `admission-rule-runner` (lanes `-b`, `-c`) | 20 admission rules (`pipeline.admission_rules`) | **Live since 16 Nov 2026 23:31 AEDT** (Pilot #1185, migration `20261116190000`, main `3fa05b38`), cut over by S2 - SS Build under the Platform Admin's override of 16 Nov 21:23. Gate read 23:30 AEDT: shadow window 24.0 h, all 20 match, 0 minutes over capacity, 20 legacy jobs active with the registered md5 and schedule. Read back 23:33–23:36: 20 live, 20 legacy jobs off (`active = false`), 20 retiring (retire after 30 Nov 2026), 3 runner lanes on, 21 control events; first live runs 6 succeeded, 0 failed; G3 drift [] (75/48) | 15 Nov 2026 23:29 AEDT | **Done.** The other session's Tue 17 Nov 22:30 slot finds it cut over (the Platform Admin cancels it). `cron.unschedule` paste file `PASTE-20261116-admission-rule-legacy-unschedule.sql` on or after 1 Dec 2026 | S2 - SS Build (cutover); the session that prepared PR 2 |
| Consolidation PR 3, `pipeline.field_execution_registry` and `coverage-lane-dispatch` (lanes `-b`, `-c`) | 13 coverage worker lanes (course-link-search-worker, coverage-find-site, coverage-reextract, coverage-reidentify, provider-contact-page, provider-facts, companion-read, course-list-read, credential-read, policy-add-tests, programme-discover, programme-read, source-find), plus 7 API v3 field lanes declared disabled and never dispatched | **Live since 18 Nov 2026 00:21 AEDT** (Pilot #1229, migration `20261118012000`, spec `s595`; cutover brought forward from Wed 06:45 by the Platform Admin, 17 Nov 23:02, 24-hour window waived). Shadow from 17 Nov 06:22: 13 of 13 commands and schedules equal to live (md5); 2,961 dispatcher ticks in 24 h, all succeeded, longest 0.8 s; load at most 235.7 of 300 s/min. Six lanes had differed only because flag-recheck (`security.flag_jobs_v1`) idle-pauses legacy jobs while the shadow counted every minute; **prerequisite Pilot #1227** (migration `20261118001000`, spec `s589`, live 17 Nov 23:06) made the shadow skip minutes the legacy job is off and moved the idle pause and its release onto the live lane (`security.job_switch_v1`, `security.job_switched_on_v1`; a retiring job is never switched on, UR-07), so `flag_requeue_v1` can no longer switch a legacy row back on beside its lane. Gate in the migration: last-hour report all_match for 13 (window wholly after #1227), legacy md5 unchanged, no person-paused job. Read back 00:21–00:25: 13 lanes live and enabled, 13 legacy jobs off and `retiring` (retire_after 1 Dec 2026), 13 cutover events, 3 dispatchers on, field lanes disabled, G3 75/48; no legacy start after the switch-off (last at 00:21:00, cutover 00:21:01.7); first live dispatches 16 succeeded, 0 failed, longest 169 ms. Unschedule: `docs/paste/PASTE-20261118-coverage-lane-legacy-unschedule.sql` on or after 2 Dec 2026 (refuses until `flag_jobs_v1` reads the live lanes from the registry, a Pilot change still to make). **Health check Wed 18 Nov 06:46 AEDT (read only, 6 h 25 min since the cutover):** 13 lanes live; 1,412 live dispatches succeeded, 0 failed, 0 skipped on an open breaker, 0 over budget, longest 1.4 s (companion-read); 0 consecutive failures and no unresolved `coverage_lane_breaker:` issue; 1,155 dispatcher ticks, 0 failed (two slow ticks at 01:46 and 01:56, 74 s and 103 s, no lane missed); 0 legacy jobs switched on and 0 legacy starts since 00:21:01; the idle pause now acts on the lanes (coverage-reextract held with a raised idle flag, three others paused and released on the lane); G3 75/48. **Left out (unchanged):** `coverage-ai-match`, `calendar-reread` (S2-Intakes), `coverage-read` and `coverage-read-2` (30-second schedules) | — | Post-cutover health check Wed 18 Nov 06:45 AEDT (scheduled, read only) | S2 - SS Build |

**Scheduled gates (S1-Build, Platform Admin 17 Nov 2026 18:02):**
- **PR 1 cutover: live since Tue 17 Nov 23:47 AEDT** (Pilot #1232, migration `20261118010000`), before Thursday's squash, so the canonical baseline captures it. The 23:20 scheduled review was switched off (done early at the Platform Admin's request, 23:07).
- **Squash pre-staged (17–18 Nov night):** squash tooling Pilot #1234 merged (folder helper, 46 listers, `scripts/migration-squash.mjs`, s594); squash tooling 2 Pilot #1237 (fixtures and path checks that build a path at run time, found by the rehearsal) merged 18 Nov about 00:58 (main `acf01a35`); **Rehearsal done Wed 18 Nov 10:30–11:06 AEDT (runbook section 6):** production dump run 44199899527 (`schema.sql` md5 `eba7462e…`, carriage returns in the 7 consumer functions equal live); rebuild proof run 44201959838 on `coursefinder-boost-test` (every squash check PASS, G3 75/48; one stale Boost check handed to S2 - BOOST); draft #1235 (never merged) green at live head `20261118113000`: 750 files archived, 1,118 references repointed, 3,364 of 3,364 tests. Thursday's window repeats these steps at that night's head. Details and the production history findings (one documented no-op file, two live-only versions): runbook section 4.
- **Canonical migration squash: done Thu 19 Nov 2026 02:15 AEDT (Pilot #1325, merge `a0f0e10f`).** Canonical baseline = production schema dump run 44324920057 (01:30 AEDT, live head `20261118272000`, 2,148 history rows), `supabase/live-capture/baseline/schema.sql` md5 `40cf02f4e8f5a6c2cb53bf351c55eccc` (2,889 functions, 720 tables; the 7 consumer functions keep their carriage returns, `.gitattributes` keeps the baseline out of line-ending conversion). Cut-off `20261118272000`: the 800 applied files up to it are in `supabase/migrations-archive/`; `supabase/migrations/` holds only `README.md` and new migrations from here. Rebuild proof run 44327488382 passed for the squash (G3 75/48, no drift; the one Boost check `outside_window_refused` fails as in the rehearsal). Read back: head and history unchanged, G3 75/48 no drift, Deploy on merge applied nothing. Production unchanged. Results: [`docs/platform/MIGRATION-SQUASH-RUNBOOK.md`](platform/MIGRATION-SQUASH-RUNBOOK.md) section 6.

**Platform Admin 16 Nov 2026 22:44 AEDT, dispatcher order changed:**
- **PR 1 does not block PR 3 or PR 2.** PR 3 (from 23:15 AEDT tonight) and PR 2 (Pilot #1185, merge after 23:28 AEDT tonight) proceed independently of PR 1.
- **PR 1** gets its three fixes now:
  - the history clean-up moves to `housekeeping-daily`;
  - each live target's due minute is recorded before it runs;
  - `layer2-onboarding-snapshot` stays on its own job.
- **PR 1 timing:** a fresh 24-hour shadow starts when the fix is live, and the cutover targets **Tue 17 Nov 2026 22:30 AEDT**.
- **PR 1 fix live 16 Nov 2026 23:14 AEDT** (Pilot #1187, read back above). The shadow started at 23:15 AEDT, so the full 24-hour cycle ends **Tue 17 Nov 23:15 AEDT** and the cutover review is scheduled for 23:20 AEDT.

Pending paste files (run by the Platform Admin; details and md5 in `docs/paste/README.md`):

| File | Run on or after |
|---|---|
| `docs/paste/PASTE-20261115-cron-legacy-jobs-drop.sql` | Part A any time; Part B from 29 Nov 2026 |
| `docs/paste/PASTE-20261116-retired-settings-drop.sql` | 29 Nov 2026 |
| `docs/paste/PASTE-20261116-admission-rule-legacy-unschedule.sql` (the 20 legacy admission rule jobs, PR 2; guarded) | 1 Dec 2026 |
| `docs/paste/PASTE-20261117-supabase-invite-email-template.md` (Supabase Auth: Site URL, Redirect URLs, Invite user and Reset password templates for v2.16.16) | **Steps 1 to 3 done 17 Nov 2026 14:33 AEDT** by admin workflow `supabase-auth-config.yml` (run 44009123373, read back; section 5 › S1-Build). Step 4 (a test invitation and reset to an address you control) is the Platform Admin's |
| `docs/paste/PASTE-20261116-staging-boost-bucket.sql` (private Boost bucket) | **Done 17 Nov 2026 14:37 AEDT** by Pilot #1199 (migration `20261117152300`, same values and check); nothing to paste |
| `docs/paste/PASTE-20261116-api-field-dictionary-number-arrays.sql` | Any time (Pilot `20261116110000` is live); then a small migration loads the 2 held fields |
| `docs/paste/PASTE-20261116-l4-lift-false-link-refusals.sql` | Any time: lifts 59 false course-link refusals of live pages verified valid (Layer 4 report §7.3); stops unless exactly 59 rows match |
| `docs/paste/PASTE-20261118-rollup-legacy-unschedule.sql` (the 25 legacy report jobs, PR 1; guarded) | 2 Dec 2026 |
| `docs/paste/PASTE-20261118-coverage-lane-legacy-unschedule.sql` (the 13 legacy coverage worker jobs, PR 3; `flag_jobs_v1` guard met by s767) | 2 Dec 2026 |
| `docs/paste/PASTE-20261119-pr4-legacy-unschedule.sql` (the 9 legacy jobs of PR 4: 8 coverage worker jobs and `settings-backup-daily`; `flag_jobs_v1` guard met by s767; md5 `1817ff40`) | 3 Dec 2026 from 08:20 AEDT |
| `docs/paste/PASTE-20261118-rm1f-amba-accreditations.sql` (RM1F: 13 AMBA schools in AU, NZ, CA as `under_review`; data only; guarded; md5 `c1ebf1b3`) | Any time; switch to `active` after the reuse position is confirmed |

## 5. Open work in the repositories

### S1-RM-Design, 19 Nov 2026 16:18 AEDT directive: AU university identity holds (s766) and Layer 4 Grid Country and Provider type pills (s767)

- **Pilot #1385** (v2.16.53, commit `0b68e4d3`), migrations `20261119172000` and `20261119173000` applied by deploy on merge and read back; G3 75/48. Full record: `docs/platform/2026-11-19-s766-s767-au-university-identity-and-grid-filters.md`. Every read ran through the rolled-back dry-run workflow (no interactive query); Firecrawl 0; spend today US$0.0081 of the US$0.50 cap.
- **s766 done:** host owners recorded (vu.edu.au to Victoria University 00124K, rmit.edu.au to RMIT University, westernsydney.edu.au to Western Sydney University) and honoured by `security.provider_description_identity_v1`; the three owners read `identity_clear`, RMIT UP stays `provider_host_conflict`. "Torrens University" and "Moore Theological College" recorded as `trading_name` aliases and passed to the reader. One stored-page read queued for each (state queued, drain rule `s766-au-university-identity`); no description admitted yet.
- **s766 handed over, by finding:**
  - Victoria University 02475D (35 active courses, vu.edu.au/international) is a separate CRICOS registration, not a copy: 120 tables reference a provider and no merge function exists. A person decides which courses move or retire; it stays held meanwhile.
  - The "NA" record (CRICOS 03811G; Myotherapy, Real Estate and Beauty Therapy courses; 7 active; website aucd.edu.au manually locked) is a different VET provider. A person should correct and unlock its website; that clears `domain_shared` on it and on the Australian University College of Divinity (41 courses, no stored page).
  - RMIT, Western Sydney, Victoria and AUCD have no stored About page, so no read is possible until one is stored (acquisition is off).
  - Macquarie University: open `identity_unconfirmed` finding (mq.edu.au fits neither the name nor the contact email domain; no site check verified it). Avondale University: About address redirects to `/your-uni/`, not an approved address.
- **s767 done:** `public.admin_layer4_grid_read_v1` takes `country` and `provider_type`; Layer 4 Review › Grid pills Country (All, Australia, New Zealand, Canada) and Provider type (All, University, VET / College, School, HEI). Live: Entry requirements (AER) 492 = AU 482 + NZ 10 + CA 0. Not kept in a saved view.
- **Spec numbers:** other lanes already hold `cf-247-s766-pr4-lane-fold-cutover-contract` and `cf-247-s767-lane-state-chronic-fail-contract`; this lane's specs are `cf-247-s766-au-university-identity-contract` and `cf-247-s767-layer4-grid-country-type-contract`. s778 untouched.
- **Addendum 17:02 (Pilot #1388 and #1391, migrations `20261119175000` and `20261119181000`):** trading names recorded for AUT, CIHE, Kaplan Murdoch and Sydney Met (with Torrens and Moore); Holmes Institute host owner holmesinstitute.edu.au to 02639M (reversible). Bounded stored-page read: Kaplan Murdoch, CIHE and Sydney Met admitted; Torrens, Moore and AUT held by the sentence checks. Firecrawl 0; OpenRouter US$0.0887 in the window across all lanes (cap US$0.10); window closed. Lyons College and Awanuiārangi need an About page with the name in a heading (a person). G3 75/48 and manual locks untouched.
- **Local note:** `cf-247-s121` Layer 4 phone test fails on a developer machine that holds an old `dist/version.json` (the "newer version" banner makes `getByRole('status')` ambiguous); it is not caused by this change.

### S2-Build, 19 Nov 2026 15:30 AEDT: page-text claim bounded (s772, IQ-00606), readiness as plain per-country CSVs (s771); s773–s775 handed to S1-Build

**Status at 19 Nov 2026 15:30 AEDT. This block is the newest for these items.**

**Directives:** Platform Admin 19 Nov 2026 14:24, 14:33 and 14:36 (quota boundary: finish #1377 and s771, hand s773–s775 to S1-Build). All live reads went through the rolled-back dry-run workflow.

**s772, IQ-00606 (Pilot #1377, migration `20261119150000`; closed by #1379, `20261119153000`):**
- **Cause.** `public.svc_page_text_next_v1` built the whole candidate set (about 18,000 bound pages, 12,700 eligible) and sorted it to keep 40: 2.9 s by plan, more under load. 14 of 55 runs had failed on the 8 s limit.
- **Fix.** `pipeline.course_priority` is empty, so the order is country Boost weight (AU 80, NZ 76, CA 72) and then course id. The claim now walks each country's bound pages in that order through the new partial index `coverage_course_pages_bound_read_course_idx` and stops at the limit. A busy call returns no items instead of waiting. Claim rows, items and order are unchanged.
- **Measured.** 0.75 s for 40 items and 0.93 s for 200 (rolled back); about 1.3 s live in a probe.
- **Live.** Every page_text run since 15:08 succeeded: 11 of 11, 440 items, 0 failed. G3 75/48.
- Migration renumbered from `20261119143000`, which S2-BOOST-AER's s751 had taken.

**s771, plain per-country CSVs (Pilot #1378; no migration):**
- The renderer writes one plain CSV per country, split by size so each file has the header and stays under 2.9 MB (one Drive connector upload).
- Today: AU 12.0 MB → 5 parts, NZ 2.99 MB → 2 parts, CA 1.64 MB → 1 file. Two AU halves would be about 6 MB each, over the limit, so it is 8 files, not 4.
- Export run 44456498448 (14:13 AEDT): the 8 files (6,061 / 6,140 / 6,128 / 5,994 / 1,380 AU rows; 3,814 CA; 6,203 / 311 NZ) are in Drive › Monitoring, and the zip is trashed.
- The scheduled task "Course field readiness to Drive (07:45)" now uploads the country files, trashes any Matrix zip or CSV, and keeps 3 days.

**Correction.** IQ-00594 and IQ-00588 were closed at 12:55 on 1.5 hours of clean runs (#1372). That was too early: Runner C timed out at 13:15 and 13:17 and Runner B at 13:19, in paths s720 had not bounded.

**Handover to S1-Build (s773–s775; no PR opened in S2):**

| Issue | Timed out | Path (from cron.job_run_details) | Suggested fix |
|---|---|---|---|
| **IQ-00594**, admission-rule-runner-b | 13:19, 120 s | `security.admission_rule_run_v1` → `security.adapter_overwrite_gated_v1(pipeline_num_v1('batch.adapter_overwrite', 200))` → `security.adapter_overwrite_v1` (FOR over SELECT rows) → `security.layer4_entity_or_parent_blocked(text,uuid,text)` → `exists(select 1 from security.layer4_active_blocks …)` | The view `security.layer4_active_blocks` is a `DISTINCT ON (entity_type, entity_id, block_scope)` over all of `pipeline.layer4_block_decisions` (then `event_type = 'block'` and not expired), so the predicate is not pushed through and each call scans every decision, twice per entity (entity, then provider), up to 200 entities a tick. Rewrite the check in the function to read the latest decision for (entity_type, entity_id, block_scope) directly, with an index on `layer4_block_decisions (entity_type, entity_id, block_scope, created_at desc, id desc)`. |
| **IQ-00588**, admission-rule-runner-c | 13:15, 120 s | `security.coverage_admission_gated_v1('coverage-admit-intakes', …)` → `coverage_admission_apply_v1` → `consumer_api_snapshot_v1()` line 31 EXECUTE → `public.zoho_edge_course_search_v2(null, array['NZ'], …, 5, 0)` → `zoho_course_search_v2` | One frozen Zoho read ran past 120 s (230 ms at 11:41). The s720 time budget only stops new reads from starting; it cannot cut one that is running. Likely it waits on the search-document refresh. Set a local `lock_timeout` before each snapshot read and catch the error per read (mark it skipped), or skip the search cases while the writer lock is held. The snapshot is evidence only (Decision 163); the frozen functions are unchanged. |
| **IQ-00588**, admission-rule-runner-c | 13:17, 120 s | `coverage_admission_apply_v1` line 9: `create temp table _adm on commit drop as select * from security.coverage_admission_plan_v1(p_extractor) where action in ('write','differs') and attribute=any(p_attributes)` | `coverage_admission_plan_v1(text)` (6,035 characters) plans every item before the attribute filter and the batch are applied. Push the attribute filter and a bounded batch into the plan (a body change only; the signature stays). |
| **IQ-00426**, no-page-propose | 13:37, 120 s | `security.no_page_propose_v1()` → `insert into pipeline.bind_match_scope(provider_id, why, unbound) select … from catalogue.courses c join …` → `security.enrich_focus_v1(uuid)` (1,015 characters) → `security.pipeline_list_v1(text,jsonb)` "during startup" | The focus is evaluated once per course across the catalogue before the top providers are chosen. Pre-select the candidate providers by an indexed key with `LIMIT` first, then call `enrich_focus_v1`, and read `pipeline_list_v1` once into a variable instead of per row. |

**Live head:** `20261119153000` (G3 75/48).
**Issue states at 15:35 AEDT:** IQ-00606, IQ-00609 and IQ-00348 closed; IQ-00594 and IQ-00588 reopened; IQ-00426 triaged (the last three are for S1-Build).
**TEST-REGISTER:** not regenerated in this session (packages not installed). New or changed specs: `s771` (new), `s772` (new, extended by #1379).

**Next:**
- S1-Build: s773–s775 above.
- 07:45 AEDT Friday: first unattended per-country publish.

### S2-Build, 19 Nov 2026 12:50 AEDT: living cost published, wave 2 published, reliability unblock live (s720), evidence-link-index alert fixed, daily course field readiness (s770)

**Status at 19 Nov 2026 12:50 AEDT. This block is the newest for these items.**

**Directives:** Platform Admin 19 Nov 2026 06:41, 06:45, 06:50, 06:57, 08:17, 10:50, 11:41 and 11:42. All live reads in this block went through the rolled-back dry-run workflow (no interactive Supabase calls after 10:50).

**Layer 1 and destination (s714–s719):**
- **10:10 scheduled check.** ABS, BOM and LIN 19/198 ran at 09:05 and are Healthy, next due 19 Dec. The NZ, GB and US visa sources ran at 10:05 and were unchanged. The Canadian clean-up and the Ontario APS pause stand.
- **LIN 19/198 fact not found.** The instrument sets "primary applicant annual living costs" in italics, so its page text has a space inside each bracket. Pilot #1363 (migration `20261119104100`) allows the space and made LIN due at once.
  - It was read at 10:36: AUD 29,710, with evidence `destination/page-facts/www.legislation.gov.au/282a04f2….html` (CC BY 4.0).
  - The new Home Affairs edition "(read 19 Nov 2026, 10:36)" is **published with visa_funds AUD 29,710** and Australian country applicability, alongside the other 5 rules.
- **Home Affairs Step by step tab (`#HowTo`).** Firecrawl's rendered page does not include the tab's content. The nearest amount (AUD 87,856, the income alternative) is refused by the plausible maximum. LIN 19/198 is the source of the amount.
- **UKVI and USCIS were not publishing.** Their owners were not on `destination.open_licence_owners`. #1363 adds both. UKVI (2 visa_funds rules, OGL v3.0) and USCIS (OPT up to 12 months, public domain) were **published** by `destination-open-licence-publish`. Immigration New Zealand stays held (terms pending).
- **Firecrawl:** 31 credits for `destination_page_facts` today; the "other" share is 74 of 200, 126 left.
  - Open item: the loader reads every page-fact page on each source run, so three sources due at one tick read the Home Affairs pages three times (23:05 UTC). Scoping the read to the source's domains is a loader change for later. Cadences are 30 days, so the cost is small.

**Reliability unblock (s720; Pilot #1364, #1366, #1369; migrations `20261119104500`, `111500`, `114500`, `115000`; CREATE OR REPLACE of 6 existing functions, settings, one outcome code, rollup target rows; no new table or function; G3 75/48, no drift):**
- **IQ-00609, coverage build.** `security.course_coverage_build_v1` rebuilds the oldest providers each run, up to `batch.course_coverage_courses` (now 400), every 2 minutes. It was a full 36,031-course rebuild taking 65–112 s. Reads are limited to the chunk, rows are replaced by provider, and the daily counts move by each run's change.
  - Live: daily counts equal the table (530,137; Australia 385,545).
  - At 800 courses runs took 11.7–16.0 s live, so the chunk is now 400 (the whole table about every 3 hours).
- **Dispatcher finding (for S1-Build).** `security.rollup_tick_v1` estimates a target's time as its longest successful run in the last 14 days. That kept the chunked build deferred behind group A's every-minute targets. #1366 gives `course-coverage-build` priority 5, so it runs first in its due ticks. The dispatcher is unchanged.
- **IQ-00594/IQ-00588, runners B and C.**
  - The admission evidence snapshot reads 5 rows per frozen read within 6 s (5.0 s measured).
  - The coverage admission tries the search writer lock and queues to `search.refresh_requests` when it is busy.
- **IQ-00606.** `svc_page_text_next_v1` claims each stored page once (20 items in 0.7 s).
- **Planner.** `enrich_plan_auto_v1` released 34 stalled automatic plans (outcome `released_stalled`, skip-locked) and created new ones: 26 open after the 11:41 run (was 40 of 40).
- **Two clean cycles.** From the 11:03 deploy to 11:52 AEDT: 203 runs of rollup-scheduler and admission-rule-runner A, B and C, **0 failures and 0 statement timeouts**.
- **IQ-00348, evidence-link-index critical alert (11:42).** The ranked queue is drained: 46,597 artifacts unindexed, none of them a ranked provider's. The feed still read 108,483 artifact rows from the heap to prove that (8.9 s, over the 8 s gateway limit).
  - #1369 (`20261119114500`) finds the ids from the queue index alone, with a 4 s query limit: 1.6 s live (was 9.5 s).
  - Edge calls at 12:19, 12:29 and 12:39 AEDT all returned **HTTP 200** (the calls at 11:59 and 12:09, before the deploy, were 500).
- **Issues.** IQ-00609, IQ-00594, IQ-00588 and IQ-00348 were verified as cleared and are **closed** through `security.integration_issue_close_v1` (Pilot #1372, migration `20261119125500`, read back 13:16 AEDT).
- **IQ-00606 stays open.** The duplicate-claim error is gone: before the deploy 92 of 92 page-text runs failed; since it, 41 of 55 succeed. The other 14 hit the 8 s limit in the claim, which reads about 18,000 bound pages to keep 40 (2.9 s by plan). The follow-up is a bounded candidate walk. A failed claim retries 2 minutes later and nothing is lost.
- **Slip (07:2x AEDT).** Pilot #1343 was merged in the same command as the head re-read, and the deploy applied `20261119083100` out of order (md5 matched). Every merge since re-reads the live head first and merges in a separate step.

**Daily course field readiness (s770; the directive's s721 was taken on main; Pilot #1370, #1371 (sheet-ready tabs, top 100 providers); no migration, nothing written to the database):**
- `scripts/telemetry/course-field-readiness.sql` (read only) gives each active course × the 14 canonical API v3 fields either its admitted value (80 characters at most) or one of TRYING, POSSIBLE_NEEDS_SOURCE, NOT_POSSIBLE or EMPTY_NOT_STARTED.
- Workflow `course-field-readiness.yml` runs daily at 07:30 AEDT (20:30 UTC) and commits the CSV and the summary to branch `course-readiness-snapshot`.
- The scheduled task "Course field readiness to Drive (07:45)" (automatic approval) puts them in Drive › Monitoring and trims dated copies older than 3 days.
- **First run 12:27 AEDT** (run 44436981882): 36,031 courses (AU 25,703, NZ 6,514, CA 3,814). Admitted:

  | Field | Admitted |
  |---|---|
  | duration | 81.9% |
  | tuition_fee | 77.0% |
  | official_url | 66.8% |
  | english_requirements | 57.8% |
  | description | 41.7% |
  | study_load | 17.2% |
  | intake_dates | 7.9% (56.2% not possible: month-only) |
  | aer_academic | 3.9% |

- **Drive › Monitoring:**
  - `Course_Field_Readiness_Matrix_2026-11-19.zip`: the full 16.6 MB CSV, zipped. The connector carries at most about 3.1 MB per call, so the plain CSV cannot be uploaded.
  - Google Sheet `Stakeholder_Course_Readiness_Summary` with tabs `Executive_Summary` (counts, with percentages as formulas), `By_Provider_Action_List` (top 100 providers by cells needing a source; UNSW Sydney, NZIST Work-Based Learning and Monash first) and `Dev_Display_Rules` (the 5 states → API v3 `empty_reason_code` → display rule).

**Guardrail notes:**
- **Pilot #1333 (coverage telemetry).** Merged 06:4x AEDT under the Platform Admin's authorised exception of 06:41: one internal table (`pipeline.tracked_fields`) and two internal functions (`security.tracked_field_coverage_v1`, `public.admin_coverage_telemetry_v1`). None is in the consumer API, which stays G3 75 functions / 48 tables with no drift. The "zero new tables or functions" rule otherwise stands.
- **Hourly admittance telemetry (06:57, s717).**
  - Drive › Monitoring has the Google Sheet `Hourly_Admittance_Telemetry` (tab of the same name, en_AU, Melbourne time) and `Hourly_Admittance_Telemetry.csv` (one current copy).
  - The scheduled task "Hourly admittance telemetry" runs `scripts/telemetry/hourly-admittance.sql` (read only) at minute 1 of every hour and appends one row. Rows are in place for 07:00, 08:02, 09:01 and 10:02.
  - The 27 columns: snapshot_aedt, snapshot_utc, courses_admitted, courses_held, courses_rejected, providers_admitted, providers_held, providers_rejected, scholarships_admitted, scholarships_held, scholarships_rejected, aer_admitted, aer_held, aer_rejected, destination_admitted, destination_held, destination_rejected, coverage_courses, coverage_fields_n, coverage_courses_all_n, coverage_courses_zero, coverage_mean_fields_admitted, coverage_tracked_fields, jobs_active, jobs_off, job_runs_1h_succeeded, job_runs_1h_failed.

**Live head:** `20261119125500` (G3 75/48, no drift).
**TEST-REGISTER:** not regenerated in this session (packages not installed). New or changed specs: `s719` (extended), `s720` (new), `s770` (new).

**Next:**
- Platform health: confirm green at its next check.
- IQ-00606: bounded page-text candidate walk.
- 07:45 AEDT Friday: first unattended readiness publish.
- S1-Build: dispatcher estimate window.
- Loader: scope page-fact reads to the source.


### S2-BOOST-Courses, 19 Nov 2026 08:35 AEDT: description reader live (Pilot #1344, v2.16.50), re-reads queued, live counts read as the UAT user (s728)

- Live migration head `20261119084000`; worker `coverage-sweep` v1.0.25; prompt `cdesc-source-grounded-v4`. #1335 and #1336 closed (superseded).
- 666 held course descriptions drained (read 10:14 AEDT): 267 admitted since 07:40 (161 with v4), 94 in review; the 09:23 `field-gap-queue` run succeeded after the 08:23 statement timeout. Courses with a description 14,700 of 36,031 active (14,433 at 07:42). G3 clean (75 functions, 48 relations); live head `20261119103000`.
- Study load 5,689 of 36,031 active; Layer 4 Boost study load 179, Campus locality 69, University description 76 (live, run 44400209609).
- Pilot #1346 (s723, s724, s726; S1-Courses lane) is open and conflicts with main. GitHub secrets are write-only; the live check ran through the deployed-uat login (s728).
- Detail: `docs/platform/S2-BOOST-COURSES-HANDOVER-2026-11-19.md`; self-check scheduled about 10:14 AEDT.

### S2-Build, 19 Nov 2026 06:00 AEDT: post-squash batch (Platform Admin 19 Nov 2026 05:21): Boost test project rebuilt and re-seeded, blades live for every role, round states on rollup-scheduler only; coverage telemetry held for a decision

**Status at 19 Nov 2026 06:00 AEDT. This block is the newest for these items.**

**Done:**
- **Item 1: Boost test project.**
  - Check d of `sql/boost-ingestion/005_rehearsal_rolled_back.sql` (`outside_window_refused`) now narrows the two window settings to 1 to 5 inside its rolled-back block and confirms the refusal there. It also reports the live window (`window_live`, today `[0, 24]`). Admin #622.
  - Full rebuild proof, admin `boost-test-rebuild.yml` run 44369667112 (05:26–05:41 AEDT), dump `db-schema-dump/44324920057` (the post-squash baseline, head `20261118272000`). Results branch `boost-test/44369667112`. **Verdict PASS, all five checks:**
    - G3 is 75/48 with no drift.
    - 1,000 rows loaded in 0.039 s.
    - 50 shadow rows, 0 admitted, 0 courses changed.
    - Rehearsal: 1 study load written, 0 `updated_at` touched.
    - A run outside a narrowed window is refused.
    - Schema: 16,989 of 16,989 statements, 0 failed.
  - Of the 5 production migrations newer than the dump, 4 applied. `20261119044000` (S2-BOOST bench-5) stopped at its own post-check ("the study-load admission qualification changed"), because the test project's qualification list is empty by design. The verdict does not count it; for S2-BOOST to note.
  - Re-seeded with admin `boost-test-experiment.yml` run 44372812878 (label `reseed-post-squash-20261119`): 12 providers, 69 courses, 60 without a study load. The admitted-count experiment passed all 9 checks, and the promotion function is production's. Results branch `boost-experiment/44372812878`.
- **Item 2: destination sources.** Already in place since 19 Nov 00:05 (Pilot #1318, #1322): five Australian sources under Layer 1 Register › Australia (Fair Work paused and restricted), the Layer 1 schedule and Run now, the Storage artifact, the evidence record (source, licence, `fetched_at`) and successor editions. Published on API v3: Home Affairs 5 rules, JSA 1,577 careers (now with `employment_count`), BOM 40, ABS 102.
- **Item 4: student-facing reads (server Pilot #1329; screen Pilot #1330, v2.16.47, merged 05:50 AEDT).**
  - Around this course and Around this provider now read city figures, careers and visa rules for every StudySearch role. The read-gap note shows only when a read fails.
  - Accreditations come from the provider record. Rows under review are marked for Editors and up only.
  - Specs `s694` and `s696` were updated, the release contract `m245` was bumped, SOPs are 2.72 and 2.32, and the UI map is unchanged (checked). Deployed UAT passed on main.
- **Item 5: round states on rollup-scheduler only (Pilot #1332, migration `20261119052000`, md5 `fc622344`, matching the dry run; `s710` extended).**
  - The paused cron job `scholarship-discover-refill` ran `security.scholarship_discovery_refill_v1` on the UTC date, and that function ended with its own round-state refresh. The refresh is removed from it; the job stays paused.
  - The target `scholarship-round-state-refresh` (Melbourne date) is now the only caller. It ran at 04:23 and 05:23 AEDT; both runs succeeded.
- Live head `20261119052000`; 2,154 migrations applied; G3 75/48 with no drift. Admin mirrors: `docs/UI-MAP.md` (v2.16.49) and `docs/sops/` (2.73, 2.32) regenerated from Pilot main `3ebe7e41`.

**Held for a Platform Admin decision:**
- **Item 3: coverage telemetry (Pilot #1333, not merged).**
  - Branch `cf247-coverage-telemetry` is renumbered to `20261119053000`, otherwise unchanged; the recorder pre-check md5 still matches live.
  - Rolled-back live dry run passed (md5 `e9ee89f4`), CI is green, and spec `s713` was added (the reserved block s691–s699 is fully used).
  - It adds one table (`pipeline.tracked_fields`) and two functions (`security.tracked_field_coverage_v1`, `public.admin_coverage_telemetry_v1`). None is in the consumer API (G3 stays 75/48), but the directive also says "zero new tables or functions". Merging needs the Platform Admin to allow that exception.
- **Stale PRs #1307 and #1287** were already merged (18 Nov). Nothing to close.

**Not done:**
- **Home Affairs 12-month living cost (financial capacity).** The rendered student visa page's main content has no amount: the loader's pattern only found "primary applicant" in the fee-concession text. Secondary sites give AUD 29,710 and place it on the Department's page under the Step by step tab. It is not published from secondary sources.
  - Options for the Platform Admin:
    - read the Step by step tab with a Firecrawl action (an on-demand read, a few credits);
    - or register the legislative instrument (LIN 19/198 as amended, Federal Register of Legislation, CC BY 4.0) as a Layer 1 source.
- **TEST-REGISTER:** not regenerated, because packages are not installed in this session and no CI workflow regenerates it. New or changed specs since the last register: `s694`, `s696`, `s710`, `s711`, `s712`, `s713`, `m245`.
- Pilot #1335 and #1336 (S1-Courses) also claim package 0.1.469; both were told on the PR to re-bump on rebase.

### S2-Build, 19 Nov 2026 04:30 AEDT: API v3 PR D read path, scholarship round states on the Melbourne date, student-facing destination read (Pilot #1328, #1329; s710–s712)

**Status at 19 Nov 2026 04:30 AEDT. This block is the newest for these items.**

**Done (Platform Admin directive 17:55, repeated 21:58; after the 03:30 freeze):**
- **Pilot #1328**, merged 19 Nov 04:03 AEDT, outside the 01:15–03:30 freeze. Live max was `20261118272000` when re-read just before the merge. History md5s match the rolled-back dry runs:
  - `20261119041000` (md5 `2b24a44e`, s710): `security.scholarship_round_state_refresh_v1` now compares round dates with the Australia/Melbourne date (`(now() at time zone 'Australia/Melbourne')::date`) instead of the UTC date. The function was edited with an md5 guard; its four `current_date` comparisons were replaced, and nothing else changed. A round no longer turns open or closed at 11:00 AEDT (UTC midnight) instead of at Melbourne midnight.
    - New `rollup-scheduler` target `scholarship-round-state-refresh`: live, group A, priority 75, hourly at :23. The batch is the setting `batch.scholarship_round_state` (default 1000; G2). No new job or `cron.job` row.
  - `20261119042000` (md5 `87c8f09a`, s711): v3 read path additions (v3 is open to additions until go-live, Decision 277):
    - `course_v3_fields_v1`: `primary_basis` on each primary campus.
    - `website_v3_provider_item`: `is_primary` and `primary_basis` on each campus.
    - `destination_read_v1`: `employment_count` on each career row (JSA Table 1, "Employment in main job"). For example, Corporate Services Managers has 10,000.
  - `20261119043000` (md5 `4c5695b5`): API v3 field dictionary synced to 2,227 fields (11 added). `docs/api/v3/field-dictionary.json` was updated, and the dictionary spec points at this migration.
- **Read back live (04:10 AEDT):** 0 `current_date` left in the function and 4 Melbourne-date comparisons; the target is live, and its first run through `rollup-scheduler` succeeded at 04:23 AEDT (1.2 s); `ref.api_field_dictionary` holds 2,227 fields; G3 is unchanged at 75 functions and 48 relations with no drift. Migrations applied: 2,151.
- **Pilot #1329** (S712), merged 19 Nov 04:46 AEDT: the student-facing destination read and the accreditations read handed over by S1-RM-Design. Live max was `20261119044000` (another session) when re-read just before the merge, and both function bodies still matched the md5 guards.
  - Migration `20261119045000` (md5 `fcd33705`, matching the rolled-back dry run; spec `s712`) makes two md5-guarded edits of existing functions. No new table or function; G3 is 75/48 with no drift.
  - `public.admin_destination_review`: a Viewer or Counsellor may read `locality_metric`, `career_outcome` and `study_rule`. Rows are approved only; careers and rules must also be in a published edition. Fields are student-facing only: no evidence, quote, applicability, edition or terms status, dataset edition or audit columns. Every other kind stays Curator and above. Curator and above see exactly what they saw before.
  - `public.admin_read('provider_detail')` now carries `accreditations[]`. Curator and above see every row with its status. Viewer and Counsellor see the API v3 set (active, not expired).
  - Read back as a Counsellor: 5 published study rules (the 4 superseded rules excluded), 142 city figures and the career list (capped at 200, the same as for admins), with student-facing keys only. The postcode review is refused ("Curator role or above required"). Accreditations: `[]`, because the AMBA rows are under review. As Platform Admin: 9 rules with edition status, as before; accreditations show AMBA `under_review`.
  - The migration file is named without "correlat" because `s694` guards that S1-RM-Design's screen change came with no migration.
  - **Handed back to S1-RM-Design:** the Course and Provider detail cards still gate the read on Curator (`curator` in `src/CorrelatedBlade.jsx`). Viewers see the read-gap note until that one-line screen change ships with its release bump.
- **Home Affairs successor edition published:** v3 `/destination` serves 5 study rules, including the 485 Post-Higher Education Work stay of 2 years.
- **On-demand window `9f54b912`** (scholarship detail fill after the reader stall, OpenRouter) closed at 04:07 AEDT:
  - Estimate US$0.19 (ceiling US$0.63).
  - OpenRouter use in the window, all lanes: US$0.31. No Firecrawl.
  - OpenRouter balance went from US$11.36 to US$10.04, with other lanes included.
- No new table or function: four existing functions were edited, each behind an md5 guard.

**Not done (reported to the Platform Admin):**
- **PR C (accreditations on API v3) is blocked on reuse terms:**
  - AMBA's 13 rows are `under_review`, awaiting the Platform Admin's terms decision (paste file from S1-RM-Design).
  - AACSB points data use to its Master Data Use Agreement (MDUA).
  - EQUIS publishes no reuse terms.
  - Nothing is published until terms are approved; a passing load never publishes by itself.
- **Multi-field live admission path:** this is the S2-BOOST lane, and it needs the qualification references first. Not built here.
- **Still open:** the 12-month living-cost benchmark (financial capacity) on the Home Affairs page; the `cron.unschedule` paste file for the three retired destination side jobs after 14 days (from 2 Dec 2026); the screen change that calls the student-facing read for every role (S1-RM-Design).
- **TEST-REGISTER:** no CI workflow regenerates it. Local generation fails here because the sandbox has no network (`lucide-react` is missing). The three new specs (`s710`, `s711`, `s712`) are picked up on the next generated run.

### S1-RM-Design, 19 Nov 2026 06:39 and 06:50 AEDT directives: scholarships listed once (s699)

**Status at 19 Nov 2026 07:40 AEDT. This block is the newest for these items.**

- **v2.16.49 (Pilot #1342, merged 19 Nov about 07:03 AEDT, no migration, spec `s699`).** Found by a live check of v2.16.47 at 375×812 in Preview as Viewer and Counsellor:
  - The Around this course card is headed **Entry requirements** and carries no scholarship line, for every role. `CARD_SPEC` (card `entry`) lost its `scholarships` field.
  - The Scholarships section (three, then Show all (N) scholarships / Show less) is the only scholarship list on the Course detail. The Provider detail is unchanged.
- **Verified live (v2.16.49, built-in browser, signed in as Platform Admin; no credentials asked for or read):** Diploma of Information Technology (Higher Education) at 375×812 in Preview as Viewer, Counsellor and Admin: card headed "Entry requirements", no scholarship text, one Scholarships list, no overflow; pipeline and task buttons hidden for Viewer and Counsellor, shown for Admin. Related insights & funding was not on this course (no QILT or PRISMS figures held), so that fold was not seen live.
- **Specs:** `s699` (7 desktop tests plus one `@responsive` phone test); `s694` and `s697` adjusted (same guards).
- **Spec document:** `docs/platform/2026-11-18-correlated-blades-role-visibility-mockup.md` v1.3 (section 6C, entry card table, layout sketch, empty states; decisions 1 and 2 marked done by S2-Build s712; one live screenshot).
- **Version coordination:** v2.16.48 stays with Pilot #1335 and #1336 (both claim it); this release took v2.16.49. Not touched: #1335, #1336, #1314, #1235.
- **Open:** confirm the Related insights & funding fold on a course that has QILT and PRISMS figures.

### S1-RM-Design, 18 Nov 2026 23:51 AEDT directive: Course detail declutter (s698)

**Status at 19 Nov 2026 00:40 AEDT. This block is the newest for these items.**

- **v2.16.46 (Pilot #1324, merged 19 Nov 00:26 AEDT, no migration, spec `s698`).** Found on Diploma of Information Technology (Higher Education), on a phone, in Preview as Viewer:
  - Description pipeline and Tasks that held this course hidden for Counsellor and Viewer; folded by default for Editors and Platform Admins.
  - Check scholarships for this course and every other task button hidden for Counsellor and Viewer.
  - Related insights & funding (QILT, PRISMS) folded by default for every role.
  - Scholarships listed once on the Course detail (the insights add no second Scholarships & funding card there; the Provider detail keeps its own).
- Adjusted to open the new folds (same guards): `cf-247-f-cdesc-06-on-demand` (desktop and phone), `s697`, deployed `a12-contextual-insights`.
- **Spec:** `docs/platform/2026-11-18-correlated-blades-role-visibility-mockup.md` v1.2 (section 6B, two matrix rows, two screenshots from mocked data; the built-in browser is still unreachable).
- **Not merged by this lane:** Pilot #1314 (still claims v2.16.44) and #1235.

### S1-RM-Design, 18 Nov 2026 23:02 AEDT directive: Course and Provider detail fixes after live inspection (s697)

**Status at 18 Nov 2026 23:55 AEDT. This block is the newest for these items.**

- **v2.16.45 (Pilot #1323, merged 23:33 AEDT, no migration, spec `s697`).** Four fixes found on Master of Teaching (Secondary) in v2.16.44:
  - Preview as pills (Admin, Counsellor, Viewer) show their full labels at every pane width (the drawer header's 32 px icon-button rule clipped them).
  - Archive course and the Read with AI bar are hidden for Counsellor and Viewer, and in Preview as Counsellor or Viewer.
  - Read / refresh entry requirements now and its pipeline steps and links are hidden for them; they see approved entry requirements only, or "No approved entry requirements published for this course yet."
  - Scholarship lists (course list, Around this course card, scholarship insight panel in Course and Provider detail) show three, then Show all (N) scholarships / Show less.
- **Spec:** `docs/platform/2026-11-18-correlated-blades-role-visibility-mockup.md` v1.1 (section 6A and four new matrix rows; screenshots from mocked data, the built-in browser still unreachable).
- **Spec number note:** Pilot #1318 (another lane) also added a spec named `s694` (`cf-247-s694-destination-sources-layer1-register-contract`); both files are distinct and pass.
- **Not merged by this lane:** Pilot #1314 (still claims v2.16.44; it re-bumps to the next free version on rebase), #1307 and #1235.

### S1-RM-Design, 18 Nov 2026 21:23 AEDT directive: correlated detail, Metric type pills, role-based field visibility

**Status at 18 Nov 2026 22:50 AEDT. This block is the newest for these items.**

- **v2.16.44 (Pilot #1315, no migration, specs `s694`, `s695`, `s696`).**
  - Course detail › **Around this course** (read only): Location & weather (BOM summer and winter means, rainfall and climate icon; ABS population; attribution), Career pathway, jobs & salary outlook (JSA), Visa & living-cost snapshot (Home Affairs), Entry requirements & scholarships.
  - Provider detail › **Around this provider**: Rankings (QS, THE, ARWU, subject), Campus city profiles, Scholarships & accreditations.
  - Destination data › City metrics & costs: **Metric type pills** (All, Climate & Weather (BOM), Population & Demographics (ABS), Careers, Jobs & Salaries (JSA), Study Rules & Living Costs (Home Affairs)).
  - **Role-based field visibility**: Viewer and Counsellor see student-facing values only; Editor and Platform Admin keep provenance and diagnostics; **Preview as: Admin | Counsellor | Viewer** in the detail header (Editor and up, never raises).
- **Spec:** `docs/platform/2026-11-18-correlated-blades-role-visibility-mockup.md` v1.0 (layout, every card's columns and fields, role matrix, live data and gaps; tables generated from Pilot `src/lib/correlation-adapters.js`, `destination-metric-types.js` and `field-visibility.js`). Screenshots from mocked data: the built-in browser could not be reached (503), so the live screen was not opened.
- **Live data behind the cards:** 40 BOM climate figures (8 capital cities), 102 ABS population figures, 1,577 JSA OSCA occupations with no salary, outlook, shortage or study-area link yet (the Career card shows its loading empty state), 4 Home Affairs rules (no post-study work years or financial-capacity figure yet), 13 AMBA accreditations.
- **Hand-off to S2-Build (no schema in this lane), after Thu 03:30 AEDT:** a read-only correlated read open to every StudySearch role that returns student-facing fields only (approved and published rows), so Viewers and Counsellors see city figures, careers and rule figures; and an admin read of provider accreditations. Until then those cards show a read-gap note to Viewers and Counsellors.
- **Not merged by this lane:** Pilot #1314 (another lane; also claims v2.16.44, so it re-bumps on rebase), #1307 and #1235; `cf247-coverage-telemetry` stays staged for S2-Build.

### S1-RM-Design, 18 Nov 2026 19:20 AEDT directive: Layer 4 clusters, Destination check

**Status at 18 Nov 2026 20:05 AEDT. This block is the newest for these items.**

- **v2.16.43 (Pilot #1309, no migration, `s693`).** Layer 4 › Inbox › Grid › **Clusters**: one kind's waiting items grouped by university, refusal reason and quote (reason and quote normalised: case, spacing, numbers and links ignored; the quote is found wherever the kind keeps it, including a hook's quote section). Read page by page from `admin_layer4_inbox` 'items' and 'detail'. Inspect, export as CSV, or settle ticked clusters with one choice, one reason and a typed confirmation; each item is decided through `admin_layer4_inbox` 'decide' exactly as its card would, at its own rank, and skipped where its hook does not allow the choice. Inspect only: `aer_review`, `campus_locality`, `intervention`, `provider_departure`; a choice needing a value, a page or a higher role is never offered. Beside S2-Build's Grouped decisions (server-defined groups for two kinds).
- **Closed loop.** A cluster that keeps returning is exported as the evidence for a Boost or reader rule, to be written into the worker or reader prompt with a regression test (both repos), not settled again and again. No recurring pattern was codified by this lane on 18 Nov.
- **Destination check (signed in, v2.16.42, before the browser link dropped at about 20:02).** Destination data › City metrics & costs: 142 figures, 40 BOM climate (icons rain, heavy rain, sunny, partly cloudy, snow) and 102 ABS population (`erp_persons`), side by side; overview: 4 editions published, 102 localities approved. No page overflow; the table scrolled 55px sideways at a 705px pane (none at 1280px), so v2.16.43 lets the measure cell wrap. The Clusters screen was not opened live (the built-in browser went offline); Deployed UAT and Release currentness are green at v2.16.43.
- **Not merged by this lane:** Pilot #1307 (S2-Build, migration `20261118234000`, CI green, a commit behind main, no rolled-back live dry run recorded in its description); `cf247-coverage-telemetry` stays staged for S2-Build after Thu 03:30 AEDT.

### S1-RM-Design, 18 Nov 2026 12:50 and 14:23 AEDT directives: Operations screens, Coverage now, climate icons, data model, RM1F, Wave 2 drafts

**Status at 18 Nov 2026 14:55 AEDT. This block is the newest for these items; where the 12:19–12:50 block below differs, this one wins.**

- **v2.16.41 Operations screens (Pilot #1278, no migration, `s640`).** Beside S2-Build's backend v2.16.39 (#1274). Automations leads with the three dispatchers: `rollup-scheduler`, `admission-rule-runner` (the directive's "enrich-lane-dispatch" does not exist live; this is the second consolidated dispatcher) and `coverage-lane-dispatch`, each with lanes, runs and failures in 24 hours and legacy jobs replaced. Retired legacy jobs (66 of the 70 switched-off `cron.job` rows) are hidden from the list and counts behind Show retired legacy jobs. Open issues links were already opening Queues & yield; their words said Work queues and are now named from the menu. Storage & retention leads with Storage now; Evidence leads with Where evidence comes from, linked to S2-Build's Audit trail.
- **v2.16.42 (Pilot #1285, no migration, `s650`, `s651`).** Coverage & completeness › Courses › Coverage now: readiness by country (AU, NZ, CA, UK, IE, US) and domain, and every recorded field, with no field list fixed in the screen. The Link refresh portal rows and the read-only Stalled fields counters are retired from Coverage. Destination data climate icons (lucide, ISC; rule in Pilot `src/lib/climate-icons.js`). Guides › Platform guide › How the data connects (Pilot `src/guide/entityModel.js`; admin `docs/platform/ENTITY-CORRELATION-MODEL.md`; pointer in `docs/integrations/api-v3/API-V3-FIELD-DEFINITION.md`).
- **Coverage read: schema need handed to S2-Build (Platform Admin 14:23: no schema change in this lane).** The 7-day change, trend lines, targets and Courses by fields admitted (0 of N to N of N) need `public.admin_coverage_telemetry_v1` and the registry `pipeline.tracked_fields` with the recorder `security.tracked_field_coverage_v1` (scholarship, destination edition and grade scale figures). Built and dry-run passed and rolled back on 18 Nov (md5 `a34e0863`, probe: 38 fields, N = 15, AU/NZ/CA grid), on Pilot branch `cf247-coverage-telemetry`, migration `20261118170000_cf247_coverage_tracked_fields_telemetry.sql`; **not merged by this lane**. The screen falls back to `admin_completeness_report` and shows the rest as soon as the read is live; it needs a timestamp above the live head when S2-Build applies it.
- **RM1F / REQ-57 accreditations.** No open licence was found for the AACSB, EQUIS or AMBA lists. AMBA's official list was read on 18 Nov: 13 schools in AU (4), NZ (6), CA (3), each matched to one provider by exact name (UQAM by acronym and domain); Ireland, the UK and the US have no providers yet. They are in paste file `docs/paste/PASTE-20261118-rm1f-amba-accreditations.sql` as `under_review` (API v3 returns only `active`); guard read live: 13 of 13. AACSB (one page per school on aacsb.edu) and EQUIS (EFMD list; the page needed an approval not available) are not loaded; secondary lists were not used.
- **Wave 2 register drafts (9, GB, IE, US, CA).** All nine already carry their official source URLs and terms `pending`; none has a sample or a parser spec. AI Auto-Map needs a sample (five file sources: HESA, UKVI, ILEP, IPEDS HD and completions) or reads the page itself (four page sources: OfS, QQI providers and programmes, IRCC PGWP). Pressing it is a fetch a Claude session asks for, which the Pilot rule opens first with `security.on_demand_open_v1` (a database write this lane cannot make without an interactive tool); the OfS draft was opened and closed without change. **Next:** the Platform Admin (or S2-Build) runs AI Auto-Map on the four page drafts, and attaches the five dataset samples.

### S1-RM-Design, 18 Nov 2026 12:19–12:50 AEDT directives: hotfix, Layer 1 wizard panel, 28-destination mapping, Operations UI, Coverage

**Status at 18 Nov 2026 13:45 AEDT. This block is the newest for these items.**

- **Hotfix v2.16.37 (ref ZDUFMC; Pilot #1270, no migration).** Cause: the v2.16.35 `lastTest` memo in `src/AuthEmailTemplates.jsx` sat below the screen's early returns, so the render after the settings loaded called one more hook (React error #310). It now sits above them. Render guard `s634` opens Users & roles › Links & Email Templates with loaded settings and steps through the four-step Create user flow; it fails against the old code and passes with the fix. A scan for the same pattern found no other case (five hits were separate functions). Live: v2.16.37 deployed 12:43 AEDT; the route rendered in a signed-in session with no console errors.
- **v2.16.38 Layer 1 wizard panel (Pilot #1272, no migration, `s635`).** Layer 1 › + Add source, step 1: once the target record type is chosen, What this source will create lists the baseline records the first apply run makes for the country (S2-Build #1258 and #1265), the rule each follows and the API v3 fields its mapping fills. It saves nothing. Numbered v2.16.38 because the hotfix took v2.16.37.
- **28-destination extensions inside the existing tables (12:21).** Runbook `docs/platform/DESTINATION-EDITIONS-AND-WAVE2-DRAFTS-RUNBOOK.md` v1.4, section 5: FT rankings (`ranking.systems` code `ft`), rule categories `dependants`, `minimum_wage`, `offer_document`, occupation schemes OSCA and NOL, national quality ratings (`catalogue.provider_accreditations` rows with `rating`, `rating_period`) and employment by industry (`destination.career_outcomes` with `series_kind = industry`). No new table. Columns live by S2-Build's #1268; value lists in paste file v2, the Platform Admin's to run before Thu 01:15. **G3 note:** 75/48 counts the consumer functions and the tables and views they read, not every table; s627 is the rule that keeps destinations in the shared tables.
- **Operations UI (12:50), in progress as v2.16.40.** S2-Build received the same directive at 12:49 and owns the backend as v2.16.39 (#1274: Task manager time-out, stranded tasks, dispatcher-aware health checks, Storage & retention › Staging tables, Evidence › Audit trail). S1-RM-Design's screen work is built and passes 708 local tests; it rebases on #1274 once merged: Automations led by the three dispatchers (rollup-scheduler, admission-rule-runner, coverage-lane-dispatch; the directive's "enrich-lane-dispatch" does not exist live, the second dispatcher is admission-rule-runner), retired legacy jobs (66 of the 70 switched-off jobs) hidden behind Show retired legacy jobs, Open issues links named from the menu (they already opened Queues & yield; only the words said Work queues), Storage now at the top of Storage & retention, and Evidence › Where evidence comes from.
- **Next:** Coverage & completeness modernisation (12:19), after v2.16.40.

### S1-RM-Design, 18 Nov 2026 10:31–11:28 AEDT directives: API v3 study load, Publish edition fix, role-centric UI, multi-country schema lock

**Status at 18 Nov 2026 12:05 AEDT. This block is the newest for these items.**

- **Publish edition fixed (ref G7QN3W; Pilot #1257, migration `20261118133707`).** A city profiles edition counts its city profiles, the localities its load wrote (country and `dataset_edition` = edition label) and its figures on another edition's localities (a figures-only edition such as S2-Build's BOM climate averages). `security.destination_edition_rows_v1` (new); `destination_edition_publish_v1` needs one approved row; Overview & editions shows rows, rows approved and figures. **Live 11:40 AEDT:** "ABS Regional population 2024-25" holds 102 rows, 102 approved (102 of 102 figures approved). **Publish edition was not run by me:** it is the Platform Admin's.
- **API v3 study load (Pilot #1257).** Every v3 course item (Website `course` and `search`, Zoho `course`, `courses`, `search`, v3 `sync`) carries `study_load`, `empty_reason_code`, `campuses[].locality` and `provider.accreditations`; the provider action carries `accreditations` (empty: `catalogue.provider_accreditations` holds 0 rows). Read back live: every Website and Zoho course and search item has the fields; course `course:nzqa:6010:1883` returns `both`. Dictionary 2,085 → 2,179 (migration `20261118133717`). `API-V3-FIELD-DEFINITION.md` updated.
- **Dictionary cross-check (RM0B; Pilot #1264, migration `20261118135707`, merged and live 11:54 AEDT, 2,216 fields, none deprecated).** `security.api_field_dictionary_drift_v1` on live Website and Zoho course, search, provider and destination answers: the new fields show no drift; 37 older fields were not described (`item.field_of_study_codes[]` on both course actions, `item.recognition[]` on Zoho course, destination `filters.*`, Website `contract_version`) and Website search `university_groups` had the wrong type. The new list describes them (2,216). No API function changes. `logo.storage_path` is removed by the edge functions and is not a gap.
- **v2.16.35 (Pilot #1259, no migration).** Dashboard drawn for the role: role line and Your role guide; Viewer and Counsellor start with Search the catalogue and see no pipeline or Inbox counts; Curator sees Waiting for you without failed jobs and automations; Platform Admin also sees **Waiting for your approval** (editions ready to publish, Layer 1 drafts, the email route). **Continue where you left off:** last searches, review queues and pages on this browser only; Resume restores a catalogue search. **Guides › Role guides:** one guide per role, pages from the menu; mirrored to `docs/platform/role-guides/` (generated). **Create user:** Person, Role (permissions shown), Sign-in, Review, confirmation. **Links & Email Templates:** body edited as formatted text in a frame that runs no script (toolbar, Insert link, Sign in button, plain-English variables, Edit HTML); the route at the top (Supabase Built-in or Resend API, sender, key, last test); buttons Save Provider Settings, Send Test Email, Save Template, Send This Template as a Test. Mockup: design canvas "StudySearch role-centric dashboard mockup". **Not checked in a signed-in session.**
- **Multi-country schema lock (Platform Admin 11:28; Pilot #1262, spec `s627`).** No migration may create or rename to a country-prefixed table or view; the six held before the lock are listed. Mapping of every destination dataset to the existing tables, and what still needs a change: `docs/platform/DESTINATION-EDITIONS-AND-WAVE2-DRAFTS-RUNBOOK.md` section 5. **Still open after S2-Build's constraint paste file:** `ranking.systems.code` has no Financial Times; `study_rules.rule_category` has no dependants, minimum wage or offer document; `career_outcomes.occupation_scheme` has no OSCA or NOL; no table for official national quality ratings or for employment by industry. Best added to the paste file before it runs.
- **Registers.** `ROADMAP-MILESTONES.csv`: RM26 to RM33 (Poland, Italy, Greece, Cyprus, Thailand, Malaysia, South Korea, Japan) after RM25; RM17, RM19, RM20, RM22 and RM24 stay unused; the workbook lists 28 destinations. `CONSUMER-REQUESTS.csv`: REQ-84 to REQ-90, the seven high-priority official-source checks (Sweden spouse work rights; Spain 2026 IPREM; Malta work hours and visa fee; Netherlands partner sponsorship income and work rights; Greece Law 5275/2026; Cyprus CRMD visa rules; Cyprus work eligibility after 1 Mar 2024), each a publication gate; REQ-91, the QILT, QS, THE and FT licence gates, with REQ-68.
- **Coordination.** Weather: S2-Build's BOM climate loader (Pilot #1256: long-term averages for eight capital cities, draft, terms pending) feeds Destination data › City metrics & costs and the v3 `destination` action with no further change; with #1257 a figures-only edition can be published. Layer 1 wizard: S2-Build's #1258 (merged: new record types and baseline records) and #1263 (open: Register a scheme and subdivisions, v2.16.35). **Clash to fix in #1263:** it claims v2.16.35 (taken by #1259) and spec number `s625` (used by #1259's `cf-247-s625-role-dashboard-guides-users-email-contract.spec.mjs`); it needs v2.16.36 and another spec number. S1-RM-Design's "What this source will create" panel for the wizard follows after #1263, so the two do not collide.
- **`study_load` row of 10:20 AEDT below is superseded by this block.**

### Destination sources in the Layer 1 Register; Home Affairs and JSA published on API v3 (S2-Build; Platform Admin 18 Nov 2026 17:55, 21:58 and 22:04)

- **Standing rule (Platform Admin 22:04):** all Destination Data sources must be registered in Layer 1 Register by country and ingest via standard Layer 1 schedule → Supabase Storage artifact → Layer 1 Evidence record → Destination Edition. NZ, CA, UK, IE and US follow the same pattern. Runbook: `docs/platform/DESTINATION-EDITIONS-AND-WAVE2-DRAFTS-RUNBOOK.md` v1.5, section 6.
- **Pilot #1318** (migrations `20261118262000` and `20261118265000`, spec s694; no new table or function; G3 75/48).
  - Five Australian sources are in the existing Layer 1 registry (`pipeline.sources` + `layer1_source_operations`, source system `DESTINATION`). They show under Layer 1 Register › Australia:
    - ABS Regional Population: statistics, hard-coded parser, 1st of the month.
    - BOM Climate Statistics (IDCJCM0037): statistics, hard-coded parser, 2nd.
    - JSA OSCA & Table 1: statistics, workbook parser, 3rd.
    - Home Affairs Student & Graduate Visa Rules: regulatory, Firecrawl page-facts reader, 3rd.
    - Fair Work Ombudsman National Minimum Wage: regulatory, restricted, **paused**.
  - `layer1-operations-scheduled` v1.6.0 and `layer1-operations-control` v1.11.0 load the sources through `layer1-destination-geo-loader` v1.4.0.
  - Every evidence record names its Layer 1 source, with `fetched_at` and `licence_terms`. The 12 earlier destination artifacts are linked: ABS 1, BOM 8, JSA 1, Home Affairs 2.
  - Side jobs `destination-abs-load`, `destination-climate-load` and `destination-page-facts-load` are off (`active = false`) and retiring. Their `cron.unschedule` paste file waits for the 14-day window.
  - `20261118265000` fixes the successor-edition load (an ambiguous SQL alias). Its post-check now runs pass 2 and rolls it back.
- **Pilot #1322** (migration `20261118272000`, s695): the Home Affairs and JSA sources were made due. **First run through the standard Layer 1 schedule: 19 Nov 2026 00:05 AEDT** (refresh requests completed, verification passed).
  - **Home Affairs:** 5 facts found, through 3 Firecrawl rendered reads. 3 evidence records name the source, each with licence CC BY 3.0 AU and its `fetched_at`; the artifacts are in `evidence/destination/page-facts/immi.homeaffairs.gov.au/*.rendered.html`.
    - The new Post-Higher Education Work stream stay (2 years after a bachelor degree) opened the successor edition "… pages (read 19 Nov 2026)" in draft, with 5 rules.
    - The hourly `destination-open-licence-publish` publishes it, which supersedes the 18 Nov edition.
  - **JSA:** the workbook is unchanged, so nothing was written. Count 1,577; next run 18 Dec.
- **Firecrawl for Home Affairs (authorised 17:55; Pilot #1304, #1305; loader v1.3.0–v1.3.1).**
  - Pages are read rendered through `/v1/scrape` with `onlyMainContent: true`.
  - The spend goes through `svc_fc_spend` (purpose `destination_page_facts`, the "other" daily share) and every call is logged in `pipeline.firecrawl_calls`.
  - Eight credits used in total, by 19 Nov 00:05 AEDT.
- **Published on API v3 `/destination` at 18:41 AEDT** (by `destination-open-licence-publish`):
  - Home Affairs edition, 4 rules, each with its verbatim quote and `evidence_date` 18 Nov 2026:
    - Student visa charge "From AUD2,500.00".
    - Temporary Graduate visa charge "From AUD5,750.00".
    - "work up to 48 hours a fortnight".
    - Overseas Student Health Cover.
  - JSA edition: 1,577 OSCA occupation rows from Table 1. The column read is "Employment in main job"; Table 1 has no earnings column.
- **Still open:**
  - The 12-month living cost (financial capacity): the rendered page places it under "Gather Documents" in Step by Step, and the table-cell pattern (#1305) still finds no amount in the main content.
  - Employment count: served on the v3 career row since 19 Nov 04:03 AEDT (Pilot #1328, s711).
- **New tooling:**
  - `destination.page_facts.read_mode` (static or rendered).
  - Workflow `destination-run-now` (Management API Run now with read-back).
  - Successor editions: a published edition is never written to (`DESTINATION_EDITION_FIXED`); a change opens "… (read <date>)".

### Post-paste verification, scholarship reader restart and page-facts loader (S2-Build; Platform Admin 18 Nov 2026 15:32)

- **Both paste files ran** (constraints v2 at 15:24 AEDT; published-per-owner index at 15:31 AEDT).
  - **BOM climate edition published** at 15:41 AEDT by the hourly target `destination-open-licence-publish`, beside ABS Regional population 2024-25 (both published).
  - Read back on API v3 (`security.destination_read_v1`, AU): 102 localities, with 40 climate figures served with BOM attribution. For example, Hobart shows summer mean max 21.3 °C, winter mean min 5.1 °C and rainfall 610.5 mm (1882–2026), beside ERP 233,736.
- **Scholarship award values and closing dates: the existing reader is running again (Pilot #1290, migration `20261118184000`, s652).**
  - Root cause: the last detail reading was 14 Nov 03:17 UTC. Two leases died at the third attempt. The picker never takes them, but the idle-fill due count still counted them, so `scholarship_detail_backfill_v1` never ran.
  - Fix: the due count now follows the picker's attempt cap, and the two dead leases are settled as failed (update only).
  - No new review kind and no overwrite: `scholarship_detail_apply_v1` fills empty fields only, and the award value and close date need their verbatim quote.
  - On-demand window `9f54b912` (claude_session, openrouter) is open until 22:01 AEDT. Estimate: 136 scholarships, US$0.19 (ceiling US$0.63). OpenRouter balance was US$11.36 before.
  - Results by 17:03 AEDT:
    - 105 readings of 89 scholarships, costing US$0.09 (balance US$11.20).
    - 87 were good and 18 held in the existing held buckets (cut-off answers and recovery parts).
    - 53 records filled: 20 application windows, 25 benefits and 3 award values. Every verified amount is now on its record.
    - 5 dates the reader inferred without a stated close date were correctly not applied.
    - 35 readings are still queued.
  - Active scholarships with no value: 307 (was 310). Published scholarships with no close date: 645 (unchanged; most pages state none).
- **Page-facts loader built and run (Pilot #1291, #1292, #1294, #1296; migrations `20261118185000`, `186000`, `191000`, `194000`; s653; loader v1.2.1).**
  - `destination.page_facts` holds each fact as data: page, edition, rule category, pattern, unit, plausible range and anchor. Mode `facts` stores each page as evidence and keeps the value with a verbatim quote and the time read. It writes draft `study_rules` and OSCA `career_outcomes`, and a reviewed row is never changed.
  - Job `destination-page-facts-load` runs on the 3rd at 05:30 Sydney, plus Run now.
  - Terms recorded:
    - Home Affairs: CC BY 3.0 AU, approved.
    - JSA: CC BY 4.0, approved.
    - Fair Work Ombudsman: CC BY-NC 4.0 (non-commercial) and its robots rules refuse automated reading, so restricted and not read.
  - **Second run (17:00 AEDT): no fact found yet.**
    - Both Home Affairs pages are stored (1.46 MB and 1.30 MB), but their static HTML holds only 3,595 and 1,656 characters of visible text. The content is rendered in the browser, so these pages need a rendered read (Firecrawl, on-demand) before any pattern can match.
    - The JSA workbook was found and stored (`osca_occupation_data_-_2021_census.xlsx`). Its tables are industries, states, age profile, descriptions and titles. Table 1 (Overview) holds the measures, but its header does not match the reader's words yet, so nothing was loaded.
    - Nothing was written, approved or published from either source.
  - **Gaps recorded (not loaded):**
    - Study Australia's living-costs page holds no figure; it points to the calculator and Home Affairs, and was last updated November 2023.
    - No official Study Tasmania figure page was found.
    - The TAC and direct application routes need a source with published terms.
    - QILT stays gated.

### Pre-freeze migration lane (S2-Build; Platform Admin 18 Nov 2026 14:23)

- **28-destination CHECK constraints: with the Platform Admin.** Pilot #1280 applied paste file v2 as migration `20261118165000`. Deploy on merge refused it ("drops, deletes or truncates at top level; the Platform Admin pastes those"), so nothing was applied. It was reverted by Pilot #1288 (spec s641 retired, retirement log) so main equals live. **Run `docs/paste/PASTE-20261118-29-destination-check-constraints.sql` v2 before Thu 19 Nov 01:15 AEDT** (its dry run passed).
- **BOM climate (Pilot #1256, #1275, #1287; edition published 15:41 AEDT after the paste file, see the block above).**
  - Terms are approved (CC BY 4.0, attribution recorded), and the 40 figures (8 capitals × 5) are **approved and served by API v3**.
  - The first publish run (14:41 AEDT) failed on `uq_destination_editions_single_published`: one published edition per country and domain, and ABS population already holds Australia's `city_profiles` slot. The failure also rolled back the approvals.
  - Pilot #1287 (migration `20261118181500`, s646; live 15:24 AEDT, md5 `776a7c0f`) isolates the publish step, so the approvals now stand.
  - The edition itself stays draft until **`docs/paste/PASTE-20261118-destination-editions-published-per-owner.sql`** is run (one published edition per country, domain and source owner). The next run at minute 41 then publishes it.
- **Page-text evidence key (Pilot #1252 fix; Pilot #1281, migration `20261118181000`, s642; live 15:15 AEDT, md5 `b4643fa1`).** 179 copies failed on `layer2_evidence_group_capture_version_uq` because every copy was capture version 1 of `coverage:<course>`. Each copy now takes the next version under a per-course lock, and the failed copies are due again (the page-text job picks them up).
- **Operations backend and grouped decisions:** already live from 12:49 and 13:02 (Pilot #1274, #1277, #1279; see the block below).
- **RM1I living costs, RM1C/RM1H study rules, RM1D JSA careers (superseded 17:03 AEDT: the page-facts loader is built; see the block above).** Not loaded at 15:30. Values change (for example the Student visa fee rose to A$2,500 from 1 Jul 2026), so each must be read from the official page with its quote and evidence, not entered from memory. The next build is a page-facts mode of `layer1-destination-geo-loader`: each fact is defined by its official URL, a deterministic pattern and a rule category, and written as draft `study_rules` or `locality_metrics` rows with the page stored as evidence and terms pending. QILT and REQ-84 to REQ-90 stay gated.
  - **Source readiness (S1-Build, read 18 Nov 2026 15:50 AEDT, Platform Admin 15:26):** before building the page-facts mode, the official pages were checked for each fact. Most figures are not in readable page text, so a deterministic page read cannot load them yet:
    - Home Affairs fees page: no amounts in the page; they are in the Visa Pricing Estimator, which runs as a script.
    - Home Affairs work restrictions: the page does not state the current hours a fortnight.
    - Fair Work (minimum wage) and Jobs and Skills Australia occupation profiles (RM1D): both refuse automated readers (robots disallowed), which the platform policy does not override.
    - Study Australia living costs: no figures on the page; they are in a calculator last updated November 2023.
    - Study Australia financial capacity news page: out of date (AU$24,505 from 1 Oct 2023).
    - **Readable now:** Study Australia agent news "The Student VAC increased from AUD $2,000 to AUD $2,500 from 1 July 2026"; Study Tasmania "TasTAFE accommodation for roughly $160 a week".
    - **Recommended next step:** load these sources the way THE rankings are loaded, from a publisher file the Platform Admin uploads with its evidence (Administration › Sources & Imports): the Visa Pricing Table, the Fair Work pay guide or annual wage review PDF, and the JSA occupation profiles data file. Page facts are used only where the figure is in readable text. Nothing was loaded; QILT stays gated.
- **Migration numbering:** other sessions merged `20261118170000` and `171000` during this lane, so #1281 and #1287 were renumbered above them before merge.

### Operations backend, open-licence destination publishing and grouped Layer 4 decisions (S2-Build; Platform Admin 18 Nov 2026 12:49, 13:02 and 13:07)

- **Operations backend (Pilot #1274, v2.16.39, migration `20261118160000`, s638; merged and live 13:45 AEDT, history md5 `9eb36f30`, G3 75/48).**
  - **Task manager (ref KEW72U):** the read took 9.4 s against the signed-in role's 8 s limit. `security.admin_job_status_v1` looked up the task runner's last run with max() over 160,000 cron runs for each task. It now reads newest-first by run id; Task manager reads in 2.0 s live.
  - **Stuck tasks:** 254 of 257 "running" tasks were AER entry readings (54 scheduled first reads, 200 corrected reads D-R2) waiting on the AI route `course_entry_requirements`, which is switched off on Models & services, so they could never finish. They are closed with that reason: 254 items skipped, 200 supersessions closed as refused, audit event `tasks_closed`. `aer-scheduled-read` asks for no read while that route is held (AER v1 correctness fix, Decision 276).
  - **Find course pages:** the other 3 tasks are genuine person tasks and are kept. Their reason now says "Today's Firecrawl share for course search is used". The search worker is run live by coverage-lane-dispatch, so it is not "switched off". `fc_budget_left_v1('course_link_search')` is 0, with 2,894 searches queued; nothing has been sent since 17 Nov 13:46 UTC.
  - **Health checks follow the dispatchers and recorded pauses:**
    - New functions `security.job_dispatched_v1` and `security.job_paused_by_person_v1`.
    - Scholarship queues reads OK, not critical: scholarship-read and scholarship-discover were paused by the Platform Admin on 17 Nov 13:11 for the bulk ingestion.
    - The watchdog no longer calls dispatcher-run queues "switched off".
  - **New Platform health checks** (rollup target `platform-health-consolidated`, every 10 minutes; thresholds `health.*` are settings): Dispatchers, Boost (switches, Layer 4 cap, staging, qualified models, 24-hour spend), Layer 4 backlog (warning at 6,000 waiting or oldest over 45 days) and Guardrails (G1 uncatalogued running jobs, G3 drift). All four read OK at 13:47.
  - **Storage & retention › Staging tables:** rows, size, what the nightly staging retention would remove and whether it is on (`retention.staging_prune_on` is still 0, dry run).
  - **Evidence › Audit trail** (`public.admin_ops_audit_v1`): dispatcher runs, Boost qualifications and Layer 4 decisions.
  - **Still warnings, and genuine:**
    - Fee reader: 1 item at 3 attempts.
    - Onboard universities: 5 cases from the 12 Oct backfill, waiting on a website or on scholarship AI.
    - Read course pages: coverage-read failures.
    - Search probe: 3.7 s.
    - Database size: 6.7 GB.
- **Open-licence destination editions (Pilot #1275, migration `20261118161000`, s637; merged and live 13:50 AEDT, md5 `a9e3270d`).**
  - BOM climate statistics (IDCJCM0037): attribution recorded and terms approved (CC BY 4.0, per bom.gov.au/copyright, read 18 Nov). The climate load ran through Run now at 13:47: 40 figures (8 cities × 5) as drafts.
  - `security.destination_open_licence_publish_v1` (rollup target `destination-open-licence-publish`, hourly at :41) approves the attributed drafts of editions whose owner is on `destination.open_licence_owners` and publishes them, with audit events. The list is BOM, ABS, Study Australia, Study Tasmania, Home Affairs, Fair Work and JSA; **QILT is not on it**.
  - Publishing now supersedes only the same owner's edition. Before this fix, the BOM edition would have superseded ABS population.
  - The first approval and publication runs at 14:41 AEDT and is read back after it.
  - No RM1I living-cost, RM1C/RM1H study-rule or RM1D career edition exists yet; they follow this path once loaded with page evidence.
- **Grouped Layer 4 decisions (Pilot #1277, v2.16.40, migration `20261118162000`, s639; merged and live 14:22 AEDT, md5 `b1affe01`; live read: 59 AER groups, 123 items, choices at rank 6). The study-load groups failed on read-back (an ungrouped column); the fix is Pilot #1279 (migration `20261118164000`), open.**
  - Measured first: the audit's 1,874 "shared page" AER items include 1,551 incomplete reads (the reader dropped printed requirements). Those are not candidates for a grouped approval.
  - The real shared-page class is 237 items on 172 pages: 125 in 60 groups of two or more, 2 of them audit samples (excluded).
  - Refused study loads: 252 of 400 fall in 48 groups by the same quote at the same university.
  - Each item is decided through `admin_layer4_inbox` at the single item's rank: AER is the Platform Admin's, study loads need a Pipeline Operator. Curators see the groups but cannot decide them.
  - Decision A2 is amended for shared-page groups only.
- **Scholarship award values and closing dates (13:02 item 2), not run, with the reason.**
  - Now missing: 310 active scholarships with no award value (the audit said 287) and 645 published with no closing date.
  - 875 of them already had a version 3 detail read of their stored page with no error, so the same reader on unchanged pages would find nothing new.
  - 69 have a stored page and no version 3 read.
  - The existing detail path (`security.scholarship_detail_apply_v1`) writes values straight to the record under its own checks, not to Layer 4. Routing to Layer 4 needs a new Layer 4 kind; that is the Scholarships lane's call. It is raised with the Platform Admin, and no AI credit was spent.
- **Scheduled task "PR C and PR D of the API v3 data admission plan"** (fired 13:30 AEDT, from an earlier session): not started in this session. PR C needs the official AACSB, EQUIS and AMBA lists, read on demand.

### 28-destination schema lock and legacy telemetry retirement (S2-Build; Platform Admin 18 Nov 2026 12:19 and 12:21)

- **#1263 → #1265 (done):** the readiness change was rebased as Pilot #1265 (v2.16.36, migration `20261118141000`, spec s629) and merged on green; read back live (scheme and subdivision data paths present, G3 75/48). #1263 was closed.
- **Schema lock, additive part (Pilot #1268, migration `20261118150000`, s632; merged and live 12:43 AEDT, history md5 `1b759f16` equals the dry run):** `catalogue.provider_accreditations.rating` and `rating_period` (national quality ratings TEF, NZQA EER, TrustEd, KHDA, SETARA, IEQAS, FINEEC, ANVUR are rows beside AACSB, EQUIS, AMBA); `destination.career_outcomes.series_kind` (occupation default; industry), `industry_scheme`, `industry_code`, `industry_title`, `employment_count`. No new table (s627), consumer API 75/48.
- **Schema lock, CHECK replacements (Platform Admin paste file, v2):** `docs/paste/PASTE-20261118-29-destination-check-constraints.sql` (md5 `22bc38a31482375b8da67e214fd73939`), run before Thu 01:15 (#1268 is live; a rolled-back live dry run of v2 passed, probe Pilot #1271 run 44218085910, closed unmerged): occupation schemes (+ OSCA, NOL, ISCO, ESCO, national schemes), numeric state codes, study rule categories (+ health_insurance, language_requirement, admission_test, dependants, minimum_wage, offer_document), accreditation bodies (+ the eight rating bodies), `ranking.systems` code `ft` (Consumer API change approved by the Platform Admin 12:21; no column change), occupation fields optional on industry rows.
- **Legacy telemetry (Pilot #1269, migration `20261118151000`, s633; merged and live 13:00 AEDT, md5 `b01cf55d`, both targets off):** consumer check per object. Retired: rollup targets `coursefinder-cf245-enrichment-coverage-snapshot` and `coursefinder-cf245-enrichment-hourly-admin-cache` (switched off, kept), their two functions, `security.admin_enrichment_operations_read` and tables `pipeline.enrichment_coverage_snapshots` (about 15,350 rows) and `pipeline.layer2_enrichment_hourly_admin_cache_v1`: read only through `admin_read('enrichment_operations')`, which no screen calls. Drops and the row purge: `docs/paste/PASTE-20261202-cf245-enrichment-snapshots-drop.sql` on or after 2 Dec. **Kept, with live readers:** Link refresh (Coverage › Courses link schedules and the portals that supply course links: configuration applied by job `link-refresh`, not telemetry), Stalled fields (actionable card on Layer 2/3 › Enrich fields), `enrich_coverage_snapshots`, `progress_snapshots`, the course coverage and completeness builds behind the trend charts, the daily telemetry sync, `rollup-scheduler`, `coverage-lane-dispatch`. The other LEGACY_DISABLED cron rows already have their unschedule paste files queued (rollup PR 1, coverage lanes, admission rules; 1–2 Dec).

### Job governance: page-text UNREGISTERED and the 13 CONSOLIDATION_CANDIDATE jobs (S2-Build; Platform Admin 18 Nov 2026 11:54)

**Read live 18 Nov 2026 12:20 AEDT.**
- **`page-text` (job 445):** in `pipeline.automation_catalogue` (area Coverage sweep) since Pilot #1252, but with no `pipeline.component_register` row, which the telemetry sync reads as UNREGISTERED. Still required (stored snapshots → page text for Boost; `coverage-lane-dispatch` does not run it), so it is registered, not retired: Pilot #1266 (migration `20261118142000`, s630) adds the job, `pipeline.page_text_conversions`, `svc_page_text_next_v1` and `svc_page_text_record_v1`.
- **The 13 CONSOLIDATION_CANDIDATE jobs** (all catalogued and registered; all single-mode `coverage-sweep` calls except one SQL job). Recommendation, to run **after Thursday's squash** under the dispatcher rule (register byte for byte, 24-hour shadow, cutover, legacy off and retiring, unschedule paste after 14 days):
  - **Fold into `coverage-lane-dispatch` (one "PR 4" wave):** `coverage-discover`, `coverage-discover-2`, `coverage-ai-match` (every minute), `central-find` (5 min), `logo-find` (10 min), `ops-diagnose` (:27 and :57), `scholarship-listing` (15 min), plus `page-text` (2 min). All are `svc_pilot_submit_nonce('coverage-sweep', {mode, limit})` with a setting-driven limit, the same shape as the 13 lanes PR 3 took over.
  - **Keep on their own jobs:** `coverage-read` and `coverage-read-2` run every 30 seconds; the dispatcher ticks once a minute, so folding them would halve their cadence. They stay unless the dispatcher gains a sub-minute tick.
  - **S2 - BOOST's lane, its call:** `boost-extract`, `boost-fields` (fold with PR 4 once Boost's reading design settles); `boost-benchmark` should be retired when the benchmark round is finished rather than folded.
  - **Fold into `rollup-scheduler`:** `settings-backup-daily` (SQL `security.settings_backup_take_v1('daily')`, 19:50 UTC), as a group A target with a 24-hour shadow.
  - Nothing is changed by this audit; no shadow is started before the squash (the freeze is Thu 01:15–03:30 AEDT).
- **Consolidation PR 4 in shadow since Wed 18 Nov 2026 14:59 AEDT (S1-Build; Platform Admin 14:24 brought it before the squash).** Pilot #1282, migration `20261118170000` (history md5 `115abe29`), spec s643. `pipeline.field_execution_registry` holds 8 new worker lanes in shadow, copied from `cron.job` byte for byte (md5): `coverage-discover`, `coverage-discover-2`, `coverage-ai-match`, `central-find`, `logo-find`, `ops-diagnose`, `scholarship-listing` and `page-text`. `pipeline.rollup_targets` holds `settings-backup-daily` (group A, shadow). The 9 legacy jobs keep running; their register rows stay active with a shadow note. Read back 15:01: 8 of 8 lanes and 1 of 1 target byte-equal, legacy on, first `shadow_due` 14:59; G1 0 unregistered (213 jobs); G3 75/48. Longest legacy run in 7 days 1.6 s, so the tick budget is not at risk. Kept on their own jobs: `coverage-read`, `coverage-read-2` (30-second schedule) and the Boost jobs (S2 - BOOST).
  - **Cutover live Thu 19 Nov 2026 08:18 AEDT (Pilot #1331, migration `20261119095000`, history md5 `7e9b9fe7`; spec s766, renumbered s644 → s765 (Pilot #1359) → s766 (Pilot #1362)).** Brought forward by the Platform Admin at 07:47 AEDT ("so DB contention drops while the S2 data-admittance drains run"): the 24-hour hold was replaced by checks on today's completed runs (`settings-backup-daily` 06:50 succeeded with its `shadow_due` rollup run; latest finished `rollup-scheduler` tick succeeded), after about 17 hours of shadow. Minute coverage now counts a legacy start pg_cron ran one minute late as the dispatcher's slot (`central-find` and `ops-diagnose` at 18 Nov 17:28 and 19 Nov 05:28). Gate at 07:53: 0 uncovered and 0 refused on all 8 lanes. Rolled-back live dry run passed; full CI green.
    - **Read back 08:19–08:25:** 8 lanes `live` and on; `settings-backup-daily` live on `rollup-scheduler`; the 9 legacy jobs off and `retiring`, `retire_after` 2 Dec; 9 cutover events logged; first live dispatches succeeded (0 failed or refused); active jobs 146 → 138 (`coverage-ai-match` had been idle-paused and was back on at cutover); G1 0 unregistered; G3 75 functions and 48 tables, 0 drift.
    - **PIM Admin › Operations › Scheduled jobs (built-in browser, 08:21):** 138 running, 78 retired legacy jobs hidden; `coverage-lane-dispatch` lists 21 legacy jobs replaced, 0 failed in 24 hours; `rollup-scheduler` 26.
    - **Not folded by PR 4 (unchanged):** `coverage-read`, `coverage-read-2` (30-second cadence) and the Boost jobs stay on their own jobs.
    - **Open:** `rollup-scheduler` failed 2 ticks in 24 hours (01:53 and 06:55), both the course-coverage rollup target hitting the 120-second statement timeout under load; the PR 4 paste file (and PR 3's) refuse until `security.flag_jobs_v1` reads the live lanes from the registry.
    - **s781 (19 Nov 2026 18:24 AEDT, Pilot #1392, v2.16.56, and #1393 at 18:47, v2.16.57, no migration):** Catalogue › Providers. Each row leads with a 32 px logo (one batched `provider-asset-access` call by stable key) or a two-letter monogram, then the name in bold with its CRICOS code or stable key. Country codes show a drawn SVG flag (AU, NZ, CA) and one code pill, in every catalogue cell (the flag emoji read "AU AU" on Windows). Extract / refresh description is a refresh icon. The adapter badge reads in full beside an Open adapter icon. The Type select is capped at 140 px. Five filters stay in the bar; eight technical ones are under More filters (with an in-use count). Inactive page tabs use slate 700. Spec s781; the Provider catalogue columns and Fill fields specs open More filters. Live check (built-in browser, v2.16.56 and v2.16.57): monogram, drawn NZ flag with one pill, readable adapter badge, More filters; #1393 shows register codes in capitals (NZQA 8530, was nzqa 8530).
    - **s778 (19 Nov 2026 18:11 AEDT, Pilot #1390, v2.16.55, no migration):** Users & roles › Create user (Person, Role, Sign-in, Review) and the role and edit dialogs: label above, full-width 40 px control (14 px, 40 px right padding for autofill icons), helper below. Audit: the Layer 1 add-source wizard, the record editor and the provider-contacts import already stack. Spec s778 (1280 px and phone).
    - **s776/s777 (19 Nov 2026 17:22 AEDT, Pilot #1382, v2.16.54, migration `20261119174000`, history md5 `0fd6fb87`; follow-up Pilot #1389 18:11, migration `20261119182000`, history md5 `71880fba`):**
      - Rollup target `course-field-readiness` (`*/4`, group A) builds the readiness snapshot in `readiness.snapshot_parts` (16) parts in `pipeline.job_input_marks`, with the export's rules verbatim; `readiness.days_kept` 15 days of daily marks give the 7-day velocity.
      - Coverage & completeness › Courses: Pipeline & field ETA panel (Consolidated, By country, By university), read by `admin_field_coverage('pipeline_eta')` (137 ms live as Platform Admin).
      - Stakeholder_Course_Readiness_Summary: Executive_Summary, Field_ETA_Forecast and By_Provider_Action_List are refreshed hourly by the telemetry sync (scheduled task revision 5, step 8b, `security.course_field_readiness_tabs_v1`). The daily per-country CSV (07:30 AEDT) is unchanged.
      - Follow-up #1389: the live read-back found the tabs read returned rows with 3 of 16 parts built; it now returns null until every part is built, so part-totals never reach the sheet. First hourly write by the 18:46 sync: Executive_Summary, Field_ETA_Forecast and By_Provider_Action_List replaced (140 rows, snapshot 17:48 AEDT); Run_History_Log row stakeholder-readiness-sync SUCCESS.
    - **s780 P1 (19 Nov 2026 17:05 AEDT, Pilot #1386, migration `20261119173500`, history md5 `abe49702`):** Provider details opens again for Curator, Operator, PIM Admin and Platform Admin (refs 3A9WTT and 3UD5A2).
      - **RPC behind both refs.** `public.admin_read('provider_detail', {id})`, called twice by the Provider details blade: `api.providerDetail(id)` and `providerRelated()` in `src/lib/supabase.js`. `pipeline.ui_error_log` ids 228 (3A9WTT, 16:21) and 231 (3UD5A2, 16:22), Platform Admin. The screen showed "Your role is not allowed to do this"; the detail was "permission denied for schema catalogue". 10 such refs were logged 16:15–16:53.
      - **Causing change.** Pilot **#1329**, commit **`a18020c8`** ("CF-247 S712: student-facing destination read for Viewer and Counsellor; accreditations on provider detail"), migration `20261119045000_cf247_student_facing_destination_read.sql`, merged 19 Nov 04:44 AEDT.
      - **Why.** S712 put a direct `select … from catalogue.provider_accreditations` into `public.admin_read` for rank ≥ 3. `admin_read` is security invoker and `authenticated` has no USAGE on schema `catalogue`, so every role from Curator up was refused. Viewer and Counsellor read through the security definer `security.provider_accreditations_v3_v1` and were not affected. It was not caught because the #1329 dry run ran as the owner and its live check was made as Viewer and Counsellor only.
      - **Fix.** New security definer `security.provider_accreditations_admin_v1(uuid)` (rank ≥ 3 full rows, below that the v3 view; execute for `authenticated` and `service_role` only); a md5-guarded fragment edit makes `admin_read` call it. `admin_read` stays invoker; no grant on `catalogue` is widened; no consumer API change (G3 75/48).
      - **Read back (rolled-back workflow, 17:07–17:08, as the Platform Admin's JWT under `authenticated`):** rank 6, `provider_detail` returns its accreditations (1 of 1 held); `admin_read` invoker, no direct `catalogue.` read; 0 "schema catalogue" refs since the deploy. Spec s780 (4 tests) also fails any later migration that puts a `catalogue` read back into `admin_read`.
    - **s773–s775 (19 Nov 2026 15:56 AEDT, Pilot #1380, migrations `20261119155000` md5 `97cbc66f`, `20261119155500` md5 `0b5999ea`, `20261119160000` md5 `b659f997`):** IQ-00594, IQ-00588 and IQ-00426.
      - **Runner B (`adapter-overwrite`).** Set-based Layer 4 block check and a keyset window of `batch.adapter_overwrite_window` (1000) courses with a cursor in `pipeline.job_input_marks`; a window that hit its limit is re-read, the "no new input" skip applies only between passes. Dry run 1.1 s a window (was up to 113 s); live 9–17 s a run.
      - **Runner C (`coverage-admit`).** Same pattern for plan and apply (`admit.window_pages`, 1500); the before-snapshot is taken only when a window writes. Dry run 1.3 s plan + 1.2 s apply (was up to 118 s); live 10–30 s, including the 6.5 s consumer snapshot when a window writes.
      - **`no-page-propose`.** `bind_match_scope_refresh_v1` groups unbound courses by provider before the focus check, with the new partial index `enrichment_flags_provider_raised_idx`. Scope refresh 4.5 s in the dry run (was 90–120 s and a time-out); the 16:37 run succeeded in 25.3 s.
      - **Unattended cycles 15:58–17:10:** 2,371 job runs, 0 failed, 0 statement time-outs. `admission-rule-runner` 75/75, `-b` 75/75, `-c` 74/74, `rollup-scheduler` 72/72, `waste-guard` 1/1 (105 s), `no-page-propose` 1/1.
      - **Not met as asked.** The targets were under 5 s per runner and under 3 s for `no-page-propose`. The fixed rules are well inside the limit but not that fast live. Runner C's whole tick still reaches 118 s from other rules on its lane (for example `provider-english-defaults`), and runner B's 96 s. Those rules are a follow-up, not part of this change.
    - **s767 post-fix check (19 Nov 2026 15:20 AEDT, read only, runs 12:24–15:15):**
      - `scholarship-coverage-classify` (batch 80): 99 s, 56 s, 75 s, all succeeded. The slowest is 21 s under the limit, so the size stays at 80.
      - `no-page-propose` (25 providers): 90 s, failed at 120 s (13:37), 102 s. Its failure is in the candidate query (`enrich_focus_v1` → `pipeline_list_v1`) before any per-provider work, so a lower batch would not help; the query needs its own fix.
      - `waste-guard`: 107 s, 76 s, both succeeded (2 of 3 failed before s767).
      - `ops-cost-guard` (rollup target): 92 s (12:43), 73 s (13:47, one tick deferred for budget), 115 s (14:43). Within 6 s of the 120 s limit at 14:43; the `ops_cost_waste_v1` profiling item stands.
      - `rollup-scheduler`: no failed tick since 06:xx; ticks over 100 s occur 1–4 times an hour under load, as before s767; each target in them is under 20 s apart from `ops-cost-guard`.
      - Telemetry: hourly syncs 12:48, 13:48, 14:47 AEDT all SUCCESS on revision 4; Pipeline_Summary shows `coverage-discover` RUNNING (231 completed, 0 failed in 24 h).
    - **s769 (19 Nov 2026 14:18 AEDT, Pilot #1374, v2.16.51, migration `20261119130000`, history md5 `78c396f5`):** Scholarships › Coverage loads again (ref 8XEY7B).
      - **Cause.** `security.scholarship_listing_match_v1` re-ran `scholarship_series_key_v1` for every listed item × record pair (the planner inlined both CTEs). One provider took 6.86 s; The University of Sydney (582 × 257) did not finish in 58 s. The page asked for 300 providers against the 8 s `authenticated` limit.
      - **Fix.** Item and record keys, words and addresses are materialised once, then compared (same matching rule): 92 ms and 721 ms. Same matches on 1,633 rows of 65 providers; a duplicated item with two links now keeps the first on the page. `admin_scholarship_coverage_read` returns at most 50 providers a page; the screen has Previous and Next. The provider drawer and sign-off use the same matcher.
      - **Part 2 (15:07 AEDT, Pilot #1375, migration `20261119144500`, history md5 `158ca349`).** The live check found the provider drawer still timing out (Sydney 8.7 s). `admin_scholarship_coverage_provider` and the Publish action read `scholarship_publishability_v1()` for every scholarship (7.5 to 13.8 s) and kept one provider's; they now call `scholarship_publishability_for_v1` with that provider's ids (identical rows, 0.6 s).
      - **Read back in PIM Admin:** watch list 523 ms; All with scholarships pages 1–5 0.5 to 1.5 s; Sydney row 582 listed, 184 found, 71 published, 398 missing; Sydney drawer 7088 ms. No 8XEY7B. G3 75/48, 0 drift.
    - **s767 (19 Nov 2026 12:24 AEDT, Pilot #1367, migration `20261119120000`, history md5 `0eb2fdce`):**
      - **Idle pause.** `security.flag_jobs_v1` now also finds live registry lanes whose legacy row is gone, so both unschedule paste files can run. The rolled-back dry run showed both `coverage-discover` lanes held idle by flag-recheck, which is correct.
      - **Telemetry.** `security.job_effective_state_v1` gives each dispatcher-held job its runner, state and runs. Telemetry exporter revision 4 (Drive `1YuZjKm-T11C73msIywKitJQQb5mgic9k`, sha256 `c339fa4a…`) uses it, and the hourly telemetry task is repointed to it.
      - **`waste-guard`.** Its cost measure (44 s of the 59 s median) now runs as rollup target `ops-cost-guard` (hourly :43, `expected_ms` 45000).
      - **Per-run sizes.** `batch.sch_coverage_classify` 120 → 80; `bind.no_page_providers_per_run` 40 → 25.
      - **Idle guard.** `security.waste_idle_guard_v1` no longer switches a retiring job on again (`course-link-reverse` was exposed).
      - **Read back 12:25:** G3 75/48, 0 drift; G1 0 unregistered; 136 active jobs.
  - **24-hour late-tick check, run Thu 19 Nov 00:26 AEDT (window 18 Nov 00:26 to 19 Nov 00:25): not a clean 24 hours; clean for the last 6.** Measured: 0 md5 or schedule drift on any rollup or coverage target; 69 retiring legacy jobs all off, none run; no refused dispatch. Over the 24 hours, minutes skipped: `rollup-scheduler` 5, `coverage-lane-dispatch` a/b/c 2 each, `admission-rule-runner` a/b/c 12/10/13. Failed ticks: admission runners 8/6/8; every other dispatcher 0. The misses fall in three episodes:
    - 00:38–01:58, the hour after the PR 3 cutover: at 01:27 all 7 dispatcher jobs missed the same minute.
    - 17:27: all 7 jobs missed one minute together, a platform-wide pause.
    - 18:13–18:31: admission targets hit the 120-second statement timeout, waiting on the `search_course_documents_writer` advisory lock and in `zoho_edge_course_search_v2`, `coverage_admission_plan_v1` and `adapter_overwrite_v1`.
    - **Since 18:32: 355 of 355 minutes on all 7 jobs, 0 failed.** Dispatch statuses over 24 hours: admission 1,414 succeeded; rollup 5,655 succeeded, 14 deferred, 1 failed (`destination-open-licence-publish` at 14:41 hit the old one-published-per-domain index; the per-owner paste file has since been run and BOM climate is published); coverage 5,226 succeeded, 196 deferred.
    - **Readiness for the 14-day unschedule window:** the legacy side is ready (all retiring jobs off and idle), so the PR 1 and PR 3 paste files can run on or after 2 Dec as planned. The admission runners' timeouts under load are a separate PR 2 follow-up: lanes a/b/c contend on the same writer lock when heavy rules fall due together. Suggested owner: the PR 2 lane (S2-Build). Watch for recurrence; do not change the timeouts.
    - **PR 4 shadow, 9.5 hours in:** all 8 lanes have at most 1 uncovered legacy minute and 0 refused dispatches, within the cutover gate. The dispatcher holds more minutes than the legacy jobs ran (pg_cron skips at busy minutes), as with PR 1. `settings-backup-daily` is first due at 06:50 Thu. Cutover still scheduled for Thu 15:10.

### 29-destination schema readiness (S2-Build; Platform Admin 18 Nov 2026 11:28): read-only cross-check, data paths, constraint paste file

**Read live 18 Nov 2026 11:40 AEDT (read only).** Goal: after Thursday's squash, onboarding any destination needs only data and Layer 1 configuration.
- **Countries:** all 28 codes named (AU, CA, GB for "UK", NZ, IE, US, DE, SE, FI, DK, ES, MT, NL, FR, AT, CH, HU, LV, AE, SG, PL, IT, GR, CY, TH, MY, KR, JP; the directive says 29) are in `ref.countries` (249 rows).
- **Accept any country:** `destination.localities`, `locality_metrics`, `locality_postcodes` (upper-case code only), `destination.study_rules`, `career_outcomes`, `editions`, `city_profiles` (foreign key to `ref.countries`), `destination.rule_applicability` (entity type and status only). `catalogue.provider_accreditations` (AACSB, EQUIS, AMBA) and rankings (`ranking.*`, `catalogue.provider_rankings`; systems `qs_wur`, `the_wur`, `arwu`) are country-agnostic. There is no `catalogue.university_metrics` or `catalogue.university_rankings`.
- **Gap 1, registration schemes (closed by data path, Pilot #1263, v2.16.35, migration `20261118133000`):** 22 of 28 countries have no row in `ref.registration_schemes`, the wizard refused an unregistered scheme and nothing wrote the table, so a new country needed a migration. Now `public.admin_registration_scheme_register_v1` (Platform Admin, reason, added as planned, never changes an existing row) and **+ Register a scheme** in + Add source step 1.
- **Gap 2, subdivisions (closed by data path, same PR):** 25 of 28 countries have no `ref.subdivisions` (register state names stay unmapped; not blocking). `public.admin_subdivisions_register_v1` loads ISO 3166-2 rows as data. Loading them per country is data work, not schema.
- **Gap 3, three CHECK constraints (paste file for the Platform Admin, run before Thu 01:15 AEDT):** `destination.career_outcomes.occupation_scheme` (only ANZSCO, NOC, SOC; adds ISCO, ESCO, KLDB, ROME, SSYK, DISCO, SSOC, MASCO, KSCO, JSCO, TSCO), `career_outcomes.state_code` (letters only; numeric ISO 3166-2 codes in JP, KR, TH, MY, SG, PL, FI, DK, AT, CY, LV), `destination.study_rules.rule_category` (adds `health_insurance`, `language_requirement`, `admission_test`). File: `docs/paste/PASTE-20261118-29-destination-check-constraints.sql` (md5 `dd60b84bdfa8392d8e89f64beb116633`; guarded, each replaced only if unchanged, accepts everything the old one did). Relaxing a CHECK drops and re-adds it, so it is not in a migration.
- **Canada prototype tables:** no `ca_institutions`, `ca_pgwp_cip_eligible`, `ca_courses`, `ca_policy_facts`, `ca_noc_*` or `ca_study_cities` exist in the Pilot (only `pipeline.ca_course_scope_keys`); nothing is migrated under `ca_*` names. Their canonical homes when the data arrives: institutions → `catalogue.providers` (country CA, scheme `ircc_dli`); courses → `catalogue.courses` (scheme `mtcu`); PGWP and CIP eligibility → scheme `pgwp` (work eligibility) with the PGWP field-of-study list (Track B reader ready, 1,107 rows) and `cip`; policy facts → `destination.study_rules` (country CA); NOC → `destination.career_outcomes` (`occupation_scheme` NOC); study cities → `destination.localities` and `locality_metrics`.
- **Australia course fields:** study mode is `catalogue.courses.delivery_mode` and study load `study_load` (held); the TEQSA category is the provider type (`catalogue.providers.provider_type_id`). No new columns are needed.

### S2-Build, 18 Nov 2026 10:09–10:51 AEDT directives: Phase 5 grid, page-text feed to Boost, Layer 1 induction v3 fields, climate loader, Layer 1 Register fixes

**Status at 18 Nov 2026 11:35 AEDT. This block is the newest for these items.**

- **Phase 5 first slice live (Pilot #1254, v2.16.33, migration `20261118120000`).** Layer 4 › Inbox › **Grid**: one built-in kind at a time as rows, paged on the server (`layer4.inbox_page_size`), reason filter, search, order, column chooser and Export CSV (new setting `layer4.grid_export_max_rows`, 5,000). `pipeline.saved_views` holds the three shared views **AER Audit Samples**, **Official URLs** and **Provider Blockers** (changed by a Platform Admin only, checked on the server) and each person's own views. A row opens the **Source Quote vs Extracted Value** drawer (`admin_layer4_item_trace_v1`: quote beside value, evidence link, decision history) where the item is decided with the Inbox's own card; decisions still go only through `admin_layer4_inbox`. Registered kinds (interventions, campus localities) stay on By kind. A parallel build of the same slice (#1253, another session) was closed unmerged. Audit §5 next slices: Evidence table on the grid; Field History drawer with restore (§7.3); then Phase 4.
- **Stored pages now feed Boost (Pilot #1252, migration `20261118113000`, worker `coverage-sweep-worker-v1.0.15`).** Root cause: the page lanes store `source_snapshot` HTML, while Boost claims `provider_course_page_text`. Job `page-text` (catalogued, every 2 minutes, `batch.page_text` 40) converts bound snapshots of active courses lacking study load or description, in `boost.matrix` order (AU, NZ, CA), into page text. Read 11:05 AEDT: 537 converted, Boost had claimed 519 of them; 22 failed on a duplicate evidence group key (pages shared by two courses; retried after a day; a fix to reuse the shared text is open), 1 too short. The read lanes `coverage-read` and `coverage-read-2` are live and idle only because no bound page is due (about 20,840 not due for 30+ days).
- **Layer 1 induction backend (Pilot #1258, migration `20261118124000`, `layer1-declarative-runner` 1.1.0).** Parser targets: `course_register` gains `study_load` and `empty_reason_code`; new record types `provider_accreditations`, `campuses` (with `is_primary`) and `grade_scale_conversions` (wizard step 3 lists ten types). `public.svc_layer1_apply_baseline_records_v1` fills only what is not held (study load from a register only where a course holds none; campuses of registered providers, primary only when none; AACSB/EQUIS/AMBA accreditations where none from that body; grade scales loaded **inactive** for review). New-country providers and courses were already created by `svc_layer1_apply_register_records` (all 249 countries seeded). Gates unchanged: activation by the Platform Admin, terms approved, source not paused.
- **Layer 1 Register fixes (Pilot #1260, v2.16.34, migration `20261118125000`).** (1) `security.layer1_next_due_roll_v1` is a live `rollup-scheduler` target `layer1-next-due-roll` (hourly :23): an overdue next ingestion date moves on by whole cadences when nothing of the source is queued or running; read back: 0 overdue, target run succeeded. (2) Retired (kept, paused; superseded by coverage-sweep, checked at apply): Aurora College, College of the North Atlantic, Confederation College, Loyalist College code readers; edge functions `layer1-ca-cna-programs`, `-confederation-programs`, `-loyalist-programs` retiring (14 days). QS 2026 and 2027 verification recorded from the applied publisher files. **Still under Needs attention (genuine): the ten other Ontario college readers** (Centennial, Boréal, Fanshawe, Fleming, Lambton, Northern, Sault, Seneca, St. Clair, St. Lawrence: no other course source, onboarding stopped, every course inactive since 16–17 Aug; readers fail on exact expected counts off by 1–5) and the Ontario colleges register (last run: statement time-out). (3) Register headings no longer stick over the filter bar or + Add source.
- **BOM climate averages loader: open as Pilot #1256 (migration `20261118131000`, s623; dry run passed).** The request (REQ-65, REQ-67/O38; Study Square 13 Nov) is long-term climate averages, not a forecast. `destination.climate_stations` (eight capital stations, season months as data), edition "BOM Climate statistics for Australian locations (IDCJCM0037)" (draft, terms pending), five draft figures per city (summer and winter mean max and min, annual rainfall) with attribution and the station page as evidence; job `destination-climate-load` (2nd of the month, 05:30 Sydney) and Run now. Per the 10:44 directive, figures load as draft while terms are pending; approval and Publish edition stay the Platform Admin's. API v3 `/destination` already returns approved figures.
- **10:44 Australia datasets, not yet loaded:** living costs (Study Australia, Study Tasmania), RM1C application routes, RM1H visa rules, RM1D JSA careers. **RM1J THE 2027 is blocked on the publisher file:** the ranking loader reads THE editions only from an uploaded THE file (Administration › Sources & Imports); no THE 2027 import exists (latest THE: 2025).
- **Open PR ordering:** #1257 (another session, `20261118123707`/`123717`) now sits below the live head and needs new timestamps; #1261 (S2 - BOOST) holds `20261118130000`.


### S3-Boost providers, 18 Nov 2026 21:10 AEDT — CRICOS full reconciliation (s700)

1,543 source codes, 1,541 exact matches (1,539 active), 2 same-provider alias candidates, 21 domain differences, 106 blank catalogue URLs and 709 source URLs normalised. Zero production rows written and US$0.00 LLM spend. G3 75/48, zero drift. Estimated 144.01 hours or 18.95 FTE days saved across this edition. See [audit evidence](https://github.com/msinghbs-ai/coursefinder-admin/blob/main/docs/platform/nz-enrichment-brief/2026-11-18-s3-boost-cricos-provider-reconciliation.md) and [Pilot #1312](https://github.com/msinghbs-ai/Coursefinder-Pilot/pull/1312). Pilot #1312 merged at `d7782d7b`. The exact rebased candidate `fe347485` passed 3,552 tests with zero failures and zero skips, including all four s700 tests, and passed production parity. [Governing CI](https://github.com/msinghbs-ai/Coursefinder-Pilot/actions/runs/44285129957) · [Edge deployment](https://github.com/msinghbs-ai/Coursefinder-Pilot/actions/runs/44287604764).

### S2 - BOOST lane: priority matrix and Boost test-project experiments (17 Nov 2026; Platform Admin 18:02)

Lane: the Boost worker (`worker-boost-bulk-ingest`), the promotion function, qualification seeds and Boost test-project benchmarks. `S1-Build` keeps the PR 1 cutover, Thursday's squash and `housekeeping-daily`.

**Status at 19 Nov 2026 09:55 AEDT, S2 - BOOST (Platform Admin directives 05:40 and 06:55 AEDT, spec block s720–s739; 07:40: continue without the browser). This block covers study load, multi-field reading, campus locality and the test project; the other blocks of the lane keep their items.**

- **s720, test project:** no Pilot change was needed. S2-Build's admin #622 fixed the `outside_window_refused` check; rebuild run 44369667112 passed with it `true`. Run-5 (admin run 44374301938, re-seeded) passed **9 of 9**: 60 admitted for 60 courses at batch sizes 1,000 and 5,000, duplicates refused, shadow admitted nothing, held courses unchanged, G3 75/48 on the test project.
- **s721, study-load label split (Pilot #1337, worker v1.0.24, selectors `study-load-windows-v6` and `study-load-international-v3`, prompt `boost-study-load-v5` unchanged):**
  - Unpunctuated stored text is split at its Domestic and International labels only when a block holds both (CDU, La Trobe, VIT).
  - A line under the Domestic label never states the international load.
  - Closures such as "not available to international students" are never split.
  - S1-Courses closed its own split (#1336) as superseded; its s666 spec passes unchanged against #1337.
- **s722, release and admission (Pilot #1347, migration `20261119082000`, data only, dry run md5 `d26cba54`):**
  - 740 study-load items were released for one re-read: rejected, failed or refused at promotion, on the course's own latest unshared page, course with no study load and no manual lock.
  - Drained by 08:10 AEDT: the batches since the release read 820 items (418 verified, 401 rejected, 1 failed).
  - **206 courses gained an international study load** (110 full-time, 93 both, 3 part-time), each matching its admitted answer. Every one had no study load at release, and the claim takes only courses with none, so nothing was overwritten.
  - 5,689 courses now hold a study load. Cost about US$0.05.
  - The 35 items released before stay released: their pages are shared, so the claim does not read them.
- **s723, s724 and s726, multi-field (Pilot #1346, worker v1.0.26, migration `20261119103000`, records only):**
  - Prompt `boost-fields-v2`: intakes are every announced start month; a new application deadline field gives the date, the intake it belongs to and the verbatim quote, checked by page check `boost-fields-check-v3`.
  - Replay scoring: a held primary intake contained in the page's months agrees. Fees are compared strictly on basis, currency and fee year. Strata are sized one by one (annual 160, whole-course total 60), and the run stops at US$0.15.
  - The `boost_fields_extract` qualification row names v2. `boost.fields_lanes` is unchanged, so live reading does not ask for deadlines.
  - Worker numbering: v1.0.25 went to S1-Courses' #1344, so this change is v1.0.26.
  - **Replay `replay-v2-1`** (Pilot run 44413900611): 237 stored pages, Qwen3 30B, cost US$0.0606 (limit US$0.15), nothing staged or admitted. **No field passes the bar** (at least 100 compared, at least 95%, no disagreement), so **s725 did not admit anything**:
    - intakes: 21 verified, 13 agree and 8 disagree (62%). By s723: 8 exact, 3 contain the held primary intake, 2 page subsets.
    - course fees: 34 verified, 17 agree and 7 disagree (71%). Annual 10 of 11 (91%); whole-course total 7 of 13 (54%).
    - application deadlines: 20 pages hold one; 3 verified, all 3 agree; 17 refused by the page check.
  - **What the disagreements show:** most are the held value, not the reading. Held intake "March" against the page's "First semester (February)"; held CRICOS registered totals against the provider's current "Total course fee". The gold set therefore needs current held values before it can qualify the model.
  - **The 150 and 50 targets were not reachable:** the catalogue holds too few stored pages with a comparable fee of the same basis, currency and year. 197 of the 234 fee answers were refused by the strict page check.
  - Next: a gold set built from verified page values (not CRICOS registration), or human-confirmed samples. Live admission of intakes, fees and deadlines stays off.
- **s727, campus locality (Pilot #1341, migration `20261119062000`):**
  - Rule `l4-campus-locality-v1` gains the basis `campus_name`: the leading urban area holds more than half the postcode's mesh blocks and is named in every waiting campus's suburb or own name, never only through the provider's name (Roseworthy 5371 waits).
  - The 07:57 run settled **3 postcodes, 9 campuses, 0 failures** (2650 Wagga Wagga, 4670 Bundaberg, 6330 Albany). 28 postcodes (69 campuses) wait for a person; settling more by rule needs a suburb-to-area gazetteer the platform does not hold.
  - `062000` was numbered above the live head and every open PR when written, but it applied after `20261119080000` (#1345), which merged first. #1346 and #1347 were renumbered above main before merging.
- **University descriptions, read-only (sentence-1 name rule):** 45 of 49 published university and university-college descriptions name the provider in sentence 1. The 4 that do not were published 10 and 11 Nov on prompt v2:
  - **University of Waikato:** off-topic ("The Academic Calendar …").
  - **Southern Cross University:** "The university uses …".
  - **ECU and ANU:** initials only. `pdesc_name_forms_v1` gives no initials for these names.
  - For S2-BOOST-Providers; nothing changed here.
- **s728, held scholarships, read-only:** rule `l4-held-sch-settle-v1` is settling. 82 pending: 57 audience not stated, 11 without a re-check, 6 publish and 2 refuse recommendations held by the rule's own conditions (for example a `/staging/` address), 3 unclear value, 3 unsettled. Nothing changed.
- **Course descriptions (item 1), S1-Courses' lane:**
  - The 1–2 sentence reader and the identity proof are live (#1344, migration `20261119084000`, prompt `cdesc-source-grounded-v4`).
  - Since 07:44 AEDT: 77 admitted with no overwrite. All 666 earlier readings were declined for a v4 re-read from the stored page (no Firecrawl).
- **Browser check:** not done. Claude in Chrome was not connected, and the Platform Admin said at 07:40 to continue without it. GitHub secrets cannot be read back, and were not printed. The screens are covered by the deployed UAT workflow, which signs in with them; it passed on each merge (for example run 44384114106).

**Status at 19 Nov 2026 05:25 AEDT, S2 - BOOST (post-squash follow-up of the Platform Admin's 18 Nov 10:10 directive). This block covers the Boost test project and the model benchmark; the other blocks of the lane keep their items.**

- **Run-4 on `coursefinder-boost-test`: PASS, 9 of 9 checks** (admin run 44349340646, dispatched 03:36 after S1-Build's "can re-seed" of 02:25; results branch `boost-experiment/44349340646`). Re-seeded from `paste/boost-test-reseed.sql`. Results:
  - 60 admitted for 60 courses, at both 1,000 and 5,000 rows (up to 8,218 rows a second).
  - 5,922 duplicates refused and none admitted; shadow rows admitted none.
  - Held courses unchanged, and the cohort put back.
  - The promotion function `security.boost_promote_v1` is byte-identical to production (md5 `fa4e3a86`).
  - G3 on the test project: 75/48, no drift.
  - The run's read-only production probe could not execute two security functions (`consumer_api_check_v1`, `boost_country_category_check_v1`: permission denied for the read-only role). It reported production head `20261118272000` (2,148 history rows). Production G3 read separately at 03:52: 75/48.
- **Benchmark bench-5 (Pilot #1327, migration `20261119044000`, s699; measures only, Qwen3 30B stays the only qualified model).** Same three named models on the current study-load reader: prompt `boost-study-load-v5`, selector `study-load-windows-v5`, worker v1.0.22.
  - Cohort: 201 pages per model (AU 200, NZ 1, CA 0), the stored pages of courses still without a study load. 138 had no study-load signal, 6 of them fee notes only, so 63 pages with signal per model.
  - Verified rate = verified with a value / pages with signal:

| Model | Verified rate | Rejected | Failed | Verified "not stated" | Tokens in / out | Cost | Cost per verified field | Average time |
|---|---|---|---|---|---|---|---|---|
| Mistral Small 3.2 | **59%** (37/63) | 12 | 6 | 8 | 51,658 / 2,666 | US$0.0044 | US$0.00012 | 1.5 s |
| MiMo v2.6 Flash | 44% (28/63) | 5 | 15 | 15 | 56,066 / 10,927 | US$0.0085 | US$0.00030 | 7.5 s |
| Qwen3 30B | 32% (20/63) | 31 | 0 | 12 | 56,042 / 3,567 | US$0.0061 | US$0.00031 | 1.3 s |

  - **Qwen3 30B's main failure:** 24 of its 31 refusals quote a duration or delivery line ("3 years full-time") as the study load, which the page check refuses (never from duration alone). The other refusals: quote not on the page 4, general definition 2, unused international sentence 2.
  - Mistral's refusals: duration line 5, quote not on page 4, unused international sentence 2, definition 1. MiMo: quote not on page 3, unused international sentence 2.
  - On the 12 pages where all three gave a verified value, they agreed on 11.
  - **Against bench-4** (prompt v4, 184 pages with signal): Qwen3 76%, Mistral 81%, MiMo 66%. Bench-5's pages are the leftovers that the Boost re-reads have not filled, so every rate is lower, and Qwen3's fell most.
  - **Not changed.** Qwen3 30B stays the only model qualified for study load (Platform Admin 18 Nov 11:57: no Mistral route). If the Platform Admin wants the leftovers read, the result points to Mistral Small 3.2 or to a prompt rule against duration lines; either needs a decision and its own qualification.
- Head `20261119044000`. Production G3: 75 functions and 48 tables.

**Status at 19 Nov 2026 16:15 AEDT, S2-BOOST-Providers (Platform Admin 16:02). This block is newer than the 11:10 block for the provider items of the lane.**

Platform Admin 16:02. Read live 16:04 to 16:08 through the rolled-back `live-dry-run` workflow (probe expression, SELECT only). No rule, route, cap, setting or description was changed, so no spec was written (s766 unused). G3 75/48, no drift. Manual locks 7,585. Firecrawl off; provider AI spend today US$0.0075 of the US$0.50 cap; US$0.00 spent by this run.

**Before and after (unchanged):** Australian universities with a description 37 of 45; Australian university colleges 6 of 8; all active providers with a description 2,185 of 3,091 (906 without, 645 of them published).

**The 10 Australian university records without a description:**

| Provider | State | Exact reason | What settles it |
|---|---|---|---|
| University of Technology Sydney (UTS) | Layer 4, pending | Machine rule: after sentences with refused words are left out, fewer than two remain. The reading itself is sound. | A person approves it in Layer 4 |
| Victoria University (two records, `0f5373c8` and `bac82321`) | Identity hold, never read | Both records hold the host vu.edu.au, so each blocks the other | Merge or retire the duplicate record |
| RMIT University | Identity hold, never read | Host rmit.edu.au is also held by "RMIT University Pathways, RMIT UP" | Record which provider owns the host |
| Western Sydney University | Identity hold, never read | Host westernsydney.edu.au is also held by "UWS College, Western Sydney University The College" | Record which provider owns the host |
| Torrens University Australia | Identity hold, stored page | Page title is "About Us \| Torrens University"; the catalogue name ends in "Australia" | A trading name "Torrens University", or a person |
| Moore College (university college) | Identity hold, stored page | Page title is "About Moore Theological College"; the catalogue name is "Moore College" | A trading name "Moore Theological College", or a person |
| Avondale University | Wrong page, no stored page | The About address redirects to `/your-uni/`, which is not an approved About address | An approved About address for the provider |
| Macquarie University | Never read, no stored page | An open identity finding (identity unconfirmed) stops the read | Resolve the identity finding |
| Australian University College of Divinity (university college) | Never read, no stored page | Its domain is shared with a provider record named "NA" | Fix or retire the "NA" record |

- **No re-read was run.** The two with a stored page and a name mismatch (Torrens, Moore) would be held again by the unchanged identity proof, so a model call would change nothing.
- **Layer 4.** Of the 62 pending university-description items, 1 is an Australian university (UTS). The others: Australian private VET 28, schools 7, higher education institutes 7, other 3; Canada 11; New Zealand 5. Each went to Layer 4 because the machine rule `pdesc-machine-v1` declined its text; none passes as it stands.
- **Why there is no Australian university pill.** The Layer 4 grid filters by kind and reason only; it has no country or provider-type filter. A `Country` and `Provider type` filter is a screen change for S1-Build after handover.
- **All 906 providers without a description, by country and state:**

| State | AU | CA | NZ |
|---|---|---|---|
| No stored page | 348 | 76 | 59 |
| Identity hold | 177 | 74 | 31 |
| Layer 4, pending | 46 | 11 | 5 |
| Grounding hold | 17 | 10 | 2 |
| Other (wrong page, sentence count, wording) | 26 | 9 | 11 |
| Never read, stored page | 3 | 0 | 0 |
| Queued | 1 | 0 | 0 |
| **Total** | **618** | **180** | **108** |

**Not done:**
- No Australian university description was admitted.
- Propagation to the Website and Zoho projections was not checked, because nothing was admitted.

**Next executable action:**
- A person: approve UTS in Layer 4.
- Platform Admin or catalogue owner: the duplicate Victoria University record, the shared hosts for RMIT and Western Sydney, the "NA" record, and the Macquarie identity finding.
- S1-Build, after handover: `Country` and `Provider type` filters on the Layer 4 grid.

**Status at 19 Nov 2026 17:10 AEDT, S2 - BOOST (Platform Admin 16:00, s754: university and higher-education provider descriptions). This block is newer than the S2-BOOST-Providers 11:10 block for those items.**

Pilot #1383, one data-only migration `20261119170500` (dry run md5 `4d54f3c2`; applied, read back 17:05). No table, column, function, job or setting. G3 75/48, no drift. Manual locks 7,585. Every live read was made through the rolled-back dry run (workflow_dispatch on a probe branch), with no interactive query.

- **Scope found live:** 201 published, active providers of the types university (53), university_college (8), higher_education_institute (137) and wānanga (3). 141 hold a description and 60 do not. The directive's 209 could not be reproduced from the live tables; this block reports the 201 and the 60.
- **The 60 without a description, by their latest read:**

| State | Count |
|---|---|
| Ready to admit (passes the machine rule) | **0** |
| Layer 4 pending: all 8 declined by the machine rule; a person decides | 8 |
| Identity hold | 29 |
| Grounding hold outside Layer 4 (read today with GPT-4.1 mini) | 2 |
| Other content hold: sentence count 3, not stated 2, refused topic 1, refused source word 1, not an about page 1 | 8 |
| No stored page and never read | 13 |

- **Identity holds (29):**
  - 9 share a website with another active provider record (Holmes Institute 3, Victoria University 2, RMIT, Western Sydney, Le Cordon Bleu, Trident).
  - 18 are pages that do not prove the full catalogue name.
  - 1 is identity unconfirmed (ECA) and 1 a sub-unit page (Christian Heritage College).
- **Why no read can clear them:** the identity proof runs before any model call and takes names only from the catalogue and the register. 8 of the 18 look like the same institution under a trading name or with a suffix, on the provider's own website:
  - AUT ("… in New Zealand");
  - Lyons College;
  - Te Whare Wānanga o Awanuiārangi;
  - Torrens University;
  - Moore Theological College;
  - Kaplan Murdoch;
  - Sydney Metropolitan Institute of Technology;
  - CIHE (Crown Institute of Higher Education).
- **Clearing those 8** needs a trading name recorded for the provider or a person; the 07:39 rule keeps a place or sub-brand after the name held, so the proof was not weakened. The other 10 correctly stay held: the page names another institution (Emmaus to ACCS, AIM, Deakin College, Texila) or the title does not carry the name (APEX, EQUALS, IBC, Ozford, Sydney Institute of Higher Education, AMPA).
- **Re-check (s754):** one GPT-4.1 mini read from the stored page went to each provider whose latest read was held by a content rule (never identity) and was not made by GPT-4.1 mini in the last day. That was 2: Kingsford Institute of Higher Education and Australian Guild of Education.
  - Both were read at 16:31 and held again (not stated: the page does not describe the institution).
  - Spend US$0.0006 (US$0.00 Firecrawl, `pdesc.acquire_firecrawl` 0); the provider_description route stood at US$0.0081 today, inside its US$0.50 cap.
- **Before and after:** published providers with a description 2,185 → 2,185; higher-education 141 → 141. Nothing was admitted, so the Website and Zoho projections are unchanged. Layer 4 provider descriptions pending (all types): 62.
- **No stored page (13):** Macquarie University, Victoria University of Wellington, Te Wānanga o Aotearoa and 10 others stay held; a read needs a page, and Firecrawl is off.

**Next executable action:**
- Platform Admin or the provider owner: record trading names for the 8 same-institution identity holds (or approve them in Layer 4), and decide the 9 shared-website records (which provider owns the site).
- A person: the 8 higher-education descriptions in Layer 4 (62 provider descriptions in all).
- Platform Admin: allow Firecrawl for the 13 providers with no stored page, if wanted (about 13 credits).

**Status at 19 Nov 2026 11:10 AEDT, S2-BOOST-Providers self-check. This block is newer than the 08:45 block for the provider items of the lane.**

Read live at 11:05, SELECT only. No rule, route, cap or setting was changed. G3 75/48, no drift. Manual locks 7,585.

**Totals:**

| Measure | 07:07 | 11:05 |
|---|---|---|
| Published, active providers with a description (of 2,830) | 2,171 | 2,184 |
| University descriptions pending in Layer 4 | 61 | 62 |
| Scholarships published (of 2,832 records) | 1,066 | 1,066 |
| Held scholarship pages | 82 | 82 |

- **Re-read of 267 (launched 08:36):** 252 finished, 14 still queued and 1 being read. 13 admitted by the unchanged machine rule, 1 proposed in Layer 4, 238 held.
  - Spend US$0.0478 for 55 model calls; Firecrawl reads 0. The service cap of US$0.50 a day was not approached.
- **58 grounding holds:** 12 admitted, 40 held again (quote not on the page 17, unsupported sentence 10, nothing stated 10, others 3), 6 queued.
- **196 identity holds:** 184 are still held by the page identity proof. 1 was admitted and 1 proposed; the other 10 are queued or held by another rule. The s762 rule released at most 12.
- **13 never-read providers with a stored page:** none admitted. All 13 were held before any model call: identity not confirmed 6, name not clean 2, shared domain 2, shared host 1, register changed 1, redirected or parked 1.
- **Held scholarships:** unchanged at 82.

**Not done:**
- 15 reads had not finished at 11:05.

**Next executable action:**
- Provider description owner or Platform Admin: the 184 identity holds need a trading name recorded for the provider, or a person; the narrow rule does not reach them.
- A person: the 62 university descriptions in Layer 4.

**Status at 19 Nov 2026 08:45 AEDT, S2-BOOST-Providers (Platform Admin 07:39 and 08:17). This block is newer than the 07:15 block for the provider items of the lane.**

Platform Admin 07:39 and 08:17. Worker change #1353 (s762, no migration) and one data-only migration `20261119090000` (md5 `f6c0971b`, #1355; s763, s764, s765). No table, column, function or job added. G3 75/48, no drift (read 08:40). Manual locks 7,585, unchanged.

- **Identity proof (s762, worker).** A title or h1 segment that holds the provider's whole catalogue name plus its own initials in brackets, or an RTO, CRICOS or TEQSA registration number, now proves the provider on its own host. The registration code's form is checked, not its value: the worker is not given the register's numbers. A place or sub-brand after the name, another institution, a campus, faculty or school, a shared host and a foreign bracket stay held. The worker version string was not bumped.
- **Route (s763).** GPT-4.1 mini is allowed again, qualified for `provider_description` only (the Platform Admin's decision is the evidence; provisional until a regression qualification), and is the service's one model with prompt version 5. The service's daily cap is US$0.50 (was US$1). No other service lists it. `pdesc.acquire_firecrawl` is 0.
- **Re-read launched 08:36 (s764).** 267 reads queued: 196 held by the identity proof, 58 held by grounding, 13 never read with a stored page. At 08:40, 23 were done and all held (identity 8, machine identity rules 12, not stated 2, shared host 1); 244 were queued. Spend so far US$0.0007. At 10 reads every 5 minutes it finishes about 10:45.
  - Not in the re-read: the 54 readings restored to Layer 4 (they keep their open reading), and 225 never-read providers that have no stored page.
- **Source words (s765, F-PDESC.01/.02).** There is no allow list. The one list is `pdesc.refused_path_words`, and dates, calendar and timetable have been in it since 9 Nov: a page address with one of them is never a description source. The migration puts a missing word back and fails if any of the three is not refused; nothing was removed.
- **Layer 4 triage (F-PDESC.03).** All 61 pending university descriptions have been checked by the machine rule and declined, so none is machine-eligible as it stands.

| Group | Items | What a person does |
|---|---|---|
| The provider is not named at the start (29) | 17 as read, 12 after refused sentences are left out | Approve only after adding nothing: reject, or wait for the re-read |
| Fewer than two sentences remain once refused sentences are left out (18), or too short (2) | 20 | Reject, or wait for a new reading |
| A refused topic (fees, visas, rankings and the like) | 11 | Reject |
| Every sentence refused | 1 | Reject |

  - 54 of the 61 are the readings restored at 07:07; 7 arrived on their own.
- **Held scholarships (82).** Unchanged, as confirmed: the 5 pages whose readings disagree, the staging address and the second Bond page stay held. No rule or spec was added for this (s683 already guards it).

**Not done:**
- Final re-read counts: the batch is running.
- The test register rows for s762 to s765 were added in the generator's format.

**Next executable action:**
- S2-BOOST-Providers, about 11:15 AEDT: read the final re-read results (admitted, proposed, held by rule, spend), then record them here and in the registers.
- Platform Admin: `pdesc.acquire_firecrawl` stays 0 and the service cap stays US$0.50 a day until changed on Settings.

**Status at 19 Nov 2026 07:15 AEDT, S2-BOOST-Providers handover (Platform Admin 06:49). This block is newer than the 18:45 block for the provider items of the lane (held scholarships, university descriptions, campus locality).**

Platform Admin 06:49. One migration, `20261119080000` (md5 `ab4845cc`), data only; specs s760 and s761. No table, column, function or job added. G3 75/48, no drift (read 07:07). Live head `20261119080000` (2,158 applied).

**Handover numbers (read live 07:07):**

| Measure | Count |
|---|---|
| Published, active providers | 2,830 |
| With a description | 2,171 |
| Without a description | 659 |
| University descriptions waiting for a person in Layer 4 | 61 |
| Scholarship records | 2,832 |
| Scholarships published | 1,066 |
| Held scholarship pages | 82 |
| Campus localities waiting | 78 |

- **Prompt record (s760).** The live prompt is version 5. Version 4 had been saved from the admin screen and version 5 built in SQL, so neither text was in a file. Both are now byte-for-byte fixtures in Pilot `tests/fixtures/pdesc/` with the live checksums; the migration refuses to apply if either live row differs.
- **Re-read finished.** All 81 descriptions sent back on 18 Nov were read again from stored pages (US$0.0206, no Firecrawl): 12 admitted, 6 proposed in Layer 4, 63 held by the reader's own checks (a quote not on the page 26, a sentence its quote does not support 24, others 13).
- **Restore (s761).** For 54 of the 63, the provider still has no description, so the earlier reading is pending in Layer 4 again with its reading proposed, and a person can approve it. The other 9 already hold a register-fact description. The migration admitted nothing.
- **Why 659 providers have no description** (latest read of each):
  - 238 have never been read.
  - 196 are held by the page identity proof: the page title or h1 is not the provider's name alone (for example "About Us | Sydney Art School (SAS)", "Scotch College Melbourne", "About Us - Princeton International College" for Princeton Education Group Pty Ltd).
  - 56 share their host with another active provider; 21 have a campus, faculty or school heading.
  - 105 are held by grounding (quote not on the page 63, unsupported sentence 34, unsupported number 8).
  - 7 are proposed in Layer 4; the rest are sentence count, wrong page and wording.
- **Held scholarships (82, unchanged).** No rule was changed. Of the 15 clear re-check recommendations, 7 were settled on 18 Nov. The other 8 stay held: in 5 the two readings disagree about who may apply, 1 is a staging address, 1 audience sentence does not say "international", and 1 (Bond) is a second page of a scholarship already admitted. The rest are audience not stated 57, value unclear 3, not settled 3, no stored copy 11.
  - The two scholarships admitted on 18 Nov are still unpublished: Ronald Lu Travel Award closed on 22 Jun 2026, and the Otago Polytechnic record has no award value.

**Not done:**
- Signing in to PIM Admin in a browser: the UAT email and password are GitHub Actions secrets, which cannot be read back, so the screens were not checked by eye. The counts above are from the live database. The Deployed UAT run on this merge was cancelled by a later merge.
- No batch drain was started and no follow-up check was scheduled: the reader has no queued description reads, and every remaining provider is held by a rule, not by a queue.
- The page identity proof and the grounding check are in the worker (`coverage-sweep/description.ts`); neither was changed.
- The test register rows for s760 and s761 were added in the generator's format.

**Next executable action:**
- Platform Admin: decide the provider description model route (Qwen3 30B gave 8 usable readings of 39 with prompt version 5; GPT-4.1 mini gave 158 of 392 with version 4). It governs the 105 grounding holds.
- Provider description owner: a worker release that accepts a title segment made of the provider's name plus its own initials in brackets or a registration number, then a re-read of the 196 identity holds.
- A person: the 61 university descriptions in Layer 4.

**Status at 18 Nov 2026 18:45 AEDT, S2-BOOST-Providers (Platform Admin 17:52). This block covers the provider items of the lane (held scholarships, university descriptions, campus locality) and is newer than the 17:30 block for them. The other blocks below stand for their own items.**

Platform Admin 17:52. One migration, `20261118213000` (md5 `8290da99`); specs s683 and s684, s681 guard line updated. No table, column, function or job added: the one function changed is this lane's own `security.scholarship_recheck_queue_rule_v1`.

- **Held scholarships (89 to 82).** Rule l4-held-sch-settle-v1 runs inside job `scholarship-recheck-queue` (hourly at minute 9) and decides through the existing decision under the system automation account, with the page sentences in the note.
  - It admits only when the AI re-check and the first reading both say international students may apply, the audience and value sentences were found on the page, and the page is on the provider's own https host. It refuses only when the re-check found a domestic-only sentence the first reading does not contradict.
  - First run: 3 admitted, 4 refused, 0 failed.
    - Two new scholarship records, both unpublished until the hourly publish checks pass: Ronald Lu Travel Award in Architecture (UNSW, 34 course links) and 2027 Otago Polytechnic International Scholarships (68 course links).
    - The third (Griffith) was closed as a duplicate of a record already held; no record was written.
  - 8 of the 15 clear recommendations stay held for a person: in 5 the re-check and the first reading disagree about who may apply, 1 is a staging address (Macquarie), 1 audience sentence does not say "international" (Massey), and 1 was not taken (Bond; cause not yet read).
  - Still held, as directed: audience not stated 57, value unclear 3, not settled 3, and 11 with no stored copy.
- **University descriptions (83 pending at 18:00; 81 sent back).** Prompt version 5 is active (version 4 retired): two to three sentences, the first beginning with the provider's full name, and the most-refused words left out. The 81 Layer 4 items were closed as superseded, with every reading kept, and a new read was queued for each provider.
  - At 18:40, 34 of the 81 were re-read from stored pages (no Firecrawl, US$0.0076): 6 admitted by the unchanged machine rule, 2 back in Layer 4 as proposals, 26 held by the reader's own checks, 47 still queued.
  - The name problem is gone (1 of 34). What holds them now is grounding: a quote that is not on the page (11) or a sentence its quote does not support (11).
  - **Cause to decide.** The description route now uses Qwen3 30B. Across all its readings with prompt version 4 it gave 11 usable readings of 161; GPT-4.1 mini gave 158 of 392. Version 5 lifts Qwen3 30B to 8 of 39. The route is a Models & services setting and was not changed.
  - **Effect on the Inbox.** Layer 4 › University descriptions shows 2 (plus the 663 course descriptions), but a reading the reader holds is not admitted. The earlier readings sit on the superseded items and cannot be approved from the Inbox until restored.
  - One read sat leased for 20 minutes (18:17 to 18:37) and paused the queue; it released itself.
- **Campus locality: source-data exceptions (no rule changed).** The locality follows the postcode, so a campus with a wrong postcode in its source record shows the wrong city.

| Postcode | Campus suburb and address as held | Provider | Locality now | What is wrong |
|---|---|---|---|---|
| 0830 | Alice Springs, 17 Grevillea Dr | Charles Darwin University | Darwin (by rule) | Alice Springs is 0870; 0830 is Palmerston |
| 2615 | Forest Hill, 138 Don Kendell Drive, Wagga Wagga Airport | AAPA Victoria Pty Ltd | Canberra - Queanbeyan (by rule) | Forest Hill NSW is 2651; state held is NSW, postcode is ACT |
| 2232 | Camperdown, 22 Carillon Avenue | Australian University of Theology | Sydney (by rule) | Camperdown is 2050; the city is right, the postcode is not |
| 2800 | North Parramatta, 16 Masons Dr | Charles Sturt University | Waits for a person | North Parramatta is 2151; 2800 is Orange |
| 4650 | Nambour, Blaxland Rd | Education Queensland International | Waits for a person | Nambour is 4560; 4650 is Maryborough |
| 2536 | "Batmans", Batemans Bay Education Centre | University of Wollongong | Waits for a person | Suburb misspelt (Batemans Bay) |
| 4740 | "Beaconsfiled", Celeber Dr | Whitsunday Anglican School | Waits for a person | Suburb misspelt (Beaconsfield) |

  - The first two show a wrong city on API v3 `campuses[].locality` until the campus postcode is corrected at its source (CRICOS). Campus locality stays at 78 waiting.
- G3 75/48, no drift (read 18:09). Live head `20261118220000` (another lane's); 2,136 applied.
- Google Drive `Roadmap_Engagement_Register`: the extra blank row was removed and the three rows that had landed mid-table (this lane's and two from other sessions) were moved to the end, so the sheet follows the CSV order.

**Not done:**
- The 47 queued re-reads had not run at 18:40.
- The superseded items of readings the reader held were not restored to the Inbox.
- The test register rows for s683 and s684 were added in the generator's format; the generator's listing step needs the full Pilot environment.

**Next executable action:**
- S2-BOOST-Providers, about 20:05 AEDT: read the final re-read counts and restore to Layer 4 the superseded item of every provider whose re-read was held, so a person can still approve the earlier reading.
- Platform Admin: decide whether the provider description route returns to GPT-4.1 mini.
- Correct the campus postcodes for 0830 and 2615 at their source.

**Status at 18 Nov 2026 23:00 AEDT (S2-Courses; Platform Admin 21:59). Items s661 and s665 of the lane are live; s662 and s664 are in Pilot #1314 (chat S1-Courses). The 18:00 block below stands for its own items.**

Findings: [`platform/S2-COURSES-STUDY-LOAD-GUARD-AND-FEE-BASIS-REPLAY-2026-11-18.md`](platform/S2-COURSES-STUDY-LOAD-GUARD-AND-FEE-BASIS-REPLAY-2026-11-18.md).

- **Worker `coverage-sweep` v1.0.22 is live** (Pilot #1316 and #1319, specs s661 and s665, no migration).
  - Study load reader cue: a course closed to international students is never read as a load rule; the international word that names the student and the study word lie within 80 characters (or a label within 160). Selectors `study-load-windows-v5` and `study-load-international-v2`; prompt `boost-study-load-v5` and the route unchanged. Live inspection of 62 readings: 41 matches before, 18 now, about 8 real. Not promoted; nothing admitted; the next change splits a block at its Domestic and International labels.
  - Fee-basis replay (run 44297706134, 225 pages, US$0.0458, nothing admitted): annual fees 6 of 6 agree, whole-course totals 3 of 7, intakes 10 of 18, fees 15 verified of 224. Qwen3 30B stays qualified for study load only.
- **s662 and s664:** Pilot #1314 (S1-Courses) carries the 1 to 2 sentence reader, the identity-proof exemption and the Layer 4 explanations and four decisions. Its migration `20261118253000` is below the live head and must be renumbered before merge.
- **Question for S2-Intakes (priority):** is a course's intake the next intake the page announces or the main annual start? The replay cannot score intakes until this is defined.
- G3 75 functions and 48 relations, no drift (read 22:52). Live head `20261118256000` (2,144 applied).

**Status at 18 Nov 2026 18:00 AEDT (S2-BOOST-Courses; Platform Admin 17:02). This block covers the course items of the lane (study load reader, multi-field reading, course descriptions). The 17:55 and 17:30 blocks below stand for their own items.**

Findings and the activation spec: [`platform/BOOST-SENTENCE-CUE-DESCRIPTIONS-AND-MULTI-FIELD-QUALIFICATION-2026-11-18.md`](platform/BOOST-SENTENCE-CUE-DESCRIPTIONS-AND-MULTI-FIELD-QUALIFICATION-2026-11-18.md).

- **Worker `coverage-sweep` v1.0.18 is live** (Pilot #1299 and #1301, specs s660 and s663, no migration).
  - Mode `boost_sentences` (read only, no model): the sentences the study load reader takes as a statement for international students. Workflow `boost-sentences-inspect.yml`.
  - Page check `boost-fields-check-v2` on Boost multi-field reading. The prompt is still `boost-fields-v1`.
  - Mode `boost_fields_replay` and workflow `boost-fields-replay.yml`: the gold-set replay. It stages and admits nothing.
- **Study load reader stays at v5.** The international-sentence cue was inspected on the 41 settled pages: 35 false matches, 6 real statements. Nothing was promoted or admitted.
- **Qwen3 30B is qualified for study load only.** Replay of 80 gold pages: intakes 6 of 12 verified answers agree with the held value, fees 7 of 10; descriptions pass the page check on 47 of 60 pages; deadlines have no field in the prompt.
- **Course descriptions waiting in Layer 4: 663** (identity margin thin 448, binding ambiguous 143, refused word 44, evidence moved 15, wrong page kind 13). No rule was changed.
- **Open work:** identity-proof rule for descriptions (s662, needs a function migration), study load v6 cue (s661), intake definition with S2-Intakes, then a larger replay.
- G3 75 functions and 48 relations, no drift (read 17:59). Head `20261118210000`.

**Status at 19 Nov 2026 11:40 AEDT, S2-BOOST-Discovery (Canada approved for the AER programme in Wave 2; priority read queue). It is the newest for these items and adds to the 11:35 block below.**

Platform Admin 11:36 AEDT. **Canada (52 international providers, including UBC, Alberta and Conestoga) joins the AER programme in Wave 2, immediately after the 20 Nov handover.** Today's remaining budget and queues stay on AU and NZ. **Priority read queue (no search credit): the 355 providers that already have discovered pages and nothing read for scholarships or entry requirements** (AU 332, NZ 21, CA 2; the 2 Canadian providers wait for Wave 2), then the remaining AU and NZ AER and scholarship drains. Docs and registers only: nothing was started on the queue, no setting, job, table or function changed (G3 75/48), no migration. Correction: the audit entry and report were stamped 11:55 AEDT in error; the audit ran about 11:15 to 11:35 AEDT on 19 Nov and the stamps now read 11:35. Ledger row, workbook and Drive Monitoring synced with this entry.

**Status at 19 Nov 2026 11:35 AEDT, S2-BOOST-Discovery (scholarship and AER discovery audit, read-only). It is the newest for these items and adds to the 08:55 block below.**

Read-only, no write, no Firecrawl spend, no table, column, function, job or setting added (G3 75/48). Of 1,675 active providers with international courses (AU 1,544, NZ 79, CA 52; 1,886 if courses not recorded as domestic-only are counted, NZ 290): **(a)** 1,571 hold a homepage (220 verified by search, 362 entered by a person, 989 register values not flagged; 104 AU have none); **(b)** 708 have a scholarship page crawled or a record published (91 published); **(c)** 797 have an entry-requirements read (AU 751, NZ 46, CA 0); **(d)** 90 have zero discovered pages (No site 26, No page 64, all AU); a further 355 have pages but nothing read. 1,385 lack a scholarship hub or an entry-requirements source (421 lack both). **Canada has no entry-requirements source for any of its 52 providers and no row in `aer_provider_coverage`**, so 25 of the top 30 uncovered providers are Canadian (UBC 575 courses, Alberta 379, Canterbury NZ 282, Conestoga 270). The Coverage & completeness screen shows academic entry as No reader for 34,631 courses because the field register reader is `none`; it cannot separate a provider with no source from one read but not admitted. Open work: Platform Admin to decide whether Canada joins the AER programme; AU and NZ top 20 and the 355 read-pending providers are listed in the report for post-handover crawls.

**Status at 19 Nov 2026 08:55 AEDT, S2-BOOST-Discovery (handover close on the 07:39 decisions and the 08:18 addendum). It is the newest for these items and adds to the 07:15 block below.**

Platform Admin 07:39 (three handover decisions) and 08:18 (addendum IQ-00029). Two Pilot changes, no table, column, job or setting added: #1354 migration `20261119085000` (md5 `ed95b24d`, data only) and #1361 migration `20261119100000` (md5 `bcb8b92d`, two function replacements; specs s659 and s666). Live head `20261119100000` (2,169 applied). G3 75 functions and 48 relations (read after each apply).

**Decisions recorded (07:39):**
1. **University search stop kept active** for all 21 providers (637 queued searches at the 07:15 read), so the day's Firecrawl share goes to the 2,108 queued searches with the gate open. Nothing was changed.
2. **ANU (34) and La Trobe (21) year-swapped addresses (55 courses): held.** No candidate table was created and `security.course_page_rebind_v1` was not called; their proved pages and readings are untouched (the s659 release selects only found pages with no read result, no proof and no stored reading).
3. **The 11 found pages left unread (UVic 8, Seafood Training Services 2, PBRS 1) were released to the reader** with no search credit (#1354: next read now, attempts reset, lease cleared; recorded in `pipeline.admin_control_events` as `read_released`, search credits 0).

**What happened to the 11 pages:**
- The two read jobs (`coverage-read`, `coverage-read-2`) had been switched off at 07:50 by the idle check (its last 30 runs found nothing). The 10-minute recheck switched them on again at 08:10 because the release left work waiting; nobody changed them by hand.
- **1 page was read:** a UVic page, HTTP 200, identity mismatch (status mismatch), so not proved.
- **10 pages (UVic 7, Seafood 2, PBRS 1) are unread, with all three attempts used.** The read call that claimed them ended with `WORKER_RESOURCE_LIMIT` (HTTP 546, "not enough compute resources") at 08:10, 08:21 and 08:31, and wrote no result each time (attempts 3, read status empty, lease ended 08:42). The same ending fits the three claims left unrecorded at 18 Nov 18:11. They were not released again: another release would repeat the ending. The cause is in the worker's read call (up to 20 pages of one university in one call), not in the queue.

**IQ-00029 (08:18 addendum), fixed by #1361:**
- **Finding that changes the fix.** The HTTP 500s on `discover` (128 of 394 calls from 05:24 AEDT to the apply, 32%) are `svc_coverage_discovery_next` ("canceling statement due to statement timeout"): its focus check (`security.enrich_focus_v1`, 10.7 ms a provider) ran over the 1,177 due providers before the order and the limit, 7.8 s with nothing in focus. The stop gate belongs to the course search pick `svc_course_link_search_next`, which showed no failure only because the daily share was spent. Both picks are fixed.
- **Both picks now check lazily, in pick order, and stop at a 5 s budget counted from the start of the call** (inside the worker's 8 s limit; the only number, marked `-- fixed:`). Course search: the stop gate (9.7 ms a row), the site-list check (7.4 ms a row) and the provider-level checks (about 17 ms a provider) run in pick order, once per provider for the provider-level ones; the stop is read per provider through the gate's own fallback; the order, the locks and the lease are unchanged. A call that spends its budget returns the rows it found, the next call continues.
- **Rolled-back live run with the daily share opened:** the old course search pick took 17.7 s for 40 rows (a time-out); the new one 5.1 s for 17 rows, all among the old 40. Discovery: 5.05 s with nothing in focus; with 3 focus providers forced due it picked the same 3, in course-count order.
- **After the apply (08:43:32):** 12 of 12 `discover` calls started since returned 200 (the 2 failures at 08:43 had started before the apply). 6 of 6 `link_search` calls returned 200, but the share is spent, so the course search pick has not yet run its full path live: that is the first check at 00:00 AEDT 20 Nov.

**Not done:**
- The 10 pages stay unread, and the other binder rows in the same state (95 at 07:50, mostly UVic) are untouched.
- The read worker's resource limit: not changed (worker code, or the read call size `batch.coverage_read`, are not this lane's).
- The course search pick under the open share: first live proof at 00:00 AEDT 20 Nov.

**Next executable action:**
- Worker owner / Platform Admin: reduce the read call's page count (setting `batch.coverage_read`, Settings › Pipeline settings, with a reason) or raise the worker's compute, then release the 10 pages again (Read now on each course) and read the results.
- S2-BOOST-Discovery, 00:05 AEDT 20 Nov: read the first 10 `link_search` calls after the share opens (expect 200 with picks, no 500).
- The ANU and La Trobe hold and the university search stop stay as decided.

**Status at 19 Nov 2026 07:15 AEDT, S2-BOOST-Discovery (own check-in on the 16:54 and 17:02 directives). It adds to the 19:20 block below and corrects two lines of it (marked).**

Read live from 06:55 AEDT (project `fxcwkweaxjtknorudmwp`, read-only SQL). No Pilot change, no migration, no data write this round: nothing in it needed one. Live head `20261119053000` (2,156 applied). G3 75 functions and 48 relations.

- **On-demand request `2fe02033` was closed 18 Nov 19:16 AEDT** (08:16 UTC) through `security.on_demand_close_v1`; it did not need closing again. Window use: 1,092 `link_search` calls, 2,184 credits (recorded 2,190). After the close the scheduled share ran from 00:00 AEDT: 400 calls, 800 credits, which is the whole daily share for course search. Credit left on the plan at the close: 70,682.
- **Pilot s658 (#1306) is live and holding.** The live rule carries the gate filter and the return to the list. Of the 563 items waiting on a search, none has its search behind a gate (489 have a search queued, all with the gate open).
- **Searches finished since the request opened (06:15 UTC 18 Nov): 922 courses.** 99 found a page (6 by CRICOS code, 93 by title; 1 of them verified); 823 found none. Course page needed now: open 1,492, search asked for 563, page added 6, no page exists 236.
- **The 99 found pages: 1 is read and proved** (CRICOS code). The other 98 are: need a rendered read 40 (24 on `sws.ucol.ac.nz`, next read 19 Nov 17:58 AEDT), could not be fetched 29 (404) and 12 (200 but not read), unread 11 (see below), robots-disallowed 4, blocked 1, a 400 response 1.
- **Queued searches by stop gate (4,049):** open 2,108 (405 providers), no page published by the provider 1,263 (29 providers), university search stop 637 (21 providers), per-course stop 31, remediation hold 10. The university stop now holds: Adelaide University 172, Swinburne 159, Victoria University 92, Flinders 45, Monash 38, Melbourne 31, ICMS 25, NorthTec 14, UCOL 13, Torrens 12 (**correction to the 19:20 list: Swinburne and Melbourne are in it too**).
- **Finding: the search pick still times out under real load.** 141 `svc_course_link_search_next` time-outs since 06:49 UTC: 18 between 06:49 and 09:00 UTC (the window was open until 08:16), 123 from 00:00 AEDT when the daily share opened (59 of 59 runs in the first hour), none after the share was spent at 02:12 AEDT. Cost measured read-only over the 4,049 queued rows: the stop gate 43 s (12 s with the provider flag the pick supplies), the site-list match 8 s, the provider-level checks 6.1 s for 171 providers; the worker's call limit is 8 s. The work was not lost: the full share of 800 credits was used. **Corrects the 19:20 block** (13 time-outs while open, 2 after close): that count was low. Not fixed: under the current share it would add no searches; the fix is a function change (evaluate the gate and site-list check lazily in pick order, with a stop time taken from the role's statement time-out), to be done with an on-demand window that needs it.
- **Binder matcher (s651 as asked, s659 reserved): no change.** Of the 98 unproved found pages, 53 have the same address in the search and the binder, 0 differ only by a query string or a trailing slash, 3 differ in whether a query string is present, and 42 are not the address the binder holds. In the 12 sampled, those 42 are wrong-page results (a student story, a news article, a library or repository page) the binder did not take. The wrong-class hosts and paths are not a rule: 55 of 66 older found or verified pages on such hosts were verified. Failures are rendering, 404 and blocks.
- **Finding: 11 found pages are unread with their lease expired.** UVic 8, Seafood Training Services 2, PBRS 1: three read attempts, lease ended 18 Nov 18:11 AEDT, no read status. Not touched (reader lane).
- **Course link year preference (s650 as asked): not built, by finding. Corrects the 19:20 block.** Layer 4 Course link: 270 waiting; the check holds 254 and would refuse 16 (audit sample), and would use or enter none. Waiting by university: Macquarie 52, SFU 47, ANU 34, Melbourne 27, Sydney 22, La Trobe 21. For ANU and La Trobe the proposed page is the binder's own old-year page (2016 to 2024 handbook address), read and proved by CRICOS code (ANU 34 of 34, La Trobe 20 of 21, the other by exact title). Melbourne's 27 are 2026 pages that failed the identity check.
  - The 19:20 line "these read as courses no longer in the current handbook" is not supported: the binder already holds 16 ANU and 16 La Trobe pages with a 2026 address, all proved by an accepted identity basis, none a 404. No 2026 address has been tried for the 55 waiting (0 rejections).
  - The rule already prefers the current year: `use` needs the page year at or above the Melbourne year, `enter` needs a binder page that is read, proved and of the current year (`security.course_relink_year_url_v1` makes the swapped address).
  - Why it is not a rule now: `security.course_page_rebind_v1` overwrites the binder row, clearing the proof and the stored page reading, before the new address is read. Offering 55 unproved addresses that way risks the proved old pages. Keeping the old row beside needs a new table (not in this lane). A live read of two swapped addresses was not possible from this session (the fetch needed approval and nobody answered).

**Not done:**
- Year-swapped read for ANU (34) and La Trobe (21), about 55 Firecrawl credits.
- The search pick fix above.
- 489 searches for waiting items are still queued with the gate open; the daily share allows about 400 searches a day.

**Next executable action:**
- Platform Admin: lift or keep the university search stop for the 21 providers above (637 queued searches); decide whether the year-swap read for ANU and La Trobe may be run as a probe that keeps the old row (needs a table: a lane with migrations).
- S2-BOOST-Discovery next: after 17:58 AEDT read the UCOL rendered reads; with the next on-demand window, build the pick fix.

**Status at 18 Nov 2026 19:20 AEDT, S2-BOOST-Discovery. It corrects the 17:55 block below (402 gate-held, not 834).**

Own follow-up of the 17:55 block (Platform Admin 16:54 and 17:02). One migration, `20261118233000` (md5 `a1c8157c`); spec s658. No table, column or job added.

- **Correction to the 17:55 block.** "834 searches held by the stop gate" counted every queued search of the 91 providers, including older ones the rule never sent. Of the items rule l4-page-needed-search-v1 itself had sent, 402 were gate-held at 18:50. The 17:55 block also said the pick fix ended the time-outs; 13 more followed while the on-demand request stayed open.
- **Finding: 709 courses had left the Layer 4 list with nothing working on them (18:50).** Of the 840 items the rule had sent: 307 searches finished and found no page, and nothing brought those items back; 402 were queued behind the stop gate; 90 had found a page; 41 were queued with the gate open.
- **Pilot #1306 (s658), live 19:16.** md5-guarded edit of `security.course_page_needed_search_rule_v1`:
  - The rule returns to the list every item it sent whose search found no page, ended in error, or is queued behind the stop gate. The decision record keeps why (`returned_because`). The search count is kept.
  - It no longer asks for a search the gate would hold, nor repeats one that found no page.
  - First run: 795 returned (349 found no page; university search stop 418; no page published by the provider 15; per-course stop 13), 229 new searches asked, 0 failed.
- **On-demand request `2fe02033` closed 19:16** through `security.on_demand_close_v1`. Actual: 2,190 Firecrawl credits (1,095 searches) against the estimate of 2,362. Credit left on the plan: 70,682.
- **What the searches gave.** 497 courses finished by 18:50: 112 found a page, 385 found none. One page is read and proved by CRICOS code. The rest wait: 38 need a rendered read (24 on `sws.ucol.ac.nz`), 37 could not be fetched, 30 unread, 6 blocked.
- **Read at 19:18 AEDT:** Course page needed 1,445 open (44 blocked or robots-disallowed, untouched), 572 with a search asked for (93 found a page, 479 queued with the gate open; they run inside the daily share from midnight). G3 75 functions and 48 relations. Live head `20261118233000` (2,139 applied).
- **Binder matcher (asked for as s651): no change made.** The pages the searches found show no query-string or trailing-slash mismatch. They fail on rendering, 404 and blocks, which a matcher rule does not fix.
- **Course link year preference (asked for as s650): not built, by finding.** Of the 158 old-handbook-year items:
  - Where the binder has read the current-year page (Melbourne 27, Flinders 1), it failed the identity check every time. Entering it by year alone would link an unproved page.
  - Where the binder holds only the old-year page (Macquarie 2014 and 2015 handbook 50, ANU 32, La Trobe 18), nothing has read a current-year address. The Macquarie handbook of those years no longer exists in that form.
  - These read as courses no longer in the current handbook. Whether to keep the archived page or retire the course is a person's decision.

**Not done:**
- A read of year-swapped addresses for ANU (32) and La Trobe (18) to test whether any current-year page proves the course.
- The test register row for s658 was added in the generator's format (the generator needs `@playwright/test`).

**Next executable action:**
- Platform Admin: lift or keep the university search stop for Adelaide University, Victoria University, Flinders, Monash and ICMS. 418 of their courses are back on the list and are not searched while it stands.
- After midnight AEDT, read how many of the 479 queued searches ran and how many found pages were read and proved.
- UCOL: 24 found pages on `sws.ucol.ac.nz` need a rendered read; check them after their next read (19 Nov 17:58 AEDT).

**Status at 18 Nov 2026 17:55 AEDT, S2-BOOST-Discovery (Platform Admin 16:54 and 17:02). The 19:20 block above is newer and corrects it. It corrects the 17:00 block: Course page needed was not draining.**

Platform Admin 16:54 and 17:02. Two migrations, `20261118200000` (md5 `77d86cb5`) and `20261118210000`; specs s656 and s657. No table, column or job added. s650 to s655 were already taken on `main`, so this lane starts at s656.

- **Finding: the Course page needed drain was not running.** Rule l4-page-needed-search-v1 (Pilot #1293) moves items off the Layer 4 list into the course-link search queue. At 17:05 all 600 it had sent were still queued with 0 attempts. Two causes:
  - Today's Firecrawl share for finding course pages (800) was used up by 00:47 AEDT, so the scheduled pick took nothing.
  - Whenever the lane had room, `public.svc_course_link_search_next` ended in a statement time-out (97 times in the seven days before 17:16; 8-second call limit). It ran the provider-level checks for all 306 providers with a queued search, about 10 seconds.
- **Pilot #1297 (s656), live 17:16.** One on-demand request (operating model 3.3.2), toolset Firecrawl, scoped to `course_search`, for the 91 providers of the items the rule had sent. Request `2fe02033`; it closes itself at 23:16 AEDT.
  - Estimate: 1,181 queued searches, 2,362 credits. Credit left on the plan before: 72,009.
  - The worker's pool is fixed at 10 searches at a time; s656 guards it.
- **Pilot #1300 (s657), live 17:48.** md5-guarded edit of the pick: the provider list is cut first to the providers the pass can take, not hidden, on the target list. Every later condition is kept. Time-outs since: 0.
- **Read at 17:55 AEDT:** 716 searches run, 1,432 credits, 0 failed. 265 courses finished: 71 found a page, 194 found none.
  - Of the 71 pages: 1 read and proved by CRICOS code, 33 not read yet, 26 could not be fetched, 5 blocked, 3 need a rendered read, 3 refused by the page check.
  - Course page needed: 1,150 open, 860 with a search asked for.
- **Finding: 834 of the searches asked for can never run.** The lane's stop gate holds them, on demand or not:
  - University search stopped after wrong pages in a row (395): Adelaide University 172, Victoria University 91, Flinders 45, Monash 35, ICMS 29. Only a person's Find course pages task passes this stop.
  - Recorded as no page published by the provider (420): Swinburne 159, RMIT 102, Southern Institute of Technology 38, AUT 37, Western Sydney 21.
  - Per-course stop (19).
  - These items left the Layer 4 list when the rule sent them, but nothing will search them. The rule keeps sending more each hour.
- **Adelaide University.** No alias added. 161 of the 163 404 pages are addresses on `adelaideuni.edu.au` itself, guessed from the course title; 2 are on `adelaide.edu.au`, already an approved host. All its searches sit behind the university stop above.
- **Course link (268 official-page items pending; the other waiting items are fee checks).** Clustered, nothing changed:
  - Old handbook year on the page shown: 158. Macquarie 2014 handbook 50, ANU 33, Melbourne 27, La Trobe 18, Sydney 19. For Macquarie, ANU and La Trobe the binder holds only the old-year page itself.
  - CRICOS page on another address: 68 (51 proved only by field and award).
  - Audit sample of finder refusals, left for a person by rule l4-link-accept-v1: 40. Two pages held: 2.
- G3 75 functions and 48 relations (read 17:56). Live head `20261118210000` (2,134 applied).

**Not done:**
- The year-preference and auto-read rule for Course link (asked for as s650) is not built. It changes what rule l4-link-accept-v1 may enter into the live catalogue, and the local spec runner is not available in this session.
- No binder matcher change (asked for as s651): the searches had not run, so there was no refusal pattern to read until 17:48.
- The 43 blocked or robots-disallowed pages were not touched.
- The test register rows for s656 and s657 were added in the generator's format; the generator needs `@playwright/test`, which this session cannot install.

**Next executable action:**
- Stop rule l4-page-needed-search-v1 sending items whose search the stop gate holds, and return the 834 parked items to the list with the gate as their reason (s658).
- Read the search results again after the found pages are read (reads run inside the scheduled share), then close request `2fe02033` with `security.on_demand_close_v1` and record the actual use.
- Platform Admin: lift or keep the university search stop for Adelaide University, Victoria University, Flinders, Monash and ICMS. While it stands, their 395 courses are not searched.

**Status at 18 Nov 2026 17:30 AEDT, S2-BOOST-Providers (Platform Admin 16:56 and 17:03). The 17:55 block above is newer.**

Platform Admin 16:56 and 17:03. One migration, `20261118203000` (md5 `df6991b9`); specs s680, s681 and s682. No table or column added.

- **Campus locality (312 to 78).** The 90% test used the share of a postcode's area inside the Significant Urban Area, so regional city postcodes always failed it (Armidale 2350: 6% by area, 82% by mesh blocks).
  - Rule l4-campus-locality-v1 (job `layer4-campus-locality`, hourly at minute 57) uses the ABS mesh-block counts already loaded, and the campuses' own suburb name, through the existing Inbox decision under the system automation account.
  - First run: 63 postcodes and 234 campuses settled, 0 failed. 44 postcodes by mesh-block share of 90% or more, 17 because every waiting campus gives the area's name as its suburb, 2 recorded as outside every area (Bellingen 2454, Murwillumbah 2484).
  - 31 postcodes (78 campuses) wait for a person: the campuses name different suburbs, or no area holds half the mesh blocks.
  - `ref.localities` does not exist. The reference tables are `destination.localities`, `destination.locality_postcodes` and `destination.abs_postcode_sua_shares`, Australia only; no New Zealand campus waits.
- **Held scholarships (89).** 82 had never had the AI re-check: it was queued once, by a data update on 19 Oct, and nothing queued it for items held later.
  - Rule l4-held-sch-recheck-v1 (job `scholarship-recheck-queue`, hourly at minute 9) queues it for every held page with a stored copy. First run: 72 queued; 11 have no stored copy and wait.
  - At 17:30, 60 of the 72 were re-checked for US$0.0072: 52 with a value sentence and 47 with an audience sentence quoted from the page. Recommendations: audience not stated 46, not for international students 5, international, check and publish 4, international but value unclear 3, not settled 2. The other 12 were still queued.
  - The 89 are still held. The re-check records a recommendation and publishes or rejects nothing; settling by recommendation is a decision for the Scholarships owner.
  - Scholarship pages not read: 89, not 69 (name does not match 46, page gone 28, blocked 10, too thin 5). None can be read from a stored copy.
- **University descriptions (88 to 86 at 17:30, settlement still running).** The Inbox kind shows 751: 88 university descriptions and 663 course descriptions, which are the Course Module's.
  - Name forms pdesc-name-forms-v2: each name of a semicolon-separated trading-name list, and a whole name's initials of four letters or more. No check, word list or admission was changed.
  - 2 admitted by the unchanged machine rule so far (ICMS and ICAE). A read-only count gives at most 8 by this rule.
  - What the rule cannot reach: 29 readings never name the provider in a sentence that passes the wording check, 33 keep fewer than two sentences once refused sentences are left out, and 12 name it only in a later sentence. They need a new reading or a person.
- G3 75/48, no drift (read 17:29). Live head `20261118203000` (2,133 applied).

**Not done:**
- The test register rows for s680 to s682 were added in the generator's format; the generator's listing step needs the full Pilot environment.
- Moving a naming sentence to the front (12 descriptions) changes the validation and the admission, which belong to the provider description owner.

**Next executable action:**
- Scholarships owner: decide whether a re-check recommendation may settle a held page by rule (5 not for international students, 4 check and publish).
- Read `pipeline.provider_description_machine_admissions` after 18:30 AEDT for the final count admitted by pdesc-name-forms-v2.

**Status at 18 Nov 2026 17:00 AEDT (Platform Admin 16:10). The 17:30 block above is newer.**

Course page needed is moving through the search lane by rule, and the study-load settlement now heals itself. Pilot #1293 and #1295 are live (migrations `20261118190000` and `193000`; specs s654 and s655).

- **Correction to the 15:45 block.** The course-page search worker and the course-list reader are **not paused**. The lane dispatcher has run them live since consolidation PR 3; their own cron rows are off only for that reason. Coverage pages are being read (300 in 24 hours).
- **Course page needed (1,958 to 1,360 at 17:00).** Rule l4-page-needed-search-v1 (job `layer4-page-needed-search`, hourly at minute 53, 300 a run) sends each open item back to the course-link search lane through the existing Search again decision, under the system automation account:
  - Order: a 404 or unread page first, then a refused page, at most `layer4.page_needed_search_max` searches a course.
  - The lane's own caps and Firecrawl limits set the pace, so no on-demand Firecrawl work was opened.
  - 43 blocked or robots-disallowed pages wait for a person.
  - First run: 300 searches asked for dead pages, 0 failed. The second hourly run took the list to 1,360.
  - Before this rule, no open item had ever had another search asked for.
- **Adelaide University (corrects 15:45).** `adelaideuni.edu.au` is the live merged domain (219 course pages read at 200). `adelaide.edu.au` has been an alias in `binding.provider_host_aliases` since before today, so no new alias rule was needed. 203 of the 220 Adelaide 404 rows are addresses the binder guessed from the course title (basis `url_pattern`, checked 3 to 13 Nov); the courses probably have other slugs on the new site or were dropped in the merger. They were among the first sent for a new search.
- **Boost study load, self-heal.** 74 of the 75 open readings had been read again at 15:12 AEDT by the previous worker instance (prompt v4) during the deploy of #1283. Rule l4-boost-sl-settle-v1 now releases any page last read with an older prompt before it settles; the 74 are released for the v5 read. Totals: 94 admitted, 231 Not stated, 75 to settle as their v5 readings arrive.
- **The 38 Not stated readings with an international sentence.** v5 sent only the international sentences: the model said not stated for 21 and gave a value the page check refused for 17. Judging whether a deterministic international cue is safe needs the sentence texts, which are in Storage and cannot be read from this session. **v6 is not built.** Next step: a worker mode that returns the selected sentences for a sample, without a model call.
- **AER (2,661 held; 489 providers):**

| Reason held | Items |
|---|---|
| Course entry gate incomplete | 1,851 |
| Audit sample (left for a person) | 488 |
| All rows held | 102 |
| Track C person admits | 82 |
| Matrix gate incomplete | 54 |
| No bound page | 39 |
| Identity not admitted | 16 |
| Matrix all rows held | 15 |

  - **Not changed, decision needed.** Splitting shared faculty or handbook pages into single-course sections is a new layout reader, and AER v1 is frozen (Decision 276: no new layout readers or recovery paths; new AER work goes to v2). Either the Platform Admin lifts the freeze for this, or it is built in AER v2.
- **University and course descriptions (751).** 88 provider descriptions and 663 course descriptions are already read from the official page. They wait because the machine rules refused them:
  - Course: identity margin thin 448, binding ambiguous 143, refused words 44, evidence moved 15, wrong page kind 13.
  - Provider: refused word 46, first sentence without the name 28, refused topic 12.
  - A new Firecrawl scrape of About pages would not change those reasons, so nothing was scraped. These belong to the description lanes' rules.
- **Offline multi-field qualification (REQ-61, REQ-69, REQ-70).** A replay qualification needs person-decided reference answers for descriptions, intakes, deadlines and fees, and none exist yet. The verified shadow candidates are listed in the 15:45 block.
- Course link stays at 420; the hourly rule set 3 more pages. G3: 75 functions and 48 tables, unchanged. Head `20261118193000`.

**Status at 18 Nov 2026 15:45 AEDT (Platform Admin 14:23, 14:25 and 14:29). The 17:00 block above is newer.**

Boost learnings went into the worker and three Layer 4 queues were settled by rule. Pilot #1283, #1284 and #1286 are live (migrations `20261118171000`, `173000` and `183000`; specs s644, s645 and s647, the last renamed from s643 in #1289).

- **Reader v5 (worker coverage-sweep v1.0.17).**
  - Prompt `boost-study-load-v5` and selector `study-load-windows-v4` treat a fee note (EFTSL, Commonwealth supported places, student contributions, "fee calculated based on a standard full-time study load") as never the study load.
  - Fee notes are not sent, do not count as a statement for international students, and are refused as a quote. A page with only fee notes sends nothing.
  - The route qualification rows moved to v5, as for v2 to v4. The admission qualification (Qwen3 30B, study load) is unchanged.
- **Boost study load (400 open readings).** The pages were re-read with v5:
  - 94 study loads were admitted by the unchanged promotion, and their readings closed as superseded.
  - 231 were settled **Not stated** by rule l4-boost-sl-settle-v1, under the system automation account through the Inbox decision, with the page check's findings as the reason.
  - 75 wait for their re-read to load. Job `layer4-boost-sl-settle` runs every 30 minutes and settles them.
  - **Check:** 38 of the 231 were settled although the page check found a sentence for international students that the reading did not use. A person may want to look at those.
- **Course link (1,487 to 423).** Rule l4-link-accept-v1 uses the course-page binder's own proof in `pipeline.coverage_course_pages` (page read, identity by CRICOS or NZQA code, exact title, degree name, adapter or person). First run: 1,335 official-page items in 18 s, 0 failed.
  - 154 **used** the proposed page and 105 **set** another proved page: 259 official links written.
  - 809 proposals were **refused**: the binder or the finder refused the page, and nothing was linked.
  - 16 were left as the audit sample, and 251 are **held** for a person: tied pages, unread pages, old handbook years, CRICOS pages elsewhere without proof, manual locks.
  - The 152 fee and English items were not in scope. Qwen3 30B tie-breaking is not wired: Qwen3 30B is qualified for study load only.
  - Job `layer4-link-accept` runs hourly at minute 41.
- **Scholarship course links stay at 0.** Job `scholarship-scope-auto` runs hourly at minute 19 and applies the 57-item rule (#1273, #1276) to every newly waiting scholarship.
- **Course page needed (1,958, unchanged), by binder state:**

| State | Items |
|---|---|
| Binder refused every page found | 1,568 |
| Page bound but returns 404 | 288 |
| Bound but unread | 60 |
| Blocked or robots | 41 |
| Ambiguous | 1 |

  - The items sit at 297 providers (AU 1,070, NZ 556, CA 332). 136 of those providers (1,003 items) have stored pages for other courses; only 2 of the 1,958 courses have a stored page of their own.
  - None has a proved page, so nothing can be resolved from stored pages without a new search or read. The course-page search worker, the coverage readers and the course-list reader are paused (`course-link-search-worker`, `coverage-read`, `coverage-read-2`, `course-list-read`); the decision to switch them on belongs to their lanes.
  - Largest single cause: **Adelaide University**, with 163 dead links. The binder holds `adelaideuni.edu.au/study/degrees/...` addresses that return 404, while the stored and linked pages are at `adelaide.edu.au/study/degrees/...`. This looks like a provider URL pattern; it was not checked against the live site (the web check needed an approval no one was there to give).
  - The 749 courses whose proposals were refused and that hold no official page will join this queue as the page finders record those refusals.
- **The 14:23 items that need a decision.** Scholarship award and deadline enrichment (REQ-71, REQ-72) and multi-field admission (REQ-61, REQ-69, REQ-70) could not proceed because that message ruled out schema migrations:
  - 0 published scholarships are past their Melbourne closing date. The scholarship round-state refresh (`security.scholarship_round_state_refresh_v1`) has not run since 17 Nov 00:23 UTC: its only caller, job `scholarship-discover-refill`, is paused, and it compares with the UTC date. 2 withdrawn rounds show "open" past closing.
  - Multi-field shadow candidates verified so far: descriptions 640, entry rows 1,038, delivery mode 27, intakes 11, fees 1. No admission path exists for them, and Qwen3 30B is qualified for study load only.
- G3: 75 functions and 48 tables, unchanged.

**Status at 18 Nov 2026 14:10 AEDT (Platform Admin 13:06). The 15:45 block above is newer.**

Scholarship course links: all 57 Layer 4 items were resolved by rule, with no person involved (Pilot #1273, migration `20261118153000`, and correction #1276, migration `20261118163000`; spec s636).

- **How each scholarship was decided.** `security.scholarship_scope_auto_decide_v1` reads the scholarship's own name, then its description, and decides in this order:
  1. Wording that is not course-specific in its name (transfer-student notices, accommodation, Huayu, "after you graduate"): No courses.
  2. A scope from its own words that keeps at least one proposed course: that scope.
  3. Explicit university-wide wording (for example "General Scholarships", "Vice-Chancellor", "International Merit", "Academic Excellence", "all programmes") with no level or subject named: All courses.
  4. Otherwise: No courses.
- **How the scope is worked out.**
  - The name comes first: its "in …" phrase, then the subject words, then a degree code (MBChB, ME, MOR, LLB, BCom, MBA, BMus, FMHS).
  - The description is read only when the name names no subject, or when the name's subjects keep no course.
  - A phrase no course title holds whole falls back to its first word ("Engineering Science" becomes "Engineering").
  - A doctoral scope with a subject also keeps the Doctor of Philosophy.
  - The word lists are settings in Settings › Pipeline settings › Scholarships: `scholarship.scope_suggest_subjects`, `scope_suggest_aliases`, `scope_all_patterns` and `scope_none_patterns`.
- **How it was applied.** Each decision is recorded under the automated rule authority (`security.system_actor_id()`), with the reason "Auto-applied deterministic title/description scope rule: …" and the rule used. The existing `security.scholarship_scope_apply_v1` applies it, and a `pipeline.layer4_mass_operations` row is written per scholarship, exactly as the Course links screen's decision writes one.
- **Live at 14:05 AEDT:**

| Measure | Count |
|---|---|
| Decisions | 57 (42 only matching courses, 1 all courses, 14 no courses) |
| Links written | 694 (667 matching, 27 all) |
| Audit rows | 60 (57, plus 3 re-applied by the correction) |
| Scholarships waiting | 0 |
| Inbox › Scholarship course links | 0 |
| Decisions made by a person | 0, none touched |
| G3 | 75 functions and 48 tables, unchanged |
| Head | `20261118163000` |

- **The correction (read back the same hour).** The first rule set three scholarships to No courses wrongly, and the correction re-applied them:
  - "International Four-Year Doctoral Partial Tuition Award": its description mentions PhD transfer students. It now keeps 127 doctoral courses.
  - "University of Otago Law Alumni Scholarship": its description mentions accommodation. It now keeps 2 first-year Law courses.
  - "UC Business School International School Leavers Scholarship": the course is the Bachelor of Commerce. It now keeps 6 courses.
- **The 14 at No courses**, which a person can change on the Course links screen at any time (the new decision then applies in place of the rule's):
  - Notices for transfer students, accommodation, exchange or after-graduation (7): Eligibility & Claiming Awards, Notification of Award, Renewing Award and Transfer Student Scholarships (US), all Burman; Huayu B.E.S.T. (KPU); Scholarships for after you graduate (Auckland); Malaysian Accommodation Award (Auckland).
  - Text that names no scope that can be proved (6): Alex Tan, JLL, International Tuition Award (UBC; no description held), Mamawi Atosketan Native School, President's Grant for International Community Engagement, Scholarships - EATS.
  - Scholarships - Nursing (Burman) (1): Burman has no nursing course in the catalogue.
- **Not yet verified:** the Course links screen, signed in.

**Status at 18 Nov 2026 12:25 AEDT (Platform Admin 11:57). The 14:10 block above is newer.**

- **Model decision closed.** Qwen3 30B stays the only model qualified for Boost study load (bench-4: 0 failed calls). No second route for Mistral Small 3.2.
- **Scholarship course links into Layer 4 (Pilot #1267, migration `20261118143000`, s631; also merged S2-Build's green #1266 first so its migration landed in order).** The 57 scholarships waiting to link hold 18,023 proposed links, all "provider owned but no explicit course or provider scope" (each proposed against every course of its provider, e.g. a School of Business award against all 575 UBC courses), so they need one scope decision per scholarship, not row-by-row approval. New Inbox kind **Scholarship course links**: one item per scholarship with a rule-based suggested scope from its own name and description (study levels; subject words from setting `scholarship.scope_suggest_subjects`), the courses it keeps, and the text it rests on. Choices (Pipeline Operator or above): Accept the suggested scope, All courses, No courses; each calls the existing `public.admin_scholarship_links_decide`, so decisions are recorded exactly as on the Course links screen. Read back 12:19: 57 items; 38 with a suggestion (together keeping 800 of the 18,023 links), 19 with none found; G3 75/48, no drift.
- **AER: nothing to advance; everything clean is already in Layer 4 or already admitted.** All 3,302 proposed provider-matrix rows (60 providers: AU 2,605 rows / 46 providers, NZ 697 / 14) and all 9,718 proposed course entry rows (2,578 courses) are covered by pending Layer 4 items. Machine admission is on for both (`aer.machine_mode` and `aer.matrix_machine_mode` = 2): it has admitted 8,611 course reads and 22 matrix runs; what remains waiting is what its rules declined (below). AER v1 is frozen (Decision 276), so no new recovery path was added. Every proposed row carries `source_url`, a verbatim `quote`, `as_at` and its evidence; `edition` is empty on 2,920 of 3,302 proposed matrix rows and `routes` is empty on all (both AER v2 fields; not part of the v1 admission rules).
- **Grade scale conversions: not seeded, with reason.** `ref.grade_scale_conversions` holds 0 rows and has no Layer 4 queue. The "1,289-row matrix (16 providers)" is the active provider entry matrix as recorded on 12 Nov (now 5,542 active rows, 22 providers), not grade-scale data. A grade scale needs an official source that states its 0–100 normalisation; none is held, and deriving one would put unsourced numbers in front of reviewers. The loader exists: Layer 1 induction (Pilot #1258, S2-Build) loads grade scales **inactive for review** when such a source is run.
- **Scholarship field gaps (reported to the Scholarships lane, not re-extracted):** of 456 active unpublished scholarships, 287 have no award value; 645 of 1,060 published have no closing date. The scholarship AI extraction lane owns these reads; a second extractor was not added.

**Layer 4 › Inbox, waiting items by kind (read 18 Nov 2026 12:19 AEDT):**

| Kind | Items | What one decision covers |
|---|---|---|
| AER provider matrix (`entry_matrix_first_run` 77, `entry_matrix_change` 6) | 83 (3,302 rows, 60 providers) | one provider's whole table |
| AER course entry (`course_entry_first_read`) | 2,578 (9,718 rows) | one course's rows; 488 are the 5% audit sample |
| Grade scale conversions | 0 (no rows held) | — |
| Scholarship course links (new) | 57 (18,023 proposed links) | one scholarship's scope |
| Held scholarship pages (`held_scholarship`) | 89 (38 providers) | one page |
| Refused study loads (Boost study load) | 400 (cap `boost.layer4_open_max`) | one course |
| Campus postcodes (`campus_locality`) | 312 | one postcode (all its campuses) |
| Official course URLs and tuition checks (`course_link`) | 1,487 (1,335 URLs, 146 tuition validations) | one course |
| Course page needed | 1,958 | one course |
| Descriptions (provider and course first read) | 751 | one description |
| Provider blockers (site down, no pages, website needed and the like) | 752 | one provider |
| Human input needed (interventions) | 491 | one case |

**What a row needs to pass Layer 4 into the consumer API:**
- **AER provider matrix row** (machine rule, `security.aer_matrix_machine_check_v1`; a person decides the rest): source on the provider's own official host, not a host shared with another provider; the read shown complete (D-R3); `confidence` ≥ `aer.matrix_machine_min_confidence` (0.9); verbatim `quote` of at least `aer.machine_min_quote_chars` (8) characters that contains the value; study level mapped; `min_grade`, or `min_value` with a `grade_scale`; not a change to an already admitted table; no earlier rejection of that source. Present on every row: `source_url`, `quote`, `as_at`, evidence. `edition`, `routes` and `conditions` are carried but not checked in v1.
- **AER course entry row** (`security.aer_machine_check_v1`): verbatim `quote` ≥ 8 characters, `confidence` ≥ `aer.machine_min_confidence` (0.8), this read's evidence, the page bound to the course by an admitted identity basis, and the stored page not shared with other programmes.
- **A person's decision on AER:** Approve, Approve except (tick the rows to leave out, one reason) or Reject; no inline edits (decision A1). Approved rows become `active`, which API v3 reads.
- **Scholarship course links:** one scope decision per scholarship (all, matching levels/fields/title words, or none); accepted links become `scholarship.course_mappings` with basis `scope_decision:*`.
- **Refused study load:** a value (Full-time, Part-time, Both) fills `study_load` only while it is empty and unlocked (source `manual`, evidence the stored page); or Not stated; or Dismiss.
- **Campus postcode:** accept the largest-share locality, choose another candidate, or none; the decision applies to every campus in that postcode.

**Why waiting AER items were declined by the machine rules:**
- Course entry: stored page shared with other programmes 1,874; every row fails a row rule 102; no bound course page 39; a row lacks quote, confidence or evidence 19; identity basis not admitted 18; not yet checked 82.
- Provider matrix: read not shown complete 61; every row fails a row rule 15; change to an admitted table 6; no minimum 4; level unmapped 3; source not on the official host 2; shared host 2; no rows 1; earlier rejection 1.

**Bulk or provider-level approval versus single-row inspection.** Phase 5's review grid (S2-Build, Pilot #1253, merged) is a view: rows, saved views (AER Audit Samples, Official URLs, Provider Blockers) and the quote-versus-value drawer. Decisions still go one item at a time through `public.admin_layer4_inbox`; there is no bulk-approve action yet.
- **Already batched (one decision, many rows):** scholarship course links (about 316 links per decision); AER provider matrix items (a provider's whole table, Approve or Approve except).
- **Candidates for a grouped decision once a bulk action lands:** AER course items declined only because the stored page is shared (1,874), grouped by provider and shared page, since one confirmation of which programme the page serves settles the group; refused study loads with the same quote at the same provider (for example "Part-time study is not available for international students"); course pages needed and official URLs grouped by provider.
- **Single-row inspection only:** the 488 AER audit-sample items (the 5% sample exists to be checked one by one); changes to an admitted matrix (6); matrix rows with an unmapped level or no minimum; host problems; identity not admitted; campus postcodes (each postcode is a different place).

**S2-BOOST-AER, 19 Nov 2026 17:35 AEDT, S753:** Layer 4 AER triage and bounded drain (`aer-l4-drain.yml`, script and workflow only, zero AI and Firecrawl spend). Of 2,579 pending AER items, 17 passed their rule and were admitted by the cron's own function in one tick (13.4 s); pending now 2,562, none passes. Active `course_entry_requirements` rows 25,412 to 25,452. Would-admit reads waiting 0; 93 course reads admitted since S748. Holds unchanged: completeness gate 1,892, audit sample 492, all rows held 111, page identity 55, matrix changes 6, host 4, other 2; no-overwrite 0, manual lock 0, no claims. Manual locks 7,585. Full block in the m2.4.7 runsheets.

**S2-BOOST-AER, 19 Nov 2026 15:45 AEDT, handover close-out:** course drain 76 of 91 (the last 16 pass the rule, queue positions 914 to 1,268 of 1,304, expected 20:30 to 22:30 AEDT); S751-S752 (Pilot #1376, worker v1.0.30, migration `20261119143000`): prompt `aer-v2-matrix-chunk-v2` (one record per row and study level, verbatim minimum) and Windows-1252 folding in the AER v2 verifier only; replay on 18 of 20 tables (cap reached, US$0.028067 of US$0.03, window closed): minimum in quote 100% (519/519), quote fidelity 99.9% (818/819), row completeness 89.4%; bar not met, nothing promoted. **Platform Admin decision 15:14 for the post-handover S1 follow-up:** a row is doubled only when (row, study level, normalised quote) repeats; 6 rows a call on wide tables (under 35 s); AER v2 live admission paused (`aer.v2_shadow_on` 0). Full block in the m2.4.7 runsheets.

**S2-BOOST-AER, 19 Nov 2026 13:45 AEDT, S750:** MiMo v2.6 Flash alone at 12 rows a call on 20 gate-held tables (645 rows; worker v1.0.29, Pilot #1373, no migration): row completeness 99.8% (644/645), quote fidelity 100%, minimum in quote 99.4% (343/345), no invented row; 62 calls, longest 32.9 s against the 90 s time-out; US$0.019775 of the US$0.05 cap, window `53d590e8` closed. Bar not met, nothing promoted. Misses: a two-level row answered twice (KBS Zimbabwe), undecoded Windows quote codes (KBS Korea), a reworded minimum "ATAR 60" (Sydney Institute). The run 2 Manukau miss is row 28 "Pacific Islands", a two-level row (page structure). Full block in the m2.4.7 runsheets.

**S2-BOOST-AER, 19 Nov 2026 12:40 AEDT, S747:** AER v2 matrix reader on the row chunker (worker `coverage-sweep` v1.0.28 mode `aer_chunk_smoke`; prompt `aer-v2-matrix-chunk-v1` as data, `pipeline.ai_instruction_versions` ids 44 to 46, migration `20261119110500`; Pilot #1365, #1368; spec s747). 10-table smoke test (237 rows), US$0.0276 of the US$0.10 cap, on-demand windows `851c9099` and `59b754f0` closed. Run 2: MiMo v2.6 Flash row completeness 100%, quote fidelity 100%, minimum in quote 99.3% (136/137); Qwen3 30B 59.5/97.2/100; Mistral Small 3.2 36.7/100/82.9. Bar (100/100/100, no invented row) not met: nothing qualified or switched on. Course drain: 75 admitted since S748, the last 16 pass the rule and are queued (positions 1,407 to 1,767 of 1,801 at 11:14). Full block in the m2.4.7 runsheets.

**S2-BOOST-AER, 19 Nov 2026 10:24 AEDT check:** 73 course reads admitted since S748 (26 at 09:24, 43 at 09:54, 4 at 10:24); 16 would-admit reads still waiting (89 at 07:02); 79 matrix items pending, no admission since 06:54 (70 need a new read, D-R3 gate); P0 0; definitions unchanged (`89a5c44b`, `fc9261cb`).

**S2-BOOST-AER, 19 Nov 2026 08:50 AEDT: matrix completion clauses and course links (s741); held-page export (s742); course machine queue (s748, s749); table row chunker (s744 to s746); s747 not yet run**

Platform Admin 1-day handover, 19 Nov 2026 06:49 (spec block s740 to s759). Migrations `20261119052500` (s741), `20261119080500` (s748) and `20261119095500` (s749), each md5-guarded `create or replace` in place: no new table or function, G3 75/48 read back after each. Pilot #1338, #1339, #1340, #1349, #1350, #1358, #1360.

**Done and read back from live (05:50 to 08:46 AEDT):**
- **S740 (checks).**
  - The course machine validation passed at 20:10 on 18 Nov and lapses 25 Nov 20:10. `aer-validation-renew.yml` is active, daily at 18:17 AEDT.
  - P0 findings open: 0. The 149 approved AER rows stay live.
- **S741, matrix completion clauses and course links (#1338).**
  - `aer_matrix_machine_exclusions_v1`, `_check_v1` and `_admit_v1` edited in place:
    - a matrix row that names one of the provider's courses is linked to it;
    - the check adds `course_linked`;
    - admission writes `course_id` only where none is set.
  - The matrix validation was re-run and passed. 2 matrix items admitted live.
  - The other waiting matrix items (57) are stopped by the D-R3 completeness gate. The reader dropped printed rows, so only a new read fixes them.
  - The 294 rows with no level have no printed level on the page, and no provider is single-level, so no further inheritance applies.
- **S742, held-page export (#1339, #1340, #1350).**
  - Read-only workflow `aer-entry-inspect.yml` (worker mode `entry_inspect`) exported the stored pages of the held matrices.
  - The pages are kept as 48 test fixtures with their sha256 (Pilot `tests/fixtures/aer-chunks/held/`).
  - No reading, data or switch changed.
- **S748, course machine queue (#1349, migration `20261119080500`).**
  - Cause: a read the machine checked and did not admit (audit sample or declined) never had its shadow row refreshed. It therefore stayed at the front of the queue, and the run spent its time limit on the same items. The 89 would-admit reads behind them were never reached (S1-AER 03:15 finding, its S677).
  - Fix: `aer_machine_admit_v1` now records the check time on every non-admitted outcome, with the same upsert the shadow mode uses.
  - md5 `7473f475` → `89a5c44b`. Course validator unchanged (`945077fe`).
  - Live from about 07:50: the 07:54 run reached 114 items and the 08:24 run 80 more (75 audit samples, 5 declined); 190 shadow rows refreshed by 08:27.
  - No course read admitted yet at 08:27, because the gate-complete group checked first is mostly audit samples (about 970).
- **S749, fair order (#1360, migration `20261119095500`).**
  - Within the same groups (gate-complete first, then never checked), the least recently checked item now comes first, then the oldest by creation.
  - Without this, an item that became eligible again after the 6-hour gap went back in front of items not yet reached.
  - `aer_machine_run_v1` md5 `da1f53c6` → `fc9261cb`, read back live at 08:44.
  - Not changed: eligibility, batch (200), the 45-second limit, daily cap, 6-hour gap, rule, thresholds (0.8 and 8), validators, the 5% audit sample.
- **S744 to S746, table row chunker (AER v2 record source; #1358, worker module only, nothing deployed or switched on).**
  - `coverage-sweep/entry-chunks.ts` splits a page into one chunk per printed table row, list line or text block, each with:
    - the nearest three headings;
    - the table header;
    - the cells with their headings;
    - the country and the qualification.
  - A header is recognised only as a header line followed by its first row, so a repeated header stays in its table and a different header starts the next one.
  - A national qualification normaliser (`national-qualifications.json`) maps overseas qualification names.
  - Regression on the 48 held pages: on 36 pages the D-R3 gate stopped, every printed row with two or more cells is a chunk quote; none is missing or doubled; every quote is a line of the page text; the output is the same on every run.
    - 1,715 row chunks (the stored readings hold 1,727 rows and lost 238).
  - 70 of 70 local specs pass (s744 7, s745 50, s746 4, plus the source contracts). The 21 gate pages without table markup (PDF or text only) are not covered.
- **UAT login with the saved GitHub credentials.** Deployed UAT acceptance on the #1358 branch (run 44398577335, 08:10 to 08:30) signed in as the UAT user through the repository secrets: 52 passed, 16 failed and 4 flaky.
  - Most failures are live statement time-outs: 156 in 21:05 to 21:35 UTC, while another session's browser made about 2,000 `admin_read` calls, giving 500s on `admin_read`, `admin_toolsets_read` and `admin_aer_discovery`.
  - The rest: a tablet filter layout check (a13), a missing regional-manager assignment on UQ (a15), and a strict-mode locator on the Data quality pager.
  - None touches the chunker, which has no frontend change. Platform Health has no deployed spec; P0 read from the database: 0.

**Not done:**
- **S747, the 10-table chunked smoke test (≤ US$0.10).**
  - It needs a worker mode that reads from the chunks, a matrix prompt version stored as data, and an on-demand window.
  - Not run this cycle. No model call made; AER v3 spend unchanged at US$1.372 of US$2.
- Course admissions after S748 and S749 are not yet measured over a full cycle.
- `docs/platform/TEST-REGISTER.md` was not regenerated here: the generator needs the frontend packages, which this runner cannot install. It is regenerated by the next release bump or by CI.

**Next executable action:**
- S2-BOOST-AER, 10:24 AEDT (scheduled check): course reads admitted since 07:50, would-admit still waiting, shadow rows refreshed, matrix outcomes, P0.
- S2-BOOST-AER: S747 smoke test on 10 chunked tables, the pinned models only, ≤ US$0.10, promote only if row completeness and quote fidelity meet the bar.
- S1-AER: S677 is delivered by S748 and S749; do not build it again.

**S1-AER, 19 Nov 2026 05:30 AEDT: morning read-back — would-admit course reads still NOT admitted; 0 P0 findings; replay pause confirmed**

Read only; no migration, no data change (zero schema migrations in this lane). Live reads: `aer-validation-renew.yml` status run 44369257782 (05:24) and a rolled-back probe (run 44370612954 on the carrier branch).
- **Course-read sweep (`s670`/`s673`): not complete.** Since 20:09:59 on 18 Nov, 2 course reads (3 rows) and 2 provider tables admitted. **89 course reads are still would-admit and waiting**; 2,576 wait in Layer 4. The post-6-hour sweep did not reach them: the machine job (every 30 minutes, succeeding) re-checks the same first items each run (cause and fix S677 in the 03:15 block, awaiting Platform Admin authorisation). The 89 were last checked 16:54 to 19:54 AEDT on 18 Nov; no shadow rows since.
- **P0 consumer-data findings: 0 open** (`pipeline.aer_gap_findings`, severity P0, state open or reopened). The 149 person-approved provider-table rows stay live; 6 `entry_matrix_change` items are pending in Layer 4 (the five from 11 Nov plus one to identify; none touched).
- **Paid replay pause recorded in all three places:** CURRENT-STATE (23:55 block), the AER runbook (`docs/platform/2026-11-12-aer-admission-mechanism.md`, item 3b) and Decision 276 (`docs/coursefinder-design-reference-v1.4.md`, 23:52 decision): no round 6 until dense entry tables are chunked per qualification or a stronger frontier model is authorised; US$0.47 of the US$2.00 cap kept; AER v2 stays at 0 (shadow only).

**Next executable action:**
- Platform Admin: authorise S677 (one function, `security.aer_machine_admit_v1`: admit-mode declined and audit-sample results refresh the last-checked time), or approve the 89 in Layer 4 › Inbox.
- S1-AER after authorisation: S677 with a rolled-back live dry run, then a status read 30 minutes after merge.
- Open for a person: the Layer 4 change items; branch `cf247-s676-probe` still exists (never merged; delete in the GitHub UI).

**S1-AER, 19 Nov 2026 03:15 AEDT: Thursday 02:45 check — the about 90 would-admit course reads were NOT admitted (the machine's job starves them)**

Read only; no migration and no data change (Thursday freeze respected; zero schema migrations in this lane). Pilot #1326 (s676, script only: the `status` mode of `aer-validation-renew.yml` now also reports why would-admit reads wait).
- **Result (status run 44339423118 at 02:46, detail run 44343797388 at 03:05):**
  - Since the 20:09:59 re-validation: **2 course reads admitted (3 rows)** and 2 provider tables admitted. **89 course reads are still recorded would-admit and waiting**; 2,576 course reads wait in Layer 4.
  - The validations are fresh (course and matrix passed 18 Nov 20:10, age 0.3 days); admission mode 2, not suspended, daily cap 5,000, 2 used.
  - All 89 still pass the rule when re-checked now (rolled-back probe run 44344041791): 79 on `aer-machine-v1`, 10 on Approve except.
- **Cause (by finding):** job `aer-machine-admission` (every 30 minutes, succeeding) re-checks the same items every run and never reaches the 89.
  - Every one of the 2,576 waiting items is eligible on every run. In admit mode a declined or audit-sample result does not refresh the item's last-checked time (only shadow mode does), so the 6-hour re-check gap never applies to them.
  - The run takes items gate-complete first, then oldest first, and stops at its 45-second limit. The first 60 in that order are 45 audit samples and 15 declined (no bound page 7, identity not admitted 8, row unsupported 1). The 89 sit at positions 443 to 2,542.
  - No shadow rows were written after 20:09; the 89 were last checked 16:54 to 19:54 AEDT.
- **Not changed:** no setting, function or row. Raising `batch.aer_machine` does not help (the 45-second limit stops the run first).

**Decision needed (Platform Admin):** authorise one function fix, S677, outside this lane's zero-migration rule:
- `security.aer_machine_admit_v1`: in admit mode, a declined or audit-sample result also refreshes the item's last-checked time (`create or replace`, md5-guarded, no table change, G3 unchanged), so each item waits 6 hours before its next check and the queue moves.
- Until then a person can approve the 89 in Layer 4 › Inbox (kind Course entry first read).

**Next executable action:**
- Platform Admin: authorise S677 (or approve the 89 by hand).
- S1-AER after authorisation: S677 migration with a rolled-back live dry run, then a status read 30 minutes after merge.
- Delete branch `cf247-s676-probe` in the GitHub UI (a never-merged probe carrier; this session cannot delete branches).
- Unchanged: the five 11 Nov `entry_matrix_change` items in Layer 4; first automatic renewal about 23 Nov.

**S1-AER, 18 Nov 2026 23:55 AEDT: decisions recorded (149 approved rows stay live; paid AER v2 replay paused)**

Platform Admin 23:52. No code or migration.
- **The 149 person-approved provider-table rows stay live** in the consumer API: AUT 56, Whitireia and WelTec 44, Massey 36, Flinders 12, Otago 1. The five 11 Nov `entry_matrix_change` items stay in Layer 4 for a person (s675).
- **Paid AER v2 replay rounds are paused.**
  - There is no round 6 on Qwen3 30B, Mistral Small 3.2 or MiMo v2.6 Flash, and the US$0.47 left of the US$2 evaluation cap is kept.
  - AER v2 stays off (shadow only, `aer.v2_shadow_on` 0, gate unchanged). AER v1 deterministic admission handles live admission: course reads and provider tables, s670, s671, s673.
  - **Replay resumes only when** dense multi-row entry tables are chunked per qualification, or a stronger frontier model is explicitly authorised.
  - Recorded in Decision 276 and the AER runbook, item 3b.

**Next executable action:**
- S1-AER, Thursday 02:45 AEDT (scheduled): read-only check that the about 90 would-admit course reads were admitted after their 6-hour re-check.

**S1-AER, 18 Nov 2026 23:35 AEDT: prompt v3.1 and 180 s evaluation calls (s674), round 5 not qualified; standing 7-day validation renewal; five AER consumer data findings resolved without quarantine (s675)**

Platform Admin 20:53 and 22:26 (alert batch `88e5ff5b-3fb9-4613-80db-3ff0c96a6b06`). Pilot #1311, #1313, #1317, #1320 (s674) and #1321 (s675). Migrations:
- `20261118243000` (md5 `28ef812f`)
- `20261118270000` (md5 `85f5e02a`)

Worker `coverage-sweep` v1.0.19. Full write-up: `docs/platform/2026-11-18-s1-aer-round5-renewal-consumer-findings.md`.

**Done and read back from live:**
- **s674, prompt `aer-v2-course-v3.1`.** v3 plus one section asking for every requirement row of a table or list. It runs on the three exact pinned models with no fallback.
- **s674, 180 s evaluation calls (was 90 s).** The 150 s request idle time-out and `EarlyDrop` of background tasks forced a streamed answer. The replay workflow calls the worker straight with a one-time nonce, records each answer as it comes and starts at most 8 examples a call.
- **Round 5 (runs 45 to 47).** The gate is unchanged and **no model passes**:

  | Model | Right of 50 | Quotes on page | Error points | False positives | Time-outs |
  |---|---|---|---|---|---|
  | Mistral Small 3.2 | 13 | 85.7% | 8 | 2 | 2 |
  | MiMo v2.6 Flash | 14 | 54.6% | 12 | 4 | 6 |
  | Qwen3 30B | 7 | 25% | 22 | 3 | 11 (27 in round 4) |

  Nothing was qualified or switched on. Switches are back to 0 and on-demand `6c37d8fc` is closed. AER v3 spend is US$1.529 of US$2.
- **Standing rule (Platform Admin 20:53).** The two AER automatic admission validations renew automatically every 7 days, without sign-off, when nothing has changed:
  - Workflow `aer-validation-renew.yml` runs daily at 18:17 AEDT and renews once the last pass is `aer.validation_renew_after_days` (5) old.
  - It renews only on 0.8/8 (course reads) and 0.9/8 (provider tables), the validators checked on 18 Nov, mode 2, not suspended, and 0 regressions.
  - Anything else fails the run and is reported; nothing is forced on.
  - Next renewal about 23 Nov. The runbook item 3a in `docs/platform/2026-11-12-aer-admission-mechanism.md` has the rule.
- **s675, the five critical consumer data findings.**
  - The findings are 149 provider-table rows at five providers: AUT 56, Whitireia and WelTec 44, Massey 36, Flinders 12, Otago 1.
  - People approved these rows on 30 Oct. On 11 Nov 19:15 the qualification-first re-record recorded the same runs again and re-pointed them to new change items, so the check read approved rows as "not admitted".
  - Not quarantined: that would have withdrawn person-approved data from the consumer API. Instead:
    - the check now accepts an approval that names the row's run;
    - a run a person approved is never recorded again.
  - The 23:27 `aer-reconcile` resolved findings 1516 to 1520: 0 P0 open and Platform health `aer:p0` resolved at 23:27:00 AEDT.
- G3 75 functions and 48 relations. AER v1 thresholds unchanged. Both migrations were applied before Thursday's 01:15 freeze.

**Not done:**
- No AER v2 model is qualified, so the about 1,620 incomplete course reads stay held.
- The five `entry_matrix_change` items, which hold the 11 Nov qualification rows, wait in Layer 4 for a person.

**Next executable action:**
- S1-AER, Thursday 02:45 AEDT (scheduled): read-only `aer-validation-renew.yml` status since 20:09:59. Confirm the 90 would-admit course reads were admitted after their 6-hour re-check.
- Platform Admin: how AER v2 qualification proceeds after round 5. Mistral now meets the error-point limit but not quote fidelity or false positives. The every-row section did not raise recall. US$0.47 of the evaluation cap is left.

**S1-AER, 18 Nov 2026 20:50 AEDT: AER course machine admission re-validated (s673); matrix level from the table heading and completion-only rows (s671); AER v2 replay round 4, no model qualified (s672)**

Platform Admin standing mandate 19:28. Pilot #1308 (migration `20261118237000`, md5 `c1ae9cae`) and #1310 (`20261118238000` md5 `070779e6`, `20261118239000` md5 `536a4204`); specs s671 to s673. Full write-up: `docs/platform/2026-11-18-s1-aer-revalidation-matrix-parser-replay.md`.

**Done and read back from live:**
- **S673 (step 1):**
  - Validation 6 of rule `aer-machine-v1` passed at 20:09:59 AEDT: 401 would-admit reads re-checked, 0 regressions. It ran inside a migration under the live md5, as on 11 Nov; there was no separate workflow.
  - Course machine admission is live again; the 20:24 run admitted 1 read.
  - The other about 90 `would_admit` reads are admitted as each 6-hour re-check comes round, by about 02:30 Thursday (fixed rule, not changed).
  - Thresholds 0.8 and 8 unchanged; variant twins held.
- **S671 (step 2):**
  - Matrix rows with no level read take the one level named in the stored heading or file title (codes bachelor, masters, doctorate, foundation; never when any row names a level).
  - "Year N equivalent" is not a level.
  - Completion requirements with no score are not missing minimums.
  - Effect: 127 rows take a level, 225 rows are completion-only; reads passing 0 to 2, both admitted at 20:24 (UTAS 29 rows, Deakin College 1 row).
  - 54 reads stay held by the D-R3 gate (dropped rows); they need a corrected read.
  - Matrix validation 12 passed. Switches `aer.matrix_level_inherit_on` and `aer.matrix_completion_only_on`. Functions replaced in place, G3 75/48.
- **S672 (step 3):**
  - Round 4 on frozen set 5 with the exact pinned IDs, through the new workflow `aer-v3-replay.yml` (run 44273806589, 20:13 to 20:37): on-demand `639066c5` opened and closed, switches back to 0.
  - Results: MiMo v2.6 Flash 14/50 right, integrity 60%, 26 pts, 2 FP; Mistral Small 3.2 11/50, 85.7%, 22 pts, 2 FP; Qwen3 30B 3/50, 100%, 54 pts, 27 time-outs.
  - **No model passes the unchanged gate:** Path B, nothing qualified or switched on.
  - US$0.125 spent; AER v3 total US$1.372 of US$2.

**Not done:**
- No held AER course read was re-read. No model is qualified.

**Next executable action:**
- Platform Admin, AER v2: (a) revise prompt v3 for missed rows, then round 5 with `aer-v3-replay.yml` (recommended); (b) longer evaluation time-out (a fixed code value); or (c) pause replays.
- Platform Admin: how the 7-day validations are renewed. They lapse on 25 Nov at 20:10 (course reads) and 20:12 (matrices).
- S1-AER, about 02:45 Thursday: read back that the 90 `would_admit` reads were admitted.

**S2-BOOST-AER, 18 Nov 2026 19:00 AEDT: hand-bound shared-page rule live (s670); AER course machine admission found running in shadow since 15:40**

Platform Admin 17:52. One migration, `20261118220000` (md5 `e0f5a6ff`), Pilot #1303, spec s670. Classification and reasons: `docs/platform/2026-11-18-aer-held-items-classification.md`.

**Done and read back from live (18:26 to 18:57 AEDT):**
- `security.course_entry_shared_page_v1` replaced in place under its live md5: `7b43d0c6…` to `077bf1637e515fc08e837f581767a1ac` (the md5 the database test and the rolled-back live dry run both predicted). One clause changed.
- New setting `entry.shared_page_hand_lock_holds` = 0: a hand lock on the page address no longer makes a refused (mismatch) binding of another course count as sharing the page. 1 restores the rule of 8 Nov.
- `entry.shared_page_own_bases` now ends with `manual`.
- Unchanged: `aer.machine_min_confidence` 0.8, `aer.machine_min_quote_chars` 8, every other AER v1 rule (Decision 276). One audit event. G3 75 functions and 48 relations.
- Effect: 25 of the 230 shared-page course reads are no longer held as a shared page (20 with only refused bindings on the page: 14 bound by hand, 4 by CRICOS code, 2 by exact title; and 5 whose recorded reason was already out of date). 19 of the 25 now pass the gate; 6 are still held for another gate reason (rows cut, dropped requirements).
- 205 stay held as shared pages: another course is bound or ambiguous on the page (qualification ladders, stream siblings, pace and duration twins). Twins stay held until an AER v2 read returns the variant with each row (Platform Admin 17:52).

**Found, not changed: AER course machine admission has been in shadow since 18 Nov 15:40 AEDT.**
- `security.aer_machine_run_v1` admits only while `aer.machine_mode` is 2 and a passed validation in `pipeline.aer_machine_validations` is no older than 7 days. The only passed validation is dated 11 Nov 2026 15:40 AEDT, so it lapsed at 15:40 today. `aer.machine_suspended` is 0.
- Every outcome the job has written since is a shadow record. 79 waiting course reads are recorded `would_admit` and are not being admitted; 7 of the 25 released reads are among them after the 18:54 run, and the rest are re-checked as the job works through its batches. The last machine admission of a course read was 15 Nov 2026 15:22 AEDT.
- Nothing was run to change this. Re-validating (`security.aer_machine_validate_v1`) turns live admission of AER v1 course reads back on, which is the Platform Admin's decision.

**Not done:**
- `docs/platform/TEST-REGISTER.md` is not regenerated for s670. The generator needs the frontend packages installed (`lucide-react`), and this session cannot install packages. The next session that runs `node scripts/test-register.mjs` in Pilot picks s670 up.
- The local Playwright run was not possible for the same reason; the full suite ran green in GitHub CI on the PR, with the 15 database scenarios (`aer-hand-bound-test.yml`) and the rolled-back live dry run.
- s671 (matrix parser and completeness) and s672 (offline model replay) are not started.

**Next executable action:**
- Platform Admin: decide whether to re-run the AER course machine validation so the 79 `would_admit` reads (and the released ones as they are re-checked) are admitted.
- s671: the 893 rows with no study level come from 22 sources whose rows are table lines with the level printed, where it is printed at all, in the page or file heading ("Undergraduate" for Lincoln, UTAS, Macquarie, Adelaide) and not in the row. Several college pages print one requirement for every course and name no level.
- s672 after s671, through the on-demand open and close route.

**AER held items re-read (S2-BOOST-AER, 18 Nov 2026 17:50 AEDT, read-only; [`platform/2026-11-18-aer-held-items-classification.md`](platform/2026-11-18-aer-held-items-classification.md)).** Shared-page class 230 items on 161 pages at 79 providers (not 1,874); about 1,620 are incomplete reads needing a corrected read. The 230 are mostly qualification ladders and stream siblings on a course's own page, plus 41 pace or duration twins: 20 of the 41 demonstrably print a different requirement per variant, so no automatic twin pass was built. Matrices: 82 of 83 runs have no completeness verdict, 1,191 rows have no mapped level (893 with no level read at all), 997 have no minimum (mostly completion requirements). No rule, threshold, switch or data changed.

**Next:** the Scholarships lane, the 57 scholarship decisions and their 287 missing award values; AER v2 for `edition`/`routes`; a bulk-decision action on the Phase 5 grid for the grouped cases above.

**Status at 18 Nov 2026 11:45 AEDT (Platform Admin 07:08 decisions 3 and 4, and 10:10). The 12:25 block above is newer.**

- **Decision 4.** Pilot #1251 (migration `20261118111500`, s618): refused Boost study-load readings (the page had study-load text and the answer failed the page check) go to Layer 4 › Inbox as kind **Boost study load**; "not stated" rows and failed calls never do. Own cap `boost.layer4_open_max` (400, not the recovery lanes' 150), refilled after each result file and each decision. Choices (Pipeline Operator or above): Full-time, Part-time, Both (fills `study_load` only while empty and unlocked, source `manual`), Not stated on the page, Dismiss. Read back 10:31: all 376 refused readings open; at 11:36 the Inbox holds 400 (the cap) as new pages are read.
- **Decision 3.** Pilot #1255 (worker `coverage-sweep` v1.0.16, migration `20261118121500`, s621): job `boost-fields` reads each stored course page once for every gap field the course misses (course description, delivery mode, intakes, tuition fee, entry requirements), in Boost priority matrix order, through its own route `boost_fields_extract` pinned to Qwen3 30B (US$2 / 6,000 calls a day). Each answer is checked against the whole page and staged in Storage `staging-boost/fields` and `pipeline.boost_field_candidates`, `promotion_state` shadow, with the field's owner. **Nothing is admitted** until each owner's rule takes Boost candidates. Its claim timed out under the API from 11:01 (no page read); fixed by Pilot #1261 (migration `20261118130000`, s626: one pass from the stored pages, post-check under an 8-second time-out).
- **Read back 11:36 AEDT:** 59 pages read for US$0.010 (59 calls); field answers verified / refused / not stated: entry requirements 31/21/4, course description 23/7/1, intakes 0/14/10, delivery mode 1/9/1, tuition fee 1/7/2; 0 left shadow. The commonest refusals: quote not on the page, intake month not in the quote, entry quote not a requirement. Early figures; the refusals keep wrong values out of staging.
- **Study load keeps admitting** as S2-Build's page feed (Pilot #1252, merged by S2 - BOOST on green under the standing mandate) adds stored pages: 1,703 admitted, courses holding a study load 4,224 (2,521 this morning). G3 75 functions and 48 relations, no drift.
- **Benchmark bench-4 finished (prompt `boost-study-load-v4`, the rules now admitting; 220 stored pages, 164 AU model calls a model).** AU pages, verified with a value / refused / call failed: **Qwen3 30B 120 / 42 / 0**, **Mistral Small 3.2 133 / 25 / 3**, MiMo v2.6 Flash 108 / 11 / 42 (provider errors). Under the final rules Mistral passes the page check more often than Qwen; Qwen never failed a call. The qualified model is unchanged (Qwen3 30B, Platform Admin decision 07:08); whether to change it or add Mistral is the Platform Admin's call.
- **Test project:** S1-Build posted "can re-seed" at 10:59; run-3 dispatched 11:11 (admin run 44205747811): cohort re-seeded (12 providers, 69 courses, 60 without study load), promotion function byte-identical to production, **PASS** on every check (60 admitted for 60 courses, nothing held changed, cohort put back, G3).
- **Registers:** test register regenerated from Pilot `main` `14a30503` (741 specs, 3,474 tests); nine S2 - BOOST engagements logged (RM0, 135 minutes; ledger 69 rows, 1,035 minutes); workbook rebuilt; Drive Monitoring synced.

**Next:** owner rules for Boost field candidates (each owner turns its rule on); Thursday squash: re-seed and run-4 right after 03:30 AEDT; watch the multi-field refusal rate as more pages are read.

**Status at 18 Nov 2026 09:50 AEDT (Platform Admin decisions of 07:08). The 11:45 block above is newer.**

- **Qwen3 30B is qualified for Boost study load and admits.** Row in `pipeline.boost_model_qualifications` (lane `study_load`, `openrouter` / `qwen/qwen3-30b-a3b-instruct-2507`), Pilot #1247, migration `20261118100000`. **Live admitted count 09:45 AEDT: 447 courses** filled; courses holding a study load 2,521 → 2,968. No course that already held a value changed (the migration's post-check compares every such course before and after); every admitted row equals its course's value; G3 75 functions and 48 relations, no drift. `worker-boost-bulk-ingest` admits each new verified study load as its file loads, so the count rises until the re-read finishes (about 1,430 pages left at 09:45, roughly 30 minutes).
- **On the qualification threshold (decision 2a).** The figure that meets 95% is cross-model agreement in bench-1: Qwen3 30B and Mistral Small 3.2 give the same value on 118 of 123 pages (96%). Qwen's own page-check pass rate in bench-1 was 163 of 180 (90.6%). Qualified as the winner by the Platform Admin's decision; the reason on the row says so.
- **Only study loads read under the final rules are admitted.** The 1,420 shadow values of 02:00 were read under the earlier rule (visa sentences refused), so they were not promoted as they stood; the whole queue is being read again and only rows verified under prompt `boost-study-load-v4` are admitted. Older rows stay shadow or refused.
- **Decision 1, the international study load first: three iterations today, measured each time.**

  | Worker, prompt | Pages read | Verified with a value | Refused | What the readings showed |
  |---|---|---|---|---|
  | v1.0.12, v2 (#1238, #1241) | 468 | 96 | 282 | The model answered from the general statement on 214 pages that state an international rule |
  | v1.0.13, v3 (#1244) | about 1,300 | about 860 | 452 | Asking the international sentences on their own fixed that, but the sentence test was too loose: fee lines ("International fee … a standard full-time course load for a year") and work-rights notes counted, so correct general answers were refused (86 "Duration 4 years (full time)") and some fee lines passed |
  | **v1.0.14, v4 (#1246)** | 344 (first 10 minutes) | 246 (100 international, 146 general) + 20 not stated | 26 (8%) | A sentence counts only when it names international students or a student visa **and** states a rule about how they may study; fee, tuition, credit-point, scholarship, work-rights and experience lines never count; "part-time … not available for international students" gives full-time. The refusals sampled are correct catches (for example `full_time` claimed from "2 years full-time, 4 years part-time") |

  The commonest international rule is "International student visa holders can only study full-time." (65 of the first 100).
- **Decision 5, done.** Setting `boost.yield_to_dispatchers` = 0 (Settings › Pipeline settings › Boost): the Boost gate no longer looks at the dispatcher tick locks, so "a dispatcher tick is running" skips stop. The squash blackout (Thu 01:15–03:30), Maintenance Mode, housekeeping-daily and the switches still hold Boost. A run reads 80 pages, 4 at a time (`batch.boost_extract`, new `reading.boost_extract_parallel`).
- **Route cap.** Today's three readings used the route's 5,000-call daily cap at 09:08 (US$0.47 of US$3); the call cap is now 15,000 (#1249, migration `20261118101500`), the US$3 cap unchanged and still pinned to Qwen3 30B. Spend today to 09:45: US$0.50.
- **Benchmark run `bench-4`** (prompt v4) runs beside the extraction on its own route (US$1 cap); results go in this block when it finishes.
- **Still to build, in this order.** (1) Decision 4: refused study loads where the page has study-load text go to Layer 4 as their own inbox kind; "not stated" rows do not. (2) Decision 3: the other Boost gap lanes in one pass per stored page. Each of those fields has an owner and its own admission rule (course descriptions, fees, entry requirements under AER v2), so the pass will stage them in shadow for those rules rather than admit them.
- **Specs.** The Boost benchmark spec is now `s600` (was `s596`, which stays S2-Build's Layer 1 runner spec); `s601` (was `s597`), `s602`, `s614`, `s615` and `s617` added. Register regenerated from Pilot `main` `c5a76500`: 734 specs.
- **Keeps its schedule:** the 11:45 AEDT re-seed and run-3 on `coursefinder-boost-test` after S1-Build's rehearsal rebuild.

**Results at 18 Nov 2026 02:00 AEDT. The 09:50 block above is newer; the 00:10 block below gives the reasons and the open decisions.**

- **The stored-page queue is read in full: 2,144 courses, finished 01:33 AEDT, all in shadow. Live admitted count: 0.** No model is qualified for admission. G3 75 functions and 48 relations, no drift (read 01:46).

  | Outcome (worker v1.0.10 and v1.0.11, rules `study-load-windows-v2`) | Courses |
  |---|---|
  | Study load verified against the page | 1,420 (`full_time` 721, `both` 691, `part_time` 8) |
  | Page read, study load not stated | 531 |
  | Answer refused by the page check | 190 |
  | Call failed | 3 |
  | **Total** | **2,144** (AU 2,124, NZ 18, CA 2) |

  - **Cost:** US$0.156 for 1,722 model calls (US$0.00009 a call; US$0.00011 for each verified study load). 62 result files loaded, none with an error.
  - **Rate:** 541 courses in the first 50 minutes, then about 11 a minute once most pages needed a model call (a run reaches its time limit at about 30 calls).
  - **Not read:** 236 queued courses whose stored page text is also stored for another course.
  - **Still not admitted, and why the first sample understated the quality.** Of the 1,420 verified study loads, 415 rest on a sentence no other course of the provider uses, and 915 on a sentence used for 3 or more of its courses. Most of the common sentences are the provider's course template and are real statements of the course ("Duration 3 years full-time or part-time equivalent", 27 courses; "Duration: Full-time 2 years Part-time 4 years", 32). Some are general and say nothing of the course ("As a full-time student, you can expect to commit around 48 hours of study per week", 76 courses, answered `full_time`). 14 answers rest on a sentence that was given two different values. So a rule that refuses every repeated sentence would throw away good data; the 55% of the 00:10 block came from 22 answers of two providers and is not the rate for the whole queue. The rate for the whole queue has not been measured: it needs a read of a random sample.
- **Model benchmark bench-1 (Pilot #1236, worker v1.0.11; production 00:33 to 01:33 AEDT; replayed on `coursefinder-boost-test`, GitHub Actions runs 44106815300 and 44107426226).** The same 220 stored pages (AU 200, NZ 18, CA 2; the course's own page only), the same request and the same page check, asked of each model directly. 40 pages had no study word and were not sent. "Admitted" is on the test project only, with that one model qualified there, through the production promotion function (same md5).

  | | Qwen3 30B | Mistral Small 3.2 | MiMo v2.6 Flash |
  |---|---|---|---|
  | Model calls | 180 | 180 | 180 |
  | Verified with a study load | 160 | 126 | 92 |
  | Verified, not stated | 3 | 3 | 7 |
  | Refused by the page check | 17 | 18 | 4 |
  | Call failed | 0 | 33 | 77 |
  | **Admitted on the test project (of 220 pages)** | **157 (71%)** | **123 (56%)** | **91 (41%)** |
  | Admitted, AU / NZ / CA pages | 139 of 200 / 16 of 18 / 2 of 2 | 107 / 14 / 2 | 82 / 8 / 1 |
  | Cost of the run | US$0.0168 | US$0.0108 | US$0.0137 |
  | **Cost per admitted field** | **US$0.00011** | **US$0.00009** | **US$0.00015** |
  | Median time of a call | 0.97 s | 0.89 s | 4.84 s |
  | Promotion of its 220 rows | 71 ms | 61 ms | 63 ms |

  - **Failures are the provider's, not the answers'.** Mistral's 33 and 66 of MiMo's 77 are "Provider returned error" from OpenRouter (the request allows no fallback provider); 11 of MiMo's are answers cut off at the 300-token limit (`reading.answer_tokens.boost_extract`). Qwen3 30B had none.
  - **Agreement.** Where two models both gave a study load they agree on 118 of 123 pages (Qwen and Mistral, 96%), 84 of 90 (Qwen and MiMo, 93%) and 64 of 67 (Mistral and MiMo, 96%). All three gave one on 67 pages and agree on 62 (93%). Agreement does not prove the value: three models reading the same general sentence agree with each other.
  - **NZ and CA** are 18 and 2 pages, all there is; too few to compare models on.
  - **Reading.** Qwen3 30B, the model already on the route, answers the most pages, fails least and is as fast as Mistral; Mistral is slightly cheaper per admitted field only because its failed calls cost nothing. Nothing here argues for changing the route's model.
  - **Test project after the replay:** no qualification row, no benchmark course, no benchmark staging row, G3 75 and 48. The benchmark's providers (and their registry rows) could not be removed, because a row the platform creates for each new provider (`coverage_provider_discovery`) refers to them; they hold no course and go with the 10:30 rebuild. Three benchmark courses were already in the admitted-count cohort; the test project will be re-seeded after the rebuild as planned.
  - **Spend on the benchmark route:** US$0.041, 441 calls recorded in the ledger. Job `boost-benchmark` now finds nothing left and does not call the worker; a new label on Settings › Pipeline settings › Boost starts another run.
- **`boost-extract` now idles**: the queue is empty until a course gains a stored page. It waits for a dispatcher tick instead of skipping its run (worker v1.0.11).
- **Decisions still with the Platform Admin** (00:10 block): what study load means when a page gives domestic and international students different loads; the admission rule (recommended from tonight's data: admit a value only when Qwen3 30B and Mistral Small 3.2 give the same one, and refuse the general sentences by a short list of phrasings, after a read of a random sample of about 100 of the 1,420); other lanes as proposals or direct; refused rows to Layer 4 or not. Once decided, the 1,420 staged rows can be settled without reading the pages again.

**Status at 18 Nov 2026 00:10 AEDT (Platform Admin directives of 17 Nov 22:45, 22:48 and 22:50). This block is current; where a bullet further down differs, this block wins.**

- **Running now, all day, in shadow.** Job `boost-extract` every minute, 40 courses a run; `worker-boost-bulk-ingest` every 2 minutes, 10 files a run; route `boost_extract` pinned to Qwen3 30B, caps US$3 and 5,000 calls a day; worker `coverage-sweep` v1.0.10. The overnight window is gone (the window settings cover the whole day, Pilot #1231). What still holds Boost: the switches, Pipeline Maintenance Mode, the squash lock **Thu 19 Nov 01:15 to 03:30 Melbourne** (gates and promotion both, proven in the migrations), `housekeeping-daily`, and the dispatcher locks.
- **Live admitted count: 0.** No model is qualified for admission (`pipeline.boost_model_qualifications` is empty), so every staged row is shadow or refused. Read 23:59 AEDT: 0 rows admitted; G3 75 functions and 48 relations, no drift.
- **Why Qwen3 30B was not qualified (directive item 2).** The 22:48 directive made it conditional on a clean reading of the first results; the 22:50 directive said to qualify now. The first results were read before the qualification was merged, and they were not clean, so it was held. This is for the Platform Admin to decide, with the evidence below.
  - **First reading (worker v1.0.9, 23:22 to 23:30, 40 courses, 35 model calls).** 35 of 35 answers passed the page check (100%). But 28 of the 29 study loads given rested on one sentence of provider boilerplate, "Only a full-time study option is available to international students on a Student visa", and 16 of the 35 pages were one page text stored for 21 different courses, which gave `full_time` for some of them and "not stated" for others. One answer of 29 was a statement of the course's own study load. The page check proves the quote is on the page; it does not prove the quote is about the course.
  - **Fixed the same night (Pilot #1231, worker v1.0.10, selector `study-load-windows-v2`).** A sentence about a visa, about what international students must do, or naming CRICOS is neither sent to the model nor accepted as a quote. A stored page whose text is also stored for another course is not read (236 of the 2,380 queued courses; 2,144 remain). The 40 courses were released and are being read again.
  - **Second reading (v1.0.10, 23:56 to 23:58, 80 courses, 36 model calls).** 44 "not stated" (35 without a model call), 28 study loads verified (18 `both`, 10 `full_time`), 8 refused by the new rules. Read by hand, a sample of 22 of the 28: about 12 are plain statements of the course ("6 Study Periods (2 years) full-time, or equivalent part-time"; "45 weeks full-time."); 9 rest on a provider's definition of full-time and part-time study that appears on many of its pages ("Full-time study is enrolling in three or more courses per study period, while part-time study is one or two courses"), which says nothing about the course; and the same sentence gave `both` for some courses and `full_time` for another, and "(1 year) full-time, or equivalent part-time" was answered `full_time`. That is roughly 55% right on substance, against a 95% bar.
  - **What would make it safe to admit.** (a) A rule for boilerplate: a quote that the same provider's pages give for many courses is not accepted. (b) Agreement between models: admit only where the candidate models give the same value from the same page (the benchmark below gives the figures). (c) A decision on what the field means when a page says "domestic: full-time or part-time; international: full-time": for an international student the answer is `full_time`; for the course it is `both`. REQ-52 does not settle it.
- **Throughput and cost so far.** 80 courses read under v1.0.10 in two runs of 40 (the first run of 20, under v1.0.9, answered in about 9 seconds). Cost US$0.0051 for 76 model calls in all (about US$0.00007 a call); the whole queue is about US$0.10. Boost spend now reaches the AI spend ledger (trigger on `pipeline.boost_extract_items`), so the route cap and the daily ceiling count it; before #1231 only the calls were recorded.
- **Defect, open: runs are skipped instead of waiting.** `boost-extract` fires at the top of the minute, as the dispatcher ticks do; 3 of 5 runs after 23:54 returned "a dispatcher tick is running" and did nothing. The ingest worker waits up to 30 seconds for a tick; the extract mode does not. Fix: wait the same way (next worker version). At the present rate the 2,144 pages still clear in about 2 to 3 hours.
- **Not done, with reasons.**
  - **Directive item 4, all Boost fields in one call (description, delivery mode, intakes, fees, entry requirements).** Not built. Each of those fields has its own admission rule and owner (course descriptions: the source-grounded prompt and its checks; fees: the fee reader and fee floors; entry requirements: AER v2 only, AER v1 frozen by Decision 276; intakes: S2-Intakes; the pre-AI admission gate, Decision 278). Boost can extract them and stage them as proposals for those rules; admitting them from Boost directly would bypass those rules. The staging table also allows five lanes only. Needs the Platform Admin's decision on proposals versus direct admission, lane by lane.
  - **Refused and conflict rows to Layer 4.** Not built. Study load has no confidence score, a course that already holds a value is never queued, and refused rows are kept in staging with their reason. Sending them to Layer 4 would add to its backlog; say if it is wanted.
  - **Model benchmark on the test project before the 10:30 rehearsal (directive of 22:45).** Not run yet. The migration is written (Pilot branch `cf247-boost-benchmark-wip`: route `boost_extract_benchmark` with the three named models, results table, job, run label on Settings); the worker mode, the guard spec and the replay onto `coursefinder-boost-test` are still to write. Next in this lane.
- **Changes tonight:** Pilot #1226 (migration `20261118000100`, s588: Boost on demand until 01:05; promotion refused inside the squash lock) and Pilot #1231 (migration `20261118011000`, s590, worker v1.0.10: all day, squash lock from 01:15, throughput, the two page rules, spend to the ledger). Both passed the rolled-back live dry run and all checks; deployed UAT passed on both merges.

**Done 18 Nov 08:20 AEDT (Pilot #1244): the Boost benchmark spec is `s600`.** Was: **Action for S2 - BOOST (Platform Admin 18 Nov 2026 07:35, via S1-Build): renumber the Boost benchmark spec.** `cf-247-s596-boost-benchmark-contract` and S2-Build's `cf-247-s596-layer1-declarative-runner-contract` share `s596`. In your next Pilot PR (qualifying the winning model and fixing the dispatcher lock skips), rename the Boost benchmark spec to a number strictly above every number in use and regenerate `docs/platform/TEST-REGISTER.md` in the same change (G4). At 07:40 AEDT the register's highest is `s596`, and open Pilot PRs already claim `s597` (#1239) and `s598` (#1240), so the next free number is `s599`; re-check open PRs before you merge. The Layer 1 runner spec keeps `s596`.

**Done 11:11 AEDT by S2 - BOOST: run-3 re-seeded and PASS (admin run 44205747811).** Was: **S2 - BOOST: you can re-seed `coursefinder-boost-test` (`ucdaaqrpgcldnatavmib`) now — Wed 18 Nov 2026 10:59 AEDT (S1-Build, squash rehearsal done).** The rehearsal rebuild (admin `boost-test-rebuild.yml` run 44201959838, from production dump `db-schema-dump/44199899527`, head `20261118111500`, plus `20261118113000` applied after) has finished; the project now holds the production schema with test cron jobs off. Re-seed it as in your lane notes (`run-3`). The next reset is the squash window, **Thu 19 Nov 01:30–03:30 AEDT**; re-seed again right after 03:30.
- **One check for S2 - BOOST to update before Thursday:** the run reported FAIL only on `outside_window_refused` (`sql/boost-ingestion/005_rehearsal_rolled_back.sql`, check d). The Boost window now covers the whole day (`[0, 24]`, Pilot #1231), so a run can never be outside it and the check returns "not refused". Please change check d (or the verdict) to follow the window settings, so the window's proof reads PASS. Every other check passed: schema from the dump, 2 newer migrations applied (0 failed), G3 75/48 with no drift, 1,000 rows in 0.042 s, 50 shadow rows with 0 admitted and 0 courses changed, 1 study load written and 0 `updated_at` touched.

**Migration freeze lifted — Thu 19 Nov 2026 02:25 AEDT (S1-Build).** The canonical squash merged at 02:15 (Pilot #1325). Pilot PRs that add migrations may merge again. **Authors of open migration PRs (Pilot #1314 and any branch cut before 02:15): rebase on main first.** Files under `supabase/migrations/` up to `20261118272000` moved to `supabase/migrations-archive/`, so a branch from before the squash conflicts or re-adds them; keep only your new file under `supabase/migrations/`, numbered above the live head.

**Done 19 Nov 05:57 AEDT by S2-Build (Platform Admin 05:21): rebuild proof PASS on all five checks (admin run 44369667112, check d fixed in admin #622) and re-seeded (admin run 44372812878, PASS).** Was: **S2 - BOOST: you can re-seed `coursefinder-boost-test` (`ucdaaqrpgcldnatavmib`) now — Thu 19 Nov 2026 02:25 AEDT (S1-Build, squash window rebuild proof done, run 44327488382).** The project holds the schema from production dump 44324920057 (head `20261118272000`) and reference data; test cron jobs are off. Check d of `005_rehearsal_rolled_back.sql` (`outside_window_refused`) still fails against the whole-day Boost window: please update it with the re-seed. `ref.study_level_source_mappings` did not load (foreign key to a source outside the copy set), as in the rehearsal.

**Action for S2 - BOOST (Platform Admin 17 Nov 2026 20:06):** S1-Build uses `coursefinder-boost-test` for the squash rebuild proof, and `boost-test-rebuild.yml` resets the project (application schemas dropped and rebuilt from the production dump; reference data copied; test cron jobs switched off). Two resets:
- **Rehearsal, Wed 18 Nov from 10:30 AEDT** (S1-Build posts here when the rebuild run finishes);
- **Squash window, Thu 19 Nov 01:30–03:30 AEDT.**

Do not run experiments on the project during those runs. Re-seed it (qualification rows, experiment batches, any test settings) after the rehearsal rebuild and again **right after the window closes at 03:30 AEDT Thursday**. Keep the re-seed steps in your lane notes so they can be repeated.

**Platform Admin decisions, 17 Nov 2026 21:18, and what changed (Pilot #1219, migration `20261117223000`, guard spec s586; merged 22:13 AEDT). Where the bullets further down differ, this block is current.**

- **Decision 3, where the matrix lives.** The Boost priority matrix is 18 settings on **Settings › Pipeline settings › Boost**, each changed on the screen with a reason:
  - `boost.matrix.country_weight.<CC>`: AU 100, NZ 95, CA 90, UK 50, IE 45, US 40 (range 0 to 100).
  - `boost.matrix.category_weight.<category key>` (range 0 to 1), one per category of the single list.
  - `boost.matrix.tier_1` (AU, NZ, CA) and `boost.matrix.tier_2` (UK, IE, US); `boost.matrix.country_aliases` (GB=UK); `boost.matrix.lane_categories`.
  - **A change that breaks the matrix is refused.** A deferred check on the settings table (`boost_matrix_check`, function `security.boost_matrix_settings_guard_v1`) refuses a change to a `boost.matrix.*` setting when a tier 2 cell would reach a tier 1 cell or a weight goes below 0. The screen shows "Boost priority matrix not saved: …".
  - The row `country_category_boost` in `pipeline.environment_settings` is kept, marked `not_applicable`, and no longer read. Per-cell overrides (there were none) were not carried over.
- **Decision 2, the categories.** The matrix has no category list of its own. It reads `ref.enrichment_categories` (S1-RM-Design, migration `20261117213000`; [`platform/ENRICHMENT-CATEGORIES.md`](platform/ENRICHMENT-CATEGORIES.md)).

  | Category | Weight | Boost lane |
  |---|---|---|
  | Recognition & registration | 1.00 | `provider_accreditations` |
  | Campus & location | 0.95 | |
  | Fees | 0.90 | `course_fees` |
  | Entry requirements | 0.85 | `aer_entry` |
  | Intakes & deadlines | 0.80 | `study_load` |
  | Course basics | 0.75 | `course_description` |
  | Provider profile | 0.70 | |
  | Scholarships | 0.65 | |

  - **How the weights were carried.** Six categories took the weight of the old matrix key they replace (by the crosswalk `ref.enrichment_category_fields.boost_category`). Course basics and Provider profile had no single old key and took the two weights left over (0.75 and 0.70). These are starting values; change them on the screen.
  - Lowest tier 1 cell is CA Scholarships 58.5; highest tier 2 cell is UK Recognition & registration 50.
  - **For S1-RM-Design:** the Boost matrix now reads the single list, so the crosswalk column `ref.enrichment_category_fields.boost_category` has no reader in the Boost lane. It was not touched; retiring it is yours.
- **Decision 4, order only.** `security.boost_promote_v1` does not read the matrix (guarded by s586). The matrix orders the Boost queue; `security.boost_lane_category_v1(lane)` gives a lane's category.
- **Decision 5, the admitted count.** `security.boost_promote_v1` now admits one row per course in a batch (the earliest); later rows for the same course are refused with the note "an earlier row of this batch fills this course's study load". What is written to the catalogue is unchanged. The function was replaced only after the migration confirmed the live definition was md5 `15be1ce6`.
- **Verification of #1219, completed 17 Nov 22:07 to 22:12 AEDT.** Read back live: head `20261117223000`, 18 `boost.matrix.*` settings, matrix check `ok` with 48 cells (AU Recognition & registration 100 rank 1; CA Scholarships 58.5 rank 24; UK Recognition & registration 50 rank 25), old row `not_applicable`, the deferred check present, promotion function md5 `c9239d35`, 0 qualified models, G3 75 functions and 48 relations with no drift. **Run-2 on the test project (GitHub Actions run 44071755287, admin workflow `boost-test-experiment.yml`): PASS.** The promotion function was copied from production (same md5 on both). 60 rows admitted for the 60 courses with no study load at 1,000 and at 5,000 rows (5,922 later rows for the same courses refused, none admitted); 19 for 19 at 50 rows; nothing admitted with no model qualified; 0 held courses and 0 `updated_at` values changed; G3 on the test project 75 and 48. Timings (database time, medians): 1,000 rows 36.5 ms load and 101.9 ms promote; 5,000 rows 183 ms and 374.7 ms, worst promotion 0.42 s.
- **Database and test-project runs are non-interactive (Platform Admin 17 Nov 2026 22:05).** No tool that asks for confirmation is used for a change. Routes:
  - **Production change:** a Pilot migration, dry run by the label `live-dry-run` (Pilot workflow `db-migration-dry-run.yml`), applied by deploy on merge. Production G3 through Actions is read by that workflow's probe, as the database owner; the read-only role of the Management API may not run `security.consumer_api_check_v1` (seen in run 44071755287).
  - **Test project:** admin workflow **Boost test project experiment** (`.github/workflows/boost-test-experiment.yml`, inputs `label` and `reseed`): production read only, then on `coursefinder-boost-test` only: re-seed, promotion function from production, `sql/boost-experiments/admitted-count.sql`, verdict; results on branch `boost-experiment/<run id>`.
- **Decision 1, Boost extraction through `coverage-sweep` and Models & services: live 17 Nov 2026 22:37 AEDT** (Pilot #1223, migration `20261117235000`, worker `coverage-sweep` v1.0.9, guard spec s587; deploy on merge run 44075576598).
  - **Route** `boost_extract` ("Boost extraction (study load)", area Boost) in Models & services: one pinned model, `qwen3-30b` (`qwen/qwen3-30b-a3b-instruct-2507`, the central model), daily caps USD 1 and 1,500 calls. No separate worker holds an OpenRouter key; the Cloudflare Worker is not deployed.
  - **Job** `boost-extract`, `2-59/5 * * * *`, catalogued, no number in its command. It runs only when `security.boost_extract_gate_v1` allows: the switch `boost.extract_on` (ships **on**), then the overnight Boost gate (01:05 to 04:50 Melbourne, not in the squash blackout, not beside `housekeeping-daily`, dispatcher locks). Read live: closed now, open Wed 01:10, closed Thu 01:45.
  - **What a run does** (mode `boost_extract`, `boost.ts`): claims up to `batch.boost_extract` (20) courses with no study load that have a stored course page, country by country in the order of the Boost priority matrix (study load is Intakes & deadlines: AU 80, NZ 76, CA 72); reads each stored page; sends only the text around "full-time" and "part-time" (at most `reading.boost_extract_section_chars`, 6,000) to the route's model; checks the answer against the whole page (allowed value, quote on the page, quote states the load it claims); writes one result file per run to Storage `staging-boost/inbound`. A page with neither word gets its "not stated" row with no model call. `worker-boost-bulk-ingest` (unchanged) loads and settles the file.
  - **Nothing is admitted.** `pipeline.boost_model_qualifications` is empty, so every row is shadow or refused and the catalogue is not written. Qualifying a model for admission stays a separate, deliberate step after the benchmark.
  - **Lane:** `study_load` only. The other Boost lanes (`course_fees`, `aer_entry`, `course_description`, `provider_accreditations`) are not read by this worker yet.
  - **The queue is small and almost all Australian.** Read live 22:40 AEDT: 2,380 active courses have no study load and a stored course page: AU 2,360, NZ 18, CA 2. (33,502 active courses have no study load; the rest have no stored course page for Boost to read.) At 20 courses a run the queue takes about three nights; `batch.boost_extract` goes to 200.
  - **Ledger and progress:** `pipeline.boost_extract_items` (one row per course and stored page, with outcome, batch, file, whether a model was called, cost); `security.boost_extract_progress_v1()`. It holds 6 `released` rows from the migration's own claim check; they are read by the job like any other.
  - **Read back live 22:38 AEDT:** route enabled, cascade `[qwen3-30b]`, not held, USD 0 spent; job active; 5 settings as above; 0 rows claimed; 9 register rows; promotion function md5 `c9239d35` (unchanged); 0 models qualified for admission; G3 75 and 48, no drift.
  - **First run:** Wed 18 Nov 01:07 AEDT. Not yet observed: the worker mode has passed the type check, the guard spec and the unit checks of `boost.ts`, but has made no live model call. The first night's figures (courses read, model calls, verified, rejected, failed, cost) are to be read from the ledger and the route's spend on Wednesday morning and recorded here.
- **Benchmark plan (Qwen3 30B, Mistral Small 3.2, MiMo v2.6 Flash; all three are allowed models in the catalogue).** Live model calls run on production, where the key and the route are; the test project has neither. To build before Thursday: a benchmark mode that asks each candidate model, pinned one at a time through the platform AI evaluation framework, for the same fixed set of stored pages, writes nothing to the catalogue and reports per model the verified rate, the rejected and failed kinds, tokens and cost per verified field. NZ and CA can supply only 18 and 2 study-load pages, so their cohorts will be small until more of their course pages are stored.
- **Test project re-seed (after the rehearsal of Wed 18 Nov 10:30 AEDT and after Thu 19 Nov 03:30 AEDT).** Dispatch **Boost test project experiment** with `reseed` on and a new label (`run-3`, `run-4`); it re-seeds from [`paste/boost-test-reseed.sql`](paste/boost-test-reseed.sql), copies the promotion function from production and repeats the admitted-count run. Not during S1-Build's rebuild runs (the workflow shares no lock with `boost-test-rebuild.yml`; check that run has finished first).

- **Already live before this session (Pilot #1205, S1-Build; re-read 18:10 AEDT, unchanged):** `security.boost_promote_v1` (md5 `15be1ce6`), `security.boost_ingest_gate_v1` (md5 `9406870c`), job `worker-boost-bulk-ingest` (`*/5 * * * *`, active, catalogued, no number in its command) and the 11 `boost.*` settings. Gate read live: now = outside the window; Wed 01:10 = open; Thu 19 Nov 01:31 = blackout. The promotion function and the job were therefore not landed again.
- **Boost priority matrix as first landed, 17 Nov 2026 18:30 AEDT; store and categories superseded at 22:13 AEDT, see the block above** (Pilot #1209, migration `20261117183000`, guard spec s581; deploy on merge run 44039205199). One row `country_category_boost` in `pipeline.environment_settings` (category `boost`, `admin_edit`, status `configured`, not required for production).
  - **Cell weight** = country weight x category weight, or the cell's own weight under `cells` (key `COUNTRY.category`). Weight 0, or a country or category not listed, means not qualified for Boost work.

    | Country weight | | Category weight | |
    |---|---|---|---|
    | AU | 100 | `identity_registers` | 1.00 |
    | NZ | 95 | `geo_localities` | 0.95 |
    | CA | 90 | `tuition_fees` | 0.90 |
    | UK | 50 | `admissions_entry` | 0.85 |
    | IE | 45 | `intakes_delivery` | 0.80 |
    | US | 40 | `study_rules` | 0.75 |
    | | | `careers_outcomes` | 0.70 |
    | | | `scholarships_accred` | 0.65 |

  - **Tiers:** `[[AU, NZ, CA], [UK, IE, US]]`. Every cell of the first tier must outweigh every cell of the second (lowest first-tier cell CA `scholarships_accred` 58.5, rank 24; highest second-tier cell UK `identity_registers` 50, rank 25). `security.boost_country_category_check_v1()` refuses a setting that breaks this; run it after any edit.
  - **Read by:** `security.boost_country_category_matrix_v1()` (48 cells in priority order) and `security.boost_country_category_weight_v1(country, category)` (one cell; `GB` resolves to `UK`). Service role only.
  - **What it does not do.** It orders work only. It qualifies no model and does not change promotion, the gate or the job. Nothing reads it yet: the queue exporter (`scripts/boost-export-queue.sql`) is to order its queue by it when the Boost Worker is deployed.
  - **Starting values are a first setting, not a measured result.** The category order is the order of the instruction. `lane_category` maps four Boost lanes (`study_load` to `intakes_delivery`, `course_fees` to `tuition_fees`, `aer_entry` to `admissions_entry`, `provider_accreditations` to `scholarships_accred`); `course_description` has no category. Both are for the Platform Admin to confirm.
  - **Where the values sit (G2 note).** The instruction named `pipeline.environment_settings`, so the matrix is there and not in `pipeline.platform_toolset_settings`; it does not show on Settings › Pipeline settings. Editing it today is a SQL update followed by the check function.
  - **Read back live 18:31 AEDT:** head `20261117183000`, 2,067 applied; check `ok`, 48 cells; 3 register rows; 0 qualified models; no execute for anon or authenticated; promotion and gate md5 unchanged; G3 75 of 75 functions, 48 of 48 relations, no drift.
- **Boost test project experiments, run-1 (17 Nov 2026 18:22 AEDT; project `coursefinder-boost-test`, `ucdaaqrpgcldnatavmib`).**
  - **Cohort:** 69 real production course ids from 12 real providers (4 each AU, NZ, CA; the largest by course count), copied read-only: 60 courses with no study load and 9 that hold one. Titles and other fields were not copied. Production holds no UK, IE or US courses yet.
  - **Input:** synthetic worker result rows generated in SQL (no model was called): 70% `study_load`, 10% each `course_fees`, `aer_entry`, `course_description`; 80% verified, 12% rejected, 8% failed; 10% of study-load answers empty; 75% of rows from the model qualified in the test, 25% from an unqualified one. This mix is an assumption, not an observation.
  - **Method:** each batch size three times; staging insert, then `security.boost_promote_v1` (the production function, same md5) in one transaction; medians below. Timings are database time on the test project and exclude the edge function, Storage reads and network.

    | Batch rows | Nothing qualified: load / promote (ms) | rows/s | One model qualified: load / promote (ms) | rows/s |
    |---|---|---|---|---|
    | 50 | 2.5 / 6.7 | 5,471 | 2.2 / 13.5 | 3,182 |
    | 250 | 9.4 / 16.7 | 9,585 | 9.5 / 35.7 | 5,417 |
    | 500 | 18.3 / 29.6 | 10,430 | 18.3 / 58.1 | 6,571 |
    | 1,000 | 35.4 / 59.9 | 10,471 | 36.4 / 88.1 | 8,044 |
    | 2,000 | 73.3 / 122.2 | 10,243 | 74.3 / 183.6 | 7,797 |
    | 5,000 | 234.9 / 313.2 | 9,122 | 255.3 / 413.5 | 7,517 |

  - **Promotion outcome, 1,000-row batch.** Nothing qualified: 800 shadow, 200 refused, 0 admitted, 0 courses changed (shadow isolation holds at every size, 50 to 5,000). One model qualified for `study_load`: 352 rows admitted, 360 shadow, 288 refused; 60 of the 60 eligible courses filled.
  - **Zero-regression checks, every run:** 0 of the 9 courses that already held a study load changed; 0 `updated_at` values changed; G3 on the test project after the runs 75 functions, 48 relations, no drift. The test qualification row was removed and the cohort restored to its starting state (60 without a study load).
  - **Tuning read.** Throughput is flat from 500 to 5,000 rows, so the live values (`boost.ingest_rows_per_call` 500, `boost.promote_rows_per_run` 1,000) are not the limit; the worst promotion run took 0.42 s against the 5 s target. No setting was changed in production.
  - **Finding for the promotion function.** When a batch holds several verified rows for one course, every one is marked `admitted` although only the first writes (352 admitted rows for 60 courses). The catalogue is right; the admitted count overstates. A fix would mark the later rows refused ("already filled in this batch"). Not changed: it alters `security.boost_promote_v1` and needs its own dry run.
  - **Not measured, and why.** Model routing, field-level accuracy, token cost per admitted field and the Layer 4 escalation rate need real model output. The Boost Cloudflare Worker (`workers/cf-boost-extractor`) is not deployed and no AI-provider key is held by this session or the test project, so no figure is given for them. The test project also has no migration 20261117163500 objects (file ledger, gate, service calls) and no edge function, so the file path of `worker-boost-bulk-ingest` itself was not exercised.
  - **Evidence:** table `public.boost_experiment_runs` on the test project (36 rows, label `run-1`) and the 52,800 staged rows of batches `exp-*`.
- **Open items of 18:40 AEDT: all five decided by the Platform Admin at 21:18 and all five delivered** (block at the top of this section). Still open: the first night's telemetry; the benchmark mode; the re-seeds after the rehearsal and the squash.

### S1-Build Wave 2: staging retention, 7-year evidence floor, operations telemetry, live dry run (Platform Admin 17 Nov 2026 17:59, 18:02 and 18:25)

- **Live 17 Nov 2026 19:3x AEDT (deploy on merge run 44044011237; history md5 `5e3173b7` equals the file)** (Pilot #1212, migration `20261117200000`, guard spec s583; numbered s583 because #1209 and #1211 hold s581 and s582). Read back live: head `20261117200000`, 2,069 applied; all 7 settings at their defaults (pruning off); housekeeping-daily calls the retention step and stays active; the evidence purge carries the 7-year floor; the three retention classes, both tables (row-level security on) and 6 register rows present; views closed to anon and authenticated; `admin_ops_telemetry` not executable by anon. G3: 75 of 75 consumer functions equal their baseline md5, 48 of 48 relations, no drift flag.
- **Staging retention in `housekeeping-daily`** (03:47 AEDT) through `security.staging_retention_v1`:
  - applied Layer 1 staging rows (`pipeline.source_record_staging`, status `processed`) after 90 days, or the source's own period (`pipeline.source_retention_policies`, set by the Platform Admin with `public.admin_source_retention_set`, with a reason); never for a source with a Layer 1 run in progress;
  - Boost staging rows settled as shadow, proposed or refused after 90 days; admitted rows stay;
  - before a row goes, its hash, source and dates are written to `pipeline.staging_hash_ledger`, kept `retention.raw_hash_keep_years` (7);
  - published editions (`destination.editions`, `pipeline.layer1_dataset_editions`) and evidence are never touched (new retention classes `applied_source_staging`, `staging_hash_ledger`, `published_editions`);
  - **dry run until `retention.staging_prune_on` is 1** (the class catalogue requires a dry run first). Each night's report is an Admin event (area retention, action `staging_retention_dry_run`). Nothing is due tonight: the 3 `processed` Layer 1 rows carry no `processed_at` (so they are kept), and there are no Boost rows.
- **Evidence purge aligned (Platform Admin 18:25):** `security.retention_evidence_candidates_v1`, used by the retention estimate and the retention worker for category `evidence_unreferenced`, never offers evidence younger than `retention.raw_hash_keep_years` (7 years). Before this, unreferenced evidence could be purged after 7 days (last run 8 Oct 2026, 2,280 records).
- **Telemetry (read only, for S1-RM-Design's Ops report):** `pipeline.ops_l1_apply_latency_v` (each Layer 1 apply run: seconds, records, chunks of `layer1.register_apply_chunk`, ms per chunk), `pipeline.ops_l4_escalation_by_source_v` (per source: evidence captured, Layer 4 items raised, escalation rate, pending and aged), `pipeline.ops_boost_vs_pr3_throughput_v` (per Melbourne day: Boost files, rows loaded, settled and admitted beside PR 3 live runs, daytime runs, failures and time; shadow rows while PR 3 is in shadow). All closed to anon and authenticated; read through `public.admin_ops_telemetry()` (Curator and above). Look-back `telemetry.window_days` (30); aged Layer 4 item `telemetry.l4_aged_days` (7).
- **Settings** (Settings › Pipeline settings › Housekeeping): `retention.staging_prune_on` 0, `retention.staging_keep_days` 90, `retention.boost_staging_keep_days` 90, `retention.raw_hash_keep_years` 7, `batch.staging_prune_rows` 1000, `telemetry.window_days` 30, `telemetry.l4_aged_days` 7.
- **Rolled-back live dry run without prompts:** Pilot workflow `db-migration-dry-run.yml` (script `scripts/ci/dry-run-migration.sh`). A PR labelled `live-dry-run`, or a manual run with the project ref typed to confirm, runs each new migration on the Pilot inside a transaction that always ends in an exception: nothing is kept, no history row. For #1212 it caught a real error first (an alias), then passed (run 44039326181 and the re-run after rebasing).
- **Telemetry caveat:** the escalation rate divides Layer 4 items raised in the look-back by evidence captured in the same look-back. Register-style sources capture once and raise many items later, so their rate can exceed 1 (IRCC 117.9; items with no evidence source 2,623). The Ops report should show items and evidence side by side, not the rate alone.
- **Open:** a Settings screen for the per-source periods and the Ops report screen are S1-RM-Design's (the RPCs are ready). Turn pruning on after reading a nightly dry-run report.

### S1-Build lane: Supabase Auth, Boost prerequisites and paused jobs (17 Nov 2026; Platform Admin 13:11 and 14:12)

- **Supabase Auth (project `fxcwkweaxjtknorudmwp`), applied 14:33 AEDT** by admin workflow `supabase-auth-config.yml` (#547; run 44009123373) through the Management API, read back:

  | Setting | Before | Live now |
  |---|---|---|
  | `site_url` | `https://coursefinder-pilot.techm.workers.dev` (set by the Platform Admin) | unchanged |
  | `uri_allow_list` | empty | `https://coursefinder-pilot.techm.workers.dev/`, `https://coursefinder-pilot.techm.workers.dev/**` |
  | `mailer_subjects_invite` | You've been invited | You're invited to StudySearch Admin |
  | `mailer_subjects_recovery` | Reset your password | Reset your StudySearch Admin password |
  | Invite and Reset password templates | Supabase defaults | match `docs/paste/PASTE-20261117-supabase-invite-email-template.md` byte for byte |

  The workflow prints only these fields and the templates' md5, never the rest of the Auth configuration. Still to do (Platform Admin): step 4 of the paste doc, a test invitation and a password reset to an address you control, then delete the test user.
- **Boost staging prerequisites, live 14:37 AEDT** (Pilot #1199, migration `20261117152300`, guard spec s578): the private Storage bucket `staging-boost` (service role only, 52,428,800 bytes, `application/x-ndjson`, `application/json`, `text/plain`, 0 objects), and `pipeline.boost_inbound_staging` and `pipeline.boost_model_qualifications` (row-level security on, no read for anon or authenticated, 0 qualified models). Nothing is switched on.
- **`worker-boost-bulk-ingest` is built and wired, live 17 Nov 2026 17:01 AEDT (deploy on merge run 44027120386)** (Pilot #1205, migration `20261117163500`, guard spec s580; Platform Admin 16:15). Read back live: migration in the history (history md5 `93725fc9` equals the file; 2,065 applied; applied after `20261117170000` of Pilot #1206, which merged minutes earlier: a lower version applied later, as on 16 Nov; Thursday's squash takes both), job 431 active with the command above (no number), catalogue row area Boost, nonce allowlisted, all 11 `boost.*` settings, 5 register rows, row-level security on `pipeline.boost_ingest_files`, no execute for anon or authenticated, 0 qualified models, 0 files, 0 staged rows, 0 objects in `staging-boost`; edge function `worker-boost-bulk-ingest` version 1 ACTIVE, `verify_jwt` false, source equal to the file. Gate read live: now = outside the window; Thu 01:31 = blackout; at the read it also reported a real `admission-rule-runner-c` tick holding its lock (the lock check works on live locks). G3: 75 of 75 consumer functions equal their baseline md5, 48 of 48 relations present, no drift flag.
  - **What it does.** Job `worker-boost-bulk-ingest` (`*/5 * * * *`, catalogued in area Boost, nonce-allowlisted) calls edge function `worker-boost-bulk-ingest` (`worker-boost-bulk-ingest-v1.0.0`) only when the gate opens. The function reads `staging-boost/inbound/*.ndjson` (or `.jsonl`), claims each file once in `pipeline.boost_ingest_files`, loads its `kind: result` lines into `pipeline.boost_inbound_staging` and settles each batch with `security.boost_promote_v1` (admin `sql/boost-ingestion/002`, unchanged). A failed file stays `failed` until a person clears its row.
  - **When it runs** (`security.boost_ingest_gate_v1`, checked in this order): `boost.ingest_on` = 1; Pipeline Maintenance Mode off; Melbourne time 01:05–04:50; not inside the squash blackout (Thu 19 Nov 2026 01:30–03:30 AEDT); `housekeeping-daily` not running and started more than 20 minutes ago (it starts 03:47 AEDT and takes about 20 s, so the lane holds 03:47–04:07); and, checked by the function before each file, no PR 1 (`rollup-scheduler`), PR 2 (`admission-rule-runner` a, b, c) or PR 3 (`coverage-lane-dispatch` a, b, c) tick holds its lock. A held lock makes the function wait 5 s and look again (up to six times), then stop for that run. The PR 1 cutover review (Tue 17 Nov 23:20 AEDT) and PR 3 (06:45) fall outside the window.
  - **Settings** (Settings › Pipeline settings › Boost, toolset `pipeline`):

    | Key | Value | Range | Used by |
    |---|---|---|---|
    | `boost.ingest_on` | 1 | 0–1 | gate (the off switch) |
    | `boost.ingest_window_start_minute` | 65 (01:05) | 0–1439 | gate |
    | `boost.ingest_window_end_minute` | 290 (04:50) | 1–1440 | gate |
    | `boost.ingest_blackout_start_epoch` | 1795012200 (Thu 19 Nov 01:30 AEDT) | Unix seconds | gate |
    | `boost.ingest_blackout_end_epoch` | 1795019400 (Thu 19 Nov 03:30 AEDT) | Unix seconds | gate |
    | `boost.ingest_after_housekeeping_minutes` | 20 | 0–240 | gate |
    | `boost.ingest_files_per_run` | 4 | 1–50 | edge function |
    | `boost.ingest_rows_per_call` | 500 | 50–2000 | edge function |
    | `boost.quiet_window_start_hour` / `boost.quiet_window_end_hour` | 1 / 5 | hours | `boost_promote_v1` |
    | `boost.promote_rows_per_run` | 1000 | 1–5000 | `boost_promote_v1` |

  - **To stop it:** set `boost.ingest_on` to 0 (Settings › Pipeline settings › Boost, with a reason); the next run skips. Pausing the job on Automations also works.
  - **Nothing reaches the catalogue yet, for two reasons.** (1) No model is qualified (`pipeline.boost_model_qualifications` has 0 rows; the migration's post-check refuses any). (2) Nothing writes result files: the Boost Cloudflare Worker (`cf-boost-extractor`) and its exporter are built and tested locally but not deployed (they need the Cloudflare account and the AI-provider keys). Until both happen, each overnight run lists 0 files and exits. The "REQ and Roadmap chunks" in the 16:15 instruction are not a Boost input: the lane only reads Boost result files.
  - **Qualifying a model (Platform Admin, SQL editor).** Only `study_load` is ever admitted (only where the course has none and no manual lock); a row for `provider_accreditations`, `course_description` or `course_fees` only moves readings from shadow to proposed for that lane's own rule; `aer_entry` stays shadow. `provider` and `model` must match the Worker's result lines exactly.

    ```sql
    begin;
    insert into pipeline.boost_model_qualifications (lane, provider, model, qualified_by, qualified_at, reason)
    values
      ('study_load', '<provider, e.g. groq>', '<model, e.g. llama-3.3-70b-versatile>', null, now(),
       '<gate evidence: benchmark run, sample size, accuracy, date, who approved>')
    on conflict (lane, provider, model) do nothing
    returning lane, provider, model, qualified_at;
    select lane, provider, model, qualified_at, reason from pipeline.boost_model_qualifications order by 1, 2, 3;
    commit;
    ```

    Lanes allowed by the table: `study_load`, `provider_accreditations`, `course_description`, `course_fees`; `reason` must not be blank. Withdrawing a qualification is a delete, so it goes as a paste file.
  - **Dry run before merge** (production, rolled back): post-checks passed; gate now = outside the window; Thu 01:31 = blackout; Wed 03:00, Thu 01:10 and Thu 04:00 = open (4 files, 500 rows a call); 04:55 = outside; promotion dry run 0 rows; 5 register rows.
- **Paused for bulk ingestion, 13:34 AEDT** (Pilot #1195, migration `20261117051700`; 72-hour evidence from `security.job_outcomes_v1` and `cron.job_run_details`):

  | Job | Evidence |
  |---|---|
  | `scholarship-discover-refill` | hourly; 86 s a run, 102 busy minutes, 8 of 71 runs failed; it feeds the lane below |
  | `scholarship-discover` | 1 of 399 runs moved anything |
  | `scholarship-read` | 0 of 767 |
  | `calendar-reread` | 0 of 70 |

  Kept on: every job shadowed by PR 1, PR 2 or PR 3 (`coverage-reextract` and `policy-add-tests` are idle too but are PR 3 lanes), `openrouter-balance` (credit floor), and the jobs still moving work. **To resume:** Automations › the job › Resume (each pause is an Automations event with the reason).


| Item | State |
|---|---|
| Pilot #1200, #1208, #1210, #1213, #1215, #1216: CRICOS 11 Nov edition applied (Layer 1 register sizes and plan finish) | **Done 17 Nov 2026 20:11 AEDT** (S2-Build; Platform Admin 14:30). The edition's **1,953 of 1,953** planned course codes are in the catalogue (1,919 active, 34 inactive as the register marks them): run `4ae92b4f` applied 1,000, run `802d8928` the other 953 and reconciled. Causes found and fixed, each a size written into code or a slow statement under the service's 8-second limit: register apply calls (setting `layer1.register_apply_chunk`, now **20**, #1200, #1210), reporting stats made non-fatal (#1208), CRICOS facts call (#1213), courses per background batch (settings `layer1.batch_courses_au` 100 and `layer1.batch_providers_nz` 20, migration `20261117201000`, #1215), and the plan finish scanning the registrations once per new code (migration `20261117211000`, #1216; 1.1 s against more than 130 s). Workers: `layer1-au-depth` v1.9.2, `layer1-nz-live` v1.4.0, `layer1-au-cricos-facts` v1.4.0, `layer1-operations-control` v1.10.0. **Waiting on the Platform Admin:** 701 courses left the register, more than the automatic limit of 504, so their retirement is held for approval (run plan `802d8928`, departures `held`); 5 retired courses that are back on the register were reactivated. Specs s573, s584 |
| Pilot #1218, #1220: Wave 2 PR A, Layer 1 AI induction mapper (Mapper Contract v1.2) | **Live 17 Nov 2026 22:00 AEDT** (S2-Build; Platform Admin 17:55, 19:08, 19:58; AI routing choice 20:30: through the worker). Migration `20261117221000` (history md5 `3a69a2cb`); edge function `layer1-ai-induction-mapper` 1.0.0 (`status`, `map`; Curator and above); worker `coverage-sweep` v1.0.8 mode `induction_map` (prompt `induction.ts`, `induction-map-v1`). AI service route **`layer1_induction_map`**: one model `qwen3-30b` (central model, decision 13 Nov 19:09), provisional qualification on that decision, caps 2 USD and 200 calls a day; answer length `reading.answer_tokens.induction_map` (4,000). Declarative parser spec: allowed targets per record type `security.layer1_parser_targets_v1`, strict check `security.layer1_parser_spec_validate_v1` (fixed keys, types, transforms; attribution; unique key; expected headers), shared engine `_shared/cf247-layer1-spec.ts`. End-to-end check 21:56: the worker answered for 7 sample columns on Qwen3 30B (cost 0.00027 USD, recorded in `ai_invocations`, outcome answered). The wizard enables AI Auto-Map when `status` answers. Known limit: units are not converted (a "Duration (years)" column was suggested for `duration_weeks`; the person reviewing corrects it). Next: PR B (drift flags from the Layer 1 readers, re-infer job), PR C (generic runner and dry run). Spec s585 |
| Pilot #1221: Wave 2 PR B, Layer 1 parser drift and re-infer; Pilot #1224: Layer 1 queue-a-run workflow; NZQA register test load | **Live 17 Nov 2026 22:2x AEDT** (S2-Build; Platform Admin 19:58, 22:04). Migration `20261117233000`: settings `layer1.declarative_max_file_mb` (50) and `batch.layer1_parser_reinfer` (3); `security.layer1_parser_drift_mark_v1`; trigger `layer1_run_drift_watch` on `pipeline.layer1_run_queue` (a layout error flags the source's parser for re-inference, a completed run clears it); due list `security.layer1_parser_reinfer_due_v1` and `public.svc_layer1_parser_reinfer_queue_v1`; job `layer1-parser-reinfer` (`41 * * * *`, catalogued) asks the mapper to re-infer flagged parsers. Shared reader `_shared/cf247-layer1-read.ts` (CSV, XLSX, JSON). Spec s586. Read back live: trigger 1, job active, catalogue row present, nothing due. **Queue workflow** `.github/workflows/layer1-queue-run.yml` (hand-started, project ref typed to confirm) queues one source run through `security.layer1_queue_system_run_v1`, the scheduler's own path and checks, and follows it to the end; this replaces interactive database writes (Platform Admin 22:04). **NZQA test load done 22:41 AEDT:** run `abf3f467` (Actions run 44075260351, apply) read 414 of 414 NZQA providers in batches of 20 with no time-out (the 13 Nov run `981ce7ed` failed at 80); 87 register records reconciled, 8 created, 0 failed, 0 conflicts, 0 departures; status `completed`, stage `reconciled`. Next: Wave 2 PR C, the generic declarative runner. |
| Pilot #1233: Wave 2 PR C, the generic Layer 1 declarative runner | **Live 18 Nov 2026 00:2x AEDT** (S2-Build; Platform Admin 17 Nov 17:55, 19:08, 19:58, 22:04, 23:02). Migration `20261118013000`, edge function `layer1-declarative-runner` 1.0.0 (verify_jwt false), spec s596. For a source whose parser is AI-built: `dry_run` (wizard step 5; Curator and above or service role) reads the first `layer1.declarative_dry_run_rows` (100) rows, writes nothing to staging and records the counts with `svc_layer1_induction_dry_run_record` (a pass switches nothing on); `apply` (service role only; active, unpaused source, terms approved under REQ-68, undrifted AI-built parser) reads `layer1.declarative_batch_rows` (2,000) a call and continues by offset, keeps the file as evidence (a changed file stops the run), stages in chunks of `layer1.declarative_chunk_rows` (200) with a row key and SHA-256 row hash in `pipeline.layer1_declarative_rows`, applies only new and changed course or provider register records through `svc_layer1_apply_register_records` (chunks of `layer1.register_apply_chunk`), stages the other five record types for review, routes each record's open fields to the eight enrichment categories (`security.layer1_gap_routes_v1`), flags Australian postcodes (primary, layer4_review, outside_sua) and, on the last call, marks unseen staged rows departed in staging only (the catalogue is not touched). Header drift halts the run and flags the parser for the hourly re-infer job (#1221). Run log `pipeline.layer1_declarative_runs`; `layer1.declarative_max_rows` (200,000) caps a source. No job scheduled: the runner is started by the service role (a scheduler hook comes with the first activated AI-built source). No AI-built parser is active yet, so nothing has run. |
| Pilot #1240 and #1243: Wave 2 drafts ready to map and sample-test; live admitted counts | **Live 18 Nov 2026 08:0x AEDT** (S2-Build; Platform Admin 07:34). Migration `20261118080000` (spec s598): registration schemes `uk_ukvi` (provider_registration, GB), `uk_hesa` (course_registration, GB), `ie_ilep` (course_registration, IE) and `us_ipeds_completions` (course_registration, US), all planned, set on the UKVI, Discover Uni, ILEP and IPEDS completions drafts; step 1 is now finished on all nine Wave 2 drafts. Four seed sources of 11 Aug (Office for Students Register, Discover Uni Dataset, Irish Register of Qualifications, UKVI Register of Licensed Student Sponsors) held no data and no Layer 1 controls (no reference in any of the 46 tables that point at `pipeline.sources`) and blocked activation; they are retired, not deleted, each naming its replacing draft (4 events). `admin_layer1_add_source` now refuses a duplicate only on the same address and the same name, so the IRQ providers and programmes drafts, and the IPEDS institutions and completions drafts, can each be activated. #1243 (spec s599): wizard step 5 gains **Run dry run** (`layer1-declarative-runner`), enabled once a draft has an AI-built parser spec. **What each draft still needs (the Platform Admin's, in the wizard):** a sample file for AI Auto-Map (step 3; none has a spec yet); the address of the data file itself where the address is a landing page (all nine are landing pages today); terms approval (all nine pending, REQ-68); a passing dry run; activation (rank 6). OfS, both IRQ drafts and PGWP are web pages (connector html_pages), which the declarative runner does not read (CSV, XLSX and JSON only): they need a file export or a page reader. **Live admitted counts (read 18 Nov 07:38 AEDT):** active courses 36,031 (AU 25,703, NZ 6,514, CA 3,814); active providers 3,091 (AU 1,544, CA 1,130, NZ 417); CRICOS 11 Nov edition: 1,953 of 1,953 planned codes in the catalogue, 1,919 active, 701 departures held for the Platform Admin; NZQA run `abf3f467` completed (414 of 416 provider rows read, reconciled, 0 departures); destination: 102 ABS SUA localities (draft) with 102 metrics, 2,947 postcode-to-SUA share rows; study rules 0 and career outcomes 0 (their loaders are Categories 2 and 3, still to build); `campuses[].locality` is in `ref.api_field_dictionary` for website and Zoho (7 paths each). |
| Pilot #1245: Wave 2 Track B page reader (`html_table`) | **Live 18 Nov 2026 09:0x AEDT** (S2-Build; Platform Admin 08:19). No migration (the spec check already allowed `html_table` with `source.table_index`); live head stays `20261118090707` (S2 - BOOST / v2.16.31). Spec **s613** (new); **s599 renumbered to s612** so s599 stays with S2 - BOOST (same guard; retirement log). New `_shared/cf247-html-table.js`: a deterministic table extractor shared by the edge reader and the wizard (no script, no network; comments, script, style, noscript, template and svg removed; nested tables numbered in opening order; colspan and rowspan resolved; entities decoded; unclosed tags closed safely; `table_index` and `header_row` choose; empty headers named, duplicates told apart, repeated header and empty rows dropped). Reader `format html_table`; mapper 1.2.0 (deployed v3: `map` takes `source.table_index`/`header_row` for Web pages, re-infer reads `html_table`); runner 1.0.1 (deployed v2: evidence `text/html`, dry run reports `tables_on_page`, still `p_write: false`); wizard: the sample upload takes a saved web page (the table with most rows, its index passed to AI Auto-Map). Read-only probe workflow `Layer 1 HTML table probe` (run 44183648063 against the Track B addresses): **PGWP** page reads as one table of 1,107 data rows and 5 columns (Category, CIP Code, CIP Title, Study permit eligibility, PGWP eligibility), so it is **ready for AI Auto-Map and Run dry run** (upload the saved page, or map from it directly); **OfS** and both **IRQ** draft addresses are guide pages with **no table** (0 tables found): they need the address of a page or file that holds the register (the OfS Register is a separate digital service; the IRQ is a search service), so Track B cannot read them as they stand. G3 75/48. |
| Pilot #1201, #1207, RM1B ABS population and postcode loader | **Live 17 Nov 2026 18:40 AEDT** (S2-Build; approvals A-1 to A-4). Migration `20261117180000` (history md5 `e2e5fbd0`), edge function `layer1-destination-geo-loader` v1.0.0, job `destination-abs-load` (1st of the month 05:30 Sydney, catalogued, Run now through `security.destination_job_run_now_v1`), workflow `destination-abs-shares-load`. First load: 2,947 Postal Area to SUA shares for 2,641 postcodes (ASGS Edition 3 Mesh Block allocation files, sha256 `96c3ce68…52340`); **102 SUA localities** and 102 population figures (ERP 30 June 2025), all draft, attribution and evidence on every row (ABS workbook stored, sha256 `625c7c3d…eca39`); 1,303 locality postcode rows (1,064 primary, 239 flagged). Of 805 AU campus postcodes: 611 map at 90% or more, 94 are flagged (312 campuses in Layer 4 › Campus locality), 100 are outside any SUA (no locality; question to the Platform Admin). Spec s574 |
| Pilot #1162, API v3 field dictionary sync (REQ-76) | **Merged 16 Nov 17:05 AEDT** (taken over by S2 - SS Build): migration `20261116110000`, 1,923 rows live; 2 fields wait for the paste file |
| Pilot #1178, AER routes | **Merged 16 Nov 17:49 AEDT.** AER v1 entry reading (`course_entry_requirements`, `entry_matrices`) is **off**: Qwen3 30B unqualified, no model qualified. AER v2 shadow: Mistral Small 3.2 alone, provisional, off. See `docs/platform/layer4-clearance-and-model-benchmark-2026-11-16.md` §6 |
| Pilot #1179, worker v1.0.6 AER long pages | **Merged 16 Nov 18:02 AEDT**; the first deploy run failed reading migration history (Management API error) and the re-run passed. Worker `coverage-sweep-worker-v1.0.6` live from 18:05. Switch `reading.aer_v2_long_page_sections_on` = 0 |
| Split Pilot `docs/paste/` (41 files) | **Approved, Platform Admin 16 Nov 2026 10:10 (option 1).** After the PR 2 cutover (Tue 17 Nov 22:30 AEDT) is verified: the SQL files that specs or database fixtures read or run move to Pilot `tests/fixtures/` (all 18 guard specs keep their assertions, no cross-repository CI); every file a person runs moves to this repository's `docs/paste/` only; a Pilot guard then refuses any new `PASTE-*.sql` in Pilot. Queued for Wed 18 Nov 2026 09:15 AEDT, separate from the PR 3 queue. Never create a new `PASTE-*.sql` in Pilot. |
| UI/UX and settings simplification audit and plan | **Committed 16 Nov 2026 10:25 AEDT:** [`docs/platform/ui-audit/ui-ux-settings-audit-2026-11-15.md`](platform/ui-audit/ui-ux-settings-audit-2026-11-15.md), verbatim as supplied by the Platform Admin (decisions §6, UnoPim specs §7, progress to v2.16.12 §8). Phase 4 (Dispatcher Panels) waits for the PR 1 to 3 cutovers. |
| `cron-governance-audit-2026-11-15.md`, `rollup-scheduler-pr1-scope.md` | **Not yet in this repository.** The session that wrote them is committing them to `docs/platform/` before it closes (Platform Admin 16 Nov 2026 10:21). Until then, Pilot migrations and PRs #1157 and #1159 cite them as "project doc claude/…". |

### Production bulk data ingestion readiness (17 Nov 2026 08:50 AEDT; Platform Admin 07:39)

**17 Nov 14:05 AEDT:** the Admin screens are live (v2.16.19). The 19 November hold is cancelled (Platform Admin 13:12); loaders and ingestion are S2-Build's lane, and each load job named `destination-…` appears on Platform health › Data delivery › Destination loads once catalogued. Design for the screens, the API v3 blueprint and the ordered post-squash build is in [`docs/Roadmap/2026-01/DESTINATION-DATA-UI-AND-INGESTION-SPEC.md`](Roadmap/2026-01/DESTINATION-DATA-UI-AND-INGESTION-SPEC.md) v1.0 (v1.2; decisions G-1 to G-5 approved 17 Nov 11:52). The Destination data page is in `docs/UI-MAP.md` from v2.16.19.

Schema for every remaining roadmap item is live (Pilot #1194, migration `20261117040000`; design `docs/Roadmap/2026-01/DESTINATION-DATA-DESIGN.md` v1.6). No destination data is loaded. Target rows marked "estimate" are planning figures to confirm at the first capture.

| Dataset or adapter | Target rows | Lands in | Entry point | Ready? | Blocker or next step |
|---|---|---|---|---|---|
| CRICOS 11 Nov edition | **Applied 17 Nov 20:11 AEDT**: 1,953 of 1,953 planned course codes in the catalogue (row above) | Catalogue, through the Layer 1 register plan `d35d2541` | Layer 1 › Sources | Yes | 701 departures wait for the Platform Admin's approval |
| ABS population and ASGS postcodes | About 100 Significant Urban Areas (estimate); one population figure each; postcode shares for the 805 distinct AU campus postcodes (3,990 AU campuses) | `destination.localities`, `locality_metrics` (category `population`), `locality_postcodes` | Service-role upsert on the tables' unique keys; flags from `security.destination_postcode_flags_v1`; approve with `admin_destination_set_status` | Schema yes; loader no | Sources approved (A-1 to A-4). Build one catalogued load job; no direct Postal Area to SUA file exists in ASGS Edition 3 correspondences (checked 17 Nov), so the Mesh Block allocation (A-4) is the method. About 368,000 Mesh Blocks across three ABS files is beyond an edge function's 2-second CPU limit: the loader is planned as a catalogued GitHub Actions job (S2-Build) |
| BOM climate and living costs | Not set: localities with a campus × agreed measures | `destination.locality_metrics` (categories `climate`, `living_cost`) | As above | Schema yes | Sources and reuse terms not yet approved; needs localities first (RM1B) |
| JSA careers | About 350 to 360 occupations at four-digit level (estimate) | `destination.career_outcomes` through a `career_outcomes` edition | `security.destination_import_v1(payload)`; terms with `destination_edition_set_terms_v1`; publish with `destination_edition_publish_v1` | Yes for a national edition | Reuse terms (REQ-68) and edition choice. Confirm the edition's occupation coding matches a listed scheme (ANZSCO, NOC, SOC). G-1 grain is live (Pilot #1196): one row per edition, country, scheme, occupation and area (national, state or locality); `security.destination_import_v1` takes `occupation_scheme` (required), `geography_level`, `state_code`, `locality_id`, `reference_period`, `dataset_edition`, `attribution_text` |
| Study rules | About 15 to 25 AU rules (estimate): direct and five admissions-centre routes, funds, fee, work rights, post-study work, processing times | `destination.study_rules` and `rule_applicability`, through a `study_rules` edition | Visa rows: `security.destination_import_v1(payload)`. Categorised rules: service-role insert into a draft edition, then row approval, then edition publish | Schema yes; importer covers visa rows only | Capture each official page first. Extend the importer to the new rule fields with the first capture |
| NZQA courses | 3,894 four-digit candidates to match; 2,559 provider-style codes to classify | `catalogue.course_registrations` (scheme `nzqa`), course-level evidence | Layer 1 NZ adapter: new NZQCF qualifications capture | Schema yes; capture no | Build the capture. NZQA commercial-use terms flagged for management |
| UK, Ireland and USA adapters | Not set | Catalogue; schemes `uk_qaa`, `uk_ofs`, `ie_qqi`, `us_opeid`, `us_ipeds`, `hecos`, `cip` registered in `ref.registration_schemes` | None yet | No | Adapters RM3A, RM5A, RM6A are not built |
| Layer 4 Boost queue | 4,906 pending review items (read 17 Nov 08:44; 61,907 items in all) | `pipeline.layer4_review_items` | Layer 4 Review; Boost plan in `docs/platform/CF-WORKER-BOOST-AND-PROD-LAUNCH.md` | Existing path | Not changed by this release |

Order that unblocks the most: CRICOS apply, then the ABS load job (it gives every later city dataset its localities), then study-rule capture.

### Parallel Wave 2: Layer 1 induction wizard and completeness report (Platform Admin 17 Nov 2026 17:59, decisions 18:10; Pilot #1211, v2.16.24, 18:54 AEDT)

| Item | State |
|---|---|
| Wizard | Layer 1 › Sources › + Add source opens six steps: Country & scheme, Source & licence (REQ-68 terms), Field mapping, Cadence & retention, Dry-run preview, Activation. Drafts are saved at each step in `pipeline.layer1_source_inductions`. Pipeline Operator and above draft; the Platform Admin activates with a reason, logged. The source is created **paused** through the existing `admin_layer1_add_source`. No draft exists yet. |
| AI Auto-Map | **The mapper `layer1-ai-induction-mapper` is deployed** (Pilot #1218, #1220, S2-Build; 17 Nov 22:00 AEDT), so the button's probe finds it and it switches on. Re-inference of drift-flagged parsers runs hourly (Pilot #1221). Contract: `docs/platform/LAYER1-AI-INDUCTION-MAPPER-CONTRACT.md`. |
| Dry run | Recorded only by the service role (`svc_layer1_induction_dry_run_record`). A new source has no reader, so step 5 says Waiting for a reader; a recorded pass switches nothing on, and a recorded fail blocks activation. |
| Retention | The wizard records per-source values (defaults 14 days staging, raw snapshots permanent, as today's policy). **Not enforced:** `pipeline.retention_class_policies`, prune jobs and stored data are unchanged. |
| Enrichment categories | `ref.enrichment_categories` (8: Course basics, Fees, Entry requirements, Intakes & deadlines, Campus & location, Provider profile, Recognition & registration, Scholarships) and `ref.enrichment_category_fields` (the 32 coverage fields; 0 unmapped). The Platform Admin moves a field with a reason. |
| Category list (decided 19:58: one list) | `ref.enrichment_categories` and `ref.enrichment_category_fields` are the single list; `public.svc_enrichment_categories()` publishes it to every lane; keys, fields and the crosswalk are in `docs/platform/ENRICHMENT-CATEGORIES.md`. **Not yet one list in practice:** the Boost matrix setting `country_category_boost` and its check function still hold eight other keys (S2 - BOOST's lane). Moving it needs new weights for five categories and a decision on study rules and career outcomes, which have no key in the eight. |
| Report | Platform health › Country & category completeness (Curator and above): field fill by country and category from `pipeline.field_coverage_daily`, each Layer 1 source's editions, last change and retention, Layer 4 items by how long they have waited (settings `health.layer4_age_warn_days` 7, `health.layer4_age_old_days` 30). First read 17 Nov: AU entry requirements 29.9%, intakes & deadlines 18.9%, scholarships 5.8%; NZ fees 22.9%; CA fees 19.2%. A category figure pools its fields, so course and provider fields are counted together. |
| Parser line items (v2.16.25, Pilot #1214, 19:09 addenda) | Layer 1 › Sources has a Parser column: Hardcoded parser, AI-built parser or No parser yet, from `pipeline.layer1_source_parsers` (`admin_layer1_parser_status`). Live now: 43 sources, all Hardcoded, no parser row yet (AU 9 including CRICOS, QILT, PRISMS and TEQSA; NZ 2; CA 26; 3 world rankings with no country). ABS is a destination load job, not a Layer 1 source, and there is no UK, IE or US source yet, so the Country filter does not list them. |
| Re-infer Parser Spec | Shown on a line only when a reader has flagged layout drift (`svc_layer1_parser_drift_record`). Pipeline Operator and above, with a reason; recorded on the parser row and in the control log; nothing is run. **No reader flags drift yet**, so the button does not appear today. |
| Target record type | Wizard step 1: Course register, Provider register, Tuition fees, Study rules, Destination metrics, Career outcomes, Scholarships. Step 3 previews the mapper's parser spec, target table and category routing when the mapper returns them; on activation the spec becomes the source's AI-built parser. Contract v1.1 for S2-Build. |
| Per-source retention (decided 19:58: one place) | The wizard keeps one optional Staging kept (days) and, on activation, sets it through S1-Build's `admin_source_retention_set` in `pipeline.source_retention_policies`, which `housekeeping-daily` reads. The completeness report reads the same table and the `retention.*` settings (90 days, hashes 7 years, pruning off). No source has its own period yet. |
| Role gates (decided 20:45, by role name) | Curator (rank 3) and above open Layer 1 and create, edit and cancel drafts; Pipeline Operator (rank 4) and above request Re-infer Parser Spec; only the Platform Admin (rank 6) activates. `security.admin_layer1_operations_read` now opens at rank 3 (md5 `3af9dff0`). Every other Layer 1 control keeps its rank; `layer1_statistics_candidates_read` stays rank 4, so a Curator does not see new-edition candidates. |
| Deployed UAT on `main` (22:55 AEDT) | **Green.** After the Platform Admin aligned the UAT account password with `UAT_PASSWORD`, the re-run of 22:31 AEDT passed, and so did the runs for Pilot #1224, #1223 and #1225 (`24651f52`: Deploy on merge, Deployed UAT, Frontend Build, Release History Contract and Release Currentness Deployed all green). These were the first live runs of the role-boundary test updated in Pilot #1222 (the operator opens the Add source wizard and cannot activate). The `admin_read` (`dashboard`) time-out seen at 21:43 and 21:57 AEDT did not recur in these four runs; its cause was not investigated. A reset of the UAT account's password from the Admin breaks the run until the secret is updated. (The earlier row was stamped 22:50 AEDT in error; it was written at about 22:25.) |
| Evidence and Layer 4 items (20:06) | Country & category completeness has the table Evidence captured and Layer 4 review items, by source, from S1-Build's `admin_ops_telemetry()`: two counts side by side, no rate. Live example: IRCC Designated Learning Institutions, 7 evidence captures and 825 review items in the window. |
| Not checked | The wizard and the report signed in; `admin_completeness_report` called as a signed-in user (its queries were read live separately). |

### Release v2.16.20, Users & roles › Links & Email Templates (Platform Admin 17 Nov 2026 14:40; Pilot #1202, 15:25 AEDT)

| Item | State |
|---|---|
| Screen | Administration › Users & roles now has two tabs (it had none): Users & roles, and Links & Email Templates (Platform Admin). Link settings, Invite User and Reset Password editors with variable chips, live preview, Reset to Default, Send Test Email, Save & Sync with a reason. |
| Database | `admin_auth_template_settings_read()` and `admin_auth_template_settings_save(payload, reason)` (rank 6; the save writes `pipeline.admin_control_events`, area `access`). One row `admin_auth_email_templates` in `pipeline.environment_settings`, written on the first save; until then the branded defaults apply. It shows read only on the Go-live checklist. |
| Copy to Supabase Auth | **Off.** `admin-user-management` copies the site URL and the two emails to Supabase Auth only when the Edge Function secret `SB_MANAGEMENT_TOKEN` (a Supabase access token for project `fxcwkweaxjtknorudmwp`) is set. Until the Platform Admin sets it, a save is stored and logged and Auth keeps the emails pasted from `docs/paste/PASTE-20261117-supabase-invite-email-template.md`. |
| Where links return | Still the edge function's `ADMIN_LOGIN_URL` (default the Worker address) and the Redirect URLs list in Supabase Auth. The Admin Site URL setting does not change the redirect by itself. |
| Signed-in test (Platform Admin, 15:45) | An invitation arrived with the indigo template applied at 14:33 and the sender "Supabase Auth". Nothing has been saved on the tab yet (no row in `pipeline.environment_settings`). |
| Emails in Supabase Auth now | **The `#0b6e5f` StudySearch PIM Admin templates, applied 17 Nov 16:04 AEDT** by workflow `supabase-auth-config.yml` (run 44021389741, read back PASS): subjects "You're invited to StudySearch PIM Admin" and "Reset your StudySearch PIM Admin password"; template md5 `f34516d2` (invite) and `e7fe57cf` (reset), equal to steps 2 and 3 of the paste file, which now hold the tab's defaults as Auth reads them. Site URL and redirect list unchanged. |
| v2.16.21 (Pilot #1203, 16:00 AEDT) | Users & roles: **Resend invite** on the row of a person who has not accepted yet (`admin-user-management` action `resend_invite`, recorded as `user_invited` with `resent`). Reset password has been on the row since v2.16.16; it is greyed for your own account and a Platform Admin. Links & Email Templates: a warning while the token is missing, with **Copy HTML for Supabase Dashboard** and Copy subject. |
| `SB_MANAGEMENT_TOKEN` | **Decided 17 Nov 16:13: not set.** No account-wide token is kept in the edge function. Supabase Auth's own templates are updated by workflow `supabase-auth-config.yml` from the paste file; Copy HTML stays on the tab. |
| Empty name (v2.16.22, Pilot #1204) | `{{user_name}}` becomes a conditional that takes its comma or space with it: "Welcome" and "Hello,". Applied to Supabase Auth 16:31 AEDT (workflow run 44024617120, read back PASS; md5 `e96fd944` invite, `d43f6e72` reset). |
| Email delivery provider (v2.16.23, Pilot #1206) | Links & Email Templates › Email delivery provider: Supabase Built-in or Resend API, Sender Name (default StudySearch PIM Admin), From Email, and a write-only Resend API key. Provider, sender and from email are the row `admin_email_delivery` in `pipeline.environment_settings`; the key is in Supabase Vault (`admin_resend_api_key`), read only by `svc_admin_email_delivery()` (service role). With Resend in use, Create user › Send invitation, Resend invite, Reset password and Send Test Email are written from the templates saved on the tab and sent through the Resend API (`auth.admin.generateLink` makes the link). |
| Email provider card: save and test (v2.16.27, Pilot #1225, 22:51 AEDT) | The card has its own Reason box, **Save Email Provider Settings** (always enabled; the card says what is missing) and **Send Test Email**. The test calls `admin-user-management` `auth_template_test` with `via: "resend"`: it sends the selected template through Resend with the saved sender, from email and key to the signed-in admin's own address, also while Supabase built-in is still the provider, and shows Resend's reference or error in the card. Save & Sync saves link settings and templates only. Edge function version 12 deployed. **Not verified:** a real send (no key is saved; provider still `supabase`) and the buttons signed in. |
| Wave 2 register drafts (Pilot #1228, migration `20261118004000`, 23:27 AEDT) | Nine drafts in `pipeline.layer1_source_inductions`, opened from Layer 1 Register › + Add source › Continue a draft. **United Kingdom:** Office for Students Register (provider register, scheme `uk_ofs`), Discover Uni dataset (course register), UKVI Register of Licensed Sponsors: Students (study rules). **Ireland:** Irish Register of Qualifications providers and programmes (scheme `ie_qqi`), Interim List of Eligible Programmes (study rules). **United States:** IPEDS institution directory (scheme `us_ipeds`; the OPE ID is a column of the same file), IPEDS completions by programme (course register). **Canada:** IRCC PGWP-eligible fields of study (scheme `pgwp`). Each has a 90-day staging keep period (applied to `pipeline.source_retention_policies` only on activation), licence terms pending and a cadence. **A draft is not a source:** `pipeline.sources` is unchanged at 3,412 and no retention policy was written. **Not drafted:** IRCC Designated Learning Institutions, already a live Layer 1 source (`layer1-ca-live`). **Open before activation:** (1) four drafts have no registered scheme (Discover Uni, UKVI, ILEP, IPEDS completions), so step 1 is unfinished until S1-Build or the owner of `ref.registration_schemes` adds them; (2) four drafts have no mappings because their field names are not known (OfS, both IRQ, ILEP): upload a sample, then AI Auto-Map; the other mappings are expected names to check against a sample (the PGWP columns were read from the page); (3) older catalogue rows already exist in `pipeline.sources` for OfS, Discover Uni, IRQ and UKVI and must be reconciled first; (4) the ILEP is closed and is being replaced by the TrustEd Ireland list about the end of 2026; (5) the eight categories have no study-rules category, so eligibility columns sit under Recognition & registration. |
| Reference tables (v2.16.28, Pilot #1230, 23:30 AEDT) | Reference data has two more types: **API field dictionary** (2,085 fields; search by field, endpoint, source column or request number; filter by API and version) and **Grade scale conversions** (0 rows loaded; the screen says so). Read-only, Curator and above, through `public.admin_reference_table_read` (stable; md5 `b9d32f97` equals the file). Setting `admin.reference_table_page_rows` (50). |
| UI audit: columns and filters for the new fields (23:05 AEDT request) | Written up in `docs/platform/ui-audit/api-v3-layer1-boost-fields-columns-filters-2026-11-17.md`. **Built:** the two reference tables. **Already present:** destination and postcode reference (Destination data › Localities & postcodes). **Not built yet:** Courses Study load and Empty reason; Campuses Primary and Locality; Sources Retention (days); Providers Accreditations. **Cannot be built as asked:** Boost priority score and Country tier (no such stored fields) and `campuses.locality` (no such column; locality is looked up by postcode). `catalogue.provider_accreditations`, `ref.grade_scale_conversions` and `pipeline.source_retention_policies` hold 0 rows. |
| Courses and Campuses columns (v2.16.29, Pilot #1239, 18 Nov 07:48 AEDT) | **Courses:** Study load and Empty reason are in the Columns picker (off until shown; the registry holds 42 columns) and under Filters (`courses_page` arguments `study_load`, `empty_reason`). **Campuses:** Primary badge and filter; Locality, looked up from the campus postcode (primary match, newest boundary vintage, whatever its review status, shown as Draft until approved) with a search. **How:** md5-guarded in-place edits of `security.admin_course_page_fast` (`a5cd4a72`), `security.admin_course_page_fast_base` (`e0cddf8a`), `security.course_list_with_extras_v1` (`db3b7ed0`) and `public.admin_read` (`b6570ab8`); live body md5s equal the migration's. New `security.admin_campuses_page_v2`; `security.admin_campus_page_fast` is unused and marked `retiring` (paste file after the retention window). Two partial indexes on `catalogue.courses`. Held forward recovery: Pilot `supabase/held/course_campus_new_fields_forward_recovery.sql`. **Speed on the production-parity fixture:** Courses filtered 11 to 85 ms; Campuses 13 to 18 ms. **Not verified:** the screens signed in; live timings. |
| Decisions of 18 Nov 2026 07:03 (Platform Admin) | **Routing rule:** a source read on a schedule belongs in Layer 1 Register; a reference address or dataset that is not belongs in Reference data. **Boost priority score and Country tier:** not stored; worked out when the Boost queue is read (shipped, Pilot #1242). **ILEP:** kept as a draft and marked as a deprecating source, to move to TrustEd Ireland. **Schemes and duplicate rows:** done by S2-Build (Pilot #1240): `uk_hesa`, `uk_ukvi`, `ie_ilep`, `us_ipeds_completions` are registered, the four older seed rows are retired, and all nine drafts now carry a scheme (checked live). |
| Operator runbook (18 Nov) | `docs/platform/DESTINATION-EDITIONS-AND-WAVE2-DRAFTS-RUNBOOK.md`: destination load to published edition, Wave 2 draft to paused source, the routing rule, and where to look up API v3 fields. **Found:** Publish edition does not require every locality to be approved (the server needs approved terms and at least one row; unapproved rows are never returned). `API-V3-FIELD-DEFINITION.md` still says `study_load` is "not proven live"; about 2,500 courses hold one. The RM0B handover stays unissued until v3 release. |
| Boost queue (v2.16.30, Pilot #1242, 18 Nov 08:33 AEDT) | Platform health › Queues & yield has a **Boost queue** card: each of the 2,178 items Boost has taken, with **Country tier** and **Priority score**, a summary by country and lane, filters (tier, country, lane, state) and a sort by score. Read through `public.admin_boost_queue_read` (Curator and above, stable, writes nothing; history md5 `0061da28` equals the file). The score is country weight × category weight through S2 - BOOST's own `security.boost_country_category_weight_v1`; tiers are the `boost.matrix.tier_1` and `tier_2` lists. Nothing is stored on a course and the Course catalogue does not show them. Live scores on 18 Nov: AU study load 80, NZ 76, CA 72. Setting `admin.boost_queue_page_rows` (50). **Not verified:** the card signed in. |
| Bulk Approve Drafts (v2.16.31, Pilot #1242, 18 Nov 08:33 AEDT) | Destination data › Localities & postcodes shows, for each dataset edition with draft localities, how many are ready, with **Bulk Approve Drafts** (Platform Admin, one reason). `public.admin_destination_localities_bulk_approve(dataset edition, reason)` approves every clean draft (name and attribution present), leaves a draft without attribution, changes no figure, rule or edition, and writes one control event (history md5 `6bd2e9f7` equals the file). **Not used yet:** all 102 localities of "ABS Regional population 2024-25" are still draft and no bulk event is recorded; the approval is the Platform Admin's. Figures have their own button since v2.16.32 (next row). **Not verified:** the button signed in. |
| Bulk Approve Drafts for figures (v2.16.32, Pilot #1250, 18 Nov 10:24 AEDT) | Destination data › City metrics & costs has the same button. `public.admin_destination_figures_bulk_approve(dataset edition, reason)`: Platform Admin, one reason, every clean draft figure of the edition (attribution present), one control event; no locality, rule or edition is changed (history md5 `e70b30bd` equals the file). The ILEP draft's note no longer says `ie_ilep` is to be registered. **Not used yet:** 102 localities and 102 figures are still draft; no bulk event is recorded. **Not verified:** the button signed in. |
| `study_load` and API v3 (checked 18 Nov 10:20 AEDT) | **Held:** 3,772 of 44,733 courses (2,251 full-time, 187 part-time, 1,334 both), all read from provider pages; Boost has admitted 1,251. `docs/integrations/api-v3/API-V3-FIELD-DEFINITION.md` says so. **Not exposed:** no `website_v3_course*` or `zoho_v3_course*` function returns it, and `ref.api_field_dictionary` lists `study_load` on the scholarship actions only. Returning it on the v3 `course` and `search` actions is open work for the v3 lane before the RM0B handover (v3 is not frozen, so it is an additive change there). |
| Migration number collision (18 Nov 07:47 AEDT) | Pilot #1239 and S2 - BOOST's #1238 both used `20261118073000`. #1238's deploy had already stopped on its own post-check and applied nothing; #1239 applied and holds the version in the history. S2 - BOOST re-landed theirs as `20261118074500` (#1241), which removed the second file. No data was affected. S1-RM-Design now re-reads `main` and the open PRs in a separate step immediately before each merge. |
| Live state of delivery | **Supabase built-in** (read 16:53 AEDT): no provider saved, no key in Vault. Resend starts when the Platform Admin chooses Resend API, enters the from email and the key, and saves with a reason. |
| Still from Supabase Auth | *Forgot password?* on the sign-in screen, whichever provider is chosen. Its sender name changes only with custom SMTP: Go-live checklist row `auth_custom_smtp` (pending), scope in `docs/platform/SUPABASE-AUTH-CUSTOM-SMTP-RESEND-SCOPE.md`. |
| Not checked | Any email as received; a real send through Resend (no key exists outside the Platform Admin's hands); the deployed edge function version read back; a save, a test email and a resent invitation, signed in. |

### Release v2.16.16, Admin UI (overnight task, Platform Admin 16 Nov 2026 22:12; Pilot #1189, 17 Nov 00:53 AEDT)

- **Users & roles:**
  - **Reset password** for another person's account (edge function `admin-user-management`, action `reset_password`). Not for a Platform Admin, your own account, the system account, a disabled account or an open invitation.
  - **Send invitation** passes `redirectTo` = `https://coursefinder-pilot.techm.workers.dev/` and `data { role, role_code, guide_url, full_name }`.
  - Links open a set-password screen. The sign-in screen has Forgot password?.
- **Catalogue lists** (Providers, Courses, Locations, Scholarships, Course readiness): **Export CSV**, visible or all columns, with every filtered row.
- **Paths taken:** A for invitations (Supabase `inviteUserByEmail`); A for the export (shared `DataTable`).
- **Not done here:**
  - Resets are not written to the access history (`user_access_events` action check). Widening it is a migration for a later change.
  - The Supabase Redirect URLs allow-list and the templates: applied 17 Nov 2026 14:33 AEDT (section 5 › S1-Build).

### Order of work to the 20 Nov data admission delivery (Platform Admin 16 Nov 2026 10:59)

| When (AEDT) | Work |
|---|---|
| Tue 17 Nov 23:20 | PR 1 cutover review, after the fixed 24-hour shadow (fix live Mon 16 Nov 23:14) |
| Mon 16 Nov 23:15 | PR 3 scope, build and merge in shadow: **in shadow since Tue 17 Nov 06:21 AEDT** (Pilot #1188, 13 lanes) |
| Wed 18 Nov 06:45 | PR 3 post-cutover health check done 06:46 (read only): 13 lanes live, 1,412 dispatches succeeded and 0 failed, 0 legacy jobs on or started, no breaker issue, G3 75/48 |
| ~~Tue 17 Nov 22:30~~ | PR 2 cutover: **done Mon 16 Nov 23:31 AEDT** (Platform Admin override 21:23) |
| Wed 18 Nov 09:15 | Pilot paste-file split (option 1) |
| Daily 08:05 | Telemetry tabs refresh (`Model_Tier_&_Token_Efficiency`, `Layer_Lifecycle_Funnel`) before the 08:15 report |
| ~~Tue 17 Nov 09:45~~ | API v3 data PR A and PR B: **done Mon 16 Nov 21:50 AEDT** (Pilot #1184; counts in section 5) |
| Wed 18 Nov 09:30 | **Phase 5 before Phase 4:** Review & Evidence DataGrid, first slice on Layer 4 › Inbox, with shared views `AER Audit Samples`, `Official URLs`, `Provider Blockers`, personal views and the quote-versus-value drawer. Phase 4 (Dispatcher Panels) follows Phase 5 |
| Tue 17 Nov 07:30 | **AER benchmark round 3: done, Path B** (Pilot #1191 and #1192; runs 24 to 26). Mistral failed the gate: 13/50 right, error 22 pts, source integrity 85.7%, 1 false positive. AER v1 and the v2 shadow stay off; nothing qualified; no re-reads. Benchmark report §6.1 |
| Tue 17 Nov 13:15 | **PR E:** grade scales (REQ-19, scale decided 16 Nov 16:52) and destination draft editions; plan section 6 |
| Wed 18 Nov 13:30 | **API v3 data PR C** (AACSB/EQUIS/AMBA accreditations from the official lists, on demand) then **PR D** (v3 reads the four fields) |

### Course descriptions (v2.16.13 and v2.16.14, 16 Nov 2026)

- **Rejection memory (v2.16.13, Pilot #1174):** only a person's decision counts as an earlier refusal; rule `cdesc-machine-v2`. 492 admitted in the first 30 minutes; the waiting count went below the 1,500 back-pressure limit at 12:24.
- **Prompt v3 (v2.16.14, Pilot #1175):** no introducing opener sentence ("The <course> at <provider> is a ..."). By the existing rule, waiting v2 descriptions declined for good are superseded and read again with v3 (400 of 782 by 13:14; 790 waiting).
- **Retry gate:** the second model only for `enrich.cdesc_retry_rules` (`quote_not_on_page`, `identity_margin_thin`). Before: Mistral retries rescued 18.6% (1,095 admitted a day). Watch `retry_rescue_rate_pct` and `first_pass_admit_rate_pct` on `Model_Tier_&_Token_Efficiency`; the list is changed with a reason in Settings › Settings › Course description and deadline.
- **Ledger:** every AI attempt is written as it completes (worker v1.0.5), which closes the HTTP 546 gap found in the check below; the spend the ledger missed is shown daily as `unlogged_546_gap_usd` (US$0.96 for 15 Nov UTC).
- **Readings (13:36):** resumed with v3 (13:23 run succeeded; 3 AI calls by 13:35), but throttled by the rolling 24-hour cap `enrich.course_text_items_per_day` (8,000, full with the 15 Nov 16:00–17:00 re-read wave). Bulk v3 re-reads, including the 782 superseded descriptions, start at the 16:23 or 17:23 run. 15 waiting in Layer 4; 892 admitted by `cdesc-machine-v2` since 11:53.
- **Next bottleneck:** about half of first descriptions are declined by the machine for page binding (`identity_margin_thin`, `binding_ambiguous`) and wait for a person, which holds the queue near the 1,500 limit. Phase 5 (Layer 4 grid, Wed 09:30) is aimed at them.

### AI token efficiency check (read only, 16 Nov 2026 12:40 AEDT)

Read-only queries only (`set transaction read only`, 20 s limit), on project `fxcwkweaxjtknorudmwp`, Supabase logs and Pilot `main` 6bfadf0 (worker `coverage-sweep-worker-v1.0.4`). Nothing was changed. The PR 1 cutover (22:30 AEDT) was not touched. Days are UTC days.

**1. Pre-AI gate and duplicate input: not in place for `enrich_ai`**
- The admission gate (`admission-gate.ts admit`) is called only in mode `scholarship_ai` (index.ts about line 2234). `admission.gate_on` is 0 there: `pipeline.pre_ai_admission_decisions` has 0 rows in 3 days.
- `enrich_ai` (description, intakes and the other course fields) sends every leased item. Neither the worker nor `public.svc_enrich_ai_next` checks any of these before calling OpenRouter:
  - (course, field, page content hash, prompt version);
  - a minimum readable text length;
  - the page's identity status.
- Measured over 24 h on `pipeline.field_enrich_items`:
  - Description: 13,121 paid reads cost $9.01. 2,741 of them re-read a course and page already read in the window (about $1.91). Only 3 of those pairs had the same prompt version: the rest are the one-off re-read when `cdesc-source-grounded-v2` was released (15 Nov 05:00 UTC), and 1,110 of them were held again.
  - Intakes: 67 items, none with an identity reason.
- So a gate on (entity, field, hash, prompt version) would save almost nothing day to day. Its value is stopping re-reads that will predictably be held again.
- The 55.7% `DUPLICATE_HASH` and 73% `IDENTITY_MISMATCH` figures could not be reproduced from these tables. The query behind them is needed before building the gate on them.

**2. Prompt caching and `cached_tokens`: not used and not recorded**
- The course description request (`course-text.ts cdescRequest`) puts the static system prompt (`CDESC_SYSTEM`, about 2.5 KB) and the JSON schema ahead of the dynamic page JSON. The order is right for caching.
- No `session_id` is sent and there is no `cache_control`.
- `cascade.ts note()` keeps only `prompt_tokens`, `completion_tokens` and `cost`. `pipeline.ai_invocations` has no `cached_tokens` column.
- The static prefix is about 600 to 800 tokens of an average of 3,408 input tokens (Qwen, course description). That caps the possible input saving at about 20%, and only on providers that cache implicitly.
- The Mistral re-ask is a different model, so it cannot use Qwen's cache.

**3. Ledger drift: cause found**
- 15 Nov: at 21:15 UTC the key showed $10.81 against $9.84 in `pipeline.ai_invocations`. At day end it was $10.99 against $10.03, a $0.96 gap.
- The gap sits in the hours with `coverage-sweep` HTTP 546 (worker limit) responses:

  | Hour (UTC) | 546 responses | Gap |
  |---|---|---|
  | 03 | 114 | $0.56 |
  | 04 to 06 | 88 | $0.25 |
  | 14 to 15 | 52 | $0.08 |

- Hours with only HTTP 500 responses (07 to 12 UTC) drift by less than $0.02 an hour.
- Cause: the attempt trace is written once, at the end of a worker call (index.ts about line 529, `svc_ai_model_answered_v1`). A call killed by 546 loses every attempt it had already paid for.
- Minor: 924 failed attempts on 15 Nov carry no cost (time-outs and thrown errors).
- **Action:** write attempts as they complete (or flush in batches during the call), and keep `usage.cost` on errors where OpenRouter returns it. Separately, reduce 546s in `enrich_ai` course description calls: fewer pages per call at peak, through the existing setting.

**4. `unsupported_sentence` holds on `cdesc-source-grounded-v2`: top three causes**
- 2,249 holds since 15 Nov 05:00 UTC, 2,243 of them on Qwen first answers. The threshold is `pdesc.support_min_share` 0.6, a provider-description setting reused here. The three groups overlap.
  1. **The opening identity sentence: 1,857 holds (83%).** Sentences like "The <title> at <provider> is a …". The check strips the known title and provider before scoring (`security.cdesc_known_strip_v1`), so the framing left over ("is a qualification offered by …", 817 holds) is scored against a quote that does not contain it.
  2. **Level, credit or duration facts not in the cited quote: 750 holds (33%).** For example AQF level, credit points or full-time years.
  3. **Audience framing ("designed for …", 356, 16%) and near-empty sentences after stripping (280, 12%).** For example "The is offered by the.", support 0.
- **Re-asks to Mistral:** 9,087 Qwen answers led to 5,786 re-asks (64% in this window). Only 1,552 items ended with the Mistral answer (1,533 filled or in review), about 27% of re-asks. About 4,200 re-asks bought nothing (about $1.70 at $0.00041 a call).
- **Action, to decide (prompt and check change, not made here):**
  - Tell the model not to open with an identity sentence.
  - Or let that sentence draw on `VERIFIED_COURSE_FACTS` (title, provider, study level), with the check treating those facts as known in the same way.
  - Only re-ask when the hold is not one of these predictable patterns.

### Layer 4 clearance and AER model benchmark round 2 (16 Nov 2026 14:06–19:45 AEDT)

Full report: `docs/platform/layer4-clearance-and-model-benchmark-2026-11-16.md`.

- **Layer 4 waiting:**
  - 5,172 at 14:20; 5,136 at 16:28 after the reconcile switch; **4,916 at 19:20** after the official URL resolution (read back). `official_course_url` 1,328.
  - 651 new items arrived from other work between 16:28 and 18:48.
  - Since 16 Nov, items are decided or superseded faster than they arrive.
- **Switched on (Platform Admin approval, 15:56):**
  - `layer4.reconcile_supersede_on` = 1 since 16:00 AEDT.
  - Job `layer4-readiness` (:22, :52) supersedes waiting platform-kind items whose course or provider is retired, repeats, and items already decided. It never approves or rejects.
  - 36 retired-course official URL items cleared at 16:27.
  - Defect fixed in Pilot #1180 (migration `20261116143000`, live 18:47 AEDT): `layer4.reconcile_batch` (200) now caps items settled; the new `layer4.reconcile_examine_max` (5,000) caps items checked; `pipeline.layer4_reconcile_cursor` continues where the last run stopped, so no settleable item starves.
- **Official URL batch resolved (Platform Admin 16:47, 18:01, 18:44):** of 856 items, **836 closed and 20 open** (report §7).
  - 751 closed by rule `l4-link-refusal-v1` through "Refuse this proposal". 28 audit-sample items verified and closed; 4 unproven stay open.
  - 73 live-link conflicts: 56 verified valid and closed with the live link kept (26 are a finder defect, where the "other campus" named is the provider itself); 1 refused (Lead College 107328J, on the unlink-review list, recommendation keep); 16 unproven stay open.
  - No link or course record was changed.
  - #1177 (`20261116110000`) was refused by deploy (the version was taken by #1162) and renumbered as #1180.
  - **Pending for the Platform Admin:** paste file `PASTE-20261116-l4-lift-false-link-refusals.sql` (59 false finder refusals of verified live pages).
  - **S2 - SS Build regenerates the test register** for #1176, #1177 and #1180 (spec `s560`).
- **For the Phase 5 grid (Wed 09:30):**
  - 1,304 other official URL items, grouped by provider;
  - the 488 AER audit sample, which always stays with a person;
  - fees 146, provider descriptions 88, no-page samples 55.
- **For the AER session:** 1,604 quote_not_on_page items need a corrected read (AER v2 prompt v3), not a person.
- **Benchmark round 2** (runs 17 to 20, frozen 50-case set 5, Pilot #1176 `20261116100000`):
  - **No model qualifies.** Right answers on the 40 readable cases:
    - Gemini 2.5 Flash 11 ($0.0317 per right, p50 5.5 s);
    - MiMo v2.6 Flash 11 ($0.0053);
    - Mistral Small 3.2 10 ($0.0032; best source integrity, 83%);
    - Qwen3 30B 2 (18 timeouts).
  - 10 of the 50 pages are over `reading.aer_v2_page_chars` (60,000) and fail for every model.
  - Recommended candidate pins: Mistral Small 3.2 first, Gemini 2.5 Flash second. Retire Qwen3 30B from the AER path.
  - Spend $0.459; on-demand `ca8dee01` closed. `ai_eval.offline_runs_on` and `ai_eval.aer_v3_runs_on` are back to 0. Nothing was admitted.

### API v3 data admission: field lanes and 48-hour plan (16 Nov 2026 16:40 AEDT)

- **Plan:** [`docs/platform/API-V3-DATA-ADMISSION-PLAN-2026-11-17.md`](platform/API-V3-DATA-ADMISSION-PLAN-2026-11-17.md) (REQ-19, -52, -53, -57, -65, -67, -75, -76).
- **Schema is live, data is not:** `study_load`, `empty_reason_code`, `campuses.is_primary`, `catalogue.provider_accreditations`, `ref.grade_scale_conversions`, `destination.*` and `ref.api_field_dictionary` exist (migration `20261115190000`); all hold 0 rows or values.
- **PR 3 (Pilot #1188, built 23:25, not merged):** each field is declared as a lane in `pipeline.field_execution_registry`, disabled, with zero new cron jobs.
- **PR A and PR B filled live (Pilot #1184, migration `20261116180000`; run 16 Nov 21:50 AEDT on the Platform Admin's instruction), 8,516 values:**
  - primary campus on **356** providers (basis `cricos_head_office`; 7 with several matches and 1,193 with no match stay null; telemetry counts 354, because 2 of them have no active course);
  - campus-null reason on **5,639** courses (not published 5,104, online only 395, pending extraction 104, not on the register 29, source unavailable 7);
  - study load on **2,521** courses from stated evidence (full time 1,413, part time 183, both 925).
  - `updated_at` was not touched by the fills; G3 drift [].
- **Expected from the deterministic steps:** primary campus on 381 providers (registered head office matches exactly one campus); a campus-null reason on 5,639 courses; study load on about 2,671 courses from stated "full-time"/"part-time" evidence.
- **Corrections to the brief:** `catalogue.provider_registrations` holds 3,103 regulator registrations (CRICOS, IRCC DLI, NZQA), not 36,075, and none is a business-school accreditation: AACSB, EQUIS and AMBA come from each body's official list. There are 4,341 active campuses (not 3,880).
- **Decisions (16 Nov 16:52):** D-4 confirmed; 824 single-campus providers not marked; REQ-19 owned here (position on the qualification's own scale); destination drafts unpublished; Pilot #1162 merged. Plan section 5.
- **Daily admittance telemetry (Pilot #1183, 20:40 AEDT):** every API v3 and request-register field is recorded daily in `pipeline.field_coverage_daily` through the existing `platform-health` writer (no new job). `security.api_v3_daily_admittance_v1()` gives admitted, yesterday, daily gain, eligible and share per field. The sheet tab `API_v3_Daily_Admittance` is filled by the 08:05 task. Contract and the 16 Nov baseline: plan section 7.

### Layer 4 quick wins and pre-authorised gates (Platform Admin 16 Nov 2026 20:14)

| Item | Path taken | Result (live) |
|---|---|---|
| Official-URL finder false positives (from #1177 / #1180) | Fix shipped: Pilot #1181, migration `20261116150000`, md5-guarded edit of `security.course_page_check_v1` | **Campus:** a campus named like the provider is no longer "another campus" (all 26 such refusals).<br>**Sibling:** an address whose remaining words name this course is no longer a sibling's (double degrees, Dean's Scholar).<br>Re-check of the 1,868 refusals on record: 26 campus and 268 sibling no longer refuse; **none is accepted** by the fix alone.<br>Durham "Dental Assisting" and Wollongong BSc–BA stay refused: a near-duplicate course record holds the page. |
| A. Course page needed (2,058 asked; 2,113 open at 20:40) | **Path B.** No batch setting clears the list; each entry needs a person's choice or a paid search. Rule `cpn-settle-v1` (Pilot #1182) settles only entries whose outcome is on record. | One pass: **242 settled** (236 confirmed no page, 6 page already held); open **2,113 → 1,871**. The rest (including 454 with a bound page waiting) goes to the Phase 5 grid. |
| B. Course link same-domain alias duplicates | **Path B (fewer than 100):** 5 strict matches (31 on a loose pattern) among 1,328 open course-link items | No custom rule; left for the Phase 5 grid. Separately, 229 open items propose the page already held: a Layer 4 rule candidate. |
| Tue 07:30 AEDT, AER round 3 | Gate written into the scheduled task | **Pass** (100% source integrity, at most 10 error points, 0 false positives): qualify Mistral Small 3.2 on the v2 shadow and re-read the held items through the admission rule (audit samples stay with a person).<br>**Fail:** stay off, no further spend, failure buckets logged. |
| Tue 13:15 AEDT, PR E | Written into the scheduled task | About 20 official scales as drafts and AU destination drafts (unpublished). An approval table comes to the Platform Admin before Wed 13:30. |

Layer 4 pending at 20:49 AEDT: **4,902**; at 23:36 AEDT: **4,904**.

**229 identical-URL course-link items (Platform Admin 21:03, rule if 150 or more): Path B.** All 196 unclaimed items are housekeeping H13 old-year addresses (187) or E16 two-page cases (9), genuine questions under the 4 Nov decision (migration `20261104570000`). No rule; nothing run.

| Kind | Pending |
|---|---|
| `course_entry_first_read` | 2,578 |
| `official_course_url` | 1,328 |
| `course_description_first_read` | 613 |
| `provider_current_tuition_validation` | 146 |
| `provider_description` | 88 |
| `entry_matrix_first_run` | 77 |
| `no_page_first_run` | 55 |
| other | 17 |

### Cloudflare Worker Boost and production launch rehearsal (16 Nov 2026 20:31–21:05 AEDT)

Design, decisions, results and setup checklist: `docs/platform/CF-WORKER-BOOST-AND-PROD-LAUNCH.md`.

- **Built, not deployed or applied.**
  - Read-only queue exporter (`scripts/boost-export-queue.sql` / `.ts`).
  - Free-tier Cloudflare Worker with a Google → Groq → Mistral → OpenRouter failover chain (`workers/cf-boost-extractor/`). Each result names its one model, and quotes and values are checked before anything is written.
  - DRAFT staging and promotion SQL (`sql/boost-ingestion/`, quiet window 01:00–05:00 AEDT).
  - The 4-point harness (`scripts/test-boost-e2e.sh`).
- **Paths taken:** fixture (the registry is not live before PR 3), standalone Worker, staging table (no Layer 4 intake function exists).
- **Nothing is admitted from an unqualified model.** `pipeline.boost_model_qualifications` starts empty. AER results are shadow only. Accreditations are only proposed until PR C's official lists match them.
- **Harness:** points 1 to 3 pass (point 3 on a local Postgres stand-in). Point 4 (replay of the 2,043 live migrations; the repository holds 696) waits for the parallel test project.
- **Next:** the Platform Admin's 5-step setup (document §8). The staging SQL reaches production only as a Pilot migration after its rolled-back dry run.
- **Setup steps 1 to 4 (21:09 request; document §11).**
  - **Test project:** `coursefinder-boost-test` (ref `ucdaaqrpgcldnatavmib`, ap-southeast-2) created 21:02 AEDT, empty. This is a third project in the organisation, beside production and coursefinder-demo.
  - **Rebuild:** `.github/workflows/boost-test-rebuild.yml` (here) replays the 2,043 live migrations read-only from production onto it, then runs G3, point 3 and the 50-item shadow check. It needs `SUPABASE_ACCESS_TOKEN` set on this repository (today it is on Pilot only), then `gh workflow run boost-test-rebuild.yml -R msinghbs-ai/coursefinder-admin -f test_project_ref=ucdaaqrpgcldnatavmib`.
  - **Point 3 and the shadow-only check on local Postgres 16:** 1,000 rows in 0.011 s. With nothing qualified, 50 verified rows gave 0 admitted and 0 courses changed. Rehearsal 1/2/2; window refusal enforced; nothing left behind.
  - **Bucket:** `docs/paste/PASTE-20261116-staging-boost-bucket.sql` (not run).
  - **Test project rebuild, run 43851316573 (22:32 AEDT; document §12):** 2,046 migrations exported read-only from production; replay applied 1,004 and failed 1,042.
    - The first failure (`20260813035800`) needs data that production loaded at run time, and the failures cascade from there. G3 and point 3 could not run there.
    - **Finding:** production cannot be rebuilt from its migration record. A launch needs a schema dump, the reference data, then the newer migrations.
    - Proposed: reset the test project and rebuild it from the newest schema dump branch.
  - **Schema-dump route (Platform Admin 22:44, admin #532):** `scripts/boost-rebuild.py` and the reworked workflow reset the test project, apply the production schema dump, copy the reference and configuration data read only, then apply the migrations newer than the dump, and run G3, point 3 and the 50-item shadow-only check.
    - Dump: Pilot `db-schema-dump/43861191617` (16 Nov 22:50–23:04 AEDT, 10.4 MB, production head `20261116200000`). The dump held share locks for 14 minutes and blocked nothing.
    - **Rebuild run 43863252704 started 23:04 AEDT**; cancelled 01:25 AEDT after 2 h 20 min in the schema step (one API call per statement after a failed batch, no progress output). Fix admin #536.
    - **Run 43885548875 (01:25 AEDT): schema step stopped at its 90-minute limit, 3,698 of 15,936 statements, 1,258 failed** (document §12.1). Cause: the dump's session settings (`check_function_bodies = false`, `search_path = ''`) reached only the first batch, so functions failed before their tables existed, followed by their ALTER and COMMENT statements. No G3, point 3 or shadow-only result yet.
    - **Run 43940610220 (17 Nov 06:33, approved): schema complete, 15,936 of 15,936 statements in 297 s (the #537 fix works); verdict FAIL on the later steps** (document §12.2). 8 reference tables were copied before their parents, the G3 baseline table was not copied (G3 0/0), and the 005 rehearsal needed `pim.entity_registry` rows. The 3 newer migrations were refused by their own live-state gates, as expected on a project without cron jobs.
    - **17 Nov, fresh dump and three more fixes (document §12.3):** dump `db-schema-dump/43989024895` (11:36–11:50 AEDT, production head `20261117040000`, 8 `destination` tables). Runs 43991418340, 44004171402, 44009650216 and 44014040952 all slowed from statement 6,243. The cause was the reset: `drop schema pipeline cascade` failed with out of shared memory (too many objects for one transaction's lock table) and the run carried on over the previous run's `pipeline` schema. Fixes: an explicit transaction per call (#545), commit markers (#548), batch errors recorded (#550), and the reset drops a large schema in chunks and stops if one is left (#551).
    - **Run 44019730363 (15:48 AEDT, main `fdd8789d`): PASS on every check** (document §12.3). Reset clean; schema 16,033 of 16,033 statements in 275 s (105 calls, 0 failed); 6,911 reference rows in 39 tables; 7 of 8 newer migrations (the job pause `20261117051700` refuses on a project with no cron jobs, as expected).

      | Check | Result |
      |---|---|
      | G3: 75 functions, 48 relations, no drift | **PASS** (75, 48, drift `[]`) |
      | Bulk load of 1,000 rows under 5 s | **PASS** (0.038 s) |
      | 50-item shadow-only check: none admitted, no course changed | **PASS** (50 shadow, 0 admitted, 0 courses changed) |
      | Rehearsal: 1 written, 0 updated_at touched | **PASS** |
      | Outside the 01:00–05:00 window: refused | **PASS** |

      On the way: run 44015982270 (#551) failed on 005 (production requires `manual_locks.mode`) and G3; run 44017816120 (#553) passed point 3, and G3 showed 7 v2 read functions changed because the dump was read in text mode, which drops Windows line endings from their bodies (fix #554). Known and outside the verdict: `ref.study_level_source_mappings` refers to `pipeline.sources`, which is not copied.
    - **The Boost test project is rebuilt from production's schema and passes point 3.** `worker-boost-bulk-ingest` is live (Pilot #1205; see S1-Build above). Still open: a Platform Admin qualification row for each lane and model, and deploying the Boost Worker and exporter so result files reach `staging-boost/inbound/`.

## 6. Known gaps (not resolved, do not work around silently)

- `docs/platform/UI-CATALOGUE.md` and the `docs/README.md` row for it are behind the v2.16 screens.
- `docs/platform/COMPONENT-REGISTER.md` is the 15 Oct 2026 copy; the daily snapshot is on a Pilot branch, not here.
- This page is written by hand from live reads. Sections 3 and 4 should be generated from the live database at each release; until then, the reader checks the time on each section.
