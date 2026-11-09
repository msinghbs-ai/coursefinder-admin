# Cover email to the Wix developer: Website API v2, Issue 8 (ready to send)

**Status (9 Nov 2026): DRAFT TEXT, NOT SENT.** Written for the Integration Controller to send (or for Mandeep to send) on or just before the release day. Australian English, plain language.
**Fill in before sending:** the one field in square brackets, `[RELEASE DAY]`, with the day and time the Platform Admin releases it (for example "Wednesday 11 November 2026, from about 10:00 AEDT"). Nothing else needs changing.
**Attach:** the Issue 8 guide (Word and PDF), `StudySearch-Website-API-v2.openapi.json`, `StudySearch-Website-API-v2.postman_collection.json`, the two files in `examples/`, and `HANDOVER-NOTE.md` (all in `docs/integrations/developer-pack/drafts/issue-8/`). Your key is unchanged; do not send keys by email.
**Release precondition A** (approval package §9.2): record the developer's acknowledgement (dated line, §9.1) before the release merges.

---

**To:** Raghav (Wix developer)
**Subject:** StudySearch Website API v2, Issue 8: campus names and course counts, scholarship nationality status

Hi Raghav,

Issue 8 of the Website API v2 guide is attached. It answers your requests for campus names and course counts, and for a nationality status on scholarships. It goes live on **[RELEASE DAY]**. I will reply on this thread when it is live. Until then, please keep building against Issue 7.

**What changes**

1. **Provider campuses.** Each campus is now its own item in `campuses[]`. Before, campuses in the same city were joined into one item with no name. Each item keeps its six existing fields with the same values and gains `campus_id`, `campus_name` and `course_count`. Some providers will return more items (University of Auckland goes from 1 to 9, RMIT from 5 to 6). The order of `campuses[]` also changes: campus name, then `campus_id`. For 489 of 1,620 providers (about 3 in 10) the array is different, and for 283 the first campus is a different campus.
2. **Scholarship nationality.** Each scholarship gains `nationality_eligibility_status`: `restricted`, `unrestricted`, `unknown` or `under_review`. An empty `citizenship_eligibility` list means "not held", never "open to all". `unrestricted` is not returned yet, so please do not show "Open to all nationalities" unless you receive it.

Nothing is renamed or removed. Course `campuses[]` are not changed. A page that ignores keys it does not know keeps working.

**What to do**

1. Read sections 7.4, 7.5 and 9 of the guide (9 has the suggested Wix mapping).
2. Key campuses by `campus_id`. Please do not rely on position or on `campuses[0]`, and group by `campus_id` rather than by city. A city filter still works on `city`.
3. Direct calls (`providers`, `provider`, `scholarships`, `scholarship`) return the new fields from the release day. The `sync` deltas pick the changes up over roughly 1.5 hours of rolling passes after the release, so a copy built from `sync` fills in during that time. They will carry the changed providers (about 1,402) and scholarships (about 1,144) once more, about 22 MB before compression (send `Accept-Encoding: gzip`). No full load is needed and your cursor stays valid.

**How to test (once it is live)**

- Run acceptance tests 25 and 26 (guide section 12; they cover the new fields. Test 27 checks ranking history, which already works).
- `provider:nzqa:7001` (University of Auckland) should return 9 campuses, each with `campus_id`, `campus_name` and `course_count`. `provider:cricos:00122a` (RMIT University) should return 6.
- Every scholarship should carry `nationality_eligibility_status`. At the moment most are `unknown` and a small number are `restricted`.
- If anything does not match, send me the `request_id` from the response and what you expected.

The note also answers your other requests: ranking history and academic entry requirements are already available (guide 7.6 and 7.9), and university-level costs are not available.

**Who to contact**

Reply to this email with questions or a failed test and I will pick it up.

Thanks,
Maddy
