read_liberty {/mnt/d/verilog_lab/PipeWeaver/eda/experiments/sky130_sta_20261027/lib/sky130_fd_sc_hd__tt_025C_1v80.lib}
read_verilog {/mnt/d/verilog_lab/PipeWeaver/eda/experiments/seq_feedback_arbiter32_20261102_212936_005046/excluded_candidate_replay/no_timing_feedback/mapped_sta.v}
link_design arbiter
read_sdc {/mnt/d/verilog_lab/PipeWeaver/eda/experiments/seq_feedback_arbiter32_20261102_212936_005046/excluded_candidate_replay/no_timing_feedback/timing.sdc}
check_setup
report_checks -path_delay max -format full_clock_expanded -group_path_count 10
report_worst_slack -max
report_tns -max
puts {PW_ELECTRICAL_BEGIN}
report_check_types -max_slew -max_capacitance -violators -digits 6
puts {PW_ELECTRICAL_END}
