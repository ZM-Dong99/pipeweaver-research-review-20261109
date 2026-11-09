"""Strict model action selection. The model cannot supply executable RTL here."""
import json
import os
import re
from pathlib import Path
import urllib.error
import urllib.request

from agents.rtl_optimizer import _curl_json, http_transport, request_parameters_for_model, LLMGenerationError
from rewrite.comparator_rewrites import actions, materialize

REGISTRY={f"{s['topology']}_{s['chunk_bits']}":s for s in actions()}

def parse_selection(content,source):
    if not isinstance(content,str):raise LLMGenerationError('Selection content must be a JSON string')
    content=content.strip();normalizations=[]
    if content.startswith('<think>'):
        end=content.find('</think>')
        if end<0:raise LLMGenerationError('Unclosed leading wrapper')
        content=content[end+len('</think>'):].strip()
        normalizations.append('Discarded complete leading think wrapper; content not executed')
    fenced=re.fullmatch(r'```(?:json)?\s*\n?(.*?)\n?```',content,re.S|re.I)
    if fenced:
        content=fenced.group(1).strip();normalizations.append('Removed one complete JSON fence')
    def unique_object(pairs):
        obj={}
        for k,v in pairs:
            if k in obj:raise LLMGenerationError('Duplicate JSON keys are forbidden')
            obj[k]=v
        return obj
    try:payload=json.loads(content,object_pairs_hook=unique_object)
    except json.JSONDecodeError as exc:raise LLMGenerationError('Selection must be one JSON object, no wrapper or markdown') from exc
    if type(payload) is not dict or set(payload)!={'action_ids','rationale'}:
        raise LLMGenerationError('Selection requires exactly action_ids and rationale; RTL fields are forbidden')
    ids=payload['action_ids']
    if type(ids) is not list or len(ids)!=2 or any(type(i) is not str or i not in REGISTRY for i in ids):
        raise LLMGenerationError('Select exactly two registered action IDs')
    if len(set(ids))!=2:raise LLMGenerationError('Selected actions must be distinct')
    if type(payload['rationale']) is not str or not payload['rationale'].strip():raise LLMGenerationError('Non-empty rationale required')
    try:rendered={i:materialize(source,REGISTRY[i]) for i in ids}
    except ValueError as exc:raise LLMGenerationError(str(exc)) from exc
    return dict(action_ids=ids,rationale=payload['rationale'],rtl_by_action=rendered,output_normalization=normalizations)

def select_actions(prompt,*,model,source,timeout_s=180,audit_dir):
    """One authorized API attempt; no retry. Audits omit credentials/reasoning fields."""
    key=os.environ.get('OPENAI_API_KEY','').strip()
    if not key:raise LLMGenerationError('OPENAI_API_KEY is not configured')
    base=os.environ.get('OPENAI_BASE_URL','https://api.openai.com/v1').rstrip('/')
    params=request_parameters_for_model(model)
    payload=dict(model=model,**params,response_format={'type':'json_object'},messages=[
        dict(role='system',content='Select exactly two whitelisted structural actions. Never return RTL, code, markdown or commands. Return only the requested JSON object.'),dict(role='user',content=prompt)])
    audit_dir=Path(audit_dir);audit_dir.mkdir(parents=True,exist_ok=False)
    (audit_dir/'request.json').write_text(json.dumps(dict(endpoint=base+'/chat/completions',body=payload,http_transport=http_transport(),credentials='Authorization header omitted'),indent=2,ensure_ascii=False),encoding='utf-8')
    req=urllib.request.Request(base+'/chat/completions',data=json.dumps(payload).encode('utf-8'),headers={'Authorization':'Bearer '+key,'Content-Type':'application/json'},method='POST')
    try:
        if http_transport()=='curl':body=_curl_json(req,timeout_s,audit_dir=audit_dir)
        else:
            with urllib.request.urlopen(req,timeout=timeout_s) as response:body=json.loads(response.read().decode('utf-8'))
    except urllib.error.HTTPError as exc:raise LLMGenerationError(f'API returned HTTP {exc.code}; no retry') from None
    except (urllib.error.URLError,OSError,TimeoutError,UnicodeError,json.JSONDecodeError) as exc:
        raise LLMGenerationError('Action request failed: '+type(exc).__name__) from None
    if type(body) is not dict:raise LLMGenerationError('Provider envelope must be an object')
    visible={k:body[k] for k in ['id','object','created','model','usage','system_fingerprint'] if k in body}
    visible['choices']=[dict(index=c.get('index'),finish_reason=c.get('finish_reason'),message={k:c.get('message',{}).get(k) for k in ['role','content']}) for c in body.get('choices',[])]
    (audit_dir/'response.json').write_text(json.dumps(visible,indent=2,ensure_ascii=False),encoding='utf-8')
    try:content=body['choices'][0]['message']['content']
    except (KeyError,IndexError,TypeError):raise LLMGenerationError('Missing visible selection response') from None
    selection=parse_selection(content,source)
    selection['provider_metadata']=dict(requested_model=model,response_model=body.get('model'),request_parameters=params,usage=body.get('usage',{}),response_id=body.get('id'))
    return selection
