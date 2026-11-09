# Platform Admin: Final Decisions D1 to D6 (7 Nov 2026 10:53 Sydney)

Recorded verbatim by Claude (Integration Controller, execution `claude-controller-20261107T0000Z`) before acting. Supplements `2026-11-07-emergency-recovery-and-integration-handover-1030.md`.

StudySearch — Platform Admin Final Decisions

This instruction supplements the existing emergency recovery mandate.

All previous decisions are confirmed. Do not repeatedly request approval for the same scope.

D1 — Controller ownership

Approve the existing atomic ownership mechanism using non-forced fast-forward Git commits, provided compare-and-set ancestry, immutable readback and controller guard validation pass.

Ownership acceptance does not authorise production mutations until actual production entry-point fencing is installed and independently verified.

D2 — P0 application deadlines

Explicitly approve clearing ONLY "application_deadline" on these three confirmed records:

- CRICOS 095229D — 2026-11-02
- CRICOS 094185G — 2027-02-15
- CRICOS 106137B — 2026-10-12

Record this approval durably under Admin #382.

Execute only after PR #896's migration is deployed, the exact intake IDs and current values are verified, controller ownership is active, an operation reservation exists and the governed before/after audit passes.

Preserve all other fields, original evidence, human locks and consumer contracts.

D3 — P1 alert collector

Approve one supervised, bounded grouped-digest recovery run AFTER production ownership and fencing are active.

Use the existing Claude task "trig_01Eo7QrJXR24e774gNzLUvTi".

Preserve the original recipient, schedule and alert identities. Do not create another collector, channel or scheduler.

I will confirm actual receipt before automatic hourly execution is restored.

Do not bulk-mark historical alerts delivered.

D4 — Account security

Approve minimum-privilege GitHub "pilot" environment and Cloudflare deployment fencing using the existing reviewed D-382-CUTOVER design.

Preserve service continuity and emergency recovery.

Do not revoke unrelated Supabase credentials without verifying ownership and service dependencies. Obtain separate approval for any credential removal that risks disruption.

D5 — Release order

Validate and execute the dependency-resolved sequence:

#895 → #896 → #894 → #893

Integrate #892 and #897 exactly once according to their actual Git ancestry.

Keep #890 and #875 held.

D6 — Delivery priority

Stop repeated approval requests, speculative engineering and redundant checkpoints.

Continue safe work immediately. Once account controls are installed and verified, complete the guarded releases and production acceptance.

Record these decisions in the existing Admin execution register.

Your next update must distinguish:

- Account controls verified
- Ownership active or blocked
- PRs merged
- Main CI
- Production releases verified
- P0/P1 incidents resolved or outstanding
- Next actionable step

Do not equate green CI with production delivery.
