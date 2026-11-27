# Cloudflare reader deployment (s1324), course partial admission budget (s1325), and the 22:36 decisions

S1-Build, 27 Nov 2026. Assignment: SS-Programme-Control 27 Nov 2026 22:36 AEDT. Pilot migrations `20261130213000` (s1324) and `20261130220000` (s1325); worker v1.0.61.

## Production results

- **DOT batch01 submitted.** Structured intake run 45991951265: 7 received, 0 duplicates, 0 refused.
- **Avondale 059850D (Bachelor of Theology).** "International Baccalaureate Diploma with 24 points" was proved on the bound page's stored copy `92d4edcd`. It went to `aer-machine-v1` (`gate_incomplete`, 22:48), then **admitted by `aer-course-partial-v1` at 22:59 AEDT**.
  - The row is **active**.
  - Layer 4 item `73b04bed` stays pending for the other routes, which DOT did not supply.
  - The course is unpublished at course level; the provider is published.
- **The other DOT candidates.**
  - 057303C and 037861E: compared with their active rows (9 and 5).
  - AUT 054688E: held, bound page differs. The proof page `aut.edu.au/course/MDIV20/` was read once directly and stored (evidence `30beab4c`); the bound page is still `actheology.edu.au`.
  - Scholarships: held (closed round, no current amount, restricted scope). One page has no copy that could be read.
- **VU tiers (s1322) live.** 14 of 14 calculated; 14 tier assignments.
- **Listing picker (s1323) live.** Picker md5 `ad4b03d3…`; 6 pages in 78 ms; 15 listing pages read since the 22:46 deploy.

## s1325: course partial admission keeps its own clock

**Problem.** The rule `aer-partial-admit` runs three passes on one clock. The entry-table pass took 37 to 85 s on recent ticks, and its 40 s guard is checked only before each item. The course pass (60 s guard on the same clock) then looked at nothing at the 22:14 and 22:44 ticks. The Avondale row was admitted at 22:59 only because that tick's first pass was quick.

**Fix.** One md5-guarded edit (`15ce951f`): the course pass gets its own clock with a 15 s fire guard. Nothing else changes.

## s1324: Cloudflare reader (Decision 2)

**Deployment.** `cloudflare-reader-deploy.yml` is started by hand. Before anything else, it checks that the token reaches **exactly one account, named Techm**, and that the account holds the frontend Worker. Otherwise it stops with `HELD:TOKEN_SCOPE`.
- It deploys only `cloudflare/reader-burst` (Wrangler 4.161.0).
- A signing key is generated in the run, masked, and set as the Worker secret and as the Supabase edge secrets `READER_BURST_SIGNING_KEY` and `READER_BURST_URL`. It is never printed.
- It then checks that an unsigned call, a wrong signature and any other route are refused (401, 401, 404).

**Limits as settings (G2):**

| Setting | Value |
|---|---|
| `cloudflare_reader.on` | 1 |
| `.slots` | 1 (most 1) |
| `.idle_minutes` | 5 |
| `.daily_usd_cap` | 2 |
| `.monthly_usd_cap` | 20 |
| `.usd_per_awake_hour` | 0.22 |
| `.max_pages` | 400 |

**Gate and record.** `public.svc_cloudflare_reader_v1` gates each read on the switch, a free slot, both caps and stored `layer2/` source evidence only. Each run is logged in `pipeline.cloudflare_reader_runs`. Rehearsed (rolled back):
- the Newcastle evidence passed the gate;
- a second call was held as `HELD:SLOT_BUSY`;
- a 60 s read was recorded at US$0.022;
- unknown evidence was held as `HELD:NOT_PUBLIC_STORED_EVIDENCE`.

**Benchmark.** Worker mode `burst_read`, started by hand through `cloudflare-reader-benchmark.yml` (Newcastle `751ba9e8` by default):
- gate, then a signed call carrying the stored bytes; Cloudflare receives no Supabase credential;
- records the container's measures and a result summary;
- after 7 minutes, reads back the application's instances to prove the automatic shutdown.

Supabase stays the default runtime; nothing routes work to Cloudflare by itself.

**Waiting.** The 22:20 preflight showed the token reaching **two** accounts, so deployment waits until it is restricted to Techm. Once it is, the deployment and benchmark workflows run in that order.

## Decision 1: UQ College Limited (CRICOS 04039H), verified, not applied

**Provider classification policy.** `security.provider_type_classify_v1` classifies from the provider's own register facts. Deakin College (PRV12137), Monash College, UNSW College and UTS College are `higher_education_institute` because each holds its **own** TEQSA registration in the Institute of Higher Education category.

**UQ College's own facts.**
- Its TEQSA facts are UQ's, not its own: PRV12080 (The University of Queensland), category Australian University, which is why it is typed `university`.
- Its own site footer (`uqcollege.uq.edu.au`) prints "TEQSA … PRV12080", that is, UQ's registration.
- It is listed on the National Training Register as RTO 32454.
- Its CRICOS institution type is Private.
- Its four courses are all non-AQF (English language and foundation).

**Policy result.** With UQ's TEQSA facts set aside, the existing classifier gives UQ College **`other`** ("CRICOS provider of English language or foundation courses only"), not `higher_education_institute`. This was rehearsed and rolled back: only UQ College changed.

**Effect on 22521.** `other` is not in `scholarship.non_university_types`, so candidate 22521 would still be refused.

**Why nothing was applied.** The approval was "subject to verification against the existing provider classification policy", and the verification does not support `higher_education_institute`. No classification was applied, and 9542 stays a recorded duplicate of UQ's award (candidate 4974, scholarship `09c117a6`).

**Options for the Platform Admin:**
- (a) record UQ College as `higher_education_institute` by a person's decision (a provider-type manual lock, which adds to the manual locks);
- (b) apply the policy result `other` and add `other` to `scholarship.non_university_types` for AU (this affects 103 providers);
- (c) correct only the borrowed TEQSA facts and leave 22521 held.
