# Regenerates Roadmap_Engagement_Register.xlsx from the two ledger CSVs, keeping its formatting and formulas.
# Usage (from this folder): python3 refresh-engagement-workbook.py Roadmap_Engagement_Register.xlsx ROADMAP-MILESTONES.csv ROADMAP-ENGAGEMENTS.csv
import csv,sys,copy,openpyxl
from openpyxl.utils import get_column_letter as L
wbp,mcsv,ecsv=sys.argv[1:4]
wb=openpyxl.load_workbook(wbp)
def rows(p):
    with open(p,newline='',encoding='utf-8-sig') as f: return list(csv.reader(f))[1:]
def fill(ws,tname,data,ncsv,formula):
    t=ws.tables[tname]; start=5
    tmpl=[copy.copy(ws.cell(start,c)._style) for c in range(1,ws.max_column+1)]
    for r in range(start,ws.max_row+1):
        for c in range(1,ws.max_column+1): ws.cell(r,c).value=None
    for i,d in enumerate(data):
        r=start+i
        for c,v in enumerate(d[:ncsv],1):
            cell=ws.cell(r,c); cell._style=copy.copy(tmpl[c-1])
            if tname=='RoadmapEngagements' and c==7: v=int(v)
            cell.value=v if v!='' else None
            if tname=='RoadmapEngagements' and c==2: cell.number_format='@'
        for c,f in formula(r).items():
            cell=ws.cell(r,c); cell._style=copy.copy(tmpl[c-1]); cell.value=f
    last=start+max(len(data),1)-1
    t.ref=f"A4:{L(ws.max_column)}{last}"
fill(wb['Milestones'],'RoadmapMilestones',rows(mcsv),8,lambda r:{
 9:f"=SUMIF('Engagements'!$C$5:$C$10004,A{r},'Engagements'!$P$5:$P$10004)",
 10:f"=IF(B{r}=\"\",SUMIF('Engagements'!$D$5:$D$10004,A{r},'Engagements'!$P$5:$P$10004),I{r})",
 11:f"=J{r}/60"})
fill(wb['Engagements'],'RoadmapEngagements',rows(ecsv),15,lambda r:{
 16:f"=IF(COUNTIF($O$5:$O$10004,A{r})>0,0,G{r})"})
wb.save(wbp)
