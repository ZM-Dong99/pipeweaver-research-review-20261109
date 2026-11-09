read_liberty {/mnt/d/verilog_lab/PipeWeaver/eda/experiments/sky130_sta_20261027/lib/sky130_fd_sc_hd__tt_025C_1v80.lib}
read_verilog {/mnt/d/verilog_lab/PipeWeaver/eda/experiments/engineering_arbiter_validation_20261102_201724_713244/wrong32_default4_positive_control/mapped_sta.v}
link_design arbiter
read_sdc {/mnt/d/verilog_lab/PipeWeaver/eda/experiments/engineering_arbiter_validation_20261102_201724_713244/wrong32_default4_positive_control/timing.sdc}
check_setup
report_checks -path_delay max -format full_clock_expanded -group_path_count 10
report_worst_slack -max
report_tns -max
puts {PW_ELECTRICAL_BEGIN}
report_check_types -max_slew -max_capacitance -violators -digits 6
puts {PW_ELECTRICAL_END}
