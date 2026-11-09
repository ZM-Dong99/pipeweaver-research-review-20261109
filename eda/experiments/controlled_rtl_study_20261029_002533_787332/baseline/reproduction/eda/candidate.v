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

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum1 <= 32'b0;
            sum2 <= 32'b0;
            y    <= 32'b0;
        end else begin
            sum1 <= a + b;
            sum2 <= sum1 + c;
            y    <= sum2;
        end
    end

endmodule