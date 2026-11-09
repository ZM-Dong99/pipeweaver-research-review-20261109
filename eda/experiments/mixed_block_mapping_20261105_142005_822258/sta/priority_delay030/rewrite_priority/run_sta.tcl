read_liberty {/mnt/d/verilog_lab/PipeWeaver/eda/experiments/sky130_sta_20261027/lib/sky130_fd_sc_hd__tt_025C_1v80.lib}
read_verilog {/mnt/d/verilog_lab/PipeWeaver/eda/experiments/mixed_block_mapping_20261105_142005_822258/mapping/rewrite_priority/mapped_sta.v}
link_design mixed_datapath
read_sdc {/mnt/d/verilog_lab/PipeWeaver/eda/experiments/mixed_block_mapping_20261105_142005_822258/profiles/priority_delay030.sdc}
puts "PW_INPUT_COUNT [llength [all_inputs]]"
puts "PW_OUTPUT_COUNT [llength [all_outputs]]"
report_checks -path_delay max -format full_clock_expanded -group_path_count 10
report_worst_slack -max
report_tns -max
puts {PW_ELECTRICAL_BEGIN}
report_check_types -max_slew -max_capacitance -violators -digits 6
puts {PW_ELECTRICAL_END}
