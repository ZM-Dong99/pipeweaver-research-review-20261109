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
        if (!rst_n)
            sum1 <= 32'b0;
        else
            sum1 <= a + b;
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            sum2 <= 32'b0;
        else
            sum2 <= sum1 + c;
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            y <= 32'b0;
        else
            y <= sum2;
    end

endmodule
