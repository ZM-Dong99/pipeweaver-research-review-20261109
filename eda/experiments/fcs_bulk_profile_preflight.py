"""KLayout guard: ordinary low-voltage bulk profile excludes isolation markers."""
import json
from pathlib import Path
import pya

layout=pya.Layout()
layout.read(in_gds)
top=layout.cell('axis_eth_fcs_reset')
assert top is not None
unsupported={'dnwell':(64,18),'substrate_cut':(81,53),'hvi':(75,20),
    'vhvi':(74,21),'uhvi':(74,22),'pwell_block':(19,44),'npn_id':(82,20),'pnp_id':(82,44)}
counts={}
for name,(layer,datatype) in unsupported.items():
    idx=layout.find_layer(layer,datatype)
    region=pya.Region() if idx is None else pya.Region(top.begin_shapes_rec(idx))
    counts[name]=region.count()
report=dict(supported=not any(counts.values()),unsupported_polygon_counts=counts,
    scope='Fixed ordinary low-voltage FCS only; no isolated, deep-well, high-voltage or bipolar extension')
Path(out_json).write_text(json.dumps(report,indent=2)+'\n')
print('PW_BULK_PROFILE_SUPPORTED '+str(report['supported']))
