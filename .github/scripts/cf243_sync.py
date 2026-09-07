from pathlib import Path

# Register
p=Path('change-control/REGISTER.md')
s=p.read_text()
summary='> **M2.4.5 COMPARE UI BUGFIX:** `CF-CHG-20260907-243` is CLOSED / PASS. Independent QS/THE edition selectors (each with Multi-year), removal of the shared QILT/PRISMS snapshot/trend control, and sticky University/Provider identity headers are accepted at Pilot v2.15.74 / `0475dc5dc88a7f3b568a5151e6fd8d94af411924`; build/browser smoke `34097989443` PASS; deployed Cloudflare UAT/currentness `34097989441` PASS. No DB or Production change.\n>\n'
needle='> **M2.4.5 UI / RELEASE CURRENTNESS:** `CF-CHG-20260907-242`'
idx=s.find(needle)
if idx>=0 and 'M2.4.5 COMPARE UI BUGFIX' not in s:
    end=s.find('\n>\n',idx)
    s=s[:end+3]+summary+s[end+3:]
row='| CF-CHG-20260907-243 | 30-admin-pim-ux | M2.4.5 Compare ranking years and sticky Provider headers | CLOSED / PASS | `30-admin-pim-ux/CF-CHG-20260907-243-compare-ranking-years-sticky-provider-headers.md` |\n'
if 'CF-CHG-20260907-243 | 30-admin-pim-ux' not in s:
    s=s.rstrip()+'\n'+row
p.write_text(s)

# Current state
p=Path('project-runsheets/milestone-2/m2.4/m2.4.5/CURRENT-STATE.md')
s=p.read_text()
block='''\n## CF-243 Compare UI bugfix — CLOSED / PASS — 7 September 2026\n\n- Visible Pilot release: **v2.15.74**.\n- Pilot main: `0475dc5dc88a7f3b568a5151e6fd8d94af411924`.\n- QS and THE now have independent edition selectors in their own ranking sections, each including a Multi-year option.\n- Shared QILT/PRISMS Current snapshot / Multi-year trend controls are removed; QILT retains its explicit year selector.\n- University/Provider identity headers are explicitly sticky across QILT and PRISMS comparison scrolling.\n- Functional deployed UAT `34097458830`: PASS.\n- Final v2.15.74 build/browser smoke `34097989443`: PASS.\n- Final deployed currentness `34097989441`: PASS.\n- No DB, publication, Search, Website/Zoho or Production semantics changed.\n- CF-241 remains reserved for separate CF-239 forward runtime reconciliation.\n\n'''
if '## CF-243 Compare UI bugfix' not in s:
    first=s.find('\n',s.find('# M2.4.5 CURRENT STATE'))
    s=s[:first+1]+block+s[first+1:]
p.write_text(s)

# Follow-ups
p=Path('project-runsheets/milestone-2/m2.4/m2.4.5/FOLLOW-UPS.md')
s=p.read_text()
row='| M245-FU-028 | Compare UI / CF-243 | Independent ranking editions + sticky University headers | CLOSED / PASS | v2.15.74; functional deployed UAT 34097458830 PASS; final currentness 34097989441 PASS |\n'
if 'M245-FU-028' not in s:
    s=s.rstrip()+'\n\n'+row
p.write_text(s)

# Next chat current pickup
p=Path('project-runsheets/milestone-2/m2.4/m2.4.5/NEXT-CHAT.md')
s=p.read_text()
block='''\n## Latest accepted UI correction — CF-243\n\n- Pilot visible release is **v2.15.74** at `0475dc5dc88a7f3b568a5151e6fd8d94af411924`.\n- Provider Compare has independent QS/THE edition selectors with Multi-year per publisher.\n- Shared QILT/PRISMS snapshot/trend controls are removed; QILT keeps its year selector.\n- QILT/PRISMS University/Provider identity headers are sticky.\n- Final build/browser smoke `34097989443` PASS; deployed Cloudflare UAT/currentness `34097989441` PASS.\n- CF-241 remains reserved for separate CF-239 runtime reconciliation.\n- Production untouched; M2.5 remains paused.\n\n'''
if '## Latest accepted UI correction — CF-243' not in s:
    pos=s.find('\n',s.find('# M2.4.5 NEXT CHAT'))
    s=s[:pos+1]+block+s[pos+1:]
p.write_text(s)
