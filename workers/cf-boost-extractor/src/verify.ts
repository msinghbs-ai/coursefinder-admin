// CF-247 Boost extractor: the deterministic gate every answer passes before a row is written to staging-boost/inbound.
// 1. JSON shape and allowed values (lanes.ts validate, with live allowed values from the batch header).
// 2. quote_on_page: every quote, in flat form, is inside the WHOLE page's flat form (the same canonical form as the Pilot worker's
//    lean-sections.ts flatForm, so a quote passes here exactly when it passes there). A section selection sent to the model never
//    narrows this check: the page is the evidence.
// 3. quoteSays: the quote states what the value claims (lane rule).
// A row that fails any check is written as rejected with its reasons; it never reaches the database's admission path.
import { LANES, allowedFor, type Allowed, type LaneKey } from "./lanes.ts";

// identical to Pilot supabase/functions/coverage-sweep/lean-sections.ts flatForm (worker v1.0.6)
export const flatForm = (s: string) => String(s || "").toLowerCase().normalize("NFKD").replace(/[^a-z0-9]+/g, "");
const MIN_QUOTE_FLAT = 12; // fixed: a quote shorter than this proves nothing (a few words match anywhere); not an operational limit

export type Verdict = { ok: boolean; problems: string[]; quotes_checked: number };

export function quoteOnPage(quote: string, pageFlat: string): boolean {
  const q = flatForm(quote);
  return q.length >= MIN_QUOTE_FLAT && pageFlat.includes(q);
}

// the whole check on the page's flat form (the exporter precomputes it, so the worker never converts a page)
export function verifyFlat(lane: LaneKey, answer: any, pageFlat: string, header?: { allowed?: Allowed }): Verdict {
  const spec = LANES[lane];
  const problems = spec.validate(answer, allowedFor(lane, header));
  if (problems.length) return { ok: false, problems, quotes_checked: 0 };
  const quotes = spec.quotes(answer).filter((q) => q != null);
  quotes.forEach((q, i) => { if (!quoteOnPage(String(q), pageFlat)) problems.push(`quote ${i} is not on the page`) });
  problems.push(...(spec.quoteSays ? spec.quoteSays(answer) : []));
  return { ok: problems.length === 0, problems, quotes_checked: quotes.length };
}

// the same check from a page's plain text (exporter, tests)
export function verify(lane: LaneKey, answer: any, pagePlain: string, header?: { allowed?: Allowed }): Verdict {
  return verifyFlat(lane, answer, flatForm(pagePlain), header);
}
