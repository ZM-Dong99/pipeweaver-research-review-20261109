read_liberty {/mnt/d/verilog_lab/PipeWeaver/eda/experiments/sky130_sta_20261027/lib/sky130_fd_sc_hd__tt_025C_1v80.lib}
read_verilog {/mnt/d/verilog_lab/PipeWeaver/eda/experiments/expanded_feedback_80_20261107/evaluations/mux10x8_0f10b2552d93f66c296ba0a6ba4cb99018cd80bc3106a89d23a859bd98e99fb1/mapped_sta.v}
link_design mux_large
read_sdc {/mnt/d/verilog_lab/PipeWeaver/eda/experiments/expanded_feedback_80_20261107/evaluations/mux10x8_0f10b2552d93f66c296ba0a6ba4cb99018cd80bc3106a89d23a859bd98e99fb1/timing.sdc}
report_checks -path_delay max -format full_clock_expanded -group_path_count 10
report_worst_slack -max
report_tns -max
puts {PW_ELECTRICAL_BEGIN}
report_check_types -max_slew -max_capacitance -violators -digits 6
puts {PW_ELECTRICAL_END}
