#!/usr/bin/env python3
"""Build the adapter pattern sheet (CSV + Markdown) from the night-run report rows and the live DB snapshot.

Inputs:  rows/*.tsv  (16 columns per EXTRACT-BRIEF.md, one row per provider per report)
         db.tsv      (live adapter state, one row per enabled/admitting adapter)
Outputs: out/adapter-pattern-sheet.csv, out/ADAPTER-PATTERN-SHEET.md
"""
import csv, glob, os, re, sys, collections, datetime

AS_AT = sys.argv[1] if len(sys.argv) > 1 else datetime.datetime.now().strftime('%d %b %Y %H:%M')
RCOLS = ['report', 'provider', 'provider_id', 'outcome', 'admitted', 'page_structure', 'intakes_at', 'fee_at',
         'english_at', 'delivery_wording', 'adapter_config', 'central_pages', 'rebinds_website', 'exclusions',
         'blockers_lessons', 'decision_next']
DCOLS = ['provider_id', 'name', 'country', 'website', 'state', 'admit_fields', 'pattern_fields', 'page_view',
         'term_months', 'json_source', 'exclusions_active', 'delivery_exclusions_active', 'central_pages_live',
         'read_pages', 'active_courses', 'adapter_updated']


def norm(s):
    s = s.lower().replace('&', ' and ')
    s = re.sub(r'\b(pty|ltd|limited|inc|incorporated|the|t/a|trading as)\b', ' ', s)
    return re.sub(r'[^a-z0-9]+', ' ', s).strip()


def report_key(r):
    # later report files win: B1-r2 after B1; order by track, batch, revision
    m = re.match(r'([A-Z]+)(\d+)?(?:-r(\d+))?\.md', r)
    if not m:
        return ('Z', 0, 0)
    return (m.group(1), int(m.group(2) or 0), int(m.group(3) or 0))


rows = []
for f in sorted(glob.glob('rows/*.tsv')):
    for line in open(f, encoding='utf-8'):
        line = line.rstrip('\n')
        if not line.strip():
            continue
        parts = line.split('\t')
        if len(parts) != 16:
            print('skip bad row', f, len(parts), file=sys.stderr)
            continue
        rows.append(dict(zip(RCOLS, [p.strip() for p in parts])))

db = {}
for line in open('db.tsv', encoding='utf-8'):
    line = line.rstrip('\n')
    if not line:
        continue
    parts = line.split('\t')
    parts += [''] * (16 - len(parts))
    d = dict(zip(DCOLS, parts[:16]))
    db[d['provider_id']] = d

by_norm = {norm(d['name']): pid for pid, d in db.items()}


def match(row):
    pid = row['provider_id']
    if pid and pid != '-':
        hits = [k for k in db if k.startswith(pid.lower()[:8])]
        if len(hits) == 1:
            return hits[0]
    n = norm(row['provider'])
    if not n:
        return None
    if n in by_norm:
        return by_norm[n]
    if row.get('outcome') not in ('admitting', 'testing'):
        return None  # a provider with no adapter must match exactly, never by a similar name
    # containment on whole names (longest db name first)
    for dn, p in sorted(by_norm.items(), key=lambda x: -len(x[0])):
        if len(n) >= 8 and len(dn) >= 8 and (n in dn or dn in n):
            return p
    # token overlap (names like 'Top Education Institute (IMC, ...)' or 'X (provider named N/A)')
    nt = set(t for t in n.split() if len(t) > 2 and t not in ('college','institute','australia','australian','education','training','school','of','and','academy','international','group','nz','new','zealand'))
    best, bs = None, 0.0
    for dn, p in by_norm.items():
        dt = set(t for t in dn.split() if len(t) > 2 and t not in ('college','institute','australia','australian','education','training','school','of','and','academy','international','group','nz','new','zealand'))
        if not nt or not dt:
            continue
        sc = len(nt & dt) / len(nt | dt)
        if sc > bs:
            best, bs = p, sc
    if bs >= 0.5:
        return best
    return None


# keep the latest report row per provider (by matched id, else by normalised name)
latest = {}
for r in sorted(rows, key=lambda r: report_key(r['report'])):
    pid = match(r)
    key = pid or ('name:' + norm(r['provider']))
    r['_pid'] = pid
    latest[key] = r

out = []
seen_db = set()
for key, r in latest.items():
    d = db.get(r['_pid']) if r['_pid'] else None
    if d:
        seen_db.add(d['provider_id'])
    out.append((r, d))
for pid, d in db.items():
    if pid not in seen_db:
        out.append((None, d))

STATE_ORDER = {'admitting': 0, 'testing': 1, 'no_adapter': 2, 'blocked': 3}


def state_of(r, d):
    if d:
        return d['state']
    return (r or {}).get('outcome') or 'no_adapter'


records = []
for r, d in out:
    r = r or {}
    st = state_of(r, d)
    rec = collections.OrderedDict()
    rec['provider'] = (d or {}).get('name') or r.get('provider', '')
    rec['provider_id'] = (d or {}).get('provider_id') or (r.get('provider_id') if r.get('provider_id') not in (None, '-') else '')
    rec['country'] = (d or {}).get('country', '')
    rec['website'] = (d or {}).get('website', '')
    rec['state'] = st
    rec['admitted_fields'] = (d or {}).get('admit_fields') if d else (r.get('admitted') if r.get('admitted') not in (None, '-') else '')
    rec['page_structure'] = r.get('page_structure', '')
    rec['intakes_at'] = r.get('intakes_at', '')
    rec['fee_at'] = r.get('fee_at', '')
    rec['english_at'] = r.get('english_at', '')
    rec['delivery_wording'] = r.get('delivery_wording', '')
    rec['pattern_fields'] = (d or {}).get('pattern_fields', '')
    special = [x for x in [(d or {}).get('page_view'), (d or {}).get('term_months'), (d or {}).get('json_source')] if x]
    rec['special_config'] = '; '.join(special + ([r['adapter_config']] if r.get('adapter_config') not in (None, '', '-') else []))
    rec['central_pages'] = (d or {}).get('central_pages_live') or (r.get('central_pages') if r.get('central_pages') != '-' else '')
    rec['exclusions_active'] = ((d or {}).get('exclusions_active', '') + ' + ' + (d or {}).get('delivery_exclusions_active', '') + ' delivery') if d else ''
    rec['read_pages_of_courses'] = (d['read_pages'] + ' / ' + d['active_courses']) if d else ''
    rec['rebinds_website'] = r.get('rebinds_website', '')
    rec['blockers_lessons'] = r.get('blockers_lessons', '')
    rec['decision_next'] = r.get('decision_next', '')
    rec['source_report'] = r.get('report', '') or 'register (before night run)'
    rec['adapter_updated'] = (d or {}).get('adapter_updated', '')
    records.append(rec)

records.sort(key=lambda x: (STATE_ORDER.get(x['state'], 9), x['provider'].lower()))
os.makedirs('out', exist_ok=True)
with open('out/adapter-pattern-sheet.csv', 'w', newline='', encoding='utf-8') as f:
    w = csv.DictWriter(f, fieldnames=list(records[0].keys()))
    w.writeheader()
    for rec in records:
        w.writerow({k: ('-' if v in ('', None) else v) for k, v in rec.items()})


def cell(s, n=140):
    s = (s or '').replace('|', '/').replace('\n', ' ').strip()
    if s in ('', '-'):
        return '-'
    return s if len(s) <= n else s[:n - 1].rstrip() + '…'


cnt = collections.Counter(r['state'] for r in records)
field_cnt = collections.Counter()
for r in records:
    if r['state'] == 'admitting':
        for f in re.split(r';\s*', r['admitted_fields'] or ''):
            if f:
                field_cnt[f] += 1


def bucket(col, keys):
    c = collections.Counter()
    for r in records:
        v = (r[col] or '').lower()
        for k in keys:
            if k in v:
                c[k] += 1
                break
        else:
            c['other / not stated'] += 1
    return c


INT_KEYS = ['course page months', 'central calendar', 'rolling', 'numeric', 'render', 'stale', 'not published']
FEE_KEYS = ['course page annual', 'whole-course total', 'central fees', 'two international', 'domestic only', 'per week', 'per unit', 'per term', 'behind toggle', 'not labelled', 'not published']
ENG_KEYS = ['course page', 'central english', 'conditional', 'not published']

md = []
md.append('# Adapter Pattern Sheet')
md.append('')
md.append(f'**Status:** CURRENT · **Decision:** 254 · **Change control:** CF-CHG-20260915-247 · **As at:** {AS_AT} AEDT')
md.append('**Machine-readable copy:** `adapter-pattern-sheet.csv` (same rows, every column in full). **Lessons learnt:** `ADAPTER-LESSONS.md`. **Reviewed configurations:** `README.md` and `configs/`.')
md.append('')
md.append("This sheet records, for every provider an adapter agent has worked on, where each attribute sits on the provider's own site and how its adapter is set up. Attributes can sit on the course page, on a central academic or fees page, behind a toggle, or not be published at all. The sheet also records the special settings each adapter needs, the blockers found, and the next step. It is rebuilt after every adapter wave from the agents' reports and the live database (`pipeline.uni_adapters`, exclusions and central pages). Where the two disagree, the live database wins for state, admitted fields, patterns, exclusions and central pages.")
md.append('')
md.append('## Summary')
md.append('')
md.append('| State | Providers |')
md.append('|---|---:|')
for k in ['admitting', 'testing', 'no_adapter', 'blocked']:
    md.append(f'| {k.replace("_", " ").capitalize()} | {cnt.get(k, 0)} |')
md.append(f'| **Total** | **{len(records)}** |')
md.append('')
md.append('"Testing" means an adapter is saved and enabled but no field is admitted. "No adapter" means pages were read but nothing could be built. "Blocked" means there was no own website or no own course pages: an aggregator only, nothing stored, or the site refuses the reader.')
md.append('')
md.append('**Admitted fields (admitting providers):** ' + ', '.join(f'{k} {v}' for k, v in field_cnt.most_common()))
md.append('')
md.append('### Where attributes sit (all providers with a report)')
md.append('')
for title, col, keys in [('Intakes', 'intakes_at', INT_KEYS), ('Fees', 'fee_at', FEE_KEYS), ('English', 'english_at', ENG_KEYS)]:
    b = bucket(col, keys)
    md.append(f'**{title}:** ' + ', '.join(f'{k} {v}' for k, v in b.most_common()))
    md.append('')
md.append('## Providers')
md.append('')
md.append('The columns are cut to about 140 characters here. The CSV has the full text.')
md.append('')
for st in ['admitting', 'testing', 'no_adapter', 'blocked']:
    group = [r for r in records if r['state'] == st]
    if not group:
        continue
    md.append(f'### {st.replace("_", " ").capitalize()} ({len(group)})')
    md.append('')
    md.append('| Provider | Admitted | Intakes at | Fees at | English at | Delivery wording | Adapter set-up | Central pages | Blockers and lessons | Next step | Report |')
    md.append('|---|---|---|---|---|---|---|---|---|---|---|')
    for r in group:
        setup = '; '.join(x for x in [r['pattern_fields'], r['special_config']] if x and x != '-')
        name = r['provider'] + (f' ({r["country"]})' if r['country'] else '')
        md.append('| ' + ' | '.join([cell(name, 80), cell(r['admitted_fields'], 60), cell(r['intakes_at']), cell(r['fee_at']),
                                      cell(r['english_at'], 90), cell(r['delivery_wording'], 100), cell(setup), cell(r['central_pages'], 120),
                                      cell(r['blockers_lessons']), cell(r['decision_next']), cell(r['source_report'], 30)]) + ' |')
    md.append('')
open('out/ADAPTER-PATTERN-SHEET.md', 'w', encoding='utf-8').write('\n'.join(md) + '\n')
print('records', len(records), dict(cnt), 'unmatched report rows', sum(1 for r, d in out if r and not d))
