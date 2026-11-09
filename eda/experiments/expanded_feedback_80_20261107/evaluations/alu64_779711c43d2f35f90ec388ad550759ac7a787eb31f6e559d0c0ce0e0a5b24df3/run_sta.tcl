read_liberty {/mnt/d/verilog_lab/PipeWeaver/eda/experiments/sky130_sta_20261027/lib/sky130_fd_sc_hd__tt_025C_1v80.lib}
read_verilog {/mnt/d/verilog_lab/PipeWeaver/eda/experiments/expanded_feedback_80_20261107/evaluations/alu64_779711c43d2f35f90ec388ad550759ac7a787eb31f6e559d0c0ce0e0a5b24df3/mapped_sta.v}
link_design alu_64bit
read_sdc {/mnt/d/verilog_lab/PipeWeaver/eda/experiments/expanded_feedback_80_20261107/evaluations/alu64_779711c43d2f35f90ec388ad550759ac7a787eb31f6e559d0c0ce0e0a5b24df3/timing.sdc}
report_checks -path_delay max -format full_clock_expanded -group_path_count 10
report_worst_slack -max
report_tns -max
puts {PW_ELECTRICAL_BEGIN}
report_check_types -max_slew -max_capacitance -violators -digits 6
puts {PW_ELECTRICAL_END}
