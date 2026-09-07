# M2.4.5 — Recovery Closure State — 7 September 2026

**Status:** ACTIVE / TARGETED GATES GREEN / BOUNDED INTEGRATION NOMINATED  
**Milestone:** M2.4.5  
**Production:** NOT PROMOTED  
**M2.5:** PAUSED

## Truth baseline

This record reconciles current repository, Pilot runtime and deployed UAT evidence under the troubleshooting/bugfix recovery protocol. It supersedes stale checklist wording only where explicit later acceptance evidence exists; it does not erase earlier evidence.

### Release-currentness recovery

- Nominated Pilot recovery head `8bc6960d05e5521ff6ae44ad0ee49e7c07ef80ff` inspected first.
- Pilot Frontend Build `34069496657`: PASS.
- CourseFinder Deployed UAT `34069496589`: PASS, targeted desktop; mobile skipped by tier.
- Visible release/currentness remains v2.15.72.
- Known implementation duplication remains: release-currentness entry reports 2.15.72 while the mature host still carries an older internal UI_VERSION constant. This is bounded version-source debt and must not be changed before functional bounded integration is green.

## Accepted gates retained closed by impact analysis

The following accepted gates were not rerun because their accepted implementation blobs/contracts were unchanged at the recovery baseline:

- H3 Scholarship PIM — CLOSED / TARGETED PASS.
- H4 Jobs Workspace — CLOSED / TARGETED PASS.
- H5 Manual PIM Candidate Workflow — CLOSED / ACCEPTED.
- H6 Publication Controls — CLOSED / ACCEPTED; `auto_publication_enabled=false` remains the Pilot runtime posture.

This retention is deliberate recovery-protocol behaviour, not an inference from chat history.

## Security recovery

### CF-235 — Layer 4 public RPC boundary

- Privileged Layer 4 implementations moved behind non-exposed `l4_api` boundary.
- Same public signatures retained as SECURITY INVOKER wrappers.
- Rank, Evidence, exact-confirmation, scope-rule and publication-isolation semantics unchanged.
- Layer 4 Security Advisor WARN findings removed.
- Deployed targeted UAT `34069963783`: PASS.
- CLOSED / TARGETED SECURITY PASS.

### CF-236 — remaining pre-production RPC boundary

- Privileged Scholarship AI/runtime and Statistics registry implementations moved behind non-exposed `admin_api` boundary.
- Public same-signature wrappers are SECURITY INVOKER; anon execute remains absent.
- Scholarship normalisation helpers now have fixed search paths.
- Supabase Security Advisor after correction: **0 WARN findings**.
- Frontend Build `34070155296`: PASS.
- Deployed targeted UAT `34070155325`: PASS.
- Performance Advisor contains only INFO-level existing observations; no WARN/ERROR introduced.
- CLOSED / BOUNDED SECURITY PASS.

No permissive RLS policy was added merely to silence INFO-level RLS/no-policy notices because direct-table access remains intentionally denied/RPC mediated.

## H11 Provider Logo surface reproof

Shared mature-host code changed after the original logo acceptance, so a targeted regression was justified.

- Candidate head `9edb848ae0bb087dda26aa72708483f9bff8896e`.
- Frontend Build `34070290328`: PASS.
- Deployed targeted UAT `34070290310`: PASS.
- Provider/Course/Compare logo-surface contract therefore remains CLOSED at targeted desktop level.
- Mobile is not inferred from this targeted result.

## Current active gate — CF-238 bounded integration

Bounded M2.4 integration nominated at Pilot head `eaedfb2bb2926bb87a37f7a8ad59e89c808ca2ff` after targeted recovery gates passed.

Required result before any final acceptance nomination:

- integration suite desktop PASS;
- integration suite mobile PASS;
- no role/security/Evidence/Layer 1 authority regression;
- no Layer 4 fail-closed semantic regression;
- no publication/Search/Website/Zoho side effect;
- no performance hard-gate regression.

Any failure is immutable evidence. Correct only demonstrated defects; do not weaken tests or governed semantics and do not perform unchanged reruns.

## Remaining sequence after bounded integration

1. If integration is green, reconcile the duplicate visible-version source so mature host and release-currentness source agree on the already-accepted visible release. This is a bounded refactor, not a new feature release.
2. Re-prove currentness after that refactor if it changes deployed source.
3. Reconcile M2.4.5 governance state/ledger/change-control pointers to accepted evidence.
4. Nominate exactly **one** M2.4.5 acceptance run only after all prior gates are green.
5. Close M2.4.5 only if the nominated acceptance passes and the release/version/governance records are synchronized.
6. Production provisioning/promotion remains a separate trust-boundary activity; no Production environment is inferred from Pilot closure.

## Explicit non-actions

- no Production cutover;
- no M2.5 implementation restart;
- no broad publication;
- no autonomous Layer 3 canonical mutation;
- no Evidence/history rewrite or deletion;
- no security/rank/data-quality rule weakened to obtain a green test.
