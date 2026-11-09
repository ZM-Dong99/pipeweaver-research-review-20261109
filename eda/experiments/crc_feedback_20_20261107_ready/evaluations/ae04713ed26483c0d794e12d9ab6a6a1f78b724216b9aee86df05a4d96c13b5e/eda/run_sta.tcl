read_liberty {/mnt/d/verilog_lab/PipeWeaver/eda/experiments/sky130_sta_20261027/lib/sky130_fd_sc_hd__tt_025C_1v80.lib}
read_verilog {/mnt/d/verilog_lab/PipeWeaver/eda/experiments/crc_feedback_20_20261107_ready/evaluations/ae04713ed26483c0d794e12d9ab6a6a1f78b724216b9aee86df05a4d96c13b5e/eda/mapped_sta.v}
link_design crc32_d8
read_sdc {/mnt/d/verilog_lab/PipeWeaver/eda/experiments/crc_feedback_20_20261107_ready/evaluations/ae04713ed26483c0d794e12d9ab6a6a1f78b724216b9aee86df05a4d96c13b5e/eda/timing.sdc}
report_checks -path_delay max -format full_clock_expanded -group_path_count 10
report_worst_slack -max
report_tns -max
puts {PW_ELECTRICAL_BEGIN}
report_check_types -max_slew -max_capacitance -violators -digits 6
puts {PW_ELECTRICAL_END}
