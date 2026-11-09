module adder #(parameter N = 32) (
    input [N-1:0] DATA_1,
    input [N-1:0] DATA_2,
    input SEL_0,
    input SEL_1,
    input clk,
    output reg [N-1:0] reg_0
);
    wire AS = !(SEL_0 != 1'b1 && SEL_1 != 1'b0);  // Activation signal
    wire [N-1:0] iso_DATA_1 = AS ? DATA_1 : {N{1'b0}};  // Isolation
    wire [N-1:0] iso_DATA_2 = AS ? DATA_2 : {N{1'b0}};  // Isolation
    
    wire [N-1:0] Add_0 = iso_DATA_1 + iso_DATA_2;  // Conditional adder
    wire [N-1:0] mux_0 = SEL_0 ? Add_0 : DATA_1;
    wire [N-1:0] mux_1 = SEL_1 ? DATA_2 : mux_0;

    always @(posedge clk) begin
        reg_0 <= mux_1;  // Unconditional register update
    end
endmodule