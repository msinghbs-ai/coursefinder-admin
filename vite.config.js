import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

function pimFinalisationGuardrails() {
  return {
    name: 'coursefinder-pim-finalisation-guardrails',
    enforce: 'pre',
    transform(code, id) {
      if (!id.endsWith('/src/finalisation.jsx')) return null

      const required = [
        "type={route.slug.slice(0,-1)}",
        "history.replaceState({...history.state,scrollY:window.scrollY},'',u)\n    if(push)history.pushState({scrollY:0},'',u)",
        "['fee_amount','CRICOS tuition (total course)','fee',190]",
        "['completeness_score_v2','Admin readiness','completeness',135]",
        "const a=useAdmin('evidence_page',args), rows=a.data?.items??[],total=Number(a.data?.total??0),filters=a.data?.filters??{}",
        "['evidence_type','Type','type',160],['source_label','Source','source',240],['entity_id','Entity ID',null,210],['content_hash','Content hash',null,220],['captured_at','Captured','captured',180],['valid_from','Valid from',null,130],['valid_to','Valid to',null,130],['source_url','Source URL',null,260]",
        "(filters.evidence_types??[]).map(x=>({value:x.code,label:`${x.name} (${x.count})`}))",
        "(filters.sources??[]).map(x=>({value:x.id,label:`${x.name} (${x.count})`}))",
      ]
      for (const marker of required) {
        if (!code.includes(marker)) throw new Error(`PIM finalisation source guard marker missing: ${marker}`)
      }

      let next = code
        .replace(
          "type={route.slug.slice(0,-1)}",
          "type={{providers:'provider',courses:'course',campuses:'campus',scholarships:'scholarship'}[route.slug]}"
        )
        .replace(
          "history.replaceState({...history.state,scrollY:window.scrollY},'',u)\n    if(push)history.pushState({scrollY:0},'',u)",
          "if(push){history.replaceState({...history.state,scrollY:window.scrollY},'',location.href);history.pushState({scrollY:0},'',u)}else{history.replaceState({...history.state,scrollY:window.scrollY},'',u)}"
        )
        .replace(
          "['fee_amount','CRICOS tuition (total course)','fee',190]",
          "['fee_amount','CRICOS tuition (total course)',null,190]"
        )
        .replace(
          "['completeness_score_v2','Admin readiness','completeness',135]",
          "['completeness_score_v2','Admin readiness',null,135]"
        )
        .replace(
          "const a=useAdmin('evidence_page',args), rows=a.data?.items??[],total=Number(a.data?.total??0),filters=a.data?.filters??{}",
          "const filterState=useAdmin('evidence_filters',{}), a=useAdmin('evidence_page',args), rows=a.data?.items??[],total=Number(a.data?.total??0),filters=filterState.data??{}"
        )
        .replace(
          "['evidence_type','Type','type',160],['source_label','Source','source',240],['entity_id','Entity ID',null,210],['content_hash','Content hash',null,220],['captured_at','Captured','captured',180],['valid_from','Valid from',null,130],['valid_to','Valid to',null,130],['source_url','Source URL',null,260]",
          "['layer','Layer','layer',80],['evidence_type','Type','type',180],['source_label','Source','source',260],['country_code','Country',null,90],['status','Status',null,120],['freshness_state','Freshness',null,120],['extraction_state','Extraction',null,150],['observation_count','Observations',null,110],['content_hash','Content hash',null,220],['captured_at','Captured','captured',180],['authority_url','Authority URL',null,260]"
        )
        .replace(
          "(filters.evidence_types??[]).map(x=>({value:x.code,label:`${x.name} (${x.count})`}))",
          "(filters.evidence_types??[]).map(x=>({value:x.code,label:x.name}))"
        )
        .replace(
          "(filters.sources??[]).map(x=>({value:x.id,label:`${x.name} (${x.count})`}))",
          "(filters.sources??[]).map(x=>({value:x.code,label:x.name}))"
        )
        .replace("k==='source_url'?safeLink(r[k])", "k==='authority_url'?safeLink(r[k])")

      return { code: next, map: null }
    },
  }
}

export default defineConfig({
  plugins: [pimFinalisationGuardrails(), react()],
  build: {
    rollupOptions: {
      onwarn(warning, warn) {
        if (warning.code === 'UNUSED_EXTERNAL_IMPORT' && warning.exporter?.includes('@supabase/')) return
        warn(warning)
      }
    }
  }
})
