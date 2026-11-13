import fs from 'node:fs/promises';
import path from 'node:path';
import { Workbook, SpreadsheetFile } from '@oai/artifact-tool';

const [milestoneCsv, engagementCsv, output, preview] = process.argv.slice(2);
if (!milestoneCsv || !engagementCsv || !output) {
  throw new Error('Usage: node build-engagement-workbook.mjs milestones.csv engagements.csv output.xlsx [preview.png]');
}

function readCsv(text) {
  // Ledger rules require one physical line per row. Support escaped quotes and commas.
  return text.replace(/^\uFEFF/, '').trimEnd().split(/\r?\n/).map(line => {
    const matches = [...line.matchAll(/(?:^|,)(?:"((?:[^"]|"")*)"|([^",]*))(?=,|$)/g)];
    const reconstructed = matches.map(match => match[0]).join('');
    if (reconstructed !== line) throw new Error('Malformed CSV row: ' + line);
    return matches.map(match => match[1] === undefined ? match[2] : match[1].replaceAll('""', '"'));
  });
}

const [milestoneHeaders, ...milestones] = readCsv(await fs.readFile(milestoneCsv, 'utf8'));
const [engagementHeaders, ...engagements] = readCsv(await fs.readFile(engagementCsv, 'utf8'));
const itemIds = new Set(milestones.map(row => row[0]));
const engagementIds = new Set(engagements.map(row => row[0]));
if (milestones.length !== itemIds.size || engagements.length !== engagementIds.size) {
  throw new Error('Duplicate milestone or engagement ID.');
}
const milestoneById = new Map(milestones.map(row => [row[0], row]));
for (const row of milestones) {
  if (row.length !== milestoneHeaders.length || !/^RM\d+[A-Z]*$/.test(row[0]) ||
      (row[1] && (!itemIds.has(row[1]) || milestoneById.get(row[1])[1] || row[1] === row[0]))) {
    throw new Error('Invalid milestone row: ' + row[0]);
  }
}
const priorIds = new Set();
const replacedIds = new Set();
for (const row of engagements) {
  const duration = Number(row[6]);
  const prior = row[14];
  const item = milestoneById.get(row[2]);
  if (row.length !== engagementHeaders.length || !item || row[3] !== (item[1] || item[0]) ||
      !Number.isInteger(duration) || duration < 15 || !['minimum','reported'].includes(row[7]) ||
      (row[7] === 'minimum' && duration !== 15) ||
      !/^\d{4}-\d\d-\d\d(?:T\d\d:\d\d:\d\d\+1[01]:00)?$/.test(row[1]) ||
      (prior && (!priorIds.has(prior) || replacedIds.has(prior)))) {
    throw new Error('Invalid engagement row: ' + row[0]);
  }
  row[6] = duration;
  priorIds.add(row[0]);
  if (prior) replacedIds.add(prior);
}

const book = Workbook.create();
const navy = '#142D42', teal = '#08756D', pale = '#E8F4F3';
const fmt = {name:'Aptos',size:11,color:navy};
const col = n => String.fromCharCode(65+n);

function sheet(name, title, description, columns, widths, data, height, tableName) {
  const tab = book.worksheets.add(name);
  tab.showGridLines = false;
  tab.tabColor = teal;
  const last = col(columns.length-1);
  for (const [index,width] of widths.entries()) {
    const c=col(index);
    tab.getRange(c+'1:'+c+(data.length+4)).format.columnWidth = width;
  }
  const band = (line, label, styling) => {
    const range = tab.getRange('A'+line+':'+last+line);
    range.merge();
    tab.getCell(line-1,0).values = [[label]];
    range.format = styling;
  };
  band(1,title,{fill:navy,font:{...fmt,size:19,bold:true,color:'#FFFFFF'},rowHeight:35,verticalAlignment:'center'});
  band(2,description,{fill:pale,font:fmt,rowHeight:31,verticalAlignment:'center',wrapText:true});
  tab.getRange('A3:'+last+'3').format.rowHeight = 9;
  const head=tab.getRange('A4:'+last+'4');
  head.values=[columns];
  head.format={fill:teal,font:{...fmt,bold:true,color:'#FFFFFF'},rowHeight:28,wrapText:true,verticalAlignment:'center'};
  if (data.length) {
    const body=tab.getRange('A5:'+last+(data.length+4));
    body.values=data;
    body.format={font:fmt,rowHeight:height,wrapText:true,verticalAlignment:'center'};
    for(let i=0;i<data.length;i+=2) tab.getRange('A'+(i+5)+':'+last+(i+5)).format.fill='#F1F6F8';
    if(tableName) {
      tab.tables.add('A4:'+last+(data.length+4),true,tableName).style='TableStyleMedium2';
    }
  }
  tab.freezePanes.freezeRows(4);
  return tab;
}
const m = sheet('Milestones','StudySearch roadmap milestones',
  'Parent rows roll up their work items. Use Summary for the grand total. The CSVs in the Admin repo hold the current entries.',
  ['Item','Parent','Topic','Module','Status','Owner','References','Next action','Direct min','Roll-up min','Roll-up hours'],
  [14,13,46,24,19,28,27,55,13,14,15],milestones.map(row=>[...row,null,null,null]),42,'RoadmapMilestones');
const l = sheet('Engagements','Human engagement ledger',
  'Melbourne time  |  15-minute minimum per human engagement  |  Counted minutes excludes superseded rows',
  ['Engagement ID','Occurred at','Item','Milestone','Module','Activity','Human minutes','Time basis','Session','Topic','Outcome','Next action','References','Related items','Supersedes ID','Counted minutes'],
  [40,27,13,13,25,17,15,15,21,44,55,44,36,18,38,16],engagements.map(row=>[...row,null]),48,'RoadmapEngagements');

const end = Math.max(10004,engagements.length+104);
const logColumn = c => "'Engagements'!$"+c+"$5:$"+c+"$"+end;
for(const [index] of engagements.entries()) {
  const n=index+5;
  l.getRange('P'+n).formulas=[['=IF(COUNTIF($O$5:$O$'+end+',A'+n+')>0,0,G'+n+')']];
}
for(const [index] of milestones.entries()) {
  const n=index+5;
  const direct = '=SUMIF('+logColumn('C')+',A'+n+','+logColumn('P')+')';
  const rollup = '=IF(B'+n+'="",SUMIF('+logColumn('D')+',A'+n+','+logColumn('P')+'),I'+n+')';
  m.getRange('I'+n+':K'+n).formulas=[[direct,rollup,'=J'+n+'/60']];
}
m.getRange('K5:K'+(milestones.length+4)).setNumberFormat('0.00');

const categories=['Planning','Development','Review','Decision','Acceptance','Handover'];
const summary = sheet('Summary','StudySearch human engagement',
  'Milestone and activity totals derived from the engagement ledger. Machine and waiting time are excluded.',
  ['Activity','Counted minutes','Hours'],
  [35,22,19],[['All engagements',null,null],...categories.map(x=>[x,null,null])],29);
summary.getRange('B5:C5').formulas=[['=SUM('+logColumn('P')+')','=B5/60']];
for(const [index] of categories.entries()) {
  const n=index+6;
  summary.getRange('B'+n+':C'+n).formulas=[['=SUMIF('+logColumn('F')+',A'+n+','+logColumn('P')+')','=B'+n+'/60']];
}
summary.getRange('A5:C5').format.fill='#CFEAE6';
summary.getRange('C5:C11').setNumberFormat('0.00');

sheet('Guide','Using the roadmap engagement register',
  'The workbook is a formatted view of the Admin repo CSVs.',
  ['Item','Instruction'],[25,105],[
    ['Current register','https://github.com/msinghbs-ai/coursefinder-admin/tree/main/docs/Roadmap/2026-01'],
    ['Refresh','Import both CSVs as UTF-8. Replace the data rows of the matching tables, retain and fill down the calculated columns, then refresh the totals.'],
    ['Milestones','Import the first eight fields and retain Direct min, Roll-up min and Roll-up hours.'],
    ['Engagements','Import the first 15 fields. Keep timestamps and IDs as text, human_minutes as a number and retain Counted minutes.'],
    ['Engagement minimum','Record the human-reported active duration with a minimum of 15 minutes. Use 15 minutes when duration is not supplied.'],
    ['Planning and development','A prompt request is Planning. A separate human request directing implementation is Development. Count each interaction once.'],
    ['Time basis','Minimum is the standard allowance. Reported comes from the human. Time spent by a machine or waiting is excluded.'],
    ['Corrections','Keep the prior row. Append a corrected row with Supersedes ID set to the old ID. The workbook excludes the prior row from totals.'],
    ['Large ledgers','Regenerate from the CSVs before exceeding 10,000 engagement rows in this template.'],
  ],33);

await fs.mkdir(path.dirname(output),{recursive:true});
book.recalculate();
await (await SpreadsheetFile.exportXlsx(book)).save(output);
if(preview) {
  const image=await book.render({sheetName:'Summary',range:'A1:C11',scale:1,format:'png'});
  await fs.writeFile(preview,new Uint8Array(await image.arrayBuffer()));
}
