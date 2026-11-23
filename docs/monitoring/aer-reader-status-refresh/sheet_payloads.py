#!/usr/bin/env python3
"""sheet_payloads.py <sheet.json> <out-dir> --snapshot "<B3 text>" --stamp "<YYYY-MM-DD HH:MM>"

Turns sheet.json (from build_register.py) into the Google Sheets calls for the Drive sheet AER_University_Reader_Status, so a
run never types a register row by hand. Tab layout: row 1 header, row 2 a merged note (A2:X2), data from row 3.

Writes into <out-dir>:
  upload.csv          the three tab blocks stacked (AU, blank, NZ, blank, CA). Upload it to Drive with create_file as a file
                      reference (base64Content "sha256:<hex>:<path>", contentMimeType text/csv) so it converts to a temporary
                      Google Sheet; copy its first tab into the target with copy_sheet_to_another_spreadsheet.
  plan.json           {"clear": [...ranges], "append_rows": {tab: n}, "blocks": {tab: [header_row_index, data_start_index, rows]},
                      "requests_template": [...]}. In requests_template replace every "@TMP@" with the copied tab's sheetId and
                      every "@<tab>@" with that tab's sheetId, then send it in ONE update_spreadsheet call (copyPaste values,
                      the row 2 note, updated_at_aedt as text, and deleteSheet of the copied tab). Then trash the temporary file.
  90_summary.json     update_values Summary!A11:M15 (column A blank)
  91_kpi_*.json       update_values single cells B3, B6, B7, F6, F7, J6, J7
It prints the sha256 of upload.csv and the rows each tab needs.
"""
import csv, hashlib, json, os, sys

def arg(k):
    return sys.argv[sys.argv.index(k) + 1] if k in sys.argv else None

src, out = sys.argv[1], sys.argv[2]
snap, stamp = arg('--snapshot'), arg('--stamp')
j = json.load(open(src)); os.makedirs(out, exist_ok=True)
for f in os.listdir(out):
    if f.endswith('.json') or f == 'upload.csv': os.remove(os.path.join(out, f))
tabs = j['tabs']; width = max(len(r) for t in tabs.values() for r in t)
notes = {
    'AU_Universities': 'Australia: universities, university colleges and higher-education institutes ({n}).',
    'NZ_Universities': 'New Zealand: universities, wananga and polytechnics ({n}).',
    'CA_Universities': 'Canada: every provider with active courses ({n}; provider type not held).',
}
rows, blocks = [], {}
for t, r in tabs.items():
    r = [[('' if v is None else str(v)) for v in x] + [''] * (width - len(x)) for x in r]
    blocks[t] = [len(rows), len(rows) + 1, len(r) - 1]
    rows += r; rows.append([''] * width)
with open(f'{out}/upload.csv', 'w', newline='') as fh:
    csv.writer(fh, lineterminator='\n').writerows(rows)
xcol = tabs['AU_Universities'][0].index('updated_at_aedt')
req = []
for t, (h, d, n) in blocks.items():
    tid = f'@{t}@'
    req.append({'copyPaste': {'source': {'sheetId': '@TMP@', 'startRowIndex': h, 'endRowIndex': h + 1, 'startColumnIndex': 0, 'endColumnIndex': width},
                              'destination': {'sheetId': tid, 'startRowIndex': 0, 'endRowIndex': 1, 'startColumnIndex': 0, 'endColumnIndex': width}, 'pasteType': 'PASTE_VALUES'}})
    req.append({'copyPaste': {'source': {'sheetId': '@TMP@', 'startRowIndex': d, 'endRowIndex': d + n, 'startColumnIndex': 0, 'endColumnIndex': width},
                              'destination': {'sheetId': tid, 'startRowIndex': 2, 'endRowIndex': 2 + n, 'startColumnIndex': 0, 'endColumnIndex': width}, 'pasteType': 'PASTE_VALUES'}})
    req.append({'repeatCell': {'range': {'sheetId': tid, 'startRowIndex': 2, 'endRowIndex': 2 + n, 'startColumnIndex': xcol, 'endColumnIndex': xcol + 1},
                               'cell': {'userEnteredValue': {'stringValue': stamp or ''}}, 'fields': 'userEnteredValue'}})
    note = notes[t].format(n=n) + f' Snapshot {stamp} AEDT; refreshed daily at 08:00 AEDT. Canonical copy: docs/monitoring/AER_University_Reader_Status.csv (admin repository).'
    req.append({'repeatCell': {'range': {'sheetId': tid, 'startRowIndex': 1, 'endRowIndex': 2, 'startColumnIndex': 0, 'endColumnIndex': 1},
                               'cell': {'userEnteredValue': {'stringValue': note}}, 'fields': 'userEnteredValue'}})
req.append({'deleteSheet': {'sheetId': '@TMP@'}})
plan = {'clear': [f'{t}!A1:AB2000' for t in tabs], 'append_rows': {t: n + 2 for t, (_, _, n) in blocks.items()},
        'blocks': blocks, 'requests_template': req}
json.dump(plan, open(f'{out}/plan.json', 'w'), indent=1)
sr = [[('' if v is None else str(v)) for v in r] + [''] * (13 - len(r)) for r in j['summary_rows']]
json.dump({'range': f'Summary!A11:M{10 + len(sr)}', 'values': sr}, open(f'{out}/90_summary.json', 'w'))
k = j['kpi']
pct = lambda a, b: f'{(100.0 * a / b):.1f}%' if b else '0.0%'
d = k.get('delta'); dtxt = 'n/a (no previous snapshot)' if d is None else (f'+{d:,}' if d >= 0 else f'{d:,}')
cells = {
    'B6': f"{k['sources_yes']:,} / {k['providers']:,} providers with a registered source",
    'B7': f"Fully Working: {k['fw']}  |  Stuck in L4: {k['stuck']}  |  Site Blocked: {k['blocked']}",
    'F6': f"{k['admitted']:,} ({pct(k['admitted'], k['active'])})",
    'F7': f"Active courses: {k['active']:,}  |  Change since previous snapshot: {dtxt}",
    'J6': f"{k['held'] + k['pending']:,} in Layer 4 (held and pending)",
    'J7': f"L4 held: {k['held']:,}  |  L4 pending: {k['pending']:,}  |  s1000 fallback courses: {k['fallback']:,}",
}
if snap: cells['B3'] = snap
for i, (c, v) in enumerate(sorted(cells.items())):
    json.dump({'range': f'Summary!{c}', 'values': [[v]]}, open(f'{out}/91_kpi_{i}_{c}.json', 'w'))
print('upload.csv sha256', hashlib.sha256(open(f'{out}/upload.csv', 'rb').read()).hexdigest(), os.path.abspath(f'{out}/upload.csv'))
for t, (_, _, n) in blocks.items(): print(f'{t}: {n} data rows (grid needs at least {n + 2} rows)')
