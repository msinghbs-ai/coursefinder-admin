import React, {useCallback, useEffect, useMemo, useRef, useState} from 'react'
import {createRoot} from 'react-dom/client'
import {adminRead, invokeAdmin, supabase} from './supabase'
import CourseSemanticDetail from './CourseSemanticDetail'
import CourseStatePanel from './CourseStatePanel'
import ScholarshipSemanticDetail from './ScholarshipSemanticDetail'
import './styles.css'
import './finalisation.css'

const UI_VERSION='2.10.0'
const PAGE_SIZE=50
const AU_TZ='Australia/Sydney'

const ROUTES=[
  {section:'Overview',slug:'dashboard',label:'Dashboard',min:1,icon:'⌂',title:'Operational overview'},
  {section:'Catalogue',slug:'providers',label:'Providers',min:1,icon:'P',title:'Providers'},
  {section:'Catalogue',slug:'courses',label:'Courses',min:1,icon:'C',title:'Courses'},
  {section:'Catalogue',slug:'campuses',label:'Campuses',min:1,icon:'L',title:'Campuses'},
  {section:'PIM Configuration',slug:'attributes',label:'Attributes',min:5,icon:'A',title:'PIM attributes & completeness configuration'},
  {section:'Enrichment & Insights',slug:'qilt',label:'Outcomes (QILT)',min:1,icon:'Q',title:'QILT outcomes'},
  {section:'Enrichment & Insights',slug:'prisms',label:'Student Flow (PRISMS)',min:1,icon:'F',title:'PRISMS student flow'},
  {section:'Data Quality',slug:'completeness',label:'Completeness',min:1,icon:'%',title:'Completeness & readiness'},
  {section:'Data Quality',slug:'reviews',label:'Review Queue',min:3,icon:'R',title:'Review Queue'},
  {section:'Evidence',slug:'evidence',label:'Evidence',min:3,icon:'E',title:'Evidence & history'},
  {section:'Pipelines & Jobs',slug:'pipeline',label:'Pipeline Control',min:4,icon:'↻',title:'Pipeline control'},
  {section:'Pipelines & Jobs',slug:'jobs',label:'Jobs',min:4,icon:'J',title:'Pipeline Jobs'},
  {section:'Pipelines & Jobs',slug:'sources',label:'Sources',min:4,icon:'S',title:'Sources & health'},
  {section:'Scholarships',slug:'scholarships',label:'Scholarships',min:1,icon:'$',title:'Scholarships'},
  {section:'Search & Publication',slug:'publication',label:'Search / Publication',min:1,icon:'⌕',title:'Search & publication readiness'},
]
const ROUTE_MAP=Object.fromEntries(ROUTES.map(r=>[r.slug,r]))
const COURSE_LIFECYCLE=['active','inactive','suspended','unknown']
const STATUS_STYLE={active:'good',current:'good',completed:'good',published:'good',healthy:'good',failed:'bad',blocked:'bad',unhealthy:'bad',running:'warn',pending:'warn',draft:'warn'}

function App(){
  const [session,setSession]=useState(null)
  const [context,setContext]=useState(null)
  const [authError,setAuthError]=useState('')
  const [routeVersion,setRouteVersion]=useState(0)
  const [navOpen,setNavOpen]=useState(false)
  const route=readRoute()

  useEffect(()=>{
    supabase.auth.getSession().then(({data})=>setSession(data.session??null))
    const {data:sub}=supabase.auth.onAuthStateChange((_e,next)=>setSession(next))
    return()=>sub.subscription.unsubscribe()
  },[])
  useEffect(()=>{
    if(!session){setContext(null);return}
    const controller=new AbortController()
    invokeAdmin('context',{}, {signal:controller.signal}).then(setContext).catch(e=>{if(e?.name!=='AbortError')setAuthError(e.message)})
    return()=>controller.abort()
  },[session])
  useEffect(()=>{
    history.scrollRestoration='manual'
    const onPop=()=>{setRouteVersion(v=>v+1);setNavOpen(false);requestAnimationFrame(()=>window.scrollTo(0,history.state?.scrollY??0))}
    window.addEventListener('popstate',onPop)
    return()=>window.removeEventListener('popstate',onPop)
  },[])
  void routeVersion

  if(!session)return <Login error={authError} onError={setAuthError}/>
  if(!context)return <div className="boot"><SkeletonLines rows={7}/><p>Loading governed role context…</p></div>
  const rank=Number(context.role_rank??0)
  const current=(ROUTE_MAP[route.view]&&rank>=ROUTE_MAP[route.view].min)?ROUTE_MAP[route.view]:ROUTES.find(r=>r.slug==='dashboard')

  const go=(view,patch={},opts={})=>{
    history.replaceState({...history.state,scrollY:window.scrollY},'')
    const u=new URL(location.href);u.searchParams.set('view',view)
    for(const key of [...u.searchParams.keys()])if(key!=='view')u.searchParams.delete(key)
    Object.entries(patch).forEach(([k,v])=>setUrlValue(u.searchParams,k,v))
    history[opts.replace?'replaceState':'pushState']({scrollY:0},'',u)
    setRouteVersion(v=>v+1);setNavOpen(false);window.scrollTo(0,0)
  }
  const patch=(values,{push=false}={})=>{
    const u=new URL(location.href)
    Object.entries(values).forEach(([k,v])=>setUrlValue(u.searchParams,k,v))
    history.replaceState({...history.state,scrollY:window.scrollY},'',u)
    if(push)history.pushState({scrollY:0},'',u)
    setRouteVersion(v=>v+1)
  }

  return <div className="op-shell">
    <aside className={`op-sidebar ${navOpen?'open':''}`}>
      <div className="op-brand"><span>CF</span><div><strong>CourseFinder</strong><small>PIM Admin v{UI_VERSION}</small></div></div>
      <nav>{groupRoutes(rank).map(([section,items])=><div className="op-nav-group" key={section}><small>{section}</small>{items.map(item=><button key={item.slug} className={current.slug===item.slug?'active':''} onClick={()=>go(item.slug)}><i>{item.icon}</i><span>{item.label}</span></button>)}</div>)}</nav>
      <div className="op-account"><span className="role-chip">{humanise(context.role)}</span><small>{context.user?.email??session.user.email}</small><button onClick={()=>supabase.auth.signOut()}>Sign out</button></div>
    </aside>
    <main className="op-main">
      <header className="op-header"><button className="menu-button" onClick={()=>setNavOpen(x=>!x)} aria-label="Toggle navigation">☰</button><div><h1>{current.title}</h1><p>Governed operational catalogue · browser state persisted in the URL</p></div><div className="header-meta"><span className="role-chip">{humanise(context.role)}</span><span className="version-chip">v{UI_VERSION}</span></div></header>
      <Page route={current} params={route.params} rank={rank} patch={patch} go={go}/>
    </main>
    {navOpen&&<button className="nav-scrim" aria-label="Close navigation" onClick={()=>setNavOpen(false)}/>} 
  </div>
}

function Login({error,onError}){
  const [email,setEmail]=useState(''),[password,setPassword]=useState(''),[busy,setBusy]=useState(false)
  async function submit(e){e.preventDefault();if(busy)return;setBusy(true);onError('');const {error:x}=await supabase.auth.signInWithPassword({email,password});if(x)onError(x.message);setBusy(false)}
  return <div className="login-wrap"><form className="login-card" onSubmit={submit}><div className="logo">CF</div><h1>CourseFinder PIM</h1><p>Authorised staff access only. <span className="ui-version">PIM Admin v{UI_VERSION}</span></p>{error&&<InlineError message={error}/>}<label>Email<input type="email" autoComplete="username" value={email} onChange={e=>setEmail(e.target.value)} required/></label><label>Password<input type="password" autoComplete="current-password" value={password} onChange={e=>setPassword(e.target.value)} required/></label><button className="primary" disabled={busy}>{busy?'Signing in…':'Sign in'}</button></form></div>
}

function Page({route,params,rank,patch,go}){
  if(rank<route.min)return <PermissionState/>
  if(route.slug==='dashboard')return <Dashboard/>
  if(['providers','courses','campuses','scholarships'].includes(route.slug))return <EntityList type={route.slug.slice(0,-1)} params={params} patch={patch} go={go}/>
  if(route.slug==='attributes')return <Attributes/>
  if(route.slug==='qilt')return <Qilt params={params} patch={patch} go={go}/>
  if(route.slug==='prisms')return <Prisms params={params} patch={patch}/>
  if(route.slug==='completeness')return <Completeness params={params} patch={patch} go={go}/>
  if(route.slug==='reviews')return <Reviews params={params} patch={patch}/>
  if(route.slug==='evidence')return <Evidence params={params} patch={patch}/>
  if(route.slug==='pipeline')return <PipelineOverview go={go}/>
  if(route.slug==='jobs')return <Jobs params={params} patch={patch}/>
  if(route.slug==='sources')return <Sources params={params} patch={patch}/>
  if(route.slug==='publication')return <Publication/>
  return <EmptyState title="Workspace unavailable" detail="No governed route is attached to this menu entry."/>
}

function useAdmin(operation,args={},deps=[]){
  const [state,setState]=useState({data:null,busy:true,error:null})
  const [retry,setRetry]=useState(0)
  const key=JSON.stringify(args)
  useEffect(()=>{
    const controller=new AbortController();let active=true
    setState(s=>({...s,busy:true,error:null}))
    adminRead(operation,args,{signal:controller.signal}).then(data=>{if(active)setState({data,busy:false,error:null})}).catch(error=>{if(active&&error?.name!=='AbortError'&&!controller.signal.aborted)setState(s=>({...s,busy:false,error}))})
    return()=>{active=false;controller.abort()}
  },[operation,key,retry,...deps])
  return {...state,retry:()=>setRetry(x=>x+1)}
}
function useDebounced(value,delay=280){const [v,setV]=useState(value);useEffect(()=>{const t=setTimeout(()=>setV(value),delay);return()=>clearTimeout(t)},[value,delay]);return v}

function Dashboard(){
  const a=useAdmin('dashboard',{})
  if(a.busy&&!a.data)return <PageSkeleton cards={8}/>
  if(a.error)return <InlineError message={a.error.message} onRetry={a.retry}/>
  const d=a.data??{}
  const cards=[['Providers',d.providers],['Courses',d.courses],['Campuses',d.campuses],['Scholarships',d.scholarships],['Jobs',d.jobs],['Open reviews',d.open_reviews],['Evidence',d.evidence],['Attributes',d.attributes]]
  return <><MetricGrid items={cards}/><section className="op-panel"><div className="panel-heading"><div><h2>Operational boundary</h2><p>Browser reads are routed through governed RPCs. Internal schemas remain non-browser CRUD surfaces.</p></div><StatusPill value="governed"/></div><div className="callout-grid"><InfoCard title="Catalogue scale" text="Course lists use server paging and filtering. The browser requests only the current page, not the full catalogue."/><InfoCard title="State model" text="Canonical lifecycle, Admin readiness, Search admission and channel publication remain independent states."/><InfoCard title="Navigation state" text="Filters, page, sort and detail identifiers live in browser history so Back/Forward restores operational context."/></div></section></>
}

const ENTITY={
  provider:{plural:'Providers',op:'providers_page',detail:'provider_detail',sort:'provider',search:'Provider name, CRICOS Provider code, stable key or location',cols:[['canonical_name','Provider','provider',300],['stable_key','Stable identity',null,240],['country_code','Country',null,90],['city','City',null,150],['lifecycle_status','Lifecycle',null,115],['publication_status','Publication',null,130],['course_count','Courses','courses',90]]},
  course:{plural:'Courses',op:'courses_page',detail:'course_detail',sort:'course',search:'Course, Provider, exact CRICOS/course code or stable key',cols:[['canonical_title','Course','course',310],['provider_name','Provider','provider',240],['course_code','CRICOS / Course code',null,160],['level_name','Study level',null,160],['field_of_study','Field','field',190],['fee_amount','CRICOS tuition (total course)','fee',190],['completeness_score_v2','Admin readiness','completeness',135],['lifecycle_status','Lifecycle',null,110],['publication_status','Canonical publication',null,155],['search_projected','Search',null,150]]},
  campus:{plural:'Campuses',op:'campuses_page',detail:'campus_detail',sort:'campus',search:'Campus, Provider, code, city or stable key',cols:[['name','Campus','campus',260],['provider_name','Provider','provider',270],['stable_key','Stable identity',null,220],['country_code','Country',null,90],['city','City','city',150],['status','Status',null,110],['course_count','Courses','courses',90]]},
  scholarship:{plural:'Scholarships',op:'scholarships_page',detail:'scholarship_detail',sort:'scholarship',search:'Scholarship, Provider or stable key',cols:[['name','Scholarship','scholarship',310],['provider_name','Provider',null,250],['stable_key','Stable identity',null,220],['scholarship_type','Type',null,170],['audience','Audience',null,130],['award_value_text','Award',null,190],['publication_status','Publication',null,130]]},
}
function EntityList({type,params,patch,go}){
  const cfg=ENTITY[type]
  const q=params.q??'', debounced=useDebounced(q)
  const page=Math.max(1,num(params.p,1)), sort=params.sort??cfg.sort, dir=params.dir==='desc'?'desc':'asc'
  const args={limit:PAGE_SIZE,offset:(page-1)*PAGE_SIZE,query:debounced||null,sort,direction:dir}
  if(type==='course'&&params.lifecycle)args.lifecycle_status=params.lifecycle
  if(type==='course'&&params.country)args.country_code=params.country
  if(type==='course'&&params.region)args.subdivision_code=params.region
  const a=useAdmin(cfg.op,args)
  const total=Number(a.data?.total??0),rows=a.data?.items??[]
  const detailId=params.detail
  const changeSort=(key)=>{if(!key)return;patch({sort:key,dir:sort===key&&dir==='asc'?'desc':'asc',p:1})}
  const open=(r)=>patch({detail:r.id??r.course_id},{push:true})
  return <>
    <section className="op-panel list-panel">
      <div className="toolbar sticky-toolbar"><div className="filter-row"><label className="search-box"><span>⌕</span><input value={q} placeholder={cfg.search} onChange={e=>patch({q:e.target.value,p:1})}/></label>{type==='course'&&<><Select label="Lifecycle" value={params.lifecycle??''} options={COURSE_LIFECYCLE.map(x=>({value:x,label:humanise(x)}))} onChange={v=>patch({lifecycle:v,p:1})}/><label className="compact-field">Country<input value={params.country??''} placeholder="AU" maxLength={2} onChange={e=>patch({country:e.target.value.toUpperCase(),p:1})}/></label><label className="compact-field">Region<input value={params.region??''} placeholder="AU-VIC" onChange={e=>patch({region:e.target.value.toUpperCase(),p:1})}/></label></>}</div><ListMeta busy={a.busy} total={total} page={page}/></div>
      {a.error?<InlineError message={a.error.message} onRetry={a.retry}/>:a.busy&&!a.data?<TableSkeleton columns={cfg.cols.length}/>:rows.length?<DataTable id={`entity-${type}`} columns={cfg.cols} rows={rows} sort={sort} dir={dir} onSort={changeSort} onRow={open} render={(r,k)=>entityCell(type,r,k)}/>:<EmptyState title={`No ${cfg.plural.toLowerCase()} found`} detail="Adjust the server-side search or filters. No rows are hidden by client-side filtering."/>}
      <Pager total={total} page={page} onPage={p=>patch({p})}/>
    </section>
    {detailId&&<EntityDetail type={type} id={detailId} onClose={()=>history.back()} go={go}/>} 
  </>
}
function entityCell(type,r,k){
  const v=r[k]
  if(['canonical_name','canonical_title','name'].includes(k))return <strong>{v??'—'}</strong>
  if(k==='stable_key'||k==='course_code')return v?<code>{v}</code>:'—'
  if(k==='country_code')return country(v)
  if(k==='fee_amount')return v===null||v===undefined?'—':money(v,r.fee_currency??r.currency_code)
  if(k==='completeness_score_v2')return <Score value={v??r.completeness_score}/>
  if(k==='search_projected')return <StatusPill value={v?'projected':'not projected'} tone={v?'good':'neutral'}/>
  if(k.includes('status')||k==='status')return <StatusPill value={v}/>
  return formatValue(v)
}

function EntityDetail({type,id,onClose,go}){
  const cfg=ENTITY[type],a=useAdmin(cfg.detail,{id})
  return <div className="drawer-backdrop" onMouseDown={e=>{if(e.target===e.currentTarget)onClose()}}><aside className="op-drawer" aria-label={`${humanise(type)} detail`}><div className="drawer-head"><div><small>{humanise(type)} detail</small><h2>{detailTitle(type,a.data)}</h2></div><button onClick={onClose}>×</button></div><div className="drawer-body">{a.error?<InlineError message={a.error.message} onRetry={a.retry}/>:a.busy&&!a.data?<PageSkeleton cards={4}/>:<DetailBody type={type} data={a.data??{}} go={go}/>}</div></aside></div>
}
function DetailBody({type,data,go}){
  if(type==='course')return <div className="detail-stack"><StickyIdentity title={data.canonical_title??data.display_title} code={data.course_code} status={data.lifecycle_status}/><CourseStatePanel data={data}/><CourseSemanticDetail data={data}/></div>
  if(type==='scholarship')return <div className="detail-stack"><StickyIdentity title={data.name} code={data.stable_key} status={data.lifecycle_status}/><ScholarshipSemanticDetail data={data}/></div>
  if(type==='provider')return <ProviderDetail data={data} go={go}/>
  if(type==='campus')return <CampusDetail data={data} go={go}/>
  return <JsonSummary value={data}/>
}
function ProviderDetail({data,go}){
  const courses=data.courses_page?.items??data.courses??[], campuses=data.campuses_page?.items??[], evidence=data.evidence_page?.items??data.evidence??[]
  return <div className="detail-stack"><StickyIdentity title={data.display_name??data.canonical_name} code={data.stable_key} status={data.lifecycle_status}/><Section title="Identity & lifecycle"><KVGrid rows={pickPairs(data,[['Stable identity','stable_key'],['Canonical name','canonical_name'],['Display name','display_name'],['Lifecycle','lifecycle_status'],['Publication','publication_status'],['Last verified','last_verified_at']])}/></Section><Section title="Regulatory identity"><ObjectRows rows={data.identifiers??[]} empty="No governed Provider identifiers recorded."/><ObjectRows rows={data.registrations??[]} empty="No Provider registration rows recorded."/></Section><Section title="Geography & delivery"><KVGrid rows={pickPairs(data,[['Country','country_name'],['Country code','country_code'],['City','city'],['Course count','course_count'],['Campus count','campus_count'],['Scholarships','scholarship_count']])}/><RelatedRows rows={campuses} titleKey="name" metaKeys={['subdivision_name','city','course_count']} onClick={r=>go('campuses',{detail:r.id})}/></Section><Section title={`Related Courses · ${data.courses_page?.total??data.course_count??courses.length}`}><RelatedRows rows={courses} titleKey="canonical_title" metaKeys={['course_code','lifecycle_status','publication_status']} onClick={r=>go('courses',{detail:r.id})}/></Section><Section title="Evidence & source history"><EvidenceRows rows={evidence}/></Section><Section title="Record history"><KVGrid rows={pickPairs(data.history??data,[['Created','created_at'],['Updated','updated_at'],['Last verified','last_verified_at']])}/><p className="semantic-note">These timestamps and evidence lineage are the available record-history signals. No synthetic change-log entries are inferred.</p></Section></div>
}
function CampusDetail({data,go}){
  const courses=data.courses_page?.items??[]
  return <div className="detail-stack"><StickyIdentity title={data.name} code={data.stable_key} status={data.status}/><Section title="Identity & lifecycle"><KVGrid rows={pickPairs(data,[['Stable identity','stable_key'],['Campus code','campus_code'],['Provider','provider_name'],['Status','status'],['Publication','publication_status'],['Last verified','last_verified_at']])}/></Section><Section title="Geography & delivery"><KVGrid rows={pickPairs(data,[['Country','country_name'],['Region','subdivision_name'],['City','city'],['Address','address_line1'],['Postcode','postcode'],['Latitude','latitude'],['Longitude','longitude'],['Website','website'],['Scholarships','scholarship_count']])}/></Section><Section title={`Related Courses · ${data.courses_page?.total??courses.length}`}><RelatedRows rows={courses} titleKey="canonical_title" metaKeys={['course_code','delivery_mode','lifecycle_status']} onClick={r=>go('courses',{detail:r.id})}/></Section><Section title="Evidence & source"><EvidenceRows rows={data.evidence??[]}/><KVGrid rows={objectPairs(data.source??{})}/></Section><Section title="Record history"><KVGrid rows={pickPairs(data,[['Created','created_at'],['Updated','updated_at'],['Valid from','valid_from'],['Valid to','valid_to']])}/></Section></div>
}

function Completeness({params,patch,go}){
  const q=params.q??'',debounced=useDebounced(q),page=Math.max(1,num(params.p,1))
  const args={limit:PAGE_SIZE,offset:(page-1)*PAGE_SIZE,query:debounced||null,sort:'course',direction:'asc'}
  const a=useAdmin('courses_page',args)
  const rows=a.data?.items??[],total=Number(a.data?.total??0)
  const cols=[['canonical_title','Course',null,320],['provider_name','Provider',null,250],['course_code','CRICOS / Course code',null,160],['completeness_score_v2','Admin readiness',null,135],['missing','Missing canonical signals',null,340],['search_projected','Search',null,140]]
  const render=(r,k)=>k==='missing'?missingSignals(r).join(', ')||'None':entityCell('course',r,k)
  return <><section className="op-panel"><div className="panel-heading"><div><h2>Canonical presence readiness</h2><p>Six Admin signals only: registration, structure, fee, intake, English and description. This is not approval or Search publication.</p></div><StatusPill value="display-only" tone="neutral"/></div><div className="toolbar"><label className="search-box"><span>⌕</span><input value={q} placeholder="Search Course, Provider or CRICOS code" onChange={e=>patch({q:e.target.value,p:1})}/></label><ListMeta busy={a.busy} total={total} page={page}/></div>{a.error?<InlineError message={a.error.message} onRetry={a.retry}/>:a.busy&&!a.data?<TableSkeleton columns={6}/>:<DataTable id="completeness" columns={cols} rows={rows} onRow={r=>go('courses',{detail:r.id})} render={render}/>}<Pager total={total} page={page} onPage={p=>patch({p})}/></section><p className="page-note">Expensive catalogue-wide completeness ordering is intentionally not performed on initial load; the operational list stays bounded and each row retains its canonical readiness calculation.</p></>
}

function Evidence({params,patch}){
  const q=params.q??'',debounced=useDebounced(q),page=Math.max(1,num(params.p,1)),sort=params.sort??'captured',dir=params.dir==='asc'?'asc':'desc'
  const args={limit:PAGE_SIZE,offset:(page-1)*PAGE_SIZE,query:debounced||null,sort,direction:dir,source_id:params.source||null,evidence_type:params.type||null}
  const a=useAdmin('evidence_page',args), rows=a.data?.items??[],total=Number(a.data?.total??0),filters=a.data?.filters??{}
  const cols=[['evidence_type','Type','type',160],['source_label','Source','source',240],['entity_id','Entity ID',null,210],['content_hash','Content hash',null,220],['captured_at','Captured','captured',180],['valid_from','Valid from',null,130],['valid_to','Valid to',null,130],['source_url','Source URL',null,260]]
  return <section className="op-panel"><div className="toolbar sticky-toolbar"><div className="filter-row"><label className="search-box"><span>⌕</span><input value={q} placeholder="Evidence UUID, entity, source, hash, type or URL" onChange={e=>patch({q:e.target.value,p:1})}/></label><Select label="Type" value={params.type??''} options={(filters.evidence_types??[]).map(x=>({value:x.code,label:`${x.name} (${x.count})`}))} onChange={v=>patch({type:v,p:1})}/><Select label="Source" value={params.source??''} options={(filters.sources??[]).map(x=>({value:x.id,label:`${x.name} (${x.count})`}))} onChange={v=>patch({source:v,p:1})}/></div><ListMeta busy={a.busy} total={total} page={page}/></div>{a.error?<InlineError message={a.error.message} onRetry={a.retry}/>:a.busy&&!a.data?<TableSkeleton columns={8}/>:rows.length?<DataTable id="evidence" columns={cols} rows={rows} sort={sort} dir={dir} onSort={k=>patch({sort:k,dir:sort===k&&dir==='asc'?'desc':'asc',p:1})} render={(r,k)=>k==='source_url'?safeLink(r[k]):k.includes('_at')||k.startsWith('valid_')?fmtDate(r[k]):k.includes('id')||k==='content_hash'?<code>{r[k]??'—'}</code>:formatValue(r[k])}/>:<EmptyState title="No evidence matched" detail="Evidence filtering is server-side; no hidden local result set remains."/>}<Pager total={total} page={page} onPage={p=>patch({p})}/></section>
}

function Reviews({params,patch}){
  const q=params.q??'',debounced=useDebounced(q),page=Math.max(1,num(params.p,1))
  const a=useAdmin('reviews_page',{limit:PAGE_SIZE,offset:(page-1)*PAGE_SIZE,query:debounced||null,status:params.status||null,domain:params.domain||null,sort:params.sort??'priority',direction:params.dir??'desc'})
  const rows=a.data?.items??[],total=Number(a.data?.total??0),f=a.data?.filters??{}
  const cols=[['priority','Priority','priority',90],['domain','Domain',null,140],['field_code','Field',null,160],['entity_id','Entity',null,210],['status','Status','status',120],['reopen_reason','Reason',null,300],['assigned_to','Assigned',null,210],['created_at','Created','created',180]]
  return <section className="op-panel"><div className="toolbar"><div className="filter-row"><label className="search-box"><span>⌕</span><input value={q} placeholder="Review, entity, field or reason" onChange={e=>patch({q:e.target.value,p:1})}/></label><Select label="Status" value={params.status??''} options={(f.statuses??[]).map(x=>({value:x.code,label:`${x.name} (${x.count})`}))} onChange={v=>patch({status:v,p:1})}/><Select label="Domain" value={params.domain??''} options={(f.domains??[]).map(x=>({value:x.code,label:`${x.name} (${x.count})`}))} onChange={v=>patch({domain:v,p:1})}/></div><ListMeta busy={a.busy} total={total} page={page}/></div>{a.error?<InlineError message={a.error.message} onRetry={a.retry}/>:a.busy&&!a.data?<TableSkeleton columns={8}/>:rows.length?<DataTable id="reviews" columns={cols} rows={rows} render={genericCell}/>:<EmptyState title="Review Queue is empty" detail="No review records currently match the governed server filters."/>}<Pager total={total} page={page} onPage={p=>patch({p})}/></section>
}

function PipelineOverview({go}){
  const a=useAdmin('pipeline_overview',{})
  if(a.error)return <InlineError message={a.error.message} onRetry={a.retry}/>
  if(a.busy&&!a.data)return <PageSkeleton cards={6}/>
  const d=a.data??{},vol=d.observed_volumes??{}
  return <><MetricGrid items={[['Jobs',vol.jobs],['Sources',vol.sources],['Evidence',vol.evidence],['Claims',vol.claims],['Search documents',d.search_admission?.documents],['Review queue',d.layer4?.review_queue_total]]}/><section className="op-panel"><div className="panel-heading"><div><h2>Layer journey</h2><p>{(d.journey??[]).join(' → ')}</p></div><button className="secondary" onClick={()=>go('jobs')}>Open jobs</button></div><div className="layer-grid">{(d.layers??[]).map(x=><article className="layer-card" key={x.code}><div className="panel-heading"><div><small>{x.code}</small><h3>{x.name}</h3></div><StatusPill value={x.blocker?'attention':'operational'} tone={x.blocker?'warn':'good'}/></div><p>{humanise(x.authority)}</p><dl><dt>Sources</dt><dd>{formatValue(x.source_count)}</dd><dt>Jobs</dt><dd>{formatValue(x.job_count)}</dd><dt>Running</dt><dd>{formatValue(x.running_jobs)}</dd><dt>Failed</dt><dd>{formatValue(x.failed_jobs)}</dd><dt>Last success</dt><dd>{fmtDate(x.last_success_at)}</dd></dl>{x.blocker&&<p className="warning-note">{x.blocker}</p>}<small>{x.next_allowed_action}</small></article>)}</div></section></>
}

function Jobs({params,patch}){
  const q=params.q??'',debounced=useDebounced(q),page=Math.max(1,num(params.p,1)),detailId=params.job
  const filters=useAdmin('pipeline_filters',{})
  const a=useAdmin('pipeline_jobs_page',{limit:PAGE_SIZE,offset:(page-1)*PAGE_SIZE,query:debounced||null,status:params.status||null,job_type:params.type||null,layer:params.layer||null,mode:params.mode||null,country_code:params.country||null,failure_class:params.failure||null,completion_class:params.completion||null,sort:params.sort??'created',direction:params.dir??'desc'})
  const rows=a.data?.items??[],total=Number(a.data?.total??0),f=filters.data??{}
  const cols=[['layer_code','Layer','layer',80],['job_type','Job type','type',200],['source_label','Source',null,230],['country_code','Country',null,90],['run_mode','Mode',null,105],['status','Status','status',115],['completion_class','Completion',null,180],['failure_class','Failure class',null,160],['duration_ms','Duration','duration',110],['created_at','Created','created',180]]
  return <><section className="op-panel"><div className="toolbar sticky-toolbar"><div className="filter-row"><label className="search-box"><span>⌕</span><input value={q} placeholder="Job UUID, type, source, provider, worker or error" onChange={e=>patch({q:e.target.value,p:1})}/></label><Select label="Layer" value={params.layer??''} options={(f.layers??[]).map(x=>({value:x,label:x}))} onChange={v=>patch({layer:v,p:1})}/><Select label="Status" value={params.status??''} options={(f.statuses??[]).map(x=>({value:x,label:humanise(x)}))} onChange={v=>patch({status:v,p:1})}/><Select label="Type" value={params.type??''} options={(f.job_types??[]).map(x=>({value:x,label:humanise(x)}))} onChange={v=>patch({type:v,p:1})}/></div><ListMeta busy={a.busy} total={total} page={page}/></div>{a.error?<InlineError message={a.error.message} onRetry={a.retry}/>:a.busy&&!a.data?<TableSkeleton columns={10}/>:<DataTable id="jobs" columns={cols} rows={rows} onRow={r=>patch({job:r.id},{push:true})} render={(r,k)=>k==='duration_ms'?duration(r[k]):genericCell(r,k)}/>}<Pager total={total} page={page} onPage={p=>patch({p})}/></section>{detailId&&<JobDetail id={detailId} onClose={()=>history.back()}/>}</>
}
function JobDetail({id,onClose}){
  const a=useAdmin('pipeline_job_detail',{id})
  const d=a.data??{},job=d.job??{}
  return <div className="drawer-backdrop" onMouseDown={e=>{if(e.target===e.currentTarget)onClose()}}><aside className="op-drawer"><div className="drawer-head"><div><small>Pipeline job</small><h2>{job.job_type??id}</h2></div><button onClick={onClose}>×</button></div><div className="drawer-body">{a.error?<InlineError message={a.error.message} onRetry={a.retry}/>:a.busy&&!a.data?<PageSkeleton cards={3}/>:<div className="detail-stack"><StickyIdentity title={job.job_type} code={job.id} status={job.status}/><Section title="Run semantics"><KVGrid rows={objectPairs(d.run_semantics??{})}/></Section><Section title="Job identity & timing"><KVGrid rows={pickPairs(job,[['Domain','domain'],['Source','source_label'],['Provider','provider_name'],['Entity','entity_stable_key'],['Started','started_at'],['Completed','completed_at'],['Duration','duration_ms'],['Attempts','attempt_count'],['Error','error_text']])}/></Section><Section title="Evidence"><EvidenceRows rows={d.evidence??[]}/></Section><Section title="Entity impact"><JsonSummary value={d.entity_impact}/></Section><Section title="Guarded actions"><JsonSummary value={d.safe_actions}/></Section></div>}</div></aside></div>
}

function Sources({params,patch}){
  const q=params.q??'',debounced=useDebounced(q),page=Math.max(1,num(params.p,1))
  const f=useAdmin('pipeline_filters',{})
  const a=useAdmin('pipeline_sources_page',{limit:PAGE_SIZE,offset:(page-1)*PAGE_SIZE,query:debounced||null,country_code:params.country||null,layer:params.layer||null,status:params.status||null,source_type:params.type||null,health:params.health||null,sort:params.sort??'source',direction:params.dir??'asc'})
  const rows=a.data?.items??[],total=Number(a.data?.total??0)
  const cols=[['source_label','Source','source',270],['layer_code','Layer',null,80],['country_code','Country','country',90],['source_type','Type',null,190],['health','Health','health',110],['freshness_age_days','Freshness (days)','freshness',130],['last_success_at','Last success',null,180],['running_jobs','Running',null,90],['problem_jobs','Problems',null,95],['evidence_count','Evidence',null,95]]
  return <section className="op-panel"><div className="toolbar"><div className="filter-row"><label className="search-box"><span>⌕</span><input value={q} placeholder="Source, type, provider or URL" onChange={e=>patch({q:e.target.value,p:1})}/></label><Select label="Layer" value={params.layer??''} options={(f.data?.layers??[]).map(x=>({value:x,label:x}))} onChange={v=>patch({layer:v,p:1})}/><Select label="Health" value={params.health??''} options={['healthy','unhealthy','untested'].map(x=>({value:x,label:humanise(x)}))} onChange={v=>patch({health:v,p:1})}/></div><ListMeta busy={a.busy} total={total} page={page}/></div>{a.error?<InlineError message={a.error.message} onRetry={a.retry}/>:a.busy&&!a.data?<TableSkeleton columns={10}/>:<DataTable id="sources" columns={cols} rows={rows} render={genericCell}/>}<Pager total={total} page={page} onPage={p=>patch({p})}/></section>
}

function Attributes(){
  const a=useAdmin('attributes',{limit:500})
  if(a.error)return <InlineError message={a.error.message} onRetry={a.retry}/>
  if(a.busy&&!a.data)return <PageSkeleton cards={6}/>
  const d=a.data??{},counts=d.counts??{}
  return <><MetricGrid items={[['Families',counts.families],['Groups',counts.groups],['Attributes',counts.attributes],['Options',counts.options],['Completeness profiles',counts.completeness_profiles],['Requirements',counts.completeness_profile_rules]]}/><section className="op-panel"><div className="panel-heading"><div><h2>Attribute model</h2><p>Configuration is separated from catalogue data. Empty option/profile sets are shown explicitly rather than treated as load failures.</p></div><StatusPill value="PIM admin"/></div><ConfigSection title="Families" rows={d.families}/><ConfigSection title="Groups" rows={d.groups}/><ConfigSection title="Attributes" rows={d.attributes}/><ConfigSection title="Options" rows={d.options} empty="No governed Attribute Options are currently loaded."/><ConfigSection title="Completeness profiles" rows={d.completeness_profiles} empty="No PIM Completeness Profiles are currently loaded. This is independent of the six-signal Course Admin readiness view."/><ConfigSection title="Completeness requirements" rows={d.completeness_profile_rules} empty="No PIM Completeness Requirements are currently loaded."/></section></>
}

function Qilt({params,patch,go}){
  const f=useAdmin('qilt_filters',{}),page=Math.max(1,num(params.p,1)),q=params.q??'',debounced=useDebounced(q)
  const a=useAdmin('qilt_outcomes',{limit:PAGE_SIZE,offset:(page-1)*PAGE_SIZE,query:debounced||null,provider_id:params.provider||null,survey_code:params.survey||null,metric_code:params.metric||null,collection_year_to:params.year||null,sort:params.sort??'provider',direction:params.dir??'asc'})
  const rows=a.data?.items??[],total=Number(a.data?.total??0),filters=f.data??{}
  const cols=[['provider_name','Provider','provider',280],['survey_name','Survey',null,220],['source_cohort_code','Cohort',null,90],['metric_name','Metric',null,230],['metric_value','Value',null,110],['collection_year_to','Year',null,80],['status','Status',null,105],['source_label','Source',null,250],['evidence_captured_at','Evidence captured',null,180]]
  return <section className="op-panel"><div className="toolbar"><div className="filter-row"><label className="search-box"><span>⌕</span><input value={q} placeholder="Provider, survey or metric" onChange={e=>patch({q:e.target.value,p:1})}/></label><Select label="Survey" value={params.survey??''} options={(filters.surveys??[]).map(x=>({value:x.code,label:`${x.name} (${x.count})`}))} onChange={v=>patch({survey:v,p:1})}/><Select label="Metric" value={params.metric??''} options={(filters.metrics??[]).map(x=>({value:x.code,label:`${x.name} (${x.count})`}))} onChange={v=>patch({metric:v,p:1})}/><Select label="Year" value={params.year??''} options={(filters.years??[]).map(x=>({value:String(x.value),label:`${x.label} (${x.count})`}))} onChange={v=>patch({year:v,p:1})}/></div><ListMeta busy={a.busy} total={total} page={page}/></div>{a.error?<InlineError message={a.error.message} onRetry={a.retry}/>:a.busy&&!a.data?<TableSkeleton columns={9}/>:<DataTable id="qilt" columns={cols} rows={rows} onRow={r=>r.provider_id&&go('providers',{detail:r.provider_id})} render={(r,k)=>k==='metric_value'?metricValue(r):genericCell(r,k)}/>}<Pager total={total} page={page} onPage={p=>patch({p})}/></section>
}
function Prisms({params,patch}){
  const f=useAdmin('prisms_filters',{}),page=Math.max(1,num(params.p,1)),q=params.q??'',debounced=useDebounced(q)
  const a=useAdmin('prisms_student_flow',{limit:PAGE_SIZE,offset:(page-1)*PAGE_SIZE,query:debounced||null,subdivision_code:params.region||null,source_sector_code:params.sector||null,source_study_area_code:params.study||null,source_remoteness_area:params.remote||null,sort:params.sort??'geography',direction:params.dir??'asc'})
  const rows=a.data?.items??[],total=Number(a.data?.total??0),filters=f.data??{}
  const cols=[['subdivision_name','State / Territory',null,180],['source_geography_name','SA4 geography','geography',260],['source_sector_code','Sector',null,150],['source_study_area_name','Study area',null,260],['source_remoteness_area','Remoteness',null,190],['enrolments','Enrolments',null,110],['commencements','Commencements',null,130],['period_end','Period end',null,120],['suppressed','Suppressed',null,110],['source_label','Source',null,250]]
  return <section className="op-panel"><div className="toolbar"><div className="filter-row"><label className="search-box"><span>⌕</span><input value={q} placeholder="Geography, study area or source" onChange={e=>patch({q:e.target.value,p:1})}/></label><Select label="Region" value={params.region??''} options={(filters.subdivisions??[]).map(x=>({value:x.code,label:`${x.name} (${x.count})`}))} onChange={v=>patch({region:v,p:1})}/><Select label="Sector" value={params.sector??''} options={(filters.sectors??[]).map(x=>({value:x.code,label:`${x.name} (${x.count})`}))} onChange={v=>patch({sector:v,p:1})}/><Select label="Remoteness" value={params.remote??''} options={(filters.remoteness??[]).map(x=>({value:x.code,label:`${x.name} (${x.count})`}))} onChange={v=>patch({remote:v,p:1})}/></div><ListMeta busy={a.busy} total={total} page={page}/></div>{a.error?<InlineError message={a.error.message} onRetry={a.retry}/>:a.busy&&!a.data?<TableSkeleton columns={10}/>:<DataTable id="prisms" columns={cols} rows={rows} render={genericCell}/>}<Pager total={total} page={page} onPage={p=>patch({p})}/></section>
}

function Publication(){
  const a=useAdmin('publication_overview',{})
  if(a.error)return <InlineError message={a.error.message} onRetry={a.retry}/>
  if(a.busy&&!a.data)return <PageSkeleton cards={6}/>
  const d=a.data??{},c=d.course_documents??{},p=d.projection??{}
  return <><MetricGrid items={[['Search documents',c.total],['Search published',c.published],['Search unpublished',c.unpublished],['Has fee',c.has_fee],['Has intake',c.has_intake],['Has English',c.has_english],['Has scholarship',c.has_scholarship],['Projection generation',p.generation]]}/><section className="op-panel"><div className="panel-heading"><div><h2>Search projection</h2><p>Search is a governed derived projection. It does not redefine canonical Course identity or Admin readiness.</p></div><StatusPill value={p.projection_version??'not reported'}/></div><KVGrid rows={pickPairs(p,[['Projection','projection_code'],['Version','projection_version'],['Generation','generation'],['Rows','row_count'],['Rebuilt','rebuilt_at'],['Enrichment gate','enrichment_gate'],['Content hash','content_hash']])}/></section><section className="op-panel"><h2>Publication channels</h2>{(d.channels??[]).length?<div className="channel-grid">{d.channels.map(x=><article className="info-card" key={x.code}><div className="panel-heading"><h3>{x.name??x.code}</h3><StatusPill value={x.status}/></div><p>{humanise(x.audience)}</p><strong>{formatValue(x.published_count)} published</strong><small>{formatValue(x.entity_state_count)} entity states</small></article>)}</div>:<EmptyState title="No publication channels configured" detail="No publishing channel state is inferred."/>}</section></>
}

function DataTable({id,columns,rows,render=genericCell,onRow,sort,dir,onSort}){
  const [widths,setWidths]=useState(()=>loadWidths(id,columns))
  useEffect(()=>localStorage.setItem(`cf-cols-${id}`,JSON.stringify(widths)),[id,widths])
  const startResize=(e,key)=>{e.preventDefault();e.stopPropagation();const x=e.clientX,w=widths[key]??160;const move=ev=>setWidths(v=>({...v,[key]:Math.max(72,w+ev.clientX-x)}));const up=()=>{removeEventListener('mousemove',move);removeEventListener('mouseup',up)};addEventListener('mousemove',move);addEventListener('mouseup',up)}
  return <div className="table-scroll"><table className="op-table"><thead><tr>{columns.map(([key,label,sortKey])=><th key={key} style={{width:widths[key],minWidth:widths[key]}}><button className={sort===sortKey?'sorted':''} disabled={!sortKey||!onSort} onClick={()=>sortKey&&onSort?.(sortKey)}>{label}{sort===sortKey?<span>{dir==='desc'?' ↓':' ↑'}</span>:null}</button><i className="resize-handle" onMouseDown={e=>startResize(e,key)}/></th>)}</tr></thead><tbody>{rows.map((r,i)=><tr key={r.id??r.course_id??r.source_id??i} className={onRow?'clickable':''} onClick={()=>onRow?.(r)}>{columns.map(([key])=><td key={key}>{render(r,key)}</td>)}</tr>)}</tbody></table></div>
}
function loadWidths(id,columns){try{const x=JSON.parse(localStorage.getItem(`cf-cols-${id}`)||'{}');return Object.fromEntries(columns.map(([k,,,w])=>[k,Number(x[k])||w||160]))}catch{return Object.fromEntries(columns.map(([k,,,w])=>[k,w||160]))}}
function Pager({total,page,onPage}){const pages=Math.max(1,Math.ceil(total/PAGE_SIZE));if(total<=PAGE_SIZE)return null;return <div className="pager"><button disabled={page<=1} onClick={()=>onPage(page-1)}>← Previous</button><span>Page {page.toLocaleString()} of {pages.toLocaleString()}</span><button disabled={page>=pages} onClick={()=>onPage(page+1)}>Next →</button></div>}
function ListMeta({busy,total,page}){return <div className="list-meta"><span className={busy?'activity active':'activity'} aria-hidden="true"/><span>{busy?'Refreshing…':`${total.toLocaleString()} matching`}</span><small>Page {page}</small></div>}
function Select({label,value,options,onChange}){return <label className="select-field"><span>{label}</span><select value={value} onChange={e=>onChange(e.target.value)}><option value="">All</option>{options.map(o=><option key={`${o.value}-${o.label}`} value={o.value}>{o.label}</option>)}</select></label>}
function MetricGrid({items}){return <div className="metric-grid">{items.map(([k,v])=><article className="op-metric" key={k}><small>{k}</small><strong>{v===null||v===undefined?'—':Number.isFinite(Number(v))?Number(v).toLocaleString():String(v)}</strong></article>)}</div>}
function PageSkeleton({cards=4}){return <><div className="metric-grid">{Array.from({length:cards}).map((_,i)=><div className="skeleton-card" key={i}/>)}</div><section className="op-panel"><SkeletonLines rows={8}/></section></>}
function TableSkeleton({columns=6}){return <div className="table-skeleton">{Array.from({length:8}).map((_,r)=><div className="skeleton-row" key={r}>{Array.from({length:columns}).map((__,c)=><i key={c}/>)}</div>)}</div>}
function SkeletonLines({rows=5}){return <div className="skeleton-lines">{Array.from({length:rows}).map((_,i)=><i key={i}/>)}</div>}
function InlineError({message,onRetry}){return <div className="inline-error" role="alert"><div><strong>Couldn’t load this workspace</strong><p>{message||'Unexpected read error.'}</p></div>{onRetry&&<button onClick={onRetry}>Retry</button>}</div>}
function EmptyState({title,detail}){return <div className="empty-state"><strong>{title}</strong><p>{detail}</p></div>}
function PermissionState(){return <EmptyState title="Not authorised" detail="This workspace is hidden from lower-ranked roles and is also protected by the server-side role check."/>}
function StatusPill({value,tone}){const text=humanise(value??'not supplied');const t=tone??STATUS_STYLE[String(value??'').toLowerCase()]??'neutral';return <span className={`status-pill ${t}`}>{text}</span>}
function Score({value}){const n=Number(value);return Number.isFinite(n)?<span className="score"><i style={{width:`${Math.max(0,Math.min(100,n))}%`}}/><b>{n.toLocaleString()}%</b></span>:'—'}
function StickyIdentity({title,code,status}){return <div className="sticky-identity"><div><small>{code??'Governed record'}</small><strong>{title??'—'}</strong></div><StatusPill value={status}/></div>}
function Section({title,children}){return <section className="detail-section"><h3>{title}</h3>{children}</section>}
function KVGrid({rows}){return <div className="kv-grid">{rows.map(([k,v])=><div className="kv" key={k}><small>{k}</small><strong>{smart(v,k)}</strong></div>)}</div>}
function ObjectRows({rows,empty}){if(!rows?.length)return <div className="empty-note">{empty}</div>;return <div className="object-rows">{rows.map((r,i)=><article key={r.id??i}><KVGrid rows={objectPairs(r).slice(0,10)}/></article>)}</div>}
function RelatedRows({rows,titleKey,metaKeys,onClick}){if(!rows?.length)return <div className="empty-note">No related rows in the bounded detail payload.</div>;return <div className="related-list">{rows.map((r,i)=><button key={r.id??i} disabled={!onClick} onClick={()=>onClick?.(r)}><strong>{r[titleKey]??r.stable_key??'Related record'}</strong><small>{metaKeys.map(k=>smart(r[k],k)).filter(x=>x!=='—').join(' · ')}</small></button>)}</div>}
function EvidenceRows({rows}){if(!rows?.length)return <div className="empty-note">No evidence rows recorded in this payload.</div>;return <div className="related-list">{rows.map((r,i)=><article key={r.id??i}><strong>{humanise(r.evidence_type??r.type??'evidence')}</strong><small>{[fmtDate(r.captured_at),r.content_hash].filter(Boolean).join(' · ')}</small>{r.source_url&&safeLink(r.source_url)}</article>)}</div>}
function ConfigSection({title,rows=[],empty}){return <section className="config-section"><div className="panel-heading"><h3>{title}</h3><span>{rows?.length??0}</span></div>{rows?.length?<ObjectRows rows={rows}/>:<div className="empty-note">{empty??`No ${title.toLowerCase()} loaded.`}</div>}</section>}
function JsonSummary({value}){if(!value||!Object.keys(value).length)return <div className="empty-note">No structured data recorded.</div>;return <KVGrid rows={objectPairs(value)}/>} 
function InfoCard({title,text}){return <article className="info-card"><h3>{title}</h3><p>{text}</p></article>}

function genericCell(r,k){const v=r[k];if(k.includes('_at')||k==='created_at'||k==='updated_at'||k==='period_end'||k==='period_start')return fmtDate(v);if(k.includes('status')||k==='status'||k==='health')return <StatusPill value={v}/>;if(k.endsWith('_id')||k==='id'||k.includes('hash'))return v?<code>{v}</code>:'—';if(k==='country_code')return country(v);if(k==='source_url'||k==='evidence_url')return safeLink(v);return formatValue(v)}
function metricValue(r){if(r.metric_value===null||r.metric_value===undefined)return '—';if(String(r.metric_unit).toUpperCase()==='AUD')return money(r.metric_value,'AUD');if(r.metric_unit==='percent')return `${Number(r.metric_value).toLocaleString()}%`;return `${Number(r.metric_value).toLocaleString()} ${r.metric_unit??''}`.trim()}
function missingSignals(r){return [['Registration',r.has_registration],['Structure',r.has_structure],['Fee',r.has_fee],['Intake',r.has_intake],['English',r.has_english],['Description',r.has_description]].filter(([,v])=>!v).map(([k])=>k)}
function detailTitle(type,d){if(type==='course')return d?.canonical_title??d?.display_title??'Course';if(type==='provider')return d?.display_name??d?.canonical_name??'Provider';return d?.name??humanise(type)}
function groupRoutes(rank){const m=new Map();for(const r of ROUTES.filter(x=>rank>=x.min)){if(!m.has(r.section))m.set(r.section,[]);m.get(r.section).push(r)}return [...m.entries()]}
function readRoute(){const u=new URL(location.href),view=u.searchParams.get('view')||'dashboard',params={};for(const [k,v] of u.searchParams)if(k!=='view')params[k]=v;return{view,params}}
function setUrlValue(params,k,v){if(v===null||v===undefined||v===''||v===false)params.delete(k);else params.set(k,String(v))}
function num(v,f){const n=Number(v);return Number.isFinite(n)&&n>0?n:f}
function humanise(v){return v===null||v===undefined||v===''?'—':String(v).replaceAll('_',' ').replace(/\b\w/g,c=>c.toUpperCase())}
function formatValue(v){if(v===null||v===undefined||v==='')return '—';if(typeof v==='boolean')return v?'Yes':'No';if(typeof v==='number')return v.toLocaleString();if(Array.isArray(v))return v.length?v.map(x=>typeof x==='object'?JSON.stringify(x):x).join(', '):'—';if(typeof v==='object')return JSON.stringify(v);return String(v)}
function fmtDate(v){if(!v)return '—';const d=new Date(v);if(Number.isNaN(d.valueOf()))return String(v);return new Intl.DateTimeFormat('en-AU',{timeZone:AU_TZ,dateStyle:'medium',timeStyle:'short'}).format(d)}
function money(v,currency='AUD'){const n=Number(v);return Number.isFinite(n)?new Intl.NumberFormat('en-AU',{style:'currency',currency:currency||'AUD',maximumFractionDigits:0}).format(n):'—'}
function duration(ms){const n=Number(ms);if(!Number.isFinite(n))return '—';if(n<1000)return `${n} ms`;if(n<60000)return `${(n/1000).toFixed(1)} s`;return `${(n/60000).toFixed(1)} min`}
function country(code){if(!code)return '—';const c=String(code).toUpperCase();const flag=c.length===2?String.fromCodePoint(...[...c].map(x=>127397+x.charCodeAt())):'';return `${flag} ${c}`.trim()}
function safeLink(v){if(!v)return '—';try{const u=new URL(v);if(!['http:','https:'].includes(u.protocol))return <code>{v}</code>;return <a href={u.href} target="_blank" rel="noreferrer" onClick={e=>e.stopPropagation()}>{u.hostname}</a>}catch{return <code>{String(v)}</code>}}
function objectPairs(v){return Object.entries(v??{}).filter(([,x])=>x!==null&&x!==undefined&&typeof x!=='object').map(([k,x])=>[humanise(k),x])}
function pickPairs(obj,pairs){return pairs.map(([label,key])=>[label,obj?.[key]])}
function smart(v,label=''){if(v===null||v===undefined||v==='')return '—';const k=String(label).toLowerCase();if(k.includes('date')||k.includes('created')||k.includes('updated')||k.includes('verified')||k.includes('started')||k.includes('completed'))return fmtDate(v);if(k.includes('duration')&&typeof v==='number')return duration(v);return formatValue(v)}

createRoot(document.getElementById('root')).render(<App/>)