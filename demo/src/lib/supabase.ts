import { createClient } from "@supabase/supabase-js";

const SUPABASE_URL = import.meta.env.VITE_SUPABASE_URL;
const SUPABASE_KEY = import.meta.env.VITE_SUPABASE_PUBLISHABLE_KEY;

if (!SUPABASE_URL || !SUPABASE_KEY) {
  throw new Error("Missing VITE_SUPABASE_URL or VITE_SUPABASE_PUBLISHABLE_KEY");
}

export const supabase = createClient(SUPABASE_URL, SUPABASE_KEY, {
  auth: { persistSession: true, autoRefreshToken: true, detectSessionInUrl: true },
});

export async function invokeAdmin(operation: string, payload: Record<string, unknown> = {}) {
  const { data, error } = await supabase.functions.invoke('pim-admin-v2-1', { body: { operation, ...payload } });
  if (error) throw error;
  if (data?.error) throw new Error(data.error);
  return data;
}

export async function runPipeline(layer: 1 | 2 | 3, payload: Record<string, unknown> = {}) {
  const { data, error } = await supabase.functions.invoke('pipeline-control-v2-5', { body: { layer, ...payload } });
  if (error) throw error;
  if (data?.error) throw new Error(data.error);
  return data;
}

export async function matchScholarships(profile: Record<string, unknown>, courseId: string | null = null) {
  const { data, error } = await supabase.functions.invoke('scholarship-match-v2-1', { body: { profile, course_id: courseId } });
  if (error) throw error;
  if (data?.error) throw new Error(data.error);
  return data;
}
