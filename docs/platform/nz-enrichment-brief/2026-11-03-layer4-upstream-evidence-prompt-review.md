# Review — Layer 4 upstream evidence prompt and browser-session use (3 November 2026)

**Reviewed:** `2026-11-03-layer4-upstream-evidence-claude-prompt.md`, the 19:00 checkpoint, its CSV, the `cf-layer4-triage` skill and playbook v5, and the deployed Layer 4 screen (read only).
**Status:** review only. No Layer 4 decision opened or submitted, no form used, no SQL, no fetch, no AI re-check, no spend. The section 1 audit in the prompt has not been run.

## Answer
Yes, the signed-in browser session can help, but as a read and verify tool and, with named approval, for individual decisions. It should not be used to fill evidence gaps or to work through the queue.

| Use of the browser session | Verdict | Why |
|---|---|---|
| Read what Layer 4 shows against a ref | Yes | Supported inspection; proves step 2 of the repaired-route proof |
| Compare a held scholarship with the Catalogue record | Yes | Read only; needed for Macquarie ref 1184 |
| Confirm a saved decision has left waiting | Yes | Existing verification route; avoid the Decided view |
| Submit a decision on a named ref | Only with named approval | One ref, one existing UI choice, one evidence basis, first write per kind verified |
| Read a university page and use it as evidence | No | Nothing is stored, so it fails evidence-first; also breaks the 3 November enrichment principle |
| Trigger Firecrawl, AI re-check or a rebuild from the UI | No, unless approved | Paid or spend-bearing; prompt section 4 |
| Bulk or queue-wide work | No | Prohibited, and Claude would become the enrichment workforce |

## Findings
1. **Baseline has moved.** Live at this review: 5,031 pending across 829 universities, AER 557. The checkpoint's final figure was 5,025 and AER 551, so all 6 of the rise is AER; the 5,024 figure is correctly labelled historical. Other kinds were not compared one by one.
2. **Attribution is unresolved.** The prompt says automated validation must not impersonate a human decision, while the checkpoint expects an agent to qualify a saved decision in a Platform Admin session. A click in that session will presumably be recorded against the Platform Admin; this has not been tested. A ruling is needed.
3. **Settlement owner is left open.** The prompt says "if that reviewer retains settlement ownership". Only one party should write to a ref.
4. **Firecrawl has 2,844 credits left, renewing 3 December.** The prompt bars unapproved paid reads but sets no allowance. Items with no stored copy (UNSW links, the four fee holds, unreadable scholarships) may stay blocked. Background jobs may also draw on these credits.
5. **The stop for University description looks justified.** The kind is live (385) and absent from playbook v5; section 7 lists an absent pill as a batch-wide stop. As written that stop has no carve-out, so whether unrelated kinds may continue needs a rule, not an assumption.
6. **The skill names only the Kimi Browser Extension.** A Claude-session route needs one line in the skill before it is used for writes.
7. **Scope could run on.** "Continue until acceptance" has no bound. Proposed: the 24 refs and their root causes, then a resume point.
8. **Throughput comes from root causes.** Course link is 3,320 of 5,031 (66%). Hand decisions at this size will not move the queue.

## Checkpoint checks done so far
CSV has 24 rows, 24 unique refs, 9 providers: 10 course link, 10 held scholarship, 4 fee check. All show submitted false, admitted 0, left pending. These match the checkpoint. 4 rows have no source URL. Nothing has yet been checked against the live items.

## Decisions needed
A. Who writes decisions on these refs. B. How an agent-submitted decision is attributed. C. Firecrawl allowance for evidence recovery. D. Whether unrelated kinds continue while University description is aligned.
