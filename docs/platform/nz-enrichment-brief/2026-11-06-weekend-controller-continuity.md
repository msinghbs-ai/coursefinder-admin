# Weekend Integration Controller and AI continuity — execution record

Authority: Platform Admin mandate received 6 November 2026 in the current authorised Codex execution. Scope: 7–8 November engineering and a Monday 9 November handover, with permanent vendor-independent continuity. Tracking: [Admin #382](https://github.com/msinghbs-ai/coursefinder-admin/issues/382). Execution: `codex-weekend-20261106-0903Z`. All stored times UTC; display timezone Australia/Melbourne.

## Decision before implementation

The current mandate supersedes the 5 November Claude-only staffing allocation for this assignment. It does not supersede release-specific approval gates, G3, spending reserves, human admission, destructive-change restrictions or the holds on Pilot #890 and #875.

Extend the canonical `docs/platform/STUDYSEARCH-EXECUTION-REGISTER.md`, `AGENT-OPERATING-MODEL.md` and `nz-enrichment-brief/INDEX.md`. The register will contain the concise current handover; a versioned JSON checkpoint and schema will live beside it. Do not create a second issue queue: `pipeline.integration_issues` is the live operational queue. Existing September milestone documents are historical and the active router's three m2.4.7 continuity files are empty; this does not justify reviving stale September state.

Implement a GitHub ref coordination protocol: one-parent commits, server-enforced fast-forward-only updates, expected-head checks, no force updates, pinned immutable operation identifiers, and fail-closed ownership verification. A lease expiry never permits takeover without reconciliation of running/queued workflows, direct writes and predecessor status. Start in reconciliation; no existing exclusive controller lock has been found. Git documents without the atomic ref transition are not ownership authority. Do not describe the mechanism as production-enforced until every production entry point participates.

The prior controller is recorded as Claude; acknowledgement/release is not available in this execution. Current candidate: Codex in the managed cloud environment. No production writes or releases while ownership remains uncertain. Independent read-only engineering and continuity work can continue.

## Reconciliation so far

- Admin main `006e0eafc1259470480a373e9991cdeba7fd1e67`; Pilot main `4ba94e3fcde53c11528eb2bfc1b5e9bc0dec2067`.
- Live database read at 2026-11-06T09:07:34Z: applied migration head `20261106400000`; provider-description migration `20261106200000` is present. Database schema order differs from merge order; use applied versions, never infer from filename alone.
- Live deploy check 27 records v2.15.489, OK at 02:22:35Z. This is historical database evidence; fresh Worker version verification is still pending.
- No in-progress GitHub workflow observed at 09:09Z. One queued historical CF-093 UQ dispatcher run `34749286102` requires investigation; do not cancel or replay it blindly.
- No other active database transaction observed at 09:09Z. This is an observation, not proof that a predecessor cannot initiate another write.
- Live Mode 1 remains active. Provider descriptions: 5 reads (4 proposed, 1 held), no active read lease; bounded workflow acceptance still pending.
- Course-description Layer 4 pending count is now 1,030; earlier 857 in the register is stale.
- Source and vendor holds remain. Course search reports out_of_toolset; no spending override authorised.

## Owned independent reviews

WS-894: existing isolated branch `cf247-course-descriptions-complete`, head `162e9fc78a6b760c6f0db94df340773903518c92`; independent reviewer `review_894`; no file ownership or mutation. Acceptance: exact-head checks, migration and admission review, actionable release blockers.

WS-893-892: existing isolated branches `cf247-english-requirements-complete` and `cf247-test-evidence`; independent reviewer `review_893_892`; no overlapping implementation writes. Acceptance: exact-head CI, root cause of failed evidence and dependencies.

Confirmed #894 blockers: two re-asks permitted against D4's one; final-page Previous hidden; publication count lacks publication predicate; fixture pipelines mask execution failures. Confirmed #893 blocker: successful workflow log contains fixture and missing-relation SQL errors hidden by tee. #892 correctly records a full-suite phone failure owned by #894. These are not production fixes and no operational issue has been closed.

## Execution boundary

No production mutation, migration, deployment, vendor read, admission or publication initiated by this execution. Shell proxy cannot connect; GitHub and Supabase connectors provide read access. Do not fabricate an unattended weekend execution, heartbeats, future results, Monday report or successor acceptance. Schedule actual resumptions where supported, and publish their verified outcomes only after they run.

Next safe action: implement and validate the continuity extension, publish the findings, and resolve ownership adoption through GitHub without using the Platform Admin as an AI message relay.

## Production evidence

Live read-only source: Supabase project `fxcwkweaxjtknorudmwp`, using read-only
transactions and 6–8 second statement timeouts. Queries used real object columns
after pg_catalog/information_schema introspection, and no mutating helper was invoked.

- 09:24:08Z: 1,791 migration versions; sorted version-set md5
  `e2194e53a7917be0fb3fcb648811aec9`. All versions are preserved in the JSON checkpoint.
  Head `20261106400000`; #894/#893 migrations remain unapplied.
- Latest actual ledger observations at 09:23–09:24Z report
  `coverage-sweep-worker-v0.59.8`, status 200, modes scholarship_ai/ai_match.
  Management metadata confirms edge coverage-sweep v239, bundle sha256
  `995d5111618181a55afa168f97d529f7bae27f9ff1d9825def373cf503f494b5`.
- 09:11:59Z function md5s are in the structured checkpoint. They include
  `course_description_check_v1=ff3d6dd7b0f88c85b1fdff6c8a8cd86b`,
  `svc_provider_description_next=559407dc479753698b858231b2e7eb93`,
  `svc_provider_description_record=d95f0bafc894b662468a309254544444`.
  These are observations, not permanent pre-release clearance.
- Fresh frontend HTTP/browser verification is unavailable: shell cannot connect to
  its configured proxy and no browser tool is exposed. Main and historical successful
  currentness run `42149758988` support the recorded v2.15.489, but do not establish
  a fresh frontend observation. The checkpoint deliberately leaves that version unknown.
- 09:09:21Z: Layer 4 pending by field includes course descriptions 1,030,
  official_course_url 2,092, course AER 564, matrix AER 41, provider descriptions 4.
  Provider descriptions remain 4 proposed/1 held, total historic cost US$0.0065848;
  no new admission or publication attributed to this execution.
- Existing AER provider coverage, queue-watch state and scholarship AI queues are
  captured as measurements, not reconstructed from stale reports. Scholarship AI:
  22,335 failed, 32 queued, 33,881 done; these are queue states, not new publications.
  Course-search state is out_of_toolset; no reserve override is authorised.
- 09:14:05Z: the bounded 33-job set has no failed cron status in the prior 24 hours;
  success does not mean actual data gain. Two P0, 78 P1 and 197 P2 integration issues
  remain nonclosed; only the highest 30 open issues were individually sampled in
  this onboarding. Full queue remains `pipeline.integration_issues`.
- [P0 readback evidence](../validation/2026-11-06-p0-reconciliation.json), 09:15–09:21Z:
  five UNSW dates remain absent and all thirteen bad fee rows inactive; SQL Website/Zoho
  outputs exclude them. Keep locks. Fee protection is live; no matched international
  conversion admission was proven in the four first post-fix reads. No global closure,
  edge HTTP/cache acceptance or issue-status mutation was performed.

## Scheduled resumption

The automation tools confirmed enabled schedules at 09:23Z:
- Hourly attempts from 7 November 00:00 through 8 November 23:00 Australia/Melbourne (48).
- Monday 9 November morning handover, flexible morning timing.

Both prompts require current repository/live reconciliation, atomic ownership and
all existing approval gates. At creation, next_run_time and last_run_time are null,
and inherited environment details are null. These are configured resumptions, not
verified execution, continuous monitoring or guaranteed environment attachment.
The separate StudySearch Independent Validation automation is supplementary and was
left unchanged. No future outcome or Monday report has been pre-written.

## Continuity implementation and acceptance boundary

CF-039 is extended, rather than creating another change register. Canonical human
handover is the existing execution register's Controller handover section; structured
state/schema sit beside it. The `studysearch-controller` ref at
`23a161046c4cf2c331c7bab13b4c21dcd904630e` has been created and read back in
reconciliation, generation 0, no owner, no heartbeat/lease, adoption pending.
Normal transfer and interrupted recovery retain immutable operation IDs and fail closed.

Local validation: 17 schema/handover tests and 11 ownership tests pass, including
a real two-contender nonforced Git push with exactly one winner. The actual populated
checkpoint passes record validation; release-ready validation is expected to fail
while authority and baseline gates are missing. Remote workflow evidence is recorded
in the governance PR after execution.

The protocol is not yet consumed by Pilot production entry points. Completing those
guards, predecessor disposition and fresh frontend verification is necessary before
exclusive release authority or a complete operational handover can be claimed.
Independent engineering and read-only reconciliation continue safely meanwhile.


## Final session checkpoint

2026-11-06T09:44:19Z (UTC): Admin PR #383 merged as `fdaac3bc72f7eabac57c308a36dfd913f8a15db9`.
Final source head `9674e59b` passed Controller continuity run `42196754253`
(17 checkpoint/handover + 11 ownership tests and populated checkpoint validation),
PIM build `42196754240` and Workers Builds. The latest code is on main.

Pilot main and all five draft PR heads are unchanged; no production release,
migration, governed write, admission, paid read or vendor-control change was made.
The final 09:41Z database check still shows 1,791 versions, head `20261106400000`,
and actual worker v0.59.8 status200. Three transient non-self transactions were
observed at 09:41:06Z; a subsequent bounded active-session query returned none.
Neither observation grants ownership. No predecessor acceptance/release has arrived.
The atomic ref remains reconciliation/adoption pending at `23a16104`.

The current pre-pause checkpoint is `CP-382-20261106T094419Z`. All intended source
changes and review evidence are published; no unique source depends on this local
materialised subset. Both implementation branches are integrated and retained as
attributable evidence. Agent review work is complete; no running sub-agent is claimed.
The next safe action is in the canonical handover; scheduled resumptions have not
run and no successor transfer is claimed. Programme completion is not declared.

## Immediate execution recovery — 2026-11-06T11:07:04Z

Platform Admin instruction: the continuity merge is not completion. Continue the full repair cycle in existing PRs: first all four #894 defects and full governed suite; second genuine #893 Postgres scenario execution, overlap reconciliation and unique Worker version; third #892 phone dependency and trustworthy suite evidence; then adopt the existing ownership gate at production entry points before any mutation and perform only permitted sequential releases. Preserve admission authority and accurate proposed/admitted/published measures. Do not create another framework or duplicate register.

Development ownership for this recovery execution: Codex coordinates existing-PR repairs. Isolated #894 worktree owns the four-defect source, migration/UI/worker re-ask and existing regression tests. Isolated #893 worktree owns English fixture execution, its CI workflow and stale evidence wording; shared Worker version edits are coordinated by Codex. Codex owns #892 evidence workflow/library and cross-branch integration. No agent merges, deploys, writes production or spends vendor budget. Exact PR heads at resumption: #894 `162e9fc7`, #893 `2513a909`, #892 `7a2f3dd3`, Pilot main `4ba94e3f`. These are unchanged from the previous checkpoint; every push uses expected-head checks and no force.

Production controller remains unaccepted; Claude release is still unacknowledged. This does not block isolated development. Local Git clone fails because the configured proxy is unreachable, and the local Docker socket denies access; use connected GitHub source operations and actual GitHub Actions Postgres/browser execution, without bypassing the environment network policy. Do not treat that local execution limit as a reason to stop repository repairs.

Each following checkpoint separates issues fixed, PRs merged, production releases verified, operational outcomes, unresolved blockers and next executable action. This section extends the existing record; no new handover mechanism is introduced.

### Recovery execution checkpoint — 2026-11-06T11:40:09Z

- Issues fixed (development): #894 four defects, #893 false-green fixture, #892 phone dependency/readiness correction.
- PRs merged: **0** in this recovery; no production merge is inferred.
- Production releases verified: **0**. Production migration/Worker baseline is unchanged in the 11:32Z readback.
- Operational outcomes: development #894 **1954/0/0/0**, #892 **1950/0/0/0** and digest-verified bundle; #893 real PG **71+17** scenarios; description/proposal counts are not counted as admissions/publications.
- Blockers: combined #893/#895 CI in progress; previous Claude release unacknowledged; external Cloudflare/protected-secret/direct-SQL controls still need authorised adoption. Concrete adapter is PR #895, not another continuity framework.
- Next executable action: complete combined CI, validate artifacts/registers and repair failures; keep production writes stopped until ownership and execution gates actually pass.

### Recovery execution checkpoint — 2026-11-06T12:05:32Z

- Issues fixed in development: all four #894 defects; #893 false-green SQL and stale parser/version contracts; #892 phone dependency and skipped-check false pass. #895 extends the existing ownership gate at production workflows.
- PRs merged: **0 Pilot PRs** during recovery. #892, #893 and #894 are ready for review; #895 is draft for controlled cutover.
- Production releases verified: **0**. No production mutation, migration, admission, paid read or setting change initiated here.
- Operational outcomes: actual full suites #894 **1954/0/0/0**, #893 **1979/0/0/0**, #892 **1950/0/0/0**, #895 **1939/0/0/0** (passed/failed/skipped/flaky). Both genuine PG tracks pass on combined English head; English asserts **71+17** cases. Downloaded structured artifacts, exact commit/tree and ZIP digests verified. Existing registers derive from those same runs; independent review results are on the PRs. First combined run found five stale assertions; corrected before the passing rerun. First gate run found the same known phone dependency; exact existing repair reused before passing. No exemptions or weakening.
- Unresolved blockers: Claude release unacknowledged; canonical ownership still reconciliation at23a16104 with no owner/lease; external protected-secret/ref, Cloudflare and direct-SQL controls unadopted; fresh frontend/authenticated UI unavailable. Historical queued34749286102 remains queued with disposition unresolved. Register-only head checks for #893 and #895 are running, not claimed complete.
- Next executable action: inspect current-head checks, retain passing artifacts, then authorised account/controller must reconcile predecessor and external controls through Admin#382 before ownership acceptance or ordered release. Live11:56:34Z remains1791migrations/head20261106400000 and Worker0.59.8status200; provider descriptions4proposed+1held,0activeleases. Last description pending1030 at11:32Z. These are not admissions/publications.

Functional evidence: [#893 combined run42212962756](https://github.com/msinghbs-ai/Coursefinder-Pilot/actions/runs/42212962756), [English PG42212963040](https://github.com/msinghbs-ai/Coursefinder-Pilot/actions/runs/42212963040), [#895 run42213117490](https://github.com/msinghbs-ai/Coursefinder-Pilot/actions/runs/42213117490). Full ZIP SHA256s: English combined `bf982e499b3c10c44b303581ee35b8adc0f718b892ef01ef04e5669cf95eafb0`, gate `b3bad718b79764c77c1397b1714f95d1b108855ea70ad9105cbf1714c62d7627`. Metadata heads: #893 `eb0caf2e8125455a076993810efef968c335fd97`, #895 `0c9cbaeaf1f8493bf5ebd210967b033aab9a0876`.

## Recovery authority-blocked checkpoint

2026-11-06T12:16:11.685202Z UTC — checkpoint `CP-382-20261106T121611Z`.

- **Issues fixed:** All four #894 defects, #893 false-green SQL execution and parser/version integration, #892 phone dependency and skipped-check readiness. Concrete existing-protocol entry-point guard prepared in #895. All intended source changes are on GitHub; no unique implementation depends on a local worktree or conversation.
- **PRs merged:** 0 Pilot PRs in recovery. #892 `4823f68f`, #894 `e15536e8`, #893 `eb0caf2e` ready for review, unmerged. #895 `0c9cbaea` draft, cutover held. #890/#875 untouched and held.
- **Production releases verified:** 0. No production migration/write/admission/vendor spend initiated by this recovery. No issue closed merely on tests.
- **Operational outcomes:** Functional full suites remain #8941954, #8931979, #8921950, #8951939 passed, each0failed/skipped/flaky. All final-head Pilot checks pass, including [#89342214539857](https://github.com/msinghbs-ai/Coursefinder-Pilot/actions/runs/42214539857), English42214539830, build42214540036 and [#89542214313013](https://github.com/msinghbs-ai/Coursefinder-Pilot/actions/runs/42214313013). Generated existing registers derive from the verified functional executions. Independent reviews are on both PRs.
- **Unresolved blockers:** Claude predecessor release/stopped-execution evidence remains absent; canonicalref23a16104 still reconciliation/noowner/lease/adoptionpending. Protected production credentials/allowedrefs, Cloudflare deployment controls and direct SQL/Management access fencing require authorised account adoption. Historicalqueued34749286102 disposition remains unknown. Exact Cloudflare deployment commit and authenticated UI checks remain unverified. Existing IQ00112 collection failure remains active.
- **Next executable action:** Authorised predecessor/account controller publishes disposition and verified external-control adoption through Admin#382. The incoming controller independently rechecks GitHub, live state and in-flight operations, accepts exclusive authority using the existing atomic protocol, then refreshes hashes/approvals and reserves each sequential894→893 release. Reconcile892/895sharedfiles against releasedhead, perform bounded live scheduler/UI/admission/publication acceptance, and repair the alert collector under authority. Never replay an unverified command or acknowledge/discard alerts to clear the watchdog.

Supported network access recovered during execution. At12:14:01.449237Z, the public home and served asset returnedHTTP200. `/assets/index-DYGiA8uP.js` exposesUI2.15.489/package0.1.416 and SHA256`2099cae683638b50dbec35ef7e3a047b3ac26f513fd82900e1456389aed88540`. No exact deploymentcommit is exposed; source-main identity is not substituted for proof. At12:14:08.464194Z the DB still shows1791migrations/head20261106400000, coverage-sweep-worker-v0.59.8status200 and lastreleasecheck27v2.15.489. Eight recorded functionhashes were rechecked unchanged at2026-11-06T12:16:11.685202Z. Provider reads remain4proposed(costUSD0.00541)+1held(costUSD0.0011748),0activeleases; descriptionpending1030 was last measured11:32Z. None is a new admission/publication claim.

New operational evidence: [watchdog42195944902/job127819102986](https://github.com/msinghbs-ai/Coursefinder-Pilot/actions/runs/42195944902/job/127819102986) failed at09:33 on62uncollectedalerts. Its function is STABLE and read-only; fresh12:13:21.045194Z evaluation confirms63alerts olderthan120minutes, oldest03Nov18:20Australia/Melbourne, deliveryenabled. Platform-alerts12:10 and platform-health12:08succeeded; the fault remains in collection/delivery rather than scanning. IQ00112 stays open in the canonical register, with no production acknowledgement/configuration attempted.

All delegated reviews and Pilot development CI are complete; no production operation belongs to this execution. Admin checkpoint-validation CI runs on publication. No successor has accepted control; no heartbeat, unattended monitoring or completed transfer is claimed. Existing future resumption schedules remain configured, not evidence of execution. The programme and live operational issues remain open at these genuine blockers.

Release packaging guard: ready-for-review does not mean production-ready. The branch UI manifests still describev2.15.489/package0.1.416. Before merge the confirmed controller must allocate unique release-specific UI/package metadata, change-control entries and currentness evidence against the then-current production baseline, and complete applicable checks. Proposed coverage Worker sequence remains894v0.59.9 then893v0.59.10. Do not blindly merge a green development head as a finished release.

## Complete integration and production delivery — 2026-11-06T12:25:59Z

Platform Admin instruction: reconcile the overdue alerts first; verify previous-controller workflows, leases and deployments, acquire valid exclusive ownership without fabricated acknowledgement; complete #895 enforcement with an authorised recovery path; finish packaging/integration of #894/#893/#892 and sequentially release only after gates pass. Continue #877/#889 and AER/scholarship/Layer4 work within existing authority. Completed engineering corrections and existing continuity architecture are retained.

Development allocation (proposed release sequence, no release authority implied): #895 UI2.15.490/package0.1.417 for the controlled entry-point/recovery cutover; #894 UI2.15.491/package0.1.418 with coverageWorker0.59.9; #893 UI2.15.492/package0.1.419 with coverageWorker0.59.10, after #894; #892 UI2.15.493/package0.1.420 preserving the released Worker. These versions are reserved for reviewable packaging against currentmain/liveUI2.15.489; recheck actual production and allocations before any merge. Root owns cross-branch integration and all production actions. Existing dedicated agents own only their PR/worktree files; no agent independently merges, deploys or mutates production. All release metadata changes require their applicable governed validation; do not repeat unchanged repair development.

Alert reconciliation started read-only: the original63 are IDs21–83; currentpending68 includes five newer rows. All68 have zero attempts/no delivery lease, and no repeated dedupe key. Existing platform_issues and live jobs/consumer evidence, rather than alert wording alone, determine active faults, stale events and severity. No alert is acknowledged or discarded merely because it is old. Preliminary current faults: collection path and provider discovery; paid Firecrawl work remains stopped by reserve governance. P0 review and precise classification are underway.

Ownership is still reconciliation with predecessor release absent and external adoption pending. #895 review identified a real recovery dependency: manual recovery must run a trusted verifier from the protected workflow revision against the chosen candidate, rather than requiring a pre-guard candidate to contain its own verifier. The existing adapter will be extended narrowly for this; no second framework or uncontrolled bypass is authorised. A consolidated external decision will name the exact predecessor termination/revocation, execution fencing and cutover actions after independent checks.

### Delivery checkpoint — 2026-11-06T12:46:35Z

Checkpoint `CP-382-20261106T124635Z`. Issues fixed/diagnosed: original63alerts reconciled by exact issue episode; new three-course deadline-semanticP0 independently confirmed and escalated in [Admin382comment6685067695](https://github.com/msinghbs-ai/coursefinder-admin/issues/382#issuecomment-6685067695). PilotPRsmerged:0. Productionreleasesverified:0. Operationaloutcomes: classification/verification only, no delivery acknowledgement or production correction. Blockers: real ownership/external controls and exact data-correction authority. Nextaction: finish tested895recovery/orderedpackaging andreviewableP0guard/containment while preparingoneconsolidateddecision.

Original63(ID21–83): **47historical recovered-episode events**, **16events tied to3activeconditions**, **0exactdedupekeyduplicates**. The active16arecollectorIDs23/29/43/56/63/74, Firecrawlreserve26/39/53/60/72/82, andcoverage-discovery46/57/65/77. Reminders are valid temporal notifications, not duplicate database rows. Historical events include each old companion/course-list episode; newerID86/88arefreshrecurrences andremainactive. At12:28currentpending68, allzeroattempts/no leases; at12:32:50Z watchdog64olderthan120minutes. Deliveryenabled=true/webhookenabled=false: the scheduled-task collection path is not taking alerts. NoHTTPtransportfailureisrecordedbecause no delivery was attempted. Do not mark historical alerts sent or delete them based on this classification.

Discovery has18waiting andboth coverage-discover jobs inactive at12:33Z. Firecrawlreserveisreached andpaidworkstopped; donotoverride. Companion/course-list recurrences need resource-hold diagnosis rather than automatic software-regression closure. Existing P0IQ00111/IQ00313 remain verified-contained only in their exact5intake/13fee scope; their stale statusfields are not acceptance. Independent latest taskrun a151ea6c-257c-832b-8f81-2243d83de2c7 completed12:08:45Z andis supplementaryevidence, not an activecontroller.

**NewconfirmedP0:** three commencement quotes were admitted as application_deadlines andreturned by WebsiteSQL,ZohoV1andV2 despitecatalogueunpublished.095229D/course2b19936a-69ad-49b8-9a33-56644609ccfc deadline2026-11-02/item273361 quoteStartdate02Nov2026;094185G/course2bad6b65-cd92-4a35-9efc-a69d4bb43d99 deadline2027-02-15/item273381 quoteIntakes15February2027;106137B/course2bb7f6ea-be1f-44e2-a51c-72a277045475 deadline2026-10-12/item273383 quoteStartDates12October2026. [Exactqueries/sourceidentities/consumerreadbacks](../validation/2026-11-06-deadline-semantic-p0.json) contain bounded evidence. ExternalHTTP/cache andbroader30intake/20course scope remainunverified. The rootcause is date-component-only course_deadline_in_quote_v1 plus trust inAIkind=date/on_page; a minimal same-signature guard is beingprepared. The existing calendar-withdrawal RPC is unsuitable forfield-enrich provenance andaddsmanual locks; donotcallit for these records. Exact3rowcorrectivepaste requiresreviewed approval, immutableauditandsearchrefresh, no lock changes.

Ownershipreadback: noPilotinprogressworkflow; historicalqueued34749286102has0jobs; bounded12:33pgactivity had0nonselftransactions. Canonicalref23a16104hasnoowner/lease andnoacceptedpredecessorrelease. These observations do NOTprove Claude stopped. PublicGitHubenvironmentreadback finds only`pilot`, protection_rules=[] anddeployment_branch_policy=null. NoconfiguredCloudflare/directManagementaccountcontrolcapability is exposed; normalghauthreportsinvalidcredential. Use supportedGitHubconnector forcodepublication, notcredentialextraction.

#895recoverywork now stages verifier from immutableprotectedworkflowSHA before candidatecheckout, supportsolderedge git_ref, rejects tracked/untracked executable-source drift andrequiresactualtrackedresources. Sixexistingbehaviouralcasespass. Nineteenprivilegedreader/writerjobsreferenceexistingpilot so movingcredentialsdoesnotstrand reviewedreports. Environmentreferences donotconfigureprotection. Rootbuild490/.417passes; integratedtargetedbrowsercontractsandactualCIremaininprogress. Otherpackaging:894491/.418,893492/.419,892493/.420. Noacceptedrecoverybaselineisrewritten.

### Integration sequencing update — 2026-11-06T13:10:00Z

The newly confirmedP0 changes the proposed sequence before any production execution: #895 controlledfencing/recovery cutover UI2.15.490/package0.1.417; deadline-semanticP0 guard+separately approvedthree-record correction UI2.15.491/package0.1.418 with newunappliedmigration20261106450000; #894 UI2.15.492/package0.1.419/Worker0.59.9; #893 UI2.15.493/package0.1.420/Worker0.59.10. This supersedes earlier prospective UI allocations only; no applied migration is renamed, no release is claimed and accepted recovery history is retained.

#892's existing test-evidence implementation will be integrated as a development dependency of #895, rather than maintain multiple temporary full-suite wrappers. It supplies the single authoritative full-suite bundle, fingerprint-safe metadata reuse and readiness report for the ordered candidates. The temporary controller-entrypoint full-suite workflow and course-description full-suite job are retired when superseded; genuinePostgres/targeted/requiredrelease checks remain. Preserve #892 source ancestry and evidence; mark its operational acceptance only after actual guarded release and phone/evidence verification. No second evidence framework is created; the existing #892 mechanism is reused. No separate UI2.15.494 release is allocated unless later actually needed.

Releasepackaging includes the existingSOPsource+generateddocuments and exactreleasehistory assertions. Newly found staleSOPreviewmarker in895 produced1937pass/2fail at4f597466; it is beingcorrected before a new finalsuite. No redcheck is exempted. P0helper actualPG17.6 now59admissionassertions pass includingcurrentbadquotes; enabledreview-correction branch has14additionalrollback/idempotency/auditcases passing inisolatedfixtures, with explicitconsumer-boundary stand-ins. Productioncorrection remains disabled/unexecuted.
