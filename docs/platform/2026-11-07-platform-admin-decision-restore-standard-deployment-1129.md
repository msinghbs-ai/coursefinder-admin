# Platform Admin decision: restore standard deployment and proceed (D-382 supersession)

Received 2026-11-07 11:29 Sydney. Recorded verbatim by Claude (Integration Controller). Supersedes the Cloudflare deployment-fencing requirement under D-382 and the Cloudflare cutover checklist/wrapper entries recorded earlier today.

```text
StudySearch — Platform Admin Decision: Restore Standard Deployment and Proceed

Effective immediately — supersedes the custom Cloudflare deployment-fencing requirement under D-382.

The existing GitHub-connected Cloudflare deployment process was operational before this additional controller-fencing development.

I do not authorise further Cloudflare deployment reconfiguration, new deployment wrappers or additional account-level infrastructure changes for this release programme.

1. Preserve the existing deployment model

Continue using:

- GitHub repository: "Coursefinder-Pilot"
- Production branch: "main"
- Cloudflare Build command: "npm run build"
- Cloudflare Deploy command: "npx wrangler deploy"
- Cloudflare Version command: "npx wrangler versions upload"

Preserve the existing automated GitHub-to-Cloudflare integration, existing credentials and Cloudflare deployment history.

If the Deploy command was modified, restore its original value before the next release and verify it.

Do not introduce a parallel pipeline.

2. Retire the additional deployment work

- #898: Do not deploy the new Cloudflare wrapper.
- #895: Remove the new controller-fencing architecture from the release-critical path.
- Record this Platform Admin decision against D-382.
- Reconcile any dependencies already incorporated into other PRs.
- Do not accidentally merge obsolete fencing code through a dependent branch.

The atomic controller record can continue serving as an AI coordination mechanism, but it is no longer an additional Cloudflare deployment prerequisite.

Claude is the nominated sole Integration Controller. Codex has stopped and its scheduled resumptions are disabled.

Preserve the existing release, security, approval and recovery guardrails. This decision does not authorise bypassing application-level admission or database-integrity protections.

3. Complete the existing engineering work

Prioritise delivery of:

1. #896 — Exact three-record P0 application-deadline correction.
2. #894 — Course descriptions.
3. #893 — English requirements.
4. #892 and #897 — Integrate the required tests and collector validation exactly once.

Independently establish the correct dependency and migration order after removing the custom fencing work.

Keep #890 and #875 held.

Do not create replacement PRs unnecessarily.

4. Release quality and rollback

Before each merge:

- Run all required CI checks and the complete governed test suite.
- Verify genuine PostgreSQL assertions.
- Check migration ordering and live function hashes.
- Confirm consumer compatibility.
- Preserve Layer 4 admission and trust controls.
- Ensure no unauthorised vendor spending or destructive changes.

Merge and deploy through the existing standard pipeline.

After every release, verify the actual GitHub commit, deployed Cloudflare Worker version, database changes and application behaviour.

If a regression occurs, stop dependent releases and restore the last verified working revision through the existing governed rollback process. Verify the resulting Cloudflare deployment; do not assume a Git revert alone completed rollback.

5. Recover production incidents

Complete the already-authorised correction of the three application deadlines.

Recover the original Claude Work queue alerts task with one supervised delivery test. Confirm receipt and correct queue processing before restoring its hourly schedule.

Do not discard alerts or mark them delivered without actual delivery.

Verify the independent GitHub Platform watchdog passes.

6. Execution expectations

Stop extending the ownership infrastructure.

Focus on merging, deploying, testing and restoring production functionality.

Continue under the canonical operating model and maintain the required Admin audit trail without excessive duplicate reporting.

Provide concise progress after each release:

- PRs merged
- Main CI status
- Production version
- P0/P1 recovery status
- Next action

Primary objective: Deliver a stable, tested StudySearch main branch and functioning production platform using the existing GitHub-to-Cloudflare deployment process.

If a specific migration or security dependency makes this revised release sequence unsafe, identify that exact dependency immediately. Do not silently remove a necessary guard or claim release readiness.```
