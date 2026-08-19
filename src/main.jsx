import React, { useEffect, useMemo, useState } from 'react'
import { createRoot } from 'react-dom/client'
import { adminRead, invokeAdmin, supabase } from './supabase'
import './styles.css'

const NAV = [
  ['Overview', [['Dashboard',1]]],
  ['Catalogue', [['Providers',1],['Courses',1],['Campuses',1],['Completeness',1],['Scholarships',1]]],
  ['Governance', [['Evidence',3],['Review Queue',3]]],
  ['Operations', [['Jobs',4],['Sources',4]]],
  ['PIM', [['Attributes',5]]],
]

const TITLES = {
  Dashboard:'Operational overview', Providers:'Providers', Courses:'Courses', Campuses:'Campuses',
  Completeness:'Completeness & readiness', Scholarships:'Scholarships', Evidence:'Evidence & history',
  'Review Queue':'Review Queue', Jobs:'Pipeline Jobs', Sources:'Regulatory Sources', Attributes:'PIM Governance'
}

function App() {
  const [session,setSession]=useState(null)
  const [context,setContext]=useState(null)
  const [page,setPage]=useState('Dashboard')
  const [error,setError]=useState('')

  useEffect(()=>{
    supabase.auth.getSession().then(({data})=>setSession(data.session??null))
    const {data:sub}=supabase.auth.onAuthStateChange((_event,next)=>setSession(next))
    return ()=>sub.subscription.unsubscribe()
  },[])
  useEffect(()=>{
    if(!session){setContext(null);return}
    invokeAdmin('context').then(setContext).catch(e=>setError(e.message))
  },[session])

  if(!session) return <Login error={error} onError={setError}/>
  const rank=context?.role_rank??0
  return <div className="shell">
    <aside>
      <div className="brand"><span>CF</span><div><strong>Coursefinder</strong><small>PIM Admin v2.2</small></div></div>
      <nav>{NAV.map(([group,items])=>{
        const allowed=items.filter(([,min])=>rank>=min)
        if(!allowed.length)return null
        return <div className="nav-group" key={group}><small>{group}</small>{allowed.map(([item])=><button key={item} className={page===item?'active':''} onClick={()=>setPage(item)}>{item}</button>)}</div>
      })}</nav>
      <div className="account"><small>{context?.role??'loading...'}</small><div>{context?.user?.email??session.user.email}</div><button onClick={()=>supabase.auth.signOut()}>Sign out</button></div>
    </aside>
    <main>
      <header><div><h1>{TITLES[page]??page}</h1><p>Governed canonical catalogue, evidence and PIM operations</p></div><span className="pill">{context?.role??'...'}</span></header>
      {error&&<div className="alert">{error}<button onClick={()=>setError('')}>×</button></div>}
      <Page page={page} rank={rank} onError={setError}/>
    </main>
  </div>
}

function Login({error,onError}){
  const [email,setEmail]=useState(''),[password,setPassword]=useState(''),[busy,setBusy]=useState(false)
  async function submit(e){e.preventDefault();setBusy(true);onError('');const {error:x}=await supabase.auth.signInWithPassword({email,password});if(x)onError(x.message);setBusy(false)}
  return <div className="login-wrap"><form className="login-card" onSubmit={submit}><div className="logo">CF</div><h1>Coursefinder PIM</h1><p>Authorised staff access only.</p>{error&&<div className="alert">{error}</div>}<label>Email<input type="email" value={email} onChange={e=>setEmail(e.target.value)} required/></label><label>Password<input type="password" value={password} onChange={e=>setPassword(e.target.value)} required/></label><button className="primary" disabled={busy}>{busy?'Signing in…':'Sign in'}</button></form></div>
}

function Page({page,rank,onError}){
  if(page==='Dashboard')return <Dashboard onError={onError}/>
  if(page==='Providers')return <EntityList operation="providers" detailOperation="provider_detail" type="provider" onError={onError}/>
  if(page==='Courses')return <EntityList operation="courses" detailOperation="course_detail" type="course" onError={onError}/>
  if(page==='Campuses')return <EntityList operation="campuses" detailOperation="campus_detail" type="campus" onError={onError}/>
  if(page==='Completeness')return <Completeness onError={onError}/>
  if(page==='Scholarships')return <EntityList operation="scholarships" detailOperation="scholarship_detail" type="scholarship" onError={onError}/>
  if(page==='Evidence'&&rank>=3)return <SimpleList operation="evidence" onError={onError}/>
  if(page==='Review Queue'&&rank>=3)return <SimpleList operation="reviews" onError={onError}/>
  if(page==='Jobs'&&rank>=4)return <SimpleList operation="jobs" onError={onError}/>
  if(page==='Sources'&&rank>=4)return <SimpleList operation="sources" onError={onError}/>
  if(page==='Attributes'&&rank>=5)return <Attributes onError={onError}/>
  return <section className="panel"><p>This role is not authorised for the selected workspace.</p></section>
}

function useRead(operation,args,onError){
  const [data,setData]=useState(null),[busy,setBusy]=useState(true)
  useEffect(()=>{let live=true;setBusy(true);adminRead(operation,args).then(x=>{if(live)setData(x)}).catch(e=>onError(e.message)).finally(()=>{if(live)setBusy(false)});return()=>{live=false}},[operation,JSON.stringify(args),onError])
  return [data,busy]
}

function Dashboard({onError}){
  const [data,busy]=useRead('dashboard',{},onError)
  if(busy)return <Loading/>
  const cards=[['Providers',data?.providers],['Courses',data?.courses],['Campuses',data?.campuses],['Scholarships',data?.scholarships],['Jobs',data?.jobs],['Open reviews',data?.open_reviews],['Evidence',data?.evidence],['Attributes',data?.attributes]]
  return <><div className="cards">{cards.map(([k,v])=><section className="metric" key={k}><small>{k}</small><strong>{v??'—'}</strong></section>)}</div><section className="panel"><h2>Admin security boundary</h2><p>Browser reads use the governed <code>admin_read</code> RPC. Internal catalogue, pipeline, scholarship and PIM schemas remain closed behind RLS and explicit role checks.</p></section></>
}

function EntityList({operation,detailOperation,type,onError}){
  const [rows,busy]=useRead(operation,{limit:type==='course'?2000:1000},onError)
  const [q,setQ]=useState(''),[selected,setSelected]=useState(null),[detail,setDetail]=useState(null),[detailBusy,setDetailBusy]=useState(false)
  const list=Array.isArray(rows)?rows:[]
  const filtered=useMemo(()=>list.filter(r=>JSON.stringify(r).toLowerCase().includes(q.toLowerCase())),[list,q])
  async function open(row){const id=row.course_id??row.id;setSelected(id);setDetailBusy(true);try{setDetail(await adminRead(detailOperation,{id}))}catch(e){onError(e.message)}finally{setDetailBusy(false)}}
  if(busy)return <Loading/>
  return <><section className="panel"><div className="toolbar"><input placeholder={`Search ${type}s`} value={q} onChange={e=>setQ(e.target.value)}/><span>{filtered.length} shown</span></div><div className="table-wrap"><table><thead><tr>{columnsFor(type).map(c=><th key={c.key}>{c.label}</th>)}</tr></thead><tbody>{filtered.map((r,i)=><tr key={r.course_id??r.id??i} className={selected===(r.course_id??r.id)?'selected-row':''} onClick={()=>open(r)}>{columnsFor(type).map(c=><td key={c.key}>{renderCell(r,c.key,type)}</td>)}</tr>)}</tbody></table></div></section>{selected&&<Detail type={type} data={detail} busy={detailBusy} onClose={()=>{setSelected(null);setDetail(null)}}/>}</>
}

function columnsFor(type){
  if(type==='provider')return [{key:'canonical_name',label:'Provider'},{key:'country_code',label:'Country'},{key:'city',label:'City'},{key:'lifecycle_status',label:'Lifecycle'},{key:'publication_status',label:'Publication'},{key:'course_count',label:'Courses'}]
  if(type==='course')return [{key:'canonical_title',label:'Course'},{key:'provider_name',label:'Provider'},{key:'level_code',label:'Level'},{key:'field_of_study',label:'Field'},{key:'fee_amount',label:'Registered fee'},{key:'completeness_score_v2',label:'Complete'}]
  if(type==='campus')return [{key:'name',label:'Campus'},{key:'provider_name',label:'Provider'},{key:'country_code',label:'Country'},{key:'city',label:'City'},{key:'status',label:'Status'},{key:'course_count',label:'Courses'}]
  return [{key:'name',label:'Scholarship'},{key:'provider_name',label:'Provider'},{key:'scholarship_type',label:'Type'},{key:'audience',label:'Audience'},{key:'award_value_text',label:'Award'},{key:'publication_status',label:'Publication'}]
}
function renderCell(r,key,type){
  const v=r[key]
  if(key==='canonical_name'||key==='canonical_title'||key==='name')return <b>{v??'—'}</b>
  if(key==='fee_amount')return v?`${r.fee_currency??''} ${Number(v).toLocaleString()}`:'—'
  if(key==='completeness_score_v2')return <Score value={v??r.completeness_score}/>
  return v===null||v===undefined||v===''?'—':String(v)
}

function Detail({type,data,busy,onClose}){
  return <section className="panel detail-panel"><div className="toolbar"><div><small>{type.toUpperCase()} DETAIL</small><h2>{detailTitle(type,data)}</h2></div><button onClick={onClose}>Close</button></div>{busy?<Loading/>:!data?<p>No detail returned.</p>:type==='course'?<CourseDetail data={data}/>:type==='scholarship'?<ScholarshipDetail data={data}/>:<GenericDetail data={data}/>}</section>
}
function detailTitle(type,d){return type==='provider'?d?.canonical_name:type==='course'?d?.canonical_title:type==='campus'?d?.name:d?.name}

function CourseDetail({data}){
  const fees=data?.fee_summary??{}, cricos=fees.cricos_registered??[], provider=fees.provider_current??[]
  return <div className="detail-stack">
    <div className="detail-grid"><KV label="Stable key" value={data.stable_key}/><KV label="Provider" value={data.provider_name}/><KV label="CRICOS / course code" value={data.course_code}/><KV label="Lifecycle" value={data.lifecycle_status}/><KV label="Publication" value={data.publication_status}/><KV label="Last verified" value={fmtDate(data.last_verified_at)}/></div>
    <div className="fee-grid"><section className="fee-card"><small>REGULATORY</small><h3>CRICOS registered course cost</h3><p>Registered total-course fee facts from CRICOS. These are not annualised and are not a substitute for the provider's current published fee.</p><FeeRows rows={cricos}/></section><section className="fee-card"><small>PROVIDER-CURRENT</small><h3>Current Provider fee</h3><p>Provider-published fee observations retain their fee year, basis, campus/intake scope and evidence separately from CRICOS.</p>{provider.length?<FeeRows rows={provider}/>:<div className="empty-note">No current Provider fee evidence loaded. CRICOS values are deliberately not substituted.</div>}</section></div>
    <Section title="Regulatory facts" value={data.regulatory_facts}/><Section title="Campuses" value={data.campuses}/><Section title="Evidence & history" value={data.evidence}/><Section title="Canonical detail" value={strip(data,['fee_summary','regulatory_facts','campuses','evidence'])}/>
  </div>
}
function FeeRows({rows}){return <div className="mini-list">{rows.map((r,i)=><div key={r.id??i}><b>{r.fee_type?.replaceAll('_',' ')}</b><span>{r.currency} {Number(r.amount??0).toLocaleString()}</span><small>{[r.basis,r.fee_year,r.audience].filter(Boolean).join(' · ')}</small></div>)}</div>}

function ScholarshipDetail({data}){
  const known=['identifiers','offering_cycles','application_windows','scopes','criterion_groups','criteria','award_tiers','coverage','evidence']
  return <div className="detail-stack"><div className="detail-grid"><KV label="Provider" value={data.provider_name}/><KV label="Type" value={data.type??data.scholarship_type}/><KV label="Audience" value={data.audience}/><KV label="Lifecycle" value={data.lifecycle_status}/><KV label="Publication" value={data.publication_status}/><KV label="Source" value={data.source_url}/></div>{known.map(k=>data[k]!==undefined&&<Section key={k} title={k.replaceAll('_',' ')} value={data[k]}/>)}<Section title="Scholarship record" value={strip(data,known)}/></div>
}
function GenericDetail({data}){return <div className="detail-stack"><div className="detail-grid">{Object.entries(data).filter(([,v])=>!Array.isArray(v)&&!(v&&typeof v==='object')).slice(0,12).map(([k,v])=><KV key={k} label={k.replaceAll('_',' ')} value={fmt(v)}/>)}</div>{Object.entries(data).filter(([,v])=>Array.isArray(v)||(v&&typeof v==='object')).map(([k,v])=><Section key={k} title={k.replaceAll('_',' ')} value={v}/>)}</div>}

function Completeness({onError}){
  const [rows,busy]=useRead('completeness',{limit:2000},onError)
  if(busy)return <Loading/>
  const list=Array.isArray(rows)?rows:[]
  const core=r=>['has_registration','has_structure','has_fee','has_intake','has_english','has_description'].every(k=>Boolean(r[k]))
  const ready=list.filter(core).length
  return <><div className="cards"><section className="metric"><small>Core-ready</small><strong>{list.length?Math.round(ready/list.length*100):0}%</strong></section><section className="metric"><small>Needs enrichment</small><strong>{list.length-ready}</strong></section><section className="metric"><small>Loaded courses</small><strong>{list.length}</strong></section></div><section className="panel"><h2>Operational readiness</h2><p>“Core-ready” means the governed completeness signals for registration, structure, fee, intake, English and description are all present. It does not by itself publish a course to Search.</p><div className="table-wrap"><table><thead><tr><th>Course</th><th>Provider</th><th>Score</th><th>Readiness</th><th>Missing</th></tr></thead><tbody>{list.sort((a,b)=>(a.completeness_score_v2??0)-(b.completeness_score_v2??0)).slice(0,1000).map(r=><tr key={r.course_id}><td><b>{r.canonical_title}</b></td><td>{r.provider_name}</td><td><Score value={r.completeness_score_v2}/></td><td><span className="pill">{core(r)?'Core-ready':'Needs enrichment'}</span></td><td>{['registration','structure','fee','intake','english','description'].filter(x=>!r[`has_${x}`]).join(', ')||'—'}</td></tr>)}</tbody></table></div></section></>
}

function SimpleList({operation,onError}){
  const [rows,busy]=useRead(operation,{limit:1000},onError)
  if(busy)return <Loading/>
  const list=Array.isArray(rows)?rows:[]
  if(!list.length)return <section className="panel"><p>No records.</p></section>
  const keys=Object.keys(list[0]).filter(k=>!['metadata','source_metadata','system_config'].includes(k)).slice(0,9)
  return <section className="panel"><div className="table-wrap"><table><thead><tr>{keys.map(k=><th key={k}>{k.replaceAll('_',' ')}</th>)}</tr></thead><tbody>{list.map((r,i)=><tr key={r.id??r.source_id??i}>{keys.map(k=><td key={k} className="truncate">{fmt(r[k])}</td>)}</tr>)}</tbody></table></div></section>
}

function Attributes({onError}){
  const [data,busy]=useRead('attributes',{limit:2000},onError)
  if(busy)return <Loading/>
  return <div className="detail-stack"><div className="cards">{[['Families',data?.families?.length],['Groups',data?.groups?.length],['Attributes',data?.attributes?.length],['Options',data?.options?.length],['Completeness profiles',data?.completeness_profiles?.length]].map(([k,v])=><section className="metric" key={k}><small>{k}</small><strong>{v??0}</strong></section>)}</div><Section title="Completeness profiles" value={data?.completeness_profiles}/><Section title="Attribute families" value={data?.families}/><Section title="Attribute groups" value={data?.groups}/><Section title="Attributes" value={data?.attributes}/></div>
}

function Section({title,value}){if(value===undefined||value===null)return null;return <section className="subpanel"><h3>{title}</h3>{Array.isArray(value)?<JsonTable rows={value}/>:typeof value==='object'?<JsonTable rows={[value]}/>:<p>{String(value)}</p>}</section>}
function JsonTable({rows}){if(!rows?.length)return <div className="empty-note">No records.</div>;const keys=[...new Set(rows.flatMap(r=>Object.keys(r??{})))].slice(0,10);return <div className="table-wrap"><table><thead><tr>{keys.map(k=><th key={k}>{k.replaceAll('_',' ')}</th>)}</tr></thead><tbody>{rows.map((r,i)=><tr key={r?.id??i}>{keys.map(k=><td key={k} className="truncate">{fmt(r?.[k])}</td>)}</tr>)}</tbody></table></div>}
function KV({label,value}){return <div className="kv"><small>{label}</small><strong>{value??'—'}</strong></div>}
function Score({value}){const n=Math.round(Number(value??0));return <span className="score"><b>{n}%</b><i style={{width:`${Math.max(0,Math.min(100,n))}%`}}/></span>}
function Loading(){return <section className="panel"><p>Loading…</p></section>}
function fmt(v){if(v===null||v===undefined||v==='')return '—';if(typeof v==='object')return JSON.stringify(v);return String(v)}
function fmtDate(v){return v?new Date(v).toLocaleString():'—'}
function strip(obj,keys){return Object.fromEntries(Object.entries(obj??{}).filter(([k])=>!keys.includes(k)))}

createRoot(document.getElementById('root')).render(<React.StrictMode><App/></React.StrictMode>)
