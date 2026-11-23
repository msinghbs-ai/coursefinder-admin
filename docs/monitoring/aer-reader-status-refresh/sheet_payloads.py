#!/usr/bin/env python3
"""sheet_payloads.py <sheet.json> <out-dir> [--snapshot "<text>"]

Turns sheet.json (from build_register.py) into the exact Google Sheets writes for the Drive sheet
AER_University_Reader_Status, so a run never retypes a number. Writes one JSON file per call into <out-dir>:
  00_clear.json      {"ranges": [...]}                       -> batch_clear_values
  NN_<tab>_<k>.json  {"range": "...", "values": [[...]]}     -> update_values (chunks of 100 rows or fewer)
  90_summary.json    {"range": "Summary!A11:M15", ...}
  91_kpi_*.json      single cells B3, B6, B7, F6, F7, J6, J7
and prints the grid rows each tab needs (rows written + 1 header) so the caller can add rows first.
"""
import json, os, sys

def col(n):
    s = ''
    while n:
        n, r = divmod(n - 1, 26); s = chr(65 + r) + s
    return s

src, out = sys.argv[1], sys.argv[2]
snap = sys.argv[sys.argv.index('--snapshot') + 1] if '--snapshot' in sys.argv else None
j = json.load(open(src)); os.makedirs(out, exist_ok=True)
for f in os.listdir(out):
    if f.endswith('.json'): os.remove(os.path.join(out, f))
tabs = j['tabs']; width = max(len(r) for t in tabs.values() for r in t)
clear = [f"{t}!A1:{col(max(width, 28))}2000" for t in tabs]
json.dump({'ranges': clear}, open(f'{out}/00_clear.json', 'w'))
n = 1
for t, rows in tabs.items():
    rows = [[('' if v is None else str(v)) for v in r] + [''] * (width - len(r)) for r in rows]
    for k in range(0, len(rows), 100):
        part = rows[k:k + 100]
        rng = f"{t}!A{k + 1}:{col(width)}{k + len(part)}"
        json.dump({'range': rng, 'values': part}, open(f'{out}/{n:02d}_{t}_{k // 100}.json', 'w')); n += 1
    print(f"{t}: {len(rows)} rows incl. header (grid needs at least {len(rows) + 2})")
sr = [[('' if v is None else str(v)) for v in r] + [''] * (13 - len(r)) for r in j['summary_rows']]
json.dump({'range': f"Summary!A11:M{10 + len(sr)}", 'values': sr}, open(f'{out}/90_summary.json', 'w'))
k = j['kpi']
pct = lambda a, b: f"{(100.0 * a / b):.1f}%" if b else '0.0%'
d = k.get('delta'); dtxt = 'n/a (no previous snapshot)' if d is None else (f"+{d:,}" if d >= 0 else f"{d:,}")
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
    json.dump({'range': f"Summary!{c}", 'values': [[v]]}, open(f'{out}/91_kpi_{i}_{c}.json', 'w'))
print('files:', len(os.listdir(out)))
