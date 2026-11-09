module adder_dsr #(parameter N = 32) (
    input [N-1:0] DATA_1,
    input [N-1:0] DATA_2,
    input SEL_0,
    input SEL_1,
    input clk,
    output reg [N-1:0] reg_0
);

    always @(posedge clk) begin
        reg_0 <= SEL_1 ? DATA_2 : (SEL_0 ? (DATA_1 + DATA_2) : DATA_1);
    end
endmodule