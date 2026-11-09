"""KLayout script: copy an untouched standard cell to a standalone GDS."""
import pya
layout=pya.Layout()
layout.read(in_gds)
cell=layout.cell('sky130_fd_sc_hd__a31oi_1')
assert cell is not None
out=pya.Layout()
out.dbu=layout.dbu
top=out.create_cell(cell.name)
top.copy_tree(cell)
out.write(out_gds)
print('PW_ISOLATED_CELL_WRITTEN')
