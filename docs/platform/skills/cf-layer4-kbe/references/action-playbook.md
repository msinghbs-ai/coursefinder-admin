# Layer 4 action playbook — v5

Use the existing UI choice and item-level evidence. Cover the 17 kinds current on 30 October 2026. If a kind is not listed, the evidence does not satisfy its rule, or the connected role cannot make the choice, leave it pending with an owner and reason.

## Contents

1. Decision and completion rules
2. Course, fee and scholarship items
3. Website, page and adapter items
4. Register and first-run items
5. Counsellor reports
6. Entry requirements (AER)
7. Exceptions and stop conditions

## 1. Decision and completion rules

### Decision reasons

Use a concise, auditable reason:

`[L4B-id] <category>: <existing choice> — <source/quote/identity basis>`

Record the stable UI item/ref id in the checkpoint. Do not place secrets or full page dumps in reasons.

### Completion contract

- Submit one existing choice at a time and verify that the item leaves **Waiting for a person**.
- Treat Open course/adapter/central-pages and other links as navigation. Finish the required correction or approval in the existing destination UI, then verify Layer 4 closure.
- Treat a queued rebuild/re-read/onboarding retry as downstream work, not an admitted value. Report its outcome separately.
- Never overwrite a manual value or binding, approve from memory, or act from an unavailable quote. Leave newer-value, identity and ownership conflicts pending.
- A role-disabled choice is not available to the Skill. Do not bypass it.

## 2. Course, fee and scholarship items

### Course link — `course_link`

- **Keep the page we hold** when stored official evidence proves it is the current page for the exact course and study level. Newer is not automatically better.
- **Use the new page** only when the proposed official URL proves the same course and is more current or correct than the held page. Do not replace a manual binding.
- **Enter another address** only for a verified URL normalisation or exact official page. For a held-fee course-link item, use the course's own HTTPS provider page so the existing read-again path can run. Do not use normalisation to bind a different page.
- Leave conflicting course codes, titles, levels, ownership or newer active values pending.

### Held scholarship — `held_scholarship`

- **Publish** only when the official stored quote proves the scholarship, its value/benefit, international eligibility and provider identity. Check for an active equivalent; leave exact or near duplicates pending for deduplication.
- **Not for international students** when the quote restricts eligibility contrary to international admission or the existing evidence rule finds international eligibility unproven.
- **Not a scholarship** when the page does not describe a scholarship for the platform.
- Do not publish from an unavailable AI re-check, unquoted inference or another provider's page.

### Fee fails the check — `fee_check`

- **Keep the CRICOS/registered total** when the page fee fails the existing variance or year rule; release the hold and keep the page fee unadmitted.
- Use **Open the course** only to complete a supported existing fee correction/admission. Require explicit course identity, amount, currency and fee year, and pass every existing match/admission gate. Verify both the course save and Layer 4 closure.
- Similar titles are insufficient. A renamed award requires source evidence connecting the names.

### Course not offered — `not_offered`

- **Archive the course** only when current official evidence supports that the provider no longer offers the exact course and the existing archive rule is met.
- **Keep it** when current authoritative evidence shows the course remains offered and the not-offered reading is wrong.
- Reader failure, a 404, an old AI result or one failed search is insufficient. Leave register/provider conflicts and renamed/replacement awards pending.

### Course not on the university's site — `not_on_site`

- **Archive the course** only under the same current-evidence archive rule as Course not offered.
- **Keep it** when the current register still lists the exact course and the evidence does not establish withdrawal; record the register basis.
- **Open the course** is navigation only. Enter or confirm its exact official page in the course UI when supported, then verify closure.
- Do not infer discontinuation merely from discovery failure. Leave identity conflicts pending.

## 3. Website, page and adapter items

### Website needed — `website_needed`

- **Enter the website** only after verifying a current official provider site and identity from stored evidence. Saving starts onboarding; report downstream work separately.
- **CRICOS data only** only when an existing provider policy or explicit Platform Admin instruction authorises that operating choice; never use it merely to clear the pill.
- **Archive the university** only with authoritative evidence that the provider is not operating and the existing archive rule and role are satisfied.
- Otherwise leave the source gap pending with an owner.

### Course pages not found — `pages_not_found`

- **Change the website** only to a verified current official provider site.
- **Add page addresses** through the existing builder only for exact official course/list pages. Complete the addition and any required hold release before claiming closure.
- **Release and try again** at most once when stored evidence shows the earlier failure was transient or its cause has been corrected. Do not repeat unchanged retries.
- **CRICOS data only** only under the explicit policy/authorisation rule above.

### Too few course pages — `too_few_pages`

- **Add page addresses** through the existing builder using current official course/list pages; onboarding must have enough pages to continue.
- **CRICOS data only** only under explicit policy/authorisation.
- If no adequate official source exists, record the source gap rather than forcing approval.

### Adapter has nothing ready — `nothing_ready`

- **Open the adapter** only to make supported pattern/page corrections through the existing builder and qualify again; navigation alone is not a decision.
- **Rebuild the adapter** at most once when current official source evidence supports it and the connected role permits it. Track the rebuild outcome separately.
- **CRICOS data only** only under explicit policy/authorisation.
- Leave repeated failure for platform review with the error and affected course count.

### Central pages to approve — `central_to_approve`

- **Open the central pages** and approve or refuse each page in the existing destination UI. Navigation alone closes nothing.
- Approve only a current official provider source with compatible study level and scope, supported by quotes for the values applied.
- Do not reuse another campus, country, faculty or provider policy by assumption. Verify that the Layer 4 item closes after the required page decisions.

### Adapter proposal failed — `onboarding_failed`

- **Try again** at most once when the failure was transient or its recorded cause has been corrected.
- **Build by hand** only through the existing builder using current official pages and existing adapter qualification/admission rules. Complete the required work rather than counting the navigation.
- Leave repeated or deterministic failure for platform review; do not autonomously repair the reader.

### Website not answering — `site_down`

- **Change the website** only to a verified current official provider site; the existing onboarding restart is downstream work.
- **Keep waiting** when authoritative evidence indicates the provider still operates at the held site and no verified replacement exists. Report this as **deferred**, with the existing re-check path, not as reconciled or admitted.
- **Archive the university** only with current authoritative closure evidence and the required role; a timeout, 404 or 30-day hold alone is not closure evidence.
- Leave uncertain ownership, replacement-site and register conflicts pending.

## 4. Register and first-run items

### Provider left the register — `provider_departure`

- **Still operating: keep it** only when current authoritative evidence proves the provider remains operating under the same identity.
- **Closed: archive it** only when current authoritative register/provider evidence proves closure and the existing retirement rule is met.
- **Merged into another provider** only with authoritative merger evidence, an exact verified successor and separate explicit Platform Admin approval for that provider/successor. A generic batch command grants no merger authority.
- Leave ownership, replacement-registration and conflicting-register cases pending.

### No page published: first run — `no_page_first_run`

- **Approve: none has its own page** only for verified non-award, shared-page, conjoint or other legitimately page-less cases under the existing rule.
- **Approve, except courses that have a page** only after checking the sample and ticking every course with its own current official page. Ticked courses keep searching; do not tick to force the 60% trust rule.
- **Reject** when the sample/list is unreliable or the page-less claim is unsupported.
- Never classify a page as absent merely because discovery or reading failed.

### Conjoint or double degrees: first run — `conjoint_first_run`

- **Approve: no page of their own** only when official evidence and the existing rule support the page-less conjoint classification.
- **Approve with their shared page** only when the proposed parent/shared official page explicitly covers the relevant awards and identities.
- **Reject** when the sample, identity or shared-page evidence is unsupported.
- Do not infer shared eligibility from similar titles or a faculty listing.

## 5. Counsellor reports

### Counsellor report — `counsellor_report`

- Read the issue, field, suggested value, source link and current record. Use stored evidence by default; if the report cannot be settled without unavailable/new evidence, leave it pending with an owner.
- **Open the course** and correct the actual value through the existing record UI only when official evidence supports the correction. Verify the saved correction before closing the report.
- **Fixed** only after the required correction is saved, or when inspection proves the reported issue was already corrected. State the corrected/current value and evidence in the note.
- **Not changed** when the current value is proven correct or the suggested change is unsupported. Give the evidence-based reason; never use it to dismiss an unresolved valid report.
- Verify that the report closes and Zoho receives the existing outcome. Do not mark Fixed before the underlying correction exists.

## 6. Entry requirements (AER)

### AER review — `aer_review`

Use a Platform Admin session and decide one item at a time. Generic bulk/batch decisions are prohibited. Do not start a re-read, AI call or reader change; those require separate authority.

Before deciding, open the source and newest stored copy. Check:

- the item is on the newest run/copy and is not already decided;
- course items have strong exact-course identity; matrix items are on the provider's official source;
- every quote is on that stored copy, with matching country and published/mapped level;
- every number has its scale, every course score its printed basis, and every band is printed rather than inferred;
- kept/not-kept counts and completeness support a whole-read decision;
- generic notes that are not academic entry requirements are excluded.

Then use the existing choice:

- **Approve all rows** only when every waiting row passes and the whole read is reliable. Earlier active rows are superseded under the existing whole-read rule.
- **Approve except…** when identified rows fail but the remaining rows pass. Tick only the rows to leave out; at least one row must remain. If all fail, use Reject. Excluded rows stay unadmitted; an earlier active row is superseded only by an approved replacement with the same identity. An excluded or absent replacement leaves the earlier active row untouched.
- For a course that already has active entry rows, do not use Approve except: the existing D4 rule holds it. Use Approve all only if every row is right, otherwise Reject.
- **Reject the read** for a materially incomplete/unreliable read, a stale older-copy item, or a no-table note where the page actually contains a requirements table. For a stale item, name the newer item/run in the reason.
- For a rendered no-table note, **Approve** only when the stored page shows no requirements table; this records no matrix published and admits no rows.
- Exclude a printed grade whose scale is not stated if the reader supplied an inferred scale. Never guess or normalise a scale.
- If approved replacements conflict, the server holds the decision with nothing changed. Do not retry the same payload. Reload, adjust exclusions only where evidence justifies it, Reject, or escalate.
- If another reviewer decided first, reload and do not re-decide. Review a newer duplicate, never approve both.

Record admitted, excluded, superseded and retained row counts separately. A complete read is not evidence of correctness, and no consumer-visible row is counted as admitted until the decision succeeds.

## 7. Exceptions and stop conditions

### Exception labels

Use the existing item state; do not create statuses. In the batch narrative, classify exceptions as:

- source unavailable or inadequate;
- course/provider identity;
- policy or human judgement;
- duplicate/deduplication;
- reader or link defect;
- correction or linked action incomplete;
- publish/decision-path timeout;
- re-raised after decision;
- adapter rebuild or onboarding retry pending/failed;
- role or separate-authorisation required.

### Batch-wide stop conditions

Stop and preserve completed checkpoints when any of these occurs:

- authentication or required Platform Admin/AER access is lost;
- repeated statement timeouts or uncertain write outcomes affect more than one provider;
- the same defect makes multiple providers' evidence or decisions unreliable;
- an action appears to cause an unexpected consumer-visible change;
- queue refs/counts cannot be reconciled after refresh;
- a new pill is absent from this playbook or an existing choice no longer matches the live UI contract.