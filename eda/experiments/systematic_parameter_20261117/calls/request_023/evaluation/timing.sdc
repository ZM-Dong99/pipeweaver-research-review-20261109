create_clock -name virtual_clk -period 100.0
set_input_delay -max 0.0 -clock virtual_clk [all_inputs]
set_output_delay -max 0.0 -clock virtual_clk [all_outputs]
set_input_transition 0.10 [all_inputs]
set_load 0.010 [all_outputs]
