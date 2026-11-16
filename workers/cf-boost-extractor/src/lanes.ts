// CF-247 Boost extractor: the four AI/web-bound lanes it reads, what each answer must look like, and what each quote must prove.
// Allowed values are the live CHECK constraints (catalogue.courses.study_load, catalogue.provider_accreditations.body_code/status), read on
// 16 Nov 2026. The exporter re-reads them and ref.api_field_dictionary into each batch header; when the header carries them they win, so a
// changed constraint is never silently out of date here.
// Page content is data: nothing here follows an instruction found on a page.

export type LaneKey = "study_load" | "provider_accreditations" | "aer_entry" | "course_description" | "course_fees";

export type Allowed = Record<string, string[]>;

export type LaneSpec = {
  lane: LaneKey;
  // where an admitted value lands (documentation and the promotion SQL use the same names)
  target: string;
  // false: results stay in staging as a shadow reading; Boost never promotes them (AER v1 is frozen and AER v2 admits only through its own rule)
  promotable: boolean;
  defaults: Allowed;
  // problems with the answer's shape and values; [] when it is valid
  validate: (answer: any, allowed: Allowed) => string[];
  // every quote the answer relies on; each must be on the page
  quotes: (answer: any) => string[];
  // a quote must also say what the value claims (REQ-52: study load only from stated full-time / part-time words)
  quoteSays?: (answer: any) => string[];
};

const isStr = (v: unknown): v is string => typeof v === "string" && v.trim().length > 0;
const oneOf = (v: unknown, list: string[] | undefined) => typeof v === "string" && !!list && list.includes(v);

export const LANES: Record<LaneKey, LaneSpec> = {
  study_load: {
    lane: "study_load",
    target: "catalogue.courses.study_load (source provider_page, study_load_evidence_id)",
    promotable: true,
    defaults: { study_load: ["full_time", "part_time", "both"] },
    validate: (a, al) => {
      const p: string[] = [];
      if (!a || typeof a !== "object") return ["answer is not an object"];
      if (a.study_load === null) { if (!isStr(a.reason)) p.push("a null study_load needs a reason"); return p }
      if (!oneOf(a.study_load, al.study_load)) p.push(`study_load ${JSON.stringify(a.study_load)} is not allowed`);
      if (!isStr(a.quote)) p.push("quote missing");
      return p;
    },
    quotes: (a) => (a?.study_load ? [a.quote] : []),
    quoteSays: (a) => {
      if (!a?.study_load) return [];
      const q = String(a.quote || "");
      const full = /full[\s-]?time/i.test(q), part = /part[\s-]?time/i.test(q);
      const need = a.study_load === "both" ? full && part : a.study_load === "full_time" ? full : part;
      return need ? [] : ["the quote does not state the study load it claims (REQ-52: never from delivery mode)"];
    },
  },
  provider_accreditations: {
    lane: "provider_accreditations",
    target: "catalogue.provider_accreditations",
    promotable: true,
    defaults: { body_code: ["AACSB", "EQUIS", "AMBA"], status: ["active", "expired", "revoked", "under_review"] },
    validate: (a, al) => {
      if (!a || !Array.isArray(a.accreditations)) return ["accreditations must be a list"];
      const p: string[] = [];
      a.accreditations.forEach((x: any, i: number) => {
        if (!oneOf(x?.body_code, al.body_code)) p.push(`[${i}] body_code ${JSON.stringify(x?.body_code)} is not allowed`);
        if (!oneOf(x?.status, al.status)) p.push(`[${i}] status ${JSON.stringify(x?.status)} is not allowed`);
        if (!isStr(x?.quote)) p.push(`[${i}] quote missing`);
      });
      return p;
    },
    quotes: (a) => (a?.accreditations || []).map((x: any) => x.quote),
    quoteSays: (a) => (a?.accreditations || []).flatMap((x: any, i: number) =>
      new RegExp(`\\b${String(x?.body_code || "").replace(/[^A-Z]/g, "")}\\b`, "i").test(String(x?.quote || "")) ? [] : [`[${i}] the quote does not name ${x?.body_code}`]),
  },
  aer_entry: {
    // the AER v2 prompt v3 answer contract (Pilot aer-v2.ts AER_V3_SCHEMA): each record proves itself with exact_quote, and lead_in_quote /
    // support[].quote when given; the Pilot verifier (aerV3Verify, block numbers, lead-in rules) still decides in the database's own rule
    lane: "aer_entry",
    target: "none: shadow reading beside the held Layer 4 item (AER v2 admits only through its own rule, after qualification)",
    promotable: false,
    defaults: { audience: ["international", "domestic", "all"] },
    validate: (a, al) => {
      if (!a || !Array.isArray(a.records)) return ["records must be a list"];
      return a.records.flatMap((r: any, i: number) => {
        const p: string[] = [];
        if (!isStr(r?.exact_quote)) p.push(`[${i}] exact_quote missing`);
        if (!Number.isInteger(r?.exact_block)) p.push(`[${i}] exact_block must be a block number`);
        if (!oneOf(r?.audience, al.audience)) p.push(`[${i}] audience ${JSON.stringify(r?.audience)} is not allowed`);
        return p;
      });
    },
    quotes: (a) => (a?.records || []).flatMap((r: any) => [r.exact_quote, r.lead_in_quote, ...(Array.isArray(r.support) ? r.support.map((s: any) => s?.quote) : [])].filter(isStr)),
  },
  course_description: {
    lane: "course_description",
    target: "the course description record function (security.course_description_check_v1 decides)",
    promotable: true,
    defaults: {},
    validate: (a) => {
      if (!a || typeof a !== "object") return ["answer is not an object"];
      if (a.status === "not_stated") return [];
      if (!Array.isArray(a.sentences) || a.sentences.length === 0) return ["sentences must be a non-empty list"];
      return a.sentences.flatMap((s: any, i: number) => (isStr(s?.text) && isStr(s?.quote) ? [] : [`[${i}] text and quote are required`]));
    },
    quotes: (a) => (a?.sentences || []).map((s: any) => s.quote),
  },
  course_fees: {
    lane: "course_fees",
    target: "the fee reader rows (the fee reader's own admission rule decides)",
    promotable: true,
    defaults: { audience: ["international", "domestic"] },
    validate: (a, al) => {
      if (!a || !Array.isArray(a.fees)) return ["fees must be a list"];
      return a.fees.flatMap((f: any, i: number) => {
        const p: string[] = [];
        if (typeof f?.amount !== "number" || !(f.amount > 0)) p.push(`[${i}] amount must be a positive number`);
        if (!/^[A-Z]{3}$/.test(String(f?.currency || ""))) p.push(`[${i}] currency must be a 3-letter code`);
        if (f?.audience != null && !oneOf(f.audience, al.audience)) p.push(`[${i}] audience ${JSON.stringify(f.audience)} is not allowed`);
        if (!isStr(f?.quote)) p.push(`[${i}] quote missing`);
        return p;
      });
    },
    quotes: (a) => (a?.fees || []).map((f: any) => f.quote),
    quoteSays: (a) => (a?.fees || []).flatMap((f: any, i: number) => {
      const digits = String(Math.round(Number(f?.amount) || 0));
      return String(f?.quote || "").replace(/[^0-9]/g, "").includes(digits) ? [] : [`[${i}] the quote does not print the amount ${digits}`];
    }),
  },
};

// The batch header may carry allowed values read live (CHECK constraints and ref.api_field_dictionary); they win over the defaults above.
export function allowedFor(lane: LaneKey, header?: { allowed?: Allowed }): Allowed {
  return { ...LANES[lane].defaults, ...(header?.allowed || {}) };
}
