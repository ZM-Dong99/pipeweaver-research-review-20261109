module timing_adder (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire [31:0] c,
    output reg  [31:0] y
);

    reg [31:0] ab_d1;
    reg [31:0] ab_d2;
    reg [31:0] c_d1;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            ab_d1 <= 32'b0;
            ab_d2 <= 32'b0;
            c_d1  <= 32'b0;
            y     <= 32'b0;
        end else begin
            ab_d1 <= a + b;
            ab_d2 <= ab_d1;
            c_d1  <= c;
            y     <= ab_d2 + c_d1;
        end
    end

endmodule
