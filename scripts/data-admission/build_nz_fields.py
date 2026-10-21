#!/usr/bin/env python3
"""Daily New Zealand field report per provider (CF-247, Platform Admin 21 Oct 2026: "Prepare the nz data per uni including all fields
before and at present" and "Produce it daily please").

Input: a file holding the JSON object returned by the query in docs/data-admission/NZ-FIELDS-README.md (it may be wrapped in other text,
for example a saved tool result; the object is found by its "rows" key). It reads pipeline.provider_field_daily (StudySearch Pilot,
read-only): today, the previous day and the start of 21 Oct 2026.
Output: docs/data-admission/nz-fields/NZ-course-data-<date>.xlsx with sheets Read me, NZ summary, Per provider, Long list.
Usage: python3 scripts/data-admission/build_nz_fields.py result.txt
"""
import html, json, os, re, sys
from openpyxl import Workbook
from openpyxl.styles import Alignment, Border, Font, PatternFill, Side
from openpyxl.utils import get_column_letter as L

ROOT = os.path.join(os.path.dirname(__file__), '..', '..', 'docs', 'data-admission', 'nz-fields')
CF = [('official_url', 'Official course page'), ('level', 'Study level'), ('field_of_study', 'Field of study'), ('duration', 'Duration'),
      ('delivery', 'Delivery mode'), ('campus', 'Campus linked'), ('campus_city', 'Campus city'), ('international', 'Open to international students'),
      ('provider_tuition', 'Tuition fee'), ('intakes', 'Intakes / start dates'), ('deadline', 'Application deadline'), ('english', 'English requirements'),
      ('academic_entry', 'Academic entry requirements'), ('description', 'Course description')]
PF = [('p_website', 'Website'), ('p_address', 'Street address'), ('p_campuses', 'Campuses'), ('p_type', 'Institution type'),
      ('p_international', 'Enrols international students'), ('p_logo', 'Logo'), ('p_contact', 'Phone or email'), ('p_scholarships', 'Scholarships'),
      ('p_description', 'Description')]
F = Font(name='Arial', size=10); FB = Font(name='Arial', size=10, bold=True); FH = Font(name='Arial', size=10, bold=True, color='FFFFFF')
HF = PatternFill('solid', fgColor='1F3A5F'); SF = PatternFill('solid', fgColor='DCE6F1')
thin = Side(style='thin', color='BFBFBF'); B = Border(left=thin, right=thin, top=thin, bottom=thin)
C = Alignment(horizontal='center', vertical='center', wrap_text=True); MID = Alignment(horizontal='center')


def find(obj, depth=0):
    """Find the report object: a dict with "today" and "rows", possibly JSON-encoded inside strings several times."""
    if depth > 6: return None
    if isinstance(obj, dict):
        if 'rows' in obj and 'today' in obj: return obj
        for v in obj.values():
            f = find(v, depth + 1)
            if f: return f
    elif isinstance(obj, list):
        for v in obj:
            f = find(v, depth + 1)
            if f: return f
    elif isinstance(obj, str):
        dec = json.JSONDecoder()
        for m in re.finditer(r'[\[{]', obj):
            try:
                v, _ = dec.raw_decode(obj[m.start():])
            except ValueError:
                continue
            f = find(v, depth + 1)
            if f: return f
    return None


def load(path):
    d = find(open(path, encoding='utf-8').read())
    if not d: sys.exit('could not find the report object (with "today" and "rows") in ' + path)
    return d


def n(d, k):
    return int((d or {}).get(k) or 0)


def yes(d, k):
    return 'Yes' if (d or {}).get(k) in (True, 'true') else 'No'


def hdr(ws, row, last):
    for c in range(1, last + 1):
        x = ws.cell(row, c); x.font = FH; x.fill = HF; x.alignment = C; x.border = B


def main():
    d = load(sys.argv[1])
    today, prev, base = d['today'], d.get('previous') or '', d.get('baseline') or '2026-10-20'
    rows = sorted(d['rows'], key=lambda r: (-int(r.get('courses') or 0), html.unescape(r.get('name') or '').lower()))
    os.makedirs(ROOT, exist_ok=True)
    out = os.path.join(ROOT, f'NZ-course-data-{today}.xlsx')
    wb = Workbook()

    r = wb.active; r.title = 'Read me'
    notes = [(f'New Zealand course data by provider: {today}', FB), ('', F),
             (f'Start: values held at the start of 21 Oct 2026, before the NZ enrichment run ({base}; worked out from what was filled that day).', F),
             (f'Previous: the day before ({prev or "none yet"}). Today: {today}. Each day is recorded at about 6:55 am Melbourne time.', F),
             (f'Scope: {len(rows)} NZ providers with active courses, {sum(int(x.get("courses") or 0) for x in rows):,} active courses.', F), ('', F),
             ('Sheets', FB),
             ('NZ summary: each field across New Zealand at the start, the previous day and today, with the changes and % filled.', F),
             ('Per provider: one row per provider; for each course field, the number of courses holding it at the start, the previous day and today, the change today and the change since the start. Provider fields show Yes or No.', F),
             ('Long list: the same figures as one row per provider and field, for filtering and pivot tables.', F), ('', F),
             ('Notes', FB),
             ('Application deadline, academic entry requirements and course description have no reader yet.', F),
             ('Six provider records are named "New Zealand Institute of Skills and Technology"; the website column tells them apart.', F),
             ('A provider with no figure for a day had no active courses recorded that day.', F)]
    for i, (t, f) in enumerate(notes, 1):
        c = r.cell(i, 1, t); c.font = f; c.alignment = Alignment(wrap_text=True, vertical='top')
    r.column_dimensions['A'].width = 120

    ws = wb.create_sheet('Per provider')
    for j, h in enumerate(['Provider', 'Website', 'Courses'], 1):
        ws.cell(1, j, h); ws.merge_cells(start_row=1, start_column=j, end_row=2, end_column=j)
    col, cfcol = 4, {}
    for key, lab in CF:
        ws.cell(1, col, lab); ws.merge_cells(start_row=1, start_column=col, end_row=1, end_column=col + 4)
        for k, s in enumerate(['Start', 'Previous', 'Today', 'Change today', 'Change since start']): ws.cell(2, col + k, s)
        cfcol[key] = col; col += 5
    pcol = col
    for i, (key, lab) in enumerate(PF):
        c = pcol + 3 * i; ws.cell(1, c, lab); ws.merge_cells(start_row=1, start_column=c, end_row=1, end_column=c + 2)
        for k, s in enumerate(['Start', 'Previous', 'Today']): ws.cell(2, c + k, s)
    last = pcol + 3 * len(PF) - 1
    hdr(ws, 1, last); hdr(ws, 2, last)
    for i, x in enumerate(rows, 3):
        ws.cell(i, 1, html.unescape(x.get('name') or '')); ws.cell(i, 2, x.get('website') or '—'); ws.cell(i, 3, int(x.get('courses') or 0))
        for key, _ in CF:
            c = cfcol[key]
            ws.cell(i, c, n(x.get('b'), key)); ws.cell(i, c + 1, n(x.get('y'), key)); ws.cell(i, c + 2, n(x.get('t'), key))
            ws.cell(i, c + 3, f'={L(c + 2)}{i}-{L(c + 1)}{i}'); ws.cell(i, c + 4, f'={L(c + 2)}{i}-{L(c)}{i}')
            ws.cell(i, c + 2).fill = SF
            for k in (3, 4): ws.cell(i, c + k).number_format = '+0;-0;-'
        for k, (key, _) in enumerate(PF):
            c = pcol + 3 * k
            ws.cell(i, c, yes(x.get('bp'), key)); ws.cell(i, c + 1, yes(x.get('yp'), key)); ws.cell(i, c + 2, yes(x.get('tp'), key))
        for c in range(1, last + 1):
            ws.cell(i, c).font = F; ws.cell(i, c).border = B
            if c >= 3: ws.cell(i, c).alignment = MID
    nrow = len(rows) + 2
    ws.column_dimensions['A'].width = 48; ws.column_dimensions['B'].width = 30; ws.column_dimensions['C'].width = 9
    for c in range(4, last + 1): ws.column_dimensions[L(c)].width = 10
    ws.row_dimensions[1].height = 42
    ws.freeze_panes = 'A3'  # rows only: frozen columns hide the provider name in some phone viewers
    ws.auto_filter.ref = f'A2:{L(last)}{nrow}'

    sm = wb.create_sheet('NZ summary', 1)
    h = ['Field', 'Level', 'Total', 'Start', 'Previous', 'Today', 'Change today', 'Change since start', '% start', '% today']
    for j, t in enumerate(h, 1): sm.cell(1, j, t)
    hdr(sm, 1, len(h))
    i = 2
    rng = lambda c: f"'Per provider'!{L(c)}3:{L(c)}{nrow}"
    for key, lab in CF:
        c = cfcol[key]
        sm.append([lab, 'Course', f"=SUM({rng(3)})", f'=SUM({rng(c)})', f'=SUM({rng(c + 1)})', f'=SUM({rng(c + 2)})',
                   f'=F{i}-E{i}', f'=F{i}-D{i}', f'=IF(C{i}=0,0,D{i}/C{i})', f'=IF(C{i}=0,0,F{i}/C{i})']); i += 1
    for k, (key, lab) in enumerate(PF):
        c = pcol + 3 * k
        sm.append([lab, 'Provider', f"=COUNTA({rng(1)})", f'=COUNTIF({rng(c)},"Yes")', f'=COUNTIF({rng(c + 1)},"Yes")', f'=COUNTIF({rng(c + 2)},"Yes")',
                   f'=F{i}-E{i}', f'=F{i}-D{i}', f'=IF(C{i}=0,0,D{i}/C{i})', f'=IF(C{i}=0,0,F{i}/C{i})']); i += 1
    for rr in range(2, i):
        for c in range(1, len(h) + 1):
            x = sm.cell(rr, c); x.font = F; x.border = B
            if c >= 3: x.alignment = MID
        for c in (3, 4, 5, 6): sm.cell(rr, c).number_format = '#,##0'
        for c in (7, 8): sm.cell(rr, c).number_format = '+#,##0;-#,##0;-'
        for c in (9, 10): sm.cell(rr, c).number_format = '0.0%'
        sm.cell(rr, 6).fill = SF
    sm.cell(i + 1, 1, 'Course fields count courses; provider fields count providers. Figures come from the Per provider sheet.').font = Font(name='Arial', size=9, italic=True)
    sm.column_dimensions['A'].width = 32
    for c in 'BCDEFGHIJ': sm.column_dimensions[c].width = 13
    sm.freeze_panes = 'A2'

    lg = wb.create_sheet('Long list')
    lg.append(['Provider', 'Website', 'Courses', 'Level', 'Field', 'Start', 'Previous', 'Today', 'Change today', 'Change since start'])
    hdr(lg, 1, 10)
    i = 2
    for x in rows:
        name = html.unescape(x.get('name') or ''); web = x.get('website') or '—'; cs = int(x.get('courses') or 0)
        for key, lab in CF:
            lg.append([name, web, cs, 'Course', lab, n(x.get('b'), key), n(x.get('y'), key), n(x.get('t'), key), f'=H{i}-G{i}', f'=H{i}-F{i}']); i += 1
        for key, lab in PF:
            v = lambda dd: 1 if (dd or {}).get(key) in (True, 'true') else 0
            lg.append([name, web, cs, 'Provider (1 = held)', lab, v(x.get('bp')), v(x.get('yp')), v(x.get('tp')), f'=H{i}-G{i}', f'=H{i}-F{i}']); i += 1
    for row in lg.iter_rows(min_row=2):
        for x in row: x.font = F
    for c, w in (('A', 48), ('B', 30), ('D', 18), ('E', 30)): lg.column_dimensions[c].width = w
    lg.freeze_panes = 'A2'; lg.auto_filter.ref = f'A1:J{i - 1}'
    wb.save(out)

    # three-line summary for the run's report
    tot = lambda dk, key: sum(n(x.get(dk), key) for x in rows)
    moved = [(lab, tot('t', k) - tot('y', k), tot('t', k) - tot('b', k)) for k, lab in CF]
    print(out)
    print('Change today: ' + (', '.join(f'{lab} {a:+,}' for lab, a, _ in moved if a) or 'none'))
    print('Change since 21 Oct: ' + (', '.join(f'{lab} {b:+,}' for lab, _, b in moved if b) or 'none'))


if __name__ == '__main__':
    main()
