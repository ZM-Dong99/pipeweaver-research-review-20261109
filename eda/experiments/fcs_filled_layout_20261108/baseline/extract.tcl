read_liberty {/mnt/d/verilog_lab/PipeWeaver/eda/experiments/sky130_sta_20261027/lib/sky130_fd_sc_hd__tt_025C_1v80.lib}
read_db {/mnt/d/verilog_lab/PipeWeaver/eda/experiments/fcs_filled_layout_20261108/baseline/detailed.odb}
read_sdc {/mnt/d/verilog_lab/PipeWeaver/eda/experiments/fcs_reset_complete_20261107_induction_fixed/physical_inputs/baseline/timing.sdc}
source {/mnt/d/verilog_lab/PipeWeaver/eda/physical_platforms/sky130hd_orfs_aef47dd6/setRC.tcl}
set_propagated_clock [all_clocks]
define_process_corner -ext_model_index 0 X
extract_parasitics -ext_model_file {/mnt/d/verilog_lab/PipeWeaver/eda/physical_platforms/sky130hd_orfs_aef47dd6/sky130_shared_rcx.rules}
write_spef filled.spef
read_spef filled.spef
puts PW_SETUP_BEGIN
report_checks -path_delay max -format full_clock_expanded -group_path_count 5
report_worst_slack -max
report_tns -max
report_check_types -max_slew -max_capacitance -violators -digits 6
puts PW_SETUP_END
puts PW_HOLD_BEGIN
report_worst_slack -min
report_tns -min
puts PW_HOLD_END
puts PW_EXTRACTED_COMPLETE
