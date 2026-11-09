create_clock -name virtual_clk -period 100.0
set_input_delay -max 0.0 -clock virtual_clk [all_inputs]
set_output_delay -max 0.0 -clock virtual_clk [all_outputs]
set_input_transition 0.10 [all_inputs]
set_load 0.010 [all_outputs]
set mux_ports [get_ports {mux_data* mux_sel*}]
set priority_ports [get_ports {requests*}]
if {[llength $mux_ports] != 84 || [llength $priority_ports] != 64} {error "Region input count mismatch"}
if {[llength [all_inputs]] != 148 || [llength [all_outputs]] != 79} {error "Top interface count mismatch"}
set_input_delay -max 0.00 -clock virtual_clk $mux_ports
set_input_delay -max 0.30 -clock virtual_clk $priority_ports
