read_liberty {/mnt/d/verilog_lab/PipeWeaver/eda/experiments/sky130_sta_20261027/lib/sky130_fd_sc_hd__tt_025C_1v80.lib}
read_verilog {/mnt/d/verilog_lab/PipeWeaver/eda/experiments/stream_feedback_ready_20261106/evaluations/skid/ef682f81f3f73640f74d2ad4573c3bab5d7b0b1c424be9e50182f571fc1e870a/mapped_sta.v}
link_design axis_register
read_sdc {/mnt/d/verilog_lab/PipeWeaver/eda/experiments/stream_feedback_ready_20261106/evaluations/skid/ef682f81f3f73640f74d2ad4573c3bab5d7b0b1c424be9e50182f571fc1e870a/timing.sdc}
check_setup
report_checks -path_delay max -format full_clock_expanded -group_path_count 10
report_worst_slack -max
report_tns -max
puts {PW_ELECTRICAL_BEGIN}
report_check_types -max_slew -max_capacitance -violators -digits 6
puts {PW_ELECTRICAL_END}
