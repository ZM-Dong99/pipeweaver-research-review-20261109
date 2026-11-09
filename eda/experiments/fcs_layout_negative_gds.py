"""KLayout-only negative control: add an isolated narrow met1 rectangle."""
from pathlib import Path
import pya

layout=pya.Layout()
layout.read(in_gds)
top=layout.cell('axis_eth_fcs_reset')
assert top is not None
layer=layout.layer(68,20)
scale=1.0/layout.dbu
top.shapes(layer).insert(pya.Box(round(3.0*scale),round(3.0*scale),round(3.10*scale),round(3.01*scale)))
layout.write(out_gds)
print('PW_NEGATIVE_GDS_WRITTEN')
