module adder_ds #(parameter N = 32) (
    input [N-1:0] DATA_1,
    input [N-1:0] DATA_2,
    input SEL_0,
    input SEL_1,
    input clk,
    output reg [N-1:0] reg_0
);
    wire AS = SEL_0 || !SEL_1;  // Simplified activation signal
    wire [N-1:0] Add_0 = DATA_1 + DATA_2;  // Moved addition before mux
    
    always @(posedge clk) begin
        if (AS)
            reg_0 <= SEL_1 ? DATA_2 : (SEL_0 ? Add_0 : DATA_1);
        else
            reg_0 <= SEL_1 ? DATA_2 : DATA_1;
    end
endmodule