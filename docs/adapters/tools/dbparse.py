import json,re,sys
raw=open(sys.argv[1]).read()
m=re.search(r'(\[\{.*\}\])',raw,re.S)
try: data=json.loads(m.group(1))
except Exception:
    inner=json.loads(raw)['result']; data=json.loads(re.search(r'(\[\{.*\}\])',inner,re.S).group(1))
open('db.tsv','w').write(data[0]['tsv']+'\n'); print(data[0]['n'], data[0].get('asat'))
