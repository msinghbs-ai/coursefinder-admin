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
