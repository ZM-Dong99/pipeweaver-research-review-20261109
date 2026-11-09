read_liberty {/mnt/d/verilog_lab/PipeWeaver/eda/experiments/sky130_sta_20261027/lib/sky130_fd_sc_hd__tt_025C_1v80.lib}
read_db {/mnt/d/verilog_lab/PipeWeaver/eda/experiments/fcs_reset_cts_pdn_20261107/optimized/detailed.odb}
filler_placement {sky130_fd_sc_hd__fill_8 sky130_fd_sc_hd__fill_4 sky130_fd_sc_hd__fill_2 sky130_fd_sc_hd__fill_1}
source {/mnt/d/verilog_lab/PipeWeaver/eda/physical_platforms/sky130hd_cts_pdn_aef47dd6/global_connect.tcl}
global_connect
check_placement -verbose
check_power_grid -net VDD
check_power_grid -net VSS
write_db detailed.odb
write_def detailed.def
set block [ord::get_db_block]
set dbu [$block getDbUnitsPerMicron]
set f [open physical_cells.tsv w]
puts $f "instance	master	area_um2"
foreach inst [$block getInsts] {
 set master [$inst getMaster]
 set area [expr {double([$master getWidth])*[$master getHeight]/$dbu/$dbu}]
 puts $f "[$inst getName]	[$master getName]	$area"
}
close $f
puts PW_FILLED_COMPLETE
