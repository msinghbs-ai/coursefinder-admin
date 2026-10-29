# Layer 4 action playbook

Use the existing UI choice and item-level evidence. If a category is not listed or the evidence does not satisfy the rule, leave it pending with an owner and reason.

## Decision reasons

Use a concise, auditable reason:

`[L4B-id] <category>: <existing choice> — <source/quote/identity basis>`

Record the stable item id in the checkpoint. Do not place secrets or full page dumps in reasons.

## Category rules

### Course link

- **Keep the page we hold** when it is the current official page for the exact course and study level. Newer is not automatically better; compare dates and course identity.
- **Use the new page** only when the proposed official URL proves the same course and is more current or correct than the held page.
- **Enter another address** only for a verified URL normalisation or an exact official page. An `http` proposed URL may be entered as `https` when it is the same official resource and the stored proposal fails validation; do not use this workaround for a different page.
- Leave conflicting course codes, titles, levels or ownership pending.

### Held scholarship

- **Publish** only when the official page quote proves the scholarship, its value/benefit and international eligibility, and provider identity is correct.
- **Not for international students** when the quote restricts eligibility contrary to international admission or the existing evidence rule finds international eligibility unproven.
- **Not a scholarship** when the page does not describe a scholarship for the platform.
- Before publishing, check for an already active equivalent scholarship for the same provider. Leave exact or near duplicates pending for deduplication; do not publish a second copy.
- Do not publish from an unavailable AI re-check, an unquoted inference or another provider’s page.

### Fee fails the check

- **Keep the CRICOS/registered total** when the page fee fails the existing variance or year rule; the page fee remains unadmitted.
- Admit or approve a page fee only when course identity, amount, currency and fee year are explicit and all existing match/admission gates pass.
- Similar titles are insufficient. A renamed award requires source evidence connecting the names.

### Course not on the university’s site / course not offered

- **Archive the course** only when current official evidence supports that the university no longer lists/offers the exact course and the existing archive rule is met.
- Reader failure, a 404, an old AI result or absence from one search result is insufficient by itself.
- Use the existing reviewable archive/unpublish action, never deletion. Record the register and official-source basis.
- Leave register-versus-provider conflicts and possible renamed/replacement awards pending.

### No page published: first run

- **Approve: none has its own page** only for verified non-award, shared-page, conjoint or other legitimately page-less cases under the existing rule.
- Do not classify a page as absent merely because discovery or reading failed.

### Conjoint or double degrees: first run

- Bind a parent/shared official page only when it explicitly covers the relevant awards and identities.
- Do not infer shared eligibility from similar titles or a faculty listing.

### Central pages to approve

- Approve only a current official provider source with compatible study level and scope, supported by a quote.
- Do not reuse another campus, country, faculty or provider policy by assumption.

### Website needed / course pages not found / too few course pages

- Use an existing source or rebuild action only when an official current source is known and the action is authorised.
- If no adequate source exists, record the source gap and owner rather than forcing approval.

### Adapter has nothing ready / adapter proposal failed

- Queue an existing rebuild at most once when current official source evidence supports it.
- A queued rebuild is not a completed admission. Track its outcome separately and do not repeatedly rebuild failures.
- Leave repeated failure for platform review with the error and affected course count.

### Provider left the register

- Require current authoritative register evidence and the existing provider-retirement rule.
- Leave ownership, merger, replacement-registration and conflicting-register cases for a human decision. Do not archive a provider merely to clear its queue.

## Exception labels for reporting

Use the existing item state; do not create statuses. In the batch narrative, classify exceptions as:

- source unavailable or inadequate;
- course/provider identity;
- policy or human judgement;
- duplicate/deduplication;
- reader or link defect;
- publish/decision-path timeout;
- re-raised after decision;
- adapter rebuild pending or failed.

## Batch-wide stop conditions

Stop and preserve completed checkpoints when any of these occurs:

- authentication or Platform Admin access is lost;
- repeated statement timeouts or uncertain write outcomes affect more than one provider;
- the same defect makes multiple providers’ evidence or decisions unreliable;
- an action appears to cause an unexpected consumer-visible change;
- queue ids/counts cannot be reconciled after refresh.
