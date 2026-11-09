#!/usr/bin/env python3
"""Build the per-university data admission running sheet (CF-247, Platform Admin 20 Oct 2026).

Input: the JSON array returned by security.admission_sheet_v1() (StudySearch Pilot, read-only).
Output (in docs/data-admission/):
  RUNNING-SHEET.md          summary, change since the previous day, what needs a person, every university
  daily/YYYY-MM-DD.csv      the full sheet for that day (kept; the change is worked out against the previous file)
Usage: python3 scripts/data-admission/build_sheet.py sheet.json [YYYY-MM-DD]
"""
import csv, datetime as dt, json, os, sys
from collections import Counter

ROOT = os.path.join(os.path.dirname(__file__), '..', '..', 'docs', 'data-admission')
FIELDS = ['country', 'name', 'courses', 'stage', 'wave', 'admitted_fields', 'with_page', 'with_intakes', 'with_english', 'with_fee',
          'with_scholarship', 'scholarships_published', 'held_scholarship_pages', 'layer4_items', 'flags', 'onboarding', 'next', 'website', 'provider_id']
STAGE = {'admitting': 'Admitting (adapter on, fields admitted)', 'adapter_testing': 'Adapter built, not admitting yet', 'building': 'Onboarding running',
         'cricos_only': 'CRICOS data only (1-4 courses)', 'stopped_too_few_pages': 'Stopped: too few course pages', 'stopped_no_website': 'Stopped: no website',
         'stopped_nothing_ready': 'Stopped: adapter has nothing ready', 'no_adapter': 'No adapter yet'}

def cell(v):
    if isinstance(v, list): return ', '.join(map(str, v))
    return '' if v is None else str(v)

def pct(a, b): return f'{(100 * a / b):.1f}%' if b else '—'

def main():
    rows = json.load(open(sys.argv[1]))
    day = sys.argv[2] if len(sys.argv) > 2 else dt.date.today().isoformat()
    os.makedirs(os.path.join(ROOT, 'daily'), exist_ok=True)
    out_csv = os.path.join(ROOT, 'daily', f'{day}.csv')
    prev = sorted(f for f in os.listdir(os.path.join(ROOT, 'daily')) if f.endswith('.csv') and f < f'{day}.csv')
    before = {}
    if prev:
        with open(os.path.join(ROOT, 'daily', prev[-1])) as fh:
            before = {r['provider_id']: r for r in csv.DictReader(fh)}
    with open(out_csv, 'w', newline='') as fh:
        w = csv.writer(fh); w.writerow(FIELDS)
        for r in rows: w.writerow([cell(r.get(k)) for k in FIELDS])

    courses = sum(r['courses'] for r in rows)
    tot = {k: sum(r.get(k) or 0 for r in rows) for k in ['with_page', 'with_intakes', 'with_english', 'with_fee', 'with_scholarship', 'scholarships_published', 'held_scholarship_pages', 'layer4_items']}
    by_stage = Counter(r['stage'] for r in rows)
    st_courses = Counter(); [st_courses.update({r['stage']: r['courses']}) for r in rows]
    by_country = Counter(r['country'] for r in rows)

    changes = []
    if before:
        for r in rows:
            b = before.get(r['provider_id'])
            if not b: changes.append((r, 'new university', '')); continue
            moved = []
            if b['stage'] != r['stage']: moved.append(f"stage {b['stage']} → {r['stage']}")
            for k in ['with_page', 'with_intakes', 'with_english', 'with_fee', 'scholarships_published']:
                d = (r.get(k) or 0) - int(b.get(k) or 0)
                if d: moved.append(f"{k.replace('with_', '').replace('_', ' ')} {d:+d}")
            if moved: changes.append((r, '; '.join(moved), ''))
    people = [r for r in rows if not str(r['next']).startswith(('None', 'Running'))]

    L = []
    L.append('# Data admission running sheet\n')
    L.append(f'**As at:** {day} (generated daily from the StudySearch Pilot database, `security.admission_sheet_v1`). '
             f'**Change control:** CF-CHG-20260915-247. Full sheet: `daily/{day}.csv`.\n')
    L.append('## Summary\n')
    L.append('| Measure | Value |\n|---|---:|')
    L.append(f'| Universities with active courses | {len(rows):,} ({", ".join(f"{c} {n:,}" for c, n in sorted(by_country.items()))}) |')
    L.append(f'| Active courses | {courses:,} |')
    for k, lab in [('with_page', 'Courses with an official page'), ('with_intakes', 'Courses with intakes'), ('with_english', 'Courses with English'),
                   ('with_fee', 'Courses with a page fee'), ('with_scholarship', 'Courses with a scholarship')]:
        L.append(f'| {lab} | {tot[k]:,} ({pct(tot[k], courses)}) |')
    L.append(f'| Scholarships published | {tot["scholarships_published"]:,} |')
    L.append(f'| Waiting for a person | {tot["layer4_items"]:,} Layer 4 items, {tot["held_scholarship_pages"]:,} held scholarship pages |\n')
    L.append('## Universities by stage\n')
    L.append('| Stage | Universities | Courses |\n|---|---:|---:|')
    for s, n in by_stage.most_common(): L.append(f'| {STAGE.get(s, s)} | {n:,} | {st_courses[s]:,} |')
    L.append('')
    L.append(f'## Change since {prev[-1][:-4] if prev else "the first sheet"}\n')
    if not before: L.append('First sheet; changes are listed from the next day.\n')
    elif not changes: L.append('No university changed stage or field counts.\n')
    else:
        L.append('| University | Country | Change |\n|---|---|---|')
        for r, c, _ in sorted(changes, key=lambda x: -x[0]['courses'])[:150]: L.append(f"| {r['name']} | {r['country']} | {c} |")
        if len(changes) > 150: L.append(f'| … | | {len(changes) - 150} more in the CSV |')
        L.append('')
    L.append('## Needs a person (largest first)\n')
    L.append('| University | Country | Courses | Next action |\n|---|---|---:|---|')
    for r in sorted(people, key=lambda x: -x['courses'])[:200]: L.append(f"| {r['name']} | {r['country']} | {r['courses']:,} | {r['next']} |")
    if len(people) > 200: L.append(f'| … | | | {len(people) - 200} more in the CSV |')
    L.append('')
    L.append('## Every university\n')
    L.append('| University | Country | Courses | Stage | Page | Intakes | English | Fee | Scholarships published | Next action |\n|---|---|---:|---|---:|---:|---:|---:|---:|---|')
    for r in rows:
        L.append(f"| {r['name']} | {r['country']} | {r['courses']:,} | {STAGE.get(r['stage'], r['stage'])} | {r['with_page']} | {r['with_intakes']} | {r['with_english']} | {r['with_fee']} | {r['scholarships_published']} | {r['next']} |")
    open(os.path.join(ROOT, 'RUNNING-SHEET.md'), 'w').write('\n'.join(L) + '\n')
    print(f'{len(rows)} universities; {len(changes)} changed; {len(people)} need a person; wrote {out_csv}')

if __name__ == '__main__':
    main()
