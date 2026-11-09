"""KLayout script: compare every polygon mask except explicit auxiliary bulk236/0."""
import json
from pathlib import Path
import pya

a,b=pya.Layout(),pya.Layout()
a.read(original_gds)
b.read(model_gds)
ta,tb=a.cell('axis_eth_fcs_reset'),b.cell('axis_eth_fcs_reset')
assert ta and tb and abs(a.dbu-b.dbu)<1e-15
infos={(info.layer,info.datatype) for layout in (a,b) for info in layout.layer_infos()}
checks={}
for layer,datatype in sorted(infos):
    if (layer,datatype)==(236,0):
        continue
    ai,bi=a.find_layer(layer,datatype),b.find_layer(layer,datatype)
    ra=pya.Region() if ai is None else pya.Region(ta.begin_shapes_rec(ai))
    rb=pya.Region() if bi is None else pya.Region(tb.begin_shapes_rec(bi))
    checks[str(layer)+'/'+str(datatype)]=(ra^rb).is_empty()
Path(out_json).write_text(json.dumps(dict(passed=all(checks.values()),checks=checks,
    scope='All flattened polygon layers identical except declared nonmanufacturing substrate model236/0'),indent=2)+'\n')
print('PW_MASK_POLYGONS_IDENTICAL '+str(all(checks.values())))
