"""KLayout diagnostic: add the public deck's missing, non-mask bulk model layer."""
import json
from pathlib import Path
import pya

layout=pya.Layout()
layout.read(in_gds)
top=layout.cell('axis_eth_fcs_reset')
assert top is not None
def region(layer,datatype):
    index=layout.find_layer(layer,datatype)
    return pya.Region() if index is None else pya.Region(top.begin_shapes_rec(index))
assert region(64,18).is_empty(), 'Deep nwell unsupported by this restricted diagnostic'
assert region(75,20).is_empty(), 'High-voltage isolation unsupported'
existing_bulk_empty=region(236,0).is_empty()
bulk=pya.Region(top.bbox())-region(64,20)
top.shapes(layout.layer(236,0)).insert(bulk)
if remove_taps=='yes':
    index=layout.find_layer(65,44)
    assert index is not None
    for cell in layout.each_cell():
        cell.shapes(index).clear()
layout.write(out_gds)
Path(out_json).write_text(json.dumps(dict(
    status='EXPLICIT_SUBSTRATE_MODEL_DIAGNOSTIC',no_deep_nwell=True,no_high_voltage_isolation=True,
    model='Preserve existing nonmanufacturing layer236/0 and add regular bulk sheet = chip extent minus nwell; no direct VNB-VSS equivalence assertion',
    original_bulk_model_empty=existing_bulk_empty,
    remove_all_tap_active_geometry=remove_taps=='yes',
    scope='Separate diagnostic GDS only; unmodified-deck result on original manufacturing GDS remains separately reported'),indent=2)+'\n')
