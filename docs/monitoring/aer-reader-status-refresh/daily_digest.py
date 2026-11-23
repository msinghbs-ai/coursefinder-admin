#!/usr/bin/env python3
"""daily_digest.py --admin <admin clone> --live <C.out> --now "YYYY-MM-DD HH:MM" [--register <csv>] [--prev-register <csv>]

S1-Build's 08:00 AEDT daily digest (design: docs/platform/2026-11-23-file-driven-continuous-delivery-design.md, sections 3, 6, 7 and 11).
In the admin clone it:
  1. releases stale claims in docs/monitoring/PROVIDER-ENRICHMENT-QUEUE.csv: a CLAIMED:<lane> cell whose row was last updated more than
     24 hours before --now goes back to PENDING (claim fields cleared when no other claim is left on the row, a dated note added);
  2. writes docs/monitoring/S1-BLOCKER-QUEUE.csv: one line per HELD:<code> cell, with provider_id, aer_source_url, storage_artifact_path,
     the exact reason (code and the provider's note for that domain) and the target solver;
  3. regenerates docs/monitoring/DAILY-EXECUTIVE-STATUS.md (queue burndown with 24-hour velocity, live coverage with the 24-hour change,
     guardrails, the Technical Blockers & Ready-to-Solve S1 Queue, approvals, notes), keeping every spend-log line the lanes wrote;
  4. keeps docs/monitoring/daily-digest-state.json (yesterday's DONE counts and coverage) for the velocity and the change columns.
It reads files only; the live figures come from the rolled-back probe output (--live). Nothing is written to the database.
"""
import argparse, csv, datetime as dt, io, json, os, re

DOMAINS = [  # queue column, domain, S1 owner after consolidation (Platform Admin 23 Nov 2026 18:55)
    ('aer_status', 'Academic entry (AER)', 'S1-RM-Design'),
    ('url_desc_status', 'Official URLs and descriptions', 'S1-Build'),
    ('intake_status', 'Intakes and deadlines', 'S1-RM-Design'),
    ('scholarship_status', 'Scholarships', 'S1-Build'),
    ('geo_status', 'Campus locality (geo)', 'S1-Build'),
    ('elr_status', 'English requirements (ELR)', 'S1-ELR'),
]
NOTE_KEYS = {'aer_status': ('AER', 'aer'), 'intake_status': ('intake',), 'url_desc_status': ('URL', 'url', 'description', 'S2-CF'),
             'scholarship_status': ('scholarship', 'Scholarship'), 'geo_status': ('geo', 'campus', 'locality'), 'elr_status': ('English', 'ELR')}
APPROVAL = {'BUDGET_GATE', 'G3_FREEZE'}


def solver(code, col):
    """Target solver for a HELD code (design section 6): S1-Build for missing URLs and sources, blocked sites and upstream snapshots;
    S1-RM-Design for parser and table edge cases; the Platform Admin for the two approval gates."""
    if code in APPROVAL:
        return 'Platform Admin'
    if code == 'NON_ACADEMIC_ONLY':
        return 'none (closed unless scope changes)'
    if code in ('NO_SOURCE', 'SITE_BLOCKED', 'WAF_OR_JS_BLOCK', 'IDENTITY_UNRESOLVED'):
        return 'S1-Build'
    return 'S1-RM-Design'  # PARSER_EDGE_CASE and any other reader or table edge case


def note_for(notes, col):
    """The part of the provider's queue note that explains this domain's HELD code (the seeding line is left out)."""
    parts = [p.strip() for p in re.split(r'\s\|\s', notes or '') if p.strip()]
    out = []
    for p in parts:
        p = re.sub(r'^seeded from AER_University_Reader_Status\.csv \(snapshot [^)]*\);?\s*', '', p)
        if not p:
            continue
        if col == 'intake_status':
            i = p.find('intake:')
            if i >= 0:
                out.append(p[i:])
        elif col == 'aer_status':
            if p.startswith('AER') or ' AER ' in p:
                out.append(p)
        elif any(k in p for k in NOTE_KEYS.get(col, ())):
            out.append(p)
    return ' | '.join(out)[:400]


def pct(n, d):
    return f'{100.0 * n / d:.1f}' if d else '0.0'


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--admin', required=True); ap.add_argument('--live', required=True); ap.add_argument('--now', required=True)
    ap.add_argument('--register'); ap.add_argument('--prev-register')
    a = ap.parse_args()
    mon = os.path.join(a.admin, 'docs', 'monitoring')
    qpath = os.path.join(mon, 'PROVIDER-ENRICHMENT-QUEUE.csv')
    now = dt.datetime.strptime(a.now, '%Y-%m-%d %H:%M')

    # 1. stale claims
    raw = open(qpath, newline='', encoding='utf-8').read()
    rows = list(csv.DictReader(io.StringIO(raw)))
    fields = list(csv.DictReader(io.StringIO(raw)).fieldnames)
    released = []
    for r in rows:
        try:
            last = dt.datetime.strptime(r['last_updated_aedt'].strip(), '%Y-%m-%d %H:%M')
        except ValueError:
            last = None
        if last is None or now - last <= dt.timedelta(hours=24):
            continue
        hit = [c for c, _, _ in DOMAINS if r[c].startswith('CLAIMED')]
        for c in hit:
            released.append((r['provider_name'], c, r[c], r['last_updated_aedt']))
            r[c] = 'PENDING'
        if hit:
            if not any(r[c].startswith('CLAIMED') for c, _, _ in DOMAINS):
                r['active_claim_lane'] = ''; r['active_spec_id'] = ''
            r['notes'] = (r['notes'] + ' | ' if r['notes'] else '') + f"stale claim released by S1-Build {a.now} ({', '.join(hit)}; no change for 24 h)"
            r['last_updated_aedt'] = a.now
    if released:
        out = io.StringIO(); w = csv.DictWriter(out, fieldnames=fields, lineterminator='\n'); w.writeheader(); w.writerows(rows)
        open(qpath, 'w', newline='', encoding='utf-8').write(out.getvalue())

    # 2. blocker queue (every HELD cell)
    blk = []
    for r in rows:
        for c, dom, _ in DOMAINS:
            if r[c].startswith('HELD:'):
                code = r[c].split(':', 1)[1]
                blk.append({'queue_rank': r['queue_rank'], 'tier': r['tier'], 'provider_id': r['provider_id'], 'provider_name': r['provider_name'],
                            'country_code': r['country_code'], 'active_courses': r['active_courses'], 'domain': dom, 'queue_column': c, 'held_code': r[c],
                            'target_solver': solver(code, c), 'source_type': r['source_type'], 'aer_source_url': r['aer_source_url'],
                            'storage_artifact_path': r['storage_artifact_path'], 'failure_reason': note_for(r['notes'], c) or r[c],
                            'last_updated_aedt': r['last_updated_aedt']})
    bcols = ['queue_rank', 'tier', 'provider_id', 'provider_name', 'country_code', 'active_courses', 'domain', 'queue_column', 'held_code', 'target_solver',
             'source_type', 'aer_source_url', 'storage_artifact_path', 'failure_reason', 'last_updated_aedt']
    out = io.StringIO(); w = csv.DictWriter(out, fieldnames=bcols, lineterminator='\n'); w.writeheader()
    w.writerows(sorted(blk, key=lambda x: (int(x['queue_rank']), x['queue_column'])))
    open(os.path.join(mon, 'S1-BLOCKER-QUEUE.csv'), 'w', newline='', encoding='utf-8').write(out.getvalue())

    # live figures
    live = {}
    for line in open(a.live, encoding='utf-8'):
        if line.startswith('C0~'):
            live = json.loads(line[3:])
    spath = os.path.join(mon, 'daily-digest-state.json')
    prev = json.load(open(spath)) if os.path.exists(spath) else {}
    act = int(live.get('active_courses') or 0)
    cov = live.get('coverage') or {}
    measures = [('Academic entry (AER)', cov.get('academic_entry')), ('English requirements (ELR)', cov.get('english')),
                ('Official course URLs', cov.get('official_url')), ('Course descriptions', cov.get('description')),
                ('Exact intake dates (courses with a dated active intake)', live.get('exact_intake_courses')),
                ('Campus locality (geo: campus city held)', cov.get('campus_city'))]
    done = {c: sum(1 for r in rows if r[c] == 'DONE') for c, _, _ in DOMAINS}

    # 3. digest
    dpath = os.path.join(mon, 'DAILY-EXECUTIVE-STATUS.md')
    old = open(dpath, encoding='utf-8').read() if os.path.exists(dpath) else ''
    spend_rows = []
    m = re.search(r'\| Time \(AEDT\) \| Lane \| Target \| Service \| US\$ \| Day total \|\n\|[-| ]+\|\n((?:\|.*\|\n?)*)', old)
    if m:
        spend_rows = [l for l in m.group(1).splitlines() if l.strip() and not l.startswith('| None')]
    lane_hdr = '| Provider | Spec | Code | Solver | Source | Exact error | Proposed fix |'
    lane_rows = []
    if lane_hdr in old:
        tail = old.split(lane_hdr, 1)[1].split('\n')[2:]
        for l in tail:
            if not l.startswith('|'):
                break
            lane_rows.append(l)
    held_ids = {b['provider_id'] for b in blk}
    kept = [l for l in lane_rows if any(pid in l for pid in held_ids)]
    dropped = len(lane_rows) - len(kept)
    day = a.now[:10]; yday = (now - dt.timedelta(days=1)).strftime('%Y-%m-%d')
    spent = 0.0
    for l in spend_rows:
        cells = [c.strip() for c in l.strip('|').split('|')]
        if len(cells) >= 5 and (cells[0].startswith(day) or cells[0].startswith(yday)):
            try:
                spent += float(cells[4].replace('US$', '').replace('$', '').replace(',', ''))
            except ValueError:
                pass
    api = live.get('api') or {}
    g3 = f"{api.get('functions')} and {api.get('relations')}, drift {len(api.get('drift') or [])}" if api else 'not read'
    g3_ok = bool(api) and api.get('functions') == 75 and api.get('relations') == 48 and not api.get('drift')
    L = []
    esc = lambda s: (s or '').replace('|', '/').replace('\n', ' ')
    L.append('# Daily Executive Status\n')
    L.append('**Owner:** `S1-Build`. **Updated:** 08:00 AEDT each day by the scheduled refresh. **Design:** `docs/platform/2026-11-23-file-driven-continuous-delivery-design.md`.')
    L.append('**Sources:** `docs/monitoring/PROVIDER-ENRICHMENT-QUEUE.csv`, `docs/monitoring/AER_University_Reader_Status.csv`, a rolled-back live read of coverage and guardrails, and the lanes\' spend log below.\n')
    L.append(f"**Report date:** {now.strftime('%d %b %Y')} {a.now[11:]} AEDT. **Live read:** {live.get('read_at', 'not read')} (Melbourne).\n")
    L.append('## 1. Queue burndown by lane\n')
    L.append(f'Counts are rows in the queue file ({len(rows):,} providers). Velocity is the change in `DONE` since the previous digest.\n')
    L.append('| Owner (S1) | Domain | DONE | CLAIMED | PENDING | HELD | PARKED | 24h velocity (rows) |')
    L.append('|---|---|---|---|---|---|---|---|')
    for c, dom, own in DOMAINS:
        n = lambda p: sum(1 for r in rows if r[c].startswith(p))
        vel = (done[c] - prev['done'][c]) if prev.get('done', {}).get(c) is not None else 'n/a (first digest)'
        vel = f'{vel:+d}' if isinstance(vel, int) else vel
        L.append(f"| `{own}` | {dom} | {n('DONE'):,} | {n('CLAIMED'):,} | {n('PENDING'):,} | {n('HELD'):,} | {n('PARKED'):,} | {vel} |")
    L.append('\n## 2. Live coverage\n')
    L.append(f'Active courses: {act:,} (denominator), read live in a rolled-back run.\n')
    L.append('| Field | Courses covered | Coverage (%) | Change since previous digest (percentage points) |')
    L.append('|---|---|---|---|')
    for name, v in measures:
        v = int(v) if v is not None else None
        p0 = prev.get('coverage_pct', {}).get(name)
        p1 = float(pct(v, act)) if v is not None else None
        ch = f'{p1 - p0:+.1f}' if (p0 is not None and p1 is not None) else 'n/a (first digest)'
        L.append(f"| {name} | {f'{v:,}' if v is not None else 'not read'} | {pct(v, act) if v is not None else '-'} | {ch} |")
    sch = live.get('scholarships_published')
    L.append(f"| Scholarships (published awards, not courses) | {f'{sch:,}' if isinstance(sch, int) else 'not read'} | - | - |")
    L.append('\n## 3. Guardrails\n')
    L.append('| Guardrail | Target | Today | OK? |')
    L.append('|---|---|---|---|')
    L.append(f"| G3 frozen API (functions and relations) | 75 and 48, no drift | {g3} | {'Yes' if g3_ok else 'NO'} |")
    lk = live.get('locks'); cr = live.get('cron_active')
    L.append(f"| Manual locks | 7,585 | {f'{lk:,}' if isinstance(lk, int) else 'not read'} | {'Yes' if lk == 7585 else 'NO'} |")
    L.append(f"| Active cron jobs | 140 or fewer | {cr if cr is not None else 'not read'} | {'Yes' if isinstance(cr, int) and cr <= 140 else 'NO'} |")
    L.append(f"| Platform spend (Firecrawl and AI, micro-budget) | US$5.00 a day or less (charter 23 Nov 2026) | US${spent:.2f} logged for {yday} and {day} | {'Yes' if spent <= 5.0 else 'NO'} |")
    L.append('\n### Spend log (micro-budget, US$5.00 a day)\n')
    L.append('Each paid call by a lane is one line: time (AEDT), lane, provider or course, service (Firecrawl or AI), US$ amount, and the running total for the day. The digest keeps every line the lanes write.\n')
    L.append('| Time (AEDT) | Lane | Target | Service | US$ | Day total |')
    L.append('|---|---|---|---|---|---|')
    L += spend_rows or ['| None | | | | | |']
    L.append('\n## 4. Approvals needed (exceptions only)\n')
    L.append('Only exceptions appear here (charter 23 Nov 2026): `HELD:BUDGET_GATE` (above US$5.00 a day, or paid Tier 2 or Tier 3 crawling), `HELD:G3_FREEZE`, and any change that would touch the 7,585 manual locks, take active cron jobs above 140, or withdraw live admitted records in bulk without replacements. If the list is empty, no decision is needed today.\n')
    L.append('| Provider | Domain | Reason code | What is needed | Cost or impact |')
    L.append('|---|---|---|---|---|')
    appr = [b for b in blk if b['target_solver'] == 'Platform Admin']
    for b in appr:
        L.append(f"| {esc(b['provider_name'])} | {b['domain']} | `{b['held_code']}` | Platform Admin decision | {esc(b['failure_reason'])[:200]} |")
    if not appr:
        L.append('| None | | | | |')
    L.append('\n## 4a. Technical Blockers & Ready-to-Solve S1 Queue\n')
    L.append(f'Every `HELD:*` cell in the queue is one line of `docs/monitoring/S1-BLOCKER-QUEUE.csv` ({len(blk):,} lines today), with `provider_id`, `aer_source_url`, `storage_artifact_path`, the exact reason and the target solver. Solvers follow design section 6: `S1-RM-Design` for parser and table edge cases (`HELD:PARSER_EDGE_CASE`); `S1-Build` for missing sources, identity, WAF or JavaScript blocks (never bypassed) and upstream snapshots; the Platform Admin for `HELD:BUDGET_GATE` and `HELD:G3_FREEZE` only (section 4).\n')
    agg = {}
    for b in blk:
        k = (b['target_solver'], b['domain'], b['held_code']); agg[k] = agg.get(k, 0) + 1
    L.append('| Target solver | Domain | Reason code | Providers |')
    L.append('|---|---|---|---|')
    for (s, d, c), n in sorted(agg.items(), key=lambda x: (-x[1], x[0])):
        L.append(f'| `{s}` | {d} | `{c}` | {n:,} |')
    top = [b for b in blk if b['tier'] in ('1', '2') and b['target_solver'] in ('S1-Build', 'S1-RM-Design')]
    L.append(f'\n**Ready to solve, Tier 1 and Tier 2 ({len(top)} lines; Tier 3 is in the CSV):**\n')
    L.append('| Rank | Provider | provider_id | Domain | Code | Solver | aer_source_url | storage_artifact_path | Reason |')
    L.append('|---|---|---|---|---|---|---|---|---|')
    for b in top:
        L.append(f"| {b['queue_rank']} | {esc(b['provider_name'])} | `{b['provider_id']}` | {b['domain']} | `{b['held_code']}` | `{b['target_solver']}` | {esc(b['aer_source_url']) or '-'} | {('`' + b['storage_artifact_path'] + '`') if b['storage_artifact_path'] else '-'} | {esc(b['failure_reason'])[:300]} |")
    L.append('\n**Solver entries written by the lanes** (kept as written while the provider is still held; a lane adds one row per provider it diagnoses):\n')
    L.append(lane_hdr)
    L.append('|---|---|---|---|---|---|---|')
    L += kept or ['| None | | | | | | |']
    L.append('\n## 5. Notes\n')
    if dropped:
        L.append(f'- {dropped} solver entries dropped because their provider is no longer held.')
    if released:
        for p, c, s, t in released:
            L.append(f'- Stale claim released: {p}, `{c}` was `{s}` (last updated {t}).')
    else:
        L.append('- No stale claim (older than 24 hours) to release.')
    stale = [b for b in appr if '$0' in b['failure_reason'] and b['held_code'] == 'HELD:BUDGET_GATE']
    if stale:
        L.append(f"- {len(stale)} `HELD:BUDGET_GATE` rows cite a missing $0 read. The charter (design 10.2) now authorises $0 plain-HTTP reads, so the owning lane re-checks them before they are treated as approvals: " + ', '.join(esc(b['provider_name']) for b in stale) + '.')
    if not g3_ok or lk != 7585 or not (isinstance(cr, int) and cr <= 140) or spent > 5.0:
        L.append('- **A guardrail is not met (section 3).**')
    open(dpath, 'w', encoding='utf-8').write('\n'.join(L) + '\n')

    # 4. state
    json.dump({'at': a.now, 'done': done, 'coverage_pct': {n: float(pct(int(v), act)) for n, v in measures if v is not None}},
              open(spath, 'w'), indent=1, sort_keys=True)
    print(f'released {len(released)} stale claims; {len(blk)} HELD cells; {len(appr)} approvals; spend US${spent:.2f}')


if __name__ == '__main__':
    main()
