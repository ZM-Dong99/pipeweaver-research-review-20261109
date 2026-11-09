"""KLayout negative copies only: remove tap active or add isolation marker."""
import pya
layout=pya.Layout()
layout.read(in_gds)
top=layout.cell('axis_eth_fcs_reset')
if variant=='no_taps':
    idx=layout.find_layer(65,44)
    assert idx is not None
    for cell in layout.each_cell():
        cell.shapes(idx).clear()
elif variant=='substrate_cut':
    scale=1.0/layout.dbu
    top.shapes(layout.layer(81,53)).insert(pya.Box(round(20*scale),round(20*scale),round(25*scale),round(25*scale)))
else:
    raise ValueError('Unknown control')
layout.write(out_gds)
