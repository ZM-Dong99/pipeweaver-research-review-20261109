"""KLayout script: fixed upstream DEF-to-GDS merge with explicit LEF paths."""
import hashlib
import importlib.util
import json
from pathlib import Path
import pya

root=Path(__file__).resolve().parents[2]
platform=root/'eda/physical_platforms/sky130hd_independent_aef47dd6'
lef=root/'eda/physical_platforms/sky130hd_orfs_aef47dd6/lef'
folder=Path(out_dir)
tech=pya.Technology()
tech.load(str(platform/'sky130hd.lyt'))
tech.base_path=str(platform)
options=tech.load_layout_options
options.lefdef_config.lef_files=[str(lef/'sky130_fd_sc_hd.tlef'),str(lef/'sky130_fd_sc_hd_merged.lef')]
tech.load_layout_options=options
tech.save(str(folder/'resolved.lyt'))
spec=importlib.util.spec_from_file_location('frozen_def2stream',platform/'def2stream.py')
module=importlib.util.module_from_spec(spec)
spec.loader.exec_module(module)
result=module.merge_gds(pya,str(folder/'resolved.lyt'),'',in_def,'axis_eth_fcs_reset',
                       str(platform/'gds/sky130_fd_sc_hd.gds'),'',str(folder/'design.gds'))
if result:
    raise RuntimeError('Merge failed: '+str(result))
layout=pya.Layout()
layout.read(str(folder/'design.gds'))
top=layout.cell('axis_eth_fcs_reset')
if top is None:
    raise RuntimeError('Top missing')
empty=[cell.name for cell in layout.each_cell() if cell.is_empty()]
if empty:
    raise RuntimeError('Empty cells: '+str(empty))
report=dict(passed=True,top=top.name,top_instances=sum(1 for _ in top.each_inst()),
    cells=layout.cells(),empty_cells=empty,layers=layout.layers(),dbu=layout.dbu,
    bbox=str(top.bbox()),gds_sha256=hashlib.sha256((folder/'design.gds').read_bytes()).hexdigest(),
    source_def_sha256=hashlib.sha256(Path(in_def).read_bytes()).hexdigest(),
    scope='Original DEF routing plus full standard-cell GDS, no missing or empty cells allowed')
(folder/'GDS_MERGE.json').write_text(json.dumps(report,indent=2)+'\n')
print('PW_GDS_COMPLETE '+json.dumps(report),flush=True)
