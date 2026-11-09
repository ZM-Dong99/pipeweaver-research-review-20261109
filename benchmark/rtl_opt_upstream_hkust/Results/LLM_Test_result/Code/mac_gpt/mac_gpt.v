module mac_gpt (
    input clk,
    input signed [7:0] a, b,
    input reset,
    output reg signed [15:0] z
);

    reg signed [7:0] a_reg, b_reg;   
    reg signed [15:0] acc;            

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            acc <= 0;
            z <= 0;
        end else begin
            a_reg <= a;
            b_reg <= b;
            acc <= acc + (a_reg * b_reg);
            z <= acc;
        end
    end
endmodule