module mac_ds (
    input clk,
    input signed [7:0] a, b,
    input reset,
    output reg signed [15:0] z
);

    reg signed [15:0] product;    
    reg signed [15:0] acc;            

    always @(posedge clk) begin
        product <= a * b;

        if (reset)
            acc <= 0;
        else
            acc <= acc + product;

        z <= acc;
    end
endmodule