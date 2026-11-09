# H01 held courses and refused shown links: measurement for a decision pack (3 Nov 2026)

- **For:** a Platform Admin decision pack (Workstream E, direction 2 Nov 2026 23:24). Findings H01/H09 and §2 of `2026-11-02-housekeeping-disposition.md`.
- **Scope:** read-only, on `fxcwkweaxjtknorudmwp`.
  - Measured 2 Nov 23:57 – 3 Nov 00:27 AEDT, in the :x6–:x8 minutes only.
  - Queries were keyed by `course_id` halves, with a 9 s statement limit.
  - Page checks ran in batches of 41 and 52.
- **Changed: 0. Deleted: 0.** Nothing here is executed. Every option below needs a decision first.

## 1. The 93 held courses (H01, with H09 overlap)

**Same cohort as at 12:06.** The md5s are unchanged: half A `bac0e6ca5736e302b709bd2189ac6987` (41), half B `c43b9dd6eb0e99e7d8ce457fb909623d` (52).

**Why they were held:** in each course a Layer 4 reviewer link is the shown link. But the tranche rule ("primary, or equal to `course_url` and passing the page check") is not met.

| Measure | Half A | Half B | Total |
|---|---:|---:|---:|
| Held courses | 41 | 52 | **93** |
| Shown link is the reviewer link (`layer4_human_review`) | 41 | 52 | 93 |
| A recorded approval of the shown page exists (`approved` or `edited_approved` item proposing it) | 4 | 9 | 13 |
| `course_url` names the **same page, spelled differently** (scheme, www, query, fragment, slash, case) | 9 | 28 | **37** |
| `course_url` names a **third page** | 28 | 20 | 48 |
| `course_url` empty | 4 | 4 | 8 |
| `course_url` was written by the nightly fill (`course_url_fills`) | 37 | 48 | **85** |
| An older-year link beside a newer one (H09) | 38 | 47 | 85 |
| Shown page carries a year of 2024 or earlier | 2 | 2 | 4 |
| Pending `official_course_url` item now (most from route v2, event #28640) | 8 | 22 | 30 |
| Page check on the shown link: pass | 39 | 47 | **86** |
| Page check on the shown link: refuse | 2 | 5 | **7** (§2) |

**By provider:**
- Australian National University 55 (30 + 25).
- Simon Fraser University 30 (8 + 22).
- Flinders 2, The University of Sydney 2, The University of Queensland 1, Bond 1, Wollongong 1, TAFE Queensland 1.

**What this means:**
- 86 of 93 shown reviewer links pass the page check today.
- The only reason they fail the rule is that `course_url` was set from a different page. For 85 of them, the nightly fill set it from the proven page binding.
- In 37 courses, `course_url` is the same page as the shown link, only spelled differently. A rule that compares normalised addresses would count them as validated.

**Options:**

| Option | What | Consumer-visible change | Courses |
|---|---|---|---:|
| A | Accept a passing page check on the reviewer's shown link as the validation; consolidate as in the tranche (set the old link `inactive`, make the reviewer link primary) | **None** (the shown link is kept) | 86 (pass), excluding the 30 with a pending item until it is decided |
| B | As A, but only where `course_url` is the same page spelled differently (normalised comparison) | None | 37 (subset of A) |
| C | Settle H07 first: align `course_url` to the reviewer link, then the existing rule applies | None on the website or Zoho (`course_url` is not in the consumer API) | 93 |
| D | Leave all as they are (multi-link, shown link unchanged) | None | 93 |

**Recommendation:** B now, then A after a decision on H07. In both, the 30 courses with a pending item wait for their Layer 4 decision. A file would follow the tranche pattern, with the same guards, rollback and in-transaction consumer check.

## 2. Shown links the page check refuses (7)

| Code | Provider | Shown (reviewer) page | Other active link | Verdict | `course_url` | Pending item | Active fee |
|---|---|---|---|---|---|---|---:|
| 079094C | ANU | `…/2020/program/4050fdd-aengi` | `…/2025/program/bfinn-aenrd` (sweep; another programme) | refuse, older_year | empty | none | 1 |
| 082271J | ANU | `…/2021/program/varsc` | `…/2015/program/varsc` (sweep) | refuse, old_year | = shown | none | 1 |
| 091191A | ANU | `…/2021/program/veinv` | `…/2020/program/veinv` (sweep) | refuse, old_year | = shown | none | 1 |
| 093912A | Bond | `…/program/bachelor-of-artsbachelor-of-laws` | `…/program/bachelor-of-laws` (sweep) | refuse, sibling | = shown | none | 0 |
| 094206G | Wollongong | `…/courses/bachelor-of-laws-graduate-entry/` | 2020 handbook PDF page (sweep) | refuse, variant | = shown | 1 (binding check, 2 Nov 21:09, proposes the same page without the slash) | 1 |
| 107313E | TAFE Queensland | `…/course/19/19030/diploma-of-information-technology` | `…/19/19415/…` (sweep) | refuse, variant | = shown | none | 1 |
| 108334C | Sydney | `…/bachelor-of-design-in-architecture-honours.html` | `…/bachelor-of-design-in-architecture.html` (sweep) | refuse, variant | = shown | none | 0 |

**Changes since 2 Nov 11:55:**
- 106362D (`f16381f9`) now passes.
- 079094C (`603633e1`) is newly refused.

**Reading the refusals:**
- The three ANU rows are reviewer choices of the newest page the handbook offered (2020 or 2021). The age rule (`binding.handbook_max_age_years`, 2) refuses them.
- 093912A looks like a page-check false positive: the shown page is the combined degree, and the "sibling" is the single Bachelor of Laws.
- 108334C may be a genuine wrong variant (honours page for a pass course code). It needs a person.

**Options:**

| Option | What | Consumer-visible change |
|---|---|---|
| E | Keep the reviewer choice (a person's decision outranks the rule); record each as a page-check exception in a fixture so the rule is tuned (ANU year rule, Bond sibling) | None |
| F | Raise one Layer 4 course-link item each (neutral route, no page rejection), with the page-check reason | None until a reviewer decides |
| G | Contain as E16 Part B (link `unverified` plus page rejection) | **Yes:** 7 courses show no link; 5 have an active fee shown |

**Recommendation:** F for all 7, so a person sees the page-check reason, plus E's fixture cases for the rule. G only with explicit approval.

## 3. New: 13 tranche courses have their superseded link active again

**What happened:**
- 13 of the 101 tranche courses (event #28622) again have two active official links.
- In each one, the link set to `inactive` at 16:xx is `active` again, `updated_at` 2 Nov 23:37 AEDT (sweep source, not primary, created 5 Oct).
- Sample: La Trobe 121337B and 110604A. Each re-activated link is the shown page plus the fragment `#/overview?studentType=int`, an H04 "same page spelled differently" pair.

**Writer:**
- The path is `security.coverage_apply_course_v1` (live md5 `c2cbc9ab616a77487d447991f33daaeb`, the common admission write). Its link upsert does `on conflict (course_id, link_type, url) do update set status = 'active', …`, which re-activates any inactive link at the same address.
- The run in that minute was `exit-awards-apply` (23:37, 94.2 s), the likely caller. The function body lives in the database only; it is not in git.

**Consumer effect:** none so far. The projection still shows the primary kept link. But the tranche's clean-up is being undone for H04 pairs, and the courses re-enter the duplicate cohort (2 in half A, 11 in half B).

**Proposal (engineering, not built):** the admission write should not re-activate a link that housekeeping or a person set inactive (same address after normalisation, or a recorded supersession). Until then, a repeat of the tranche on these 13 would be undone at the next admission. This is a candidate integration-queue issue (P2, A2/A4, root cause `code_defect`).

## 4. Also seen

- Job `search-refresh-requested` hit its statement time-out (120 s) at 2 Nov 23:36. The context was `security.course_page_check_v1` inside the projection refresh.
- This is a scheduler run with zero work and an error. It is a candidate for the integration queue under the 23:24 direction §3, and is not hidden behind a successful status.

## 5. Records

**Read-only queries:**

| Time (AEDT) | Query |
|---|---|
| 23:57 | Held cohort, two halves |
| 00:06 | Re-duplication of the tranche courses |
| 00:06 | Writer lookup |
| 00:16 | Function bodies |
| 00:17 | Page checks, 41 + 52 |
| 00:26 | The 7 (plus 1) courses |

**Window rules:** no query ran in :35–:42 or at the admission minutes (:x3, :x5, :x9).

**Production writes:** none.
