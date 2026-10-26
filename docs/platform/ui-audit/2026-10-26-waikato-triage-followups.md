# Waikato triage follow-ups (from the extension's Layer 4 run)

Date: 26 Oct 2026 (AEDT)
Input: Platform Admin 26 Oct 2026 12:29, four items from the browser extension's Layer 4 run on the University of Waikato. The verbatim quotes are in the extension's own report.
Lodged with the other inputs: the speed record (`2026-10-25-speed-reconfiguration.md`), the overnight outcomes (`2026-10-25-overnight-outcomes.md`), the auto-admit record (`2026-10-26-auto-admit-escalation.md`, acceptance evidence) and `PIPELINE-LINEAGE.md` (mechanism table).
No code tonight except the redirect rule's spec (section 2).

## 1 Bachelor of Social Work (WI0858): a rename, not a no-page course

**Live state, checked 26 Oct 12:4x:**
- WI0858 "Bachelor of Social Work (Level 7)" has only its NZQA register link and no official page.
- It was not in any no-page record or first-run sample, so the no-page cause had not recorded it.

**Done now (a data hold, reversible).** I added a `pipeline.course_no_page` row for WI0858 in state `rejected`, with basis `hold: title-verify (Defect 1)` and your instruction quoted. The event is logged in `admin_control_events` (`no_page / title_verify_hold`). The effect:
- job `no-page-propose` skips the course, including after Waikato becomes trusted, when later cases are recorded without a person;
- the course stays in the course search, because `no_page_hold_v1` is false for `rejected`;
- the course goes to the Defect 1 title-verify flow (alias after verification) when that batch is built.

**Two things the check found:**
- **The machine look-alike check would have missed this rename.** "Bachelor of Social Work" against the published "bachelor-of-social-sciences" shares 0.5 of the title words. The auto-admit sample check treats 0.6 and above as a look-alike (`layer4.auto_admit_match_share`). So in a sample, WI0858 would have been machine-"confirmed" as having no page. This is evidence for the sample-rate review (section 4).
- **A wrong fee waits in Layer 4 for WI0858.** The fee reader matched the schedule row "Graduate Certificate in Postgraduate | $15,320 | $16,088" to Bachelor of Social Work. The title similarity was 0.000 and the match confidence 0.7. The Layer 4 item proposes $15,320 as the 2027 fee. **Recommend: reject.** It is not decided by me; it waits for you.

**"Same check for any other register course whose near-twin exists on the provider's site."** Measured at Waikato, read-only:
- 169 active courses have no official page; 111 of them are conjoint.
- Of the other 58:
  - 40 have an unbound page on Waikato's own list sharing at least 0.5 of their title words;
  - 27 share at least 0.6.
- Most of the 40 are the variant shape: "… with Honours" and "Postgraduate Diploma in X" against a "Bachelor of X" or "Master of X" page. That is Defect 1 territory too.
- Word overlap alone cannot tell a rename (Social Work → Social Sciences) from a variant or an unrelated course, so the near-twin check is designed inside the Defect 1 batch, not as a threshold change tonight.
- Until then, the no-page proposer treats any course whose nearest list page shares at least 0.5 of its title words as "title-verify first", not "no page". This is a design statement for the batch; it is not built yet.

## 2 Redirect to a different course's page: rule and spec

**What happened** (live data, with one correction to the premise):
- The AI page match chose `waikato.ac.nz/study/qualifications/certificate-of-attainment-in-english-language` for **WI0911** (Certificate of Attainment in Academic English) on 22 Oct. That address is the CAEL page of **WI0194** (Certificate of Attainment in English Language), a different course. The extension found that the Academic English address redirects there.
- The choice was not bound: WI0911 has no active official page, so the identity gate held.
- **Correction:** the $6,483 did not come from the CAEL page. The fee reader read it from Waikato's international fees schedule (`/study/fees-costs/international-tuition-costs/`). There it is quoted on the row named exactly "Certificate of Attainment in Academic English | $6,483 | $6,807" (title similarity 1.000), so it is WI0911's own schedule line.
- **The year is wrong.** The reader's rows say $6,483 is 2026 and $6,807 is 2027, but the pending Layer 4 item proposes $6,483 as the **2027** fee. That is a year mislabel in the proposal. **Recommend:** reject that item. The 2027 value is $6,807, and the 2026 row should be admitted with fee year 2026 by the reader, not by hand.
- The redirect rule is still needed, because the AI match did pick another course's page for WI0911 and only the identity gate stopped the binding.

**Rule** (Platform Admin 26 Oct 2026 12:29): a page reached through a redirect that lands on a **different course's** page is a **wrong page** for the course that asked for it (S1 semantics). It is not a valid binding.

**Spec, for the search-quality / Defect 1 batch:**
1. **Detect.** Every course-page fetch records the requested address and the final address (after redirects). Firecrawl and the direct fetch both return the final URL.
2. **Same-course test.** The redirect is harmless when the final address is the course's own page: the same normalised path, or a page whose identity proof names this course (code, CRICOS/NZQA id, or title at the identity threshold). Otherwise it is "different course" when either:
   - the final address is bound to, or is the AI-match choice of, another course of the same provider; or
   - the page's identity proof names a different qualification.
3. **Outcome for a different course.**
   - Write a `pipeline.page_rejections` row for the requesting course and the requested address, with reason `redirect_to_other_course`, the same as an S1 rejection. That address is then never offered to that course again.
   - Do not bind.
   - Do not read any value from that page for the requesting course.
   - The AI match drops the candidate.
   - The course stays in search (it does not count toward no-page).
4. **Fee reader.** A value read from a course page applies only to the course the page is identified with. Schedule rows are matched by the row's own qualification text, which is how $6,483 / $6,807 reached WI0911 correctly.
5. **Layer 4 wording.** Where a redirect is the reason, the item says "this address redirects to the page of <other course>".
6. **Acceptance test (fixture).** WI0911's address redirects to WI0194's page. The result: no binding, a rejection with reason `redirect_to_other_course`, no fee from the CAEL page, and WI0194 unaffected.

The rule is recorded in `PIPELINE-LINEAGE.md` (mechanism table). The build queues with the search-quality / Defect 1 batch, not as a hotfix.

## 3 Waikato conjoint first run: pending, and not visible "by university"

**Current state:**
- Waikato's conjoint first run (`4995f89f…`, 111 courses, opened 25 Oct 23:37 AEDT) is **pending**.
- Auto-admit held it with "course list not verified": 0 of 109 bound pages appear on `waikato.ac.nz/study/qualifications/`, because Waikato's bound pages are under `/int/study/qualifications/`.
- The no-page first run (`a534d26b…`) is pending for the same reason.

**Why the extension found no card.** All 60 waiting first runs are in the Layer 4 Inbox, but with **no university attached**:
- The Inbox reads `layer4_review_items` with `coalesce(course.provider_id, scholarship.provider_id)`, so items whose entity is the provider itself get no provider.
- They show only under "By kind", labelled "Course link", with the raw field code as the subject. None appears under "By university".
- **This also blocks the auto-admit bootstrap.** The one approval per list shape is expected from you, and the leaders cannot be found where you work.
- **Fix:**
  - provider-entity items take their provider from the item, and get their own kinds ("No page published: first run", "Conjoint rule: first run");
  - their choices are approve, edit and approve (`has_page_course_ids`), and reject, which already exist in `layer4_review_decide_impl`.

  It is a small Inbox change. I have not made it tonight (you said no code tonight); it is the first item for the next release unless you want it sooner.
- **The list-path mismatch** (`/study/` against `/int/study/`) also holds Waikato out of auto-admit. Same-site path variants belong with the same batch.

## 4 Extension skill: acceptance evidence

The run is logged in the auto-admit record's acceptance evidence, which feeds the review of `layer4.auto_admit_sample_rate`:
- 4 decisions, all rule-correct: 2 skips of click-map entries (NCUK, Summer Research) and 2 keeps (Social Work, Academic English);
- 2 pieces of evidence for the rules themselves: the Social Work rename that the 0.6 look-alike share would miss (section 1), and the redirect case (section 2).

## 5 Platform Admin decisions, 26 Oct 2026 12:50

- **Inbox fix now, as a hotfix release under rule 9.** Scope, exactly: first-run items (no page and conjoint) carry their university in the Layer 4 inbox, appear under "By university", and offer approve / edit / reject on the card. Nothing else in the release. Built as v2.15.357 (S122); the merge record is below.
- **The Platform Admin rejects the two fees in Layer 4.** At 12:5x both items were still pending:
  - WI0858, "Graduate Certificate in Postgraduate, $15,320" (title similarity 0.000), item `44b8f7c6…`;
  - WI0911, $6,483 proposed as the 2027 fee where it is the 2026 figure, item `8889d2f0…`.

  I will check them at the next check.
- Recorded:
  1. **The identity check stopping the WI0194 redirect binding is positive gate evidence.** It is logged in the acceptance data (auto-admit record).
  2. **The near-twin rename check joins the Defect 1 batch as a designed check, not a threshold tweak.** The evidence: 40 Waikato courses with no page have a published neighbour sharing at least half their title words, and the 60% look-alike threshold misses renames.
  3. **Academic English (WI0911) may not be a no-page course at all.** The fees schedule has its own row (exact name, 2026 and 2027 figures), which suggests the course is offered. This is noted for the first-run review rather than assumed: when WI0911 comes up in a no-page sample, it is ticked "has a page" or routed to Defect 1. It is not in Waikato's current no-page sample (WI0003, WI0918, WI0072, WI1007, WI0157). No hold row was added, because the Platform Admin asked for a note, not a hold.
