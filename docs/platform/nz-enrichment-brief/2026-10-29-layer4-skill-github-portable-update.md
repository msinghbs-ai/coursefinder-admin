# Layer 4 Skill — GitHub source and portable Kimi Work update

Date: 29 October 2026; updated 30 October 2026  
Scope: Skill documentation/package update only. No Layer 4 decisions, catalogue writes or platform code changes performed.

## Canonical source

The `cf-layer4-triage` / **Layer-4-Review** Skill source lives in GitHub:

- `docs/platform/skills/cf-layer4-triage/SKILL.md` — latest audit/ref correction commit `47153f2504a68add6affffb70bdf2bfeba41ad47`
- `docs/platform/skills/cf-layer4-triage/references/action-playbook.md`

The existing run/export guide is updated rather than leaving a conflicting full-queue-only SOP:

- `docs/platform/nz-enrichment-brief/2026-10-28-layer4-skill-run-and-export.md`

## Reusable behaviour

The Skill supports:

```text
layer4-by-kind-qualify
```

On a new workstation, untested connection or previous zero-decision/uncertain batch, this qualification is required before `layer4-clear-all`. It:

- selects one suitable existing kind and excludes higher-risk qualification categories;
- reviews at most 10 oldest items and submits at most five decisions;
- requires the first actual UI decision to be submitted and verified before continuing;
- permits up to four more individually evidenced decisions only after that verification;
- stops on uncertain writes, remaining queue items or UI/network failure;
- reports actual decisions and stable UI item/ref ids, never snapshots or proposed actions as progress.

Qualification proves UI submission and the selected kind's route, not every Layer 4 route. When later work enters a different kind, its first decision must be verified before continuing.

The provider workflow requires supported decisions rather than proposed-action summaries and prohibits broad By kind snapshots from substituting for provider checkpoints. A new bounded qualification is required when a checkpoint is unavailable on another workstation.

## Verified audit correction

Live verification of `L4B-20261030-0938` confirmed that Inbox submissions are recorded in `pipeline.admin_control_events`; applicable routed review items can also have `pipeline.layer4_decisions` rows. The Skill now uses stable UI item/ref ids—review-item UUIDs where applicable and numeric/kind-specific refs otherwise—and prohibits double-counting the two ledger records.

The audit guide was corrected accordingly:

- `docs/platform/nz-enrichment-brief/2026-10-28-layer4-decision-audit.md` — commit `758e41d4efda6d0eda96d4b900bd5cb6918a89b2`

Existing evidence, no-SQL, no-delete, no-bulk-approval, stored-source and Decided-view safeguards remain in force.

## Portable package verification

The rebuilt `cf-layer4-triage.skill` package passed the Skill validator and ZIP integrity/content checks. It contains exactly:

- `cf-layer4-triage/SKILL.md`
- `cf-layer4-triage/references/action-playbook.md`

Package size: 6,312 bytes.  
SHA-256: `8af76c7804bab991f1619f368e233f8aee33bcc4088f2ac993c7d21620a61ae8`

The validated `.skill` package is delivered with the chat response; GitHub holds its canonical text source and operating guide.

## Reuse on another workstation

1. Transfer the delivered `cf-layer4-triage.skill` package to the workstation.
2. In Kimi Desktop **Work → Skills**, import/upload the package. Remove or replace an older copy so there is no ambiguity about the active version.
3. Install/connect Kimi Browser Extension and authenticate Platform Admin separately; no credentials or browser state are included.
4. Invoke the Skill and run `layer4-by-kind-qualify` before any full-queue command.
5. Transfer an in-flight consolidated checkpoint separately only when deliberately resuming an earlier batch. Otherwise start a new batch.

For subsequent changes, edit the GitHub source and regenerate the package from that source. Do not maintain independent workstation-only Skill variants.
