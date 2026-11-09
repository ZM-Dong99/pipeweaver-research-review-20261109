module adder_mini #(parameter N = 32) (
    input [N-1:0] DATA_1,
    input [N-1:0] DATA_2,
    input SEL_0,
    input SEL_1,
    input clk,
    output reg [N-1:0] reg_0
);
    wire [N-1:0] sum;
    wire [N-1:0] mux_output;

    // Combine the arithmetic operation and the first level of muxing
    // based on SEL_0. This eliminates the 'iso' signals and
    // potentially simplifies the logic for the adder's input gating.
    assign sum = DATA_1 + DATA_2;
    assign mux_output = SEL_0 ? sum : DATA_1;

    // Implement the second level of muxing based on SEL_1
    // This feeds into the register.
    assign mux_output = SEL_1 ? DATA_2 : mux_output;

    always @(posedge clk) begin
        // The register update condition was effectively integrated
        // into the muxing logic. For optimal PPA, synthesis tools
        // are good at identifying redundant logic and don't generally
        // benefit from manually gating the clock or enable to a register unless explicitly needed.
        reg_0 <= mux_output;
    end
endmodule