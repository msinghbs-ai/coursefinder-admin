# M2.3 Next Chat Continuation Prompt

Copy/paste the block below into the next CourseFinder chat.

---

**M2.3 — CONTINUE FROM REPOSITORY RUN SHEET / OPENROUTER BENCHMARK HANDOFF**

Before doing any work, read `PROJECT_INSTRUCTIONS.md` in `msinghbs-ai/coursefinder-admin`, then read in full:

- `project-runsheets/README.md`
- `project-runsheets/milestone-2/m2.3/RUNSHEET.md`
- `project-runsheets/milestone-2/m2.3/CURRENT-STATE.md`
- this `NEXT-CHAT.md`
- CF-CHG-20260825-036, -037 and -038
- current Running Build

Treat current GitHub, deployed Supabase/runtime and CI/UAT as authoritative. Inherit newer parallel work; do not rely on stale chat history, SHAs or assumptions.

Current Go 4 target is Pilot SHA `87da570d8e6701928e45d532caf11877b6eab369`, PIM Admin `v2.15.5`, M2.3 Intelligence `v1.2`. The UI includes terminal Layer 4 and a Platform-Admin-only **Layer 3 Provider** control that can store an OpenRouter API key in Supabase Vault and run bounded provider verification. Credential save/verification never unpauses the profile.

Proceed autonomously in dependency order:

1. Reconcile the final Frontend Build/browser-smoke/deployed desktop/mobile outcome for the current Pilot head. If a newer head exists, use the newer accepted head rather than this SHA.
2. If the permanent Go 4 desktop/mobile matrix is not PASS, diagnose and correct the product/runtime without weakening acceptance tests, then rerun the matrix.
3. Reconcile `openrouter-free-router-v1`. Until the authorised user has entered a credential through **Layer 3 Provider**, keep the profile PAUSED and classify real-provider work `BLOCKED — USER CREDENTIAL NOT YET CONFIGURED`.
4. Once the user has entered the key and selected **Verify provider**, read only non-secret profile/audit state. Never request, echo, retrieve into chat or persist the credential itself.
5. Require successful connectivity state `credential_verified_pending_benchmark`; the profile must still be PAUSED.
6. Execute the bounded real-provider Layer 3 benchmark autonomously using governed retained Evidence. Cover valid extraction, no-candidate, malformed output, unsupported/hallucinated candidate rejection, unavailable provider/model, timeout, retry/RPM/day/cost ceilings, unchanged-Evidence zero-call, changed/expired/revalidation eligibility and fallback behaviour. Retain configured/returned model, profile, prompt/validator versions, token/cost/latency/result/quality/Evidence/UAT/Change Control lineage.
7. Do not unpause/resume Layer 3 until benchmark PASS is explicit and governance permits it. If benchmark fails, leave PAUSED and record evidence.
8. Complete CF-CHG-037 representative Onboarding lifecycle rollback/negative UAT, including invalid transitions, rank/anon/private-helper denial, audit lineage and no canonical country fork.
9. Complete any remaining CF-CHG-036 production-grade Layer 1/2 source/scale/economics, guide/role-tour and authority-regression gates.
10. Establish the complete M2.3 PASS/BLOCKED/DEFERRED classification. M2.4 remains blocked until this boundary is explicit.
11. Update RUNSHEET, CURRENT-STATE, NEXT-CHAT, applicable Change Controls, Change Control REGISTER and Running Build to actual deployed truth before ending.

Automated UAT is the default. Do not ask the user to perform routine technical UAT that can be automated. The only expected manual action at this boundary is entering their OpenRouter API key in the secure Admin UI; do not ask them to paste it into chat.

---
