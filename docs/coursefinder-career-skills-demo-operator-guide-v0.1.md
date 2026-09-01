# CourseFinder Career & Skills — Demo, Operator and Reading Guide v0.1

**Status:** M2.5 DESIGN GUIDE — IMPLEMENTATION PENDING  
**Date:** 1 September 2026  
**Change Control:** `CF-CHG-20260901-062`

## What the user is looking at

The Career & Skills section deliberately combines several related but different datasets.

**Skills you'll develop** means CourseFinder found evidence in the Course/provider curriculum, learning outcomes, graduate attributes, accreditation or another governed education source.

**Potential career pathways** means there is an evidence-backed relationship between the Course and an occupation. It is not a promise of employment.

**Current market** is a time-scoped official labour-market observation. Vacancy activity is a demand proxy, not the number of jobs guaranteed to a graduate.

**Registration** tells the user whether an occupation has professional/licensing conditions.

**Migration** is a current policy signal only. It is never a visa-eligibility decision.

## How to read provenance

Every skill/pathway/market item should expose:
- Source
- Evidence or public source link
- Country
- Classification + version
- Reporting/effective period
- Last verified
- Relationship basis
- Confidence/review state where admin-only

Admin users should reject or hold an item when these cannot be explained.

## Operator workflow

1. Open Course.
2. Open Career & Skills.
3. Check whether the Course has first-party learning-outcome Evidence.
4. Inspect skills and open provenance for questionable mappings.
5. Review occupation relationship basis.
6. Check current market geography/period/classification.
7. Review registration and migration separately.
8. Use Layer 4 Review for a low-confidence/conflicting mapping.
9. Publish only accepted mappings under the governed publication boundary.

## How to demonstrate it

### 5-minute demo

1. Open a Course with learning outcomes.
2. Point to one provider learning outcome.
3. Show the corresponding normalised skill badge.
4. Open a career pathway and show why it is related.
5. Show the official market observation with reporting month/year and geography.
6. Show registration/migration in separate cards.
7. State that Course skill evidence, labour demand and migration eligibility are not the same claim.
8. Open Compare and contrast common/differentiating skills and occupations across two Courses.

### Admin demo

Show:
- Evidence lineage;
- mapping relationship type;
- confidence/review state;
- Layer 4 accept/reject/edit note;
- immutable underlying source;
- fresh market observation;
- stale/unavailable state;
- classification concordance where a JSA metric is ANZSCO while CourseFinder canonical occupation identity is OSCA.

## Recommended demo wording

“CourseFinder starts with what the institution says the student will learn, normalises that into a governed skills vocabulary, links those skills and provider career statements to official occupations, and then adds current official labour-market context. It keeps employment demand, professional registration and migration policy separate so the student can see the evidence behind each statement.”

## What not to say

Do not say:
- “This Course guarantees these jobs.”
- “These are the skills every graduate will definitely have.”
- “High vacancies mean you will get a job.”
- “This Course makes you eligible for a visa.”
- “Green List means automatic residency.”
- “QILT employment rate is the employment rate for this exact Course” unless source grain explicitly supports that.

## Comparison reading rules

Only compare:
- market metrics with clearly disclosed geography/period;
- skills under the same taxonomy/version or a governed concordance;
- QILT at its true reporting grain;
- migration policies as current policy flags, not ranking scores.

Where data is not comparable, show “Different period”, “Different geography”, “Not mapped” or “Unavailable”; do not force a score.

## Troubleshooting

**No skills shown:** check L2 Course learning outcomes/Evidence before Layer 3.

**Occupation exists but no market metric:** check classification/version concordance and source release coverage.

**JSA record is ANZSCO but occupation is OSCA:** this can be valid during transition; inspect the explicit correspondence link.

**Migration card stale:** hold from consumer display or mark stale until the policy source is revalidated.

**AI suggested a surprising job:** do not publish automatically; inspect evidence, confidence and send to Layer 4 review.

## Demo acceptance checklist

- [ ] AU source lineage demonstrated
- [ ] NZ source lineage demonstrated
- [ ] one Course-acquired skill proven from first-party Evidence
- [ ] one occupation relationship basis explained
- [ ] market period/geography visible
- [ ] OSCA/NOL/native-code handling visible
- [ ] registration/migration separated
- [ ] Layer 4 review shown
- [ ] Compare view shown
- [ ] disclaimer/unavailable state shown
