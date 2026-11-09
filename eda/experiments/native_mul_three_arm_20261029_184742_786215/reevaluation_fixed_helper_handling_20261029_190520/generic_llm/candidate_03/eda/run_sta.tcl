read_liberty {/mnt/d/verilog_lab/PipeWeaver/eda/experiments/sky130_sta_20261027/lib/sky130_fd_sc_hd__tt_025C_1v80.lib}
read_verilog {/mnt/d/verilog_lab/PipeWeaver/eda/experiments/native_mul_three_arm_20261029_184742_786215/reevaluation_fixed_helper_handling_20261029_190520/generic_llm/candidate_03/eda/mapped_sta.v}
link_design mul_subexpression
read_sdc {/mnt/d/verilog_lab/PipeWeaver/eda/experiments/native_mul_three_arm_20261029_184742_786215/reevaluation_fixed_helper_handling_20261029_190520/generic_llm/candidate_03/eda/timing.sdc}
report_checks -path_delay max -format full_clock_expanded -group_path_count 10
report_worst_slack -max
report_tns -max
