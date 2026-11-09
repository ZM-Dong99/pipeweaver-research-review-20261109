module mac (
    input clk,
    input signed [7:0] a, b,
    input reset,
    output reg signed [15:0] z
);

    reg signed [7:0] a_reg, b_reg;   
    reg signed [15:0] product_reg;    
    reg signed [15:0] acc;            

    always @(posedge clk) begin
        a_reg <= a;
        b_reg <= b;

        product_reg <= a_reg * b_reg;

        if (reset)
            acc <= 0;
        else
            acc <= acc + product_reg;

        z <= acc;
    end
endmodule