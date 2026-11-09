# CF-247 — Layer 4 AER queue investigation and governed settlement playbook
**Date:** 2 November 2026 AEDT. **Status:** live read-only review and recommended decision rules; no admissions, re-reads or production writes performed.
**Sources:** current signed-in Layer 4 UI v2.15.406; live Supabase `fxcwkweaxjtknorudmwp` review/source/canonical tables; `AGENT-OPERATING-MODEL.md`, `AER-OPERATIONS-WORKSPACE-DECISION-2026-10-29.md`, `ENTRY-REQUIREMENTS-STEP-B-DECISION-2026-10-28.md`, `2026-11-02-morning-execution-mandate-and-decisions.md`, AER design Draft 1.2 and its gap/continuous assurance mandates.

## 1. Measured review queue
Live pending: **539 AER** (`course_entry_first_read` **499**, `entry_matrix_first_run` **40**). The web UI showed the same 539 of 1,545 overall pending; status is point-in-time. Course pending by provider: RMIT 298; Monash 66; AUT 46; QUT 38; VUW 12; MIT 10; EIT 10; Auckland 10; Lincoln 4; Ara 2; Toi Ohomai, Otago, NMIT 1 each. Provider review pending: ANU 22; Melbourne 2; 16 other individual-provider reviews including UWA, Adelaide, Curtin, Griffith, Newcastle and VUW.

Historical/decided AER: course reviews 497 approved, 1 edited-approved; provider first-run 31 approved, 6 edited-approved, 2 rejected, 40 superseded. Do not confuse this with the *current* set of active rows; previously approved rows may subsequently have been withdrawn, including E14.

## 2. Incomplete course-read evidence in pending reviews
Of 499 pending course reviews, 353 contain a nonempty JSON `proposed_value.dropped`; 146 have no recorded drop. Across all pending there are **5,209 dropped candidate rows**, with breakdown:
- `over_row_limit`: 2,842 rows affecting 162 reviews.
- `score_without_basis`: 1,731 rows affecting 258 reviews.
- `quote_not_on_page`: 622 rows affecting 224 reviews.
- `english_duplicate`: 8 rows affecting 7 reviews.
- `low_confidence`: 6 rows affecting 6 reviews.

Review counts overlap. A dropped row is a diagnostic, **not automatically an omitted valid academic requirement** (English-test duplicates may be appropriately excluded). However, an `over_row_limit` drop is a high-risk completeness gate until the complete source section has been reconciled. `score_without_basis` and `quote_not_on_page` demand classification: true reader error, unsupported score or unrelated content; cannot safely infer a minimum.

Per-provider risk among pending course items (counts overlap):
| Provider | Pending | Row cap | Score basis | Quote mismatch | None of three |
|---|---:|---:|---:|---:|---:|
| RMIT | 298 | 94 | 171 | 114 | 74 |
| Monash | 66 | 15 | 28 | 34 | 23 |
| AUT | 46 | 3 | 11 | 18 | 23 |
| QUT | 38 | 38 | 38 | 38 | 0 |
| VUW | 12 | 0 | 0 | 2 | 10 |
| MIT | 10 | 5 | 3 | 5 | 4 |
| EIT | 10 | 2 | 0 | 5 | 5 |
| University of Auckland | 10 | 4 | 7 | 7 | 0 |
| Lincoln | 4 | 0 | 0 | 0 | 4 |
| Ara | 2 | 1 | 0 | 1 | 1 |
| Toi Ohomai/Otago/NMIT | 1 each | 0 | 0 | 0 | 1 each |

**Key examples:** QUT Bachelor of Behavioural Science (Honours Psychology) pending `c5165aaa-c4cf-462e-a669-5032d318ce2f`: six proposed rows, multiple over-cap and quote/basis drops, some apparently English/progression content; verify exact course/programme identity and completeness before disposition. UWA provider run pending `a0595bd2-740a-48fd-bb88-596749e6727c`: 177 proposed, eight dropped; 236 non-active matrix rows in snapshot and no active; reconcile duplicates, scope/qualification/country, printed ATAR/points basis, edition and whole-read fidelity. ANU has 22 separate qualification source runs (most 0 dropped); do not assume 22 approvals are equivalent to 22 provider-wide policies.

## 3. Admission decision tree (every review)
Before a decision, refresh the live queue; ensure still pending, source and stored evidence current, no newer read/Layer 4 decision and provider/course identity matches.
1. **Provider matrix first-run:** validate official source, publisher and edition, stored copy, full table/section manifest, qualification identity, country/global scope, study level, each row's quote, grade scale and minimum; compare published versus proposed and dropped; check active duplication/supersession and source ownership. If fully evidenced, person may approve the entire run in current UI. If some rows are unsupported or wrong, use the allowed **edited approval only if the UI safely expresses exact exclusions and remaining whole-run completeness**; otherwise return/hold for reader/source correction. A reader `done` or `source.status='read'` is not enough. Zero-row source note may be approved only when stored rendered page truly contains no applicable table and the documented `no matrix published` outcome is correct; never call an inaccessible or unparsed page `no table`.
2. **Course first-read:** require strong course identity (CRICOS/approved adapter/manual proof), exact official stored course page, quote-on-page, academic versus English separation, correct domestic/international/all audience, printed grade basis, correct programme/variant, no missed academic requirements, no over-cap loss. Review all `dropped` reasons; `score_without_basis` cannot be "repaired" by guessing. The six-row cap (E13) requires completeness guard and validation before admission. Admit only the supported entirety through the existing UI and per-item actions, not bulk.
3. **RMIT 298 pending:** comply with E11: do not bulk-reject or blindly approve. Investigate stored-copy completeness, especially global IB/GAC and provider band mapping; one authorised bounded pilot only after separately recorded cost ceiling. An approved course requirement cannot infer a 65%-band from an ATAR unless the course prints the band; protect E14 withdrawn items from reintroduction.
4. **QUT 38 pending:** comply with E12: existing international content, 5-course pilot conditional on recorded ceiling; do not admit domestic ATAR/guaranteed offers as international, lose alternatives to cap, or approve existing held items automatically.
5. **UWA:** one provider review, 177 proposed and eight dropped in sample; reconcile source manifest, repeated rows/editions and proposed vs non-active statuses. Do not convert review to blanket approval.
6. **Rows without drops:** promote to a *review-ready shortlist* only after independent checks of identity, evidence, completeness and applicability; 146 absence-of-drop items are **not auto-pass**.
7. **Provider reviewed before course:** prioritise verified high-leverage source runs, but provider approval may not substitute for missing programme-specific prerequisites; record what the consumer resolver can and cannot answer.

Allowed decision route: authenticated StudySearch Layer 4 only, per applicable role/playbook, with audit reason and saved-result verification. Never direct SQL approval, bulk AER admission or migration that unilaterally toggles statuses; 2 Nov D-B1 explicitly excludes AER from provider bulk approval.

### Dispositions
- **Approve**: verified complete source with correct identity, grade/basis, scope and no unresolved material drops; verify active destination and consumer resolver.
- **Edited approval**: only if exact erroneous rows can be excluded/corrected in the authorised UI and all valid published minima remain represented; source quote/provenance immutable.
- **Return / request more evidence**: incomplete read, over-cap, uncertain foreign/global qualification applicability, stale/incorrect source, wrong programme variant, pending newer evidence, invalid identity or conflicting active rows. Preserve evidence and link the root-cause gap in AER continuous assurance.
- **Reject**: provably wrong source/provider/course identity, duplicate superseded read, unrelated content or invalid entire run, with explicit evidence. Do not reject just to remove backlog.
- **No published matrix note**: requires a verified rendered copy and explicit absence; source error ≠ no published requirements.

## 4. Engineering, queuing and verification
Classify all live pending items by root-cause risk before starting decisions. Group issues such as six-row truncation/foreign qualification parser failure across providers; repair once and re-evaluate current stored copies through approved routes. Respect no new paid reads, no change to hold status or unbounded processing without documented authority. E13 has approval for *building* whole-read completeness gate, but no unrestricted re-reads or global cap increase; test its **deployed** status rather than assuming it is live.

Create per-item dry-run evidence manifest: review ID, provider/course IDs, stored evidence/hash, source URL, current status, proposed/dropped count, all guard results, eligible decision and reason. Counsellor-facing checks: consumer retains only active evidence-supported rows; no fabricated ATAR/qualification inference.

Operational priority: (a) closed-loop triage of material reader defects; (b) evidence-complete provider runs with high impact, ANU per-qualification checks; (c) ready course cases, by provider and current source; (d) RMIT E11 and QUT E12 pilot only under ceilings; (e) incomplete reads after correction. Do not sacrifice coverage accuracy for item counts.

For every saved decision, recheck pending before write, submit single action through governed UI, confirm persisted decision and destination row versions, reconcile consumer output, and record audit reference. If UI changed from v2.15.406, re-verify current controls before writes. Show progress: reviewed, approved, edited, rejected, returned, blocked, active rows, consumer-resolvable course deltas, gaps fixed, no invalid cross-course admission. Distinguish reviews settled from material coverage actually gained. Checkpoint every ten decisions (or twenty reviews with none) and kind transition.

## 5. Claude handover
Claude/main integrator handles reader fixes, evidence manifests, risk grouping, completeness guards, migration/tests, coverage reporting and only actions expressly authorised by role/mandate. Human Layer 4 decisions remain separate from code and cannot be replaced with an AI-origin SQL batch. Claude may prepare an **evidence-backed action recommendation per item**, and may process a UI decision only when the existing playbook, actor's authorisation and current explicit mandate permit it. Coordinate with the dedicated Layer 4 reviewer to avoid concurrent duplicate decisions.

**Not performed:** no admissions or re-reads, no deployed code changes, no post-decision consumer check. Snapshot figures can drift; recompute first.
