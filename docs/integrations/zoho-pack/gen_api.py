# Builds the OpenAPI file and the Postman collection for Zoho API v2. No key is written: Postman reads it from the variable apiKey.
import json
FN="zoho-api-v2"
ex={
 "reference":{"action":"reference"},
 "search_nursing":{"action":"search","filters":{"keyword":"nursing","country_codes":["AU"],"english_test_codes":["IELTS"],"english_score_max":7,"english_band_max":6.5,"intake_months":[2,7]},"page":1,"page_size":10},
 "search_provider_name":{"action":"search","filters":{"provider_name":"Queensland"},"page":1,"page_size":2},
 "search_provider_cricos":{"action":"search","filters":{"provider_cricos_codes":["00025B"],"tuition_annual_max":45000},"page":1,"page_size":20,"sort":"tuition_annual_asc"},
 "course":{"action":"course","cricos_course_code":"082960F"},
 "courses":{"action":"courses","identifiers":["082960F","0100879","NOPE"]},
 "providers":{"action":"providers","filters":{"provider_name":"RMIT"},"page":1,"page_size":5},
 "provider":{"action":"provider","cricos_provider_code":"00025B"},
 "campuses":{"action":"campuses","filters":{"provider_cricos_codes":["00025B"]},"page":1,"page_size":50},
 "contacts":{"action":"contacts","filters":{"provider_cricos_codes":["00025B"]},"page":1,"page_size":50},
 "statistics_qilt":{"action":"statistics","kind":"qilt","filters":{"provider_cricos_codes":["00025B"]},"page":1,"page_size":50},
 "statistics_prisms":{"action":"statistics","kind":"prisms","filters":{"subdivision_codes":["AU-QLD"]},"page":1,"page_size":50},
 "rankings":{"action":"rankings","filters":{"system_codes":["qs_wur"],"country_codes":["AU"]},"page":1,"page_size":20},
 "scholarships":{"action":"scholarships","filters":{"student_types":["international"]},"page":1,"page_size":10},
 "scholarship":{"action":"scholarship","scholarship_id":"{{scholarshipId}}"},
 "export_provider":{"action":"export","entity":"provider"},
 "export_course_page2":{"action":"export","entity":"course","page":2},
 "export_course_json":{"action":"export","entity":"course","format":"json"},
 "sync_full":{"action":"sync","full_load":True,"page_size":200},
 "sync_next":{"action":"sync","cursor":"{{syncCursor}}","page_size":200},
}
s=lambda t,**k:dict(type=t,**k)
arr=lambda t="string":{"type":"array","items":{"type":t}}
filters={"type":"object","additionalProperties":True,
 "description":"All optional, combined with AND. Unknown keys are listed in filters_not_applied. Which keys apply depends on the action (guide, sections 5 and 7).",
 "properties":{
  "keyword":s("string"),"provider_name":s("string",description="Part of the provider's name"),"provider_cricos_codes":arr(),"provider_ids":arr(),
  "country_codes":{"type":"array","items":{"type":"string","enum":["AU","NZ","CA"]}},
  "subdivision_codes":arr(),"cities":arr(),"postcodes":arr(),"regional_categories":{"type":"array","items":{"type":"integer","enum":[1,2,3]}},
  "study_level_codes":arr(),"study_area_codes":arr(),"institution_types":arr(),"university_groups":arr(),
  "delivery_modes":{"type":"array","items":{"type":"string","enum":["on_campus","online","blended","on_campus_and_online"]}},
  "intake_months":{"type":"array","items":{"type":"integer","minimum":1,"maximum":12}},
  "english_test_codes":arr(),"english_score_max":s("number"),"english_band_max":s("number"),
  "tuition_annual_min":s("number"),"tuition_annual_max":s("number"),
  "has_intake":s("boolean"),"has_english":s("boolean"),"has_official_url":s("boolean"),"has_tuition":s("boolean"),"has_scholarship":s("boolean"),"has_logo":s("boolean"),
  "changed_since":s("string",format="date-time"),"contact_types":{"type":"array","items":{"type":"string","enum":["head_of_institution","general","team","staff"]}},
  "sectors":arr(),"system_codes":arr(),"edition_year":s("integer"),"rank_max":s("integer"),
  "student_types":{"type":"array","items":{"type":"string","enum":["international","domestic","both"]}},"open_only":s("boolean"),"nationality_codes":arr(),"course_id":s("string")}}
ACTIONS=["reference","search","course","courses","providers","provider","campuses","contacts","statistics","rankings","scholarships","scholarship","sync","export","report"]
req={"type":"object","required":["action"],"properties":{
 "action":{"type":"string","enum":ACTIONS},
 "filters":{"$ref":"#/components/schemas/Filters"},
 "page":{"type":"integer","minimum":1,"default":1},
 "page_size":{"type":"integer","minimum":1,"maximum":200,"description":"Lists: 1-50, default 20. Sync: 1-200"},
 "sort":s("string",description="search: relevance, title_asc, tuition_annual_asc, tuition_annual_desc, duration_asc, updated_asc"),
 "course_id":s("string"),"cricos_course_code":s("string"),"identifiers":{"type":"array","maxItems":50,"items":{"type":"string"}},
 "provider_id":s("string"),"cricos_provider_code":s("string"),"scholarship_id":s("string"),
 "kind":{"type":"string","enum":["qilt","prisms"]},
 "entity":{"type":"string","enum":["provider","campus","contact","course"]},"format":{"type":"string","enum":["csv","json"]},
 "cursor":{"type":["string","null"]},"full_load":s("boolean"),"entities":{"type":"array","items":{"type":"string","enum":["provider","campus","contact","course"]}},
 "field":s("string"),"note":s("string"),"reporter":{"type":"object","properties":{"name":s("string"),"email":s("string"),"ref":s("string")}}}}
base={"api_version":{"type":"string","const":"zoho-v2"},"request_id":s("string")}
lst={"type":"object","properties":dict(base,total=s("integer"),page=s("integer"),page_size=s("integer"),items={"type":"array","items":{"type":"object","additionalProperties":True}},filters_not_applied=arr())}
det={"type":"object","properties":dict(base,item={"type":"object","additionalProperties":True})}
syn={"type":"object","properties":dict(base,
  items={"type":"array","items":{"type":"object","required":["entity","id","seq","change"],"properties":{
   "entity":{"type":"string","enum":["provider","campus","contact","course"]},"id":s("string"),"seq":s("integer"),
   "change":{"type":"string","enum":["upsert","remove"]},"item":{"type":"object","additionalProperties":True}}}},
  has_more=s("boolean"),next_cursor=s("string",description="Store as is after the page is written"))}
errs={"type":"object","properties":dict(base,error={"type":"object","properties":{"code":{"type":"string","enum":["INVALID_JSON","INVALID_INPUT","INVALID_ACTION","AUTHENTICATION_REQUIRED","NOT_FOUND","RATE_LIMITED","SERVICE_UNAVAILABLE"]},"message":s("string"),"detail":s("string")}})}
def er(d,h=None):
    r={"description":d,"content":{"application/json":{"schema":{"$ref":"#/components/schemas/Error"}}}}
    if h: r["headers"]={"Retry-After":{"schema":{"type":"integer"},"description":"Seconds to wait"}}
    return r
oas={"openapi":"3.1.0",
 "info":{"title":"StudySearch Zoho API v2","version":"zoho-api-v2 (issue 2, 19 October 2026)",
   "description":"One address for Zoho API v2, fifteen actions chosen by the body field `action`. Read the Developer Guide for field meanings. Null means not held. Within v2 the API is additive only: ignore unknown fields. Keep the key in a Zoho Connection."},
 "servers":[{"url":"https://fxcwkweaxjtknorudmwp.supabase.co/functions/v1","description":"Pilot"}],
 "security":[{"bearerKey":[]}],
 "paths":{"/"+FN:{"post":{"operationId":"zohoApiV2","summary":"Call an action of Zoho API v2",
   "description":"Actions: "+", ".join(ACTIONS)+". 120 requests a minute per key.",
   "requestBody":{"required":True,"content":{"application/json":{"schema":{"$ref":"#/components/schemas/Request"},
     "examples":{k:{"summary":k.replace("_"," "),"value":v} for k,v in ex.items() if "{{" not in json.dumps(v)}}}},
   "responses":{"200":{"description":"Lists return ListResponse; details return DetailResponse; sync returns SyncResponse; export returns text/csv (headers x-rows, x-page, x-pages, x-total-rows, x-has-more, x-complete and x-sync-cursor) unless format is json",
      "content":{"application/json":{"schema":{"oneOf":[{"$ref":"#/components/schemas/ListResponse"},{"$ref":"#/components/schemas/DetailResponse"},{"$ref":"#/components/schemas/SyncResponse"},{"type":"object","additionalProperties":True}]}},
                 "text/csv":{"schema":{"type":"string"}}}},
     "400":er("INVALID_JSON, INVALID_INPUT or INVALID_ACTION"),"401":er("AUTHENTICATION_REQUIRED"),"404":er("NOT_FOUND"),"429":er("RATE_LIMITED",1),"503":er("SERVICE_UNAVAILABLE")}}}},
 "components":{"securitySchemes":{"bearerKey":{"type":"http","scheme":"bearer","description":"Your StudySearch Zoho key, issued separately"}},
   "schemas":{"Request":req,"Filters":filters,"ListResponse":lst,"DetailResponse":det,"SyncResponse":syn,"Error":errs}}}
json.dump(oas,open("StudySearch-Zoho-API-v2.openapi.json","w"),indent=2,ensure_ascii=False)
names={"reference":"reference","search_nursing":"search – nursing, IELTS 7 / 6.5, Feb or Jul (118)","search_provider_name":"search – provider name 'Queensland'","search_provider_cricos":"search – 00025B, tuition ≤ 45,000 (59)",
 "course":"course – 082960F","courses":"courses – batch with one not found","providers":"providers – 'RMIT' (3)","provider":"provider – 00025B with campuses and contacts",
 "campuses":"campuses – 00025B","contacts":"contacts – 00025B","statistics_qilt":"statistics – QILT 00025B (48)","statistics_prisms":"statistics – PRISMS AU-QLD",
 "rankings":"rankings – QS, Australia","scholarships":"scholarships – international","scholarship":"scholarship – detail (uses scholarshipId)",
 "export_provider":"export – providers CSV (1,546 rows)","export_course_page2":"export – courses CSV, page 2 of 9","export_course_json":"export – courses CSV inside JSON","sync_full":"sync – full load, first page","sync_next":"sync – next page or changes (uses syncCursor)"}
items=[]
for k,v in ex.items():
    it={"name":names[k],"request":{"method":"POST","header":[{"key":"Content-Type","value":"application/json"}],
      "body":{"mode":"raw","raw":json.dumps(v,indent=2,ensure_ascii=False),"options":{"raw":{"language":"json"}}},"url":"{{baseUrl}}/"+FN}}
    if k in("sync_full","sync_next"):
        it["event"]=[{"listen":"test","script":{"type":"text/javascript","exec":["const r = pm.response.json();","if (r.next_cursor) pm.collectionVariables.set('syncCursor', r.next_cursor);","pm.test('status 200', () => pm.response.to.have.status(200));"]}}]
    if k=="scholarships":
        it["event"]=[{"listen":"test","script":{"type":"text/javascript","exec":["const r = pm.response.json();","if (r.items && r.items[0]) pm.collectionVariables.set('scholarshipId', r.items[0].scholarship_id);"]}}]
    items.append(it)
pm={"info":{"name":"StudySearch Zoho API v2","description":"Set the collection variable apiKey to your key (kept out of this file). Run 'scholarships' before 'scholarship', and 'sync – full load' before 'sync – next page'.","schema":"https://schema.getpostman.com/json/collection/v2.1.0/collection.json"},
 "auth":{"type":"bearer","bearer":[{"key":"token","value":"{{apiKey}}","type":"string"}]},
 "variable":[{"key":"baseUrl","value":"https://fxcwkweaxjtknorudmwp.supabase.co/functions/v1"},{"key":"apiKey","value":""},{"key":"syncCursor","value":""},{"key":"scholarshipId","value":""}],
 "item":items}
json.dump(pm,open("StudySearch-Zoho-API-v2.postman_collection.json","w"),indent=2,ensure_ascii=False)
