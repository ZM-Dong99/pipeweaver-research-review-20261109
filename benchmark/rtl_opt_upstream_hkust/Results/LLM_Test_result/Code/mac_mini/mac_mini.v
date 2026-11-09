module mac_mini (
    input clk,
    input signed [7:0] a, b,
    input reset,
    output reg signed [15:0] z
);

    reg signed [7:0] a_reg, b_reg;
    reg signed [15:0] acc;
    wire signed [15:0] product;

    assign product = a_reg * b_reg;

    always @(posedge clk) begin
        if (reset) begin
            a_reg <= 0; // Resetting input registers might help power in some cases
            b_reg <= 0; // though synthesis tools often optimize this away.
            acc <= 0;
            z <= 0; // Explicitly reset output
        end else begin
            a_reg <= a;
            b_reg <= b;
            acc <= acc + product;
            z <= acc + product; // Output the current accumulation
        end
    end
endmodule