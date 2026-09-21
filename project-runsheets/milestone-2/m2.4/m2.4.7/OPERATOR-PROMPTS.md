# CF-247 operator prompts

Use one command at a time. Repository/runtime truth overrides this card.

- `CF247 REVIEW` — Review PR #99 exact head against issue #74, live runtime and M2.4.7 gates; report blockers and the next slice only.
- `CF247 PROCEED` — Finish the active PR #99 Gitar slice, inspect the exact diff, require exact-head proof, update continuity and keep the PR draft.
- `CF247 RESUME` — Resume from PR #99 plus M2.4.7 continuity; detect in-flight work, complete one safe slice and persist the next action.
- `CF247 PROVE` — Run the smallest authorised exact-head deployed proof; never bulk-drain or claim admission without M247-FU-021.
- `CF247 CLOSE` — Close only when exact-head CI/deployed UAT, runtime admission-or-Layer-4, canonical/Search/API and governance evidence all pass; otherwise name the blocker.
- `CF247 PAUSE` — Pause the CF-247 hourly automation after preserving the exact in-flight state and next action.

For a context-free new chat, use:

> CF247 RESUME — use both repos, PR #99, issue #74, Supabase and M2.4.7 continuity; finish one safe Gitar slice, verify exact head, persist the handoff and keep the PR draft.
