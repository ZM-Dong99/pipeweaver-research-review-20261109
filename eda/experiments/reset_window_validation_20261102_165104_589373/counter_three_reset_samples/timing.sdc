create_clock -name core_clk -period 10.0 [get_ports {clk}]
set data_inputs [get_ports {rst en}]
set_input_delay -max 0 -clock core_clk $data_inputs
set_output_delay -max 0 -clock core_clk [all_outputs]
set_input_transition 0.10 $data_inputs
set_load 0.010 [all_outputs]
