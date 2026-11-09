read_liberty eda/experiments/sky130_sta_20261027/lib/sky130_fd_sc_hd__tt_025C_1v80.lib
read_verilog eda/experiments/controlled_rtl_study_20261029_002533_787332/constrained_search/candidate_03/evaluation/eda/mapped_sta.v
link_design timing_adder
read_sdc eda/experiments/sky130_sta_20261027/timing_adder.sdc
report_checks -path_delay max -format full_clock_expanded -group_path_count 10
report_checks -path_delay max -to [get_ports {y[*]}] -format full_clock_expanded -group_path_count 10
report_worst_slack -max
report_tns -max
