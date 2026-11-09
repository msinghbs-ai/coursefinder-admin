# Cover email to the Zoho developer (Divya): Zoho API v2 provider list and scholarships (ready to send)

**Status (9 Nov 2026): DRAFT TEXT, NOT SENT.** Written for the Integration Controller to send (or for Mandeep to send) before the release. This is release precondition C (approval package §9.2); record the send as a dated line in §9.1.
**Fill in before sending:** the one field in square brackets, `[RELEASE DAY]`, with the day and time the Platform Admin releases it. Nothing else needs changing.
**Attach:** nothing is required. The note is the text below; the Zoho guide (issue 4) is unchanged. Do not name repositories or internal tools.

---

**To:** Divya (Zoho developer)
**Subject:** StudySearch Zoho API v2: two additive changes from [RELEASE DAY] (provider list and scholarships)

Hi Divya,

A short heads-up. On **[RELEASE DAY]** we are adding some fields to the website API, and two Zoho API v2 calls return them because they pass the same items through. Nothing is renamed or removed, so Zoho keeps working if it ignores keys it does not know. The number and order of campuses in the provider list do change, so please check one thing on your side.

**What changes**

1. **Provider list** (`providers`, the Zoho v2 provider list). Each provider's `campuses[]` now has one item per campus. Before, campuses in the same city were joined into one item with no name. Each item also gains three keys: `campus_id`, `campus_name` and `course_count`. The existing keys keep their values. The number of items and their order change for many providers (about 30 of the 50 we sampled). For example, University of Auckland goes from 1 campus item to 9.
2. **Scholarships** (`scholarships` and `scholarship`, through the Zoho v2 passthrough). Each item gains one key, `nationality_eligibility_status`: `restricted`, `unrestricted`, `unknown` or `under_review`. `unknown` means nothing is held about nationality; it does not mean open to all. The existing keys, including `citizenship_eligibility`, are unchanged.

**Not changed:** the provider detail (it already returns its own campus list), the Zoho sync items, and the Zoho course search and detail.

**What to do**

- If a Zoho mapping reads the first campus of a provider, or counts campuses, please check it. If you store campuses, key them by `campus_id`, not by city or position.
- If you map scholarship fields one by one, you can ignore the new key or store it; it is optional.

**How to test (once it is live)**

1. Call the provider list and find University of Auckland. It should show 9 campus items, each with `campus_id`, `campus_name` and `course_count`.
2. Call `scholarships` and check that each item has `nationality_eligibility_status`. Most are `unknown` today and a small number are `restricted`.
3. Check that your existing campus and scholarship mappings still load without errors.

**Who to contact**

Reply to this email with any question or anything that does not match, and include the request details so I can look it up.

Thanks,
Maddy
