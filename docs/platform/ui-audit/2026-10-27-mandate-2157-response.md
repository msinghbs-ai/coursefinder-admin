# Response to the Platform Admin mandate of 27 Oct 2026, 21:57 (corrected 22:00) — governed actions replace manual SQL

One dated response for this mandate. Reporting points:
1. decision record lodged;
2. PR ready with full evidence;
3. deployed UI action ready for approval;
4. recovery closure completed after approval.

## 1. Decision record lodged — 27 Oct 2026, 22:2x AEDT

**Decision 268** is in `docs/coursefinder-design-reference-v1.4.md`, lodged before any code. It decides that:
- routine operations become governed actions in the existing admin interface;
- Platform Admin approval stays mandatory and moves to an authenticated UI action;
- SQL becomes break-glass only;
- the existing controls stay intact;
- covered paste steps are retired from the operating procedure, not duplicated.

The first and only action in this slice adopts and closes the AER PR A recovery that is already open.

**Correction.** The 21:57 mandate said the recovery had never opened. It was opened by paste at 21:50:00 (events 22140 and 22141) and ran under worker v0.48.8 until 22:05:20.

**Settled state (verified live 22:0x):**
- **Norway:** held before any AI read (no printed scale).
- **Complete:** Singapore 9/9, Sri Lanka 13/13, Thailand 13/13 and Qatar 2/2. Together that is 37 proposed rows in 4 pending Layer 4 items; nothing is admitted.
- **United Kingdom:** held after its third attempt (2 of 31 cells not read).
- **RMIT rows:** 343 active and 20 quarantined, both unchanged.
- **Cost:** US$0.027.

**RMIT in `entry.providers`:** recorded as a temporary, owned exception until the governed closure.
- No read can be claimed before the 30-day refresh, which first falls due on 25 Nov 2026 at 21:59 AEDT.
- The closure must be approved before then.

**In-flight work:** recorded in change control. There are no open PRs. The local PR B and measurement branches were lost unpushed and are recorded as not built.

**Paste-era follow-ups:** retired from the active next-action lists.

**Next:** build the slice (Pilot PR under CF-247 and G4, with change control before merge). The next report is at point 2.

## 2. PR ready with full evidence — 27 Oct 2026, 23:3x

PR #716 (v2.15.360):
- local suite 1,061 passed, 0 failed, 0 skipped; build OK;
- live rolled-back dry run: preview, refusal, one run, repeated click returning the first result, live unchanged;
- change control written before merge (admin `da576091`).

## 3. Deployed UI action ready for approval — 27 Oct 2026, 23:5x

#716 is merged as `f33e4702` and deployed:
- Deploy on merge, Release Currentness Deployed and Deployed UAT passed;
- the live migration md5 matches the file;
- nothing has run.

The action **Close the AER PR A recovery** is on Layer 2/3 › Operations › Governed actions, and all ten preconditions pass live. It runs only on the Platform Admin's approval in the UI.

## 4. Recovery closure completed after approval — 27 Oct 2026, 22:47

- **Approval:** the Platform Admin previewed at 22:46:24 (event 22685) and approved at 22:46:54. The action ran once: task `c24fe0d7…`, `done`, audit event 22686. It is idempotent, so a repeat returns the first result.
- **Scope:** RMIT was removed from `entry.providers`; UTS and WSU stay in scope. All five post-checks are true. The RMIT exception is closed.
- **RMIT rows:** 343 active and 20 quarantined. The 37 proposed rows stay in four pending Layer 4 items, and none were admitted.
- **Recovery runs:** all six keep their outcomes and history. There have been no new reads and no new cost.
- **Recovery cost:** US$0.0268956 (US$0.027).
- **Consumer API:** unchanged (73 functions and 48 relations, as baselined).
- **Times:** report 2 was 22:39 and report 3 was 22:43 AEDT (earlier labels "23:3x" and "23:5x" corrected).
- **Stopped.** The 37 proposed rows remain a separate Layer 4 review task.
