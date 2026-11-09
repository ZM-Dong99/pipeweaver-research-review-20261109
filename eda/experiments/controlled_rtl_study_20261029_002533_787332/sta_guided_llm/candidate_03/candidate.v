module timing_adder (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire [31:0] c,
    output reg  [31:0] y
);

    reg [31:0] sum1;
    reg [31:0] sum2;

    // Carry-select adder function for 32-bit addition.
    function [31:0] cs_add;
        input [31:0] x;
        input [31:0] y;
        reg [16:0] sum_low;
        reg [15:0] sum_high0;
        reg [15:0] sum_high1;
        reg carry_low;
        begin
            sum_low   = {1'b0, x[15:0]} + {1'b0, y[15:0]};
            carry_low = sum_low[16];
            sum_high0 = x[31:16] + y[31:16];
            sum_high1 = x[31:16] + y[31:16] + 16'd1;
            cs_add = carry_low ? {sum_high1, sum_low[15:0]} : {sum_high0, sum_low[15:0]};
        end
    endfunction

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum1 <= 32'b0;
            sum2 <= 32'b0;
            y    <= 32'b0;
        end else begin
            sum1 <= cs_add(a, b);
            sum2 <= cs_add(sum1, c);
            y    <= sum2;
        end
    end

endmodule
