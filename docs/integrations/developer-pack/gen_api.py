import json
URL="https://fxcwkweaxjtknorudmwp.supabase.co/functions/v1/website-api-v2"
C="website-search-v2"
ex={
 "reference":{"action":"reference"},
 "search":{"action":"search","filters":{"country_codes":["AU"],"keyword":"business","cities":["Melbourne"],"study_level_codes":["masters_coursework"],"intake_months":[2],"english_test_codes":["IELTS"],"english_score_max":6.5,"tuition_annual_max":45000},"page":1,"page_size":6},
 "search_nursing_melbourne":{"action":"search","filters":{"keyword":"nursing","cities":["Melbourne"]},"page":1,"page_size":20,"sort":"relevance"},
 "search_canada":{"action":"search","filters":{"country_codes":["CA"]},"page":1,"page_size":20},
 "course":{"action":"course","course_code":"082960F"},
 "course_display_code":{"action":"course","course_code":"UNBC-BA-019"},
 "providers":{"action":"providers","filters":{"country_codes":["AU"],"university_groups":["go8"]},"sort":"qs_rank_asc","page":1,"page_size":6},
 "providers_universities":{"action":"providers","filters":{"country_codes":["AU"],"institution_types":["university"]},"page":1,"page_size":50},
 "providers_with_logo":{"action":"providers","filters":{"has_logo":True},"page":1,"page_size":50},
 "provider":{"action":"provider","provider_id":"provider:cricos:00025b"},
 "rankings":{"action":"rankings","filters":{"system_codes":["qs_wur"],"edition_year":2027,"country_codes":["AU"]},"page":1,"page_size":20},
 "scholarships":{"action":"scholarships","filters":{"student_types":["international"]},"page":1,"page_size":10},
 "scholarship":{"action":"scholarship","scholarship_id":"{{scholarshipId}}"},
 "sync_full":{"action":"sync","page_size":200},
 "sync_next":{"action":"sync","cursor":"{{syncCursor}}","page_size":200},
}
s=lambda t,**k:dict(type=t,**k)
arr=lambda t="string":{"type":"array","items":{"type":t}}
filters={"type":"object","additionalProperties":True,
 "description":"All optional, combined with AND. Unknown keys are listed in filters_not_applied. Which keys apply depends on the action (see the guide, section 7).",
 "properties":{
  "keyword":s("string"),"country_codes":{"type":"array","items":{"type":"string","enum":["AU","NZ","CA"]}},
  "study_level_codes":arr(),"study_area_codes":arr(),"subdivision_codes":arr(),"cities":arr(),"postcodes":arr(),
  "regional_categories":{"type":"array","items":{"type":"integer","enum":[1,2,3]}},
  "provider_ids":arr(),"university_groups":{"type":"array","items":{"type":"string","enum":["go8","atn","iru","run"]}},
  "institution_types":{"type":"array","items":{"type":"string","enum":["university","university_college","higher_education_institute","tafe_polytechnic","private_vet","school","wananga","other"]}},
  "delivery_modes":{"type":"array","items":{"type":"string","enum":["on_campus","online","blended","on_campus_and_online"]}},
  "intake_months":{"type":"array","items":{"type":"integer","minimum":1,"maximum":12}},
  "english_test_codes":arr(),"english_score_max":s("number"),
  "tuition_annual_min":s("number"),"tuition_annual_max":s("number"),
  "has_intake":s("boolean"),"has_english":s("boolean"),"has_official_url":s("boolean"),"has_tuition":s("boolean"),"has_scholarship":s("boolean"),"has_logo":s("boolean"),
  "changed_since":s("string",format="date-time"),
  "ranked_in":{"type":"array","items":{"type":"string","enum":["qs_wur","the_wur"]}},"qs_rank_max":s("integer"),"the_rank_max":s("integer"),
  "system_codes":{"type":"array","items":{"type":"string","enum":["qs_wur","the_wur"]}},"edition_year":s("integer"),"rank_max":s("integer"),
  "amount_types":{"type":"array","items":{"type":"string","enum":["fixed_amount","percentage_tuition","full_tuition"]}},
  "open_only":s("boolean"),"student_types":{"type":"array","items":{"type":"string","enum":["international","domestic","both"]}},
  "study_stages":{"type":"array","items":{"type":"string","enum":["commencing","current"]}},
  "automatic_consideration":s("boolean"),"nationality_codes":arr(),"course_id":s("string")}}
req={"type":"object","required":["action"],"properties":{
 "action":{"type":"string","enum":["reference","search","course","providers","provider","rankings","scholarships","scholarship","sync"]},
 "filters":{"$ref":"#/components/schemas/Filters"},
 "page":{"type":"integer","minimum":1,"default":1},
 "page_size":{"type":"integer","minimum":1,"maximum":200,"description":"Lists: 1-50, default 20. Sync: 1-200, default 200; a sync page also stops at about 550 KB"},
 "sort":{"type":"string","enum":["relevance","title_asc","tuition_annual_asc","tuition_annual_desc","duration_asc","updated_asc","name_asc","qs_rank_asc","the_rank_asc","course_count_desc"],"description":"Course sorts for search; provider sorts for providers"},
 "course_id":s("string"),"course_code":{"type":"string","description":"A source code, a StudySearch display code or a course_id"},
 "provider_id":s("string"),"scholarship_id":s("string"),
 "cursor":{"type":["string","null"],"description":"sync: next_cursor from the last reply; omit or null for a full load"},
 "full_load":{"type":"boolean","description":"sync: true starts a full load again"},
 "entities":{"type":"array","items":{"type":"string","enum":["reference","provider","logo","rankings","scholarship","course"]},"description":"sync, full load only; default all six"}}}
base={"api_version":{"type":"string","const":"website-v2"},"request_id":s("string")}
lst={"type":"object","properties":dict(base,total=s("integer"),page=s("integer"),page_size=s("integer"),items={"type":"array","items":{"type":"object","additionalProperties":True}},filters_not_applied=arr())}
det={"type":"object","properties":dict(base,item={"type":"object","additionalProperties":True})}
syn={"type":"object","properties":dict(base,
  items={"type":"array","items":{"type":"object","required":["entity","id","seq","change"],"properties":{
   "entity":{"type":"string","enum":["reference","provider","logo","rankings","scholarship","course"]},"id":s("string"),"seq":s("integer"),
   "change":{"type":"string","enum":["upsert","remove"]},"item":{"type":"object","additionalProperties":True,"description":"Present for upsert"}}}},
  has_more=s("boolean"),next_cursor={"type":"string","description":"Opaque; store as is after the page is written"},
  mode={"type":"string","enum":["full","delta"]},full_load_complete=s("boolean"),
  checked_through={"type":["string","null"],"format":"date-time"},as_of=s("string",format="date-time"))}
errs={"type":"object","properties":dict(base,error={"type":"object","properties":{"code":{"type":"string","enum":["INVALID_JSON","INVALID_INPUT","INVALID_ACTION","AUTHENTICATION_REQUIRED","NOT_FOUND","RATE_LIMITED","SERVICE_UNAVAILABLE"]},"message":s("string"),"detail":s("string")}})}
def er(d,h=None):
    r={"description":d,"content":{"application/json":{"schema":{"$ref":"#/components/schemas/Error"}}}}
    if h: r["headers"]={"Retry-After":{"schema":{"type":"integer"},"description":"Seconds to wait"}}
    return r
oas={"openapi":"3.1.0",
 "info":{"title":"StudySearch Website API","version":"website-api-v2 (Version 2, issue 3, 16 October 2026)",
   "description":"One address for Website API v2, nine actions chosen by the body field `action` (no contract field). Read the Developer Guide for field meanings and integration. Null means not held. Additive only: ignore unknown fields. Call from Wix backend code only; keep the key in Wix Secrets Manager."},
 "servers":[{"url":"https://fxcwkweaxjtknorudmwp.supabase.co/functions/v1","description":"Pilot (Production uses the same address with its own key)"}],
 "security":[{"bearerKey":[]}],
 "paths":{"/website-api-v2":{"post":{"operationId":"websiteApiV2","summary":"Call an action of Website API v2",
   "description":"Actions: reference, search, course, providers, provider, rankings, scholarships, scholarship, sync. 300 requests a minute per key, all actions together.",
   "requestBody":{"required":True,"content":{"application/json":{"schema":{"$ref":"#/components/schemas/Request"},
     "examples":{k:{"summary":k.replace("_"," "),"value":v} for k,v in ex.items() if "{{" not in json.dumps(v)}}}},
   "responses":{"200":{"description":"List actions return ListResponse; course, provider and scholarship return DetailResponse; reference returns the vocabularies; sync returns SyncResponse",
      "content":{"application/json":{"schema":{"oneOf":[{"$ref":"#/components/schemas/ListResponse"},{"$ref":"#/components/schemas/DetailResponse"},{"$ref":"#/components/schemas/SyncResponse"},{"type":"object","additionalProperties":True}]}}}},
     "400":er("INVALID_INPUT or INVALID_ACTION"),"401":er("AUTHENTICATION_REQUIRED"),"404":er("NOT_FOUND"),"429":er("RATE_LIMITED",1),"503":er("SERVICE_UNAVAILABLE")}}}},
 "components":{"securitySchemes":{"bearerKey":{"type":"http","scheme":"bearer","description":"Your StudySearch key, issued separately"}},
   "schemas":{"Request":req,"Filters":filters,"ListResponse":lst,"DetailResponse":det,"SyncResponse":syn,"Error":errs}}}
json.dump(oas,open("StudySearch-Website-API.openapi.json","w"),indent=2,ensure_ascii=False)
items=[]
names={"reference":"reference","search":"search – example (35)","search_nursing_melbourne":"search – nursing Melbourne (109)","search_canada":"search – Canada (4,723)","course":"course – 082960F","course_display_code":"course – display code UNBC-BA-019","providers":"providers – Go8 by QS (8)","providers_universities":"providers – AU universities (45)","providers_with_logo":"providers – with logo (49)","provider":"provider – UQ detail","rankings":"rankings – QS 2027 AU (38)","scholarships":"scholarships – international (1,096)","scholarship":"scholarship – detail","sync_full":"sync – full load, first page","sync_next":"sync – next page or delta (uses syncCursor)"}
for k,v in ex.items():
    it={"name":names[k],"request":{"method":"POST","header":[{"key":"Content-Type","value":"application/json"}],
      "body":{"mode":"raw","raw":json.dumps(v,indent=2,ensure_ascii=False),"options":{"raw":{"language":"json"}}},"url":"{{baseUrl}}/website-api-v2"}}
    if k=="sync_full" or k=="sync_next":
        it["event"]=[{"listen":"test","script":{"type":"text/javascript","exec":["const r = pm.response.json();","if (r.next_cursor) pm.collectionVariables.set('syncCursor', r.next_cursor);","pm.test('status 200', () => pm.response.to.have.status(200));"]}}]
    if k=="scholarships":
        it["event"]=[{"listen":"test","script":{"type":"text/javascript","exec":["const r = pm.response.json();","if (r.items && r.items[0]) pm.collectionVariables.set('scholarshipId', r.items[0].scholarship_id);"]}}]
    items.append(it)
pm={"info":{"name":"StudySearch Website API v2 (website-api-v2)","description":"Set the collection variable apiKey to your key (kept out of this file). Run 'scholarships' before 'scholarship', and 'sync – full load' before 'sync – next page'.","schema":"https://schema.getpostman.com/json/collection/v2.1.0/collection.json"},
 "auth":{"type":"bearer","bearer":[{"key":"token","value":"{{apiKey}}","type":"string"}]},
 "variable":[{"key":"baseUrl","value":"https://fxcwkweaxjtknorudmwp.supabase.co/functions/v1"},{"key":"apiKey","value":""},{"key":"syncCursor","value":""},{"key":"scholarshipId","value":""}],
 "item":items}
json.dump(pm,open("StudySearch-Website-API.postman_collection.json","w"),indent=2,ensure_ascii=False)

