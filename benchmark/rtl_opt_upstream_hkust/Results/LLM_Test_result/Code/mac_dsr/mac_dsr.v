module mac_dsr (
    input clk,
    input signed [7:0] a, b,
    input reset,
    output reg signed [15:0] z
);

    reg signed [7:0] a_reg, b_reg;
    reg signed [15:0] acc;
    wire signed [15:0] product = a_reg * b_reg;

    always @(posedge clk) begin
        a_reg <= a;
        b_reg <= b;

        if (reset)
            acc <= 0;
        else
            acc <= acc + product;

        z <= acc;
    end
endmodule