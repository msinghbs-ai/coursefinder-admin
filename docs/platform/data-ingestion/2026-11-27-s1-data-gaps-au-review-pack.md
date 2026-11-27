# S1-Data-Gaps: AU evidence-ready review pack and relink exception (27 Nov 2026, 16:30 to 16:48 AEDT)

**Brief:** SS-Programme-Control 16:30 AEDT, "P0 Production data delivery" (all Australian data population chats). **Lane:** S1-Data-Gaps (read-only audits; no writer). **Change made:** none to Pilot, settings, jobs or data. **Spend:** US$0. **No PR to Pilot.**

## 1. Actual canonical data gains from this lane

None. This lane owns no admission writer, and no eligible record could be admitted without a person or the reader. Recorded plainly so it is not read as a gain.

- Relink (s1306, released 13:35; read 16:31): 164 of the 227 requests were taken; Swinburne 133 trying and 28 absent, WSU 20 trying and 7 absent. The reader has not read the bound candidates for three hours (152 searches `found`, 18 candidate pages read, all HTTP 404 or mismatch). Verified rebinds 0; official links changed 0. **Exception recorded:** the known reader blocker (reader plugin recovery); not investigated again. The 41 requests still queued and the 152 found searches stay as they are and move when the reader does.

## 2. What is waiting for a person (rolled-back reads, 16:31 to 16:45 AEDT)

Australian open Layer 4 review items for entry, English requirements and scholarships: 952 `course_entry_first_read` pending (902 AU), 92 `entry_matrix_first_run`, 17 `entry_matrix_change`, 23 `course_english` (22 AU). Of the 902 AU course entry items, 835 are technical blocks (not for a person): 467 `completeness_gate` plus `nothing_to_admit`, 299 `completeness_gate`, 69 `nothing_to_admit` (S2-AER's D-R3 record, 27 Nov 2026 16:40, explains the gate and the smallest freeze exceptions). **66 entry items and 22 English items are `judgement_ready`: a person can decide them today.** Oldest pending item: 29 Oct 2026.

| Group | Items | Provider(s) | Proposed | Recommended decision and basis |
|---|---|---|---|---|
| A | 33 | The University of Newcastle | 1 row each, audience domestic, quote is a scholarship offer ("base ATAR of 95+ ... $5,000 scholarship"), reader `aer_det` / `aer-det-v1.4` | **Reject in Layer 4.** Not an academic entry requirement. Same finding as S2-AER's of 27 Nov (the Newcastle proposed rows are scholarship offers); a rule that detects scholarship wording needs a code change, so the reader cannot reject them itself under the freeze. |
| B | 33 | 20 providers (Adelaide, ACU, ANU, Avondale, CDU, Charlton Brown, Christian Heritage, Curtin, Entrepreneur Education, Flinders, Griffith, Monash, RMIT, SCU, Stott's, Torrens, UNSW College, WIC Sydney and others) | 1 to 8 proposed rows each, each with stored evidence, no scholarship wording | **Review (Platform Admin).** Confirm each row against the stored page in the three-decision card. |
| C | 17 | Pivot Education 8, WSU 2 (central policy), Navitas English 2 and others | English requirement, readers agree | **Review (Curator).** `elr-det-v1.0` 14, `elr-central-v1.0` 2, 1 no reader tag. |
| D | 5 | Inforum, UOW College, Milner and others | English requirement where two or more quotes disagree | **Review (Curator) and resolve the conflict** on the page. |

Item identifiers, provider, course code, rows and recommended action are in `2026-11-27-s1-data-gaps-au-review-pack.csv` (88 rows). In Layer 4 the group A to D items are the ones whose route is `review:platform_admin` or `review:curator` and whose readiness is judgement-ready; filter by provider to take one provider at a time.

## 3. Exceptions recorded (not investigated, moved on)

| Exception | Count | Owner and next step |
|---|---|---|
| Reader plugin not reading relink candidates | 152 found searches, 41 queued requests | S1-Build / S2-Build reader recovery |
| `completeness_gate` (D-R3) stops AU entry items | 766 (467 and 299) | S2-AER freeze exceptions 1 and 2 (their record of 27 Nov) |
| `nothing_to_admit` entry items | 69 plus the 467 above | S2-AER |
| Held `no_route` gone-page requests (wave 2: Sydney 240, Adelaide 215, Alberta 155, Torrens 46, UNSW 29) | not released | Released only when the reader returns verified rebinds |
| Newcastle scholarship-offer rows | 33 here (S2-AER counts 41) | A person rejects them (group A) |

## 4. Website and Creator verification

Nothing was admitted or changed by this lane, so there is nothing new to read back from the website API or Zoho Creator. The group A to D decisions will change the canonical data once a person decides them; the first read-back after that is the AU `entry_resolve_v3` and English requirement response for one decided course per provider.
