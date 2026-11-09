module adder_ref #(parameter N = 32) (
    input [N-1:0] DATA_1,
    input [N-1:0] DATA_2,
    input SEL_0,
    input SEL_1,
    input clk,
    output reg [N-1:0] reg_0
);
    wire [N-1:0] Add_0 = DATA_1 + DATA_2;  // Adder always active
    wire [N-1:0] mux_0 = SEL_0 ? Add_0 : DATA_1;
    wire [N-1:0] mux_1 = SEL_1 ? DATA_2 : mux_0;

    always @(posedge clk) begin
        // if (!(SEL_0 != 1'b1 && SEL_1 != 1'b0)) begin
            reg_0 <= mux_1;  // Conditional register update
        // end
    end
endmodule