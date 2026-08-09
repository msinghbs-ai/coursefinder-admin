import React, { useEffect, useMemo, useState } from 'react'
import { createRoot } from 'react-dom/client'
import { supabase } from './supabase'
import './styles.css'

function App(){
  const [courses,setCourses]=useState([])
  const [scholarships,setScholarships]=useState([])
  const [query,setQuery]=useState('')
  const [level,setLevel]=useState('all')
  const [loading,setLoading]=useState(true)

  useEffect(()=>{
    Promise.all([
      supabase.from('course_completeness_v2').select('course_id,canonical_title,provider_name,level_code,field_of_study,country_code,fee_amount,fee_currency,ielts_overall,duration_weeks,scholarship_count,completeness_score_v2').order('completeness_score_v2',{ascending:false}).limit(180),
      supabase.from('scholarship_catalogue_v2').select('id,canonical_name,provider_name,academic_year,value_percent_max,value_amount_max,currency,value_text,application_mode,status').eq('status','active').limit(12)
    ]).then(([c,s])=>{setCourses(c.data??[]);setScholarships(s.data??[]);setLoading(false)})
  },[])

  const levels=useMemo(()=>['all',...Array.from(new Set(courses.map(c=>c.level_code).filter(Boolean))).sort()], [courses])
  const filtered=useMemo(()=>courses.filter(c=>{
    const text=`${c.canonical_title} ${c.provider_name} ${c.field_of_study??''}`.toLowerCase()
    return text.includes(query.toLowerCase()) && (level==='all'||c.level_code===level)
  }),[courses,query,level])

  return <div className="app">
    <header className="topbar">
      <div className="brand"><div className="mark">CF</div><div><strong>Coursefinder</strong><small>International study discovery</small></div></div>
      <nav><a href="#search">Find courses</a><a href="#scholarships">Scholarships</a><a href="#about">How it works</a></nav>
      <button className="ghost">Counsellor demo</button>
    </header>

    <main>
      <section className="hero">
        <div className="hero-copy">
          <span className="eyebrow">Coursefinder demo</span>
          <h1>Find the right international course, faster.</h1>
          <p>Search structured course, fee, English requirement and scholarship information from one catalogue.</p>
          <div className="searchbox" id="search">
            <input value={query} onChange={e=>setQuery(e.target.value)} placeholder="Search course, provider or field of study" />
            <select value={level} onChange={e=>setLevel(e.target.value)}>{levels.map(x=><option key={x} value={x}>{x==='all'?'All study levels':x}</option>)}</select>
          </div>
          <div className="hero-stats"><span><b>{courses.length||'—'}</b> sample courses</span><span><b>{scholarships.length||'—'}</b> featured scholarships</span><span><b>AU</b> pilot catalogue</span></div>
        </div>
        <div className="hero-card">
          <div className="mini-card"><span>Catalogue quality</span><strong>{loading?'Loading…':'Structured + evidence backed'}</strong><small>Regulatory → Evidence → AI → Human review</small></div>
          <div className="layer-flow"><i>1</i><span>Regulatory</span><i>2</i><span>Evidence</span><i>3</i><span>Normalise</span><i>4</i><span>Human verify</span></div>
        </div>
      </section>

      <section className="section">
        <div className="section-head"><div><span className="eyebrow">Course catalogue</span><h2>Explore courses</h2></div><span>{filtered.length} results</span></div>
        <div className="course-grid">{filtered.slice(0,12).map(c=><article className="course" key={c.course_id}>
          <div className="course-top"><span className="badge">{c.level_code||'Course'}</span><span className="score">{Number(c.completeness_score_v2||0).toFixed(0)}% complete</span></div>
          <h3>{c.canonical_title}</h3><p className="provider">{c.provider_name}</p>
          <dl><div><dt>Field</dt><dd>{c.field_of_study||'—'}</dd></div><div><dt>Tuition</dt><dd>{c.fee_amount?`${c.fee_currency||''} ${Number(c.fee_amount).toLocaleString()}`:'—'}</dd></div><div><dt>IELTS</dt><dd>{c.ielts_overall||'—'}</dd></div><div><dt>Scholarships</dt><dd>{c.scholarship_count||0}</dd></div></dl>
          <button>View course</button>
        </article>)}</div>
      </section>

      <section className="section alt" id="scholarships">
        <div className="section-head"><div><span className="eyebrow">Funding</span><h2>Featured scholarships</h2></div></div>
        <div className="scholarship-list">{scholarships.slice(0,6).map(s=><article key={s.id}><div><span className="badge">{s.academic_year||'Current'}</span><h3>{s.canonical_name}</h3><p>{s.provider_name}</p></div><div className="award"><strong>{s.value_percent_max?`${s.value_percent_max}%`:s.value_amount_max?`${s.currency||''} ${Number(s.value_amount_max).toLocaleString()}`:s.value_text||'See details'}</strong><small>{s.application_mode||'Eligibility varies'}</small></div></article>)}</div>
      </section>

      <section className="section process" id="about">
        <span className="eyebrow">Why Coursefinder</span><h2>More than a scraped list.</h2>
        <div className="process-grid"><div><b>01</b><h3>Official foundations</h3><p>Provider and course identity starts with authoritative regulatory sources.</p></div><div><b>02</b><h3>Evidence retained</h3><p>Source pages and evidence are retained for provenance and review.</p></div><div><b>03</b><h3>Structured enrichment</h3><p>Fees, intakes, English requirements and scholarships are normalised into consistent fields.</p></div><div><b>04</b><h3>Human maintained</h3><p>Low-confidence or unusual attributes move through Layer 4 human curation.</p></div></div>
      </section>
    </main>
    <footer><strong>Coursefinder Demo</strong><span>Demo catalogue only — not for admissions decisions.</span></footer>
  </div>
}

createRoot(document.getElementById('root')).render(<React.StrictMode><App/></React.StrictMode>)
