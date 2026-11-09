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

    // Carry-select 32-bit adder (split at bit 16)
    function [31:0] cs_add;
        input [31:0] x;
        input [31:0] y;
        reg [16:0] low_add;
        reg        carry;
        reg [15:0] high_c0;
        reg [15:0] high_c1;
        begin
            low_add = {1'b0, x[15:0]} + {1'b0, y[15:0]};
            carry   = low_add[16];
            high_c0 = x[31:16] + y[31:16];
            high_c1 = x[31:16] + y[31:16] + 1'b1;
            cs_add  = {carry ? high_c1 : high_c0, low_add[15:0]};
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
