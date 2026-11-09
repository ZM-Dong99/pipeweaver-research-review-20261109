"""KLayout script: inspect native LVS cross-reference without altering it."""
import json
from pathlib import Path
import pya

db=pya.LayoutVsSchematic()
db.read(in_db)
xref=db.xref()
def value(obj,name):
    v=getattr(obj,name,None)
    return v() if callable(v) else v
records=[]
for pair in xref.each_circuit_pair():
    first=value(pair,'first')
    second=value(pair,'second')
    entry=dict(layout=value(first,'name') if first else None,reference=value(second,'name') if second else None,
               status=str(value(pair,'status')))
    entry['devices']={}
    for label,circuit in [('layout',first),('reference',second)]:
        if circuit:
            entry['devices'][label]=sum(1 for _ in circuit.each_device())
    if entry['layout']=='axis_eth_fcs_reset':
        details=[]
        for np in xref.each_net_pair(pair):
            a,b=value(np,'first'),value(np,'second')
            status=str(value(np,'status'))
            if status.lower() not in ('match','matched'):
                details.append(dict(layout=value(a,'name') if a else None,reference=value(b,'name') if b else None,status=status))
        entry['net_statuses']=details
    elif entry['status']!='Match':
        entry['pin_pairs']=[dict(status=str(value(pp,'status')),layout=value(value(pp,'first'),'name') if value(pp,'first') else None,
                                reference=value(value(pp,'second'),'name') if value(pp,'second') else None) for pp in xref.each_pin_pair(pair)]
        entry['device_pairs']=[]
        for dp in xref.each_device_pair(pair):
            a,b=value(dp,'first'),value(dp,'second')
            def describe(d):
                if not d:
                    return None
                result=dict(name=value(d,'name'))
                for name in ('L','W'):
                    try:
                        result[name]=d.parameter(name)
                    except Exception:
                        pass
                return result
            entry['device_pairs'].append(dict(status=str(value(dp,'status')),layout=describe(a),reference=describe(b)))
        entry['net_pairs']=[dict(status=str(value(np,'status')),layout=value(value(np,'first'),'name') if value(np,'first') else None,
                               reference=value(value(np,'second'),'name') if value(np,'second') else None) for np in xref.each_net_pair(pair)]
    records.append(entry)
Path(out_json).write_text(json.dumps(dict(circuits=records),indent=2)+'\n')
print('PW_XREF_COMPLETE '+str(len(records)))
